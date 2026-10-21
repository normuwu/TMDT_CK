package com.tmdt.service;

import com.tmdt.dao.ReviewDAO;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import static com.tmdt.util.DBConnection.getConnection;

/**
 * Gửi đánh giá sản phẩm / nhà cung cấp. Mỗi người một đánh giá cho mỗi đối tượng
 * (gửi lại = cập nhật). Chủ cửa hàng không được tự đánh giá. Ghi đánh giá và tính lại
 * điểm trung bình nằm trong CÙNG một transaction.
 */
public class ReviewService {

    public record Outcome(boolean success, String message) {
        static Outcome ok(String m) { return new Outcome(true, m); }
        static Outcome fail(String m) { return new Outcome(false, m); }
    }

    public static final String MSG_PRODUCT_OK = "Cảm ơn bạn đã đánh giá sản phẩm!";
    public static final String MSG_SUPPLIER_OK = "Cảm ơn bạn đã đánh giá nhà cung cấp!";

    private static final Logger LOG = Logger.getLogger(ReviewService.class.getName());
    private static final int MIN_COMMENT = 5;
    private static final int MAX_COMMENT = 1000;
    private static final String MSG_SYSTEM = "Không gửi được đánh giá, vui lòng thử lại sau.";

    private final ReviewDAO reviewDAO = new ReviewDAO();

    public Outcome reviewProduct(int userId, int productId, String ratingRaw, String commentRaw) {
        String err = validate(ratingRaw, commentRaw);
        if (err != null) return Outcome.fail(err);
        int rating = Integer.parseInt(ratingRaw.trim());
        String comment = commentRaw.trim();

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try {
                Optional<Integer> owner = reviewDAO.findProductOwnerUserId(conn, productId);
                if (owner.isEmpty()) {
                    conn.rollback();
                    return Outcome.fail("Sản phẩm không tồn tại hoặc đã ngừng bán.");
                }
                if (owner.get() == userId) {
                    conn.rollback();
                    return Outcome.fail("Bạn không thể đánh giá sản phẩm của chính mình.");
                }
                reviewDAO.upsertProductReview(conn, productId, userId, rating, comment);
                reviewDAO.recalcProductRating(conn, productId);
                conn.commit();
                return Outcome.ok(MSG_PRODUCT_OK);
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            LOG.log(Level.SEVERE, "Lỗi lưu đánh giá sản phẩm", e);
            return Outcome.fail(MSG_SYSTEM);
        }
    }

    public Outcome reviewSupplier(int userId, int supplierId, String ratingRaw, String commentRaw) {
        String err = validate(ratingRaw, commentRaw);
        if (err != null) return Outcome.fail(err);
        int rating = Integer.parseInt(ratingRaw.trim());
        String comment = commentRaw.trim();

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try {
                Optional<Integer> owner = reviewDAO.findSupplierOwnerUserId(conn, supplierId);
                if (owner.isEmpty()) {
                    conn.rollback();
                    return Outcome.fail("Nhà cung cấp không tồn tại hoặc đã ngừng hoạt động.");
                }
                if (owner.get() == userId) {
                    conn.rollback();
                    return Outcome.fail("Bạn không thể đánh giá cửa hàng của chính mình.");
                }
                reviewDAO.upsertSupplierReview(conn, supplierId, userId, rating, comment);
                reviewDAO.recalcSupplierRating(conn, supplierId);
                conn.commit();
                return Outcome.ok(MSG_SUPPLIER_OK);
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            LOG.log(Level.SEVERE, "Lỗi lưu đánh giá nhà cung cấp", e);
            return Outcome.fail(MSG_SYSTEM);
        }
    }

    /** null = hợp lệ, ngược lại là thông báo lỗi tiếng Việt. */
    private static String validate(String ratingRaw, String commentRaw) {
        int rating;
        try {
            rating = Integer.parseInt(ratingRaw == null ? "" : ratingRaw.trim());
        } catch (NumberFormatException e) {
            return "Vui lòng chọn số sao đánh giá.";
        }
        if (rating < 1 || rating > 5) return "Vui lòng chọn số sao từ 1 đến 5.";
        String comment = commentRaw == null ? "" : commentRaw.trim();
        if (comment.length() < MIN_COMMENT) return "Vui lòng nhập nhận xét (ít nhất " + MIN_COMMENT + " ký tự).";
        if (comment.length() > MAX_COMMENT) return "Nhận xét tối đa " + MAX_COMMENT + " ký tự.";
        return null;
    }
}