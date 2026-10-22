package com.tmdt.model;

/** Trạng thái thanh toán — khớp CHECK constraint của bảng payments. */
public enum PaymentStatus {
    PENDING("Chưa thanh toán"),
    PAID("Đã thanh toán"),
    FAILED("Thanh toán thất bại"),
    REFUNDED("Đã hoàn tiền");

    private final String label;

    PaymentStatus(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }

    public String getCode() {
        return name();
    }

    public String getCss() {
        return name().toLowerCase();
    }

    public static PaymentStatus fromDb(String value) {
        if (value == null) return PENDING;
        try {
            return valueOf(value.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return PENDING;
        }
    }
}
