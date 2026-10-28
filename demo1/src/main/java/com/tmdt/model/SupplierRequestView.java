package com.tmdt.model;

import java.time.format.DateTimeFormatter;

/**
 * Dữ liệu chỉ-đọc cho trang "Xin làm Nhà cung cấp" (JSP dùng EL nên cần
 * JavaBean getters, không dùng record).
 */
public class SupplierRequestView {

    private static final DateTimeFormatter DATE_TIME = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    private final String status;
    private final String statusLabel;
    private final String shopName;
    private final String contactPhone;
    private final String address;
    private final String description;
    private final String rejectReason;
    private final String submittedAt;
    private final String reviewedAt;

    private SupplierRequestView(String status, String statusLabel, String shopName,
                                String contactPhone, String address, String description,
                                String rejectReason, String submittedAt, String reviewedAt) {
        this.status = status;
        this.statusLabel = statusLabel;
        this.shopName = shopName;
        this.contactPhone = contactPhone;
        this.address = address;
        this.description = description;
        this.rejectReason = rejectReason;
        this.submittedAt = submittedAt;
        this.reviewedAt = reviewedAt;
    }

    /** null khi user chưa từng gửi yêu cầu. */
    public static SupplierRequestView from(SupplierRequest request) {
        if (request == null) {
            return null;
        }
        SupplierRequestStatus status = request.getStatus();
        return new SupplierRequestView(
                status == null ? "" : status.name(),
                label(status),
                request.getShopName(),
                request.getContactPhone(),
                request.getAddress(),
                request.getDescription(),
                request.getRejectReason(),
                request.getCreatedAt() == null ? "" : request.getCreatedAt().format(DATE_TIME),
                request.getReviewedAt() == null ? "" : request.getReviewedAt().format(DATE_TIME));
    }

    private static String label(SupplierRequestStatus status) {
        if (status == null) return "";
        return switch (status) {
            case PENDING -> "Đang chờ duyệt";
            case APPROVED -> "Đã được duyệt";
            case REJECTED -> "Bị từ chối";
        };
    }

    public String getStatus() {
        return status;
    }

    public String getStatusLabel() {
        return statusLabel;
    }

    public String getShopName() {
        return shopName;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public String getAddress() {
        return address;
    }

    public String getDescription() {
        return description;
    }

    public String getRejectReason() {
        return rejectReason;
    }

    public String getSubmittedAt() {
        return submittedAt;
    }

    public String getReviewedAt() {
        return reviewedAt;
    }
}
