<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%--
  Login page. Servlet: GET/POST /login
  Request attributes (all optional): error, success (String), errors (Map<String,String>),
                                     showResend (Boolean), csrfToken
  Params echoed back on failure: identifier, redirect
--%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <title>PrintKraft — Đăng nhập</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=IBM+Plex+Sans:wght@400;500;600&family=IBM+Plex+Mono:wght@400;500&family=Barlow+Condensed:wght@600;700&family=Barlow:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/assets/css/auth.css">
</head>
<body data-t="kh">

<main class="screen on kh" id="login">
    <div class="card">
        <div class="logo"><span class="mark"></span> PrintKraft</div>
        <h2>Đăng nhập</h2>
        <p class="sub">Chào mừng quay lại. Tiếp tục theo dõi đơn in 3D của bạn.</p>

        <c:if test="${not empty success}"><div class="alert success" role="status"><c:out value="${success}"/></div></c:if>
        <c:if test="${not empty error}"><div class="alert error" role="alert"><c:out value="${error}"/></div></c:if>
        <c:if test="${showResend}">
            <form class="inline-form" method="post" action="${ctx}/resend-verification">
                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                <input type="hidden" name="identifier" value="<c:out value='${param.identifier}'/>">
                <button type="submit" class="linkbtn">Gửi lại email xác nhận</button>
            </form>
        </c:if>

        <form method="post" action="${ctx}/login">
            <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
            <input type="hidden" name="redirect" value="<c:out value='${param.redirect}'/>">

            <div class="field${not empty errors.identifier ? ' has-err' : ''}">
                <label for="l1">Email hoặc số điện thoại</label>
                <input id="l1" name="identifier" type="text" autocomplete="username" placeholder="ban@email.com"
                       value="<c:out value='${param.identifier}'/>" required>
                <c:if test="${not empty errors.identifier}"><p class="err"><c:out value="${errors.identifier}"/></p></c:if>
            </div>

            <div class="field${not empty errors.password ? ' has-err' : ''}">
                <label for="l2">Mật khẩu <a class="ln" href="${ctx}/forgot-password">Quên mật khẩu?</a></label>
                <input id="l2" name="password" type="password" autocomplete="current-password" placeholder="Nhập mật khẩu" required>
                <c:if test="${not empty errors.password}"><p class="err"><c:out value="${errors.password}"/></p></c:if>
            </div>

            <%-- TODO: remember-me is implemented last (see backend plan). Default is unchecked. --%>
            <label class="chk"><input type="checkbox" name="remember" value="on"${param.remember == 'on' ? ' checked' : ''}> Ghi nhớ đăng nhập trên thiết bị này</label>
            <button class="btn" type="submit">Đăng nhập</button>
        </form>

        <%-- TODO: "Continue with Google" is out of scope for now. --%>

        <div class="foot">
            <p>Chưa có tài khoản? <a class="ln" href="${ctx}/register">Tạo tài khoản</a></p>
            <%-- TODO: enable when the supplier registration flow is built:
            <p>Bạn là xưởng in? <a class="ln" href="${ctx}/register-supplier">Đăng ký làm nhà cung cấp</a></p> --%>
        </div>
    </div>
</main>

<script src="${ctx}/assets/js/auth.js"></script>
</body>
</html>
