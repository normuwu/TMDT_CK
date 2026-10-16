package com.tmdt.servlet;

import com.tmdt.service.AuthService;
import com.tmdt.util.FlashUtil;
import com.tmdt.util.Views;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * GET  /forgot-password -> show the request form.
 * POST /forgot-password -> ALWAYS forwards back with sent=true (the same
 * success screen whether or not the email exists — anti account
 * enumeration). Real work happens silently in AuthService (verified
 * accounts only, 60s cooldown, async mail).
 */
@WebServlet(name = "ForgotPasswordServlet", urlPatterns = "/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        FlashUtil.moveToRequest(request);
        request.getRequestDispatcher(Views.FORGOT_PASSWORD).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        authService.requestPasswordReset(request.getParameter("email"));

        // FORWARD (not redirect) so ${param.email} still renders on the page.
        request.setAttribute("sent", Boolean.TRUE);
        request.getRequestDispatcher(Views.FORGOT_PASSWORD).forward(request, response);
    }
}
