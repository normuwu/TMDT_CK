<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>PrintKraft Admin — Bảng điều khiển</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<style>
:root{
  --bg:#F4F6FB;
  --surface:#FFFFFF;
  --sidebar:#0F1420;
  --sidebar-2:#161C2C;
  --ink:#0F1420;
  --ink-2:#1E2536;
  --muted:#6B7280;
  --muted-2:#9CA3AF;
  --line:#E4E7EE;
  --line-2:#EDEFF4;
  --blue:#3B6FF6;
  --blue-soft:#EAF0FF;
  --green:#10B981;
  --green-soft:#E6F8F2;
  --amber:#F59E0B;
  --amber-soft:#FFF3DF;
  --red:#EF4444;
  --red-soft:#FEE9E9;
  --violet:#7C5CFC;
  --cyan:#06B6D4;
  --shadow-sm:0 1px 2px rgba(15,20,32,.05);
  --shadow:0 4px 16px rgba(15,20,32,.06);
  --shadow-lg:0 20px 48px rgba(15,20,32,.14);
  --r:12px;
  --r-sm:8px;
  --r-lg:16px;
}
*{box-sizing:border-box; margin:0; padding:0;}
html,body{height:100%;}
body{
  font-family:'IBM Plex Sans', system-ui, -apple-system, sans-serif;
  background:var(--bg);
  color:var(--ink);
  font-size:14px;
  line-height:1.5;
  -webkit-font-smoothing:antialiased;
}
.num{font-family:'IBM Plex Mono', monospace; font-weight:600;}
.mono{font-family:'IBM Plex Mono', monospace;}
a{color:inherit; text-decoration:none;}
button{font-family:inherit; cursor:pointer; border:none; background:none; color:inherit; font-size:inherit;}
input,select,textarea{font-family:inherit; font-size:14px;}
::-webkit-scrollbar{width:8px; height:8px;}
::-webkit-scrollbar-track{background:transparent;}
::-webkit-scrollbar-thumb{background:#C9CFDB; border-radius:8px;}
::-webkit-scrollbar-thumb:hover{background:#A8B0BF;}

/* ================= LAYOUT ================= */
.layout{display:flex; min-height:100vh;}

/* ================= SIDEBAR ================= */
.sidebar{
  width:264px; flex-shrink:0;
  background:linear-gradient(180deg, var(--sidebar), var(--sidebar-2));
  color:#C7CEDB;
  display:flex; flex-direction:column;
  padding:20px 14px;
  position:sticky; top:0; height:100vh;
  overflow-y:auto;
}
.sidebar::-webkit-scrollbar{width:6px;}
.sidebar::-webkit-scrollbar-thumb{background:rgba(255,255,255,.08);}

.brand{
  display:flex; align-items:center; gap:11px;
  font-size:16px; font-weight:700; color:#fff;
  padding:6px 10px 22px;
  letter-spacing:-0.01em;
}
.brand .sq{
  width:26px; height:26px; border-radius:7px;
  background:linear-gradient(135deg,#3B6FF6,#7C5CFC);
  box-shadow:0 6px 16px rgba(59,111,246,.4);
  position:relative;
}
.brand .sq:before{
  content:""; position:absolute; inset:7px;
  background:#fff; border-radius:3px;
  clip-path:polygon(50% 0, 100% 100%, 0 100%);
}

.nav-group{margin-bottom:18px;}
.nav-label{
  font-size:10.5px; font-weight:700; text-transform:uppercase; letter-spacing:.1em;
  color:#5B6579; padding:0 12px 8px;
}
.nav-item{
  display:flex; align-items:center; gap:11px;
  padding:10px 12px; border-radius:var(--r-sm);
  font-size:13.5px; font-weight:500;
  color:#AFB7C7; cursor:pointer;
  transition:.15s; margin-bottom:2px;
  position:relative;
}
.nav-item:hover{background:rgba(255,255,255,.06); color:#fff;}
.nav-item.active{
  background:linear-gradient(90deg, rgba(59,111,246,.22), rgba(124,92,252,.16));
  color:#fff;
  box-shadow:inset 0 0 0 1px rgba(59,111,246,.3);
}
.nav-item.active:before{
  content:""; position:absolute; left:0; top:8px; bottom:8px; width:3px;
  background:linear-gradient(180deg,#3B6FF6,#7C5CFC); border-radius:0 4px 4px 0;
}
.nav-item .ic{
  width:18px; height:18px; flex-shrink:0;
  display:flex; align-items:center; justify-content:center;
  font-size:15px; opacity:.9;
}

.sidebar-foot{
  margin-top:auto; padding:14px 12px 6px;
  display:flex; align-items:center; gap:11px;
  border-top:1px solid rgba(255,255,255,.08);
}
.sidebar-foot .avatar{
  width:36px; height:36px; border-radius:50%;
  background:linear-gradient(135deg,#3B6FF6,#7C5CFC);
  color:#fff; font-weight:700; font-size:12.5px;
  display:flex; align-items:center; justify-content:center;
  flex-shrink:0;
}
.sidebar-foot strong{display:block; font-size:13.5px; color:#fff; font-weight:600;}
.sidebar-foot span{font-size:11.5px; color:#7A8296;}

/* ================= MAIN ================= */
.main{flex:1; min-width:0; display:flex; flex-direction:column;}

.topbar{
  display:flex; align-items:center; justify-content:space-between; gap:20px;
  padding:20px 32px 18px;
  background:var(--surface);
  border-bottom:1px solid var(--line);
  position:sticky; top:0; z-index:20;
  flex-wrap:wrap;
}
.topbar h1{font-size:20px; font-weight:700; color:var(--ink); letter-spacing:-0.01em;}
.topbar .sub{font-size:12.5px; color:var(--muted); margin-top:2px;}
.topbar-right{display:flex; align-items:center; gap:12px; flex-wrap:wrap;}
.search-box{
  border:1px solid var(--line); border-radius:10px;
  padding:9px 14px 9px 34px; font-size:13px;
  background:#F9FAFC url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='14' height='14' viewBox='0 0 24 24' fill='none' stroke='%236B7280' stroke-width='2'><circle cx='11' cy='11' r='7'/><line x1='21' y1='21' x2='16.65' y2='16.65'/></svg>") no-repeat 12px center;
  min-width:280px; outline:none;
  transition:.15s; color:var(--ink);
}
.search-box:focus{
  border-color:var(--blue); background-color:#fff;
  box-shadow:0 0 0 3px rgba(59,111,246,.12);
}
.icon-btn{
  width:38px; height:38px; border-radius:10px;
  border:1px solid var(--line); background:#fff;
  display:flex; align-items:center; justify-content:center;
  font-size:16px; cursor:pointer; transition:.15s;
  position:relative;
}
.icon-btn:hover{border-color:var(--blue); color:var(--blue); background:#F6F9FF;}
.icon-btn .dot{
  position:absolute; top:8px; right:8px;
  width:7px; height:7px; border-radius:50%;
  background:var(--red); border:1.5px solid #fff;
}

.content{padding:26px 32px 60px; flex:1;}

/* ================= TAB CONTENT ================= */
.tab-content{display:none;}
.tab-content.active{display:block; animation:fadeUp .25s ease;}
@keyframes fadeUp{from{opacity:0; transform:translateY(6px);} to{opacity:1; transform:none;}}

/* ================= ALERT ================= */
.alert{
  display:flex; align-items:center; gap:12px;
  background:var(--amber-soft);
  border:1px solid rgba(245,158,11,.35);
  border-radius:var(--r);
  padding:12px 16px; margin-bottom:20px;
  font-size:13.5px; color:#8A5A00;
}
.alert span:first-child{font-size:18px;}
.alert a{
  color:#B45309; font-weight:600; cursor:pointer;
  margin-left:auto; white-space:nowrap;
  border-bottom:1px solid transparent;
}
.alert a:hover{border-bottom-color:#B45309;}

/* ================= KPI ================= */
.kpi-row{
  display:grid; grid-template-columns:repeat(4, 1fr);
  gap:16px; margin-bottom:20px;
}
.kpi{
  background:var(--surface); border:1px solid var(--line);
  border-radius:var(--r); padding:18px 20px;
  position:relative; overflow:hidden;
  transition:.2s;
  box-shadow:var(--shadow-sm);
}
.kpi:hover{transform:translateY(-2px); box-shadow:var(--shadow); border-color:transparent;}
.kpi:before{
  content:""; position:absolute; left:0; top:0; bottom:0; width:3px;
  background:linear-gradient(180deg,#3B6FF6,#7C5CFC);
}
.kpi:nth-child(2):before{background:linear-gradient(180deg,#10B981,#06B6D4);}
.kpi:nth-child(3):before{background:linear-gradient(180deg,#F59E0B,#EF4444);}
.kpi:nth-child(4):before{background:linear-gradient(180deg,#EF4444,#7C5CFC);}
.kpi .label{font-size:12px; color:var(--muted); font-weight:600; text-transform:uppercase; letter-spacing:.04em;}
.kpi .value{font-size:28px; font-weight:700; margin:6px 0 6px; color:var(--ink);}
.kpi .delta{font-size:12px; font-weight:600;}
.kpi .delta.up{color:var(--green);}
.kpi .delta.down{color:var(--red);}

/* ================= PANELS & GRID ================= */
.cols{
  display:grid; grid-template-columns:1.6fr 1fr; gap:18px;
}
.panel{
  background:var(--surface); border:1px solid var(--line);
  border-radius:var(--r); padding:20px;
  box-shadow:var(--shadow-sm);
}
.panel-head{
  display:flex; align-items:center; justify-content:space-between;
  gap:12px; margin-bottom:16px; flex-wrap:wrap;
}
.panel-head h3{font-size:15px; font-weight:700; color:var(--ink);}
.panel-head a{
  font-size:12.5px; color:var(--blue); font-weight:600; cursor:pointer;
  padding:5px 10px; border-radius:6px; transition:.15s;
}
.panel-head a:hover{background:var(--blue-soft);}

/* ================= CHART ================= */
.chart{
  display:flex; align-items:flex-end; gap:12px;
  height:220px; padding:16px 4px 0;
  border-bottom:1px solid var(--line-2);
}
.bar{
  flex:1; background:linear-gradient(180deg,#3B6FF6, #7C5CFC);
  border-radius:8px 8px 0 0;
  position:relative; transition:.2s;
  min-height:6px;
  display:flex; align-items:flex-end; justify-content:center;
}
.bar:hover{filter:brightness(1.1); transform:translateY(-2px);}
.bar .val{
  position:absolute; top:-24px; left:50%; transform:translateX(-50%);
  font-size:11px; font-weight:700; color:var(--ink);
  background:#fff; padding:1px 7px; border-radius:6px;
  border:1px solid var(--line); white-space:nowrap;
  font-family:'IBM Plex Mono', monospace;
}
.bar > span:last-child{
  position:absolute; bottom:-24px; left:50%; transform:translateX(-50%);
  font-size:11px; color:var(--muted); font-weight:600;
  white-space:nowrap;
}

/* ================= LIST ITEM ================= */
.list-item{
  display:flex; align-items:center; justify-content:space-between;
  gap:14px; padding:11px 0;
  border-bottom:1px solid var(--line-2);
}
.list-item:last-child{border-bottom:none;}
.list-item .name{font-size:13.5px; font-weight:600; color:var(--ink);}
.list-item .meta{font-size:11.5px; color:var(--muted); margin-top:2px;}
.bar-bg{
  width:110px; height:6px; background:#EEF1F7;
  border-radius:999px; overflow:hidden; flex-shrink:0;
}
.bar-fill{
  height:100%; border-radius:999px;
  background:linear-gradient(90deg,#3B6FF6,#7C5CFC);
  transition:width .4s;
}

/* ================= TABS (small) ================= */
.tabs{display:flex; gap:4px; margin-bottom:14px; flex-wrap:wrap;}
.tab{
  padding:6px 12px; font-size:12.5px; font-weight:600;
  border-radius:8px; cursor:pointer; color:var(--muted);
  transition:.15s; user-select:none;
}
.tab:hover{background:var(--line-2); color:var(--ink);}
.tab.active{background:var(--blue-soft); color:var(--blue);}

/* ================= TABLE ================= */
table{width:100%; border-collapse:collapse; font-size:13px;}
thead th{
  text-align:left; font-size:11px; font-weight:700;
  text-transform:uppercase; letter-spacing:.05em;
  color:var(--muted); padding:10px 12px;
  border-bottom:1px solid var(--line);
}
tbody td{
  padding:13px 12px;
  border-bottom:1px solid var(--line-2);
  vertical-align:middle;
}
tbody tr:last-child td{border-bottom:none;}
tbody tr{transition:.15s;}
tbody tr:hover{background:#FAFBFD;}

.order-id{
  font-family:'IBM Plex Mono', monospace;
  font-weight:600; color:var(--blue);
}

.supplier-cell{
  display:inline-flex; align-items:center; gap:8px;
  font-size:13px; font-weight:500;
}
.supplier-cell .sq{
  width:24px; height:24px; border-radius:6px;
  background:linear-gradient(135deg,#3B6FF6,#7C5CFC);
  color:#fff; font-size:10px; font-weight:700;
  display:flex; align-items:center; justify-content:center;
  flex-shrink:0;
}

/* ================= PILL ================= */
.pill{
  display:inline-flex; align-items:center; gap:6px;
  font-size:11.5px; font-weight:600;
  padding:4px 10px; border-radius:999px;
  white-space:nowrap;
}
.pill .dot{width:6px; height:6px; border-radius:50%; background:currentColor;}
.pill.blue{background:var(--blue-soft); color:#2246B8;}
.pill.green{background:var(--green-soft); color:#047857;}
.pill.amber{background:var(--amber-soft); color:#B45309;}
.pill.red{background:var(--red-soft); color:#B91C1C;}
.pill.gray{background:#EEF1F7; color:#4B5563;}

/* ================= DISPUTE ITEM ================= */
.dispute-item{
  background:#FAFBFD;
  border:1px solid var(--line-2);
  border-left:3px solid var(--red);
  border-radius:var(--r-sm);
  padding:12px 14px; margin-bottom:10px;
  cursor:pointer; transition:.15s;
}
.dispute-item:hover{background:#F4F7FF; border-left-color:var(--blue); transform:translateX(2px);}
.dispute-item:last-child{margin-bottom:0;}
.dispute-item .top{
  display:flex; justify-content:space-between; align-items:center;
  margin-bottom:5px;
}
.dispute-item .top > span:first-child{
  font-family:'IBM Plex Mono', monospace;
  font-size:12.5px; font-weight:700; color:var(--ink);
}
.dispute-item .desc{font-size:12.5px; color:var(--muted); line-height:1.45;}

/* ================= TOOLBAR ================= */
.toolbar{
  display:flex; gap:10px; flex-wrap:wrap;
  padding:14px; margin-bottom:14px;
  background:#FAFBFD; border-radius:var(--r-sm);
  border:1px solid var(--line-2);
}
.toolbar input, .toolbar select{
  border:1px solid var(--line); border-radius:var(--r-sm);
  padding:9px 12px; font-size:13px; background:#fff;
  outline:none; transition:.15s; min-width:140px;
}
.toolbar input:focus, .toolbar select:focus{
  border-color:var(--blue); box-shadow:0 0 0 3px rgba(59,111,246,.12);
}

/* ================= BUTTONS ================= */
.btn{
  display:inline-flex; align-items:center; gap:6px;
  padding:9px 16px; border-radius:var(--r-sm);
  font-size:13px; font-weight:600;
  border:1px solid var(--line); background:#fff; color:var(--ink);
  transition:.15s; cursor:pointer;
}
.btn:hover{border-color:var(--blue); color:var(--blue); background:#F6F9FF;}
.btn.primary{
  background:linear-gradient(135deg,#3B6FF6,#7C5CFC);
  color:#fff; border-color:transparent;
  box-shadow:0 6px 16px rgba(59,111,246,.3);
}
.btn.primary:hover{filter:brightness(1.08); transform:translateY(-1px); color:#fff;}
.btn.danger{background:var(--red); color:#fff; border-color:transparent;}
.btn.danger:hover{filter:brightness(1.08); color:#fff;}

/* ================= DETAIL GRID ================= */
.detail-grid{
  display:grid; grid-template-columns:1fr 1fr; gap:12px;
  margin-bottom:16px;
}
.detail-grid .field{
  background:#FAFBFD; border:1px solid var(--line-2);
  border-radius:var(--r-sm); padding:12px 14px;
}
.detail-grid .field label{
  display:block; font-size:11px; font-weight:700;
  text-transform:uppercase; letter-spacing:.05em;
  color:var(--muted); margin-bottom:5px;
}
.detail-grid .field strong{
  font-size:14px; color:var(--ink); font-weight:600;
}

/* ================= MODAL ================= */
.overlay{
  position:fixed; inset:0; z-index:80;
  background:rgba(15,20,32,.55);
  backdrop-filter:blur(3px); -webkit-backdrop-filter:blur(3px);
  opacity:0; pointer-events:none; transition:.2s;
}
.overlay.show{opacity:1; pointer-events:auto;}

.modal{
  position:fixed; inset:0; z-index:90;
  display:flex; align-items:center; justify-content:center;
  padding:20px;
  opacity:0; pointer-events:none; transition:.2s;
  overflow-y:auto;
}
.modal.show{opacity:1; pointer-events:auto;}
.modal-box{
  background:#fff; border-radius:var(--r-lg);
  padding:26px; width:560px; max-width:100%;
  box-shadow:var(--shadow-lg);
  position:relative;
  max-height:92vh; overflow-y:auto; margin:auto;
  transform:translateY(10px) scale(.98); transition:.22s;
}
.modal.show .modal-box{transform:none;}
.modal-box h3{font-size:19px; font-weight:700; color:var(--ink); margin-bottom:4px;}
.modal-box .sub{font-size:13px; color:var(--muted); margin-bottom:20px;}
.modal-close{
  position:absolute; top:16px; right:16px;
  width:32px; height:32px; border-radius:8px;
  display:flex; align-items:center; justify-content:center;
  font-size:16px; color:var(--muted); transition:.15s;
}
.modal-close:hover{background:var(--line-2); color:var(--ink);}

.modal-actions{
  display:flex; gap:10px; margin-top:20px;
  justify-content:flex-end;
}

/* ================= TOAST ================= */
.toast{
  position:fixed; bottom:26px; left:50%; transform:translate(-50%, 90px);
  background:linear-gradient(135deg,#0F1420,#1E2536);
  color:#fff; padding:13px 24px; border-radius:12px;
  font-size:13.5px; font-weight:500;
  z-index:200; transition:.3s cubic-bezier(.4,0,.2,1);
  opacity:0; box-shadow:var(--shadow-lg);
  max-width:90vw; text-align:center;
}
.toast.show{transform:translate(-50%, 0); opacity:1;}

/* ================= RESPONSIVE ================= */
@media (max-width:1200px){
  .kpi-row{grid-template-columns:repeat(2,1fr);}
  .cols{grid-template-columns:1fr;}
}
@media (max-width:900px){
  .sidebar{width:72px; padding:16px 8px;}
  .brand span, .nav-label, .nav-item span:not(.ic), .sidebar-foot > div{display:none;}
  .nav-item{justify-content:center; padding:12px 0;}
  .nav-item.active:before{left:auto; right:0; border-radius:4px 0 0 4px;}
  .brand{justify-content:center; padding-bottom:16px;}
  .sidebar-foot{justify-content:center;}
  .topbar{padding:16px 20px;}
  .content{padding:20px 20px 50px;}
  .search-box{min-width:180px;}
}
@media (max-width:640px){
  .kpi-row{grid-template-columns:1fr;}
  .detail-grid{grid-template-columns:1fr;}
  .chart{height:180px; gap:6px;}
  .bar .val{font-size:9.5px; padding:1px 5px;}
  .toolbar input, .toolbar select{min-width:100%;}
  .search-box{min-width:150px;}
}
</style>
</head>
<body>
<div class="layout">

  <!-- ================= SIDEBAR ================= -->
  <aside class="sidebar">
    <div class="brand"><span class="sq"></span> PrintKraft Admin</div>

    <div class="nav-group">
      <div class="nav-label">Tổng quan</div>
      <a class="nav-item active" href="admin.jsp"><span class="ic">▤</span> Bảng điều khiển</a>
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
      <a class="nav-item" href="admin-notifications.jsp"><span class="ic">🔔</span> Thông báo</a>
      <a class="nav-item" href="admin.jsp#settings"><span class="ic">⚙️</span> Cấu hình</a>
      <a class="nav-item" href="admin.jsp#logs"><span class="ic">📜</span> Nhật ký hoạt động</a>
    </div>

    <div class="sidebar-foot">
      <div class="avatar">TH</div>
      <div><strong>Trần Hòa</strong><span>Quản trị viên</span></div>
    </div>
  </aside>

  <!-- ================= MAIN ================= -->
  <div class="main">
    <div class="topbar">
      <div>
        <h1>Bảng điều khiển vận hành</h1>
        <div class="sub" id="pageSub">Thứ Bảy, 26 tháng 9, 2026</div>
      </div>
      <div class="topbar-right">
        <input class="search-box" placeholder="Tìm đơn hàng, xưởng in, khách hàng...">
        <div class="icon-btn" onclick="toast('Bạn có 3 thông báo mới')">🔔<span class="dot"></span></div>
        <div class="icon-btn" onclick="toast('Hộp thư đến: 5 tin nhắn chưa đọc')">✉️</div>
      </div>
    </div>

    <div class="content">

      <div class="tab-content active" id="page-dashboard">
        <div class="alert">
          <span>⚠️</span>
          <span><strong>3 xưởng in</strong> đang trễ tiến độ giao hàng hơn 12 giờ so với cam kết.</span>
          <a href="admin.jsp#disputes">Xem chi tiết</a>
        </div>

        <div class="kpi-row">
          <div class="kpi">
            <div class="label">Doanh thu hôm nay</div>
            <div class="value num">184,2 tr</div>
            <div class="delta up">▲ 12,4% so với hôm qua</div>
          </div>
          <div class="kpi">
            <div class="label">Đơn hàng mới</div>
            <div class="value num">342</div>
            <div class="delta up">▲ 6,1%</div>
          </div>
          <div class="kpi">
            <div class="label">Tỉ lệ đúng hạn</div>
            <div class="value num">94,3%</div>
            <div class="delta down">▼ 1,8% tuần này</div>
          </div>
          <div class="kpi">
            <div class="label">Tranh chấp mở</div>
            <div class="value num">4</div>
            <div class="delta down">▲ 2 đơn mới</div>
          </div>
        </div>

        <div class="cols" style="margin-bottom:18px;">
          <div class="panel">
            <div class="panel-head">
              <h3>Doanh thu 7 ngày gần đây</h3>
              <a onclick="toast('Đã xuất báo cáo doanh thu')">Xuất báo cáo</a>
            </div>
            <div class="chart">
              <div class="bar" style="height:58%;"><span class="val">118tr</span><span>T2</span></div>
              <div class="bar" style="height:72%;"><span class="val">142tr</span><span>T3</span></div>
              <div class="bar" style="height:65%;"><span class="val">128tr</span><span>T4</span></div>
              <div class="bar" style="height:88%;"><span class="val">171tr</span><span>T5</span></div>
              <div class="bar" style="height:95%;"><span class="val">184tr</span><span>T6</span></div>
              <div class="bar" style="height:78%;"><span class="val">152tr</span><span>T7</span></div>
              <div class="bar" style="height:90%;"><span class="val">175tr</span><span>CN</span></div>
            </div>
          </div>

          <div class="panel">
            <div class="panel-head">
              <h3>Phân bổ theo sản phẩm</h3>
              <a onclick="toast('Đã mở báo cáo chi tiết')">Chi tiết</a>
            </div>
            <div class="list-item">
              <div><div class="name">Áo thun &amp; Hoodie</div><div class="meta">142 đơn · 38%</div></div>
              <div><div class="bar-bg"><div class="bar-fill" style="width:38%"></div></div></div>
            </div>
            <div class="list-item">
              <div><div class="name">Cốc &amp; Bình giữ nhiệt</div><div class="meta">98 đơn · 26%</div></div>
              <div><div class="bar-bg"><div class="bar-fill" style="width:26%"></div></div></div>
            </div>
            <div class="list-item">
              <div><div class="name">Poster &amp; Canvas</div><div class="meta">62 đơn · 17%</div></div>
              <div><div class="bar-bg"><div class="bar-fill" style="width:17%"></div></div></div>
            </div>
            <div class="list-item">
              <div><div class="name">Bao bì &amp; Nhãn dán</div><div class="meta">48 đơn · 12%</div></div>
              <div><div class="bar-bg"><div class="bar-fill" style="width:12%"></div></div></div>
            </div>
            <div class="list-item">
              <div><div class="name">Khác</div><div class="meta">30 đơn · 7%</div></div>
              <div><div class="bar-bg"><div class="bar-fill" style="width:7%"></div></div></div>
            </div>
          </div>
        </div>

        <div class="cols">
          <div class="panel">
            <div class="panel-head">
              <h3>Đơn hàng gần đây</h3>
              <a href="admin.jsp#orders">Xem tất cả</a>
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
              <tbody>
                <tr>
                  <td class="order-id">#PK-08231</td>
                  <td>Minh Anh Store</td>
                  <td><div class="supplier-cell"><span class="sq">SG</span> Sài Gòn Print</div></td>
                  <td><span class="pill blue"><span class="dot"></span>Đang sản xuất</span></td>
                  <td class="num">4.680.000đ</td>
                </tr>
                <tr>
                  <td class="order-id">#PK-08230</td>
                  <td>Local Brand Co.</td>
                  <td><div class="supplier-cell"><span class="sq">HN</span> Hà Nội Digital</div></td>
                  <td><span class="pill amber"><span class="dot"></span>Trễ hạn 6h</span></td>
                  <td class="num">12.400.000đ</td>
                </tr>
                <tr>
                  <td class="order-id">#PK-08229</td>
                  <td>Nguyễn Thảo</td>
                  <td><div class="supplier-cell"><span class="sq">DN</span> Đà Nẵng Xpress</div></td>
                  <td><span class="pill green"><span class="dot"></span>Hoàn tất</span></td>
                  <td class="num">890.000đ</td>
                </tr>
                <tr>
                  <td class="order-id">#PK-08228</td>
                  <td>Quà Tặng Việt</td>
                  <td><div class="supplier-cell"><span class="sq">SG</span> Sài Gòn Print</div></td>
                  <td><span class="pill red"><span class="dot"></span>Khiếu nại</span></td>
                  <td class="num">6.250.000đ</td>
                </tr>
                <tr>
                  <td class="order-id">#PK-08227</td>
                  <td>The Coffee House X</td>
                  <td><div class="supplier-cell"><span class="sq">CT</span> Cần Thơ Print</div></td>
                  <td><span class="pill blue"><span class="dot"></span>Đang sản xuất</span></td>
                  <td class="num">3.120.000đ</td>
                </tr>
              </tbody>
            </table>
          </div>

          <div style="display:flex; flex-direction:column; gap:18px;">
            <div class="panel">
              <div class="panel-head">
                <h3>Xưởng in hiệu suất cao</h3>
                <a href="admin.jsp#suppliers">Tất cả</a>
              </div>
              <div class="list-item">
                <div><div class="name">Sài Gòn Print</div><div class="meta">142 đơn tháng này</div></div>
                <div><div class="bar-bg"><div class="bar-fill" style="width:92%"></div></div></div>
              </div>
              <div class="list-item">
                <div><div class="name">Hà Nội Digital</div><div class="meta">98 đơn tháng này</div></div>
                <div><div class="bar-bg"><div class="bar-fill" style="width:81%"></div></div></div>
              </div>
              <div class="list-item">
                <div><div class="name">Đà Nẵng Xpress</div><div class="meta">76 đơn tháng này</div></div>
                <div><div class="bar-bg"><div class="bar-fill" style="width:70%; background:var(--amber);"></div></div></div>
              </div>
              <div class="list-item">
                <div><div class="name">Cần Thơ Print</div><div class="meta">54 đơn tháng này</div></div>
                <div><div class="bar-bg"><div class="bar-fill" style="width:58%; background:var(--amber);"></div></div></div>
              </div>
            </div>

            <div class="panel">
              <div class="panel-head">
                <h3>Tranh chấp cần xử lý</h3>
                <a href="admin.jsp#disputes">4 tất cả</a>
              </div>
              <div class="dispute-item" onclick="openDisputeModal('#PK-08228','Khách báo lỗi in sai màu — chờ xưởng phản hồi','Khẩn cấp')">
                <div class="top"><span>#PK-08228</span><span class="pill red">Khẩn cấp</span></div>
                <div class="desc">Khách báo lỗi in sai màu — chờ xưởng phản hồi</div>
              </div>
              <div class="dispute-item" onclick="openDisputeModal('#PK-08201','Yêu cầu hoàn tiền một phần do giao trễ','Đang xử lý')">
                <div class="top"><span>#PK-08201</span><span class="pill amber">Đang xử lý</span></div>
                <div class="desc">Yêu cầu hoàn tiền một phần do giao trễ</div>
              </div>
              <div class="dispute-item" onclick="openDisputeModal('#PK-08196','Sản phẩm không đúng chất liệu đã đặt','Đang xử lý')">
                <div class="top"><span>#PK-08196</span><span class="pill amber">Đang xử lý</span></div>
                <div class="desc">Sản phẩm không đúng chất liệu đã đặt</div>
              </div>
              <div class="dispute-item" onclick="openDisputeModal('#PK-08188','Khách khiếu nại đóng gói kém, sản phẩm bị móp','Mới')">
                <div class="top"><span>#PK-08188</span><span class="pill blue">Mới</span></div>
                <div class="desc">Khách khiếu nại đóng gói kém, sản phẩm bị móp</div>
              </div>
            </div>
          </div>
        </div>
      </div>

    </div>
  </div>
</div>

<!-- ================= OVERLAY & MODALS ================= -->
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

    <div class="modal-actions" style="margin-top:18px;">
      <button class="btn" style="flex:1;" onclick="toast('Đã gửi phản hồi cho khách hàng')">Phản hồi khách</button>
      <button class="btn danger" style="flex:1;" onclick="toast('Đã quyết định hoàn tiền cho khách')">Hoàn tiền</button>
    </div>
  </div>
</div>

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
    <div class="list-item">
      <div><div class="name">Thời gian sản xuất TB</div><div class="meta">42 giờ · Nhanh hơn 12% mức chuẩn</div></div>
    </div>
    <div class="list-item">
      <div><div class="name">Tỉ lệ lỗi in</div><div class="meta">1,2% · Thấp hơn mức cho phép</div></div>
    </div>
    <div class="list-item">
      <div><div class="name">Tỉ lệ hủy đơn</div><div class="meta">0,4% · Rất thấp</div></div>
    </div>

    <div class="modal-actions" style="margin-top:18px;">
      <button class="btn" style="flex:1;" onclick="toast('Đã gửi tin nhắn cho xưởng')">Nhắn tin</button>
      <button class="btn primary" style="flex:1;" onclick="toast('Đã mở trang quản lý xưởng')">Quản lý</button>
    </div>
  </div>
</div>

<div class="toast" id="toast">Đã thực hiện</div>

<script>
/* ================= TOAST ================= */
let toastTimer;
function toast(msg){
  const t = document.getElementById('toast');
  t.textContent = msg;
  t.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => t.classList.remove('show'), 2400);
}

/* ================= MODAL ================= */
function openModal(id){
  document.getElementById(id).classList.add('show');
  document.getElementById('overlay').classList.add('show');
}
function closeAll(){
  document.querySelectorAll('.modal, .overlay').forEach(el => el.classList.remove('show'));
}
document.addEventListener('keydown', e => { if(e.key === 'Escape') closeAll(); });

function openDisputeModal(id, desc, status){
  document.getElementById('dmId').textContent = id;
  document.getElementById('dmDesc').textContent = desc;
  document.getElementById('dmStatus').textContent = status;
  const statusEl = document.getElementById('dmStatus');
  statusEl.style.color = status === 'Khẩn cấp' ? 'var(--red)'
    : status === 'Đang xử lý' ? 'var(--amber)'
    : status === 'Mới' ? 'var(--blue)'
    : 'var(--green)';
  openModal('disputeModal');
}

function openSupplierModal(name, region, orders, perf, rating){
  document.getElementById('smName').textContent = name;
  document.getElementById('smRegion').textContent = region + ' · Đối tác từ 2024';
  document.getElementById('smOrders').textContent = orders;
  document.getElementById('smPerf').textContent = perf;
  document.getElementById('smRating').textContent = rating + ' ★';
  openModal('supplierModal');
}

/* ================= TABS ================= */
function pickTab(el){
  el.parentElement.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
  el.classList.add('active');
  toast('Đã lọc: ' + el.textContent.trim());
}

/* ================= DATE ================= */
function updateDate(){
  const d = new Date();
  const days = ['Chủ Nhật','Thứ Hai','Thứ Ba','Thứ Tư','Thứ Năm','Thứ Sáu','Thứ Bảy'];
  const months = ['1','2','3','4','5','6','7','8','9','10','11','12'];
  document.getElementById('pageSub').textContent =
    days[d.getDay()] + ', ' + d.getDate() + ' tháng ' + months[d.getMonth()] + ', ' + d.getFullYear();
}
updateDate();
</script>
</body>
</html>