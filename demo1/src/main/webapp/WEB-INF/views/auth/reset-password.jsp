<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%--
  Set-new-password page. Servlet: GET/POST /reset-password?token=...
  Request attributes (all optional): tokenInvalid (Boolean), error (String),
                                     errors (Map<String,String>), csrfToken
  Token is carried in the hidden field "token" (also available as ${param.token}).
--%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <title>PrintKraft — Đặt lại mật khẩu</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=IBM+Plex+Sans:wght@400;500;600&family=IBM+Plex+Mono:wght@400;500&family=Barlow+Condensed:wght@600;700&family=Barlow:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/assets/css/auth.css">
</head>
<body data-t="kh">

<main class="screen on kh" id="reset">
    <div class="card">
        <div class="logo"><span class="mark"></span> PrintKraft</div>

        <c:choose>
            <c:when test="${tokenInvalid}">
                <div class="ok">
                    <div class="tick bad">✕</div>
                    <h2>Liên kết không hợp lệ</h2>
                    <p class="sub">Liên kết đã hết hạn hoặc đã được sử dụng. Vui lòng yêu cầu liên kết mới.</p>
                    <a class="btn" href="${ctx}/forgot-password">Yêu cầu liên kết mới</a>
                </div>
            </c:when>
            <c:otherwise>
                <h2>Đặt lại mật khẩu</h2>
                <p class="sub">Nhập mật khẩu mới cho tài khoản của bạn.</p>

                <c:if test="${not empty error}"><div class="alert error" role="alert"><c:out value="${error}"/></div></c:if>

                <form method="post" action="${ctx}/reset-password">
                    <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                    <input type="hidden" name="token" value="<c:out value='${param.token}'/>">

                    <div class="field${not empty errors.newPassword ? ' has-err' : ''}">
                        <label for="s1">Mật khẩu mới</label>
                        <input id="s1" name="newPassword" type="password" autocomplete="new-password" minlength="8" placeholder="Tối thiểu 8 ký tự" required>
                        <c:if test="${not empty errors.newPassword}"><p class="err"><c:out value="${errors.newPassword}"/></p></c:if>
                    </div>
                    <div class="field${not empty errors.confirmNewPassword ? ' has-err' : ''}">
                        <label for="s2">Nhập lại mật khẩu mới</label>
                        <input id="s2" name="confirmNewPassword" type="password" autocomplete="new-password" minlength="8" placeholder="Nhập lại mật khẩu mới" required>
                        <c:if test="${not empty errors.confirmNewPassword}"><p class="err"><c:out value="${errors.confirmNewPassword}"/></p></c:if>
                    </div>
                    <button class="btn" type="submit">Đặt lại mật khẩu</button>
                </form>
            </c:otherwise>
        </c:choose>

        <div class="foot"><p><a class="ln" href="${ctx}/login">Quay lại đăng nhập</a></p></div>
    </div>
</main>

<script src="${ctx}/assets/js/auth.js"></script>
</body>
</html>
