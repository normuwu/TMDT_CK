<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>PrintKraft — Đăng nhập</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=IBM+Plex+Sans:wght@400;500;600&family=IBM+Plex+Mono:wght@400;500&family=Barlow+Condensed:wght@600;700&family=Barlow:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="auth.css">
</head>
<body data-t="kh">

<nav class="sw" aria-label="Điều hướng">
  <a href="Đăng-nhập.jsp" class="on">Đăng nhập</a>
  <a href="Tạo-tài-khoản.jsp">Tạo tài khoản</a>
  <a href="Đăng-ký-NCC.jsp">Đăng ký NCC</a>
  <a href="Quên-mật-khẩu.jsp">Quên mật khẩu</a>
  <a href="Chỉnh-sửa-thông-tin.jsp">Chỉnh sửa thông tin</a>
  <a href="Quản-lý-tài-khoản.jsp">Quản lý tài khoản</a>
</nav>

<main class="screen on kh" id="login" data-t="kh">
  <div class="card">
    <div class="logo"><span class="mark"></span> PrintKraft</div>
    <h2>Đăng nhập</h2>
    <p class="sub">Chào mừng quay lại. Tiếp tục theo dõi đơn in 3D của bạn.</p>
    <form data-msg="Đăng nhập thành công">
      <div class="field"><label for="l1">Email hoặc số điện thoại</label><input id="l1" type="text" placeholder="ban@email.com" required></div>
      <div class="field"><label for="l2">Mật khẩu <a class="ln" href="Quên-mật-khẩu.jsp">Quên mật khẩu?</a></label><input id="l2" type="password" placeholder="Nhập mật khẩu" required></div>
      <label class="chk"><input type="checkbox" checked> Ghi nhớ đăng nhập trên thiết bị này</label>
      <button class="btn">Đăng nhập</button>
    </form>
    <div class="or">hoặc</div>
    <button class="btn o" type="button">Tiếp tục với Google</button>
    <div class="foot"><p>Chưa có tài khoản?<a class="ln" href="Tạo-tài-khoản.jsp">Tạo tài khoản</a>
</p><p>Bạn là xưởng in? <a class="ln" href="Đăng-ký-NCC.jsp">Đăng ký làm nhà cung cấp</a>
</p></div>
  </div>
</main>

<div class="toast" id="toast" role="status"></div>

<script src="auth.js"></script>
</body>
</html></body>
</html>
