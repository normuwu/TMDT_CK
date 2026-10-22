package com.tmdt.servlet;

import com.tmdt.model.Cart;
import com.tmdt.service.CartService;
import com.tmdt.util.FlashUtil;
import com.tmdt.util.Views;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * GET  /KhachHang/gio-hang : hiển thị giỏ hàng trong session
 * POST /KhachHang/gio-hang : action=update|remove|clear → redirect lại (PRG)
 *
 * Mọi thay đổi đều kiểm tra ở server; giá không lấy từ form.
 */
@WebServlet(name = "CartServlet", urlPatterns = Views.CART_URL)
public class CartServlet extends HttpServlet {

    private final CartService cartService = new CartService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        FlashUtil.moveToRequest(request);
        request.getRequestDispatcher(Views.CART).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(true);
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        String action = request.getParameter("action");
        if ("update".equals(action)) {
            update(request, session, cart);
        } else if ("remove".equals(action)) {
            String key = request.getParameter("key");
            cartService.remove(cart, key == null ? "" : key);
            FlashUtil.flashSuccess(session, "Đã xóa sản phẩm khỏi giỏ hàng.");
        } else if ("clear".equals(action)) {
            cart.clear();
            FlashUtil.flashSuccess(session, "Đã xóa toàn bộ giỏ hàng.");
        }
        response.sendRedirect(request.getContextPath() + Views.CART_URL);
    }

    private void update(HttpServletRequest request, HttpSession session, Cart cart) {
        String key = request.getParameter("key");
        if (key == null || cart.get(key) == null) {
            FlashUtil.flashError(session, "Sản phẩm không có trong giỏ hàng.");
            return;
        }

        // Nút −/+ gửi delta; ô số lượng gửi quantity. Server luôn tính lại từ session.
        Integer quantity;
        Integer delta = integerOrNull(request.getParameter("delta"));
        if (delta != null) {
            int current = cart.get(key).getQuantity();
            quantity = Math.max(1, current + delta);
        } else {
            quantity = positiveInt(request.getParameter("quantity"));
        }
        if (quantity == null) {
            FlashUtil.flashError(session, "Số lượng không hợp lệ.");
            return;
        }
        boolean ok = cartService.updateQuantity(cart, key, quantity);
        if (!ok) {
            var item = cart.get(key);
            String max = item == null ? "" : " (tối đa " + item.getMaxStock() + ")";
            FlashUtil.flashError(session,
                    "Không cập nhật được số lượng" + max + ". Vui lòng kiểm tra lại tồn kho.");
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

    private static Integer integerOrNull(String s) {
        try {
            return Integer.parseInt(s == null ? "" : s.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
