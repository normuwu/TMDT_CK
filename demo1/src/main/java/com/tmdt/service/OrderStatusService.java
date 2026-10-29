package com.tmdt.service;

import com.tmdt.dao.OrderDAO;
import com.tmdt.dao.OrderItemDAO;
import com.tmdt.dao.OrderStatusHistoryDAO;
import com.tmdt.dao.ProductDAO;
import com.tmdt.model.Order;
import com.tmdt.model.OrderItem;
import com.tmdt.model.OrderStatus;
import com.tmdt.model.OrderStatusHistory;
import com.tmdt.model.Role;
import com.tmdt.model.SessionUser;
import com.tmdt.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Cập nhật trạng thái đơn hàng.
 *
 * Quy trình (đúng 5 trạng thái đang có trong DB, KHÔNG thêm trạng thái mới):
 *
 *   PENDING (Chờ xác nhận)
 *      ├─> CONFIRMED (Đã xác nhận)
 *      │      ├─> SHIPPING (Đang giao hàng) ─> COMPLETED (Đã giao hàng)
 *      │      └─> CANCELLED (Đã hủy)
 *      └─> CANCELLED
 *
 * Phân quyền (lấy từ SessionUser, KHÔNG nhận role/userId từ trình duyệt):
 *   - ADMIN  : mọi đơn trên hệ thống, theo đúng ma trận chuyển trạng thái.
 *   - SELLER : chỉ đơn thuộc shop mình (shops.user_id = user đang đăng nhập).
 *   - CUSTOMER: chỉ đơn của mình, và chỉ được HỦY khi đơn còn PENDING/CONFIRMED.
 *
 * Mọi thay đổi nằm trong một transaction: UPDATE orders + lịch sử + hoàn kho.
 * Trạng thái thanh toán (payments) KHÔNG tự đổi — thu tiền COD là nghiệp vụ riêng.
 */
public class OrderStatusService {

    private static final Logger LOG = LoggerFactory.getLogger(OrderStatusService.class);
    private static final int MAX_NOTE = 300;   // orders.cancel_reason VARCHAR(300)
    private static final int MAX_HISTORY_NOTE = 300;

    private static final Map<OrderStatus, List<OrderStatus>> TRANSITIONS = Map.of(
            OrderStatus.PENDING, List.of(OrderStatus.CONFIRMED, OrderStatus.CANCELLED),
            OrderStatus.CONFIRMED, List.of(OrderStatus.SHIPPING, OrderStatus.CANCELLED),
            OrderStatus.SHIPPING, List.of(OrderStatus.COMPLETED),
            OrderStatus.COMPLETED, List.of(),
            OrderStatus.CANCELLED, List.of());

    private final OrderDAO orderDAO = new OrderDAO();
    private final OrderItemDAO orderItemDAO = new OrderItemDAO();
    private final ProductDAO productDAO = new ProductDAO();
    private final OrderStatusHistoryDAO historyDAO = new OrderStatusHistoryDAO();

    public record Outcome(boolean success, String message) {
        static Outcome ok(String message) { return new Outcome(true, message); }
        static Outcome fail(String message) { return new Outcome(false, message); }
    }

    // ---------------------------------------------------------------------
    // Quy tắc (dùng chung cho hiển thị UI và kiểm tra POST)
    // ---------------------------------------------------------------------

    public static List<OrderStatus> nextStatuses(OrderStatus current) {
        if (current == null) return List.of();
        return TRANSITIONS.getOrDefault(current, List.of());
    }

    public static boolean canTransition(OrderStatus from, OrderStatus to) {
        return from != null && to != null && nextStatuses(from).contains(to);
    }

    public static boolean canManageOrders(SessionUser actor) {
        return actor != null
                && (actor.getRole() == Role.ADMIN || actor.getRole() == Role.SELLER);
    }

    /** Người đang đăng nhập có phạm vi quản lý đơn này không (chưa xét trạng thái). */
    public static boolean canAccessOrder(SessionUser actor, Order order) {
        if (actor == null || order == null) return false;
        return switch (actor.getRole()) {
            case ADMIN -> true;
            case SELLER -> order.getShopOwnerUserId() == actor.getUserId();
            case CUSTOMER -> order.getUserId() == actor.getUserId();
        };
    }

    /** Người đang đăng nhập có được chuyển đơn sang trạng thái target không? */
    public static boolean canUpdate(SessionUser actor, Order order, OrderStatus target) {
        if (target == null || !canAccessOrder(actor, order)) return false;
        if (actor.getRole() == Role.CUSTOMER) {
            return target == OrderStatus.CANCELLED && canTransition(order.getStatus(), target);
        }
        return canTransition(order.getStatus(), target);
    }

    /** Khách chỉ được tự hủy đơn của mình khi chưa giao. */
    public static boolean canCustomerCancel(SessionUser actor, Order order) {
        return actor != null && order != null
                && actor.getRole() == Role.CUSTOMER
                && order.getUserId() == actor.getUserId()
                && (order.getStatus() == OrderStatus.PENDING
                || order.getStatus() == OrderStatus.CONFIRMED);
    }

    /** Các trạng thái mà actor hiện tại được phép chọn cho đơn này (cho <select>). */
    public List<OrderStatus> allowedNextStatuses(SessionUser actor, Order order) {
        List<OrderStatus> allowed = new ArrayList<>();
        for (OrderStatus status : nextStatuses(order.getStatus())) {
            if (canUpdate(actor, order, status)) allowed.add(status);
        }
        return allowed;
    }

    // ---------------------------------------------------------------------
    // Danh sách cho Admin / Seller
    // ---------------------------------------------------------------------

    public List<Order> listForManagement(SessionUser actor, OrderStatus statusFilter) {
        if (!canManageOrders(actor)) {
            throw new SecurityException("Không có quyền quản lý đơn hàng");
        }
        try {
            Integer shopOwner = actor.getRole() == Role.SELLER ? actor.getUserId() : null;
            return orderDAO.findForManagement(shopOwner, statusFilter);
        } catch (SQLException e) {
            throw new IllegalStateException("Không tải được danh sách đơn hàng", e);
        }
    }

    // ---------------------------------------------------------------------
    // Cập nhật trạng thái
    // ---------------------------------------------------------------------

    /**
     * Cập nhật trạng thái đơn. Trả về Outcome lỗi (không ném exception) cho các
     * trường hợp nghiệp vụ; lỗi DB -> SYSTEM message + rollback.
     */
    public Outcome updateStatus(SessionUser actor, int orderId, OrderStatus target, String note) {
        if (actor == null) return Outcome.fail("Vui lòng đăng nhập.");
        if (orderId <= 0 || target == null) return Outcome.fail("Yêu cầu cập nhật không hợp lệ.");

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Optional<Order> found = orderDAO.findById(conn, orderId, true);
                if (found.isEmpty()) {
                    conn.rollback();
                    return Outcome.fail("Đơn hàng không tồn tại.");
                }
                Order order = found.get();

                if (!canAccessOrder(actor, order)) {
                    conn.rollback();
                    return Outcome.fail(denyMessage(actor, order));
                }
                if (actor.getRole() == Role.CUSTOMER && target != OrderStatus.CANCELLED) {
                    conn.rollback();
                    return Outcome.fail("Bạn không có quyền tự cập nhật trạng thái giao hàng của đơn.");
                }
                if (!canTransition(order.getStatus(), target)) {
                    conn.rollback();
                    if (actor.getRole() == Role.CUSTOMER && target == OrderStatus.CANCELLED) {
                        return Outcome.fail("Đơn hàng đang ở trạng thái \""
                                + order.getStatus().getLabel() + "\" nên không thể hủy.");
                    }
                    return Outcome.fail("Không thể chuyển đơn từ \"" + order.getStatus().getLabel()
                            + "\" sang \"" + target.getLabel() + "\".");
                }

                String cancelReason = null;
                String historyNote = trimTo(note, MAX_HISTORY_NOTE);
                if (target == OrderStatus.CANCELLED) {
                    cancelReason = trimTo(note, MAX_NOTE);
                    if (cancelReason == null || cancelReason.isBlank()) {
                        cancelReason = "Hủy bởi " + actor.getFullName();
                    }
                    historyNote = cancelReason;
                }

                boolean updated = orderDAO.updateStatus(conn, orderId, order.getStatus(), target,
                        cancelReason);
                if (!updated) {
                    conn.rollback();
                    return Outcome.fail("Trạng thái đơn vừa được thay đổi bởi người khác. "
                            + "Vui lòng tải lại trang.");
                }

                // Hủy đơn -> hoàn lại tồn kho đã trừ lúc đặt hàng.
                if (target == OrderStatus.CANCELLED) {
                    for (OrderItem item : orderItemDAO.findByOrderId(conn, orderId)) {
                        productDAO.restoreStock(conn, item.getProductId(), item.getQuantity());
                    }
                }

                historyDAO.insert(conn, orderId, order.getStatus(), target, actor.getUserId(),
                        historyNote);

                conn.commit();
                LOG.info("Order {} đổi trạng thái {} -> {} bởi userId={}",
                        orderId, order.getStatus(), target, actor.getUserId());
                return Outcome.ok("Đã cập nhật đơn #" + order.getOrderCode()
                        + " sang \"" + target.getLabel() + "\".");
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            LOG.error("Lỗi cập nhật trạng thái đơn {} (userId={})", orderId, actor.getUserId(), e);
            return Outcome.fail("Không cập nhật được trạng thái đơn, vui lòng thử lại sau.");
        }
    }

    /** Khách tự hủy đơn (đi qua cùng logic cập nhật + phân quyền). */
    public Outcome cancelByCustomer(SessionUser actor, int orderId, String reason) {
        return updateStatus(actor, orderId, OrderStatus.CANCELLED, reason);
    }

    public List<OrderStatusHistory> history(int orderId) {
        try {
            return historyDAO.findByOrderId(orderId);
        } catch (SQLException e) {
            LOG.error("Không đọc được lịch sử trạng thái đơn {}", orderId, e);
            return List.of();
        }
    }

    private static String denyMessage(SessionUser actor, Order order) {
        return switch (actor.getRole()) {
            case CUSTOMER -> "Bạn không có quyền cập nhật đơn hàng của tài khoản khác.";
            case SELLER -> "Đơn hàng này không thuộc cửa hàng của bạn.";
            case ADMIN -> "Bạn không có quyền cập nhật đơn hàng này.";
        };
    }

    private static String trimTo(String value, int max) {
        if (value == null) return null;
        String trimmed = value.trim();
        return trimmed.length() > max ? trimmed.substring(0, max) : trimmed;
    }
}
