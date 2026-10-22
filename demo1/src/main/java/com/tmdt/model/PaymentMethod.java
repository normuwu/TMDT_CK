package com.tmdt.model;

/**
 * Phương thức thanh toán của đơn hàng.
 * Hiện chỉ COD được ghi vào DB (bảng payments chỉ cho phép ONLINE/COD);
 * BANK_TRANSFER mới ở mức giao diện và sẽ trả thông báo "đang phát triển".
 */
public enum PaymentMethod {
    COD("COD", "Thanh toán khi nhận hàng (COD)"),
    BANK_TRANSFER("BANK_TRANSFER", "Chuyển khoản ngân hàng");

    private final String code;
    private final String label;

    PaymentMethod(String code, String label) {
        this.code = code;
        this.label = label;
    }

    public String getCode() {
        return code;
    }

    public String getLabel() {
        return label;
    }

    /** Mã gửi từ form (chỉ nhận đúng 2 giá trị này). */
    public static PaymentMethod fromForm(String value) {
        if (value == null) return null;
        for (PaymentMethod m : values()) {
            if (m.code.equalsIgnoreCase(value.trim())) return m;
        }
        return null;
    }

    /** Mã trong bảng payments (ONLINE/COD). */
    public static PaymentMethod fromDb(String value) {
        if ("COD".equalsIgnoreCase(value)) return COD;
        if ("ONLINE".equalsIgnoreCase(value)) return BANK_TRANSFER;
        return null;
    }

    public static PaymentMethod fromDbOrDefault(String value) {
        PaymentMethod m = fromDb(value);
        return m == null ? COD : m;
    }
}
