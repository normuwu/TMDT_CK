package com.tmdt.servlet;

import com.tmdt.dao.SellerProductDAO;
import com.tmdt.model.Role;
import com.tmdt.model.SessionUser;
import com.tmdt.util.AuthUtil;
import com.tmdt.util.JsonUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

/**
 * API sản phẩm cho Người bán (xưởng in). Chỉ trả dữ liệu của xưởng thuộc tài
 * khoản đang đăng nhập; shop_id/supplier_id luôn lấy từ session + DB, không đọc
 * từ request.
 *
 *   GET  /nhacungcap/api/products?q=&status=&page=&size=
 *   POST /nhacungcap/api/products  action=create|update|status
 *
 * Request POST dùng application/x-www-form-urlencoded (kèm CSRF do CsrfFilter
 * kiểm tra như mọi POST khác của ứng dụng).
 */
@WebServlet(name = "SellerProductApiServlet", urlPatterns = "/nhacungcap/api/products")
public class SellerProductApiServlet extends HttpServlet {

    private static final Logger LOG = LoggerFactory.getLogger(SellerProductApiServlet.class);

    private static final int NAME_MAX = 200;
    private static final int SHORT_DESC_MAX = 500;
    private static final int URL_MAX = 500;
    private static final long PRICE_MAX = 999_999_999_999L;
    private static final int STOCK_MAX = 1_000_000;
    private static final int DEFAULT_PAGE_SIZE = 10;
    private static final int MAX_PAGE_SIZE = 50;

    private final SellerProductDAO dao = new SellerProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        SellerContext ctx = resolveContext(request, response);
        if (ctx == null) {
            return;
        }
        try {
            int supplierId = ctx.shop().supplierId();
            String keyword = request.getParameter("q");
            String status = parseStatusFilter(request.getParameter("status"));
            int size = clampSize(request.getParameter("size"));

            int total = dao.count(supplierId, keyword, status);
            int pages = total == 0 ? 0 : (total + size - 1) / size;
            int page = clampPage(request.getParameter("page"), pages);
            int offset = (page - 1) * size;

            List<SellerProductDAO.Product> products =
                    dao.findPage(supplierId, keyword, status, offset, size);
            SellerProductDAO.ProductStats stats = dao.stats(supplierId);

            JsonUtil.Arr items = new JsonUtil.Arr();
            for (SellerProductDAO.Product p : products) {
                items.add(new JsonUtil.Obj()
                        .putNumber("id", p.productId())
                        .putString("name", p.name())
                        .putString("slug", p.slug())
                        .putNumber("categoryId", p.categoryId())
                        .putString("categoryName", p.categoryName())
                        .putString("description", p.shortDescription())
                        .putString("thumbnail", p.thumbnailUrl())
                        .putNumber("price", p.price())
                        .putNumber("stock", p.stockQuantity())
                        .putNumber("sold", p.soldCount())
                        .putString("status", p.status())
                        .putString("updatedAt", p.updatedAt())
                        .end());
            }

            JsonUtil.Arr categories = new JsonUtil.Arr();
            for (SellerProductDAO.Category c : dao.findCategories()) {
                categories.add(new JsonUtil.Obj()
                        .putNumber("id", c.categoryId())
                        .putString("name", c.name())
                        .end());
            }

            String body = new JsonUtil.Obj()
                    .put("shop", new JsonUtil.Obj()
                            .putNumber("supplierId", supplierId)
                            .putString("shopName", ctx.shop().shopName())
                            .end())
                    .put("categories", categories.end())
                    .put("products", items.end())
                    .putNumber("page", page)
                    .putNumber("size", size)
                    .putNumber("pages", pages)
                    .putNumber("total", total)
                    .put("stats", new JsonUtil.Obj()
                            .putNumber("total", stats.total())
                            .putNumber("active", stats.active())
                            .putNumber("hidden", stats.hidden())
                            .putNumber("lowStock", stats.lowStock())
                            .end())
                    .end();
            writeJson(response, HttpServletResponse.SC_OK, body);
        } catch (SQLException e) {
            LOG.error("Seller products query failed", e);
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Không tải được danh sách sản phẩm.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        SellerContext ctx = resolveContext(request, response);
        if (ctx == null) {
            return;
        }
        String action = trim(request.getParameter("action"));
        try {
            switch (action) {
                case "create" -> create(ctx.shop(), request, response);
                case "update" -> update(ctx.shop(), request, response);
                case "status" -> changeStatus(ctx.shop(), request, response);
                default -> writeError(response, HttpServletResponse.SC_BAD_REQUEST,
                        "Hành động không hợp lệ.");
            }
        } catch (IllegalArgumentException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SQLException e) {
            LOG.error("Seller products write failed: " + action, e);
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Không lưu được sản phẩm, vui lòng thử lại.");
        }
    }

    // ------------------------------------------------------------------

    private void create(SellerProductDAO.Shop shop, HttpServletRequest request,
                        HttpServletResponse response) throws SQLException, IOException {
        String name = validName(request.getParameter("name"));
        int categoryId = validCategory(request.getParameter("categoryId"));
        long price = validPrice(request.getParameter("price"));
        int stock = validStock(request.getParameter("stock"));
        String description = validText(request.getParameter("description"), SHORT_DESC_MAX,
                "Mô tả ngắn");
        String thumbnail = validText(request.getParameter("thumbnail"), URL_MAX, "Ảnh đại diện");

        String slug = dao.uniqueSlug(name);
        int id = dao.create(shop.supplierId(), categoryId, name, slug,
                description, thumbnail, price, stock);
        writeJson(response, HttpServletResponse.SC_OK, new JsonUtil.Obj()
                .putBoolean("ok", id > 0)
                .putNumber("id", id)
                .end());
    }

    private void update(SellerProductDAO.Shop shop, HttpServletRequest request,
                        HttpServletResponse response) throws SQLException, IOException {
        int productId = validProductId(request.getParameter("id"));
        requireOwned(shop, productId);

        String name = validName(request.getParameter("name"));
        int categoryId = validCategory(request.getParameter("categoryId"));
        long price = validPrice(request.getParameter("price"));
        int stock = validStock(request.getParameter("stock"));
        String description = validText(request.getParameter("description"), SHORT_DESC_MAX,
                "Mô tả ngắn");
        String thumbnail = validText(request.getParameter("thumbnail"), URL_MAX, "Ảnh đại diện");

        boolean ok = dao.update(shop.supplierId(), productId, categoryId, name,
                description, thumbnail, price, stock);
        writeJson(response, HttpServletResponse.SC_OK,
                new JsonUtil.Obj().putBoolean("ok", ok).end());
    }

    private void changeStatus(SellerProductDAO.Shop shop, HttpServletRequest request,
                              HttpServletResponse response) throws SQLException, IOException {
        int productId = validProductId(request.getParameter("id"));
        requireOwned(shop, productId);

        String status = trim(request.getParameter("status")).toUpperCase();
        if (!"ACTIVE".equals(status) && !"HIDDEN".equals(status)) {
            throw new IllegalArgumentException("Trạng thái sản phẩm không hợp lệ.");
        }
        boolean ok = dao.setStatus(shop.supplierId(), productId, status);
        writeJson(response, HttpServletResponse.SC_OK,
                new JsonUtil.Obj().putBoolean("ok", ok).putString("status", status).end());
    }

    /** Không cho sửa sản phẩm của xưởng khác, kể cả khi đoán được product_id. */
    private void requireOwned(SellerProductDAO.Shop shop, int productId)
            throws SQLException {
        if (dao.findOwned(shop.supplierId(), productId).isEmpty()) {
            throw new IllegalArgumentException(
                    "Không tìm thấy sản phẩm thuộc xưởng của bạn.");
        }
    }

    // ------------------------------------------------------------------

    private SellerContext resolveContext(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        SessionUser user = AuthUtil.currentUser(request);
        if (user == null || user.getRole() != Role.SELLER) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN,
                    "Chỉ tài khoản người bán được dùng chức năng này.");
            return null;
        }
        try {
            Optional<SellerProductDAO.Shop> shop = dao.findShop(user.getUserId());
            if (shop.isEmpty()) {
                writeError(response, HttpServletResponse.SC_FORBIDDEN,
                        "Tài khoản chưa có hồ sơ xưởng in đang hoạt động.");
                return null;
            }
            return new SellerContext(user, shop.get());
        } catch (SQLException e) {
            LOG.error("Cannot resolve seller shop for user {}", user.getUserId(), e);
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Không xác định được xưởng của tài khoản.");
            return null;
        }
    }

    private record SellerContext(SessionUser user, SellerProductDAO.Shop shop) {
    }

    // ------------------------------------------------------------------
    // Validation
    // ------------------------------------------------------------------

    private static String validName(String raw) {
        String name = trim(raw);
        if (name.length() < 2 || name.length() > NAME_MAX) {
            throw new IllegalArgumentException(
                    "Tên sản phẩm phải từ 2 đến " + NAME_MAX + " ký tự.");
        }
        return name;
    }

    private int validCategory(String raw) throws SQLException {
        int categoryId = positiveInt(raw, "Danh mục không hợp lệ.");
        if (!dao.categoryExists(categoryId)) {
            throw new IllegalArgumentException("Danh mục không tồn tại hoặc đã ngừng dùng.");
        }
        return categoryId;
    }

    private static long validPrice(String raw) {
        long price;
        try {
            price = Long.parseLong(trim(raw).replace(",", "").replace(".", ""));
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Giá bán không hợp lệ.");
        }
        if (price < 0 || price > PRICE_MAX) {
            throw new IllegalArgumentException("Giá bán phải trong khoảng 0 – 999.999.999.999.");
        }
        return price;
    }

    private static int validStock(String raw) {
        int stock;
        try {
            stock = Integer.parseInt(trim(raw));
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Số lượng tồn kho không hợp lệ.");
        }
        if (stock < 0 || stock > STOCK_MAX) {
            throw new IllegalArgumentException("Tồn kho phải trong khoảng 0 – " + STOCK_MAX + ".");
        }
        return stock;
    }

    private static String validText(String raw, int max, String fieldName) {
        String value = trim(raw);
        if (value.length() > max) {
            throw new IllegalArgumentException(fieldName + " tối đa " + max + " ký tự.");
        }
        return value.isEmpty() ? null : value;
    }

    private static String parseStatusFilter(String raw) {
        String status = trim(raw).toUpperCase();
        return "ACTIVE".equals(status) || "HIDDEN".equals(status) ? status : null;
    }

    private static int clampSize(String raw) {
        try {
            int size = Integer.parseInt(trim(raw));
            return size < 1 || size > MAX_PAGE_SIZE ? DEFAULT_PAGE_SIZE : size;
        } catch (NumberFormatException e) {
            return DEFAULT_PAGE_SIZE;
        }
    }

    private static int clampPage(String raw, int pages) {
        int page;
        try {
            page = Integer.parseInt(trim(raw));
        } catch (NumberFormatException e) {
            page = 1;
        }
        if (page < 1) {
            page = 1;
        }
        return pages > 0 && page > pages ? pages : page;
    }

    private static int validProductId(String raw) {
        return positiveInt(raw, "Mã sản phẩm không hợp lệ.");
    }

    private static int positiveInt(String raw, String message) {
        try {
            int value = Integer.parseInt(trim(raw));
            if (value <= 0) {
                throw new IllegalArgumentException(message);
            }
            return value;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(message);
        }
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }

    // ------------------------------------------------------------------

    private static void writeError(HttpServletResponse response, int status, String message)
            throws IOException {
        writeJson(response, status, new JsonUtil.Obj()
                .putString("error", message == null ? "Đã xảy ra lỗi." : message)
                .end());
    }

    private static void writeJson(HttpServletResponse response, int status, String body)
            throws IOException {
        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");
        response.getWriter().write(body);
    }
}
