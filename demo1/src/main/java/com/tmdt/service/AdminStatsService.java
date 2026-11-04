package com.tmdt.service;

import com.tmdt.dao.AdminStatsDAO;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Thống kê doanh thu / cơ cấu cho Admin.
 *
 * Định nghĩa (theo yêu cầu):
 *  - Doanh thu = SUM(orders.total_amount) của đơn COMPLETED, theo DATE(completed_at).
 *  - Số đơn = số đơn COMPLETED cùng cách tính.
 *  - cancelRate = CANCELLED / tổng đơn TẠO trong kỳ (theo created_at) * 100.
 *  - "prev" = kỳ liền trước, cùng số ngày.
 *  - Tuần bắt đầu thứ Hai; mọi bucket rỗng vẫn được trả về với giá trị 0.
 */
public class AdminStatsService {

    private static final int MAX_RANGE_DAYS = 366;
    private static final Set<String> GROUPS = Set.of("day", "week", "month");
    private static final Set<String> DIMENSIONS = Set.of("category", "shop", "status");
    private static final Set<String> METRICS = Set.of("revenue", "orders");

    private static final DateTimeFormatter DM = DateTimeFormatter.ofPattern("dd/MM");
    private static final DateTimeFormatter DMY = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private static final BigDecimal HUNDRED = BigDecimal.valueOf(100);

    private final AdminStatsDAO dao = new AdminStatsDAO();

    public record Bucket(String key, String label, String title,
                         BigDecimal revenue, long orders) {
    }

    public record Kpi(BigDecimal revenue, long orders, BigDecimal avgOrder,
                      BigDecimal cancelRate) {
    }

    public record RevenueResult(String from, String to, String group,
                                List<Bucket> buckets, Kpi kpi, Kpi prev) {
    }

    public record Slice(String name, BigDecimal value) {
    }

    public record BreakdownResult(String by, String metric, BigDecimal total,
                                  List<Slice> slices) {
    }

    // ------------------------------------------------------------------
    // Doanh thu theo khoảng ngày
    // ------------------------------------------------------------------

    public RevenueResult revenue(String fromRaw, String toRaw, String groupRaw) throws SQLException {
        return revenue(fromRaw, toRaw, groupRaw, 0);
    }

    /** shopId = 0: toàn sàn (Admin); > 0: chỉ một xưởng (Người bán). */
    public RevenueResult revenue(String fromRaw, String toRaw, String groupRaw, int shopId) throws SQLException {
        LocalDate from = parseDate(fromRaw, "Từ ngày");
        LocalDate to = parseDate(toRaw, "Đến ngày");
        validateRange(from, to);

        String group = (groupRaw == null || groupRaw.isBlank())
                ? "day" : groupRaw.trim().toLowerCase();
        if (!GROUPS.contains(group)) {
            throw new IllegalArgumentException("Nhóm thời gian không hợp lệ (day, week hoặc month).");
        }

        List<AdminStatsDAO.DayRevenue> daily = dao.completedByDay(from, to.plusDays(1), shopId);
        Map<String, Bucket> buckets = buildBuckets(from, to, group);
        for (AdminStatsDAO.DayRevenue row : daily) {
            if (row.day().isBefore(from) || row.day().isAfter(to)) {
                continue;
            }
            Bucket bucket = buckets.get(bucketKey(row.day(), group));
            if (bucket != null) {
                buckets.put(bucket.key(), new Bucket(bucket.key(), bucket.label(), bucket.title(),
                        bucket.revenue().add(row.revenue()), bucket.orders() + row.orders()));
            }
        }

        Kpi kpi = kpiOf(from, to, daily, dao.createdByStatus(from, to.plusDays(1), shopId));
        long length = to.toEpochDay() - from.toEpochDay() + 1;
        LocalDate prevTo = from.minusDays(1);
        LocalDate prevFrom = prevTo.minusDays(length - 1);
        Kpi prev = kpiOf(prevFrom, prevTo,
                dao.completedByDay(prevFrom, prevTo.plusDays(1), shopId),
                dao.createdByStatus(prevFrom, prevTo.plusDays(1), shopId));

        return new RevenueResult(from.toString(), to.toString(), group,
                new ArrayList<>(buckets.values()), kpi, prev);
    }

    // ------------------------------------------------------------------
    // Cơ cấu (biểu đồ tròn)
    // ------------------------------------------------------------------

    public BreakdownResult breakdown(String fromRaw, String toRaw, String byRaw, String metricRaw)
            throws SQLException {
        return breakdown(fromRaw, toRaw, byRaw, metricRaw, 0);
    }

    public BreakdownResult breakdown(String fromRaw, String toRaw, String byRaw, String metricRaw, int shopId)
            throws SQLException {
        LocalDate from = parseDate(fromRaw, "Từ ngày");
        LocalDate to = parseDate(toRaw, "Đến ngày");
        validateRange(from, to);

        String by = byRaw == null || byRaw.isBlank() ? "category" : byRaw.trim().toLowerCase();
        if (!DIMENSIONS.contains(by)) {
            throw new IllegalArgumentException("Chiều thống kê không hợp lệ (category, shop hoặc status).");
        }
        String metric = metricRaw == null || metricRaw.isBlank()
                ? "revenue" : metricRaw.trim().toLowerCase();
        if (!METRICS.contains(metric)) {
            throw new IllegalArgumentException("Chỉ số không hợp lệ (revenue hoặc orders).");
        }
        if ("status".equals(by)) {
            metric = "orders"; // trạng thái luôn đếm theo số đơn
        }

        List<AdminStatsDAO.Slice> raw = dao.breakdown(by, metric, from, to.plusDays(1), shopId);

        BigDecimal total = BigDecimal.ZERO;
        List<Slice> slices = new ArrayList<>();
        for (AdminStatsDAO.Slice slice : raw) {
            BigDecimal value = slice.value() == null ? BigDecimal.ZERO : slice.value();
            if (value.signum() <= 0) {
                continue;
            }
            total = total.add(value);
            String name = "status".equals(by) ? statusLabel(slice.name()) : slice.name();
            slices.add(new Slice(name == null ? "Khác" : name, value));
        }

        // Quá 6 nhóm: giữ 6 nhóm lớn nhất, phần còn lại gộp vào "Khác".
        if (slices.size() > 6) {
            List<Slice> merged = new ArrayList<>(slices.subList(0, 6));
            BigDecimal rest = BigDecimal.ZERO;
            for (Slice slice : slices.subList(6, slices.size())) {
                rest = rest.add(slice.value());
            }
            if (rest.signum() > 0) {
                merged.add(new Slice("Khác", rest));
            }
            slices = merged;
        }
        return new BreakdownResult(by, metric, total, slices);
    }

    // ------------------------------------------------------------------
    // Helpers
    // ------------------------------------------------------------------

    private static LocalDate parseDate(String raw, String fieldName) {
        if (raw == null || raw.isBlank()) {
            throw new IllegalArgumentException(fieldName + " không được để trống.");
        }
        try {
            return LocalDate.parse(raw.trim());
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException(fieldName + " phải có định dạng YYYY-MM-DD.");
        }
    }

    private static void validateRange(LocalDate from, LocalDate to) {
        if (from.isAfter(to)) {
            throw new IllegalArgumentException("Từ ngày phải nhỏ hơn hoặc bằng Đến ngày.");
        }
        long days = to.toEpochDay() - from.toEpochDay() + 1;
        if (days > MAX_RANGE_DAYS) {
            throw new IllegalArgumentException("Khoảng thời gian tối đa là " + MAX_RANGE_DAYS + " ngày.");
        }
        if (to.isAfter(LocalDate.now())) {
            throw new IllegalArgumentException("Đến ngày không được vượt quá hôm nay.");
        }
    }

    /** Khung bucket theo thứ tự thời gian, giá trị khởi tạo 0. */
    private static Map<String, Bucket> buildBuckets(LocalDate from, LocalDate to, String group) {
        Map<String, Bucket> buckets = new LinkedHashMap<>();
        if ("day".equals(group)) {
            for (LocalDate d = from; !d.isAfter(to); d = d.plusDays(1)) {
                String key = d.toString();
                buckets.put(key, new Bucket(key, DM.format(d), DMY.format(d),
                        BigDecimal.ZERO, 0));
            }
        } else if ("week".equals(group)) {
            for (LocalDate monday = mondayOf(from); !monday.isAfter(to); monday = monday.plusDays(7)) {
                LocalDate start = monday.isBefore(from) ? from : monday;
                LocalDate end = monday.plusDays(6).isAfter(to) ? to : monday.plusDays(6);
                String key = monday.toString();
                buckets.put(key, new Bucket(key, DM.format(start),
                        DMY.format(start) + " – " + DMY.format(end), BigDecimal.ZERO, 0));
            }
        } else {
            YearMonth last = YearMonth.from(to);
            for (YearMonth ym = YearMonth.from(from); !ym.isAfter(last); ym = ym.plusMonths(1)) {
                LocalDate start = ym.atDay(1);
                LocalDate end = ym.atEndOfMonth();
                LocalDate clampedStart = start.isBefore(from) ? from : start;
                LocalDate clampedEnd = end.isAfter(to) ? to : end;
                boolean partial = !clampedStart.equals(start) || !clampedEnd.equals(end);
                String key = ym.toString();
                String title = "Tháng " + ym.getMonthValue() + "/" + ym.getYear()
                        + (partial ? " (" + DM.format(clampedStart) + " – " + DM.format(clampedEnd) + ")" : "");
                buckets.put(key, new Bucket(key,
                        "T" + ym.getMonthValue() + "/" + String.valueOf(ym.getYear()).substring(2),
                        title, BigDecimal.ZERO, 0));
            }
        }
        return buckets;
    }

    private static String bucketKey(LocalDate day, String group) {
        return switch (group) {
            case "week" -> mondayOf(day).toString();
            case "month" -> YearMonth.from(day).toString();
            default -> day.toString();
        };
    }

    private static LocalDate mondayOf(LocalDate day) {
        return day.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
    }

    private static Kpi kpiOf(LocalDate from, LocalDate to,
                             List<AdminStatsDAO.DayRevenue> daily,
                             Map<String, Long> createdByStatus) {
        BigDecimal revenue = BigDecimal.ZERO;
        long orders = 0;
        for (AdminStatsDAO.DayRevenue row : daily) {
            if (row.day().isBefore(from) || row.day().isAfter(to)) {
                continue;
            }
            revenue = revenue.add(row.revenue() == null ? BigDecimal.ZERO : row.revenue());
            orders += row.orders();
        }

        long created = 0;
        for (Long value : createdByStatus.values()) {
            created += value == null ? 0 : value;
        }
        long cancelled = createdByStatus.getOrDefault("CANCELLED", 0L);

        BigDecimal avgOrder = orders > 0
                ? revenue.divide(BigDecimal.valueOf(orders), 2, RoundingMode.HALF_UP)
                : BigDecimal.ZERO.setScale(2);
        BigDecimal cancelRate = created > 0
                ? BigDecimal.valueOf(cancelled).multiply(HUNDRED)
                        .divide(BigDecimal.valueOf(created), 2, RoundingMode.HALF_UP)
                : BigDecimal.ZERO.setScale(2);
        return new Kpi(revenue, orders, avgOrder, cancelRate);
    }

    private static String statusLabel(String status) {
        if (status == null) {
            return "Khác";
        }
        return switch (status) {
            case "PENDING" -> "Chờ xác nhận";
            case "CONFIRMED" -> "Đã xác nhận";
            case "SHIPPING" -> "Đang giao";
            case "COMPLETED" -> "Hoàn tất";
            case "CANCELLED" -> "Hoàn/Hủy";
            default -> status;
        };
    }
}
