<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn yêu cầu</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@600;700&family=Barlow:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
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
        ::-webkit-scrollbar{width:9px;height:9px;}
        ::-webkit-scrollbar-track{background:var(--steel-2);}
        ::-webkit-scrollbar-thumb{background:#3A4052;border-radius:9px;}
        ::-webkit-scrollbar-thumb:hover{background:var(--orange);}

        /* ===== Top bar ===== */
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
            width:34px; height:34px; border-radius:9px;
            background:var(--grad-hot);
            clip-path: polygon(50% 0%, 100% 100%, 0% 100%);
            filter:drop-shadow(0 0 12px var(--orange-glow));
        }
        .brand h1{font-size:24px; font-weight:700; color:white;}
        .brand span{font-size:12.5px; color:var(--muted); display:block; margin-top:-2px;}
        .shift-info{
            display:flex; align-items:center; gap:22px; font-size:13px; color:var(--muted); flex-wrap:wrap;
        }
        .shift-info .live{
            display:flex; align-items:center; gap:7px; color:var(--green); font-weight:600;
        }
        .shift-info .live .dot{width:8px; height:8px; border-radius:50%; background:var(--green); animation:pulse 1.6s infinite; box-shadow:0 0 10px var(--green);}
        @keyframes pulse{0%,100%{opacity:1; transform:scale(1);}50%{opacity:0.35; transform:scale(.8);}}
        .op-avatar{
            width:38px; height:38px; border-radius:50%; background:var(--grad-hot);
            display:flex; align-items:center; justify-content:center; font-weight:700; color:#1A1C22;
            cursor:pointer; transition:.18s; box-shadow:0 0 0 0 var(--orange-glow);
        }
        .op-avatar:hover{transform:scale(1.06); box-shadow:0 0 0 5px var(--orange-glow);}

        /* ===== Nav tabs ===== */
        .nav-tabs{
            background:linear-gradient(180deg,#1F222B,#1B1E26);
            border-bottom:1px solid var(--steel);
            padding:0 28px;
            display:flex; gap:4px; overflow-x:auto;
        }
        .nav-tabs button{
            background:transparent; border:none; color:var(--muted);
            padding:14px 18px; font-size:13.5px; font-weight:600;
            border-bottom:3px solid transparent; white-space:nowrap; transition:.18s;
        }
        .nav-tabs button:hover{color:var(--off);}
        .nav-tabs button.active{
            color:white;
            border-bottom:3px solid var(--orange);
            text-shadow:0 0 18px var(--orange-glow);
        }

        /* ===== Stat strip ===== */
        .stat-strip{
            display:grid; grid-template-columns:repeat(5,1fr);
            border-bottom:1px solid var(--steel);
            background:rgba(32,35,44,.5);
        }
        .stat{padding:20px 28px; border-right:1px solid var(--steel); position:relative; overflow:hidden;}
        .stat:last-child{border-right:none;}
        .stat:before{content:""; position:absolute; left:0; top:0; width:100%; height:2px; background:transparent; transition:.2s;}
        .stat:hover:before{background:var(--grad-hot);}
        .stat .cond{font-size:15px; color:var(--muted); text-transform:uppercase; letter-spacing:0.06em;}
        .stat .val{font-size:38px; font-weight:700; color:white; margin-top:4px;}
        .stat .val.orange{color:var(--orange); text-shadow:0 0 26px var(--orange-glow);}
        .stat .val.red{color:var(--red); text-shadow:0 0 26px rgba(251,90,106,.35);}
        .stat .val.green{color:var(--green); text-shadow:0 0 26px rgba(52,211,153,.35);}
        .stat .val.violet{color:var(--violet); text-shadow:0 0 26px rgba(139,92,246,.4);}
        .stat .sub{font-size:12.5px; color:var(--muted); margin-top:4px;}

        .content{padding:26px 28px 90px;}

        .section-title{
            display:flex; justify-content:space-between; align-items:center; margin-bottom:16px; flex-wrap:wrap; gap:12px;
        }
        .section-title h2{font-size:26px; color:white; font-weight:700;}
        .filter-tabs{display:flex; gap:8px; flex-wrap:wrap;}
        .filter-tabs button{
            background:var(--steel-2); border:1px solid var(--steel); color:var(--muted);
            padding:9px 16px; border-radius:8px; font-weight:600; font-size:13.5px; cursor:pointer; transition:.16s;
        }
        .filter-tabs button:hover{color:var(--off); border-color:#3C4358;}
        .filter-tabs button.active{background:var(--grad-hot); color:#1A1C22; border-color:transparent; box-shadow:0 4px 16px var(--orange-glow);}

        /* ===== Job queue kanban ===== */
        .queue{display:grid; grid-template-columns:repeat(5,1fr); gap:16px; margin-bottom:36px;}
        .queue-col{background:linear-gradient(180deg,var(--steel-3),var(--steel-2)); border-radius:14px; padding:16px; border:1px solid var(--steel);}
        .queue-col-head{display:flex; justify-content:space-between; align-items:center; margin-bottom:14px;}
        .queue-col-head h3{font-size:19px; color:white; font-weight:700; text-transform:uppercase; letter-spacing:0.03em;}
        .count-chip{background:var(--steel); color:var(--off); font-size:12px; font-weight:700; padding:3px 10px; border-radius:999px;}
        .queue-col.urgent-col .count-chip{background:var(--red); color:white; box-shadow:0 0 14px rgba(251,90,106,.5);}
        .queue-col.new-col .count-chip{background:var(--violet); color:white; box-shadow:0 0 14px rgba(139,92,246,.5);}

        .job-card{
            background:linear-gradient(180deg,#1D2029,#191C24);
            border:1px solid var(--steel); border-radius:11px;
            padding:14px; margin-bottom:12px; transition:.18s;
        }
        .job-card:hover{border-color:var(--orange); transform:translateY(-2px); box-shadow:0 8px 22px rgba(0,0,0,.35), 0 0 0 1px rgba(255,138,31,.15);}
        .job-card.urgent{border-color:var(--red); border-width:1.5px; box-shadow:0 0 0 1px rgba(251,90,106,.12);}
        .job-card.done-card{border-color:rgba(52,211,153,.55);}
        .job-card.done-card:hover{border-color:var(--green); box-shadow:0 8px 22px rgba(0,0,0,.35), 0 0 0 1px rgba(52,211,153,.2);}
        .job-top{display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:8px; gap:8px;}
        .job-id{font-family:'Barlow Condensed'; font-size:17px; font-weight:700; color:white;}
        .due{font-size:11.5px; font-weight:700; padding:3px 9px; border-radius:6px; white-space:nowrap;}
        .due.ok{background:rgba(52,211,153,0.16); color:var(--green);}
        .due.soon{background:rgba(255,138,31,0.16); color:var(--orange);}
        .due.late{background:rgba(251,90,106,0.16); color:var(--red);}
        .due.new{background:rgba(139,92,246,0.16); color:var(--violet);}
        .job-desc{font-size:13.5px; color:var(--off); margin-bottom:8px;}
        .job-meta{display:flex; justify-content:space-between; font-size:12px; color:var(--muted); margin-bottom:10px; flex-wrap:wrap; gap:4px;}
        .job-actions{display:flex; gap:8px; flex-wrap:wrap;}
        .job-actions button{
            flex:1; min-width:88px; padding:10px; border-radius:8px; font-weight:700; font-size:13px; cursor:pointer; border:none; transition:.16s;
        }
        .btn-start{background:var(--grad-hot); color:#1A1C22; box-shadow:0 4px 14px rgba(255,138,31,.28);}
        .btn-start:hover{filter:brightness(1.1); transform:translateY(-1px);}
        .btn-done{background:var(--grad-money); color:#0F1A15; box-shadow:0 4px 14px rgba(52,211,153,.25);}
        .btn-done:hover{filter:brightness(1.1); transform:translateY(-1px);}
        .btn-danger{background:rgba(251,90,106,.15); color:var(--red); border:1px solid rgba(251,90,106,.4) !important;}
        .btn-danger:hover{background:var(--red); color:#fff;}
        .btn-edit{background:rgba(139,92,246,.16); color:#B79BFF; border:1px solid rgba(139,92,246,.4) !important;}
        .btn-edit:hover{background:var(--violet); color:#fff;}
        .btn-ghost{background:transparent; border:1px solid var(--steel) !important; color:var(--off);}
        .btn-ghost:hover{border-color:var(--orange) !important; color:var(--orange);}

        /* ===== Alerts + Timeline ===== */
        .bottom-grid{display:grid; grid-template-columns:1.3fr 1fr; gap:18px; margin-bottom:18px;}
        .panel{
            background:linear-gradient(180deg,var(--steel-3),var(--steel-2));
            border:1px solid var(--steel); border-radius:14px; padding:18px 20px;
        }
        .panel h3{font-size:19px; color:white; font-weight:700; margin-bottom:14px; text-transform:uppercase; letter-spacing:0.03em;}
        .panel-head{display:flex; justify-content:space-between; align-items:center; margin-bottom:14px;}
        .panel-head h3{margin-bottom:0;}
        .panel-head a{font-size:12.5px; color:var(--orange); font-weight:600;}
        .panel-head a:hover{text-decoration:underline;}

        .alert-row{
            display:flex; align-items:center; gap:12px; padding:12px 14px;
            background:rgba(251,90,106,0.08); border:1px solid rgba(251,90,106,0.3);
            border-radius:11px; margin-bottom:10px; font-size:13px;
        }
        .alert-row.warn{background:rgba(255,138,31,0.08); border-color:rgba(255,138,31,0.3);}
        .alert-row.info{background:rgba(96,165,250,0.08); border-color:rgba(96,165,250,0.3);}
        .alert-row.good{background:rgba(52,211,153,0.08); border-color:rgba(52,211,153,0.3);}
        .alert-row .ic{font-size:18px; flex-shrink:0;}
        .alert-row .txt{flex:1; color:var(--off); min-width:0;}
        .alert-row .txt strong{color:white; display:block; font-size:13.5px;}
        .alert-row .txt span{font-size:12px; color:var(--muted);}
        .alert-row button{
            background:transparent; border:1px solid var(--steel); color:var(--off);
            padding:6px 12px; border-radius:8px; font-size:12px; font-weight:600; transition:.16s; white-space:nowrap;
        }
        .alert-row button:hover{border-color:var(--orange); color:var(--orange);}

        /* ===== Timeline ===== */
        .timeline{position:relative; padding-left:22px;}
        .timeline:before{content:""; position:absolute; left:5px; top:4px; bottom:4px; width:2px; background:var(--steel);}
        .tl-item{position:relative; padding-bottom:16px;}
        .tl-item:last-child{padding-bottom:0;}
        .tl-item:before{content:""; position:absolute; left:-22px; top:4px; width:12px; height:12px; border-radius:50%; background:var(--steel); border:2px solid var(--steel-2);}
        .tl-item.done:before{background:var(--green); box-shadow:0 0 10px rgba(52,211,153,.6);}
        .tl-item.active:before{background:var(--orange); box-shadow:0 0 0 4px rgba(255,138,31,0.15), 0 0 14px var(--orange-glow);}
        .tl-item .tl-txt{font-size:13.5px; color:var(--off);}
        .tl-item .tl-time{font-size:11.5px; color:var(--muted); margin-top:2px;}

        /* ===== Machine meter (progress bar trong job-card) ===== */
        .machine-meter{height:6px; background:#14161C; border-radius:999px; overflow:hidden; margin-top:6px;}
        .machine-meter div{height:100%; border-radius:999px; transition:width .4s;}

        /* ===== Modal ===== */
        .overlay{position:fixed; inset:0; background:rgba(8,9,13,0.72); backdrop-filter:blur(3px); opacity:0; pointer-events:none; transition:.2s; z-index:90;}
        .overlay.show{opacity:1; pointer-events:auto;}
        .modal{
            position:fixed; inset:0; display:flex; align-items:center; justify-content:center; z-index:100;
            opacity:0; pointer-events:none; transition:.2s; padding:20px;
        }
        .modal.show{opacity:1; pointer-events:auto;}
        .modal-box{
            background:linear-gradient(180deg,#262A35,#1E2129);
            border:1px solid var(--steel); border-radius:16px;
            padding:26px; width:560px; max-width:100%; max-height:90vh; overflow-y:auto;
            box-shadow:0 24px 60px rgba(0,0,0,.6);
        }
        .modal-box h3{font-size:24px; color:white; margin-bottom:6px;}
        .modal-box .sub{font-size:13px; color:var(--muted); margin-bottom:20px;}
        .modal-close{position:absolute; top:16px; right:18px; background:none; border:none; font-size:20px; color:var(--muted); transition:.15s;}
        .modal-close:hover{color:var(--red);}
        .modal-head{position:relative;}
        .detail-grid{display:grid; grid-template-columns:1fr 1fr; gap:14px; margin-bottom:18px;}
        .detail-grid .field{background:#181B22; border-radius:10px; padding:12px 14px; border:1px solid #232734;}
        .detail-grid .field label{font-size:11px; text-transform:uppercase; letter-spacing:0.05em; color:var(--muted); display:block; margin-bottom:4px;}
        .detail-grid .field strong{font-size:14.5px; color:white; font-weight:600;}

        /* ===== Form fields ===== */
        .form-field{margin-bottom:14px;}
        .form-field label{display:block; font-size:11.5px; text-transform:uppercase; letter-spacing:.06em; color:var(--muted); margin-bottom:6px; font-weight:600;}
        .form-field input, .form-field select, .form-field textarea{
            width:100%; background:#181B22; border:1px solid var(--steel); border-radius:9px;
            padding:11px 13px; color:var(--off); font-family:inherit; font-size:13.5px; outline:none; transition:.16s;
        }
        .form-field input:focus, .form-field select:focus, .form-field textarea:focus{
            border-color:var(--orange); box-shadow:0 0 0 3px rgba(255,138,31,.15);
        }
        .form-field textarea{resize:vertical; min-height:78px;}
        .radio-list{display:flex; flex-direction:column; gap:8px;}
        .radio-list label{
            display:flex; align-items:center; gap:10px; background:#181B22; border:1px solid var(--steel);
            padding:11px 13px; border-radius:9px; font-size:13.5px; cursor:pointer; transition:.16s;
            text-transform:none; letter-spacing:0; font-weight:400; color:var(--off); margin-bottom:0;
        }
        .radio-list label:hover{border-color:var(--orange);}
        .radio-list input{accent-color:var(--orange); width:16px; height:16px;}

        /* ===== Toast ===== */
        .toast{
            position:fixed; bottom:26px; left:50%; transform:translate(-50%,90px);
            background:var(--grad-hot); color:#1A1C22; padding:13px 24px; border-radius:11px;
            font-size:14px; font-weight:700; z-index:200; transition:.25s; opacity:0;
            box-shadow:0 12px 34px rgba(255,138,31,.4); max-width:90vw; text-align:center;
        }
        .toast.show{transform:translate(-50%,0); opacity:1;}

        /* ===== Responsive ===== */
        @media (max-width:1200px){
            .queue{grid-template-columns:repeat(2,1fr);}
            .stat-strip{grid-template-columns:repeat(2,1fr);}
            .stat{border-bottom:1px solid var(--steel);}
        }
        @media (max-width:760px){
            .queue{grid-template-columns:1fr;}
            .bottom-grid{grid-template-columns:1fr !important;}
            .stat-strip{grid-template-columns:1fr;}
            .detail-grid{grid-template-columns:1fr;}
            .content{padding:20px 16px 100px;}
            .topbar{padding:12px 16px;}
            .nav-tabs{padding:0 16px;}
        }
    </style>
</head>
<body>

<div class="topbar">
    <div class="brand">
        <span class="mark"></span>
        <div><h1>Sài Gòn Print</h1><span>Cổng xưởng sản xuất · PrintKraft</span></div>
    </div>
    <div class="shift-info">
        <div class="live"><span class="dot"></span> Ca sáng · 06:00–14:00</div>
        <div>Thứ Ba, 15/09/2026 — <span id="clock">10:42</span></div>
        <div class="op-avatar" onclick="openModal('profileModal')">ĐL</div>
    </div>
</div>

<!-- Nav tabs -->
<div class="nav-tabs">
    <button onclick="toast('Quay lại Bảng sản xuất')">Bảng sản xuất</button>
    <button class="active">📋 Đơn yêu cầu</button>
    <button onclick="toast('Quay lại Máy móc')">Máy móc</button>
    <button onclick="toast('Quay lại Vật tư')">Vật tư</button>
    <button onclick="toast('Quay lại Kiểm tra chất lượng')">Kiểm tra chất lượng</button>
    <button onclick="toast('Quay lại Lịch ca')">Lịch ca</button>
    <button onclick="toast('Quay lại Doanh thu')">💰 Doanh thu</button>
    <button onclick="toast('Quay lại Mẫu bán sẵn')">🛍️ Mẫu bán sẵn</button>
    <button onclick="toast('Quay lại Hỗ trợ & Đổi trả')">🎧 Hỗ trợ &amp; Đổi trả</button>
</div>

<div class="stat-strip">
    <div class="stat">
        <div class="cond">Việc chờ xử lý</div>
        <div class="val">18</div>
        <div class="sub">4 đơn ưu tiên cao</div>
    </div>
    <div class="stat">
        <div class="cond">Đang sản xuất</div>
        <div class="val orange">7</div>
        <div class="sub">3 máy in đang chạy</div>
    </div>
    <div class="stat">
        <div class="cond">Trễ hạn giao</div>
        <div class="val red">2</div>
        <div class="sub">Cần xử lý ngay</div>
    </div>
    <div class="stat">
        <div class="cond">Hoàn tất hôm nay</div>
        <div class="val green">24</div>
        <div class="sub">Mục tiêu ca: 30</div>
    </div>
    <div class="stat">
        <div class="cond">Doanh thu hôm nay</div>
        <div class="val violet">18.4tr</div>
        <div class="sub">▲ 12% so với hôm qua</div>
    </div>
</div>

<div class="content">

    <div class="section-title">
        <h2>Đơn yêu cầu chỉnh sửa / hủy</h2>
        <div class="filter-tabs">
            <button class="active" onclick="pickFilter(this)">Chờ duyệt (2)</button>
            <button onclick="pickFilter(this)">Đã xử lý</button>
        </div>
    </div>

    <div class="bottom-grid" style="grid-template-columns:1.4fr 1fr;">
        <div class="panel">
            <h3>Yêu cầu đang chờ duyệt</h3>

            <div class="job-card" data-req="#PK-08231" style="margin-bottom:14px;">
                <div class="job-top"><span class="job-id">#PK-08231</span><span class="due new">Yêu cầu chỉnh sửa</span></div>
                <div class="job-desc">Áo thun Oversize — 24 chiếc · Minh Anh Store</div>
                <div class="job-meta"><span>Nội dung: Tăng từ 24 lên 30 áo, thêm size XL</span><span>Gửi lúc: 10:12</span></div>
                <div class="job-actions">
                    <button class="btn-done" onclick="approveOrderRequest(this,'#PK-08231','edit')">✓ Duyệt chỉnh sửa</button>
                    <button class="btn-danger" onclick="rejectOrderRequest(this,'#PK-08231','edit')">✕ Từ chối</button>
                    <button class="btn-ghost" onclick="toast('Đang mở khung chat với Minh Anh Store...')">Liên hệ khách</button>
                </div>
            </div>

            <div class="job-card" data-req="#PK-08233">
                <div class="job-top"><span class="job-id">#PK-08233</span><span class="due late">Yêu cầu hủy đơn</span></div>
                <div class="job-desc">Túi vải canvas — 80 chiếc · The Coffee House X</div>
                <div class="job-meta"><span>Lý do: Tìm được nhà cung cấp khác</span><span>Phí hủy: 30% (đã sản xuất)</span></div>
                <div class="job-actions">
                    <button class="btn-done" onclick="approveOrderRequest(this,'#PK-08233','cancel')">✓ Duyệt hủy đơn</button>
                    <button class="btn-danger" onclick="rejectOrderRequest(this,'#PK-08233','cancel')">✕ Từ chối</button>
                    <button class="btn-ghost" onclick="toast('Đang mở khung chat với The Coffee House X...')">Liên hệ khách</button>
                </div>
            </div>
        </div>

        <div style="display:flex; flex-direction:column; gap:18px;">
            <div class="panel">
                <h3>Thống kê yêu cầu hôm nay</h3>
                <div class="detail-grid" style="grid-template-columns:1fr 1fr;">
                    <div class="field"><label>Tổng yêu cầu</label><strong>2</strong></div>
                    <div class="field"><label>Đã duyệt</label><strong style="color:var(--green);">0</strong></div>
                    <div class="field"><label>Đã từ chối</label><strong style="color:var(--red);">0</strong></div>
                    <div class="field"><label>Chờ xử lý</label><strong style="color:var(--violet);">2</strong></div>
                </div>
            </div>

            <div class="panel">
                <h3>Lưu ý duyệt yêu cầu</h3>
                <div class="alert-row info">
                    <span class="ic">✎</span>
                    <div class="txt"><strong>Yêu cầu chỉnh sửa</strong><span>Kiểm tra máy còn kịp đổi vật tư/thiết kế trước khi duyệt</span></div>
                </div>
                <div class="alert-row warn">
                    <span class="ic">✕</span>
                    <div class="txt"><strong>Yêu cầu hủy đơn</strong><span>Nếu đã sản xuất, khách chịu phí hủy 30% theo chính sách</span></div>
                </div>
            </div>
        </div>
    </div>

</div>

<div class="overlay" id="overlay" onclick="closeAll()"></div>

<!-- ===== PROFILE MODAL ===== -->
<div class="modal" id="profileModal">
    <div class="modal-box" style="width:420px;">
        <div class="modal-head">
            <button class="modal-close" onclick="closeAll()">✕</button>
            <h3>Đặng Long</h3>
            <div class="sub">Quản lý ca sản xuất · Sài Gòn Print</div>
        </div>
        <div class="detail-grid" style="grid-template-columns:1fr 1fr;">
            <div class="field"><label>Ca hiện tại</label><strong>Ca sáng</strong></div>
            <div class="field"><label>Bắt đầu</label><strong>06:00</strong></div>
            <div class="field"><label>Đơn đã xử lý</label><strong>24 hôm nay</strong></div>
            <div class="field"><label>Hiệu suất</label><strong style="color:var(--green);">96%</strong></div>
        </div>
        <div style="display:flex; gap:10px; margin-top:6px;">
            <button class="btn-ghost" style="flex:1; padding:11px; border-radius:9px; font-weight:700;" onclick="toast('Đã đăng xuất')">Đăng xuất</button>
            <button class="btn-start" style="flex:1; padding:11px; border-radius:9px; font-weight:700; border:none;" onclick="closeAll()">Đóng</button>
        </div>
    </div>
</div>

<div class="toast" id="toast">Đã thực hiện</div>

<script>
    /* ---------- Clock ---------- */
    function tick(){
        const d = new Date();
        const hh = String(d.getHours()).padStart(2,'0');
        const mm = String(d.getMinutes()).padStart(2,'0');
        document.getElementById('clock').textContent = hh + ':' + mm;
    }
    tick(); setInterval(tick, 30000);

    /* ---------- Toast ---------- */
    let toastTimer;
    function toast(msg){
        const t = document.getElementById('toast');
        t.textContent = msg;
        t.classList.add('show');
        clearTimeout(toastTimer);
        toastTimer = setTimeout(()=>t.classList.remove('show'), 2400);
    }

    /* ---------- Filter tabs ---------- */
    function pickFilter(btn){
        btn.parentElement.querySelectorAll('button').forEach(b=>b.classList.remove('active'));
        btn.classList.add('active');
    }

    /* ---------- Modal ---------- */
    function openModal(id){
        document.getElementById(id).classList.add('show');
        document.getElementById('overlay').classList.add('show');
    }
    function closeAll(){
        document.querySelectorAll('.modal, .overlay').forEach(el=>el.classList.remove('show'));
    }
    document.addEventListener('keydown', e=>{ if(e.key === 'Escape') closeAll(); });

    /* ---------- Duyệt / Từ chối yêu cầu chỉnh sửa & hủy đơn ---------- */
    function approveOrderRequest(btn, id, type){
        const card = btn.closest('.job-card');
        card.style.opacity = '0.4';
        card.style.pointerEvents = 'none';
        toast(type === 'edit'
            ? 'Đã duyệt yêu cầu chỉnh sửa ' + id + ' — đơn sẽ được cập nhật'
            : 'Đã duyệt hủy đơn ' + id + ' — dừng sản xuất, khách hàng sẽ được thông báo');
    }

    function rejectOrderRequest(btn, id, type){
        const card = btn.closest('.job-card');
        card.style.opacity = '0.3';
        card.style.pointerEvents = 'none';
        card.style.filter = 'grayscale(.7)';
        toast(type === 'edit'
            ? 'Đã từ chối yêu cầu chỉnh sửa ' + id + ' — đơn tiếp tục theo kế hoạch ban đầu'
            : 'Đã từ chối yêu cầu hủy ' + id + ' — đơn tiếp tục sản xuất');
    }
</script>
</body>
</html>