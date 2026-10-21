package com.tmdt.dao;

import com.tmdt.model.ProductAttribute;
import com.tmdt.model.ProductDetail;
import com.tmdt.model.ProductImage;
import com.tmdt.model.ProductMaterial;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static com.tmdt.util.DBConnection.getConnection;

/** Pure JDBC: lấy một sản phẩm đầy đủ (kèm vật liệu + giá, ảnh, thông số) cho trang chi tiết. */
public class ProductDetailDAO {

    private static final String SQL =
            "SELECT p.product_id, p.supplier_id, s.shop_name, s.avg_rating AS supplier_rating, "
                    + "s.review_count AS supplier_review_count, s.address AS supplier_address, "
                    + "p.category_id, c.name AS category_name, p.name, p.slug, p.short_description, "
                    + "p.description, p.thumbnail_url, p.price, p.stock_quantity, p.sold_count, "
                    + "p.avg_rating, p.review_count, p.created_at "
                    + "FROM products p "
                    + "JOIN supplier_profiles s ON s.supplier_id = p.supplier_id "
                    + "JOIN categories c ON c.category_id = p.category_id "
                    + "WHERE p.product_id = ? AND p.status = 'ACTIVE' AND s.status = 'ACTIVE'";

    /** Empty khi không có sản phẩm, hoặc sản phẩm / nhà cung cấp đang bị ẩn. */
    public Optional<ProductDetail> findById(int productId) throws SQLException {
        try (Connection conn = getConnection()) {
            ProductDetail d;
            try (PreparedStatement ps = conn.prepareStatement(SQL)) {
                ps.setInt(1, productId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) return Optional.empty();
                    d = mapRow(rs);
                }
            }
            d.setMaterials(loadMaterials(conn, productId));
            d.setImages(loadImages(conn, productId));
            d.setAttributes(loadAttributes(conn, productId));

            List<String> names = new ArrayList<>();
            for (ProductMaterial m : d.getMaterials()) names.add(m.getName());
            d.setMaterialNames(names);

            // Chưa có ảnh trong product_images thì dùng ảnh đại diện làm ảnh duy nhất.
            if (d.getImages().isEmpty() && d.getThumbnailUrl() != null && !d.getThumbnailUrl().isBlank()) {
                d.getImages().add(new ProductImage(d.getThumbnailUrl(), true));
            }
            return Optional.of(d);
        }
    }

    private ProductDetail mapRow(ResultSet rs) throws SQLException {
        ProductDetail d = new ProductDetail();
        d.setProductId(rs.getInt("product_id"));
        d.setSupplierId(rs.getInt("supplier_id"));
        d.setSupplierName(rs.getString("shop_name"));
        d.setSupplierAvgRating(rs.getDouble("supplier_rating"));
        d.setSupplierReviewCount(rs.getInt("supplier_review_count"));
        d.setSupplierAddress(rs.getString("supplier_address"));
        d.setCategoryId(rs.getInt("category_id"));
        d.setCategoryName(rs.getString("category_name"));
        d.setName(rs.getString("name"));
        d.setSlug(rs.getString("slug"));
        d.setShortDescription(rs.getString("short_description"));
        d.setDescription(rs.getString("description"));
        d.setThumbnailUrl(rs.getString("thumbnail_url"));
        d.setPrice(rs.getLong("price"));
        d.setStockQuantity(rs.getInt("stock_quantity"));
        d.setSoldCount(rs.getInt("sold_count"));
        d.setAvgRating(rs.getDouble("avg_rating"));
        d.setReviewCount(rs.getInt("review_count"));
        d.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        return d;
    }

    private List<ProductMaterial> loadMaterials(Connection conn, int productId) throws SQLException {
        final String sql = "SELECT m.material_id, m.name, pm.price FROM product_materials pm "
                + "JOIN materials m ON m.material_id = pm.material_id "
                + "WHERE pm.product_id = ? AND m.is_active = TRUE ORDER BY pm.price, m.name";
        List<ProductMaterial> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new ProductMaterial(rs.getInt("material_id"), rs.getString("name"), rs.getLong("price")));
                }
            }
        }
        return list;
    }

    private List<ProductImage> loadImages(Connection conn, int productId) throws SQLException {
        final String sql = "SELECT image_url, is_primary FROM product_images WHERE product_id = ? "
                + "ORDER BY is_primary DESC, sort_order, image_id";
        List<ProductImage> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new ProductImage(rs.getString("image_url"), rs.getBoolean("is_primary")));
                }
            }
        }
        return list;
    }

    private List<ProductAttribute> loadAttributes(Connection conn, int productId) throws SQLException {
        final String sql = "SELECT attr_name, attr_value FROM product_attributes WHERE product_id = ? "
                + "ORDER BY sort_order, attribute_id";
        List<ProductAttribute> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new ProductAttribute(rs.getString("attr_name"), rs.getString("attr_value")));
                }
            }
        }
        return list;
    }
}