package com.tmdt.service;

import com.tmdt.dao.CatalogDAO;
import com.tmdt.dao.ProductDAO;
import com.tmdt.model.FilterOption;
import com.tmdt.model.PageResult;
import com.tmdt.model.Product;
import com.tmdt.model.ProductFilter;

import java.sql.SQLException;
import java.util.List;

/** Nghiệp vụ trang sản phẩm. Lỗi DB được gói thành IllegalStateException để servlet xử lý một chỗ. */
public class ProductService {

    private final ProductDAO productDAO = new ProductDAO();
    private final CatalogDAO catalogDAO = new CatalogDAO();

    public PageResult<Product> search(ProductFilter filter) {
        try {
            return productDAO.search(filter);
        } catch (SQLException e) {
            throw new IllegalStateException("Không tải được danh sách sản phẩm", e);
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