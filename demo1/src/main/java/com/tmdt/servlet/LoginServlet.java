package com.tmdt.servlet;

import com.tmdt.model.SessionUser;
import com.tmdt.service.AuthService;
import com.tmdt.util.ClientIpUtil;
import com.tmdt.util.FlashUtil;
import com.tmdt.util.RememberMeCookie;
import com.tmdt.util.TokenUtil;
import com.tmdt.util.ValidationUtil;
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
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * GET /login  -> logged in: redirect role home; otherwise render login.jsp.
 * POST /login -> AuthService decides (throttle / wrong creds / locked /
 *                unverified / success). Success rebuilds the session (guards
 *                against session fixation), stores SessionUser under
 *                "currentUser" and redirects to a validated internal target.
 */
@WebServlet(name = "LoginServlet", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        if (redirectHomeIfLoggedIn(request, response)) {
            return;
        }
        FlashUtil.moveToRequest(request);
        request.getRequestDispatcher(Views.LOGIN).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");

        String identifier = trim(request.getParameter("identifier"));
        String password = request.getParameter("password");
        String redirectParam = trim(request.getParameter("redirect"));

        // Field-level validation first (does NOT count as a brute-force try).
        Map<String, String> errors = new LinkedHashMap<>();
        if (identifier.isEmpty()) errors.put("identifier", "Vui lòng nhập email.");
        if (password == null || password.isEmpty()) errors.put("password", "Vui lòng nhập mật khẩu.");
        if (!errors.isEmpty()) {
            renderFailure(request, response, errors, null, false);
            return;
        }

        String throttleKey = identifier.toLowerCase() + "|" + ClientIpUtil.getIp(request);
        AuthService.LoginOutcome outcome = authService.login(identifier, password, throttleKey);

        switch (outcome.status()) {
            case THROTTLED -> renderFailure(request, response, null,
                    "Bạn đã thử quá nhiều lần. Vui lòng thử lại sau 5 phút.", false);
            case WRONG_CREDENTIALS -> renderFailure(request, response, null,
                    "Email hoặc mật khẩu không đúng.", false);
            case LOCKED -> renderFailure(request, response, null,
                    "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.", false);
            case NOT_VERIFIED -> renderFailure(request, response, null,
                    "Tài khoản chưa được xác minh email.", true);
            case SUCCESS -> {
                HttpSession old = request.getSession(false);
                if (old != null) old.invalidate();

                HttpSession session = request.getSession(true);
                session.setAttribute(SessionUser.SESSION_KEY, outcome.user());
                // Fresh CSRF token for the new session.
                session.setAttribute("csrfToken", TokenUtil.generateRawToken());

                // "Ghi nhớ đăng nhập": chỉ cấp cookie khi được tick; lỗi tạo
                // token KHÔNG làm hỏng đăng nhập (createRememberToken trả null).
                if ("on".equals(request.getParameter("remember"))) {
                    String rawToken = authService.createRememberToken(outcome.user().getUserId());
                    if (rawToken != null) {
                        RememberMeCookie.set(response, rawToken, request.isSecure());
                    }
                }

                String target = ValidationUtil.isSafeRedirect(redirectParam)
                        ? redirectParam
                        : Views.homeFor(outcome.user().getRole());
                response.sendRedirect(request.getContextPath() + target);
            }
        }
    }

    private void renderFailure(HttpServletRequest request, HttpServletResponse response,
                               Map<String, String> errors, String error, boolean showResend)
            throws ServletException, IOException {
        if (errors != null) request.setAttribute("errors", errors);
        if (error != null) request.setAttribute("error", error);
        request.setAttribute("showResend", showResend);
        request.getRequestDispatcher(Views.LOGIN).forward(request, response);
    }

    /** Shared by /login and /register: already signed in -> send to role home. */
    public static boolean redirectHomeIfLoggedIn(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        SessionUser user = session == null ? null : (SessionUser) session.getAttribute(SessionUser.SESSION_KEY);
        if (user == null) {
            return false;
        }
        response.sendRedirect(request.getContextPath() + Views.homeFor(user.getRole()));
        return true;
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
