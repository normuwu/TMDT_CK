package com.tmdt.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Header bảo mật cho mọi response (phòng thủ theo chiều sâu):
 *  - X-Content-Type-Options: chặn trình duyệt tự đoán MIME
 *  - X-Frame-Options + frame-ancestors: chống clickjacking
 *  - Referrer-Policy / Permissions-Policy: giảm rò rỉ dữ liệu
 *  - HSTS: chỉ gửi khi request đã là HTTPS
 *  - CSP: lớp giảm thiểu tác động của XSS
 *
 * CSP còn 'unsafe-inline' vì các JSP hiện dùng <style>/<script> inline.
 * Đây là điểm cần siết tiếp bằng nonce khi tách hết JS ra file riêng.
 *
 * Danh sách nguồn ngoài bám theo code thật:
 *  - cdnjs.cloudflare.com: three.js ở dat_in_3d.jsp
 *  - accounts.google.com + connect.facebook.net: nút đăng nhập ở login.jsp
 *  - fonts.googleapis.com / fonts.gstatic.com: font của giao diện
 */
public class SecurityHeadersFilter implements Filter {

    private static final String CSP =
            "default-src 'self'; "
          + "img-src 'self' data: https:; "
          + "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://accounts.google.com; "
          + "font-src 'self' data: https://fonts.gstatic.com; "
          + "script-src 'self' 'unsafe-inline' https://cdnjs.cloudflare.com "
          + "https://accounts.google.com https://connect.facebook.net "
          + "https://www.google.com https://www.gstatic.com; "
          + "connect-src 'self' https://accounts.google.com https://www.facebook.com; "
          + "frame-src 'self' https://accounts.google.com https://www.facebook.com; "
          + "form-action 'self' https://sandbox.vnpayment.vn https://vnpayment.vn; "
          + "base-uri 'self'; "
          + "frame-ancestors 'self'; "
          + "object-src 'none'";

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletResponse response = (HttpServletResponse) res;
        HttpServletRequest request = (HttpServletRequest) req;

        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("X-Frame-Options", "SAMEORIGIN");
        response.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
        response.setHeader("Permissions-Policy", "geolocation=(), microphone=(), camera=()");
        response.setHeader("Content-Security-Policy", CSP);

        if (request.isSecure()) {
            response.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");
        }
        chain.doFilter(req, res);
    }
}
