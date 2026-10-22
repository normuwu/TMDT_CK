package com.tmdt.servlet;

import com.tmdt.model.Order;
import com.tmdt.model.SessionUser;
import com.tmdt.service.OrderService;
import com.tmdt.util.AuthUtil;
import com.tmdt.util.FlashUtil;
import com.tmdt.util.Views;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * GET /KhachHang/lich-su-mua-hang
 * userId LUÔN lấy từ session, không nhận từ URL → chỉ thấy đơn của mình.
 */
@WebServlet(name = "OrderHistoryServlet", urlPatterns = Views.ORDER_HISTORY_URL)
public class OrderHistoryServlet extends HttpServlet {

    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (AuthUtil.requireLogin(request, response, Views.ORDER_HISTORY_URL)) {
            return;
        }
        FlashUtil.moveToRequest(request);

        SessionUser user = AuthUtil.currentUser(request);
        List<Order> orders;
        try {
            orders = orderService.history(user.getUserId());
        } catch (IllegalStateException e) {
            getServletContext().log("Lỗi tải lịch sử mua hàng", e);
            request.setAttribute("error", "Hệ thống đang bận, không tải được lịch sử mua hàng.");
            orders = List.of();
        }
        request.setAttribute("orders", orders);
        request.getRequestDispatcher(Views.ORDER_HISTORY).forward(request, response);
    }
}
