<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Đơn hàng in 3D — PrintKraft Xưởng</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@600;700&family=Barlow:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
/* ============================================================
   TOKENS — sao chép nguyên vẹn từ hệ thống Xưởng (Sài Gòn Print)
   ============================================================ */
:root{
    --charcoal:#171920;
    --steel:#2C3140;
    --steel-2:#20232C;
    --steel-3:#262A35;
    --orange:#FF8A1F;
    --amber:#FFB020;
    --violet:#8B5CF6;
    --teal:#22D3EE;
    --pink:#F472B6;
    --green:#34D399;
    --red:#FB5A6A;
    --blue:#60A5FA;
    --off:#EDEFF5;
    --muted:#9AA0B0;
    --orange-glow:rgba(255,138,31,.35);
    --grad-hot:linear-gradient(135deg,#FF8A1F,#FFB020);
    --grad-cool:linear-gradient(135deg,#8B5CF6,#22D3EE);
    --grad-money:linear-gradient(135deg,#34D399,#22D3EE);
}
*{box-sizing:border-box; margin:0; padding:0;}
body{
    background:
            radial-gradient(900px 520px at 8% -8%, rgba(255,138,31,.10), transparent 60%),
            radial-gradient(820px 520px at 95% -4%, rgba(139,92,246,.12), transparent 62%),
            radial-gradient(700px 500px at 50% 110%, rgba(34,211,238,.07), transparent 60%),
            var(--charcoal);
    color:var(--off);
    font-family:'Barlow', sans-serif;
    font-size:15px;
    min-height:100vh;
}
h1,h2,h3,.cond{font-family:'Barlow Condensed', sans-serif; letter-spacing:0.01em;}
a{color:inherit; text-decoration:none;}
button{font-family:inherit; cursor:pointer;}
input,select,textarea{font-family:inherit;}
::-webkit-scrollbar{width:9px;height:9px;}
::-webkit-scrollbar-track{background:var(--steel-2);}
::-webkit-scrollbar-thumb{background:#3A4052;border-radius:9px;}
::-webkit-scrollbar-thumb:hover{background:var(--orange);}
:focus-visible{outline:2px solid var(--orange); outline-offset:2px;}

/* ===== Top bar (tái sử dụng nguyên bản) ===== */
.topbar{
    background:linear-gradient(180deg,#262A35,#1D2028);
    padding:14px 28px;
    display:flex; align-items:center; justify-content:space-between;
    position:sticky; top:0; z-index:50; flex-wrap:wrap; gap:12px;
    box-shadow:0 6px 24px rgba(0,0,0,.35);
}
.topbar:after{
    content:""; position:absolute; left:0; right:0; bottom:0; height:3px;
    background:linear-gradient(90deg,var(--orange),var(--amber),var(--pink),var(--violet),var(--teal));
}
.brand{display:flex; align-items:center; gap:12px;}
.brand .mark{
    width:34px; height:34px; border-radius:9px; background:var(--grad-hot);
    clip-path: polygon(50% 0%, 100% 100%, 0% 100%); filter:drop-shadow(0 0 12px var(--orange-glow));
}
.brand h1{font-size:24px; font-weight:700; color:white;}
.brand span{font-size:12.5px; color:var(--muted); display:block; margin-top:-2px;}
.shift-info{display:flex; align-items:center; gap:22px; font-size:13px; color:var(--muted); flex-wrap:wrap;}
.op-avatar{
    width:38px; height:38px; border-radius:50%; background:var(--grad-hot);
    display:flex; align-items:center; justify-content:center; font-weight:700; color:#1A1C22; cursor:pointer; transition:.18s;
}
.op-avatar:hover{transform:scale(1.06); box-shadow:0 0 0 5px var(--orange-glow);}

/* ===== Nav tabs (tái sử dụng — hệ thống không có sidebar) ===== */
.nav-tabs{
    background:linear-gradient(180deg,#1F222B,#1B1E26); border-bottom:1px solid var(--steel);
    padding:0 28px; display:flex; gap:4px; overflow-x:auto;
}
.nav-tabs button{
    background:transparent; border:none; color:var(--muted); padding:14px 18px; font-size:13.5px; font-weight:600;
    border-bottom:3px solid transparent; white-space:nowrap; transition:.18s;
}
.nav-tabs button.active{color:white; border-bottom:3px solid var(--orange); text-shadow:0 0 18px var(--orange-glow);}
.nav-tabs button:hover{color:var(--off);}

.content{padding:26px 28px 90px; max-width:1560px; margin:0 auto;}

/* ===== Page header ===== */
.page-header{display:flex; justify-content:space-between; align-items:flex-start; gap:18px; flex-wrap:wrap; margin-bottom:22px;}
.crumbs{font-size:12px; color:var(--muted); margin-bottom:6px;}
.page-header h2{font-size:28px; color:white; font-weight:700;}
.page-header p{font-size:13.5px; color:var(--muted); margin-top:4px;}

/* ===== Summary stat cards ===== */
.stat-cards{display:grid; grid-template-columns:repeat(5,1fr); gap:14px; margin-bottom:22px;}
.scard{
    background:linear-gradient(180deg,var(--steel-3),var(--steel-2)); border:1px solid var(--steel);
    border-radius:14px; padding:17px 19px; position:relative; overflow:hidden; cursor:pointer; transition:.16s;
}
.scard:before{content:""; position:absolute; left:0; top:0; width:100%; height:2px; background:transparent; transition:.2s;}
.scard:hover{border-color:#3C4358; transform:translateY(-2px);}
.scard:hover:before{background:var(--grad-hot);}
.scard.active{border-color:var(--orange); box-shadow:0 0 0 1px rgba(255,138,31,.25);}
.scard .cond{font-size:14px; color:var(--muted); text-transform:uppercase; letter-spacing:0.05em;}
.scard .val{font-size:32px; font-weight:700; color:white; margin-top:4px;}
.scard .val.orange{color:var(--orange);}
.scard .val.red{color:var(--red);}
.scard .val.green{color:var(--green);}
.scard .val.violet{color:var(--violet);}
.scard .sub{font-size:11.5px; color:var(--muted); margin-top:4px;}

/* ===== Toolbar: search + filter + sort ===== */
.toolbar{
    display:flex; align-items:center; gap:12px; flex-wrap:wrap; margin-bottom:16px;
    background:linear-gradient(180deg,var(--steel-3),var(--steel-2)); border:1px solid var(--steel);
    border-radius:14px; padding:14px 16px;
}
.search-box{
    flex:1; min-width:220px; display:flex; align-items:center; gap:9px;
    background:#181B22; border:1px solid var(--steel); border-radius:10px; padding:0 14px;
}
.search-box input{
    flex:1; background:transparent; border:none; outline:none; color:var(--off);
    padding:11px 0; font-size:13.5px;
}
.search-box .ic{color:var(--muted); font-size:14px;}
.search-box .clear{color:var(--muted); font-size:16px; padding:4px; display:none;}
.search-box .clear.show{display:block;}
.search-box .clear:hover{color:var(--red);}

.tb-btn{
    background:var(--steel-2); border:1px solid var(--steel); color:var(--off);
    padding:11px 16px; border-radius:10px; font-weight:600; font-size:13px; display:flex; align-items:center; gap:7px; transition:.16s; position:relative;
}
.tb-btn:hover{border-color:#3C4358;}
.tb-btn.active{border-color:var(--orange); color:var(--orange);}
.tb-count{background:var(--grad-hot); color:#1A1C22; font-size:10.5px; font-weight:700; padding:1px 7px; border-radius:999px;}

.sort-select{
    background:#181B22; border:1px solid var(--steel); color:var(--off); border-radius:10px;
    padding:11px 14px; font-size:13px; font-weight:500; outline:none; cursor:pointer;
}
.sort-select:focus{border-color:var(--orange);}

/* ===== Status tabs ===== */
.status-tabs{display:flex; gap:8px; flex-wrap:wrap; margin-bottom:16px;}
.status-tabs button{
    background:var(--steel-2); border:1px solid var(--steel); color:var(--muted);
    padding:9px 16px; border-radius:999px; font-weight:600; font-size:13px; transition:.16s; display:flex; align-items:center; gap:7px;
}
.status-tabs button:hover{color:var(--off); border-color:#3C4358;}
.status-tabs button.active{background:var(--grad-hot); color:#1A1C22; border-color:transparent; box-shadow:0 4px 16px var(--orange-glow);}
.status-tabs button .n{background:rgba(255,255,255,.18); padding:1px 8px; border-radius:999px; font-size:11.5px;}
.status-tabs button.active .n{background:rgba(0,0,0,.18);}

/* ===== Active filter chips ===== */
.chip-row{display:flex; gap:8px; flex-wrap:wrap; align-items:center; margin-bottom:16px;}
.chip-row.hidden{display:none;}
.f-chip{
    display:inline-flex; align-items:center; gap:7px; background:rgba(255,138,31,.12); color:var(--orange);
    border:1px solid rgba(255,138,31,.35); padding:6px 8px 6px 13px; border-radius:999px; font-size:12.5px; font-weight:600;
}
.f-chip button{background:none; border:none; color:inherit; font-size:14px; line-height:1; padding:2px;}
.chip-row .clear-all{font-size:12.5px; color:var(--muted); font-weight:600;}
.chip-row .clear-all:hover{color:var(--red);}

/* ===== Filter panel (dropdown) ===== */
.filter-panel{
    position:absolute; top:calc(100% + 8px); right:0; z-index:40; width:340px; max-width:92vw;
    background:linear-gradient(180deg,#262A35,#1E2129); border:1px solid var(--steel); border-radius:14px;
    box-shadow:0 24px 60px rgba(0,0,0,.55); padding:18px; opacity:0; pointer-events:none; transform:translateY(-6px); transition:.16s;
    max-height:70vh; overflow-y:auto;
}
.filter-panel.show{opacity:1; pointer-events:auto; transform:none;}
.filter-panel h4{font-size:12px; text-transform:uppercase; letter-spacing:.06em; color:var(--muted); margin:14px 0 9px;}
.filter-panel h4:first-child{margin-top:0;}
.check-grid{display:grid; grid-template-columns:1fr 1fr; gap:7px;}
.check-item{
    display:flex; align-items:center; gap:8px; font-size:13px; color:var(--off); cursor:pointer;
    background:#181B22; border:1px solid var(--steel); border-radius:8px; padding:8px 10px;
}
.check-item:hover{border-color:var(--orange);}
.check-item input{accent-color:var(--orange); width:14px; height:14px;}
.filter-actions{display:flex; gap:9px; margin-top:16px; padding-top:14px; border-top:1px solid var(--steel);}
.filter-actions button{flex:1; padding:10px; border-radius:9px; font-weight:700; font-size:13px;}

/* ===== Table ===== */
.table-wrap{
    background:linear-gradient(180deg,var(--steel-3),var(--steel-2)); border:1px solid var(--steel);
    border-radius:14px; overflow:hidden;
}
.table-scroll{overflow-x:auto;}
.order-table{width:100%; border-collapse:collapse; font-size:13.5px; min-width:1180px;}
.order-table th{
    text-align:left; padding:13px 14px; color:var(--muted); font-weight:600; font-size:11.5px;
    text-transform:uppercase; letter-spacing:.04em; border-bottom:1px solid var(--steel); white-space:nowrap;
    cursor:pointer; user-select:none;
}
.order-table th:hover{color:var(--off);}
.order-table th .arrow{opacity:.4; font-size:10px; margin-left:3px;}
.order-table th.sorted .arrow{opacity:1; color:var(--orange);}
.order-table td{padding:13px 14px; border-bottom:1px solid #232734; vertical-align:middle;}
.order-table tr:last-child td{border-bottom:none;}
.order-table tbody tr{transition:.14s; cursor:pointer;}
.order-table tbody tr:hover{background:rgba(255,138,31,.05);}

.model-cell{display:flex; align-items:center; gap:11px;}
.model-thumb{
    width:44px; height:44px; border-radius:9px; background:var(--grad-cool); flex-shrink:0;
    display:flex; align-items:center; justify-content:center; font-size:10.5px; font-weight:700; color:white; letter-spacing:.02em; text-align:center;
}
.model-cell .mn{font-weight:600; color:white; font-size:13.5px;}
.model-cell .mn span{display:block; font-weight:400; color:var(--muted); font-size:11.5px; margin-top:1px;}

.order-id-cell{display:flex; align-items:center; gap:7px;}
.order-id-cell a{color:white; font-family:'Barlow Condensed'; font-weight:700; font-size:14.5px;}
.order-id-cell a:hover{color:var(--orange);}
.priority-dot{width:8px; height:8px; border-radius:50%; flex-shrink:0;}
.priority-dot.NORMAL{background:var(--steel); outline:1.5px solid #3C4358;}
.priority-dot.PRIORITY{background:var(--violet); box-shadow:0 0 8px rgba(139,92,246,.5);}
.priority-dot.URGENT{background:var(--red); box-shadow:0 0 8px rgba(251,90,106,.6);}
.warn-ic{font-size:12.5px; cursor:help; position:relative;}
.warn-ic:hover:after{
    content:attr(data-tip); position:absolute; bottom:135%; left:50%; transform:translateX(-50%);
    background:#0D0E12; color:var(--off); font-size:11.5px; font-weight:400; line-height:1.4;
    padding:8px 11px; border-radius:8px; width:190px; white-space:normal; text-align:left;
    box-shadow:0 10px 26px rgba(0,0,0,.5); z-index:20; border:1px solid var(--steel);
}

.cust-cell strong{display:block; font-size:13.5px; color:var(--off); font-weight:600;}
.cust-cell span{font-size:11.5px; color:var(--muted);}

.tbadge{font-size:11px; font-weight:700; padding:4px 10px; border-radius:999px; white-space:nowrap; display:inline-block;}
.tbadge.fdm{background:rgba(255,138,31,.16); color:var(--orange);}
.tbadge.resin{background:rgba(139,92,246,.16); color:#B79BFF;}
.tbadge.powder{background:rgba(34,211,238,.16); color:var(--teal);}

.mat-cell{font-size:13px; color:var(--off);}
.mat-cell .more{color:var(--muted); font-size:11.5px; cursor:help;}

.dl-cell strong{display:block; font-size:13px; color:var(--off); font-weight:600;}
.dl-tag{display:inline-flex; align-items:center; gap:5px; font-size:11.5px; font-weight:700; padding:3px 9px; border-radius:999px; margin-top:3px;}
.dl-tag.overdue{background:rgba(251,90,106,.16); color:var(--red);}
.dl-tag.soon{background:rgba(255,138,31,.16); color:var(--orange);}
.dl-tag.today{background:rgba(255,176,32,.16); color:var(--amber);}
.dl-tag.ok{background:rgba(52,211,153,.16); color:var(--green);}
.dl-tag.none{background:rgba(154,160,176,.14); color:var(--muted);}

.value-cell{font-family:'Barlow Condensed'; font-weight:700; font-size:15.5px; color:white;}

.sbadge{font-size:11px; font-weight:700; padding:5px 11px; border-radius:999px; white-space:nowrap; display:inline-block;}
.sbadge.PENDING_CONFIRMATION{background:rgba(255,138,31,.16); color:var(--orange);}
.sbadge.CONFIRMED{background:rgba(96,165,250,.16); color:var(--blue);}
.sbadge.PREPARING{background:rgba(139,92,246,.16); color:#B79BFF;}
.sbadge.PRINTING{background:rgba(255,176,32,.16); color:var(--amber);}
.sbadge.POST_PROCESSING{background:rgba(244,114,182,.16); color:var(--pink);}
.sbadge.QC{background:rgba(34,211,238,.16); color:var(--teal);}
.sbadge.PACKAGING{background:rgba(154,160,176,.16); color:var(--off);}
.sbadge.SHIPPING{background:rgba(96,165,250,.16); color:var(--blue);}
.sbadge.COMPLETED{background:rgba(52,211,153,.16); color:var(--green);}
.sbadge.CANCELLED{background:rgba(251,90,106,.12); color:var(--red);}

.date-cell{font-size:12.5px; color:var(--off); cursor:help;}
.date-cell span{display:block; color:var(--muted); font-size:11px;}

.act-cell{display:flex; gap:8px; align-items:center; justify-content:flex-end;}
.act-cell .btn-view{
    background:var(--steel-2); border:1px solid var(--steel); color:var(--off);
    padding:8px 14px; border-radius:8px; font-size:12.5px; font-weight:600; white-space:nowrap; transition:.16s;
}
.act-cell .btn-view:hover{border-color:var(--orange); color:var(--orange);}
.act-cell .btn-review{background:var(--grad-hot); color:#1A1C22; border:none; padding:8px 14px; border-radius:8px; font-size:12.5px; font-weight:700; white-space:nowrap;}
.act-cell .btn-review:hover{filter:brightness(1.08);}
.menu-wrap{position:relative;}
.menu-dots{background:transparent; border:1px solid var(--steel); color:var(--muted); width:32px; height:32px; border-radius:8px; font-size:15px;}
.menu-dots:hover{border-color:var(--orange); color:var(--orange);}
.dd-menu{
    position:absolute; right:0; top:calc(100% + 6px); background:#1E2129; border:1px solid var(--steel);
    border-radius:10px; padding:6px; min-width:170px; box-shadow:0 16px 40px rgba(0,0,0,.5); z-index:30;
    opacity:0; pointer-events:none; transform:translateY(-4px); transition:.14s;
}
.dd-menu.show{opacity:1; pointer-events:auto; transform:none;}
.dd-menu button{
    display:block; width:100%; text-align:left; background:none; border:none; color:var(--off);
    padding:9px 11px; border-radius:7px; font-size:13px;
}
.dd-menu button:hover{background:var(--steel-2); color:var(--orange);}

/* ===== Empty / no-result states ===== */
.empty-state{padding:64px 20px; text-align:center;}
.empty-state .ic{font-size:40px; margin-bottom:14px;}
.empty-state h3{font-size:19px; color:white; margin-bottom:8px;}
.empty-state p{font-size:13.5px; color:var(--muted); margin-bottom:18px; max-width:44ch; margin-left:auto; margin-right:auto;}
.empty-state button{background:var(--grad-hot); color:#1A1C22; padding:11px 20px; border-radius:9px; font-weight:700; font-size:13.5px; border:none;}

/* ===== Mobile order cards ===== */
.mobile-cards{display:none; flex-direction:column; gap:12px;}
.m-card{
    background:linear-gradient(180deg,#1D2029,#191C24); border:1px solid var(--steel); border-radius:13px; padding:15px; transition:.16s;
}
.m-card:active{border-color:var(--orange);}
.m-card-top{display:flex; justify-content:space-between; align-items:center; margin-bottom:10px; gap:8px;}
.m-card-top .oid{font-family:'Barlow Condensed'; font-weight:700; color:white; font-size:16px; display:flex; align-items:center; gap:7px;}
.m-card-model{display:flex; align-items:center; gap:10px; margin-bottom:12px;}
.m-card-model .mn strong{display:block; font-size:14px; color:white;}
.m-card-model .mn span{font-size:12px; color:var(--muted);}
.m-card-grid{display:grid; grid-template-columns:1fr 1fr; gap:8px; margin-bottom:12px; font-size:12.5px;}
.m-card-grid .g-lbl{color:var(--muted); font-size:11px; text-transform:uppercase; letter-spacing:.04em;}
.m-card-grid .g-val{color:var(--off); font-weight:600; margin-top:2px;}
.m-card-foot{display:flex; justify-content:space-between; align-items:center; gap:10px; margin-bottom:12px;}
.m-card-foot .val{font-family:'Barlow Condensed'; font-weight:700; font-size:16px; color:white;}
.m-card button{width:100%;}

/* ===== Pagination ===== */
.pagination-bar{
    display:flex; justify-content:space-between; align-items:center; gap:14px; flex-wrap:wrap;
    padding:16px 4px 4px;
}
.pg-info{font-size:12.5px; color:var(--muted);}
.pg-info select{
    background:#181B22; border:1px solid var(--steel); color:var(--off); border-radius:7px; padding:5px 9px; font-size:12.5px; margin:0 4px;
}
.pg-nav{display:flex; gap:6px; align-items:center;}
.pg-nav button{
    min-width:34px; height:34px; padding:0 10px; border-radius:8px; background:var(--steel-2); border:1px solid var(--steel);
    color:var(--off); font-size:13px; font-weight:600;
}
.pg-nav button:hover:not(:disabled){border-color:var(--orange); color:var(--orange);}
.pg-nav button.active{background:var(--grad-hot); color:#1A1C22; border-color:transparent;}
.pg-nav button:disabled{opacity:.35; cursor:not-allowed;}
.pg-nav .dots{color:var(--muted); padding:0 4px;}

/* ===== Toast (tái sử dụng) ===== */
.toast{
    position:fixed; bottom:26px; left:50%; transform:translate(-50%,90px);
    background:var(--grad-hot); color:#1A1C22; padding:13px 24px; border-radius:11px;
    font-size:14px; font-weight:700; z-index:200; transition:.25s; opacity:0;
    box-shadow:0 12px 34px rgba(255,138,31,.4); max-width:90vw; text-align:center;
}
.toast.show{transform:translate(-50%,0); opacity:1;}

/* ===== Responsive ===== */
@media (max-width:1200px){
    .stat-cards{grid-template-columns:repeat(3,1fr);}
}
@media (max-width:980px){
    .table-wrap{display:none;}
    .mobile-cards{display:flex;}
    .stat-cards{grid-template-columns:repeat(2,1fr);}
    .content{padding:20px 16px 90px;}
    .topbar, .nav-tabs{padding-left:16px; padding-right:16px;}
    .toolbar{flex-direction:column; align-items:stretch;}
    .toolbar .tb-btn, .toolbar .sort-select{width:100%; justify-content:center;}
    .filter-panel{position:fixed; top:auto; bottom:0; left:0; right:0; width:100%; max-width:100%; border-radius:16px 16px 0 0; max-height:80vh;}
}
@media (max-width:640px){
    .stat-cards{grid-template-columns:1fr 1fr;}
    .page-header h2{font-size:24px;}
    .check-grid{grid-template-columns:1fr;}
}
</style>
</head>
<body>

<!-- ============ TOPBAR (tái sử dụng nguyên bản) ============ -->
<div class="topbar">
    <div class="brand">
        <span class="mark"></span>
        <div><h1>Sài Gòn Print</h1><span>Cổng xưởng sản xuất · PrintKraft</span></div>
    </div>
    <div class="shift-info">
        <div>Thứ Bảy, 26/09/2026 — <span id="clock">19:20</span></div>
        <div class="op-avatar" title="Đặng Long">ĐL</div>
    </div>
</div>

<!-- ============ NAV TABS (tái sử dụng nguyên bản) ============ -->
<div class="nav-tabs">
    <button onclick="location.hash='board'">Bảng sản xuất</button>
    <button class="active">📋 Đơn hàng in 3D</button>
    <button>Máy móc</button>
    <button>Vật tư</button>
    <button>Kiểm tra chất lượng</button>
    <button>Lịch ca</button>
    <button>💰 Doanh thu</button>
    <button>🎧 Hỗ trợ &amp; Đổi trả</button>
</div>

<div class="content">

    <!-- ============ PAGE HEADER ============ -->
    <div class="page-header">
        <div>
            <div class="crumbs">Trang chủ &nbsp;/&nbsp; Đơn hàng</div>
            <h2>Đơn hàng in 3D</h2>
            <p>Quản lý và xử lý các đơn hàng in 3D từ khách hàng.</p>
        </div>
    </div>

    <!-- ============ SUMMARY STATS ============ -->
    <div class="stat-cards" id="statCards"></div>

    <!-- ============ TOOLBAR: SEARCH + FILTER + SORT ============ -->
    <div class="toolbar">
        <div class="search-box">
            <span class="ic">🔍</span>
            <input type="text" id="searchInput" placeholder="Tìm theo mã đơn, tên khách, tên model, tên file, SĐT...">
            <button class="clear" id="searchClear">✕</button>
        </div>
        <div style="position:relative;">
            <button class="tb-btn" id="filterBtn">🔧 Lọc <span class="tb-count" id="filterCount" style="display:none;">0</span></button>
            <div class="filter-panel" id="filterPanel">
                <h4>Công nghệ</h4>
                <div class="check-grid" id="fTech"></div>
                <h4>Vật liệu</h4>
                <div class="check-grid" id="fMaterial"></div>
                <h4>Deadline</h4>
                <div class="check-grid" id="fDeadline" style="grid-template-columns:1fr;"></div>
                <h4>Mức độ ưu tiên</h4>
                <div class="check-grid" id="fPriority" style="grid-template-columns:1fr;"></div>
                <div class="filter-actions">
                    <button class="tb-btn" id="filterReset" style="flex:1; justify-content:center;">Đặt lại</button>
                    <button id="filterApply" style="flex:1; background:var(--grad-hot); color:#1A1C22; border:none; font-weight:700;">Áp dụng bộ lọc</button>
                </div>
            </div>
        </div>
        <select class="sort-select" id="sortSelect">
            <option value="deadline_asc">Deadline gần nhất</option>
            <option value="deadline_desc">Deadline xa nhất</option>
            <option value="newest">Mới nhất</option>
            <option value="oldest">Cũ nhất</option>
            <option value="value_desc">Giá trị cao → thấp</option>
            <option value="value_asc">Giá trị thấp → cao</option>
            <option value="customer_az">Tên khách hàng A → Z</option>
        </select>
    </div>

    <!-- ============ STATUS TABS ============ -->
    <div class="status-tabs" id="statusTabs"></div>

    <!-- ============ ACTIVE FILTER CHIPS ============ -->
    <div class="chip-row hidden" id="chipRow"></div>

    <!-- ============ DESKTOP TABLE ============ -->
    <div class="table-wrap" id="tableWrap">
        <div class="table-scroll">
            <table class="order-table">
                <thead>
                    <tr>
                        <th data-sort="model">Model</th>
                        <th data-sort="id">Mã đơn</th>
                        <th data-sort="customer">Khách hàng</th>
                        <th>Số lượng</th>
                        <th>Công nghệ</th>
                        <th>Vật liệu</th>
                        <th data-sort="deadline">Deadline <span class="arrow">▾</span></th>
                        <th data-sort="value">Giá trị</th>
                        <th>Trạng thái</th>
                        <th data-sort="created">Ngày đặt</th>
                        <th style="text-align:right;">Thao tác</th>
                    </tr>
                </thead>
                <tbody id="tableBody"></tbody>
            </table>
        </div>
        <div class="empty-state" id="emptyState" style="display:none;"></div>
    </div>

    <!-- ============ MOBILE CARDS ============ -->
    <div class="mobile-cards" id="mobileCards"></div>
    <div class="empty-state" id="emptyStateMobile" style="display:none;"></div>

    <!-- ============ PAGINATION ============ -->
    <div class="pagination-bar" id="paginationBar"></div>

</div>

<div class="toast" id="toast"></div>

<script>
/* ============================================================
   1. MOCK DATA — thay bằng API sau này (giữ đúng cấu trúc order{})
   ============================================================ */
const STATUS_LABELS = {
    PENDING_CONFIRMATION:'Chờ duyệt', CONFIRMED:'Đã xác nhận', PREPARING:'Chuẩn bị sản xuất',
    PRINTING:'Đang in', POST_PROCESSING:'Hậu xử lý', QC:'QC', PACKAGING:'Đóng gói',
    SHIPPING:'Đang giao', COMPLETED:'Hoàn thành', CANCELLED:'Đã hủy'
};
const TECH_GROUP = {FDM:'fdm', SLA:'resin', MSLA:'resin', DLP:'resin', SLS:'powder', MJF:'powder'};
const WARNING_LABELS = {
    DEADLINE_NEAR:{ic:'⚠', tip:'Deadline khách yêu cầu rất gần, cần ưu tiên xử lý.'},
    MATERIAL_LOW:{ic:'📦', tip:'Vật liệu yêu cầu đang sắp hết trong kho.'},
    OVERSIZED:{ic:'📐', tip:'Model có thể vượt build volume của máy hiện tại.'},
    NEEDS_CONFIRMATION:{ic:'❓', tip:'Cần khách xác nhận lại cấu hình trước khi sản xuất.'},
    PAYMENT_PENDING:{ic:'💳', tip:'Đơn đang chờ khách hoàn tất thanh toán.'}
};

function mkOrder(o){ return o; }
const ORDERS = [
    mkOrder({id:'3DP-20260926-00125', customer:{name:'Nguyễn Văn A', phone:'0912345671'}, model:{name:'Dragon.stl', count:1}, quantity:10, technology:'FDM', materials:['PLA'], deadline:'2026-09-27T10:00:00', total:350000, status:'PENDING_CONFIRMATION', priority:'PRIORITY', createdAt:'2026-09-26T18:32:00', warnings:['DEADLINE_NEAR']}),
    mkOrder({id:'3DP-20260926-00126', customer:{name:'Trần Thị B', phone:'0912345672'}, model:{name:'Vase_v2.obj', count:1}, quantity:4, technology:'SLA', materials:['Standard Resin'], deadline:'2026-09-26T20:00:00', total:520000, status:'PENDING_CONFIRMATION', priority:'URGENT', createdAt:'2026-09-26T17:50:00', warnings:['DEADLINE_NEAR','NEEDS_CONFIRMATION']}),
    mkOrder({id:'3DP-20260926-00124', customer:{name:'Lê Minh C', phone:'0912345673'}, model:{name:'Bracket_v3.stl', count:1}, quantity:20, technology:'FDM', materials:['PETG'], deadline:'2026-10-02T00:00:00', total:890000, status:'PENDING_CONFIRMATION', priority:'NORMAL', createdAt:'2026-09-26T16:10:00', warnings:[]}),
    mkOrder({id:'3DP-20260925-00118', customer:{name:'Phạm Gia Hân', phone:'0912345674'}, model:{name:'Helmet_prop.stl', count:1}, quantity:1, technology:'SLA', materials:['Tough Resin'], deadline:'2026-09-25T18:00:00', total:610000, status:'PENDING_CONFIRMATION', priority:'URGENT', createdAt:'2026-09-25T09:20:00', warnings:['OVERSIZED']}),
    mkOrder({id:'3DP-20260925-00117', customer:{name:'Đỗ Anh Khoa', phone:'0912345675'}, model:{name:'Gear_set.3mf', count:3}, quantity:15, technology:'FDM', materials:['ABS','Nylon'], deadline:'2026-09-29T00:00:00', total:1240000, status:'CONFIRMED', priority:'NORMAL', createdAt:'2026-09-25T08:40:00', warnings:[]}),
    mkOrder({id:'3DP-20260924-00112', customer:{name:'Vũ Thu Trang', phone:'0912345676'}, model:{name:'Figurine.stl', count:1}, quantity:2, technology:'MSLA', materials:['ABS-like Resin'], deadline:'2026-09-28T00:00:00', total:280000, status:'CONFIRMED', priority:'NORMAL', createdAt:'2026-09-24T14:05:00', warnings:['MATERIAL_LOW']}),
    mkOrder({id:'3DP-20260924-00110', customer:{name:'Ngô Bảo Long', phone:'0912345677'}, model:{name:'Drone_arm.stl', count:1}, quantity:8, technology:'FDM', materials:['PA12'], deadline:'2026-09-30T00:00:00', total:960000, status:'PREPARING', priority:'PRIORITY', createdAt:'2026-09-24T11:15:00', warnings:[]}),
    mkOrder({id:'3DP-20260923-00105', customer:{name:'Hoàng Yến Nhi', phone:'0912345678'}, model:{name:'Lamp_shade.stl', count:1}, quantity:5, technology:'FDM', materials:['PLA+'], deadline:'2026-09-27T00:00:00', total:410000, status:'PRINTING', priority:'NORMAL', createdAt:'2026-09-23T09:30:00', warnings:[]}),
    mkOrder({id:'3DP-20260923-00104', customer:{name:'Bùi Quốc Huy', phone:'0912345679'}, model:{name:'Chess_set.stl', count:1}, quantity:32, technology:'SLA', materials:['Standard Resin'], deadline:'2026-09-29T00:00:00', total:2150000, status:'PRINTING', priority:'PRIORITY', createdAt:'2026-09-23T08:00:00', warnings:['PAYMENT_PENDING']}),
    mkOrder({id:'3DP-20260922-00098', customer:{name:'Đặng Mỹ Linh', phone:'0912345680'}, model:{name:'Cosplay_visor.stl', count:1}, quantity:1, technology:'DLP', materials:['Engineering Resin'], deadline:'2026-09-26T00:00:00', total:475000, status:'POST_PROCESSING', priority:'NORMAL', createdAt:'2026-09-22T15:20:00', warnings:[]}),
    mkOrder({id:'3DP-20260922-00095', customer:{name:'Trịnh Văn Nam', phone:'0912345681'}, model:{name:'Robot_arm_kit.stl', count:6}, quantity:24, technology:'MJF', materials:['PA12'], deadline:'2026-10-05T00:00:00', total:3200000, status:'POST_PROCESSING', priority:'NORMAL', createdAt:'2026-09-22T10:00:00', warnings:[]}),
    mkOrder({id:'3DP-20260921-00090', customer:{name:'Lý Cẩm Tú', phone:'0912345682'}, model:{name:'Jewelry_ring.stl', count:1}, quantity:3, technology:'DLP', materials:['Standard Resin'], deadline:'2026-09-25T00:00:00', total:195000, status:'QC', priority:'NORMAL', createdAt:'2026-09-21T13:45:00', warnings:[]}),
    mkOrder({id:'3DP-20260921-00088', customer:{name:'Phan Đức Anh', phone:'0912345683'}, model:{name:'Phone_stand.stl', count:1}, quantity:12, technology:'FDM', materials:['PETG'], deadline:'2026-09-26T00:00:00', total:320000, status:'QC', priority:'PRIORITY', createdAt:'2026-09-21T09:10:00', warnings:[]}),
    mkOrder({id:'3DP-20260920-00082', customer:{name:'Đinh Thảo Vy', phone:'0912345684'}, model:{name:'Planter_pot.stl', count:1}, quantity:6, technology:'FDM', materials:['ASA'], deadline:'2026-09-24T00:00:00', total:270000, status:'PACKAGING', priority:'NORMAL', createdAt:'2026-09-20T16:30:00', warnings:[]}),
    mkOrder({id:'3DP-20260919-00075', customer:{name:'Mai Xuân Sơn', phone:'0912345685'}, model:{name:'Cable_clip.stl', count:1}, quantity:50, technology:'FDM', materials:['TPU'], deadline:'2026-09-23T00:00:00', total:180000, status:'SHIPPING', priority:'NORMAL', createdAt:'2026-09-19T08:15:00', warnings:[]}),
    mkOrder({id:'3DP-20260918-00060', customer:{name:'Châu Bích Ngọc', phone:'0912345686'}, model:{name:'Toy_car.stl', count:1}, quantity:2, technology:'FDM', materials:['PLA'], deadline:'2026-09-20T00:00:00', total:150000, status:'COMPLETED', priority:'NORMAL', createdAt:'2026-09-18T10:00:00', warnings:[]}),
    mkOrder({id:'3DP-20260917-00055', customer:{name:'Hồ Gia Bảo', phone:'0912345687'}, model:{name:'Keychain_batch.stl', count:1}, quantity:100, technology:'MJF', materials:['PA11'], deadline:'2026-09-21T00:00:00', total:2800000, status:'COMPLETED', priority:'NORMAL', createdAt:'2026-09-17T09:00:00', warnings:[]}),
    mkOrder({id:'3DP-20260916-00048', customer:{name:'Tăng Kim Chi', phone:'0912345688'}, model:{name:'Art_sculpture.stl', count:1}, quantity:1, technology:'SLA', materials:['Flexible Resin'], deadline:'2026-09-19T00:00:00', total:680000, status:'COMPLETED', priority:'NORMAL', createdAt:'2026-09-16T14:20:00', warnings:[]}),
    mkOrder({id:'3DP-20260915-00040', customer:{name:'Vương Đình Phúc', phone:'0912345689'}, model:{name:'Prototype_housing.stl', count:1}, quantity:3, technology:'FDM', materials:['PC'], deadline:'2026-09-18T00:00:00', total:540000, status:'CANCELLED', priority:'NORMAL', createdAt:'2026-09-15T11:00:00', warnings:[]}),
    mkOrder({id:'3DP-20260914-00035', customer:{name:'Lâm Ánh Dương', phone:'0912345690'}, model:{name:'Medical_model.stl', count:1}, quantity:1, technology:'SLS', materials:['PA12'], deadline:'2026-09-16T00:00:00', total:1150000, status:'CANCELLED', priority:'URGENT', createdAt:'2026-09-14T15:40:00', warnings:[]})
];

const STATUS_TABS = [
    {id:'ALL', label:'Tất cả'},
    {id:'PENDING_CONFIRMATION', label:'Chờ duyệt'},
    {id:'CONFIRMED', label:'Đã xác nhận'},
    {id:'PREPARING', label:'Chuẩn bị SX'},
    {id:'PRINTING', label:'Đang in'},
    {id:'POST_PROCESSING', label:'Hậu xử lý'},
    {id:'QC', label:'QC'},
    {id:'PACKAGING', label:'Đóng gói'},
    {id:'SHIPPING', label:'Đang giao'},
    {id:'COMPLETED', label:'Hoàn thành'},
    {id:'CANCELLED', label:'Đã hủy'}
];
const TECH_OPTIONS = ['FDM','SLA','MSLA','DLP','SLS','MJF'];
const MATERIAL_OPTIONS = ['PLA','PLA+','PETG','ABS','ASA','TPU','Nylon','PC','Resin','PA12','PA11'];
const DEADLINE_OPTIONS = [
    {id:'overdue', label:'Quá hạn'}, {id:'today', label:'Hôm nay'}, {id:'24h', label:'Trong 24 giờ'},
    {id:'3d', label:'Trong 3 ngày'}, {id:'none', label:'Không có deadline'}
];
const PRIORITY_OPTIONS = [
    {id:'NORMAL', label:'Thường'}, {id:'PRIORITY', label:'Ưu tiên'}, {id:'URGENT', label:'Gấp'}
];

/* ============================================================
   2. TRẠNG THÁI ỨNG DỤNG
   ============================================================ */
const state = {
    search:'', statusTab:'ALL', sort:'deadline_asc', page:1, pageSize:20,
    filters:{technology:[], material:[], deadline:[], priority:[]}
};

const $ = id => document.getElementById(id);
const now = () => new Date('2026-09-26T19:20:00');

function toast(msg){
    const t = $('toast'); t.textContent = msg; t.className = 'toast show';
    clearTimeout(t._t); t._t = setTimeout(() => t.className = 'toast', 2600);
}
function money(n){ return n.toLocaleString('vi-VN') + 'đ'; }
function fmtDate(iso){
    const d = new Date(iso);
    return d.toLocaleDateString('vi-VN') ;
}
function fmtDateTime(iso){
    const d = new Date(iso);
    return d.toLocaleDateString('vi-VN') + ' ' + d.toLocaleTimeString('vi-VN', {hour:'2-digit', minute:'2-digit'});
}

/* ============================================================
   3. DEADLINE LOGIC
   ============================================================ */
function deadlineInfo(iso){
    const diffMs = new Date(iso) - now();
    const diffH = diffMs / 36e5;
    if(diffMs < 0) return {cls:'overdue', text:'🔴 Quá hạn'};
    if(diffH <= 6 && new Date(iso).toDateString() === now().toDateString()) return {cls:'today', text:'⚠ Hôm nay'};
    if(diffH <= 24) return {cls:'soon', text:'🟠 Còn ' + Math.max(1, Math.round(diffH)) + ' giờ'};
    const days = Math.ceil(diffH / 24);
    return {cls:'ok', text:'🟢 Còn ' + days + ' ngày'};
}
function deadlineBucket(o){
    const diffMs = new Date(o.deadline) - now();
    if(diffMs < 0) return 'overdue';
    if(new Date(o.deadline).toDateString() === now().toDateString()) return 'today';
    if(diffMs / 36e5 <= 24) return '24h';
    if(diffMs / 36e5 <= 72) return '3d';
    return 'far';
}

/* ============================================================
   4. RENDER: STAT CARDS
   ============================================================ */
function computeStats(){
    const total = ORDERS.length;
    const pending = ORDERS.filter(o => o.status === 'PENDING_CONFIRMATION').length;
    const inProd = ORDERS.filter(o => ['PREPARING','PRINTING','POST_PROCESSING','QC','PACKAGING'].includes(o.status)).length;
    const dueSoon = ORDERS.filter(o => { const b = deadlineBucket(o); return (b === '24h' || b === 'today') && !['COMPLETED','CANCELLED'].includes(o.status); }).length;
    const done = ORDERS.filter(o => o.status === 'COMPLETED').length;
    return [
        {key:'ALL', label:'Tổng đơn hàng', val:total, sub:'Tất cả đơn hàng', cls:''},
        {key:'PENDING_CONFIRMATION', label:'Chờ duyệt', val:pending, sub:'Cần xử lý', cls:'orange'},
        {key:'INPROD', label:'Đang sản xuất', val:inProd, sub:'Đang được xưởng xử lý', cls:'violet'},
        {key:'DUESOON', label:'Sắp đến hạn', val:dueSoon, sub:'Trong 24 giờ', cls:'red'},
        {key:'COMPLETED', label:'Hoàn thành', val:done, sub:'Đã hoàn tất', cls:'green'}
    ];
}
function renderStats(){
    $('statCards').innerHTML = computeStats().map(s => `
        <div class="scard ${state._statFilter === s.key ? 'active' : ''}" data-stat="${s.key}">
            <div class="cond">${s.label}</div>
            <div class="val ${s.cls}">${s.val}</div>
            <div class="sub">${s.sub}</div>
        </div>`).join('');
    $('statCards').querySelectorAll('[data-stat]').forEach(el => {
        el.onclick = () => {
            const key = el.dataset.stat;
            state._statFilter = state._statFilter === key ? null : key;
            if(key === 'ALL' || !state._statFilter){ state.statusTab = 'ALL'; }
            else if(key === 'INPROD'){ state.statusTab = 'ALL'; state._inProdOnly = state._statFilter === 'INPROD'; }
            else if(key === 'DUESOON'){ state.statusTab = 'ALL'; state._dueSoonOnly = state._statFilter === 'DUESOON'; }
            else { state.statusTab = key; }
            if(state._statFilter !== 'INPROD') state._inProdOnly = false;
            if(state._statFilter !== 'DUESOON') state._dueSoonOnly = false;
            state.page = 1;
            renderStats(); renderStatusTabs(); applyAndRender();
        };
    });
}

/* ============================================================
   5. RENDER: STATUS TABS
   ============================================================ */
function renderStatusTabs(){
    $('statusTabs').innerHTML = STATUS_TABS.map(t => {
        const count = t.id === 'ALL' ? ORDERS.length : ORDERS.filter(o => o.status === t.id).length;
        return `<button class="${state.statusTab === t.id ? 'active' : ''}" data-tab="${t.id}">${t.label} <span class="n">${count}</span></button>`;
    }).join('');
    $('statusTabs').querySelectorAll('[data-tab]').forEach(b => {
        b.onclick = () => {
            state.statusTab = b.dataset.tab; state.page = 1;
            state._statFilter = b.dataset.tab === 'ALL' ? null : b.dataset.tab;
            state._inProdOnly = false; state._dueSoonOnly = false;
            renderStats(); renderStatusTabs(); applyAndRender();
        };
    });
}

/* ============================================================
   6. FILTER PANEL
   ============================================================ */
function techGroupClass(tech){ return TECH_GROUP[tech] || 'fdm'; }
function renderFilterOptions(){
    $('fTech').innerHTML = TECH_OPTIONS.map(t => checkItem('technology', t, t)).join('');
    $('fMaterial').innerHTML = MATERIAL_OPTIONS.map(m => checkItem('material', m, m)).join('');
    $('fDeadline').innerHTML = DEADLINE_OPTIONS.map(d => checkItem('deadline', d.id, d.label)).join('');
    $('fPriority').innerHTML = PRIORITY_OPTIONS.map(p => checkItem('priority', p.id, p.label)).join('');
}
function checkItem(group, value, label){
    return `<label class="check-item"><input type="checkbox" data-group="${group}" value="${value}"> ${label}</label>`;
}
function toggleFilterPanel(force){
    const panel = $('filterPanel');
    const show = force !== undefined ? force : !panel.classList.contains('show');
    panel.classList.toggle('show', show);
    $('filterBtn').classList.toggle('active', show);
}
$('filterBtn').onclick = e => { e.stopPropagation(); toggleFilterPanel(); };
document.addEventListener('click', e => { if(!e.target.closest('#filterPanel') && !e.target.closest('#filterBtn')) toggleFilterPanel(false); });

$('filterApply').onclick = () => {
    const f = {technology:[], material:[], deadline:[], priority:[]};
    document.querySelectorAll('#filterPanel input[type=checkbox]:checked').forEach(cb => f[cb.dataset.group].push(cb.value));
    state.filters = f; state.page = 1;
    toggleFilterPanel(false);
    renderChips(); applyAndRender();
};
$('filterReset').onclick = () => {
    document.querySelectorAll('#filterPanel input[type=checkbox]').forEach(cb => cb.checked = false);
    state.filters = {technology:[], material:[], deadline:[], priority:[]}; state.page = 1;
    renderChips(); applyAndRender();
};

/* ============================================================
   7. ACTIVE FILTER CHIPS
   ============================================================ */
function renderChips(){
    const chips = [];
    Object.entries(state.filters).forEach(([group, vals]) => vals.forEach(v => chips.push({group, v})));
    const count = chips.length;
    $('filterCount').style.display = count ? 'inline-block' : 'none';
    $('filterCount').textContent = count;
    if(!count){ $('chipRow').classList.add('hidden'); $('chipRow').innerHTML = ''; return; }
    $('chipRow').classList.remove('hidden');
    $('chipRow').innerHTML = chips.map(c => `<span class="f-chip" data-g="${c.group}" data-v="${c.v}">${chipLabel(c)}<button>✕</button></span>`).join('')
        + `<span class="clear-all" id="clearAllChips">Xóa tất cả</span>`;
    $('chipRow').querySelectorAll('.f-chip button').forEach(btn => {
        btn.onclick = () => {
            const chip = btn.parentElement;
            const g = chip.dataset.g, v = chip.dataset.v;
            state.filters[g] = state.filters[g].filter(x => x !== v);
            document.querySelectorAll(`#filterPanel input[data-group="${g}"][value="${CSS.escape(v)}"]`).forEach(cb => cb.checked = false);
            renderChips(); applyAndRender();
        };
    });
    const clearAll = $('clearAllChips');
    if(clearAll) clearAll.onclick = () => $('filterReset').click();
}
function chipLabel(c){
    if(c.group === 'deadline') return DEADLINE_OPTIONS.find(d => d.id === c.v).label;
    if(c.group === 'priority') return PRIORITY_OPTIONS.find(p => p.id === c.v).label;
    return c.v;
}

/* ============================================================
   8. SEARCH
   ============================================================ */
$('searchInput').oninput = e => {
    state.search = e.target.value.trim().toLowerCase(); state.page = 1;
    $('searchClear').classList.toggle('show', !!state.search);
    applyAndRender();
};
$('searchClear').onclick = () => { $('searchInput').value = ''; state.search = ''; $('searchClear').classList.remove('show'); applyAndRender(); };

/* ============================================================
   9. SORT
   ============================================================ */
$('sortSelect').onchange = e => { state.sort = e.target.value; state.page = 1; applyAndRender(); };

/* ============================================================
   10. TABLE HEADER SORT
   ============================================================ */
const HEADER_SORT_MAP = {
    id:{asc:'id_asc', desc:'id_desc'}, customer:{asc:'customer_az', desc:'customer_za'},
    deadline:{asc:'deadline_asc', desc:'deadline_desc'}, value:{asc:'value_asc', desc:'value_desc'},
    created:{asc:'oldest', desc:'newest'}
};
document.querySelectorAll('.order-table th[data-sort]').forEach(th => {
    th.addEventListener('click', () => {
        const key = th.dataset.sort;
        const map = HEADER_SORT_MAP[key]; if(!map) return;
        state.sort = state.sort === map.asc ? map.desc : map.asc;
        $('sortSelect').value = ['deadline_asc','deadline_desc','newest','oldest','value_desc','value_asc','customer_az'].includes(state.sort) ? state.sort : $('sortSelect').value;
        document.querySelectorAll('.order-table th').forEach(h => h.classList.remove('sorted'));
        th.classList.add('sorted');
        applyAndRender();
    });
});

/* ============================================================
   11. FILTER + SORT + PAGINATE PIPELINE
   ============================================================ */
function matchesSearch(o, q){
    if(!q) return true;
    return o.id.toLowerCase().includes(q) || o.customer.name.toLowerCase().includes(q) ||
           o.model.name.toLowerCase().includes(q) || o.customer.phone.includes(q);
}
function matchesFilters(o){
    const f = state.filters;
    if(f.technology.length && !f.technology.includes(o.technology)) return false;
    if(f.material.length && !o.materials.some(m => f.material.includes(m) || (f.material.includes('Resin') && m.toLowerCase().includes('resin')))) return false;
    if(f.deadline.length && !f.deadline.includes(deadlineBucket(o) === 'far' ? '__none__' : deadlineBucket(o))) return false;
    if(f.priority.length && !f.priority.includes(o.priority)) return false;
    return true;
}
function matchesStatusTab(o){
    if(state._inProdOnly) return ['PREPARING','PRINTING','POST_PROCESSING','QC','PACKAGING'].includes(o.status);
    if(state._dueSoonOnly) return ['today','24h'].includes(deadlineBucket(o)) && !['COMPLETED','CANCELLED'].includes(o.status);
    if(state.statusTab === 'ALL') return true;
    return o.status === state.statusTab;
}
function sortOrders(list){
    const l = [...list];
    switch(state.sort){
        case 'newest': return l.sort((a,b) => new Date(b.createdAt) - new Date(a.createdAt));
        case 'oldest': return l.sort((a,b) => new Date(a.createdAt) - new Date(b.createdAt));
        case 'deadline_asc': return l.sort((a,b) => new Date(a.deadline) - new Date(b.deadline));
        case 'deadline_desc': return l.sort((a,b) => new Date(b.deadline) - new Date(a.deadline));
        case 'value_desc': return l.sort((a,b) => b.total - a.total);
        case 'value_asc': return l.sort((a,b) => a.total - b.total);
        case 'customer_az': return l.sort((a,b) => a.customer.name.localeCompare(b.customer.name, 'vi'));
        case 'customer_za': return l.sort((a,b) => b.customer.name.localeCompare(a.customer.name, 'vi'));
        case 'id_asc': return l.sort((a,b) => a.id.localeCompare(b.id));
        case 'id_desc': return l.sort((a,b) => b.id.localeCompare(a.id));
        default: return l;
    }
}
function getFiltered(){
    return sortOrders(ORDERS.filter(o => matchesStatusTab(o) && matchesFilters(o) && matchesSearch(o, state.search)));
}

/* ============================================================
   12. RENDER: TABLE + MOBILE CARDS
   ============================================================ */
function techBadgeClass(tech){ return techGroupClass(tech); }
function priorityIcon(p){ return p === 'URGENT' ? '🔴' : p === 'PRIORITY' ? '●' : '○'; }

function orderWarningsHtml(o){
    if(!o.warnings.length) return '';
    return o.warnings.slice(0,2).map(w => {
        const wi = WARNING_LABELS[w]; if(!wi) return '';
        return `<span class="warn-ic" data-tip="${wi.tip}">${wi.ic}</span>`;
    }).join('');
}

function renderRow(o){
    const dl = deadlineInfo(o.deadline);
    const matText = o.materials.length > 1 ? o.materials.length + ' materials' : o.materials[0];
    const modelText = o.model.count > 1 ? o.model.count + ' models' : o.model.name;
    return `
    <tr data-open="${o.id}">
        <td>
            <div class="model-cell">
                <div class="model-thumb">3D</div>
                <div class="mn">${modelText}${o.model.count > 1 ? `<span>${o.quantity} sản phẩm</span>` : ''}</div>
            </div>
        </td>
        <td>
            <div class="order-id-cell">
                <span class="priority-dot ${o.priority}" title="${o.priority}"></span>
                <a href="#" data-open="${o.id}">#${o.id}</a>
                ${orderWarningsHtml(o)}
            </div>
        </td>
        <td class="cust-cell"><strong>${o.customer.name}</strong><span>${o.customer.phone}</span></td>
        <td>${o.quantity} sản phẩm</td>
        <td><span class="tbadge ${techBadgeClass(o.technology)}">${o.technology}</span></td>
        <td class="mat-cell">${matText}${o.materials.length > 1 ? ` <span class="warn-ic more" data-tip="${o.materials.join(', ')}">ⓘ</span>` : ''}</td>
        <td class="dl-cell"><strong>${fmtDate(o.deadline)}</strong><span class="dl-tag ${dl.cls}">${dl.text}</span></td>
        <td class="value-cell">${money(o.total)}</td>
        <td><span class="sbadge ${o.status}">${STATUS_LABELS[o.status]}</span></td>
        <td class="date-cell" title="${fmtDateTime(o.createdAt)}">${fmtDate(o.createdAt)}<span>${new Date(o.createdAt).toLocaleTimeString('vi-VN',{hour:'2-digit',minute:'2-digit'})}</span></td>
        <td>
            <div class="act-cell">
                ${o.status === 'PENDING_CONFIRMATION'
                    ? `<button class="btn-review" data-open="${o.id}">Xem &amp; duyệt</button>`
                    : `<button class="btn-view" data-open="${o.id}">Xem</button>`}
                <div class="menu-wrap">
                    <button class="menu-dots" data-menu="${o.id}">⋮</button>
                    <div class="dd-menu" id="menu-${o.id}">
                        <button data-open="${o.id}">👁 Xem chi tiết</button>
                        <button data-chat="${o.id}">💬 Chat với khách</button>
                        <button data-status="${o.id}">🔄 Cập nhật trạng thái</button>
                    </div>
                </div>
            </div>
        </td>
    </tr>`;
}

function renderMobileCard(o){
    const dl = deadlineInfo(o.deadline);
    const matText = o.materials.length > 1 ? o.materials.length + ' vật liệu' : o.materials[0];
    return `
    <div class="m-card" data-open="${o.id}">
        <div class="m-card-top">
            <span class="oid"><span class="priority-dot ${o.priority}"></span> #${o.id}</span>
            <span class="sbadge ${o.status}">${STATUS_LABELS[o.status]}</span>
        </div>
        <div class="m-card-model">
            <div class="model-thumb">3D</div>
            <div class="mn"><strong>${o.model.name}</strong><span>${o.customer.name}</span></div>
        </div>
        <div class="m-card-grid">
            <div><div class="g-lbl">Số lượng</div><div class="g-val">${o.quantity}</div></div>
            <div><div class="g-lbl">Công nghệ</div><div class="g-val">${o.technology}</div></div>
            <div><div class="g-lbl">Vật liệu</div><div class="g-val">${matText}</div></div>
            <div><div class="g-lbl">Deadline</div><div class="g-val">${dl.text}</div></div>
        </div>
        <div class="m-card-foot">
            <span class="val">${money(o.total)}</span>
            ${orderWarningsHtml(o)}
        </div>
        ${o.status === 'PENDING_CONFIRMATION'
            ? `<button class="btn-review" data-open="${o.id}">Xem &amp; duyệt</button>`
            : `<button class="btn-view" data-open="${o.id}">Xem</button>`}
    </div>`;
}

function bindRowEvents(container){
    container.querySelectorAll('[data-open]').forEach(el => {
        el.addEventListener('click', e => {
            if(e.target.closest('[data-menu]')) return;
            e.preventDefault();
            goToDetail(el.dataset.open);
        });
    });
    container.querySelectorAll('[data-menu]').forEach(btn => {
        btn.addEventListener('click', e => {
            e.stopPropagation();
            const id = btn.dataset.menu;
            const menu = $('menu-' + id);
            const isOpen = menu.classList.contains('show');
            document.querySelectorAll('.dd-menu.show').forEach(m => m.classList.remove('show'));
            menu.classList.toggle('show', !isOpen);
        });
    });
    container.querySelectorAll('[data-chat]').forEach(btn => btn.addEventListener('click', e => { e.stopPropagation(); toast('Đang mở khung chat với khách…'); }));
    container.querySelectorAll('[data-status]').forEach(btn => btn.addEventListener('click', e => { e.stopPropagation(); toast('Mở trong Chi tiết đơn hàng để cập nhật trạng thái'); }));
}
document.addEventListener('click', () => document.querySelectorAll('.dd-menu.show').forEach(m => m.classList.remove('show')));

function goToDetail(id){
    // Route theo cấu trúc hiện tại của hệ thống: /supplier/orders/{id}
    toast('Đang mở Chi tiết đơn hàng #' + id + '…');
    // window.location.href = '/supplier/orders/' + id;
}

/* ============================================================
   13. EMPTY / NO RESULT STATES
   ============================================================ */
function renderEmpty(target, hasAnyOrders, hasActiveQuery){
    let html;
    if(!hasAnyOrders){
        html = `<div class="ic">📭</div><h3>Xưởng chưa nhận được đơn hàng nào</h3><p>Khi có khách đặt in, đơn hàng sẽ xuất hiện tại đây.</p>`;
    } else if(state.search){
        html = `<div class="ic">🔍</div><h3>Không tìm thấy đơn hàng</h3><p>Không tìm thấy đơn hàng phù hợp với "<b>${state.search}</b>".</p><button id="clearSearchBtn">Xóa tìm kiếm</button>`;
    } else {
        html = `<div class="ic">🗂️</div><h3>Chưa có đơn hàng</h3><p>Hiện tại chưa có đơn hàng phù hợp với bộ lọc.</p><button id="clearFilterBtn2">Xóa bộ lọc</button>`;
    }
    target.innerHTML = html;
    target.style.display = 'block';
    const csb = target.querySelector('#clearSearchBtn'); if(csb) csb.onclick = () => $('searchClear').click();
    const cfb = target.querySelector('#clearFilterBtn2'); if(cfb) cfb.onclick = () => $('filterReset').click();
}

/* ============================================================
   14. PAGINATION
   ============================================================ */
function renderPagination(totalItems){
    const totalPages = Math.max(1, Math.ceil(totalItems / state.pageSize));
    if(state.page > totalPages) state.page = totalPages;
    const start = totalItems === 0 ? 0 : (state.page - 1) * state.pageSize + 1;
    const end = Math.min(state.page * state.pageSize, totalItems);

    let pages = [];
    const p = state.page;
    const add = n => pages.push(n);
    if(totalPages <= 7){ for(let i=1;i<=totalPages;i++) add(i); }
    else {
        add(1);
        if(p > 3) pages.push('...');
        for(let i=Math.max(2,p-1); i<=Math.min(totalPages-1,p+1); i++) add(i);
        if(p < totalPages-2) pages.push('...');
        add(totalPages);
    }

    $('paginationBar').innerHTML = `
        <div class="pg-info">
            Hiển thị ${start}–${end} trong ${totalItems} đơn hàng
            &nbsp;·&nbsp; Số dòng:
            <select id="pageSizeSelect">
                ${[10,20,50,100].map(n => `<option value="${n}" ${state.pageSize===n?'selected':''}>${n}</option>`).join('')}
            </select>
        </div>
        <div class="pg-nav">
            <button id="pgPrev" ${p<=1?'disabled':''}>←</button>
            ${pages.map(n => n === '...' ? `<span class="dots">…</span>` : `<button data-pg="${n}" class="${n===p?'active':''}">${n}</button>`).join('')}
            <button id="pgNext" ${p>=totalPages?'disabled':''}>→</button>
        </div>`;
    $('pageSizeSelect').onchange = e => { state.pageSize = +e.target.value; state.page = 1; applyAndRender(); };
    $('pgPrev').onclick = () => { state.page--; applyAndRender(); };
    $('pgNext').onclick = () => { state.page++; applyAndRender(); };
    $('paginationBar').querySelectorAll('[data-pg]').forEach(b => b.onclick = () => { state.page = +b.dataset.pg; applyAndRender(); });
}

/* ============================================================
   15. MAIN RENDER PIPELINE
   ============================================================ */
function applyAndRender(){
    const filtered = getFiltered();
    const totalPages = Math.max(1, Math.ceil(filtered.length / state.pageSize));
    if(state.page > totalPages) state.page = totalPages;
    const pageItems = filtered.slice((state.page-1)*state.pageSize, state.page*state.pageSize);

    const hasAnyOrders = ORDERS.length > 0;
    if(pageItems.length === 0){
        $('tableBody').innerHTML = '';
        $('mobileCards').innerHTML = '';
        renderEmpty($('emptyState'), hasAnyOrders);
        renderEmpty($('emptyStateMobile'), hasAnyOrders);
        $('emptyState').style.display = 'block';
        $('emptyStateMobile').style.display = 'block';
    } else {
        $('emptyState').style.display = 'none';
        $('emptyStateMobile').style.display = 'none';
        $('tableBody').innerHTML = pageItems.map(renderRow).join('');
        $('mobileCards').innerHTML = pageItems.map(renderMobileCard).join('');
        bindRowEvents($('tableBody'));
        bindRowEvents($('mobileCards'));
    }
    renderPagination(filtered.length);
}

/* ============================================================
   16. KHỞI TẠO
   ============================================================ */
function tick(){ $('clock').textContent = now().toLocaleTimeString('vi-VN', {hour:'2-digit', minute:'2-digit'}); }
tick();

renderFilterOptions();
renderStats();
renderStatusTabs();
renderChips();
applyAndRender();
</script>
</body>
</html>
