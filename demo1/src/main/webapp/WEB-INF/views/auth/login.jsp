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

    <!-- Thêm thư viện Google Identity Services -->
    <script src="https://accounts.google.com/gsi/client" async defer></script>

    <!-- Thêm SDK Facebook -->
    <script async defer crossorigin="anonymous" src="https://connect.facebook.net/vi_VN/sdk.js"></script>

    <style>
        .divider {
            display: flex;
            align-items: center;
            text-align: center;
            margin: 20px 0;
            color: #666;
            font-size: 14px;
        }
        .divider::before, .divider::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid #ddd;
        }
        .divider span {
            padding: 0 10px;
        }
        .social-login-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
        }
        /* Đảm bảo thẻ bọc nút Google đạt đúng 240px */
        .g_id_signin {
            width: 240px !important;
        }
        .g_id_signin > div {
            width: 100% !important;
        }
        /* Style nút Facebook cân bằng kích thước với nút Google chuẩn */
        .fb-btn {
            background-color: #1877F2;
            color: #ffffff;
            border: none;
            border-radius: 4px;
            height: 40px;
            width: 240px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            box-sizing: border-box;
            font-family: Roboto, arial, sans-serif;
        }
        .fb-btn:hover {
            background-color: #166fe5;
        }
    </style>
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
                <label for="l1">Email</label>
                <input id="l1" name="identifier" type="text" autocomplete="username" placeholder="ban@email.com"
                       value="<c:out value='${param.identifier}'/>" required>
                <c:if test="${not empty errors.identifier}"><p class="err"><c:out value="${errors.identifier}"/></p></c:if>
            </div>

            <div class="field${not empty errors.password ? ' has-err' : ''}">
                <label for="l2">Mật khẩu <a class="ln" href="${ctx}/forgot-password">Quên mật khẩu?</a></label>
                <input id="l2" name="password" type="password" autocomplete="current-password" placeholder="Nhập mật khẩu" required>
                <c:if test="${not empty errors.password}"><p class="err"><c:out value="${errors.password}"/></p></c:if>
            </div>

            <label class="chk"><input type="checkbox" name="remember" value="on"${param.remember == 'on' ? ' checked' : ''}> Ghi nhớ đăng nhập trên thiết bị này</label>
            <button class="btn" type="submit">Đăng nhập</button>
        </form>

        <div class="divider"><span>Hoặc</span></div>

        <div class="social-login-wrapper">
            <!-- Cấu hình Đăng nhập Google -->
            <div id="g_id_onload"
                 data-client_id="1018661876708-10lju5b03u9m4tf11ifgijjtfs6aqhn7.apps.googleusercontent.com"
                 data-context="signin"
                 data-ux_mode="popup"
                 data-login_uri="http://localhost:8080${ctx}/google-login"
                 data-auto_prompt="false">
            </div>

            <!-- Nút Đăng nhập Google -->
            <div class="g_id_signin"
                 data-type="standard"
                 data-shape="rectangular"
                 data-theme="outline"
                 data-text="signin_with"
                 data-size="large"
                 data-logo_alignment="left">
            </div>

            <!-- Nút Đăng nhập Facebook -->
            <button type="button" class="fb-btn" onclick="loginWithFacebook()">
                <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
                </svg>
                Đăng nhập bằng Facebook
            </button>
        </div>

        <div class="foot">
            <p>Chưa có tài khoản? <a class="ln" href="${ctx}/register">Tạo tài khoản</a></p>
        </div>
    </div>
</main>

<script>
    // Khởi tạo Facebook SDK
    window.fbAsyncInit = function() {
        FB.init({
            appId      : '1758410285217946', // Thay App ID từ Facebook Developer Console
            cookie     : true,
            xfbml      : true,
            version    : 'v19.0'
        });
    };

    function loginWithFacebook() {
        FB.login(function(response) {
            if (response.authResponse) {
                FB.api('/me', {fields: 'name, email'}, function(userInfo) {
                    if (!userInfo.email) {
                        alert("Tài khoản Facebook của bạn không chia sẻ Email.");
                        return;
                    }

                    // Tạo Form tự động để submit dữ liệu về Servlet
                    var form = document.createElement("form");
                    form.method = "POST";
                    form.action = "${ctx}/facebook-login";

                    var inputEmail = document.createElement("input");
                    inputEmail.type = "hidden";
                    inputEmail.name = "email";
                    inputEmail.value = userInfo.email;
                    form.appendChild(inputEmail);

                    var inputName = document.createElement("input");
                    inputName.type = "hidden";
                    inputName.name = "name";
                    inputName.value = userInfo.name;
                    form.appendChild(inputName);

                    var inputCsrf = document.createElement("input");
                    inputCsrf.type = "hidden";
                    inputCsrf.name = "csrfToken";
                    inputCsrf.value = "${csrfToken}";
                    form.appendChild(inputCsrf);

                    document.body.appendChild(form);
                    form.submit();
                });
            }
        }, {scope: 'public_profile,email'});
    }
</script>

<script src="${ctx}/assets/js/auth.js"></script>
</body>
</html>
