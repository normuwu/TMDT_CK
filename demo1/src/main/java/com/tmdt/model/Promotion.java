package com.tmdt.model;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Mã khuyến mãi — ánh xạ bảng promotions (MySQL: tmdt.promotions).
 *
 * shop_id = NULL  -> mã dùng chung toàn sàn.
 * shop_id != NULL -> chỉ áp dụng cho đơn của xưởng đó (xem PromotionService).
 *
 * Việc tính tiền giảm LUÔN chạy ở server (PromotionService / OrderService),
 * không bao giờ lấy số tiền từ trình duyệt.
 */
public class Promotion {

    public static final String TYPE_PERCENTAGE = "PERCENTAGE";
    public static final String TYPE_FIXED_AMOUNT = "FIXED_AMOUNT";

    private static final BigDecimal HUNDRED = new BigDecimal("100");
    private static final DateTimeFormatter DATE_TIME = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    private int promotionId;
    private Integer shopId;
    private String code;
    private String name;
    private String discountType;
    private BigDecimal discountValue = BigDecimal.ZERO;
    private BigDecimal maxDiscountAmount;               // chỉ dùng cho PERCENTAGE, có thể NULL
    private BigDecimal minOrderValue = BigDecimal.ZERO;
    private Integer usageLimit;                          // NULL = không giới hạn
    private int usedCount;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private boolean active;

    public boolean isPercentage() {
        return TYPE_PERCENTAGE.equalsIgnoreCase(discountType);
    }

    /**
     * Số tiền giảm cho một giá trị đơn hàng.
     * - PERCENTAGE : subtotal × discount_value% , chặn trên bởi max_discount_amount.
     * - FIXED_AMOUNT: discount_value.
     * Không bao giờ lớn hơn subtotal (nên tổng sau giảm không âm) và không âm.
     */
    public BigDecimal discountFor(BigDecimal subtotal) {
        if (subtotal == null || subtotal.signum() <= 0 || discountValue == null) {
            return BigDecimal.ZERO.setScale(2);
        }
        BigDecimal discount;
        if (isPercentage()) {
            discount = subtotal.multiply(discountValue).divide(HUNDRED, 2, RoundingMode.HALF_UP);
            if (maxDiscountAmount != null && maxDiscountAmount.signum() > 0
                    && discount.compareTo(maxDiscountAmount) > 0) {
                discount = maxDiscountAmount;
            }
        } else {
            discount = discountValue;
        }
        if (discount.compareTo(subtotal) > 0) {
            discount = subtotal;
        }
        if (discount.signum() < 0) {
            return BigDecimal.ZERO.setScale(2);
        }
        return discount.setScale(2, RoundingMode.HALF_UP);
    }

    /** Nhãn hiển thị: "Giảm 10%" hoặc "Giảm 20.000đ". */
    public String getDiscountLabel() {
        if (isPercentage()) {
            String percent = discountValue.stripTrailingZeros().toPlainString();
            return "Giảm " + percent + "%";
        }
        return "Giảm " + discountValue.setScale(0, RoundingMode.HALF_UP).toPlainString() + "đ";
    }

    public String getStartDateText() {
        return startDate == null ? "" : startDate.format(DATE_TIME);
    }

    public String getEndDateText() {
        return endDate == null ? "" : endDate.format(DATE_TIME);
    }

    public int getPromotionId() { return promotionId; }
    public void setPromotionId(int promotionId) { this.promotionId = promotionId; }

    public Integer getShopId() { return shopId; }
    public void setShopId(Integer shopId) { this.shopId = shopId; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }

    public BigDecimal getDiscountValue() { return discountValue; }
    public void setDiscountValue(BigDecimal discountValue) { this.discountValue = discountValue; }

    public BigDecimal getMaxDiscountAmount() { return maxDiscountAmount; }
    public void setMaxDiscountAmount(BigDecimal maxDiscountAmount) { this.maxDiscountAmount = maxDiscountAmount; }

    public BigDecimal getMinOrderValue() { return minOrderValue; }
    public void setMinOrderValue(BigDecimal minOrderValue) { this.minOrderValue = minOrderValue; }

    public Integer getUsageLimit() { return usageLimit; }
    public void setUsageLimit(Integer usageLimit) { this.usageLimit = usageLimit; }

    public int getUsedCount() { return usedCount; }
    public void setUsedCount(int usedCount) { this.usedCount = usedCount; }

    public LocalDateTime getStartDate() { return startDate; }
    public void setStartDate(LocalDateTime startDate) { this.startDate = startDate; }

    public LocalDateTime getEndDate() { return endDate; }
    public void setEndDate(LocalDateTime endDate) { this.endDate = endDate; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
