package com.tmdt.dao;

import com.tmdt.model.Role;
import com.tmdt.model.User;
import com.tmdt.model.UserStatus;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static com.tmdt.util.DBConnection.getConnection;

/**
 * Truy vấn cho màn hình Quản lý người dùng của Admin.
 * - Đọc danh sách/tìm kiếm: tự lấy connection từ pool.
 * - Ghi (khóa/mở, đổi role): nhận Connection từ AdminUserService để service
 *   quyết định commit/rollback và khóa dòng (SELECT ... FOR UPDATE).
 * Chỉ dùng PreparedStatement, không nối chuỗi từ tham số.
 */
public class AdminUserDAO {

    private static final String COLUMNS =
            "user_id, email, full_name, phone, role, is_email_verified, status, created_at";

    /** Tìm theo tên/email, lọc theo role + trạng thái, có phân trang. */
    public List<User> search(String q, Role role, UserStatus status, int offset, int limit)
            throws SQLException {
        List<Object> params = new ArrayList<>();
        String where = whereClause(q, role, status, params);
        String sql = "SELECT " + COLUMNS + " FROM users" + where
                + " ORDER BY created_at DESC, user_id DESC LIMIT ? OFFSET ?";
        params.add(limit);
        params.add(offset);

        List<User> users = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            bind(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(mapRow(rs));
                }
            }
        }
        return users;
    }

    public long count(String q, Role role, UserStatus status) throws SQLException {
        List<Object> params = new ArrayList<>();
        String where = whereClause(q, role, status, params);
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM users" + where)) {
            bind(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong(1) : 0L;
            }
        }
    }

    /** Số lượng tài khoản theo role (dùng cho bộ lọc + thẻ số liệu). */
    public Map<String, Integer> countByRole() throws SQLException {
        return countByColumn("role");
    }

    /** Số lượng tài khoản theo trạng thái ACTIVE/LOCKED. */
    public Map<String, Integer> countByStatus() throws SQLException {
        return countByColumn("status");
    }

    /** Số tài khoản chưa xác minh email. */
    public int countUnverified() throws SQLException {
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT COUNT(*) FROM users WHERE is_email_verified = 0")) {
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /** Khóa dòng mục tiêu để kiểm tra "admin cuối cùng" an toàn trong transaction. */
    public Optional<User> findByIdForUpdate(Connection conn, int userId) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT " + COLUMNS + " FROM users WHERE user_id = ? FOR UPDATE")) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(mapRow(rs)) : Optional.empty();
            }
        }
    }

    /**
     * Đếm các ADMIN đang ACTIVE khác userId. Khoá các dòng admin đọc được để
     * hai request đồng thời không cùng hạ quyền admin cuối cùng.
     */
    public int countOtherActiveAdmins(Connection conn, int userId) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT user_id FROM users WHERE role = 'ADMIN' AND status = 'ACTIVE' "
                        + "AND user_id <> ? FOR UPDATE")) {
            ps.setInt(1, userId);
            int count = 0;
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    count++;
                }
            }
            return count;
        }
    }

    public boolean updateStatus(Connection conn, int userId, UserStatus status) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE users SET status = ? WHERE user_id = ?")) {
            ps.setString(1, status.name());
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateRole(Connection conn, int userId, Role role) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE users SET role = ? WHERE user_id = ?")) {
            ps.setString(1, role.name());
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    // ------------------------------------------------------------------
    // Helpers
    // ------------------------------------------------------------------

    private Map<String, Integer> countByColumn(String column) throws SQLException {
        // column chỉ nhận 'role' | 'status' (do code gọi, không từ request).
        Map<String, Integer> result = new LinkedHashMap<>();
        String sql = "SELECT " + column + " AS k, COUNT(*) AS total FROM users GROUP BY " + column;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                result.put(rs.getString("k"), rs.getInt("total"));
            }
        }
        return result;
    }

    private static String whereClause(String q, Role role, UserStatus status, List<Object> params) {
        StringBuilder where = new StringBuilder(" WHERE 1 = 1");
        if (q != null && !q.isBlank()) {
            where.append(" AND (full_name LIKE ? OR email LIKE ? OR phone LIKE ?)");
            String like = "%" + q.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if (role != null) {
            where.append(" AND role = ?");
            params.add(role.name());
        }
        if (status != null) {
            where.append(" AND status = ?");
            params.add(status.name());
        }
        return where.toString();
    }

    private static void bind(PreparedStatement ps, List<Object> params) throws SQLException {
        for (int i = 0; i < params.size(); i++) {
            Object value = params.get(i);
            if (value instanceof Integer number) {
                ps.setInt(i + 1, number);
            } else {
                ps.setString(i + 1, String.valueOf(value));
            }
        }
    }

    private static User mapRow(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setEmail(rs.getString("email"));
        user.setFullName(rs.getString("full_name"));
        user.setPhone(rs.getString("phone"));
        user.setRole(Role.fromString(rs.getString("role")));
        user.setEmailVerified(rs.getBoolean("is_email_verified"));
        user.setStatus(UserStatus.fromString(rs.getString("status")));
        if (rs.getTimestamp("created_at") != null) {
            user.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        }
        return user;
    }
}
