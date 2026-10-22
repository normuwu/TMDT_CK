<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<fmt:setLocale value="vi_VN"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn hàng #<c:out value="${order.orderCode}"/> — PrintKraft</title>
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
    <nav class="ord-breadcrumb" aria-label="Đường dẫn">
        <a href="${ctx}/KhachHang/lich-su-mua-hang">Lịch sử mua hàng</a><span class="sep">›</span>
        <span>#<c:out value="${order.orderCode}"/></span>
    </nav>

    <div class="ord-head">
        <h1>Chi tiết đơn hàng</h1>
        <p>Mã đơn <b>#<c:out value="${order.orderCode}"/></b> · đặt lúc <c:out value="${order.createdAtText}"/></p>
    </div>

    <c:if test="${not empty success or not empty error}">
        <div class="alerts">
            <c:if test="${not empty success}"><div class="alert ok" role="status"><c:out value="${success}"/></div></c:if>
            <c:if test="${not empty error}"><div class="alert err" role="alert"><c:out value="${error}"/></div></c:if>
        </div>
    </c:if>

    <div class="detail-grid">
        <div>
            <div class="ord-panel">
                <h2><span class="ic">🛍️</span> Sản phẩm đã mua</h2>
                <table class="items-table">
                    <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th class="hide-sm">Đơn giá</th>
                        <th>SL</th>
                        <th>Thành tiền</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${order.items}" var="item">
                        <tr>
                            <td class="pname"><c:out value="${item.productName}"/></td>
                            <td class="hide-sm"><fmt:formatNumber value="${item.unitPrice}" groupingUsed="true"/>đ</td>
                            <td>${item.quantity}</td>
                            <td><fmt:formatNumber value="${item.lineTotal}" groupingUsed="true"/>đ</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <div class="sum-div"></div>
                <div class="sum-row"><span>Tạm tính (${order.totalQuantity} sản phẩm)</span><b><fmt:formatNumber value="${order.subtotalAmount}" groupingUsed="true"/>đ</b></div>
                <div class="sum-row"><span>Phí vận chuyển</span><b>Miễn phí</b></div>
                <div class="sum-total"><span>Tổng thanh toán</span><span class="big"><fmt:formatNumber value="${order.totalAmount}" groupingUsed="true"/>đ</span></div>
                <div class="sum-note">Đơn giá trên là giá tại thời điểm bạn đặt hàng.</div>
            </div>
        </div>

        <aside>
            <div class="ord-panel">
                <h2><span class="ic">📦</span> Thông tin nhận hàng</h2>
                <div class="info-row"><span class="lbl">Người nhận</span><span class="val"><c:out value="${order.recipientName}"/></span></div>
                <div class="info-row"><span class="lbl">Điện thoại</span><span class="val"><c:out value="${order.recipientPhone}"/></span></div>
                <div class="info-row"><span class="lbl">Địa chỉ</span><span class="val"><c:out value="${order.shippingAddress}"/></span></div>
                <c:if test="${not empty order.note}">
                    <div class="info-row"><span class="lbl">Ghi chú</span><span class="val"><c:out value="${order.note}"/></span></div>
                </c:if>
                <div class="info-row"><span class="lbl">Xưởng in</span><span class="val"><c:out value="${order.shopName}"/></span></div>
            </div>

            <div class="ord-panel">
                <h2><span class="ic">💳</span> Thanh toán &amp; trạng thái</h2>
                <div class="info-row">
                    <span class="lbl">Phương thức</span>
                    <span class="val">
                        <c:choose>
                            <c:when test="${order.paymentMethod.code == 'BANK_TRANSFER'}">Chuyển khoản ngân hàng</c:when>
                            <c:otherwise>Thanh toán khi nhận hàng (COD)</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="info-row">
                    <span class="lbl">Thanh toán</span>
                    <span class="val">
                        <span class="status ${order.paymentStatus.code == 'PENDING' ? 'unpaid' : order.paymentStatus.css}">
                            <c:out value="${order.paymentStatus.label}"/>
                        </span>
                    </span>
                </div>
                <div class="info-row">
                    <span class="lbl">Đơn hàng</span>
                    <span class="val"><span class="status ${order.status.css}"><c:out value="${order.status.label}"/></span></span>
                </div>
            </div>

            <a class="btn-secondary" style="width:100%;" href="${ctx}/KhachHang/lich-su-mua-hang">← Về lịch sử mua hàng</a>
        </aside>
    </div>
</main>

<div id="site-footer"></div>
<script src="${ctx}/assets/js/printkraft.js"></script>
</body>
</html>
