<%-- isELIgnored: de JSP khong xu ly ${...} trong template literal cua JavaScript ben duoi --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>PrintKraft — Đơn hàng của tôi</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
    <style>
        /* CSS riêng của trang Đơn hàng (phần chung: header, footer, nút, drawer, toast... nằm trong site.css) */

        /* ===== Nút nhỏ + badge trạng thái + pill ===== */
        .btn-sm{padding:10px 16px; font-size:13px; border-radius:9px; box-shadow:none;}
        .btn-primary.btn-sm:hover,.btn-secondary.btn-sm:hover{transform:translateY(-1px);}
        .btn-primary.btn-sm{background:var(--grad-primary); box-shadow:0 8px 20px rgba(108,92,231,0.26);}
        .status-badge{font-size:11.5px; font-weight:700; padding:6px 13px; border-radius:999px; text-transform:uppercase; letter-spacing:.04em; white-space:nowrap; display:inline-flex; align-items:center; gap:6px;}
        .st-pending{background:#FFF4E0; color:#9A6200;}
        .st-quote{background:#FFF6D6; color:#8A6D00;}
        .st-producing{background:#EDE9FF; color:#5A46D6;}
        .st-shipping{background:#E1F0FF; color:#0C63B8;}
        .st-delivered{background:#E1FBF3; color:#0A7A5E;}
        .st-cancelled{background:#FFE9E9; color:#C0392B;}
        .pill{font-size:11.5px; font-weight:600; padding:4px 11px; border-radius:999px; background:#F2EFFF; color:var(--violet);}

        /* ===== Trang ===== */
        .page-wrap{max-width:1280px; margin:0 auto; padding:26px 32px 66px; min-height:60vh;}
        .orders-head{display:flex; justify-content:space-between; align-items:flex-start; gap:20px; flex-wrap:wrap; margin-bottom:20px;}
        .orders-head h1{font-size:34px;}
        .orders-head .sub{color:var(--ink-soft); font-size:14.5px; margin-top:8px;}

        /* Banner ưu tiên */
        .priority-banner{
            display:flex; gap:14px; align-items:center; flex-wrap:wrap;
            background:linear-gradient(135deg,#FFF6D6 0%, #FFFDF7 100%);
            border:1px solid rgba(255,179,71,0.5); border-radius:var(--r-md);
            padding:16px 20px; margin-bottom:20px; box-shadow:var(--shadow-xs);
        }
        .priority-banner .pb-ic{width:44px;height:44px;border-radius:14px; background:var(--grad-warm); color:#fff; display:flex;align-items:center;justify-content:center; font-size:20px; flex-shrink:0;}
        .priority-banner .pb-body{flex:1; min-width:200px;}
        .priority-banner strong{display:block; font-family:'Space Grotesk'; font-size:16px; color:#8A5A00;}
        .priority-banner span{font-size:13px; color:#9A6200;}

        /* Summary cards */
        .summary-grid{display:grid; grid-template-columns:repeat(4,1fr); gap:14px; margin-bottom:22px;}
        .sum-card{background:var(--surface); border:1px solid var(--line); border-radius:var(--r-md); padding:16px 18px; box-shadow:var(--shadow-xs); text-align:left; transition:.18s; border-left:4px solid var(--violet);}
        .sum-card:hover{box-shadow:var(--shadow-sm); transform:translateY(-2px);}
        .sum-card .sc-label{font-size:12px; font-weight:700; color:var(--ink-soft); text-transform:uppercase; letter-spacing:.05em;}
        .sum-card .sc-value{font-family:'Space Grotesk'; font-size:28px; font-weight:700; line-height:1.1; margin:4px 0 2px;}
        .sum-card .sc-note{font-size:12px; color:var(--ink-soft);}
        .sum-card.warn{border-left-color:var(--amber);}
        .sum-card.warn .sc-value{color:#9A6200;}
        .sum-card.producing{border-left-color:var(--violet-soft);}
        .sum-card.done{border-left-color:var(--teal);}
        .sum-card.done .sc-value{color:#0A7A5E;}
        .sum-card.active-tab{box-shadow:0 0 0 3px rgba(108,92,231,0.18), var(--shadow-sm);}

        /* Toolbar */
        .toolbar{display:flex; gap:12px; align-items:center; flex-wrap:wrap; margin-bottom:16px;}
        .search-box{flex:1 1 300px; display:flex; align-items:center; background:var(--surface); border:1.5px solid var(--line-strong); border-radius:999px; overflow:hidden; box-shadow:var(--shadow-xs); transition:.18s;}
        .search-box:focus-within{border-color:var(--violet); box-shadow:0 0 0 4px rgba(108,92,231,0.14);}
        .search-box input{border:none; outline:none; background:transparent; padding:12px 20px; font-size:14px; flex:1; min-width:0;}
        .search-box button{padding:0 18px; font-size:15px; color:var(--ink-soft); align-self:stretch;}
        .search-box button:hover{color:var(--coral-deep);}
        .sort-wrap{display:flex; align-items:center; gap:9px; background:var(--surface); border:1.5px solid var(--line-strong); border-radius:var(--r-sm); padding:0 6px 0 14px; box-shadow:var(--shadow-xs);}
        .sort-wrap > span{font-size:12.5px; font-weight:600; color:var(--ink-soft); white-space:nowrap;}
        .sort-wrap select{border:none; outline:none; background:transparent; padding:12px 8px; font-size:13.5px; font-weight:600; color:var(--ink); cursor:pointer;}
        .fcount{background:var(--coral-deep); color:#fff; border-radius:999px; padding:1px 8px; font-size:11.5px; margin-left:4px;}

        /* Tabs */
        .tabs{display:flex; gap:8px; overflow-x:auto; scrollbar-width:none; padding:2px 2px 4px;}
        .tabs::-webkit-scrollbar{display:none;}
        .tab{border:1.5px solid var(--line-strong); background:var(--surface); border-radius:999px; padding:9px 16px; font-size:13px; font-weight:600; white-space:nowrap; transition:.18s; display:inline-flex; align-items:center; gap:8px; flex-shrink:0;}
        .tab:hover{border-color:var(--violet); color:var(--violet);}
        .tab.active{background:var(--grad-primary); color:#fff; border-color:transparent; box-shadow:0 8px 20px rgba(108,92,231,0.28);}
        .tab .cnt{background:rgba(27,27,47,0.08); border-radius:999px; padding:1px 8px; font-size:11.5px;}
        .tab.active .cnt{background:rgba(255,255,255,0.28);}

        /* Active filters */
        .active-filters{display:flex; gap:8px; flex-wrap:wrap; align-items:center; margin:16px 0 0;}
        .active-filters:empty{display:none;}
        .af-chip{display:inline-flex; align-items:center; gap:8px; background:#F2EFFF; color:var(--violet); border-radius:999px; padding:7px 10px 7px 14px; font-size:12.5px; font-weight:600;}
        .af-chip button{width:18px; height:18px; border-radius:50%; background:rgba(108,92,231,0.16); font-size:11px; line-height:1; display:flex; align-items:center; justify-content:center;}
        .af-chip button:hover{background:var(--coral-deep); color:#fff;}
        .af-clear{font-size:12.5px; font-weight:600; color:var(--ink-soft); text-decoration:underline; padding:7px 4px;}
        .af-clear:hover{color:var(--coral-deep);}

        /* Danh sách đơn */
        .order-list{display:flex; flex-direction:column; gap:16px; margin-top:20px;}
        .order-card{position:relative; background:var(--surface); border:1px solid var(--line); border-radius:var(--r-md); padding:20px; box-shadow:var(--shadow-xs); transition:.2s;}
        .order-card:hover{box-shadow:var(--shadow-sm); border-color:rgba(108,92,231,0.3);}
        .order-card.highlight{border-color:rgba(255,179,71,0.55); background:linear-gradient(180deg,#FFFDF7 0%, #FFFFFF 46%); box-shadow:0 10px 28px rgba(255,179,71,0.18);}
        .order-card.highlight:before{content:""; position:absolute; left:0; top:0; bottom:0; width:5px; border-radius:var(--r-md) 0 0 var(--r-md); background:var(--grad-warm);}
        .order-card.cancelled{opacity:.8;}
        .oc-head{display:flex; justify-content:space-between; align-items:flex-start; gap:14px; flex-wrap:wrap; margin-bottom:14px;}
        .oc-id{font-family:'Space Grotesk'; font-weight:700; font-size:16px; display:flex; gap:10px; align-items:baseline; flex-wrap:wrap;}
        .oc-id a:hover{color:var(--violet); text-decoration:underline;}
        .oc-date{font-family:'IBM Plex Sans'; font-weight:400; font-size:12.5px; color:var(--ink-soft);}
        .oc-urgent{display:flex; gap:9px; align-items:center; background:#FFF6D6; color:#8A6D00; border:1px dashed rgba(255,179,71,0.75); border-radius:var(--r-sm); padding:10px 14px; font-size:12.5px; font-weight:700; margin-bottom:14px; text-transform:uppercase; letter-spacing:.03em;}
        .oc-body{display:flex; gap:16px; align-items:flex-start;}
        .thumb{width:74px; height:74px; border-radius:14px; display:flex; align-items:center; justify-content:center; font-family:'Space Grotesk'; font-weight:700; color:#fff; font-size:16px; flex-shrink:0; box-shadow:var(--shadow-xs);}
        .thumb.t-fdm{background:var(--grad-primary);}
        .thumb.t-resin{background:var(--grad-sky);}
        .thumb.t-powder{background:var(--grad-cool); color:#063a2e;}
        .oc-info{flex:1; min-width:0;}
        .oc-model{font-size:16.5px; margin-bottom:9px; word-break:break-word;}
        .oc-model a:hover{color:var(--violet);}
        .oc-tags{display:flex; gap:7px; flex-wrap:wrap; margin-bottom:11px;}
        .oc-meta{display:flex; gap:6px 18px; flex-wrap:wrap; font-size:13px; color:var(--ink-soft);}
        .oc-meta b{color:var(--ink); font-weight:600;}
        .deadline.warn{color:#9A6200; font-weight:600;}
        .deadline.late{color:var(--coral-deep); font-weight:700;}
        .oc-hint{margin-top:12px; font-size:12.5px; color:var(--ink-soft); border-left:3px solid var(--line-strong); padding-left:10px;}
        .oc-hint.urgent{color:#8A6D00; border-left-color:var(--amber); font-weight:600;}
        .order-progress{display:flex; gap:5px; margin:14px 0 0;}
        .order-progress .bar{flex:1; height:5px; border-radius:999px; background:#EDEBF5;}
        .order-progress .bar.on{background:var(--grad-primary);}
        .oc-right{width:236px; flex-shrink:0; text-align:right; display:flex; flex-direction:column; gap:12px;}
        .oc-price span{display:block; font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.06em; color:var(--ink-soft);}
        .oc-price b{display:block; font-family:'Space Grotesk'; font-size:22px; font-weight:700; margin-top:3px;}
        .oc-price b.muted{font-size:14px; font-family:'IBM Plex Sans'; font-weight:500; color:var(--ink-soft);}
        .oc-price b.hot{color:#9A6200;}
        .oc-price em{display:block; font-style:normal; font-size:11.5px; color:var(--ink-soft); margin-top:4px;}
        .oc-cta{display:flex; flex-direction:column; gap:8px;}
        .oc-cta > *{width:100%;}

        /* Empty / error */
        .empty-state{text-align:center; background:var(--surface); border:1px solid var(--line); border-radius:var(--r-lg); padding:52px 28px; box-shadow:var(--shadow-xs);}
        .empty-state .ic{width:76px;height:76px;border-radius:24px; background:#EDE9FF; color:var(--violet); display:flex;align-items:center;justify-content:center;font-size:32px; margin:0 auto 18px;}
        .empty-state h3{font-size:21px; margin-bottom:8px;}
        .empty-state p{color:var(--ink-soft); font-size:14px; max-width:44ch; margin:0 auto 22px;}
        .error-state{text-align:center; background:var(--surface); border:1px solid var(--line); border-radius:var(--r-lg); padding:52px 28px; box-shadow:var(--shadow-sm);}
        .error-state .ic{width:76px;height:76px;border-radius:24px; background:#FFECEC; color:var(--coral-deep); display:flex;align-items:center;justify-content:center;font-size:32px; margin:0 auto 18px;}
        .error-state h3{font-size:21px; margin-bottom:8px;}
        .error-state p{color:var(--ink-soft); font-size:14px; margin-bottom:22px;}

        /* Pagination */
        .pager{display:flex; justify-content:space-between; align-items:center; gap:16px; flex-wrap:wrap; margin-top:24px; font-size:13px; color:var(--ink-soft);}
        .pager-label b{color:var(--ink); font-family:'Space Grotesk';}
        .pager-controls{display:flex; gap:8px; align-items:center; flex-wrap:wrap;}
        .pager-controls button{min-width:38px; height:38px; padding:0 12px; border:1.5px solid var(--line-strong); background:var(--surface); border-radius:10px; font-size:13.5px; font-weight:600; transition:.18s;}
        .pager-controls button:hover:not(:disabled){border-color:var(--violet); color:var(--violet);}
        .pager-controls button.active{background:var(--grad-primary); color:#fff; border-color:transparent;}
        .pager-controls button:disabled{opacity:.4; cursor:not-allowed;}
        .page-size{display:flex; align-items:center; gap:8px;}
        .page-size select{border:1.5px solid var(--line-strong); border-radius:10px; padding:8px 10px; font-size:13px; font-weight:600; background:var(--surface); cursor:pointer;}

        /* Bộ lọc trong drawer (khung .drawer nằm trong site.css) */
        .fgroup{margin-bottom:24px;}
        .fgroup h4{font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:.07em; color:var(--ink-soft); margin-bottom:12px;}
        .fopt{display:flex; align-items:center; gap:11px; padding:10px 12px; border:1.5px solid var(--line); border-radius:var(--r-sm); background:var(--surface); margin-bottom:8px; cursor:pointer; font-size:13.5px; transition:.16s;}
        .fopt:hover{border-color:var(--violet);}
        .fopt input{width:17px; height:17px; accent-color:var(--violet); flex-shrink:0;}
        .fopt .n{margin-left:auto; font-size:12px; color:var(--ink-soft); font-weight:600;}
        .f-range{display:grid; grid-template-columns:1fr 1fr; gap:10px;}
        .f-range label{font-size:12px; font-weight:600; color:var(--ink-soft); display:flex; flex-direction:column; gap:6px;}
        .f-range input{border:1.5px solid var(--line); border-radius:var(--r-sm); padding:10px; font-size:13px; background:var(--surface); outline:none;}
        .f-range input:focus{border-color:var(--violet);}
        .action-row{display:flex; gap:10px;}
        .action-row > *{flex:1;}

        /* Demo bar */
        .demo-bar{background:rgba(255,255,255,0.72); border:1px dashed var(--line-strong); border-radius:var(--r-md); padding:12px 16px; margin-bottom:20px;}
        .demo-label{font-size:12px; font-weight:700; color:var(--ink-soft); text-transform:uppercase; letter-spacing:.05em; margin-bottom:10px;}
        .demo-chips{display:flex; gap:8px; flex-wrap:wrap;}
        .demo-chips button{border:1.5px solid var(--line-strong); background:var(--surface); border-radius:999px; padding:7px 14px; font-size:12px; font-weight:600; transition:.18s;}
        .demo-chips button:hover{border-color:var(--violet); color:var(--violet);}
        .demo-chips button.active{background:var(--grad-primary); color:white; border-color:transparent;}

        /* Skeleton */
        .sk{background:linear-gradient(90deg,#EFEDF6 25%, #F7F5FC 37%, #EFEDF6 63%); background-size:400% 100%; animation:sk 1.4s ease infinite; border-radius:10px;}
        @keyframes sk{0%{background-position:100% 0;}100%{background-position:0 0;}}
        .sk-card{background:var(--surface); border:1px solid var(--line); border-radius:var(--r-md); padding:20px; box-shadow:var(--shadow-xs); display:flex; gap:16px;}
        .sk-card .sk-thumb{width:74px; height:74px; flex-shrink:0; border-radius:14px;}
        .sk-card .sk-lines{flex:1;}
        .sk-line{height:14px; margin-bottom:10px;}
        .sk-line.w40{width:40%;} .sk-line.w70{width:70%;} .sk-line.w55{width:55%;}

        /* ===== Responsive (riêng trang) ===== */
        @media (max-width:1080px){
            .summary-grid{grid-template-columns:repeat(2,1fr);}
            .oc-right{width:200px;}
        }
        @media (max-width:980px){
            .page-wrap{padding:22px 20px 48px;}
            .orders-head h1{font-size:28px;}
        }
        @media (max-width:760px){
            .summary-grid{grid-template-columns:1fr 1fr; gap:10px;}
            .sum-card{padding:13px 14px;}
            .sum-card .sc-value{font-size:23px;}
            .oc-body{flex-direction:column;}
            .oc-right{width:100%; text-align:left; border-top:1px dashed var(--line); padding-top:14px;}
            .oc-head{flex-direction:column; align-items:flex-start; gap:10px;}
            .thumb{width:60px; height:60px; border-radius:12px;}
            .orders-head{flex-direction:column;}
            .orders-head .btn-primary{width:100%;}
            .toolbar{flex-direction:column; align-items:stretch;}
            .sort-wrap{justify-content:space-between;}
            .oc-meta{gap:4px 14px;}
        }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="active" value="donhang"/>
</jsp:include>

<main>
    <div class="page-wrap">

        <div class="demo-bar" id="demoBar">
            <div class="demo-label">🧪 Chế độ demo — dữ liệu mock · dùng để kiểm thử các trạng thái trang</div>
            <div class="demo-chips" id="demoChips"></div>
        </div>

        <div class="orders-head">
            <div>
                <h1>Đơn hàng của tôi</h1>
                <p class="sub">Theo dõi và quản lý các đơn in 3D của bạn.</p>
            </div>
            <a class="btn-primary" href="dat_in_3d.jsp">+ Đặt đơn in mới</a>
        </div>

        <div id="bannerHost"></div>
        <div class="summary-grid" id="summaryGrid"></div>

        <div class="toolbar" id="toolbarWrap">
            <div class="search-box">
                <input type="text" id="searchInput" placeholder="🔍 Tìm mã đơn hoặc tên model..." autocomplete="off" aria-label="Tìm đơn hàng">
                <button type="button" id="searchClear" hidden aria-label="Xóa tìm kiếm">✕</button>
            </div>
            <label class="sort-wrap">
                <span>Sắp xếp</span>
                <select id="sortSelect" aria-label="Sắp xếp đơn hàng">
                    <option value="newest">Mới nhất</option>
                    <option value="oldest">Cũ nhất</option>
                    <option value="priceDesc">Giá cao → thấp</option>
                    <option value="priceAsc">Giá thấp → cao</option>
                    <option value="deadline">Deadline gần nhất</option>
                </select>
            </label>
            <button type="button" class="btn-secondary btn-sm" id="filterBtn">⚙ Lọc <span class="fcount" id="filterCount" hidden>0</span></button>
        </div>

        <div class="tabs" id="tabs" role="tablist" aria-label="Lọc theo trạng thái"></div>
        <div class="active-filters" id="activeFilters"></div>

        <div id="listHost"></div>
        <div id="pagerHost"></div>

    </div>
</main>

<!-- ============ DRAWER LỌC (khung .drawer, .overlay lấy từ site.css) ============ -->
<aside class="drawer" id="filterDrawer" aria-label="Bộ lọc đơn hàng">
    <div class="drawer-head">
        <h3>Lọc đơn hàng</h3>
        <button type="button" id="drawerClose" aria-label="Đóng bộ lọc">×</button>
    </div>
    <div class="drawer-body">
        <div class="fgroup">
            <h4>Trạng thái</h4>
            <div id="fStatus"></div>
        </div>
        <div class="fgroup">
            <h4>Công nghệ</h4>
            <div id="fTech"></div>
        </div>
        <div class="fgroup">
            <h4>Thời gian đặt</h4>
            <div id="fTime"></div>
        </div>
        <div class="fgroup" id="fRange" hidden>
            <h4>Tùy chọn khoảng ngày</h4>
            <div class="f-range">
                <label>Từ <input type="date" id="fFrom"></label>
                <label>Đến <input type="date" id="fTo"></label>
            </div>
        </div>
    </div>
    <div class="drawer-foot">
        <div class="action-row">
            <button type="button" class="btn-secondary" id="filterReset">Đặt lại</button>
            <button type="button" class="btn-primary" id="filterApply">Áp dụng</button>
        </div>
    </div>
</aside>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script>
    // Dam bao co #overlay va #toast (neu footer.jsp chua in ra)
    (function () {
        if (!document.getElementById('overlay')) {
            var o = document.createElement('div'); o.className = 'overlay'; o.id = 'overlay';
            document.body.appendChild(o);
        }
        if (!document.getElementById('toast')) {
            var t = document.createElement('div'); t.className = 'toast'; t.id = 'toast';
            document.body.appendChild(t);
        }
    })();
</script>
<script src="<%= request.getContextPath() %>/assets/js/site.js"></script>

<script id="listScript">
    /* ============================================================
       1. STATUS MODEL — enum ở code, label thân thiện ở UI
       ============================================================ */
    const STATUS = {
        PENDING_SUPPLIER_REVIEW:{label:'Chờ xưởng tiếp nhận', icon:'🟠', tone:'st-pending',  group:'processing'},
        SUPPLIER_REVIEWING:     {label:'Xưởng đang kiểm tra', icon:'🟠', tone:'st-pending',  group:'processing'},
        PENDING_QUOTE:          {label:'Chờ báo giá',         icon:'🟠', tone:'st-pending',  group:'processing'},
        REVISION_REQUESTED:     {label:'Đang điều chỉnh',     icon:'🟠', tone:'st-pending',  group:'processing'},
        QUOTE_RECEIVED:         {label:'Chờ bạn xác nhận',    icon:'🟡', tone:'st-quote',    group:'needs_action'},
        QUOTE_ACCEPTED:         {label:'Đã xác nhận báo giá', icon:'🔵', tone:'st-producing',group:'payment'},
        PAYMENT_PENDING:        {label:'Chờ thanh toán',      icon:'🟡', tone:'st-quote',    group:'payment'},
        PAID:                   {label:'Đã thanh toán',       icon:'🔵', tone:'st-producing',group:'producing'},
        PREPARING:              {label:'Đang chuẩn bị',       icon:'🔵', tone:'st-producing',group:'producing'},
        PRINTING:               {label:'Đang sản xuất',       icon:'🔵', tone:'st-producing',group:'producing'},
        POST_PROCESSING:        {label:'Đang hậu xử lý',      icon:'🔵', tone:'st-producing',group:'producing'},
        QC:                     {label:'Đang kiểm tra chất lượng', icon:'🔵', tone:'st-producing', group:'producing'},
        PACKAGING:              {label:'Đang đóng gói',       icon:'🔷', tone:'st-shipping', group:'producing'},
        SHIPPING:               {label:'Đang giao',           icon:'🔷', tone:'st-shipping', group:'shipping'},
        COMPLETED:              {label:'Hoàn thành',          icon:'🟢', tone:'st-delivered',group:'completed'},
        CANCELLED:              {label:'Đã hủy',              icon:'⚫', tone:'st-cancelled',group:'cancelled'},
        QUOTE_REJECTED:         {label:'Đã từ chối báo giá',  icon:'🔴', tone:'st-cancelled',group:'cancelled'}
    };
    const meta = s => STATUS[s] || {label:s, icon:'⚪', tone:'st-pending', group:'processing'};
    const groupOf = s => meta(s).group;

    /* Tabs (nhóm trạng thái) + nhãn filter */
    const TABS = [
        {key:'all',          label:'Tất cả'},
        {key:'processing',   label:'Đang xử lý'},
        {key:'needs_action', label:'Chờ bạn xác nhận'},
        {key:'producing',    label:'Đang sản xuất'},
        {key:'shipping',     label:'Đang giao'},
        {key:'completed',    label:'Hoàn thành'},
        {key:'cancelled',    label:'Đã hủy'}
    ];
    /* Filter trạng thái chi tiết hơn tab: có thêm "Chờ thanh toán" */
    const STATUS_FILTERS = [
        {key:'processing',   label:'Đang xử lý'},
        {key:'needs_action', label:'Chờ bạn xác nhận'},
        {key:'payment',      label:'Chờ thanh toán'},
        {key:'producing',    label:'Đang sản xuất'},
        {key:'shipping',     label:'Đang giao'},
        {key:'completed',    label:'Hoàn thành'},
        {key:'cancelled',    label:'Đã hủy'}
    ];
    const TECH_OPTIONS = ['FDM','SLA','MSLA','DLP','SLS','MJF'];
    const TIME_OPTIONS = [
        {key:'all',   label:'Tất cả thời gian'},
        {key:'today', label:'Hôm nay'},
        {key:'7d',    label:'7 ngày qua'},
        {key:'30d',   label:'30 ngày qua'},
        {key:'custom',label:'Tùy chọn khoảng ngày'}
    ];

    /* ============================================================
       2. MOCK DATA — thay bằng API GET /api/orders?customer=me
       ============================================================ */
    const SUPPLIERS = {
        abc:  {name:'ABC 3D Printing'},
        sg:   {name:'Xưởng In Sài Gòn'},
        hn:   {name:'Hà Nội 3D Lab'},
        dn:   {name:'Đà Nẵng Maker'},
        sls:  {name:'SLS Việt Nam'},
        mjf:  {name:'MJF Tech'}
    };
    function O(id, status, model, quantity, technology, material, supplier, price, deadline, createdAt, quoteValidUntil){
        return {
            id, status,
            model:{name:model, thumbnail:null},
            quantity, technology, material,
            supplier:SUPPLIERS[supplier],
            price, deadline:deadline || null, createdAt,
            quoteValidUntil:quoteValidUntil || null
        };
    }
    const ORDERS = [
        O('3DP-20260926-00125','QUOTE_RECEIVED',    'Rồng thần.stl',              10,'FDM', 'PLA',           'abc', 350000,  '2026-09-29','2026-09-26T18:32:00','2026-09-29'),
        O('3DP-20260926-00124','PENDING_QUOTE',     'Mô hình kiến trúc.stl',       2,'SLA', 'Standard Resin','sg',  null,   '2026-10-02','2026-09-26T16:05:00'),
        O('3DP-20260926-00120','PENDING_SUPPLIER_REVIEW','Bánh răng in 3D.stl',   25,'FDM', 'PETG',          'hn',  null,   null,        '2026-09-26T09:12:00'),
        O('3DP-20260925-00118','SUPPLIER_REVIEWING', 'Vỏ hộp Raspberry Pi.stl',    5,'FDM', 'ABS',           'dn',  null,   '2026-10-01','2026-09-25T20:40:00'),
        O('3DP-20260925-00112','QUOTE_RECEIVED',    'Tượng rồng con.stl',          1,'MSLA','Tough Resin',   'abc', 520000, '2026-10-01','2026-09-25T14:22:00','2026-10-01'),
        O('3DP-20260925-00110','PAYMENT_PENDING',   'Phụ tùng máy bay mô hình.3mf', 4,'SLS', 'Nylon PA12',    'sls', 1280000,'2026-10-05','2026-09-25T10:03:00'),
        O('3DP-20260924-00108','PAID',              'Hộp đựng dụng cụ.stl',       12,'MJF', 'PA12',          'mjf', 2400000,'2026-10-04','2026-09-24T15:48:00'),
        O('3DP-20260924-00105','PRINTING',          'Mô hình robot.stl',           3,'FDM', 'PLA+',          'abc', 480000, '2026-10-03','2026-09-24T11:30:00'),
        O('3DP-20260923-00101','POST_PROCESSING',   'Bình hoa nghệ thuật.stl',     6,'SLA', 'Standard Resin','sg',  890000, '2026-10-02','2026-09-23T17:15:00'),
        O('3DP-20260923-00098','QC',                'Khay linh kiện.stl',         30,'FDM', 'PETG',          'hn',  1650000,'2026-10-01','2026-09-23T09:05:00'),
        O('3DP-20260922-00095','PACKAGING',         'Mô hình tàu thủy.stl',        1,'DLP', 'Engineering Resin','dn',750000,'2026-09-30','2026-09-22T19:26:00'),
        O('3DP-20260922-00091','SHIPPING',          'Chân đế điện thoại.stl',     40,'FDM', 'PLA',           'abc', 3200000,'2026-09-29','2026-09-22T08:44:00'),
        O('3DP-20260920-00088','SHIPPING',          'Mô hình nhân vật.stl',        2,'MSLA','ABS-like Resin', 'sg',  610000, '2026-09-28','2026-09-20T21:10:00'),
        O('3DP-20260915-00070','COMPLETED',         'Đế kê laptop.stl',           15,'FDM', 'PETG',          'hn',  1750000,'2026-09-20','2026-09-15T13:40:00'),
        O('3DP-20260912-00065','COMPLETED',         'Mô hình linh vật.stl',        1,'SLS', 'PA11',          'sls', 1450000,null,        '2026-09-12T10:18:00'),
        O('3DP-20260910-00060','COMPLETED',         'Bộ phận cơ khí.3mf',          8,'MJF', 'PA12',          'mjf', 1980000,'2026-09-18','2026-09-10T16:02:00'),
        O('3DP-20260908-00055','COMPLETED',         'Ly cốc giữ nhiệt.stl',       20,'DLP', 'Standard Resin','dn',  1120000,null,        '2026-09-08T09:33:00'),
        O('3DP-20260905-00048','CANCELLED',         'Khuôn mẫu thử.stl',           1,'FDM', 'PLA',           'abc', null,   null,        '2026-09-05T14:50:00'),
        O('3DP-20260903-00041','QUOTE_REJECTED',    'Mô hình kiến trúc cũ.stl',    3,'SLA', 'Standard Resin','sg',  null,   null,        '2026-09-03T11:20:00'),
        O('3DP-20260901-00037','REVISION_REQUESTED','Hộp quà doanh nghiệp.stl',   50,'FDM', 'PLA',           'hn',  null,   '2026-09-28','2026-09-01T08:15:00')
    ];

    /* ============================================================
       3. TIỆN ÍCH
       (toast, toastOk, closeAll, openCart... đã có sẵn trong site.js)
       ============================================================ */
    const $ = id => document.getElementById(id);
    const pad = n => String(n).padStart(2,'0');
    function fDate(iso){ if(!iso) return '—'; const d = new Date(iso); return `${pad(d.getDate())}/${pad(d.getMonth()+1)}/${d.getFullYear()}`; }
    const fMoney = n => (n == null ? '—' : Math.round(n).toLocaleString('vi-VN') + 'đ');
    const esc = s => String(s == null ? '' : s).replace(/[&<>"]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));

    const DETAIL_PAGE = 'chi_tiet_don_hang_3d.jsp';
    /** Route Order List → Order Detail (đổi sang URL backend khi có API) */
    function detailUrl(o){
        const p = new URLSearchParams();
        p.set('status', o.status);
        p.set('id', o.id);
        p.set('model', o.model.name);
        p.set('qty', o.quantity);
        p.set('tech', o.technology);
        p.set('mat', o.material);
        if(o.supplier) p.set('supplier', o.supplier.name);
        if(o.price != null) p.set('price', o.price);
        if(o.deadline) p.set('deadline', o.deadline);
        return DETAIL_PAGE + '?' + p.toString();
    }

    /* Deadline: luôn kèm TEXT, không chỉ dùng màu (a11y) */
    function deadlineInfo(iso){
        if(!iso) return null;
        const now = new Date();
        const end = new Date(iso + 'T23:59:59');
        const startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        const startOfDeadline = new Date(end.getFullYear(), end.getMonth(), end.getDate());
        const days = Math.round((startOfDeadline - startOfToday) / 86400000);
        let text = '', tone = '';
        if(days < 0){ text = '⚠ Quá hạn'; tone = 'late'; }
        else if(days === 0){ text = '⚠ Hôm nay'; tone = 'warn'; }
        else {
            const hours = (end - now) / 3600000;
            if(hours < 24){ text = '⚠ Còn ' + Math.max(1, Math.round(hours)) + ' giờ'; tone = 'warn'; }
            else { text = 'Còn ' + days + ' ngày'; }
        }
        return {label:'Deadline: ' + fDate(iso), text, tone};
    }

    function priceInfo(o){
        const amount = o.price != null ? fMoney(o.price) : null;
        const s = o.status;
        if(['PENDING_SUPPLIER_REVIEW','SUPPLIER_REVIEWING','PENDING_QUOTE','REVISION_REQUESTED'].includes(s))
            return {label:'Giá', value:'Chưa có báo giá', muted:true};
        if(s === 'QUOTE_RECEIVED')  return {label:'Báo giá xưởng', value:amount, hot:true, note:o.quoteValidUntil ? 'Hiệu lực đến ' + fDate(o.quoteValidUntil) : null};
        if(['PAYMENT_PENDING','QUOTE_ACCEPTED'].includes(s)) return {label:'Cần thanh toán', value:amount};
        if(s === 'PAID')            return {label:'Đã thanh toán', value:amount};
        if(s === 'COMPLETED')       return {label:'Tổng tiền', value:amount};
        if(['CANCELLED','QUOTE_REJECTED'].includes(s)) return {label:'Giá', value:'Không áp dụng', muted:true};
        return {label:'Tổng tiền', value:amount};
    }

    /* Hành động theo trạng thái — không cho action sai trạng thái */
    function actionFor(o){
        const url = detailUrl(o), s = o.status;
        const detail = {label:'Xem chi tiết', href:url, secondary:true};
        if(s === 'QUOTE_RECEIVED')  return {hint:'Xưởng đã gửi báo giá. Vui lòng xem và xác nhận.', urgent:true, primary:{label:'Xem báo giá & xác nhận', href:url}, extra:detail};
        if(['PAYMENT_PENDING','QUOTE_ACCEPTED'].includes(s)) return {hint:'Đơn hàng đã được xác nhận. Vui lòng thanh toán.', urgent:true, primary:{label:'Thanh toán', href:url}, extra:detail};
        if(s === 'SHIPPING')        return {hint:'Đơn hàng đang được giao.', primary:{label:'Theo dõi giao hàng', href:url}};
        if(['PAID','PREPARING','PRINTING','POST_PROCESSING','QC','PACKAGING'].includes(s)) return {hint:'Xưởng đang sản xuất đơn hàng.', primary:{label:'Theo dõi đơn', href:url}};
        if(s === 'COMPLETED')       return {hint:'Đơn hàng đã hoàn thành.', primary:{label:'Xem chi tiết', href:url}};
        if(['PENDING_SUPPLIER_REVIEW','SUPPLIER_REVIEWING','PENDING_QUOTE'].includes(s)) return {hint:'Xưởng đang kiểm tra và tính toán báo giá.', primary:{label:'Xem chi tiết', href:url}};
        if(s === 'REVISION_REQUESTED') return {hint:'Bạn đã yêu cầu điều chỉnh. Xưởng sẽ gửi báo giá mới.', primary:{label:'Xem chi tiết', href:url}};
        return {hint:'Đơn hàng đã bị hủy.', primary:{label:'Xem chi tiết', href:url}};
    }

    /* Thanh tiến độ mini — suy ra từ nhóm trạng thái, không bịa % */
    const PROGRESS = {processing:1, needs_action:2, payment:2, producing:3, shipping:3, completed:4, cancelled:0};
    /* ============================================================
       4. TRẠNG THÁI TRANG + PIPELINE LỌC
       ============================================================ */
    const state = {
        tab:'all', q:'',
        filters:{statuses:[], techs:[], time:'all', from:'', to:''},
        sortSelect:'newest',
        page:1, pageSize:10,
        loading:true, mode:'ok'   // mode: ok | error | guest
    };

    /* Tab gộp nhóm 'payment' vào 'processing' (tab không có 'Chờ thanh toán') */
    const tabOf = s => (groupOf(s) === 'payment' ? 'processing' : groupOf(s));
    function filterStatusMatch(o, key){
        return key === 'payment' ? groupOf(o.status) === 'payment' : tabOf(o.status) === key;
    }

    const searchText = o => (o.id + ' ' + o.model.name + ' ' + (o.supplier ? o.supplier.name : '')).toLowerCase();
    const matchesSearch = o => !state.q || searchText(o).includes(state.q);

    function inTimeRange(o){
        const f = state.filters;
        if(f.time === 'all') return true;
        const created = new Date(o.createdAt);
        const now = new Date();
        const startToday = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        if(f.time === 'today') return created >= startToday;
        if(f.time === '7d')    return created >= new Date(startToday.getTime() - 6 * 86400000);
        if(f.time === '30d')   return created >= new Date(startToday.getTime() - 29 * 86400000);
        if(f.time === 'custom'){
            if(f.from && created < new Date(f.from + 'T00:00:00')) return false;
            if(f.to && created > new Date(f.to + 'T23:59:59'))     return false;
            return true;
        }
        return true;
    }
    function matchesFilters(o){
        const f = state.filters;
        if(f.statuses.length && !f.statuses.some(k => filterStatusMatch(o, k))) return false;
        if(f.techs.length && !f.techs.includes(o.technology)) return false;
        return inTimeRange(o);
    }
    const matchesTab = o => state.tab === 'all' || tabOf(o.status) === state.tab;

    function sortList(list){
        const arr = list.slice();
        const ts = o => new Date(o.createdAt).getTime();
        const cmpPrice = (a, b, desc) => {
            const pa = a.price, pb = b.price;
            if(pa == null && pb == null) return 0;
            if(pa == null) return 1;            // chưa có giá luôn xuống cuối
            if(pb == null) return -1;
            return desc ? pb - pa : pa - pb;
        };
        const cmpDeadline = (a, b) => {
            if(!a.deadline && !b.deadline) return 0;
            if(!a.deadline) return 1;
            if(!b.deadline) return -1;
            return new Date(a.deadline) - new Date(b.deadline);
        };
        switch(state.sortSelect){
            case 'oldest':    arr.sort((a,b) => ts(a) - ts(b)); break;
            case 'priceDesc': arr.sort((a,b) => cmpPrice(a,b,true)); break;
            case 'priceAsc':  arr.sort((a,b) => cmpPrice(a,b,false)); break;
            case 'deadline':  arr.sort(cmpDeadline); break;
            default:          arr.sort((a,b) => ts(b) - ts(a));       // newest
        }
        return arr;
    }
    function visibleOrders(){
        return sortList(ORDERS.filter(o => matchesTab(o) && matchesSearch(o) && matchesFilters(o)));
    }
    function tabCount(key){
        return key === 'all' ? ORDERS.length : ORDERS.filter(o => tabOf(o.status) === key).length;
    }

    /* ============================================================
       5. RENDER ORDER CARD
       ============================================================ */
    const thumbClass = tech => ['SLA','MSLA','DLP'].includes(tech) ? 't-resin' : (['SLS','MJF'].includes(tech) ? 't-powder' : 't-fdm');

    function cardHTML(o){
        const m = meta(o.status), g = m.group, act = actionFor(o), pr = priceInfo(o);
        const dl = deadlineInfo(o.deadline);
        const prog = PROGRESS[g] || 0;
        const highlight = o.status === 'QUOTE_RECEIVED';
        const url = detailUrl(o);
        return `
    <article class="order-card ${highlight ? 'highlight' : ''} ${g === 'cancelled' ? 'cancelled' : ''}">
      <div class="oc-head">
        <div class="oc-id">
          <a href="${url}" aria-label="Xem chi tiết đơn ${esc(o.id)}">#${esc(o.id)}</a>
          <span class="oc-date">Đặt ${fDate(o.createdAt)}</span>
        </div>
        <span class="status-badge ${m.tone}">${m.icon} ${m.label}</span>
      </div>
      ${highlight ? `<div class="oc-urgent"><span aria-hidden="true">🟡</span><span>Cần bạn xác nhận — xưởng đã gửi báo giá ${fMoney(o.price)}${o.quoteValidUntil ? ', hiệu lực đến ' + fDate(o.quoteValidUntil) : ''}</span></div>` : ''}
      <div class="oc-body">
        <div class="thumb ${thumbClass(o.technology)}" aria-hidden="true">${o.model.thumbnail ? `<img src="${esc(o.model.thumbnail)}" alt="">` : '3D'}</div>
        <div class="oc-info">
          <h4 class="oc-model"><a href="${url}">${esc(o.model.name)}</a></h4>
          <div class="oc-tags">
            <span class="pill">${esc(o.technology)}</span>
            <span class="pill">${esc(o.material)}</span>
            <span class="pill">${esc(o.quantity)} sản phẩm</span>
          </div>
          <div class="oc-meta">
            <span>Xưởng: <b>${esc(o.supplier.name)}</b></span>
            <span>Đặt ngày: <b>${fDate(o.createdAt)}</b></span>
            ${dl ? `<span class="deadline ${dl.tone}">${dl.label} · <b>${dl.text}</b></span>` : ''}
          </div>
          <p class="oc-hint ${act.urgent ? 'urgent' : ''}">${esc(act.hint)}</p>
          ${prog > 0 ? `<div class="order-progress" role="img" aria-label="Tiến độ đơn ${prog} trên 4">${[1,2,3,4].map(i => `<div class="bar ${i <= prog ? 'on' : ''}"></div>`).join('')}</div>` : ''}
        </div>
        <div class="oc-right">
          <div class="oc-price">
            <span>${esc(pr.label)}</span>
            <b class="${pr.muted ? 'muted' : ''} ${pr.hot ? 'hot' : ''}">${esc(pr.value)}</b>
            ${pr.note ? `<em>${esc(pr.note)}</em>` : ''}
          </div>
          <div class="oc-cta">
            <a class="btn-primary btn-sm" href="${act.primary.href}">${esc(act.primary.label)}</a>
            ${act.extra ? `<a class="btn-secondary btn-sm" href="${act.extra.href}">${esc(act.extra.label)}</a>` : ''}
          </div>
        </div>
      </div>
    </article>`;
    }

    /* ============================================================
       6. RENDER CÁC KHỐI
       ============================================================ */
    function renderBanner(){
        const host = $('bannerHost');
        const n = ORDERS.filter(o => o.status === 'QUOTE_RECEIVED').length;
        if(state.mode !== 'ok' || !n){ host.innerHTML = ''; return; }
        host.innerHTML = `
    <div class="priority-banner">
      <div class="pb-ic" aria-hidden="true">🟡</div>
      <div class="pb-body">
        <strong>${n} đơn đang chờ bạn xác nhận báo giá.</strong>
        <span>Xưởng đã gửi báo giá — xem và xác nhận để đơn được tiếp tục sản xuất.</span>
      </div>
      <button type="button" class="btn-primary btn-sm" id="pbBtn">Xem ngay</button>
    </div>`;
        $('pbBtn').onclick = () => setTab('needs_action');
    }

    function renderSummary(){
        const host = $('summaryGrid');
        if(state.mode !== 'ok'){ host.innerHTML = ''; return; }
        const cards = [
            {key:'processing',   label:'Đang xử lý',       note:'Đơn hàng đang xử lý', cls:''},
            {key:'needs_action', label:'Chờ bạn xác nhận', note:'Cần bạn thao tác',    cls:'warn'},
            {key:'producing',    label:'Đang sản xuất',    note:'Xưởng đang in',       cls:'producing'},
            {key:'completed',    label:'Hoàn thành',       note:'Đã giao xong',        cls:'done'}
        ];
        host.innerHTML = cards.map(c => `
    <button type="button" class="sum-card ${c.cls} ${state.tab === c.key ? 'active-tab' : ''}" data-tab="${c.key}">
      <span class="sc-label">${c.label}</span>
      <span class="sc-value">${tabCount(c.key)}</span>
      <span class="sc-note">${c.note}</span>
    </button>`).join('');
        host.querySelectorAll('[data-tab]').forEach(b => b.onclick = () => setTab(b.dataset.tab));
    }

    function renderTabs(){
        const host = $('tabs');
        host.innerHTML = TABS.map(t => `
    <button type="button" role="tab" aria-selected="${state.tab === t.key}" class="tab ${state.tab === t.key ? 'active' : ''}" data-tab="${t.key}">
      ${t.label} <span class="cnt">${tabCount(t.key)}</span>
    </button>`).join('');
        host.querySelectorAll('[data-tab]').forEach(b => b.onclick = () => setTab(b.dataset.tab));
    }

    function currentChips(){
        const chips = [];
        state.filters.statuses.forEach(k => {
            const opt = STATUS_FILTERS.find(s => s.key === k);
            chips.push({kind:'statuses', key:k, label: opt ? opt.label : k});
        });
        state.filters.techs.forEach(t => chips.push({kind:'techs', key:t, label:t}));
        if(state.filters.time && state.filters.time !== 'all'){
            let label = (TIME_OPTIONS.find(x => x.key === state.filters.time) || {}).label || state.filters.time;
            if(state.filters.time === 'custom'){
                const parts = [];
                if(state.filters.from) parts.push('từ ' + fDate(state.filters.from));
                if(state.filters.to)   parts.push('đến ' + fDate(state.filters.to));
                label = 'Thời gian ' + (parts.join(' ') || '(chưa chọn)');
            }
            chips.push({kind:'time', key:state.filters.time, label});
        }
        return chips;
    }

    function renderActiveFilters(){
        const host = $('activeFilters');
        const chips = currentChips();
        const badge = $('filterCount');
        badge.hidden = chips.length === 0;
        badge.textContent = chips.length;
        if(!chips.length){ host.innerHTML = ''; return; }
        host.innerHTML = chips.map(c => `
      <span class="af-chip">${esc(c.label)}
        <button type="button" data-kind="${c.kind}" data-key="${esc(c.key)}" aria-label="Bỏ lọc ${esc(c.label)}">✕</button>
      </span>`).join('') + `<button type="button" class="af-clear" id="afClear">Xóa tất cả</button>`;
        host.querySelectorAll('.af-chip button').forEach(b => b.onclick = () => removeChip(b.dataset.kind, b.dataset.key));
        $('afClear').onclick = () => { clearFilters(); toastOk('Đã xóa bộ lọc'); };
    }

    function skeletonHTML(){
        return `<div class="order-list">` + [1,2,3].map(() => `
    <div class="sk-card">
      <div class="sk sk-thumb"></div>
      <div class="sk-lines">
        <div class="sk sk-line w40"></div>
        <div class="sk sk-line w70"></div>
        <div class="sk sk-line w55"></div>
      </div>
    </div>`).join('') + `</div>`;
    }
    function emptyHTML(){
        return `<div class="empty-state">
    <div class="ic" aria-hidden="true">📦</div>
    <h3>Bạn chưa có đơn hàng nào</h3>
    <p>Đặt in 3D theo yêu cầu và theo dõi đơn hàng ngay tại đây.</p>
    <a class="btn-primary" href="dat_in_3d.jsp">Đặt đơn in</a>
  </div>`;
    }
    function noSearchHTML(){
        return `<div class="empty-state">
    <div class="ic" aria-hidden="true">🔍</div>
    <h3>Không tìm thấy đơn hàng</h3>
    <p>Không có đơn hàng phù hợp với từ khóa của bạn.</p>
    <button type="button" class="btn-primary" id="clearSearchBtn">Xóa tìm kiếm</button>
  </div>`;
    }
    function noFilterHTML(){
        return `<div class="empty-state">
    <div class="ic" aria-hidden="true">🧰</div>
    <h3>Không có đơn hàng phù hợp</h3>
    <p>Thử bỏ bớt bộ lọc để xem nhiều đơn hàng hơn.</p>
    <button type="button" class="btn-primary" id="clearFilterBtn">Xóa bộ lọc</button>
  </div>`;
    }
    function errorHTML(){
        return `<div class="error-state">
    <div class="ic" aria-hidden="true">⚠</div>
    <h3>Không thể tải danh sách đơn hàng.</h3>
    <p>Kết nối tới hệ thống đang gặp sự cố. Vui lòng thử lại.</p>
    <button type="button" class="btn-primary" id="retryBtn">Thử lại</button>
  </div>`;
    }
    function guestHTML(){
        // Link dang nhap that (PK.ctx lay tu site.js)
        return `<div class="empty-state">
    <div class="ic" aria-hidden="true">🔒</div>
    <h3>Vui lòng đăng nhập để xem đơn hàng.</h3>
    <p>Bạn cần đăng nhập để xem và theo dõi các đơn in 3D của mình.</p>
    <a class="btn-primary" href="${PK.ctx}/login">Đăng nhập</a>
  </div>`;
    }

    function renderList(){
        const host = $('listHost');
        if(state.loading){ host.innerHTML = skeletonHTML(); return; }
        if(!ORDERS.length){ host.innerHTML = emptyHTML(); return; }

        const list = visibleOrders();
        if(!list.length){
            host.innerHTML = state.q ? noSearchHTML() : noFilterHTML();
            const cs = $('clearSearchBtn');
            if(cs) cs.onclick = () => { state.q = ''; $('searchInput').value = ''; $('searchClear').hidden = true; state.page = 1; renderAll(); };
            const cf = $('clearFilterBtn');
            if(cf) cf.onclick = () => { clearFilters(); toastOk('Đã xóa bộ lọc'); };
            return;
        }

        const start = (state.page - 1) * state.pageSize;
        const pageList = list.slice(start, start + state.pageSize);
        host.innerHTML = `<div class="order-list">${pageList.map(cardHTML).join('')}</div>`;
    }

    function renderPagination(){
        const host = $('pagerHost');
        if(state.mode !== 'ok' || state.loading || !ORDERS.length){ host.innerHTML = ''; return; }
        const list = visibleOrders();
        if(!list.length){ host.innerHTML = ''; return; }
        const total = list.length;
        const pages = Math.max(1, Math.ceil(total / state.pageSize));
        if(state.page > pages) state.page = pages;
        const start = (state.page - 1) * state.pageSize + 1;
        const end = Math.min(total, state.page * state.pageSize);
        let btns = `<button type="button" data-page="${state.page - 1}" ${state.page === 1 ? 'disabled' : ''} aria-label="Trang trước">←</button>`;
        for(let i = 1; i <= pages; i++) btns += `<button type="button" data-page="${i}" class="${i === state.page ? 'active' : ''}" aria-current="${i === state.page ? 'page' : 'false'}">${i}</button>`;
        btns += `<button type="button" data-page="${state.page + 1}" ${state.page === pages ? 'disabled' : ''} aria-label="Trang sau">→</button>`;

        host.innerHTML = `
    <div class="pager">
      <div class="pager-label">Hiển thị <b>${start}–${end}</b> trong <b>${total}</b> đơn hàng</div>
      <div class="pager-controls">
        ${btns}
        <span class="page-size">Số đơn/trang
          <select id="pageSize" aria-label="Số đơn mỗi trang">
            ${[10,20,50].map(n => `<option value="${n}" ${n === state.pageSize ? 'selected' : ''}>${n}</option>`).join('')}
          </select>
        </span>
      </div>
    </div>`;
        host.querySelectorAll('[data-page]').forEach(b => b.onclick = () => {
            const p = +b.dataset.page;
            if(p < 1 || p > pages) return;
            state.page = p; renderList(); renderPagination();
            $('tabs').scrollIntoView({behavior:'smooth', block:'start'});
        });
        const ps = $('pageSize');
        if(ps) ps.onchange = () => { state.pageSize = +ps.value; state.page = 1; renderList(); renderPagination(); };
    }

    function renderAll(){
        // Chỉ hiện thanh công cụ/tab/summary khi đã có dữ liệu thật (không hiện khi loading/lỗi/trống/khách chưa đăng nhập)
        const showChrome = state.mode === 'ok' && !state.loading;
        $('toolbarWrap').hidden = !showChrome;
        $('tabs').style.display = showChrome ? '' : 'none';

        if(!showChrome){
            $('bannerHost').innerHTML = '';
            $('summaryGrid').innerHTML = '';
            $('activeFilters').innerHTML = '';
            $('filterCount').hidden = true;
            $('pagerHost').innerHTML = '';
            if(state.loading)                 $('listHost').innerHTML = skeletonHTML();
            else if(state.mode === 'empty')   $('listHost').innerHTML = emptyHTML();
            else if(state.mode === 'guest')   $('listHost').innerHTML = guestHTML();
            else {
                $('listHost').innerHTML = errorHTML();
                const r = $('retryBtn');
                if(r) r.onclick = () => { toast('Đang thử tải lại…'); load('ok'); };
            }
            return;
        }
        renderBanner();
        renderSummary();
        renderTabs();
        renderActiveFilters();
        renderList();
        renderPagination();
    }

    /* ============================================================
       7. ĐIỀU KHIỂN TAB / FILTER
       ============================================================ */
    function setTab(key){ state.tab = key; state.page = 1; renderAll(); }

    function clearFilters(){
        state.filters = {statuses:[], techs:[], time:'all', from:'', to:''};
        state.page = 1;
        renderFilterDrawer();
        renderAll();
    }
    function removeChip(kind, key){
        if(kind === 'statuses') state.filters.statuses = state.filters.statuses.filter(k => k !== key);
        else if(kind === 'techs') state.filters.techs = state.filters.techs.filter(t => t !== key);
        else if(kind === 'time'){ state.filters.time = 'all'; state.filters.from = ''; state.filters.to = ''; }
        state.page = 1;
        renderFilterDrawer();
        renderAll();
    }

    function renderFilterDrawer(){
        $('fStatus').innerHTML = STATUS_FILTERS.map(s => {
            const n = ORDERS.filter(o => filterStatusMatch(o, s.key)).length;
            return `<label class="fopt"><input type="checkbox" value="${s.key}" ${state.filters.statuses.includes(s.key) ? 'checked' : ''}> ${s.label} <span class="n">${n}</span></label>`;
        }).join('');
        $('fTech').innerHTML = TECH_OPTIONS.map(t => {
            const n = ORDERS.filter(o => o.technology === t).length;
            return `<label class="fopt"><input type="checkbox" value="${t}" ${state.filters.techs.includes(t) ? 'checked' : ''}> ${t} <span class="n">${n}</span></label>`;
        }).join('');
        $('fTime').innerHTML = TIME_OPTIONS.map(t => `
    <label class="fopt"><input type="radio" name="fTime" value="${t.key}" ${state.filters.time === t.key ? 'checked' : ''}> ${t.label}</label>`).join('');
        $('fRange').hidden = state.filters.time !== 'custom';
        $('fFrom').value = state.filters.from || '';
        $('fTo').value = state.filters.to || '';
    }
    // Mở / đóng drawer lọc bằng cơ chế chung của site.js (closeAll đóng mọi .drawer, .modal và #overlay)
    function openDrawer(){ renderFilterDrawer(); openModalById('filterDrawer'); }
    function closeDrawer(){ closeAll(); }

    function applyFilterDrawer(){
        const statuses = [...$('fStatus').querySelectorAll('input:checked')].map(i => i.value);
        const techs = [...$('fTech').querySelectorAll('input:checked')].map(i => i.value);
        const timeEl = $('fTime').querySelector('input[name="fTime"]:checked');
        const time = timeEl ? timeEl.value : 'all';
        let from = '', to = '';
        if(time === 'custom'){
            from = $('fFrom').value; to = $('fTo').value;
            if(from && to && from > to){ toast('Khoảng ngày không hợp lệ.', 'err'); return; }
        }
        state.filters = {statuses, techs, time, from, to};
        state.page = 1;
        closeDrawer();
        renderAll();
        toastOk('Đã áp dụng bộ lọc');
    }

    /* ============================================================
       8. DEMO BAR + LOADING / ERROR
       ============================================================ */
    const DEMO = [
        {key:'ok',    label:'Danh sách đơn hàng'},
        {key:'empty', label:'Chưa có đơn nào'},
        {key:'error', label:'Lỗi tải danh sách'},
        {key:'guest', label:'Chưa đăng nhập'}
    ];
    function renderDemoChips(){
        const box = $('demoChips');
        box.innerHTML = DEMO.map(d => `<button type="button" data-mode="${d.key}" class="${state.mode === d.key ? 'active' : ''}">${d.label}</button>`).join('');
        box.querySelectorAll('button').forEach(b => b.onclick = () => {
            state.tab = 'all'; state.q = ''; state.page = 1;
            state.filters = {statuses:[], techs:[], time:'all', from:'', to:''};
            $('searchInput').value = ''; $('searchClear').hidden = true;
            load(b.dataset.mode);
        });
    }

    function load(mode){
        state.mode = mode || 'ok';
        state.loading = true;
        renderDemoChips();
        renderAll();
        setTimeout(() => { state.loading = false; renderAll(); }, 520);
    }

    /* ============================================================
       9. GẮN SỰ KIỆN (không reload trang khi search/filter/sort/tab/page)
       ============================================================ */
    $('searchInput').addEventListener('input', e => {
        state.q = e.target.value.trim().toLowerCase();
        state.page = 1;
        $('searchClear').hidden = !state.q;
        renderList();
        renderPagination();
    });
    $('searchClear').onclick = () => {
        state.q = ''; $('searchInput').value = ''; $('searchClear').hidden = true; state.page = 1;
        renderList(); renderPagination(); $('searchInput').focus();
    };
    $('sortSelect').onchange = e => { state.sortSelect = e.target.value; state.page = 1; renderList(); renderPagination(); };
    $('filterBtn').onclick = openDrawer;
    $('drawerClose').onclick = closeDrawer;
    $('overlay').addEventListener('click', closeDrawer);
    $('filterApply').onclick = applyFilterDrawer;
    $('filterReset').onclick = () => { clearFilters(); toast('Đã đặt lại bộ lọc'); };
    $('fTime').addEventListener('change', e => {
        if(e.target.name === 'fTime') $('fRange').hidden = e.target.value !== 'custom';
    });
    /* Phím Esc đã được site.js xử lý (closeAll) */

    /* ============================================================
       10. KHỞI TẠO — hỗ trợ ?state=error|guest để test
       ============================================================ */
    (function init(){
        const mode = new URLSearchParams(location.search).get('state');
        load(['empty','error','guest'].includes(mode) ? mode : 'ok');
    })();
</script>
</body>
</html>
