package com.tmdt.servlet;

import com.tmdt.service.AuthService;
import com.tmdt.util.Views;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * GET /verify-email?token=... -> try the EMAIL_VERIFICATION token, then
 * always forward verify-result.jsp with verified=true/false.
 */
@WebServlet(name = "VerifyEmailServlet", urlPatterns = "/verify-email")
public class VerifyEmailServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthService.VerifyOutcome outcome = authService.verifyEmail(request.getParameter("token"));
        request.setAttribute("verified", outcome.verified());
        request.getRequestDispatcher(Views.VERIFY_RESULT).forward(request, response);
    }
}
