package com.tmdt.util;

import com.tmdt.model.SessionUser;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Tiện ích dùng chung cho các servlet cần đăng nhập (giỏ hàng/đặt hàng).
 * Chỉ đọc SessionUser do LoginServlet/AuthFilter đặt vào session — không tự
 * tạo hay giả mạo tài khoản.
 */
public final class AuthUtil {

    private AuthUtil() {
    }

    public static SessionUser currentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null
                ? null
                : (SessionUser) session.getAttribute(SessionUser.SESSION_KEY);
    }

    /**
     * Chưa đăng nhập → redirect /login?redirect=<trang hiện tại>.
     * LoginServlet sẽ kiểm tra lại redirect này bằng ValidationUtil.isSafeRedirect.
     *
     * @return true nếu đã redirect (caller phải return ngay)
     */
    public static boolean requireLogin(HttpServletRequest request, HttpServletResponse response,
                                       String target) throws IOException {
        if (currentUser(request) != null) {
            return false;
        }
        String redirect = target == null ? Views.CART_URL : target;
        response.sendRedirect(request.getContextPath() + Views.LOGIN_URL
                + "?redirect=" + URLEncoder.encode(redirect, StandardCharsets.UTF_8));
        return true;
    }
}
