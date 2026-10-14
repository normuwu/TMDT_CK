<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>PrintKraft Admin — Quản lý tài khoản</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=IBM+Plex+Sans:wght@400;500;600&family=IBM+Plex+Mono:wght@400;500&family=Barlow+Condensed:wght@600;700&family=Barlow:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="auth.css">
</head>
<body data-t="ad">

<nav class="sw" aria-label="Điều hướng">
  <a href="Đăng-nhập.jsp">Đăng nhập</a>
  <a href="Tạo-tài-khoản.jsp">Tạo tài khoản</a>
  <a href="Đăng-ký-NCC.jsp">Đăng ký NCC</a>
  <a href="Quên-mật-khẩu.jsp">Quên mật khẩu</a>
  <a href="Chỉnh-sửa-thông-tin.jsp">Chỉnh sửa thông tin</a>
  <a href="Quản-lý-tài-khoản.jsp" class="on">Quản lý tài khoản</a>
</nav>

<div class="screen on ad" id="accounts" data-t="ad">
  <aside class="side">
    <div class="brand"><span class="sq"></span> PrintKraft Admin</div>
    <a>Tổng quan</a><a>Quản lý Đơn hàng</a><a>Quản lý Khách hàng</a><a>Quản lý Nhà cung cấp</a><a>Vật liệu</a><a>Doanh thu nền tảng</a><a>Khiếu nại</a><a class="act">Quản lý tài khoản</a>
  </aside>
  <section class="amain">
    <header class="atop">
      <div><h1>Quản lý tài khoản</h1><p>Khách hàng, nhà cung cấp và quản trị viên</p></div>
      <input class="srch" type="search" placeholder="Tìm theo tên hoặc email" aria-label="Tìm tài khoản">
    </header>
    <div class="acont">
      <div class="panel">
        <div class="tabs">
          <button class="on" data-f="all">Tất cả<i>6</i></button>
          <button data-f="kh">Khách hàng<i>3</i></button>
          <button data-f="ncc">Nhà cung cấp<i>2</i></button>
          <button data-f="pd">Chờ duyệt<i>1</i></button>
        </div>
        <div class="tw">
        <table>
          <thead><tr><th>Tài khoản</th><th>Vai trò</th><th>Ngày tạo</th><th>Trạng thái</th><th>Thao tác</th></tr></thead>
          <tbody>
            <tr data-r="kh"><td><div class="u"><div class="a">MA</div><div><b>Nguyễn Minh Anh</b><span>minhanh@gmail.com</span></div></div></td><td><span class="bd kh">Khách hàng</span></td><td class="mono">12/03/2026</td><td><span class="bd on st">Hoạt động</span></td><td><button class="bt">Sửa</button><button class="bt dg tg">Khóa</button></td></tr>
            <tr data-r="ncc"><td><div class="u"><div class="a">SG</div><div><b>Sài Gòn Print</b><span>contact@saigonprint.vn</span></div></div></td><td><span class="bd ncc">Nhà cung cấp</span></td><td class="mono">02/02/2026</td><td><span class="bd on st">Hoạt động</span></td><td><button class="bt">Sửa</button><button class="bt dg tg">Khóa</button></td></tr>
            <tr data-r="kh"><td><div class="u"><div class="a">QB</div><div><b>Trần Quốc Bảo</b><span>quocbao@outlook.com</span></div></div></td><td><span class="bd kh">Khách hàng</span></td><td class="mono">28/05/2026</td><td><span class="bd lk st">Đã khóa</span></td><td><button class="bt">Sửa</button><button class="bt dg tg">Mở khóa</button></td></tr>
            <tr data-r="ncc pd"><td><div class="u"><div class="a">LL</div><div><b>Layer Lab Studio</b><span>hello@layerlab.vn</span></div></div></td><td><span class="bd ncc">Nhà cung cấp</span></td><td class="mono">22/09/2026</td><td><span class="bd pd st">Chờ duyệt</span></td><td><button class="bt ap">Duyệt</button><button class="bt dg">Từ chối</button></td></tr>
            <tr data-r="kh"><td><div class="u"><div class="a">TH</div><div><b>Lê Thu Hà</b><span>thuha.le@gmail.com</span></div></div></td><td><span class="bd kh">Khách hàng</span></td><td class="mono">05/07/2026</td><td><span class="bd on st">Hoạt động</span></td><td><button class="bt">Sửa</button><button class="bt dg tg">Khóa</button></td></tr>
            <tr data-r="adm"><td><div class="u"><div class="a" style="background:#1E2430">AD</div><div><b>Quản trị viên</b><span>admin@printkraft.vn</span></div></div></td><td><span class="bd adm">Admin</span></td><td class="mono">01/01/2026</td><td><span class="bd on">Hoạt động</span></td><td><button class="bt">Sửa</button></td></tr>
          </tbody>
        </table>
        </div>
      </div>
    </div>
  </section>
</div>

<div class="toast" id="toast" role="status"></div>

<script src="auth.js"></script>
<script src="auth.js"></script>
</body>
</html>
