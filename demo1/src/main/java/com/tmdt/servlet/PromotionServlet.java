package com.tmdt.servlet;

import com.tmdt.model.Cart;
import com.tmdt.model.Promotion;
import com.tmdt.service.PromotionService;
import com.tmdt.util.AuthUtil;
import com.tmdt.util.FlashUtil;
import com.tmdt.util.Views;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * POST /KhachHang/khuyen-mai  (action = apply | remove)
 *
 * - Áp dụng: kiểm tra mã ở server (PromotionService), chỉ lưu CODE vào session.
 *   Số tiền giảm KHÔNG nhận từ form; mỗi lần hiển thị/đặt hàng đều tính lại.
 * - Bỏ mã: xóa code khỏi session.
 * Xong luôn redirect về trang thanh toán (Post/Redirect/Get).
 * CSRF do CsrfFilter kiểm tra trước khi request tới đây.
 */
@WebServlet(name = "PromotionServlet", urlPatterns = Views.PROMOTION_URL)
public class PromotionServlet extends HttpServlet {

    private final PromotionService promotionService = new PromotionService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (AuthUtil.requireLogin(request, response, Views.CHECKOUT_URL)) {
            return;
        }
        HttpSession session = request.getSession(true);
        Cart cart = (Cart) session.getAttribute("cart");
        String action = request.getParameter("action");

        if ("remove".equals(action)) {
            session.removeAttribute(PromotionService.SESSION_KEY);
            FlashUtil.flashSuccess(session, "Đã bỏ mã khuyến mãi.");
            response.sendRedirect(request.getContextPath() + Views.CHECKOUT_URL);
            return;
        }

        if (!"apply".equals(action)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thao tác không hợp lệ.");
            return;
        }

        if (cart == null || cart.isEmpty()) {
            session.removeAttribute(PromotionService.SESSION_KEY);
            FlashUtil.flashError(session, "Giỏ hàng đang trống, chưa áp dụng được mã khuyến mãi.");
            response.sendRedirect(request.getContextPath() + Views.CART_URL);
            return;
        }

        String rawCode = request.getParameter("code");
        if (rawCode == null || rawCode.isBlank()) {
            session.removeAttribute(PromotionService.SESSION_KEY);
            FlashUtil.flashError(session, "Vui lòng nhập mã khuyến mãi.");
            response.sendRedirect(request.getContextPath() + Views.CHECKOUT_URL);
            return;
        }

        PromotionService.Preview preview;
        try {
            preview = promotionService.preview(rawCode, cart);
        } catch (IllegalStateException e) {
            getServletContext().log("Lỗi kiểm tra mã khuyến mãi", e);
            FlashUtil.flashError(session, "Không kiểm tra được mã khuyến mãi, vui lòng thử lại sau.");
            response.sendRedirect(request.getContextPath() + Views.CHECKOUT_URL);
            return;
        }

        if (!preview.valid()) {
            session.removeAttribute(PromotionService.SESSION_KEY);
            FlashUtil.flashError(session, preview.message());
            response.sendRedirect(request.getContextPath() + Views.CHECKOUT_URL);
            return;
        }

        Promotion promotion = preview.promotion();
        session.setAttribute(PromotionService.SESSION_KEY, promotion.getCode());
        FlashUtil.flashSuccess(session, "Đã áp dụng mã " + promotion.getCode()
                + " (" + promotion.getDiscountLabel() + "), giảm "
                + PromotionService.formatVnd(preview.discount()) + " cho đơn hàng.");
        response.sendRedirect(request.getContextPath() + Views.CHECKOUT_URL);
    }
}
