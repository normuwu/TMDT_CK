package com.tmdt.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static com.tmdt.util.DBConnection.getConnection;

/**
 * Truy vấn sản phẩm cho trang Người bán (xưởng in).
 *
 * Mọi thao tác ghi đều kèm điều kiện supplier_id của xưởng đang đăng nhập, nên
 * người bán không thể sửa/xóa sản phẩm của xưởng khác dù có đoán product_id.
 * Dữ liệu lưu ở bảng products (không dùng localStorage).
 */
public class SellerProductDAO {

    private static final DateTimeFormatter UPDATED_FORMAT =
            DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    public record Shop(int supplierId, String shopName) {
    }

    public record Category(int categoryId, String name) {
    }

    public record Product(int productId, int categoryId, String categoryName, String name,
                          String slug, String shortDescription, String thumbnailUrl,
                          long price, int stockQuantity, int soldCount, String status,
                          String updatedAt) {
    }

    public record ProductStats(int total, int active, int hidden, int lowStock) {
    }

    /** Hồ sơ xưởng đang hoạt động của tài khoản; empty nếu chưa được duyệt làm NCC. */
    public Optional<Shop> findShop(int userId) throws SQLException {
        final String sql = "SELECT supplier_id, shop_name FROM supplier_profiles "
                + "WHERE user_id = ? AND status = 'ACTIVE' LIMIT 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next()
                        ? Optional.of(new Shop(rs.getInt("supplier_id"), rs.getString("shop_name")))
                        : Optional.empty();
            }
        }
    }

    /** Danh mục đang bán (kể cả danh mục con) để chọn khi tạo/sửa sản phẩm. */
    public List<Category> findCategories() throws SQLException {
        final String sql = "SELECT category_id, name FROM categories "
                + "WHERE is_active = TRUE ORDER BY name";
        List<Category> list = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Category(rs.getInt("category_id"), rs.getString("name")));
            }
        }
        return list;
    }

    /**
     * Một trang sản phẩm của xưởng (ACTIVE + HIDDEN), mới cập nhật trước.
     *
     * @param keyword tìm theo tên sản phẩm / danh mục (null hoặc rỗng = bỏ lọc)
     * @param status  ACTIVE / HIDDEN (null hoặc rỗng = tất cả)
     */
    public List<Product> findPage(int supplierId, String keyword, String status,
                                  int offset, int limit) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT p.product_id, p.category_id, c.name AS category_name, p.name, p.slug, "
                        + "p.short_description, p.thumbnail_url, p.price, p.stock_quantity, "
                        + "p.sold_count, p.status, p.updated_at "
                        + "FROM products p JOIN categories c ON c.category_id = p.category_id "
                        + "WHERE p.supplier_id = ?");
        appendFilters(sql, keyword, status);
        sql.append(" ORDER BY p.updated_at DESC, p.product_id DESC LIMIT ? OFFSET ?");

        List<Product> list = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = bindFilters(ps, supplierId, keyword, status);
            ps.setInt(index++, limit);
            ps.setInt(index, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    /** Tổng số sản phẩm khớp bộ lọc (để tính số trang). */
    public int count(int supplierId, String keyword, String status) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM products p "
                        + "JOIN categories c ON c.category_id = p.category_id "
                        + "WHERE p.supplier_id = ?");
        appendFilters(sql, keyword, status);
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            bindFilters(ps, supplierId, keyword, status);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /** Số liệu tổng quan của toàn bộ sản phẩm xưởng (không phụ thuộc bộ lọc). */
    public ProductStats stats(int supplierId) throws SQLException {
        final String sql = "SELECT COUNT(*) AS total, "
                + "COALESCE(SUM(status = 'ACTIVE'), 0) AS active, "
                + "COALESCE(SUM(status = 'HIDDEN'), 0) AS hidden, "
                + "COALESCE(SUM(status = 'ACTIVE' AND stock_quantity <= 5), 0) AS low_stock "
                + "FROM products WHERE supplier_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return new ProductStats(0, 0, 0, 0);
                }
                return new ProductStats(rs.getInt("total"), rs.getInt("active"),
                        rs.getInt("hidden"), rs.getInt("low_stock"));
            }
        }
    }

    /** Sản phẩm thuộc đúng xưởng (dùng để kiểm tra quyền trước khi sửa). */
    public Optional<Product> findOwned(int supplierId, int productId) throws SQLException {
        final String sql = "SELECT p.product_id, p.category_id, c.name AS category_name, p.name, p.slug, "
                + "p.short_description, p.thumbnail_url, p.price, p.stock_quantity, "
                + "p.sold_count, p.status, p.updated_at "
                + "FROM products p JOIN categories c ON c.category_id = p.category_id "
                + "WHERE p.product_id = ? AND p.supplier_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, supplierId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    public boolean categoryExists(int categoryId) throws SQLException {
        final String sql = "SELECT 1 FROM categories WHERE category_id = ? AND is_active = TRUE";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean slugExists(String slug) throws SQLException {
        final String sql = "SELECT 1 FROM products WHERE slug = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, slug);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /** Gợi ý slug chưa trùng: ten-san-pham, ten-san-pham-2, ... */
    public String uniqueSlug(String name) throws SQLException {
        String base = AdminSupplierRequestDAO.slugify(name);
        if (base.length() > 200) {
            base = base.substring(0, 200);
        }
        String candidate = base;
        int suffix = 2;
        while (slugExists(candidate)) {
            candidate = base + "-" + suffix;
            suffix++;
        }
        return candidate;
    }

    public int create(int supplierId, int categoryId, String name, String slug,
                      String shortDescription, String thumbnailUrl, long price, int stock)
            throws SQLException {
        final String sql = "INSERT INTO products "
                + "(supplier_id, category_id, name, slug, short_description, thumbnail_url, "
                + "price, stock_quantity, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'ACTIVE')";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, supplierId);
            ps.setInt(2, categoryId);
            ps.setString(3, name);
            ps.setString(4, slug);
            setNullable(ps, 5, shortDescription);
            setNullable(ps, 6, thumbnailUrl);
            ps.setLong(7, price);
            ps.setInt(8, stock);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : -1;
            }
        }
    }

    /** Cập nhật nội dung; slug giữ nguyên để link cũ không bị chết. */
    public boolean update(int supplierId, int productId, int categoryId, String name,
                          String shortDescription, String thumbnailUrl, long price, int stock)
            throws SQLException {
        final String sql = "UPDATE products SET category_id = ?, name = ?, short_description = ?, "
                + "thumbnail_url = ?, price = ?, stock_quantity = ? "
                + "WHERE product_id = ? AND supplier_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setString(2, name);
            setNullable(ps, 3, shortDescription);
            setNullable(ps, 4, thumbnailUrl);
            ps.setLong(5, price);
            ps.setInt(6, stock);
            ps.setInt(7, productId);
            ps.setInt(8, supplierId);
            return ps.executeUpdate() == 1;
        }
    }

    /** Ẩn/hiện sản phẩm (không xóa cứng vì order_items còn tham chiếu). */
    public boolean setStatus(int supplierId, int productId, String status) throws SQLException {
        final String sql = "UPDATE products SET status = ? "
                + "WHERE product_id = ? AND supplier_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, productId);
            ps.setInt(3, supplierId);
            return ps.executeUpdate() == 1;
        }
    }

    // ------------------------------------------------------------------

    private static Product map(ResultSet rs) throws SQLException {
        Timestamp updated = rs.getTimestamp("updated_at");
        String updatedAt = updated == null ? "" : UPDATED_FORMAT.format(updated.toLocalDateTime());
        return new Product(
                rs.getInt("product_id"),
                rs.getInt("category_id"),
                rs.getString("category_name"),
                rs.getString("name"),
                rs.getString("slug"),
                rs.getString("short_description"),
                rs.getString("thumbnail_url"),
                rs.getLong("price"),
                rs.getInt("stock_quantity"),
                rs.getInt("sold_count"),
                rs.getString("status"),
                updatedAt);
    }

    private static void appendFilters(StringBuilder sql, String keyword, String status) {
        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (p.name LIKE ? OR c.name LIKE ?)");
        }
        if ("ACTIVE".equals(status) || "HIDDEN".equals(status)) {
            sql.append(" AND p.status = ?");
        }
    }

    private static int bindFilters(PreparedStatement ps, int supplierId, String keyword,
                                   String status) throws SQLException {
        int index = 1;
        ps.setInt(index++, supplierId);
        if (keyword != null && !keyword.isBlank()) {
            String like = "%" + escapeLike(keyword.trim()) + "%";
            ps.setString(index++, like);
            ps.setString(index++, like);
        }
        if ("ACTIVE".equals(status) || "HIDDEN".equals(status)) {
            ps.setString(index++, status);
        }
        return index;
    }

    private static void setNullable(PreparedStatement ps, int index, String value)
            throws SQLException {
        if (value == null || value.isBlank()) {
            ps.setNull(index, java.sql.Types.VARCHAR);
        } else {
            ps.setString(index, value);
        }
    }

    private static String escapeLike(String s) {
        return s.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
    }
}
