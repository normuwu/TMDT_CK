<html lang="vi">

<head>
  <meta charset="UTF-8">
  <title>PrintKraft Admin — Giải quyết tranh chấp</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link
    href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap"
    rel="stylesheet">
  <style>
    :root {
      --graphite: #1E2430;
      --panel: #262E3D;
      --bg: #F5F6F8;
      --cobalt: #3B5BDB;
      --green: #2F9E44;
      --amber: #E8590C;
      --red: #E03131;
      --line: #E3E5EA;
      --text: #1E2430;
      --muted: #6B7280;
    }

    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }

    body {
      background: var(--bg);
      color: var(--text);
      font-family: 'IBM Plex Sans', sans-serif;
      font-size: 14px;
    }

    .num,
    .mono {
      font-family: 'IBM Plex Mono', monospace;
    }

    a {
      color: inherit;
      text-decoration: none;
    }

    button {
      font-family: inherit;
      cursor: pointer;
    }

    .layout {
      display: grid;
      grid-template-columns: 236px 1fr;
      min-height: 100vh;
    }

    /* ===== Sidebar ===== */
    .sidebar {
      background: var(--graphite);
      color: rgba(255, 255, 255, 0.7);
      padding: 22px 16px;
      display: flex;
      flex-direction: column;
      position: sticky;
      top: 0;
      height: 100vh;
      overflow-y: auto;
    }

    .brand {
      display: flex;
      align-items: center;
      gap: 10px;
      color: white;
      font-weight: 600;
      font-size: 15px;
      padding: 0 8px 24px;
    }

    .brand .sq {
      width: 20px;
      height: 20px;
      background: var(--cobalt);
      border-radius: 5px;
    }

    .nav-group {
      margin-bottom: 22px;
    }

    .nav-label {
      font-size: 11px;
      text-transform: uppercase;
      letter-spacing: 0.06em;
      color: rgba(255, 255, 255, 0.35);
      padding: 0 8px 8px;
      font-weight: 600;
    }

    .nav-item {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 9px 10px;
      border-radius: 8px;
      font-size: 13.5px;
      font-weight: 500;
      margin-bottom: 2px;
      cursor: pointer;
    }

    .nav-item .ic {
      width: 16px;
      text-align: center;
      opacity: 0.8;
    }

    .nav-item:hover {
      background: rgba(255, 255, 255, 0.06);
      color: white;
    }

    .nav-item.active {
      background: var(--cobalt);
      color: white;
    }

    .sidebar-foot {
      margin-top: auto;
      border-top: 1px solid rgba(255, 255, 255, 0.1);
      padding-top: 16px;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .avatar {
      width: 32px;
      height: 32px;
      border-radius: 50%;
      background: var(--cobalt);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 12px;
      font-weight: 600;
      color: white;
    }

    .sidebar-foot div strong {
      display: block;
      color: white;
      font-size: 13px;
    }

    .sidebar-foot div span {
      font-size: 11.5px;
      color: rgba(255, 255, 255, 0.4);
    }

    /* ===== Main ===== */
    .main {
      display: flex;
      flex-direction: column;
      min-width: 0;
    }

    .topbar {
      height: 64px;
      background: white;
      border-bottom: 1px solid var(--line);
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 0 28px;
      flex-shrink: 0;
      gap: 16px;
      flex-wrap: wrap;
    }

    .topbar h1 {
      font-size: 17px;
      font-weight: 600;
    }

    .topbar-right {
      display: flex;
      align-items: center;
      gap: 14px;
    }

    .search-box {
      background: var(--bg);
      border: 1px solid var(--line);
      border-radius: 8px;
      padding: 8px 12px;
      font-size: 13px;
      width: 260px;
      color: var(--text);
      outline: none;
    }

    .search-box:focus {
      border-color: var(--cobalt);
    }

    .icon-btn {
      width: 36px;
      height: 36px;
      border-radius: 8px;
      background: var(--bg);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 15px;
      border: 1px solid var(--line);
      position: relative;
      cursor: pointer;
    }

    .icon-btn .dot {
      position: absolute;
      top: 6px;
      right: 7px;
      width: 6px;
      height: 6px;
      background: var(--red);
      border-radius: 50%;
    }

    .content {
      padding: 26px 28px;
      flex: 1;
    }

    /* two-col */
    .cols {
      display: grid;
      grid-template-columns: 1fr 340px;
      gap: 18px;
      align-items: start;
    }

    .panel {
      background: white;
      border: 1px solid var(--line);
      border-radius: 12px;
      overflow: hidden;
    }

    .panel-head {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 16px 20px;
      border-bottom: 1px solid var(--line);
    }

    .panel-head h3 {
      font-size: 14.5px;
      font-weight: 600;
    }

    .panel-head a {
      font-size: 12.5px;
      color: var(--cobalt);
      font-weight: 500;
      cursor: pointer;
    }

    .pill {
      display: inline-flex;
      align-items: center;
      gap: 5px;
      padding: 4px 10px;
      border-radius: 999px;
      font-size: 11.5px;
      font-weight: 600;
      white-space: nowrap;
    }

    .pill.red {
      background: #FFF0F0;
      color: var(--red);
    }

    .pill .dot {
      width: 6px;
      height: 6px;
      border-radius: 50%;
      background: currentColor;
    }

    .btn {
      border: 1px solid var(--line);
      background: white;
      border-radius: 8px;
      padding: 9px 16px;
      font-size: 13px;
      font-weight: 500;
    }

    .btn:hover {
      background: var(--bg);
    }

    .btn.primary {
      background: var(--cobalt);
      color: white;
      border-color: var(--cobalt);
    }

    .btn.primary:hover {
      background: #2f4bc4;
    }

    .btn.danger {
      background: var(--red);
      color: white;
      border-color: var(--red);
    }

    .btn.danger:hover {
      background: #c92a2a;
    }

    .data-table { width: 100%; border-collapse: collapse; }
    .data-table th, .data-table td { padding: 16px 24px; text-align: left; border-bottom: 1px solid var(--line); font-size: 14px; }
    .data-table th { font-size: 12px; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: 0.5px; }
    .data-table tbody tr:hover { background: #F8FAFC; }
    .data-table td.mado { color: var(--muted); }
    .data-table td.mado span { color: var(--text); font-weight: 500; }
    .data-table .action { color: var(--cobalt); font-weight: 600; cursor: pointer; }
    .data-table .action:hover { text-decoration: underline; }
    
    .filter-bar { display: flex; gap: 20px; padding: 16px 24px; border-bottom: 1px solid var(--line); font-size: 14px; font-weight: 600; color: var(--muted); }
    .filter-item { cursor: pointer; padding: 6px 12px; border-radius: 8px; }
    .filter-item.active { background: #F1F5F9; color: var(--text); }
    .filter-item:hover:not(.active) { color: var(--text); }


  </style>
</head>

<body>
  <div class="layout">

    <!-- ================= SIDEBAR ================= -->
    <aside class="sidebar">
      <div class="brand"><span class="sq"></span> PrintKraft Admin</div>

      <div class="nav-group">
        <div class="nav-label">Tổng quan</div>
        <div class="nav-item" onclick="switchPage(this,'dashboard')"><span class="ic">▤</span> Bảng điều khiển</div>
        <div class="nav-item" onclick="switchPage(this,'reports')"><span class="ic">📈</span> Báo cáo &amp; Doanh thu</div>
      </div>
      <div class="nav-group">
        <div class="nav-label">Vận hành</div>
        <div class="nav-item" onclick="switchPage(this,'orders')"><span class="ic">📦</span> Đơn hàng</div>
        <div class="nav-item" onclick="switchPage(this,'suppliers')"><span class="ic">🏭</span> Xưởng in đối tác</div>
        <div class="nav-item active" onclick="switchPage(this,'disputes')"><span class="ic">⚠️</span> Tranh chấp <span style="margin-left:auto; background:var(--red); color:white; font-size:10px; padding:1px 6px; border-radius:999px;">4</span></div>
      </div>
      <div class="nav-group">
        <div class="nav-label">Người dùng</div>
        <div class="nav-item" onclick="switchPage(this,'buyers')"><span class="ic">🛍️</span> Người mua</div>
        <div class="nav-item" onclick="switchPage(this,'staff')"><span class="ic">🧑‍💼</span> Nhân sự nội bộ</div>
      </div>
      <div class="nav-group">
        <div class="nav-label">Hệ thống</div>
        <div class="nav-item" onclick="switchPage(this,'settings')"><span class="ic">⚙️</span> Cấu hình</div>
        <div class="nav-item" onclick="switchPage(this,'logs')"><span class="ic">📜</span> Nhật ký hoạt động</div>
      </div>

      <div class="sidebar-foot">
        <div class="avatar">TH</div>
        <div><strong>Trần Hòa</strong><span>Quản trị viên</span></div>
      </div>
    </aside>

    <!-- ================= MAIN CONTENT ================= -->
    <div class="main">
      <div class="topbar">
        <div>
          <h1 id="pageTitle">Tranh chấp</h1>
          <div class="sub" style="font-size:12px; color:var(--muted); margin-top:1px;">Xử lý khiếu nại giữa khách hàng và xưởng in</div>
        </div>
        <div class="topbar-right">
          <input class="search-box" placeholder="Tìm đơn hàng, xưởng in, khách hàng..." style="width:300px;">
          <div class="icon-btn">🔔<span class="dot"></span></div>
          <div class="icon-btn">✉️</div>
        </div>
      </div>

      <div class="content">
        <div class="kpi-grid" style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 24px;">
          <!-- Tranh chấp mở -->
          <div class="panel" style="padding:24px;">
            <div style="font-size:13px; font-weight:600; color:var(--muted); margin-bottom:12px;">Tranh chấp mở</div>
            <div style="font-size:32px; font-weight:700; color:var(--text); margin-bottom:12px;">4</div>
            <div style="font-size:13px; font-weight:600; color:var(--red);">▲ 2 đơn mới hôm nay</div>
          </div>
          <!-- Đã giải quyết tháng này -->
          <div class="panel" style="padding:24px;">
            <div style="font-size:13px; font-weight:600; color:var(--muted); margin-bottom:12px;">Đã giải quyết tháng này</div>
            <div style="font-size:32px; font-weight:700; color:var(--text); margin-bottom:12px;">38</div>
            <div style="font-size:13px; font-weight:600; color:var(--green);">▲ 8 so với tháng 8</div>
          </div>
          <!-- Thời gian xử lý TB -->
          <div class="panel" style="padding:24px;">
            <div style="font-size:13px; font-weight:600; color:var(--muted); margin-bottom:12px;">Thời gian xử lý TB</div>
            <div style="font-size:32px; font-weight:700; color:var(--text); margin-bottom:12px;">6,2h</div>
            <div style="font-size:13px; font-weight:600; color:var(--green);">▼ 1,4h</div>
          </div>
          <!-- Tỉ lệ khách hài lòng -->
          <div class="panel" style="padding:24px;">
            <div style="font-size:13px; font-weight:600; color:var(--muted); margin-bottom:12px;">Tỉ lệ khách hài lòng</div>
            <div style="font-size:32px; font-weight:700; color:var(--text); margin-bottom:12px;">87%</div>
            <div style="font-size:13px; font-weight:600; color:var(--green);">▲ 3%</div>
          </div>
        </div>

        <div class="panel" style="margin-bottom: 24px;">
          <div class="panel-head">
            <h3>Danh sách tranh chấp</h3>
            <a style="color:var(--cobalt); font-size:14px; font-weight:600; cursor:pointer;">Xuất báo cáo</a>
          </div>
          <div class="filter-bar">
            <div class="filter-item active">Tất cả (4)</div>
            <div class="filter-item">Khẩn cấp</div>
            <div class="filter-item">Đang xử lý</div>
            <div class="filter-item">Đã giải quyết</div>
          </div>
          <table class="data-table">
            <thead>
              <tr>
                <th>Mã đơn</th>
                <th>Khách hàng</th>
                <th>Loại</th>
                <th>Trạng thái</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td class="mado">#<span>PK-08228</span></td>
                <td style="font-weight:500;">Quà Tặng Việt</td>
                <td>Sai màu in</td>
                <td><span class="pill red" style="background:#FEE2E2; color:#DC2626; border:none;"><span class="dot" style="background:#DC2626;"></span> Khẩn cấp</span></td>
                <td><span class="action">Xử lý</span></td>
              </tr>
              <tr>
                <td class="mado">#<span>PK-08201</span></td>
                <td style="font-weight:500;">Local Brand Co.</td>
                <td>Giao trễ</td>
                <td><span class="pill" style="background:#FFEDD5; color:#EA580C; border:none;"><span class="dot" style="background:#EA580C;"></span> Đang xử lý</span></td>
                <td><span class="action">Xử lý</span></td>
              </tr>
              <tr>
                <td class="mado">#<span>PK-08196</span></td>
                <td style="font-weight:500;">Minh Anh Store</td>
                <td>Sai chất liệu</td>
                <td><span class="pill" style="background:#FFEDD5; color:#EA580C; border:none;"><span class="dot" style="background:#EA580C;"></span> Đang xử lý</span></td>
                <td><span class="action">Xử lý</span></td>
              </tr>
              <tr>
                <td class="mado">#<span>PK-08188</span></td>
                <td style="font-weight:500;">The Coffee House X</td>
                <td>Đóng gói kém</td>
                <td><span class="pill" style="background:#E0E7FF; color:#4F46E5; border:none;"><span class="dot" style="background:#4F46E5;"></span> Mới</span></td>
                <td><span class="action">Xử lý</span></td>
              </tr>
              <tr>
                <td class="mado">#<span>PK-08174</span></td>
                <td style="font-weight:500;">Nguyễn Thảo</td>
                <td>Thiếu số lượng</td>
                <td><span class="pill" style="background:#DCFCE7; color:#16A34A; border:none;"><span class="dot" style="background:#16A34A;"></span> Đã giải quyết</span></td>
                <td><span class="action">Xem</span></td>
              </tr>
            </tbody>
          </table>
        </div>

        <div class="cols">
          <!-- Timeline Panel -->
          <div class="panel" style="flex:2;">
            <div class="panel-head">
              <h3>Diễn biến Khiếu nại #RE-9800</h3>
            </div>
            <div style="padding: 32px; position:relative;">
              <!-- Line -->
              <div style="position:absolute; top:48px; bottom:70px; left:56px; width:2px; background:var(--line); z-index:0;"></div>
              
              <!-- KH -->
              <div style="display:flex; gap:20px; margin-bottom:40px; position:relative; z-index:1;">
                <div style="width:50px; height:50px; border-radius:50%; background:#EA580C; display:flex; align-items:center; justify-content:center; color:white; font-weight:700; font-size:15px; flex-shrink:0;">KH</div>
                <div style="flex:1; background:#F8FAFC; border-radius:12px; padding:20px;">
                  <div style="display:flex; justify-content:space-between; margin-bottom:16px; align-items:center;">
                    <strong style="font-size:15px; color:var(--text);">Nguyễn Thảo (Khách hàng)</strong>
                    <span style="font-size:13px; color:var(--muted); font-weight:500;">05/09/2026</span>
                  </div>
                  <div style="font-size:14.5px; color:var(--text); line-height:1.6; margin-bottom:16px;">Ly sứ bị vỡ 3 cái do đóng gói sơ sài. Tôi yêu cầu hoàn tiền 450.000đ.</div>
                  <div style="display:inline-flex; align-items:center; gap:8px; padding:8px 12px; background:white; border:1px solid var(--line); border-radius:8px; font-size:13px; font-weight:500; color:var(--text); cursor:pointer;">📎 anh_ly_vo.jpg</div>
                </div>
              </div>

              <!-- XG -->
              <div style="display:flex; gap:20px; margin-bottom:40px; position:relative; z-index:1;">
                <div style="width:50px; height:50px; border-radius:50%; background:var(--cobalt); display:flex; align-items:center; justify-content:center; color:white; font-weight:700; font-size:15px; flex-shrink:0;">XG</div>
                <div style="flex:1; background:#F8FAFC; border-radius:12px; padding:20px;">
                  <div style="display:flex; justify-content:space-between; margin-bottom:16px; align-items:center;">
                    <strong style="font-size:15px; color:var(--text);">Sài Gòn Print (Xưởng in)</strong>
                    <span style="font-size:13px; color:var(--muted); font-weight:500;">05/09/2026</span>
                  </div>
                  <div style="font-size:14.5px; color:var(--text); line-height:1.6; margin-bottom:16px;">Xưởng đã bọc mút xốp cẩn thận. Đây là do đơn vị vận chuyển làm rơi vỡ. Xưởng không chấp nhận đền bù toàn bộ.</div>
                  <div style="display:inline-flex; align-items:center; gap:8px; padding:8px 12px; background:white; border:1px solid var(--line); border-radius:8px; font-size:13px; font-weight:500; color:var(--text); cursor:pointer;">📎 anh_dong_goi.jpg</div>
                </div>
              </div>

              <!-- AD -->
              <div style="display:flex; gap:20px; position:relative; z-index:1;">
                <div style="width:50px; height:50px; border-radius:50%; background:var(--graphite); display:flex; align-items:center; justify-content:center; color:white; font-weight:700; font-size:15px; flex-shrink:0;">AD</div>
                <div style="flex:1; background:white; border:1px solid var(--cobalt); border-radius:12px; padding:20px; box-shadow: 0 4px 12px rgba(47, 75, 196, 0.08);">
                  <div style="display:flex; justify-content:space-between; margin-bottom:16px; align-items:center;">
                    <strong style="font-size:15px; color:var(--text);">Trần Hòa (Admin)</strong>
                    <span style="font-size:13px; color:var(--muted); font-weight:500;">06/09/2026</span>
                  </div>
                  <div style="font-size:14.5px; color:var(--text); line-height:1.6;">Theo hình ảnh, xốp bọc ly chưa đủ tiêu chuẩn vận chuyển hàng dễ vỡ.<br>Quyết định sơ bộ: Xưởng chịu 50%, PrintKraft chịu 50% chi phí. Chờ xưởng xác nhận.</div>
                </div>
              </div>
            </div>
          </div>

          <!-- Info Panel -->
          <div class="panel" style="flex:1;">
            <div class="panel-head">
              <h3>Thông tin Yêu cầu</h3>
            </div>
            <div style="padding:24px;">
              <div style="margin-bottom:20px;">
                <label style="display:block; font-size:12px; text-transform:uppercase; color:var(--muted); font-weight:700; margin-bottom:6px;">Mã Đơn</label>
                <span style="font-size:15px; font-weight:600; color:var(--cobalt); cursor:pointer;">#PK-08005</span>
              </div>
              <div style="margin-bottom:20px;">
                <label style="display:block; font-size:12px; text-transform:uppercase; color:var(--muted); font-weight:700; margin-bottom:6px;">Sản phẩm</label>
                <span style="font-size:15px; font-weight:600;">Cốc sứ Sublimation (30 cái)</span>
              </div>
              <div style="margin-bottom:24px;">
                <label style="display:block; font-size:12px; text-transform:uppercase; color:var(--muted); font-weight:700; margin-bottom:6px;">Giá trị tranh chấp</label>
                <span style="font-size:15px; font-weight:700; color:var(--red);">450.000đ</span>
              </div>
              <div style="margin-bottom:24px;">
                <label style="display:block; font-size:12px; text-transform:uppercase; color:var(--muted); font-weight:700; margin-bottom:6px;">Trạng thái</label>
                <span class="pill red"><span class="dot"></span>Cần Admin phân xử</span>
              </div>

              <div style="margin-top:40px; display:flex; flex-direction:column; gap:12px;">
                <button class="btn primary" style="width:100%; font-size:14px; padding:12px; border-radius:8px;">Đóng khiếu nại (Hoàn tất)</button>
                <button class="btn danger" style="width:100%; font-size:14px; padding:12px; border-radius:8px;">Thực thi Hoàn tiền</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</body>

</html>