package com.tmdt.dao;

import com.tmdt.model.Promotion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Locale;
import java.util.Optional;

import static com.tmdt.util.DBConnection.getConnection;

/**
 * Pure JDBC cho bảng promotions (đã có sẵn trong schema tmdt).
 *
 * Đọc ngoài transaction: tự lấy connection từ pool.
 * Đọc/ghi trong lúc đặt hàng: nhận Connection của OrderService để khóa dòng mã
 * (SELECT ... FOR UPDATE) và tăng lượt dùng cùng một transaction.
 */
public class PromotionDAO {

    private static final String COLUMNS =
            "promotion_id, shop_id, code, promotion_name, discount_type, discount_value, "
                    + "max_discount_amount, min_order_value, usage_limit, used_count, "
                    + "start_date, end_date, is_active";

    /** Mã khuyến mãi theo code (không phân biệt hoa thường — DB dùng collation *_ci). */
    public Optional<Promotion> findByCode(String rawCode) throws SQLException {
        try (Connection conn = getConnection()) {
            return findByCode(conn, rawCode, false);
        }
    }

    /**
     * @param forUpdate true khi gọi trong transaction đặt hàng: khóa dòng mã để
     *                  hai đơn đồng thời không cùng vượt usage_limit.
     */
    public Optional<Promotion> findByCode(Connection conn, String rawCode, boolean forUpdate)
            throws SQLException {
        String code = normalizeCode(rawCode);
        if (code.isEmpty()) return Optional.empty();

        String sql = "SELECT " + COLUMNS + " FROM promotions WHERE code = ?"
                + (forUpdate ? " FOR UPDATE" : "");
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(mapRow(rs)) : Optional.empty();
            }
        }
    }

    /**
     * Tăng used_count đúng 1 lượt, chỉ khi còn lượt.
     * Câu UPDATE có điều kiện nên an toàn khi nhiều đơn đặt cùng lúc.
     *
     * @return true nếu đã tăng được (mã còn lượt), false nếu đã hết lượt
     */
    public boolean incrementUsedCount(Connection conn, int promotionId) throws SQLException {
        final String sql = "UPDATE promotions SET used_count = used_count + 1 "
                + "WHERE promotion_id = ? AND is_active = 1 "
                + "AND (usage_limit IS NULL OR used_count < usage_limit)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, promotionId);
            return ps.executeUpdate() == 1;
        }
    }

    /** Chuẩn hóa mã người dùng nhập: bỏ khoảng trắng, viết hoa. */
    public static String normalizeCode(String rawCode) {
        return rawCode == null ? "" : rawCode.trim().toUpperCase(Locale.ROOT);
    }

    private Promotion mapRow(ResultSet rs) throws SQLException {
        Promotion p = new Promotion();
        p.setPromotionId(rs.getInt("promotion_id"));
        int shopId = rs.getInt("shop_id");
        p.setShopId(rs.wasNull() ? null : shopId);
        p.setCode(rs.getString("code"));
        p.setName(rs.getString("promotion_name"));
        p.setDiscountType(rs.getString("discount_type"));
        p.setDiscountValue(rs.getBigDecimal("discount_value"));
        p.setMaxDiscountAmount(rs.getBigDecimal("max_discount_amount"));
        p.setMinOrderValue(rs.getBigDecimal("min_order_value"));
        int usageLimit = rs.getInt("usage_limit");
        p.setUsageLimit(rs.wasNull() ? null : usageLimit);
        p.setUsedCount(rs.getInt("used_count"));
        Timestamp start = rs.getTimestamp("start_date");
        if (start != null) p.setStartDate(start.toLocalDateTime());
        Timestamp end = rs.getTimestamp("end_date");
        if (end != null) p.setEndDate(end.toLocalDateTime());
        p.setActive(rs.getBoolean("is_active"));
        return p;
    }
}
