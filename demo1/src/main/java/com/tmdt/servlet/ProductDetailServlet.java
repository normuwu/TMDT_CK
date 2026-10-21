package com.tmdt.servlet;

import com.tmdt.model.ProductDetail;
import com.tmdt.service.ProductDetailService;
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
import java.util.Optional;

/**
 * GET /KhachHang/chi-tiet-san-pham?id=5
 * Đặt dưới /KhachHang/ để link tương đối trong header/footer vẫn đúng thư mục.
 */
@WebServlet(name = "ProductDetailServlet", urlPatterns = "/KhachHang/chi-tiet-san-pham")
public class ProductDetailServlet extends HttpServlet {

    private final ProductDetailService detailService = new ProductDetailService();

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