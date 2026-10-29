<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>PrintKraft Admin - Quản lý nền tảng</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="admin-platform.css">
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
      <a class="nav-item" href="<%= request.getContextPath() %>/Admin/quan-ly-don-hang"><span class="ic">📦</span> Đơn hàng</a>
      <a class="nav-item" href="admin.jsp#suppliers"><span class="ic">🏭</span> Xưởng in đối tác</a>
      <a class="nav-item" href="admin-ncc.jsp"><span class="ic">🏢</span> Nhà cung cấp</a>
      <a class="nav-item" href="admin-inventory.jsp"><span class="ic">▦</span> Quản lý kho</a>
      <a class="nav-item" href="admin-contracts.jsp"><span class="ic">§</span> Hợp đồng</a>
      <a class="nav-item" href="admin.jsp#disputes"><span class="ic">⚠️</span> Tranh chấp <span style="margin-left:auto; background:var(--red); color:white; font-size:10px; padding:1px 6px; border-radius:999px;">4</span></a>
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
      <a class="nav-item active" href="admin-platform.jsp"><span class="ic">◈</span> Quản lý nền tảng</a>
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
        <h1 id="pageTitle">Quản lý nền tảng</h1>
        <div class="sub" id="pageSub">Vận hành, cấu hình và giám sát hệ thống chung</div>
      </div>
      <div class="topbar-right">
        <input class="search-box" placeholder="Tìm nhanh trong quản lý nền tảng...">
        <div class="icon-btn" onclick="toast('Bạn có 3 thông báo mới')">🔔<span class="dot"></span></div>
        <div class="icon-btn" onclick="toast('Hộp thư đến: 5 tin nhắn chưa đọc')">✉️</div>
      </div>
    </div>

    <div class="content">
      <div class="tab-content active" id="page-platform">
        <div class="section-grid">
          <div class="metric-card"><div><div class="metric-title">Dịch vụ ổn định</div><div class="metric-value num" id="healthyServiceCount">0/0</div><div class="metric-note">Cập nhật theo lần kiểm tra gần nhất</div></div><div class="metric-icon green">✓</div></div>
          <div class="metric-card"><div><div class="metric-title">Tác vụ đang chạy</div><div class="metric-value num" id="runningJobCount">0</div><div class="metric-note">Đồng bộ, gửi tin và sao lưu</div></div><div class="metric-icon">◈</div></div>
          <div class="metric-card"><div><div class="metric-title">Sự cố chưa xử lý</div><div class="metric-value num" id="openIncidentCount">0</div><div class="metric-note">Cần theo dõi hoặc xác nhận</div></div><div class="metric-icon amber">!</div></div>
        </div>
        <div class="cols">
          <div>
            <div class="panel"><div class="panel-head"><div><h3>Giám sát dịch vụ</h3><div class="panel-subtitle" id="platformLastCheck">Chưa kiểm tra</div></div><button class="btn" type="button" onclick="refreshServices()">Làm mới</button></div><div class="status-stack" id="serviceList"></div></div>
            <div class="panel top-gap"><div class="panel-head"><h3>Sự cố và tác vụ vận hành</h3><button class="btn" type="button" onclick="runBackup()">Chạy backup</button></div><div id="incidentList"></div></div>
          </div>
          <form class="panel" id="platformConfigForm" onsubmit="savePlatformConfig(event)">
            <div class="panel-head"><div><h3>Cấu hình vận hành</h3><div class="panel-subtitle">Thiết lập áp dụng cho toàn hệ thống</div></div><span class="pill blue">Admin</span></div>
            <div class="settings-list">
              <label class="setting-row"><span><strong>Bảo trì theo lịch</strong><small>Tự động chuyển sang chế độ hạn chế</small></span><input type="checkbox" id="configScheduledMaintenance"></label>
              <label class="setting-row"><span><strong>Tự động backup</strong><small>Lưu tối đa 30 bản gần nhất</small></span><input type="checkbox" id="configAutoBackup"></label>
              <label class="setting-row"><span><strong>Tự động mở rộng</strong><small>Tăng tài nguyên khi tải vượt 80%</small></span><input type="checkbox" id="configAutoScale"></label>
              <label class="setting-row"><span><strong>Chế độ bảo trì</strong><small>Dừng nhận đơn mới khi bật</small></span><input type="checkbox" id="configMaintenanceMode"></label>
              <div class="form-field"><label>Giới hạn upload (MB)</label><input type="number" id="configUploadLimit" min="10" max="2048" required></div>
              <div class="form-field"><label>Khoảng cách backup (giờ)</label><input type="number" id="configBackupInterval" min="1" max="24" required></div>
            </div>
            <div class="panel-actions"><button class="btn" type="button" onclick="resetPlatformConfig()">Khôi phục</button><button class="btn primary" type="submit">Lưu cấu hình</button></div>
          </form>
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

<script src="admin-platform.js"></script>
</body>
</html>
