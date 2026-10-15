<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%--
  Email verification result. Servlet: GET /verify-email?token=...
  Request attributes: verified (Boolean). Optional: message (String) to override the default text.
--%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <title>PrintKraft — Xác minh email</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=IBM+Plex+Sans:wght@400;500;600&family=IBM+Plex+Mono:wght@400;500&family=Barlow+Condensed:wght@600;700&family=Barlow:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/assets/css/auth.css">
</head>
<body data-t="kh">

<main class="screen on kh" id="verify">
    <div class="card">
        <div class="logo"><span class="mark"></span> PrintKraft</div>
        <div class="ok">
            <c:choose>
                <c:when test="${verified}">
                    <div class="tick">✓</div>
                    <h2>Xác minh thành công</h2>
                    <p class="sub"><c:out value="${empty message ? 'Email của bạn đã được xác minh. Bạn có thể đăng nhập ngay bây giờ.' : message}"/></p>
                    <a class="btn" href="${ctx}/login">Đăng nhập</a>
                </c:when>
                <c:otherwise>
                    <div class="tick bad">✕</div>
                    <h2>Xác minh không thành công</h2>
                    <p class="sub"><c:out value="${empty message ? 'Liên kết xác minh đã hết hạn hoặc không hợp lệ. Hãy đăng nhập để yêu cầu gửi lại email xác nhận.' : message}"/></p>
                    <a class="btn" href="${ctx}/login">Về trang đăng nhập</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<script src="${ctx}/assets/js/auth.js"></script>
</body>
</html>
