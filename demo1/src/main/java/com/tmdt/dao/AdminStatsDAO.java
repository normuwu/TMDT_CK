package com.tmdt.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import static com.tmdt.util.DBConnection.getConnection;

/**
 * Truy vấn thống kê dùng chung cho Admin (shopId = 0: toàn sàn) và Người bán
 * (shopId = shops.shop_id của người bán). Mọi câu SQL cố định, không ghép chuỗi
 * từ tham số người dùng. Khoảng thời gian luôn là [from, toExclusive).
 */
public class AdminStatsDAO {

    public record DayRevenue(LocalDate day, BigDecimal revenue, long orders) {
    }

    public record Slice(String name, BigDecimal value) {
    }

    /** Doanh thu + số đơn COMPLETED, gom theo DATE(completed_at). */
    public List<DayRevenue> completedByDay(LocalDate from, LocalDate toExclusive, int shopId)
            throws SQLException {
        final String sql = "SELECT DATE(completed_at) AS d, "
                + "COALESCE(SUM(total_amount), 0) AS revenue, COUNT(*) AS orders "
                + "FROM orders WHERE order_status = 'COMPLETED' "
                + "AND completed_at >= ? AND completed_at < ? "
                + "AND (? = 0 OR shop_id = ?) "
                + "GROUP BY DATE(completed_at) ORDER BY d";
        List<DayRevenue> rows = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            bindRange(ps, from, toExclusive, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    rows.add(new DayRevenue(
                            rs.getDate("d").toLocalDate(),
                            rs.getBigDecimal("revenue"),
                            rs.getLong("orders")));
                }
            }
        }
        return rows;
    }

    /** Số đơn TẠO trong kỳ theo order_status (dùng cho tỉ lệ hủy). */
    public Map<String, Long> createdByStatus(LocalDate from, LocalDate toExclusive, int shopId)
            throws SQLException {
        final String sql = "SELECT order_status, COUNT(*) AS total FROM orders "
                + "WHERE created_at >= ? AND created_at < ? "
                + "AND (? = 0 OR shop_id = ?) GROUP BY order_status";
        Map<String, Long> result = new LinkedHashMap<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            bindCreatedRange(ps, from, toExclusive, shopId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.put(rs.getString("order_status"), rs.getLong("total"));
                }
            }
        }
        return result;
    }

    /**
     * Cơ cấu theo chiều:
     *  - category: order_items -> orders -> products -> categories (đơn COMPLETED)
     *  - shop: orders -> shops (đơn COMPLETED); với người bán chỉ còn 1 xưởng
     *  - status: đơn TẠO trong kỳ, luôn đếm số đơn
     */
    public List<Slice> breakdown(String by, String metric,
                                 LocalDate from, LocalDate toExclusive, int shopId) throws SQLException {
        boolean revenue = "revenue".equals(metric);
        String sql;
        if ("status".equals(by)) {
            sql = "SELECT order_status AS name, COUNT(*) AS value FROM orders "
                    + "WHERE created_at >= ? AND created_at < ? "
                    + "AND (? = 0 OR shop_id = ?) "
                    + "GROUP BY order_status ORDER BY value DESC";
        } else if ("shop".equals(by)) {
            sql = "SELECT s.shop_name AS name, "
                    + (revenue ? "COALESCE(SUM(o.total_amount), 0)" : "COUNT(DISTINCT o.order_id)")
                    + " AS value FROM orders o "
                    + "JOIN shops s ON s.shop_id = o.shop_id "
                    + "WHERE o.order_status = 'COMPLETED' "
                    + "AND o.completed_at >= ? AND o.completed_at < ? "
                    + "AND (? = 0 OR o.shop_id = ?) "
                    + "GROUP BY s.shop_id, s.shop_name ORDER BY value DESC";
        } else {
            sql = "SELECT c.name AS name, "
                    + (revenue ? "COALESCE(SUM(oi.line_total), 0)" : "COUNT(DISTINCT o.order_id)")
                    + " AS value FROM order_items oi "
                    + "JOIN orders o ON o.order_id = oi.order_id "
                    + "JOIN products p ON p.product_id = oi.product_id "
                    + "JOIN categories c ON c.category_id = p.category_id "
                    + "WHERE o.order_status = 'COMPLETED' "
                    + "AND o.completed_at >= ? AND o.completed_at < ? "
                    + "AND (? = 0 OR o.shop_id = ?) "
                    + "GROUP BY c.category_id, c.name ORDER BY value DESC";
        }

        List<Slice> slices = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if ("status".equals(by)) {
                bindCreatedRange(ps, from, toExclusive, shopId);
            } else {
                bindRange(ps, from, toExclusive, shopId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    slices.add(new Slice(rs.getString("name"), rs.getBigDecimal("value")));
                }
            }
        }
        return slices;
    }

    /**
     * Mã xưởng (shops.shop_id) của người dùng. Trả về -1 nếu người dùng chưa có xưởng.
     */
    public int findShopIdByUser(int userId) throws SQLException {
        final String sql = "SELECT shop_id FROM shops WHERE user_id = ? AND status = 'ACTIVE' LIMIT 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("shop_id") : -1;
            }
        }
    }

    /** Tham số: 1-2 = khoảng completed_at, 3-4 = bộ lọc shop_id. */
    private static void bindRange(PreparedStatement ps, LocalDate from, LocalDate toExclusive, int shopId)
            throws SQLException {
        ps.setTimestamp(1, Timestamp.valueOf(from.atStartOfDay()));
        ps.setTimestamp(2, Timestamp.valueOf(toExclusive.atStartOfDay()));
        ps.setInt(3, shopId);
        ps.setInt(4, shopId);
    }

    /** Giống bindRange nhưng khoảng theo created_at (cùng thứ tự tham số). */
    private static void bindCreatedRange(PreparedStatement ps, LocalDate from, LocalDate toExclusive,
                                         int shopId) throws SQLException {
        bindRange(ps, from, toExclusive, shopId);
    }
}
