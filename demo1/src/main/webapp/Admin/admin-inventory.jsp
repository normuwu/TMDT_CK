<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>PrintKraft Admin - Quản lý kho</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="admin-inventory.css">
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
      <a class="nav-item active" href="admin-inventory.jsp"><span class="ic">▦</span> Quản lý kho</a>
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
        <h1 id="pageTitle">Quản lý kho</h1>
        <div class="sub" id="pageSub">Theo dõi hàng hóa, xuất nhập tồn và lưu trữ</div>
      </div>
      <div class="topbar-right">
        <input class="search-box" placeholder="Tìm nhanh trong quản lý kho...">
        <div class="icon-btn" onclick="toast('Bạn có 3 thông báo mới')">🔔<span class="dot"></span></div>
        <div class="icon-btn" onclick="toast('Hộp thư đến: 5 tin nhắn chưa đọc')">✉️</div>
      </div>
    </div>

    <div class="content">
      <div class="tab-content active" id="page-inventory">
        <div class="section-grid">
          <div class="metric-card"><div><div class="metric-title">SKU đang quản lý</div><div class="metric-value num" id="inventorySkuCount">0</div><div class="metric-note">Tất cả kho và nhóm vật tư</div></div><div class="metric-icon">▦</div></div>
          <div class="metric-card"><div><div class="metric-title">Cảnh báo tồn thấp</div><div class="metric-value num" id="inventoryLowCount">0</div><div class="metric-note">Tồn khả dụng dưới ngưỡng</div></div><div class="metric-icon amber">!</div></div>
          <div class="metric-card"><div><div class="metric-title">Tổng tồn khả dụng</div><div class="metric-value num" id="inventoryAvailableCount">0</div><div class="metric-note">Đã trừ số lượng đang giữ</div></div><div class="metric-icon green">∑</div></div>
        </div>
        <div class="cols">
          <div class="panel">
            <div class="panel-head">
              <div><h3>Danh mục và xuất nhập tồn</h3><div class="panel-subtitle">Số lượng được cập nhật theo từng phiếu kho</div></div>
              <div class="inline-actions"><button class="btn" type="button" onclick="openInventoryItemForm()">+ Vật tư</button><button class="btn" type="button" onclick="openStockMovement('out')">Xuất kho</button><button class="btn primary" type="button" onclick="openStockMovement('in')">+ Nhập kho</button></div>
            </div>
            <div class="toolbar">
              <input id="inventorySearch" placeholder="Mã hoặc tên vật tư" oninput="renderInventory()">
              <select id="inventoryWarehouseFilter" onchange="renderInventory()"><option value="">Tất cả kho</option><option>Kho A</option><option>Kho B</option><option>Kho C</option></select>
              <select id="inventoryStateFilter" onchange="renderInventory()"><option value="">Tất cả mức tồn</option><option>Đủ hàng</option><option>Sắp thiếu</option><option>Cần nhập</option></select>
            </div>
            <div class="table-wrap"><table><thead><tr><th>Mã vật tư</th><th>Tên hàng</th><th>Tồn</th><th>Đã giữ</th><th>Khả dụng</th><th>Kho</th><th>Trạng thái</th><th></th></tr></thead><tbody id="inventoryTableBody"></tbody></table></div>
          </div>
          <div class="panel"><div class="panel-head"><h3>Giao dịch kho gần đây</h3><button class="btn" type="button" onclick="openStockMovement('audit')">Kiểm kê</button></div><div id="movementList"></div></div>
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

<script src="admin-inventory.js"></script>
</body>
</html>
