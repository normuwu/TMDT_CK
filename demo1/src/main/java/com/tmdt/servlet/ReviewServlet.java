package com.tmdt.servlet;

import com.tmdt.model.SessionUser;
import com.tmdt.service.ReviewService;
import com.tmdt.util.FlashUtil;
import com.tmdt.util.Views;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * POST /KhachHang/danh-gia-san-pham       : productId, rating, comment
 * POST /KhachHang/danh-gia-nha-cung-cap   : productId (để quay lại), supplierId, rating, comment
 * Cần đăng nhập. Token CSRF do CsrfFilter kiểm tra trước khi tới đây.
 * Xong thì PRG: flash + redirect về trang chi tiết (mục #reviews).
 */
@WebServlet(name = "ReviewServlet",
        urlPatterns = {"/KhachHang/danh-gia-san-pham", "/KhachHang/danh-gia-nha-cung-cap"})
public class ReviewServlet extends HttpServlet {

    private final ReviewService reviewService = new ReviewService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer productId = positiveInt(request.getParameter("productId"));
        if (productId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        String detailPath = Views.PRODUCT_DETAIL_URL + "?id=" + productId;

        HttpSession session = request.getSession(false);
        SessionUser user = session == null ? null : (SessionUser) session.getAttribute(SessionUser.SESSION_KEY);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + Views.LOGIN_URL
                    + "?redirect=" + URLEncoder.encode(detailPath, StandardCharsets.UTF_8));
            return;
        }

        String rating = request.getParameter("rating");
        String comment = request.getParameter("comment");
        boolean forSupplier = request.getServletPath().endsWith("danh-gia-nha-cung-cap");

        ReviewService.Outcome outcome;
        if (forSupplier) {
            Integer supplierId = positiveInt(request.getParameter("supplierId"));
            if (supplierId == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
            outcome = reviewService.reviewSupplier(user.getUserId(), supplierId, rating, comment);
        } else {
            outcome = reviewService.reviewProduct(user.getUserId(), productId, rating, comment);
        }

        if (outcome.success()) {
            FlashUtil.flashSuccess(session, outcome.message());
        } else {
            FlashUtil.flashError(session, outcome.message());
        }
        response.sendRedirect(request.getContextPath() + detailPath + "#reviews");
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