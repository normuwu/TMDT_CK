package com.tmdt.model;

/**
 * Trạng thái của một yêu cầu "Xin làm Nhà cung cấp".
 * Mirror DB check constraint:
 * supplier_requests.status IN ('PENDING','APPROVED','REJECTED').
 *
 * Tách riêng khỏi Role: người gửi yêu cầu vẫn giữ role CUSTOMER cho tới khi
 * Admin duyệt.
 */
public enum SupplierRequestStatus {
    PENDING, APPROVED, REJECTED;

    /** Returns null when the value is not a valid status string. */
    public static SupplierRequestStatus fromString(String value) {
        if (value == null) return null;
        try {
            return SupplierRequestStatus.valueOf(value.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
