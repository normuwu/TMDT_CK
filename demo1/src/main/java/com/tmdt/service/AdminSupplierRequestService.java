package com.tmdt.service;

import com.tmdt.dao.AdminSupplierRequestDAO;
import com.tmdt.dao.AdminUserDAO;
import com.tmdt.model.Role;
import com.tmdt.model.SupplierRequest;
import com.tmdt.model.SupplierRequestStatus;
import com.tmdt.model.User;
import com.tmdt.model.UserStatus;
import com.tmdt.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Nghiệp vụ duyệt / từ chối yêu cầu "Xin làm Nhà cung cấp".
 *
 * Quy tắc an toàn:
 *  - Chỉ xử lý yêu cầu đang PENDING; yêu cầu đã xử lý trả lỗi (không duyệt lặp).
 *  - Duyệt: giữ nguyên supplier_profiles (upsert theo UNIQUE user_id) và đổi
 *    users.role CUSTOMER -> SELLER trong CÙNG transaction với việc cập nhật
 *    yêu cầu, nên không có trạng thái nửa vời.
 *  - Không cấp quyền NCC cho ADMIN, không duyệt cho tài khoản đang LOCKED.
 *  - Từ chối: chỉ ghi lý do + trạng thái, KHÔNG đổi role.
 *  - actorId do servlet lấy từ session (role ADMIN đã được AuthFilter chặn).
 */
public class AdminSupplierRequestService {

    private static final Logger LOG = LoggerFactory.getLogger(AdminSupplierRequestService.class);

    public static final int DEFAULT_PAGE_SIZE = 10;
    public static final int MAX_PAGE_SIZE = 100;
    public static final int REASON_MAX = 500; // supplier_requests.reject_reason VARCHAR(500)

    private final AdminSupplierRequestDAO dao = new AdminSupplierRequestDAO();
    private final AdminUserDAO userDAO = new AdminUserDAO();

    public record Page(List<AdminSupplierRequestDAO.Row> requests, long total, int page, int size,
                       int totalPages, Map<String, Integer> byStatus) {
    }

    public record Outcome(boolean ok, String error) {
        public static Outcome success() {
            return new Outcome(true, null);
        }

        public static Outcome failure(String message) {
            return new Outcome(false, message);
        }
    }

    /** Danh sách + lọc trạng thái/từ khóa + phân trang. Tham số sai -> IllegalArgumentException. */
    public Page list(String statusRaw, String qRaw, String pageRaw, String sizeRaw) throws SQLException {
        SupplierRequestStatus status = null;
        if (statusRaw != null && !statusRaw.isBlank()) {
            status = SupplierRequestStatus.fromString(statusRaw);
            if (status == null) {
                throw new IllegalArgumentException("Trạng thái yêu cầu không hợp lệ.");
            }
        }

        int page = parsePositiveInt(pageRaw, 1);
        int size = Math.min(parsePositiveInt(sizeRaw, DEFAULT_PAGE_SIZE), MAX_PAGE_SIZE);

        String q = qRaw == null ? null : qRaw.trim();
        long total = dao.count(q, status);
        int totalPages = Math.max(1, (int) ((total + size - 1) / size));
        page = Math.min(page, totalPages);

        List<AdminSupplierRequestDAO.Row> rows =
                dao.search(q, status, (page - 1) * size, size);
        return new Page(rows, total, page, size, totalPages, dao.countByStatus());
    }

    public Outcome approve(int actorId, String requestIdRaw) throws SQLException {
        int requestId = parseRequestId(requestIdRaw);

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Optional<SupplierRequest> found = dao.findByIdForUpdate(conn, requestId);
                if (found.isEmpty()) {
                    conn.rollback();
                    return Outcome.failure("Không tìm thấy yêu cầu.");
                }
                SupplierRequest request = found.get();
                if (request.getStatus() != SupplierRequestStatus.PENDING) {
                    conn.rollback();
                    return Outcome.failure("Yêu cầu này đã được xử lý.");
                }

                Optional<User> target = userDAO.findByIdForUpdate(conn, request.getUserId());
                if (target.isEmpty()) {
                    conn.rollback();
                    return Outcome.failure("Không tìm thấy tài khoản gửi yêu cầu.");
                }
                User user = target.get();
                if (user.getStatus() == UserStatus.LOCKED) {
                    conn.rollback();
                    return Outcome.failure("Tài khoản đang bị khóa. Hãy mở khóa trước khi duyệt.");
                }
                if (user.getRole() == Role.ADMIN) {
                    conn.rollback();
                    return Outcome.failure("Không thể cấp quyền nhà cung cấp cho tài khoản quản trị.");
                }

                if (user.getRole() != Role.SELLER) {
                    userDAO.updateRole(conn, user.getUserId(), Role.SELLER);
                }
                if (dao.shopNameTakenByOther(conn, user.getUserId(), request.getShopName())) {
                    conn.rollback();
                    return Outcome.failure("Tên xưởng đã được tài khoản khác sử dụng.");
                }
                dao.upsertSupplierProfile(conn, user.getUserId(), request.getShopName(),
                        request.getDescription(), request.getAddress());
                dao.upsertShop(conn, user.getUserId(), request.getShopName(),
                        request.getContactPhone(), request.getAddress(), request.getDescription());

                if (!dao.markApproved(conn, requestId, actorId)) {
                    conn.rollback();
                    return Outcome.failure("Yêu cầu này đã được xử lý.");
                }
                conn.commit();
                LOG.info("Supplier request approved requestId={} userId={} by={}",
                        requestId, user.getUserId(), actorId);
                return Outcome.success();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    public Outcome reject(int actorId, String requestIdRaw, String reasonRaw) throws SQLException {
        int requestId = parseRequestId(requestIdRaw);
        String reason = reasonRaw == null ? "" : reasonRaw.trim();
        if (reason.isEmpty()) {
            return Outcome.failure("Vui lòng nhập lý do từ chối.");
        }
        if (reason.length() > REASON_MAX) {
            return Outcome.failure("Lý do từ chối tối đa " + REASON_MAX + " ký tự.");
        }

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Optional<SupplierRequest> found = dao.findByIdForUpdate(conn, requestId);
                if (found.isEmpty()) {
                    conn.rollback();
                    return Outcome.failure("Không tìm thấy yêu cầu.");
                }
                if (found.get().getStatus() != SupplierRequestStatus.PENDING) {
                    conn.rollback();
                    return Outcome.failure("Yêu cầu này đã được xử lý.");
                }
                if (!dao.markRejected(conn, requestId, actorId, reason)) {
                    conn.rollback();
                    return Outcome.failure("Yêu cầu này đã được xử lý.");
                }
                conn.commit();
                LOG.info("Supplier request rejected requestId={} by={}", requestId, actorId);
                return Outcome.success();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    // ------------------------------------------------------------------

    private static int parseRequestId(String raw) {
        int id = parsePositiveInt(raw, -1);
        if (id <= 0) {
            throw new IllegalArgumentException("Mã yêu cầu không hợp lệ.");
        }
        return id;
    }

    private static int parsePositiveInt(String raw, int fallback) {
        if (raw == null || raw.isBlank()) {
            return fallback;
        }
        try {
            int value = Integer.parseInt(raw.trim());
            return value > 0 ? value : fallback;
        } catch (NumberFormatException e) {
            return fallback;
        }
    }
}
