package com.tmdt.dao;

import com.tmdt.model.FilterOption;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static com.tmdt.util.DBConnection.getConnection;

/** Danh sách lựa chọn cho các ô lọc: danh mục, vật liệu, nhà cung cấp. */
public class CatalogDAO {

    public List<FilterOption> findActiveCategories() throws SQLException {
        return options("SELECT category_id, name FROM categories WHERE is_active = TRUE ORDER BY name");
    }

    public List<FilterOption> findActiveMaterials() throws SQLException {
        return options("SELECT material_id, name FROM materials WHERE is_active = TRUE ORDER BY name");
    }

    public List<FilterOption> findActiveSuppliers() throws SQLException {
        return options("SELECT supplier_id, shop_name FROM supplier_profiles WHERE status = 'ACTIVE' ORDER BY shop_name");
    }

    private List<FilterOption> options(String sql) throws SQLException {
        List<FilterOption> list = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new FilterOption(rs.getInt(1), rs.getString(2)));
            }
        }
        return list;
    }
}