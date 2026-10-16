package com.tmdt.dao;

import com.tmdt.model.TokenType;
import com.tmdt.model.UserToken;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Optional;

import static com.tmdt.util.DBConnection.getConnection;

/**
 * Pure JDBC access to `user_tokens`. token_code stores the SHA-256 hash of a
 * raw token (never the raw value). Transactional methods accept the caller's
 * Connection; lookup methods use their own pooled connection.
 */
public class UserTokenDAO {

    // ---------------------------------------------------------------------
    // Writes
    // ---------------------------------------------------------------------

    public void insert(Connection conn, UserToken token) throws SQLException {
        final String sql = "INSERT INTO user_tokens (user_id, token_code, token_type, expires_at, is_used) "
                + "VALUES (?, ?, ?, ?, FALSE)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, token.getUserId());
            ps.setString(2, token.getTokenCode());
            ps.setString(3, token.getTokenType().name());
            ps.setTimestamp(4, java.sql.Timestamp.valueOf(token.getExpiresAt()));
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    token.setTokenId(keys.getLong(1));
                }
            }
        }
    }

    /** One-time use: a token can never be consumed twice. */
    public void markUsed(Connection conn, long tokenId) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE user_tokens SET is_used = TRUE WHERE token_id = ?")) {
            ps.setLong(1, tokenId);
            ps.executeUpdate();
        }
    }

    /** Invalidate all unused tokens of a type for one user (resend / new reset links). */
    public void invalidateUnused(Connection conn, int userId, TokenType type) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE user_tokens SET is_used = TRUE "
                        + "WHERE user_id = ? AND token_type = ? AND is_used = FALSE")) {
            ps.setInt(1, userId);
            ps.setString(2, type.name());
            ps.executeUpdate();
        }
    }

    // ---------------------------------------------------------------------
    // Lookups
    // ---------------------------------------------------------------------

    /**
     * Finds an UNUSED, non-expired token matching the given hash and type.
     * Used ones and expired ones simply do not match (tokén lookup is by hash,
     * so a lost/stale raw token maps to nothing).
     */
    public Optional<UserToken> findValidByCode(String tokenCodeHash, TokenType type) throws SQLException {
        final String sql = "SELECT token_id, user_id, token_code, token_type, expires_at, is_used, created_at "
                + "FROM user_tokens "
                + "WHERE token_code = ? AND token_type = ? AND is_used = FALSE AND expires_at > NOW()";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tokenCodeHash);
            ps.setString(2, type.name());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRow(rs));
                }
                return Optional.empty();
            }
        }
    }

    private UserToken mapRow(ResultSet rs) throws SQLException {
        UserToken t = new UserToken();
        t.setTokenId(rs.getLong("token_id"));
        t.setUserId(rs.getInt("user_id"));
        t.setTokenCode(rs.getString("token_code"));
        t.setTokenType(TokenType.fromString(rs.getString("token_type")));
        t.setExpiresAt(rs.getTimestamp("expires_at").toLocalDateTime());
        t.setUsed(rs.getBoolean("is_used"));
        t.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        return t;
    }
}
