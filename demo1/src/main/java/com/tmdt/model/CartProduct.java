package com.tmdt.model;

/**
 * Dữ liệu tối thiểu của một sản phẩm đang bán, dùng cho giỏ hàng và bước
 * đặt hàng. Giá và tồn kho LUÔN đọc từ DB, không nhận từ trình duyệt.
 */
public class CartProduct {
    private final int productId;
    private final int supplierId;
    private final String supplierName;
    private final String name;
    private final String thumbnailUrl;
    private final long price;
    private final int stockQuantity;

    public CartProduct(int productId, int supplierId, String supplierName, String name,
                       String thumbnailUrl, long price, int stockQuantity) {
        this.productId = productId;
        this.supplierId = supplierId;
        this.supplierName = supplierName;
        this.name = name;
        this.thumbnailUrl = thumbnailUrl;
        this.price = price;
        this.stockQuantity = stockQuantity;
    }

    public int getProductId() { return productId; }

    public int getSupplierId() { return supplierId; }

    public String getSupplierName() { return supplierName; }

    public String getName() { return name; }

    public String getThumbnailUrl() { return thumbnailUrl; }

    /** Giá "từ" (products.price). Giá theo vật liệu do ProductDAO trả riêng. */
    public long getPrice() { return price; }

    public int getStockQuantity() { return stockQuantity; }
}
