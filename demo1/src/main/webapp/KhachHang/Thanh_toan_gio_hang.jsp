<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>PrintKraft — Thanh toán giỏ hàng</title>
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

  /* Top */
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
  .head-right{margin-left:auto; font-size:13px; color:var(--ink-soft); display:flex; align-items:center; gap:8px;}
  .head-right b{color:var(--teal); font-weight:600;}

  /* Breadcrumb */
  .breadcrumb{max-width:1180px; margin:26px auto 0; padding:0 32px; font-size:13px; color:var(--ink-soft);}
  .breadcrumb a{color:var(--violet); font-weight:600;}

  /* Page */
  .page{max-width:1180px; margin:0 auto; padding:18px 32px 0;}
  .page-head{margin:8px 0 26px;}
  .page-head h1{font-size:36px;}
  .page-head p{color:var(--ink-soft); font-size:14.5px; margin-top:8px;}

  /* Stepper */
  .stepper-full{
    display:flex; align-items:center; gap:6px; background:white; border:1px solid var(--line);
    border-radius:var(--r-md); padding:16px 22px; margin-bottom:24px; box-shadow:var(--shadow-xs);
    overflow-x:auto; scrollbar-width:none;
  }
  .stepper-full::-webkit-scrollbar{display:none;}
  .stepper-full .s{display:flex; align-items:center; gap:10px; flex-shrink:0;}
  .stepper-full .s .n{
    width:32px;height:32px;border-radius:50%; background:#EDEBF5; color:var(--ink-soft);
    display:flex; align-items:center; justify-content:center; font-size:13px; font-weight:700;
    font-family:'Space Grotesk'; transition:.2s; flex-shrink:0;
  }
  .stepper-full .s.active .n{background:var(--grad-primary); color:white; box-shadow:0 6px 16px rgba(108,92,231,0.32);}
  .stepper-full .s.done .n{background:var(--grad-cool); color:#063a2e;}
  .stepper-full .s span{font-size:13px; font-weight:600; color:var(--ink-soft); white-space:nowrap;}
  .stepper-full .s.active span{color:var(--violet);}
  .stepper-full .s.done span{color:var(--teal);}
  .stepper-full .sep{flex:1; min-width:24px; height:2px; background:#EDEBF5; border-radius:999px;}
  .stepper-full .sep.on{background:var(--grad-cool);}

  /* Layout */
  .layout{display:grid; grid-template-columns:1.6fr 1fr; gap:26px; align-items:start;}

  /* Panels */
  .panel{
    background:var(--surface); border:1px solid var(--line); border-radius:var(--r-lg);
    padding:26px; box-shadow:var(--shadow-xs); margin-bottom:22px;
  }
  .panel-head{display:flex; align-items:center; gap:12px; margin-bottom:20px; flex-wrap:wrap;}
  .panel-head .ic{
    width:40px;height:40px;border-radius:12px; display:flex;align-items:center;justify-content:center;
    font-size:18px; color:white; flex-shrink:0;
  }
  .panel-head h3{font-size:19px;}
  .panel-head p{font-size:13px; color:var(--ink-soft); margin-top:2px;}
  .panel-head .count{
    margin-left:auto; font-size:12.5px; color:var(--ink-soft); background:#F2EFFF;
    padding:6px 14px; border-radius:999px; font-weight:600;
  }

  /* Cart list */
  .cart-list{display:flex; flex-direction:column; gap:6px;}
  .cart-row{
    display:grid; grid-template-columns:80px 1fr auto auto; gap:16px; align-items:center;
    padding:16px; border-radius:var(--r-md); border:1px solid var(--line);
    background:#FDFCFF; transition:.2s;
  }
  .cart-row:hover{border-color:rgba(108,92,231,0.3); box-shadow:var(--shadow-xs);}
  .cart-thumb{
    width:80px;height:80px; border-radius:14px; display:flex; align-items:center;
    justify-content:center; color:white; font-family:'Space Grotesk'; font-weight:700;
    font-size:11px; text-align:center; padding:6px; letter-spacing:.04em;
  }
  .cart-info h4{font-size:15px; margin-bottom:3px;}
  .cart-info .meta{font-size:12.5px; color:var(--ink-soft); margin-bottom:6px;}
  .cart-info .unit{font-size:12.5px; color:var(--violet); font-weight:600;}
  .qty-ctrl{display:flex; align-items:center; gap:0; border:1.5px solid var(--line-strong); border-radius:9px; overflow:hidden; background:white;}
  .qty-ctrl button{width:30px; height:32px; font-size:15px; font-weight:600; transition:.16s; color:var(--ink-soft);}
  .qty-ctrl button:hover{background:var(--violet); color:white;}
  .qty-ctrl input{width:46px; height:32px; text-align:center; border:none; outline:none; font-weight:700; font-family:'Space Grotesk'; font-size:14px; background:white;}
  .cart-line-total{text-align:right;}
  .cart-line-total .amt{font-family:'Space Grotesk'; font-weight:700; font-size:16px;}
  .cart-line-total .rm{font-size:12px; color:var(--ink-soft); cursor:pointer; transition:.16s; margin-top:4px; display:inline-block;}
  .cart-line-total .rm:hover{color:var(--coral-deep);}

  .cart-empty{
    text-align:center; padding:60px 20px; color:var(--ink-soft);
    border:1.5px dashed var(--line-strong); border-radius:var(--r-md); background:rgba(255,255,255,0.5);
  }
  .cart-empty .big{font-size:44px; margin-bottom:12px;}
  .cart-empty strong{display:block; font-size:16px; color:var(--ink); margin-bottom:6px;}

  /* Voucher */
  .voucher-section{margin-top:22px; padding-top:22px; border-top:1px dashed var(--line);}
  .voucher-section > label{display:block; font-size:12.5px; font-weight:700; text-transform:uppercase; letter-spacing:.08em; color:var(--ink-soft); margin-bottom:10px;}
  .voucher-input-row{display:flex; gap:10px;}
  .voucher-input-row input{
    flex:1; border:1.5px solid var(--line-strong); border-radius:var(--r-sm);
    padding:13px 16px; font-size:14px; outline:none; background:#FBF9FF;
    transition:.18s; text-transform:uppercase; font-weight:600; letter-spacing:.04em;
  }
  .voucher-input-row input:focus{border-color:var(--violet); background:white; box-shadow:0 0 0 4px rgba(108,92,231,0.12);}
  .voucher-input-row button{
    background:var(--grad-primary); color:white; padding:0 24px; border-radius:var(--r-sm);
    font-weight:600; font-size:13.5px; box-shadow:0 8px 18px rgba(108,92,231,0.28); transition:.18s;
  }
  .voucher-input-row button:hover{transform:translateY(-2px);}

  .voucher-hints{margin-top:12px; display:flex; gap:8px; flex-wrap:wrap; align-items:center; font-size:12px; color:var(--ink-soft);}
  .voucher-hints .vh-label{font-weight:600; margin-right:2px;}
  .voucher-chip{
    background:#F2EFFF; color:var(--violet); font-weight:700; font-size:11.5px;
    padding:5px 12px; border-radius:999px; cursor:pointer; transition:.16s; border:1px dashed transparent;
    font-family:'Space Grotesk'; letter-spacing:.03em;
  }
  .voucher-chip:hover{background:var(--violet); color:white; transform:translateY(-1px);}
  .voucher-chip.freeship{background:#E1FBF3; color:#0A7A5E;}
  .voucher-chip.freeship:hover{background:#00B894; color:white;}

  .voucher-applied{
    margin-top:14px; display:flex; gap:14px; align-items:center; padding:16px 18px;
    background:linear-gradient(135deg,#F5FFFB,#E8FFF7); border:1.5px solid rgba(0,184,148,0.35);
    border-radius:var(--r-md); position:relative;
  }
  .voucher-applied .va-icon{
    width:42px;height:42px;border-radius:12px; background:var(--grad-cool); color:#063a2e;
    display:flex; align-items:center; justify-content:center; font-size:20px; flex-shrink:0;
  }
  .voucher-applied .va-body{flex:1;}
  .voucher-applied .va-body strong{display:block; font-size:14px; color:#0A7A5E;}
  .voucher-applied .va-body span{font-size:12.5px; color:var(--ink-soft);}
  .voucher-applied .va-remove{
    font-size:12.5px; font-weight:600; color:var(--coral-deep); cursor:pointer;
    border:1.5px solid rgba(238,82,83,0.3); padding:7px 13px; border-radius:9px;
    background:white; transition:.18s;
  }
  .voucher-applied .va-remove:hover{background:var(--coral-deep); color:white; border-color:var(--coral-deep);}

  .voucher-msg{margin-top:10px; font-size:12.5px; font-weight:600; display:none;}
  .voucher-msg.err{color:var(--coral-deep); display:block;}
  .voucher-msg.ok{color:var(--teal); display:block;}

  /* Shipping */
  .ship-options{display:flex; flex-direction:column; gap:11px;}
  .ship-opt{
    display:flex; align-items:center; gap:14px; padding:16px; border:1.5px solid var(--line-strong);
    border-radius:var(--r-md); background:white; transition:.18s; text-align:left; width:100%;
  }
  .ship-opt:hover{border-color:var(--violet); background:#FBFAFF;}
  .ship-opt.active{border-color:var(--violet); background:#F6F3FF; box-shadow:0 0 0 4px rgba(108,92,231,0.12);}
  .ship-opt .sh-ic{
    width:42px;height:42px;border-radius:12px; display:flex; align-items:center; justify-content:center;
    font-size:18px; flex-shrink:0; color:white; background:var(--grad-sky);
  }
  .ship-opt .sh-body{flex:1;}
  .ship-opt strong{display:block; font-size:14px;}
  .ship-opt span{font-size:12.5px; color:var(--ink-soft);}
  .ship-opt .sh-fee{font-family:'Space Grotesk'; font-weight:700; font-size:15px; color:var(--violet); white-space:nowrap;}
  .ship-opt .sh-fee.free{color:var(--teal);}
  .ship-opt .radio{width:20px;height:20px;border-radius:50%; border:2px solid var(--line-strong); flex-shrink:0; position:relative;}
  .ship-opt.active .radio{border-color:var(--violet);}
  .ship-opt.active .radio:after{content:""; position:absolute; inset:3px; border-radius:50%; background:var(--violet);}

  /* Payment methods */
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

  /* Fields */
  .field{margin-bottom:14px;}
  .field label{display:block; font-size:12.5px; font-weight:600; margin-bottom:6px; color:var(--ink-soft);}
  .field input, .field select, .field textarea{
    width:100%; border:1.5px solid var(--line); border-radius:var(--r-sm); padding:12px 14px;
    font-size:14px; background:#FBF9FF; outline:none; transition:.18s; color:var(--ink);
  }
  .field input:focus, .field select:focus, .field textarea:focus{border-color:var(--violet); background:white; box-shadow:0 0 0 4px rgba(108,92,231,0.12);}
  .field-row{display:grid; grid-template-columns:1fr 1fr; gap:14px;}

  /* Buttons */
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

  .nav-row{display:flex; gap:10px; margin-top:20px;}
  .nav-row .btn-secondary{flex:1;}
  .nav-row .btn-primary{flex:2;}

  /* Summary sidebar */
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
  .summary .row.ship-free b{color:var(--teal-soft);}
  .summary .row .vcode{
    font-family:'Space Grotesk'; font-size:11px; font-weight:700; letter-spacing:.06em;
    background:rgba(0,184,148,0.22); color:var(--teal-soft); padding:2px 8px; border-radius:6px;
    margin-left:6px;
  }
  .summary .div{height:1px; background:rgba(253,249,243,0.18); margin:14px 0; position:relative;}
  .summary .total-row{display:flex; justify-content:space-between; align-items:flex-end; position:relative; margin-bottom:4px;}
  .summary .total-row span{font-size:13.5px; color:rgba(253,249,243,0.8);}
  .summary .total-row .big{font-family:'Space Grotesk'; font-size:28px; font-weight:700; color:white; line-height:1;}
  .summary .note{font-size:11.5px; color:rgba(253,249,243,0.6); margin-top:6px; position:relative; line-height:1.5;}
  .summary .save-note{
    background:rgba(0,184,148,0.16); border:1px solid rgba(85,239,196,0.35); color:var(--teal-soft);
    padding:10px 14px; border-radius:12px; font-size:12.5px; font-weight:600;
    margin:14px 0 0; position:relative; text-align:center;
  }
  .summary .trust{
    margin-top:16px; padding-top:16px; border-top:1px solid rgba(253,249,243,0.18);
    font-size:11.5px; color:rgba(253,249,243,0.6); line-height:1.7; position:relative;
  }
  .summary .trust div{display:flex; gap:8px; align-items:flex-start; padding:3px 0;}

  /* Success view */
  .success-view{max-width:720px; margin:0 auto; text-align:center; padding:30px 0 40px;}
  .success-icon{
    width:92px;height:92px;border-radius:50%; background:var(--grad-cool); color:#063a2e;
    display:flex;align-items:center;justify-content:center;font-size:44px; margin:0 auto 22px;
    box-shadow:0 16px 40px rgba(0,184,148,0.35);
  }
  .success-view h2{font-size:32px; margin-bottom:12px;}
  .success-view > p{color:var(--ink-soft); font-size:14.5px; margin-bottom:8px;}
  .order-code{
    display:inline-block; font-family:'Space Grotesk'; font-weight:700; font-size:18px;
    background:#F2EFFF; color:var(--violet); padding:12px 24px; border-radius:999px; margin:16px 0 28px;
  }
  .success-box{
    background:white; border:1px solid var(--line); border-radius:var(--r-lg); padding:26px;
    box-shadow:var(--shadow-sm); text-align:left; margin-bottom:22px;
  }
  .success-box h4{font-size:16px; margin-bottom:16px;}
  .success-box .row{display:flex; justify-content:space-between; font-size:13.5px; padding:7px 0; color:var(--ink-soft);}
  .success-box .row b{color:var(--ink);}
  .success-box .row.total{border-top:1px dashed var(--line); margin-top:10px; padding-top:14px; font-family:'Space Grotesk'; font-size:18px; font-weight:700; color:var(--ink);}

  /* Alert */
  .alert{display:flex; gap:12px; padding:14px 16px; border-radius:12px; font-size:13px; line-height:1.6; margin-bottom:18px;}
  .alert.info{background:#EDE9FF; color:#4B3A8F; border:1px dashed rgba(108,92,231,0.4);}

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
    .page-head h1{font-size:28px;}
    header{padding:12px 18px;}
    .page{padding:18px 18px 0;}
    .breadcrumb{padding:0 18px;}
    .cart-row{grid-template-columns:64px 1fr; grid-template-areas:"thumb info" "qty total"; row-gap:12px;}
    .cart-thumb{grid-area:thumb; width:64px; height:64px;}
    .cart-info{grid-area:info;}
    .qty-ctrl{grid-area:qty; justify-self:start;}
    .cart-line-total{grid-area:total; text-align:right;}
    .field-row{grid-template-columns:1fr;}
  }
</style>
</head>
<body>

<div class="utility">
  <span>🚚 Miễn phí vận chuyển cho đơn từ 500.000đ · <b>Voucher 100K</b> cho đơn đầu tiên</span>
  <span>Hỗ trợ: <b>1900 6868</b> · 8:00–21:00</span>
</div>

<header>
  <a href="trang_chu.jsp" class="logo"><span class="mark"></span> PrintKraft</a>
  <div class="head-right">🔒 Thanh toán an toàn · <b>Bảo mật SSL</b></div>
</header>

<div class="breadcrumb"><a href="dat_in_3d.jsp">← Tiếp tục mua sắm</a></div>

<!-- ============ CHECKOUT ============ -->
<main class="page" id="checkoutView">
  <div class="page-head">
    <h1>Thanh toán giỏ hàng</h1>
    <p>Kiểm tra sản phẩm, áp dụng mã giảm giá và hoàn tất đơn hàng chỉ trong vài bước.</p>
  </div>

  <!-- Stepper -->
  <div class="stepper-full" id="stepper">
    <div class="s active" data-s="1"><div class="n">1</div><span>Giỏ hàng</span></div>
    <div class="sep" data-sep="1"></div>
    <div class="s" data-s="2"><div class="n">2</div><span>Giao hàng</span></div>
    <div class="sep" data-sep="2"></div>
    <div class="s" data-s="3"><div class="n">3</div><span>Thanh toán</span></div>
    <div class="sep" data-sep="3"></div>
    <div class="s" data-s="4"><div class="n">4</div><span>Hoàn tất</span></div>
  </div>

  <div class="layout">
    <!-- ===== LEFT ===== -->
    <div class="col-main">

      <!-- STEP 1: CART -->
      <div class="panel" id="step1">
        <div class="panel-head">
          <div class="ic" style="background:var(--grad-primary)">🛒</div>
          <div>
            <h3>Giỏ hàng của bạn</h3>
            <p>Kiểm tra số lượng và sản phẩm trước khi thanh toán</p>
          </div>
          <span class="count" id="cartCount">3 sản phẩm</span>
        </div>

        <div class="cart-list" id="cartList"></div>

        <!-- Voucher -->
        <div class="voucher-section">
          <label>Mã giảm giá / Voucher</label>
          <div class="voucher-input-row">
            <input id="voucherInput" placeholder="Nhập mã..." autocomplete="off">
            <button onclick="applyVoucher()">Áp dụng</button>
          </div>
          <div class="voucher-msg" id="voucherMsg"></div>

          <div class="voucher-hints">
            <span class="vh-label">🎁 Mã có sẵn:</span>
            <span class="voucher-chip" onclick="quickFill('PRINTKRAFT100')">PRINTKRAFT100</span>
            <span class="voucher-chip" onclick="quickFill('SALE10')">SALE10</span>
            <span class="voucher-chip" onclick="quickFill('WELCOME50')">WELCOME50</span>
            <span class="voucher-chip" onclick="quickFill('BULK20')">BULK20</span>
            <span class="voucher-chip freeship" onclick="quickFill('FREESHIP')">FREESHIP</span>
          </div>

          <div id="appliedBox"></div>
        </div>

        <div class="nav-row">
          <button class="btn-secondary" onclick="toast('Đang quay lại trang sản phẩm...')">← Tiếp tục mua</button>
          <button class="btn-primary" onclick="goStep(2)">Tiếp tục →</button>
        </div>
      </div>

      <!-- STEP 2: SHIPPING -->
      <div class="panel" id="step2" style="display:none;">
        <div class="panel-head">
          <div class="ic" style="background:var(--grad-sky)">📦</div>
          <div>
            <h3>Thông tin giao hàng</h3>
            <p>Điền địa chỉ nhận hàng và chọn phương thức vận chuyển</p>
          </div>
        </div>

        <div class="field-row">
          <div class="field"><label>Họ và tên</label><input id="shipName" placeholder="Nguyễn Văn A" value="Nguyễn Minh Anh"></div>
          <div class="field"><label>Số điện thoại</label><input id="shipPhone" placeholder="09xx xxx xxx" value="0901 234 567"></div>
        </div>
        <div class="field"><label>Email</label><input id="shipEmail" placeholder="ban@email.com" value="minhanh@store.vn"></div>
        <div class="field"><label>Địa chỉ giao hàng</label><input id="shipAddr" placeholder="Số nhà, đường, phường, quận, tỉnh" value="128 Nguyễn Đình Chiểu, Q.3, TP.HCM"></div>
        <div class="field"><label>Ghi chú đơn hàng</label><textarea rows="2" placeholder="VD: Giao giờ hành chính, gọi trước khi đến..."></textarea></div>

        <label style="display:block; font-size:12.5px; font-weight:700; text-transform:uppercase; letter-spacing:.08em; color:var(--ink-soft); margin:22px 0 12px;">Phương thức vận chuyển</label>
        <div class="ship-options" id="shipOptions"></div>

        <div class="nav-row">
          <button class="btn-secondary" onclick="goStep(1)">← Quay lại</button>
          <button class="btn-primary" onclick="goStep(3)">Tiếp tục →</button>
        </div>
      </div>

      <!-- STEP 3: PAYMENT -->
      <div class="panel" id="step3" style="display:none;">
        <div class="panel-head">
          <div class="ic" style="background:var(--grad-warm)">💳</div>
          <div>
            <h3>Phương thức thanh toán</h3>
            <p>Chọn cách thanh toán phù hợp với bạn</p>
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
          <button class="pay-method" data-m="cod" onclick="pickPayMethod(this)">
            <div class="ic" style="background:var(--grad-cool); color:#063a2e">💵</div>
            <div class="pm-body"><strong>Thanh toán khi nhận hàng (COD)</strong><span>Phụ phí 15.000đ</span></div>
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
              <b>Nội dung CK:</b> <b style="color:var(--coral-deep)">PK-CART-<span id="ckCode">08231</span></b>
            </div>
          </div>
        </div>

        <label style="display:flex; gap:10px; align-items:flex-start; font-size:13px; color:var(--ink-soft); margin-top:22px;">
          <input type="checkbox" id="agreeTerms" style="margin-top:3px; accent-color:var(--violet);">
          <span>Tôi đồng ý với <a href="lien-he.jsp" style="color:var(--violet); font-weight:600;">Điều khoản dịch vụ</a> và <a href="lien-he.jsp" style="color:var(--violet); font-weight:600;">Chính sách đổi trả</a> của PrintKraft.</span>
        </label>

        <div class="nav-row">
          <button class="btn-secondary" onclick="goStep(2)">← Quay lại</button>
          <button class="btn-primary btn-teal" id="btnConfirm" onclick="confirmOrder()">🔒 Đặt hàng</button>
        </div>
      </div>

    </div>

    <!-- ===== RIGHT: SUMMARY ===== -->
    <aside class="col-side">
      <div class="summary">
        <h3>Đơn hàng của bạn</h3>

        <div class="row"><span>Tạm tính (<span id="sumQty">3</span> sản phẩm)</span><b id="sumSubtotal">0đ</b></div>
        <div class="row" id="rowDiscount" style="display:none;"><span>Giảm giá<span class="vcode" id="sumCode"></span></span><b id="sumDiscount">0đ</b></div>
        <div class="row ship-free" id="rowShipping"><span>Phí vận chuyển</span><b id="sumShipping">Miễn phí</b></div>
        <div class="row" id="rowCod" style="display:none;"><span>Phụ phí COD</span><b>15.000đ</b></div>
        <div class="div"></div>

        <div class="total-row">
          <span>Tổng thanh toán</span>
          <span class="big" id="sumTotal">0đ</span>
        </div>
        <div class="note" id="sumNote">Đã bao gồm VAT</div>

        <div class="save-note" id="saveNote" style="display:none;">🎉 Bạn tiết kiệm được <b id="saveVal">0đ</b></div>

        <div class="trust">
          <div><span>🔒</span><span>Thanh toán mã hóa SSL 256-bit</span></div>
          <div><span>↩️</span><span>Đổi trả miễn phí trong 7 ngày</span></div>
          <div><span>🚚</span><span>Giao toàn quốc 63 tỉnh thành</span></div>
          <div><span>🏭</span><span>120+ xưởng in đối tác đã kiểm duyệt</span></div>
        </div>
      </div>
    </aside>
  </div>
</main>

<!-- ============ SUCCESS VIEW ============ -->
<main class="page" id="successView" style="display:none;">
  <div class="success-view">
    <div class="success-icon">✓</div>
    <h2>Đặt hàng thành công!</h2>
    <p>Cảm ơn bạn đã tin tưởng PrintKraft. Đơn hàng đã được chuyển tới xưởng in.</p>
    <div class="order-code">#PK-08231</div>
  </div>

  <div style="max-width:720px; margin:0 auto;">
    <div class="success-box">
      <h4>Thông tin đơn hàng</h4>
      <div class="row"><span>Người nhận</span><b id="cfName">—</b></div>
      <div class="row"><span>Điện thoại</span><b id="cfPhone">—</b></div>
      <div class="row"><span>Địa chỉ</span><b id="cfAddr" style="text-align:right; max-width:60%;">—</b></div>
      <div class="row"><span>Phương thức</span><b id="cfPay">—</b></div>
      <div class="row"><span>Vận chuyển</span><b id="cfShip">—</b></div>
    </div>

    <div class="success-box">
      <h4>Chi tiết thanh toán</h4>
      <div class="row"><span>Tạm tính</span><span id="cfSubtotal">—</span></div>
      <div class="row" id="cfDiscountRow" style="display:none;"><span>Giảm giá <span id="cfCode" style="font-family:'Space Grotesk'; font-weight:700; color:var(--teal);"></span></span><span id="cfDiscount" style="color:var(--teal); font-weight:600;">0đ</span></div>
      <div class="row"><span>Phí vận chuyển</span><span id="cfShipFee">—</span></div>
      <div class="row total"><span>Tổng thanh toán</span><span id="cfTotal">—</span></div>
    </div>

    <div style="background:#FFF4E0; border:1px dashed rgba(255,179,71,0.7); border-radius:14px; padding:16px 20px; font-size:13.5px; color:#8A5A00; line-height:1.6; margin-bottom:22px;">
      📧 Hóa đơn điện tử đã được gửi tới <b>minhanh@store.vn</b>. Xưởng in sẽ xác nhận đơn trong vòng 30 phút.
    </div>

    <div style="display:flex; gap:12px; flex-wrap:wrap;">
      <button class="btn-secondary" style="flex:1; min-width:180px;" onclick="toast('Đang mở trang theo dõi đơn hàng...')">Theo dõi đơn hàng</button>
      <button class="btn-primary" style="flex:1.4; min-width:220px;" onclick="location.reload()">Tiếp tục mua sắm</button>
    </div>
  </div>
</main>

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
   STATE
   ============================================================ */
let cart = [
  { id:1, name:'Áo thun Oversize Cotton', meta:'DTG · Size L · Màu Navy', price:129000, qty:24, grad:'var(--grad-primary)', label:'ÁO THUN' },
  { id:2, name:'Cốc sứ trắng 2 mặt', meta:'Sublimation · 350ml', price:65000, qty:2, grad:'var(--grad-warm)', label:'CỐC SỨ' },
  { id:3, name:'Poster A2 giấy mỹ thuật', meta:'In UV · 40 tờ', price:89000, qty:40, grad:'var(--grad-cool)', label:'POSTER' }
];

const VOUCHERS = {
  PRINTKRAFT100: { code:'PRINTKRAFT100', type:'fixed', value:100000, min:500000, label:'Giảm 100.000đ', desc:'Áp dụng cho đơn từ 500.000đ' },
  SALE10:        { code:'SALE10',        type:'percent', value:10, max:200000, label:'Giảm 10% (tối đa 200.000đ)', desc:'Áp dụng cho mọi đơn hàng' },
  WELCOME50:     { code:'WELCOME50',     type:'fixed', value:50000, min:200000, label:'Giảm 50.000đ', desc:'Áp dụng cho đơn từ 200.000đ' },
  BULK20:        { code:'BULK20',        type:'percent', value:20, max:1000000, min:5000000, label:'Giảm 20% (tối đa 1.000.000đ)', desc:'Áp dụng cho đơn từ 5.000.000đ' },
  FREESHIP:      { code:'FREESHIP',      type:'freeship', value:50000, label:'Miễn phí vận chuyển', desc:'Giảm tối đa 50.000đ phí ship' }
};

const SHIPPING = {
  standard: { label:'Giao tiêu chuẩn', time:'Dự kiến 3–5 ngày', fee:0,   ic:'🚚' },
  express:  { label:'Giao nhanh',      time:'Dự kiến 1–2 ngày', fee:30000, ic:'⚡' },
  fast:     { label:'Hỏa tốc 24h',     time:'Nhận hàng trong 24h', fee:60000, ic:'🚀' }
};

let appliedVoucher = null;
let shippingMethod = 'standard';
let payMethod = 'card';

/* ============================================================
   RENDER CART
   ============================================================ */
function renderCart(){
  const list = document.getElementById('cartList');
  if(cart.length === 0){
    list.innerHTML = `
      <div class="cart-empty">
        <div class="big">🛒</div>
        <strong>Giỏ hàng đang trống</strong>
        <p>Thêm sản phẩm để tiếp tục thanh toán</p>
      </div>`;
    document.getElementById('cartCount').textContent = '0 sản phẩm';
    updateSummary();
    return;
  }

  list.innerHTML = cart.map(item=>`
    <div class="cart-row">
      <div class="cart-thumb" style="background:${item.grad}">${item.label}</div>
      <div class="cart-info">
        <h4>${item.name}</h4>
        <div class="meta">${item.meta}</div>
        <div class="unit">${fmt(item.price)} / sản phẩm</div>
      </div>
      <div class="qty-ctrl">
        <button onclick="changeQty(${item.id}, -1)">−</button>
        <input type="number" min="1" value="${item.qty}" onchange="setQty(${item.id}, this.value)">
        <button onclick="changeQty(${item.id}, 1)">+</button>
      </div>
      <div class="cart-line-total">
        <div class="amt">${fmt(item.price * item.qty)}</div>
        <span class="rm" onclick="removeItem(${item.id})">🗑️ Xóa</span>
      </div>
    </div>
  `).join('');

  const totalQty = cart.reduce((s,i)=>s+i.qty, 0);
  document.getElementById('cartCount').textContent = cart.length + ' sản phẩm · ' + totalQty + ' món';
  updateSummary();
}

function changeQty(id, delta){
  const it = cart.find(i=>i.id === id);
  if(!it) return;
  const nv = it.qty + delta;
  if(nv < 1){ removeItem(id); return; }
  it.qty = nv;
  renderCart();
}
function setQty(id, v){
  const it = cart.find(i=>i.id === id);
  if(!it) return;
  const nv = Math.max(1, parseInt(v,10) || 1);
  it.qty = nv;
  renderCart();
}
function removeItem(id){
  cart = cart.filter(i=>i.id !== id);
  renderCart();
  toast('Đã xóa sản phẩm khỏi giỏ hàng');
}

/* ============================================================
   VOUCHER
   ============================================================ */
function quickFill(code){
  document.getElementById('voucherInput').value = code;
  applyVoucher();
}

function applyVoucher(){
  const input = document.getElementById('voucherInput');
  const msg = document.getElementById('voucherMsg');
  const code = input.value.trim().toUpperCase();
  msg.className = 'voucher-msg';

  if(!code){
    msg.textContent = 'Vui lòng nhập mã giảm giá.';
    msg.classList.add('err');
    return;
  }

  const v = VOUCHERS[code];
  if(!v){
    msg.textContent = '❌ Mã "' + code + '" không tồn tại hoặc đã hết hạn.';
    msg.classList.add('err');
    return;
  }

  const subtotal = getSubtotal();
  if(v.min && subtotal < v.min){
    msg.textContent = '❌ Đơn hàng chưa đủ điều kiện. Cần tối thiểu ' + fmt(v.min) + ' (hiện tại ' + fmt(subtotal) + ').';
    msg.classList.add('err');
    return;
  }

  appliedVoucher = v;
  msg.textContent = '';
  msg.className = 'voucher-msg';
  input.value = '';
  renderAppliedVoucher();
  updateSummary();
  toastOk('Đã áp dụng mã ' + v.code);
}

function renderAppliedVoucher(){
  const box = document.getElementById('appliedBox');
  if(!appliedVoucher){ box.innerHTML = ''; return; }

  const v = appliedVoucher;
  let amount = 0;
  if(v.type === 'fixed') amount = v.value;
  else if(v.type === 'percent') amount = Math.min(Math.round(getSubtotal()*v.value/100), v.max);
  else if(v.type === 'freeship') amount = Math.min(SHIPPING[shippingMethod].fee, v.value);

  const amtText = v.type === 'freeship'
    ? 'Giảm ' + fmt(amount) + ' phí vận chuyển'
    : 'Giảm ' + fmt(amount);

  box.innerHTML = `
    <div class="voucher-applied">
      <div class="va-icon">🎁</div>
      <div class="va-body">
        <strong>${v.label}</strong>
        <span>Mã <b style="font-family:'Space Grotesk'; letter-spacing:.05em;">${v.code}</b> · ${amtText}</span>
      </div>
      <button class="va-remove" onclick="removeVoucher()">Hủy</button>
    </div>`;
}

function removeVoucher(){
  appliedVoucher = null;
  renderAppliedVoucher();
  updateSummary();
  toast('Đã hủy mã giảm giá');
}

/* ============================================================
   SHIPPING
   ============================================================ */
function renderShipping(){
  const box = document.getElementById('shipOptions');
  box.innerHTML = Object.entries(SHIPPING).map(([key, s])=>{
    const isActive = key === shippingMethod;
    const feeText = s.fee === 0 ? 'Miễn phí' : fmt(s.fee);
    const feeClass = s.fee === 0 ? 'free' : '';
    return `
      <button class="ship-opt ${isActive?'active':''}" onclick="pickShipping('${key}')">
        <div class="sh-ic">${s.ic}</div>
        <div class="sh-body">
          <strong>${s.label}</strong>
          <span>${s.time}</span>
        </div>
        <div class="sh-fee ${feeClass}">${feeText}</div>
        <div class="radio"></div>
      </button>`;
  }).join('');
}
function pickShipping(key){
  shippingMethod = key;
  renderShipping();
  renderAppliedVoucher();
  updateSummary();
}

/* ============================================================
   PAYMENT METHOD
   ============================================================ */
function pickPayMethod(btn){
  document.querySelectorAll('#payMethods .pay-method').forEach(b=>b.classList.remove('active'));
  btn.classList.add('active');
  payMethod = btn.dataset.m;
  document.getElementById('cardForm').style.display = (payMethod === 'card') ? 'block' : 'none';
  document.getElementById('bankInfo').style.display = (payMethod === 'bank') ? 'block' : 'none';
  updateSummary();
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
   CALCULATIONS
   ============================================================ */
function getSubtotal(){ return cart.reduce((s,i)=>s + i.price*i.qty, 0); }
function getTotalQty(){ return cart.reduce((s,i)=>s + i.qty, 0); }

function getDiscount(){
  if(!appliedVoucher) return 0;
  const v = appliedVoucher;
  if(v.type === 'fixed') return Math.min(v.value, getSubtotal());
  if(v.type === 'percent') return Math.min(Math.round(getSubtotal()*v.value/100), v.max);
  return 0; // freeship tính riêng ở shipping
}

function getShippingFee(){
  let fee = SHIPPING[shippingMethod].fee;
  if(appliedVoucher && appliedVoucher.type === 'freeship'){
    fee = Math.max(0, fee - appliedVoucher.value);
  }
  // Miễn phí vận chuyển cho đơn từ 500k (chỉ áp dụng cho standard)
  if(shippingMethod === 'standard' && getSubtotal() - getDiscount() >= 500000){
    fee = 0;
  }
  return fee;
}

function getCodFee(){ return payMethod === 'cod' ? 15000 : 0; }

function getTotal(){
  return Math.max(0, getSubtotal() - getDiscount() + getShippingFee() + getCodFee());
}

/* ============================================================
   UPDATE SUMMARY
   ============================================================ */
function updateSummary(){
  const subtotal = getSubtotal();
  const discount = getDiscount();
  const ship = getShippingFee();
  const cod = getCodFee();
  const total = subtotal - discount + ship + cod;

  document.getElementById('sumQty').textContent = getTotalQty();
  document.getElementById('sumSubtotal').textContent = fmt(subtotal);

  // Discount row
  const rowDisc = document.getElementById('rowDiscount');
  if(discount > 0){
    rowDisc.style.display = 'flex';
    document.getElementById('sumCode').textContent = appliedVoucher.code;
    document.getElementById('sumDiscount').textContent = '-' + fmt(discount);
  } else {
    rowDisc.style.display = 'none';
  }

  // Shipping
  const rowShip = document.getElementById('rowShipping');
  const shEl = document.getElementById('sumShipping');
  if(ship === 0){
    shEl.textContent = 'Miễn phí';
    shEl.style.color = 'var(--teal-soft)';
  } else {
    shEl.textContent = fmt(ship);
    shEl.style.color = 'white';
  }
  // Nhãn ship khi có freeship
  if(appliedVoucher && appliedVoucher.type === 'freeship' && SHIPPING[shippingMethod].fee > 0){
    rowShip.querySelector('span').innerHTML = `Phí vận chuyển <span class="vcode">${appliedVoucher.code}</span>`;
  } else {
    rowShip.querySelector('span').textContent = 'Phí vận chuyển';
  }

  // COD
  document.getElementById('rowCod').style.display = cod > 0 ? 'flex' : 'none';

  // Total
  document.getElementById('sumTotal').textContent = fmt(total);

  // Save note
  const saveBox = document.getElementById('saveNote');
  const totalSave = discount + (SHIPPING[shippingMethod].fee - ship);
  if(totalSave > 0){
    saveBox.style.display = 'block';
    document.getElementById('saveVal').textContent = fmt(totalSave);
  } else {
    saveBox.style.display = 'none';
  }

  // Cập nhật nút confirm
  const btn = document.getElementById('btnConfirm');
  if(btn) btn.textContent = '🔒 Thanh toán ' + fmt(total);
}

/* ============================================================
   STEP NAVIGATION
   ============================================================ */
let currentStep = 1;

function goStep(n){
  // Validate
  if(n === 2){
    if(cart.length === 0){ toastErr('Giỏ hàng đang trống'); return; }
  }
  if(n === 3){
    const name = document.getElementById('shipName').value.trim();
    const phone = document.getElementById('shipPhone').value.trim();
    const addr = document.getElementById('shipAddr').value.trim();
    if(!name || !phone || !addr){
      toastErr('Vui lòng điền đầy đủ thông tin giao hàng');
      return;
    }
  }

  currentStep = n;
  [1,2,3].forEach(i=>{
    document.getElementById('step'+i).style.display = (i === n) ? 'block' : 'none';
  });

  document.querySelectorAll('#stepper .s').forEach(s=>{
    const sn = parseInt(s.dataset.s, 10);
    s.classList.toggle('active', sn === n);
    s.classList.toggle('done', sn < n);
  });
  document.querySelectorAll('#stepper .sep').forEach(sep=>{
    const sn = parseInt(sep.dataset.sep, 10);
    sep.classList.toggle('on', sn < n);
  });

  window.scrollTo({ top: 0, behavior:'smooth' });
}

/* ============================================================
   CONFIRM ORDER
   ============================================================ */
function confirmOrder(){
  if(!document.getElementById('agreeTerms').checked){
    toastErr('Vui lòng đồng ý với điều khoản dịch vụ');
    return;
  }
  if(cart.length === 0){ toastErr('Giỏ hàng đang trống'); return; }

  if(payMethod === 'card'){
    const no = document.getElementById('cardNo').value.replace(/\s/g,'');
    if(no.length < 16){ toastErr('Vui lòng nhập đầy đủ số thẻ (16 số)'); return; }
  }

  const btn = document.getElementById('btnConfirm');
  btn.disabled = true;
  btn.textContent = '⏳ Đang xử lý...';

  setTimeout(()=>{
    // Đánh dấu step 4 done
    document.querySelectorAll('#stepper .s').forEach(s=>{
      const sn = parseInt(s.dataset.s,10);
      s.classList.toggle('done', sn < 4);
      s.classList.toggle('active', sn === 4);
    });
    document.querySelectorAll('#stepper .sep').forEach(sep=>{
      const sn = parseInt(sep.dataset.sep,10);
      sep.classList.toggle('on', true);
    });

    // Điền thông tin xác nhận
    document.getElementById('cfName').textContent = document.getElementById('shipName').value;
    document.getElementById('cfPhone').textContent = document.getElementById('shipPhone').value;
    document.getElementById('cfAddr').textContent = document.getElementById('shipAddr').value;
    document.getElementById('cfPay').textContent = {
      card:'Thẻ tín dụng/ghi nợ', bank:'Chuyển khoản', wallet:'Ví điện tử', cod:'COD'
    }[payMethod];
    document.getElementById('cfShip').textContent = SHIPPING[shippingMethod].label;

    document.getElementById('cfSubtotal').textContent = fmt(getSubtotal());

    const disc = getDiscount();
    if(disc > 0){
      document.getElementById('cfDiscountRow').style.display = 'flex';
      document.getElementById('cfCode').textContent = appliedVoucher.code;
      document.getElementById('cfDiscount').textContent = '-' + fmt(disc);
    } else {
      document.getElementById('cfDiscountRow').style.display = 'none';
    }

    document.getElementById('cfShipFee').textContent = getShippingFee() === 0 ? 'Miễn phí' : fmt(getShippingFee());
    document.getElementById('cfTotal').textContent = fmt(getTotal());

    // Chuyển view
    document.getElementById('checkoutView').style.display = 'none';
    document.getElementById('successView').style.display = 'block';
    window.scrollTo({ top: 0, behavior:'smooth' });

    toastOk('Đặt hàng thành công!');
  }, 1500);
}

/* ============================================================
   INIT
   ============================================================ */
renderCart();
renderShipping();
renderAppliedVoucher();
updateSummary();
</script>
</body>
</html>