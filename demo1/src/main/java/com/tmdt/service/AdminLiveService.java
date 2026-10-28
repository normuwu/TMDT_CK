package com.tmdt.service;

import com.tmdt.dao.AdminLiveDAO;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * Dữ liệu thật cho các màn hình admin từng dùng seed localStorage:
 * bảng điều khiển, sản phẩm, đơn hàng, xưởng in.
 *
 * Quy ước:
 *  - Doanh thu / cơ cấu dùng chung định nghĩa với AdminStatsService
 *    (đơn COMPLETED, doanh thu theo completed_at).
 *  - Sản phẩm: status DB là ACTIVE/HIDDEN; "sắp hết hàng" = ACTIVE và tồn <= 10.
 *  - Đơn hàng: trạng thái DB PENDING/CONFIRMED/SHIPPING/COMPLETED/CANCELLED.
 *  - Xưởng in: supplier_profiles; đơn/doanh thu 30 ngày tính qua order_items.
 */
public class AdminLiveService {

    private static final Set<String> PRODUCT_STATUS = Set.of("ACTIVE", "HIDDEN");
    private static final Set<String> ORDER_STATUS =
            Set.of("PENDING", "CONFIRMED", "SHIPPING", "COMPLETED", "CANCELLED");
    private static final Set<String> SUPPLIER_SORTS = Set.of("revenue", "orders", "rating", "name");

    private final AdminLiveDAO dao = new AdminLiveDAO();
    private final AdminStatsService stats = new AdminStatsService();

    public record Page<T>(List<T> items, long total, int page, int size, int totalPages) {
    }

    public record SupplierSlice(String name, BigDecimal value) {
    }

    public record Dashboard(AdminLiveDAO.Kpi kpi,
                            List<AdminStatsService.Bucket> bars,
                            List<AdminStatsService.Slice> categories,
                            List<SupplierSlice> topShops,
                            List<AdminLiveDAO.RecentOrder> recentOrders,
                            List<AdminLiveDAO.RecentOrder> pendingOrders,
                            AdminLiveDAO.ProductCounts productCounts,
                            AdminLiveDAO.OrderCounts orderCounts) {
    }

    // ------------------------------------------------------------------
    // Bảng điều khiển
    // ------------------------------------------------------------------

    public Dashboard dashboard() throws SQLException {
        LocalDate today = LocalDate.now();
        AdminStatsService.RevenueResult week = stats.revenue(
                today.minusDays(6).toString(), today.toString(), "day");
        AdminStatsService.BreakdownResult categories = stats.breakdown(
                today.withDayOfMonth(1).toString(), today.toString(), "category", "revenue");
        AdminStatsService.BreakdownResult shops = stats.breakdown(
                today.withDayOfMonth(1).toString(), today.toString(), "shop", "revenue");

        List<SupplierSlice> topShops = new ArrayList<>();
        for (AdminStatsService.Slice slice : shops.slices()) {
            topShops.add(new SupplierSlice(slice.name(), slice.value()));
        }

        return new Dashboard(dao.kpi(), week.buckets(), categories.slices(), topShops,
                dao.recentOrders(6), dao.pendingOrders(5),
                dao.productCounts(), dao.orderCounts());
    }

    // ------------------------------------------------------------------
    // Sản phẩm
    // ------------------------------------------------------------------

    public Page<AdminLiveDAO.Product> products(String q, String categoryRaw, String statusRaw,
                                               String lowRaw, String pageRaw, String sizeRaw)
            throws SQLException {
        int page = page(pageRaw);
        int size = size(sizeRaw);

        Long categoryId = null;
        if (categoryRaw != null && !categoryRaw.isBlank()) {
            try {
                categoryId = Long.valueOf(categoryRaw.trim());
                if (categoryId <= 0) {
                    throw new NumberFormatException();
                }
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Nhóm sản phẩm không hợp lệ.");
            }
        }

        String status = null;
        if (statusRaw != null && !statusRaw.isBlank()) {
            status = statusRaw.trim().toUpperCase();
            if (!PRODUCT_STATUS.contains(status)) {
                throw new IllegalArgumentException("Trạng thái sản phẩm không hợp lệ.");
            }
        }
        boolean lowOnly = "1".equals(lowRaw) || "true".equalsIgnoreCase(lowRaw);

        long total = dao.countProducts(q, categoryId, status, lowOnly);
        List<AdminLiveDAO.Product> items = total == 0
                ? List.of()
                : dao.products(q, categoryId, status, lowOnly, size, (page - 1) * size);
        return new Page<>(items, total, page, size, totalPages(total, size));
    }

    public List<AdminLiveDAO.Category> productCategories() throws SQLException {
        return dao.categories();
    }

    public AdminLiveDAO.ProductCounts productCounts() throws SQLException {
        return dao.productCounts();
    }

    // ------------------------------------------------------------------
    // Đơn hàng
    // ------------------------------------------------------------------

    public Page<AdminLiveDAO.Order> orders(String q, String statusRaw, String shopRaw,
                                           String daysRaw, String pageRaw, String sizeRaw)
            throws SQLException {
        int page = page(pageRaw);
        int size = size(sizeRaw);

        String status = null;
        if (statusRaw != null && !statusRaw.isBlank()) {
            status = statusRaw.trim().toUpperCase();
            if (!ORDER_STATUS.contains(status)) {
                throw new IllegalArgumentException("Trạng thái đơn hàng không hợp lệ.");
            }
        }

        Long shopId = null;
        if (shopRaw != null && !shopRaw.isBlank()) {
            try {
                shopId = Long.valueOf(shopRaw.trim());
                if (shopId <= 0) {
                    throw new NumberFormatException();
                }
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Xưởng in không hợp lệ.");
            }
        }

        Integer days = null;
        if (daysRaw != null && !daysRaw.isBlank()) {
            try {
                int value = Integer.parseInt(daysRaw.trim());
                if (value != 7 && value != 30) {
                    throw new IllegalArgumentException("Khoảng thời gian chỉ nhận 7 hoặc 30 ngày.");
                }
                days = value;
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Khoảng thời gian không hợp lệ.");
            }
        }

        long total = dao.countOrders(q, status, shopId, days);
        List<AdminLiveDAO.Order> items = total == 0
                ? List.of()
                : dao.orders(q, status, shopId, days, size, (page - 1) * size);
        return new Page<>(items, total, page, size, totalPages(total, size));
    }

    public List<AdminLiveDAO.ShopRef> shops() throws SQLException {
        return dao.shops();
    }

    public AdminLiveDAO.OrderCounts orderCounts() throws SQLException {
        return dao.orderCounts();
    }

    // ------------------------------------------------------------------
    // Xưởng in
    // ------------------------------------------------------------------

    public Page<AdminLiveDAO.Supplier> suppliers(String q, String sortRaw,
                                                 String pageRaw, String sizeRaw)
            throws SQLException {
        int page = page(pageRaw);
        int size = size(sizeRaw);
        String sort = sortRaw == null || sortRaw.isBlank()
                ? "revenue" : sortRaw.trim().toLowerCase();
        if (!SUPPLIER_SORTS.contains(sort)) {
            throw new IllegalArgumentException("Kiểu sắp xếp không hợp lệ.");
        }
        long total = dao.countSuppliers(q);
        List<AdminLiveDAO.Supplier> items = total == 0
                ? List.of()
                : dao.suppliers(q, sort, size, (page - 1) * size);
        return new Page<>(items, total, page, size, totalPages(total, size));
    }

    public AdminLiveDAO.SupplierCounts supplierCounts() throws SQLException {
        return dao.supplierCounts();
    }

    // ------------------------------------------------------------------
    // Helpers
    // ------------------------------------------------------------------

    private static int page(String raw) {
        if (raw == null || raw.isBlank()) {
            return 1;
        }
        try {
            int value = Integer.parseInt(raw.trim());
            if (value < 1) {
                throw new IllegalArgumentException("Số trang phải lớn hơn 0.");
            }
            return value;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Số trang không hợp lệ.");
        }
    }

    private static int size(String raw) {
        if (raw == null || raw.isBlank()) {
            return 20;
        }
        try {
            int value = Integer.parseInt(raw.trim());
            if (value < 1 || value > 100) {
                throw new IllegalArgumentException("Số dòng mỗi trang phải từ 1 đến 100.");
            }
            return value;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Số dòng mỗi trang không hợp lệ.");
        }
    }

    private static int totalPages(long total, int size) {
        return total == 0 ? 0 : (int) ((total + size - 1) / size);
    }
}
