package com.tmdt.servlet.admin;

import com.tmdt.dao.AdminShopListDAO;
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
 * GET /admin/api/supplier-accounts -> danh sách xưởng in (shops) + số yêu cầu NCC đang chờ.
 * Chỉ ADMIN (AuthFilter chặn /admin/ trước khi vào đây).
 */
@WebServlet(name = "AdminSupplierApiServlet", urlPatterns = "/admin/api/supplier-accounts")
public class AdminSupplierApiServlet extends HttpServlet {

    private static final Logger LOG = LoggerFactory.getLogger(AdminSupplierApiServlet.class);

    private final AdminShopListDAO dao = new AdminShopListDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            JsonUtil.Arr suppliers = new JsonUtil.Arr();
            for (AdminShopListDAO.ShopRow row : dao.listShops()) {
                suppliers.add(new JsonUtil.Obj()
                        .putNumber("shopId", row.shopId())
                        .putNumber("userId", row.userId())
                        .putString("shopName", row.shopName())
                        .putString("address", row.address())
                        .putString("phone", row.phone())
                        .putString("status", row.status())
                        .putString("createdAt", row.createdAt())
                        .putString("email", row.email())
                        .putString("fullName", row.fullName())
                        .end());
            }
            String body = new JsonUtil.Obj()
                    .put("suppliers", suppliers.end())
                    .put("counts", new JsonUtil.Obj()
                            .putNumber("pendingRequests", dao.countPendingRequests())
                            .end())
                    .end();
            writeJson(response, HttpServletResponse.SC_OK, body);
        } catch (SQLException e) {
            LOG.error("Admin supplier list query failed", e);
            writeJson(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    new JsonUtil.Obj().putString("error", "Không tải được danh sách nhà cung cấp.").end());
        }
    }

    private static void writeJson(HttpServletResponse response, int status, String body) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");
        response.getWriter().write(body);
    }
}
