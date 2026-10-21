package com.tmdt.model;

/** Một ảnh của sản phẩm (bảng product_images). */
public class ProductImage {
    private final String imageUrl;
    private final boolean primary;

    public ProductImage(String imageUrl, boolean primary) {
        this.imageUrl = imageUrl;
        this.primary = primary;
    }

    public String getImageUrl() { return imageUrl; }
    public boolean isPrimary() { return primary; }
}