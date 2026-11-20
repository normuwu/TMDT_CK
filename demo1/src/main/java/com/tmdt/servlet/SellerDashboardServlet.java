package com.tmdt.servlet;

import com.tmdt.dao.SellerDashboardDAO;
import com.tmdt.model.Role;
import com.tmdt.model.SessionUser;
import com.tmdt.util.AuthUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Dashboard của Người bán (xưởng in):
 *   GET /NhaCungCap/dashboard
 *
 * Khác với trang dashBoard.jsp cũ (chỉ là HTML tĩnh), servlet này đọc dữ liệu thật
 * từ MySQL và giới hạn theo xưởng của tài khoản đang đăng nhập (lấy từ session,
 * không nhận shop_id/supplier_id từ request).
 *
 * Doanh thu chỉ tính đơn COMPLETED (đã giao) — xem SellerDashboardDAO.
 * Biểu đồ do /nhacungcap/api/stats/* trả về (cùng phạm vi xưởng).
 */
@WebServlet(name = "SellerDashboardServlet", urlPatterns = SellerDashboardServlet.BASE_URL)
public class SellerDashboardServlet extends HttpServlet {

    public static final String BASE_URL = "/NhaCungCap/dashboard";
    private static final String VIEW = "/WEB-INF/views/seller/dashboard.jsp";

    private static final int RECENT_LIMIT = 5;
    private static final int TOP_PRODUCT_LIMIT = 5;
    private static final int TOP_PRODUCT_DAYS = 30;

    private static final Logger LOG = LoggerFactory.getLogger(SellerDashboardServlet.class);

    private final SellerDashboardDAO dao = new SellerDashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (AuthUtil.requireRole(request, response, BASE_URL, Role.SELLER)) {
            return;
        }
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        response.setHeader("Pragma", "no-cache");

        SessionUser user = AuthUtil.currentUser(request);
        request.setAttribute("baseUrl", BASE_URL);
        request.setAttribute("today", LocalDate.now().toString());

        Optional<SellerDashboardDAO.Shop> found;
        try {
            found = dao.findShop(user.getUserId());
        } catch (SQLException e) {
            LOG.error("Không tải được xưởng của người bán userId={}", user.getUserId(), e);
            request.setAttribute("loadError",
                    "Không kết nối được cơ sở dữ liệu, số liệu có thể chưa đầy đủ.");
            forward(request, response);
            return;
        }

        if (found.isEmpty()) {
            request.setAttribute("noShop", Boolean.TRUE);
            forward(request, response);
            return;
        }

        SellerDashboardDAO.Shop shop = found.get();
        request.setAttribute("shopId", shop.shopId());
        request.setAttribute("supplierId", shop.supplierId());
        request.setAttribute("shopName", shop.shopName());

        try {
            SellerDashboardDAO.ProductStats products = dao.productStats(shop.supplierId());
            request.setAttribute("productTotal", products.total());
            request.setAttribute("productActive", products.active());
            request.setAttribute("productHidden", products.hidden());
            request.setAttribute("productLowStock", products.lowStock());

            SellerDashboardDAO.OrderCounts counts = dao.orderCounts(shop.shopId());
            request.setAttribute("orderTotal", counts.total());
            request.setAttribute("orderPending", counts.pending());
            request.setAttribute("orderConfirmed", counts.confirmed());
            request.setAttribute("orderShipping", counts.shipping());
            request.setAttribute("orderCompleted", counts.completed());
            request.setAttribute("orderCancelled", counts.cancelled());
            request.setAttribute("orderProcessing", counts.processing());

            SellerDashboardDAO.Revenue revenue = dao.revenue(shop.shopId());
            request.setAttribute("revenueTotal", revenue.total());
            request.setAttribute("revenueToday", revenue.today());
            request.setAttribute("revenueYesterday", revenue.yesterday());
            request.setAttribute("revenueMonth", revenue.thisMonth());

            request.setAttribute("recentOrders",
                    toOrderMaps(dao.recentOrders(shop.shopId(), RECENT_LIMIT), request));
            request.setAttribute("pendingOrders",
                    toOrderMaps(dao.pendingOrders(shop.shopId(), RECENT_LIMIT), request));
            request.setAttribute("recentProducts",
                    toProductMaps(dao.recentProducts(shop.supplierId(), RECENT_LIMIT)));
            request.setAttribute("topProducts",
                    toTopProductMaps(dao.topProducts(shop.shopId(),
                            LocalDate.now().minusDays(TOP_PRODUCT_DAYS - 1L),
                            LocalDate.now(), TOP_PRODUCT_LIMIT)));
            request.setAttribute("topProductDays", TOP_PRODUCT_DAYS);
        } catch (SQLException e) {
            LOG.error("Không tải được số liệu dashboard cho shop_id={}", shop.shopId(), e);
            applyEmptyStats(request);
            request.setAttribute("loadError",
                    "Không tải được số liệu từ cơ sở dữ liệu. Vui lòng thử lại sau.");
        }

        forward(request, response);
    }

    private void forward(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(VIEW).forward(request, response);
    }

    private void applyEmptyStats(HttpServletRequest request) {
        request.setAttribute("productTotal", 0);
        request.setAttribute("productActive", 0);
        request.setAttribute("productHidden", 0);
        request.setAttribute("productLowStock", 0);
        request.setAttribute("orderTotal", 0);
        request.setAttribute("orderPending", 0);
        request.setAttribute("orderConfirmed", 0);
        request.setAttribute("orderShipping", 0);
        request.setAttribute("orderCompleted", 0);
        request.setAttribute("orderCancelled", 0);
        request.setAttribute("orderProcessing", 0);
        request.setAttribute("revenueTotal", BigDecimal.ZERO);
        request.setAttribute("revenueToday", BigDecimal.ZERO);
        request.setAttribute("revenueYesterday", BigDecimal.ZERO);
        request.setAttribute("revenueMonth", BigDecimal.ZERO);
        request.setAttribute("recentOrders", List.of());
        request.setAttribute("pendingOrders", List.of());
        request.setAttribute("recentProducts", List.of());
        request.setAttribute("topProducts", List.of());
    }

    // ------------------------------------------------------------------

    private static List<Map<String, Object>> toOrderMaps(List<SellerDashboardDAO.OrderRow> rows,
                                                         HttpServletRequest request) {
        List<Map<String, Object>> list = new ArrayList<>();
        for (SellerDashboardDAO.OrderRow row : rows) {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("orderId", row.orderId());
            map.put("orderCode", row.orderCode());
            map.put("customerName", row.customerName());
            map.put("recipientName", row.recipientName());
            map.put("totalAmount", row.totalAmount());
            map.put("status", row.status());
            map.put("statusLabel", row.statusLabel());
            map.put("createdAtText", row.getCreatedAtText());
            map.put("detailUrl", request.getContextPath()
                    + "/KhachHang/chi-tiet-don-hang?id=" + row.orderId());
            list.add(map);
        }
        return list;
    }

    private static List<Map<String, Object>> toProductMaps(List<SellerDashboardDAO.ProductRow> rows) {
        List<Map<String, Object>> list = new ArrayList<>();
        for (SellerDashboardDAO.ProductRow row : rows) {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("productId", row.productId());
            map.put("name", row.name());
            map.put("price", row.price());
            map.put("stock", row.stock());
            map.put("status", row.status());
            map.put("statusLabel", "ACTIVE".equals(row.status()) ? "Đang bán" : "Đã ẩn");
            map.put("updatedAtText", row.getUpdatedAtText());
            list.add(map);
        }
        return list;
    }

    private static List<Map<String, Object>> toTopProductMaps(List<SellerDashboardDAO.TopProduct> rows) {
        List<Map<String, Object>> list = new ArrayList<>();
        for (SellerDashboardDAO.TopProduct row : rows) {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("productId", row.productId());
            map.put("name", row.name());
            map.put("quantity", row.quantity());
            map.put("revenue", row.revenue());
            list.add(map);
        }
        return list;
    }
}
