package com.tmdt.service;

import com.tmdt.dao.ProductDetailDAO;
import com.tmdt.dao.ReviewDAO;
import com.tmdt.model.ProductDetail;

import java.sql.SQLException;
import java.util.Optional;

/** Nghiệp vụ trang chi tiết: lấy sản phẩm + đánh giá gần nhất. Lỗi DB -> IllegalStateException. */
public class ProductDetailService {

    private static final int REVIEW_LIMIT = 20;

    private final ProductDetailDAO detailDAO = new ProductDetailDAO();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    public Optional<ProductDetail> find(int productId) {
        try {
            Optional<ProductDetail> opt = detailDAO.findById(productId);
            if (opt.isPresent()) {
                ProductDetail d = opt.get();
                d.setProductReviews(reviewDAO.findProductReviews(productId, REVIEW_LIMIT));
                d.setSupplierReviews(reviewDAO.findSupplierReviews(d.getSupplierId(), REVIEW_LIMIT));
            }
            return opt;
        } catch (SQLException e) {
            throw new IllegalStateException("Không tải được chi tiết sản phẩm", e);
        }
    }
}