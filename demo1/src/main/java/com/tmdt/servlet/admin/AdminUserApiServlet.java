package com.tmdt.servlet.admin;

import com.tmdt.model.SessionUser;
import com.tmdt.model.User;
import com.tmdt.service.AdminUserService;
import com.tmdt.util.AuthUtil;
import com.tmdt.util.JsonUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.sql.SQLException;
import java.time.format.DateTimeFormatter;

/**
 * API quản lý tài khoản (chỉ ADMIN — AuthFilter chặn trước khi vào đây):
 *   GET  /admin/api/users?q=&role=&status=&page=&size=
 *   POST /admin/api/users/status  (userId, status=ACTIVE|LOCKED)
 *   POST /admin/api/users/role    (userId, role=CUSTOMER|SELLER|ADMIN)
 *
 * POST đi qua CsrfFilter nên bắt buộc có tham số csrfToken. Mọi phản hồi là
 * application/json;charset=UTF-8; lỗi dùng {"error":"..."} kèm mã 4xx.
 */
@WebServlet(name = "AdminUserApiServlet", urlPatterns = {"/admin/api/users", "/admin/api/users/*"})
public class AdminUserApiServlet extends HttpServlet {

    private static final Logger LOG = LoggerFactory.getLogger(AdminUserApiServlet.class);
    private static final DateTimeFormatter DATE_TIME =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private final AdminUserService service = new AdminUserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo != null && !pathInfo.equals("/")) {
            writeError(response, HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy tài nguyên.");
            return;
        }
        try {
            AdminUserService.Page page = service.list(
                    request.getParameter("q"),
                    request.getParameter("role"),
                    request.getParameter("status"),
                    request.getParameter("page"),
                    request.getParameter("size"));

            JsonUtil.Arr users = new JsonUtil.Arr();
            for (User user : page.users()) {
                users.add(new JsonUtil.Obj()
                        .putNumber("userId", user.getUserId())
                        .putString("fullName", user.getFullName())
                        .putString("email", user.getEmail())
                        .putString("phone", user.getPhone())
                        .putString("role", user.getRole() == null ? null : user.getRole().name())
                        .putString("status", user.getStatus() == null ? null : user.getStatus().name())
                        .putBoolean("emailVerified", user.isEmailVerified())
                        .putString("createdAt", user.getCreatedAt() == null
                                ? null : DATE_TIME.format(user.getCreatedAt()))
                        .end());
            }

            String body = new JsonUtil.Obj()
                    .put("users", users.end())
                    .putNumber("total", page.total())
                    .putNumber("page", page.page())
                    .putNumber("size", page.size())
                    .putNumber("totalPages", page.totalPages())
                    .put("counts", new JsonUtil.Obj()
                            .put("byRole", intMap(page.byRole()))
                            .put("byStatus", intMap(page.byStatus()))
                            .putNumber("unverified", page.unverified())
                            .end())
                    .end();
            writeJson(response, HttpServletResponse.SC_OK, body);
        } catch (IllegalArgumentException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SQLException e) {
            LOG.error("Admin users list failed", e);
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Không tải được danh sách tài khoản.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        SessionUser actor = AuthUtil.currentUser(request);
        if (actor == null) {
            // AuthFilter đã chặn; nhánh này chỉ để phòng hờ.
            writeError(response, HttpServletResponse.SC_UNAUTHORIZED, "Bạn cần đăng nhập để tiếp tục.");
            return;
        }

        String action = request.getPathInfo();
        if (action == null) {
            writeError(response, HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy tài nguyên.");
            return;
        }

        try {
            AdminUserService.Outcome outcome = switch (action) {
                case "/status" -> service.setStatus(actor.getUserId(),
                        request.getParameter("userId"), request.getParameter("status"));
                case "/role" -> service.setRole(actor.getUserId(),
                        request.getParameter("userId"), request.getParameter("role"));
                default -> null;
            };
            if (outcome == null) {
                writeError(response, HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy tài nguyên.");
                return;
            }
            if (!outcome.ok()) {
                writeError(response, HttpServletResponse.SC_BAD_REQUEST, outcome.error());
                return;
            }
            writeJson(response, HttpServletResponse.SC_OK,
                    new JsonUtil.Obj().putBoolean("success", true).end());
        } catch (IllegalArgumentException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SQLException e) {
            LOG.error("Admin user update failed", e);
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Hệ thống bận, vui lòng thử lại sau.");
        }
    }

    private static String intMap(java.util.Map<String, Integer> values) {
        JsonUtil.Obj obj = new JsonUtil.Obj();
        values.forEach(obj::putNumber);
        return obj.end();
    }

    private static void writeError(HttpServletResponse response, int status, String message)
            throws IOException {
        writeJson(response, status, new JsonUtil.Obj()
                .putString("error", message == null ? "Đã xảy ra lỗi." : message)
                .end());
    }

    private static void writeJson(HttpServletResponse response, int status, String body)
            throws IOException {
        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(body);
    }
}
