<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>PrintKraft Admin - Quản lý người dùng</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- Trang Admin là HTML+JS thuần (el-ignored=true): truyền contextPath/csrf bằng scriptlet -->
<meta name="app-ctx" content="<%= request.getContextPath() %>">
<meta name="csrf-token" content="<%= session.getAttribute("csrfToken") %>">
<%
  Object sessionUser = session.getAttribute("currentUser");
  int currentAdminId = sessionUser instanceof com.tmdt.model.SessionUser
      ? ((com.tmdt.model.SessionUser) sessionUser).getUserId() : 0;
%>
<meta name="current-user-id" content="<%= currentAdminId %>">
<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="admin-users.css">
</head>
<body>
<div class="layout">
  <aside class="sidebar">
    <div class="brand"><span class="sq"></span> PrintKraft Admin</div>

    <div class="nav-group">
      <div class="nav-label">Tổng quan</div>
      <a class="nav-item" href="admin.jsp#dashboard"><span class="ic">▤</span> Bảng điều khiển</a>
      <a class="nav-item" href="admin.jsp#reports"><span class="ic">📈</span> Báo cáo &amp; Doanh thu</a>
    </div>
    <div class="nav-group">
      <div class="nav-label">Vận hành</div>
      <a class="nav-item" href="admin.jsp#products"><span class="ic">🏷️</span> Sản phẩm</a>
      <a class="nav-item" href="admin.jsp#orders"><span class="ic">📦</span> Đơn hàng</a>
      <a class="nav-item" href="admin.jsp#suppliers"><span class="ic">🏭</span> Xưởng in đối tác</a>
      <a class="nav-item" href="admin-ncc.jsp"><span class="ic">🏢</span> Nhà cung cấp</a>
      <a class="nav-item" href="admin-supplier-requests.jsp"><span class="ic">📝</span> Yêu cầu NCC</a>
      <a class="nav-item" href="admin-inventory.jsp"><span class="ic">▦</span> Quản lý kho</a>
      <a class="nav-item" href="admin-contracts.jsp"><span class="ic">§</span> Hợp đồng</a>
      <a class="nav-item" href="admin.jsp#disputes"><span class="ic">⚠️</span> Tranh chấp <span style="margin-left:auto; background:var(--red); color:white; font-size:10px; padding:1px 6px; border-radius:999px;">4</span></a>
    </div>
    <div class="nav-group">
      <div class="nav-label">Truy cập</div>
      <a class="nav-item active" href="admin-users.jsp"><span class="ic">👥</span> Quản lý người dùng</a>
      <a class="nav-item" href="admin-rbac.jsp"><span class="ic">🔐</span> Phân quyền RBAC</a>
      <a class="nav-item" href="admin.jsp#buyers"><span class="ic">🛍️</span> Người mua</a>
      <a class="nav-item" href="admin.jsp#staff"><span class="ic">🧑‍💼</span> Nhân sự nội bộ</a>
    </div>
    <div class="nav-group">
      <div class="nav-label">Hệ thống</div>
      <a class="nav-item" href="admin-platform.jsp"><span class="ic">◈</span> Quản lý nền tảng</a>
      <a class="nav-item" href="admin-notifications.jsp"><span class="ic">🔔</span> Thông báo</a>
      <a class="nav-item" href="admin.jsp#settings"><span class="ic">⚙️</span> Cấu hình</a>
      <a class="nav-item" href="admin.jsp#logs"><span class="ic">📜</span> Nhật ký hoạt động</a>
    </div>

    <div class="sidebar-foot">
      <div class="avatar">TH</div>
      <div><strong>Trần Hòa</strong><span>Quản trị viên</span></div>
    </div>
  </aside>

  <div class="main">
    <div class="topbar">
      <div>
        <h1 id="pageTitle">Quản lý người dùng</h1>
        <div class="sub" id="pageSub">Thêm, sửa, xóa và theo dõi tài khoản thành viên</div>
      </div>
      <div class="topbar-right">
        <input class="search-box" placeholder="Tìm nhanh trong quản lý người dùng...">
        <div class="icon-btn" onclick="toast('Bạn có 3 thông báo mới')">🔔<span class="dot"></span></div>
        <div class="icon-btn" onclick="toast('Hộp thư đến: 5 tin nhắn chưa đọc')">✉️</div>
      </div>
    </div>

    <div class="content">
      <div class="tab-content active" id="page-users">
        <div class="section-grid">
          <div class="metric-card"><div><div class="metric-title">Tài khoản hoạt động</div><div class="metric-value num" id="userActiveCount">0</div><div class="metric-note">Có thể đăng nhập hệ thống</div></div><div class="metric-icon">👥</div></div>
          <div class="metric-card"><div><div class="metric-title">Chờ xác minh email</div><div class="metric-value num" id="userPendingCount">0</div><div class="metric-note">Chưa xác minh, không thể đăng nhập</div></div><div class="metric-icon amber">⏱</div></div>
          <div class="metric-card"><div><div class="metric-title">Tài khoản bị khóa</div><div class="metric-value num" id="userLockedCount">0</div><div class="metric-note">Không thể đăng nhập</div></div><div class="metric-icon red">!</div></div>
        </div>
        <div class="cols">
          <div class="panel">
            <div class="panel-head">
              <div><h3>Danh sách tài khoản thành viên</h3><div class="panel-subtitle">Quản lý hồ sơ, trạng thái và vai trò truy cập</div></div>
              <div class="inline-actions"><button class="btn" type="button" onclick="exportUsers()">Xuất CSV</button><button class="btn" type="button" onclick="loadUsers()">Tải lại</button></div>
            </div>
            <div class="toolbar">
              <input id="userSearch" placeholder="Tìm theo tên, email, SĐT" oninput="onUserSearchInput()">
              <select id="userRoleFilter" onchange="onUserFilterChange()">
                <option value="">Tất cả vai trò</option>
                <option value="CUSTOMER">Khách hàng</option>
                <option value="SELLER">Nhà cung cấp</option>
                <option value="ADMIN">Quản trị viên</option>
              </select>
              <select id="userStatusFilter" onchange="onUserFilterChange()">
                <option value="">Tất cả trạng thái</option>
                <option value="ACTIVE">Hoạt động</option>
                <option value="LOCKED">Bị khóa</option>
              </select>
            </div>
            <div class="table-wrap"><table><thead><tr><th>Người dùng</th><th>Liên hệ</th><th>Vai trò</th><th>Ngày tạo</th><th>Trạng thái</th><th>Thao tác</th></tr></thead><tbody id="usersTableBody"></tbody></table></div>
            <div class="table-footer">
              <span id="userResultCount">0 tài khoản</span>
              <span class="inline-actions">
                <button class="mini-btn" type="button" id="userPrev" onclick="gotoUserPage(-1)">‹ Trước</button>
                <span id="userPageInfo" class="table-note">Trang 1/1</span>
                <button class="mini-btn" type="button" id="userNext" onclick="gotoUserPage(1)">Sau ›</button>
              </span>
              <span>Dữ liệu từ máy chủ</span>
            </div>
          </div>
          <div class="panel">
            <div class="panel-head"><h3>Theo dõi tài khoản</h3><button class="btn" type="button" onclick="openAccessReview()">Rà soát</button></div>
            <div class="status-stack" id="userMonitoring"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="overlay" id="overlay" onclick="closeAll()"></div>

<div class="modal" id="entityModal" aria-hidden="true">
  <div class="modal-box" id="entityModalBox">
    <button class="modal-close" type="button" onclick="closeAll()">✕</button>
    <h3 id="entityModalTitle">Cập nhật dữ liệu</h3>
    <div class="sub" id="entityModalSubtitle"></div>
    <form id="entityForm">
      <div class="form-grid modal-form-grid" id="entityFormFields"></div>
      <div class="modal-actions">
        <button class="btn" type="button" onclick="closeAll()">Hủy</button>
        <button class="btn primary" type="submit" id="entitySubmitButton">Lưu thay đổi</button>
      </div>
    </form>
    <div id="entityInfoContent" hidden></div>
  </div>
</div>

<div class="modal" id="confirmModal" aria-hidden="true">
  <div class="modal-box confirm-box">
    <button class="modal-close" type="button" onclick="closeAll()">✕</button>
    <div class="confirm-icon">!</div>
    <h3 id="confirmTitle">Xác nhận thao tác</h3>
    <div class="sub" id="confirmMessage"></div>
    <div class="modal-actions">
      <button class="btn" type="button" onclick="closeAll()">Hủy</button>
      <button class="btn danger" type="button" id="confirmButton">Xác nhận</button>
    </div>
  </div>
</div>

<div class="toast" id="toast">Đã thực hiện</div>

<script src="admin-users.js"></script>
</body>
</html>
