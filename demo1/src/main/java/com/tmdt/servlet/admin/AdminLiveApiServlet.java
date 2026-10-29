package com.tmdt.servlet.admin;

import com.tmdt.dao.AdminLiveDAO;
import com.tmdt.service.AdminLiveService;
import com.tmdt.service.AdminStatsService;
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

/**
 * API dữ liệu thật cho admin (chỉ ADMIN — AuthFilter chặn trước khi vào đây):
 *   GET /admin/api/dashboard
 *   GET /admin/api/products?q=&category=&status=ACTIVE|HIDDEN&low=1&page=&size=
 *   GET /admin/api/orders?q=&status=&shop=&days=7|30&page=&size=
 *   GET /admin/api/suppliers?q=&sort=revenue|orders|rating|name&page=&size=
 *
 * Mọi phản hồi là application/json;charset=UTF-8; lỗi dùng {"error":"..."} 4xx.
 */
@WebServlet(name = "AdminLiveApiServlet", urlPatterns = {
        "/admin/api/dashboard",
        "/admin/api/products",
        "/admin/api/orders",
        "/admin/api/suppliers"
})
public class AdminLiveApiServlet extends HttpServlet {

    private static final Logger LOG = LoggerFactory.getLogger(AdminLiveApiServlet.class);

    private final AdminLiveService service = new AdminLiveService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String path = request.getServletPath();
        try {
            switch (path) {
                case "/admin/api/dashboard" ->
                        writeJson(response, HttpServletResponse.SC_OK, dashboardJson());
                case "/admin/api/products" ->
                        writeJson(response, HttpServletResponse.SC_OK, productsJson(request));
                case "/admin/api/orders" ->
                        writeJson(response, HttpServletResponse.SC_OK, ordersJson(request));
                case "/admin/api/suppliers" ->
                        writeJson(response, HttpServletResponse.SC_OK, suppliersJson(request));
                default -> writeError(response, HttpServletResponse.SC_NOT_FOUND,
                        "Không tìm thấy tài nguyên.");
            }
        } catch (IllegalArgumentException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SQLException e) {
            LOG.error("Admin live data query failed: " + path, e);
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Không tải được dữ liệu.");
        }
    }

    private String dashboardJson() throws SQLException {
        AdminLiveService.Dashboard data = service.dashboard();

        JsonUtil.Arr bars = new JsonUtil.Arr();
        for (AdminStatsService.Bucket bucket : data.bars()) {
            bars.add(new JsonUtil.Obj()
                    .putString("key", bucket.key())
                    .putString("label", bucket.label())
                    .putString("title", bucket.title())
                    .putNumber("revenue", bucket.revenue())
                    .putNumber("orders", bucket.orders())
                    .end());
        }

        JsonUtil.Arr categories = new JsonUtil.Arr();
        for (AdminStatsService.Slice slice : data.categories()) {
            categories.add(new JsonUtil.Obj()
                    .putString("name", slice.name())
                    .putNumber("value", slice.value())
                    .end());
        }

        JsonUtil.Arr topShops = new JsonUtil.Arr();
        for (AdminLiveService.SupplierSlice slice : data.topShops()) {
            topShops.add(new JsonUtil.Obj()
                    .putString("name", slice.name())
                    .putNumber("value", slice.value())
                    .end());
        }

        return new JsonUtil.Obj()
                .put("kpi", new JsonUtil.Obj()
                        .putNumber("revenueToday", data.kpi().revenueToday())
                        .putNumber("revenueYesterday", data.kpi().revenueYesterday())
                        .putNumber("createdToday", data.kpi().createdToday())
                        .putNumber("processing", data.kpi().processing())
                        .putNumber("completionRate", data.kpi().completionRate())
                        .putNumber("lowStock", data.kpi().lowStock())
                        .end())
                .put("bars", bars.end())
                .put("categories", categories.end())
                .put("topShops", topShops.end())
                .put("recentOrders", recentOrders(data.recentOrders()))
                .put("pendingOrders", recentOrders(data.pendingOrders()))
                .put("productCounts", new JsonUtil.Obj()
                        .putNumber("total", data.productCounts().total())
                        .putNumber("active", data.productCounts().active())
                        .putNumber("lowStock", data.productCounts().lowStock())
                        .end())
                .put("orderCounts", new JsonUtil.Obj()
                        .putNumber("total", data.orderCounts().total())
                        .putNumber("value", data.orderCounts().value())
                        .putNumber("active", data.orderCounts().active())
                        .putNumber("cancelled", data.orderCounts().cancelled())
                        .end())
                .end();
    }

    private String productsJson(HttpServletRequest request) throws SQLException {
        AdminLiveService.Page<AdminLiveDAO.Product> page = service.products(
                request.getParameter("q"),
                request.getParameter("category"),
                request.getParameter("status"),
                request.getParameter("low"),
                request.getParameter("page"),
                request.getParameter("size"));

        JsonUtil.Arr items = new JsonUtil.Arr();
        for (AdminLiveDAO.Product product : page.items()) {
            items.add(new JsonUtil.Obj()
                    .putNumber("id", product.id())
                    .putString("name", product.name())
                    .putString("slug", product.sku())
                    .putString("category", product.category())
                    .putString("supplier", product.supplier())
                    .putNumber("price", product.price())
                    .putNumber("stock", product.stock())
                    .putNumber("sold", product.sold())
                    .putString("status", product.status())
                    .putString("updatedAt", product.updatedAt())
                    .end());
        }

        AdminLiveDAO.ProductCounts counts = service.productCounts();
        JsonUtil.Arr categories = new JsonUtil.Arr();
        for (AdminLiveDAO.Category category : service.productCategories()) {
            categories.add(new JsonUtil.Obj()
                    .putNumber("id", category.id())
                    .putString("name", category.name())
                    .putNumber("products", category.products())
                    .end());
        }

        return pageJson(page.items(), items.end(), page)
                .put("counts", new JsonUtil.Obj()
                        .putNumber("total", counts.total())
                        .putNumber("active", counts.active())
                        .putNumber("lowStock", counts.lowStock())
                        .end())
                .put("categories", categories.end())
                .end();
    }

    private String ordersJson(HttpServletRequest request) throws SQLException {
        AdminLiveService.Page<AdminLiveDAO.Order> page = service.orders(
                request.getParameter("q"),
                request.getParameter("status"),
                request.getParameter("shop"),
                request.getParameter("days"),
                request.getParameter("page"),
                request.getParameter("size"));

        JsonUtil.Arr items = new JsonUtil.Arr();
        for (AdminLiveDAO.Order order : page.items()) {
            items.add(new JsonUtil.Obj()
                    .putString("code", order.code())
                    .putString("customer", order.customer())
                    .putString("recipient", order.recipient())
                    .putString("shop", order.shop())
                    .putString("status", order.status())
                    .putNumber("total", order.total())
                    .putNumber("itemCount", order.itemCount())
                    .putString("createdAt", order.createdAt())
                    .end());
        }

        AdminLiveDAO.OrderCounts counts = service.orderCounts();
        JsonUtil.Arr shops = new JsonUtil.Arr();
        for (AdminLiveDAO.ShopRef shop : service.shops()) {
            shops.add(new JsonUtil.Obj()
                    .putNumber("id", shop.id())
                    .putString("name", shop.name())
                    .end());
        }

        return pageJson(page.items(), items.end(), page)
                .put("counts", new JsonUtil.Obj()
                        .putNumber("total", counts.total())
                        .putNumber("value", counts.value())
                        .putNumber("active", counts.active())
                        .putNumber("cancelled", counts.cancelled())
                        .end())
                .put("shops", shops.end())
                .end();
    }

    private String suppliersJson(HttpServletRequest request) throws SQLException {
        AdminLiveService.Page<AdminLiveDAO.Supplier> page = service.suppliers(
                request.getParameter("q"),
                request.getParameter("sort"),
                request.getParameter("page"),
                request.getParameter("size"));

        JsonUtil.Arr items = new JsonUtil.Arr();
        for (AdminLiveDAO.Supplier supplier : page.items()) {
            items.add(new JsonUtil.Obj()
                    .putNumber("id", supplier.id())
                    .putString("name", supplier.name())
                    .putString("address", supplier.address())
                    .putNumber("rating", supplier.rating())
                    .putNumber("reviews", supplier.reviews())
                    .putNumber("products", supplier.products())
                    .putNumber("orders30", supplier.orders30())
                    .putNumber("revenue30", supplier.revenue30())
                    .putString("status", supplier.status())
                    .end());
        }

        AdminLiveDAO.SupplierCounts counts = service.supplierCounts();
        return pageJson(page.items(), items.end(), page)
                .put("counts", new JsonUtil.Obj()
                        .putNumber("total", counts.total())
                        .putNumber("active", counts.active())
                        .putNumber("avgRating", counts.avgRating())
                        .putNumber("products", counts.products())
                        .end())
                .end();
    }

    private static JsonUtil.Obj pageJson(List<?> items, String itemsJson,
                                         AdminLiveService.Page<?> page) {
        return new JsonUtil.Obj()
                .put("items", itemsJson)
                .putNumber("total", page.total())
                .putNumber("page", page.page())
                .putNumber("size", page.size())
                .putNumber("totalPages", page.totalPages());
    }

    private static String recentOrders(List<AdminLiveDAO.RecentOrder> rows) {
        JsonUtil.Arr items = new JsonUtil.Arr();
        for (AdminLiveDAO.RecentOrder row : rows) {
            items.add(new JsonUtil.Obj()
                    .putString("code", row.code())
                    .putString("customer", row.customer())
                    .putString("shop", row.shop())
                    .putString("status", row.status())
                    .putNumber("total", row.total())
                    .putString("createdAt", row.createdAt())
                    .end());
        }
        return items.end();
    }

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
