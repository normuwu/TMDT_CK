package com.tmdt.model;

/** Một thông số "tên - giá trị" của sản phẩm (bảng product_attributes). */
public class ProductAttribute {
    private final String name;
    private final String value;

    public ProductAttribute(String name, String value) {
        this.name = name;
        this.value = value;
    }

    public String getName() { return name; }
    public String getValue() { return value; }
}