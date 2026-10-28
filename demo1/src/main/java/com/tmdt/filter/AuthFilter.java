package com.tmdt.filter;

import com.tmdt.dao.UserDAO;
import com.tmdt.model.Role;
import com.tmdt.model.SessionUser;
import com.tmdt.model.User;
import com.tmdt.model.UserStatus;
import com.tmdt.service.AuthService;
import com.tmdt.util.JsonUtil;
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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.EnumSet;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.Set;

/**
 * Chặn các khu vực cần đăng nhập / cần vai trò.
 *
 * Bảng quy tắc (tiền tố, không phân biệt hoa thường):
 *   /Admin/*       -> chỉ ADMIN (kèm đọc lại role/status từ DB mỗi request)
 *   /admin/*       -> chỉ ADMIN (API JSON, cũng đọc lại DB)
 *   /NhaCungCap/*  -> SELLER hoặc ADMIN (cũng đọc lại role/status từ DB, nên
 *                     quyền Nhà cung cấp vừa được duyệt có hiệu lực ngay và
 *                     quyền bị thu hồi cũng mất ngay, không cần đăng nhập lại)
 *
 * Chưa đăng nhập: chuyển /login?redirect=<đường dẫn>. Riêng /admin/api/* trả
 * JSON {"error":"..."} với 401 (không redirect) để fetch() xử lý được.
 * Sai quyền: 403 (JSON với API). Tài khoản bị khóa giữa phiên: hủy session và
 * coi như chưa đăng nhập, nên việc khóa có hiệu lực ngay.
 *
 * Thứ tự filter nằm trong web.xml: Encoding -> Csrf -> Auth.
 */
public class AuthFilter implements Filter {

    private static final Logger LOG = LoggerFactory.getLogger(AuthFilter.class);

    private final AuthService authService = new AuthService();
    private final UserDAO userDAO = new UserDAO();

    private static final Set<Role> ADMIN_ONLY = EnumSet.of(Role.ADMIN);
    private static final Set<Role> SELLER_OR_ADMIN = EnumSet.of(Role.SELLER, Role.ADMIN);

    /** prefix luôn viết thường, kết thúc bằng '/'. */
    private record PathRule(String prefix, Set<Role> allowedRoles, boolean recheckFromDb) {
    }

    private static final List<PathRule> RULES = List.of(
            new PathRule("/admin/", ADMIN_ONLY, true),
            new PathRule("/nhacungcap/", SELLER_OR_ADMIN, true)
    );

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        tryAutoLogin(request, response);

        String path = pathOf(request);
        PathRule rule = ruleFor(path);
        if (rule != null) {
            boolean api = isJsonApi(path);
            HttpSession session = request.getSession(false);
            SessionUser user = session == null
                    ? null
                    : (SessionUser) session.getAttribute(SessionUser.SESSION_KEY);

            if (user == null) {
                denySignedOut(request, response, path, api);
                return;
            }

            if (rule.recheckFromDb()) {
                Optional<User> fresh;
                try {
                    fresh = userDAO.findById(user.getUserId());
                } catch (SQLException e) {
                    LOG.error("Protected area: cannot reload account from DB", e);
                    writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                            api, "Hệ thống bận, vui lòng thử lại sau.");
                    return;
                }
                if (fresh.isEmpty() || fresh.get().getStatus() == UserStatus.LOCKED) {
                    // Tài khoản vừa bị khóa/xóa -> phiên cũ mất hiệu lực ngay.
                    session.invalidate();
                    denySignedOut(request, response, path, api);
                    return;
                }
                User dbUser = fresh.get();
                SessionUser refreshed = new SessionUser(
                        dbUser.getUserId(), dbUser.getEmail(), dbUser.getFullName(), dbUser.getRole());
                session.setAttribute(SessionUser.SESSION_KEY, refreshed);
                user = refreshed;
            }

            if (user.getRole() == null || !rule.allowedRoles().contains(user.getRole())) {
                writeError(response, HttpServletResponse.SC_FORBIDDEN, api,
                        "Bạn không có quyền truy cập khu vực này.");
                return;
            }
        }
        chain.doFilter(req, res);
    }

    /** Chưa đăng nhập: API trả 401 JSON, trang thường chuyển về /login. */
    private static void denySignedOut(HttpServletRequest request, HttpServletResponse response,
                                      String path, boolean api) throws IOException {
        if (api) {
            writeError(response, HttpServletResponse.SC_UNAUTHORIZED, true,
                    "Bạn cần đăng nhập để tiếp tục.");
            return;
        }
        String wanted = path + (request.getQueryString() == null
                ? "" : "?" + request.getQueryString());
        String target = Views.LOGIN_URL
                + "?redirect=" + URLEncoder.encode(wanted, StandardCharsets.UTF_8);
        response.sendRedirect(request.getContextPath() + target);
    }

    private static void writeError(HttpServletResponse response, int status,
                                   boolean json, String message) throws IOException {
        response.setStatus(status);
        if (json) {
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(new JsonUtil.Obj().putString("error", message).end());
        } else {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write("<p>" + JsonUtil.escape(message) + "</p>");
        }
    }

    /**
     * Remember-me auto-login (phase 6): khi chưa có SessionUser trong session
     * và có cookie remember-me hợp lệ -> tạo session mới (csrfToken mới) và
     * XOAY VÒNG cookie với token mới từ AuthService. Cookie hết hạn/sai -> xóa
     * cookie khỏi trình duyệt.
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

    private static PathRule ruleFor(String path) {
        String lower = path.toLowerCase(Locale.ROOT);
        for (PathRule rule : RULES) {
            String prefix = rule.prefix();
            if (lower.equals(prefix.substring(0, prefix.length() - 1)) || lower.startsWith(prefix)) {
                return rule;
            }
        }
        return null;
    }

    private static boolean isJsonApi(String path) {
        return path.toLowerCase(Locale.ROOT).startsWith("/admin/api/");
    }

    private static String pathOf(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String ctx = request.getContextPath();
        return uri.startsWith(ctx) ? uri.substring(ctx.length()) : uri;
    }
}
