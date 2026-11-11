package com.tmdt.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Giỏ hàng của MỘT người dùng, lưu trong HttpSession (attribute "cart").
 * Không dùng biến static: mỗi session có một giỏ riêng.
 *
 * Dòng giỏ được khóa theo productId + materialId, nên thêm cùng sản phẩm
 * nhiều lần chỉ tăng số lượng chứ không tạo dòng trùng.
 */
public class Cart implements Serializable {

    private final Map<String, CartItem> items = new LinkedHashMap<>();

    public static String keyOf(int productId, Integer materialId) {
        return productId + ":" + (materialId == null ? "0" : materialId);
    }

    /**
     * Thêm một dòng. Nếu dòng đã có thì cộng dồn số lượng nhưng không vượt tồn kho.
     * Giá và tồn kho luôn được cập nhật theo dữ liệu server vừa đọc.
     *
     * @return số lượng thực sự được cộng thêm (0 nếu đã đủ tồn kho)
     */
    public int add(CartItem item) {
        CartItem existing = items.get(item.getKey());
        if (existing == null) {
            items.put(item.getKey(), item);
            return item.getQuantity();
        }
        existing.setName(item.getName());
        existing.setSupplierId(item.getSupplierId());
        existing.setThumbnailUrl(item.getThumbnailUrl());
        existing.setMaterialName(item.getMaterialName());
        existing.setUnitPrice(item.getUnitPrice());
        existing.setMaxStock(item.getMaxStock());

        int before = existing.getQuantity();
        int target = Math.min(before + item.getQuantity(), item.getMaxStock());
        existing.setQuantity(target);
        return target - before;
    }

    /** @return true nếu dòng tồn tại và số lượng hợp lệ (1..maxStock). */
    public boolean updateQuantity(String key, int quantity) {
        CartItem item = items.get(key);
        if (item == null || quantity < 1 || quantity > item.getMaxStock()) {
            return false;
        }
        item.setQuantity(quantity);
        return true;
    }

    public void remove(String key) {
        items.remove(key);
    }

    public void clear() {
        items.clear();
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }

    public Collection<CartItem> getItems() {
        return items.values();
    }

    public CartItem get(String key) {
        return items.get(key);
    }

    /** Tổng số món (cộng dồn số lượng) — dùng cho badge trên header. */
    public int getItemCount() {
        int total = 0;
        for (CartItem item : items.values()) {
            total += item.getQuantity();
        }
        return total;
    }

    /** Tổng tiền tạm tính (VNĐ) theo giá đã chốt trong session. */
    public long getTotal() {
        long total = 0;
        for (CartItem item : items.values()) {
            total += item.getLineTotal();
        }
        return total;
    }
}
