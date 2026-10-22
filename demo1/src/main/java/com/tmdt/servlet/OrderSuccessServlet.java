package com.tmdt.servlet;

import com.tmdt.model.Order;
import com.tmdt.model.SessionUser;
import com.tmdt.service.OrderService;
import com.tmdt.util.AuthUtil;
import com.tmdt.util.Views;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * GET /KhachHang/dat-hang-thanh-cong?ids=12,13
 * Chỉ đọc đơn của chính tài khoản trong session (đổi id trên URL không xem được
 * đơn người khác). Trang này là đích của PRG sau khi đặt hàng.
 */
@WebServlet(name = "OrderSuccessServlet", urlPatterns = Views.ORDER_SUCCESS_URL)
public class OrderSuccessServlet extends HttpServlet {

    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (AuthUtil.requireLogin(request, response, Views.CART_URL)) {
            return;
        }

        List<Integer> ids = parseIds(request.getParameter("ids"));
        if (ids.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn hàng.");
            return;
        }

        SessionUser user = AuthUtil.currentUser(request);
        List<Order> orders;
        try {
            orders = orderService.successOrders(user.getUserId(), ids);
        } catch (IllegalStateException e) {
            getServletContext().log("Lỗi tải đơn vừa đặt", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Hệ thống đang bận, vui lòng mở lịch sử mua hàng sau.");
            return;
        }
        if (orders.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn hàng.");
            return;
        }

        BigDecimal total = BigDecimal.ZERO;
        for (Order order : orders) {
            total = total.add(order.getTotalAmount());
        }
        request.setAttribute("orders", orders);
        request.setAttribute("grandTotal", total);
        request.getRequestDispatcher(Views.ORDER_SUCCESS).forward(request, response);
    }

    private static List<Integer> parseIds(String raw) {
        List<Integer> ids = new ArrayList<>();
        if (raw == null) return ids;
        for (String part : raw.split(",")) {
            try {
                int id = Integer.parseInt(part.trim());
                if (id > 0 && !ids.contains(id)) ids.add(id);
            } catch (NumberFormatException ignored) {
                // bỏ qua phần tử rác trên URL
            }
            if (ids.size() >= 20) break;
        }
        return ids;
    }
}
