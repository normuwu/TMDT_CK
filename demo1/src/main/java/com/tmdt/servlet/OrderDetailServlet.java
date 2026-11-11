package com.tmdt.servlet;

import com.tmdt.model.Order;
import com.tmdt.model.Role;
import com.tmdt.model.SessionUser;
import com.tmdt.service.OrderService;
import com.tmdt.service.OrderStatusService;
import com.tmdt.util.AuthUtil;
import com.tmdt.util.FlashUtil;
import com.tmdt.util.Views;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Optional;

/**
 * GET /KhachHang/chi-tiet-don-hang?id=12
 * Truy vấn luôn kèm user_id của session: đổi id trên URL sang đơn người khác
 * sẽ nhận 404, không lộ dữ liệu.
 *
 * ADMIN/SELLER cũng dùng lại trang này khi bấm "Chi tiết" ở trang quản lý đơn:
 * phạm vi được kiểm tra ở server (ADMIN: mọi đơn, SELLER: đơn của shop mình),
 * khách hàng vẫn chỉ thấy đơn của chính mình.
 */
@WebServlet(name = "OrderDetailServlet", urlPatterns = Views.ORDER_DETAIL_URL)
public class OrderDetailServlet extends HttpServlet {

    private final OrderService orderService = new OrderService();
    private final OrderStatusService statusService = new OrderStatusService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer orderId = positiveInt(request.getParameter("id"));
        String target = orderId == null
                ? Views.ORDER_HISTORY_URL
                : Views.ORDER_DETAIL_URL + "?id=" + orderId;

        if (AuthUtil.requireLogin(request, response, target)) {
            return;
        }
        FlashUtil.moveToRequest(request);

        if (orderId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã đơn hàng không hợp lệ.");
            return;
        }

        SessionUser user = AuthUtil.currentUser(request);
        boolean manager = user.getRole() == Role.ADMIN || user.getRole() == Role.SELLER;
        Optional<Order> order;
        try {
            order = manager
                    ? orderService.detailForManagement(user, orderId)
                    : orderService.detail(user.getUserId(), orderId);
        } catch (IllegalStateException e) {
            getServletContext().log("Lỗi tải chi tiết đơn hàng " + orderId, e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Hệ thống đang bận, vui lòng thử lại sau.");
            return;
        }
        if (order.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND,
                    "Đơn hàng không tồn tại hoặc không thuộc tài khoản của bạn.");
            return;
        }

        request.setAttribute("order", order.get());
        request.setAttribute("isManager", manager);
        request.setAttribute("backUrl",
                manager ? Views.ADMIN_ORDER_LIST_URL : Views.ORDER_HISTORY_URL);
        request.setAttribute("backLabel",
                manager ? "Quản lý đơn hàng" : "Lịch sử mua hàng");
        // Khách chỉ thấy nút hủy khi đúng chủ đơn và đơn còn ở bước cho phép hủy.
        request.setAttribute("canCancel",
                !manager && OrderStatusService.canCustomerCancel(user, order.get()));
        request.setAttribute("statusHistory",
                statusService.history(order.get().getOrderId()));
        request.getRequestDispatcher(Views.ORDER_DETAIL).forward(request, response);
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
