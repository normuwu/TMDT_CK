package com.tmdt.service;

import com.tmdt.dao.AdminUserDAO;
import com.tmdt.model.Role;
import com.tmdt.model.User;
import com.tmdt.model.UserStatus;
import com.tmdt.util.DBConnection;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Nghiệp vụ quản lý tài khoản của Admin.
 * Quy tắc an toàn: không tự khóa / tự hạ quyền; không khóa hoặc hạ quyền
 * ADMIN đang hoạt động cuối cùng. Mọi giá trị role/status đều qua whitelist enum.
 */
public class AdminUserService {

    public static final int DEFAULT_PAGE_SIZE = 10;
    public static final int MAX_PAGE_SIZE = 100;

    private final AdminUserDAO dao = new AdminUserDAO();

    public record Page(List<User> users, long total, int page, int size, int totalPages,
                       Map<String, Integer> byRole, Map<String, Integer> byStatus,
                       int unverified) {
    }

    public record Outcome(boolean ok, String error) {
        public static Outcome success() {
            return new Outcome(true, null);
        }

        public static Outcome failure(String message) {
            return new Outcome(false, message);
        }
    }

    /** Danh sách + tổng số + số lượng theo role/status. Lỗi tham số -> IllegalArgumentException (400). */
    public Page list(String q, String roleRaw, String statusRaw, String pageRaw, String sizeRaw)
            throws SQLException {
        Role role = null;
        if (roleRaw != null && !roleRaw.isBlank()) {
            role = Role.fromString(roleRaw);
            if (role == null) {
                throw new IllegalArgumentException("Vai trò không hợp lệ.");
            }
        }
        UserStatus status = null;
        if (statusRaw != null && !statusRaw.isBlank()) {
            status = UserStatus.fromString(statusRaw);
            if (status == null) {
                throw new IllegalArgumentException("Trạng thái không hợp lệ.");
            }
        }

        int page = parsePositiveInt(pageRaw, 1);
        int size = Math.min(parsePositiveInt(sizeRaw, DEFAULT_PAGE_SIZE), MAX_PAGE_SIZE);

        long total = dao.count(q, role, status);
        int totalPages = Math.max(1, (int) ((total + size - 1) / size));
        page = Math.min(page, totalPages);
        int offset = (page - 1) * size;

        List<User> users = dao.search(q, role, status, offset, size);
        return new Page(users, total, page, size, totalPages,
                dao.countByRole(), dao.countByStatus(), dao.countUnverified());
    }

    public Outcome setStatus(int actorId, String userIdRaw, String statusRaw) throws SQLException {
        int userId = parseUserId(userIdRaw);
        UserStatus status = UserStatus.fromString(statusRaw);
        if (status == null) {
            return Outcome.failure("Trạng thái không hợp lệ.");
        }
        if (userId == actorId && status == UserStatus.LOCKED) {
            return Outcome.failure("Bạn không thể tự khóa tài khoản của mình.");
        }

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Optional<User> target = dao.findByIdForUpdate(conn, userId);
                if (target.isEmpty()) {
                    conn.rollback();
                    return Outcome.failure("Không tìm thấy tài khoản.");
                }
                if (target.get().getRole() == Role.ADMIN && status == UserStatus.LOCKED
                        && dao.countOtherActiveAdmins(conn, userId) == 0) {
                    conn.rollback();
                    return Outcome.failure("Không thể khóa quản trị viên cuối cùng của hệ thống.");
                }
                dao.updateStatus(conn, userId, status);
                conn.commit();
                return Outcome.success();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    public Outcome setRole(int actorId, String userIdRaw, String roleRaw) throws SQLException {
        int userId = parseUserId(userIdRaw);
        Role role = Role.fromString(roleRaw);
        if (role == null) {
            return Outcome.failure("Vai trò không hợp lệ.");
        }
        if (userId == actorId && role != Role.ADMIN) {
            return Outcome.failure("Bạn không thể tự hạ quyền quản trị của mình.");
        }

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                Optional<User> target = dao.findByIdForUpdate(conn, userId);
                if (target.isEmpty()) {
                    conn.rollback();
                    return Outcome.failure("Không tìm thấy tài khoản.");
                }
                if (target.get().getRole() == Role.ADMIN && role != Role.ADMIN
                        && dao.countOtherActiveAdmins(conn, userId) == 0) {
                    conn.rollback();
                    return Outcome.failure("Không thể hạ quyền quản trị viên cuối cùng của hệ thống.");
                }
                dao.updateRole(conn, userId, role);
                conn.commit();
                return Outcome.success();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    private static int parseUserId(String raw) {
        int id = parsePositiveInt(raw, -1);
        if (id <= 0) {
            throw new IllegalArgumentException("Mã người dùng không hợp lệ.");
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
