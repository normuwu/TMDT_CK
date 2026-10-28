package com.tmdt.dao;

import com.tmdt.model.SupplierRequest;
import com.tmdt.model.SupplierRequestStatus;
import com.tmdt.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Optional;

/**
 * Truy cập bảng `supplier_requests` cho phía NGƯỜI GỬI yêu cầu.
 * (Màn hình Admin dùng AdminSupplierRequestDAO.)
 *
 * Chỉ PreparedStatement, không nối chuỗi từ tham số. Các method nhận Connection
 * là để service quyết định commit/rollback.
 */
public class SupplierRequestDAO {

    private static final String COLUMNS =
            "request_id, user_id, shop_name, contact_phone, address, description, "
                    + "status, reject_reason, reviewed_by, reviewed_at, created_at";

    /** Yêu cầu mới nhất của một user (mọi trạng thái) - dùng để hiển thị trạng thái. */
    public Optional<SupplierRequest> findLatestByUser(int userId) throws SQLException {
        final String sql = "SELECT " + COLUMNS + " FROM supplier_requests "
                + "WHERE user_id = ? ORDER BY request_id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(mapRow(rs)) : Optional.empty();
            }
        }
    }

    /** Yêu cầu đang chờ duyệt (nếu có) - transaction-aware. */
    public Optional<SupplierRequest> findPending(Connection conn, int userId) throws SQLException {
        final String sql = "SELECT " + COLUMNS + " FROM supplier_requests "
                + "WHERE user_id = ? AND status = 'PENDING' "
                + "ORDER BY request_id DESC LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(mapRow(rs)) : Optional.empty();
            }
        }
    }

    /** User đã có hồ sơ nhà cung cấp chưa (đã được duyệt trước đó). */
    public boolean hasSupplierProfile(Connection conn, int userId) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT 1 FROM supplier_profiles WHERE user_id = ? LIMIT 1")) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /** Insert yêu cầu mới (luôn ở trạng thái PENDING) và trả về request_id. */
    public int insertPending(Connection conn, int userId, String shopName, String contactPhone,
                             String address, String description) throws SQLException {
        final String sql = "INSERT INTO supplier_requests "
                + "(user_id, shop_name, contact_phone, address, description, status) "
                + "VALUES (?, ?, ?, ?, ?, 'PENDING')";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setString(2, shopName);
            ps.setString(3, contactPhone);
            ps.setString(4, address);
            if (description == null) {
                ps.setNull(5, java.sql.Types.LONGVARCHAR);
            } else {
                ps.setString(5, description);
            }
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : 0;
            }
        }
    }

    private static SupplierRequest mapRow(ResultSet rs) throws SQLException {
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
        Timestamp reviewedAt = rs.getTimestamp("reviewed_at");
        if (reviewedAt != null) {
            request.setReviewedAt(reviewedAt.toLocalDateTime());
        }
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            request.setCreatedAt(createdAt.toLocalDateTime());
        }
        return request;
    }
}
