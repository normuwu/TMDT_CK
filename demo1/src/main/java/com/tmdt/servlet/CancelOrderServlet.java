package com.tmdt.servlet;

import com.tmdt.model.SessionUser;
import com.tmdt.service.OrderStatusService;
import com.tmdt.util.AuthUtil;
import com.tmdt.util.FlashUtil;
import com.tmdt.util.Views;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * POST /KhachHang/huy-don-hang : orderId, reason (tùy chọn)
 *
 * Khách chỉ hủy được đơn của CHÍNH MÌNH ở trạng thái PENDING/CONFIRMED.
 * Điều kiện được kiểm tra lại trong OrderStatusService (server), không tin
 * orderId/role từ form. Thành công: PRG về trang chi tiết đơn.
 */
@WebServlet(name = "CancelOrderServlet", urlPatterns = Views.CANCEL_ORDER_URL)
public class CancelOrderServlet extends HttpServlet {

    private final OrderStatusService statusService = new OrderStatusService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Integer orderId = positiveInt(request.getParameter("orderId"));
        if (orderId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã đơn hàng không hợp lệ.");
            return;
        }
        String detailTarget = Views.ORDER_DETAIL_URL + "?id=" + orderId;
        if (AuthUtil.requireLogin(request, response, detailTarget)) {
            return;
        }

        SessionUser user = AuthUtil.currentUser(request);
        String reason = request.getParameter("reason");

        OrderStatusService.Outcome outcome = statusService.cancelByCustomer(user, orderId, reason);
        if (outcome.success()) {
            FlashUtil.flashSuccess(request.getSession(true), outcome.message());
            response.sendRedirect(request.getContextPath() + detailTarget);
        } else {
            FlashUtil.flashError(request.getSession(true), outcome.message());
            response.sendRedirect(request.getContextPath() + Views.ORDER_HISTORY_URL);
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
