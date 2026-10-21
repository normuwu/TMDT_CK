<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <title>PrintKraft — Thông tin tài khoản</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=IBM+Plex+Sans:wght@400;500;600&family=IBM+Plex+Mono:wght@400;500&family=Barlow+Condensed:wght@600;700&family=Barlow:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/assets/css/auth.css">
</head>
<body data-t="kh">

<main class="screen on kh" id="profile">
    <div class="card w">
        <%-- TODO: send SUPPLIER / ADMIN to their own home once those URLs are final. --%>
        <p style="margin-bottom:16px"><a class="ln" href="${ctx}/KhachHang/trang_chu.jsp">← Về trang chủ</a></p>

        <div class="who">
            <div class="av"><c:out value="${profile.initials}"/></div>
            <div style="flex:1"><b><c:out value="${profile.displayName}"/></b><span>Thành viên từ <c:out value="${profile.memberSince}"/></span></div>
            <%-- TODO: avatar upload is out of scope for now (users.avatar_url exists but needs a file-upload feature). --%>
        </div>

        <c:if test="${not empty success}"><div class="alert success" role="status"><c:out value="${success}"/></div></c:if>

        <form method="post" action="${ctx}/profile">
            <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
            <h3>Thông tin cá nhân</h3>
            <c:if test="${not empty error}"><div class="alert error" role="alert"><c:out value="${error}"/></div></c:if>

            <div class="row">
                <div class="field${not empty errors.fullName ? ' has-err' : ''}">
                    <label for="p1">Họ và tên</label>
                    <input id="p1" name="fullName" type="text" autocomplete="name" maxlength="100"
                           value="<c:out value='${form.fullName}'/>" required>
                    <c:if test="${not empty errors.fullName}"><p class="err"><c:out value="${errors.fullName}"/></p></c:if>
                </div>
                <div class="field${not empty errors.phone ? ' has-err' : ''}">
                    <label for="p2">Số điện thoại</label>
                    <input id="p2" name="phone" type="tel" autocomplete="tel" maxlength="20"
                           value="<c:out value='${form.phone}'/>" required>
                    <c:if test="${not empty errors.phone}"><p class="err"><c:out value="${errors.phone}"/></p></c:if>
                </div>
            </div>

            <div class="field">
                <label for="p3">Email</label>
                <%-- Read-only and has no name attribute, so it is never submitted. Changing email needs re-verification (out of scope). --%>
                <input id="p3" type="email" value="<c:out value='${profile.email}'/>" readonly>
            </div>

            <div class="field${not empty errors.defaultAddress ? ' has-err' : ''}">
                <label for="p4">Địa chỉ nhận hàng</label>
                <textarea id="p4" name="defaultAddress" autocomplete="street-address" maxlength="300"><c:out value="${form.defaultAddress}"/></textarea>
                <c:if test="${not empty errors.defaultAddress}"><p class="err"><c:out value="${errors.defaultAddress}"/></p></c:if>
            </div>

            <div class="actions">
                <a class="btn o auto" href="${ctx}/profile">Hủy</a>
                <button class="btn auto" type="submit">Lưu thay đổi</button>
            </div>
        </form>

        <form method="post" action="${ctx}/profile/password" id="password">
            <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
            <h3>Đổi mật khẩu</h3>
            <c:if test="${not empty pwError}"><div class="alert error" role="alert"><c:out value="${pwError}"/></div></c:if>

            <div class="field${not empty pwErrors.currentPassword ? ' has-err' : ''}">
                <label for="p5">Mật khẩu hiện tại</label>
                <input id="p5" name="currentPassword" type="password" autocomplete="current-password" required>
                <c:if test="${not empty pwErrors.currentPassword}"><p class="err"><c:out value="${pwErrors.currentPassword}"/></p></c:if>
            </div>
            <div class="row">
                <div class="field${not empty pwErrors.newPassword ? ' has-err' : ''}">
                    <label for="p6">Mật khẩu mới</label>
                    <input id="p6" name="newPassword" type="password" autocomplete="new-password" minlength="8" placeholder="Tối thiểu 8 ký tự" required>
                    <c:if test="${not empty pwErrors.newPassword}"><p class="err"><c:out value="${pwErrors.newPassword}"/></p></c:if>
                </div>
                <div class="field${not empty pwErrors.confirmNewPassword ? ' has-err' : ''}">
                    <label for="p7">Nhập lại mật khẩu mới</label>
                    <input id="p7" name="confirmNewPassword" type="password" autocomplete="new-password" minlength="8" required>
                    <c:if test="${not empty pwErrors.confirmNewPassword}"><p class="err"><c:out value="${pwErrors.confirmNewPassword}"/></p></c:if>
                </div>
            </div>
            <div class="actions">
                <button class="btn auto" type="submit">Đổi mật khẩu</button>
            </div>
        </form>
    </div>
</main>

<script src="${ctx}/assets/js/auth.js"></script>
</body>
</html>
