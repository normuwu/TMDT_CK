package com.tmdt.dao;

import com.tmdt.model.Order;
import com.tmdt.model.OrderStatus;
import com.tmdt.model.PaymentMethod;
import com.tmdt.model.PaymentStatus;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static com.tmdt.util.DBConnection.getConnection;

/**
 * Pure JDBC cho bảng orders + payments.
 *
 * Đọc: tự lấy connection từ pool.
 * Ghi: nhận Connection của OrderService để service giữ commit/rollback
 *      (một đơn hàng gồm nhiều bảng, không được mở connection riêng từng bước).
 */
public class OrderDAO {

    private static final String SELECT_ORDER =
            "SELECT o.order_id, o.order_code, o.user_id, u.full_name AS customer_name, "
                    + "o.shop_id, sh.shop_name, sh.user_id AS shop_owner_user_id, o.promotion_id, "
                    + "o.recipient_name, o.recipient_phone, o.shipping_address, o.note, "
                    + "o.subtotal_amount, o.shipping_fee, o.discount_amount, o.total_amount, "
                    + "o.order_status, o.cancel_reason, o.created_at, "
                    + "p.payment_method, p.payment_status "
                    + "FROM orders o "
                    + "JOIN shops sh ON sh.shop_id = o.shop_id "
                    + "JOIN users u ON u.user_id = o.user_id "
                    + "LEFT JOIN payments p ON p.payment_id = ("
                    + "    SELECT p2.payment_id FROM payments p2 "
                    + "    WHERE p2.order_id = o.order_id ORDER BY p2.payment_id DESC LIMIT 1) ";

    /** Lịch sử mua hàng của một tài khoản (mới nhất trước). */
    public List<Order> findByUserId(int userId) throws SQLException {
        final String sql = SELECT_ORDER + "WHERE o.user_id = ? "
                + "ORDER BY o.created_at DESC, o.order_id DESC";
        List<Order> orders = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapRow(rs));
                }
            }
        }
        return orders;
    }

    /**
     * Một đơn của đúng chủ sở hữu. Dùng user_id trong WHERE để người dùng không
     * thể đổi id trên URL và xem đơn của người khác.
     */
    public Optional<Order> findByIdAndUser(int orderId, int userId) throws SQLException {
        final String sql = SELECT_ORDER + "WHERE o.order_id = ? AND o.user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(mapRow(rs)) : Optional.empty();
            }
        }
    }

    /**
     * Một đơn theo id (dùng cho quản lý đơn / cập nhật trạng thái).
     * forUpdate=true để khóa dòng trong transaction cập nhật trạng thái.
     */
    public Optional<Order> findById(Connection conn, int orderId, boolean forUpdate)
            throws SQLException {
        String sql = SELECT_ORDER + "WHERE o.order_id = ?" + (forUpdate ? " FOR UPDATE" : "");
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(mapRow(rs)) : Optional.empty();
            }
        }
    }

    /** Danh sách đơn cho Admin (shopOwnerUserId = null) hoặc Seller (chỉ đơn của shop mình). */
    public List<Order> findForManagement(Integer shopOwnerUserId, OrderStatus statusFilter)
            throws SQLException {
        StringBuilder sql = new StringBuilder(SELECT_ORDER).append("WHERE 1 = 1 ");
        List<Object> params = new ArrayList<>();
        if (shopOwnerUserId != null) {
            sql.append("AND sh.user_id = ? ");
            params.add(shopOwnerUserId);
        }
        if (statusFilter != null) {
            sql.append("AND o.order_status = ? ");
            params.add(statusFilter.getCode());
        }
        sql.append("ORDER BY o.created_at DESC, o.order_id DESC LIMIT 200");

        List<Order> orders = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapRow(rs));
                }
            }
        }
        return orders;
    }

    /** Số đơn của một xưởng (shopOwnerUserId = null: toàn sàn) theo từng trạng thái. */
    public record StatusCounts(int total, int pending, int confirmed, int shipping,
                               int completed, int cancelled) {
        public int processing() {
            return pending + confirmed + shipping;
        }
    }

    /**
     * Một trang đơn cho Admin (shopOwnerUserId = null) hoặc Seller (chỉ đơn của xưởng mình),
     * kèm bộ lọc trạng thái và khoảng ngày tạo [from, to]. Cả hai tham số ngày đều có thể null.
     */
    public List<Order> findForManagement(Integer shopOwnerUserId, OrderStatus statusFilter,
                                         LocalDate from, LocalDate to,
                                         int offset, int limit) throws SQLException {
        List<Object> params = new ArrayList<>();
        String sql = SELECT_ORDER + managementWhere(shopOwnerUserId, statusFilter, from, to, params)
                + " ORDER BY o.created_at DESC, o.order_id DESC LIMIT ? OFFSET ?";

        List<Order> orders = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int index = bindParams(ps, params);
            ps.setInt(index++, limit);
            ps.setInt(index, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapRow(rs));
                }
            }
        }
        return orders;
    }

    /** Tổng số đơn khớp bộ lọc (để tính số trang). */
    public int countForManagement(Integer shopOwnerUserId, OrderStatus statusFilter,
                                  LocalDate from, LocalDate to) throws SQLException {
        List<Object> params = new ArrayList<>();
        String sql = "SELECT COUNT(*) FROM orders o "
                + "JOIN shops sh ON sh.shop_id = o.shop_id "
                + managementWhere(shopOwnerUserId, statusFilter, from, to, params);
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            bindParams(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /** Số đơn toàn bộ (không lọc ngày/trạng thái) của xưởng hoặc toàn sàn. */
    public StatusCounts statusCounts(Integer shopOwnerUserId) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) AS total, "
                + "COALESCE(SUM(o.order_status = 'PENDING'), 0) AS pending, "
                + "COALESCE(SUM(o.order_status = 'CONFIRMED'), 0) AS confirmed, "
                + "COALESCE(SUM(o.order_status = 'SHIPPING'), 0) AS shipping, "
                + "COALESCE(SUM(o.order_status = 'COMPLETED'), 0) AS completed, "
                + "COALESCE(SUM(o.order_status = 'CANCELLED'), 0) AS cancelled "
                + "FROM orders o JOIN shops sh ON sh.shop_id = o.shop_id WHERE 1 = 1 ");
        if (shopOwnerUserId != null) {
            sql.append("AND sh.user_id = ?");
        }
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (shopOwnerUserId != null) {
                ps.setInt(1, shopOwnerUserId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return new StatusCounts(0, 0, 0, 0, 0, 0);
                }
                return new StatusCounts(rs.getInt("total"), rs.getInt("pending"),
                        rs.getInt("confirmed"), rs.getInt("shipping"),
                        rs.getInt("completed"), rs.getInt("cancelled"));
            }
        }
    }

    private static String managementWhere(Integer shopOwnerUserId, OrderStatus statusFilter,
                                         LocalDate from, LocalDate to, List<Object> params) {
        StringBuilder where = new StringBuilder("WHERE 1 = 1 ");
        if (shopOwnerUserId != null) {
            where.append("AND sh.user_id = ? ");
            params.add(shopOwnerUserId);
        }
        if (statusFilter != null) {
            where.append("AND o.order_status = ? ");
            params.add(statusFilter.getCode());
        }
        if (from != null) {
            where.append("AND o.created_at >= ? ");
            params.add(Timestamp.valueOf(from.atStartOfDay()));
        }
        if (to != null) {
            where.append("AND o.created_at < ? ");
            params.add(Timestamp.valueOf(to.plusDays(1).atStartOfDay()));
        }
        return where.toString();
    }

    private static int bindParams(PreparedStatement ps, List<Object> params) throws SQLException {
        int index = 1;
        for (Object value : params) {
            ps.setObject(index++, value);
        }
        return index;
    }

    /**
     * Cập nhật trạng thái + mốc thời gian tương ứng. Điều kiện order_status = from
     * để hai yêu cầu đồng thời không ghi đè lên nhau.
     *
     * @return true nếu đúng 1 dòng được cập nhật
     */
    public boolean updateStatus(Connection conn, int orderId, OrderStatus from, OrderStatus to,
                                String cancelReason) throws SQLException {
        String timestampColumn = switch (to) {
            case CONFIRMED -> "confirmed_at";
            case SHIPPING -> "shipping_at";
            case COMPLETED -> "completed_at";
            case CANCELLED -> "cancelled_at";
            case PENDING -> null;
        };

        StringBuilder sql = new StringBuilder("UPDATE orders SET order_status = ?");
        if (timestampColumn != null) {
            sql.append(", ").append(timestampColumn).append(" = NOW()");
        }
        if (to == OrderStatus.CANCELLED) {
            sql.append(", cancel_reason = ?");
        }
        sql.append(" WHERE order_id = ? AND order_status = ?");

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int i = 1;
            ps.setString(i++, to.getCode());
            if (to == OrderStatus.CANCELLED) {
                ps.setString(i++, cancelReason);
            }
            ps.setInt(i++, orderId);
            ps.setString(i, from.getCode());
            return ps.executeUpdate() == 1;
        }
    }

    /**
     * shop_id của xưởng bán một sản phẩm. orders.shop_id là NOT NULL và FK shops,
     * nên mỗi supplier phải có một dòng shops (seed bằng database/order_flow.sql).
     */
    public Optional<Integer> findShopIdBySupplier(Connection conn, int supplierId) throws SQLException {
        final String sql = "SELECT sh.shop_id FROM supplier_profiles sp "
                + "JOIN shops sh ON sh.user_id = sp.user_id "
                + "WHERE sp.supplier_id = ? AND sh.status = 'ACTIVE'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(rs.getInt(1)) : Optional.empty();
            }
        }
    }

    /** Insert đơn và gán order_id sinh ra vào chính đối tượng order. */
    public void insert(Connection conn, Order order) throws SQLException {
        final String sql = "INSERT INTO orders "
                + "(order_code, user_id, shop_id, promotion_id, recipient_name, recipient_phone, "
                + "shipping_address, note, subtotal_amount, shipping_fee, discount_amount, total_amount, "
                + "commission_rate, commission_amount, seller_net_amount, order_status, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, order.getOrderCode());
            ps.setInt(2, order.getUserId());
            ps.setInt(3, order.getShopId());
            if (order.getPromotionId() == null) {
                ps.setNull(4, Types.INTEGER);
            } else {
                ps.setInt(4, order.getPromotionId());
            }
            ps.setString(5, order.getRecipientName());
            ps.setString(6, order.getRecipientPhone());
            ps.setString(7, order.getShippingAddress());
            if (order.getNote() == null || order.getNote().isBlank()) {
                ps.setNull(8, Types.VARCHAR);
            } else {
                ps.setString(8, order.getNote());
            }
            ps.setBigDecimal(9, order.getSubtotalAmount());
            ps.setBigDecimal(10, order.getShippingFee());
            ps.setBigDecimal(11, order.getDiscountAmount());
            ps.setBigDecimal(12, order.getTotalAmount());

            // Hoa hồng nền tảng mặc định 10% (đúng DEFAULT của cột commission_rate).
            BigDecimal commissionRate = new BigDecimal("10.00");
            BigDecimal commission = order.getTotalAmount()
                    .multiply(commissionRate)
                    .divide(new BigDecimal("100"), 2, java.math.RoundingMode.HALF_UP);
            ps.setBigDecimal(13, commissionRate);
            ps.setBigDecimal(14, commission);
            ps.setBigDecimal(15, order.getTotalAmount().subtract(commission));

            ps.setString(16, order.getStatus().getCode());
            ps.setTimestamp(17, Timestamp.valueOf(
                    order.getCreatedAt() == null ? java.time.LocalDateTime.now() : order.getCreatedAt()));
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    order.setOrderId(keys.getInt(1));
                }
            }
        }
    }

    /** Ghi bản ghi thanh toán ban đầu (COD / BANK_TRANSFER → PENDING: chưa thanh toán). */
    public void insertPayment(Connection conn, int orderId, PaymentMethod method,
                              BigDecimal amount, PaymentStatus status) throws SQLException {
        final String sql = "INSERT INTO payments "
                + "(order_id, payment_method, amount, transaction_code, payment_status, paid_at) "
                + "VALUES (?, ?, ?, NULL, ?, NULL)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setString(2, method.getCode());
            ps.setBigDecimal(3, amount);
            ps.setString(4, status.getCode());
            ps.executeUpdate();
        }
    }

    /**
     * Cập nhật kết quả thanh toán từ cổng VNPay trong cùng transaction.
     */
    public void updatePaymentAfterVnpay(Connection conn, int orderId, PaymentStatus status,
                                        String transactionCode, boolean markPaidTime) throws SQLException {
        final String sql = "UPDATE payments SET payment_status = ?, transaction_code = ?, "
                + "paid_at = " + (markPaidTime ? "NOW()" : "NULL")
                + " WHERE order_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status.getCode());
            if (transactionCode == null || transactionCode.isBlank()) {
                ps.setNull(2, Types.VARCHAR);
            } else {
                ps.setString(2, transactionCode.trim());
            }
            ps.setInt(3, orderId);
            ps.executeUpdate();
        }
    }

    private Order mapRow(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setOrderCode(rs.getString("order_code"));
        o.setUserId(rs.getInt("user_id"));
        o.setCustomerName(rs.getString("customer_name"));
        o.setShopId(rs.getInt("shop_id"));
        o.setShopName(rs.getString("shop_name"));
        o.setShopOwnerUserId(rs.getInt("shop_owner_user_id"));
        int promotionId = rs.getInt("promotion_id");
        o.setPromotionId(rs.wasNull() ? null : promotionId);
        o.setRecipientName(rs.getString("recipient_name"));
        o.setRecipientPhone(rs.getString("recipient_phone"));
        o.setShippingAddress(rs.getString("shipping_address"));
        o.setNote(rs.getString("note"));
        o.setSubtotalAmount(rs.getBigDecimal("subtotal_amount"));
        o.setShippingFee(rs.getBigDecimal("shipping_fee"));
        o.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        o.setTotalAmount(rs.getBigDecimal("total_amount"));
        o.setStatus(OrderStatus.fromDb(rs.getString("order_status")));
        o.setCancelReason(rs.getString("cancel_reason"));
        o.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());

        String method = rs.getString("payment_method");
        o.setPaymentMethod(PaymentMethod.fromDb(method));
        String paymentStatus = rs.getString("payment_status");
        o.setPaymentStatus(paymentStatus == null
                ? PaymentStatus.PENDING
                : PaymentStatus.fromDb(paymentStatus));
        return o;
    }
}