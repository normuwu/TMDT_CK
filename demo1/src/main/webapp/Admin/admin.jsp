<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>PrintKraft Admin — Vận hành hệ thống</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- Trang Admin là HTML+JS thuần (el-ignored=true): contextPath truyền bằng scriptlet -->
<meta name="app-ctx" content="<%= request.getContextPath() %>">
<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="admin.css">
</head>
<body>
<div class="layout">

  <aside class="sidebar">
    <div class="brand"><span class="sq"></span> PrintKraft Admin</div>

    <div class="nav-group">
      <div class="nav-label">Tổng quan</div>
      <div class="nav-item active" onclick="switchPage(this,'dashboard')"><span class="ic">▤</span> Bảng điều khiển</div>
      <div class="nav-item" onclick="switchPage(this,'reports')"><span class="ic">📈</span> Báo cáo &amp; Doanh thu</div>
    </div>
    <div class="nav-group">
      <div class="nav-label">Vận hành</div>
      <div class="nav-item" onclick="switchPage(this,'products')"><span class="ic">🏷️</span> Sản phẩm</div>
      <div class="nav-item" onclick="switchPage(this,'orders')"><span class="ic">📦</span> Đơn hàng</div>
      <div class="nav-item" onclick="switchPage(this,'suppliers')"><span class="ic">🏭</span> Xưởng in đối tác</div>
      <a class="nav-item" href="admin-ncc.jsp"><span class="ic">🏢</span> Nhà cung cấp</a>
      <a class="nav-item" href="admin-supplier-requests.jsp"><span class="ic">📝</span> Yêu cầu NCC</a>
      <a class="nav-item" href="admin-inventory.jsp"><span class="ic">▦</span> Quản lý kho</a>
      <a class="nav-item" href="admin-contracts.jsp"><span class="ic">§</span> Hợp đồng</a>
      <div class="nav-item" onclick="switchPage(this,'disputes')"><span class="ic">⚠️</span> Tranh chấp</div>
    </div>
    <div class="nav-group">
      <div class="nav-label">Truy cập</div>
      <a class="nav-item" href="admin-users.jsp"><span class="ic">👥</span> Quản lý người dùng</a>
      <a class="nav-item" href="admin-rbac.jsp"><span class="ic">🔐</span> Phân quyền RBAC</a>
      <div class="nav-item" onclick="switchPage(this,'buyers')"><span class="ic">🛍️</span> Người mua</div>
      <div class="nav-item" onclick="switchPage(this,'staff')"><span class="ic">🧑‍💼</span> Nhân sự nội bộ</div>
    </div>
    <div class="nav-group">
      <div class="nav-label">Hệ thống</div>
      <a class="nav-item" href="admin-platform.jsp"><span class="ic">◈</span> Quản lý nền tảng</a>
      <a class="nav-item" href="admin-notifications.jsp"><span class="ic">🔔</span> Thông báo</a>
      <div class="nav-item" onclick="switchPage(this,'settings')"><span class="ic">⚙️</span> Cấu hình</div>
      <div class="nav-item" onclick="switchPage(this,'logs')"><span class="ic">📜</span> Nhật ký hoạt động</div>
    </div>

    <div class="sidebar-foot">
      <div class="avatar">TH</div>
      <div><strong>Trần Hòa</strong><span>Quản trị viên</span></div>
    </div>
  </aside>

  <div class="main">
    <div class="topbar">
      <div>
        <h1 id="pageTitle">Bảng điều khiển vận hành</h1>
        <div class="sub" id="pageSub">Thứ Bảy, 26 tháng 9, 2026</div>
      </div>
      <div class="topbar-right">
        <input class="search-box" placeholder="Tìm đơn hàng, xưởng in, khách hàng...">
        <div class="icon-btn" onclick="toast('Bạn có 3 thông báo mới')">🔔<span class="dot"></span></div>
        <div class="icon-btn" onclick="toast('Hộp thư đến: 5 tin nhắn chưa đọc')">✉️</div>
      </div>
    </div>

    <div class="content">

      <!-- ============ DASHBOARD ============ -->
      <div class="tab-content active" id="page-dashboard">
        <div class="alert" id="dashAlert" hidden>
          <span>⚠️</span>
          <span id="dashAlertText"></span>
          <a onclick="switchPageByName('products')">Xem chi tiết</a>
        </div>

        <div class="kpi-row">
          <div class="kpi">
            <div class="label">Doanh thu hôm nay</div>
            <div class="value num" id="dashRevenue">—</div>
            <div class="delta" id="dashRevenueDelta"></div>
          </div>
          <div class="kpi">
            <div class="label">Đơn hàng mới hôm nay</div>
            <div class="value num" id="dashOrders">—</div>
            <div class="delta" id="dashOrdersDelta"></div>
          </div>
          <div class="kpi">
            <div class="label">Đơn đang xử lý</div>
            <div class="value num" id="dashProcessing">—</div>
            <div class="delta" id="dashProcessingNote"></div>
          </div>
          <div class="kpi">
            <div class="label">Tỉ lệ hoàn tất (30 ngày)</div>
            <div class="value num" id="dashCompletion">—</div>
            <div class="delta" id="dashCompletionNote"></div>
          </div>
        </div>

        <div class="cols" style="margin-bottom:18px;">
          <div class="panel">
            <div class="panel-head">
              <h3>Doanh thu 7 ngày gần đây</h3>
              <a onclick="toast('Đã xuất báo cáo doanh thu')">Xuất báo cáo</a>
            </div>
            <div class="chart" id="dashChart"></div>
          </div>

          <div class="panel">
            <div class="panel-head">
              <h3>Cơ cấu doanh thu theo nhóm sản phẩm</h3>
              <a onclick="switchPageByName('reports')">Chi tiết</a>
            </div>
            <div id="dashCategories"></div>
          </div>
        </div>

        <div class="cols">
          <div class="panel">
            <div class="panel-head">
              <h3>Đơn hàng gần đây</h3>
              <a onclick="switchPageByName('orders')">Xem tất cả</a>
            </div>
            <div class="tabs">
              <div class="tab active" onclick="pickTab(this)">Tất cả</div>
              <div class="tab" onclick="pickTab(this)">Đang sản xuất</div>
              <div class="tab" onclick="pickTab(this)">Trễ hạn</div>
              <div class="tab" onclick="pickTab(this)">Khiếu nại</div>
            </div>
            <table>
              <thead>
                <tr><th>Mã đơn</th><th>Khách hàng</th><th>Xưởng in</th><th>Trạng thái</th><th>Giá trị</th></tr>
              </thead>
              <tbody id="dashboardOrdersBody"></tbody>
            </table>
          </div>

          <div style="display:flex; flex-direction:column; gap:18px;">
            <div class="panel">
              <div class="panel-head">
                <h3>Xưởng in doanh thu cao</h3>
                <a onclick="switchPageByName('suppliers')">Tất cả</a>
              </div>
              <div id="dashTopShops"></div>
            </div>

            <div class="panel">
              <div class="panel-head">
                <h3>Đơn chờ xác nhận</h3>
                <a onclick="switchPageByName('orders')">Xem tất cả</a>
              </div>
              <div id="dashPendingOrders"></div>
            </div>
          </div>
        </div>
      </div>

            <!-- ============ REPORTS ============ -->
            <div class="tab-content" id="page-reports">

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

              <!-- KPI theo khoảng thời gian đã chọn -->
              <div class="kpi-row">
                <div class="kpi">
                  <div class="label">Doanh thu</div>
                  <div class="value num" id="statKpiRevenue">—</div>
                  <div class="delta" id="statDeltaRevenue"></div>
                </div>
                <div class="kpi">
                  <div class="label">Tổng đơn hàng</div>
                  <div class="value num" id="statKpiOrders">—</div>
                  <div class="delta" id="statDeltaOrders"></div>
                </div>
                <div class="kpi">
                  <div class="label">Giá trị TB/đơn</div>
                  <div class="value num" id="statKpiAvg">—</div>
                  <div class="delta" id="statDeltaAvg"></div>
                </div>
                <div class="kpi">
                  <div class="label">Tỉ lệ hoàn/hủy</div>
                  <div class="value num" id="statKpiCancel">—</div>
                  <div class="delta" id="statDeltaCancel"></div>
                </div>
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
                    <div class="tab" data-dim="supplier">Xưởng in</div>
                    <div class="tab" data-dim="status">Trạng thái đơn</div>
                  </div>
                  <div class="stats-pie-body">
                    <div class="stats-pie-wrap" id="statsPieChart"></div>
                    <div class="stats-legend" id="statsPieLegend"></div>
                  </div>
                </div>
              </div>

              <div class="panel">
                <div class="panel-head">
                  <h3>Top xưởng in theo doanh thu</h3>
                  <a onclick="toast('Đã mở bảng xếp hạng đầy đủ')">Chi tiết</a>
                </div>
                <div id="statsTopSuppliers"></div>
              </div>

              <div style="height:18px;"></div>
              <div class="panel">
                <div class="panel-head">
                  <h3>Chỉ số vận hành chi tiết</h3>
                  <a onclick="toast('Đã tải dữ liệu mới nhất')">Tải lại</a>
                </div>
                <div class="detail-grid" style="grid-template-columns:repeat(4,1fr);">
                  <div class="field"><label>Thời gian SX TB</label><strong>47,2 giờ</strong></div>
                  <div class="field"><label>Tỉ lệ đúng hạn</label><strong>94,3%</strong></div>
                  <div class="field"><label>Tỉ lệ lỗi in</label><strong>1,8%</strong></div>
                  <div class="field"><label>Điểm hài lòng</label><strong>4,9/5</strong></div>
                  <div class="field"><label>Xưởng hoạt động</label><strong>118/120</strong></div>
                  <div class="field"><label>Đơn đang xử lý</label><strong>2.148</strong></div>
                  <div class="field"><label>Khách hàng mới</label><strong>186</strong></div>
                  <div class="field"><label>Khách quay lại</label><strong>68%</strong></div>
                </div>
              </div>
            </div>
      <!-- ============ PRODUCTS (SẢN PHẨM) ============ -->
      <div class="tab-content" id="page-products">
        <div class="section-grid">
          <div class="metric-card"><div><div class="metric-title">Tổng sản phẩm</div><div class="metric-value num" id="productTotalCount">0</div><div class="metric-note">Mã hàng đang được quản lý</div></div><div class="metric-icon">🏷️</div></div>
          <div class="metric-card"><div><div class="metric-title">Đang bán</div><div class="metric-value num" id="productActiveCount">0</div><div class="metric-note">Có thể nhận đơn mới</div></div><div class="metric-icon green">✓</div></div>
          <div class="metric-card"><div><div class="metric-title">Cần chú ý</div><div class="metric-value num" id="productLowCount">0</div><div class="metric-note">Sắp hết hàng hoặc đã ngừng bán</div></div><div class="metric-icon amber">!</div></div>
        </div>
        <div class="cols">
          <div class="panel">
            <div class="panel-head">
              <div><h3>Danh mục sản phẩm</h3><div class="panel-subtitle">Quản lý giá bán, tồn kho và trạng thái kinh doanh</div></div>
              <div class="inline-actions"><button class="btn" type="button" onclick="exportProducts()">Xuất CSV</button></div>
            </div>
            <div class="toolbar">
              <input id="productSearch" placeholder="Tìm tên hoặc mã sản phẩm" oninput="renderProducts()">
              <select id="productCategoryFilter" onchange="renderProducts()"><option value="">Tất cả nhóm</option></select>
              <select id="productStatusFilter" onchange="renderProducts()"><option value="">Tất cả trạng thái</option><option value="ACTIVE">Đang bán</option><option value="LOW">Sắp hết hàng</option><option value="HIDDEN">Ngừng bán</option></select>
            </div>
            <div class="table-wrap"><table><thead><tr><th>Sản phẩm</th><th>Nhóm sản phẩm</th><th>Giá bán</th><th>Tồn kho</th><th>Đã bán</th><th>Trạng thái</th><th>Thao tác</th></tr></thead><tbody id="productsTableBody"></tbody></table></div>
            <div class="table-footer"><span id="productResultCount">0 sản phẩm</span><span class="pager" id="productPager"></span></div>
          </div>
          <div class="panel">
            <div class="panel-head"><h3>Hiệu quả kinh doanh</h3><button class="btn" type="button" onclick="openProductInsight()">Phân tích</button></div>
            <div id="productInsight"></div>
          </div>
        </div>
      </div>
      <!-- ============ ORDERS ============ -->
      <div class="tab-content" id="page-orders">
        <div class="section-grid">
          <div class="metric-card"><div><div class="metric-title">Tổng đơn hàng</div><div class="metric-value num" id="orderTotalCount">0</div><div class="metric-note" id="orderTotalValue">Tổng giá trị 0đ</div></div><div class="metric-icon">📦</div></div>
          <div class="metric-card"><div><div class="metric-title">Đang sản xuất / giao</div><div class="metric-value num" id="orderActiveCount">0</div><div class="metric-note">Đơn đang trong quá trình xử lý</div></div><div class="metric-icon green">⏱</div></div>
          <div class="metric-card"><div><div class="metric-title">Cần xử lý</div><div class="metric-value num" id="orderIssueCount">0</div><div class="metric-note">Trễ hạn, khiếu nại hoặc hoàn/hủy</div></div><div class="metric-icon red">!</div></div>
        </div>
        <div class="panel">
          <div class="panel-head">
            <div><h3>Quản lý đơn hàng</h3><div class="panel-subtitle">Thêm, sửa, xóa và cập nhật trạng thái đơn</div></div>
            <div class="inline-actions"><button class="btn" type="button" onclick="exportOrders()">Xuất CSV</button></div>
          </div>
          <div class="toolbar">
            <input id="orderSearch" placeholder="Tìm mã đơn, khách hàng, sản phẩm" oninput="renderOrders()">
            <select id="orderStatusFilter" onchange="renderOrders()"><option value="">Tất cả trạng thái</option><option value="PENDING">Chờ xác nhận</option><option value="CONFIRMED">Đã xác nhận</option><option value="SHIPPING">Đang giao</option><option value="COMPLETED">Hoàn tất</option><option value="CANCELLED">Đã hủy</option></select>
            <select id="orderSupplierFilter" onchange="renderOrders()"><option value="">Tất cả xưởng in</option></select>
            <select id="orderRangeFilter" onchange="renderOrders()"><option value="">Tất cả thời gian</option><option value="7">7 ngày gần nhất</option><option value="30">30 ngày gần nhất</option></select>
          </div>
          <div class="table-wrap"><table><thead><tr><th>Mã đơn</th><th>Khách hàng</th><th>Xưởng in</th><th>Trạng thái</th><th>Giá trị</th><th>Ngày tạo</th><th>Thao tác</th></tr></thead><tbody id="ordersTableBody"></tbody></table></div>
          <div class="table-footer"><span id="orderResultCount">0 đơn hàng</span><span class="pager" id="orderPager"></span></div>
        </div>
      </div>
      <!-- ============ SUPPLIERS ============ -->
      <div class="tab-content" id="page-suppliers">
        <div class="kpi-row">
          <div class="kpi">
            <div class="label">Tổng xưởng đối tác</div>
            <div class="value num" id="supplierListTotal">—</div>
            <div class="delta">Hồ sơ xưởng in trong hệ thống</div>
          </div>
          <div class="kpi">
            <div class="label">Đang hoạt động</div>
            <div class="value num" id="supplierListActive">—</div>
            <div class="delta" id="supplierListInactiveNote"></div>
          </div>
          <div class="kpi">
            <div class="label">Đánh giá trung bình</div>
            <div class="value num" id="supplierListRating">—</div>
            <div class="delta">Từ đánh giá thực tế của khách</div>
          </div>
          <div class="kpi">
            <div class="label">Sản phẩm đang bán</div>
            <div class="value num" id="supplierListProducts">—</div>
            <div class="delta">Tổng sản phẩm của các xưởng</div>
          </div>
        </div>

        <div class="panel">
          <div class="panel-head">
            <h3>Danh sách xưởng in đối tác</h3>
            <button class="btn" type="button" onclick="exportSuppliersList()">Xuất CSV</button>
          </div>
          <div class="toolbar">
            <input id="supplierListSearch" placeholder="Tìm xưởng in..." style="flex:1; min-width:180px;" oninput="renderSuppliersList()">
            <select id="supplierListSort" onchange="renderSuppliersList()">
              <option value="revenue">Sắp xếp: Doanh thu 30 ngày</option>
              <option value="orders">Sắp xếp: Số đơn 30 ngày</option>
              <option value="rating">Sắp xếp: Đánh giá</option>
              <option value="name">Sắp xếp: Tên A–Z</option>
            </select>
          </div>
          <table>
            <thead>
              <tr><th>Xưởng in</th><th>Khu vực</th><th>Đơn 30 ngày</th><th>Doanh thu 30 ngày</th><th>Đánh giá</th><th>Trạng thái</th><th></th></tr>
            </thead>
            <tbody id="suppliersListBody"></tbody>
          </table>
        </div>
      </div>

      <!-- ============ DISPUTES ============ -->
      <div class="tab-content" id="page-disputes">
        <div class="kpi-row">
          <div class="kpi">
            <div class="label">Tranh chấp mở</div>
            <div class="value num">4</div>
            <div class="delta down">▲ 2 đơn mới hôm nay</div>
          </div>
          <div class="kpi">
            <div class="label">Đã giải quyết tháng này</div>
            <div class="value num">38</div>
            <div class="delta up">▲ 8 so với tháng 8</div>
          </div>
          <div class="kpi">
            <div class="label">Thời gian xử lý TB</div>
            <div class="value num">6,2h</div>
            <div class="delta up">▼ 1,4h</div>
          </div>
          <div class="kpi">
            <div class="label">Tỉ lệ khách hài lòng</div>
            <div class="value num">87%</div>
            <div class="delta up">▲ 3%</div>
          </div>
        </div>

        <div class="cols">
          <div class="panel">
            <div class="panel-head">
              <h3>Danh sách tranh chấp</h3>
              <a onclick="toast('Đã xuất danh sách tranh chấp')">Xuất báo cáo</a>
            </div>
            <div class="tabs">
              <div class="tab active" onclick="pickTab(this)">Tất cả (4)</div>
              <div class="tab" onclick="pickTab(this)">Khẩn cấp</div>
              <div class="tab" onclick="pickTab(this)">Đang xử lý</div>
              <div class="tab" onclick="pickTab(this)">Đã giải quyết</div>
            </div>
            <table>
              <thead>
                <tr><th>Mã đơn</th><th>Khách hàng</th><th>Loại</th><th>Trạng thái</th><th></th></tr>
              </thead>
              <tbody>
                <tr>
                  <td class="order-id">#PK-08228</td>
                  <td>Quà Tặng Việt</td>
                  <td>Sai màu in</td>
                  <td><span class="pill red"><span class="dot"></span>Khẩn cấp</span></td>
                  <td><span class="action-link" onclick="openDisputeModal('#PK-08228','Khách báo lỗi in sai màu — chờ xưởng phản hồi','Khẩn cấp')">Xử lý</span></td>
                </tr>
                <tr>
                  <td class="order-id">#PK-08201</td>
                  <td>Local Brand Co.</td>
                  <td>Giao trễ</td>
                  <td><span class="pill amber"><span class="dot"></span>Đang xử lý</span></td>
                  <td><span class="action-link" onclick="openDisputeModal('#PK-08201','Yêu cầu hoàn tiền một phần do giao trễ','Đang xử lý')">Xử lý</span></td>
                </tr>
                <tr>
                  <td class="order-id">#PK-08196</td>
                  <td>Minh Anh Store</td>
                  <td>Sai chất liệu</td>
                  <td><span class="pill amber"><span class="dot"></span>Đang xử lý</span></td>
                  <td><span class="action-link" onclick="openDisputeModal('#PK-08196','Sản phẩm không đúng chất liệu đã đặt','Đang xử lý')">Xử lý</span></td>
                </tr>
                <tr>
                  <td class="order-id">#PK-08188</td>
                  <td>The Coffee House X</td>
                  <td>Đóng gói kém</td>
                  <td><span class="pill blue"><span class="dot"></span>Mới</span></td>
                  <td><span class="action-link" onclick="openDisputeModal('#PK-08188','Khách khiếu nại đóng gói kém, sản phẩm bị móp','Mới')">Xử lý</span></td>
                </tr>
                <tr>
                  <td class="order-id">#PK-08174</td>
                  <td>Nguyễn Thảo</td>
                  <td>Thiếu số lượng</td>
                  <td><span class="pill green"><span class="dot"></span>Đã giải quyết</span></td>
                  <td><span class="action-link" onclick="toast('Đã xem chi tiết tranh chấp đã đóng')">Xem</span></td>
                </tr>
              </tbody>
            </table>
          </div>

          <div class="panel">
            <div class="panel-head">
              <h3>Phân loại tranh chấp</h3>
              <a onclick="toast('Đã mở báo cáo phân tích')">Chi tiết</a>
            </div>
            <div class="list-item">
              <div><div class="name">Sai màu / sai thiết kế</div><div class="meta">18 vụ · 32%</div></div>
              <div><div class="bar-bg"><div class="bar-fill" style="width:32%; background:var(--red);"></div></div></div>
            </div>
            <div class="list-item">
              <div><div class="name">Giao trễ</div><div class="meta">14 vụ · 25%</div></div>
              <div><div class="bar-bg"><div class="bar-fill" style="width:25%; background:var(--amber);"></div></div></div>
            </div>
            <div class="list-item">
              <div><div class="name">Sai chất liệu</div><div class="meta">9 vụ · 16%</div></div>
              <div><div class="bar-bg"><div class="bar-fill" style="width:16%"></div></div></div>
            </div>
            <div class="list-item">
              <div><div class="name">Đóng gói / hư hỏng</div><div class="meta">8 vụ · 14%</div></div>
              <div><div class="bar-bg"><div class="bar-fill" style="width:14%"></div></div></div>
            </div>
            <div class="list-item">
              <div><div class="name">Khác</div><div class="meta">7 vụ · 13%</div></div>
              <div><div class="bar-bg"><div class="bar-fill" style="width:13%"></div></div></div>
            </div>
          </div>
        </div>
      </div>

      <!-- ============ BUYERS ============ -->
      <div class="tab-content" id="page-buyers">
        <div class="kpi-row">
          <div class="kpi">
            <div class="label">Tổng người mua</div>
            <div class="value num">18.420</div>
            <div class="delta up">▲ 186 mới tháng này</div>
          </div>
          <div class="kpi">
            <div class="label">Khách hoạt động 30 ngày</div>
            <div class="value num">6.842</div>
            <div class="delta up">▲ 12%</div>
          </div>
          <div class="kpi">
            <div class="label">Khách quay lại</div>
            <div class="value num">68%</div>
            <div class="delta up">▲ 4%</div>
          </div>
          <div class="kpi">
            <div class="label">Giá trị TB/khách</div>
            <div class="value num">2,4 tr</div>
            <div class="delta up">▲ 8%</div>
          </div>
        </div>

        <div class="panel">
          <div class="panel-head">
            <h3>Danh sách người mua</h3>
            <button class="btn" onclick="toast('Đã xuất danh sách khách hàng')">Xuất Excel</button>
          </div>
          <div class="toolbar">
            <input placeholder="Tìm tên, email, số điện thoại..." style="flex:1; min-width:200px;">
            <select>
              <option>Tất cả phân loại</option>
              <option>Khách VIP</option>
              <option>Khách doanh nghiệp</option>
              <option>Khách lẻ</option>
            </select>
          </div>
          <table>
            <thead>
              <tr><th>Khách hàng</th><th>Loại</th><th>Đơn hàng</th><th>Tổng chi tiêu</th><th>Đăng ký</th><th>Trạng thái</th></tr>
            </thead>
            <tbody>
              <tr>
                <td><strong>Minh Anh Store</strong><div style="font-size:11.5px; color:var(--muted);">minhanh@store.vn</div></td>
                <td><span class="pill blue">Doanh nghiệp</span></td>
                <td class="num">42</td>
                <td class="num">86.400.000đ</td>
                <td class="mono">12/03/2025</td>
                <td><span class="pill green"><span class="dot"></span>Hoạt động</span></td>
              </tr>
              <tr>
                <td><strong>Local Brand Co.</strong><div style="font-size:11.5px; color:var(--muted);">hello@localbrand.vn</div></td>
                <td><span class="pill blue">Doanh nghiệp</span></td>
                <td class="num">38</td>
                <td class="num">124.800.000đ</td>
                <td class="mono">05/01/2025</td>
                <td><span class="pill green"><span class="dot"></span>VIP</span></td>
              </tr>
              <tr>
                <td><strong>Quà Tặng Việt</strong><div style="font-size:11.5px; color:var(--muted);">sales@quatangviet.vn</div></td>
                <td><span class="pill blue">Doanh nghiệp</span></td>
                <td class="num">28</td>
                <td class="num">68.250.000đ</td>
                <td class="mono">18/07/2025</td>
                <td><span class="pill green"><span class="dot"></span>Hoạt động</span></td>
              </tr>
              <tr>
                <td><strong>Nguyễn Thảo</strong><div style="font-size:11.5px; color:var(--muted);">thaonguyen@gmail.com</div></td>
                <td><span class="pill gray">Khách lẻ</span></td>
                <td class="num">12</td>
                <td class="num">8.900.000đ</td>
                <td class="mono">22/11/2025</td>
                <td><span class="pill green"><span class="dot"></span>Hoạt động</span></td>
              </tr>
              <tr>
                <td><strong>The Coffee House X</strong><div style="font-size:11.5px; color:var(--muted);">ops@coffeex.vn</div></td>
                <td><span class="pill blue">Doanh nghiệp</span></td>
                <td class="num">19</td>
                <td class="num">52.120.000đ</td>
                <td class="mono">03/06/2025</td>
                <td><span class="pill green"><span class="dot"></span>VIP</span></td>
              </tr>
              <tr>
                <td><strong>Cần Thơ Store</strong><div style="font-size:11.5px; color:var(--muted);">ctstore@email.vn</div></td>
                <td><span class="pill gray">Khách lẻ</span></td>
                <td class="num">7</td>
                <td class="num">4.480.000đ</td>
                <td class="mono">14/08/2026</td>
                <td><span class="pill amber"><span class="dot"></span>Ít hoạt động</span></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- ============ STAFF ============ -->
      <div class="tab-content" id="page-staff">
        <div class="section-grid">
          <div class="metric-card"><div><div class="metric-title">Nhân sự đang làm</div><div class="metric-value num" id="staffActiveCount">0</div><div class="metric-note">Tài khoản nội bộ đang hoạt động</div></div><div class="metric-icon">👥</div></div>
          <div class="metric-card"><div><div class="metric-title">Đang tạm nghỉ</div><div class="metric-value num" id="staffLeaveCount">0</div><div class="metric-note">Quyền truy cập đang tạm khóa</div></div><div class="metric-icon amber">⏱</div></div>
          <div class="metric-card"><div><div class="metric-title">Bộ phận</div><div class="metric-value num" id="staffDepartmentCount">0</div><div class="metric-note">Đơn vị có nhân sự hoạt động</div></div><div class="metric-icon green">▦</div></div>
        </div>
        <div class="panel">
          <div class="panel-head">
            <div><h3>Danh sách nhân sự nội bộ</h3><div class="panel-subtitle">Quản lý hồ sơ công việc và tài khoản truy cập hệ thống</div></div>
            <div class="inline-actions"><button class="btn" type="button" onclick="exportStaff()">Xuất CSV</button><button class="btn primary" type="button" onclick="openStaffForm()">+ Thêm nhân sự</button></div>
          </div>
          <div class="toolbar">
            <input id="staffSearch" placeholder="Tìm tên, mã nhân viên, email" oninput="renderStaff()">
            <select id="staffDepartmentFilter" onchange="renderStaff()"><option value="">Tất cả bộ phận</option></select>
            <select id="staffStatusFilter" onchange="renderStaff()"><option value="">Tất cả trạng thái</option><option>Đang làm</option><option>Tạm nghỉ</option><option>Đã nghỉ việc</option></select>
          </div>
          <div class="table-wrap">
            <table>
              <thead><tr><th>Nhân sự</th><th>Chức danh</th><th>Bộ phận</th><th>Liên hệ</th><th>Ngày vào làm</th><th>Trạng thái</th><th>Thao tác</th></tr></thead>
              <tbody id="staffTableBody"></tbody>
            </table>
          </div>
          <div class="table-footer"><span id="staffResultCount">0 nhân sự</span><span>Đồng bộ với tài khoản người dùng nội bộ</span></div>
        </div>
      </div>

      <!-- ============ SETTINGS ============ -->
      <div class="tab-content" id="page-settings">
        <div class="cols">
          <div class="panel">
            <div class="panel-head"><h3>Cấu hình hệ thống</h3></div>
            <div class="detail-grid">
              <div class="field"><label>Phiên bản</label><strong>v2.8.4</strong></div>
              <div class="field"><label>Môi trường</label><strong>Production</strong></div>
              <div class="field"><label>Múi giờ</label><strong>GMT+7 (Việt Nam)</strong></div>
              <div class="field"><label>Tiền tệ</label><strong>VND (₫)</strong></div>
            </div>
            <div style="padding:0 20px 20px;">
              <div class="list-item" style="padding-left:0; padding-right:0;">
                <div><div class="name">Thông báo email đơn hàng mới</div><div class="meta">Gửi email cho quản trị viên khi có đơn mới</div></div>
                <span class="pill green"><span class="dot"></span>Bật</span>
              </div>
              <div class="list-item" style="padding-left:0; padding-right:0;">
                <div><div class="name">Tự động ghép xưởng in</div><div class="meta">Hệ thống tự chọn xưởng tối ưu theo giá và thời gian</div></div>
                <span class="pill green"><span class="dot"></span>Bật</span>
              </div>
              <div class="list-item" style="padding-left:0; padding-right:0;">
                <div><div class="name">Duyệt thủ công đơn &gt; 50 triệu</div><div class="meta">Yêu cầu quản trị viên duyệt trước khi sản xuất</div></div>
                <span class="pill green"><span class="dot"></span>Bật</span>
              </div>
              <div class="list-item" style="padding-left:0; padding-right:0;">
                <div><div class="name">Chế độ bảo trì</div><div class="meta">Tạm dừng nhận đơn mới để bảo trì hệ thống</div></div>
                <span class="pill gray"><span class="dot"></span>Tắt</span>
              </div>
            </div>
            <div style="padding:0 20px 20px; display:flex; gap:10px;">
              <button class="btn primary" onclick="toast('Đã lưu cấu hình hệ thống')">Lưu thay đổi</button>
              <button class="btn" onclick="toast('Đã khôi phục cấu hình mặc định')">Khôi phục mặc định</button>
            </div>
          </div>

          <div class="panel">
            <div class="panel-head"><h3>Phân quyền vai trò</h3></div>
            <div class="list-item">
              <div><div class="name">Quản trị viên</div><div class="meta">Toàn quyền hệ thống</div></div>
              <span class="pill blue">2 người</span>
            </div>
            <div class="list-item">
              <div><div class="name">Quản lý vận hành</div><div class="meta">Quản lý đơn hàng, xưởng in, tranh chấp</div></div>
              <span class="pill blue">6 người</span>
            </div>
            <div class="list-item">
              <div><div class="name">CSKH</div><div class="meta">Xử lý khiếu nại, hỗ trợ khách hàng</div></div>
              <span class="pill blue">12 người</span>
            </div>
            <div class="list-item">
              <div><div class="name">Kế toán</div><div class="meta">Xem báo cáo doanh thu, hóa đơn</div></div>
              <span class="pill blue">4 người</span>
            </div>
            <div class="list-item">
              <div><div class="name">Giám sát xưởng</div><div class="meta">Theo dõi tiến độ xưởng đối tác</div></div>
              <span class="pill blue">8 người</span>
            </div>
            <div style="padding:14px 20px;">
              <button class="btn" onclick="toast('Đã mở trang phân quyền chi tiết')">Quản lý phân quyền</button>
            </div>
          </div>
        </div>
      </div>

      <!-- ============ USERS ============ -->
      <div class="tab-content" id="page-users">
        <div class="section-grid">
          <div class="metric-card"><div><div class="metric-title">Tài khoản hoạt động</div><div class="metric-value num" id="userActiveCount">0</div><div class="metric-note">Có thể đăng nhập hệ thống</div></div><div class="metric-icon">👥</div></div>
          <div class="metric-card"><div><div class="metric-title">Đang chờ duyệt</div><div class="metric-value num" id="userPendingCount">0</div><div class="metric-note">Cần xác minh thông tin</div></div><div class="metric-icon amber">⏱</div></div>
          <div class="metric-card"><div><div class="metric-title">Tài khoản bị khóa</div><div class="metric-value num" id="userLockedCount">0</div><div class="metric-note">Không thể đăng nhập</div></div><div class="metric-icon red">!</div></div>
        </div>
        <div class="cols">
          <div class="panel">
            <div class="panel-head">
              <div><h3>Danh sách tài khoản thành viên</h3><div class="panel-subtitle">Quản lý hồ sơ, trạng thái và vai trò truy cập</div></div>
              <div class="inline-actions"><button class="btn" type="button" onclick="exportUsers()">Xuất CSV</button><button class="btn primary" type="button" onclick="openUserForm()">+ Thêm người dùng</button></div>
            </div>
            <div class="toolbar">
              <input id="userSearch" placeholder="Tìm theo tên, email, SĐT" oninput="renderUsers()">
              <select id="userRoleFilter" onchange="renderUsers()"><option value="">Tất cả vai trò</option></select>
              <select id="userStatusFilter" onchange="renderUsers()"><option value="">Tất cả trạng thái</option><option>Hoạt động</option><option>Chờ duyệt</option><option>Bị khóa</option></select>
            </div>
            <div class="table-wrap"><table><thead><tr><th>Người dùng</th><th>Loại / Bộ phận</th><th>Vai trò</th><th>Đăng nhập cuối</th><th>Trạng thái</th><th>Thao tác</th></tr></thead><tbody id="usersTableBody"></tbody></table></div>
            <div class="table-footer"><span id="userResultCount">0 tài khoản</span><span>Dữ liệu được lưu trên trình duyệt</span></div>
          </div>
          <div class="panel">
            <div class="panel-head"><h3>Theo dõi tài khoản</h3><button class="btn" type="button" onclick="openAccessReview()">Rà soát</button></div>
            <div class="status-stack" id="userMonitoring"></div>
          </div>
        </div>
      </div>

      <!-- ============ RBAC ============ -->
      <div class="tab-content" id="page-rbac">
        <div class="section-grid">
          <div class="metric-card"><div><div class="metric-title">Vai trò đang dùng</div><div class="metric-value num" id="roleCount">0</div><div class="metric-note">Vai trò hệ thống và tùy chỉnh</div></div><div class="metric-icon">🔐</div></div>
          <div class="metric-card"><div><div class="metric-title">Quyền đang cấp</div><div class="metric-value num" id="permissionCount">0</div><div class="metric-note">Trên toàn bộ vai trò</div></div><div class="metric-icon green">✓</div></div>
          <div class="metric-card"><div><div class="metric-title">Yêu cầu cấp quyền</div><div class="metric-value num" id="accessRequestCount">0</div><div class="metric-note">Đang chờ phê duyệt</div></div><div class="metric-icon amber">⏱</div></div>
        </div>
        <div class="panel page-panel">
          <div class="panel-head">
            <div><h3>Ma trận phân quyền nội bộ</h3><div class="panel-subtitle">Bật hoặc tắt quyền theo từng vai trò công việc</div></div>
            <div class="inline-actions"><button class="btn" type="button" onclick="openRoleForm()">+ Vai trò</button><button class="btn" type="button" onclick="openRoleAssignment()">Gán vai trò</button><button class="btn primary" type="button" onclick="savePermissions()">Lưu phân quyền</button></div>
          </div>
          <div class="table-wrap"><table class="role-matrix" id="permissionMatrix"></table></div>
        </div>
        <div class="cols top-gap">
          <div class="panel"><div class="panel-head"><h3>Vai trò & phạm vi</h3></div><div id="roleList"></div></div>
          <div class="panel"><div class="panel-head"><h3>Yêu cầu cấp quyền</h3><span class="pill amber" id="pendingRequestPill">0 chờ duyệt</span></div><div id="accessRequestList"></div></div>
        </div>
      </div>

      <!-- ============ NCC ============ -->
      <div class="tab-content" id="page-ncc">
        <div class="section-grid">
          <div class="metric-card"><div><div class="metric-title">Nhà cung cấp</div><div class="metric-value num" id="supplierCount">0</div><div class="metric-note">Tổng hồ sơ đang quản lý</div></div><div class="metric-icon">🏢</div></div>
          <div class="metric-card"><div><div class="metric-title">Hồ sơ chờ duyệt</div><div class="metric-value num" id="supplierPendingCount">0</div><div class="metric-note">Cần xác minh pháp lý</div></div><div class="metric-icon amber">⏱</div></div>
          <div class="metric-card"><div><div class="metric-title">Quyền bị tạm dừng</div><div class="metric-value num" id="supplierSuspendedCount">0</div><div class="metric-note">Cần đánh giá lại SLA</div></div><div class="metric-icon red">!</div></div>
        </div>
        <div class="panel">
          <div class="panel-head">
            <div><h3>Nhà cung cấp và quyền truy cập</h3><div class="panel-subtitle">Quản lý hồ sơ pháp lý, hợp đồng và phạm vi vận hành</div></div>
            <div class="inline-actions"><button class="btn" type="button" onclick="exportSuppliers()">Xuất CSV</button><button class="btn primary" type="button" onclick="openSupplierAccessForm()">+ Thêm NCC</button></div>
          </div>
          <div class="toolbar">
            <input id="supplierSearch" placeholder="Tên NCC, mã số thuế, khu vực" oninput="renderSuppliers()">
            <select id="supplierRegionFilter" onchange="renderSuppliers()"><option value="">Tất cả khu vực</option><option>Miền Bắc</option><option>Miền Trung</option><option>Miền Nam</option></select>
            <select id="supplierStatusFilter" onchange="renderSuppliers()"><option value="">Tất cả trạng thái</option><option>Hoạt động</option><option>Chờ duyệt</option><option>Tạm dừng</option></select>
          </div>
          <div class="table-wrap"><table><thead><tr><th>NCC</th><th>Khu vực</th><th>Quyền hiện tại</th><th>SLA</th><th>Hợp đồng</th><th>Trạng thái</th><th>Thao tác</th></tr></thead><tbody id="suppliersTableBody"></tbody></table></div>
          <div class="table-footer"><span id="supplierResultCount">0 nhà cung cấp</span><span>Quyền thay đổi có hiệu lực ngay</span></div>
        </div>
      </div>

      <!-- ============ INVENTORY ============ -->
      <div class="tab-content" id="page-inventory">
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

      <!-- ============ CONTRACTS ============ -->
      <div class="tab-content" id="page-contracts">
        <div class="section-grid">
          <div class="metric-card"><div><div class="metric-title">Hợp đồng hiệu lực</div><div class="metric-value num" id="contractActiveCount">0</div><div class="metric-note">Đang trong thời gian áp dụng</div></div><div class="metric-icon">§</div></div>
          <div class="metric-card"><div><div class="metric-title">Sắp hết hạn</div><div class="metric-value num" id="contractExpiringCount">0</div><div class="metric-note">Cần gia hạn hoặc thanh lý</div></div><div class="metric-icon amber">⏱</div></div>
          <div class="metric-card"><div><div class="metric-title">Chờ ký số</div><div class="metric-value num" id="contractSigningCount">0</div><div class="metric-note">Đang chờ một hoặc nhiều bên ký</div></div><div class="metric-icon red">!</div></div>
        </div>
        <div class="cols">
          <div class="panel">
            <div class="panel-head">
              <div><h3>Kho hợp đồng</h3><div class="panel-subtitle">Theo dõi vòng đời và hồ sơ pháp lý</div></div>
              <div class="inline-actions"><button class="btn" type="button" onclick="exportContracts()">Xuất CSV</button><button class="btn primary" type="button" onclick="openContractForm()">+ Hợp đồng</button></div>
            </div>
            <div class="toolbar"><input id="contractSearch" placeholder="Mã hợp đồng hoặc đối tác" oninput="renderContracts()"><select id="contractStatusFilter" onchange="renderContracts()"><option value="">Tất cả trạng thái</option><option>Hiệu lực</option><option>Sắp hết hạn</option><option>Chờ ký</option><option>Hết hiệu lực</option></select></div>
            <div class="table-wrap"><table><thead><tr><th>Mã HĐ</th><th>Đối tác</th><th>Loại</th><th>Giá trị</th><th>Hiệu lực</th><th>Trạng thái</th><th>Thao tác</th></tr></thead><tbody id="contractsTableBody"></tbody></table></div>
          </div>
          <div class="panel"><div class="panel-head"><h3>Luồng xử lý gần đây</h3><span class="pill blue">Theo thời gian</span></div><div class="contract-timeline" id="contractTimeline"></div></div>
        </div>
      </div>

      <!-- ============ PLATFORM ============ -->
      <div class="tab-content" id="page-platform">
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

      <!-- ============ NOTIFICATIONS ============ -->
      <div class="tab-content" id="page-notifications">
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

      <!-- ============ LOGS ============ -->
      <div class="tab-content" id="page-logs">
        <div class="panel">
          <div class="panel-head">
            <h3>Nhật ký hoạt động</h3>
            <div style="display:flex; gap:8px;">
              <select style="border:1px solid var(--line); border-radius:8px; padding:8px 12px; font-size:13px;">
                <option>Tất cả hành động</option>
                <option>Đơn hàng</option>
                <option>Xưởng in</option>
                <option>Người dùng</option>
                <option>Hệ thống</option>
              </select>
              <button class="btn" onclick="toast('Đã xuất nhật ký')">Xuất log</button>
            </div>
          </div>
          <table>
            <thead>
              <tr><th>Thời gian</th><th>Người thực hiện</th><th>Hành động</th><th>Đối tượng</th><th>Chi tiết</th></tr>
            </thead>
            <tbody>
              <tr>
                <td class="mono">15/09 10:42</td>
                <td>Trần Hòa</td>
                <td><span class="pill blue">Cập nhật</span></td>
                <td>#PK-08231</td>
                <td>Chuyển trạng thái sang "Đang sản xuất"</td>
              </tr>
              <tr>
                <td class="mono">15/09 10:30</td>
                <td>Hệ thống</td>
                <td><span class="pill green">Tự động</span></td>
                <td>#PK-08235</td>
                <td>Ghép xưởng in Sài Gòn Print</td>
              </tr>
              <tr>
                <td class="mono">15/09 10:12</td>
                <td>Nguyễn Linh</td>
                <td><span class="pill amber">Cảnh báo</span></td>
                <td>#PK-08230</td>
                <td>Đánh dấu trễ hạn — gửi thông báo cho xưởng</td>
              </tr>
              <tr>
                <td class="mono">15/09 09:55</td>
                <td>Phạm Minh</td>
                <td><span class="pill red">Tranh chấp</span></td>
                <td>#PK-08228</td>
                <td>Tạo tranh chấp mới — loại "Sai màu in"</td>
              </tr>
              <tr>
                <td class="mono">15/09 09:40</td>
                <td>Trần Hòa</td>
                <td><span class="pill blue">Cập nhật</span></td>
                <td>Hà Nội Digital</td>
                <td>Điều chỉnh hiệu suất từ 78% lên 81%</td>
              </tr>
              <tr>
                <td class="mono">15/09 09:20</td>
                <td>Hệ thống</td>
                <td><span class="pill green">Tự động</span></td>
                <td>#PK-08240</td>
                <td>Nhận đơn mới từ The Coffee House X</td>
              </tr>
              <tr>
                <td class="mono">15/09 08:45</td>
                <td>Lê Trang</td>
                <td><span class="pill blue">Tài chính</span></td>
                <td>#PK-08225</td>
                <td>Xác nhận thanh toán 2.240.000đ</td>
              </tr>
              <tr>
                <td class="mono">15/09 08:15</td>
                <td>Hệ thống</td>
                <td><span class="pill green">Tự động</span></td>
                <td>#PK-08231</td>
                <td>Gửi file thiết kế đến xưởng Sài Gòn Print</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

    </div>
  </div>
</div>

<!-- ===== DISPUTE MODAL ===== -->
<div class="overlay" id="overlay" onclick="closeAll()"></div>
<div class="modal" id="disputeModal">
  <div class="modal-box">
    <button class="modal-close" onclick="closeAll()">✕</button>
    <h3 id="dmId">#PK-08228</h3>
    <div class="sub" id="dmDesc">Khách báo lỗi in sai màu — chờ xưởng phản hồi</div>

    <div class="detail-grid">
      <div class="field"><label>Khách hàng</label><strong>Quà Tặng Việt</strong></div>
      <div class="field"><label>Xưởng in</label><strong>Sài Gòn Print</strong></div>
      <div class="field"><label>Giá trị đơn</label><strong class="num">6.250.000đ</strong></div>
      <div class="field"><label>Trạng thái</label><strong id="dmStatus">Khẩn cấp</strong></div>
    </div>

    <h3 style="font-size:15px; margin-bottom:12px;">Lịch sử xử lý</h3>
    <div class="detail-grid" style="grid-template-columns:1fr;">
      <div class="field"><label>15/09 09:55 · Phạm Minh</label><strong style="font-size:13px;">Tạo tranh chấp — gửi ảnh sản phẩm lỗi</strong></div>
      <div class="field"><label>15/09 10:05 · Hệ thống</label><strong style="font-size:13px;">Thông báo xưởng Sài Gòn Print</strong></div>
      <div class="field"><label>Chờ xử lý</label><strong style="font-size:13px;">Đang đợi xưởng phản hồi trong 2 giờ</strong></div>
    </div>

    <div style="display:flex; gap:10px; margin-top:18px;">
      <button class="btn primary" style="flex:1;" onclick="toast('Đã gửi phản hồi cho khách hàng')">Phản hồi khách</button>
      <button class="btn danger" style="flex:1;" onclick="toast('Đã quyết định hoàn tiền cho khách')">Hoàn tiền</button>
    </div>
  </div>
</div>

<!-- ===== SUPPLIER MODAL ===== -->
<div class="modal" id="supplierModal">
  <div class="modal-box" style="width:520px;">
    <button class="modal-close" onclick="closeAll()">✕</button>
    <h3 id="smName">Sài Gòn Print</h3>
    <div class="sub" id="smRegion">TP.HCM · Đối tác từ 2024</div>

    <div class="detail-grid">
      <div class="field"><label>Đơn tháng này</label><strong id="smOrders" class="num">142</strong></div>
      <div class="field"><label>Hiệu suất</label><strong id="smPerf">92%</strong></div>
      <div class="field"><label>Đánh giá</label><strong id="smRating">4.9 ★</strong></div>
      <div class="field"><label>Tỉ lệ đúng hạn</label><strong>96%</strong></div>
    </div>

    <h3 style="font-size:15px; margin-bottom:12px;">Chỉ số chi tiết</h3>
    <div class="list-item" style="padding-left:0; padding-right:0;">
      <div><div class="name">Thời gian sản xuất TB</div><div class="meta">42 giờ · Nhanh hơn 12% mức chuẩn</div></div>
    </div>
    <div class="list-item" style="padding-left:0; padding-right:0;">
      <div><div class="name">Tỉ lệ lỗi in</div><div class="meta">1,2% · Thấp hơn mức cho phép</div></div>
    </div>
    <div class="list-item" style="padding-left:0; padding-right:0;">
      <div><div class="name">Tỉ lệ hủy đơn</div><div class="meta">0,4% · Rất thấp</div></div>
    </div>

    <div style="display:flex; gap:10px; margin-top:18px;">
      <button class="btn" style="flex:1;" onclick="toast('Đã gửi tin nhắn cho xưởng')">Nhắn tin</button>
      <button class="btn primary" style="flex:1;" onclick="toast('Đã mở trang quản lý xưởng')">Quản lý</button>
    </div>
  </div>
</div>

<!-- ===== ENTITY FORM MODAL ===== -->
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

<!-- ===== CONFIRM MODAL ===== -->
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

<script src="admin.js"></script>
<script src="admin-live.js"></script>
<script src="admin-stats.js"></script>
</body>
</html>
