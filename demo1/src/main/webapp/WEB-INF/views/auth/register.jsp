<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%--
  Register page. Servlet: GET/POST /register
  Request attributes (all optional): error (String), errors (Map<String,String>), csrfToken
  Params echoed back on failure: fullName, email, phone, agreeTerms (passwords are never echoed)
--%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <title>PrintKraft — Tạo tài khoản</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=IBM+Plex+Sans:wght@400;500;600&family=IBM+Plex+Mono:wght@400;500&family=Barlow+Condensed:wght@600;700&family=Barlow:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/assets/css/auth.css">
</head>
<body data-t="kh">

<main class="screen on kh" id="register">
    <div class="card">
        <div class="logo"><span class="mark"></span> PrintKraft</div>
        <h2>Tạo tài khoản</h2>
        <p class="sub">Tải file STL, nhận báo giá từ các xưởng và đặt in trong vài phút.</p>

        <c:if test="${not empty error}"><div class="alert error" role="alert"><c:out value="${error}"/></div></c:if>

        <form method="post" action="${ctx}/register">
            <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">

            <div class="field${not empty errors.fullName ? ' has-err' : ''}">
                <label for="r1">Họ và tên</label>
                <input id="r1" name="fullName" type="text" autocomplete="name" placeholder="Nguyễn Minh Anh"
                       value="<c:out value='${param.fullName}'/>" required>
                <c:if test="${not empty errors.fullName}"><p class="err"><c:out value="${errors.fullName}"/></p></c:if>
            </div>

            <div class="row">
                <div class="field${not empty errors.email ? ' has-err' : ''}">
                    <label for="r2">Email</label>
                    <input id="r2" name="email" type="email" autocomplete="email" placeholder="ban@email.com"
                           value="<c:out value='${param.email}'/>" required>
                    <c:if test="${not empty errors.email}"><p class="err"><c:out value="${errors.email}"/></p></c:if>
                </div>
                <div class="field${not empty errors.phone ? ' has-err' : ''}">
                    <label for="r3">Số điện thoại</label>
                    <input id="r3" name="phone" type="tel" autocomplete="tel" placeholder="0901 234 567"
                           value="<c:out value='${param.phone}'/>" required>
                    <c:if test="${not empty errors.phone}"><p class="err"><c:out value="${errors.phone}"/></p></c:if>
                </div>
            </div>

            <div class="row">
                <div class="field${not empty errors.password ? ' has-err' : ''}">
                    <label for="r4">Mật khẩu</label>
                    <input id="r4" name="password" type="password" autocomplete="new-password" minlength="8" placeholder="Tối thiểu 8 ký tự" required>
                    <c:if test="${not empty errors.password}"><p class="err"><c:out value="${errors.password}"/></p></c:if>
                </div>
                <div class="field${not empty errors.confirmPassword ? ' has-err' : ''}">
                    <label for="r5">Nhập lại mật khẩu</label>
                    <input id="r5" name="confirmPassword" type="password" autocomplete="new-password" minlength="8" placeholder="Nhập lại mật khẩu" required>
                    <c:if test="${not empty errors.confirmPassword}"><p class="err"><c:out value="${errors.confirmPassword}"/></p></c:if>
                </div>
            </div>

            <%-- TODO: point these links to the real terms / privacy pages when they exist. --%>
            <label class="chk"><input type="checkbox" name="agreeTerms" value="on"${param.agreeTerms == 'on' ? ' checked' : ''} required> <span>Tôi đồng ý với <a class="ln" href="#">Điều khoản sử dụng</a> và <a class="ln" href="#">Chính sách bảo mật</a></span></label>
            <c:if test="${not empty errors.agreeTerms}"><p class="err" style="margin:-12px 0 14px;color:#E03131;font-size:12.5px"><c:out value="${errors.agreeTerms}"/></p></c:if>

            <button class="btn" type="submit">Tạo tài khoản</button>
        </form>

        <div class="foot"><p>Đã có tài khoản? <a class="ln" href="${ctx}/login">Đăng nhập</a></p></div>
    </div>
</main>

<script src="${ctx}/assets/js/auth.js"></script>
</body>
</html>
