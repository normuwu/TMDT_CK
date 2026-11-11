package com.tmdt.dao;

import com.tmdt.model.OrderStatus;
import com.tmdt.model.OrderStatusHistory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import static com.tmdt.util.DBConnection.getConnection;

/**
 * Pure JDBC cho bảng order_status_history (thêm bằng migration
 * database/feature_promotion_review_order_status.sql).
 *
 * Ghi: nhận Connection của OrderService/OrderStatusService để lưu cùng transaction
 * với UPDATE orders. Đọc: tự lấy connection.
 */
public class OrderStatusHistoryDAO {

    public void insert(Connection conn, int orderId, OrderStatus oldStatus,
                       OrderStatus newStatus, Integer changedBy, String note) throws SQLException {
        final String sql = "INSERT INTO order_status_history "
                + "(order_id, old_status, new_status, changed_by, note) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            if (oldStatus == null) {
                ps.setNull(2, Types.VARCHAR);
            } else {
                ps.setString(2, oldStatus.getCode());
            }
            ps.setString(3, newStatus.getCode());
            if (changedBy == null) {
                ps.setNull(4, Types.INTEGER);
            } else {
                ps.setInt(4, changedBy);
            }
            if (note == null || note.isBlank()) {
                ps.setNull(5, Types.VARCHAR);
            } else {
                ps.setString(5, note);
            }
            ps.executeUpdate();
        }
    }

    /** Lịch sử của một đơn, cũ nhất trước (đọc cho trang chi tiết đơn). */
    public List<OrderStatusHistory> findByOrderId(int orderId) throws SQLException {
        final String sql = "SELECT h.history_id, h.order_id, h.old_status, h.new_status, "
                + "h.note, h.created_at, u.full_name AS changed_by_name "
                + "FROM order_status_history h "
                + "LEFT JOIN users u ON u.user_id = h.changed_by "
                + "WHERE h.order_id = ? ORDER BY h.created_at, h.history_id";
        List<OrderStatusHistory> list = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderStatusHistory h = new OrderStatusHistory();
                    h.setHistoryId(rs.getInt("history_id"));
                    h.setOrderId(rs.getInt("order_id"));
                    String old = rs.getString("old_status");
                    h.setOldStatus(old == null ? null : OrderStatus.fromDb(old));
                    h.setNewStatus(OrderStatus.fromDb(rs.getString("new_status")));
                    h.setChangedByName(rs.getString("changed_by_name"));
                    h.setNote(rs.getString("note"));
                    h.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    list.add(h);
                }
            }
        }
        return list;
    }
}
