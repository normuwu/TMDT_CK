package com.tmdt.servlet;

import com.tmdt.model.Order;
import com.tmdt.model.OrderStatus;
import com.tmdt.model.Role;
import com.tmdt.model.SessionUser;
import com.tmdt.service.OrderStatusService;
import com.tmdt.util.AuthUtil;
import com.tmdt.util.FlashUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Quản lý đơn hàng dành riêng cho Người bán (xưởng in):
 *   GET  /NhaCungCap/don-hang            : danh sách đơn của xưởng + trạng thái
 *   GET  /NhaCungCap/don-hang?status=... : lọc theo trạng thái
 *   POST /NhaCungCap/don-hang            : action=update, orderId, status, note
 *
 * Dữ liệu đọc/ghi trực tiếp từ bảng orders (OrderStatusService), KHÔNG dùng
 * localStorage. Phạm vi xưởng được kiểm tra ở server: SELLER chỉ thấy và chỉ
 * cập nhật được đơn thuộc shops.user_id = tài khoản đang đăng nhập.
 *
 * Trang này tách khỏi /Admin/quan-ly-don-hang (chỉ ADMIN) để không phải nới
 * quyền của khu vực quản trị.
 */
@WebServlet(name = "SellerOrderServlet", urlPatterns = SellerOrderServlet.BASE_URL)
public class SellerOrderServlet extends HttpServlet {

    public static final String BASE_URL = "/NhaCungCap/don-hang";
    private static final String VIEW = "/WEB-INF/views/seller/order-management.jsp";

    private final OrderStatusService statusService = new OrderStatusService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (AuthUtil.requireRole(request, response, BASE_URL, Role.SELLER)) {
            return;
        }
        FlashUtil.moveToRequest(request);

        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        response.setHeader("Pragma", "no-cache");

        SessionUser user = AuthUtil.currentUser(request);
        OrderStatus filter = parseStatus(request.getParameter("status"));

        List<Order> orders;
        List<Order> allOrders;
        try {
            allOrders = statusService.listForManagement(user, null);
            orders = filter == null ? allOrders : statusService.listForManagement(user, filter);
        } catch (IllegalStateException e) {
            getServletContext().log("Lỗi tải danh sách đơn hàng của người bán", e);
            request.setAttribute("error", "Hệ thống đang bận, không tải được danh sách đơn hàng.");
            orders = List.of();
            allOrders = List.of();
        }

        int pendingCount = 0;
        int activeCount = 0;
        for (Order o : allOrders) {
            if (o.getStatus() == OrderStatus.PENDING) pendingCount++;
            if (o.getStatus() == OrderStatus.CONFIRMED || o.getStatus() == OrderStatus.SHIPPING) {
                activeCount++;
            }
        }

        Map<Integer, List<OrderStatus>> nextStatusMap = new LinkedHashMap<>();
        for (Order order : orders) {
            nextStatusMap.put(order.getOrderId(), statusService.allowedNextStatuses(user, order));
        }

        request.setAttribute("orders", orders);
        request.setAttribute("totalCount", allOrders.size());
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("activeCount", activeCount);
        request.setAttribute("nextStatusMap", nextStatusMap);
        request.setAttribute("statuses", OrderStatus.values());
        request.setAttribute("selectedStatus", filter == null ? "" : filter.getCode());
        request.setAttribute("baseUrl", BASE_URL);
        request.getRequestDispatcher(VIEW).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (AuthUtil.requireRole(request, response, BASE_URL, Role.SELLER)) {
            return;
        }

        SessionUser user = AuthUtil.currentUser(request);
        Integer orderId = positiveInt(request.getParameter("orderId"));
        OrderStatus target = parseStatus(request.getParameter("status"));
        String note = request.getParameter("note");
        String backFilter = request.getParameter("filter");

        if (!"update".equals(request.getParameter("action")) || orderId == null || target == null) {
            FlashUtil.flashError(request.getSession(true), "Yêu cầu cập nhật không hợp lệ.");
            response.sendRedirect(request.getContextPath() + listUrl(backFilter));
            return;
        }

        OrderStatusService.Outcome outcome =
                statusService.updateStatus(user, orderId, target, note);
        if (outcome.success()) {
            FlashUtil.flashSuccess(request.getSession(true), outcome.message());
        } else {
            FlashUtil.flashError(request.getSession(true), outcome.message());
        }
        response.sendRedirect(request.getContextPath() + listUrl(backFilter));
    }

    private static String listUrl(String filter) {
        OrderStatus parsed = parseStatus(filter);
        return parsed == null
                ? BASE_URL
                : BASE_URL + "?status=" + URLEncoder.encode(
                        parsed.getCode(), StandardCharsets.UTF_8);
    }

    private static OrderStatus parseStatus(String raw) {
        if (raw == null || raw.isBlank()) return null;
        try {
            return OrderStatus.valueOf(raw.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }

    private static Integer positiveInt(String s) {
        try {
            int v = Integer.parseInt(s == null ? "" : s.trim());
            return v > 0 ? v : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
