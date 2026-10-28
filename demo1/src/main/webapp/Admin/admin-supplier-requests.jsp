<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>PrintKraft Admin - Yêu cầu làm Nhà cung cấp</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- Trang Admin là HTML+JS thuần (el-ignored=true): truyền contextPath/csrf bằng scriptlet -->
<meta name="app-ctx" content="<%= request.getContextPath() %>">
<meta name="csrf-token" content="<%= session.getAttribute("csrfToken") %>">
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
      <a class="nav-item active" href="admin-supplier-requests.jsp"><span class="ic">📝</span> Yêu cầu NCC</a>
      <a class="nav-item" href="admin-inventory.jsp"><span class="ic">▦</span> Quản lý kho</a>
      <a class="nav-item" href="admin-contracts.jsp"><span class="ic">§</span> Hợp đồng</a>
      <a class="nav-item" href="admin.jsp#disputes"><span class="ic">⚠️</span> Tranh chấp</a>
    </div>
    <div class="nav-group">
      <div class="nav-label">Truy cập</div>
      <a class="nav-item" href="admin-users.jsp"><span class="ic">👥</span> Quản lý người dùng</a>
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
        <h1 id="pageTitle">Yêu cầu làm Nhà cung cấp</h1>
        <div class="sub" id="pageSub">Duyệt hoặc từ chối yêu cầu xin quyền Nhà cung cấp</div>
      </div>
      <div class="topbar-right">
        <input class="search-box" placeholder="Tìm nhanh yêu cầu...">
        <div class="icon-btn" onclick="toast('Thông báo hệ thống')">🔔</div>
      </div>
    </div>

    <div class="content">
      <div class="section-grid">
        <div class="metric-card"><div><div class="metric-title">Đang chờ duyệt</div><div class="metric-value num" id="requestPendingCount">0</div><div class="metric-note">Cần Admin xử lý</div></div><div class="metric-icon amber">⏱</div></div>
        <div class="metric-card"><div><div class="metric-title">Đã duyệt</div><div class="metric-value num" id="requestApprovedCount">0</div><div class="metric-note">Đã cấp quyền Nhà cung cấp</div></div><div class="metric-icon green">✓</div></div>
        <div class="metric-card"><div><div class="metric-title">Đã từ chối</div><div class="metric-value num" id="requestRejectedCount">0</div><div class="metric-note">Người dùng có thể gửi lại</div></div><div class="metric-icon red">!</div></div>
      </div>

      <div class="panel">
        <div class="panel-head">
          <div><h3>Danh sách yêu cầu</h3><div class="panel-subtitle">Dữ liệu đọc trực tiếp từ bảng supplier_requests</div></div>
          <div class="inline-actions"><button class="btn" type="button" onclick="loadRequests()">Tải lại</button></div>
        </div>
        <div class="toolbar">
          <input id="requestSearch" placeholder="Tìm tên cửa hàng, người gửi, email, SĐT" oninput="onSearchInput()">
          <select id="requestStatusFilter" onchange="onFilterChange()">
            <option value="">Tất cả trạng thái</option>
            <option value="PENDING">Đang chờ duyệt</option>
            <option value="APPROVED">Đã duyệt</option>
            <option value="REJECTED">Bị từ chối</option>
          </select>
        </div>
        <div class="table-wrap">
          <table>
            <thead>
              <tr><th>Người gửi</th><th>Cửa hàng / xưởng in</th><th>Liên hệ</th><th>Trạng thái</th><th>Thời gian</th><th>Thao tác</th></tr>
            </thead>
            <tbody id="requestsTableBody"></tbody>
          </table>
        </div>
        <div class="table-footer">
          <span id="requestResultCount">0 yêu cầu</span>
          <span class="inline-actions">
            <button class="mini-btn" type="button" id="requestPrev" onclick="gotoPage(-1)">‹ Trước</button>
            <span id="requestPageInfo" class="table-note">Trang 1/1</span>
            <button class="mini-btn" type="button" id="requestNext" onclick="gotoPage(1)">Sau ›</button>
          </span>
          <span>Quyền thay đổi có hiệu lực ngay với khu vực Nhà cung cấp</span>
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

<script src="admin-supplier-requests.js"></script>
</body>
</html>
