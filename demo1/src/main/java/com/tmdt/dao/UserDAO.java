package com.tmdt.dao;

import com.tmdt.model.Role;
import com.tmdt.model.User;
import com.tmdt.model.UserStatus;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Optional;

import static com.tmdt.util.DBConnection.getConnection;

/**
 * Pure JDBC access to `users`. PreparedStatement everywhere; transactional
 * methods accept the caller's Connection (the service owns commit/rollback),
 * read-only methods grab a pooled connection themselves.
 */
public class UserDAO {

    private static final String COLUMN_LIST =
            "user_id, email, password_hash, full_name, phone, avatar_url, "
                    + "default_address, role, is_email_verified, status, created_at, updated_at";

    // ---------------------------------------------------------------------
    // Lookups
    // ---------------------------------------------------------------------

    /** Read-only lookup on its own pooled connection. */
    public Optional<User> findByEmail(String email) throws SQLException {
        try (Connection conn = getConnection()) {
            return findByEmail(conn, email);
        }
    }

    /** Transaction-aware lookup (service owns commit/rollback). */
    public Optional<User> findByEmail(Connection conn, String email) throws SQLException {
        final String sql = "SELECT " + COLUMN_LIST + " FROM users WHERE email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            return first(ps);
        }
    }

    /** Read-only lookup on its own pooled connection. */
    public Optional<User> findByPhone(String phone) throws SQLException {
        try (Connection conn = getConnection()) {
            return findByPhone(conn, phone);
        }
    }

    /** Transaction-aware lookup (service owns commit/rollback). */
    public Optional<User> findByPhone(Connection conn, String phone) throws SQLException {
        final String sql = "SELECT " + COLUMN_LIST + " FROM users WHERE phone = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            return first(ps);
        }
    }

    /** Read-only by primary key (remember-me auto-login). */
    public Optional<User> findById(int userId) throws SQLException {
        try (Connection conn = getConnection()) {
            return findById(conn, userId);
        }
    }

    /** Transaction-aware by primary key. */
    public Optional<User> findById(Connection conn, int userId) throws SQLException {
        final String sql = "SELECT " + COLUMN_LIST + " FROM users WHERE user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return first(ps);
        }
    }

    // ---------------------------------------------------------------------
    // Writes (transactional — Connection passed in by the service layer)
    // ---------------------------------------------------------------------

    /** Inserts the user and returns it with the generated user_id set. */
    public void insert(Connection conn, User user) throws SQLException {
        final String sql = "INSERT INTO users "
                + "(email, password_hash, full_name, phone, role, is_email_verified, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getFullName());
            if (user.getPhone() == null || user.getPhone().isBlank()) {
                ps.setNull(4, java.sql.Types.VARCHAR);
            } else {
                ps.setString(4, user.getPhone());
            }
            ps.setString(5, user.getRole().name());
            ps.setBoolean(6, user.isEmailVerified());
            ps.setString(7, user.getStatus().name());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    user.setUserId(keys.getInt(1));
                }
            }
        }
    }

    /** Marks the email as verified (one column, no other fields touched). */
    public void setEmailVerified(Connection conn, int userId, boolean verified) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE users SET is_email_verified = ? WHERE user_id = ?")) {
            ps.setBoolean(1, verified);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    /** Replaces the password hash (reset flow). */
    public void updatePasswordHash(Connection conn, int userId, String passwordHash) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE users SET password_hash = ? WHERE user_id = ?")) {
            ps.setString(1, passwordHash);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    /**
     * Profile edit: updates ONLY the three columns a user may change herself.
     * Email, role, status and verification are deliberately not touched here.
     */
    public void updateProfile(Connection conn, int userId, String fullName,
                              String phone, String defaultAddress) throws SQLException {
        final String sql = "UPDATE users SET full_name = ?, phone = ?, default_address = ?, "
                + "updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullName);
            if (phone == null || phone.isBlank()) {
                ps.setNull(2, java.sql.Types.VARCHAR);
            } else {
                ps.setString(2, phone);
            }
            if (defaultAddress == null || defaultAddress.isBlank()) {
                ps.setNull(3, java.sql.Types.VARCHAR);
            } else {
                ps.setString(3, defaultAddress);
            }
            ps.setInt(4, userId);
            ps.executeUpdate();
        }
    }

    // ---------------------------------------------------------------------
    // Mapping
    // ---------------------------------------------------------------------

    private Optional<User> first(PreparedStatement ps) throws SQLException {
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return Optional.of(mapRow(rs));
            }
            return Optional.empty();
        }
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setFullName(rs.getString("full_name"));
        u.setPhone(rs.getString("phone"));
        u.setAvatarUrl(rs.getString("avatar_url"));
        u.setDefaultAddress(rs.getString("default_address"));
        u.setRole(Role.fromString(rs.getString("role")));
        u.setEmailVerified(rs.getBoolean("is_email_verified"));
        u.setStatus(UserStatus.fromString(rs.getString("status")));
        u.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        u.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        if (u.getRole() == null) u.setRole(Role.CUSTOMER);
        if (u.getStatus() == null) u.setStatus(UserStatus.ACTIVE);
        return u;
    }
}
