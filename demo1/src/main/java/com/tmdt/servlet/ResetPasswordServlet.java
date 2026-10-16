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
import java.util.Map;

/**
 * GET  /reset-password?token=... -> valid token shows the form, otherwise
 *                                  the "invalid link" screen (tokenInvalid).
 * POST /reset-password         -> applies the new password in one transaction;
 *                                  success = PRG to /login with a flash;
 *                                  bad password params = forward back (the
 *                                  token stays valid); expired/used token =
 *                                  tokenInvalid screen.
 */
@WebServlet(name = "ResetPasswordServlet", urlPatterns = "/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("tokenInvalid", !authService.hasValidResetToken(request.getParameter("token")));
        request.getRequestDispatcher(Views.RESET_PASSWORD).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        AuthService.ResetOutcome outcome = authService.resetPassword(token, newPassword, confirmNewPassword);

        switch (outcome.status()) {
            case SUCCESS -> {
                HttpSession session = request.getSession(true);
                FlashUtil.flashSuccess(session, AuthService.MSG_RESET_SUCCESS);
                response.sendRedirect(request.getContextPath() + Views.LOGIN_URL);
            }
            case VALIDATION_ERROR -> {
                Map<String, String> errors = outcome.fieldErrors();
                if (!errors.isEmpty()) {
                    request.setAttribute("errors", errors);
                }
                request.getRequestDispatcher(Views.RESET_PASSWORD).forward(request, response);
            }
            case SYSTEM_ERROR -> {
                request.setAttribute("error", "Hệ thống bận, vui lòng thử lại sau.");
                request.getRequestDispatcher(Views.RESET_PASSWORD).forward(request, response);
            }
            case TOKEN_INVALID -> {
                request.setAttribute("tokenInvalid", Boolean.TRUE);
                request.getRequestDispatcher(Views.RESET_PASSWORD).forward(request, response);
            }
        }
    }
}
