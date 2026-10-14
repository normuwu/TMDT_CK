<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>PrintKraft — Thanh toán đơn tự thiết kế</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<style>
  :root{
    --ink:#1B1B2F; --ink-soft:#4A4A6A; --cream:#FDF9F3; --surface:#FFFFFF;
    --violet:#6C5CE7; --violet-soft:#A29BFE; --coral:#FF6B6B; --coral-deep:#EE5253;
    --amber:#FFB347; --teal:#00B894; --teal-soft:#55EFC4; --pink:#FD79A8; --sky:#48A9F8;
    --grad-primary:linear-gradient(135deg,#6C5CE7 0%,#A29BFE 100%);
    --grad-warm:linear-gradient(135deg,#FF6B6B 0%,#FFB347 100%);
    --grad-cool:linear-gradient(135deg,#00B894 0%,#55EFC4 100%);
    --grad-sky:linear-gradient(135deg,#48A9F8 0%,#6C5CE7 100%);
    --grad-pink:linear-gradient(135deg,#FD79A8 0%,#A29BFE 100%);
    --line:rgba(27,27,47,0.10); --line-strong:rgba(27,27,47,0.18);
    --shadow-xs:0 1px 3px rgba(27,27,47,0.06);
    --shadow-sm:0 4px 14px rgba(27,27,47,0.07);
    --shadow-md:0 12px 32px rgba(27,27,47,0.11);
    --shadow-lg:0 24px 60px rgba(27,27,47,0.18);
    --shadow-glow:0 12px 34px rgba(108,92,231,0.32);
    --r-sm:10px; --r-md:16px; --r-lg:22px; --r-xl:28px;
  }
  *{box-sizing:border-box; margin:0; padding:0;}
  html{scroll-behavior:smooth;}
  body{
    color:var(--ink); font-family:'IBM Plex Sans',sans-serif; line-height:1.55;
    background:
      radial-gradient(1100px 620px at 8% -8%, rgba(108,92,231,0.13), transparent 62%),
      radial-gradient(880px 520px at 96% -4%, rgba(255,107,107,0.13), transparent 58%),
      radial-gradient(900px 640px at 50% 104%, rgba(0,184,148,0.10), transparent 62%),
      var(--cream);
    background-attachment:fixed;
    padding-bottom:60px;
  }
  h1,h2,h3,h4,h5{font-family:'Space Grotesk',sans-serif; letter-spacing:-0.02em; line-height:1.15;}
  a{color:inherit; text-decoration:none;}
  button{font-family:inherit; cursor:pointer; border:none; background:none; color:inherit;}
  input,select,textarea{font-family:inherit;}

  /* ===== Top bar ===== */
  .utility{
    background:linear-gradient(90deg,#1B1B2F 0%,#2D2B55 50%,#1B1B2F 100%);
    color:rgba(253,249,243,0.82); font-size:12.5px; padding:9px 32px;
    display:flex; justify-content:space-between; flex-wrap:wrap; gap:8px;
  }
  .utility b{color:var(--amber); font-weight:600;}
  header{
    background:rgba(253,249,243,0.9); backdrop-filter:blur(14px); -webkit-backdrop-filter:blur(14px);
    border-bottom:1px solid var(--line); padding:12px 32px;
    display:flex; align-items:center; gap:16px; position:sticky; top:0; z-index:50;
  }
  .logo{font-size:22px; font-weight:700; display:flex; align-items:center; gap:10px;}
  .logo .mark{width:28px;height:28px; background:var(--grad-warm); display:inline-block; transform:rotate(45deg); border-radius:8px; box-shadow:0 6px 16px rgba(255,107,107,0.4);}
  .steps-bar{margin-left:auto; display:flex; align-items:center; gap:8px; font-size:12.5px; color:var(--ink-soft); font-weight:600;}
  .steps-bar .n{
    width:24px;height:24px;border-radius:50%; background:#EDEBF5; color:var(--ink-soft);
    display:flex;align-items:center;justify-content:center; font-size:11.5px; font-weight:700;
  }
  .steps-bar .s{display:flex; align-items:center; gap:7px;}
  .steps-bar .s.active .n{background:var(--grad-primary); color:white; box-shadow:0 6px 16px rgba(108,92,231,0.32);}
  .steps-bar .s.active span{color:var(--violet);}
  .steps-bar .s.done .n{background:var(--grad-cool); color:#063a2e;}
  .steps-bar .sep{width:26px; height:2px; background:#EDEBF5; border-radius:999px;}

  /* ===== Layout ===== */
  .breadcrumb{max-width:1180px; margin:26px auto 0; padding:0 32px; font-size:13px; color:var(--ink-soft);}
  .breadcrumb a{color:var(--violet); font-weight:600;}
  .page{max-width:1180px; margin:0 auto; padding:18px 32px 0;}
  .page-head{margin:8px 0 26px;}
  .page-head h1{font-size:36px;}
  .page-head p{color:var(--ink-soft); font-size:14.5px; margin-top:8px;}

  .layout{display:grid; grid-template-columns:1.55fr 1fr; gap:26px; align-items:start;}

  /* ===== Panels ===== */
  .panel{
    background:var(--surface); border:1px solid var(--line); border-radius:var(--r-lg);
    padding:26px; box-shadow:var(--shadow-xs); margin-bottom:22px;
  }
  .panel-head{display:flex; align-items:center; gap:12px; margin-bottom:20px;}
  .panel-head .ic{
    width:40px;height:40px;border-radius:12px; display:flex;align-items:center;justify-content:center;
    font-size:18px; color:white; flex-shrink:0;
  }
  .panel-head h3{font-size:19px;}
  .panel-head p{font-size:13px; color:var(--ink-soft); margin-top:2px;}

  /* ===== Order hero ===== */
  .order-hero{display:flex; gap:20px; align-items:center; flex-wrap:wrap;}
  .mockup-box{
    width:120px;height:130px; border-radius:16px; background:var(--grad-primary);
    display:flex; align-items:center; justify-content:center; position:relative;
    box-shadow:var(--shadow-md); flex-shrink:0;
  }
  .mockup-box:before,.mockup-box:after{
    content:""; position:absolute; top:10px; width:34px; height:48px;
    background:var(--grad-primary); border-radius:8px;
  }
  .mockup-box:before{left:-28px;}
  .mockup-box:after{right:-28px;}
  .mockup-box span{
    width:66px;height:66px;border:2px dashed rgba(255,255,255,0.6); border-radius:10px;
    display:flex; align-items:center; justify-content:center; font-size:9px; color:white;
    text-align:center; font-family:'Space Grotesk'; letter-spacing:.06em; padding:4px; z-index:1;
  }
  .order-meta h4{font-size:19px; margin-bottom:6px;}
  .order-meta .oid{font-family:'Space Grotesk'; font-weight:700; font-size:13px; color:var(--violet); background:#F2EFFF; padding:5px 12px; border-radius:999px; display:inline-block; margin-bottom:10px;}
  .order-meta ul{list-style:none; font-size:13.5px; color:var(--ink-soft);}
  .order-meta li{padding:3px 0;}
  .order-meta li b{color:var(--ink); font-weight:600;}

  /* ===== Plan cards ===== */
  .plan-grid{display:grid; grid-template-columns:1fr 1fr; gap:14px; margin-bottom:20px;}
  .plan-card{
    text-align:left; border:2px solid var(--line-strong); background:var(--surface);
    border-radius:var(--r-md); padding:20px; transition:.2s; position:relative; width:100%;
  }
  .plan-card:hover{border-color:var(--violet-soft); transform:translateY(-2px);}
  .plan-card.active{border-color:var(--violet); background:#FBFAFF; box-shadow:0 0 0 4px rgba(108,92,231,0.12);}
  .plan-card .p-badge{
    position:absolute; top:-11px; right:14px; font-size:10.5px; font-weight:700;
    padding:4px 11px; border-radius:999px; background:var(--grad-warm); color:white;
    letter-spacing:.04em; text-transform:uppercase; box-shadow:0 6px 14px rgba(255,107,107,0.35);
  }
  .plan-card .p-badge.green{background:var(--grad-cool); color:#063a2e;}
  .plan-card h4{font-size:16px; margin-bottom:6px;}
  .plan-card .p-desc{font-size:12.5px; color:var(--ink-soft); margin-bottom:14px; min-height:34px;}
  .plan-card .p-price{font-family:'Space Grotesk'; font-weight:700; font-size:24px; color:var(--violet);}
  .plan-card .p-sub{font-size:12px; color:var(--ink-soft); margin-top:2px;}
  .plan-card .p-radio{
    position:absolute; top:18px; left:18px; width:20px;height:20px; border-radius:50%;
    border:2px solid var(--line-strong); background:white;
  }
  .plan-card.active .p-radio{border-color:var(--violet);}
  .plan-card.active .p-radio:after{content:""; position:absolute; inset:3px; border-radius:50%; background:var(--violet);}

  /* ===== Schedule ===== */
  .schedule{background:#FBF9FF; border:1px dashed var(--line-strong); border-radius:var(--r-md); padding:20px;}
  .schedule-title{font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:.1em; color:var(--ink-soft); margin-bottom:16px;}
  .sch-item{display:flex; align-items:center; gap:14px; padding:6px 0;}
  .sch-dot{
    width:32px;height:32px;border-radius:50%; background:#EDEBF5; color:var(--ink-soft);
    display:flex; align-items:center; justify-content:center; font-size:12.5px; font-weight:700;
    flex-shrink:0; font-family:'Space Grotesk';
  }
  .sch-item.now .sch-dot{background:var(--grad-warm); color:white; box-shadow:0 6px 14px rgba(255,107,107,0.35);}
  .sch-item.later .sch-dot{background:#EDEBF5;}
  .sch-item.paid .sch-dot{background:var(--grad-cool); color:#063a2e;}
  .sch-body{flex:1;}
  .sch-body strong{display:block; font-size:14px;}
  .sch-body span{font-size:12.5px; color:var(--ink-soft);}
  .sch-amt{font-family:'Space Grotesk'; font-weight:700; font-size:15px; color:var(--ink); white-space:nowrap;}
  .sch-line{width:2px; height:16px; background:var(--line-strong); margin-left:15px; border-radius:2px;}

  /* ===== Payment methods ===== */
  .pay-methods{display:flex; flex-direction:column; gap:11px;}
  .pay-method{
    display:flex; align-items:center; gap:14px; padding:16px; border:1.5px solid var(--line-strong);
    border-radius:var(--r-md); background:white; transition:.18s; text-align:left; width:100%;
  }
  .pay-method:hover{border-color:var(--violet); background:#FBFAFF;}
  .pay-method.active{border-color:var(--violet); background:#F6F3FF; box-shadow:0 0 0 4px rgba(108,92,231,0.12);}
  .pay-method .ic{
    width:42px;height:42px;border-radius:12px; display:flex;align-items:center;justify-content:center;
    font-size:19px; flex-shrink:0; color:white;
  }
  .pay-method .pm-body{flex:1;}
  .pay-method strong{display:block; font-size:14px;}
  .pay-method span{font-size:12.5px; color:var(--ink-soft);}
  .pay-method .radio{width:20px;height:20px;border-radius:50%; border:2px solid var(--line-strong); flex-shrink:0; position:relative;}
  .pay-method.active .radio{border-color:var(--violet);}
  .pay-method.active .radio:after{content:""; position:absolute; inset:3px; border-radius:50%; background:var(--violet);}

  .field{margin-bottom:14px;}
  .field label{display:block; font-size:12.5px; font-weight:600; margin-bottom:6px; color:var(--ink-soft);}
  .field input, .field select, .field textarea{
    width:100%; border:1.5px solid var(--line); border-radius:var(--r-sm); padding:12px 14px;
    font-size:14px; background:#FBF9FF; outline:none; transition:.18s; color:var(--ink);
  }
  .field input:focus, .field select:focus, .field textarea:focus{border-color:var(--violet); background:white; box-shadow:0 0 0 4px rgba(108,92,231,0.12);}
  .field-row{display:grid; grid-template-columns:1fr 1fr; gap:14px;}

  /* ===== Buttons ===== */
  .btn-primary{
    background:var(--grad-primary); color:white; padding:15px 26px; border-radius:var(--r-sm);
    font-weight:600; font-size:14.5px; display:block; width:100%; text-align:center;
    box-shadow:var(--shadow-glow); transition:.2s;
  }
  .btn-primary:hover{transform:translateY(-2px); box-shadow:0 18px 40px rgba(108,92,231,0.42);}
  .btn-primary:disabled{opacity:.5; cursor:not-allowed; transform:none;}
  .btn-secondary{
    border:1.5px solid var(--line-strong); padding:14px 26px; border-radius:var(--r-sm);
    font-weight:600; font-size:14.5px; background:var(--surface); color:var(--ink);
    display:block; width:100%; text-align:center; transition:.2s;
  }
  .btn-secondary:hover{border-color:var(--violet); color:var(--violet); transform:translateY(-2px);}
  .btn-teal{background:var(--grad-cool); color:#063a2e; box-shadow:0 12px 30px rgba(0,184,148,0.32);}

  /* ===== Summary sidebar ===== */
  .col-side{position:sticky; top:90px;}
  .summary{
    background:linear-gradient(150deg,#241F45 0%,#3B2F73 55%,#4B3A8F 100%);
    color:var(--cream); border-radius:var(--r-lg); padding:26px; box-shadow:var(--shadow-md);
    position:relative; overflow:hidden;
  }
  .summary:before{content:""; position:absolute; width:220px;height:220px;border-radius:50%; background:rgba(162,155,254,0.28); filter:blur(55px); top:-80px; right:-60px;}
  .summary h3{font-size:16px; margin-bottom:18px; position:relative;}
  .summary .row{display:flex; justify-content:space-between; font-size:13.5px; padding:7px 0; color:rgba(253,249,243,0.78); position:relative; gap:12px;}
  .summary .row b{color:white; font-weight:600;}
  .summary .row.disc b{color:var(--teal-soft);}
  .summary .div{height:1px; background:rgba(253,249,243,0.18); margin:14px 0; position:relative;}
  .summary .total-row{display:flex; justify-content:space-between; align-items:flex-end; position:relative; margin-bottom:4px;}
  .summary .total-row span{font-size:13.5px; color:rgba(253,249,243,0.8);}
  .summary .total-row .big{font-family:'Space Grotesk'; font-size:28px; font-weight:700; color:white; line-height:1;}
  .summary .today{
    background:rgba(255,255,255,0.10); border:1px solid rgba(255,255,255,0.16);
    border-radius:14px; padding:16px; margin:16px 0 18px; position:relative;
  }
  .summary .today .t-label{font-size:12px; color:rgba(253,249,243,0.7); margin-bottom:4px;}
  .summary .today .t-val{font-family:'Space Grotesk'; font-size:24px; font-weight:700; color:var(--amber);}
  .summary .today .t-sub{font-size:12px; color:rgba(253,249,243,0.66); margin-top:5px;}
  .summary .sec-note{font-size:12px; color:rgba(253,249,243,0.62); margin-top:14px; text-align:center; position:relative; line-height:1.5;}
  .summary .badge-save{
    display:inline-block; background:var(--grad-warm); color:white; font-size:11.5px; font-weight:700;
    padding:5px 12px; border-radius:999px; margin-top:8px; position:relative;
  }

  /* ===== Success view ===== */
  .success-view{max-width:760px; margin:0 auto; text-align:center; padding:20px 0 40px;}
  .success-icon{
    width:88px;height:88px;border-radius:50%; background:var(--grad-cool); color:#063a2e;
    display:flex;align-items:center;justify-content:center;font-size:42px; margin:0 auto 22px;
    box-shadow:0 16px 40px rgba(0,184,148,0.35);
  }
  .success-view h2{font-size:30px; margin-bottom:10px;}
  .success-view > p{color:var(--ink-soft); font-size:14.5px; margin-bottom:8px;}
  .order-code{
    display:inline-block; font-family:'Space Grotesk'; font-weight:700; font-size:17px;
    background:#F2EFFF; color:var(--violet); padding:11px 22px; border-radius:999px; margin:14px 0 26px;
  }

  /* Timeline tracking */
  .timeline{background:var(--surface); border:1px solid var(--line); border-radius:var(--r-lg); padding:26px; box-shadow:var(--shadow-sm); text-align:left; margin-bottom:22px;}
  .timeline h3{font-size:17px; margin-bottom:18px;}
  .tl-row{display:flex; gap:14px; padding:12px 0; border-bottom:1px solid var(--line);}
  .tl-row:last-child{border-bottom:none;}
  .tl-dot{width:14px;height:14px;border-radius:50%; background:#E4E2EF; flex-shrink:0; margin-top:4px;}
  .tl-dot.done{background:var(--grad-cool);}
  .tl-dot.active{background:var(--grad-warm); box-shadow:0 0 0 5px rgba(255,107,107,0.16);}
  .tl-body{flex:1;}
  .tl-body strong{display:block; font-size:14px;}
  .tl-body span{font-size:12.5px; color:var(--ink-soft);}
  .tl-time{font-size:12px; color:var(--ink-soft); white-space:nowrap;}

  /* Payment schedule in track view */
  .pay-schedule{background:var(--surface); border:1px solid var(--line); border-radius:var(--r-lg); padding:26px; box-shadow:var(--shadow-sm); text-align:left; margin-bottom:22px;}
  .pay-schedule h3{font-size:17px; margin-bottom:18px; display:flex; justify-content:space-between; align-items:center;}
  .pay-schedule h3 .pill{
    font-size:11.5px; font-weight:700; padding:5px 12px; border-radius:999px;
    background:#E1FBF3; color:#0A7A5E; text-transform:uppercase; letter-spacing:.04em;
  }
  .ps-item{
    display:flex; align-items:center; gap:16px; padding:18px; border-radius:var(--r-md);
    border:1.5px solid var(--line); margin-bottom:12px; background:#FDFCFF;
  }
  .ps-item.paid{border-color:rgba(0,184,148,0.4); background:#F5FFFB;}
  .ps-item.due{border-color:rgba(255,179,71,0.55); background:#FFFBF2;}
  .ps-item .ps-icon{
    width:44px;height:44px;border-radius:12px; display:flex; align-items:center; justify-content:center;
    font-size:20px; flex-shrink:0; color:white;
  }
  .ps-item.paid .ps-icon{background:var(--grad-cool); color:#063a2e;}
  .ps-item.due .ps-icon{background:var(--grad-warm);}
  .ps-body{flex:1;}
  .ps-body strong{display:block; font-size:14.5px;}
  .ps-body span{font-size:12.5px; color:var(--ink-soft);}
  .ps-amount{font-family:'Space Grotesk'; font-weight:700; font-size:17px; white-space:nowrap;}
  .ps-item.paid .ps-amount{color:var(--teal);}
  .ps-item.due .ps-amount{color:var(--coral-deep);}

  /* Alert note */
  .alert{
    display:flex; gap:12px; padding:14px 16px; border-radius:12px; font-size:13px;
    line-height:1.6; margin-bottom:18px;
  }
  .alert.warn{background:#FFF4E0; color:#8A5A00; border:1px dashed rgba(255,179,71,0.7);}
  .alert.info{background:#EDE9FF; color:#4B3A8F; border:1px dashed rgba(108,92,231,0.4);}
  .alert b{font-weight:700;}

  /* Modal */
  .overlay{position:fixed; inset:0; background:rgba(27,27,47,0.5); backdrop-filter:blur(3px); opacity:0; pointer-events:none; transition:.25s; z-index:90;}
  .overlay.show{opacity:1; pointer-events:auto;}
  .modal{position:fixed; inset:0; display:flex; align-items:center; justify-content:center; z-index:110; opacity:0; pointer-events:none; transition:.22s; padding:20px; overflow-y:auto;}
  .modal.show{opacity:1; pointer-events:auto;}
  .modal-box{
    background:var(--cream); border-radius:var(--r-xl); padding:32px; width:500px; max-width:100%;
    position:relative; box-shadow:var(--shadow-lg); transform:translateY(14px) scale(.98); transition:.25s;
    max-height:92vh; overflow-y:auto; margin:auto;
  }
  .modal.show .modal-box{transform:translateY(0) scale(1);}
  .modal-box h3{font-size:22px; margin-bottom:6px;}
  .modal-box .sub{font-size:13.5px; color:var(--ink-soft); margin-bottom:22px;}
  .modal-close{position:absolute; top:16px; right:18px; font-size:20px; width:36px;height:36px;border-radius:50%; color:var(--ink-soft); transition:.18s;}
  .modal-close:hover{background:var(--line); color:var(--ink);}
  .modal-actions{display:flex; gap:10px; margin-top:20px;}

  /* toast */
  .toast{
    position:fixed; bottom:28px; left:50%; transform:translate(-50%,100px);
    background:var(--ink); color:var(--cream); padding:14px 24px; border-radius:999px;
    font-size:13.5px; font-weight:500; z-index:300; transition:.3s cubic-bezier(.4,0,.2,1);
    opacity:0; box-shadow:var(--shadow-lg); max-width:90vw; text-align:center;
  }
  .toast.show{transform:translate(-50%,0); opacity:1;}
  .toast.ok{background:linear-gradient(135deg,#00B894,#0A7A5E);}
  .toast.err{background:linear-gradient(135deg,#FF6B6B,#C0392B);}

  /* Responsive */
  @media (max-width:980px){
    .layout{grid-template-columns:1fr;}
    .col-side{position:static;}
    .plan-grid{grid-template-columns:1fr;}
    .page-head h1{font-size:28px;}
    header{padding:12px 18px;}
    .page{padding:18px 18px 0;}
    .breadcrumb{padding:0 18px;}
    .steps-bar{display:none;}
    .field-row{grid-template-columns:1fr;}
  }
</style>
</head>
<body>

<!-- ============ TOP ============ -->
<div class="utility">
  <span>🔒 Thanh toán an toàn — mã hóa SSL 256-bit · <b>Hoàn tiền 100%</b> nếu lỗi từ xưởng</span>
  <span>Hỗ trợ: <b>1900 6868</b> · 8:00–21:00</span>
</div>
<header>
  <a href="trang_chu.jsp" class="logo"><span class="mark"></span> PrintKraft</a>
  <div class="steps-bar" id="topSteps">
    <div class="s active" data-s="1"><div class="n">1</div><span>Xác nhận đơn</span></div>
    <div class="sep"></div>
    <div class="s" data-s="2"><div class="n">2</div><span>Thanh toán</span></div>
    <div class="sep"></div>
    <div class="s" data-s="3"><div class="n">3</div><span>Hoàn tất</span></div>
  </div>
</header>

<div class="breadcrumb"><a href="dat_in_3d.jsp">← Quay lại xưởng thiết kế</a></div>

<!-- ============ CHECKOUT VIEW ============ -->
<main class="page" id="checkoutView">
  <div class="page-head">
    <h1>Thanh toán đơn hàng tự thiết kế</h1>
    <p>Đơn hàng in theo yêu cầu — bạn có thể đặt cọc trước để xưởng khởi động sản xuất.</p>
  </div>

  <div class="layout">
    <!-- ===== LEFT ===== -->
    <div class="col-main">

      <!-- Order info -->
      <div class="panel">
        <div class="panel-head">
          <div class="ic" style="background:var(--grad-primary)">🎨</div>
          <div>
            <h3>Thông tin đơn hàng</h3>
            <p>Đơn thiết kế tùy chỉnh — gửi từ Xưởng thiết kế trực tuyến</p>
          </div>
        </div>
        <div class="order-hero">
          <div class="mockup-box"><span>LOGO<br>CỦA BẠN</span></div>
          <div class="order-meta">
            <h4>Áo thun Oversize Cotton</h4>
            <div class="oid">#PK-09001</div>
            <ul>
              <li>Phương pháp in: <b>DTG (Direct to Garment)</b></li>
              <li>Màu sản phẩm: <b>Tím Violet</b> · Size: <b>L / XL</b></li>
              <li>Số lượng: <b>200 chiếc</b> · Đơn giá: <b>89.000đ</b></li>
              <li>Xưởng in: <b>Sài Gòn Print</b> · Dự kiến giao: <b>25/09/2026</b></li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Payment plan -->
      <div class="panel">
        <div class="panel-head">
          <div class="ic" style="background:var(--grad-warm)">💳</div>
          <div>
            <h3>Chọn phương án thanh toán</h3>
            <p>Đặt cọc để xưởng bắt đầu sản xuất, hoặc thanh toán toàn bộ để được ưu đãi</p>
          </div>
        </div>

        <div class="plan-grid" id="planGrid">
          <button class="plan-card active" data-plan="deposit" onclick="setPlan('deposit')">
            <span class="p-badge">Phổ biến nhất</span>
            <div class="p-radio"></div>
            <h4>Đặt cọc 40%</h4>
            <div class="p-desc">Xưởng khởi động sản xuất ngay. Phần còn lại thanh toán sau khi duyệt mẫu thật.</div>
            <div class="p-price">7.120.000đ</div>
            <div class="p-sub">Còn lại 10.680.000đ (60%)</div>
          </button>

          <button class="plan-card" data-plan="full" onclick="setPlan('full')">
            <span class="p-badge green">Tiết kiệm 5%</span>
            <div class="p-radio"></div>
            <h4>Thanh toán toàn bộ</h4>
            <div class="p-desc">Ưu tiên xếp hàng sản xuất, giao nhanh hơn 1–2 ngày. Không phát sinh thủ tục.</div>
            <div class="p-price">16.910.000đ</div>
            <div class="p-sub">Giảm 890.000đ (5%)</div>
          </button>
        </div>

        <div class="schedule" id="scheduleBox">
          <div class="schedule-title">Lịch thanh toán dự kiến</div>
          <div id="scheduleInner"></div>
        </div>
      </div>

      <!-- Payment method -->
      <div class="panel">
        <div class="panel-head">
          <div class="ic" style="background:var(--grad-sky)">🏦</div>
          <div>
            <h3>Phương thức thanh toán</h3>
            <p>Chọn cách bạn muốn thanh toán cho đợt này</p>
          </div>
        </div>

        <div class="pay-methods" id="payMethods">
          <button class="pay-method active" data-m="card" onclick="pickPayMethod(this)">
            <div class="ic" style="background:var(--grad-primary)">💳</div>
            <div class="pm-body"><strong>Thẻ tín dụng / ghi nợ</strong><span>Visa, Mastercard, JCB — xác nhận tức thì</span></div>
            <div class="radio"></div>
          </button>
          <button class="pay-method" data-m="bank" onclick="pickPayMethod(this)">
            <div class="ic" style="background:var(--grad-sky)">🏦</div>
            <div class="pm-body"><strong>Chuyển khoản ngân hàng</strong><span>Xác nhận tự động trong 5 phút</span></div>
            <div class="radio"></div>
          </button>
          <button class="pay-method" data-m="wallet" onclick="pickPayMethod(this)">
            <div class="ic" style="background:var(--grad-pink)">📱</div>
            <div class="pm-body"><strong>Ví điện tử</strong><span>MoMo, ZaloPay, ShopeePay</span></div>
            <div class="radio"></div>
          </button>
        </div>

        <div id="cardForm" style="margin-top:22px;">
          <div class="field"><label>Số thẻ</label><input id="cardNo" placeholder="1234 5678 9012 3456" maxlength="19" oninput="formatCard(this)"></div>
          <div class="field-row">
            <div class="field"><label>Ngày hết hạn</label><input placeholder="MM/YY" maxlength="5" oninput="formatExpiry(this)"></div>
            <div class="field"><label>CVC</label><input placeholder="123" maxlength="4"></div>
          </div>
          <div class="field"><label>Tên chủ thẻ</label><input placeholder="NGUYEN VAN A" style="text-transform:uppercase;"></div>
        </div>

        <div id="bankInfo" style="display:none; margin-top:22px;">
          <div class="alert info">
            <span>🏦</span>
            <div>
              <b>Ngân hàng:</b> Vietcombank — CN Sài Gòn<br>
              <b>Số TK:</b> 0071 0009 8877 66 · <b>Chủ TK:</b> CONG TY PRINTKRAFT<br>
              <b>Nội dung CK:</b> <b style="color:var(--coral-deep)">PK-09001 COC</b>
            </div>
          </div>
        </div>
      </div>

    </div>

    <!-- ===== RIGHT ===== -->
    <aside class="col-side">
      <div class="summary">
        <h3>Chi tiết thanh toán</h3>
        <div class="row"><span>Tạm tính (200 × 89.000đ)</span><span>17.800.000đ</span></div>
        <div class="row"><span>Phí thiết kế</span><span style="color:var(--teal-soft)">Miễn phí</span></div>
        <div class="row"><span>Phí in mẫu thử</span><span style="color:var(--teal-soft)">Miễn phí</span></div>
        <div class="row disc" id="discRow" style="display:none;"><span>Giảm giá thanh toán toàn bộ</span><b id="discVal">-890.000đ</b></div>
        <div class="div"></div>
        <div class="total-row">
          <span>Tổng đơn hàng</span>
          <span class="big" id="orderTotal">17.800.000đ</span>
        </div>

        <div class="today">
          <div class="t-label" id="todayLabel">Thanh toán hôm nay (đặt cọc 40%)</div>
          <div class="t-val" id="todayVal">7.120.000đ</div>
          <div class="t-sub" id="todaySub">Còn lại 10.680.000đ thanh toán sau khi duyệt mẫu</div>
        </div>

        <span class="badge-save" id="saveTag" style="display:none;">🎁 Tiết kiệm 890.000đ</span>

        <button class="btn-primary" style="margin-top:18px;" onclick="confirmPay()">🔒 Xác nhận & thanh toán</button>
        <div class="sec-note">Bằng việc đặt hàng, bạn đồng ý với <a href="lien-he.jsp" style="color:var(--violet-soft); text-decoration:underline;">Điều khoản dịch vụ</a> của PrintKraft.</div>
      </div>

      <div style="background:white; border:1px solid var(--line); border-radius:var(--r-md); padding:18px; margin-top:16px; box-shadow:var(--shadow-xs);">
        <div style="display:flex; gap:12px; font-size:12.5px; color:var(--ink-soft); line-height:1.6;">
          <span style="font-size:18px;">🛡️</span>
          <div>
            <b style="color:var(--ink); display:block; margin-bottom:3px;">Cam kết của PrintKraft</b>
            Hủy miễn phí trước khi xưởng nhận file · Hoàn cọc 100% nếu đơn không thể sản xuất · Hỗ trợ đổi trả 7 ngày.
          </div>
        </div>
      </div>
    </aside>
  </div>
</main>

<!-- ============ TRACK VIEW (SAU KHI CỌC) ============ -->
<main class="page" id="trackView" style="display:none;">
  <div class="success-view">
    <div class="success-icon">✓</div>
    <h2>Đặt cọc thành công!</h2>
    <p>Xưởng <b>Sài Gòn Print</b> đã nhận đơn và bắt đầu xử lý. Mẫu thử sẽ có trong 48 giờ.</p>
    <div class="order-code">#PK-09001</div>
  </div>

  <div class="timeline">
    <h3>Tiến độ đơn hàng</h3>
    <div class="tl-row">
      <div class="tl-dot done"></div>
      <div class="tl-body"><strong>Đã xác nhận đơn &amp; đặt cọc</strong><span>Thanh toán 7.120.000đ qua thẻ tín dụng</span></div>
      <div class="tl-time">Vừa xong</div>
    </div>
    <div class="tl-row">
      <div class="tl-dot active"></div>
      <div class="tl-body"><strong>Đang in mẫu thử</strong><span>Xưởng chuẩn bị 1 áo mẫu để bạn duyệt</span></div>
      <div class="tl-time">Dự kiến 17/09</div>
    </div>
    <div class="tl-row">
      <div class="tl-dot"></div>
      <div class="tl-body"><strong>Duyệt mẫu &amp; thanh toán phần còn lại</strong><span>Thanh toán 10.680.000đ (60%) trước khi sản xuất hàng loạt</span></div>
      <div class="tl-time">Dự kiến 19/09</div>
    </div>
    <div class="tl-row">
      <div class="tl-dot"></div>
      <div class="tl-body"><strong>Sản xuất hàng loạt</strong><span>200 áo · thời gian 3–4 ngày</span></div>
      <div class="tl-time">Dự kiến 22/09</div>
    </div>
    <div class="tl-row">
      <div class="tl-dot"></div>
      <div class="tl-body"><strong>Giao hàng</strong><span>Giao tới 128 Nguyễn Đình Chiểu, Q.3, TP.HCM</span></div>
      <div class="tl-time">Dự kiến 25/09</div>
    </div>
  </div>

  <div class="pay-schedule">
    <h3>Lịch thanh toán <span class="pill">Đã cọc 40%</span></h3>

    <div class="ps-item paid">
      <div class="ps-icon">✓</div>
      <div class="ps-body">
        <strong>Đợt 1 — Đặt cọc 40%</strong>
        <span>Đã thanh toán lúc 14:32 · 15/09/2026 · Thẻ tín dụng ****3456</span>
      </div>
      <div class="ps-amount">7.120.000đ</div>
    </div>

    <div class="ps-item due">
      <div class="ps-icon">💰</div>
      <div class="ps-body">
        <strong>Đợt 2 — Phần còn lại 60%</strong>
        <span>Thanh toán sau khi duyệt mẫu thật · hạn chót 19/09/2026</span>
      </div>
      <div class="ps-amount">10.680.000đ</div>
    </div>

    <div class="alert warn" style="margin-top:16px; margin-bottom:0;">
      <span>⏰</span>
      <div>Bạn có thể thanh toán phần còn lại bất cứ lúc nào sau khi duyệt mẫu. Nút "Thanh toán phần còn lại" sẽ kích hoạt ngay khi xưởng xác nhận mẫu hoàn tất.</div>
    </div>

    <div style="display:flex; gap:10px; margin-top:20px; flex-wrap:wrap;">
      <button class="btn-secondary" style="flex:1; min-width:180px;" onclick="toast('Đang mở chi tiết đơn #PK-09001...')">Xem chi tiết đơn</button>
      <button class="btn-primary" style="flex:1.4; min-width:220px;" id="btnPayRest" onclick="openRestPay()">🔓 Thanh toán phần còn lại</button>
    </div>
  </div>

  <div style="text-align:center; margin-top:26px;">
    <a href="dat_in_3d.jsp" style="font-size:13.5px; font-weight:600; color:var(--violet);" onclick="backToCheckout();return false;">← Tạo đơn thiết kế mới</a>
  </div>
</main>

<!-- ============ MODAL: THANH TOÁN PHẦN CÒN LẠI ============ -->
<div class="overlay" id="overlay" onclick="closeModal()"></div>
<div class="modal" id="restModal">
  <div class="modal-box">
    <button class="modal-close" onclick="closeModal()">✕</button>
    <h3>Thanh toán phần còn lại</h3>
    <div class="sub">Đợt 2 · 60% giá trị đơn hàng #PK-09001</div>

    <div class="alert info" style="margin-bottom:20px;">
      <span>💡</span>
      <div>Mẫu thử đã được duyệt — xưởng sẵn sàng sản xuất hàng loạt sau khi nhận đủ phần còn lại.</div>
    </div>

    <div style="background:white; border:1px solid var(--line); border-radius:var(--r-md); padding:18px; margin-bottom:20px;">
      <div style="display:flex; justify-content:space-between; font-size:13.5px; padding:6px 0; color:var(--ink-soft);"><span>Tổng đơn hàng</span><strong>17.800.000đ</strong></div>
      <div style="display:flex; justify-content:space-between; font-size:13.5px; padding:6px 0; color:var(--ink-soft);"><span>Đã đặt cọc (40%)</span><span style="color:var(--teal); font-weight:600;">-7.120.000đ</span></div>
      <div style="display:flex; justify-content:space-between; font-size:17px; font-weight:700; padding:12px 0 0; margin-top:8px; border-top:1px dashed var(--line); font-family:'Space Grotesk';">
        <span>Còn lại</span><span style="color:var(--coral-deep);">10.680.000đ</span>
      </div>
    </div>

    <div class="field"><label>Số thẻ</label><input placeholder="1234 5678 9012 3456" maxlength="19" oninput="formatCard(this)"></div>
    <div class="field-row">
      <div class="field"><label>Ngày hết hạn</label><input placeholder="MM/YY" maxlength="5" oninput="formatExpiry(this)"></div>
      <div class="field"><label>CVC</label><input placeholder="123" maxlength="4"></div>
    </div>

    <div class="modal-actions">
      <button class="btn-secondary" style="flex:1;" onclick="closeModal()">Hủy</button>
      <button class="btn-primary btn-teal" style="flex:2;" onclick="payRest()">🔒 Thanh toán 10.680.000đ</button>
    </div>
  </div>
</div>

<div class="toast" id="toast">Đã thực hiện</div>

<script>
/* ============================================================
   HELPERS
   ============================================================ */
const fmt = n => n.toLocaleString('vi-VN') + 'đ';

let toastTimer;
function toast(msg, type){
  const t = document.getElementById('toast');
  t.textContent = msg;
  t.className = 'toast show' + (type ? ' ' + type : '');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(()=>t.classList.remove('show'), 2400);
}
const toastOk  = m => toast(m, 'ok');
const toastErr = m => toast(m, 'err');

/* ============================================================
   CONSTANTS
   ============================================================ */
const TOTAL = 17800000;
const DEPOSIT_RATE = 0.4;
const FULL_DISCOUNT_RATE = 0.05;

const DEPOSIT   = Math.round(TOTAL * DEPOSIT_RATE);          // 7.120.000
const REMAINING = TOTAL - DEPOSIT;                            // 10.680.000
const FULL_SAVE = Math.round(TOTAL * FULL_DISCOUNT_RATE);    // 890.000
const FULL_PAY  = TOTAL - FULL_SAVE;                          // 16.910.000

let currentPlan = 'deposit';

/* ============================================================
   PLAN SELECTION
   ============================================================ */
function setPlan(plan){
  currentPlan = plan;

  document.querySelectorAll('.plan-card').forEach(c=>{
    c.classList.toggle('active', c.dataset.plan === plan);
  });

  const isFull = plan === 'full';

  // Discount row
  document.getElementById('discRow').style.display = isFull ? 'flex' : 'none';
  document.getElementById('orderTotal').textContent = fmt(isFull ? FULL_PAY : TOTAL);
  document.getElementById('saveTag').style.display = isFull ? 'inline-block' : 'none';

  // Today payment
  if(isFull){
    document.getElementById('todayLabel').textContent = 'Thanh toán hôm nay (toàn bộ đơn)';
    document.getElementById('todayVal').textContent = fmt(FULL_PAY);
    document.getElementById('todaySub').textContent = 'Đã bao gồm ưu đãi 5% — không phát sinh thêm';
  } else {
    document.getElementById('todayLabel').textContent = 'Thanh toán hôm nay (đặt cọc 40%)';
    document.getElementById('todayVal').textContent = fmt(DEPOSIT);
    document.getElementById('todaySub').textContent = 'Còn lại ' + fmt(REMAINING) + ' thanh toán sau khi duyệt mẫu';
  }

  renderSchedule();
  updateTopStep(1);
}

/* ============================================================
   SCHEDULE RENDER
   ============================================================ */
function renderSchedule(){
  const box = document.getElementById('scheduleInner');
  if(currentPlan === 'full'){
    box.innerHTML = `
      <div class="sch-item now">
        <div class="sch-dot">1</div>
        <div class="sch-body"><strong>Thanh toán toàn bộ</strong><span>Thực hiện ngay hôm nay · ưu đãi 5%</span></div>
        <div class="sch-amt" style="color:var(--coral-deep)">${fmt(FULL_PAY)}</div>
      </div>
      <div class="sch-line"></div>
      <div class="sch-item paid">
        <div class="sch-dot">✓</div>
        <div class="sch-body"><strong>Hoàn tất — không còn đợt thanh toán nào</strong><span>Xưởng sản xuất &amp; giao hàng theo tiến độ</span></div>
        <div class="sch-amt" style="color:var(--teal)">0đ</div>
      </div>`;
  } else {
    box.innerHTML = `
      <div class="sch-item now">
        <div class="sch-dot">1</div>
        <div class="sch-body"><strong>Đợt 1 — Đặt cọc 40%</strong><span>Thanh toán ngay để xưởng bắt đầu sản xuất</span></div>
        <div class="sch-amt" style="color:var(--coral-deep)">${fmt(DEPOSIT)}</div>
      </div>
      <div class="sch-line"></div>
      <div class="sch-item later">
        <div class="sch-dot">2</div>
        <div class="sch-body"><strong>Đợt 2 — Phần còn lại 60%</strong><span>Thanh toán sau khi duyệt mẫu thật · trước khi giao hàng</span></div>
        <div class="sch-amt">${fmt(REMAINING)}</div>
      </div>`;
  }
}

/* ============================================================
   PAYMENT METHOD
   ============================================================ */
function pickPayMethod(btn){
  document.querySelectorAll('#payMethods .pay-method').forEach(b=>b.classList.remove('active'));
  btn.classList.add('active');
  const m = btn.dataset.m;
  document.getElementById('cardForm').style.display = (m === 'card') ? 'block' : 'none';
  document.getElementById('bankInfo').style.display = (m === 'bank') ? 'block' : 'none';
}

function formatCard(el){
  let v = el.value.replace(/\D/g,'').slice(0,16);
  el.value = v.replace(/(.{4})/g,'$1 ').trim();
}
function formatExpiry(el){
  let v = el.value.replace(/\D/g,'').slice(0,4);
  if(v.length >= 3) v = v.slice(0,2) + '/' + v.slice(2);
  el.value = v;
}

/* ============================================================
   TOP STEPPER
   ============================================================ */
function updateTopStep(step){
  document.querySelectorAll('#topSteps .s').forEach(s=>{
    const n = parseInt(s.dataset.s, 10);
    s.classList.toggle('active', n === step);
    s.classList.toggle('done', n < step);
  });
}

/* ============================================================
   CONFIRM PAYMENT
   ============================================================ */
function confirmPay(){
  const active = document.querySelector('#payMethods .pay-method.active');
  const method = active ? active.dataset.m : 'card';

  if(method === 'card'){
    const no = document.getElementById('cardNo').value.replace(/\s/g,'');
    if(no.length < 16){ toastErr('Vui lòng nhập đầy đủ số thẻ (16 số)'); document.getElementById('cardNo').focus(); return; }
  }

  const amount = currentPlan === 'full' ? FULL_PAY : DEPOSIT;

  updateTopStep(2);
  const btn = document.querySelector('.summary .btn-primary');
  btn.disabled = true;
  btn.textContent = '⏳ Đang xử lý thanh toán...';

  setTimeout(()=>{
    btn.disabled = false;
    btn.textContent = '🔒 Xác nhận & thanh toán';
    updateTopStep(3);

    // Switch to track view
    document.getElementById('checkoutView').style.display = 'none';
    document.getElementById('trackView').style.display = 'block';
    window.scrollTo(0, 0);

    if(currentPlan === 'full'){
      // Đã trả hết → cập nhật track view
      document.querySelector('.success-view h2').textContent = 'Thanh toán thành công!';
      document.querySelector('.success-view p').innerHTML = 'Bạn đã thanh toán toàn bộ đơn hàng. Xưởng <b>Sài Gòn Print</b> sẽ ưu tiên sản xuất và giao sớm hơn dự kiến.';
      document.querySelector('.pay-schedule h3 .pill').textContent = 'Đã thanh toán 100%';
      document.querySelector('.pay-schedule h3 .pill').style.background = '#E1FBF3';
      document.querySelector('.pay-schedule h3 .pill').style.color = '#0A7A5E';

      // Đổi item thứ 2
      const items = document.querySelectorAll('.ps-item');
      items[0].querySelector('.ps-body strong').textContent = 'Đợt 1 — Thanh toán toàn bộ (đã ưu đãi 5%)';
      items[0].querySelector('.ps-amount').textContent = fmt(FULL_PAY);
      items[1].remove();

      // Ẩn nút thanh toán phần còn lại
      document.getElementById('btnPayRest').style.display = 'none';
      document.querySelector('.alert.warn').style.display = 'none';

      // Cập nhật timeline
      const tl = document.querySelectorAll('.tl-row');
      if(tl[2]) tl[2].querySelector('.tl-body strong').textContent = 'Duyệt mẫu & sản xuất hàng loạt';
      if(tl[2]) tl[2].querySelector('.tl-body span').textContent = 'Đã thanh toán đủ — không cần chờ duyệt cọc';
    }

    toastOk('Thanh toán thành công · ' + fmt(amount));
  }, 1400);
}

/* ============================================================
   REST PAYMENT MODAL
   ============================================================ */
function openRestPay(){
  document.getElementById('overlay').classList.add('show');
  document.getElementById('restModal').classList.add('show');
  document.body.style.overflow = 'hidden';
}
function closeModal(){
  document.getElementById('overlay').classList.remove('show');
  document.querySelectorAll('.modal').forEach(m=>m.classList.remove('show'));
  document.body.style.overflow = '';
}
document.addEventListener('keydown', e=>{ if(e.key === 'Escape') closeModal(); });

function payRest(){
  const inputs = document.querySelectorAll('#restModal input');
  const no = inputs[0].value.replace(/\s/g,'');
  if(no.length < 16){ toastErr('Vui lòng nhập đầy đủ số thẻ'); return; }

  closeModal();
  setTimeout(()=>{
    // Cập nhật UI
    const items = document.querySelectorAll('.ps-item');
    if(items[1]){
      items[1].classList.remove('due');
      items[1].classList.add('paid');
      items[1].querySelector('.ps-icon').textContent = '✓';
      items[1].querySelector('.ps-body strong').textContent = 'Đợt 2 — Đã thanh toán phần còn lại';
      items[1].querySelector('.ps-body span').textContent = 'Đã thanh toán lúc ' + new Date().toLocaleTimeString('vi-VN',{hour:'2-digit',minute:'2-digit'}) + ' · Thẻ ****3456';
    }

    document.querySelector('.pay-schedule h3 .pill').textContent = 'Đã thanh toán 100%';
    document.getElementById('btnPayRest').style.display = 'none';
    document.querySelector('.alert.warn').style.display = 'none';

    // Timeline: đánh dấu bước sản xuất
    const tl = document.querySelectorAll('.tl-row');
    if(tl[2]){ tl[2].querySelector('.tl-dot').classList.remove('active'); tl[2].querySelector('.tl-dot').classList.add('done'); }
    if(tl[3]){ tl[3].querySelector('.tl-dot').classList.add('active'); }

    toastOk('Đã thanh toán phần còn lại ' + fmt(REMAINING) + ' — xưởng bắt đầu sản xuất!');
  }, 400);
}

/* ============================================================
   BACK
   ============================================================ */
function backToCheckout(){
  document.getElementById('trackView').style.display = 'none';
  document.getElementById('checkoutView').style.display = 'block';
  updateTopStep(1);
  window.scrollTo(0, 0);
}

/* ============================================================
   INIT
   ============================================================ */
renderSchedule();
</script>
</body>
</html>