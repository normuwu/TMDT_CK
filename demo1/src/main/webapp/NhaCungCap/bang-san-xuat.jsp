<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bảng sản xuất</title>
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
    <button class="active">Bảng sản xuất</button>
    <button onclick="toast('Quay lại Đơn yêu cầu')">📋 Đơn yêu cầu</button>
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
        <h2>Hàng đợi sản xuất</h2>
        <div class="filter-tabs">
            <button class="active" onclick="pickFilter(this)">Tất cả</button>
            <button onclick="pickFilter(this)">Ưu tiên cao</button>
            <button onclick="pickFilter(this)">Áo thun</button>
            <button onclick="pickFilter(this)">Cốc sứ</button>
            <button onclick="pickFilter(this)">Poster</button>
        </div>
    </div>

    <div class="queue">
        <!-- Đơn hàng mới -->
        <div class="queue-col new-col">
            <div class="queue-col-head"><h3>Đơn hàng mới</h3><span class="count-chip">3</span></div>

            <div class="job-card" data-job="#PK-08242">
                <div class="job-top"><span class="job-id">#PK-08242</span><span class="due new">Mới · 5 phút trước</span></div>
                <div class="job-desc">Ốp lưng điện thoại in UV — 50 chiếc</div>
                <div class="job-meta"><span>Thảo Nguyên Shop</span><span>Hẹn giao: 18/09</span></div>
                <div class="job-actions">
                    <button class="btn-done" onclick="acceptOrder(this,'#PK-08242')">✓ Nhận đơn</button>
                    <button class="btn-ghost" onclick="openJobModal('#PK-08242','Ốp lưng điện thoại in UV — 50 chiếc','Thảo Nguyên Shop','Chưa gán máy','Đơn mới · chờ nhận','new')">Chi tiết</button>
                </div>
                <div class="job-actions" style="margin-top:8px;">
                    <button class="btn-danger" style="flex:1;" onclick="rejectOrder(this,'#PK-08242')">✕ Từ chối đơn</button>
                </div>
            </div>

            <div class="job-card" data-job="#PK-08243">
                <div class="job-top"><span class="job-id">#PK-08243</span><span class="due new">Mới · 20 phút trước</span></div>
                <div class="job-desc">Bình giữ nhiệt in logo — 100 chiếc</div>
                <div class="job-meta"><span>Xanh Coffee</span><span>Hẹn giao: 20/09</span></div>
                <div class="job-actions">
                    <button class="btn-done" onclick="acceptOrder(this,'#PK-08243')">✓ Nhận đơn</button>
                    <button class="btn-ghost" onclick="openJobModal('#PK-08243','Bình giữ nhiệt in logo — 100 chiếc','Xanh Coffee','Chưa gán máy','Đơn mới · chờ nhận','new')">Chi tiết</button>
                </div>
                <div class="job-actions" style="margin-top:8px;">
                    <button class="btn-danger" style="flex:1;" onclick="rejectOrder(this,'#PK-08243')">✕ Từ chối đơn</button>
                </div>
            </div>

            <div class="job-card" data-job="#PK-08244">
                <div class="job-top"><span class="job-id">#PK-08244</span><span class="due new">Mới · 1 giờ trước</span></div>
                <div class="job-desc">Sổ tay bìa da khắc laser — 30 quyển</div>
                <div class="job-meta"><span>Gia Hân Boutique</span><span>Hẹn giao: 22/09</span></div>
                <div class="job-actions">
                    <button class="btn-done" onclick="acceptOrder(this,'#PK-08244')">✓ Nhận đơn</button>
                    <button class="btn-ghost" onclick="openJobModal('#PK-08244','Sổ tay bìa da khắc laser — 30 quyển','Gia Hân Boutique','Chưa gán máy','Đơn mới · chờ nhận','new')">Chi tiết</button>
                </div>
                <div class="job-actions" style="margin-top:8px;">
                    <button class="btn-danger" style="flex:1;" onclick="rejectOrder(this,'#PK-08244')">✕ Từ chối đơn</button>
                </div>
            </div>
        </div>

        <!-- Chờ xử lý -->
        <div class="queue-col urgent-col">
            <div class="queue-col-head"><h3>Chờ xử lý</h3><span class="count-chip">18</span></div>

            <div class="job-card urgent" data-job="#PK-08230">
                <div class="job-top"><span class="job-id">#PK-08230</span><span class="due late">Trễ 6h</span></div>
                <div class="job-desc">Áo thun DTG — 120 chiếc, 3 màu size</div>
                <div class="job-meta"><span>Local Brand Co.</span><span>Máy: DTG-02</span></div>
                <div class="job-actions">
                    <button class="btn-start" onclick="startJob(this,'#PK-08230')">Bắt đầu in</button>
                    <button class="btn-ghost" onclick="openJobModal('#PK-08230','Áo thun DTG — 120 chiếc, 3 màu size','Local Brand Co.','DTG-02','Trễ 6h','late')">Chi tiết</button>
                </div>
                <div class="job-actions" style="margin-top:8px;">
                    <button class="btn-edit" onclick="openEditJob('#PK-08230','Áo thun DTG — 120 chiếc, 3 màu size')">✎ Sửa đơn</button>
                    <button class="btn-danger" onclick="openCancelJob('#PK-08230','Áo thun DTG — 120 chiếc')">✕ Hủy đơn</button>
                </div>
            </div>

            <div class="job-card" data-job="#PK-08235">
                <div class="job-top"><span class="job-id">#PK-08235</span><span class="due soon">Còn 2h</span></div>
                <div class="job-desc">Cốc sứ Sublimation — 200 chiếc</div>
                <div class="job-meta"><span>Quà Tặng Việt</span><span>Máy: SUB-01</span></div>
                <div class="job-actions">
                    <button class="btn-start" onclick="startJob(this,'#PK-08235')">Bắt đầu in</button>
                    <button class="btn-ghost" onclick="openJobModal('#PK-08235','Cốc sứ Sublimation — 200 chiếc','Quà Tặng Việt','SUB-01','Còn 2h','soon')">Chi tiết</button>
                </div>
                <div class="job-actions" style="margin-top:8px;">
                    <button class="btn-edit" onclick="openEditJob('#PK-08235','Cốc sứ Sublimation — 200 chiếc')">✎ Sửa đơn</button>
                    <button class="btn-danger" onclick="openCancelJob('#PK-08235','Cốc sứ Sublimation — 200 chiếc')">✕ Hủy đơn</button>
                </div>
            </div>

            <div class="job-card" data-job="#PK-08237">
                <div class="job-top"><span class="job-id">#PK-08237</span><span class="due ok">Còn 8h</span></div>
                <div class="job-desc">Poster A2 UV — 40 tờ</div>
                <div class="job-meta"><span>Minh Anh Store</span><span>Máy: UV-01</span></div>
                <div class="job-actions">
                    <button class="btn-start" onclick="startJob(this,'#PK-08237')">Bắt đầu in</button>
                    <button class="btn-ghost" onclick="openJobModal('#PK-08237','Poster A2 UV — 40 tờ','Minh Anh Store','UV-01','Còn 8h','ok')">Chi tiết</button>
                </div>
                <div class="job-actions" style="margin-top:8px;">
                    <button class="btn-edit" onclick="openEditJob('#PK-08237','Poster A2 UV — 40 tờ')">✎ Sửa đơn</button>
                    <button class="btn-danger" onclick="openCancelJob('#PK-08237','Poster A2 UV — 40 tờ')">✕ Hủy đơn</button>
                </div>
            </div>

            <div class="job-card" data-job="#PK-08240">
                <div class="job-top"><span class="job-id">#PK-08240</span><span class="due ok">Còn 12h</span></div>
                <div class="job-desc">Túi vải canvas — 60 chiếc</div>
                <div class="job-meta"><span>The Coffee House X</span><span>Máy: SILK-01</span></div>
                <div class="job-actions">
                    <button class="btn-start" onclick="startJob(this,'#PK-08240')">Bắt đầu in</button>
                    <button class="btn-ghost" onclick="openJobModal('#PK-08240','Túi vải canvas — 60 chiếc','The Coffee House X','SILK-01','Còn 12h','ok')">Chi tiết</button>
                </div>
                <div class="job-actions" style="margin-top:8px;">
                    <button class="btn-edit" onclick="openEditJob('#PK-08240','Túi vải canvas — 60 chiếc')">✎ Sửa đơn</button>
                    <button class="btn-danger" onclick="openCancelJob('#PK-08240','Túi vải canvas — 60 chiếc')">✕ Hủy đơn</button>
                </div>
            </div>
        </div>

        <!-- Đang sản xuất -->
        <div class="queue-col">
            <div class="queue-col-head"><h3>Đang sản xuất</h3><span class="count-chip">7</span></div>

            <div class="job-card" data-job="#PK-08231">
                <div class="job-top"><span class="job-id">#PK-08231</span><span class="due ok">Còn 3h</span></div>
                <div class="job-desc">Áo thun Oversize — 24 chiếc</div>
                <div class="job-meta"><span>Minh Anh Store</span><span>Máy: DTG-01</span></div>
                <div class="machine-meter" style="width:100%;"><div style="width:62%; background:var(--green);"></div></div>
                <div class="job-actions" style="margin-top:10px;">
                    <button class="btn-done" onclick="finishJob(this,'#PK-08231')">Đánh dấu xong</button>
                    <button class="btn-ghost" onclick="openJobModal('#PK-08231','Áo thun Oversize — 24 chiếc','Minh Anh Store','DTG-01','Còn 3h','ok')">Chi tiết</button>
                </div>
                <div class="job-actions" style="margin-top:8px;">
                    <button class="btn-edit" onclick="openEditJob('#PK-08231','Áo thun Oversize — 24 chiếc')">✎ Sửa giữa chừng</button>
                    <button class="btn-danger" onclick="openCancelJob('#PK-08231','Áo thun Oversize — 24 chiếc')">✕ Hủy</button>
                </div>
            </div>

            <div class="job-card" data-job="#PK-08233">
                <div class="job-top"><span class="job-id">#PK-08233</span><span class="due ok">Còn 5h</span></div>
                <div class="job-desc">Túi vải canvas — 80 chiếc</div>
                <div class="job-meta"><span>The Coffee House X</span><span>Máy: SILK-01</span></div>
                <div class="machine-meter" style="width:100%;"><div style="width:38%; background:var(--green);"></div></div>
                <div class="job-actions" style="margin-top:10px;">
                    <button class="btn-done" onclick="finishJob(this,'#PK-08233')">Đánh dấu xong</button>
                    <button class="btn-ghost" onclick="openJobModal('#PK-08233','Túi vải canvas — 80 chiếc','The Coffee House X','SILK-01','Còn 5h','ok')">Chi tiết</button>
                </div>
                <div class="job-actions" style="margin-top:8px;">
                    <button class="btn-edit" onclick="openEditJob('#PK-08233','Túi vải canvas — 80 chiếc')">✎ Sửa giữa chừng</button>
                    <button class="btn-danger" onclick="openCancelJob('#PK-08233','Túi vải canvas — 80 chiếc')">✕ Hủy</button>
                </div>
            </div>

            <div class="job-card" data-job="#PK-08232">
                <div class="job-top"><span class="job-id">#PK-08232</span><span class="due soon">Còn 1.5h</span></div>
                <div class="job-desc">Cốc sứ Sublimation — 150 chiếc</div>
                <div class="job-meta"><span>Quà Tặng Việt</span><span>Máy: SUB-01</span></div>
                <div class="machine-meter" style="width:100%;"><div style="width:85%; background:var(--orange);"></div></div>
                <div class="job-actions" style="margin-top:10px;">
                    <button class="btn-done" onclick="finishJob(this,'#PK-08232')">Đánh dấu xong</button>
                    <button class="btn-ghost" onclick="openJobModal('#PK-08232','Cốc sứ Sublimation — 150 chiếc','Quà Tặng Việt','SUB-01','Còn 1.5h','soon')">Chi tiết</button>
                </div>
                <div class="job-actions" style="margin-top:8px;">
                    <button class="btn-edit" onclick="openEditJob('#PK-08232','Cốc sứ Sublimation — 150 chiếc')">✎ Sửa giữa chừng</button>
                    <button class="btn-danger" onclick="openCancelJob('#PK-08232','Cốc sứ Sublimation — 150 chiếc')">✕ Hủy</button>
                </div>
            </div>
        </div>

        <!-- Kiểm tra chất lượng -->
        <div class="queue-col">
            <div class="queue-col-head"><h3>Kiểm tra chất lượng</h3><span class="count-chip">3</span></div>

            <div class="job-card" data-job="#PK-08229">
                <div class="job-top"><span class="job-id">#PK-08229</span><span class="due ok">Sẵn sàng</span></div>
                <div class="job-desc">Cốc sứ — 30 chiếc</div>
                <div class="job-meta"><span>Nguyễn Thảo</span><span>QC: Chờ duyệt</span></div>
                <div class="job-actions">
                    <button class="btn-done" onclick="approveQC(this,'#PK-08229')">Duyệt &amp; đóng gói</button>
                    <button class="btn-ghost" onclick="openJobModal('#PK-08229','Cốc sứ — 30 chiếc','Nguyễn Thảo','SUB-01','Sẵn sàng','ok')">Chi tiết</button>
                </div>
                <div class="job-actions" style="margin-top:8px;">
                    <button class="btn-danger" onclick="openReturnModal('#PK-08229','Cốc sứ — 30 chiếc')">↩ Yêu cầu trả hàng</button>
                </div>
            </div>

            <div class="job-card" data-job="#PK-08226">
                <div class="job-top"><span class="job-id">#PK-08226</span><span class="due ok">Sẵn sàng</span></div>
                <div class="job-desc">Namecard — 500 tấm</div>
                <div class="job-meta"><span>Cần Thơ Store</span><span>QC: Chờ duyệt</span></div>
                <div class="job-actions">
                    <button class="btn-done" onclick="approveQC(this,'#PK-08226')">Duyệt &amp; đóng gói</button>
                    <button class="btn-ghost" onclick="openJobModal('#PK-08226','Namecard — 500 tấm','Cần Thơ Store','UV-01','Sẵn sàng','ok')">Chi tiết</button>
                </div>
                <div class="job-actions" style="margin-top:8px;">
                    <button class="btn-danger" onclick="openReturnModal('#PK-08226','Namecard — 500 tấm')">↩ Yêu cầu trả hàng</button>
                </div>
            </div>
        </div>

        <!-- Hoàn tất hôm nay -->
        <div class="queue-col">
            <div class="queue-col-head"><h3>Hoàn tất hôm nay</h3><span class="count-chip">24</span></div>

            <div class="job-card done-card" data-job="#PK-08238">
                <div class="job-top"><span class="job-id">#PK-08238</span><span class="due new">Chờ bàn giao</span></div>
                <div class="job-desc">Cốc sứ 350ml — 60 chiếc</div>
                <div class="job-meta"><span>Cần Thơ Store</span><span>SUB-01 · 11:20</span></div>
                <div class="job-actions" style="margin-top:8px;">
                    <button class="btn-start" onclick="openHandoverModal('#PK-08238','Cốc sứ 350ml — 60 chiếc')">📦 Bàn giao đơn</button>
                    <button class="btn-ghost" onclick="openJobModal('#PK-08238','Cốc sứ 350ml — 60 chiếc','Cần Thơ Store','SUB-01','Chờ bàn giao','new')">Chi tiết</button>
                </div>
            </div>

            <div class="job-card done-card">
                <div class="job-top"><span class="job-id">#PK-08225</span><span class="due ok">Đã giao</span></div>
                <div class="job-desc">Poster A2 — 100 tờ</div>
                <div class="job-meta"><span>Minh Anh Store</span><span>UV-01 · 10:15</span></div>
                <div class="job-actions" style="margin-top:8px;">
                    <button class="btn-ghost" onclick="openReturnModal('#PK-08225','Poster A2 — 100 tờ')">↩ Đổi/Trả</button>
                    <button class="btn-ghost" onclick="openJobModal('#PK-08225','Poster A2 — 100 tờ','Minh Anh Store','UV-01','Đã giao','ok')">Chi tiết</button>
                </div>
            </div>

            <div class="job-card done-card">
                <div class="job-top"><span class="job-id">#PK-08224</span><span class="due ok">Đã giao</span></div>
                <div class="job-desc">Áo thun DTG — 36 chiếc</div>
                <div class="job-meta"><span>Local Brand Co.</span><span>DTG-01 · 09:40</span></div>
                <div class="job-actions" style="margin-top:8px;">
                    <button class="btn-ghost" onclick="openReturnModal('#PK-08224','Áo thun DTG — 36 chiếc')">↩ Đổi/Trả</button>
                    <button class="btn-ghost" onclick="openJobModal('#PK-08224','Áo thun DTG — 36 chiếc','Local Brand Co.','DTG-01','Đã giao','ok')">Chi tiết</button>
                </div>
            </div>

            <div class="job-card done-card">
                <div class="job-top"><span class="job-id">#PK-08223</span><span class="due ok">Đã giao</span></div>
                <div class="job-desc">Cốc sứ — 80 chiếc</div>
                <div class="job-meta"><span>Quà Tặng Việt</span><span>SUB-01 · 08:55</span></div>
                <div class="job-actions" style="margin-top:8px;">
                    <button class="btn-ghost" onclick="openReturnModal('#PK-08223','Cốc sứ — 80 chiếc')">↩ Đổi/Trả</button>
                    <button class="btn-ghost" onclick="openJobModal('#PK-08223','Cốc sứ — 80 chiếc','Quà Tặng Việt','SUB-01','Đã giao','ok')">Chi tiết</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Alerts + Timeline -->
    <div class="bottom-grid">
        <div class="panel">
            <div class="panel-head"><h3>Cảnh báo vận hành</h3><a href="#" onclick="toast('Đã đánh dấu tất cả đã đọc');return false;">Đánh dấu đã đọc</a></div>

            <div class="alert-row">
                <span class="ic">⚠️</span>
                <div class="txt"><strong>#PK-08230 trễ hạn 6 giờ</strong><span>Áo thun DTG · 120 chiếc · Local Brand Co.</span></div>
                <button onclick="openEditJob('#PK-08230','Áo thun DTG — 120 chiếc')">Xử lý</button>
            </div>

            <div class="alert-row warn">
                <span class="ic">🖨️</span>
                <div class="txt"><strong>UV-01 đang bảo trì</strong><span>Dự kiến hoàn tất 13:00 · 2 đơn bị ảnh hưởng</span></div>
                <button onclick="toast('Đã mở lịch bảo trì')">Xem</button>
            </div>

            <div class="alert-row warn">
                <span class="ic">📦</span>
                <div class="txt"><strong>Phôi áo Cotton (L) sắp hết</strong><span>Còn 38% · Đề xuất đặt thêm 500 chiếc</span></div>
                <button onclick="toast('Đã gửi yêu cầu nhập vật tư')">Đặt hàng</button>
            </div>

            <div class="alert-row info">
                <span class="ic">↩️</span>
                <div class="txt"><strong>1 yêu cầu đổi/trả mới</strong><span>#PK-08220 · Sai màu · Chờ xử lý</span></div>
                <button onclick="location.href='xu_ly_tra_hang_hoan_tien_xuong.jsp'">Xem ngay</button>
            </div>
        </div>

        <div class="panel">
            <h3>Hoạt động gần đây</h3>
            <div class="timeline">
                <div class="tl-item done">
                    <div class="tl-txt">Hoàn tất in <strong>#PK-08225</strong> · Poster A2, 100 tờ</div>
                    <div class="tl-time">10:15 · UV-01</div>
                </div>
                <div class="tl-item done">
                    <div class="tl-txt">Bắt đầu in <strong>#PK-08232</strong> · Cốc sứ, 150 chiếc</div>
                    <div class="tl-time">10:02 · SUB-01</div>
                </div>
                <div class="tl-item active">
                    <div class="tl-txt">Đang in <strong>#PK-08231</strong> · Áo thun, 24 chiếc</div>
                    <div class="tl-time">09:40 · DTG-01 · 62%</div>
                </div>
                <div class="tl-item done">
                    <div class="tl-txt">QC duyệt <strong>#PK-08224</strong> · 36 áo thun</div>
                    <div class="tl-time">09:35 · Trần Hòa</div>
                </div>
                <div class="tl-item">
                    <div class="tl-txt">Nhận đơn mới <strong>#PK-08240</strong> · Túi vải, 60 chiếc</div>
                    <div class="tl-time">09:10 · Hệ thống</div>
                </div>
            </div>
        </div>
    </div>

</div>

<!-- ===== OVERLAY ===== -->
<div class="overlay" id="overlay" onclick="closeAll()"></div>

<!-- ===== JOB DETAIL MODAL ===== -->
<div class="modal" id="jobModal">
    <div class="modal-box">
        <div class="modal-head">
            <button class="modal-close" onclick="closeAll()">✕</button>
            <h3 id="jmId">#PK-08230</h3>
            <div class="sub" id="jmDesc">Áo thun DTG — 120 chiếc, 3 màu size</div>
        </div>

        <div class="detail-grid">
            <div class="field"><label>Khách hàng</label><strong id="jmCustomer">Local Brand Co.</strong></div>
            <div class="field"><label>Máy</label><strong id="jmMachine">DTG-02</strong></div>
            <div class="field"><label>Trạng thái</label><strong id="jmStatus">Trễ 6h</strong></div>
            <div class="field"><label>Số lượng</label><strong>120 chiếc</strong></div>
            <div class="field"><label>Chất liệu</label><strong>Cotton 100%</strong></div>
            <div class="field"><label>Phương pháp in</label><strong>DTG</strong></div>
        </div>

        <h3 style="font-size:16px; margin-bottom:12px; color:white;">Tiến độ sản xuất</h3>
        <div class="timeline" style="margin-bottom:20px;">
            <div class="tl-item done">
                <div class="tl-txt">Nhận file thiết kế</div>
                <div class="tl-time">08:15 · Từ hệ thống PrintKraft</div>
            </div>
            <div class="tl-item done">
                <div class="tl-txt">Duyệt mẫu in</div>
                <div class="tl-time">08:40 · Khách hàng xác nhận</div>
            </div>
            <div class="tl-item active">
                <div class="tl-txt">Đang in DTG</div>
                <div class="tl-time">62% · Dự kiến xong 11:30</div>
            </div>
            <div class="tl-item">
                <div class="tl-txt">Kiểm tra chất lượng</div>
                <div class="tl-time">Chờ xử lý</div>
            </div>
            <div class="tl-item">
                <div class="tl-txt">Đóng gói &amp; bàn giao</div>
                <div class="tl-time">Chờ xử lý</div>
            </div>
        </div>

        <div style="display:flex; gap:10px; flex-wrap:wrap;">
            <button class="btn-start" style="flex:1; min-width:130px; padding:12px; border-radius:9px; font-weight:700; border:none;" onclick="toast('Đã cập nhật tiến độ đơn hàng')">Cập nhật tiến độ</button>
            <button class="btn-edit" style="flex:1; min-width:110px; padding:12px; border-radius:9px; font-weight:700;" onclick="closeAll();openEditJob(document.getElementById('jmId').textContent, document.getElementById('jmDesc').textContent)">✎ Chỉnh sửa</button>
            <button class="btn-danger" style="flex:1; min-width:110px; padding:12px; border-radius:9px; font-weight:700;" onclick="closeAll();openCancelJob(document.getElementById('jmId').textContent, document.getElementById('jmDesc').textContent)">✕ Hủy đơn</button>
            <button class="btn-ghost" style="flex:1; min-width:110px; padding:12px; border-radius:9px; font-weight:700;" onclick="toast('Đã in phiếu công việc')">In phiếu</button>
        </div>
    </div>
</div>

<!-- ===== EDIT JOB MODAL ===== -->
<div class="modal" id="editModal">
    <div class="modal-box" style="width:520px;">
        <div class="modal-head">
            <button class="modal-close" onclick="closeAll()">✕</button>
            <h3>Chỉnh sửa đơn sản xuất</h3>
            <div class="sub" id="emSub">#PK-08230 · Áo thun DTG — 120 chiếc</div>
        </div>

        <div class="form-field">
            <label>Số lượng</label>
            <input id="emQty" type="number" value="120" min="1">
        </div>
        <div class="form-field">
            <label>Máy sản xuất</label>
            <select id="emMachine">
                <option>DTG-01</option>
                <option selected>DTG-02</option>
                <option>SUB-01</option>
                <option>UV-01</option>
                <option>SILK-01</option>
                <option>HEAT-01</option>
            </select>
        </div>
        <div class="form-field">
            <label>Hạn giao mới</label>
            <input id="emDue" type="text" value="15/09/2026 — 18:00">
        </div>
        <div class="form-field">
            <label>Mức ưu tiên</label>
            <select id="emPriority">
                <option>Bình thường</option>
                <option selected>Ưu tiên cao</option>
                <option>Hỏa tốc</option>
            </select>
        </div>
        <div class="form-field">
            <label>Ghi chú cho xưởng</label>
            <textarea id="emNote" placeholder="VD: Đổi sang mực bền màu hơn, giữ nguyên form oversize..."></textarea>
        </div>

        <div style="display:flex; gap:10px; margin-top:6px;">
            <button class="btn-ghost" style="flex:1; padding:12px; border-radius:9px; font-weight:700;" onclick="closeAll()">Huỷ</button>
            <button class="btn-start" style="flex:1.4; padding:12px; border-radius:9px; font-weight:700; border:none;" onclick="saveEditJob()">Lưu thay đổi</button>
        </div>
    </div>
</div>

<!-- ===== CANCEL JOB MODAL ===== -->
<div class="modal" id="cancelModal">
    <div class="modal-box" style="width:500px;">
        <div class="modal-head">
            <button class="modal-close" onclick="closeAll()">✕</button>
            <h3 style="color:var(--red);">Hủy đơn sản xuất</h3>
            <div class="sub" id="cmSub">#PK-08230 · Áo thun DTG — 120 chiếc</div>
        </div>

        <div class="alert-row" style="margin-bottom:16px;">
            <span class="ic">⚠️</span>
            <div class="txt"><strong>Hành động này không thể hoàn tác</strong><span>Vật tư đã dùng sẽ được ghi nhận vào chi phí xưởng.</span></div>
        </div>

        <div class="form-field">
            <label>Lý do hủy đơn</label>
            <div class="radio-list">
                <label><input type="radio" name="cancelReason" checked> Khách hàng yêu cầu hủy</label>
                <label><input type="radio" name="cancelReason"> Không đủ vật tư / phôi</label>
                <label><input type="radio" name="cancelReason"> Máy hỏng, không kịp tiến độ</label>
                <label><input type="radio" name="cancelReason"> File thiết kế lỗi, khách chưa xác nhận</label>
                <label><input type="radio" name="cancelReason"> Lý do khác</label>
            </div>
        </div>

        <div class="form-field">
            <label>Ghi chú thêm</label>
            <textarea placeholder="Nhập ghi chú nội bộ..."></textarea>
        </div>

        <div style="display:flex; gap:10px;">
            <button class="btn-ghost" style="flex:1; padding:12px; border-radius:9px; font-weight:700;" onclick="closeAll()">Giữ đơn</button>
            <button class="btn-danger" style="flex:1.3; padding:12px; border-radius:9px; font-weight:700;" onclick="confirmCancel()">Xác nhận hủy đơn</button>
        </div>
    </div>
</div>

<!-- ===== RETURN MODAL ===== -->
<div class="modal" id="returnModal">
    <div class="modal-box" style="width:520px;">
        <div class="modal-head">
            <button class="modal-close" onclick="closeAll()">✕</button>
            <h3>Yêu cầu đổi / trả hàng</h3>
            <div class="sub" id="rmSub">Tạo phiếu đổi trả cho đơn hàng</div>
        </div>

        <div class="form-field">
            <label>Mã đơn hàng</label>
            <input id="rmOrder" placeholder="VD: #PK-08229">
        </div>
        <div class="form-field">
            <label>Số lượng đổi/trả</label>
            <input id="rmQty" type="number" value="1" min="1">
        </div>
        <div class="form-field">
            <label>Lý do</label>
            <div class="radio-list">
                <label><input type="radio" name="returnReason" checked> In sai màu so với file</label>
                <label><input type="radio" name="returnReason"> Lệch vị trí in / lỗi hình</label>
                <label><input type="radio" name="returnReason"> Sản phẩm bị lỗi, bong tróc</label>
                <label><input type="radio" name="returnReason"> Giao sai số lượng / sai mẫu</label>
                <label><input type="radio" name="returnReason"> Khách đổi ý</label>
            </div>
        </div>
        <div class="form-field">
            <label>Hình thức xử lý</label>
            <select id="rmMethod">
                <option>In lại sản phẩm</option>
                <option>Hoàn tiền toàn phần</option>
                <option>Hoàn tiền một phần</option>
                <option>Đổi sang mẫu khác</option>
            </select>
        </div>
        <div class="form-field">
            <label>Mô tả chi tiết</label>
            <textarea placeholder="Mô tả tình trạng lỗi để bộ phận QC xử lý..."></textarea>
        </div>

        <div style="display:flex; gap:10px;">
            <button class="btn-ghost" style="flex:1; padding:12px; border-radius:9px; font-weight:700;" onclick="closeAll()">Huỷ</button>
            <button class="btn-start" style="flex:1.4; padding:12px; border-radius:9px; font-weight:700; border:none;" onclick="submitReturn()">Gửi yêu cầu</button>
        </div>
    </div>
</div>

<!-- ===== HANDOVER MODAL ===== -->
<div class="modal" id="handoverModal">
    <div class="modal-box" style="width:520px;">
        <div class="modal-head">
            <button class="modal-close" onclick="closeAll()">✕</button>
            <h3>Bàn giao đơn hàng</h3>
            <div class="sub" id="hmSub">#PK-08238 · Cốc sứ 350ml — 60 chiếc</div>
        </div>

        <div class="form-field">
            <label>Đơn vị vận chuyển</label>
            <select id="hmCarrier">
                <option>Giao Hàng Nhanh</option>
                <option>Giao Hàng Tiết Kiệm</option>
                <option>Viettel Post</option>
                <option>Ninja Van</option>
                <option>Khách tự đến lấy</option>
            </select>
        </div>
        <div class="form-field">
            <label>Mã vận đơn</label>
            <input id="hmTracking" placeholder="VD: GHN123456789">
        </div>
        <div class="form-field">
            <label>Số kiện hàng</label>
            <input id="hmPackages" type="number" value="1" min="1">
        </div>
        <div class="form-field">
            <label>Người bàn giao</label>
            <input id="hmStaff" value="Đặng Long">
        </div>
        <div class="form-field">
            <label>Ghi chú tình trạng đóng gói</label>
            <textarea id="hmNote" placeholder="VD: Đóng thùng carton, có lót xốp chống vỡ..."></textarea>
        </div>

        <div style="display:flex; gap:10px;">
            <button class="btn-ghost" style="flex:1; padding:12px; border-radius:9px; font-weight:700;" onclick="closeAll()">Huỷ</button>
            <button class="btn-start" style="flex:1.4; padding:12px; border-radius:9px; font-weight:700; border:none;" onclick="confirmHandover()">📦 Xác nhận bàn giao</button>
        </div>
    </div>
</div>

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

    /* ---------- Job actions ---------- */
    function acceptOrder(btn, id){
        toast('Đã nhận đơn ' + id + ' — chuyển sang mục Chờ xử lý');
        const card = btn.closest('.job-card');
        card.style.opacity = '0.4';
        card.style.pointerEvents = 'none';
    }

    function rejectOrder(btn, id){
        const card = btn.closest('.job-card');
        card.style.opacity = '0.3';
        card.style.pointerEvents = 'none';
        card.style.filter = 'grayscale(.7)';
        toast('Đã từ chối đơn ' + id + ' — khách hàng sẽ được thông báo');
    }

    function startJob(btn, id){
        toast('Đã bắt đầu in ' + id + ' — chuyển sang mục Đang sản xuất');
        const card = btn.closest('.job-card');
        card.style.opacity = '0.4';
        card.style.pointerEvents = 'none';
    }

    function finishJob(btn, id){
        toast('Đã hoàn tất ' + id + ' — chuyển sang Kiểm tra chất lượng');
        const card = btn.closest('.job-card');
        card.style.opacity = '0.4';
        card.style.pointerEvents = 'none';
    }

    function approveQC(btn, id){
        toast('Đã duyệt ' + id + ' — chuyển đóng gói & giao hàng');
        const card = btn.closest('.job-card');
        card.style.opacity = '0.4';
        card.style.pointerEvents = 'none';
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

    function openJobModal(id, desc, customer, machine, status, statusType){
        document.getElementById('jmId').textContent = id;
        document.getElementById('jmDesc').textContent = desc;
        document.getElementById('jmCustomer').textContent = customer;
        document.getElementById('jmMachine').textContent = machine;
        const statusEl = document.getElementById('jmStatus');
        statusEl.textContent = status;
        statusEl.style.color = statusType === 'late' ? 'var(--red)'
            : statusType === 'soon' ? 'var(--orange)'
                : statusType === 'new' ? 'var(--violet)'
                    : 'var(--green)';
        openModal('jobModal');
    }

    /* ---------- EDIT JOB ---------- */
    let editingJobId = '';
    function openEditJob(id, desc){
        editingJobId = id;
        document.getElementById('emSub').textContent = id + ' · ' + desc;
        openModal('editModal');
    }
    function saveEditJob(){
        closeAll();
        toast('Đã lưu thay đổi cho ' + editingJobId + ' — xưởng sẽ nhận thông báo');
    }

    /* ---------- CANCEL JOB ---------- */
    let cancellingJobId = '';
    function openCancelJob(id, desc){
        cancellingJobId = id;
        document.getElementById('cmSub').textContent = id + ' · ' + desc;
        openModal('cancelModal');
    }
    function confirmCancel(){
        const card = document.querySelector('.job-card[data-job="' + cancellingJobId + '"]');
        if(card){
            card.style.opacity = '0.3';
            card.style.pointerEvents = 'none';
            card.style.filter = 'grayscale(.7)';
        }
        closeAll();
        toast('Đã hủy đơn ' + cancellingJobId + ' — khách hàng sẽ được thông báo');
    }

    /* ---------- RETURN ---------- */
    function openReturnModal(id, desc){
        document.getElementById('rmOrder').value = id || '';
        document.getElementById('rmSub').textContent = id
            ? 'Tạo phiếu đổi trả cho ' + id + (desc ? ' · ' + desc : '')
            : 'Tạo phiếu đổi trả cho đơn hàng';
        openModal('returnModal');
    }
    function submitReturn(){
        const order = document.getElementById('rmOrder').value.trim() || 'đơn hàng';
        const method = document.getElementById('rmMethod').value;
        closeAll();
        toast('Đã gửi yêu cầu ' + method.toLowerCase() + ' cho ' + order);
    }

    /* ---------- HANDOVER ---------- */
    let handoverJobId = '';
    function openHandoverModal(id, desc){
        handoverJobId = id;
        document.getElementById('hmSub').textContent = id + ' · ' + desc;
        openModal('handoverModal');
    }
    function confirmHandover(){
        const carrier = document.getElementById('hmCarrier').value;
        const tracking = document.getElementById('hmTracking').value.trim();
        if(!tracking){ toast('Vui lòng nhập mã vận đơn'); return; }
        closeAll();
        toast('Đã bàn giao ' + handoverJobId + ' cho ' + carrier + ' — mã vận đơn ' + tracking);
        const card = document.querySelector('.job-card[data-job="' + handoverJobId + '"]');
        if(card){
            const badge = card.querySelector('.due');
            if(badge){ badge.textContent = 'Đã giao'; badge.className = 'due ok'; }
            const actionsRow = card.querySelector('.job-actions');
            if(actionsRow) actionsRow.innerHTML = '<button class="btn-ghost" onclick="openReturnModal(\'' + handoverJobId + '\',\'\')">↩ Đổi/Trả</button><button class="btn-ghost" onclick="openJobModal(\'' + handoverJobId + '\',\'\',\'\',\'\',\'Đã giao\',\'ok\')">Chi tiết</button>';
        }
    }
</script>
</body>
</html>