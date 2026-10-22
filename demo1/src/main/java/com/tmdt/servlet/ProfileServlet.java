package com.tmdt.servlet;

import com.tmdt.model.ProfileView;
import com.tmdt.model.SessionUser;
import com.tmdt.model.User;
import com.tmdt.service.ProfileService;
import com.tmdt.util.FlashUtil;
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
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * GET  /profile -> shows the profile form (data always read fresh from the DB).
 * POST /profile -> updates full name / phone / default address of the
 *                  LOGGED-IN user only (user id comes from the session, never
 *                  from the request). Success = PRG with a flash message and
 *                  the header name refreshed; validation errors = forward back.
 *
 * CSRF is checked by CsrfFilter for every POST.
 */
@WebServlet(name = "ProfileServlet", urlPatterns = "/profile")
public class ProfileServlet extends HttpServlet {

    private static final String VIEW = "/WEB-INF/views/profile/profile.jsp";
    private static final String PROFILE_URL = "/profile";

    private final ProfileService profileService = new ProfileService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        SessionUser sessionUser = currentUser(request);
        if (sessionUser == null) {
            redirectToLogin(request, response);
            return;
        }
        User user = loadUser(sessionUser);
        if (user == null) {
            logoutAndRedirect(request, response);
            return;
        }
        FlashUtil.moveToRequest(request);
        render(request, response, user, formFrom(user), null, null);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        SessionUser sessionUser = currentUser(request);
        if (sessionUser == null) {
            redirectToLogin(request, response);
            return;
        }

        // Whitelist: only these three parameters are ever read.
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String defaultAddress = request.getParameter("defaultAddress");

        ProfileService.UpdateOutcome outcome =
                profileService.update(sessionUser.getUserId(), fullName, phone, defaultAddress);

        switch (outcome.status()) {
            case SUCCESS -> {
                User u = outcome.user();
                HttpSession session = request.getSession(false);
                // Refresh the session user so the header shows the new name immediately.
                session.setAttribute(SessionUser.SESSION_KEY,
                        new SessionUser(u.getUserId(), u.getEmail(), u.getFullName(), u.getRole()));
                FlashUtil.flashSuccess(session, ProfileService.MSG_SAVED);
                response.sendRedirect(request.getContextPath() + PROFILE_URL);
            }
            case VALIDATION_ERROR -> {
                User user = loadUser(sessionUser);
                if (user == null) {
                    logoutAndRedirect(request, response);
                    return;
                }
                render(request, response, user, formFromParams(fullName, phone, defaultAddress),
                        outcome.fieldErrors(), null);
            }
            case NOT_FOUND -> logoutAndRedirect(request, response);
            case SYSTEM_ERROR -> {
                User user = loadUser(sessionUser);
                if (user == null) {
                    logoutAndRedirect(request, response);
                    return;
                }
                render(request, response, user, formFromParams(fullName, phone, defaultAddress),
                        null, "Hệ thống bận, vui lòng thử lại sau.");
            }
        }
    }

    // ------------------------------------------------------------------

    private void render(HttpServletRequest request, HttpServletResponse response, User user,
                        Map<String, String> form, Map<String, String> errors, String error)
            throws ServletException, IOException {
        request.setAttribute("profile", ProfileView.from(user));
        request.setAttribute("homeUrl", Views.homeFor(user.getRole()));
        request.setAttribute("form", form);
        if (errors != null && !errors.isEmpty()) {
            request.setAttribute("errors", errors);
        }
        if (error != null) {
            request.setAttribute("error", error);
        }
        request.getRequestDispatcher(VIEW).forward(request, response);
    }

    private User loadUser(SessionUser sessionUser) throws ServletException {
        try {
            return profileService.load(sessionUser.getUserId());
        } catch (SQLException e) {
            throw new ServletException("Cannot load profile", e);
        }
    }

    private static SessionUser currentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object value = session.getAttribute(SessionUser.SESSION_KEY);
        return value instanceof SessionUser ? (SessionUser) value : null;
    }

    private static void redirectToLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.sendRedirect(request.getContextPath() + Views.LOGIN_URL
                + "?redirect=" + URLEncoder.encode(PROFILE_URL, StandardCharsets.UTF_8));
    }

    private static void logoutAndRedirect(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        redirectToLogin(request, response);
    }

    private static Map<String, String> formFrom(User user) {
        return formFromParams(user.getFullName(), user.getPhone(), user.getDefaultAddress());
    }

    private static Map<String, String> formFromParams(String fullName, String phone, String defaultAddress) {
        Map<String, String> form = new LinkedHashMap<>();
        form.put("fullName", fullName == null ? "" : fullName);
        form.put("phone", phone == null ? "" : phone);
        form.put("defaultAddress", defaultAddress == null ? "" : defaultAddress);
        return form;
    }
}