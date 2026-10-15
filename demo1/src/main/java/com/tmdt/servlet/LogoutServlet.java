package com.tmdt.servlet;

import com.tmdt.model.SessionUser;
import com.tmdt.service.AuthService;
import com.tmdt.util.RememberMeCookie;
import com.tmdt.util.Views;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * POST /logout -> revoke every REMEMBER_ME token of the user, delete the
 * remember-me cookie, invalidate the session (CSRF is enforced by
 * CsrfFilter), then redirect to /login.
 * GET  /logout -> does NOT log out, just goes to the home page (the HTML
 * snippet for the logout button lives in docs/LOGIN_LOGOUT_GUIDE.md).
 */
@WebServlet(name = "LogoutServlet", urlPatterns = "/logout")
public class LogoutServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        SessionUser user = session == null
                ? null
                : (SessionUser) session.getAttribute(SessionUser.SESSION_KEY);
        if (user != null) {
            authService.revokeRememberTokens(user.getUserId());
        }
        RememberMeCookie.clear(response);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + Views.LOGIN_URL);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // Not a logout: bounce to the home page for the DEFAULT role instead.
        response.sendRedirect(request.getContextPath() + Views.HOME_CUSTOMER);
    }
}
