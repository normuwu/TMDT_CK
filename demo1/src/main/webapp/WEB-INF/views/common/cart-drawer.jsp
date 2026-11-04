<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%--
  Mini-cart trượt bên phải (dùng chung mọi trang).
  Dữ liệu lấy từ session "cart" do CartServlet/AddToCartServlet ghi — không còn
  danh sách demo hard-code. Nhúng bằng:
      <jsp:include page="/WEB-INF/views/common/cart-drawer.jsp" />
--%>
<fmt:setLocale value="vi_VN"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="miniCart" value="${sessionScope.cart}"/>

<aside class="drawer" id="cartDrawer" aria-label="Giỏ hàng của bạn">
    <div class="drawer-head">
        <h3>Giỏ hàng của bạn</h3>
        <button type="button" onclick="closeAll()" aria-label="Đóng giỏ hàng">✕</button>
    </div>

    <div class="drawer-body">
        <c:choose>
            <c:when test="${empty miniCart or empty miniCart.items}">
                <div style="text-align:center;padding:44px 12px;color:var(--ink-soft);">
                    <div style="font-size:40px;margin-bottom:12px;">🛒</div>
                    <strong style="display:block;font-family:'Space Grotesk';font-size:16px;color:var(--ink);margin-bottom:6px;">
                        Giỏ hàng đang trống
                    </strong>
                    <p style="font-size:13.5px;">Thêm sản phẩm in 3D vào giỏ để bắt đầu đặt hàng.</p>
                    <a class="btn-primary" style="margin-top:18px;" href="${ctx}/KhachHang/san-pham">Xem sản phẩm</a>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach items="${miniCart.items}" var="item">
                    <div class="cart-item">
                        <div class="thumb" style="background:var(--grad-primary);overflow:hidden;color:#fff;display:flex;align-items:center;justify-content:center;font-family:'Space Grotesk';font-weight:700;">
                            <c:choose>
                                <c:when test="${empty item.thumbnailUrl}">
                                    <c:out value="${fn:toUpperCase(fn:substring(item.name, 0, 1))}"/>
                                </c:when>
                                <c:when test="${fn:startsWith(item.thumbnailUrl, 'http')}">
                                    <img style="width:100%;height:100%;object-fit:cover;"
                                         src="<c:out value='${item.thumbnailUrl}'/>" alt="<c:out value='${item.name}'/>">
                                </c:when>
                                <c:when test="${fn:startsWith(item.thumbnailUrl, '/')}">
                                    <img style="width:100%;height:100%;object-fit:cover;"
                                         src="${ctx}<c:out value='${item.thumbnailUrl}'/>" alt="<c:out value='${item.name}'/>">
                                </c:when>
                                <c:otherwise>
                                    <img style="width:100%;height:100%;object-fit:cover;"
                                         src="${ctx}/<c:out value='${item.thumbnailUrl}'/>" alt="<c:out value='${item.name}'/>">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="info">
                            <strong><c:out value="${item.name}"/></strong>
                            <span>
                                <c:if test="${not empty item.materialName}">
                                    <c:out value="${item.materialName}"/> ·
                                </c:if>
                                SL: ${item.quantity} ·
                                <fmt:formatNumber value="${item.unitPrice}" groupingUsed="true"/>đ
                            </span>
                            <div style="margin-top:6px;">
                                <a href="${ctx}/KhachHang/gio-hang"
                                   style="font-size:12px;font-weight:600;color:var(--violet);">Sửa số lượng</a>
                            </div>
                        </div>
                        <div style="font-family:'Space Grotesk';font-weight:700;font-size:14px;white-space:nowrap;">
                            <fmt:formatNumber value="${item.lineTotal}" groupingUsed="true"/>đ
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <c:if test="${not empty miniCart and not empty miniCart.items}">
        <div class="drawer-foot">
            <div class="row">
                <span>Tạm tính (${miniCart.itemCount} sản phẩm)</span>
                <span><fmt:formatNumber value="${miniCart.total}" groupingUsed="true"/>đ</span>
            </div>
            <div class="row"><span>Phí vận chuyển</span><span>Miễn phí</span></div>
            <div class="row total">
                <span>Tổng cộng</span>
                <span><fmt:formatNumber value="${miniCart.total}" groupingUsed="true"/>đ</span>
            </div>
            <a class="btn-primary" style="display:block;width:100%;" href="${ctx}/KhachHang/thanh-toan">
                Tiến hành thanh toán
            </a>
            <a class="btn-secondary" style="display:block;width:100%;margin-top:8px;" href="${ctx}/KhachHang/gio-hang">
                Xem giỏ hàng
            </a>
        </div>
    </c:if>
</aside>
