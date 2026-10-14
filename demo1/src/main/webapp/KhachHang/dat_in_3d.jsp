<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>PrintKraft — Đặt in 3D theo yêu cầu</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<style>
  /* ============================================================
     TOKENS — đồng bộ với hệ thống PrintKraft hiện tại
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
    --grad-pink: linear-gradient(135deg,#FD79A8 0%,#A29BFE 100%);

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
  h1,h2,h3,h4,h5,.display{font-family:'Space Grotesk', sans-serif; letter-spacing:-0.02em; line-height:1.15;}
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
  .cart-btn:hover{transform:translateY(-2px); box-shadow:0 12px 26px rgba(255,107,107,0.42);}
  .badge{background:rgba(255,255,255,0.28); border-radius:999px; padding:1px 8px; font-size:11.5px;}

  /* ===== Buttons ===== */
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
  .btn-sm{padding:9px 16px; font-size:13px; border-radius:9px;}

  /* ===== Section / heads ===== */
  .section{max-width:1280px; margin:0 auto; padding:40px 32px 66px;}
  .eyebrow-line{
    display:inline-block; font-size:12px; font-weight:700; letter-spacing:.12em; text-transform:uppercase;
    color:var(--violet); margin-bottom:10px;
  }
  .page-head{max-width:1280px; margin:0 auto; padding:34px 32px 0;}
  .page-head h1{font-size:38px;}
  .page-head p{color:var(--ink-soft); font-size:15px; margin-top:10px; max-width:62ch;}
  .flow-hint{display:flex; gap:10px; flex-wrap:wrap; margin-top:20px;}
  .flow-hint span{
    font-size:12.5px; font-weight:600; color:var(--ink-soft);
    background:rgba(255,255,255,0.75); border:1px solid var(--line);
    padding:7px 14px; border-radius:999px;
  }
  .flow-hint span b{color:var(--violet); font-family:'Space Grotesk';}

  /* ===== Chips / pills / swatches (tái sử dụng) ===== */
  .chips{display:flex; gap:9px; flex-wrap:wrap;}
  .chip{
    border:1.5px solid var(--line-strong); background:var(--surface); border-radius:999px;
    padding:9px 17px; font-size:13px; font-weight:500; transition:.18s;
  }
  .chip:hover{border-color:var(--violet); color:var(--violet);}
  .chip.active{background:var(--grad-primary); color:white; border-color:transparent; box-shadow:0 8px 18px rgba(108,92,231,0.3);}
  .pill{font-size:11.5px; font-weight:600; padding:4px 11px; border-radius:999px; background:#F2EFFF; color:var(--violet);}
  .pill.teal{background:#E1FBF3; color:#0A7A5E;}
  .pill.amber{background:#FFF4E0; color:#9A6200;}
  .pill.coral{background:#FFECEC; color:#C0392B;}

  .opt-group{margin-bottom:26px;}
  .opt-group > label, .opt-label{
    display:block; font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:0.08em;
    color:var(--ink-soft); margin-bottom:10px;
  }
  .opt-note{font-size:12.5px; color:var(--ink-soft); margin-top:9px;}

  .field{margin-bottom:14px;}
  .field label{display:block; font-size:12.5px; font-weight:600; margin-bottom:6px; color:var(--ink-soft);}
  .field input, .field select, .field textarea{
    width:100%; border:1.5px solid var(--line); border-radius:var(--r-sm); padding:12px 14px;
    font-size:14px; background:#FBF9FF; outline:none; transition:.18s; color:var(--ink);
  }
  .field input:focus, .field select:focus, .field textarea:focus{border-color:var(--violet); background:white; box-shadow:0 0 0 4px rgba(108,92,231,0.12);}
  .field-row{display:grid; grid-template-columns:repeat(3,1fr); gap:12px;}

  /* ============================================================
     TRANG ĐẶT IN 3D
     ============================================================ */
  .order3d{display:grid; grid-template-columns:1.02fr 0.98fr; gap:28px; align-items:start;}

  /* --- Cột trái: viewer --- */
  .viewer-col{position:sticky; top:82px;}
  .studio-preview{background:var(--surface); border:1px solid var(--line); border-radius:var(--r-lg); padding:22px; box-shadow:var(--shadow-sm);}
  .preview-stage{
    height:400px; border-radius:var(--r-md); border:1.5px dashed var(--line-strong);
    position:relative; overflow:hidden; margin-bottom:16px;
    background:
      radial-gradient(420px 260px at 50% 38%, rgba(108,92,231,0.10), transparent 70%),
      repeating-linear-gradient(45deg, rgba(27,27,47,0.03) 0 12px, transparent 12px 24px),
      #FDFCFF;
  }
  .preview-stage.loaded{border-style:solid; border-color:var(--line);}
  .preview-stage canvas{width:100%; height:100%; touch-action:none; cursor:grab;}
  .preview-stage canvas:active{cursor:grabbing;}
  .stage-empty{
    position:absolute; inset:0; display:flex; flex-direction:column; align-items:center; justify-content:center;
    gap:8px; text-align:center; padding:26px; color:var(--ink-soft);
  }
  .stage-empty .ic{
    width:64px;height:64px;border-radius:20px; background:var(--grad-primary); color:white;
    display:flex;align-items:center;justify-content:center;font-size:26px; margin-bottom:6px;
    box-shadow:var(--shadow-glow);
  }
  .stage-empty h4{font-size:17px; color:var(--ink);}
  .stage-empty p{font-size:13.5px; max-width:34ch;}
  .stage-badge{
    position:absolute; top:12px; left:12px; z-index:3;
    background:rgba(255,255,255,0.9); backdrop-filter:blur(6px);
    border:1px solid var(--line); border-radius:999px;
    font-size:11.5px; font-weight:700; padding:5px 12px; color:var(--ink-soft);
  }
  .stage-hint{
    position:absolute; bottom:12px; right:12px; z-index:3; font-size:11.5px; color:var(--ink-soft);
    background:rgba(255,255,255,0.86); border:1px solid var(--line); border-radius:999px; padding:5px 12px;
  }
  .preview-tools{display:flex; gap:8px; justify-content:center; flex-wrap:wrap;}
  .preview-tools button{
    background:#F7F4FF; border:1px solid var(--line); border-radius:9px; padding:8px 13px;
    font-size:12.5px; font-weight:500; transition:.18s;
  }
  .preview-tools button:hover:not(:disabled){background:var(--violet); color:white; border-color:var(--violet);}
  .preview-tools button:disabled{opacity:.45; cursor:not-allowed;}
  .preview-tools button.on{background:var(--grad-primary); color:white; border-color:transparent;}

  .dims{display:grid; grid-template-columns:repeat(4,1fr); gap:10px; margin-top:18px;}
  .dim{
    background:#FBF9FF; border:1px solid var(--line); border-radius:var(--r-sm);
    padding:12px 13px; text-align:left;
  }
  .dim span{display:block; font-size:11px; font-weight:700; letter-spacing:.07em; text-transform:uppercase; color:var(--ink-soft);}
  .dim strong{display:block; font-family:'Space Grotesk'; font-size:17px; font-weight:700; margin-top:3px;}
  .dim.vol strong{color:var(--violet);}

  .check-panel{
    margin-top:16px; border:1px solid var(--line); border-radius:var(--r-md);
    background:#FBF9FF; padding:16px 18px;
  }
  .check-panel h5{font-size:13px; text-transform:uppercase; letter-spacing:.08em; color:var(--ink-soft); margin-bottom:10px;}
  .check-row{display:flex; gap:10px; align-items:flex-start; font-size:13.5px; padding:5px 0;}
  .check-row .ic{width:20px; flex-shrink:0; font-weight:700; text-align:center;}
  .check-row.ok .ic{color:var(--teal);}
  .check-row.warn .ic{color:var(--amber);}
  .check-row.err .ic{color:var(--coral-deep);}
  .check-row span{color:var(--ink-soft);}

  .file-card{
    display:flex; gap:14px; align-items:center; margin-top:16px;
    border:1px solid var(--line); border-radius:var(--r-md); background:var(--surface);
    padding:14px 16px; box-shadow:var(--shadow-xs);
  }
  .file-card .ft{
    width:46px;height:46px;border-radius:13px; background:var(--grad-sky); color:white; flex-shrink:0;
    display:flex;align-items:center;justify-content:center; font-family:'Space Grotesk'; font-weight:700; font-size:12.5px;
  }
  .file-card .fi{flex:1; min-width:0;}
  .file-card .fi strong{display:block; font-size:14px; font-weight:600; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;}
  .file-card .fi span{font-size:12.5px; color:var(--ink-soft);}
  .file-card .fa{display:flex; gap:8px; flex-shrink:0;}
  .file-card .fa button{
    border:1.5px solid var(--line-strong); background:var(--surface); border-radius:9px;
    padding:8px 12px; font-size:12.5px; font-weight:600; transition:.18s;
  }
  .file-card .fa button:hover{border-color:var(--violet); color:var(--violet);}
  .file-card .fa button.danger:hover{border-color:var(--coral-deep); color:var(--coral-deep);}

  /* --- Cột phải: form --- */
  .config-col{display:flex; flex-direction:column; gap:20px;}
  .panel{
    background:var(--surface); border:1px solid var(--line); border-radius:var(--r-lg);
    padding:26px; box-shadow:var(--shadow-xs);
  }
  .panel > h3{font-size:19px; margin-bottom:4px;}
  .panel > .sub{font-size:13.5px; color:var(--ink-soft); margin-bottom:20px;}

  /* Dropzone */
  .dropzone{
    border:1.5px dashed var(--line-strong); border-radius:var(--r-md); background:#FBF9FF;
    padding:34px 24px; text-align:center; transition:.2s; cursor:pointer;
  }
  .dropzone:hover, .dropzone.drag{border-color:var(--violet); background:#F6F3FF; box-shadow:0 0 0 4px rgba(108,92,231,0.12);}
  .dropzone .ic{
    width:56px;height:56px;border-radius:18px; background:var(--grad-primary); color:white;
    display:flex;align-items:center;justify-content:center;font-size:24px;margin:0 auto 14px;
    box-shadow:var(--shadow-glow);
  }
  .dropzone h4{font-size:17px; margin-bottom:6px;}
  .dropzone p{font-size:13.5px; color:var(--ink-soft); max-width:40ch; margin:0 auto 16px;}
  .formats{display:flex; gap:7px; justify-content:center; flex-wrap:wrap; margin-top:14px;}
  .formats .pill{font-size:11px;}

  /* Quantity */
  .qty-box{display:flex; align-items:center; gap:14px;}
  .qty-ctrl{display:flex; align-items:center; gap:0; border:1.5px solid var(--line-strong); border-radius:999px; overflow:hidden; background:var(--surface);}
  .qty-ctrl button{width:42px; height:42px; font-size:19px; font-weight:600; color:var(--ink-soft); transition:.16s;}
  .qty-ctrl button:hover{background:var(--violet); color:white;}
  .qty-ctrl input{
    width:62px; text-align:center; border:none; outline:none; background:transparent;
    font-family:'Space Grotesk'; font-weight:700; font-size:17px; color:var(--violet);
    -moz-appearance:textfield;
  }
  .qty-ctrl input::-webkit-outer-spin-button, .qty-ctrl input::-webkit-inner-spin-button{-webkit-appearance:none; margin:0;}
  .qty-box .hint{font-size:12.5px; color:var(--ink-soft);}

  /* Option cards (công nghệ / chất lượng / dung sai) */
  .opt-cards{display:grid; grid-template-columns:repeat(2,1fr); gap:11px;}
  .opt-cards.one{grid-template-columns:1fr;}
  .opt-card{
    display:flex; gap:12px; align-items:flex-start; text-align:left; width:100%;
    border:1.5px solid var(--line-strong); border-radius:var(--r-md); background:var(--surface);
    padding:14px 15px; transition:.18s;
  }
  .opt-card:hover{border-color:var(--violet); background:#FBFAFF;}
  .opt-card.active{border-color:var(--violet); background:#F6F3FF; box-shadow:0 0 0 4px rgba(108,92,231,0.12);}
  .opt-card .radio{width:19px;height:19px;border-radius:50%; border:2px solid var(--line-strong); flex-shrink:0; margin-top:2px; position:relative; transition:.18s;}
  .opt-card.active .radio{border-color:var(--violet);}
  .opt-card.active .radio:after{content:""; position:absolute; inset:3px; border-radius:50%; background:var(--violet);}
  .opt-card .radio.sq{border-radius:6px;}
  .opt-card.active .radio.sq:after{border-radius:3px;}
  .opt-card .oc-body{flex:1; min-width:0;}
  .opt-card strong{display:block; font-size:14px; font-family:'Space Grotesk'; letter-spacing:-0.01em;}
  .opt-card em{font-style:normal; display:block; font-size:12.5px; font-weight:600; color:var(--violet); margin-top:1px;}
  .opt-card span{display:block; font-size:12.5px; color:var(--ink-soft); margin-top:4px; line-height:1.45;}

  /* Colors */
  .swatches{display:flex; gap:10px; flex-wrap:wrap;}
  .swatch{width:38px; height:38px; border-radius:50%; border:2px solid transparent; outline:1.5px solid var(--line-strong); transition:.18s;}
  .swatch:hover{transform:scale(1.1);}
  .swatch.active{border-color:var(--ink); outline-color:var(--ink); transform:scale(1.08);}
  .color-custom{display:flex; align-items:center; gap:12px; margin-top:16px; flex-wrap:wrap;}
  .color-custom input[type=color]{width:46px; height:42px; border:1.5px solid var(--line-strong); border-radius:var(--r-sm); background:var(--surface); padding:3px; cursor:pointer;}
  .color-custom input[type=text]{
    width:130px; border:1.5px solid var(--line); border-radius:var(--r-sm); padding:11px 14px;
    font-family:'Space Grotesk'; font-weight:600; font-size:14px; background:#FBF9FF; outline:none; text-transform:uppercase;
  }
  .color-custom input[type=text]:focus{border-color:var(--violet); background:white; box-shadow:0 0 0 4px rgba(108,92,231,0.12);}
  .ref-img{
    display:flex; gap:14px; align-items:center; margin-top:16px; border:1.5px dashed var(--line-strong);
    border-radius:var(--r-md); padding:14px; background:#FBF9FF; transition:.18s;
  }
  .ref-img:hover{border-color:var(--violet);}
  .ref-img .thumb{width:58px; height:58px; border-radius:12px; background:#EDEBF5; object-fit:cover; flex-shrink:0; display:flex; align-items:center; justify-content:center; font-size:20px;}
  .ref-img .t{flex:1; font-size:13px; color:var(--ink-soft);}
  .ref-img .t strong{display:block; color:var(--ink); font-size:13.5px; font-weight:600;}
  .notice{
    display:flex; gap:10px; align-items:flex-start; margin-top:14px;
    background:#FFF4E0; border:1px dashed rgba(255,179,71,0.7); color:#8A5A00;
    border-radius:var(--r-sm); padding:11px 14px; font-size:12.5px; font-weight:500;
  }

  /* Tolerance custom */
  .tol-custom{display:flex; align-items:center; gap:10px; margin-top:12px;}
  .tol-custom input{
    width:110px; border:1.5px solid var(--line); border-radius:var(--r-sm); padding:11px 14px;
    font-family:'Space Grotesk'; font-weight:600; background:#FBF9FF; outline:none; font-size:14px;
  }
  .tol-custom input:disabled{opacity:.5;}
  .tol-custom input:focus{border-color:var(--violet); background:white; box-shadow:0 0 0 4px rgba(108,92,231,0.12);}
  .tip{
    display:inline-flex; align-items:center; justify-content:center; width:17px; height:17px; border-radius:50%;
    background:#EDE9FF; color:var(--violet); font-size:11px; font-weight:700; margin-left:6px; cursor:help;
    position:relative; vertical-align:middle;
  }
  .tip:hover:after{
    content:attr(data-tip); position:absolute; bottom:130%; left:50%; transform:translateX(-50%);
    background:var(--ink); color:var(--cream); font-size:12px; font-weight:400; line-height:1.45;
    padding:10px 13px; border-radius:10px; width:250px; text-transform:none; letter-spacing:0;
    box-shadow:var(--shadow-md); z-index:20; text-align:left;
  }

  /* Advanced */
  details.adv{
    background:var(--surface); border:1px solid var(--line); border-radius:var(--r-md);
    padding:16px 20px; box-shadow:var(--shadow-xs); transition:.2s;
  }
  details.adv[open]{border-color:rgba(108,92,231,0.4); box-shadow:var(--shadow-sm);}
  details.adv summary{font-weight:600; font-size:14.5px; cursor:pointer; list-style:none; display:flex; justify-content:space-between; gap:14px; align-items:center;}
  details.adv summary::-webkit-details-marker{display:none;}
  details.adv summary:after{content:"+"; font-family:'Space Grotesk'; font-size:21px; line-height:1; color:var(--violet);}
  details.adv[open] summary:after{content:"–";}
  details.adv .adv-body{margin-top:16px; padding-top:16px; border-top:1px dashed var(--line);}

  /* Summary + price */
  .summary-card{
    background:var(--surface); border:1px solid var(--line); border-radius:var(--r-lg);
    padding:24px; box-shadow:var(--shadow-sm);
  }
  .summary-card h3{font-size:18px; margin-bottom:16px;}
  .sum-row{display:flex; justify-content:space-between; gap:18px; font-size:13.5px; padding:9px 0; border-bottom:1px dashed var(--line);}
  .sum-row:last-of-type{border-bottom:none;}
  .sum-row span{color:var(--ink-soft); flex-shrink:0;}
  .sum-row b{font-weight:600; text-align:right; word-break:break-word;}
  .sum-row b.muted{color:var(--ink-soft); font-weight:500;}
  .sum-dot{display:inline-block; width:12px; height:12px; border-radius:50%; outline:1.5px solid var(--line-strong); vertical-align:-1px; margin-right:6px;}

  .price-box{
    background:linear-gradient(150deg,#241F45 0%, #3B2F73 55%, #4B3A8F 100%);
    color:var(--cream); border-radius:var(--r-lg); padding:24px; box-shadow:var(--shadow-md);
    position:relative; overflow:hidden;
  }
  .price-box:before{content:""; position:absolute; width:200px;height:200px; border-radius:50%; background:rgba(162,155,254,0.28); filter:blur(50px); top:-70px; right:-50px;}
  .price-box h4{font-size:17px; color:white; position:relative; margin-bottom:12px;}
  .price-box .row{display:flex; justify-content:space-between; gap:14px; font-size:13.5px; padding:7px 0; color:rgba(253,249,243,0.78); position:relative;}
  .price-box .row b{color:white; font-weight:600;}
  .price-box .row.total{border-top:1px solid rgba(253,249,243,0.22); margin-top:10px; padding-top:14px; color:white; font-weight:600; font-size:15px; align-items:center;}
  .price-box .big{font-family:'Space Grotesk'; font-size:22px; font-weight:700; color:white;}
  .price-box .note{position:relative; font-size:12.5px; color:rgba(253,249,243,0.72); margin-top:12px; line-height:1.5;}

  .actions{display:flex; gap:12px; flex-wrap:wrap;}
  .actions .btn-primary{flex:1; min-width:200px;}

  .form-error{
    background:#FFECEC; color:#C0392B; border-radius:var(--r-sm); padding:14px 16px; font-size:13.5px;
    margin-bottom:16px; display:none; font-weight:500; border:1px solid rgba(192,57,43,0.18);
  }
  .form-error.show{display:block;}
  .form-error ul{margin:6px 0 0 18px;}
  .form-error li{padding:2px 0;}
  .invalid input, input.invalid{border-color:var(--coral-deep) !important; background:#FFF7F7 !important;}

  /* Modal + toast (tái sử dụng) */
  .modal{
    position:fixed; inset:0; display:flex; align-items:center; justify-content:center; z-index:110;
    opacity:0; pointer-events:none; transition:.22s; padding:20px; overflow-y:auto;
    background:rgba(27,27,47,0.5); backdrop-filter:blur(3px);
  }
  .modal.show{opacity:1; pointer-events:auto;}
  .modal-box{
    background:var(--cream); border-radius:var(--r-xl); padding:34px; width:520px; max-width:100%;
    position:relative; box-shadow:var(--shadow-lg); transform:translateY(14px) scale(.98); transition:.25s;
    max-height:92vh; overflow-y:auto; margin:auto;
  }
  .modal.show .modal-box{transform:translateY(0) scale(1);}
  .modal-box h3{font-size:23px; margin-bottom:6px;}
  .modal-box .sub{font-size:13.5px; color:var(--ink-soft); margin-bottom:22px;}
  .modal-close{position:absolute; top:18px; right:20px; font-size:20px; width:36px;height:36px;border-radius:50%; color:var(--ink-soft); transition:.18s;}
  .modal-close:hover{background:var(--line); color:var(--ink);}
  .success-icon{
    width:76px;height:76px;border-radius:50%; background:var(--grad-cool); color:#063a2e;
    display:flex;align-items:center;justify-content:center;font-size:34px; margin:0 auto 18px;
    box-shadow:0 16px 40px rgba(0,184,148,0.35);
  }
  .order-code{
    display:inline-block; font-family:'Space Grotesk'; font-weight:700; font-size:16px;
    background:#F2EFFF; color:var(--violet); padding:9px 18px; border-radius:999px; margin:10px 0 6px;
  }
  .toast{
    position:fixed; bottom:28px; left:50%; transform:translate(-50%, 100px);
    background:var(--ink); color:var(--cream); padding:14px 24px; border-radius:999px;
    font-size:13.5px; font-weight:500; z-index:300; transition:.3s cubic-bezier(.4,0,.2,1);
    opacity:0; box-shadow:var(--shadow-lg); max-width:90vw; text-align:center;
  }
  .toast.show{transform:translate(-50%,0); opacity:1;}
  .toast.ok{background:linear-gradient(135deg,#00B894,#0A7A5E);}
  .toast.err{background:linear-gradient(135deg,#FF6B6B,#C0392B);}

  /* Footer */
  footer{border-top:1px solid var(--line); padding:56px 32px 26px; background:rgba(255,255,255,0.6);}
  .foot-inner{max-width:1280px; margin:0 auto; display:grid; grid-template-columns:1.4fr repeat(3,1fr); gap:34px;}
  .foot-inner h5{font-family:'Space Grotesk'; font-size:12.5px; text-transform:uppercase; letter-spacing:0.1em; margin-bottom:16px;}
  .foot-inner ul{list-style:none;}
  .foot-inner li{padding:6px 0; font-size:13.5px; color:var(--ink-soft); transition:.16s; cursor:pointer;}
  .foot-inner li:hover{color:var(--violet); transform:translateX(3px);}
  .foot-bottom{max-width:1280px; margin:34px auto 0; padding-top:22px; border-top:1px solid var(--line); display:flex; justify-content:space-between; font-size:12.5px; color:var(--ink-soft); flex-wrap:wrap; gap:10px;}

  /* ===== Responsive ===== */
  @media (max-width:1240px){
    .order3d{grid-template-columns:1fr 1fr;}
  }
  @media (max-width:1080px){
    .order3d{grid-template-columns:1fr; gap:22px;}
    .viewer-col{position:static;}
    .preview-stage{height:340px;}
  }
  @media (max-width:980px){
    header{padding:10px 18px; gap:12px; flex-wrap:wrap;}
    nav{order:3; flex-basis:100%; width:100%;}
    .head-actions{margin-left:auto;}
    .utility{padding:8px 20px; font-size:11.5px;}
    .section{padding:28px 20px 48px;}
    .page-head{padding:26px 20px 0;}
    .page-head h1{font-size:30px;}
    .foot-inner{grid-template-columns:1fr 1fr;}
  }
  @media (max-width:640px){
    .opt-cards{grid-template-columns:1fr;}
    .dims{grid-template-columns:repeat(2,1fr);}
    .field-row{grid-template-columns:1fr;}
    .panel{padding:20px;}
    .studio-preview{padding:16px;}
    .preview-stage{height:280px;}
    .foot-inner{grid-template-columns:1fr;}
    .actions .btn-primary, .actions .btn-secondary{width:100%;}
    .file-card{flex-wrap:wrap;}
    .tip:hover:after{width:200px;}
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
      <a href="dat_in_3d.jsp" class="active">Sản phẩm</a>
      <a href="dat_in_3d.jsp">Đặt in 3D</a>
      <a href="trang_chu.jsp">Doanh nghiệp</a>
      <a href="tim-kiem-nha-cung-cap.jsp">Nhà cung cấp</a>
      <a href="don_hang_cua_toi_3d.jsp">Đơn hàng</a>
      <a href="lien-he.jsp">Hỗ trợ</a>
    </nav>
    <div class="head-actions">
      <a href="../Auth/Đăng-nhập.jsp" style="font-weight:600;">Tài khoản</a>
      <button class="cart-btn">🛒 Giỏ hàng <span class="badge">0</span></button>
    </div>
  </header>

  <main>
    <div class="page-head">
      <span class="eyebrow-line">In 3D theo yêu cầu</span>
      <h1>Đặt in mô hình 3D của bạn</h1>
      <p>Tải file lên, chọn công nghệ và vật liệu, xem trước mô hình — xưởng sẽ kiểm tra file và xác nhận báo giá cho bạn. Bạn không cần biết kỹ thuật in để bắt đầu.</p>
      <div class="flow-hint">
        <span><b>1</b> Tải mô hình</span>
        <span><b>2</b> Cấu hình sản phẩm</span>
        <span><b>3</b> Xem trước</span>
        <span><b>4</b> Gửi yêu cầu in</span>
      </div>
    </div>

    <div class="section">
      <div class="order3d">

        <!-- ============================================================
             CỘT TRÁI — PREVIEW 3D
             ============================================================ -->
        <section class="viewer-col" aria-label="Xem trước mô hình 3D">
          <div class="studio-preview">
            <div class="preview-stage" id="stage">
              <div class="stage-badge" id="stageBadge">Chưa có mô hình</div>
              <div class="stage-empty" id="stageEmpty">
                <div class="ic">⬆</div>
                <h4>Chưa có mô hình để hiển thị</h4>
                <p>Tải file 3D ở cột bên phải để xem trước, đo kích thước và thể tích.</p>
              </div>
              <div class="stage-hint" id="stageHint" style="display:none;">Kéo để xoay · Lăn chuột để zoom · Giữ Shift để di chuyển</div>
            </div>

            <div class="preview-tools">
              <button type="button" id="btnSpin" disabled>Tự xoay</button>
              <button type="button" id="btnZoomIn" disabled>Phóng to</button>
              <button type="button" id="btnZoomOut" disabled>Thu nhỏ</button>
              <button type="button" id="btnTop" disabled>Nhìn từ trên</button>
              <button type="button" id="btnReset" disabled>Đặt lại góc nhìn</button>
            </div>

            <div class="dims">
              <div class="dim"><span>X</span><strong id="dimX">—</strong></div>
              <div class="dim"><span>Y</span><strong id="dimY">—</strong></div>
              <div class="dim"><span>Z</span><strong id="dimZ">—</strong></div>
              <div class="dim vol"><span>Thể tích</span><strong id="dimV">—</strong></div>
            </div>

            <div class="file-card" id="fileCard" style="display:none;">
              <div class="ft" id="fileExt">STL</div>
              <div class="fi">
                <strong id="fileName">—</strong>
                <span id="fileMeta">—</span>
              </div>
              <div class="fa">
                <button type="button" id="btnReplace">Đổi file</button>
                <button type="button" class="danger" id="btnRemove">Xoá</button>
              </div>
            </div>

            <div class="check-panel" id="checkPanel">
              <h5>Kiểm tra mô hình</h5>
              <div id="checkList">
                <div class="check-row"><span class="ic">·</span><span>Chưa có file để kiểm tra.</span></div>
              </div>
            </div>
          </div>
        </section>

        <!-- ============================================================
             CỘT PHẢI — FORM CẤU HÌNH
             ============================================================ -->
        <form class="config-col" id="orderForm" novalidate>

          <!-- 1. Upload -->
          <section class="panel" aria-label="Tải mô hình 3D">
            <h3>Mô hình 3D</h3>
            <p class="sub">Định dạng hỗ trợ: STL, OBJ, 3MF, STEP/STP. Dung lượng tối đa 60 MB.</p>

            <div class="dropzone" id="dropzone" tabindex="0" role="button" aria-label="Chọn file mô hình 3D">
              <div class="ic">⬆</div>
              <h4>Tải lên mô hình 3D</h4>
              <p>Kéo thả file vào đây, hoặc chọn file từ máy để bắt đầu đặt in.</p>
              <span class="btn-primary btn-sm">Chọn file</span>
              <div class="formats">
                <span class="pill">.STL</span><span class="pill">.OBJ</span>
                <span class="pill">.3MF</span><span class="pill">.STEP</span><span class="pill">.STP</span>
              </div>
            </div>
            <input type="file" id="fileInput" accept=".stl,.obj,.3mf,.step,.stp" hidden>

            <div class="opt-group" style="margin:24px 0 0;">
              <label for="qtyInput">Số lượng</label>
              <div class="qty-box">
                <div class="qty-ctrl">
                  <button type="button" id="qtyMinus" aria-label="Giảm số lượng">−</button>
                  <input type="number" id="qtyInput" value="1" min="1" step="1" inputmode="numeric" aria-label="Số lượng">
                  <button type="button" id="qtyPlus" aria-label="Tăng số lượng">+</button>
                </div>
                <div class="hint">Tối thiểu 1 sản phẩm. Đơn từ 20 sản phẩm được báo giá sỉ.</div>
              </div>
            </div>
          </section>

          <!-- 2. Kích thước -->
          <section class="panel" aria-label="Kích thước sản phẩm">
            <h3>Kích thước sản phẩm</h3>
            <p class="sub">Giữ nguyên kích thước file, phóng theo tỷ lệ phần trăm, hoặc nhập kích thước mong muốn.</p>

            <div class="chips" id="sizeModes" style="margin-bottom:18px;">
              <button type="button" class="chip active" data-mode="default">Kích thước gốc</button>
              <button type="button" class="chip" data-mode="scale">Phóng theo %</button>
              <button type="button" class="chip" data-mode="custom">Nhập kích thước</button>
            </div>

            <div id="sizeDefault">
              <div class="field-row">
                <div class="field"><label>X</label><input type="text" id="defX" value="—" readonly></div>
                <div class="field"><label>Y</label><input type="text" id="defY" value="—" readonly></div>
                <div class="field"><label>Z</label><input type="text" id="defZ" value="—" readonly></div>
              </div>
              <p class="opt-note">Sản phẩm được in đúng kích thước trong file bạn tải lên.</p>
            </div>

            <div id="sizeScale" style="display:none;">
              <div class="field" style="max-width:200px;">
                <label for="scaleInput">Tỷ lệ (%)</label>
                <input type="number" id="scaleInput" value="100" min="1" max="1000" step="1">
              </div>
              <div class="chips" id="scalePresets" style="margin:-4px 0 14px;">
                <button type="button" class="chip" data-scale="50">50%</button>
                <button type="button" class="chip" data-scale="100">100%</button>
                <button type="button" class="chip" data-scale="150">150%</button>
                <button type="button" class="chip" data-scale="200">200%</button>
              </div>
              <p class="opt-note">Kích thước sau khi phóng: <b id="scaleResult">—</b></p>
            </div>

            <div id="sizeCustom" style="display:none;">
              <div class="field-row">
                <div class="field"><label for="cusX">X (mm)</label><input type="number" id="cusX" min="0.1" step="0.1"></div>
                <div class="field"><label for="cusY">Y (mm)</label><input type="number" id="cusY" min="0.1" step="0.1"></div>
                <div class="field"><label for="cusZ">Z (mm)</label><input type="number" id="cusZ" min="0.1" step="0.1"></div>
              </div>
              <label style="display:flex; gap:9px; align-items:center; font-size:13.5px; cursor:pointer;">
                <input type="checkbox" id="lockRatio" checked style="width:17px;height:17px; accent-color:var(--violet);">
                Giữ tỷ lệ — thay đổi một chiều, hai chiều còn lại tự đổi theo
              </label>
            </div>
          </section>

          <!-- 3. Công nghệ + vật liệu -->
          <section class="panel" aria-label="Công nghệ và vật liệu">
            <h3>Công nghệ in</h3>
            <p class="sub">Không chắc chọn gì? FDM phù hợp với phần lớn nhu cầu thông thường.</p>
            <div class="opt-cards" id="techList"></div>

            <div class="opt-group" style="margin:26px 0 0;">
              <span class="opt-label">Vật liệu</span>
              <div class="opt-cards" id="materialList"></div>
              <p class="opt-note" id="materialNote"></p>
            </div>
          </section>

          <!-- 4. Màu sắc -->
          <section class="panel" aria-label="Màu sắc">
            <h3>Màu sắc</h3>
            <p class="sub">Chọn màu có sẵn hoặc gửi mã màu, hình mẫu để xưởng pha đúng.</p>
            <div class="swatches" id="swatches"></div>

            <div class="color-custom">
              <input type="color" id="colorPicker" value="#1A1A1A" aria-label="Chọn màu tuỳ chỉnh">
              <input type="text" id="colorHex" value="#1A1A1A" maxlength="7" aria-label="Mã màu HEX">
              <span style="font-size:12.5px; color:var(--ink-soft);">Nhập mã HEX nếu bạn có màu thương hiệu riêng</span>
            </div>

            <div class="ref-img" id="refImgBox">
              <div class="thumb" id="refThumb">🖼️</div>
              <div class="t">
                <strong id="refTitle">Tải hình mẫu màu</strong>
                <span id="refDesc">JPG hoặc PNG — dùng khi bạn muốn xưởng tham khảo màu thực tế.</span>
              </div>
              <button type="button" class="chip" id="refBtn">Chọn ảnh</button>
            </div>
            <input type="file" id="refInput" accept="image/*" hidden>

            <div class="notice">⚠ Màu thực tế có thể lệch so với màu trên màn hình, tuỳ vật liệu và công nghệ in.</div>
          </section>

          <!-- 5. Chất lượng + hậu xử lý -->
          <section class="panel" aria-label="Chất lượng và hoàn thiện">
            <h3>Chất lượng bề mặt</h3>
            <p class="sub" id="qualitySub">Lớp in càng mỏng, chi tiết càng mịn — thời gian in và chi phí cũng tăng theo.</p>
            <div class="opt-cards" id="qualityList"></div>

            <div class="opt-group" style="margin:26px 0 0;">
              <span class="opt-label">Xử lý bề mặt <span class="tip" data-tip="Chọn được nhiều tuỳ chọn. Hậu xử lý làm sản phẩm đẹp hơn nhưng kéo dài thời gian giao hàng.">?</span></span>
              <div class="opt-cards" id="postList"></div>
            </div>

            <div class="opt-group" style="margin:26px 0 0;">
              <span class="opt-label">Độ chính xác kích thước <span class="tip" data-tip="Dung sai là mức sai lệch cho phép giữa sản phẩm thực tế và kích thước thiết kế. Xưởng sẽ xác nhận mức đáp ứng được với công nghệ và vật liệu bạn chọn.">?</span></span>
              <div class="opt-cards" id="tolList"></div>
              <div class="tol-custom">
                <label for="tolCustom" style="font-size:13.5px; color:var(--ink-soft);">Dung sai riêng: ±</label>
                <input type="number" id="tolCustom" step="0.01" min="0.01" placeholder="0.15" disabled>
                <span style="font-size:13.5px; color:var(--ink-soft);">mm</span>
              </div>
            </div>
          </section>

          <!-- 6. Nâng cao + ghi chú -->
          <details class="adv">
            <summary>Cấu hình nâng cao (không bắt buộc)</summary>
            <div class="adv-body">
              <p style="font-size:13px; color:var(--ink-soft); margin-bottom:16px;">Để trống thì xưởng sẽ chọn thông số tối ưu cho mô hình của bạn.</p>
              <div class="field-row" style="grid-template-columns:repeat(2,1fr);">
                <div class="field">
                  <label for="advInfill">Mật độ đổ đầy (%)</label>
                  <input type="number" id="advInfill" min="0" max="100" step="5" placeholder="Xưởng đề xuất">
                </div>
                <div class="field">
                  <label for="advWall">Độ dày thành (mm)</label>
                  <input type="number" id="advWall" min="0.4" step="0.1" placeholder="Xưởng đề xuất">
                </div>
                <div class="field">
                  <label for="advSupport">Support</label>
                  <select id="advSupport">
                    <option value="auto">Để xưởng quyết định</option>
                    <option value="yes">Có support</option>
                    <option value="no">Không dùng support</option>
                  </select>
                </div>
                <div class="field">
                  <label for="advNozzle">Đường kính nozzle (mm)</label>
                  <select id="advNozzle">
                    <option value="auto">Để xưởng quyết định</option>
                    <option value="0.2">0.2</option>
                    <option value="0.4">0.4</option>
                    <option value="0.6">0.6</option>
                    <option value="0.8">0.8</option>
                  </select>
                </div>
              </div>
            </div>
          </details>

          <section class="panel" aria-label="Yêu cầu đặc biệt">
            <h3>Yêu cầu đặc biệt</h3>
            <p class="sub">Ghi chú những điểm xưởng cần lưu ý khi in hoặc hoàn thiện sản phẩm.</p>
            <div class="field" style="margin:0;">
              <textarea id="notes" rows="4" placeholder="Ví dụ: lỗ ở đế cần giữ đúng đường kính 10 mm, vui lòng kiểm tra trước khi in."></textarea>
            </div>
          </section>

          <!-- 7. Tổng quan -->
          <section class="summary-card" aria-label="Tổng quan đơn hàng">
            <h3>Tổng quan đơn hàng</h3>
            <div class="sum-row"><span>Mô hình</span><b id="sModel" class="muted">Chưa tải file</b></div>
            <div class="sum-row"><span>Số lượng</span><b id="sQty">1</b></div>
            <div class="sum-row"><span>Kích thước</span><b id="sSize" class="muted">—</b></div>
            <div class="sum-row"><span>Công nghệ</span><b id="sTech">FDM</b></div>
            <div class="sum-row"><span>Vật liệu</span><b id="sMat">PLA</b></div>
            <div class="sum-row"><span>Màu</span><b id="sColor"><i class="sum-dot" id="sColorDot" style="background:#1A1A1A"></i>Đen</b></div>
            <div class="sum-row"><span>Chất lượng</span><b id="sQuality">—</b></div>
            <div class="sum-row"><span>Xử lý bề mặt</span><b id="sPost" class="muted">Không xử lý</b></div>
            <div class="sum-row"><span>Dung sai</span><b id="sTol">±0.3 mm</b></div>
          </section>

          <!-- 8. Giá dự kiến -->
          <section class="price-box" aria-label="Giá dự kiến">
            <h4>Giá dự kiến</h4>
            <div class="row"><span>Vật liệu</span><b id="pMat">—</b></div>
            <div class="row"><span>Thời gian máy</span><b id="pTime">Theo thể tích &amp; lớp in</b></div>
            <div class="row"><span>Gia công &amp; hậu xử lý</span><b id="pPost">Không xử lý</b></div>
            <div class="row"><span>Số lượng</span><b id="pQty">× 1</b></div>
            <div class="row total"><span>Tạm tính</span><span class="big" id="pTotal">Chờ xác nhận</span></div>
            <p class="note">Giá sẽ được xưởng xác nhận sau khi kiểm tra file. Bạn nhận báo giá chi tiết trong vòng 2 giờ làm việc và chỉ thanh toán khi đồng ý.</p>
          </section>

          <!-- 9. Hành động -->
          <div>
            <div class="form-error" id="formError" role="alert"></div>
            <div class="actions">
              <button type="submit" class="btn-primary">Tiếp tục đặt hàng</button>
              <button type="button" class="btn-secondary" id="btnSave">Lưu cấu hình</button>
            </div>
          </div>
        </form>
      </div>
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

  <!-- ============ MODAL XÁC NHẬN ============ -->
  <div class="modal" id="confirmModal">
    <div class="modal-box">
      <button class="modal-close" type="button" data-close>×</button>
      <div class="success-screen" style="text-align:center;">
        <div class="success-icon">✓</div>
        <h3>Đã gửi yêu cầu in</h3>
        <p class="sub" style="margin-bottom:0;">Xưởng sẽ kiểm tra file và gửi báo giá trong vòng 2 giờ làm việc.</p>
        <div class="order-code" id="orderCode">#3D-000000</div>
      </div>
      <div class="summary-card" style="box-shadow:none; margin-top:10px;">
        <div id="confirmSummary"></div>
      </div>
      <div class="actions" style="margin-top:18px;">
        <button type="button" class="btn-primary" data-close style="flex:1;">Đã hiểu</button>
      </div>
    </div>
  </div>

  <div class="toast" id="toast"></div>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
  <script>
  /* ============================================================
     1. DỮ LIỆU CẤU HÌNH — thêm/bớt công nghệ, vật liệu tại đây
     ============================================================ */
  const QUALITY_SETS = {
    fdm: [
      {id:'standard', name:'Standard', layer:0.28, desc:'Prototype, sản phẩm ưu tiên chi phí.'},
      {id:'normal',   name:'Normal',   layer:0.20, desc:'Cân bằng cho nhu cầu thông thường.'},
      {id:'fine',     name:'Fine',     layer:0.12, desc:'Nhiều chi tiết, bề mặt mịn hơn.'},
      {id:'ultra',    name:'Ultra Fine', layer:0.08, desc:'Chi tiết cao, thời gian in dài hơn.'}
    ],
    resin: [
      {id:'r-normal', name:'Normal',     layer:0.10, desc:'Mô hình thông thường, in nhanh.'},
      {id:'r-fine',   name:'Fine',       layer:0.05, desc:'Chi tiết sắc nét cho mô hình trưng bày.'},
      {id:'r-ultra',  name:'Ultra Fine', layer:0.03, desc:'Chi tiết rất nhỏ như trang sức, nha khoa.'}
    ],
    powder: [
      {id:'p-standard', name:'Standard', layer:0.12, desc:'Mặc định của máy, phù hợp đa số chi tiết.'},
      {id:'p-fine',     name:'Fine',     layer:0.08, desc:'Bề mặt mịn hơn, dùng cho chi tiết nhỏ.'}
    ]
  };

  const TECHNOLOGIES = [
    {
      id:'fdm', name:'FDM', tagline:'Phổ biến nhất',
      desc:'Phù hợp prototype, đồ dùng, mô hình lớn và các sản phẩm ưu tiên chi phí.',
      build:{x:300,y:300,z:400}, quality:'fdm',
      materials:[
        {id:'pla',   name:'PLA',   desc:'Dễ in, giá tốt, nhiều màu — dùng trong nhà.'},
        {id:'plap',  name:'PLA+',  desc:'Bền và dai hơn PLA thường.'},
        {id:'petg',  name:'PETG',  desc:'Chịu ẩm và va đập tốt, hơi dẻo.'},
        {id:'abs',   name:'ABS',   desc:'Chịu nhiệt, gia công và sơn dễ.'},
        {id:'asa',   name:'ASA',   desc:'Chịu nắng mưa, dùng ngoài trời.'},
        {id:'tpu',   name:'TPU',   desc:'Dẻo như cao su, làm ron, vỏ bọc.'},
        {id:'nylon', name:'Nylon', desc:'Dai, chịu mài mòn cho chi tiết cơ khí.'},
        {id:'pc',    name:'PC',    desc:'Cứng và chịu nhiệt cao.'}
      ]
    },
    {
      id:'sla', name:'SLA', tagline:'Resin',
      desc:'Mô hình cần độ chi tiết cao và bề mặt mịn.',
      build:{x:145,y:145,z:175}, quality:'resin', materials:'resin'
    },
    {
      id:'msla', name:'MSLA', tagline:'Resin',
      desc:'Chi tiết cao, chi phí hợp lý cho mô hình nhỏ và vừa.',
      build:{x:218,y:123,z:230}, quality:'resin', materials:'resin'
    },
    {
      id:'dlp', name:'DLP', tagline:'Resin',
      desc:'Bề mặt mịn, in nhanh cho chi tiết nhỏ chính xác.',
      build:{x:192,y:120,z:280}, quality:'resin', materials:'resin'
    },
    {
      id:'sls', name:'SLS', tagline:'Bột nylon',
      desc:'Hình dạng phức tạp, không cần support truyền thống.',
      build:{x:300,y:300,z:300}, quality:'powder',
      materials:[
        {id:'pa12', name:'Nylon PA12', desc:'Bền, ổn định — lựa chọn mặc định của SLS.'},
        {id:'pa11', name:'PA11',       desc:'Dai hơn PA12, chịu va đập tốt.'},
        {id:'pa12gf', name:'PA12-GF',  desc:'Pha sợi thuỷ tinh, cứng và ổn định nhiệt.'}
      ]
    },
    {
      id:'mjf', name:'MJF', tagline:'Sản xuất loạt',
      desc:'Chi tiết có độ bền và độ đồng nhất cao, hợp sản xuất số lượng.',
      build:{x:380,y:284,z:380}, quality:'powder',
      materials:[
        {id:'mjf-pa12', name:'PA12',      desc:'Chi tiết chức năng, bền và đồng nhất.'},
        {id:'mjf-pa11', name:'PA11',      desc:'Dẻo dai hơn, chịu va đập.'},
        {id:'mjf-tpu',  name:'TPU',       desc:'Đàn hồi — tuỳ khả năng của xưởng.'}
      ]
    }
  ];

  const RESIN_MATERIALS = [
    {id:'std-resin',  name:'Standard Resin',    desc:'Mô hình trưng bày, chi tiết sắc nét.'},
    {id:'tough-resin',name:'Tough Resin',       desc:'Chịu lực tốt hơn, ít giòn.'},
    {id:'abs-resin',  name:'ABS-like Resin',    desc:'Tính chất gần ABS, dùng cho chi tiết chức năng.'},
    {id:'flex-resin', name:'Flexible Resin',    desc:'Dẻo, đàn hồi nhẹ.'},
    {id:'eng-resin',  name:'Engineering Resin', desc:'Chịu nhiệt và tải cho chi tiết kỹ thuật.'}
  ];

  const COLORS = [
    {id:'black', name:'Đen',     hex:'#1A1A1A'},
    {id:'white', name:'Trắng',   hex:'#F5F5F5'},
    {id:'gray',  name:'Xám',     hex:'#8A8A99'},
    {id:'red',   name:'Đỏ',      hex:'#E03131'},
    {id:'blue',  name:'Xanh dương', hex:'#1C7ED6'},
    {id:'yellow',name:'Vàng',    hex:'#FAB005'},
    {id:'orange',name:'Cam',     hex:'#FD7E14'},
    {id:'green', name:'Xanh lá', hex:'#2F9E44'}
  ];

  const POST_OPTIONS = [
    {id:'none',    name:'Không xử lý', desc:'Giữ nguyên sau khi in, làm sạch cơ bản.', exclusive:true},
    {id:'sanding', name:'Chà nhám',    desc:'Làm mịn bề mặt bằng sanding.'},
    {id:'paint',   name:'Sơn màu',     desc:'Sơn theo màu bạn chọn.'},
    {id:'gloss',   name:'Sơn bóng',    desc:'Hoàn thiện bề mặt bóng.'},
    {id:'matte',   name:'Sơn mờ',      desc:'Hoàn thiện bề mặt matte.'},
    {id:'polish',  name:'Đánh bóng',   desc:'Tăng độ mịn và độ bóng.'},
    {id:'special', name:'Xử lý đặc biệt', desc:'Mô tả trong ghi chú, xưởng báo giá riêng.'}
  ];

  const TOLERANCES = [
    {id:'std',  name:'Tiêu chuẩn', value:0.3, desc:'Đủ cho hầu hết mô hình và đồ dùng.'},
    {id:'high', name:'Cao',        value:0.2, desc:'Chi tiết cần lắp ghép với nhau.'},
    {id:'vhigh',name:'Rất cao',    value:0.1, desc:'Chi tiết kỹ thuật, dung sai chặt.'},
    {id:'custom',name:'Dung sai riêng', value:null, desc:'Tự nhập mức dung sai bạn cần.'}
  ];

  const ACCEPTED_EXT = ['stl','obj','3mf','step','stp'];
  const PREVIEWABLE  = ['stl','obj'];
  const MAX_SIZE_MB  = 60;

  /* ============================================================
     2. TRẠNG THÁI
     ============================================================ */
  const state = {
    file:null, ext:'', previewable:false,
    base:null,            // {x,y,z} mm gốc từ file
    volume:null,          // cm³ gốc
    sizeMode:'default',
    scale:100,
    custom:{x:null,y:null,z:null},
    lockRatio:true,
    qty:1,
    tech:'fdm', material:'pla',
    colorId:'black', colorHex:'#1A1A1A', colorName:'Đen', refImage:null,
    quality:'normal',
    post:['none'],
    tol:'std', tolCustom:null,
    notes:''
  };

  const $ = (id) => document.getElementById(id);

  /* ============================================================
     3. TIỆN ÍCH
     ============================================================ */
  function toast(msg, type){
    const t = $('toast');
    t.textContent = msg;
    t.className = 'toast show' + (type ? ' ' + type : '');
    clearTimeout(t._t);
    t._t = setTimeout(() => { t.className = 'toast' + (type ? ' ' + type : ''); }, 3200);
  }
  const toastOk  = m => toast(m, 'ok');
  const toastErr = m => toast(m, 'err');

  const fmt = n => (Math.round(n * 10) / 10).toLocaleString('vi-VN');
  const fileSize = b => b < 1024*1024 ? (b/1024).toFixed(0) + ' KB' : (b/1024/1024).toFixed(1) + ' MB';
  const getTech = () => TECHNOLOGIES.find(t => t.id === state.tech);
  const getMaterials = () => {
    const t = getTech();
    return t.materials === 'resin' ? RESIN_MATERIALS : t.materials;
  };
  const getQualities = () => QUALITY_SETS[getTech().quality];
  const matName = () => (getMaterials().find(m => m.id === state.material) || {}).name || '—';

  /** Kích thước cuối cùng sau khi áp size mode */
  function finalSize(){
    if(!state.base) return null;
    if(state.sizeMode === 'scale'){
      const k = (state.scale || 100) / 100;
      return {x:state.base.x*k, y:state.base.y*k, z:state.base.z*k, k};
    }
    if(state.sizeMode === 'custom' && state.custom.x && state.custom.y && state.custom.z){
      return {x:state.custom.x, y:state.custom.y, z:state.custom.z, k:state.custom.x/state.base.x};
    }
    return {x:state.base.x, y:state.base.y, z:state.base.z, k:1};
  }
  function finalVolume(){
    const s = finalSize();
    if(!s || state.volume == null) return null;
    return state.volume * Math.pow(s.k || 1, 3);
  }

  /* ============================================================
     4. PARSER FILE 3D (STL nhị phân / ASCII, OBJ)
     ============================================================ */
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
        off += 12; // bỏ normal
        for(let v=0; v<3; v++){
          verts.push(view.getFloat32(off, true), view.getFloat32(off+4, true), view.getFloat32(off+8, true));
          off += 12;
        }
        off += 2;
      }
    } else {
      const text = new TextDecoder().decode(new Uint8Array(buffer));
      const re = /vertex\s+([-\d.eE+]+)\s+([-\d.eE+]+)\s+([-\d.eE+]+)/g;
      let m;
      while((m = re.exec(text)) !== null) verts.push(+m[1], +m[2], +m[3]);
    }
    if(verts.length < 9) throw new Error('empty');
    return new Float32Array(verts);
  }

  function parseOBJ(buffer){
    const text = new TextDecoder().decode(new Uint8Array(buffer));
    const pts = [], out = [];
    const lines = text.split('\n');
    for(const raw of lines){
      const line = raw.trim();
      if(line.startsWith('v ')){
        const p = line.split(/\s+/);
        pts.push([+p[1], +p[2], +p[3]]);
      } else if(line.startsWith('f ')){
        const idx = line.split(/\s+/).slice(1).map(tok => {
          let i = parseInt(tok.split('/')[0], 10);
          return i < 0 ? pts.length + i : i - 1;
        }).filter(i => !isNaN(i) && pts[i]);
        for(let i=1; i<idx.length-1; i++){           // fan-triangulate
          [idx[0], idx[i], idx[i+1]].forEach(k => out.push(pts[k][0], pts[k][1], pts[k][2]));
        }
      }
    }
    if(out.length < 9) throw new Error('empty');
    return new Float32Array(out);
  }

  /** Thể tích mesh (mm³) bằng tổng tetrahedron có dấu */
  function meshVolume(pos){
    let v = 0;
    for(let i=0; i<pos.length; i+=9){
      const ax=pos[i],   ay=pos[i+1], az=pos[i+2];
      const bx=pos[i+3], by=pos[i+4], bz=pos[i+5];
      const cx=pos[i+6], cy=pos[i+7], cz=pos[i+8];
      v += (ax*(by*cz - bz*cy) - ay*(bx*cz - bz*cx) + az*(bx*cy - by*cx)) / 6;
    }
    return Math.abs(v);
  }

  /* ============================================================
     5. VIEWER 3D (Three.js + điều khiển tự viết)
     ============================================================ */
  const Viewer = (() => {
    const stage = $('stage');
    let renderer, scene, camera, mesh, raf = null, ready = false;
    let spin = false;
    const cam = {theta:-0.9, phi:1.05, dist:3, target:new THREE.Vector3()};
    let radius = 1;

    function init(){
      if(ready || typeof THREE === 'undefined') return ready;
      renderer = new THREE.WebGLRenderer({antialias:true, alpha:true});
      renderer.setPixelRatio(Math.min(devicePixelRatio, 2));
      renderer.setSize(stage.clientWidth, stage.clientHeight);
      stage.appendChild(renderer.domElement);

      scene = new THREE.Scene();
      camera = new THREE.PerspectiveCamera(42, stage.clientWidth/stage.clientHeight, 0.01, 5000);

      scene.add(new THREE.HemisphereLight(0xffffff, 0xC8C2E8, 0.95));
      const key = new THREE.DirectionalLight(0xffffff, 0.85); key.position.set(1.4, 2, 1.6); scene.add(key);
      const rim = new THREE.DirectionalLight(0xA29BFE, 0.5);  rim.position.set(-2, 1, -1.4);  scene.add(rim);

      bindControls();
      new ResizeObserver(resize).observe(stage);
      ready = true;
      return true;
    }

    function resize(){
      if(!renderer) return;
      const w = stage.clientWidth, h = stage.clientHeight;
      if(!w || !h) return;
      renderer.setSize(w, h);
      camera.aspect = w/h; camera.updateProjectionMatrix();
      render();
    }

    function bindControls(){
      const el = renderer.domElement;
      let drag = null;
      const pos = e => ({x:e.touches ? e.touches[0].clientX : e.clientX, y:e.touches ? e.touches[0].clientY : e.clientY});

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
      const pinchDist = e => Math.hypot(e.touches[0].clientX - e.touches[1].clientX, e.touches[0].clientY - e.touches[1].clientY);

      el.addEventListener('mousedown', down);
      window.addEventListener('mousemove', move);
      window.addEventListener('mouseup', up);
      el.addEventListener('touchstart', down, {passive:false});
      el.addEventListener('touchmove', move, {passive:false});
      el.addEventListener('touchend', up);
      el.addEventListener('contextmenu', e => e.preventDefault());
      el.addEventListener('wheel', e => {
        if(!mesh) return;
        cam.dist *= e.deltaY > 0 ? 1.1 : 0.9; clampDist(); render(); e.preventDefault();
      }, {passive:false});
    }

    const clampDist = () => { cam.dist = Math.max(radius*1.2, Math.min(radius*14, cam.dist)); };

    function render(){
      if(!renderer || !scene) return;
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

    return {
      available: () => typeof THREE !== 'undefined',
      show(positions, colorHex){
        if(!init()) return false;
        this.clear();
        const geo = new THREE.BufferGeometry();
        geo.setAttribute('position', new THREE.BufferAttribute(positions, 3));
        geo.computeVertexNormals();
        geo.computeBoundingBox();
        const box = geo.boundingBox;
        const center = new THREE.Vector3(); box.getCenter(center);
        geo.translate(-center.x, -center.y, -center.z);

        const size = new THREE.Vector3(); box.getSize(size);
        radius = Math.max(size.x, size.y, size.z) || 1;

        const mat = new THREE.MeshStandardMaterial({
          color:new THREE.Color(colorHex || '#6C5CE7'), roughness:0.55, metalness:0.08, flatShading:false
        });
        mesh = new THREE.Mesh(geo, mat);
        scene.add(mesh);

        const grid = new THREE.GridHelper(radius*3, 14, 0xC9C3E8, 0xE6E2F5);
        grid.position.y = -size.y/2 - radius*0.02;
        grid.name = 'grid';
        scene.add(grid);

        this.reset();
        return true;
      },
      setColor(hex){ if(mesh) { mesh.material.color.set(hex); render(); } },
      reset(){
        cam.theta = -0.9; cam.phi = 1.05; cam.dist = radius * 2.6;
        cam.target.set(0,0,0); render();
      },
      top(){ cam.theta = 0; cam.phi = 0.2; render(); },
      zoom(f){ if(!mesh) return; cam.dist *= f; clampDist(); render(); },
      toggleSpin(){
        spin = !spin;
        if(spin && !raf) raf = requestAnimationFrame(loop);
        return spin;
      },
      clear(){
        spin = false; if(raf){ cancelAnimationFrame(raf); raf = null; }
        if(!scene) return;
        [mesh, scene.getObjectByName('grid')].forEach(o => {
          if(!o) return;
          scene.remove(o);
          if(o.geometry) o.geometry.dispose();
          if(o.material) o.material.dispose();
        });
        mesh = null;
        if(renderer) renderer.clear();
      }
    };
  })();

  /* ============================================================
     6. RENDER CÁC NHÓM LỰA CHỌN
     ============================================================ */
  function optCard(active, title, sub, desc, square){
    return `<span class="radio${square ? ' sq' : ''}"></span>
      <span class="oc-body"><strong>${title}</strong>${sub ? `<em>${sub}</em>` : ''}${desc ? `<span>${desc}</span>` : ''}</span>`;
  }

  function renderTech(){
    $('techList').innerHTML = TECHNOLOGIES.map(t => `
      <button type="button" class="opt-card ${t.id === state.tech ? 'active' : ''}" data-tech="${t.id}">
        ${optCard(true, t.name, t.tagline, t.desc)}
      </button>`).join('');
    $('techList').querySelectorAll('[data-tech]').forEach(b => {
      b.onclick = () => {
        if(state.tech === b.dataset.tech) return;
        state.tech = b.dataset.tech;
        const mats = getMaterials();
        state.material = mats[0].id;                              // vật liệu đổi theo công nghệ
        const qs = getQualities();
        state.quality = (qs.find(q => q.id === state.quality) || qs[Math.min(1, qs.length-1)]).id;
        renderTech(); renderMaterials(); renderQuality(); update();
      };
    });
  }

  function renderMaterials(){
    const mats = getMaterials();
    $('materialList').innerHTML = mats.map(m => `
      <button type="button" class="opt-card ${m.id === state.material ? 'active' : ''}" data-mat="${m.id}">
        ${optCard(true, m.name, '', m.desc)}
      </button>`).join('');
    $('materialList').querySelectorAll('[data-mat]').forEach(b => {
      b.onclick = () => { state.material = b.dataset.mat; renderMaterials(); update(); };
    });
    const t = getTech();
    $('materialNote').textContent = t.materials === 'resin'
      ? 'Danh sách resin dùng chung cho SLA, MSLA và DLP. Cần loại resin đặc thù? Ghi trong yêu cầu đặc biệt.'
      : (t.quality === 'powder'
          ? 'Vật liệu bột phụ thuộc máy của từng xưởng — xưởng sẽ xác nhận khi nhận đơn.'
          : 'Chưa thấy vật liệu bạn cần? Ghi rõ trong phần yêu cầu đặc biệt.');
  }

  function renderQuality(){
    const qs = getQualities();
    $('qualityList').innerHTML = qs.map(q => `
      <button type="button" class="opt-card ${q.id === state.quality ? 'active' : ''}" data-q="${q.id}">
        ${optCard(true, q.name, q.layer.toFixed(2) + ' mm', q.desc)}
      </button>`).join('');
    $('qualityList').querySelectorAll('[data-q]').forEach(b => {
      b.onclick = () => { state.quality = b.dataset.q; renderQuality(); update(); };
    });
    const set = getTech().quality;
    $('qualitySub').textContent = set === 'resin'
      ? 'Với công nghệ resin, độ dày lớp nhỏ hơn nhiều so với FDM nên chi tiết mịn hơn hẳn.'
      : set === 'powder'
        ? 'Độ dày lớp của SLS/MJF cố định theo máy, chủ yếu ảnh hưởng tới bề mặt chi tiết nhỏ.'
        : 'Lớp in càng mỏng, chi tiết càng mịn — thời gian in và chi phí cũng tăng theo.';
  }

  function renderColors(){
    $('swatches').innerHTML = COLORS.map(c => `
      <button type="button" class="swatch ${c.id === state.colorId ? 'active' : ''}"
        data-color="${c.id}" style="background:${c.hex}" title="${c.name}" aria-label="${c.name}"></button>`).join('');
    $('swatches').querySelectorAll('[data-color]').forEach(b => {
      b.onclick = () => {
        const c = COLORS.find(x => x.id === b.dataset.color);
        state.colorId = c.id; state.colorHex = c.hex; state.colorName = c.name;
        $('colorPicker').value = c.hex; $('colorHex').value = c.hex.toUpperCase();
        renderColors(); Viewer.setColor(c.hex); update();
      };
    });
  }

  function renderPost(){
    $('postList').innerHTML = POST_OPTIONS.map(p => `
      <button type="button" class="opt-card ${state.post.includes(p.id) ? 'active' : ''}" data-post="${p.id}">
        ${optCard(true, p.name, '', p.desc, true)}
      </button>`).join('');
    $('postList').querySelectorAll('[data-post]').forEach(b => {
      b.onclick = () => {
        const id = b.dataset.post;
        if(id === 'none'){ state.post = ['none']; }
        else {
          state.post = state.post.filter(x => x !== 'none');
          state.post.includes(id) ? state.post = state.post.filter(x => x !== id) : state.post.push(id);
          if(!state.post.length) state.post = ['none'];
        }
        renderPost(); update();
      };
    });
  }

  function renderTol(){
    $('tolList').innerHTML = TOLERANCES.map(t => `
      <button type="button" class="opt-card ${t.id === state.tol ? 'active' : ''}" data-tol="${t.id}">
        ${optCard(true, t.name, t.value ? '±' + t.value.toFixed(1) + ' mm' : '', t.desc)}
      </button>`).join('');
    $('tolList').querySelectorAll('[data-tol]').forEach(b => {
      b.onclick = () => {
        state.tol = b.dataset.tol;
        $('tolCustom').disabled = state.tol !== 'custom';
        if(state.tol === 'custom') $('tolCustom').focus();
        renderTol(); update();
      };
    });
  }

  function tolText(){
    if(state.tol === 'custom') return state.tolCustom ? '±' + state.tolCustom + ' mm' : 'Chưa nhập';
    const t = TOLERANCES.find(x => x.id === state.tol);
    return '±' + t.value.toFixed(1) + ' mm';
  }
  function postText(){
    return state.post.map(id => POST_OPTIONS.find(p => p.id === id).name).join(', ');
  }
  function qualityText(){
    const q = getQualities().find(x => x.id === state.quality);
    return q ? `${q.name} – ${q.layer.toFixed(2)} mm` : '—';
  }

  /* ============================================================
     7. XỬ LÝ FILE
     ============================================================ */
  function handleFile(file){
    const ext = (file.name.split('.').pop() || '').toLowerCase();
    if(!ACCEPTED_EXT.includes(ext)){
      toastErr('Định dạng file không được hỗ trợ.');
      return;
    }
    if(file.size > MAX_SIZE_MB * 1024 * 1024){
      toastErr(`Dung lượng file vượt quá giới hạn ${MAX_SIZE_MB} MB.`);
      return;
    }

    state.file = file; state.ext = ext;
    state.previewable = PREVIEWABLE.includes(ext) && Viewer.available();

    $('fileCard').style.display = 'flex';
    $('fileExt').textContent = ext.toUpperCase();
    $('fileName').textContent = file.name;
    $('fileMeta').textContent = `${ext.toUpperCase()} · ${fileSize(file.size)}`;
    $('dropzone').querySelector('h4').textContent = 'Đổi mô hình khác';
    $('dropzone').querySelector('p').textContent = 'Tải file mới để thay thế mô hình hiện tại. Kích thước và thể tích sẽ được tính lại.';

    if(!state.previewable){
      state.base = null; state.volume = null;
      Viewer.clear();
      $('stageEmpty').style.display = 'flex';
      $('stageEmpty').querySelector('h4').textContent = 'Chưa xem trước được định dạng này';
      $('stageEmpty').querySelector('p').textContent = ext.toUpperCase() + ' cần xưởng mở bằng phần mềm CAD. Bạn nhập kích thước mong muốn ở mục “Kích thước sản phẩm”.';
      $('stageBadge').textContent = 'Không có preview';
      state.sizeMode = 'custom';
      syncSizeMode();
      toolsEnabled(false);
      update();
      return;
    }

    const reader = new FileReader();
    reader.onload = e => {
      try{
        const pos = ext === 'stl' ? parseSTL(e.target.result) : parseOBJ(e.target.result);

        let minX=Infinity,minY=Infinity,minZ=Infinity,maxX=-Infinity,maxY=-Infinity,maxZ=-Infinity;
        for(let i=0; i<pos.length; i+=3){
          if(pos[i]<minX) minX=pos[i];     if(pos[i]>maxX) maxX=pos[i];
          if(pos[i+1]<minY) minY=pos[i+1]; if(pos[i+1]>maxY) maxY=pos[i+1];
          if(pos[i+2]<minZ) minZ=pos[i+2]; if(pos[i+2]>maxZ) maxZ=pos[i+2];
        }
        // STL/OBJ không có đơn vị — quy ước 1 unit = 1 mm như đa số phần mềm CAD
        state.base = {x:maxX-minX, y:maxY-minY, z:maxZ-minZ};
        state.volume = meshVolume(pos) / 1000;   // mm³ → cm³
        state.triangles = pos.length / 9;

        const ok = Viewer.show(pos, state.colorHex);
        $('stageEmpty').style.display = ok ? 'none' : 'flex';
        $('stageHint').style.display = ok ? 'block' : 'none';
        $('stage').classList.toggle('loaded', ok);
        $('stageBadge').textContent = ok ? state.triangles.toLocaleString('vi-VN') + ' tam giác' : 'Không hiển thị được';
        toolsEnabled(ok);

        state.custom = {x:+state.base.x.toFixed(1), y:+state.base.y.toFixed(1), z:+state.base.z.toFixed(1)};
        $('cusX').value = state.custom.x; $('cusY').value = state.custom.y; $('cusZ').value = state.custom.z;
        state.sizeMode = 'default'; state.scale = 100; $('scaleInput').value = 100;
        syncSizeMode();
        update();
        toastOk('Đã tải mô hình lên');
      } catch(err){
        state.base = null; state.volume = null;
        Viewer.clear();
        $('stageEmpty').style.display = 'flex';
        $('stageEmpty').querySelector('h4').textContent = 'Không đọc được file';
        $('stageEmpty').querySelector('p').textContent = 'File có thể bị lỗi hoặc rỗng. Thử xuất lại từ phần mềm thiết kế rồi tải lên lần nữa.';
        $('stageBadge').textContent = 'Lỗi đọc file';
        toolsEnabled(false);
        state.sizeMode = 'custom'; syncSizeMode();
        update();
        toastErr('Không đọc được nội dung mô hình.');
      }
    };
    reader.onerror = () => toastErr('Không đọc được file. Thử lại nhé.');
    reader.readAsArrayBuffer(file);
  }

  function clearFile(){
    state.file = null; state.ext = ''; state.base = null; state.volume = null;
    state.custom = {x:null,y:null,z:null}; state.sizeMode = 'default'; state.scale = 100;
    Viewer.clear();
    $('fileCard').style.display = 'none';
    $('fileInput').value = '';
    $('stage').classList.remove('loaded');
    $('stageEmpty').style.display = 'flex';
    $('stageEmpty').querySelector('h4').textContent = 'Chưa có mô hình để hiển thị';
    $('stageEmpty').querySelector('p').textContent = 'Tải file 3D ở cột bên phải để xem trước, đo kích thước và thể tích.';
    $('stageHint').style.display = 'none';
    $('stageBadge').textContent = 'Chưa có mô hình';
    $('dropzone').querySelector('h4').textContent = 'Tải lên mô hình 3D';
    $('dropzone').querySelector('p').textContent = 'Kéo thả file vào đây, hoặc chọn file từ máy để bắt đầu đặt in.';
    $('cusX').value = ''; $('cusY').value = ''; $('cusZ').value = '';
    $('scaleInput').value = 100;
    toolsEnabled(false);
    syncSizeMode();
    update();
  }

  function toolsEnabled(on){
    ['btnSpin','btnZoomIn','btnZoomOut','btnTop','btnReset'].forEach(id => $(id).disabled = !on);
    if(!on) $('btnSpin').classList.remove('on');
  }

  /* ============================================================
     8. KIỂM TRA MÔ HÌNH
     ============================================================ */
  function runChecks(){
    const rows = [];
    if(!state.file){
      rows.push({t:'', ic:'·', m:'Chưa có file để kiểm tra.'});
    } else {
      rows.push({t:'ok', ic:'✓', m:`Đọc được file ${state.ext.toUpperCase()} (${fileSize(state.file.size)}).`});

      if(!state.previewable){
        rows.push({t:'warn', ic:'⚠', m:'Định dạng này cần xưởng mở bằng CAD — chưa kiểm tra tự động được kích thước.'});
      } else if(!state.base){
        rows.push({t:'err', ic:'✕', m:'Không đọc được hình học trong file.'});
      } else {
        const s = finalSize(), b = getTech().build;
        const over = s.x > b.x || s.y > b.y || s.z > b.z;
        rows.push(over
          ? {t:'err', ic:'✕', m:`Mô hình ${fmt(s.x)}×${fmt(s.y)}×${fmt(s.z)} mm vượt vùng in ${b.x}×${b.y}×${b.z} mm của ${getTech().name}. Thu nhỏ lại, đổi công nghệ, hoặc để xưởng cắt ghép.`}
          : {t:'ok', ic:'✓', m:`Kích thước nằm trong vùng in ${b.x}×${b.y}×${b.z} mm của ${getTech().name}.`});

        const min = Math.min(s.x, s.y, s.z);
        const layer = (getQualities().find(q => q.id === state.quality) || {}).layer || 0.2;
        if(min < layer * 6){
          rows.push({t:'warn', ic:'⚠', m:`Chi tiết mỏng nhất khoảng ${fmt(min)} mm — khá mỏng so với lớp in ${layer} mm, có thể gãy khi in.`});
        }
        if(state.volume != null && state.volume < 0.01){
          rows.push({t:'warn', ic:'⚠', m:'Thể tích rất nhỏ — kiểm tra lại đơn vị của file (có thể file đang ở cm hoặc inch).'});
        }
        if(state.triangles && state.triangles < 60){
          rows.push({t:'warn', ic:'⚠', m:'Lưới mô hình khá thô, bề mặt cong có thể bị gãy khúc khi in.'});
        }
        if(rows.every(r => r.t === 'ok')){
          rows.push({t:'ok', ic:'✓', m:'Mô hình hợp lệ, sẵn sàng gửi xưởng kiểm tra chi tiết.'});
        }
      }
    }
    $('checkList').innerHTML = rows.map(r => `
      <div class="check-row ${r.t}"><span class="ic">${r.ic}</span><span>${r.m}</span></div>`).join('');
    return rows;
  }

  /* ============================================================
     9. CẬP NHẬT GIAO DIỆN
     ============================================================ */
  function syncSizeMode(){
    $('sizeModes').querySelectorAll('.chip').forEach(c => c.classList.toggle('active', c.dataset.mode === state.sizeMode));
    $('sizeDefault').style.display = state.sizeMode === 'default' ? 'block' : 'none';
    $('sizeScale').style.display   = state.sizeMode === 'scale'   ? 'block' : 'none';
    $('sizeCustom').style.display  = state.sizeMode === 'custom'  ? 'block' : 'none';
  }

  function update(){
    const s = finalSize(), v = finalVolume();

    // kích thước hiển thị
    $('dimX').textContent = s ? fmt(s.x) + ' mm' : '—';
    $('dimY').textContent = s ? fmt(s.y) + ' mm' : '—';
    $('dimZ').textContent = s ? fmt(s.z) + ' mm' : '—';
    $('dimV').textContent = v != null ? fmt(v) + ' cm³' : '—';

    $('defX').value = state.base ? fmt(state.base.x) + ' mm' : '—';
    $('defY').value = state.base ? fmt(state.base.y) + ' mm' : '—';
    $('defZ').value = state.base ? fmt(state.base.z) + ' mm' : '—';
    $('scaleResult').textContent = (state.base && state.sizeMode === 'scale')
      ? `${fmt(s.x)} × ${fmt(s.y)} × ${fmt(s.z)} mm` : '—';
    $('scalePresets').querySelectorAll('.chip').forEach(c => c.classList.toggle('active', +c.dataset.scale === +state.scale));

    // tổng quan
    $('sModel').textContent = state.file ? state.file.name : 'Chưa tải file';
    $('sModel').className = state.file ? '' : 'muted';
    $('sQty').textContent = state.qty;
    $('sSize').textContent = s ? `${fmt(s.x)} × ${fmt(s.y)} × ${fmt(s.z)} mm` : '—';
    $('sSize').className = s ? '' : 'muted';
    $('sTech').textContent = getTech().name;
    $('sMat').textContent = matName();
    $('sColor').innerHTML = `<i class="sum-dot" style="background:${state.colorHex}"></i>${state.colorName}`;
    $('sQuality').textContent = qualityText();
    $('sPost').textContent = postText();
    $('sPost').className = state.post[0] === 'none' && state.post.length === 1 ? 'muted' : '';
    $('sTol').textContent = tolText();

    // giá dự kiến
    $('pMat').textContent = v != null ? `${matName()} · ~${fmt(v * state.qty)} cm³` : matName();
    $('pTime').textContent = qualityText();
    $('pPost').textContent = postText();
    $('pQty').textContent = '× ' + state.qty;

    runChecks();
  }

  /* ============================================================
     10. VALIDATION + GỬI ĐƠN
     ============================================================ */
  function validate(){
    const errs = [];
    if(!state.file) errs.push('Vui lòng tải mô hình 3D trước khi tiếp tục.');
    if(!(state.qty >= 1)) errs.push('Số lượng phải lớn hơn hoặc bằng 1.');

    const s = finalSize();
    if(state.sizeMode === 'custom' && state.file){
      if(!(state.custom.x > 0 && state.custom.y > 0 && state.custom.z > 0))
        errs.push('Kích thước X, Y, Z phải lớn hơn 0.');
    }
    if(state.sizeMode === 'scale' && !(state.scale > 0)) errs.push('Tỷ lệ phóng phải lớn hơn 0.');
    if(!state.tech) errs.push('Vui lòng chọn công nghệ in.');
    if(!state.material) errs.push('Vui lòng chọn vật liệu.');
    if(!state.quality) errs.push('Vui lòng chọn chất lượng bề mặt.');
    if(state.tol === 'custom' && !(state.tolCustom > 0)) errs.push('Vui lòng nhập mức dung sai lớn hơn 0.');

    if(s){
      const b = getTech().build;
      if(s.x > b.x || s.y > b.y || s.z > b.z)
        errs.push(`Cấu hình hiện tại có thể không phù hợp với mô hình: kích thước vượt vùng in của ${getTech().name}. Chọn công nghệ khác, thu nhỏ mô hình, hoặc để xưởng kiểm tra.`);
    }
    return errs;
  }

  function submit(e){
    e.preventDefault();
    const errs = validate();
    const box = $('formError');
    if(errs.length){
      box.className = 'form-error show';
      box.innerHTML = `<strong>Cần bổ sung trước khi gửi yêu cầu:</strong><ul>${errs.map(x => `<li>${x}</li>`).join('')}</ul>`;
      box.scrollIntoView({behavior:'smooth', block:'center'});
      toastErr(errs[0]);
      return;
    }
    box.className = 'form-error';

    const s = finalSize();
    $('orderCode').textContent = '#3D-' + Math.floor(100000 + Math.random()*900000);
    $('confirmSummary').innerHTML = [
      ['Mô hình', state.file.name],
      ['Số lượng', state.qty],
      ['Kích thước', s ? `${fmt(s.x)} × ${fmt(s.y)} × ${fmt(s.z)} mm` : 'Xưởng xác nhận'],
      ['Công nghệ', getTech().name],
      ['Vật liệu', matName()],
      ['Màu', state.colorName],
      ['Chất lượng', qualityText()],
      ['Xử lý bề mặt', postText()],
      ['Dung sai', tolText()]
    ].map(([k,v]) => `<div class="sum-row"><span>${k}</span><b>${v}</b></div>`).join('');

    $('confirmModal').classList.add('show');
    toastOk('Đã gửi yêu cầu in');
  }

  function saveConfig(){
    const data = {...state, file: state.file ? state.file.name : null, refImage: null};
    try{ localStorage.setItem('printkraft:3d-config', JSON.stringify(data)); } catch(err){ /* bỏ qua */ }
    toastOk('Đã lưu cấu hình vào tài khoản của bạn');
  }

  /* ============================================================
     11. GẮN SỰ KIỆN
     ============================================================ */
  // Upload
  $('dropzone').onclick = () => $('fileInput').click();
  $('dropzone').onkeydown = e => { if(e.key === 'Enter' || e.key === ' '){ e.preventDefault(); $('fileInput').click(); } };
  $('fileInput').onchange = e => { if(e.target.files[0]) handleFile(e.target.files[0]); };
  ['dragenter','dragover'].forEach(ev => $('dropzone').addEventListener(ev, e => {
    e.preventDefault(); $('dropzone').classList.add('drag');
  }));
  ['dragleave','drop'].forEach(ev => $('dropzone').addEventListener(ev, e => {
    e.preventDefault(); $('dropzone').classList.remove('drag');
  }));
  $('dropzone').addEventListener('drop', e => { if(e.dataTransfer.files[0]) handleFile(e.dataTransfer.files[0]); });
  $('btnReplace').onclick = () => $('fileInput').click();
  $('btnRemove').onclick = () => { clearFile(); toast('Đã xoá mô hình'); };

  // Viewer tools
  $('btnSpin').onclick    = e => e.currentTarget.classList.toggle('on', Viewer.toggleSpin());
  $('btnZoomIn').onclick  = () => Viewer.zoom(0.85);
  $('btnZoomOut').onclick = () => Viewer.zoom(1.18);
  $('btnTop').onclick     = () => Viewer.top();
  $('btnReset').onclick   = () => Viewer.reset();

  // Số lượng
  const setQty = n => {
    state.qty = Math.max(1, Math.floor(n || 1));
    $('qtyInput').value = state.qty;
    update();
  };
  $('qtyMinus').onclick = () => setQty(state.qty - 1);
  $('qtyPlus').onclick  = () => setQty(state.qty + 1);
  $('qtyInput').oninput = e => { const v = parseInt(e.target.value, 10); if(v >= 1) { state.qty = v; update(); } };
  $('qtyInput').onblur  = e => setQty(parseInt(e.target.value, 10));

  // Kích thước
  $('sizeModes').querySelectorAll('.chip').forEach(c => {
    c.onclick = () => { state.sizeMode = c.dataset.mode; syncSizeMode(); update(); };
  });
  $('scaleInput').oninput = e => { state.scale = parseFloat(e.target.value) || 0; update(); };
  $('scalePresets').querySelectorAll('.chip').forEach(c => {
    c.onclick = () => { state.scale = +c.dataset.scale; $('scaleInput').value = state.scale; update(); };
  });
  $('lockRatio').onchange = e => state.lockRatio = e.target.checked;

  ['x','y','z'].forEach(axis => {
    const el = $('cus' + axis.toUpperCase());
    el.oninput = e => {
      const v = parseFloat(e.target.value);
      state.custom[axis] = v > 0 ? v : null;
      if(state.lockRatio && state.base && v > 0){
        const k = v / state.base[axis];
        ['x','y','z'].forEach(other => {
          if(other === axis) return;
          state.custom[other] = +(state.base[other] * k).toFixed(1);
          $('cus' + other.toUpperCase()).value = state.custom[other];
        });
      }
      update();
    };
  });

  // Màu
  $('colorPicker').oninput = e => setCustomColor(e.target.value);
  $('colorHex').oninput = e => {
    let v = e.target.value.trim();
    if(!v.startsWith('#')) v = '#' + v;
    if(/^#[0-9a-fA-F]{6}$/.test(v)){ $('colorPicker').value = v; setCustomColor(v); }
  };
  function setCustomColor(hex){
    state.colorId = 'custom'; state.colorHex = hex.toUpperCase(); state.colorName = 'Màu tuỳ chỉnh ' + hex.toUpperCase();
    $('colorHex').value = hex.toUpperCase();
    renderColors(); Viewer.setColor(hex); update();
  }
  $('refBtn').onclick = () => $('refInput').click();
  $('refInput').onchange = e => {
    const f = e.target.files[0];
    if(!f) return;
    state.refImage = f.name;
    const url = URL.createObjectURL(f);
    $('refThumb').outerHTML = `<img class="thumb" id="refThumb" src="${url}" alt="Hình mẫu màu">`;
    $('refTitle').textContent = f.name;
    $('refDesc').textContent = 'Xưởng sẽ tham khảo ảnh này khi pha màu.';
    $('refBtn').textContent = 'Đổi ảnh';
    toastOk('Đã thêm hình mẫu màu');
  };

  // Dung sai
  $('tolCustom').oninput = e => { state.tolCustom = parseFloat(e.target.value) || null; update(); };

  // Ghi chú
  $('notes').oninput = e => state.notes = e.target.value;

  // Gửi / lưu
  $('orderForm').onsubmit = submit;
  $('btnSave').onclick = saveConfig;

  // Modal
  $('confirmModal').querySelectorAll('[data-close]').forEach(b => b.onclick = () => $('confirmModal').classList.remove('show'));
  $('confirmModal').onclick = e => { if(e.target === $('confirmModal')) $('confirmModal').classList.remove('show'); };
  document.addEventListener('keydown', e => { if(e.key === 'Escape') $('confirmModal').classList.remove('show'); });

  /* ============================================================
     12. KHỞI TẠO
     ============================================================ */
  renderTech(); renderMaterials(); renderQuality(); renderColors(); renderPost(); renderTol();
  syncSizeMode(); update();

  if(!Viewer.available()){
    $('stageEmpty').querySelector('p').textContent = 'Không tải được thư viện 3D. Bạn vẫn đặt in được — nhập kích thước mong muốn ở mục “Kích thước sản phẩm”.';
  }
  </script>
</body>
</html>
