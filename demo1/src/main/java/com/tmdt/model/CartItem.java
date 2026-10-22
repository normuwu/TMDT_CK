package com.tmdt.model;

import java.io.Serializable;

/**
 * Một dòng trong giỏ hàng. Giỏ nằm trong HttpSession nên class phải Serializable.
 * Khóa dòng = productId + materialId (một sản phẩm có thể được mua với nhiều vật liệu).
 */
public class CartItem implements Serializable {

    private int productId;
    private Integer materialId;      // null = không chọn vật liệu
    private String materialName;
    private String name;
    private String thumbnailUrl;
    private long unitPrice;          // VNĐ, lấy từ DB tại thời điểm thêm
    private int quantity;
    private int maxStock;            // tồn kho hiện tại của sản phẩm

    public String getKey() {
        return Cart.keyOf(productId, materialId);
    }

    /** Đơn giá × số lượng (VNĐ). */
    public long getLineTotal() {
        return unitPrice * quantity;
    }

    /** Tên hiển thị kèm vật liệu, ví dụ "Tượng rồng 15cm (PLA)". */
    public String getDisplayName() {
        return materialName == null || materialName.isBlank()
                ? name
                : name + " (" + materialName + ")";
    }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public Integer getMaterialId() { return materialId; }
    public void setMaterialId(Integer materialId) { this.materialId = materialId; }

    public String getMaterialName() { return materialName; }
    public void setMaterialName(String materialName) { this.materialName = materialName; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getThumbnailUrl() { return thumbnailUrl; }
    public void setThumbnailUrl(String thumbnailUrl) { this.thumbnailUrl = thumbnailUrl; }

    public long getUnitPrice() { return unitPrice; }
    public void setUnitPrice(long unitPrice) { this.unitPrice = unitPrice; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public int getMaxStock() { return maxStock; }
    public void setMaxStock(int maxStock) { this.maxStock = maxStock; }
}
