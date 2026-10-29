package com.tmdt.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import static com.tmdt.util.DBConnection.getConnection;

/**
 * Đọc dữ liệu thật từ schema tmdt cho các màn hình admin còn dùng dữ liệu mẫu
 * trước đây: bảng điều khiển, sản phẩm, đơn hàng và xưởng in.
 *
 * Mọi câu SQL đều cố định; tham số người dùng chỉ đi qua PreparedStatement.
 * Riêng phần sắp xếp của danh sách xưởng in được chọn từ whitelist ở service.
 */
public class AdminLiveDAO {

    /** KPI của bảng điều khiển, tất cả tính trên dữ liệu thật. */
    public record Kpi(BigDecimal revenueToday, BigDecimal revenueYesterday,
                      long createdToday, long processing,
                      BigDecimal completionRate, long lowStock) {
    }

    public record RecentOrder(String code, String customer, String shop,
                              String status, BigDecimal total, String createdAt) {
    }

    public record Category(long id, String name, long products) {
    }

    public record Product(long id, String name, String sku, String category,
                          String supplier, BigDecimal price, int stock,
                          int sold, String status, String updatedAt) {
    }

    public record ProductCounts(long total, long active, long lowStock) {
    }

    public record Order(String code, String customer, String recipient,
                        String shop, String status, BigDecimal total,
                        int itemCount, String createdAt) {
    }

    public record OrderCounts(long total, BigDecimal value, long active, long cancelled) {
    }

    public record ShopRef(long id, String name) {
    }

    public record Supplier(long id, String name, String address, BigDecimal rating,
                           int reviews, long products, long orders30,
                           BigDecimal revenue30, String status) {
    }

    public record SupplierCounts(long total, long active, BigDecimal avgRating, long products) {
    }

    // ------------------------------------------------------------------
    // Bảng điều khiển
    // ------------------------------------------------------------------

    public Kpi kpi() throws SQLException {
        final String sql = "SELECT "
                + "COALESCE(SUM(CASE WHEN order_status = 'COMPLETED' "
                + "AND DATE(completed_at) = CURDATE() THEN total_amount END), 0) AS revenue_today, "
                + "COALESCE(SUM(CASE WHEN order_status = 'COMPLETED' "
                + "AND DATE(completed_at) = CURDATE() - INTERVAL 1 DAY THEN total_amount END), 0) "
                + "AS revenue_yesterday, "
                + "SUM(CASE WHEN DATE(created_at) = CURDATE() THEN 1 ELSE 0 END) AS created_today, "
                + "SUM(CASE WHEN order_status IN ('PENDING','CONFIRMED','SHIPPING') "
                + "THEN 1 ELSE 0 END) AS processing "
                + "FROM orders";
        BigDecimal revenueToday = BigDecimal.ZERO;
        BigDecimal revenueYesterday = BigDecimal.ZERO;
        long createdToday = 0;
        long processing = 0;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                revenueToday = rs.getBigDecimal("revenue_today");
                revenueYesterday = rs.getBigDecimal("revenue_yesterday");
                createdToday = rs.getLong("created_today");
                processing = rs.getLong("processing");
            }
        }
        return new Kpi(revenueToday, revenueYesterday, createdToday, processing,
                completionRate30(), lowStockCount());
    }

    /** Tỉ lệ đơn hoàn tất trên số đơn tạo trong 30 ngày gần nhất (%). */
    private BigDecimal completionRate30() throws SQLException {
        final String sql = "SELECT COUNT(*) AS total, "
                + "SUM(CASE WHEN order_status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed "
                + "FROM orders WHERE created_at >= CURDATE() - INTERVAL 29 DAY";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (!rs.next() || rs.getLong("total") == 0) {
                return BigDecimal.ZERO;
            }
            return BigDecimal.valueOf(rs.getLong("completed"))
                    .multiply(BigDecimal.valueOf(100))
                    .divide(BigDecimal.valueOf(rs.getLong("total")), 1, java.math.RoundingMode.HALF_UP);
        }
    }

    private long lowStockCount() throws SQLException {
        final String sql = "SELECT COUNT(*) FROM products "
                + "WHERE status = 'ACTIVE' AND stock_quantity <= 10";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getLong(1) : 0;
        }
    }

    public List<RecentOrder> recentOrders(int limit) throws SQLException {
        final String sql = "SELECT o.order_code, u.full_name AS customer, s.shop_name AS shop, "
                + "o.order_status, o.total_amount, o.created_at "
                + "FROM orders o "
                + "JOIN users u ON u.user_id = o.user_id "
                + "JOIN shops s ON s.shop_id = o.shop_id "
                + "ORDER BY o.created_at DESC, o.order_id DESC LIMIT ?";
        return readOrders(sql, limit);
    }

    public List<RecentOrder> pendingOrders(int limit) throws SQLException {
        final String sql = "SELECT o.order_code, u.full_name AS customer, s.shop_name AS shop, "
                + "o.order_status, o.total_amount, o.created_at "
                + "FROM orders o "
                + "JOIN users u ON u.user_id = o.user_id "
                + "JOIN shops s ON s.shop_id = o.shop_id "
                + "WHERE o.order_status IN ('PENDING','CONFIRMED') "
                + "ORDER BY o.created_at ASC, o.order_id ASC LIMIT ?";
        return readOrders(sql, limit);
    }

    private List<RecentOrder> readOrders(String sql, int limit) throws SQLException {
        List<RecentOrder> rows = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    rows.add(new RecentOrder(
                            rs.getString("order_code"),
                            rs.getString("customer"),
                            rs.getString("shop"),
                            rs.getString("order_status"),
                            rs.getBigDecimal("total_amount"),
                            format(rs.getTimestamp("created_at"))));
                }
            }
        }
        return rows;
    }

    // ------------------------------------------------------------------
    // Sản phẩm
    // ------------------------------------------------------------------

    public ProductCounts productCounts() throws SQLException {
        final String sql = "SELECT COUNT(*) AS total, "
                + "SUM(CASE WHEN status = 'ACTIVE' THEN 1 ELSE 0 END) AS active, "
                + "SUM(CASE WHEN status = 'ACTIVE' AND stock_quantity <= 10 THEN 1 ELSE 0 END) AS low_stock "
                + "FROM products";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) {
                return new ProductCounts(0, 0, 0);
            }
            return new ProductCounts(rs.getLong("total"), rs.getLong("active"),
                    rs.getLong("low_stock"));
        }
    }

    public List<Category> categories() throws SQLException {
        final String sql = "SELECT c.category_id, c.name, COUNT(p.product_id) AS products "
                + "FROM categories c JOIN products p ON p.category_id = c.category_id "
                + "GROUP BY c.category_id, c.name ORDER BY c.name";
        List<Category> rows = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                rows.add(new Category(rs.getLong("category_id"), rs.getString("name"),
                        rs.getLong("products")));
            }
        }
        return rows;
    }

    public long countProducts(String q, Long categoryId, String status, boolean lowOnly)
            throws SQLException {
        List<Object> args = new ArrayList<>();
        String where = productWhere(q, categoryId, status, lowOnly, args);
        String sql = "SELECT COUNT(*) FROM products p " + where;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            bind(ps, args);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong(1) : 0;
            }
        }
    }

    public List<Product> products(String q, Long categoryId, String status, boolean lowOnly,
                                  int limit, int offset) throws SQLException {
        List<Object> args = new ArrayList<>();
        String where = productWhere(q, categoryId, status, lowOnly, args);
        String sql = "SELECT p.product_id, p.name, p.slug, c.name AS category, "
                + "COALESCE(sp.shop_name, 'Chưa gán') AS supplier, p.price, "
                + "p.stock_quantity, p.sold_count, p.status, p.updated_at "
                + "FROM products p "
                + "JOIN categories c ON c.category_id = p.category_id "
                + "LEFT JOIN supplier_profiles sp ON sp.supplier_id = p.supplier_id "
                + where
                + " ORDER BY p.sold_count DESC, p.product_id DESC LIMIT ? OFFSET ?";
        args.add(limit);
        args.add(offset);
        List<Product> rows = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            bind(ps, args);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    rows.add(new Product(
                            rs.getLong("product_id"),
                            rs.getString("name"),
                            rs.getString("slug"),
                            rs.getString("category"),
                            rs.getString("supplier"),
                            rs.getBigDecimal("price"),
                            rs.getInt("stock_quantity"),
                            rs.getInt("sold_count"),
                            rs.getString("status"),
                            format(rs.getTimestamp("updated_at"))));
                }
            }
        }
        return rows;
    }

    private static String productWhere(String q, Long categoryId, String status,
                                       boolean lowOnly, List<Object> args) {
        StringBuilder where = new StringBuilder(" WHERE 1 = 1");
        if (q != null && !q.isBlank()) {
            where.append(" AND (p.name LIKE ? OR p.slug LIKE ?)");
            String like = "%" + q.trim() + "%";
            args.add(like);
            args.add(like);
        }
        if (categoryId != null) {
            where.append(" AND p.category_id = ?");
            args.add(categoryId);
        }
        if (status != null && !status.isBlank()) {
            where.append(" AND p.status = ?");
            args.add(status);
        }
        if (lowOnly) {
            where.append(" AND p.stock_quantity <= 10");
        }
        return where.toString();
    }

    // ------------------------------------------------------------------
    // Đơn hàng
    // ------------------------------------------------------------------

    public OrderCounts orderCounts() throws SQLException {
        final String sql = "SELECT COUNT(*) AS total, COALESCE(SUM(total_amount), 0) AS value, "
                + "SUM(CASE WHEN order_status IN ('PENDING','CONFIRMED','SHIPPING') "
                + "THEN 1 ELSE 0 END) AS active, "
                + "SUM(CASE WHEN order_status = 'CANCELLED' THEN 1 ELSE 0 END) AS cancelled "
                + "FROM orders";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) {
                return new OrderCounts(0, BigDecimal.ZERO, 0, 0);
            }
            return new OrderCounts(rs.getLong("total"), rs.getBigDecimal("value"),
                    rs.getLong("active"), rs.getLong("cancelled"));
        }
    }

    public List<ShopRef> shops() throws SQLException {
        final String sql = "SELECT shop_id, shop_name FROM shops ORDER BY shop_name";
        List<ShopRef> rows = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                rows.add(new ShopRef(rs.getLong("shop_id"), rs.getString("shop_name")));
            }
        }
        return rows;
    }

    public long countOrders(String q, String status, Long shopId, Integer days)
            throws SQLException {
        List<Object> args = new ArrayList<>();
        String where = orderWhere(q, status, shopId, days, args);
        String sql = "SELECT COUNT(*) FROM orders o "
                + "JOIN users u ON u.user_id = o.user_id "
                + "JOIN shops s ON s.shop_id = o.shop_id " + where;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            bind(ps, args);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong(1) : 0;
            }
        }
    }

    public List<Order> orders(String q, String status, Long shopId, Integer days,
                              int limit, int offset) throws SQLException {
        List<Object> args = new ArrayList<>();
        String where = orderWhere(q, status, shopId, days, args);
        String sql = "SELECT o.order_code, u.full_name AS customer, o.recipient_name, "
                + "s.shop_name AS shop, o.order_status, o.total_amount, "
                + "(SELECT COUNT(*) FROM order_items oi WHERE oi.order_id = o.order_id) AS item_count, "
                + "o.created_at "
                + "FROM orders o "
                + "JOIN users u ON u.user_id = o.user_id "
                + "JOIN shops s ON s.shop_id = o.shop_id "
                + where
                + " ORDER BY o.created_at DESC, o.order_id DESC LIMIT ? OFFSET ?";
        args.add(limit);
        args.add(offset);
        List<Order> rows = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            bind(ps, args);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    rows.add(new Order(
                            rs.getString("order_code"),
                            rs.getString("customer"),
                            rs.getString("recipient_name"),
                            rs.getString("shop"),
                            rs.getString("order_status"),
                            rs.getBigDecimal("total_amount"),
                            rs.getInt("item_count"),
                            format(rs.getTimestamp("created_at"))));
                }
            }
        }
        return rows;
    }

    private static String orderWhere(String q, String status, Long shopId, Integer days,
                                     List<Object> args) {
        StringBuilder where = new StringBuilder(" WHERE 1 = 1");
        if (q != null && !q.isBlank()) {
            where.append(" AND (o.order_code LIKE ? OR u.full_name LIKE ? "
                    + "OR o.recipient_name LIKE ? OR s.shop_name LIKE ?)");
            String like = "%" + q.trim() + "%";
            for (int i = 0; i < 4; i++) {
                args.add(like);
            }
        }
        if (status != null && !status.isBlank()) {
            where.append(" AND o.order_status = ?");
            args.add(status);
        }
        if (shopId != null) {
            where.append(" AND o.shop_id = ?");
            args.add(shopId);
        }
        if (days != null && days > 0) {
            where.append(" AND o.created_at >= ?");
            args.add(Timestamp.valueOf(LocalDate.now().minusDays(days - 1L).atStartOfDay()));
        }
        return where.toString();
    }

    // ------------------------------------------------------------------
    // Xưởng in (supplier_profiles)
    // ------------------------------------------------------------------

    public SupplierCounts supplierCounts() throws SQLException {
        final String sql = "SELECT COUNT(*) AS total, "
                + "SUM(CASE WHEN status = 'ACTIVE' THEN 1 ELSE 0 END) AS active, "
                + "COALESCE(AVG(NULLIF(avg_rating, 0)), 0) AS avg_rating, "
                + "(SELECT COUNT(*) FROM products) AS products "
                + "FROM supplier_profiles";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) {
                return new SupplierCounts(0, 0, BigDecimal.ZERO, 0);
            }
            return new SupplierCounts(rs.getLong("total"), rs.getLong("active"),
                    rs.getBigDecimal("avg_rating"), rs.getLong("products"));
        }
    }

    public long countSuppliers(String q) throws SQLException {
        final String sql = "SELECT COUNT(*) FROM supplier_profiles sp "
                + "WHERE (? = '' OR sp.shop_name LIKE ?)";
        String like = "%" + (q == null ? "" : q.trim()) + "%";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, q == null ? "" : q.trim());
            ps.setString(2, like);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong(1) : 0;
            }
        }
    }

    /**
     * @param orderBy whitelist: revenue | orders | rating | name
     */
    public List<Supplier> suppliers(String q, String orderBy, int limit, int offset)
            throws SQLException {
        String sort = switch (orderBy == null ? "revenue" : orderBy) {
            case "orders" -> "orders30 DESC, revenue30 DESC";
            case "rating" -> "sp.avg_rating DESC, sp.review_count DESC";
            case "name" -> "sp.shop_name ASC";
            default -> "revenue30 DESC, orders30 DESC";
        };
        final String sql = "SELECT sp.supplier_id, sp.shop_name, sp.address, sp.avg_rating, "
                + "sp.review_count, sp.status, "
                + "(SELECT COUNT(*) FROM products p WHERE p.supplier_id = sp.supplier_id) AS products, "
                + "(SELECT COUNT(DISTINCT o.order_id) FROM order_items oi "
                + " JOIN orders o ON o.order_id = oi.order_id "
                + " JOIN products p ON p.product_id = oi.product_id "
                + " WHERE p.supplier_id = sp.supplier_id "
                + " AND o.created_at >= CURDATE() - INTERVAL 29 DAY) AS orders30, "
                + "(SELECT COALESCE(SUM(oi.line_total), 0) FROM order_items oi "
                + " JOIN orders o ON o.order_id = oi.order_id "
                + " JOIN products p ON p.product_id = oi.product_id "
                + " WHERE p.supplier_id = sp.supplier_id AND o.order_status = 'COMPLETED' "
                + " AND o.completed_at >= CURDATE() - INTERVAL 29 DAY) AS revenue30 "
                + "FROM supplier_profiles sp "
                + "WHERE (? = '' OR sp.shop_name LIKE ?) "
                + "ORDER BY " + sort + " LIMIT ? OFFSET ?";
        String keyword = q == null ? "" : q.trim();
        List<Supplier> rows = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, keyword);
            ps.setString(2, "%" + keyword + "%");
            ps.setInt(3, limit);
            ps.setInt(4, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    rows.add(new Supplier(
                            rs.getLong("supplier_id"),
                            rs.getString("shop_name"),
                            rs.getString("address"),
                            rs.getBigDecimal("avg_rating"),
                            rs.getInt("review_count"),
                            rs.getLong("products"),
                            rs.getLong("orders30"),
                            rs.getBigDecimal("revenue30"),
                            rs.getString("status")));
                }
            }
        }
        return rows;
    }

    // ------------------------------------------------------------------
    // Helpers
    // ------------------------------------------------------------------

    private static void bind(PreparedStatement ps, List<Object> args) throws SQLException {
        for (int i = 0; i < args.size(); i++) {
            Object value = args.get(i);
            if (value instanceof Timestamp ts) {
                ps.setTimestamp(i + 1, ts);
            } else if (value instanceof Long l) {
                ps.setLong(i + 1, l);
            } else if (value instanceof Integer n) {
                ps.setInt(i + 1, n);
            } else {
                ps.setString(i + 1, String.valueOf(value));
            }
        }
    }

    private static String format(Timestamp value) {
        if (value == null) {
            return null;
        }
        LocalDateTime time = value.toLocalDateTime();
        return String.format("%04d-%02d-%02d %02d:%02d",
                time.getYear(), time.getMonthValue(), time.getDayOfMonth(),
                time.getHour(), time.getMinute());
    }
}
