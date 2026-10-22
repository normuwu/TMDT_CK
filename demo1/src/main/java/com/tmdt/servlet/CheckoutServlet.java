package com.tmdt.servlet;

import com.tmdt.dao.UserDAO;
import com.tmdt.model.Cart;
import com.tmdt.model.PaymentMethod;
import com.tmdt.model.SessionUser;
import com.tmdt.model.User;
import com.tmdt.service.OrderService;
import com.tmdt.util.AuthUtil;
import com.tmdt.util.FlashUtil;
import com.tmdt.util.Views;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * GET  /KhachHang/thanh-toan : form thông tin nhận hàng + đơn hàng
 * POST /KhachHang/thanh-toan : đặt hàng COD
 *
 * - Bắt buộc đăng nhập (orders.user_id FK users).
 * - Chuyển khoản ngân hàng: chưa hỗ trợ → quay lại form kèm thông báo,
 *   KHÔNG tạo đơn, KHÔNG đánh dấu thanh toán.
 * - Thành công: xóa giỏ + redirect sang trang thành công (PRG).
 * - Lỗi: rollback ở service, giữ nguyên giỏ, hiển thị lỗi ngay trên form.
 */
@WebServlet(name = "CheckoutServlet", urlPatterns = Views.CHECKOUT_URL)
public class CheckoutServlet extends HttpServlet {

    private static final String MSG_BANK_COMING_SOON =
            "Phương thức thanh toán này đang được phát triển. Vui lòng chọn thanh toán khi nhận hàng (COD).";

    private final OrderService orderService = new OrderService();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (AuthUtil.requireLogin(request, response, Views.CHECKOUT_URL)) {
            return;
        }
        FlashUtil.moveToRequest(request);

        Cart cart = currentCart(request);
        if (cart == null || cart.isEmpty()) {
            FlashUtil.flashError(request.getSession(true), "Giỏ hàng đang trống, chưa thể thanh toán.");
            response.sendRedirect(request.getContextPath() + Views.CART_URL);
            return;
        }

        SessionUser user = AuthUtil.currentUser(request);
        prefillFromProfile(request, user.getUserId());
        prepareForm(request, cart);
        request.getRequestDispatcher(Views.CHECKOUT).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (AuthUtil.requireLogin(request, response, Views.CHECKOUT_URL)) {
            return;
        }
        FlashUtil.moveToRequest(request);

        HttpSession session = request.getSession(true);
        Cart cart = currentCart(request);
        if (cart == null || cart.isEmpty()) {
            FlashUtil.flashError(session, "Giỏ hàng đang trống, chưa thể đặt hàng.");
            response.sendRedirect(request.getContextPath() + Views.CART_URL);
            return;
        }

        PaymentMethod method = PaymentMethod.fromForm(request.getParameter("paymentMethod"));
        if (method == null) {
            FlashUtil.flashError(session, "Vui lòng chọn phương thức thanh toán.");
            response.sendRedirect(request.getContextPath() + Views.CHECKOUT_URL);
            return;
        }
        if (method == PaymentMethod.BANK_TRANSFER) {
            FlashUtil.flashError(session, MSG_BANK_COMING_SOON);
            response.sendRedirect(request.getContextPath() + Views.CHECKOUT_URL);
            return;
        }

        SessionUser user = AuthUtil.currentUser(request);

        // Giữ lại giá trị người dùng đã nhập nếu đơn hàng bị từ chối.
        String fullName = request.getParameter("recipientName");
        String phone = request.getParameter("recipientPhone");
        String address = request.getParameter("shippingAddress");
        String note = request.getParameter("note");
        request.setAttribute("formName", fullName);
        request.setAttribute("formPhone", phone);
        request.setAttribute("formAddress", address);
        request.setAttribute("formNote", note);

        OrderService.PlaceOutcome outcome = orderService.placeCodOrder(
                user.getUserId(), cart, fullName, phone, address, note);

        if (outcome.success()) {
            List<String> ids = new ArrayList<>();
            for (var order : outcome.orders()) {
                ids.add(String.valueOf(order.getOrderId()));
            }
            // Chỉ xóa giỏ sau khi transaction đã commit thành công.
            session.removeAttribute("cart");
            response.sendRedirect(request.getContextPath() + Views.ORDER_SUCCESS_URL
                    + "?ids=" + String.join(",", ids));
            return;
        }

        request.setAttribute("error", outcome.message());
        if (!outcome.fieldErrors().isEmpty()) {
            request.setAttribute("fieldErrors", outcome.fieldErrors());
        }
        prepareForm(request, cart);
        request.getRequestDispatcher(Views.CHECKOUT).forward(request, response);
    }

    // ---------------------------------------------------------------------

    private static Cart currentCart(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (Cart) session.getAttribute("cart");
    }

    /** Tự điền họ tên / điện thoại / địa chỉ mặc định của tài khoản (vẫn sửa được). */
    private void prefillFromProfile(HttpServletRequest request, int userId) {
        try {
            Optional<User> user = userDAO.findById(userId);
            user.ifPresent(u -> {
                request.setAttribute("formName", u.getFullName());
                request.setAttribute("formPhone", u.getPhone());
                request.setAttribute("formAddress", u.getDefaultAddress());
            });
        } catch (SQLException e) {
            getServletContext().log("Không đọc được hồ sơ để điền form thanh toán", e);
        }
    }

    private static void prepareForm(HttpServletRequest request, Cart cart) {
        request.setAttribute("cart", cart);
        request.setAttribute("paymentMethods", PaymentMethod.values());
    }
}
