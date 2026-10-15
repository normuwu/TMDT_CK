package com.tmdt.servlet;

import com.tmdt.service.AuthService;
import com.tmdt.util.FlashUtil;
import com.tmdt.util.Views;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * POST /resend-verification (identifier) -> always responds with the same
 * generic message; real actions run only for an existing, unverified account
 * and are rate-limited by AuthService (60s cooldown).
 */
@WebServlet(name = "ResendVerificationServlet", urlPatterns = "/resend-verification")
public class ResendVerificationServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        authService.resendVerification(request.getParameter("identifier"));

        HttpSession session = request.getSession(true);
        FlashUtil.flashSuccess(session, AuthService.MSG_RESEND_GENERIC);
        response.sendRedirect(request.getContextPath() + Views.LOGIN_URL);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // No UI for GET: bounce to the login page.
        response.sendRedirect(request.getContextPath() + Views.LOGIN_URL);
    }
}
