package com.tmdt.servlet;

import com.tmdt.model.ProfileView;
import com.tmdt.model.Role;
import com.tmdt.model.SessionUser;
import com.tmdt.model.SupplierRequest;
import com.tmdt.model.SupplierRequestStatus;
import com.tmdt.model.SupplierRequestView;
import com.tmdt.model.User;
import com.tmdt.service.SupplierRequestService;
import com.tmdt.util.AuthUtil;
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
import java.util.Optional;

/**
 * GET  /xin-lam-nha-cung-cap -> form "Xin làm Nhà cung cấp" + trạng thái yêu
 *                               cầu mới nhất (PENDING / REJECTED / APPROVED).
 * POST /xin-lam-nha-cung-cap -> tạo yêu cầu mới ở trạng thái PENDING.
 *
 * Chỉ CUSTOMER đang ACTIVE mới dùng được trang này:
 *   - chưa đăng nhập  -> /login?redirect=...
 *   - SELLER          -> trang Nhà cung cấp (đã là NCC)
 *   - ADMIN           -> trang quản trị
 * Role/status/userId KHÔNG bao giờ đọc từ request: userId lấy từ session,
 * role đọc lại từ DB trong service. CSRF do CsrfFilter kiểm tra.
 */
@WebServlet(name = "SupplierRequestServlet", urlPatterns = "/xin-lam-nha-cung-cap")
public class SupplierRequestServlet extends HttpServlet {

    private static final String VIEW = "/WEB-INF/views/supplier/yeu-cau-nha-cung-cap.jsp";
    private static final String REQUEST_URL = "/xin-lam-nha-cung-cap";

    private static final String MSG_DUPLICATE =
            "Bạn đã có một yêu cầu đang chờ duyệt. Vui lòng chờ Admin phản hồi.";
    private static final String MSG_NOT_ELIGIBLE =
            "Tài khoản hiện tại không thể gửi yêu cầu trở thành Nhà cung cấp.";
    private static final String MSG_SYSTEM_ERROR = "Hệ thống bận, vui lòng thử lại sau.";

    private final SupplierRequestService service = new SupplierRequestService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        SessionUser sessionUser = AuthUtil.currentUser(request);
        if (sessionUser == null) {
            redirectToLogin(request, response);
            return;
        }
        User user = loadUser(sessionUser.getUserId());
        if (user == null) {
            logoutAndRedirect(request, response);
            return;
        }
        if (redirectIfNotCustomer(request, response, user)) {
            return;
        }

        Optional<SupplierRequest> latest = latestOrNull(user.getUserId());
        FlashUtil.moveToRequest(request);
        render(request, response, user, latest.orElse(null),
                formDefaults(user, latest.orElse(null)), null, null);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        SessionUser sessionUser = AuthUtil.currentUser(request);
        if (sessionUser == null) {
            redirectToLogin(request, response);
            return;
        }
        User user = loadUser(sessionUser.getUserId());
        if (user == null) {
            logoutAndRedirect(request, response);
            return;
        }
        if (redirectIfNotCustomer(request, response, user)) {
            return;
        }

        // Whitelist: chỉ 4 trường của form, không đọc role/status từ request.
        String shopName = request.getParameter("shopName");
        String contactPhone = request.getParameter("contactPhone");
        String address = request.getParameter("address");
        String description = request.getParameter("description");

        SupplierRequestService.SubmitOutcome outcome = service.submit(
                sessionUser.getUserId(), shopName, contactPhone, address, description);

        switch (outcome.status()) {
            case SUCCESS -> {
                flashSuccess(request, SupplierRequestService.MSG_SENT);
                response.sendRedirect(request.getContextPath() + REQUEST_URL);
            }
            case DUPLICATE -> {
                flashError(request, MSG_DUPLICATE);
                response.sendRedirect(request.getContextPath() + REQUEST_URL);
            }
            case NOT_ELIGIBLE -> {
                flashError(request, MSG_NOT_ELIGIBLE);
                response.sendRedirect(request.getContextPath() + REQUEST_URL);
            }
            case VALIDATION_ERROR -> {
                Optional<SupplierRequest> latest = latestOrNull(user.getUserId());
                render(request, response, user, latest.orElse(null),
                        formFromParams(shopName, contactPhone, address, description),
                        outcome.fieldErrors(), null);
            }
            case SYSTEM_ERROR -> {
                Optional<SupplierRequest> latest = latestOrNull(user.getUserId());
                render(request, response, user, latest.orElse(null),
                        formFromParams(shopName, contactPhone, address, description),
                        null, MSG_SYSTEM_ERROR);
            }
        }
    }

    // ------------------------------------------------------------------

    private void render(HttpServletRequest request, HttpServletResponse response, User user,
                        SupplierRequest latest, Map<String, String> form,
                        Map<String, String> errors, String error)
            throws ServletException, IOException {
        request.setAttribute("supplierRequest", SupplierRequestView.from(latest));
        request.setAttribute("profile", ProfileView.from(user));
        request.setAttribute("form", form);
        if (errors != null && !errors.isEmpty()) {
            request.setAttribute("errors", errors);
        }
        if (error != null) {
            request.setAttribute("error", error);
        }
        request.getRequestDispatcher(VIEW).forward(request, response);
    }

    /** Giá trị mặc định: lấy từ user, hoặc từ yêu cầu bị từ chối gần nhất. */
    private static Map<String, String> formDefaults(User user, SupplierRequest latest) {
        if (latest != null && latest.getStatus() == SupplierRequestStatus.REJECTED) {
            return formFromParams(latest.getShopName(), latest.getContactPhone(),
                    latest.getAddress(), latest.getDescription());
        }
        return formFromParams(null, user.getPhone(), user.getDefaultAddress(), null);
    }

    private static Map<String, String> formFromParams(String shopName, String contactPhone,
                                                      String address, String description) {
        Map<String, String> form = new LinkedHashMap<>();
        form.put("shopName", shopName == null ? "" : shopName);
        form.put("contactPhone", contactPhone == null ? "" : contactPhone);
        form.put("address", address == null ? "" : address);
        form.put("description", description == null ? "" : description);
        return form;
    }

    private User loadUser(int userId) throws ServletException {
        try {
            return service.loadUser(userId);
        } catch (SQLException e) {
            throw new ServletException("Cannot load user for supplier request", e);
        }
    }

    private Optional<SupplierRequest> latestOrNull(int userId) throws ServletException {
        try {
            return service.latest(userId);
        } catch (SQLException e) {
            throw new ServletException("Cannot load supplier request", e);
        }
    }

    /** SELLER đã là NCC, ADMIN thuộc khu quản trị: chuyển về đúng trang chủ. */
    private static boolean redirectIfNotCustomer(HttpServletRequest request,
                                                 HttpServletResponse response, User user)
            throws IOException {
        if (user.getRole() == Role.ADMIN) {
            response.sendRedirect(request.getContextPath() + Views.HOME_ADMIN);
            return true;
        }
        if (user.getRole() == Role.SELLER) {
            response.sendRedirect(request.getContextPath() + Views.HOME_SELLER);
            return true;
        }
        return false;
    }

    private static void flashSuccess(HttpServletRequest request, String message) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            FlashUtil.flashSuccess(session, message);
        }
    }

    private static void flashError(HttpServletRequest request, String message) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            FlashUtil.flashError(session, message);
        }
    }

    private static void redirectToLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.sendRedirect(request.getContextPath() + Views.LOGIN_URL
                + "?redirect=" + URLEncoder.encode(REQUEST_URL, StandardCharsets.UTF_8));
    }

    private static void logoutAndRedirect(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        redirectToLogin(request, response);
    }
}
