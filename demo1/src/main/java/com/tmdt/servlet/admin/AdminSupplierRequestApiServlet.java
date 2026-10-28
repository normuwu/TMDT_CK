package com.tmdt.servlet.admin;

import com.tmdt.dao.AdminSupplierRequestDAO;
import com.tmdt.model.SessionUser;
import com.tmdt.service.AdminSupplierRequestService;
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
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;

/**
 * API yêu cầu "Xin làm Nhà cung cấp" (chỉ ADMIN — AuthFilter chặn /admin/*):
 *   GET  /admin/api/supplier-requests?status=PENDING|APPROVED|REJECTED&q=&page=&size=
 *   POST /admin/api/supplier-requests/approve  (requestId)
 *   POST /admin/api/supplier-requests/reject   (requestId, reason)
 *
 * POST đi qua CsrfFilter nên bắt buộc có tham số csrfToken. Mọi phản hồi là
 * application/json;charset=UTF-8; lỗi dùng {"error":"..."} kèm mã 4xx.
 */
@WebServlet(name = "AdminSupplierRequestApiServlet",
        urlPatterns = {"/admin/api/supplier-requests", "/admin/api/supplier-requests/*"})
public class AdminSupplierRequestApiServlet extends HttpServlet {

    private static final Logger LOG = LoggerFactory.getLogger(AdminSupplierRequestApiServlet.class);
    private static final DateTimeFormatter DATE_TIME =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private final AdminSupplierRequestService service = new AdminSupplierRequestService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo != null && !pathInfo.equals("/")) {
            writeError(response, HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy tài nguyên.");
            return;
        }
        try {
            AdminSupplierRequestService.Page page = service.list(
                    request.getParameter("status"),
                    request.getParameter("q"),
                    request.getParameter("page"),
                    request.getParameter("size"));

            JsonUtil.Arr requests = new JsonUtil.Arr();
            for (AdminSupplierRequestDAO.Row row : page.requests()) {
                requests.add(new JsonUtil.Obj()
                        .putNumber("requestId", row.requestId())
                        .putNumber("userId", row.userId())
                        .putString("shopName", row.shopName())
                        .putString("contactPhone", row.contactPhone())
                        .putString("address", row.address())
                        .putString("description", row.description())
                        .putString("status", row.status())
                        .putString("rejectReason", row.rejectReason())
                        .putString("createdAt", format(row.createdAt()))
                        .putString("reviewedAt", format(row.reviewedAt()))
                        .putString("fullName", row.fullName())
                        .putString("email", row.email())
                        .putString("userPhone", row.userPhone())
                        .putString("userRole", row.userRole())
                        .putString("userStatus", row.userStatus())
                        .putString("reviewerName", row.reviewerName())
                        .end());
            }

            String body = new JsonUtil.Obj()
                    .put("requests", requests.end())
                    .putNumber("total", page.total())
                    .putNumber("page", page.page())
                    .putNumber("size", page.size())
                    .putNumber("totalPages", page.totalPages())
                    .put("counts", intMap(page.byStatus()))
                    .end();
            writeJson(response, HttpServletResponse.SC_OK, body);
        } catch (IllegalArgumentException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SQLException e) {
            LOG.error("Admin supplier request list failed", e);
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Không tải được danh sách yêu cầu.");
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
            AdminSupplierRequestService.Outcome outcome = switch (action) {
                case "/approve" -> service.approve(actor.getUserId(),
                        request.getParameter("requestId"));
                case "/reject" -> service.reject(actor.getUserId(),
                        request.getParameter("requestId"), request.getParameter("reason"));
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
            LOG.error("Admin supplier request update failed", e);
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Hệ thống bận, vui lòng thử lại sau.");
        }
    }

    private static String format(LocalDateTime value) {
        return value == null ? null : DATE_TIME.format(value);
    }

    private static String intMap(Map<String, Integer> values) {
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
