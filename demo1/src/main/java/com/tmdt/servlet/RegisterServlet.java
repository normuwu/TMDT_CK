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
 * GET  /register  -> show the registration form (auth/register.jsp).
 * POST /register  -> validate + create user + EMAIL_VERIFICATION token in one
 *                    transaction; success = PRG redirect to /login with a
 *                    flash message, failure = forward back with field errors.
 */
@WebServlet(name = "RegisterServlet", urlPatterns = "/register")
public class RegisterServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Người đã đăng nhập mà vào /register -> về trang theo role (plan 7.3).
        if (LoginServlet.redirectHomeIfLoggedIn(request, response)) {
            return;
        }
        FlashUtil.moveToRequest(request);
        request.getRequestDispatcher(Views.REGISTER).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        boolean agreeTerms = request.getParameter("agreeTerms") != null;

        AuthService.RegisterOutcome outcome =
                authService.register(fullName, email, phone, password, confirmPassword, agreeTerms);

        if (outcome.success()) {
            HttpSession session = request.getSession(true);
            FlashUtil.flashSuccess(session, AuthService.MSG_REGISTER_SUCCESS);
            response.sendRedirect(request.getContextPath() + Views.LOGIN_URL);
            return;
        }

        // Failure: forward so the form keeps the typed values via ${param...}.
        Map<String, String> errors = outcome.fieldErrors();
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            // Show the first non-field message as a general error when present.
            String general = errors.get("system");
            if (general != null) {
                request.setAttribute("error", general);
            }
        }
        request.getRequestDispatcher(Views.REGISTER).forward(request, response);
    }
}
