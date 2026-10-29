package com.tmdt.servlet.admin;

import com.tmdt.dao.AdminStatsDAO;
import com.tmdt.model.Role;
import com.tmdt.model.SessionUser;
import com.tmdt.util.AuthUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;

import java.sql.SQLException;

/**
 * API thống kê doanh thu cho Người bán (xưởng in). Cùng logic với Admin nhưng
 * chỉ trả dữ liệu của xưởng thuộc tài khoản đang đăng nhập:
 *   GET /nhacungcap/api/stats/revenue?from=&to=&group=day|week|month
 *   GET /nhacungcap/api/stats/breakdown?from=&to=&by=category|status&metric=revenue|orders
 * Shop_id luôn lấy từ session + DB, không đọc từ request.
 */
@WebServlet(name = "SellerStatsApiServlet", urlPatterns = "/nhacungcap/api/stats/*")
public class SellerStatsApiServlet extends AdminStatsApiServlet {

    private final AdminStatsDAO shopDao = new AdminStatsDAO();

    @Override
    protected int resolveShopId(HttpServletRequest request) throws SQLException {
        SessionUser user = AuthUtil.currentUser(request);
        if (user == null || user.getRole() != Role.SELLER) {
            return -1;
        }
        return shopDao.findShopIdByUser(user.getUserId());
    }
}
