package com.tmdt.model;

/** Điều kiện lọc / sắp xếp / phân trang của danh sách sản phẩm. Trường null = không lọc. */
public class ProductFilter {
    public static final int DEFAULT_PAGE_SIZE = 12;

    private String keyword;
    private Integer categoryId;
    private Integer supplierId;
    private Integer materialId;
    private Long minPrice;
    private Long maxPrice;
    private ProductSort sort = ProductSort.NEWEST;
    private int page = 1;
    private int pageSize = DEFAULT_PAGE_SIZE;

    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }

    public Integer getCategoryId() { return categoryId; }
    public void setCategoryId(Integer categoryId) { this.categoryId = categoryId; }

    public Integer getSupplierId() { return supplierId; }
    public void setSupplierId(Integer supplierId) { this.supplierId = supplierId; }

    public Integer getMaterialId() { return materialId; }
    public void setMaterialId(Integer materialId) { this.materialId = materialId; }

    public Long getMinPrice() { return minPrice; }
    public void setMinPrice(Long minPrice) { this.minPrice = minPrice; }

    public Long getMaxPrice() { return maxPrice; }
    public void setMaxPrice(Long maxPrice) { this.maxPrice = maxPrice; }

    public ProductSort getSort() { return sort; }
    public void setSort(ProductSort sort) { this.sort = sort == null ? ProductSort.NEWEST : sort; }

    public int getPage() { return page; }
    public void setPage(int page) { this.page = Math.max(1, page); }

    public int getPageSize() { return pageSize; }
    public void setPageSize(int pageSize) { this.pageSize = Math.max(1, pageSize); }
}