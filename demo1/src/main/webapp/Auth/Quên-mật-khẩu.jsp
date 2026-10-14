<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>PrintKraft — Quên mật khẩu</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=IBM+Plex+Sans:wght@400;500;600&family=IBM+Plex+Mono:wght@400;500&family=Barlow+Condensed:wght@600;700&family=Barlow:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="auth.css">
</head>
<body data-t="kh">

<nav class="sw" aria-label="Điều hướng">
  <a href="Đăng-nhập.jsp">Đăng nhập</a>
  <a href="Tạo-tài-khoản.jsp">Tạo tài khoản</a>
  <a href="Đăng-ký-NCC.jsp">Đăng ký NCC</a>
  <a href="Quên-mật-khẩu.jsp" class="on">Quên mật khẩu</a>
  <a href="Chỉnh-sửa-thông-tin.jsp">Chỉnh sửa thông tin</a>
  <a href="Quản-lý-tài-khoản.jsp">Quản lý tài khoản</a>
</nav>

<main class="screen on kh" id="forgot" data-t="kh">
  <div class="card">
    <div class="logo"><span class="mark"></span> PrintKraft</div>
    <div id="f1">
      <h2>Quên mật khẩu</h2>
      <p class="sub">Nhập email đã đăng ký. Chúng tôi sẽ gửi liên kết để bạn đặt lại mật khẩu.</p>
      <form data-act="forgot">
        <div class="field"><label for="q1">Email</label><input id="q1" type="email" placeholder="ban@email.com" required></div>
        <button class="btn">Gửi liên kết đặt lại</button>
      </form>
    </div>
    <div id="f2" class="ok hide">
      <div class="tick">✓</div>
      <h2>Kiểm tra hộp thư</h2>
      <p class="sub">Liên kết đặt lại mật khẩu đã được gửi tới <b id="fm"></b>. Liên kết có hiệu lực trong 30 phút.</p>
      <button class="btn o" type="button" data-act="resend">Gửi lại liên kết</button>
    </div>
    <div class="foot"><p><a class="ln" href="Đăng-nhập.jsp">Quay lại đăng nhập</a></p></div>
  </div>
</main>

<div class="toast" id="toast" role="status"></div>

<script src="auth.js"></script>
</body>
</html></body>
</html>
