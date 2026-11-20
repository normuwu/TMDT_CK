package com.tmdt.servlet;

import com.tmdt.service.OrderService;
import com.tmdt.util.FlashUtil;
import com.tmdt.util.Views;
import com.tmdt.util.VnPayConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * GET /KhachHang/vnpay-return
 * Nhận kết quả redirect từ cổng thanh toán VNPay Sandbox.
 */
@WebServlet(name = "VnpayReturnServlet", urlPatterns = Views.VNPAY_RETURN_URL)
public class VnpayReturnServlet extends HttpServlet {

    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(true);

        if (!VnPayConfig.verifyReturn(request)) {
            FlashUtil.flashError(session, "Chữ ký giao dịch VNPay không hợp lệ.");
            response.sendRedirect(request.getContextPath() + Views.ORDER_HISTORY_URL);
            return;
        }

        String txnRef = request.getParameter("vnp_TxnRef");
        String responseCode = request.getParameter("vnp_ResponseCode");
        String transactionStatus = request.getParameter("vnp_TransactionStatus");
        String transactionNo = request.getParameter("vnp_TransactionNo");

        List<Integer> orderIds = parseOrderIds(txnRef);
        if (orderIds.isEmpty()) {
            FlashUtil.flashError(session, "Không xác định được mã đơn hàng từ giao dịch VNPay.");
            response.sendRedirect(request.getContextPath() + Views.ORDER_HISTORY_URL);
            return;
        }

        boolean isSuccess = "00".equals(responseCode)
                && (transactionStatus == null || "00".equals(transactionStatus));

        orderService.processVnpayReturn(orderIds, isSuccess, transactionNo, responseCode);

        if (isSuccess) {
            String idsParam = orderIds.stream()
                    .map(String::valueOf)
                    .collect(Collectors.joining(","));
            FlashUtil.flashSuccess(session, "Thanh toán trực tuyến qua VNPay thành công (Mã GD: "
                    + (transactionNo == null ? "" : transactionNo) + ").");
            response.sendRedirect(request.getContextPath() + Views.ORDER_SUCCESS_URL + "?ids=" + idsParam);
        } else {
            FlashUtil.flashError(session, "Giao dịch VNPay không thành công hoặc đã bị hủy (Mã: "
                    + responseCode + "). Đơn hàng đã được hủy và hoàn lại tồn kho.");
            response.sendRedirect(request.getContextPath() + Views.ORDER_HISTORY_URL);
        }
    }

    /**
     * Tách danh sách orderId từ vnp_TxnRef có định dạng: "12-13_1730791234567"
     */
    private static List<Integer> parseOrderIds(String txnRef) {
        if (txnRef == null || txnRef.isBlank()) return List.of();
        String prefix = txnRef.split("_")[0];
        List<Integer> ids = new ArrayList<>();
        for (String part : prefix.split("-")) {
            try {
                int id = Integer.parseInt(part.trim());
                if (id > 0) ids.add(id);
            } catch (NumberFormatException ignored) {
            }
        }
        return ids;
    }
}