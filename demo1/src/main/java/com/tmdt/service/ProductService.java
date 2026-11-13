package com.tmdt.service;

import com.tmdt.dao.CatalogDAO;
import com.tmdt.dao.ProductDAO;
import com.tmdt.model.FilterOption;
import com.tmdt.model.PageResult;
import com.tmdt.model.Product;
import com.tmdt.model.ProductFilter;

import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ProductService {

    private final ProductDAO productDAO = new ProductDAO();
    private static final Logger LOG = Logger.getLogger(ProductService.class.getName());

    private final CatalogDAO catalogDAO = new CatalogDAO();

    public PageResult<Product> search(ProductFilter filter) {
        try {
            return productDAO.search(filter);
        } catch (SQLException e) {
            throw new IllegalStateException("Không tải được danh sách sản phẩm", e);
        }
    }

    /**
     * Sản phẩm gợi ý cho trang chi tiết. Người chưa đăng nhập hoặc chưa có hành vi
     * (cold start) nhận danh sách bán chạy, nên khối gợi ý luôn có nội dung.
     */
    public List<Product> recommendationsFor(Integer userId, Integer excludeProductId) {
        if (userId != null) {
            try {
                List<Product> personalized =
                        productDAO.findRecommendedForUser(userId, excludeProductId, 8);
                if (!personalized.isEmpty()) {
                    return personalized;
                }
            } catch (SQLException e) {
                // Ví dụ chưa chạy script tạo bảng product_views: vẫn còn fallback bên dưới.
                LOG.log(Level.WARNING, "Không tính được gợi ý cá nhân hoá cho user " + userId, e);
            }
        }
        try {
            return productDAO.findBestsellers(8);
        } catch (SQLException e) {
            throw new IllegalStateException("Không tải được sản phẩm gợi ý", e);
        }
    }

    public List<FilterOption> categories() {
        try {
            return catalogDAO.findActiveCategories();
        } catch (SQLException e) {
            throw new IllegalStateException("Không tải được danh mục", e);
        }
    }

    public List<FilterOption> materials() {
        try {
            return catalogDAO.findActiveMaterials();
        } catch (SQLException e) {
            throw new IllegalStateException("Không tải được vật liệu", e);
        }
    }

    public List<FilterOption> suppliers() {
        try {
            return catalogDAO.findActiveSuppliers();
        } catch (SQLException e) {
            throw new IllegalStateException("Không tải được nhà cung cấp", e);
        }
    }
}