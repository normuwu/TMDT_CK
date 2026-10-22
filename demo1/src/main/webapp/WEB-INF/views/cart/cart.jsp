<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<fmt:setLocale value="vi_VN"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="cart" value="${sessionScope.cart}"/>
<c:set var="listUrl" value="${ctx}/KhachHang/san_pham.jsp"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng — PrintKraft</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/assets/css/printkraft.css">
    <link rel="stylesheet" href="${ctx}/assets/css/order.css">
</head>
<body data-page="san-pham" data-search="san_pham.jsp">
<jsp:include page="/WEB-INF/views/common/session-info.jsp" />
<div id="site-header"></div>
<jsp:include page="/WEB-INF/views/common/cart-drawer.jsp" />

<main class="ord-wrap">
    <nav class="ord-breadcrumb" aria-label="Đường dẫn">
        <a href="${ctx}/KhachHang/trang_chu.jsp">Trang chủ</a><span class="sep">›</span>
        <a href="${listUrl}">Sản phẩm</a><span class="sep">›</span>
        <span>Giỏ hàng</span>
    </nav>

    <div class="ord-head">
        <h1>Giỏ hàng của bạn</h1>
        <p>Kiểm tra sản phẩm, số lượng và tổng tiền trước khi thanh toán.</p>
    </div>

    <c:if test="${not empty success or not empty error}">
        <div class="alerts">
            <c:if test="${not empty success}"><div class="alert ok" role="status"><c:out value="${success}"/></div></c:if>
            <c:if test="${not empty error}"><div class="alert err" role="alert"><c:out value="${error}"/></div></c:if>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty cart or empty cart.items}">
            <div class="ord-empty">
                <div class="big">🛒</div>
                <strong>Giỏ hàng đang trống</strong>
                <p>Hãy chọn một sản phẩm in 3D phù hợp rồi thêm vào giỏ hàng.</p>
                <a class="btn-primary" href="${listUrl}">Xem sản phẩm</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="ord-layout">
                <div>
                    <div class="ord-panel">
                        <h2><span class="ic">🛒</span> Sản phẩm trong giỏ (${cart.itemCount})</h2>

                        <c:forEach items="${cart.items}" var="item">
                            <div class="cart-line">
                                <div class="cart-thumb">
                                    <c:choose>
                                        <c:when test="${empty item.thumbnailUrl}">
                                            <c:out value="${fn:toUpperCase(fn:substring(item.name, 0, 1))}"/>
                                        </c:when>
                                        <c:when test="${fn:startsWith(item.thumbnailUrl, 'http')}">
                                            <img src="<c:out value='${item.thumbnailUrl}'/>" alt="<c:out value='${item.name}'/>">
                                        </c:when>
                                        <c:when test="${fn:startsWith(item.thumbnailUrl, '/')}">
                                            <img src="${ctx}<c:out value='${item.thumbnailUrl}'/>" alt="<c:out value='${item.name}'/>">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${ctx}/<c:out value='${item.thumbnailUrl}'/>" alt="<c:out value='${item.name}'/>">
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div>
                                    <div class="cart-name">
                                        <a href="${ctx}/KhachHang/chi-tiet-san-pham?id=${item.productId}">
                                            <c:out value="${item.name}"/>
                                        </a>
                                    </div>
                                    <c:if test="${not empty item.materialName}">
                                        <div class="cart-meta">Vật liệu: <c:out value="${item.materialName}"/></div>
                                    </c:if>
                                    <div class="cart-meta">Còn lại ${item.maxStock} sản phẩm</div>
                                    <div class="cart-unit"><fmt:formatNumber value="${item.unitPrice}" groupingUsed="true"/>đ / sản phẩm</div>

                                    <form method="post" action="${ctx}/KhachHang/gio-hang" class="qty-form">
                                        <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="key" value="<c:out value='${item.key}'/>">
                                        <button type="submit" name="delta" value="-1"
                                                aria-label="Giảm số lượng" <c:if test="${item.quantity <= 1}">disabled</c:if>>−</button>
                                        <input type="number" name="quantity" value="${item.quantity}"
                                               min="1" max="${item.maxStock}" inputmode="numeric" aria-label="Số lượng">
                                        <button type="submit" name="delta" value="1"
                                                aria-label="Tăng số lượng" <c:if test="${item.quantity >= item.maxStock}">disabled</c:if>>+</button>
                                        <button type="submit" class="update-btn">Cập nhật</button>
                                    </form>

                                    <div class="cart-actions">
                                        <form method="post" action="${ctx}/KhachHang/gio-hang">
                                            <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                                            <input type="hidden" name="action" value="remove">
                                            <input type="hidden" name="key" value="<c:out value='${item.key}'/>">
                                            <button type="submit" class="link-btn">Xóa khỏi giỏ</button>
                                        </form>
                                        <a class="link-btn" href="${ctx}/KhachHang/chi-tiet-san-pham?id=${item.productId}">Xem chi tiết sản phẩm</a>
                                    </div>
                                </div>

                                <div class="cart-line-total">
                                    <fmt:formatNumber value="${item.lineTotal}" groupingUsed="true"/>đ
                                </div>
                            </div>
                        </c:forEach>

                        <div class="cart-actions" style="margin-top:18px;">
                            <form method="post" action="${ctx}/KhachHang/gio-hang">
                                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                                <input type="hidden" name="action" value="clear">
                                <button type="submit" class="link-btn">Xóa tất cả</button>
                            </form>
                        </div>
                    </div>
                </div>

                <aside class="ord-summary">
                    <h2>Tóm tắt đơn hàng</h2>
                    <div class="sum-row"><span>Số sản phẩm</span><b>${cart.itemCount}</b></div>
                    <div class="sum-row"><span>Tạm tính</span><b><fmt:formatNumber value="${cart.total}" groupingUsed="true"/>đ</b></div>
                    <div class="sum-row"><span>Phí vận chuyển</span><b>Miễn phí</b></div>
                    <div class="sum-div"></div>
                    <div class="sum-total"><span>Tổng thanh toán</span><span class="big"><fmt:formatNumber value="${cart.total}" groupingUsed="true"/>đ</span></div>
                    <div class="sum-note">Giá đã bao gồm VAT</div>

                    <a class="btn-primary" href="${ctx}/KhachHang/thanh-toan">Tiến hành thanh toán</a>
                    <a class="btn-secondary" href="${listUrl}">Tiếp tục mua sắm</a>
                </aside>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<div id="site-footer"></div>
<script src="${ctx}/assets/js/printkraft.js"></script>
</body>
</html>
