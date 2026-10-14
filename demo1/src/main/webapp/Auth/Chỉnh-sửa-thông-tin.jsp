<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>PrintKraft — Chỉnh sửa thông tin</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=IBM+Plex+Sans:wght@400;500;600&family=IBM+Plex+Mono:wght@400;500&family=Barlow+Condensed:wght@600;700&family=Barlow:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="auth.css">
</head>
<body data-t="kh">

<nav class="sw" aria-label="Điều hướng">
  <a href="Đăng-nhập.jsp">Đăng nhập</a>
  <a href="Tạo-tài-khoản.jsp">Tạo tài khoản</a>
  <a href="Đăng-ký-NCC.jsp">Đăng ký NCC</a>
  <a href="Quên-mật-khẩu.jsp">Quên mật khẩu</a>
  <a href="Chỉnh-sửa-thông-tin.jsp" class="on">Chỉnh sửa thông tin</a>
  <a href="Quản-lý-tài-khoản.jsp">Quản lý tài khoản</a>
</nav>

<main class="screen on kh" id="profile" data-t="kh">
  <div class="card w">
    <div class="who">
      <div class="av">MA</div>
      <div style="flex:1"><b>Nguyễn Minh Anh</b><span>Khách hàng từ 03/2026</span></div>
      <button class="btn o auto" type="button">Đổi ảnh đại diện</button>
    </div>
    <form data-msg="Đã lưu thay đổi">
      <h3>Thông tin cá nhân</h3>
      <div class="row">
        <div class="field"><label for="p1">Họ và tên</label><input id="p1" value="Nguyễn Minh Anh" required></div>
        <div class="field"><label for="p2">Số điện thoại</label><input id="p2" type="tel" value="0901 234 567" required></div>
      </div>
      <div class="row">
        <div class="field"><label for="p3">Email</label><input id="p3" value="minhanh@gmail.com" readonly></div>
        <div class="field"><label for="p4">Ngày sinh</label><input id="p4" type="date" value="1999-08-14"></div>
      </div>
      <div class="field"><label for="p5">Địa chỉ nhận hàng</label><textarea id="p5">12 Nguyễn Văn Bảo, Phường 4, Gò Vấp, TP. Hồ Chí Minh</textarea></div>
      <h3>Đổi mật khẩu</h3>
      <div class="field"><label for="p6">Mật khẩu hiện tại</label><input id="p6" type="password" placeholder="Để trống nếu không đổi"></div>
      <div class="row">
        <div class="field"><label for="p7">Mật khẩu mới</label><input id="p7" type="password" minlength="8" placeholder="Tối thiểu 8 ký tự"></div>
        <div class="field"><label for="p8">Nhập lại mật khẩu mới</label><input id="p8" type="password" minlength="8"></div>
      </div>
      <div class="actions"><a class="btn o auto" href="Đăng-nhập.jsp">Hủy</a><button class="btn auto">Lưu thay đổi</button></div>
    </form>
  </div>
</main>

<div class="toast" id="toast" role="status"></div>

<script src="auth.js"></script>
</body>
</html></body>
</html>
