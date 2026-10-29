package com.tmdt.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static com.tmdt.util.DBConnection.getConnection;

/** Đọc danh sách xưởng in (shops + users) và số yêu cầu NCC đang chờ. */
public class AdminShopListDAO {

    public record ShopRow(int shopId, int userId, String shopName, String address,
                          String phone, String status, String createdAt, String email, String fullName) {
    }

    public List<ShopRow> listShops() throws SQLException {
        final String sql = "SELECT s.shop_id, s.user_id, s.shop_name, s.address, s.phone, s.status, "
                + "s.created_at, u.email, u.full_name "
                + "FROM shops s JOIN users u ON u.user_id = s.user_id "
                + "ORDER BY s.created_at DESC, s.shop_id DESC";
        List<ShopRow> rows = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                rows.add(new ShopRow(
                        rs.getInt("shop_id"),
                        rs.getInt("user_id"),
                        rs.getString("shop_name"),
                        rs.getString("address"),
                        rs.getString("phone"),
                        rs.getString("status"),
                        String.valueOf(rs.getTimestamp("created_at")),
                        rs.getString("email"),
                        rs.getString("full_name")));
            }
        }
        return rows;
    }

    public long countPendingRequests() throws SQLException {
        final String sql = "SELECT COUNT(*) FROM supplier_requests WHERE status = 'PENDING'";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getLong(1) : 0L;
        }
    }
}
