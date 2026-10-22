package com.tmdt.model;

/** Một vật liệu của sản phẩm kèm GIÁ riêng của vật liệu đó (bảng product_materials). */
public class ProductMaterial {
    private final int materialId;
    private final String name;
    private final long price;

    public ProductMaterial(int materialId, String name, long price) {
        this.materialId = materialId;
        this.name = name;
        this.price = price;
    }

    public int getMaterialId() { return materialId; }
    public String getName() { return name; }
    public long getPrice() { return price; }
}