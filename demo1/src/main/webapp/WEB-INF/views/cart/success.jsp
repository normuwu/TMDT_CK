<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<fmt:setLocale value="vi_VN"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="listUrl" value="${ctx}/KhachHang/san_pham.jsp"/>
<c:set var="first" value="${orders[0]}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt hàng thành công — PrintKraft</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/assets/css/printkraft.css">
    <link rel="stylesheet" href="${ctx}/assets/css/order.css">
</head>
<body data-page="donhang" data-search="san_pham.jsp">
<jsp:include page="/WEB-INF/views/common/session-info.jsp" />
<div id="site-header"></div>
<jsp:include page="/WEB-INF/views/common/cart-drawer.jsp" />

<main class="ord-wrap">
    <div class="success-box">
        <div class="success-icon">✓</div>
        <h1>Đặt hàng thành công!</h1>
        <p>Cảm ơn bạn đã tin tưởng PrintKraft. Xưởng in sẽ xác nhận đơn trong vòng 30 phút.</p>

        <div class="success-codes">
            <c:forEach items="${orders}" var="o">
                <span class="order-chip">#<c:out value="${o.orderCode}"/></span>
            </c:forEach>
        </div>

        <div class="ord-panel success-card">
            <h2><span class="ic">📋</span> Thông tin đơn hàng</h2>
            <div class="info-row"><span class="lbl">Ngày đặt</span><span class="val"><c:out value="${first.createdAtText}"/></span></div>
            <div class="info-row"><span class="lbl">Người nhận</span><span class="val"><c:out value="${first.recipientName}"/></span></div>
            <div class="info-row"><span class="lbl">Điện thoại</span><span class="val"><c:out value="${first.recipientPhone}"/></span></div>
            <div class="info-row"><span class="lbl">Địa chỉ giao hàng</span><span class="val"><c:out value="${first.shippingAddress}"/></span></div>
            <div class="info-row">
                <span class="lbl">Phương thức thanh toán</span>
                <span class="val">
                    <c:choose>
                        <c:when test="${first.paymentMethod.code == 'BANK_TRANSFER'}">Chuyển khoản ngân hàng</c:when>
                        <c:otherwise>Thanh toán khi nhận hàng (COD)</c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="info-row">
                <span class="lbl">Trạng thái đơn hàng</span>
                <span class="val"><span class="status ${first.status.css}"><c:out value="${first.status.label}"/></span></span>
            </div>
            <div class="info-row">
                <span class="lbl">Trạng thái thanh toán</span>
                <span class="val"><span class="status unpaid"><c:out value="${first.paymentStatus.label}"/></span></span>
            </div>
        </div>

        <c:forEach items="${orders}" var="o">
            <div class="ord-panel success-card">
                <h2><span class="ic">🧾</span> Đơn #<c:out value="${o.orderCode}"/> · <c:out value="${o.shopName}"/></h2>
                <table class="items-table">
                    <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Đơn giá</th>
                        <th>Số lượng</th>
                        <th>Thành tiền</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${o.items}" var="item">
                        <tr>
                            <td class="pname"><c:out value="${item.productName}"/></td>
                            <td><fmt:formatNumber value="${item.unitPrice}" groupingUsed="true"/>đ</td>
                            <td>${item.quantity}</td>
                            <td><fmt:formatNumber value="${item.lineTotal}" groupingUsed="true"/>đ</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
                <div class="sum-row" style="margin-top:10px;"><span>Phí vận chuyển</span><b>Miễn phí</b></div>
                <div class="sum-total"><span>Tổng đơn này</span><span class="big"><fmt:formatNumber value="${o.totalAmount}" groupingUsed="true"/>đ</span></div>
            </div>
        </c:forEach>

        <div class="ord-panel success-card" style="text-align:center;">
            <div class="sum-total" style="justify-content:center;gap:16px;">
                <span>Tổng thanh toán</span>
                <span class="big"><fmt:formatNumber value="${grandTotal}" groupingUsed="true"/>đ</span>
            </div>
            <div class="sum-note">Bạn thanh toán cho người giao hàng khi nhận được sản phẩm.</div>
        </div>

        <div class="success-actions">
            <a class="btn-primary" href="${listUrl}">Tiếp tục mua sắm</a>
            <a class="btn-secondary" href="${ctx}/KhachHang/lich-su-mua-hang">Xem lịch sử mua hàng</a>
        </div>
    </div>
</main>

<div id="site-footer"></div>
<script src="${ctx}/assets/js/printkraft.js"></script>
</body>
</html>
