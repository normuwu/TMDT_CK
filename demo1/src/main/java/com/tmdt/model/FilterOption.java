package com.tmdt.model;

/** Một lựa chọn (id + tên) cho các ô lọc: danh mục, vật liệu, nhà cung cấp. */
public class FilterOption {
    private final int id;
    private final String name;

    public FilterOption(int id, String name) {
        this.id = id;
        this.name = name;
    }

    public int getId() { return id; }
    public String getName() { return name; }
}