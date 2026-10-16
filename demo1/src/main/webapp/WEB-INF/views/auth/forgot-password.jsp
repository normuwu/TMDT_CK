<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%--
  Forgot-password page. Servlet: GET/POST /forgot-password
  Request attributes (all optional): sent (Boolean, true after a POST was handled),
                                     error (String), errors (Map<String,String>), csrfToken
  IMPORTANT: after POST the servlet must FORWARD here (not redirect) so ${param.email} is still available.
  The same message is shown whether or not the email exists (anti account-enumeration).
--%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <title>PrintKraft — Quên mật khẩu</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=IBM+Plex+Sans:wght@400;500;600&family=IBM+Plex+Mono:wght@400;500&family=Barlow+Condensed:wght@600;700&family=Barlow:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/assets/css/auth.css">
</head>
<body data-t="kh">

<main class="screen on kh" id="forgot">
    <div class="card">
        <div class="logo"><span class="mark"></span> PrintKraft</div>

        <c:choose>
            <c:when test="${sent}">
                <div class="ok">
                    <div class="tick">✓</div>
                    <h2>Kiểm tra hộp thư</h2>
                    <p class="sub">Nếu <b><c:out value="${param.email}"/></b> đã đăng ký, chúng tôi vừa gửi liên kết đặt lại mật khẩu tới địa chỉ này. Liên kết có hiệu lực trong 30 phút.</p>
                    <form method="post" action="${ctx}/forgot-password">
                        <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                        <input type="hidden" name="email" value="<c:out value='${param.email}'/>">
                        <button class="btn o" type="submit">Gửi lại liên kết</button>
                    </form>
                </div>
            </c:when>
            <c:otherwise>
                <h2>Quên mật khẩu</h2>
                <p class="sub">Nhập email đã đăng ký. Chúng tôi sẽ gửi liên kết để bạn đặt lại mật khẩu.</p>

                <c:if test="${not empty error}"><div class="alert error" role="alert"><c:out value="${error}"/></div></c:if>

                <form method="post" action="${ctx}/forgot-password">
                    <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                    <div class="field${not empty errors.email ? ' has-err' : ''}">
                        <label for="q1">Email</label>
                        <input id="q1" name="email" type="email" autocomplete="email" placeholder="ban@email.com"
                               value="<c:out value='${param.email}'/>" required>
                        <c:if test="${not empty errors.email}"><p class="err"><c:out value="${errors.email}"/></p></c:if>
                    </div>
                    <button class="btn" type="submit">Gửi liên kết đặt lại</button>
                </form>
            </c:otherwise>
        </c:choose>

        <div class="foot"><p><a class="ln" href="${ctx}/login">Quay lại đăng nhập</a></p></div>
    </div>
</main>

<script src="${ctx}/assets/js/auth.js"></script>
</body>
</html>
