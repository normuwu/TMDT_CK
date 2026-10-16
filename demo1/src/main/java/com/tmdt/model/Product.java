package com.tmdt.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Sản phẩm dùng cho trang danh sách (thẻ sản phẩm).
 * price = giá hiển thị: giá của vật liệu đang lọc, hoặc "giá từ" (thấp nhất).
 */
public class Product {
    private int productId;
    private int supplierId;
    private String supplierName;
    private int categoryId;
    private String categoryName;
    private String name;
    private String slug;
    private String shortDescription;
    private String thumbnailUrl;
    private long price;
    private int soldCount;
    private double avgRating;
    private int reviewCount;
    private LocalDateTime createdAt;
    private List<String> materialNames = new ArrayList<>();

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getSupplierId() { return supplierId; }
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }

    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }

    public String getShortDescription() { return shortDescription; }
    public void setShortDescription(String shortDescription) { this.shortDescription = shortDescription; }

    public String getThumbnailUrl() { return thumbnailUrl; }
    public void setThumbnailUrl(String thumbnailUrl) { this.thumbnailUrl = thumbnailUrl; }

    public long getPrice() { return price; }
    public void setPrice(long price) { this.price = price; }

    public int getSoldCount() { return soldCount; }
    public void setSoldCount(int soldCount) { this.soldCount = soldCount; }

    public double getAvgRating() { return avgRating; }
    public void setAvgRating(double avgRating) { this.avgRating = avgRating; }

    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public List<String> getMaterialNames() { return materialNames; }
    public void setMaterialNames(List<String> materialNames) { this.materialNames = materialNames; }
}