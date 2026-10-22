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
            "SELECT o.order_id, o.order_code, o.user_id, o.shop_id, sh.shop_name, "
                    + "o.recipient_name, o.recipient_phone, o.shipping_address, o.note, "
                    + "o.subtotal_amount, o.shipping_fee, o.discount_amount, o.total_amount, "
                    + "o.order_status, o.created_at, "
                    + "p.payment_method, p.payment_status "
                    + "FROM orders o "
                    + "JOIN shops sh ON sh.shop_id = o.shop_id "
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
                + "VALUES (?, ?, ?, NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, order.getOrderCode());
            ps.setInt(2, order.getUserId());
            ps.setInt(3, order.getShopId());
            ps.setString(4, order.getRecipientName());
            ps.setString(5, order.getRecipientPhone());
            ps.setString(6, order.getShippingAddress());
            if (order.getNote() == null || order.getNote().isBlank()) {
                ps.setNull(7, Types.VARCHAR);
            } else {
                ps.setString(7, order.getNote());
            }
            ps.setBigDecimal(8, order.getSubtotalAmount());
            ps.setBigDecimal(9, order.getShippingFee());
            ps.setBigDecimal(10, order.getDiscountAmount());
            ps.setBigDecimal(11, order.getTotalAmount());

            // Hoa hồng nền tảng mặc định 10% (đúng DEFAULT của cột commission_rate).
            BigDecimal commissionRate = new BigDecimal("10.00");
            BigDecimal commission = order.getTotalAmount()
                    .multiply(commissionRate)
                    .divide(new BigDecimal("100"), 2, java.math.RoundingMode.HALF_UP);
            ps.setBigDecimal(12, commissionRate);
            ps.setBigDecimal(13, commission);
            ps.setBigDecimal(14, order.getTotalAmount().subtract(commission));

            ps.setString(15, order.getStatus().getCode());
            ps.setTimestamp(16, Timestamp.valueOf(
                    order.getCreatedAt() == null ? java.time.LocalDateTime.now() : order.getCreatedAt()));
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    order.setOrderId(keys.getInt(1));
                }
            }
        }
    }

    /** Ghi bản ghi thanh toán ban đầu (COD → PENDING: chưa thanh toán). */
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

    private Order mapRow(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setOrderCode(rs.getString("order_code"));
        o.setUserId(rs.getInt("user_id"));
        o.setShopId(rs.getInt("shop_id"));
        o.setShopName(rs.getString("shop_name"));
        o.setRecipientName(rs.getString("recipient_name"));
        o.setRecipientPhone(rs.getString("recipient_phone"));
        o.setShippingAddress(rs.getString("shipping_address"));
        o.setNote(rs.getString("note"));
        o.setSubtotalAmount(rs.getBigDecimal("subtotal_amount"));
        o.setShippingFee(rs.getBigDecimal("shipping_fee"));
        o.setDiscountAmount(rs.getBigDecimal("discount_amount"));
        o.setTotalAmount(rs.getBigDecimal("total_amount"));
        o.setStatus(OrderStatus.fromDb(rs.getString("order_status")));
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
