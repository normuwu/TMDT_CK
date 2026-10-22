package com.tmdt.model;

/** Trạng thái đơn hàng — khớp CHECK constraint của bảng orders. */
public enum OrderStatus {
    PENDING("Chờ xác nhận"),
    CONFIRMED("Đã xác nhận"),
    SHIPPING("Đang giao hàng"),
    COMPLETED("Đã giao hàng"),
    CANCELLED("Đã hủy");

    private final String label;

    OrderStatus(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }

    public String getCode() {
        return name();
    }

    /** CSS class cho badge trạng thái. */
    public String getCss() {
        return name().toLowerCase();
    }

    public static OrderStatus fromDb(String value) {
        if (value == null) return PENDING;
        try {
            return valueOf(value.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return PENDING;
        }
    }
}
