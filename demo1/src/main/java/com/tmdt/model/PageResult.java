package com.tmdt.model;

import java.util.Collections;
import java.util.List;

/** Một trang kết quả kèm thông tin phân trang. */
public class PageResult<T> {
    private final List<T> items;
    private final int page;
    private final int pageSize;
    private final long totalItems;

    public PageResult(List<T> items, int page, int pageSize, long totalItems) {
        this.items = items;
        this.page = page;
        this.pageSize = pageSize;
        this.totalItems = totalItems;
    }

    public static <T> PageResult<T> empty(int pageSize) {
        return new PageResult<>(Collections.emptyList(), 1, pageSize, 0);
    }

    public List<T> getItems() { return items; }
    public int getPage() { return page; }
    public int getPageSize() { return pageSize; }
    public long getTotalItems() { return totalItems; }

    public int getTotalPages() {
        return (int) Math.max(1, (totalItems + pageSize - 1) / pageSize);
    }

    public boolean isHasPrev() { return page > 1; }
    public boolean isHasNext() { return page < getTotalPages(); }
}