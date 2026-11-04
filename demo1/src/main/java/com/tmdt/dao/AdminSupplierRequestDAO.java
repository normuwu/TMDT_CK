package com.tmdt.dao;

import com.tmdt.model.SupplierRequest;
import com.tmdt.model.SupplierRequestStatus;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static com.tmdt.util.DBConnection.getConnection;

/**
 * Truy vấn cho màn hình Admin "Yêu cầu làm Nhà cung cấp".
 * - Đọc danh sách: tự lấy connection từ pool.
 * - Duyệt / từ chối: nhận Connection từ AdminSupplierRequestService để service
 *   quyết định commit/rollback (khóa dòng bằng SELECT ... FOR UPDATE).
 * Chỉ PreparedStatement; cột sắp xếp/tìm kiếm cố định trong code.
 */
public class AdminSupplierRequestDAO {

    /** Một dòng danh sách = yêu cầu + thông tin tài khoản gửi + người duyệt. */
    public record Row(int requestId, int userId, String shopName, String contactPhone,
                      String address, String description, String status, String rejectReason,
                      LocalDateTime createdAt, LocalDateTime reviewedAt,
                      String fullName, String email, String userPhone, String userRole,
                      String userStatus, String reviewerName) {
    }

    private static final String SELECT_JOIN =
            "SELECT r.request_id, r.user_id, r.shop_name, r.contact_phone, r.address, r.description, "
                    + "r.status, r.reject_reason, r.created_at, r.reviewed_at, "
                    + "u.full_name, u.email, u.phone AS user_phone, u.role AS user_role, "
                    + "u.status AS user_status, rv.full_name AS reviewer_name "
                    + "FROM supplier_requests r "
                    + "JOIN users u ON u.user_id = r.user_id "
                    + "LEFT JOIN users rv ON rv.user_id = r.reviewed_by";

    public List<Row> search(String q, SupplierRequestStatus status, int offset, int limit)
            throws SQLException {
        List<Object> params = new ArrayList<>();
        String where = whereClause(q, status, params);
        String sql = SELECT_JOIN + where
                + " ORDER BY (r.status = 'PENDING') DESC, r.created_at DESC, r.request_id DESC "
                + "LIMIT ? OFFSET ?";
        params.add(limit);
        params.add(offset);

        List<Row> rows = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            bind(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    rows.add(mapRow(rs));
                }
            }
        }
        return rows;
    }

    public long count(String q, SupplierRequestStatus status) throws SQLException {
        List<Object> params = new ArrayList<>();
        String where = whereClause(q, status, params);
        String sql = "SELECT COUNT(*) FROM supplier_requests r JOIN users u ON u.user_id = r.user_id"
                + where;
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            bind(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong(1) : 0L;
            }
        }
    }

    /** Số yêu cầu theo từng trạng thái (thẻ số liệu + bộ lọc). */
    public Map<String, Integer> countByStatus() throws SQLException {
        Map<String, Integer> result = new LinkedHashMap<>();
        result.put("PENDING", 0);
        result.put("APPROVED", 0);
        result.put("REJECTED", 0);
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT status, COUNT(*) AS total FROM supplier_requests GROUP BY status");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                result.put(rs.getString("status"), rs.getInt("total"));
            }
        }
        return result;
    }

    /** Khóa dòng yêu cầu để hai Admin không cùng xử lý một yêu cầu. */
    public Optional<SupplierRequest> findByIdForUpdate(Connection conn, int requestId)
            throws SQLException {
        final String sql = "SELECT request_id, user_id, shop_name, contact_phone, address, "
                + "description, status, reject_reason, reviewed_by, reviewed_at, created_at "
                + "FROM supplier_requests WHERE request_id = ? FOR UPDATE";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(mapEntity(rs)) : Optional.empty();
            }
        }
    }

    /** Chỉ chuyển PENDING -> APPROVED; trả false khi yêu cầu đã được xử lý trước đó. */
    public boolean markApproved(Connection conn, int requestId, int reviewerId) throws SQLException {
        final String sql = "UPDATE supplier_requests SET status = 'APPROVED', reject_reason = NULL, "
                + "reviewed_by = ?, reviewed_at = CURRENT_TIMESTAMP "
                + "WHERE request_id = ? AND status = 'PENDING'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewerId);
            ps.setInt(2, requestId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Chỉ chuyển PENDING -> REJECTED; trả false khi yêu cầu đã được xử lý trước đó. */
    public boolean markRejected(Connection conn, int requestId, int reviewerId, String reason)
            throws SQLException {
        final String sql = "UPDATE supplier_requests SET status = 'REJECTED', reject_reason = ?, "
                + "reviewed_by = ?, reviewed_at = CURRENT_TIMESTAMP "
                + "WHERE request_id = ? AND status = 'PENDING'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reason);
            ps.setInt(2, reviewerId);
            ps.setInt(3, requestId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Tạo/cập nhật hồ sơ nhà cung cấp khi duyệt. supplier_profiles có
     * UNIQUE(user_id) nên dùng ON DUPLICATE KEY UPDATE để không tạo bản trùng.
     */
    public void upsertSupplierProfile(Connection conn, int userId, String shopName,
                                      String description, String address) throws SQLException {
        final String sql = "INSERT INTO supplier_profiles (user_id, shop_name, description, address, status) "
                + "VALUES (?, ?, ?, ?, 'ACTIVE') "
                + "ON DUPLICATE KEY UPDATE shop_name = VALUES(shop_name), "
                + "description = VALUES(description), address = VALUES(address), status = 'ACTIVE'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, shopName);
            if (description == null) {
                ps.setNull(3, java.sql.Types.LONGVARCHAR);
            } else {
                ps.setString(3, description);
            }
            ps.setString(4, address);
            ps.executeUpdate();
        }
    }

    /** true nếu tên xưởng đã thuộc về tài khoản khác (shops.shop_name UNIQUE). */
    public boolean shopNameTakenByOther(Connection conn, int userId, String shopName) throws SQLException {
        final String sql = "SELECT 1 FROM shops WHERE shop_name = ? AND user_id <> ? LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, shopName);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Tạo/cập nhật dòng shops khi duyệt NCC. Đây là bản ghi xưởng mà orders.shop_id
     * tham chiếu, nên thiếu dòng này thì người bán không có đơn và thống kê.
     * slug = slug(tên) + "-" + userId để không đụng UNIQUE(slug) của tài khoản khác.
     */
    public void upsertShop(Connection conn, int userId, String shopName, String contactPhone,
                           String address, String description) throws SQLException {
        final String sql = "INSERT INTO shops (user_id, shop_name, slug, description, address, phone, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, 'ACTIVE') "
                + "ON DUPLICATE KEY UPDATE shop_name = VALUES(shop_name), description = VALUES(description), "
                + "address = VALUES(address), phone = VALUES(phone), status = 'ACTIVE'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, shopName);
            ps.setString(3, slugify(shopName) + "-" + userId);
            if (description == null) {
                ps.setNull(4, java.sql.Types.LONGVARCHAR);
            } else {
                ps.setString(4, description);
            }
            ps.setString(5, address);
            ps.setString(6, contactPhone);
            ps.executeUpdate();
        }
    }

    static String slugify(String text) {
        String n = java.text.Normalizer.normalize(text, java.text.Normalizer.Form.NFD)
                .replaceAll("\\p{M}+", "")
                .replace('đ', 'd').replace('Đ', 'D')
                .toLowerCase(java.util.Locale.ROOT)
                .replaceAll("[^a-z0-9]+", "-")
                .replaceAll("(^-+|-+$)", "");
        return n.isEmpty() ? "xuong" : n;
    }

    // ------------------------------------------------------------------
    // Helpers
    // ------------------------------------------------------------------

    private static String whereClause(String q, SupplierRequestStatus status, List<Object> params) {
        StringBuilder where = new StringBuilder(" WHERE 1 = 1");
        if (q != null && !q.isBlank()) {
            where.append(" AND (r.shop_name LIKE ? OR u.full_name LIKE ? OR u.email LIKE ? ")
                    .append("OR r.contact_phone LIKE ?)");
            String like = "%" + q.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if (status != null) {
            where.append(" AND r.status = ?");
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

    private static Row mapRow(ResultSet rs) throws SQLException {
        return new Row(
                rs.getInt("request_id"),
                rs.getInt("user_id"),
                rs.getString("shop_name"),
                rs.getString("contact_phone"),
                rs.getString("address"),
                rs.getString("description"),
                rs.getString("status"),
                rs.getString("reject_reason"),
                toLocal(rs.getTimestamp("created_at")),
                toLocal(rs.getTimestamp("reviewed_at")),
                rs.getString("full_name"),
                rs.getString("email"),
                rs.getString("user_phone"),
                rs.getString("user_role"),
                rs.getString("user_status"),
                rs.getString("reviewer_name"));
    }

    private static SupplierRequest mapEntity(ResultSet rs) throws SQLException {
        SupplierRequest request = new SupplierRequest();
        request.setRequestId(rs.getInt("request_id"));
        request.setUserId(rs.getInt("user_id"));
        request.setShopName(rs.getString("shop_name"));
        request.setContactPhone(rs.getString("contact_phone"));
        request.setAddress(rs.getString("address"));
        request.setDescription(rs.getString("description"));
        SupplierRequestStatus status = SupplierRequestStatus.fromString(rs.getString("status"));
        request.setStatus(status == null ? SupplierRequestStatus.PENDING : status);
        request.setRejectReason(rs.getString("reject_reason"));
        int reviewedBy = rs.getInt("reviewed_by");
        request.setReviewedBy(rs.wasNull() ? null : reviewedBy);
        request.setReviewedAt(toLocal(rs.getTimestamp("reviewed_at")));
        request.setCreatedAt(toLocal(rs.getTimestamp("created_at")));
        return request;
    }

    private static LocalDateTime toLocal(Timestamp timestamp) {
        return timestamp == null ? null : timestamp.toLocalDateTime();
    }
}
