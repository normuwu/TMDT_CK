<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
  Fragment dùng chung: in thông tin phiên đăng nhập ra data-attribute để JS đọc.
  Nhúng bằng:  <jsp:include page="/WEB-INF/views/common/session-info.jsp" />
  Giá trị được HTML-escape bằng <c:out>, JS đọc qua element.dataset (không cần escape JS).
  Giả định: session attribute "currentUser" là SessionUser có getFullName() và getRole();
            "csrfToken" nằm trong session (do CsrfFilter tạo). Đổi tên nếu code thật khác.
--%>
<div id="pk-session" hidden
     data-ctx="<c:out value='${pageContext.request.contextPath}'/>"
     data-csrf="<c:out value='${sessionScope.csrfToken}'/>"
     data-logged-in="${not empty sessionScope.currentUser}"
     data-name="<c:out value='${sessionScope.currentUser.fullName}'/>"
     data-cart-count="${empty sessionScope.cart ? 0 : sessionScope.cart.itemCount}"
     data-role="<c:out value='${sessionScope.currentUser.role}'/>"></div>
