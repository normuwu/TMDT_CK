package com.tmdt.model;

/** Các kiểu sắp xếp của trang sản phẩm. code = giá trị tham số ?sort=. */
public enum ProductSort {
    NEWEST("newest", "Mới nhất"),
    BEST_SELLING("best_selling", "Bán chạy"),
    PRICE_ASC("price_asc", "Giá tăng dần"),
    PRICE_DESC("price_desc", "Giá giảm dần"),
    NAME_ASC("name_asc", "Tên A-Z"),
    NAME_DESC("name_desc", "Tên Z-A");

    private final String code;
    private final String label;

    ProductSort(String code, String label) {
        this.code = code;
        this.label = label;
    }

    public String getCode() {
        return code;
    }

    public String getLabel() {
        return label;
    }

    /** Giá trị lạ hoặc rỗng -> NEWEST (mặc định). */
    public static ProductSort fromCode(String code) {
        if (code != null) {
            for (ProductSort s : values()) {
                if (s.code.equals(code.trim())) return s;
            }
        }
        return NEWEST;
    }
}