package com.tmdt.model;

import java.time.LocalDateTime;

/**
 * One row of the `supplier_requests` table (luồng "Xin làm Nhà cung cấp").
 *
 * Đây là yêu cầu, KHÔNG phải hồ sơ nhà cung cấp: hồ sơ thật nằm ở
 * supplier_profiles và chỉ được tạo khi Admin duyệt.
 * Column widths (từ migration 05): shop_name 150, contact_phone 20,
 * address 300, description TEXT, reject_reason 500.
 */
public class SupplierRequest {

    private int requestId;
    private int userId;
    private String shopName;
    private String contactPhone;
    private String address;
    private String description;
    private SupplierRequestStatus status;
    private String rejectReason;
    private Integer reviewedBy;
    private LocalDateTime reviewedAt;
    private LocalDateTime createdAt;

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getShopName() {
        return shopName;
    }

    public void setShopName(String shopName) {
        this.shopName = shopName;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public SupplierRequestStatus getStatus() {
        return status;
    }

    public void setStatus(SupplierRequestStatus status) {
        this.status = status;
    }

    public String getRejectReason() {
        return rejectReason;
    }

    public void setRejectReason(String rejectReason) {
        this.rejectReason = rejectReason;
    }

    public Integer getReviewedBy() {
        return reviewedBy;
    }

    public void setReviewedBy(Integer reviewedBy) {
        this.reviewedBy = reviewedBy;
    }

    public LocalDateTime getReviewedAt() {
        return reviewedAt;
    }

    public void setReviewedAt(LocalDateTime reviewedAt) {
        this.reviewedAt = reviewedAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
