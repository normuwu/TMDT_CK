package com.tmdt.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * GET /KhachHang/gio-hang-fragment
 *
 * Chỉ render lại ngăn kéo giỏ (cart-drawer.jsp) từ session, để cart-ajax.js
 * thay thế #cartDrawer sau khi thêm hàng mà không reload cả trang.
 * GET nên không cần CSRF; dữ liệu chỉ đọc từ session của chính người dùng.
 */
@WebServlet(name = "CartFragmentServlet", urlPatterns = "/KhachHang/gio-hang-fragment")
public class CartFragmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Cache-Control", "no-store");
        request.getRequestDispatcher("/WEB-INF/views/common/cart-drawer.jsp")
                .forward(request, response);
    }
}
