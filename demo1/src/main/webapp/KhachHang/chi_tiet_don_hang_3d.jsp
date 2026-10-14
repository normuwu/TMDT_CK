<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>PrintKraft — Chi tiết đơn hàng</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<style>
  /* ============================================================
     TOKENS — đồng bộ với hệ thống PrintKraft hiện tại
     (copy từ dat_in_3d.html / Mẫu trang.html, không đổi token)
     ============================================================ */
  :root{
    --ink:#1B1B2F;
    --ink-soft:#4A4A6A;
    --cream:#FDF9F3;
    --surface:#FFFFFF;

    --violet:#6C5CE7;
    --violet-soft:#A29BFE;
    --coral:#FF6B6B;
    --coral-deep:#EE5253;
    --amber:#FFB347;
    --teal:#00B894;
    --teal-soft:#55EFC4;
    --pink:#FD79A8;
    --sky:#48A9F8;

    --grad-primary: linear-gradient(135deg,#6C5CE7 0%,#A29BFE 100%);
    --grad-warm: linear-gradient(135deg,#FF6B6B 0%,#FFB347 100%);
    --grad-cool: linear-gradient(135deg,#00B894 0%,#55EFC4 100%);
    --grad-sky: linear-gradient(135deg,#48A9F8 0%,#6C5CE7 100%);

    --line: rgba(27,27,47,0.10);
    --line-strong: rgba(27,27,47,0.18);

    --shadow-xs: 0 1px 3px rgba(27,27,47,0.06);
    --shadow-sm: 0 4px 14px rgba(27,27,47,0.07);
    --shadow-md: 0 12px 32px rgba(27,27,47,0.11);
    --shadow-lg: 0 24px 60px rgba(27,27,47,0.18);
    --shadow-glow: 0 12px 34px rgba(108,92,231,0.32);

    --r-sm:10px; --r-md:16px; --r-lg:22px; --r-xl:28px;
  }
  *{box-sizing:border-box; margin:0; padding:0;}
  html{scroll-behavior:smooth;}
  body{
    color:var(--ink);
    font-family:'IBM Plex Sans', sans-serif;
    line-height:1.55;
    background:
      radial-gradient(1100px 620px at 8% -8%, rgba(108,92,231,0.13), transparent 62%),
      radial-gradient(880px 520px at 96% -4%, rgba(255,107,107,0.13), transparent 58%),
      radial-gradient(900px 640px at 50% 104%, rgba(0,184,148,0.10), transparent 62%),
      var(--cream);
    background-attachment: fixed;
  }
  h1,h2,h3,h4,h5{font-family:'Space Grotesk', sans-serif; letter-spacing:-0.02em; line-height:1.15;}
  a{color:inherit; text-decoration:none;}
  img,svg,canvas{display:block;}
  button{font-family:inherit; cursor:pointer; border:none; background:none; color:inherit;}
  input,select,textarea{font-family:inherit;}
  :focus-visible{outline:3px solid rgba(108,92,231,0.45); outline-offset:2px; border-radius:6px;}

  /* ===== Utility bar ===== */
  .utility{
    background:linear-gradient(90deg,#1B1B2F 0%, #2D2B55 50%, #1B1B2F 100%);
    color:rgba(253,249,243,0.82);
    font-size:12.5px; padding:9px 32px;
    display:flex; justify-content:space-between; flex-wrap:wrap; gap:8px;
  }
  .utility b{color:var(--amber); font-weight:600;}

  /* ===== Header ===== */
  header{
    background:rgba(253,249,243,0.88);
    backdrop-filter:blur(14px); -webkit-backdrop-filter:blur(14px);
    border-bottom:1px solid var(--line);
    padding:12px 32px; display:flex; align-items:center; gap:16px;
    position:sticky; top:0; z-index:50;
  }
  .logo{font-size:22px; font-weight:700; display:flex; align-items:center; gap:10px; white-space:nowrap; flex-shrink:0; font-family:'Space Grotesk';}
  .logo .mark{
    width:28px;height:28px; background:var(--grad-warm);
    display:inline-block; transform: rotate(45deg); border-radius:8px;
    box-shadow:0 6px 16px rgba(255,107,107,0.4);
  }
  nav{
    display:flex; gap:4px; font-size:14px; font-weight:500;
    overflow-x:auto; scrollbar-width:none; -ms-overflow-style:none;
    flex:1; min-width:0; padding:2px;
  }
  nav::-webkit-scrollbar{display:none;}
  nav a{
    padding:9px 14px; border-radius:999px; white-space:nowrap;
    color:var(--ink-soft); transition:.18s; flex-shrink:0;
  }
  nav a:hover{background:rgba(108,92,231,0.10); color:var(--violet);}
  nav a.active{background:var(--grad-primary); color:#fff; box-shadow:0 6px 16px rgba(108,92,231,0.30);}
  .head-actions{display:flex; align-items:center; gap:14px; font-size:13px; font-weight:500; flex-shrink:0; margin-left:auto;}
  .cart-btn{
    display:flex; align-items:center; gap:7px; background:var(--grad-warm); color:white;
    padding:10px 16px; border-radius:999px; font-weight:600; font-size:13.5px;
    box-shadow:0 8px 20px rgba(255,107,107,0.32); transition:.18s; white-space:nowrap;
  }
  .cart-btn:hover{transform:translateY(-2px);}
  .badge{background:rgba(255,255,255,0.28); border-radius:999px; padding:1px 8px; font-size:11.5px;}

  /* ===== Buttons (tái sử dụng) ===== */
  .btn-primary{
    background:var(--grad-primary); color:white; padding:14px 26px; border-radius:var(--r-sm);
    font-weight:600; font-size:14.5px; display:inline-block; text-align:center;
    box-shadow:var(--shadow-glow); transition:.2s;
  }
  .btn-primary:hover{transform:translateY(-2px); box-shadow:0 18px 40px rgba(108,92,231,0.42);}
  .btn-secondary{
    border:1.5px solid var(--line-strong); padding:14px 26px; border-radius:var(--r-sm);
    font-weight:600; font-size:14.5px; background:var(--surface); color:var(--ink);
    display:inline-block; text-align:center; transition:.2s;
  }
  .btn-secondary:hover{border-color:var(--violet); color:var(--violet); transform:translateY(-2px);}
  .btn-sm{padding:10px 16px; font-size:13px; border-radius:9px; box-shadow:none;}
  .btn-primary.btn-sm:hover,.btn-secondary.btn-sm:hover{transform:translateY(-1px);}
  .btn-danger:hover{border-color:var(--coral-deep) !important; color:var(--coral-deep) !important; background:#FFF5F5;}
  .btn:disabled,button:disabled{opacity:.45; cursor:not-allowed; transform:none !important;}

  /* ===== Status badge (tái sử dụng .status-badge của hệ thống) ===== */
  .status-badge{font-size:11.5px; font-weight:700; padding:6px 13px; border-radius:999px; text-transform:uppercase; letter-spacing:.04em; white-space:nowrap; display:inline-flex; align-items:center; gap:6px;}
  .st-pending{background:#FFF4E0; color:#9A6200;}
  .st-quote{background:#FFF6D6; color:#8A6D00;}
  .st-producing{background:#EDE9FF; color:#5A46D6;}
  .st-shipping{background:#E1F0FF; color:#0C63B8;}
  .st-delivered{background:#E1FBF3; color:#0A7A5E;}
  .st-cancelled{background:#FFE9E9; color:#C0392B;}

  /* ===== Layout trang ===== */
  .page-wrap{max-width:1280px; margin:0 auto; padding:26px 32px 66px; min-height:60vh;}

  .breadcrumb{font-size:13px; color:var(--ink-soft); display:flex; gap:8px; align-items:center; flex-wrap:wrap; margin-bottom:18px;}
  .breadcrumb a:hover{color:var(--violet);}
  .breadcrumb b{color:var(--ink); font-family:'Space Grotesk';}

  .order-head{display:flex; justify-content:space-between; align-items:flex-start; gap:20px; flex-wrap:wrap; margin-bottom:22px;}
  .order-head h1{font-size:34px;}
  .order-meta{display:flex; align-items:center; gap:12px; flex-wrap:wrap; margin-top:12px;}
  .order-code{
    font-family:'Space Grotesk'; font-weight:700; font-size:15px;
    background:#F2EFFF; color:var(--violet); padding:7px 15px; border-radius:999px;
  }
  .order-sub{color:var(--ink-soft); font-size:13.5px; margin-top:10px;}

  /* Tiến trình trạng thái */
  .track-card{background:var(--surface); border:1px solid var(--line); border-radius:var(--r-lg); padding:24px 26px; box-shadow:var(--shadow-xs);}
  .track-card > h3{font-size:18px; margin-bottom:4px;}
  .track-card > .sub{font-size:13px; color:var(--ink-soft); margin-bottom:20px;}
  .track-steps{display:flex; align-items:flex-start; gap:6px;}
  .ts{flex:1; min-width:0; display:flex; flex-direction:column; align-items:center; gap:9px; position:relative; text-align:center;}
  .ts .dot{
    width:24px;height:24px;border-radius:50%; background:#E4E2EF; color:#9A99B5;
    display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:700;
    flex-shrink:0; z-index:1; transition:.2s;
  }
  .ts.done .dot{background:var(--grad-cool); color:#063a2e;}
  .ts.active .dot{background:var(--grad-warm); color:#fff; box-shadow:0 0 0 5px rgba(255,107,107,0.18);}
  .ts .lbl{font-size:11.5px; font-weight:600; color:var(--ink-soft); line-height:1.35;}
  .ts.done .lbl{color:var(--ink);}
  .ts.active .lbl{color:var(--coral-deep);}
  .ts:not(:last-child):after{content:""; position:absolute; top:11px; left:50%; width:100%; height:2px; background:#E4E2EF; z-index:0;}
  .ts.done:not(:last-child):after{background:var(--grad-cool);}
  .track-note{margin-top:20px; padding-top:16px; border-top:1px dashed var(--line); font-size:13.5px; color:var(--ink-soft);}
  .track-note b{color:var(--ink); font-family:'Space Grotesk';}

  /* Lưới 2 cột */
  .detail-grid{display:grid; grid-template-columns:1.42fr 1fr; gap:22px; align-items:start; margin-top:22px;}
  .dcol{display:flex; flex-direction:column; gap:18px; min-width:0;}
  .dcol.right{position:sticky; top:86px; align-self:start;}

  /* Card chung */
  .card{background:var(--surface); border:1px solid var(--line); border-radius:var(--r-lg); padding:22px 24px; box-shadow:var(--shadow-xs);}
  .card > h3{font-size:17px; margin-bottom:4px; display:flex; align-items:center; gap:9px;}
  .card > .sub{font-size:13px; color:var(--ink-soft); margin-bottom:16px;}
  .card.critical{border-color:rgba(255,107,107,0.35); box-shadow:var(--shadow-sm);}
  .card.critical > h3{color:var(--coral-deep);}
  .card.quote{border-color:rgba(108,92,231,0.35); box-shadow:var(--shadow-sm);}

  .chip-note{
    display:inline-flex; align-items:center; gap:7px; font-size:11.5px; font-weight:700; letter-spacing:.03em;
    text-transform:uppercase; background:#F2EFFF; color:var(--violet); padding:5px 12px; border-radius:999px;
  }

  /* Key/value */
  .kv-grid{display:grid; grid-template-columns:repeat(2,1fr); gap:11px;}
  .kv-grid.three{grid-template-columns:repeat(3,1fr);}
  .kv{background:#FBF9FF; border:1px solid var(--line); border-radius:var(--r-sm); padding:12px 14px; min-width:0;}
  .kv span{display:block; font-size:10.5px; font-weight:700; letter-spacing:.06em; text-transform:uppercase; color:var(--ink-soft);}
  .kv strong{display:block; font-size:14.5px; font-weight:600; margin-top:5px; word-break:break-word;}
  .kv strong.muted{color:var(--ink-soft); font-weight:500; font-size:13.5px;}
  .swatch-inline{display:inline-flex; align-items:center; gap:8px;}
  .swatch-inline i{width:15px;height:15px;border-radius:50%; outline:1.5px solid var(--line-strong); display:inline-block; flex-shrink:0;}

  /* Yêu cầu khách — đọc nguyên văn */
  .verbatim{
    background:#FBF9FF; border:1px dashed var(--line-strong); border-radius:var(--r-md);
    padding:16px 18px; font-size:14px; line-height:1.65; white-space:pre-wrap; color:var(--ink);
  }
  .readonly-tag{font-size:11px; font-weight:700; color:var(--ink-soft); text-transform:uppercase; letter-spacing:.06em;}
  .readonly-tag:before{content:"🔒 ";}
  .notice-line{display:flex; gap:10px; align-items:flex-start; font-size:12.5px; color:var(--ink-soft); margin-top:14px; line-height:1.55;}

  /* Banner cảnh báo */
  .banner{
    display:flex; gap:11px; align-items:flex-start; border-radius:var(--r-sm);
    padding:13px 15px; font-size:13px; line-height:1.55; margin-bottom:16px;
  }
  .banner.amber{background:#FFF4E0; border:1px dashed rgba(255,179,71,0.7); color:#8A5A00;}
  .banner.violet{background:#F4F1FF; border:1px dashed rgba(108,92,231,0.45); color:#4B3ABF;}
  .banner.teal{background:#E7FBF4; border:1px dashed rgba(0,184,148,0.45); color:#0A7A5E;}
  .banner.coral{background:#FFECEC; border:1px dashed rgba(238,82,83,0.45); color:#B5312F;}
  .banner b{font-weight:700;}

  /* 3D viewer */
  .viewer-stage{
    height:380px; border-radius:var(--r-md); border:1px solid var(--line);
    position:relative; overflow:hidden; margin-bottom:14px;
    background:
      radial-gradient(420px 260px at 50% 38%, rgba(108,92,231,0.10), transparent 70%),
      repeating-linear-gradient(45deg, rgba(27,27,47,0.03) 0 12px, transparent 12px 24px),
      #FDFCFF;
  }
  .viewer-stage canvas{width:100%; height:100%; touch-action:none; cursor:grab;}
  .viewer-stage canvas:active{cursor:grabbing;}
  .viewer-stage:fullscreen{height:100vh; width:100vw; border-radius:0; border:none;}
  .stage-badge{
    position:absolute; top:12px; left:12px; z-index:3;
    background:rgba(255,255,255,0.92); backdrop-filter:blur(6px);
    border:1px solid var(--line); border-radius:999px;
    font-size:11.5px; font-weight:700; padding:5px 12px; color:var(--ink-soft);
  }
  .stage-hint{
    position:absolute; bottom:12px; right:12px; z-index:3; font-size:11.5px; color:var(--ink-soft);
    background:rgba(255,255,255,0.88); border:1px solid var(--line); border-radius:999px; padding:5px 12px;
  }
  .stage-empty{
    position:absolute; inset:0; display:none; flex-direction:column; align-items:center; justify-content:center;
    gap:8px; text-align:center; padding:26px; color:var(--ink-soft);
  }
  .stage-empty .ic{
    width:60px;height:60px;border-radius:18px; background:#EDE9FF; color:var(--violet);
    display:flex;align-items:center;justify-content:center;font-size:26px; margin-bottom:4px;
  }
  .stage-empty h4{font-size:16px; color:var(--ink);}
  .stage-empty p{font-size:13px; max-width:36ch;}
  .viewer-tools{display:flex; gap:8px; justify-content:center; flex-wrap:wrap; margin-bottom:16px;}
  .viewer-tools button{
    background:#F7F4FF; border:1px solid var(--line); border-radius:9px; padding:8px 13px;
    font-size:12.5px; font-weight:500; transition:.18s;
  }
  .viewer-tools button:hover:not(:disabled){background:var(--violet); color:white; border-color:var(--violet);}
  .viewer-tools button.on{background:var(--grad-primary); color:white; border-color:transparent;}

  .dims{display:grid; grid-template-columns:repeat(4,1fr); gap:10px;}
  .dim{background:#FBF9FF; border:1px solid var(--line); border-radius:var(--r-sm); padding:11px 13px;}
  .dim span{display:block; font-size:10.5px; font-weight:700; letter-spacing:.07em; text-transform:uppercase; color:var(--ink-soft);}
  .dim strong{display:block; font-family:'Space Grotesk'; font-size:16px; font-weight:700; margin-top:3px;}
  .dim.vol strong{color:var(--violet);}
  .dim strong.pending{color:var(--amber); font-size:13.5px; font-weight:600; font-family:'IBM Plex Sans';}

  /* Checklist xưởng đang kiểm tra */
  .check-row{display:flex; gap:11px; align-items:center; padding:9px 0; border-bottom:1px dashed var(--line); font-size:13.5px;}
  .check-row:last-child{border-bottom:none;}
  .check-row .ic{width:22px;height:22px;border-radius:50%; display:flex;align-items:center;justify-content:center; font-size:11px; font-weight:700; flex-shrink:0;}
  .check-row.done .ic{background:var(--grad-cool); color:#063a2e;}
  .check-row.active .ic{background:var(--grad-warm); color:#fff; box-shadow:0 0 0 4px rgba(255,107,107,0.16);}
  .check-row.pending .ic{background:#EEEDF4; color:#9A99B5;}
  .check-row.done{color:var(--ink);}
  .check-row.active{color:var(--coral-deep); font-weight:600;}
  .check-row.pending{color:#9A99B5;}
  .check-row .state{margin-left:auto; font-size:11px; font-weight:700; letter-spacing:.04em; text-transform:uppercase; color:var(--ink-soft);}
  .check-row.active .state{color:var(--coral-deep);}

  /* Quote box */
  .quote-box{background:#FBF9FF; border:1px solid var(--line); border-radius:var(--r-md); padding:16px 18px;}
  .q-row{display:flex; justify-content:space-between; gap:16px; font-size:14px; padding:9px 0; color:var(--ink-soft); border-bottom:1px dashed var(--line);}
  .q-row:last-child{border-bottom:none;}
  .q-row b{color:var(--ink); font-weight:600; white-space:nowrap;}
  .q-row.total{
    font-size:18px; font-family:'Space Grotesk'; font-weight:700; color:var(--violet);
    border-top:1px solid var(--line-strong); border-bottom:none; margin-top:6px; padding-top:14px;
  }
  .q-row.total b{color:var(--violet); font-size:20px;}
  .q-valid{font-size:12.5px; color:var(--ink-soft); margin-top:12px;}
  .q-valid b{color:var(--coral-deep);}

  .price-hero{display:flex; align-items:baseline; gap:10px; flex-wrap:wrap; margin-bottom:6px;}
  .price-hero .amount{font-family:'Space Grotesk'; font-size:26px; font-weight:700; color:var(--violet);}
  .price-hero .amount.muted{color:var(--ink-soft); font-size:19px;}

  /* Deliver / supplier */
  .supplier-top{display:flex; gap:14px; align-items:center; margin-bottom:16px;}
  .avatar{
    width:52px;height:52px;border-radius:15px; background:var(--grad-sky); color:white;
    display:flex;align-items:center;justify-content:center; font-family:'Space Grotesk'; font-weight:700; font-size:17px; flex-shrink:0;
    box-shadow:var(--shadow-sm);
  }
  .supplier-top strong{display:block; font-size:15.5px; font-family:'Space Grotesk';}
  .supplier-top span{font-size:12.5px; color:var(--ink-soft);}
  .rating{display:inline-flex; align-items:center; gap:5px; font-size:12.5px; font-weight:600; color:#9A6200; margin-top:4px;}

  /* Actions */
  .action-row{display:flex; flex-wrap:wrap; gap:10px;}
  .action-row > *{flex:1 1 auto;}

  /* Activity */
  .activity-wrap{margin-top:30px;}
  .activity-wrap > h2{font-size:24px; margin-bottom:16px;}
  .act-row{display:flex; gap:14px; padding:12px 0; border-bottom:1px dashed var(--line); align-items:flex-start;}
  .act-row:last-child{border-bottom:none;}
  .act-row .dot{width:14px;height:14px;border-radius:50%; background:#E4E2EF; flex-shrink:0; margin-top:4px;}
  .act-row.done .dot{background:var(--grad-cool);}
  .act-row.active .dot{background:var(--grad-warm); box-shadow:0 0 0 5px rgba(255,107,107,0.16);}
  .act-row .body{flex:1;}
  .act-row .body strong{display:block; font-size:14px; font-weight:600;}
  .act-row.pending .body strong{color:#9A99B5;}
  .act-row .body span{font-size:12.5px; color:var(--ink-soft);}

  /* Demo bar */
  .demo-bar{
    background:rgba(255,255,255,0.72); border:1px dashed var(--line-strong); border-radius:var(--r-md);
    padding:12px 16px; margin-bottom:20px;
  }
  .demo-label{font-size:12px; font-weight:700; color:var(--ink-soft); text-transform:uppercase; letter-spacing:.05em; margin-bottom:10px;}
  .demo-chips{display:flex; gap:8px; flex-wrap:wrap;}
  .demo-chips button{
    border:1.5px solid var(--line-strong); background:var(--surface); border-radius:999px;
    padding:7px 14px; font-size:12px; font-weight:600; transition:.18s;
  }
  .demo-chips button:hover{border-color:var(--violet); color:var(--violet);}
  .demo-chips button.active{background:var(--grad-primary); color:white; border-color:transparent;}

  /* Modal (tái sử dụng) */
  .modal{
    position:fixed; inset:0; display:flex; align-items:center; justify-content:center; z-index:110;
    opacity:0; pointer-events:none; visibility:hidden; transition:opacity .22s, visibility .22s; padding:20px; overflow-y:auto;
    background:rgba(27,27,47,0.5); backdrop-filter:blur(3px);
  }
  /* visibility:hidden giữ modal đóng không thể focus bằng bàn phím */
  .modal.show{opacity:1; pointer-events:auto; visibility:visible;}
  .modal-box{
    background:var(--cream); border-radius:var(--r-xl); padding:32px; width:560px; max-width:100%;
    position:relative; box-shadow:var(--shadow-lg); transform:translateY(14px) scale(.98); transition:.25s;
    max-height:92vh; overflow-y:auto; margin:auto;
  }
  .modal.show .modal-box{transform:translateY(0) scale(1);}
  .modal-box h3{font-size:22px; margin-bottom:6px;}
  .modal-box .sub{font-size:13.5px; color:var(--ink-soft); margin-bottom:22px;}
  .modal-close{position:absolute; top:16px; right:18px; font-size:20px; width:36px;height:36px;border-radius:50%; color:var(--ink-soft); transition:.18s;}
  .modal-close:hover{background:var(--line); color:var(--ink);}
  .field{margin-bottom:16px;}
  .field label{display:block; font-size:12.5px; font-weight:600; margin-bottom:7px; color:var(--ink-soft);}
  .field textarea,.field select{
    width:100%; border:1.5px solid var(--line); border-radius:var(--r-sm); padding:12px 14px;
    font-size:14px; background:#FBF9FF; outline:none; transition:.18s; color:var(--ink); resize:vertical;
  }
  .field textarea:focus,.field select:focus{border-color:var(--violet); background:white; box-shadow:0 0 0 4px rgba(108,92,231,0.12);}
  .radio-row{display:flex; align-items:center; gap:11px; padding:12px 14px; border:1.5px solid var(--line); border-radius:var(--r-sm); background:#FBF9FF; margin-bottom:9px; cursor:pointer; font-size:14px; transition:.16s;}
  .radio-row:hover{border-color:var(--violet);}
  .radio-row input{width:17px;height:17px; accent-color:var(--violet); flex-shrink:0;}
  .modal-actions{display:flex; gap:10px; justify-content:flex-end; flex-wrap:wrap; margin-top:22px;}
  .modal-actions > *{flex:1 1 auto;}

  /* Toast (tái sử dụng) */
  .toast{
    position:fixed; bottom:28px; left:50%; transform:translate(-50%, 100px);
    background:var(--ink); color:var(--cream); padding:14px 24px; border-radius:999px;
    font-size:13.5px; font-weight:500; z-index:300; transition:.3s cubic-bezier(.4,0,.2,1);
    opacity:0; box-shadow:var(--shadow-lg); max-width:90vw; text-align:center;
  }
  .toast.show{transform:translate(-50%,0); opacity:1;}
  .toast.ok{background:linear-gradient(135deg,#00B894,#0A7A5E);}
  .toast.err{background:linear-gradient(135deg,#FF6B6B,#C0392B);}

  /* Loading skeleton */
  .sk{background:linear-gradient(90deg,#EFEDF6 25%, #F7F5FC 37%, #EFEDF6 63%); background-size:400% 100%; animation:sk 1.4s ease infinite; border-radius:10px;}
  @keyframes sk{0%{background-position:100% 0;}100%{background-position:0 0;}}
  .sk-row{height:16px; margin-bottom:12px;}
  .sk-title{height:26px; width:44%; margin-bottom:18px;}
  .sk-card{background:var(--surface); border:1px solid var(--line); border-radius:var(--r-lg); padding:24px; box-shadow:var(--shadow-xs);}

  /* Error state */
  .error-state{max-width:620px; margin:60px auto; text-align:center; background:var(--surface); border:1px solid var(--line); border-radius:var(--r-lg); padding:44px 32px; box-shadow:var(--shadow-sm);}
  .error-state .ic{width:74px;height:74px;border-radius:22px; background:#FFECEC; color:var(--coral-deep); display:flex;align-items:center;justify-content:center;font-size:32px; margin:0 auto 18px;}
  .error-state h2{font-size:23px; margin-bottom:8px;}
  .error-state p{color:var(--ink-soft); font-size:14px; margin-bottom:22px;}

  /* Footer (tái sử dụng) */
  footer{border-top:1px solid var(--line); padding:56px 32px 26px; background:rgba(255,255,255,0.6);}
  .foot-inner{max-width:1280px; margin:0 auto; display:grid; grid-template-columns:1.4fr repeat(3,1fr); gap:34px;}
  .foot-inner h5{font-family:'Space Grotesk'; font-size:12.5px; text-transform:uppercase; letter-spacing:0.1em; margin-bottom:16px;}
  .foot-inner ul{list-style:none;}
  .foot-inner li{padding:6px 0; font-size:13.5px; color:var(--ink-soft); transition:.16s;}
  .foot-bottom{max-width:1280px; margin:34px auto 0; padding-top:22px; border-top:1px solid var(--line); display:flex; justify-content:space-between; font-size:12.5px; color:var(--ink-soft); flex-wrap:wrap; gap:10px;}

  /* ===== Responsive ===== */
  @media (max-width:1080px){
    .detail-grid{grid-template-columns:1fr;}
    .dcol.right{position:static;}
  }
  @media (max-width:980px){
    header{padding:10px 18px; gap:12px; flex-wrap:wrap;}
    nav{order:3; flex-basis:100%; width:100%;}
    .utility{padding:8px 20px; font-size:11.5px;}
    .page-wrap{padding:22px 20px 48px;}
    .order-head h1{font-size:28px;}
    .foot-inner{grid-template-columns:1fr 1fr;}
  }
  /* Mobile: gộp 2 cột thành 1, sắp xếp lại thứ tự ưu tiên nội dung */
  @media (max-width:760px){
    .detail-grid{display:flex; flex-direction:column; gap:16px;}
    .dcol{display:contents;}
    .m-current{order:2;} .m-summary{order:3;} .m-price{order:4;} .m-viewer{order:5;}
    .m-config{order:6;} .m-supplier{order:7;} .m-delivery{order:8;} .m-actions{order:9;}
    .m-model{order:10;} .m-file{order:11;} .m-req{order:12;} .m-check{order:13;} .m-notice{order:14;}
    .track-card{order:1;}

    .track-steps{flex-direction:column; gap:0;}
    .ts{flex-direction:row; align-items:center; gap:12px; text-align:left; padding:9px 0;}
    .ts:not(:last-child):after{top:26px; left:11px; width:2px; height:100%;}
    .kv-grid,.kv-grid.three{grid-template-columns:1fr;}
    .dims{grid-template-columns:repeat(2,1fr);}
    .viewer-stage{height:280px;}
    .action-row > *{flex:1 1 100%;}
    .modal-box{padding:24px;}
    .foot-inner{grid-template-columns:1fr;}
    .order-head{flex-direction:column;}
  }
  @media (prefers-reduced-motion: reduce){
    *{transition:none !important; animation:none !important;}
  }
</style>
</head>
<body>

  <!-- ============ UTILITY BAR ============ -->
  <div class="utility">
    <span>🖨️ Kiểm tra file miễn phí — <b>Báo giá trong 2 giờ</b> cho đơn in 3D</span>
    <span>Hỗ trợ: <b>1900 6868</b> · Theo dõi đơn hàng · <a href="../Auth/Đăng-nhập.jsp">Đăng nhập</a></span>
  </div>

  <!-- ============ HEADER ============ -->
  <header>
    <a href="trang_chu.jsp" class="logo"><span class="mark"></span> PrintKraft</a>
    <nav>
      <a href="trang_chu.jsp">Trang chủ</a>
      <a href="dat_in_3d.jsp">Sản phẩm</a>
      <a href="dat_in_3d.jsp">Đặt in 3D</a>
      <a href="trang_chu.jsp">Doanh nghiệp</a>
      <a href="tim-kiem-nha-cung-cap.jsp">Nhà cung cấp</a>
      <a href="don_hang_cua_toi_3d.jsp" class="active">Đơn hàng</a>
      <a href="tra_hang_hoan_tien_custom.jsp">Trả hàng &amp; Hoàn tiền</a>
      <a href="lien-he.jsp">Hỗ trợ</a>
    </nav>
    <div class="head-actions">
      <a href="../Auth/Đăng-nhập.jsp" style="font-weight:600;">Tài khoản</a>
      <button class="cart-btn">🛒 Giỏ hàng <span class="badge">0</span></button>
    </div>
  </header>

  <main>
    <div class="page-wrap">

      <!-- Thanh chuyển trạng thái dùng cho việc kiểm thử giao diện (mock data) -->
      <div class="demo-bar" id="demoBar">
        <div class="demo-label">🧪 Chế độ demo — dữ liệu mock · cùng một trang, render theo <code>order.status</code></div>
        <div class="demo-chips" id="demoChips"></div>
      </div>

      <!-- Toàn bộ nội dung đơn hàng được render theo trạng thái -->
      <div id="orderRoot"></div>

    </div>
  </main>

  <!-- ============ FOOTER ============ -->
  <footer>
    <div class="foot-inner">
      <div>
        <div class="logo" style="margin-bottom:16px;"><span class="mark"></span> PrintKraft</div>
        <p style="font-size:13.5px; color:var(--ink-soft); max-width:34ch;">Nền tảng in theo yêu cầu kết nối khách hàng với hơn 120 xưởng in đối tác trên toàn quốc.</p>
      </div>
      <div>
        <h5>Dịch vụ in 3D</h5>
        <ul><li>In FDM</li><li>In Resin (SLA/MSLA/DLP)</li><li>In SLS &amp; MJF</li><li>Hậu xử lý &amp; sơn</li></ul>
      </div>
      <div>
        <h5>Hỗ trợ</h5>
        <ul><li>Hướng dẫn chuẩn bị file</li><li>Theo dõi đơn hàng</li><li>Chính sách đổi trả</li><li>Điều khoản sử dụng</li></ul>
      </div>
      <div>
        <h5>Liên hệ</h5>
        <ul><li>Hotline: 1900 6868</li><li>Email: hi@printkraft.vn</li><li>128 Nguyễn Đình Chiểu, Q.3, TP.HCM</li><li>8:00 – 21:00</li></ul>
      </div>
    </div>
    <div class="foot-bottom">
      <span>© 2026 PrintKraft. Nền tảng in theo yêu cầu.</span>
      <span>Điều khoản · Bảo mật · Hỗ trợ khách hàng</span>
    </div>
  </footer>

  <!-- ============ MODAL HỦY YÊU CẦU ============ -->
  <div class="modal" id="cancelModal">
    <div class="modal-box">
      <button class="modal-close" type="button" data-close>×</button>
      <h3>Bạn có chắc muốn hủy yêu cầu này?</h3>
      <p class="sub">Yêu cầu in sẽ dừng lại và xưởng không tiếp tục kiểm tra/báo giá. Thao tác này không thể hoàn tác.</p>
      <div class="field">
        <label>Lý do hủy</label>
        <label class="radio-row"><input type="radio" name="cancelReason" value="Không còn nhu cầu" checked> Không còn nhu cầu</label>
        <label class="radio-row"><input type="radio" name="cancelReason" value="Muốn thay đổi model"> Muốn thay đổi model</label>
        <label class="radio-row"><input type="radio" name="cancelReason" value="Muốn thay đổi yêu cầu"> Muốn thay đổi yêu cầu</label>
        <label class="radio-row"><input type="radio" name="cancelReason" value="Khác"> Khác</label>
      </div>
      <div class="modal-actions">
        <button type="button" class="btn-secondary" data-close>Quay lại</button>
        <button type="button" class="btn-primary" id="confirmCancel">Hủy đơn</button>
      </div>
    </div>
  </div>

  <!-- ============ MODAL XÁC NHẬN BÁO GIÁ ============ -->
  <div class="modal" id="quoteModal">
    <div class="modal-box">
      <button class="modal-close" type="button" data-close>×</button>
      <h3>Bạn có đồng ý với báo giá này không?</h3>
      <p class="sub" id="quoteModalSub">Xưởng đã gửi báo giá cho đơn hàng của bạn.</p>
      <div id="quoteModalSummary"></div>
      <div class="banner amber" style="margin-top:16px; margin-bottom:0;">
        <span>⚠</span>
        <span>Sau khi bạn đồng ý, đơn sẽ chuyển sang bước <b>thanh toán</b>. Xưởng chỉ bắt đầu sản xuất sau khi thanh toán hoàn tất.</span>
      </div>
      <div class="modal-actions">
        <button type="button" class="btn-secondary btn-danger" data-act="rejectFromModal">Từ chối</button>
        <button type="button" class="btn-secondary" data-act="reviseFromModal">Yêu cầu điều chỉnh</button>
        <button type="button" class="btn-primary" id="confirmAccept">Đồng ý &amp; tiếp tục</button>
      </div>
    </div>
  </div>

  <!-- ============ MODAL YÊU CẦU ĐIỀU CHỈNH ============ -->
  <div class="modal" id="reviseModal">
    <div class="modal-box">
      <button class="modal-close" type="button" data-close>×</button>
      <h3>Yêu cầu điều chỉnh báo giá</h3>
      <p class="sub">Cho xưởng biết bạn muốn điều chỉnh điểm nào. Xưởng sẽ xem lại và gửi báo giá mới.</p>
      <div class="field">
        <label for="reviseNote">Nội dung cần điều chỉnh</label>
        <textarea id="reviseNote" rows="4" placeholder="Ví dụ: giảm số lượng xuống 5 sản phẩm, hoặc dùng vật liệu rẻ hơn..."></textarea>
      </div>
      <div class="modal-actions">
        <button type="button" class="btn-secondary" data-close>Quay lại</button>
        <button type="button" class="btn-primary" id="confirmRevise">Gửi yêu cầu điều chỉnh</button>
      </div>
    </div>
  </div>

  <!-- ============ MODAL TỪ CHỐI BÁO GIÁ ============ -->
  <div class="modal" id="rejectModal">
    <div class="modal-box">
      <button class="modal-close" type="button" data-close>×</button>
      <h3>Từ chối báo giá?</h3>
      <p class="sub">Đơn hàng sẽ dừng ở bước báo giá và không chuyển sang sản xuất. Bạn có thể liên hệ xưởng để trao đổi thêm.</p>
      <div class="field">
        <label for="rejectNote">Lý do (không bắt buộc)</label>
        <textarea id="rejectNote" rows="3" placeholder="Ví dụ: giá cao hơn dự kiến..."></textarea>
      </div>
      <div class="modal-actions">
        <button type="button" class="btn-secondary" data-close>Quay lại</button>
        <button type="button" class="btn-primary" id="confirmReject">Từ chối báo giá</button>
      </div>
    </div>
  </div>

  <div class="toast" id="toast"></div>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
  <script>
  /* ============================================================
     0. HẰNG SỐ DÙNG CHUNG
     ============================================================ */
  const ORDER_LIST_URL = 'don_hang_cua_toi_3d.jsp';   // Order List → Order Detail (đổi sang URL backend khi có API)
  const DEMO_STATUSES  = ['PENDING_SUPPLIER_REVIEW','SUPPLIER_REVIEWING','PENDING_QUOTE','QUOTE_RECEIVED','PRINTING'];
  const DEMO_ERRORS    = [
    {key:'ERR_NOT_FOUND', label:'Không tìm thấy đơn'},
    {key:'ERR_FORBIDDEN', label:'Không có quyền'},
    {key:'ERR_FAIL',      label:'Lỗi tải đơn'}
  ];

  /* ============================================================
     1. STATUS MODEL — nhãn hướng tới khách hàng
     ============================================================ */
  const STATUS = {
    PENDING_SUPPLIER_REVIEW:{label:'Chờ xưởng tiếp nhận', icon:'🟠', tone:'st-pending',   step:1},
    SUPPLIER_REVIEWING:     {label:'Xưởng đang kiểm tra', icon:'🟠', tone:'st-pending',   step:2},
    PENDING_QUOTE:          {label:'Chờ báo giá',         icon:'🟠', tone:'st-pending',   step:3},
    QUOTE_RECEIVED:         {label:'Chờ bạn xác nhận',    icon:'🟡', tone:'st-quote',     step:4},
    QUOTE_ACCEPTED:         {label:'Đã chấp nhận báo giá',icon:'🔵', tone:'st-producing', step:5},
    REVISION_REQUESTED:     {label:'Đang yêu cầu điều chỉnh', icon:'🟠', tone:'st-pending', step:3},
    QUOTE_REJECTED:         {label:'Đã từ chối báo giá',  icon:'🔴', tone:'st-cancelled', step:3},
    PAYMENT_PENDING:        {label:'Chờ thanh toán',      icon:'🟡', tone:'st-quote',     step:5},
    PAID:                   {label:'Đã thanh toán',       icon:'🔵', tone:'st-producing', step:5},
    PREPARING:              {label:'Đang chuẩn bị sản xuất', icon:'🔵', tone:'st-producing', step:5},
    PRINTING:               {label:'Đang sản xuất',       icon:'🔵', tone:'st-producing', step:5},
    POST_PROCESSING:        {label:'Đang hậu xử lý',      icon:'🔵', tone:'st-producing', step:5},
    QC:                     {label:'Đang kiểm tra chất lượng', icon:'🔵', tone:'st-producing', step:5},
    PACKAGING:              {label:'Đang đóng gói',       icon:'🔷', tone:'st-shipping',  step:6},
    SHIPPING:               {label:'Đang giao',           icon:'🔷', tone:'st-shipping',  step:6},
    COMPLETED:              {label:'Hoàn thành',          icon:'🟢', tone:'st-delivered', step:8},
    CANCELLED:              {label:'Đã hủy',              icon:'⚫', tone:'st-cancelled', step:-1}
  };
  const STEPS = ['Đã gửi yêu cầu','Xưởng tiếp nhận','Kiểm tra model','Báo giá','Bạn xác nhận','Sản xuất','Giao hàng','Hoàn thành'];

  // Nhóm trạng thái dùng để quyết định phần nào của trang được hiển thị
  const PRE_QUOTE   = ['PENDING_SUPPLIER_REVIEW','SUPPLIER_REVIEWING','PENDING_QUOTE'];
  const HAS_QUOTE   = ['QUOTE_RECEIVED','QUOTE_ACCEPTED','PAYMENT_PENDING','PAID','PREPARING','PRINTING','POST_PROCESSING','QC','PACKAGING','SHIPPING','COMPLETED','REVISION_REQUESTED','QUOTE_REJECTED'];
  const CAN_CANCEL  = ['PENDING_SUPPLIER_REVIEW','SUPPLIER_REVIEWING','PENDING_QUOTE'];

  // Luật chuyển trạng thái — chặn mọi đường tắt (PENDING_QUOTE → PAYMENT/PRINTING/QUOTE_ACCEPTED)
  const ALLOWED_TRANSITIONS = {
    QUOTE_ACCEPTED:    ['QUOTE_RECEIVED'],
    QUOTE_REJECTED:    ['QUOTE_RECEIVED'],
    REVISION_REQUESTED:['QUOTE_RECEIVED'],
    PAYMENT_PENDING:   ['QUOTE_ACCEPTED'],
    PRINTING:          ['PAID','PREPARING'],
    CANCELLED:         ['PENDING_SUPPLIER_REVIEW','SUPPLIER_REVIEWING','PENDING_QUOTE']
  };

  const meta = s => STATUS[s] || {label:s, icon:'⚪', tone:'st-pending', step:0};

  /* ============================================================
     2. MOCK DATA — không có backend, toàn bộ là dữ liệu mẫu
     ============================================================ */
  const SUPPLIER = {
    name:'ABC 3D Printing', initials:'AB', rating:4.8, reviews:214,
    address:'KCN Tân Bình, TP.HCM', memberSince:'2021'
  };
  const MODEL = {
    fileName:'dragon.stl', format:'STL', fileSizeText:'2.4 MB', fileSizeBytes:2516582,
    version:'v1', uploadedAt:'2026-09-26T18:30:00',
    dimensions:{x:120, y:80, z:45}, volume:96.4,
    analyzed:true, downloadable:false, viewerUrl:null
  };
  const PRINT_CONFIG = {
    technology:'FDM', material:'PLA',
    color:{name:'Đen', hex:'#1A1A1A', custom:false},
    quality:'Fine', quantity:10, scale:100,
    dimensions:{x:120, y:80, z:45},
    surfaceTreatment:'Standard',
    tolerance:'±0.3 mm',
    advanced:{infill:'Xưởng đề xuất', wall:'Xưởng đề xuất', support:'Để xưởng quyết định', nozzle:'Xưởng đề xuất'}
  };
  const REQUIREMENT_NOTE = 'Ưu tiên bề mặt đẹp.\nKhông cần sơn.\nĐóng gói riêng từng sản phẩm.';
  const DELIVERY = {
    recipient:'Nguyễn Văn A', phone:'09xx xxx xxx',
    address:'128 Nguyễn Đình Chiểu, Phường 6, Quận 3, TP.HCM',
    method:'Giao hàng tận nơi'
  };
  const QUOTE = {
    status:'SENT',
    materialCost:180000, printingCost:80000, postProcessingCost:40000, packagingCost:20000,
    shippingCost:30000, total:350000, validUntil:'2026-10-03T18:32:00',
    supplierNote:'Giá áp dụng cho đúng file và cấu hình bạn đã gửi. Nếu đổi vật liệu hoặc số lượng, xưởng sẽ gửi báo giá mới.'
  };

  function baseOrder(overrides){
    return Object.assign({
      id:'#3DP-20260926-00125',
      status:'PENDING_QUOTE',
      createdAt:'2026-09-26T18:32:00',
      customer:{name:'Nguyễn Văn A', phone:'09xx xxx xxx'},
      supplier:SUPPLIER,
      model:MODEL,
      printConfig:PRINT_CONFIG,
      requirements:{note:REQUIREMENT_NOTE},
      delivery:DELIVERY,
      estimatedPrice:{available:false, min:null, max:null, quoteEta:null, currency:'đ'},
      quote:null,
      activityLog:[]
    }, overrides);
  }

  const ORDERS = {
    PENDING_SUPPLIER_REVIEW: baseOrder({
      status:'PENDING_SUPPLIER_REVIEW',
      estimatedPrice:{available:false, min:null, max:null, quoteEta:null, currency:'đ'},
      activityLog:[
        {time:'2026-09-26T18:32:00', text:'Bạn đã gửi yêu cầu in', state:'done'},
        {time:null, text:'Đang chờ xưởng tiếp nhận yêu cầu', state:'pending'}
      ]
    }),
    SUPPLIER_REVIEWING: baseOrder({
      status:'SUPPLIER_REVIEWING',
      estimatedPrice:{available:false, min:null, max:null, quoteEta:null, currency:'đ'},
      activityLog:[
        {time:'2026-09-26T18:32:00', text:'Bạn đã gửi yêu cầu in', state:'done'},
        {time:'2026-09-26T18:35:00', text:'Xưởng đã tiếp nhận yêu cầu', state:'done'},
        {time:'2026-09-26T18:40:00', text:'Xưởng đang kiểm tra model và khả năng sản xuất', state:'active'}
      ]
    }),
    PENDING_QUOTE: baseOrder({
      status:'PENDING_QUOTE',
      estimatedPrice:{available:true, min:280000, max:350000, quoteEta:'2026-09-27T18:32:00', currency:'đ'},
      activityLog:[
        {time:'2026-09-26T18:32:00', text:'Bạn đã gửi yêu cầu in', state:'done'},
        {time:'2026-09-26T18:35:00', text:'Xưởng đã tiếp nhận yêu cầu', state:'done'},
        {time:'2026-09-26T18:40:00', text:'Xưởng đang kiểm tra model và tính toán chi phí', state:'active'}
      ]
    }),
    QUOTE_RECEIVED: baseOrder({
      status:'QUOTE_RECEIVED',
      quote:QUOTE,
      estimatedPrice:{available:true, min:QUOTE.total, max:QUOTE.total, quoteEta:null, currency:'đ'},
      activityLog:[
        {time:'2026-09-26T18:32:00', text:'Bạn đã gửi yêu cầu in', state:'done'},
        {time:'2026-09-26T18:35:00', text:'Xưởng đã tiếp nhận yêu cầu', state:'done'},
        {time:'2026-09-26T18:40:00', text:'Xưởng đã kiểm tra model', state:'done'},
        {time:'2026-09-26T19:05:00', text:'Xưởng đã gửi báo giá cho đơn hàng', state:'done'},
        {time:null, text:'Đang chờ bạn xác nhận báo giá', state:'active'}
      ]
    }),
    PRINTING: baseOrder({
      status:'PRINTING',
      quote:QUOTE,
      estimatedPrice:{available:true, min:QUOTE.total, max:QUOTE.total, quoteEta:null, currency:'đ'},
      activityLog:[
        {time:'2026-09-26T18:32:00', text:'Bạn đã gửi yêu cầu in', state:'done'},
        {time:'2026-09-26T18:35:00', text:'Xưởng đã tiếp nhận yêu cầu', state:'done'},
        {time:'2026-09-26T18:40:00', text:'Xưởng đã kiểm tra model', state:'done'},
        {time:'2026-09-26T19:05:00', text:'Xưởng đã gửi báo giá cho đơn hàng', state:'done'},
        {time:'2026-09-26T19:20:00', text:'Bạn đã đồng ý với báo giá', state:'done'},
        {time:'2026-09-26T19:25:00', text:'Đã thanh toán', state:'done'},
        {time:'2026-09-27T08:10:00', text:'Xưởng đã bắt đầu in đơn hàng', state:'active'}
      ]
    })
  };

  /* Dựng đơn cho các trạng thái chưa có mock riêng — cùng một trang, render theo status */
  function activityForStatus(status){
    const E = {
      sent:       ['2026-09-26T18:32:00','Bạn đã gửi yêu cầu in'],
      received:   ['2026-09-26T18:35:00','Xưởng đã tiếp nhận yêu cầu'],
      reviewed:   ['2026-09-26T18:40:00','Xưởng đã kiểm tra model'],
      quoteSent:  ['2026-09-26T19:05:00','Xưởng đã gửi báo giá cho đơn hàng'],
      rejected:   ['2026-09-26T19:15:00','Bạn đã từ chối báo giá'],
      revision:   ['2026-09-26T19:15:00','Bạn đã yêu cầu điều chỉnh báo giá'],
      accepted:   ['2026-09-26T19:20:00','Bạn đã đồng ý với báo giá'],
      paid:       ['2026-09-26T19:25:00','Đã thanh toán'],
      preparing:  ['2026-09-26T19:30:00','Xưởng đang chuẩn bị sản xuất'],
      printing:   ['2026-09-27T08:10:00','Xưởng đã bắt đầu in đơn hàng'],
      post:       ['2026-09-27T13:40:00','Xưởng đang hậu xử lý bề mặt'],
      qc:         ['2026-09-27T15:10:00','Xưởng đang kiểm tra chất lượng'],
      packing:    ['2026-09-27T16:00:00','Xưởng đang đóng gói đơn hàng'],
      shipping:   ['2026-09-28T09:00:00','Đơn hàng đang được giao'],
      completed:  ['2026-09-29T11:20:00','Đơn hàng đã hoàn thành'],
      cancelled:  ['2026-09-26T19:00:00','Bạn đã hủy yêu cầu in'],
      reviewing:  [null,'Xưởng đang kiểm tra model và khả năng sản xuất'],
      checking:   [null,'Xưởng đang kiểm tra model và tính toán chi phí'],
      waitConfirm:[null,'Đang chờ bạn xác nhận báo giá'],
      waitPayment:[null,'Đang chờ bạn thanh toán']
    };
    const SEQ = {
      PENDING_SUPPLIER_REVIEW:['sent'],
      SUPPLIER_REVIEWING:['sent','received','reviewing'],
      PENDING_QUOTE:['sent','received','checking'],
      QUOTE_RECEIVED:['sent','received','reviewed','quoteSent','waitConfirm'],
      REVISION_REQUESTED:['sent','received','reviewed','quoteSent','revision'],
      QUOTE_REJECTED:['sent','received','reviewed','quoteSent','rejected'],
      QUOTE_ACCEPTED:['sent','received','reviewed','quoteSent','accepted','waitPayment'],
      PAYMENT_PENDING:['sent','received','reviewed','quoteSent','accepted','waitPayment'],
      PAID:['sent','received','reviewed','quoteSent','accepted','paid','preparing'],
      PREPARING:['sent','received','reviewed','quoteSent','accepted','paid','preparing'],
      PRINTING:['sent','received','reviewed','quoteSent','accepted','paid','printing'],
      POST_PROCESSING:['sent','received','reviewed','quoteSent','accepted','paid','printing','post'],
      QC:['sent','received','reviewed','quoteSent','accepted','paid','printing','post','qc'],
      PACKAGING:['sent','received','reviewed','quoteSent','accepted','paid','printing','post','qc','packing'],
      SHIPPING:['sent','received','reviewed','quoteSent','accepted','paid','printing','post','qc','packing','shipping'],
      COMPLETED:['sent','received','reviewed','quoteSent','accepted','paid','printing','post','qc','packing','shipping','completed'],
      CANCELLED:['sent','cancelled']
    };
    const keys = SEQ[status] || ['sent'];
    const terminal = ['COMPLETED','CANCELLED','QUOTE_REJECTED'].includes(status);
    return keys.map((k, i) => {
      const e = E[k] || [null, k];
      const isLast = i === keys.length - 1;
      return {time:e[0], text:e[1], state:(!terminal && isLast) ? 'active' : 'done'};
    });
  }

  function makeOrderForStatus(status){
    const q = HAS_QUOTE.includes(status) ? JSON.parse(JSON.stringify(QUOTE)) : null;
    const o = baseOrder({status:status, quote:q});
    if(PRE_QUOTE.includes(status)) o.estimatedPrice = {available:false, min:null, max:null, quoteEta:null, currency:'đ'};
    else if(q) o.estimatedPrice = {available:true, min:q.total, max:q.total, quoteEta:null, currency:'đ'};
    if(status === 'PENDING_QUOTE') o.estimatedPrice = {available:true, min:280000, max:350000, quoteEta:'2026-09-27T18:32:00', currency:'đ'};
    o.activityLog = activityForStatus(status);
    return o;
  }

  /* Nhận dữ liệu đơn được click từ Order List qua query string */
  function applyQueryOverrides(o){
    const qs = new URLSearchParams(location.search);
    const id = qs.get('id');
    if(id) o.id = '#' + id.replace(/^#/, '');
    const model = qs.get('model');   if(model) o.model.fileName = model;
    const qty = qs.get('qty');       if(qty && +qty > 0) o.printConfig.quantity = +qty;
    const tech = qs.get('tech');     if(tech) o.printConfig.technology = tech;
    const mat = qs.get('mat');       if(mat) o.printConfig.material = mat;
    const sup = qs.get('supplier');  if(sup) o.supplier.name = sup;
    const price = qs.get('price');
    if(price && +price > 0 && o.quote){
      // co giãn các dòng báo giá theo tỉ lệ để bảng chi tiết luôn khớp tổng
      const fields = ['materialCost','printingCost','postProcessingCost','packagingCost','shippingCost'];
      const old = fields.reduce((s,f) => s + o.quote[f], 0);
      const k = old ? (+price) / old : 1;
      fields.forEach(f => { o.quote[f] = Math.round(o.quote[f] * k); });
      o.quote.total = fields.reduce((s,f) => s + o.quote[f], 0);
    }
    if(qs.get('deadline')) o.deadline = qs.get('deadline');
    return o;
  }

  /* ============================================================
     3. TIỆN ÍCH
     ============================================================ */
  const $ = id => document.getElementById(id);
  const root = $('orderRoot');

  function toast(msg, type){
    const t = $('toast');
    t.textContent = msg;
    t.className = 'toast show' + (type ? ' ' + type : '');
    clearTimeout(t._t);
    t._t = setTimeout(() => { t.className = 'toast' + (type ? ' ' + type : ''); }, 3200);
  }
  const toastOk  = m => toast(m, 'ok');
  const toastErr = m => toast(m, 'err');

  const pad = n => String(n).padStart(2,'0');
  function fDate(iso){ if(!iso) return '—'; const d = new Date(iso); return `${pad(d.getDate())}/${pad(d.getMonth()+1)}/${d.getFullYear()}`; }
  function fDateTime(iso){ if(!iso) return '—'; const d = new Date(iso); return `${pad(d.getDate())}/${pad(d.getMonth()+1)}/${d.getFullYear()} ${pad(d.getHours())}:${pad(d.getMinutes())}`; }
  function fDateTimeShort(iso){ if(!iso) return ''; const d = new Date(iso); return `${pad(d.getDate())}/${pad(d.getMonth()+1)} ${pad(d.getHours())}:${pad(d.getMinutes())}`; }
  const fMoney = n => (n == null ? '—' : Math.round(n).toLocaleString('vi-VN') + 'đ');
  const fNum   = n => (n == null ? '—' : (Math.round(n*10)/10).toLocaleString('vi-VN'));
  const esc = s => String(s == null ? '' : s).replace(/[&<>"]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));

  /* ============================================================
     4. VIEWER 3D — tái sử dụng cách làm của dat_in_3d.html
        (Three.js + điều khiển tự viết, có fallback an toàn)
     ============================================================ */
  const Viewer = (() => {
    let renderer, scene, camera, mesh, grid, raf = null, ready = false, spin = false, radius = 1, target = null, ro = null;

    function init(){
      const stage = $('stage');
      if(!stage) return false;
      if(typeof THREE === 'undefined') return false;
      if(ready && renderer && stage.contains(renderer.domElement)) return true;      dispose();
      // Khởi tạo WebGL có thể lỗi (máy không hỗ trợ) — không để lỗi này lan ra toàn trang
      try{
        target = new THREE.Vector3();
        renderer = new THREE.WebGLRenderer({antialias:true, alpha:true});
        renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
        renderer.setSize(stage.clientWidth || 320, stage.clientHeight || 320);
        stage.appendChild(renderer.domElement);

        scene = new THREE.Scene();
        camera = new THREE.PerspectiveCamera(42, (stage.clientWidth || 320)/(stage.clientHeight || 320), 0.01, 5000);
        scene.add(new THREE.HemisphereLight(0xffffff, 0xC8C2E8, 0.95));
        const key = new THREE.DirectionalLight(0xffffff, 0.85); key.position.set(1.4, 2, 1.6); scene.add(key);
        const rim = new THREE.DirectionalLight(0xA29BFE, 0.5);  rim.position.set(-2, 1, -1.4);  scene.add(rim);

        bindControls(renderer.domElement);
        if(window.ResizeObserver){ ro = new ResizeObserver(resize); ro.observe(stage); }
        else { window.addEventListener('resize', resize); }
        ready = true;
        resize();
        return true;
      } catch(err){
        dispose();
        return false;
      }
    }

    function dispose(){
      spin = false;
      if(raf){ cancelAnimationFrame(raf); raf = null; }
      if(ro){ ro.disconnect(); ro = null; }
      clearMesh();
      if(renderer){
        try{ renderer.dispose(); }catch(e){}
        if(renderer.domElement && renderer.domElement.parentNode) renderer.domElement.parentNode.removeChild(renderer.domElement);
      }
      renderer = null; scene = null; camera = null; ready = false;
    }

    function resize(){
      const stage = $('stage');
      if(!renderer || !stage) return;
      const w = stage.clientWidth, h = stage.clientHeight;
      if(!w || !h) return;
      renderer.setSize(w, h);
      camera.aspect = w/h; camera.updateProjectionMatrix();
      render();
    }

    function bindControls(el){
      let drag = null;
      const pos = e => ({x:e.touches ? e.touches[0].clientX : e.clientX, y:e.touches ? e.touches[0].clientY : e.clientY});
      const pinchDist = e => Math.hypot(e.touches[0].clientX - e.touches[1].clientX, e.touches[0].clientY - e.touches[1].clientY);
      const down = e => {
        if(e.touches && e.touches.length === 2){ drag = {pinch:pinchDist(e)}; return; }
        const p = pos(e); drag = {x:p.x, y:p.y, pan:e.shiftKey || e.button === 2};
      };
      const move = e => {
        if(!drag || !mesh) return;
        if(e.touches && e.touches.length === 2 && drag.pinch){
          const d = pinchDist(e);
          cam.dist *= drag.pinch / d; clampDist(); drag.pinch = d; render(); e.preventDefault(); return;
        }
        const p = pos(e), dx = p.x - drag.x, dy = p.y - drag.y;
        if(drag.pan){
          const s = cam.dist * 0.0016;
          const right = new THREE.Vector3().subVectors(camera.position, cam.target).cross(camera.up).normalize();
          cam.target.addScaledVector(right, -dx * s);
          cam.target.addScaledVector(camera.up, dy * s);
        } else {
          cam.theta -= dx * 0.008;
          cam.phi = Math.max(0.08, Math.min(Math.PI - 0.08, cam.phi - dy * 0.008));
        }
        drag.x = p.x; drag.y = p.y;
        render(); e.preventDefault();
      };
      const up = () => { drag = null; };
      el.addEventListener('mousedown', down);
      window.addEventListener('mousemove', move);
      window.addEventListener('mouseup', up);
      el.addEventListener('touchstart', down, {passive:false});
      el.addEventListener('touchmove', move, {passive:false});
      el.addEventListener('touchend', up);
      el.addEventListener('contextmenu', e => e.preventDefault());
      el.addEventListener('wheel', e => {
        if(!mesh || !camera) return;
        cam.dist *= e.deltaY > 0 ? 1.1 : 0.9; clampDist(); render(); e.preventDefault();
      }, {passive:false});
    }

    const cam = {theta:-0.9, phi:1.05, dist:3, target:null};
    const clampDist = () => { cam.dist = Math.max(radius*1.2, Math.min(radius*14, cam.dist)); };

    function render(){
      if(!renderer || !scene || !camera) return;
      const s = Math.sin(cam.phi), c = Math.cos(cam.phi);
      camera.position.set(
        cam.target.x + cam.dist * s * Math.sin(cam.theta),
        cam.target.y + cam.dist * c,
        cam.target.z + cam.dist * s * Math.cos(cam.theta)
      );
      camera.lookAt(cam.target);
      renderer.render(scene, camera);
    }

    function loop(){
      if(!spin){ raf = null; return; }
      cam.theta += 0.006; render();
      raf = requestAnimationFrame(loop);
    }

    function clearMesh(){
      if(!scene) return;
      [mesh, grid].forEach(o => {
        if(!o) return;
        scene.remove(o);
        if(o.geometry) o.geometry.dispose();
        if(o.material) o.material.dispose();
      });
      mesh = null; grid = null;
    }

    function setGeometry(geo, colorHex){
      geo.computeBoundingBox();
      const box = geo.boundingBox;
      const center = new THREE.Vector3(); box.getCenter(center);
      geo.translate(-center.x, -center.y, -center.z);
      const size = new THREE.Vector3(); box.getSize(size);
      radius = Math.max(size.x, size.y, size.z) || 1;

      const mat = new THREE.MeshStandardMaterial({color:new THREE.Color(colorHex || '#6C5CE7'), roughness:0.55, metalness:0.08});
      mesh = new THREE.Mesh(geo, mat);
      scene.add(mesh);

      grid = new THREE.GridHelper(radius*3, 14, 0xC9C3E8, 0xE6E2F5);
      grid.position.y = -size.y/2 - radius*0.02;
      scene.add(grid);
      reset();
    }

    return {
      available: () => typeof THREE !== 'undefined',
      /** Dựng lại viewer vào #stage của lần render hiện tại */
      mount(){
        const ok = init();
        if(!ok) return false;
        clearMesh();
        const stage = $('stage');
        if(stage) stage.classList.toggle('loaded', true);
        return true;
      },
      /** Hiển thị từ mảng đỉnh (STL/OBJ đã parse) */
      showPositions(positions, colorHex){
        if(!init()) return false;
        clearMesh();
        const geo = new THREE.BufferGeometry();
        geo.setAttribute('position', new THREE.BufferAttribute(positions, 3));
        geo.computeVertexNormals();
        setGeometry(geo, colorHex);
        return true;
      },
      /** Mô hình minh hoạ khi chưa có file viewer thật */
      showPlaceholder(colorHex){
        if(!init()) return false;
        clearMesh();
        const geo = new THREE.TorusKnotGeometry(0.9, 0.30, 150, 22, 2, 3);
        setGeometry(geo, colorHex);
        return true;
      },
      setColor(hex){ if(mesh && mesh.material){ mesh.material.color.set(hex); render(); } },
      reset(){ if(!camera) return; cam.theta = -0.9; cam.phi = 1.05; cam.dist = radius * 2.6; cam.target.set(0,0,0); render(); },
      top(){ if(!camera) return; cam.theta = 0; cam.phi = 0.2; render(); },
      zoom(f){ if(!mesh) return; cam.dist *= f; clampDist(); render(); },
      toggleSpin(){ spin = !spin; if(spin && !raf) raf = requestAnimationFrame(loop); return spin; },
      clear(){ clearMesh(); if(renderer) renderer.clear(); }
    };
  })();

  /* ============================================================
     5. BUILD CÁC KHỐI GIAO DIỆN THEO order.status
     ============================================================ */
  function stepsHTML(status){
    const m = meta(status);
    return STEPS.map((label, i) => {
      const cls = i < m.step ? 'done' : (i === m.step ? 'active' : '');
      const ic  = i < m.step ? '✓' : (i === m.step ? '●' : '○');
      return `<div class="ts ${cls}"><span class="dot">${ic}</span><span class="lbl">${label}</span></div>`;
    }).join('');
  }

  function currentStatusCard(o){
    const m = meta(o.status);
    const desc = {
      PENDING_SUPPLIER_REVIEW:'Yêu cầu in của bạn đã được gửi thành công và đang chờ xưởng tiếp nhận.',
      SUPPLIER_REVIEWING:'Xưởng đã tiếp nhận yêu cầu của bạn và đang kiểm tra model để xác định khả năng sản xuất và chi phí.',
      PENDING_QUOTE:'Xưởng đã kiểm tra model và đang tính toán chi phí sản xuất. Báo giá sẽ được gửi tới bạn.',
      QUOTE_RECEIVED:'Xưởng đã gửi báo giá cho đơn hàng. Vui lòng xem và xác nhận để đơn được tiếp tục.',
      REVISION_REQUESTED:'Bạn đã gửi yêu cầu điều chỉnh. Xưởng đang xem lại và sẽ gửi báo giá mới.',
      QUOTE_REJECTED:'Bạn đã từ chối báo giá. Đơn hàng dừng ở bước báo giá.',
      PAYMENT_PENDING:'Bạn đã đồng ý với báo giá. Đơn hàng đang chờ thanh toán để chuyển sang sản xuất.',
      PAID:'Thanh toán đã hoàn tất. Xưởng sẽ chuẩn bị sản xuất.',
      PREPARING:'Xưởng đang chuẩn bị vật tư và lên lịch in cho đơn hàng của bạn.',
      PRINTING:'Xưởng đang in đơn hàng của bạn.',
      POST_PROCESSING:'Xưởng đang xử lý bề mặt và hoàn thiện sản phẩm.',
      QC:'Xưởng đang kiểm tra chất lượng sản phẩm trước khi đóng gói.',
      PACKAGING:'Xưởng đang đóng gói đơn hàng để giao cho đơn vị vận chuyển.',
      SHIPPING:'Đơn hàng đang được giao tới bạn.',
      COMPLETED:'Đơn hàng đã hoàn thành.',
      CANCELLED:'Yêu cầu in đã được hủy.'
    }[o.status] || m.label;

    const eta = o.estimatedPrice && o.estimatedPrice.quoteEta
      ? `Báo giá dự kiến trước ${fDateTime(o.estimatedPrice.quoteEta)}`
      : 'Thời gian báo giá sẽ được cập nhật khi xưởng xác nhận.';

    return `
      <section class="card critical m-current">
        <h3>${PRE_QUOTE.includes(o.status) ? 'Đơn hàng đang được xử lý' : m.label}</h3>
        <p class="sub" style="margin-bottom:18px;">${desc}</p>
        <div class="kv-grid">
          <div class="kv"><span>Xưởng thực hiện</span><strong>${esc(o.supplier.name)}</strong></div>
          <div class="kv"><span>Trạng thái hiện tại</span><strong><span class="status-badge ${m.tone}">${m.icon} ${m.label}</span></strong></div>
          <div class="kv"><span>Thời gian gửi yêu cầu</span><strong>${fDateTime(o.createdAt)}</strong></div>
          <div class="kv"><span>Dự kiến báo giá</span><strong class="${o.estimatedPrice.quoteEta ? '' : 'muted'}">${PRE_QUOTE.includes(o.status) ? eta : 'Đã có báo giá'}</strong></div>
        </div>
      </section>`;
  }

  function viewerCard(o){
    const analyzed = o.model.analyzed;
    const dims = o.model.dimensions || {};
    return `
      <section class="card m-viewer">
        <h3>Model 3D</h3>
        <p class="sub">Xem lại đúng mô hình bạn đã gửi cho xưởng. Kéo để xoay, lăn chuột để zoom.</p>
        <div class="viewer-stage" id="stage">
          <div class="stage-badge" id="stageBadge">Đang tải model…</div>
          <div class="stage-empty" id="stageEmpty">
            <div class="ic">⚠</div>
            <h4>Không thể hiển thị model 3D</h4>
            <p>Thông tin file vẫn được giữ nguyên bên dưới để bạn kiểm tra.</p>
          </div>
          <div class="stage-hint" id="stageHint" style="display:none;">Kéo xoay · Lăn chuột zoom · Shift để di chuyển</div>
        </div>
        <div class="viewer-tools">
          <button type="button" id="btnSpin" disabled>Tự xoay</button>
          <button type="button" id="btnZoomIn" disabled>Phóng to</button>
          <button type="button" id="btnZoomOut" disabled>Thu nhỏ</button>
          <button type="button" id="btnTop" disabled>Nhìn từ trên</button>
          <button type="button" id="btnFit" disabled>Vừa khung</button>
          <button type="button" id="btnFull" disabled>Toàn màn hình</button>
        </div>
        <div class="dims">
          <div class="dim"><span>X</span><strong>${analyzed ? fNum(dims.x) + ' mm' : '—'}</strong></div>
          <div class="dim"><span>Y</span><strong>${analyzed ? fNum(dims.y) + ' mm' : '—'}</strong></div>
          <div class="dim"><span>Z</span><strong>${analyzed ? fNum(dims.z) + ' mm' : '—'}</strong></div>
          <div class="dim vol"><span>Thể tích</span><strong class="${analyzed ? '' : 'pending'}">${analyzed && o.model.volume != null ? fNum(o.model.volume) + ' cm³' : 'Đang phân tích'}</strong></div>
        </div>
        <div class="notice-line">🔒 Đây là mô hình bạn đã gửi. Trang này chỉ để xem lại — bạn không thể chỉnh sửa file tại đây.</div>
      </section>`;
  }

  function modelInfoCard(o){
    const m = o.model, d = m.dimensions || {};
    const pending = '<strong class="muted">Đang được phân tích</strong>';
    return `
      <section class="card m-model">
        <h3>Thông tin model</h3>
        <p class="sub">Thông số được hệ thống đọc trực tiếp từ file bạn tải lên.</p>
        <div class="kv-grid three">
          <div class="kv"><span>Tên file</span><strong>${esc(m.fileName)}</strong></div>
          <div class="kv"><span>Định dạng</span><strong>${esc(m.format)}</strong></div>
          <div class="kv"><span>Dung lượng</span><strong>${esc(m.fileSizeText)}</strong></div>
          <div class="kv"><span>X</span>${m.analyzed ? `<strong>${fNum(d.x)} mm</strong>` : pending}</div>
          <div class="kv"><span>Y</span>${m.analyzed ? `<strong>${fNum(d.y)} mm</strong>` : pending}</div>
          <div class="kv"><span>Z</span>${m.analyzed ? `<strong>${fNum(d.z)} mm</strong>` : pending}</div>
        </div>
        ${m.analyzed
          ? `<div class="notice-line">ℹ Thông số kích thước và thể tích do hệ thống đọc từ file. Xưởng sẽ kiểm tra lại trên model thực tế trước khi báo giá.</div>`
          : `<div class="notice-line">ℹ Thông số model sẽ được cập nhật sau khi hệ thống phân tích file.</div>`}
      </section>`;
  }

  function fileCard(o){
    const m = o.model;
    return `
      <section class="card m-file">
        <h3>File 3D</h3>
        <div class="kv-grid three">
          <div class="kv"><span>Tên file</span><strong>${esc(m.fileName)}</strong></div>
          <div class="kv"><span>Định dạng</span><strong>${esc(m.format)}</strong></div>
          <div class="kv"><span>Dung lượng</span><strong>${esc(m.fileSizeText)}</strong></div>
          <div class="kv"><span>Phiên bản</span><strong>${esc(m.version)}</strong></div>
          <div class="kv"><span>Ngày tải lên</span><strong>${fDateTime(m.uploadedAt)}</strong></div>
          <div class="kv"><span>Quyền tải lại</span><strong class="muted">Không hỗ trợ</strong></div>
        </div>
        <div class="action-row" style="margin-top:16px;">
          <button type="button" class="btn-secondary btn-sm" data-act="viewModel">Xem model</button>
        </div>
      </section>`;
  }

  function printConfigCard(o){
    const c = o.printConfig;
    const d = c.dimensions || {};
    const color = c.color || {};
    return `
      <section class="card m-config">
        <h3>Yêu cầu in của bạn</h3>
        <p class="sub">Đây là cấu hình bạn đã gửi. <b>Xưởng chưa xác nhận</b> các thông số này.</p>
        <div class="banner amber" style="margin-bottom:16px;">
          <span>📝</span>
          <span>Toàn bộ thông số dưới đây là <b>yêu cầu khách hàng</b>, không phải thông số xưởng đã xác nhận.</span>
        </div>
        <div class="kv-grid three">
          <div class="kv"><span>Công nghệ</span><strong>${esc(c.technology)}</strong></div>
          <div class="kv"><span>Vật liệu</span><strong>${esc(c.material)}</strong></div>
          <div class="kv"><span>Màu</span><strong><span class="swatch-inline"><i style="background:${esc(color.hex)}"></i>${esc(color.name)}${color.custom ? ' · ' + esc(color.hex) : ''}</span></strong></div>
          <div class="kv"><span>Chất lượng</span><strong>${esc(c.quality)}</strong></div>
          <div class="kv"><span>Số lượng</span><strong>${esc(c.quantity)} sản phẩm</strong></div>
          <div class="kv"><span>Scale</span><strong>${esc(c.scale)}%</strong></div>
          <div class="kv"><span>X</span><strong>${fNum(d.x)} mm</strong></div>
          <div class="kv"><span>Y</span><strong>${fNum(d.y)} mm</strong></div>
          <div class="kv"><span>Z</span><strong>${fNum(d.z)} mm</strong></div>
          <div class="kv"><span>Xử lý bề mặt</span><strong>${esc(c.surfaceTreatment)}</strong></div>
          <div class="kv"><span>Dung sai</span><strong>${esc(c.tolerance)}</strong></div>
          <div class="kv"><span>Mật độ / Thành / Support</span><strong class="muted">${esc(c.advanced.infill)} · ${esc(c.advanced.wall)} · ${esc(c.advanced.support)}</strong></div>
        </div>
      </section>`;
  }

  function requirementCard(o){
    return `
      <section class="card m-req">
        <h3>Yêu cầu của khách hàng</h3>
        <p class="sub">Nguyên văn ghi chú bạn đã nhập khi gửi yêu cầu.</p>
        <div class="verbatim">${esc(o.requirements.note)}</div>
        <div class="notice-line"><span class="readonly-tag">Nội dung chỉ đọc</span></div>
      </section>`;
  }

  function checklistFor(status){
    const items = ['Kiểm tra file 3D','Kiểm tra kích thước model','Kiểm tra khả năng in','Tính toán vật liệu','Tính thời gian sản xuất','Tính chi phí','Gửi báo giá'];
    const completed = {
      PENDING_SUPPLIER_REVIEW:0,
      SUPPLIER_REVIEWING:2,
      PENDING_QUOTE:4,
      QUOTE_RECEIVED:7, QUOTE_REJECTED:7, REVISION_REQUESTED:7,
      QUOTE_ACCEPTED:7, PAYMENT_PENDING:7, PAID:7, PREPARING:7, PRINTING:7,
      POST_PROCESSING:7, QC:7, PACKAGING:7, SHIPPING:7, COMPLETED:7,
      CANCELLED:0
    }[status] ?? 0;
    const noActive = !['PENDING_SUPPLIER_REVIEW','SUPPLIER_REVIEWING','PENDING_QUOTE'].includes(status);
    return items.map((label, i) => {
      const state = i < completed ? 'done' : (i === completed && !noActive ? 'active' : 'pending');
      const ic = state === 'done' ? '✓' : (state === 'active' ? '●' : '○');
      const label2 = {done:'Hoàn tất', active:'Đang làm', pending:'Chờ'}[state];
      return `<div class="check-row ${state}"><span class="ic">${ic}</span><span>${label}</span><span class="state">${label2}</span></div>`;
    }).join('');
  }

  function supplierCheckCard(o){
    return `
      <section class="card m-check">
        <h3>Xưởng đang kiểm tra</h3>
        <p class="sub">Đây là lý do bạn chưa nhận được giá ngay: xưởng cần kiểm tra model và tính chi phí trước khi báo giá.</p>
        ${checklistFor(o.status)}
      </section>`;
  }

  function orderSummaryCard(o){
    const c = o.printConfig;
    const hasQuote = HAS_QUOTE.includes(o.status) && o.quote;
    const acceptedTotal = ['QUOTE_ACCEPTED','PAYMENT_PENDING','PAID','PREPARING','PRINTING','POST_PROCESSING','QC','PACKAGING','SHIPPING','COMPLETED'].includes(o.status);
    return `
      <section class="card m-summary">
        <h3>Tóm tắt đơn hàng</h3>
        <div class="q-row"><span>Số lượng</span><b>${esc(c.quantity)} sản phẩm</b></div>
        <div class="q-row"><span>Công nghệ</span><b>${esc(c.technology)}</b></div>
        <div class="q-row"><span>Vật liệu</span><b>${esc(c.material)}</b></div>
        <div class="q-row"><span>Xưởng</span><b>${esc(o.supplier.name)}</b></div>
        <div class="q-row"><span>Giá</span><b class="${hasQuote ? '' : 'muted'}">${hasQuote ? fMoney(o.quote.total) : 'Chưa có báo giá'}</b></div>
        <div class="q-row total"><span>Tổng thanh toán</span><b>${acceptedTotal ? fMoney(o.quote ? o.quote.total : null) : 'Chưa xác định'}</b></div>
      </section>`;
  }

  function supplierCard(o){
    const s = o.supplier;
    return `
      <section class="card m-supplier">
        <h3>Xưởng thực hiện</h3>
        <div class="supplier-top">
          <div class="avatar">${esc(s.initials)}</div>
          <div>
            <strong>${esc(s.name)}</strong>
            <span>${esc(s.address)} · Tham gia ${esc(s.memberSince)}</span>
            <div class="rating">★ ${esc(s.rating)} <span style="color:var(--ink-soft); font-weight:500;">(${esc(s.reviews)} đánh giá)</span></div>
          </div>
        </div>
        <div class="action-row">
          <button type="button" class="btn-secondary btn-sm" data-act="chat">💬 Nhắn tin với xưởng</button>
        </div>
      </section>`;
  }

  function priceCard(o){
    const status = o.status;

    if(status === 'CANCELLED'){
      return `
        <section class="card m-price">
          <h3>Giá</h3>
          <p class="sub">Yêu cầu in đã được hủy nên không có báo giá cho đơn này.</p>
          <div class="banner coral" style="margin:0;">
            <span>⚫</span>
            <span>Không phát sinh chi phí cho yêu cầu đã hủy.</span>
          </div>
        </section>`;
    }

    if(PRE_QUOTE.includes(status)){
      const est = o.estimatedPrice;
      const body = est.available && est.min != null
        ? `<div class="price-hero"><span class="amount">${fMoney(est.min)} – ${fMoney(est.max)}</span><span class="chip-note">Giá dự kiến</span></div>
           <p style="font-size:13px; color:var(--ink-soft);">Đây chỉ là giá tham khảo. Giá cuối cùng do xưởng xác nhận sau khi kiểm tra model.</p>`
        : `<div class="price-hero"><span class="amount muted">Chưa có báo giá</span></div>
           <p style="font-size:13px; color:var(--ink-soft);">Xưởng đang tính toán chi phí sản xuất.</p>`;
      return `
        <section class="card m-price">
          <h3>Giá dự kiến</h3>
          <p class="sub">Xưởng chưa gửi báo giá chính thức cho đơn này.</p>
          ${body}
          <div class="banner amber" style="margin:16px 0 0;">
            <span>⚠</span>
            <span>Bạn chưa thể thanh toán hoặc xác nhận sản xuất khi chưa có báo giá từ xưởng.</span>
          </div>
        </section>`;
    }

    // Đã có báo giá: hiển thị chi tiết báo giá
    const q = o.quote;
    if(!q){
      return `
        <section class="card m-price">
          <h3>Giá</h3>
          <p class="sub">Chưa có báo giá cho đơn hàng ở trạng thái này.</p>
        </section>`;
    }
    const subtotal = q.materialCost + q.printingCost + q.postProcessingCost + q.packagingCost;
    const acceptedStates = ['QUOTE_ACCEPTED','PAYMENT_PENDING','PAID','PREPARING','PRINTING','POST_PROCESSING','QC','PACKAGING','SHIPPING','COMPLETED'];
    const head = acceptedStates.includes(status)
      ? `<p class="sub">Xưởng báo giá cho đơn hàng của bạn. Bạn đã đồng ý với báo giá này.</p>`
      : (status === 'QUOTE_REJECTED'
          ? `<p class="sub">Bạn đã từ chối báo giá này.</p>`
          : (status === 'REVISION_REQUESTED'
              ? `<p class="sub">Bạn đã yêu cầu điều chỉnh. Xưởng sẽ gửi báo giá mới.</p>`
              : `<p class="sub">Xưởng đã gửi báo giá. Vui lòng xem và xác nhận.</p>`));

    return `
      <section class="card quote m-price" id="quoteCard">
        <h3>Báo giá từ xưởng</h3>
        ${head}
        <div class="quote-box">
          <div class="q-row"><span>Vật liệu</span><b>${fMoney(q.materialCost)}</b></div>
          <div class="q-row"><span>Chi phí in</span><b>${fMoney(q.printingCost)}</b></div>
          <div class="q-row"><span>Hậu xử lý</span><b>${fMoney(q.postProcessingCost)}</b></div>
          <div class="q-row"><span>Đóng gói</span><b>${fMoney(q.packagingCost)}</b></div>
          <div class="q-row"><span>Tạm tính</span><b>${fMoney(subtotal)}</b></div>
          <div class="q-row"><span>Vận chuyển</span><b>${fMoney(q.shippingCost)}</b></div>
          <div class="q-row total"><span>TỔNG</span><b>${fMoney(q.total)}</b></div>
        </div>
        <div class="q-valid">Báo giá có hiệu lực đến: <b>${fDateTime(q.validUntil)}</b></div>
        ${q.supplierNote ? `<div class="notice-line">💬 Ghi chú từ xưởng: ${esc(q.supplierNote)}</div>` : ''}
        ${status === 'QUOTE_RECEIVED' ? `
          <div class="action-row" style="margin-top:18px;">
            <button type="button" class="btn-primary btn-sm" data-act="accept">Đồng ý &amp; tiếp tục</button>
            <button type="button" class="btn-secondary btn-sm" data-act="revise">Yêu cầu điều chỉnh</button>
            <button type="button" class="btn-secondary btn-sm btn-danger" data-act="reject">Từ chối</button>
          </div>` : ''}
      </section>`;
  }

  function noticeCard(o){
    if(!PRE_QUOTE.includes(o.status)) return '';
    return `
      <section class="card m-notice">
        <h3>Lưu ý về giá</h3>
        <p style="font-size:13.5px; color:var(--ink-soft);">Giá cuối cùng có thể thay đổi sau khi xưởng kiểm tra model thực tế.</p>
        <div class="notice-line">Nếu xưởng cần thay đổi <b>công nghệ</b>, <b>vật liệu</b>, <b>kích thước</b>, <b>hậu xử lý</b> hoặc <b>thời gian sản xuất</b>, xưởng sẽ gửi lại thông tin và báo giá mới để bạn xác nhận trước khi sản xuất.</div>
      </section>`;
  }

  function deliveryCard(o){
    const d = o.delivery;
    return `
      <section class="card m-delivery">
        <h3>Thông tin nhận hàng</h3>
        <div class="kv-grid">
          <div class="kv"><span>Người nhận</span><strong>${esc(d.recipient)}</strong></div>
          <div class="kv"><span>Số điện thoại</span><strong>${esc(d.phone)}</strong></div>
        </div>
        <div class="kv" style="margin-top:11px;"><span>Địa chỉ</span><strong>${esc(d.address)}</strong></div>
        <div class="kv" style="margin-top:11px;"><span>Phương thức</span><strong>${esc(d.method)}</strong></div>
        <div class="notice-line">🔒 Thông tin nhận hàng chỉ đọc trong bước chờ báo giá.</div>
      </section>`;
  }

  function actionsCard(o){
    const status = o.status;
    let buttons = '';

    if(PRE_QUOTE.includes(status)){
      buttons = `
        <button type="button" class="btn-secondary btn-sm" data-act="chat">💬 Nhắn tin với xưởng</button>
        <a class="btn-secondary btn-sm" href="${ORDER_LIST_URL}">← Quay lại đơn hàng</a>`;
      if(CAN_CANCEL.includes(status)){
        buttons += `<button type="button" class="btn-secondary btn-sm btn-danger" data-act="cancel">✕ Hủy yêu cầu</button>`;
      }
    } else if(status === 'QUOTE_RECEIVED'){
      buttons = `
        <button type="button" class="btn-primary btn-sm" data-act="accept">✓ Đồng ý &amp; tiếp tục</button>
        <button type="button" class="btn-secondary btn-sm" data-act="viewQuote">Xem báo giá</button>
        <button type="button" class="btn-secondary btn-sm" data-act="revise">✎ Yêu cầu điều chỉnh</button>
        <button type="button" class="btn-secondary btn-sm btn-danger" data-act="reject">✕ Từ chối</button>
        <button type="button" class="btn-secondary btn-sm" data-act="chat">💬 Nhắn tin với xưởng</button>`;
    } else if(status === 'PAYMENT_PENDING' || status === 'QUOTE_ACCEPTED'){
      buttons = `
        <button type="button" class="btn-primary btn-sm" data-act="pay">Tiếp tục thanh toán</button>
        <button type="button" class="btn-secondary btn-sm" data-act="chat">💬 Nhắn tin với xưởng</button>
        <a class="btn-secondary btn-sm" href="${ORDER_LIST_URL}">← Quay lại đơn hàng</a>`;
    } else {
      buttons = `
        <button type="button" class="btn-secondary btn-sm" data-act="chat">💬 Nhắn tin với xưởng</button>
        <a class="btn-secondary btn-sm" href="${ORDER_LIST_URL}">← Quay lại đơn hàng</a>`;
    }

    return `
      <section class="card m-actions">
        <h3>Thao tác</h3>
        <p class="sub">Các thao tác khả dụng cho trạng thái hiện tại của đơn.</p>
        <div class="action-row">${buttons}</div>
      </section>`;
  }

  function activityHTML(o){
    return o.activityLog.map(e => {
      const cls = e.state === 'done' ? 'done' : (e.state === 'active' ? 'active' : 'pending');
      return `
        <div class="act-row ${cls}">
          <span class="dot"></span>
          <div class="body">
            <strong>${esc(e.text)}</strong>
            <span>${e.time ? fDateTime(e.time) : 'Chưa có thời gian'}</span>
          </div>
        </div>`;
    }).join('');
  }

  /* ============================================================
     6. RENDER TRANG
     ============================================================ */
  let currentOrder = null;
  let currentKey = 'PENDING_QUOTE';

  function render(){
    const o = currentOrder;
    const m = meta(o.status);
    document.title = `Đơn ${o.id} — PrintKraft`;

    root.innerHTML = `
      <nav class="breadcrumb" aria-label="Breadcrumb">
        <a href="#">Trang chủ</a><span>/</span>
        <a href="${ORDER_LIST_URL}">Đơn hàng</a><span>/</span>
        <b>${esc(o.id)}</b>
      </nav>

      <div class="order-head">
        <div>
          <h1>Chi tiết đơn hàng</h1>
          <div class="order-meta">
            <span class="order-code">${esc(o.id)}</span>
            <span class="status-badge ${m.tone}">${m.icon} ${m.label}</span>
          </div>
          <p class="order-sub">Đặt ngày ${fDateTime(o.createdAt)}</p>
        </div>
        <a class="btn-secondary btn-sm" href="${ORDER_LIST_URL}">← Quay lại đơn hàng</a>
      </div>

      <section class="track-card">
        <h3>Tiến trình đơn hàng</h3>
        <p class="sub">Vị trí hiện tại của đơn trên toàn bộ quy trình.</p>
        <div class="track-steps">${stepsHTML(o.status)}</div>
        <div class="track-note">Trạng thái hiện tại: <b>${m.label}</b></div>
      </section>

      <div class="detail-grid">
        <div class="dcol left">
          ${currentStatusCard(o)}
          ${viewerCard(o)}
          ${modelInfoCard(o)}
          ${fileCard(o)}
          ${printConfigCard(o)}
          ${requirementCard(o)}
          ${supplierCheckCard(o)}
        </div>
        <div class="dcol right">
          ${orderSummaryCard(o)}
          ${supplierCard(o)}
          ${priceCard(o)}
          ${noticeCard(o)}
          ${deliveryCard(o)}
          ${actionsCard(o)}
        </div>
      </div>

      <section class="activity-wrap">
        <h2>Hoạt động đơn hàng</h2>
        <div class="track-card">${activityHTML(o)}</div>
      </section>`;

    // Gắn sự kiện trước, viewer sau: lỗi viewer không được làm hỏng các phần còn lại của trang
    bindOrderEvents();
    bindViewerControls();
    updateDemoChips();
    try{ mountViewer(o); }
    catch(err){ viewerFallback('Không thể hiển thị model 3D. Tên file và thông tin đơn vẫn đầy đủ bên dưới.'); }
  }

  /* Điều khiển viewer 3D — gắn lại sau mỗi lần render */
  function bindViewerControls(){
    const on = (id, fn) => { const b = $(id); if(b) b.onclick = fn; };
    on('btnSpin', () => { const b = $('btnSpin'); if(b) b.classList.toggle('on', Viewer.toggleSpin()); });
    on('btnZoomIn', () => Viewer.zoom(0.85));
    on('btnZoomOut', () => Viewer.zoom(1.18));
    on('btnTop', () => Viewer.top());
    on('btnFit', () => Viewer.reset());
    on('btnFull', () => {
      const el = $('stage');
      if(!el) return;
      if(document.fullscreenElement){ document.exitFullscreen(); return; }
      if(el.requestFullscreen) el.requestFullscreen().catch(() => toastErr('Không thể mở toàn màn hình.'));
    });
  }

  function bindOrderEvents(){
    root.querySelectorAll('[data-act]').forEach(el => {
      el.addEventListener('click', e => {
        if(el.tagName === 'A') return;           // link điều hướng bình thường
        e.preventDefault();
        handleAction(el.dataset.act);
      });
    });
  }

  /* ============================================================
     7. VIEWER MOUNT + FALLBACK
     ============================================================ */
  function viewerFallback(msg){
    const empty = $('stageEmpty'), badge = $('stageBadge'), hint = $('stageHint');
    if(badge) badge.textContent = 'Không hiển thị được';
    if(empty){ empty.style.display = 'flex'; if(msg) empty.querySelector('p').textContent = msg; }
    if(hint) hint.style.display = 'none';
    toolsEnabled(false);
  }

  function toolsEnabled(on){
    ['btnSpin','btnZoomIn','btnZoomOut','btnTop','btnFit','btnFull'].forEach(id => { const b = $(id); if(b) b.disabled = !on; });
    const spin = $('btnSpin'); if(!on && spin) spin.classList.remove('on');
  }

  function mountViewer(o){
    if(!$('stage')) return;

    if(!Viewer.available()){
      viewerFallback('Thư viện 3D chưa tải được. Tên file, định dạng và kích thước vẫn đầy đủ bên dưới.');
      return;
    }

    const mounted = Viewer.mount();
    if(!mounted){ viewerFallback('Không thể khởi tạo trình xem 3D. Thông tin file vẫn được hiển thị bên dưới.'); return; }

    const colorHex = (o.printConfig.color && o.printConfig.color.hex) || '#6C5CE7';
    const badge = $('stageBadge'), hint = $('stageHint'), empty = $('stageEmpty');

    const done = ok => {
      if(empty) empty.style.display = ok ? 'none' : 'flex';
      if(hint) hint.style.display = ok ? 'block' : 'none';
      toolsEnabled(ok);
    };

    // Chưa có file viewer thật (mock) → dùng mô hình minh hoạ, ghi rõ là bản minh hoạ.
    if(!o.model.viewerUrl){
      const ok = Viewer.showPlaceholder(colorHex);
      if(badge) badge.textContent = ok ? 'Bản xem trước minh hoạ' : 'Không hiển thị được';
      done(ok);
      if(!ok) viewerFallback('Không thể hiển thị model 3D.');
      return;
    }

    // Có file thật: thử tải & parse STL/OBJ, lỗi thì fallback an toàn.
    const ext = (o.model.viewerUrl.split('.').pop() || '').toLowerCase();
    fetch(o.model.viewerUrl)
      .then(r => { if(!r.ok) throw new Error('http ' + r.status); return r.arrayBuffer(); })
      .then(buf => {
        const positions = ext === 'obj' ? parseOBJ(buf) : parseSTL(buf);
        const ok = Viewer.showPositions(positions, colorHex);
        if(badge) badge.textContent = ok ? 'Model đã gửi' : 'Không hiển thị được';
        done(ok);
      })
      .catch(() => {
        // Không tải/parse được file gốc → vẫn hiển thị bản minh hoạ, không làm hỏng trang
        let ok = false;
        try{ ok = Viewer.showPlaceholder(colorHex); }catch(err){ ok = false; }
        if(badge) badge.textContent = ok ? 'Bản xem trước minh hoạ (không tải được file gốc)' : 'Không hiển thị được';
        done(ok);
        if(!ok) viewerFallback('Không thể hiển thị model 3D.');
      });
  }

  /* Parser STL/OBJ — tái sử dụng từ dat_in_3d.html */
  function parseSTL(buffer){
    const view = new DataView(buffer);
    const isBinary = (() => {
      if(buffer.byteLength < 84) return false;
      const tris = view.getUint32(80, true);
      if(84 + tris * 50 === buffer.byteLength) return true;
      const head = new TextDecoder().decode(new Uint8Array(buffer, 0, 5)).toLowerCase();
      return head !== 'solid';
    })();
    const verts = [];
    if(isBinary){
      const tris = view.getUint32(80, true);
      let off = 84;
      for(let i=0; i<tris; i++){
        off += 12;
        for(let v=0; v<3; v++){ verts.push(view.getFloat32(off,true), view.getFloat32(off+4,true), view.getFloat32(off+8,true)); off += 12; }
        off += 2;
      }
    } else {
      const text = new TextDecoder().decode(new Uint8Array(buffer));
      const re = /vertex\s+([-\d.eE+]+)\s+([-\d.eE+]+)\s+([-\d.eE+]+)/g;
      let m; while((m = re.exec(text)) !== null) verts.push(+m[1], +m[2], +m[3]);
    }
    if(verts.length < 9) throw new Error('empty');
    return new Float32Array(verts);
  }
  function parseOBJ(buffer){
    const text = new TextDecoder().decode(new Uint8Array(buffer));
    const pts = [], out = [];
    for(const raw of text.split('\n')){
      const line = raw.trim();
      if(line.startsWith('v ')){ const p = line.split(/\s+/); pts.push([+p[1], +p[2], +p[3]]); }
      else if(line.startsWith('f ')){
        const idx = line.split(/\s+/).slice(1).map(t => {
          let i = parseInt(t.split('/')[0], 10);
          return i < 0 ? pts.length + i : i - 1;
        }).filter(i => !isNaN(i) && pts[i]);
        for(let i=1; i<idx.length-1; i++) [idx[0], idx[i], idx[i+1]].forEach(k => out.push(pts[k][0], pts[k][1], pts[k][2]));
      }
    }
    if(out.length < 9) throw new Error('empty');
    return new Float32Array(out);
  }

  /* ============================================================
     8. CHUYỂN TRẠNG THÁI + VALIDATION
     ============================================================ */
  function assertTransition(to){
    const from = currentOrder.status;
    const allowed = ALLOWED_TRANSITIONS[to] || [];
    if(!allowed.includes(from)){
      toastErr(`Không thể chuyển từ “${meta(from).label}” sang “${meta(to).label}”.`);
      return false;
    }
    currentOrder.status = to;
    return true;
  }

  function pushActivity(text, state){
    currentOrder.activityLog.forEach(e => { if(e.state === 'active') e.state = 'done'; });
    currentOrder.activityLog.push({time:new Date().toISOString(), text, state: state || 'active'});
  }

  function handleAction(act){
    switch(act){
      case 'viewModel':
        $('stage') && $('stage').scrollIntoView({behavior:'smooth', block:'center'});
        break;
      case 'viewQuote':
        $('quoteCard') && $('quoteCard').scrollIntoView({behavior:'smooth', block:'center'});
        break;
      case 'chat':
        toast('Đang mở cuộc trò chuyện với ' + currentOrder.supplier.name + '…');
        break;
      case 'cancel':
        openModal('cancelModal');
        break;
      case 'accept':
        openQuoteModal();
        break;
      case 'revise':
        openModal('reviseModal');
        break;
      case 'reject':
        openModal('rejectModal');
        break;
      case 'pay':
        toast('Đang chuyển tới trang thanh toán…');
        break;
    }
  }

  /* ============================================================
     9. MODAL
     ============================================================ */
  function openModal(id){ const m = $(id); if(m) m.classList.add('show'); }
  function closeModal(id){ const m = $(id); if(m) m.classList.remove('show'); }
  function closeAllModals(){ document.querySelectorAll('.modal.show').forEach(m => m.classList.remove('show')); }

  function openQuoteModal(){
    const q = currentOrder.quote;
    if(!q){ toastErr('Chưa có báo giá để xác nhận.'); return; }
    const subtotal = q.materialCost + q.printingCost + q.postProcessingCost + q.packagingCost;
    $('quoteModalSub').textContent = `Báo giá cho đơn ${currentOrder.id} · ${currentOrder.printConfig.quantity} sản phẩm`;
    $('quoteModalSummary').innerHTML = `
      <div class="quote-box">
        <div class="q-row"><span>Tạm tính</span><b>${fMoney(subtotal)}</b></div>
        <div class="q-row"><span>Vận chuyển</span><b>${fMoney(q.shippingCost)}</b></div>
        <div class="q-row total"><span>TỔNG</span><b>${fMoney(q.total)}</b></div>
      </div>`;
    openModal('quoteModal');
  }

  // Đồng ý báo giá: QUOTE_RECEIVED → QUOTE_ACCEPTED → PAYMENT_PENDING
  $('confirmAccept').addEventListener('click', () => {
    if(!assertTransition('QUOTE_ACCEPTED')){ closeAllModals(); return; }
    pushActivity('Bạn đã đồng ý với báo giá', 'done');
    if(!assertTransition('PAYMENT_PENDING')){ toastErr('Không thể chuyển sang bước thanh toán.'); }
    closeAllModals();
    render();
    toastOk('Đã xác nhận báo giá. Đơn chuyển sang bước thanh toán.');
  });

  // Từ chối báo giá: QUOTE_RECEIVED → QUOTE_REJECTED
  $('confirmReject').addEventListener('click', () => {
    if(!assertTransition('QUOTE_REJECTED')){ closeAllModals(); return; }
    const note = ($('rejectNote').value || '').trim();
    pushActivity('Bạn đã từ chối báo giá' + (note ? ` (${note})` : ''), 'done');
    closeAllModals();
    render();
    toast('Đã từ chối báo giá.');
  });

  // Yêu cầu điều chỉnh: QUOTE_RECEIVED → REVISION_REQUESTED
  $('confirmRevise').addEventListener('click', () => {
    const note = ($('reviseNote').value || '').trim();
    if(!note){ toastErr('Vui lòng nhập nội dung cần điều chỉnh.'); return; }
    if(!assertTransition('REVISION_REQUESTED')){ closeAllModals(); return; }
    pushActivity(`Bạn yêu cầu điều chỉnh báo giá: ${note}`, 'done');
    closeAllModals();
    render();
    toastOk('Đã gửi yêu cầu điều chỉnh tới xưởng.');
  });

  // Hủy yêu cầu (chỉ khi business rule cho phép): → CANCELLED
  $('confirmCancel').addEventListener('click', () => {
    const reason = (document.querySelector('input[name="cancelReason"]:checked') || {}).value || 'Khác';
    if(!assertTransition('CANCELLED')){ closeAllModals(); return; }
    pushActivity(`Bạn đã hủy yêu cầu (${reason})`, 'done');
    closeAllModals();
    render();
    toast('Đã hủy yêu cầu in.');
  });

  document.querySelectorAll('.modal').forEach(m => {
    m.addEventListener('click', e => { if(e.target === m) closeAllModals(); });
    m.querySelectorAll('[data-close]').forEach(b => b.addEventListener('click', () => closeAllModals()));
  });
  document.addEventListener('keydown', e => { if(e.key === 'Escape') closeAllModals(); });

  // Nút trong modal báo giá (từ chối / điều chỉnh)
  document.querySelectorAll('[data-act="rejectFromModal"]').forEach(b => b.addEventListener('click', () => { closeModal('quoteModal'); openModal('rejectModal'); }));
  document.querySelectorAll('[data-act="reviseFromModal"]').forEach(b => b.addEventListener('click', () => { closeModal('quoteModal'); openModal('reviseModal'); }));

  /* ============================================================
     10. LOADING / ERROR STATE
     ============================================================ */
  function skeletonHTML(){
    return `
      <div class="sk sk-title"></div>
      <div class="sk-card" style="margin-bottom:18px;">
        <div class="sk sk-row" style="width:30%; height:22px;"></div>
        <div class="sk sk-row" style="width:70%;"></div>
        <div class="sk sk-row" style="width:55%;"></div>
      </div>
      <div class="detail-grid">
        <div class="dcol left">
          <div class="sk-card"><div class="sk sk-row" style="width:40%; height:20px;"></div><div class="sk sk-row"></div><div class="sk sk-row" style="width:80%;"></div></div>
          <div class="sk-card"><div class="sk" style="height:260px; border-radius:14px;"></div></div>
        </div>
        <div class="dcol right">
          <div class="sk-card"><div class="sk sk-row" style="width:50%; height:20px;"></div><div class="sk sk-row"></div><div class="sk sk-row" style="width:70%;"></div></div>
          <div class="sk-card"><div class="sk sk-row" style="width:60%; height:20px;"></div><div class="sk sk-row"></div></div>
        </div>
      </div>`;
  }

  const ERRORS = {
    ERR_NOT_FOUND:{title:'Không tìm thấy đơn hàng.', desc:'Đơn hàng có thể đã bị xóa hoặc đường dẫn không đúng.'},
    ERR_FORBIDDEN:{title:'Bạn không có quyền xem đơn hàng này.', desc:'Đơn hàng này không thuộc tài khoản đang đăng nhập.'},
    ERR_FAIL:{title:'Không thể tải thông tin đơn hàng.', desc:'Kết nối tới hệ thống đang gặp sự cố. Vui lòng thử lại.'}
  };

  function renderError(key){
    const e = ERRORS[key] || ERRORS.ERR_FAIL;
    root.innerHTML = `
      <div class="error-state">
        <div class="ic">⚠</div>
        <h2>${e.title}</h2>
        <p>${e.desc}</p>
        <div class="action-row" style="justify-content:center;">
          <button type="button" class="btn-primary" id="retryBtn">Thử lại</button>
          <a class="btn-secondary" href="${ORDER_LIST_URL}">← Quay lại đơn hàng</a>
        </div>
      </div>`;
    const retry = $('retryBtn');
    if(retry) retry.addEventListener('click', () => load(currentKey));
    updateDemoChips();
  }

  /* ============================================================
     11. DEMO BAR — chuyển giữa các trạng thái/ngữ cảnh lỗi
     ============================================================ */
  function updateDemoChips(){
    const box = $('demoChips');
    if(!box) return;
    const items = DEMO_STATUSES.map(k => ({key:k, label:meta(k).label}))
      .concat(DEMO_ERRORS.map(e => ({key:e.key, label:e.label})));
    box.innerHTML = items.map(it => `<button type="button" data-key="${it.key}" class="${it.key === currentKey ? 'active' : ''}">${it.label}</button>`).join('');
    box.querySelectorAll('button').forEach(b => b.addEventListener('click', () => load(b.dataset.key)));
  }

  /* ============================================================
     12. LOAD
     ============================================================ */
  function load(key){
    currentKey = key;
    updateDemoChips();

    // Loading state — không hiển thị dữ liệu giả trong lúc chờ
    Viewer.clear();
    root.innerHTML = skeletonHTML();

    setTimeout(() => {
      if(ERRORS[key]){ renderError(key); return; }
      const known = ORDERS[key] || STATUS[key];
      const src = ORDERS[key] || (STATUS[key] ? makeOrderForStatus(key) : ORDERS.PENDING_QUOTE);
      // clone để thao tác không làm hỏng dữ liệu gốc
      currentOrder = applyQueryOverrides(JSON.parse(JSON.stringify(src)));
      if(!known) currentKey = 'PENDING_QUOTE';
      render();
    }, 480);
  }

  /* ============================================================
     13. KHỞI TẠO — hỗ trợ ?status=... để mở thẳng một trạng thái
     ============================================================ */
  (function init(){
    const qs = new URLSearchParams(location.search);
    const wanted = qs.get('status');
    const start = (wanted && (ORDERS[wanted] || STATUS[wanted] || ERRORS[wanted])) ? wanted : 'PENDING_QUOTE';
    load(start);
  })();
  </script>
</body>
</html>
