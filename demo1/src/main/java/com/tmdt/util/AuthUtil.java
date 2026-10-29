package com.tmdt.util;

import com.tmdt.model.Role;
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
     * Như {@link #requireLogin} nhưng còn kiểm tra vai trò (lấy từ session).
     * Sai vai trò → 403, không lộ nội dung trang.
     *
     * @return true nếu đã redirect/sendError (caller phải return ngay)
     */
    public static boolean requireRole(HttpServletRequest request, HttpServletResponse response,
                                      String target, Role... allowed) throws IOException {
        if (requireLogin(request, response, target)) {
            return true;
        }
        SessionUser user = currentUser(request);
        for (Role role : allowed) {
            if (user.getRole() == role) {
                return false;
            }
        }
        response.sendError(HttpServletResponse.SC_FORBIDDEN,
                "Bạn không có quyền truy cập trang này.");
        return true;
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
