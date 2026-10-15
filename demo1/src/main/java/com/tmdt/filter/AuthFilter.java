package com.tmdt.filter;

import com.tmdt.model.SessionUser;
import com.tmdt.service.AuthService;
import com.tmdt.util.RememberMeCookie;
import com.tmdt.util.TokenUtil;
import com.tmdt.util.Views;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

/**
 * Protects URLs that require a signed-in session. The protected list starts
 * EMPTY (no auth-only pages exist yet); declare patterns here when a page
 * must be locked behind login, e.g.:
 *
 *   private static final List<String> PROTECTED_PATHS =
 *           List.of("/profile/*",           // any signed-in user
 *                   "/Admin/*",             // example: require a role
 *                   "/NhaCungCap/*");
 *
 * Role checks (when configured) belong to a second mapping table, i.e.
 * path -> allowed Role, judged from SessionUser#getRole().
 *
 * Not signed in -> redirect /login?redirect=<current path> (validated again
 * on the way back by LoginServlet). Filter order lives in web.xml:
 * Encoding -> Csrf -> Auth.
 */
public class AuthFilter implements Filter {

    private final AuthService authService = new AuthService();

    /** Protected page patterns. Starts empty per plan; fill in when needed. */
    private static final List<String> PROTECTED_PATHS = List.of();

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        tryAutoLogin(request, response);

        String path = pathOf(request);
        if (isProtected(path)) {
            HttpSession session = request.getSession(false);
            SessionUser user = session == null
                    ? null
                    : (SessionUser) session.getAttribute(SessionUser.SESSION_KEY);
            if (user == null) {
                String wanted = path + (request.getQueryString() == null
                        ? "" : "?" + request.getQueryString());
                String target = Views.LOGIN_URL
                        + "?redirect=" + URLEncoder.encode(wanted, StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + target);
                return;
            }
            // TODO: role-based rule table (path -> Role) once pages need it.
        }
        chain.doFilter(req, res);
    }

    /**
     * Remember-me auto-login (phase 6): khi chưa có SessionUser trong session
     * và có cookie remember-me hợp lệ -> tạo session mới (csrfToken mới) và
     * XOAY VÒNG cookie với token mới từ AuthService. Cookie hết hạn/sai ->
     * xóa cookie khỏi trình duyệt.
     */
    private void tryAutoLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession existing = request.getSession(false);
        if (existing != null
                && existing.getAttribute(SessionUser.SESSION_KEY) != null) {
            return; // đã đăng nhập, không cần cookie
        }
        RememberMeCookie.get(request).ifPresent(cookie -> {
            var outcome = authService.loginWithRememberToken(cookie.getValue());
            if (outcome.isPresent()) {
                var result = outcome.get();
                HttpSession old = request.getSession(false);
                if (old != null) old.invalidate();
                HttpSession session = request.getSession(true);
                session.setAttribute(SessionUser.SESSION_KEY, result.user());
                session.setAttribute("csrfToken", TokenUtil.generateRawToken());
                RememberMeCookie.set(response, result.newRawToken(), request.isSecure());
            } else {
                RememberMeCookie.clear(response);
            }
        });
    }

    private static boolean isProtected(String path) {
        for (String pattern : PROTECTED_PATHS) {
            if (pattern.endsWith("/*")) {
                String prefix = pattern.substring(0, pattern.length() - 1); // keep trailing '/'
                if (path.equals(pattern.substring(0, pattern.length() - 2))
                        || path.startsWith(prefix)) {
                    return true;
                }
            } else if (path.equals(pattern)) {
                return true;
            }
        }
        return false;
    }

    private static String pathOf(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String ctx = request.getContextPath();
        return uri.startsWith(ctx) ? uri.substring(ctx.length()) : uri;
    }
}
