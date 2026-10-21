package com.tmdt.model;

import java.util.ArrayList;
import java.util.List;

/** Sản phẩm đầy đủ cho trang chi tiết: kế thừa Product và thêm mô tả, vật liệu, ảnh, thông số, đánh giá. */
public class ProductDetail extends Product {
    private String description;
    private int stockQuantity;
    private double supplierAvgRating;
    private int supplierReviewCount;
    private String supplierAddress;
    private List<ProductMaterial> materials = new ArrayList<>();
    private List<ProductImage> images = new ArrayList<>();
    private List<ProductAttribute> attributes = new ArrayList<>();
    private List<Review> productReviews = new ArrayList<>();
    private List<Review> supplierReviews = new ArrayList<>();

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public double getSupplierAvgRating() { return supplierAvgRating; }
    public void setSupplierAvgRating(double supplierAvgRating) { this.supplierAvgRating = supplierAvgRating; }

    public int getSupplierReviewCount() { return supplierReviewCount; }
    public void setSupplierReviewCount(int supplierReviewCount) { this.supplierReviewCount = supplierReviewCount; }

    public String getSupplierAddress() { return supplierAddress; }
    public void setSupplierAddress(String supplierAddress) { this.supplierAddress = supplierAddress; }

    public List<ProductMaterial> getMaterials() { return materials; }
    public void setMaterials(List<ProductMaterial> materials) { this.materials = materials; }

    public List<ProductImage> getImages() { return images; }
    public void setImages(List<ProductImage> images) { this.images = images; }

    public List<ProductAttribute> getAttributes() { return attributes; }
    public void setAttributes(List<ProductAttribute> attributes) { this.attributes = attributes; }

    public List<Review> getProductReviews() { return productReviews; }
    public void setProductReviews(List<Review> productReviews) { this.productReviews = productReviews; }

    public List<Review> getSupplierReviews() { return supplierReviews; }
    public void setSupplierReviews(List<Review> supplierReviews) { this.supplierReviews = supplierReviews; }
}