<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>PrintKraft — Tạo tài khoản</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=IBM+Plex+Sans:wght@400;500;600&family=IBM+Plex+Mono:wght@400;500&family=Barlow+Condensed:wght@600;700&family=Barlow:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="auth.css">
</head>
<body data-t="kh">

<nav class="sw" aria-label="Điều hướng">
  <a href="Đăng-nhập.jsp">Đăng nhập</a>
  <a href="Tạo-tài-khoản.jsp" class="on">Tạo tài khoản</a>
  <a href="Đăng-ký-NCC.jsp">Đăng ký NCC</a>
  <a href="Quên-mật-khẩu.jsp">Quên mật khẩu</a>
  <a href="Chỉnh-sửa-thông-tin.jsp">Chỉnh sửa thông tin</a>
  <a href="Quản-lý-tài-khoản.jsp">Quản lý tài khoản</a>
</nav>

<main class="screen on kh" id="register" data-t="kh">
  <div class="card">
    <div class="logo"><span class="mark"></span> PrintKraft</div>
    <h2>Tạo tài khoản</h2>
    <p class="sub">Tải file STL, nhận báo giá từ các xưởng và đặt in trong vài phút.</p>
    <form data-msg="Đã tạo tài khoản. Kiểm tra email để xác minh.">
      <div class="field"><label for="r1">Họ và tên</label><input id="r1" type="text" placeholder="Nguyễn Minh Anh" required></div>
      <div class="row">
        <div class="field"><label for="r2">Email</label><input id="r2" type="email" placeholder="ban@email.com" required></div>
        <div class="field"><label for="r3">Số điện thoại</label><input id="r3" type="tel" placeholder="0901 234 567" required></div>
      </div>
      <div class="row">
        <div class="field"><label for="r4">Mật khẩu</label><input id="r4" type="password" minlength="8" placeholder="Tối thiểu 8 ký tự" required></div>
        <div class="field"><label for="r5">Nhập lại mật khẩu</label><input id="r5" type="password" minlength="8" placeholder="Nhập lại mật khẩu" required></div>
      </div>
      <label class="chk"><input type="checkbox" required> Tôi đồng ý với <a class="ln">Điều khoản sử dụng</a> và <a class="ln">Chính sách bảo mật</a></label>
      <button class="btn">Tạo tài khoản</button>
    </form>
    <div class="foot"><p>Đã có tài khoản? <a class="ln" href="Đăng-nhập.jsp">Đăng nhập</a></p></div>
  </div>
</main>

<div class="toast" id="toast" role="status"></div>

<script src="auth.js"></script>
</body>
</html></body>
</html>
