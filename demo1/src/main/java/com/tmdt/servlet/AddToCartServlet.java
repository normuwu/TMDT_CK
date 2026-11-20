package com.tmdt.servlet;

import com.tmdt.model.Cart;
import com.tmdt.service.CartService;
import com.tmdt.util.FlashUtil;
import com.tmdt.util.JsonUtil;
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
 *
 * Hai luồng trả về:
 *  - Submit thường (progressive enhancement): PRG — flash + redirect.
 *  - AJAX (Accept: application/json hoặc ajax=1): JSON để JS cập nhật badge/toast
 *    mà không reload trang. Nhận diện bằng header Accept vì CsrfFilter đang dùng
 *    X-Requested-With để chứa CSRF token.
 */
@WebServlet(name = "AddToCartServlet", urlPatterns = Views.ADD_TO_CART_URL)
public class AddToCartServlet extends HttpServlet {

    private final CartService cartService = new CartService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        boolean ajax = wantsJson(request);

        Integer productId = positiveInt(request.getParameter("productId"));
        String back = safeBack(request.getParameter("redirect"));

        if (productId == null) {
            if (ajax) {
                writeJson(response, HttpServletResponse.SC_BAD_REQUEST, new JsonUtil.Obj()
                        .putBoolean("ok", false)
                        .putString("message", "Thiếu mã sản phẩm.")
                        .end());
                return;
            }
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

        CartService.AddOutcome outcome;
        try {
            outcome = cartService.add(cart, productId, materialId, qty);
            session.setAttribute("cart", cart);
            // Flash chỉ dành cho luồng redirect; AJAX đã có JSON nên không set.
            if (!ajax) {
                if (outcome.status() == CartService.AddStatus.ADDED) {
                    FlashUtil.flashSuccess(session, outcome.message());
                } else {
                    FlashUtil.flashError(session, outcome.message());
                }
            }
        } catch (IllegalStateException e) {
            getServletContext().log("Lỗi thêm vào giỏ hàng (productId=" + productId + ")", e);
            if (ajax) {
                writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, new JsonUtil.Obj()
                        .putBoolean("ok", false)
                        .putString("message", "Không thêm được vào giỏ hàng, vui lòng thử lại sau.")
                        .end());
                return;
            }
            FlashUtil.flashError(session, "Không thêm được vào giỏ hàng, vui lòng thử lại sau.");
            response.sendRedirect(request.getContextPath() + back);
            return;
        }

        if (ajax) {
            writeJson(response, HttpServletResponse.SC_OK, new JsonUtil.Obj()
                    .putBoolean("ok", outcome.status() == CartService.AddStatus.ADDED)
                    .putString("status", outcome.status().name())
                    .putString("message", outcome.message())
                    .putNumber("cartCount", cart.getItemCount())
                    .putNumber("cartTotal", cart.getTotal())
                    .end());
            return;
        }

        response.sendRedirect(request.getContextPath() + back);
    }

    /** AJAX nếu client xin JSON (không dùng X-Requested-With: header đó là CSRF token). */
    private static boolean wantsJson(HttpServletRequest request) {
        String accept = request.getHeader("Accept");
        return "1".equals(request.getParameter("ajax"))
                || (accept != null && accept.contains("application/json"));
    }

    private static void writeJson(HttpServletResponse response, int status, String json)
            throws IOException {
        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-store");
        response.getWriter().write(json);
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
