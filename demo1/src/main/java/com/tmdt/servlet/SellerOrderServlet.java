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
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Quản lý đơn hàng dành riêng cho Người bán (xưởng in):
 *   GET  /NhaCungCap/don-hang?status=&from=&to=&page=
 *        : danh sách đơn của xưởng, lọc trạng thái + khoảng ngày tạo, phân trang
 *   POST /NhaCungCap/don-hang  action=update, orderId, status, note
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
    private static final int PAGE_SIZE = 10;

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

        String fromRaw = trim(request.getParameter("from"));
        String toRaw = trim(request.getParameter("to"));
        LocalDate from = parseDate(fromRaw);
        LocalDate to = parseDate(toRaw);
        String dateError = null;
        if (!fromRaw.isEmpty() && from == null) {
            dateError = "Từ ngày không hợp lệ (định dạng YYYY-MM-DD).";
        } else if (!toRaw.isEmpty() && to == null) {
            dateError = "Đến ngày không hợp lệ (định dạng YYYY-MM-DD).";
        } else if (from != null && to != null && from.isAfter(to)) {
            dateError = "Từ ngày phải nhỏ hơn hoặc bằng Đến ngày.";
        }
        if (dateError != null) {
            // Bộ lọc sai không được lặng lẽ trả về toàn bộ đơn.
            from = null;
            to = null;
            request.setAttribute("error", dateError);
        }

        int page = parsePage(request.getParameter("page"));

        OrderStatusService.OrderPage pageResult;
        OrderStatusService.OrderCounts counts;
        try {
            pageResult = statusService.pageForManagement(user, filter, from, to, page, PAGE_SIZE);
            counts = statusService.countsForManagement(user);
        } catch (IllegalStateException e) {
            getServletContext().log("Lỗi tải danh sách đơn hàng của người bán", e);
            request.setAttribute("error", "Hệ thống đang bận, không tải được danh sách đơn hàng.");
            pageResult = new OrderStatusService.OrderPage(List.of(), 0, 1, PAGE_SIZE, 0);
            counts = new OrderStatusService.OrderCounts(0, 0, 0, 0, 0);
        }

        Map<Integer, List<OrderStatus>> nextStatusMap = new LinkedHashMap<>();
        for (Order order : pageResult.orders()) {
            nextStatusMap.put(order.getOrderId(), statusService.allowedNextStatuses(user, order));
        }

        request.setAttribute("orders", pageResult.orders());
        request.setAttribute("totalCount", counts.total());
        request.setAttribute("pendingCount", counts.pending());
        request.setAttribute("activeCount", counts.processing());
        request.setAttribute("completedCount", counts.completed());
        request.setAttribute("cancelledCount", counts.cancelled());
        request.setAttribute("filteredCount", pageResult.total());
        request.setAttribute("page", pageResult.page());
        request.setAttribute("pages", pageResult.pages());
        request.setAttribute("pageSize", pageResult.size());
        request.setAttribute("nextStatusMap", nextStatusMap);
        request.setAttribute("statuses", OrderStatus.values());
        request.setAttribute("selectedStatus", filter == null ? "" : filter.getCode());
        request.setAttribute("fromDate", from == null ? "" : from.toString());
        request.setAttribute("toDate", to == null ? "" : to.toString());
        String filterQuery = filterQuery(request.getParameter("status"), fromRaw, toRaw);
        request.setAttribute("filterQuery", filterQuery);
        request.setAttribute("pagerBase", request.getContextPath() + BASE_URL + "?"
                + (filterQuery.isEmpty() ? "" : filterQuery + "&"));
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
        String backFrom = request.getParameter("from");
        String backTo = request.getParameter("to");
        String backPage = request.getParameter("page");

        if (!"update".equals(request.getParameter("action")) || orderId == null || target == null) {
            FlashUtil.flashError(request.getSession(true), "Yêu cầu cập nhật không hợp lệ.");
            response.sendRedirect(request.getContextPath()
                    + listUrl(backFilter, backFrom, backTo, backPage));
            return;
        }

        OrderStatusService.Outcome outcome =
                statusService.updateStatus(user, orderId, target, note);
        if (outcome.success()) {
            FlashUtil.flashSuccess(request.getSession(true), outcome.message());
        } else {
            FlashUtil.flashError(request.getSession(true), outcome.message());
        }
        response.sendRedirect(request.getContextPath()
                + listUrl(backFilter, backFrom, backTo, backPage));
    }

    /** Giữ nguyên bộ lọc + trang hiện tại sau khi cập nhật trạng thái (PRG). */
    private static String listUrl(String filter, String from, String to, String page) {
        StringBuilder url = new StringBuilder(BASE_URL);
        String query = filterQuery(filter, from, to);
        if (!query.isEmpty()) {
            url.append('?').append(query);
        }
        int p = parsePage(page);
        if (p > 1) {
            url.append(query.isEmpty() ? '?' : '&').append("page=").append(p);
        }
        return url.toString();
    }

    /** Chuỗi query (không có dấu ?) cho các bộ lọc hợp lệ. */
    private static String filterQuery(String filter, String from, String to) {
        List<String> parts = new ArrayList<>();
        OrderStatus parsed = parseStatus(filter);
        if (parsed != null) {
            parts.add("status=" + URLEncoder.encode(parsed.getCode(), StandardCharsets.UTF_8));
        }
        LocalDate fromDate = parseDate(trim(from));
        if (fromDate != null) {
            parts.add("from=" + fromDate);
        }
        LocalDate toDate = parseDate(trim(to));
        if (toDate != null) {
            parts.add("to=" + toDate);
        }
        return String.join("&", parts);
    }

    private static OrderStatus parseStatus(String raw) {
        if (raw == null || raw.isBlank()) return null;
        try {
            return OrderStatus.valueOf(raw.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }

    private static LocalDate parseDate(String raw) {
        if (raw == null || raw.isBlank()) return null;
        try {
            return LocalDate.parse(raw.trim());
        } catch (DateTimeParseException e) {
            return null;
        }
    }

    private static int parsePage(String raw) {
        try {
            int page = Integer.parseInt(raw == null ? "" : raw.trim());
            return page < 1 ? 1 : page;
        } catch (NumberFormatException e) {
            return 1;
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

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
