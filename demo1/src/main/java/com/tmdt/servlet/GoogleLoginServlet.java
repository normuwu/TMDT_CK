package com.tmdt.servlet;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
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
import java.util.Collections;
import java.util.Optional;

@WebServlet("/google-login")
public class GoogleLoginServlet extends HttpServlet {

    // THAY CLIENT_ID CỦA BẠN VÀO ĐÂY
    private static final String CLIENT_ID = "1018661876708-10lju5b03u9m4tf11ifgijjtfs6aqhn7.apps.googleusercontent.com";
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idTokenString = request.getParameter("credential");

        if (idTokenString == null) {
            response.sendRedirect(request.getContextPath() + Views.LOGIN_URL + "?error=missing_token");
            return;
        }

        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(), new GsonFactory())
                .setAudience(Collections.singletonList(CLIENT_ID))
                .build();

        try {
            GoogleIdToken idToken = verifier.verify(idTokenString);

            if (idToken != null) {
                GoogleIdToken.Payload payload = idToken.getPayload();

                String email = payload.getEmail();
                String name = (String) payload.get("name");

                UserDAO userDAO = new UserDAO();
                Optional<User> userOpt = userDAO.findByEmail(email);

                User user;
                if (userOpt.isEmpty()) {
                    user = new User();
                    user.setEmail(email);
                    user.setFullName(name);
                    user.setPasswordHash("GOOGLE_AUTH_NO_PASSWORD");
                    user.setRole(Role.CUSTOMER);
                    user.setEmailVerified(true);
                    user.setStatus(UserStatus.ACTIVE);

                    try (Connection conn = DBConnection.getConnection()) {
                        userDAO.insert(conn, user);
                    }
                } else {
                    user = userOpt.get();
                }

                // 1. Giữ lại Giỏ hàng khách (Guest Cart) và tái tạo Session (Chống Session Fixation)
                HttpSession oldSession = request.getSession(false);
                Cart guestCart = oldSession == null ? null : (Cart) oldSession.getAttribute("cart");
                if (oldSession != null) {
                    oldSession.invalidate();
                }

                // 2. TẠO SESSION MỚI
                HttpSession session = request.getSession(true);
                if (guestCart != null) {
                    session.setAttribute("cart", guestCart);
                }

                // 3. Khởi tạo SessionUser và lưu với đúng Key "currentUser" (SessionUser.SESSION_KEY)
                SessionUser sessionUser = new SessionUser(
                        user.getUserId(),
                        user.getEmail(),
                        user.getFullName(),
                        user.getRole()
                );
                session.setAttribute(SessionUser.SESSION_KEY, sessionUser);

                // 4. Cấp CSRF Token mới cho Session
                session.setAttribute("csrfToken", TokenUtil.generateRawToken());

                // 5. Chuyển hướng tới trang chủ tương ứng với Role của user
                String target = Views.homeFor(user.getRole());
                response.sendRedirect(request.getContextPath() + target);

            } else {
                response.sendRedirect(request.getContextPath() + Views.LOGIN_URL + "?error=invalid_token");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + Views.LOGIN_URL + "?error=server_error");
        }
    }
}