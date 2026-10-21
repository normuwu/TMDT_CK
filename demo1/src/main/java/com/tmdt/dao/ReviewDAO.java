package com.tmdt.dao;

import com.tmdt.model.Review;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static com.tmdt.util.DBConnection.getConnection;

/**
 * Pure JDBC cho product_reviews và supplier_reviews.
 * Đọc: tự lấy connection. Ghi: nhận Connection của service (service giữ commit/rollback).
 */
public class ReviewDAO {

    // ---------------------------------------------------------------------
    // Đọc
    // ---------------------------------------------------------------------

    public List<Review> findProductReviews(int productId, int limit) throws SQLException {
        return findReviews("SELECT r.review_id, r.user_id, u.full_name, r.rating, r.comment, r.created_at "
                + "FROM product_reviews r JOIN users u ON u.user_id = r.user_id "
                + "WHERE r.product_id = ? AND r.status = 'VISIBLE' "
                + "ORDER BY r.created_at DESC, r.review_id DESC LIMIT ?", productId, limit);
    }

    public List<Review> findSupplierReviews(int supplierId, int limit) throws SQLException {
        return findReviews("SELECT r.review_id, r.user_id, u.full_name, r.rating, r.comment, r.created_at "
                + "FROM supplier_reviews r JOIN users u ON u.user_id = r.user_id "
                + "WHERE r.supplier_id = ? AND r.status = 'VISIBLE' "
                + "ORDER BY r.created_at DESC, r.review_id DESC LIMIT ?", supplierId, limit);
    }

    private List<Review> findReviews(String sql, int id, int limit) throws SQLException {
        List<Review> list = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review r = new Review();
                    r.setReviewId(rs.getInt("review_id"));
                    r.setUserId(rs.getInt("user_id"));
                    r.setUserName(rs.getString("full_name"));
                    r.setRating(rs.getInt("rating"));
                    r.setComment(rs.getString("comment"));
                    r.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    list.add(r);
                }
            }
        }
        return list;
    }

    // ---------------------------------------------------------------------
    // Kiểm tra tồn tại + chủ sở hữu (transaction-aware)
    // ---------------------------------------------------------------------

    /** user_id của chủ nhà cung cấp bán sản phẩm này; empty nếu sản phẩm không tồn tại / đang ẩn. */
    public Optional<Integer> findProductOwnerUserId(Connection conn, int productId) throws SQLException {
        return firstInt(conn, "SELECT s.user_id FROM products p "
                + "JOIN supplier_profiles s ON s.supplier_id = p.supplier_id "
                + "WHERE p.product_id = ? AND p.status = 'ACTIVE' AND s.status = 'ACTIVE'", productId);
    }

    /** user_id của chủ nhà cung cấp; empty nếu nhà cung cấp không tồn tại / đang ẩn. */
    public Optional<Integer> findSupplierOwnerUserId(Connection conn, int supplierId) throws SQLException {
        return firstInt(conn, "SELECT user_id FROM supplier_profiles WHERE supplier_id = ? AND status = 'ACTIVE'",
                supplierId);
    }

    private Optional<Integer> firstInt(Connection conn, String sql, int id) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(rs.getInt(1)) : Optional.empty();
            }
        }
    }

    // ---------------------------------------------------------------------
    // Ghi (transaction-aware). Mỗi người một đánh giá / đối tượng: gửi lại = cập nhật.
    // ---------------------------------------------------------------------

    public void upsertProductReview(Connection conn, int productId, int userId, int rating, String comment)
            throws SQLException {
        final String sql = "INSERT INTO product_reviews (product_id, user_id, rating, comment, status) "
                + "VALUES (?, ?, ?, ?, 'VISIBLE') "
                + "ON DUPLICATE KEY UPDATE rating = VALUES(rating), comment = VALUES(comment)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, userId);
            ps.setInt(3, rating);
            ps.setString(4, comment);
            ps.executeUpdate();
        }
    }

    public void upsertSupplierReview(Connection conn, int supplierId, int userId, int rating, String comment)
            throws SQLException {
        final String sql = "INSERT INTO supplier_reviews (supplier_id, user_id, rating, comment, status) "
                + "VALUES (?, ?, ?, ?, 'VISIBLE') "
                + "ON DUPLICATE KEY UPDATE rating = VALUES(rating), comment = VALUES(comment)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            ps.setInt(2, userId);
            ps.setInt(3, rating);
            ps.setString(4, comment);
            ps.executeUpdate();
        }
    }

    /** Tính lại avg_rating / review_count của sản phẩm từ các đánh giá đang hiển thị. */
    public void recalcProductRating(Connection conn, int productId) throws SQLException {
        final String sql = "UPDATE products p SET "
                + "p.avg_rating = COALESCE((SELECT ROUND(AVG(r.rating), 2) FROM product_reviews r "
                + "WHERE r.product_id = p.product_id AND r.status = 'VISIBLE'), 0), "
                + "p.review_count = (SELECT COUNT(*) FROM product_reviews r "
                + "WHERE r.product_id = p.product_id AND r.status = 'VISIBLE') "
                + "WHERE p.product_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.executeUpdate();
        }
    }

    /** Tính lại avg_rating / review_count của nhà cung cấp. */
    public void recalcSupplierRating(Connection conn, int supplierId) throws SQLException {
        final String sql = "UPDATE supplier_profiles s SET "
                + "s.avg_rating = COALESCE((SELECT ROUND(AVG(r.rating), 2) FROM supplier_reviews r "
                + "WHERE r.supplier_id = s.supplier_id AND r.status = 'VISIBLE'), 0), "
                + "s.review_count = (SELECT COUNT(*) FROM supplier_reviews r "
                + "WHERE r.supplier_id = s.supplier_id AND r.status = 'VISIBLE') "
                + "WHERE s.supplier_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            ps.executeUpdate();
        }
    }
}