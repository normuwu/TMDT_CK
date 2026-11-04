package com.tmdt.servlet;

import com.tmdt.dao.UserDAO;
import com.tmdt.model.Cart;
import com.tmdt.model.Role;
import com.tmdt.model.SessionUser;
import com.tmdt.model.User;
import com.tmdt.model.UserStatus;
import com.tmdt.util.DBConnection;
import com.tmdt.util.TokenUtil;
import com.tmdt.util.Views;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.util.Optional;

@WebServlet("/facebook-login")
public class FacebookLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String name = request.getParameter("name");

        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + Views.LOGIN_URL + "?error=missing_email");
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();
            Optional<User> userOpt = userDAO.findByEmail(email);

            User user;
            if (userOpt.isEmpty()) {
                user = new User();
                user.setEmail(email);
                user.setFullName(name != null ? name : "Facebook User");
                user.setPasswordHash("FACEBOOK_AUTH_NO_PASSWORD");
                user.setRole(Role.CUSTOMER);
                user.setEmailVerified(true);
                user.setStatus(UserStatus.ACTIVE);

                try (Connection conn = DBConnection.getConnection()) {
                    userDAO.insert(conn, user);
                }
            } else {
                user = userOpt.get();
            }

            // 1. Giữ lại Cart cũ & tái tạo Session chống Session Fixation
            HttpSession oldSession = request.getSession(false);
            Cart guestCart = oldSession == null ? null : (Cart) oldSession.getAttribute("cart");
            if (oldSession != null) {
                oldSession.invalidate();
            }

            // 2. Tạo Session mới
            HttpSession session = request.getSession(true);
            if (guestCart != null) {
                session.setAttribute("cart", guestCart);
            }

            // 3. Set SessionUser đúng key SESSION_KEY ("currentUser")
            SessionUser sessionUser = new SessionUser(
                    user.getUserId(),
                    user.getEmail(),
                    user.getFullName(),
                    user.getRole()
            );
            session.setAttribute(SessionUser.SESSION_KEY, sessionUser);

            // 4. Cấp CSRF Token mới
            session.setAttribute("csrfToken", TokenUtil.generateRawToken());

            // 5. Chuyển hướng tới trang chủ tương ứng với Role
            String target = Views.homeFor(user.getRole());
            response.sendRedirect(request.getContextPath() + target);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + Views.LOGIN_URL + "?error=server_error");
        }
    }
}