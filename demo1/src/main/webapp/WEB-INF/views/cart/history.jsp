<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<fmt:setLocale value="vi_VN"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="listUrl" value="${ctx}/KhachHang/san_pham.jsp"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử mua hàng — PrintKraft</title>
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
        <a href="${ctx}/KhachHang/trang_chu.jsp">Trang chủ</a><span class="sep">›</span>
        <span>Lịch sử mua hàng</span>
    </nav>

    <div class="ord-head">
        <h1>Lịch sử mua hàng</h1>
        <p>Các đơn hàng của tài khoản <b><c:out value="${sessionScope.currentUser.fullName}"/></b>.</p>
    </div>

    <c:if test="${not empty success or not empty error}">
        <div class="alerts">
            <c:if test="${not empty success}"><div class="alert ok" role="status"><c:out value="${success}"/></div></c:if>
            <c:if test="${not empty error}"><div class="alert err" role="alert"><c:out value="${error}"/></div></c:if>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="ord-empty">
                <div class="big">🧾</div>
                <strong>Bạn chưa có đơn hàng nào</strong>
                <p>Các đơn đặt hàng COD sẽ xuất hiện tại đây ngay sau khi đặt thành công.</p>
                <a class="btn-primary" href="${listUrl}">Mua sắm ngay</a>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach items="${orders}" var="o">
                <article class="order-card">
                    <div class="order-top">
                        <div>
                            <div class="order-code">#<c:out value="${o.orderCode}"/></div>
                            <div class="order-date"><c:out value="${o.createdAtText}"/> · <c:out value="${o.shopName}"/></div>
                        </div>
                        <span class="status ${o.status.css}"><c:out value="${o.status.label}"/></span>
                    </div>

                    <div class="order-grid">
                        <div class="order-cell">
                            <div class="lbl">Thanh toán</div>
                            <div class="val">
                                <c:choose>
                                    <c:when test="${o.paymentMethod.code == 'BANK_TRANSFER'}">Chuyển khoản</c:when>
                                    <c:otherwise>COD</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="order-cell">
                            <div class="lbl">Trạng thái thanh toán</div>
                            <div class="val">
                                <span class="status ${o.paymentStatus.code == 'PENDING' ? 'unpaid' : o.paymentStatus.css}">
                                    <c:out value="${o.paymentStatus.label}"/>
                                </span>
                            </div>
                        </div>
                        <div class="order-cell">
                            <div class="lbl">Người nhận</div>
                            <div class="val"><c:out value="${o.recipientName}"/></div>
                        </div>
                        <div class="order-cell">
                            <div class="lbl">Tổng tiền</div>
                            <div class="val"><fmt:formatNumber value="${o.totalAmount}" groupingUsed="true"/>đ</div>
                        </div>
                    </div>

                    <div class="order-foot">
                        <span class="order-date">Giao tới: <c:out value="${o.shippingAddress}"/></span>
                        <a class="btn-secondary" style="padding:10px 20px;font-size:13.5px;"
                           href="${ctx}/KhachHang/chi-tiet-don-hang?id=${o.orderId}">Xem chi tiết</a>
                    </div>
                </article>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</main>

<div id="site-footer"></div>
<script src="${ctx}/assets/js/printkraft.js"></script>
</body>
</html>
