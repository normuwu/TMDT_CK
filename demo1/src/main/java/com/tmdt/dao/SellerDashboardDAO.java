package com.tmdt.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static com.tmdt.util.DBConnection.getConnection;

/**
 * Dữ liệu cho Dashboard của Người bán (xưởng in).
 *
 * Nguyên tắc:
 *  - Mọi truy vấn đều lọc theo shop_id (đơn/doanh thu) hoặc supplier_id (sản phẩm)
 *    của đúng tài khoản đang đăng nhập — không có tham số nào lấy từ trình duyệt.
 *  - Doanh thu = SUM(orders.total_amount) của đơn COMPLETED (đơn đã giao), theo
 *    completed_at. Đơn PENDING/CONFIRMED/SHIPPING/CANCELLED KHÔNG được tính.
 *  - Mỗi đơn chỉ là một dòng trong orders nên không thể cộng trùng khi đơn có
 *    nhiều order_items.
 *  - Toàn bộ dùng PreparedStatement, không ghép chuỗi từ dữ liệu người dùng.
 */
public class SellerDashboardDAO {

    private static final DateTimeFormatter DATE_TIME =
            DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    private static final int LOW_STOCK = 5;

    /** Xưởng (shops) + hồ sơ xưởng (supplier_profiles) của một tài khoản SELLER. */
    public record Shop(int shopId, int supplierId, String shopName) {
    }

    public record ProductStats(int total, int active, int hidden, int lowStock) {
    }

    public record OrderCounts(int total, int pending, int confirmed, int shipping,
                              int completed, int cancelled) {
        public int processing() {
            return pending + confirmed + shipping;
        }
    }

    public record Revenue(BigDecimal total, BigDecimal today, BigDecimal yesterday,
                          BigDecimal thisMonth) {
    }

    public record OrderRow(int orderId, String orderCode, String customerName,
                           String recipientName, BigDecimal totalAmount, String status,
                           String statusLabel, LocalDateTime createdAt) {
        public String getCreatedAtText() {
            return createdAt == null ? "" : DATE_TIME.format(createdAt);
        }
    }

    public record ProductRow(int productId, String name, long price, int stock,
                             String status, LocalDateTime updatedAt) {
        public String getUpdatedAtText() {
            return updatedAt == null ? "" : DATE_TIME.format(updatedAt);
        }
    }

    public record TopProduct(int productId, String name, long quantity, BigDecimal revenue) {
    }

    // ------------------------------------------------------------------

    public Optional<Shop> findShop(int userId) throws SQLException {
        final String sql = "SELECT sh.shop_id, sp.supplier_id, sh.shop_name "
                + "FROM shops sh JOIN supplier_profiles sp ON sp.user_id = sh.user_id "
                + "WHERE sh.user_id = ? AND sh.status = 'ACTIVE' AND sp.status = 'ACTIVE' "
                + "LIMIT 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next()
                        ? Optional.of(new Shop(rs.getInt("shop_id"),
                                rs.getInt("supplier_id"), rs.getString("shop_name")))
                        : Optional.empty();
            }
        }
    }

    public ProductStats productStats(int supplierId) throws SQLException {
        final String sql = "SELECT COUNT(*) AS total, "
                + "COALESCE(SUM(status = 'ACTIVE'), 0) AS active, "
                + "COALESCE(SUM(status = 'HIDDEN'), 0) AS hidden, "
                + "COALESCE(SUM(status = 'ACTIVE' AND stock_quantity <= ?), 0) AS low_stock "
                + "FROM products WHERE supplier_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, LOW_STOCK);
            ps.setInt(2, supplierId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return new ProductStats(0, 0, 0, 0);
                }
                return new ProductStats(rs.getInt("total"), rs.getInt("active"),
                        rs.getInt("hidden"), rs.getInt("low_stock"));
            }
        }
    }

    public OrderCounts orderCounts(int shopId) throws SQLException {
        final String sql = "SELECT COUNT(*) AS total, "
                + "COALESCE(SUM(order_status = 'PENDING'), 0) AS pending, "
                + "COALESCE(SUM(order_status = 'CONFIRMED'), 0) AS confirmed, "
                + "COALESCE(SUM(order_status = 'SHIPPING'), 0) AS shipping, "
                + "COALESCE(SUM(order_status = 'COMPLETED'), 0) AS completed, "
                + "COALESCE(SUM(order_status = 'CANCELLED'), 0) AS cancelled "
                + "FROM orders WHERE shop_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return new OrderCounts(0, 0, 0, 0, 0, 0);
                }
                return new OrderCounts(rs.getInt("total"), rs.getInt("pending"),
                        rs.getInt("confirmed"), rs.getInt("shipping"),
                        rs.getInt("completed"), rs.getInt("cancelled"));
            }
        }
    }

    /** Doanh thu thực nhận theo đơn COMPLETED: tổng, hôm nay, hôm qua, tháng này. */
    public Revenue revenue(int shopId) throws SQLException {
        final String sql = "SELECT "
                + "COALESCE(SUM(total_amount), 0) AS total, "
                + "COALESCE(SUM(CASE WHEN completed_at >= CURRENT_DATE "
                + "AND completed_at < CURRENT_DATE + INTERVAL 1 DAY THEN total_amount END), 0) AS today, "
                + "COALESCE(SUM(CASE WHEN completed_at >= CURRENT_DATE - INTERVAL 1 DAY "
                + "AND completed_at < CURRENT_DATE THEN total_amount END), 0) AS yesterday, "
                + "COALESCE(SUM(CASE WHEN completed_at >= DATE_FORMAT(CURRENT_DATE, '%Y-%m-01') "
                + "AND completed_at < DATE_FORMAT(CURRENT_DATE, '%Y-%m-01') + INTERVAL 1 MONTH "
                + "THEN total_amount END), 0) AS this_month "
                + "FROM orders WHERE shop_id = ? AND order_status = 'COMPLETED'";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return new Revenue(BigDecimal.ZERO, BigDecimal.ZERO,
                            BigDecimal.ZERO, BigDecimal.ZERO);
                }
                return new Revenue(rs.getBigDecimal("total"), rs.getBigDecimal("today"),
                        rs.getBigDecimal("yesterday"), rs.getBigDecimal("this_month"));
            }
        }
    }

    /** N đơn mới nhất của xưởng. */
    public List<OrderRow> recentOrders(int shopId, int limit) throws SQLException {
        final String sql = "SELECT o.order_id, o.order_code, u.full_name AS customer_name, "
                + "o.recipient_name, o.total_amount, o.order_status, o.created_at "
                + "FROM orders o JOIN users u ON u.user_id = o.user_id "
                + "WHERE o.shop_id = ? "
                + "ORDER BY o.created_at DESC, o.order_id DESC LIMIT ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shopId);
            ps.setInt(2, limit);
            return readOrderRows(ps);
        }
    }

    /** Các đơn đang chờ xưởng xác nhận, cũ nhất trước (cần xử lý gấp). */
    public List<OrderRow> pendingOrders(int shopId, int limit) throws SQLException {
        final String sql = "SELECT o.order_id, o.order_code, u.full_name AS customer_name, "
                + "o.recipient_name, o.total_amount, o.order_status, o.created_at "
                + "FROM orders o JOIN users u ON u.user_id = o.user_id "
                + "WHERE o.shop_id = ? AND o.order_status = 'PENDING' "
                + "ORDER BY o.created_at ASC, o.order_id ASC LIMIT ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shopId);
            ps.setInt(2, limit);
            return readOrderRows(ps);
        }
    }

    private static List<OrderRow> readOrderRows(PreparedStatement ps) throws SQLException {
        List<OrderRow> rows = new ArrayList<>();
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String status = rs.getString("order_status");
                Timestamp created = rs.getTimestamp("created_at");
                rows.add(new OrderRow(rs.getInt("order_id"), rs.getString("order_code"),
                        rs.getString("customer_name"), rs.getString("recipient_name"),
                        rs.getBigDecimal("total_amount"), status,
                        statusLabel(status),
                        created == null ? null : created.toLocalDateTime()));
            }
        }
        return rows;
    }

    /** N sản phẩm vừa được cập nhật. */
    public List<ProductRow> recentProducts(int supplierId, int limit) throws SQLException {
        final String sql = "SELECT product_id, name, price, stock_quantity, status, updated_at "
                + "FROM products WHERE supplier_id = ? "
                + "ORDER BY updated_at DESC, product_id DESC LIMIT ?";
        List<ProductRow> rows = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Timestamp updated = rs.getTimestamp("updated_at");
                    rows.add(new ProductRow(rs.getInt("product_id"), rs.getString("name"),
                            rs.getLong("price"), rs.getInt("stock_quantity"),
                            rs.getString("status"),
                            updated == null ? null : updated.toLocalDateTime()));
                }
            }
        }
        return rows;
    }

    /**
     * Sản phẩm bán chạy trong khoảng ngày (chỉ tính đơn COMPLETED).
     * Số lượng bán lấy từ order_items (đơn giá là snapshot lúc mua).
     */
    public List<TopProduct> topProducts(int shopId, LocalDate from, LocalDate to, int limit)
            throws SQLException {
        final String sql = "SELECT p.product_id, p.name, "
                + "COALESCE(SUM(oi.quantity), 0) AS qty, "
                + "COALESCE(SUM(oi.line_total), 0) AS revenue "
                + "FROM order_items oi "
                + "JOIN orders o ON o.order_id = oi.order_id "
                + "JOIN products p ON p.product_id = oi.product_id "
                + "WHERE o.shop_id = ? AND o.order_status = 'COMPLETED' "
                + "AND o.completed_at >= ? AND o.completed_at < ? "
                + "GROUP BY p.product_id, p.name ORDER BY qty DESC, revenue DESC LIMIT ?";
        List<TopProduct> rows = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shopId);
            ps.setTimestamp(2, Timestamp.valueOf(from.atStartOfDay()));
            ps.setTimestamp(3, Timestamp.valueOf(to.plusDays(1).atStartOfDay()));
            ps.setInt(4, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    rows.add(new TopProduct(rs.getInt("product_id"), rs.getString("name"),
                            rs.getLong("qty"), rs.getBigDecimal("revenue")));
                }
            }
        }
        return rows;
    }

    public static String statusLabel(String status) {
        if (status == null) {
            return "";
        }
        return switch (status) {
            case "PENDING" -> "Chờ xác nhận";
            case "CONFIRMED" -> "Đã xác nhận";
            case "SHIPPING" -> "Đang giao hàng";
            case "COMPLETED" -> "Đã giao hàng";
            case "CANCELLED" -> "Đã hủy";
            default -> status;
        };
    }

}
