<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<fmt:setLocale value="vi_VN"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="cart" value="${requestScope.cart}"/>
<c:set var="listUrl" value="${ctx}/KhachHang/san_pham.jsp"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán — PrintKraft</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/assets/css/printkraft.css">
    <link rel="stylesheet" href="${ctx}/assets/css/order.css">
    <style>
        /* Sửa lỗi nút .btn-secondary chiếm 100% chiều rộng làm ép nhỏ ô nhập mã khuyến mãi */
        .promo-box .promo-form {
            display: flex !important;
            align-items: stretch !important;
            gap: 8px !important;
            width: 100% !important;
        }
        .promo-box .promo-form input[type="text"] {
            flex: 1 1 auto !important;
            min-width: 0 !important;
            width: auto !important;
            padding: 9px 12px !important;
            border: 1.5px solid var(--line-strong, #d0d5dd) !important;
            border-radius: 8px !important;
            font-size: 13.5px !important;
            background: #fff !important;
            color: var(--ink, #1e2430) !important;
        }
        .promo-box .promo-form button.btn-secondary {
            flex: 0 0 auto !important;
            width: auto !important;
            white-space: nowrap !important;
            padding: 9px 16px !important;
            margin: 0 !important;
        }
    </style>
</head>
<body data-page="san-pham" data-search="san_pham.jsp">
<jsp:include page="/WEB-INF/views/common/session-info.jsp" />
<div id="site-header"></div>
<jsp:include page="/WEB-INF/views/common/cart-drawer.jsp" />

<main class="ord-wrap">
    <nav class="ord-breadcrumb" aria-label="Đường dẫn">
        <a href="${ctx}/KhachHang/gio-hang">Giỏ hàng</a><span class="sep">›</span>
        <span>Thanh toán</span>
    </nav>

    <div class="ord-head">
        <h1>Thanh toán</h1>
        <p>Điền thông tin nhận hàng và chọn phương thức thanh toán. Giá và tồn kho được kiểm tra lại khi bạn đặt hàng.</p>
    </div>

    <c:if test="${not empty error or not empty success}">
        <div class="alerts">
            <c:if test="${not empty success}"><div class="alert ok" role="status"><c:out value="${success}"/></div></c:if>
            <c:if test="${not empty error}"><div class="alert err" role="alert"><c:out value="${error}"/></div></c:if>
        </div>
    </c:if>

    <div class="ord-layout">
        <div>
            <form method="post" action="${ctx}/KhachHang/thanh-toan" id="checkoutForm">
                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">

                <div class="ord-panel">
                    <h2><span class="ic">📦</span> Thông tin nhận hàng</h2>

                    <div class="field-row">
                        <div class="field">
                            <label for="recipientName">Họ và tên người nhận *</label>
                            <input id="recipientName" type="text" name="recipientName" maxlength="100" required
                                   value="<c:out value='${formName}'/>" placeholder="Nguyễn Văn A"
                                   class="${not empty fieldErrors.fullName ? 'invalid' : ''}">
                            <c:if test="${not empty fieldErrors.fullName}">
                                <div class="field-error"><c:out value="${fieldErrors.fullName}"/></div>
                            </c:if>
                        </div>
                        <div class="field">
                            <label for="recipientPhone">Số điện thoại *</label>
                            <input id="recipientPhone" type="tel" name="recipientPhone" maxlength="20" required
                                   value="<c:out value='${formPhone}'/>" placeholder="0901234567" inputmode="numeric"
                                   class="${not empty fieldErrors.phone ? 'invalid' : ''}">
                            <c:if test="${not empty fieldErrors.phone}">
                                <div class="field-error"><c:out value="${fieldErrors.phone}"/></div>
                            </c:if>
                        </div>
                    </div>

                    <div class="field">
                        <label for="shippingAddress">Địa chỉ nhận hàng *</label>
                        <input id="shippingAddress" type="text" name="shippingAddress" maxlength="300" required
                               value="<c:out value='${formAddress}'/>"
                               placeholder="Số nhà, đường, phường, quận, tỉnh/thành phố"
                               class="${not empty fieldErrors.address ? 'invalid' : ''}">
                        <c:if test="${not empty fieldErrors.address}">
                            <div class="field-error"><c:out value="${fieldErrors.address}"/></div>
                        </c:if>
                    </div>

                    <div class="field">
                        <label for="note">Ghi chú đơn hàng (không bắt buộc)</label>
                        <textarea id="note" name="note" rows="2" maxlength="500"
                                  placeholder="VD: Giao giờ hành chính, gọi trước khi đến..."
                                  class="${not empty fieldErrors.note ? 'invalid' : ''}"><c:out value='${formNote}'/></textarea>
                        <c:if test="${not empty fieldErrors.note}">
                            <div class="field-error"><c:out value="${fieldErrors.note}"/></div>
                        </c:if>
                    </div>
                </div>

                <div class="ord-panel">
                    <h2><span class="ic">💳</span> Phương thức thanh toán</h2>
                    <div class="pay-methods">
                        <c:forEach items="${paymentMethods}" var="pm">
                            <label class="pay-method">
                                <input type="radio" name="paymentMethod" value="${pm.code}"
                                       <c:if test="${pm.code == 'COD'}">checked</c:if>>
                                <span class="pm-ic"
                                      style="background:${pm.code == 'COD' ? 'var(--grad-cool)' : 'var(--grad-sky)'};">
                                    ${pm.code == 'COD' ? '💵' : '🏦'}
                                </span>
                                <span class="pm-body">
                                    <strong><c:out value="${pm.label}"/></strong>
                                    <span>
                                        <c:choose>
                                            <c:when test="${pm.code == 'COD'}">Thanh toán trực tiếp khi nhận hàng.</c:when>
                                            <c:otherwise>Chuyển khoản trước, xưởng xác nhận sau.</c:otherwise>
                                        </c:choose>
                                    </span>
                                </span>
                                <c:if test="${pm.code == 'BANK_TRANSFER'}">
                                    <span class="pm-tag">Đang phát triển</span>
                                </c:if>
                            </label>
                        </c:forEach>
                    </div>
                    <p class="sum-note" style="text-align:left;margin-top:12px;">
                        Hiện chỉ thanh toán khi nhận hàng (COD) được hỗ trợ tạo đơn thật.
                        Chọn chuyển khoản sẽ hiển thị thông báo và <b>không</b> tạo đơn hàng.
                    </p>
                </div>

                <div style="display:flex;gap:12px;flex-wrap:wrap;">
                    <a class="btn-secondary" href="${ctx}/KhachHang/gio-hang">← Quay lại giỏ hàng</a>
                    <button type="submit" class="btn-primary">Đặt hàng</button>
                </div>
            </form>
        </div>

        <aside class="ord-summary">
            <h2>Đơn hàng của bạn</h2>

            <c:forEach items="${cart.items}" var="item">
                <div class="sum-row" style="align-items:flex-start;">
                    <span>
                        <c:out value="${item.displayName}"/>
                        <br><small style="color:var(--ink-soft);">× ${item.quantity}</small>
                    </span>
                    <b><fmt:formatNumber value="${item.lineTotal}" groupingUsed="true"/>đ</b>
                </div>
            </c:forEach>

            <div class="sum-div"></div>
            <div class="sum-row"><span>Số sản phẩm</span><b>${cart.itemCount}</b></div>
            <div class="sum-row"><span>Tạm tính</span><b><fmt:formatNumber value="${cart.total}" groupingUsed="true"/>đ</b></div>
            <div class="sum-row"><span>Phí vận chuyển</span><b>Miễn phí</b></div>

            <%-- ---------- Mã khuyến mãi (form riêng, không lồng trong form thanh toán) ---------- --%>
            <div class="promo-box">
                <c:choose>
                    <c:when test="${not empty promoCode}">
                        <div class="promo-applied">
                            <div>
                                <strong><c:out value="${promoCode}"/></strong>
                                <c:if test="${not empty promoName}"> — <c:out value="${promoName}"/></c:if>
                                <div class="promo-note">
                                    <c:out value="${promoLabel}"/> · đã giảm
                                    <b><fmt:formatNumber value="${promoDiscount}" groupingUsed="true"/>đ</b>
                                </div>
                            </div>
                            <form method="post" action="${ctx}/KhachHang/khuyen-mai">
                                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                                <input type="hidden" name="action" value="remove">
                                <button type="submit" class="link-btn">Bỏ mã</button>
                            </form>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <form method="post" action="${ctx}/KhachHang/khuyen-mai" class="promo-form">
                            <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                            <input type="hidden" name="action" value="apply">
                            <input type="text" name="code" maxlength="50" placeholder="Nhập mã khuyến mãi"
                                   aria-label="Mã khuyến mãi" autocomplete="off">
                            <button type="submit" class="btn-secondary">Áp dụng</button>
                        </form>
                    </c:otherwise>
                </c:choose>

                <c:if test="${not empty promoError}">
                    <div class="alert err" role="alert"><c:out value="${promoError}"/></div>
                </c:if>
                <div class="promo-hint">Mỗi đơn chỉ áp dụng một mã. Mã được kiểm tra lại khi bạn bấm Đặt hàng.</div>
            </div>

            <c:if test="${promoDiscount > 0}">
                <div class="sum-row promo-discount-row">
                    <span>Giảm giá (<c:out value="${promoCode}"/>)</span>
                    <b>−<fmt:formatNumber value="${promoDiscount}" groupingUsed="true"/>đ</b>
                </div>
            </c:if>
            <div class="sum-div"></div>
            <div class="sum-total"><span>Tổng thanh toán</span><span class="big"><fmt:formatNumber value="${payableTotal}" groupingUsed="true"/>đ</span></div>
            <div class="sum-note">Số tiền cuối cùng được tính lại trên server khi đặt hàng.</div>
        </aside>
    </div>
</main>

<div id="site-footer"></div>
<script src="${ctx}/assets/js/printkraft.js"></script>
</body>
</html>