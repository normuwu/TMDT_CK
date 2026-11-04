package com.tmdt.servlet.admin;

import com.tmdt.service.AdminStatsService;
import com.tmdt.util.JsonUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.sql.SQLException;

/**
 * API thống kê (chỉ ADMIN — AuthFilter chặn trước khi vào đây):
 *   GET /admin/api/stats/revenue?from=&to=&group=day|week|month
 *   GET /admin/api/stats/breakdown?from=&to=&by=category|shop|status&metric=revenue|orders
 */
@WebServlet(name = "AdminStatsApiServlet", urlPatterns = "/admin/api/stats/*")
public class AdminStatsApiServlet extends HttpServlet {

    private static final Logger LOG = LoggerFactory.getLogger(AdminStatsApiServlet.class);

    protected final AdminStatsService service = new AdminStatsService();

    /**
     * Phạm vi dữ liệu: 0 = toàn sàn (Admin). Servlet con (Người bán) ghi đè để
     * trả về shop_id của người bán; trả về -1 nếu không có quyền xem thống kê.
     */
    protected int resolveShopId(HttpServletRequest request) throws SQLException {
        return 0;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String action = request.getPathInfo();
        if (action == null) {
            writeError(response, HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy tài nguyên.");
            return;
        }
        try {
            int shopId = resolveShopId(request);
            if (shopId < 0) {
                writeError(response, HttpServletResponse.SC_FORBIDDEN,
                        "Tài khoản chưa có xưởng in hoạt động.");
                return;
            }
            switch (action) {
                case "/revenue" -> writeJson(response, HttpServletResponse.SC_OK, revenueJson(request, shopId));
                case "/breakdown" -> writeJson(response, HttpServletResponse.SC_OK, breakdownJson(request, shopId));
                default -> writeError(response, HttpServletResponse.SC_NOT_FOUND,
                        "Không tìm thấy tài nguyên.");
            }
        } catch (IllegalArgumentException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SQLException e) {
            LOG.error("Admin stats query failed", e);
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Không tải được dữ liệu thống kê.");
        }
    }

    private String revenueJson(HttpServletRequest request, int shopId) throws SQLException {
        AdminStatsService.RevenueResult result = service.revenue(
                request.getParameter("from"),
                request.getParameter("to"),
                request.getParameter("group"),
                shopId);

        JsonUtil.Arr buckets = new JsonUtil.Arr();
        for (AdminStatsService.Bucket bucket : result.buckets()) {
            buckets.add(new JsonUtil.Obj()
                    .putString("key", bucket.key())
                    .putString("label", bucket.label())
                    .putString("title", bucket.title())
                    .putNumber("revenue", bucket.revenue())
                    .putNumber("orders", bucket.orders())
                    .end());
        }

        return new JsonUtil.Obj()
                .putString("from", result.from())
                .putString("to", result.to())
                .putString("group", result.group())
                .put("buckets", buckets.end())
                .put("kpi", kpiJson(result.kpi(), result.prev()))
                .end();
    }

    private static String kpiJson(AdminStatsService.Kpi kpi, AdminStatsService.Kpi prev) {
        return new JsonUtil.Obj()
                .putNumber("revenue", kpi.revenue())
                .putNumber("orders", kpi.orders())
                .putNumber("avgOrder", kpi.avgOrder())
                .putNumber("cancelRate", kpi.cancelRate())
                .put("prev", new JsonUtil.Obj()
                        .putNumber("revenue", prev.revenue())
                        .putNumber("orders", prev.orders())
                        .putNumber("avgOrder", prev.avgOrder())
                        .putNumber("cancelRate", prev.cancelRate())
                        .end())
                .end();
    }

    private String breakdownJson(HttpServletRequest request, int shopId) throws SQLException {
        AdminStatsService.BreakdownResult result = service.breakdown(
                request.getParameter("from"),
                request.getParameter("to"),
                request.getParameter("by"),
                request.getParameter("metric"),
                shopId);

        JsonUtil.Arr slices = new JsonUtil.Arr();
        for (AdminStatsService.Slice slice : result.slices()) {
            slices.add(new JsonUtil.Obj()
                    .putString("name", slice.name())
                    .putNumber("value", slice.value())
                    .end());
        }

        return new JsonUtil.Obj()
                .putString("by", result.by())
                .putString("metric", result.metric())
                .putNumber("total", result.total())
                .put("slices", slices.end())
                .end();
    }

    private static void writeError(HttpServletResponse response, int status, String message)
            throws IOException {
        writeJson(response, status, new JsonUtil.Obj()
                .putString("error", message == null ? "Đã xảy ra lỗi." : message)
                .end());
    }

    private static void writeJson(HttpServletResponse response, int status, String body)
            throws IOException {
        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");
        response.getWriter().write(body);
    }
}
