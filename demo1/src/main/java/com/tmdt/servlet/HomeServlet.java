package com.tmdt.servlet;

import com.tmdt.service.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

// Nếu project dùng Tomcat 9 trở xuống (javax.servlet), đổi "jakarta." thành "javax." ở các import trên.
@WebServlet(name = "HomeServlet", urlPatterns = {"/trang-chu"})
public class HomeServlet extends HttpServlet {

    private static final int HOME_LIMIT = 8;

    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("newestProducts", productService.newest(HOME_LIMIT));
            req.setAttribute("bestSellingProducts", productService.bestSelling(HOME_LIMIT));
        } catch (IllegalStateException e) {
            // Lỗi DB: vẫn hiển thị trang chủ, chỉ là không có danh sách sản phẩm.
            log("Không tải được sản phẩm cho trang chủ", e);
            req.setAttribute("newestProducts", List.of());
            req.setAttribute("bestSellingProducts", List.of());
        }
        req.getRequestDispatcher("/KhachHang/trang_chu.jsp").forward(req, resp);
    }
}