package com.tmdt.servlet;

import com.tmdt.model.Cart;
import com.tmdt.service.CartService;
import com.tmdt.util.FlashUtil;
import com.tmdt.util.ValidationUtil;
import com.tmdt.util.Views;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * POST /KhachHang/them-vao-gio
 *   productId, materialId (tùy chọn), quantity, redirect (trang quay lại)
 *
 * Giỏ lưu trong HttpSession (không static). Giá/tồn kho do CartService đọc DB.
 * Xong thì PRG: flash thông báo + redirect, refresh không gửi lại POST.
 */
@WebServlet(name = "AddToCartServlet", urlPatterns = Views.ADD_TO_CART_URL)
public class AddToCartServlet extends HttpServlet {

    private final CartService cartService = new CartService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Integer productId = positiveInt(request.getParameter("productId"));
        String back = safeBack(request.getParameter("redirect"));

        if (productId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu mã sản phẩm.");
            return;
        }

        Integer materialId = positiveInt(request.getParameter("materialId"));
        Integer quantity = positiveInt(request.getParameter("quantity"));
        int qty = quantity == null ? 1 : quantity;

        HttpSession session = request.getSession(true);
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
        }

        try {
            CartService.AddOutcome outcome = cartService.add(cart, productId, materialId, qty);
            session.setAttribute("cart", cart);
            if (outcome.status() == CartService.AddStatus.ADDED) {
                FlashUtil.flashSuccess(session, outcome.message());
            } else {
                FlashUtil.flashError(session, outcome.message());
            }
        } catch (IllegalStateException e) {
            getServletContext().log("Lỗi thêm vào giỏ hàng (productId=" + productId + ")", e);
            FlashUtil.flashError(session, "Không thêm được vào giỏ hàng, vui lòng thử lại sau.");
        }

        response.sendRedirect(request.getContextPath() + back);
    }

    /** Chỉ cho phép đường dẫn nội bộ; mặc định về trang danh sách sản phẩm. */
    private static String safeBack(String redirect) {
        return ValidationUtil.isSafeRedirect(redirect) ? redirect : Views.PRODUCT_LIST_URL;
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
