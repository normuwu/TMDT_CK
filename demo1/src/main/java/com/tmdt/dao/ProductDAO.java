package com.tmdt.dao;

import com.tmdt.model.CartProduct;
import com.tmdt.model.PageResult;
import com.tmdt.model.Product;
import com.tmdt.model.ProductFilter;
import com.tmdt.model.ProductMaterial;
import com.tmdt.model.ProductSort;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static com.tmdt.util.DBConnection.getConnection;

/**
 * Pure JDBC cho danh sách sản phẩm: lọc + sắp xếp + phân trang.
 * Giá trị người dùng luôn đi qua PreparedStatement; phần ORDER BY chỉ lấy
 * từ enum ProductSort (không bao giờ ghép chuỗi người dùng vào SQL).
 */
public class ProductDAO {

    private static final String SELECT_COLUMNS =
            "SELECT p.product_id, p.supplier_id, s.shop_name, p.category_id, c.name AS category_name, "
                    + "p.name, p.slug, p.short_description, p.thumbnail_url, "
                    + "p.sold_count, p.avg_rating, p.review_count, p.created_at, ";

    /** Tìm sản phẩm ACTIVE theo bộ lọc. Trang vượt quá tổng số trang sẽ được kéo về trang cuối. */
    public PageResult<Product> search(ProductFilter f) throws SQLException {
        try (Connection conn = getConnection()) {
            List<Object> params = new ArrayList<>();
            String fromWhere = buildFromWhere(f, params);

            long total = count(conn, fromWhere, params);
            int pageSize = f.getPageSize();
            int totalPages = (int) Math.max(1, (total + pageSize - 1) / pageSize);
            int page = Math.min(Math.max(1, f.getPage()), totalPages);

            String priceExpr = priceExpr(f);
            String sql = SELECT_COLUMNS + priceExpr + " AS display_price" + fromWhere
                    + " ORDER BY " + orderBy(f.getSort(), priceExpr)
                    + " LIMIT ? OFFSET ?";

            List<Object> listParams = new ArrayList<>(params);
            listParams.add(pageSize);
            listParams.add((page - 1) * pageSize);

            List<Product> products = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                bind(ps, listParams);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        products.add(mapRow(rs));
                    }
                }
            }
            loadMaterialNames(conn, products);
            return new PageResult<>(products, page, pageSize, total);
        }
    }

    // ---------------------------------------------------------------------
    // SQL building
    // ---------------------------------------------------------------------

    /** Khi đang lọc theo vật liệu thì giá = giá của vật liệu đó, ngược lại = "giá từ". */
    private static String priceExpr(ProductFilter f) {
        return f.getMaterialId() != null ? "pm.price" : "p.price";
    }

    private static String buildFromWhere(ProductFilter f, List<Object> params) {
        StringBuilder sb = new StringBuilder(
                " FROM products p"
                        + " JOIN supplier_profiles s ON s.supplier_id = p.supplier_id"
                        + " JOIN categories c ON c.category_id = p.category_id");

        // Tham số của JOIN phải được thêm TRƯỚC tham số của WHERE.
        if (f.getMaterialId() != null) {
            sb.append(" JOIN product_materials pm ON pm.product_id = p.product_id AND pm.material_id = ?");
            params.add(f.getMaterialId());
        }

        sb.append(" WHERE p.status = 'ACTIVE' AND s.status = 'ACTIVE' AND c.is_active = TRUE");

        if (f.getKeyword() != null && !f.getKeyword().isBlank()) {
            String like = "%" + escapeLike(f.getKeyword().trim()) + "%";
            sb.append(" AND (p.name LIKE ? OR p.short_description LIKE ?)");
            params.add(like);
            params.add(like);
        }
        if (f.getCategoryId() != null) {
            // Gồm cả danh mục con của danh mục được chọn.
            sb.append(" AND (p.category_id = ? OR c.parent_id = ?)");
            params.add(f.getCategoryId());
            params.add(f.getCategoryId());
        }
        if (f.getSupplierId() != null) {
            sb.append(" AND p.supplier_id = ?");
            params.add(f.getSupplierId());
        }
        String priceExpr = priceExpr(f);
        if (f.getMinPrice() != null) {
            sb.append(" AND ").append(priceExpr).append(" >= ?");
            params.add(f.getMinPrice());
        }
        if (f.getMaxPrice() != null) {
            sb.append(" AND ").append(priceExpr).append(" <= ?");
            params.add(f.getMaxPrice());
        }
        return sb.toString();
    }

    private static String orderBy(ProductSort sort, String priceExpr) {
        return switch (sort) {
            case PRICE_ASC -> priceExpr + " ASC, p.product_id DESC";
            case PRICE_DESC -> priceExpr + " DESC, p.product_id DESC";
            case NAME_ASC -> "p.name ASC, p.product_id DESC";
            case NAME_DESC -> "p.name DESC, p.product_id DESC";
            case BEST_SELLING -> "p.sold_count DESC, p.product_id DESC";
            case NEWEST -> "p.created_at DESC, p.product_id DESC";
        };
    }

    /** Escape ký tự đặc biệt của LIKE (\ % _) để từ khóa được hiểu theo nghĩa đen. */
    private static String escapeLike(String s) {
        return s.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
    }

    private static void bind(PreparedStatement ps, List<Object> params) throws SQLException {
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
    }

    private long count(Connection conn, String fromWhere, List<Object> params) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*)" + fromWhere)) {
            bind(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong(1) : 0;
            }
        }
    }

    // ---------------------------------------------------------------------
    // Mapping
    // ---------------------------------------------------------------------

    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductId(rs.getInt("product_id"));
        p.setSupplierId(rs.getInt("supplier_id"));
        p.setSupplierName(rs.getString("shop_name"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setCategoryName(rs.getString("category_name"));
        p.setName(rs.getString("name"));
        p.setSlug(rs.getString("slug"));
        p.setShortDescription(rs.getString("short_description"));
        p.setThumbnailUrl(rs.getString("thumbnail_url"));
        p.setPrice(rs.getLong("display_price"));
        p.setSoldCount(rs.getInt("sold_count"));
        p.setAvgRating(rs.getDouble("avg_rating"));
        p.setReviewCount(rs.getInt("review_count"));
        p.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        return p;
    }

    // ---------------------------------------------------------------------
    // Giỏ hàng / đặt hàng
    // ---------------------------------------------------------------------

    private static final String CART_PRODUCT_COLUMNS =
            "SELECT p.product_id, p.supplier_id, s.shop_name, p.name, p.thumbnail_url, "
                    + "p.price, p.stock_quantity "
                    + "FROM products p JOIN supplier_profiles s ON s.supplier_id = p.supplier_id "
                    + "WHERE p.product_id = ? AND p.status = 'ACTIVE' AND s.status = 'ACTIVE'";

    /** Sản phẩm đang bán (giá + tồn kho) để thêm vào giỏ; empty nếu ẩn/không tồn tại. */
    public Optional<CartProduct> findCartProduct(int productId) throws SQLException {
        try (Connection conn = getConnection()) {
            return findCartProduct(conn, productId, false);
        }
    }

    /**
     * Bản dùng trong transaction đặt hàng: forUpdate=true sẽ khóa dòng sản phẩm
     * (SELECT ... FOR UPDATE) để hai đơn đồng thời không mua vượt tồn kho.
     */
    public Optional<CartProduct> findCartProduct(Connection conn, int productId, boolean forUpdate)
            throws SQLException {
        String sql = CART_PRODUCT_COLUMNS + (forUpdate ? " FOR UPDATE" : "");
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(mapCartProduct(rs)) : Optional.empty();
            }
        }
    }

    /** Khóa toàn bộ sản phẩm trong giỏ bằng một truy vấn (thứ tự id tăng dần, tránh deadlock). */
    public List<CartProduct> findCartProductsForUpdate(Connection conn, Collection<Integer> productIds)
            throws SQLException {
        if (productIds == null || productIds.isEmpty()) return List.of();

        List<Integer> ids = new ArrayList<>(productIds);
        Collections.sort(ids);
        String placeholders = String.join(",", Collections.nCopies(ids.size(), "?"));
        String sql = "SELECT p.product_id, p.supplier_id, s.shop_name, p.name, p.thumbnail_url, "
                + "p.price, p.stock_quantity "
                + "FROM products p JOIN supplier_profiles s ON s.supplier_id = p.supplier_id "
                + "WHERE p.product_id IN (" + placeholders + ")"
                + " AND p.status = 'ACTIVE' AND s.status = 'ACTIVE' ORDER BY p.product_id FOR UPDATE";

        List<CartProduct> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < ids.size(); i++) {
                ps.setInt(i + 1, ids.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapCartProduct(rs));
                }
            }
        }
        return list;
    }

    /** Giá của một vật liệu thuộc sản phẩm; empty nếu vật liệu không gắn với sản phẩm/đang ẩn. */
    public Optional<ProductMaterial> findMaterial(int productId, int materialId) throws SQLException {
        try (Connection conn = getConnection()) {
            return findMaterial(conn, productId, materialId, false);
        }
    }

    public Optional<ProductMaterial> findMaterial(Connection conn, int productId, int materialId,
                                                  boolean forUpdate) throws SQLException {
        String sql = "SELECT m.material_id, m.name, pm.price FROM product_materials pm "
                + "JOIN materials m ON m.material_id = pm.material_id "
                + "WHERE pm.product_id = ? AND pm.material_id = ? AND m.is_active = TRUE"
                + (forUpdate ? " FOR UPDATE" : "");
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, materialId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return Optional.empty();
                return Optional.of(new ProductMaterial(rs.getInt("material_id"),
                        rs.getString("name"), rs.getLong("price")));
            }
        }
    }

    /**
     * Trừ tồn kho an toàn trong transaction: chỉ cập nhật khi còn đủ hàng.
     * @return true nếu đã trừ được đúng 1 dòng (đủ tồn kho)
     */
    public boolean decreaseStock(Connection conn, int productId, int quantity) throws SQLException {
        final String sql = "UPDATE products SET stock_quantity = stock_quantity - ?, "
                + "sold_count = sold_count + ? "
                + "WHERE product_id = ? AND stock_quantity >= ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, quantity);
            ps.setInt(3, productId);
            ps.setInt(4, quantity);
            return ps.executeUpdate() == 1;
        }
    }

    private CartProduct mapCartProduct(ResultSet rs) throws SQLException {
        return new CartProduct(
                rs.getInt("product_id"),
                rs.getInt("supplier_id"),
                rs.getString("shop_name"),
                rs.getString("name"),
                rs.getString("thumbnail_url"),
                rs.getLong("price"),
                rs.getInt("stock_quantity"));
    }

    /** Một truy vấn cho cả trang: lấy tên các vật liệu của những sản phẩm vừa tìm được. */
    private void loadMaterialNames(Connection conn, List<Product> products) throws SQLException {
        if (products.isEmpty()) return;

        Map<Integer, Product> byId = new LinkedHashMap<>();
        for (Product p : products) byId.put(p.getProductId(), p);

        String placeholders = String.join(",", Collections.nCopies(byId.size(), "?"));
        String sql = "SELECT pm.product_id, m.name FROM product_materials pm "
                + "JOIN materials m ON m.material_id = pm.material_id "
                + "WHERE m.is_active = TRUE AND pm.product_id IN (" + placeholders + ") "
                + "ORDER BY m.name";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            int i = 1;
            for (Integer id : byId.keySet()) ps.setInt(i++, id);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = byId.get(rs.getInt("product_id"));
                    if (p != null) p.getMaterialNames().add(rs.getString("name"));
                }
            }
        }
    }
}