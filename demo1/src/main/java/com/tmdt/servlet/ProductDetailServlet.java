package com.tmdt.servlet;

import com.tmdt.dao.ProductViewDAO;
import com.tmdt.model.ProductDetail;
import com.tmdt.model.SessionUser;
import com.tmdt.service.ProductDetailService;
import com.tmdt.service.ProductService;
import com.tmdt.service.ReviewService;
import com.tmdt.util.AuthUtil;
import com.tmdt.util.FlashUtil;
import com.tmdt.util.Views;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.Optional;

/**
 * GET /KhachHang/chi-tiet-san-pham?id=5
 * Đặt dưới /KhachHang/ để link tương đối trong header/footer vẫn đúng thư mục.
 */
@WebServlet(name = "ProductDetailServlet", urlPatterns = "/KhachHang/chi-tiet-san-pham")
public class ProductDetailServlet extends HttpServlet {

    private final ProductDetailService detailService = new ProductDetailService();
    private final ReviewService reviewService = new ReviewService();
    private final ProductService productService = new ProductService();
    private final ProductViewDAO productViewDAO = new ProductViewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        FlashUtil.moveToRequest(request);

        Integer id = positiveInt(request.getParameter("id"));
        if (id == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sản phẩm.");
            return;
        }

        Optional<ProductDetail> found;
        try {
            found = detailService.find(id);
        } catch (IllegalStateException e) {
            getServletContext().log("Lỗi tải chi tiết sản phẩm " + id, e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Hệ thống đang bận, vui lòng thử lại sau.");
            return;
        }
        if (found.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Sản phẩm không tồn tại hoặc đã ngừng bán.");
            return;
        }

        // Chỉ hiện form đánh giá khi tài khoản đã mua + đơn đã giao thành công.
        // Server kiểm tra lại lần nữa trong ReviewService khi nhận POST.
        SessionUser user = AuthUtil.currentUser(request);
        boolean canReview = user != null
                && reviewService.canReviewProduct(user.getUserId(), id);
        request.setAttribute("canReview", canReview);
        if (user != null && !canReview) {
            request.setAttribute("reviewNotice", ReviewService.MSG_NOT_PURCHASED);
        }

        // Ghi nhận lượt xem + tính gợi ý. Đây là tính năng phụ: mọi lỗi chỉ log,
        // tuyệt đối không làm hỏng trang chi tiết sản phẩm.
        Integer userId = user == null ? null : user.getUserId();
        try {
            productViewDAO.record(userId, request.getSession(true).getId(), id);
            request.setAttribute("recommended", productService.recommendationsFor(userId, id));
        } catch (SQLException | IllegalStateException e) {
            getServletContext().log("Không tải được gợi ý sản phẩm (productId=" + id + ")", e);
        }

        String back = Views.PRODUCT_DETAIL_URL + "?id=" + id;
        request.setAttribute("product", found.get());
        // Link đăng nhập quay lại đúng trang này sau khi đăng nhập xong.
        request.setAttribute("loginUrl", request.getContextPath() + Views.LOGIN_URL
                + "?redirect=" + URLEncoder.encode(back, StandardCharsets.UTF_8));
        request.getRequestDispatcher(Views.PRODUCT_DETAIL).forward(request, response);
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