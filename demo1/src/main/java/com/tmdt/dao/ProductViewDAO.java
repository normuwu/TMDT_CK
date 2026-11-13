package com.tmdt.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;

import static com.tmdt.util.DBConnection.getConnection;

/**
 * Ghi nhận lượt xem sản phẩm để tính "category affinity" cho trang gợi ý.
 * Người đã đăng nhập lưu theo user_id; khách lưu theo session_id.
 *
 * Lỗi ghi log KHÔNG được làm hỏng trang chi tiết: nơi gọi bọc try/catch.
 */
public class ProductViewDAO {

    private static final String INSERT_VIEW =
            "INSERT INTO product_views (user_id, session_id, product_id) VALUES (?, ?, ?)";

    public void record(Integer userId, String sessionId, int productId) throws SQLException {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_VIEW)) {
            if (userId == null) {
                ps.setNull(1, Types.INTEGER);
            } else {
                ps.setInt(1, userId);
            }
            ps.setString(2, sessionId);
            ps.setInt(3, productId);
            ps.executeUpdate();
        }
    }

    /** Dọn log cũ để bảng không phình (gọi tay hoặc đặt lịch định kỳ). */
    public int purgeOlderThan(int days) throws SQLException {
        final String sql = "DELETE FROM product_views WHERE viewed_at < NOW() - INTERVAL ? DAY";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, days);
            return ps.executeUpdate();
        }
    }
}
