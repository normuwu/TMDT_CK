<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
  Thống kê doanh thu cho Người bán (xưởng in).
  Dữ liệu lấy từ /nhacungcap/api/stats/* (SellerStatsApiServlet) — chỉ xưởng của
  tài khoản đang đăng nhập. Giao diện và script dùng chung với trang Admin
  (Admin/admin.css + Admin/admin-stats.js), chỉ khác đường dẫn API qua meta stats-api.
--%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>PrintKraft Xưởng — Thống kê doanh thu</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="app-ctx" content="<%= request.getContextPath() %>">
<meta name="stats-api" content="<%= request.getContextPath() %>/nhacungcap/api/stats">
<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/Admin/admin.css">
</head>
<body>
<div class="layout">
  <div class="main">
    <div class="topbar">
      <div>
        <h1>Thống kê doanh thu</h1>
        <div class="sub">Doanh thu và đơn hoàn tất của xưởng bạn</div>
      </div>
      <div class="topbar-right">
        <a class="btn" href="dashBoard.jsp">← Bảng điều khiển</a>
      </div>
    </div>

    <div class="content">

      <!-- Bộ lọc thời gian -->
      <div class="panel stats-filter">
        <div class="toolbar">
          <label class="stats-field"><span>Từ ngày</span><input type="date" id="statsFrom"></label>
          <label class="stats-field"><span>Đến ngày</span><input type="date" id="statsTo"></label>
          <label class="stats-field"><span>Nhóm theo</span>
            <select id="statsGroup">
              <option value="auto">Tự động</option>
              <option value="day">Ngày</option>
              <option value="week">Tuần</option>
              <option value="month">Tháng</option>
            </select>
          </label>
          <button class="btn primary" id="statsApply" type="button">Áp dụng</button>
          <div class="stats-presets">
            <button class="stats-chip" type="button" data-preset="7">7 ngày</button>
            <button class="stats-chip" type="button" data-preset="30">30 ngày</button>
            <button class="stats-chip" type="button" data-preset="month">Tháng này</button>
            <button class="stats-chip" type="button" data-preset="lastmonth">Tháng trước</button>
            <button class="stats-chip" type="button" data-preset="quarter">Quý này</button>
            <button class="stats-chip" type="button" data-preset="year">Năm nay</button>
          </div>
        </div>
      </div>

      <!-- KPI -->
      <div class="kpi-row">
        <div class="kpi"><div class="label">Doanh thu</div><div class="value num" id="statKpiRevenue">—</div><div class="delta" id="statDeltaRevenue"></div></div>
        <div class="kpi"><div class="label">Đơn hoàn tất</div><div class="value num" id="statKpiOrders">—</div><div class="delta" id="statDeltaOrders"></div></div>
        <div class="kpi"><div class="label">Giá trị TB/đơn</div><div class="value num" id="statKpiAvg">—</div><div class="delta" id="statDeltaAvg"></div></div>
        <div class="kpi"><div class="label">Tỉ lệ hoàn/hủy</div><div class="value num" id="statKpiCancel">—</div><div class="delta" id="statDeltaCancel"></div></div>
      </div>

      <div class="cols" style="margin-bottom:18px;">
        <!-- Biểu đồ cột -->
        <div class="panel">
          <div class="panel-head">
            <div>
              <h3>Thống kê theo thời gian</h3>
              <div class="panel-subtitle" id="statsBarSub"></div>
            </div>
            <a id="statsExport">Xuất CSV</a>
          </div>
          <div class="tabs" id="statsMetricTabs">
            <div class="tab active" data-metric="revenue">Doanh thu</div>
            <div class="tab" data-metric="orders">Số đơn hàng</div>
          </div>
          <div class="stats-chart-wrap" id="statsBarChart"></div>
        </div>

        <!-- Biểu đồ tròn -->
        <div class="panel">
          <div class="panel-head">
            <div>
              <h3>Cơ cấu phân bổ</h3>
              <div class="panel-subtitle" id="statsPieSub"></div>
            </div>
          </div>
          <div class="tabs" id="statsDimTabs">
            <div class="tab active" data-dim="category">Nhóm sản phẩm</div>
            <div class="tab" data-dim="status">Trạng thái đơn</div>
          </div>
          <div class="stats-pie-body">
            <div class="stats-pie-wrap" id="statsPieChart"></div>
            <div class="stats-legend" id="statsPieLegend"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="toast" id="toast">Đã thực hiện</div>

<script>
  /* Hàm hỗ trợ mà admin-stats.js dùng (trang này không nạp admin.js). */
  function toast(message) {
    var el = document.getElementById('toast');
    el.textContent = message;
    el.classList.add('show');
    clearTimeout(window._toastTimer);
    window._toastTimer = setTimeout(function () { el.classList.remove('show'); }, 2200);
  }
  function csvCell(value) {
    return '"' + String(value == null ? '' : value).replace(/"/g, '""') + '"';
  }
  function downloadCsv(filename, rows) {
    var blob = new Blob(['\uFEFF' + rows.join('\n')], { type: 'text/csv;charset=utf-8' });
    var link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = filename;
    document.body.appendChild(link);
    link.click();
    link.remove();
    URL.revokeObjectURL(link.href);
    toast('Đã xuất ' + filename);
  }
</script>
<script src="<%= request.getContextPath() %>/Admin/admin-stats.js"></script>
</body>
</html>
