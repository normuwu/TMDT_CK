package com.tmdt.dao;

import com.tmdt.model.OrderItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static com.tmdt.util.DBConnection.getConnection;

/**
 * Pure JDBC cho bảng order_items.
 * Ghi: nhận Connection của OrderService (cùng transaction với orders).
 * Đọc: tự lấy connection từ pool.
 */
public class OrderItemDAO {

    /** Insert một dòng chi tiết đơn (giá là snapshot tại thời điểm đặt). */
    public void insert(Connection conn, int orderId, OrderItem item) throws SQLException {
        final String sql = "INSERT INTO order_items "
                + "(order_id, product_id, product_name_snapshot, unit_price, quantity, line_total) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, item.getProductId());
            ps.setString(3, item.getProductName());
            ps.setBigDecimal(4, item.getUnitPrice());
            ps.setInt(5, item.getQuantity());
            ps.setBigDecimal(6, item.getLineTotal());
            ps.executeUpdate();
        }
    }

    /** Các sản phẩm của một đơn, giữ nguyên giá lúc mua. */
    public List<OrderItem> findByOrderId(int orderId) throws SQLException {
        try (Connection conn = getConnection()) {
            return findByOrderId(conn, orderId);
        }
    }

    /** Bản dùng trong transaction (ví dụ: hoàn kho khi hủy đơn). */
    public List<OrderItem> findByOrderId(Connection conn, int orderId) throws SQLException {
        final String sql = "SELECT order_item_id, product_id, product_name_snapshot, "
                + "unit_price, quantity, line_total "
                + "FROM order_items WHERE order_id = ? ORDER BY order_item_id";
        List<OrderItem> items = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setOrderItemId(rs.getInt("order_item_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setProductName(rs.getString("product_name_snapshot"));
                    item.setUnitPrice(rs.getBigDecimal("unit_price"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setLineTotal(rs.getBigDecimal("line_total"));
                    items.add(item);
                }
            }
        }
        return items;
    }
}
