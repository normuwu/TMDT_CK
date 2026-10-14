<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>PrintKraft Admin - Thông báo</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="admin-notifications.css">
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
      <a class="nav-item" href="admin.jsp#orders"><span class="ic">📦</span> Đơn hàng</a>
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
      <a class="nav-item" href="admin-platform.jsp"><span class="ic">◈</span> Quản lý nền tảng</a>
      <a class="nav-item active" href="admin-notifications.jsp"><span class="ic">🔔</span> Thông báo</a>
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
        <h1 id="pageTitle">Thông báo</h1>
        <div class="sub" id="pageSub">Gửi tin nhắn, cảnh báo và cập nhật đến người dùng</div>
      </div>
      <div class="topbar-right">
        <input class="search-box" placeholder="Tìm nhanh trong thông báo...">
        <div class="icon-btn" onclick="toast('Bạn có 3 thông báo mới')">🔔<span class="dot"></span></div>
        <div class="icon-btn" onclick="toast('Hộp thư đến: 5 tin nhắn chưa đọc')">✉️</div>
      </div>
    </div>

    <div class="content">
      <div class="tab-content active" id="page-notifications">
        <div class="section-grid">
          <div class="metric-card"><div><div class="metric-title">Đã gửi</div><div class="metric-value num" id="sentNotificationCount">0</div><div class="metric-note">Trong lịch sử hiện tại</div></div><div class="metric-icon">🔔</div></div>
          <div class="metric-card"><div><div class="metric-title">Đã lên lịch</div><div class="metric-value num" id="scheduledNotificationCount">0</div><div class="metric-note">Sẽ gửi đúng thời điểm đã chọn</div></div><div class="metric-icon green">✓</div></div>
          <div class="metric-card"><div><div class="metric-title">Bản nháp</div><div class="metric-value num" id="draftNotificationCount">0</div><div class="metric-note">Chưa gửi đến người dùng</div></div><div class="metric-icon amber">✎</div></div>
        </div>
        <div class="cols">
          <form class="panel" id="notificationForm" onsubmit="submitNotification(event)">
            <div class="panel-head"><div><h3>Soạn thông báo</h3><div class="panel-subtitle">Gửi ngay, lên lịch hoặc lưu nháp</div></div><span class="pill blue">Đa kênh</span></div>
            <div class="form-grid">
              <div class="form-field"><label>Đối tượng nhận</label><select id="notificationAudience" required><option>Tất cả người dùng</option><option>Nhân sự nội bộ</option><option>Nhà cung cấp</option><option>Khách hàng doanh nghiệp</option></select></div>
              <div class="form-field"><label>Kênh gửi</label><select id="notificationChannel" required><option>In-app + Email</option><option>Chỉ in-app</option><option>Email</option><option>SMS</option></select></div>
              <div class="form-field"><label>Tiêu đề</label><input id="notificationTitle" maxlength="100" required placeholder="VD: Lịch bảo trì hệ thống"></div>
              <div class="form-field"><label>Mức độ</label><select id="notificationLevel"><option>Thông tin</option><option>Cảnh báo</option><option>Khẩn cấp</option></select></div>
              <div class="form-field"><label>Thời điểm gửi</label><select id="notificationTiming" onchange="toggleScheduleField()"><option value="now">Gửi ngay</option><option value="schedule">Lên lịch</option></select></div>
              <div class="form-field" id="notificationScheduleField" hidden><label>Ngày giờ gửi</label><input type="datetime-local" id="notificationScheduleAt"></div>
              <div class="form-field full-span"><label>Nội dung</label><textarea id="notificationMessage" maxlength="1000" required placeholder="Nhập nội dung gửi đến người dùng..."></textarea><small class="field-help"><span id="notificationCharCount">0</span>/1000 ký tự</small></div>
            </div>
            <div class="panel-actions"><button class="btn" type="button" onclick="saveNotificationDraft()">Lưu nháp</button><button class="btn primary" type="submit">Gửi thông báo</button></div>
          </form>
          <div class="panel">
            <div class="panel-head"><div><h3>Lịch sử thông báo</h3><div class="panel-subtitle">Theo dõi trạng thái gửi và gửi lại</div></div></div>
            <div class="toolbar"><input id="notificationSearch" placeholder="Tìm tiêu đề" oninput="renderNotifications()"><select id="notificationStatusFilter" onchange="renderNotifications()"><option value="">Tất cả trạng thái</option><option>Đã gửi</option><option>Đã lên lịch</option><option>Bản nháp</option></select></div>
            <div id="notificationList"></div>
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

<script src="admin-notifications.js"></script>
</body>
</html>
