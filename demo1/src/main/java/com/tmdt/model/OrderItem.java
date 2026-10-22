package com.tmdt.model;

import java.math.BigDecimal;

/**
 * Một sản phẩm trong đơn hàng. unitPrice là GIÁ TẠI THỜI ĐIỂM ĐẶT HÀNG
 * (snapshot), không đọc lại từ products khi xem lịch sử.
 */
public class OrderItem {
    private int orderItemId;
    private int productId;
    private String productName;
    private BigDecimal unitPrice = BigDecimal.ZERO;
    private int quantity;
    private BigDecimal lineTotal = BigDecimal.ZERO;

    public int getOrderItemId() { return orderItemId; }
    public void setOrderItemId(int orderItemId) { this.orderItemId = orderItemId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getLineTotal() { return lineTotal; }
    public void setLineTotal(BigDecimal lineTotal) { this.lineTotal = lineTotal; }
}
