package com.tmdt.service;

import com.tmdt.dao.OrderDAO;
import com.tmdt.dao.PromotionDAO;
import com.tmdt.model.Cart;
import com.tmdt.model.CartItem;
import com.tmdt.model.Promotion;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

import static com.tmdt.util.DBConnection.getConnection;

/**
 * Kiểm tra và tính tiền mã khuyến mãi. Toàn bộ quy tắc nằm ở server:
 *
 *   1. Mã có tồn tại không?
 *   2. Mã có đang hoạt động (is_active) không?
 *   3. Đã đến start_date chưa? / Đã quá end_date chưa?
 *   4. Giá trị đơn hàng có đạt min_order_value không?
 *   5. Mã còn lượt dùng không (usage_limit / used_count)?
 *   6. Mã có áp dụng được cho đơn hiện tại không (shop_id)?
 *   7. Số tiền giảm > 0 và không vượt quá giá trị đơn (tổng không âm).
 *
 * Trang thanh toán dùng {@link #preview(String, Cart)} chỉ để hiển thị.
 * Lúc đặt hàng, OrderService gọi {@link #validateForOrder(Connection, String, BigDecimal)}
 * để kiểm tra lại trên dòng promotions đã khóa (FOR UPDATE) trong cùng transaction.
 */
public class PromotionService {

    /** Tên attribute trong HttpSession đang giữ mã khách đã áp dụng. */
    public static final String SESSION_KEY = "promotionCode";

    private final PromotionDAO promotionDAO = new PromotionDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    /** Kết quả kiểm tra mã. */
    public record Preview(boolean valid, String message, Promotion promotion, BigDecimal discount) {
        public static Preview fail(String message) {
            return new Preview(false, message, null, BigDecimal.ZERO.setScale(2));
        }

        static Preview ok(Promotion promotion, BigDecimal discount) {
            return new Preview(true, "Mã khuyến mãi hợp lệ.", promotion, discount);
        }
    }

    // ---------------------------------------------------------------------
    // Trang thanh toán (chỉ đọc)
    // ---------------------------------------------------------------------

    public Preview preview(String rawCode, Cart cart) {
        if (cart == null || cart.isEmpty()) {
            return Preview.fail("Giỏ hàng đang trống, chưa áp dụng được mã khuyến mãi.");
        }
        BigDecimal subtotal = money(cart.getTotal());

        Promotion promotion;
        try {
            Optional<Promotion> found = promotionDAO.findByCode(rawCode);
            if (found.isEmpty()) {
                return Preview.fail("Mã khuyến mãi không tồn tại.");
            }
            promotion = found.get();
        } catch (SQLException e) {
            throw new IllegalStateException("Không kiểm tra được mã khuyến mãi", e);
        }

        Preview checked = validate(promotion, subtotal);
        if (!checked.valid()) {
            return checked;
        }
        if (promotion.getShopId() != null && !cartBelongsToShop(cart, promotion.getShopId())) {
            return Preview.fail("Mã khuyến mãi này chỉ áp dụng cho đơn hàng của xưởng tương ứng.");
        }
        return checked;
    }

    // ---------------------------------------------------------------------
    // Đặt hàng (trong transaction, khóa dòng mã)
    // ---------------------------------------------------------------------

    public Preview validateForOrder(Connection conn, String rawCode, BigDecimal subtotal)
            throws SQLException {
        Optional<Promotion> found = promotionDAO.findByCode(conn, rawCode, true);
        if (found.isEmpty()) {
            return Preview.fail("Mã khuyến mãi không tồn tại.");
        }
        return validate(found.get(), subtotal == null ? BigDecimal.ZERO : subtotal);
    }

    // ---------------------------------------------------------------------

    /** Các quy tắc chung, không phụ thuộc giỏ/xưởng. */
    private Preview validate(Promotion promotion, BigDecimal subtotal) {
        LocalDateTime now = LocalDateTime.now();

        if (!promotion.isActive()) {
            return Preview.fail("Mã khuyến mãi đang tạm dừng áp dụng.");
        }
        if (promotion.getStartDate() != null && now.isBefore(promotion.getStartDate())) {
            return Preview.fail("Mã khuyến mãi chưa đến thời gian áp dụng (từ "
                    + promotion.getStartDateText() + ").");
        }
        if (promotion.getEndDate() != null && now.isAfter(promotion.getEndDate())) {
            return Preview.fail("Mã khuyến mãi đã hết hạn sử dụng (hết hạn "
                    + promotion.getEndDateText() + ").");
        }
        if (promotion.getMinOrderValue() != null
                && subtotal.compareTo(promotion.getMinOrderValue()) < 0) {
            return Preview.fail("Đơn hàng tối thiểu " + formatVnd(promotion.getMinOrderValue())
                    + " mới dùng được mã này.");
        }
        if (promotion.getUsageLimit() != null && promotion.getUsedCount() >= promotion.getUsageLimit()) {
            return Preview.fail("Mã khuyến mãi đã hết lượt sử dụng.");
        }

        BigDecimal discount = promotion.discountFor(subtotal);
        if (discount.signum() <= 0) {
            return Preview.fail("Mã khuyến mãi không giảm được giá trị nào cho đơn hàng này.");
        }
        return Preview.ok(promotion, discount);
    }

    /**
     * Mã gắn với một shop chỉ dùng được khi TẤT CẢ sản phẩm trong giỏ thuộc shop đó.
     * Mã toàn sàn (shop_id NULL) không cần kiểm tra bước này.
     */
    private boolean cartBelongsToShop(Cart cart, int shopId) {
        Set<Integer> supplierIds = new HashSet<>();
        for (CartItem item : cart.getItems()) {
            supplierIds.add(item.getSupplierId());
        }
        try (Connection conn = getConnection()) {
            for (Integer supplierId : supplierIds) {
                if (supplierId == null || supplierId <= 0) return false;
                Optional<Integer> supplierShop = orderDAO.findShopIdBySupplier(conn, supplierId);
                if (supplierShop.isEmpty() || supplierShop.get() != shopId) {
                    return false;
                }
            }
            return !supplierIds.isEmpty();
        } catch (SQLException e) {
            throw new IllegalStateException("Không kiểm tra được phạm vi xưởng của mã khuyến mãi", e);
        }
    }

    /** Chia số tiền giảm của cả giỏ cho từng đơn (mỗi xưởng một đơn), không làm tổng âm. */
    public static BigDecimal shareOf(BigDecimal totalDiscount, BigDecimal orderSubtotal,
                                     BigDecimal cartSubtotal) {
        if (totalDiscount == null || totalDiscount.signum() <= 0
                || orderSubtotal == null || cartSubtotal == null || cartSubtotal.signum() <= 0) {
            return BigDecimal.ZERO.setScale(2);
        }
        BigDecimal share = totalDiscount.multiply(orderSubtotal)
                .divide(cartSubtotal, 2, RoundingMode.HALF_UP);
        if (share.compareTo(orderSubtotal) > 0) {
            share = orderSubtotal.setScale(2, RoundingMode.HALF_UP);
        }
        return share.max(BigDecimal.ZERO.setScale(2));
    }

    /** 50000 -> "50.000đ" (dấu chấm ngăn cách nghìn, không phụ thuộc locale máy chủ). */
    public static String formatVnd(BigDecimal amount) {
        if (amount == null) return "0đ";
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setGroupingSeparator('.');
        DecimalFormat format = new DecimalFormat("#,##0", symbols);
        return format.format(amount.setScale(0, RoundingMode.HALF_UP)) + "đ";
    }

    public static BigDecimal money(long amount) {
        return BigDecimal.valueOf(amount).setScale(2, RoundingMode.HALF_UP);
    }
}
