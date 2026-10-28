<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
  Header dùng chung cho mọi trang khách hàng: thanh tiện ích, menu, ô tìm kiếm,
  khu vực tài khoản và nút giỏ hàng. Đã gồm sẵn session-info.jsp và cart-drawer.jsp,
  nên trang chỉ cần include header.jsp là có đủ đăng nhập + giỏ hàng.

  Cách dùng (đặt ngay sau <body>):
      <jsp:include page="/WEB-INF/views/common/header.jsp">
          <jsp:param name="active" value="home"/>
      </jsp:include>

  Giá trị active (mục menu được tô sáng):
      home | san-pham | studio | doanh-nghiep | nhacungcap | donhang | danhgia | faq
  Trang không nằm trong menu thì bỏ qua tham số này.

  Tất cả link dùng đường dẫn tuyệt đối theo context path, nên đặt trang ở thư mục nào cũng đúng.
--%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="kh" value="${ctx}/KhachHang"/>
<c:set var="active" value="${param.active}"/>
<c:set var="cartCount" value="${empty sessionScope.cart ? 0 : sessionScope.cart.itemCount}"/>

<jsp:include page="/WEB-INF/views/common/session-info.jsp"/>

<div class="utility">
    <span>🚚 Miễn phí thiết kế mockup cho đơn từ 20 sản phẩm — <b>Voucher 100K</b> cho đơn đầu tiên</span>
    <span>Hỗ trợ: <b>1900 6868</b> · <a href="${kh}/don_hang_cua_toi_3d.jsp">Theo dõi đơn hàng</a><c:if test="${empty sessionScope.currentUser}"> · <a href="${ctx}/login">Đăng nhập</a></c:if></span>
</div>

<header>
    <a href="${kh}/trang_chu.jsp" class="logo"><span class="mark"></span> PrintKraft</a>
    <nav id="mainNav" aria-label="Menu chính">
        <a href="${kh}/trang_chu.jsp" class="${active == 'home' ? 'active' : ''}">Trang chủ</a>
        <a href="${kh}/san-pham" class="${active == 'san-pham' ? 'active' : ''}">Sản phẩm</a>
        <a href="${kh}/dat_in_3d.jsp" class="${active == 'studio' ? 'active' : ''}">Tự thiết kế</a>
        <%-- TODO: khi có trang doanh nghiệp thì đổi href sang ${kh}/doanhnghiep.jsp (hiện giữ về trang chủ) --%>
        <a href="${kh}/trang_chu.jsp" class="${active == 'doanh-nghiep' ? 'active' : ''}">Doanh nghiệp</a>
        <a href="${kh}/tim-kiem-nha-cung-cap.jsp" class="${active == 'nhacungcap' ? 'active' : ''}">Nhà cung cấp</a>
        <a href="${kh}/don_hang_cua_toi_3d.jsp" class="${active == 'donhang' ? 'active' : ''}">Đơn hàng</a>
        <a href="${kh}/danh-gia.jsp" class="${active == 'danhgia' ? 'active' : ''}">Đánh giá</a>
        <a href="${kh}/lien-he.jsp" class="${active == 'faq' ? 'active' : ''}">Hỗ trợ</a>
    </nav>
    <div class="search-wrap" role="search">
        <input type="text" id="globalSearch" placeholder="Tìm sản phẩm..." maxlength="100" aria-label="Tìm sản phẩm">
        <button type="button" onclick="doGlobalSearch()">Tìm</button>
    </div>
    <div class="head-actions">
        <div id="authArea"></div>
        <button type="button" class="cart-btn" onclick="openCart()">🛒 Giỏ hàng <span class="badge" id="cartBadge"><c:out value="${cartCount}"/></span></button>
    </div>
</header>

<%-- Ngăn kéo giỏ hàng phải nằm NGOÀI <header> (header có backdrop-filter nên làm lệch vị trí fixed) --%>
<jsp:include page="/WEB-INF/views/common/cart-drawer.jsp"/>
