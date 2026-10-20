<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>PrintKraft — In theo yêu cầu</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root{
            --ink:#1B1B2F;--ink-soft:#4A4A6A;--cream:#FDF9F3;--surface:#FFF;
            --violet:#6C5CE7;--violet-soft:#A29BFE;--coral:#FF6B6B;--coral-deep:#EE5253;
            --amber:#FFB347;--teal:#00B894;--teal-soft:#55EFC4;--pink:#FD79A8;--sky:#48A9F8;
            --grad-primary:linear-gradient(135deg,#6C5CE7,#A29BFE);
            --grad-warm:linear-gradient(135deg,#FF6B6B,#FFB347);
            --grad-cool:linear-gradient(135deg,#00B894,#55EFC4);
            --grad-sky:linear-gradient(135deg,#48A9F8,#6C5CE7);
            --grad-pink:linear-gradient(135deg,#FD79A8,#A29BFE);
            --line:rgba(27,27,47,.10);--line-strong:rgba(27,27,47,.18);
            --shadow-xs:0 1px 3px rgba(27,27,47,.06);
            --shadow-sm:0 4px 14px rgba(27,27,47,.07);
            --shadow-md:0 12px 32px rgba(27,27,47,.11);
            --shadow-lg:0 24px 60px rgba(27,27,47,.18);
            --shadow-glow:0 12px 34px rgba(108,92,231,.32);
            --r-sm:10px;--r-md:16px;--r-lg:22px;--r-xl:28px;
        }
        *{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth}
        body{
            color:var(--ink);font-family:'IBM Plex Sans',sans-serif;line-height:1.55;
            background:
                    radial-gradient(1100px 620px at 8% -8%,rgba(108,92,231,.13),transparent 62%),
                    radial-gradient(880px 520px at 96% -4%,rgba(255,107,107,.13),transparent 58%),
                    radial-gradient(900px 640px at 50% 104%,rgba(0,184,148,.10),transparent 62%),
                    var(--cream);
            background-attachment:fixed;
        }
        h1,h2,h3,h4,h5,.display{font-family:'Space Grotesk',sans-serif;letter-spacing:-.02em;line-height:1.15}
        a{color:inherit;text-decoration:none}
        img,svg{display:block}
        button{font-family:inherit;cursor:pointer;border:none;background:none;color:inherit}
        input,select,textarea{font-family:inherit}

        /* ===== Utility bar ===== */
        .utility{
            background:linear-gradient(90deg,#1B1B2F,#2D2B55 50%,#1B1B2F);
            color:rgba(253,249,243,.82);font-size:12.5px;padding:9px 32px;
            display:flex;justify-content:space-between;flex-wrap:wrap;gap:8px;
        }
        .utility b{color:var(--amber);font-weight:600}

        /* ===== Header ===== */
        header{
            background:rgba(253,249,243,.88);
            backdrop-filter:blur(14px);-webkit-backdrop-filter:blur(14px);
            border-bottom:1px solid var(--line);
            padding:12px 32px;display:flex;align-items:center;gap:16px;
            position:sticky;top:0;z-index:50;
        }
        .logo{font-size:22px;font-weight:700;display:flex;align-items:center;gap:10px;white-space:nowrap;flex-shrink:0}
        .logo .mark{
            width:28px;height:28px;background:var(--grad-warm);
            display:inline-block;transform:rotate(45deg);border-radius:8px;
            box-shadow:0 6px 16px rgba(255,107,107,.4);
        }
        nav{
            display:flex;gap:4px;font-size:14px;font-weight:500;
            overflow-x:auto;scrollbar-width:none;-ms-overflow-style:none;
            flex:1;min-width:0;padding:2px;
        }
        nav::-webkit-scrollbar{display:none}
        nav a{
            padding:9px 14px;border-radius:999px;white-space:nowrap;
            color:var(--ink-soft);transition:.18s;flex-shrink:0;
        }
        nav a:hover{background:rgba(108,92,231,.10);color:var(--violet)}
        nav a.active{background:var(--grad-primary);color:#fff;box-shadow:0 6px 16px rgba(108,92,231,.30)}
        .search-wrap{
            flex:0 1 250px;display:flex;min-width:0;
            background:var(--surface);border:1.5px solid var(--line-strong);border-radius:999px;
            overflow:hidden;transition:.2s;box-shadow:var(--shadow-xs);
        }
        .search-wrap:focus-within{border-color:var(--violet);box-shadow:0 0 0 4px rgba(108,92,231,.14)}
        .search-wrap input{border:none;outline:none;background:transparent;padding:10px 18px;font-size:14px;flex:1;min-width:0}
        .search-wrap button{background:var(--grad-primary);color:#fff;padding:0 18px;font-weight:600;font-size:13.5px}
        .head-actions{display:flex;align-items:center;gap:14px;font-size:13px;font-weight:500;flex-shrink:0;margin-left:auto}
        .cart-btn{
            display:flex;align-items:center;gap:7px;background:var(--grad-warm);color:#fff;
            padding:10px 16px;border-radius:999px;font-weight:600;font-size:13.5px;
            box-shadow:0 8px 20px rgba(255,107,107,.32);transition:.18s;white-space:nowrap;
        }
        .cart-btn:hover{transform:translateY(-2px);box-shadow:0 12px 26px rgba(255,107,107,.42)}
        .badge{background:rgba(255,255,255,.28);border-radius:999px;padding:1px 8px;font-size:11.5px}
        .user-chip{
            display:flex;align-items:center;gap:9px;padding:6px 14px 6px 6px;
            background:var(--surface);border:1.5px solid var(--line-strong);border-radius:999px;
            font-weight:600;font-size:13px;transition:.18s;
        }
        .user-chip:hover{border-color:var(--violet);box-shadow:0 0 0 4px rgba(108,92,231,.12)}
        .avatar{
            width:28px;height:28px;border-radius:50%;background:var(--grad-primary);color:#fff;
            display:flex;align-items:center;justify-content:center;font-size:11.5px;font-weight:700;
        }
        .avatar.lg{width:56px;height:56px;font-size:19px}
        .avatar.coral{background:var(--grad-warm)}
        .avatar.teal{background:var(--grad-cool)}
        .avatar.pink{background:var(--grad-pink)}

        /* ===== Buttons ===== */
        .btn-primary{
            background:var(--grad-primary);color:#fff;padding:14px 26px;border-radius:var(--r-sm);
            font-weight:600;font-size:14.5px;display:inline-block;text-align:center;
            box-shadow:var(--shadow-glow);transition:.2s;
        }
        .btn-primary:hover{transform:translateY(-2px);box-shadow:0 18px 40px rgba(108,92,231,.42)}
        .btn-secondary{
            border:1.5px solid var(--line-strong);padding:14px 26px;border-radius:var(--r-sm);
            font-weight:600;font-size:14.5px;background:var(--surface);color:var(--ink);
            display:inline-block;text-align:center;transition:.2s;
        }
        .btn-secondary:hover{border-color:var(--violet);color:var(--violet);transform:translateY(-2px)}
        .btn-warm{background:var(--grad-warm);color:#fff;box-shadow:0 12px 30px rgba(255,107,107,.34)}
        .btn-teal{background:var(--grad-cool);color:#08352b;box-shadow:0 12px 30px rgba(0,184,148,.3)}

        /* ===== Page animation ===== */
        main{min-height:62vh}
        main>.page{animation:pageIn .32s cubic-bezier(.4,0,.2,1)}
        @keyframes pageIn{from{opacity:0;transform:translateY(10px)}to{opacity:1;transform:translateY(0)}}

        /* ===== Hero ===== */
        .hero{
            display:grid;grid-template-columns:1.05fr .95fr;gap:44px;
            padding:70px 32px 60px;align-items:center;max-width:1280px;margin:0 auto;
        }
        .hero-eyebrow{
            display:inline-flex;align-items:center;gap:8px;
            background:linear-gradient(135deg,#FFF3D6,#FFE0C2);color:#8A5A00;
            padding:7px 16px;border-radius:999px;font-size:12.5px;font-weight:600;
            margin-bottom:24px;border:1px solid rgba(255,179,71,.5);
        }
        .hero h1{font-size:58px;font-weight:700;line-height:1.02;max-width:11ch}
        .hero h1 .accent{
            background:var(--grad-warm);-webkit-background-clip:text;background-clip:text;
            -webkit-text-fill-color:transparent;color:transparent;
        }
        .hero p{margin-top:22px;font-size:16.5px;max-width:46ch;color:var(--ink-soft)}
        .hero-cta{display:flex;gap:14px;margin-top:32px;flex-wrap:wrap}
        .hero-stats{display:flex;gap:34px;margin-top:44px;flex-wrap:wrap}
        .hero-stats div strong{
            display:block;font-family:'Space Grotesk';font-size:26px;
            background:var(--grad-primary);-webkit-background-clip:text;background-clip:text;
            -webkit-text-fill-color:transparent;
        }
        .hero-stats div span{font-size:12.5px;color:var(--ink-soft)}
        .hero-visual{position:relative;height:440px}
        .blob{position:absolute;border-radius:50%;filter:blur(60px);opacity:.55}
        .blob.b1{width:280px;height:280px;background:#A29BFE;top:-20px;left:20px}
        .blob.b2{width:240px;height:240px;background:#FFB347;bottom:0;right:20px}
        .blob.b3{width:200px;height:200px;background:#55EFC4;bottom:60px;left:120px}
        .mockup{
            position:absolute;border-radius:var(--r-lg);box-shadow:var(--shadow-lg);
            display:flex;align-items:center;justify-content:center;font-family:'Space Grotesk';
            font-weight:600;color:#fff;text-align:center;padding:16px;font-size:13.5px;
            letter-spacing:.02em;transition:transform .3s ease;
        }
        .mockup:hover{transform:translateY(-8px) rotate(0deg) !important}
        .mockup.m1{width:240px;height:300px;background:var(--grad-primary);top:20px;left:30px;z-index:3}
        .mockup.m2{width:200px;height:200px;background:var(--grad-warm);top:180px;left:250px;z-index:4;border-radius:50%}
        .mockup.m3{width:170px;height:230px;background:var(--grad-cool);color:#063a2e;top:0;right:10px;transform:rotate(7deg);z-index:2}
        .mockup.m4{width:130px;height:130px;background:var(--grad-pink);bottom:10px;right:120px;z-index:5;border-radius:24px;font-size:11.5px}

        /* ===== Category strip ===== */
        .cat-strip{border-top:1px solid var(--line);border-bottom:1px solid var(--line);background:rgba(255,255,255,.7);backdrop-filter:blur(10px)}
        .cat-strip .inner{max-width:1280px;margin:0 auto;display:flex;overflow-x:auto;padding:0 32px;scrollbar-width:none}
        .cat-strip .inner::-webkit-scrollbar{display:none}
        .cat-strip a{padding:16px 22px;font-size:14px;font-weight:500;white-space:nowrap;border-right:1px solid var(--line);color:var(--ink-soft);transition:.18s;cursor:pointer}
        .cat-strip a:hover{background:linear-gradient(180deg,transparent,rgba(108,92,231,.10));color:var(--violet)}

        /* ===== Section ===== */
        .section{max-width:1280px;margin:0 auto;padding:66px 32px}
        .section-head{display:flex;justify-content:space-between;align-items:flex-end;margin-bottom:32px;gap:20px;flex-wrap:wrap}
        .section-head h2{font-size:32px}
        .section-head p{color:var(--ink-soft);font-size:14px;margin-top:8px}
        .section-head .link{font-size:14px;font-weight:600;color:var(--violet);border-bottom:2px solid var(--violet-soft);padding-bottom:2px;cursor:pointer}
        .eyebrow-line{
            display:inline-block;font-size:12px;font-weight:700;letter-spacing:.12em;
            text-transform:uppercase;color:var(--violet);margin-bottom:10px;
        }

        /* ===== How it works ===== */
        .how{background:linear-gradient(140deg,#1B1B2F,#2A2352 55%,#3A2C6E);color:var(--cream);position:relative;overflow:hidden}
        .how:before{content:"";position:absolute;width:420px;height:420px;border-radius:50%;background:rgba(108,92,231,.35);filter:blur(90px);top:-140px;left:-80px}
        .how:after{content:"";position:absolute;width:360px;height:360px;border-radius:50%;background:rgba(255,107,107,.22);filter:blur(90px);bottom:-140px;right:-60px}
        .how .section{position:relative;z-index:1}
        .how .section-head h2{color:var(--cream)}
        .how .section-head p{color:rgba(253,249,243,.65)}
        .steps{display:grid;grid-template-columns:repeat(3,1fr);gap:24px}
        .step{
            border:1px solid rgba(253,249,243,.16);border-radius:var(--r-md);padding:28px;
            background:rgba(255,255,255,.05);backdrop-filter:blur(8px);transition:.22s;
        }
        .step:hover{background:rgba(255,255,255,.09);transform:translateY(-4px);border-color:rgba(162,155,254,.5)}
        .step .num{
            font-family:'Space Grotesk';font-weight:700;font-size:15px;width:38px;height:38px;border-radius:12px;
            background:var(--grad-warm);color:#fff;display:flex;align-items:center;justify-content:center;
            margin-bottom:18px;box-shadow:0 8px 20px rgba(255,107,107,.4);
        }
        .step h4{font-size:17px;margin-bottom:8px}
        .step p{font-size:13.5px;color:rgba(253,249,243,.72)}

        /* ===== CTA band ===== */
        .cta-band{background:var(--grad-primary);color:#fff;position:relative;overflow:hidden}
        .cta-band:before{content:"";position:absolute;width:400px;height:400px;border-radius:50%;background:rgba(255,255,255,.14);filter:blur(80px);top:-120px;right:10%}
        .cta-band .section{display:flex;justify-content:space-between;align-items:center;gap:30px;flex-wrap:wrap;position:relative}
        .cta-band h2{font-size:34px;max-width:18ch}
        .cta-band p{opacity:.9;margin-top:10px;font-size:15px}
        .cta-band .btn-primary{background:#fff;color:var(--violet);box-shadow:0 14px 34px rgba(0,0,0,.2)}
        .cta-band .btn-primary:hover{color:var(--coral-deep)}
        .newsletter{display:flex;gap:10px;margin-top:20px;flex-wrap:wrap}
        .newsletter input{
            border:1.5px solid rgba(255,255,255,.5);background:rgba(255,255,255,.16);color:#fff;
            border-radius:var(--r-sm);padding:14px 18px;font-size:14px;outline:none;min-width:250px;transition:.18s;
        }
        .newsletter input::placeholder{color:rgba(255,255,255,.7)}
        .newsletter input:focus{background:rgba(255,255,255,.24);border-color:#fff}

        /* ===== Footer ===== */
        footer{border-top:1px solid var(--line);padding:56px 32px 26px;background:rgba(255,255,255,.6)}
        .foot-inner{max-width:1280px;margin:0 auto;display:grid;grid-template-columns:1.4fr repeat(3,1fr);gap:34px}
        .foot-inner h5{font-family:'Space Grotesk';font-size:12.5px;text-transform:uppercase;letter-spacing:.1em;margin-bottom:16px;color:var(--ink)}
        .foot-inner ul{list-style:none}
        .foot-inner li{padding:6px 0;font-size:13.5px;color:var(--ink-soft);transition:.16s;cursor:pointer}
        .foot-inner li:hover{color:var(--violet);transform:translateX(3px)}
        .foot-bottom{max-width:1280px;margin:34px auto 0;padding-top:22px;border-top:1px solid var(--line);display:flex;justify-content:space-between;font-size:12.5px;color:var(--ink-soft);flex-wrap:wrap;gap:10px}

        /* ===== Overlay / Drawer / Modal ===== */
        .overlay{position:fixed;inset:0;background:rgba(27,27,47,.5);backdrop-filter:blur(3px);opacity:0;pointer-events:none;transition:.25s;z-index:90}
        .overlay.show{opacity:1;pointer-events:auto}
        .drawer{
            position:fixed;top:0;right:0;height:100vh;width:420px;max-width:94vw;background:var(--cream);
            z-index:100;transform:translateX(102%);transition:.3s cubic-bezier(.4,0,.2,1);
            display:flex;flex-direction:column;box-shadow:-20px 0 60px rgba(27,27,47,.2);
        }
        .drawer.show{transform:translateX(0)}
        .drawer-head{padding:22px 24px;border-bottom:1px solid var(--line);display:flex;justify-content:space-between;align-items:center}
        .drawer-head h3{font-size:19px}
        .drawer-head button{font-size:22px;color:var(--ink-soft);width:34px;height:34px;border-radius:50%;transition:.18s}
        .drawer-head button:hover{background:var(--line);color:var(--ink)}
        .drawer-body{padding:20px 24px;overflow-y:auto;flex:1}
        .cart-item{display:flex;gap:14px;padding:16px 0;border-bottom:1px solid var(--line)}
        .cart-item .thumb{width:64px;height:64px;border-radius:12px;flex-shrink:0;box-shadow:var(--shadow-xs)}
        .cart-item .info{flex:1;font-size:13.5px}
        .cart-item .info strong{display:block;font-weight:600;margin-bottom:2px}
        .cart-item .info span{font-size:12px;color:var(--ink-soft)}
        .cart-item .qty{display:flex;align-items:center;gap:9px;margin-top:8px}
        .cart-item .qty button{width:24px;height:24px;border:1.5px solid var(--line-strong);border-radius:7px;background:#fff;font-weight:600;transition:.16s}
        .cart-item .qty button:hover{background:var(--violet);color:#fff;border-color:var(--violet)}
        .drawer-foot{padding:22px 24px;border-top:1px solid var(--line);background:#fff}
        .drawer-foot .row{display:flex;justify-content:space-between;font-size:14px;margin-bottom:9px;color:var(--ink-soft)}
        .drawer-foot .row.total{font-weight:700;font-size:19px;font-family:'Space Grotesk';margin:14px 0 18px;color:var(--ink);border-top:1px dashed var(--line);padding-top:14px}

        .modal{position:fixed;inset:0;display:flex;align-items:center;justify-content:center;z-index:110;opacity:0;pointer-events:none;transition:.22s;padding:20px;overflow-y:auto}
        .modal.show{opacity:1;pointer-events:auto}
        .modal-box{
            background:var(--cream);border-radius:var(--r-xl);padding:34px;width:460px;max-width:100%;
            position:relative;box-shadow:var(--shadow-lg);transform:translateY(14px) scale(.98);transition:.25s;
            max-height:92vh;overflow-y:auto;margin:auto;
        }
        .modal.show .modal-box{transform:translateY(0) scale(1)}
        .modal-box.wide{width:620px}
        .modal-box h3{font-size:23px;margin-bottom:6px}
        .modal-box .sub{font-size:13.5px;color:var(--ink-soft);margin-bottom:24px}
        .modal-close{position:absolute;top:18px;right:20px;font-size:20px;width:36px;height:36px;border-radius:50%;color:var(--ink-soft);transition:.18s}
        .modal-close:hover{background:var(--line);color:var(--ink)}
        .social-row{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin:16px 0}
        .social-row button{border:1.5px solid var(--line-strong);background:#fff;border-radius:var(--r-sm);padding:12px;font-size:13.5px;font-weight:600;transition:.18s}
        .social-row button:hover{border-color:var(--violet);color:var(--violet)}
        .divider{display:flex;align-items:center;gap:12px;color:var(--ink-soft);font-size:12px;margin:16px 0}
        .divider:before,.divider:after{content:"";flex:1;height:1px;background:var(--line)}
        .form-error{background:#FFECEC;color:#C0392B;border-radius:9px;padding:10px 14px;font-size:13px;margin-bottom:14px;display:none;font-weight:500}
        .form-error.show{display:block}

        .field{margin-bottom:14px}
        .field label{display:block;font-size:12.5px;font-weight:600;margin-bottom:6px;color:var(--ink-soft)}
        .field input,.field select,.field textarea{
            width:100%;border:1.5px solid var(--line);border-radius:var(--r-sm);padding:12px 14px;
            font-size:14px;background:#FBF9FF;outline:none;transition:.18s;color:var(--ink);
        }
        .field input:focus,.field select:focus,.field textarea:focus{border-color:var(--violet);background:#fff;box-shadow:0 0 0 4px rgba(108,92,231,.12)}
        .field-row{display:grid;grid-template-columns:1fr 1fr;gap:14px}

        .demo-hint{
            display:inline-flex;gap:8px;align-items:center;background:#FFF4E0;color:#8A5A00;
            border:1px dashed rgba(255,179,71,.7);border-radius:999px;padding:8px 16px;
            font-size:13px;font-weight:600;margin-bottom:18px;
        }

        /* ===== Toast ===== */
        .toast{
            position:fixed;bottom:28px;left:50%;transform:translate(-50%,100px);
            background:var(--ink);color:var(--cream);padding:14px 24px;border-radius:999px;
            font-size:13.5px;font-weight:500;z-index:300;transition:.3s cubic-bezier(.4,0,.2,1);
            opacity:0;box-shadow:var(--shadow-lg);max-width:90vw;text-align:center;
        }
        .toast.show{transform:translate(-50%,0);opacity:1}
        .toast.ok{background:linear-gradient(135deg,#00B894,#0A7A5E)}
        .toast.err{background:linear-gradient(135deg,#FF6B6B,#C0392B)}

        /* ===== Responsive ===== */
        @media (max-width:1240px){.search-wrap{display:none}}
        @media (max-width:980px){
            header{padding:10px 18px;gap:12px;flex-wrap:wrap}
            nav{order:3;flex-basis:100%;width:100%}
            .head-actions{margin-left:auto}
            .hero{grid-template-columns:1fr}
            .hero-visual{height:360px}
            .hero h1{font-size:42px}
            .steps{grid-template-columns:1fr}
            .foot-inner{grid-template-columns:1fr 1fr}
            .utility{padding:8px 20px;font-size:11.5px}
            .section{padding:44px 20px}
            .hero{padding:40px 20px}
        }
        @media (max-width:640px){
            .foot-inner{grid-template-columns:1fr}
            .hero h1{font-size:34px}
            .hero-stats{gap:22px}
            .modal-box{padding:24px}
            .field-row{grid-template-columns:1fr}
            nav a{padding:8px 12px;font-size:13.5px}
        }
    </style>
</head>
<body data-page="home">
<jsp:include page="/WEB-INF/views/common/session-info.jsp" />

<div id="site-header"></div>

<main>
    <div class="page">
        <section class="hero">
            <div>
                <div class="hero-eyebrow">⚡ Giao mẫu thử trong 48 giờ</div>
                <h1>In ấn của bạn, <span class="accent">theo cách của bạn.</span></h1>
                <p>Tải thiết kế lên, chọn chất liệu và số lượng — xưởng in đối tác của chúng tôi lo phần còn lại. Từ 1 chiếc áo đến 10.000 sản phẩm.</p>
                <div class="hero-cta">
                    <a class="btn-primary" href="dat_in_3d.jsp">Bắt đầu thiết kế</a>
                    <a class="btn-secondary" href="dat_in_3d.jsp">Xem sản phẩm mẫu</a>
                </div>
                <div class="hero-stats">
                    <div><strong>4.9/5</strong><span>Đánh giá khách hàng</span></div>
                    <div><strong>120+</strong><span>Xưởng in đối tác</span></div>
                    <div><strong>48h</strong><span>Thời gian sản xuất TB</span></div>
                    <div><strong>63</strong><span>Tỉnh thành giao hàng</span></div>
                </div>
            </div>
            <div class="hero-visual">
                <div class="blob b1"></div><div class="blob b2"></div><div class="blob b3"></div>
                <div class="mockup m3">POSTER<br>A2 GLOSS</div>
                <div class="mockup m1">ÁO THUN<br>COTTON 100%</div>
                <div class="mockup m2">CỐC SỨ<br>350ML</div>
                <div class="mockup m4">STICKER<br>DECAL</div>
            </div>
        </section>

        <div class="cat-strip">
            <div class="inner">
                <a href="dat_in_3d.jsp">Áo thun &amp; Hoodie</a>
                <a href="dat_in_3d.jsp">Cốc &amp; Bình giữ nhiệt</a>
                <a href="dat_in_3d.jsp">Poster &amp; Canvas</a>
                <a href="dat_in_3d.jsp">Bao bì &amp; Nhãn dán</a>
                <a href="dat_in_3d.jsp">Namecard &amp; Văn phòng phẩm</a>
                <a href="trang_chu.jsp">Quà tặng doanh nghiệp</a>
                <a href="dat_in_3d.jsp">Túi vải &amp; Phụ kiện</a>
                <a href="dat_in_3d.jsp">Đồng phục team</a>
            </div>
        </div>

        <section class="how">
            <div class="section">
                <div class="section-head">
                    <div>
                        <div class="eyebrow-line" style="color:var(--violet-soft);">Quy trình</div>
                        <h2>Đặt hàng chỉ với 3 bước</h2>
                        <p>Không cần kinh nghiệm thiết kế — công cụ của chúng tôi lo phần khó</p>
                    </div>
                </div>
                <div class="steps">
                    <div class="step">
                        <div class="num">1</div>
                        <h4>Tải thiết kế lên</h4>
                        <p>Dùng công cụ kéo-thả hoặc tải file có sẵn. Xem trước mockup ngay lập tức.</p>
                    </div>
                    <div class="step">
                        <div class="num">2</div>
                        <h4>Chọn xưởng in phù hợp</h4>
                        <p>Hệ thống gợi ý xưởng in gần bạn nhất, đánh giá cao và đúng thời hạn.</p>
                    </div>
                    <div class="step">
                        <div class="num">3</div>
                        <h4>Theo dõi &amp; nhận hàng</h4>
                        <p>Cập nhật trạng thái theo thời gian thực, từ sản xuất đến giao hàng.</p>
                    </div>
                </div>
            </div>
        </section>

        <section class="cta-band">
            <div class="section">
                <div>
                    <h2>Sẵn sàng in đơn đầu tiên?</h2>
                    <p>Đăng ký nhận voucher 100.000đ cho đơn từ 500.000đ và bảng giá số lượng lớn.</p>
                    <div class="newsletter">
                        <input type="email" placeholder="Email của bạn">
                        <button class="btn-primary" onclick="toastOk('Đã đăng ký — kiểm tra email để nhận voucher')">Nhận voucher</button>
                    </div>
                </div>
                <div style="text-align:right;">
                    <div style="font-family:'Space Grotesk';font-size:52px;font-weight:700;line-height:1;">100K</div>
                    <div style="opacity:.9;font-size:14px;margin-top:6px;">voucher cho đơn đầu tiên</div>
                </div>
            </div>
        </section>
    </div>
</main>

<div id="site-footer"></div>

<script>
    /* ============================================================
       PRINTKRAFT — SHARED SCRIPT (nhúng trực tiếp)
       ============================================================ */

    /* ---------- DATA ---------- */
    var SUPPLIERS=[
        {name:'Sài Gòn Print',city:'TP. Hồ Chí Minh',rating:4.9,jobs:1240,min:'24h',tags:['DTG','DTF','In lụa'],grad:'linear-gradient(135deg,#6C5CE7,#A29BFE)',initials:'SP'},
        {name:'Hà Nội In Nhanh',city:'Hà Nội',rating:4.8,jobs:980,min:'12h',tags:['In lụa','DTF'],grad:'linear-gradient(135deg,#FF6B6B,#FFB347)',initials:'HN'},
        {name:'Đà Nẵng Xpress',city:'Đà Nẵng',rating:4.7,jobs:640,min:'24h',tags:['Sublimation','DTG'],grad:'linear-gradient(135deg,#00B894,#55EFC4)',initials:'ĐN'},
        {name:'Cần Thơ Print Hub',city:'Cần Thơ',rating:4.6,jobs:410,min:'36h',tags:['In lụa','Sublimation'],grad:'linear-gradient(135deg,#48A9F8,#6C5CE7)',initials:'CT'},
        {name:'Laser Art Studio',city:'TP. Hồ Chí Minh',rating:4.9,jobs:520,min:'48h',tags:['Khắc laser','DTF'],grad:'linear-gradient(135deg,#FD79A8,#A29BFE)',initials:'LA'},
        {name:'Hải Phòng Canvas',city:'Hải Phòng',rating:4.5,jobs:300,min:'48h',tags:['DTG','Sublimation'],grad:'linear-gradient(135deg,#FFB347,#FF6B6B)',initials:'HP'}
    ];

    var ORDERS=[
        {id:'PK-08231',product:'Áo thun Oversize Cotton',detail:'DTG · Size L · Màu Navy · 24 chiếc',total:'3.096.000đ',status:'producing',statusLabel:'Đang sản xuất',supplier:'Sài Gòn Print',eta:'17/09/2026',progress:2},
        {id:'PK-08228',product:'Namecard giấy mỹ thuật 300gsm',detail:'In offset · 500 tấm · 2 mặt',total:'600.000đ',status:'pending',statusLabel:'Chờ xác nhận',supplier:'Hà Nội In Nhanh',eta:'20/09/2026',progress:1},
        {id:'PK-08204',product:'Cốc sứ trắng 2 mặt',detail:'Sublimation · 30 chiếc · 350ml',total:'1.950.000đ',status:'shipping',statusLabel:'Đang giao',supplier:'Đà Nẵng Xpress',eta:'16/09/2026',progress:3},
        {id:'PK-08180',product:'Túi vải canvas dày',detail:'In lụa · 80 chiếc · Màu kem',total:'3.360.000đ',status:'delivered',statusLabel:'Đã giao',supplier:'Sài Gòn Print',eta:'Đã giao 12/09/2026',progress:4}
    ];

    var NAV_ITEMS=[
        {id:'home',label:'Trang chủ',href:'trang_chu.jsp'},
        {id:'san-pham',label:'Sản phẩm',href:'san_pham.jsp'},
        {id:'studio',label:'Tự thiết kế',href:'dat_in_3d.jsp'},
        {id:'doanh-nghiep',label:'Doanh nghiệp',href:'trang_chu.jsp'},
        {id:'nhacungcap',label:'Nhà cung cấp',href:'tim-kiem-nha-cung-cap.jsp'},
        {id:'donhang',label:'Đơn hàng',href:'don_hang_cua_toi_3d.jsp'},
        {id:'danhgia',label:'Đánh giá',href:'danh-gia.jsp'},
        {id:'faq',label:'Hỗ trợ',href:'lien-he.jsp'}
    ];

    /* ---------- TOAST ---------- */
    var toastTimer;
    function toast(msg,type){
        var t=document.getElementById('toast');if(!t)return;
        t.textContent=msg;
        t.className='toast show'+(type?' '+type:'');
        clearTimeout(toastTimer);
        toastTimer=setTimeout(function(){t.classList.remove('show')},2400);
    }
    function toastOk(m){toast(m,'ok')}
    function toastErr(m){toast(m,'err')}

    /* ---------- STORAGE ---------- */
    var store={
        get:function(k,d){try{var v=localStorage.getItem('pk_'+k);return v===null?d:JSON.parse(v)}catch(e){return d}},
        set:function(k,v){try{localStorage.setItem('pk_'+k,JSON.stringify(v))}catch(e){}}
    };

    /* ---------- HEADER ---------- */
    function renderHeader(active){
        var el=document.getElementById('site-header');if(!el)return;
        el.innerHTML='<div class="utility"><span>🚚 Miễn phí thiết kế mockup cho đơn từ 20 sản phẩm — <b>Voucher 100K</b> cho đơn đầu tiên</span><span>Hỗ trợ: <b>1900 6868</b> · <a href="don_hang_cua_toi_3d.jsp">Theo dõi đơn hàng</a>'+(isLoggedIn()?'':' · <a href="'+PK.ctx+'/login">Đăng nhập</a>')+'</span></div>'+
            '<header><a href="trang_chu.jsp" class="logo"><span class="mark"></span> PrintKraft</a><nav id="mainNav">'+
            NAV_ITEMS.map(function(i){return '<a href="'+i.href+'" class="'+(i.id===active?'active':'')+'">'+i.label+'</a>'}).join('')+
            '</nav><div class="search-wrap"><input type="text" id="globalSearch" placeholder="Tìm áo thun, cốc sứ, poster..."><button onclick="doGlobalSearch()">Tìm</button></div>'+
            '<div class="head-actions"><div id="authArea"></div><button class="cart-btn" onclick="openCart()">🛒 Giỏ hàng <span class="badge" id="cartBadge">0</span></button></div></header>';
    }
    function doGlobalSearch(){
        var i=document.getElementById('globalSearch');
        var q=i?i.value.trim():'';
        if(!q){toastErr('Nhập từ khoá để tìm kiếm');return}
        location.href='tim-kiem-nha-cung-cap.jsp?q='+encodeURIComponent(q);
    }

    /* ---------- FOOTER ---------- */
    function renderFooter(){
        var el=document.getElementById('site-footer');if(!el)return;
        el.innerHTML='<footer><div class="foot-inner">'+
            '<div><div class="logo" style="margin-bottom:16px;"><span class="mark"></span> PrintKraft</div><p style="font-size:13.5px;color:var(--ink-soft);max-width:34ch;">Nền tảng in theo yêu cầu kết nối khách hàng với hơn 120 xưởng in đối tác trên toàn quốc.</p><div style="display:flex;gap:10px;margin-top:18px;"><span class="chip" style="font-size:12px;padding:7px 14px;">Facebook</span><span class="chip" style="font-size:12px;padding:7px 14px;">Instagram</span><span class="chip" style="font-size:12px;padding:7px 14px;">Zalo</span></div></div>'+
            '<div><h5>Sản phẩm</h5><ul><li onclick="location.href=\'dat_in_3d.jsp\'">Áo thun &amp; Hoodie</li><li onclick="location.href=\'dat_in_3d.jsp\'">Cốc &amp; Bình giữ nhiệt</li><li onclick="location.href=\'dat_in_3d.jsp\'">Poster &amp; Canvas</li><li onclick="location.href=\'dat_in_3d.jsp\'">Bao bì &amp; Nhãn dán</li><li onclick="location.href=\'trang_chu.jsp\'">Quà tặng doanh nghiệp</li></ul></div>'+
            '<div><h5>Hỗ trợ</h5><ul><li onclick="location.href=\'lien-he.jsp\'">Trung tâm trợ giúp</li><li onclick="location.href=\'don_hang_cua_toi_3d.jsp\'">Theo dõi đơn hàng</li><li onclick="location.href=\'lien-he.jsp\'">Chính sách đổi trả</li><li onclick="location.href=\'lien-he.jsp\'">Chính sách bảo mật</li><li onclick="location.href=\'lien-he.jsp\'">Điều khoản sử dụng</li></ul></div>'+
            '<div><h5>Liên hệ</h5><ul><li>Hotline: 1900 6868</li><li>Email: hi@printkraft.vn</li><li>Văn phòng: 128 Nguyễn Đình Chiểu, Q.3, TP.HCM</li><li>Giờ làm việc: 8:00 – 21:00</li></ul></div>'+
            '</div><div class="foot-bottom"><span>© 2026 PrintKraft. Nền tảng in theo yêu cầu.</span><span>Điều khoản · Bảo mật · Hỗ trợ khách hàng</span></div></footer>';
    }

    /* ---------- AUTH (đăng nhập thật qua session phía server) ---------- */
    /* Dữ liệu lấy từ <div id="pk-session"> do WEB-INF/views/common/session-info.jsp in ra */
    var PK=(function(){
        var el=document.getElementById('pk-session'),d=el?el.dataset:{};
        return {ctx:d.ctx||'',csrf:d.csrf||'',loggedIn:d.loggedIn==='true',name:d.name||'',role:d.role||''};
    })();
    function isLoggedIn(){return PK.loggedIn}
    function escHtml(s){return String(s).replace(/[&<>"']/g,function(c){return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]})}
    function nameParts(n){return String(n).trim().split(/\s+/).filter(Boolean).slice(-2)}
    function initialsOf(n){return nameParts(n).map(function(w){return w.charAt(0)}).join('').toUpperCase()||'U'}
    function shortName(n){return nameParts(n).join(' ')||'Tài khoản'}

    function renderAuthArea(){
        var area=document.getElementById('authArea');if(!area)return;
        if(isLoggedIn()){
            area.innerHTML='<div style="display:flex;align-items:center;gap:8px;">'+
                '<button class="user-chip" onclick="location.href=\''+PK.ctx+'/profile\'"><span class="avatar">'+escHtml(initialsOf(PK.name))+'</span> '+escHtml(shortName(PK.name))+'</button>'+
                '<button onclick="logout()" style="font-size:12.5px;font-weight:600;color:var(--ink-soft);">Thoát</button></div>';
        } else {
            area.innerHTML='<a href="'+PK.ctx+'/login" style="font-weight:600;">Tài khoản</a>';
        }
    }

    /* Đăng xuất: POST + CSRF token tới LogoutServlet */
    function logout(){
        var f=document.createElement('form');f.method='post';f.action=PK.ctx+'/logout';
        var t=document.createElement('input');t.type='hidden';t.name='csrfToken';t.value=PK.csrf;
        f.appendChild(t);document.body.appendChild(f);f.submit();
    }
    /* Giữ tên hàm cũ để các nút "Đăng nhập" còn sót ở trang khác vẫn chạy: chuyển sang trang đăng nhập thật */
    function openLogin(){location.href=PK.ctx+'/login'}

    /* ---------- MODAL / DRAWER ---------- */
    function openCart(){
        closeAll();
        document.getElementById('cartDrawer').classList.add('show');
        document.getElementById('overlay').classList.add('show');
        document.body.style.overflow='hidden';
    }
    function openModalById(id){
        var el=document.getElementById(id);if(!el)return;
        closeAll();
        el.classList.add('show');
        document.getElementById('overlay').classList.add('show');
        document.body.style.overflow='hidden';
    }
    function closeAll(){
        document.querySelectorAll('.drawer, .modal').forEach(function(el){el.classList.remove('show')});
        var ov=document.getElementById('overlay');
        if(ov)ov.classList.remove('show');
        document.body.style.overflow='';
    }
    document.addEventListener('keydown',function(e){if(e.key==='Escape')closeAll()});

    /* ---------- CART ---------- */
    function getCartCount(){return store.get('cartCount',3)}
    function setCartCount(n){
        store.set('cartCount',n);
        var b=document.getElementById('cartBadge');if(b)b.textContent=n;
    }
    function addCart(name,price){
        setCartCount(getCartCount()+1);
        toastOk('Đã thêm "'+name+'" vào giỏ hàng');
    }

    /* ---------- SUPPLIERS ---------- */
    var supplierFilter='all';
    function setSupplierFilter(btn,f){
        supplierFilter=f;
        btn.parentElement.querySelectorAll('.chip').forEach(function(c){c.classList.remove('active')});
        btn.classList.add('active');
        renderSuppliers();
    }
    function renderSuppliers(){
        var grid=document.getElementById('supplierGrid');if(!grid)return;
        var input=document.getElementById('supplierSearch');
        var q=(input?input.value:'').toLowerCase().trim();
        var list=SUPPLIERS.filter(function(s){
            var mf=supplierFilter==='all'||s.tags.indexOf(supplierFilter)>=0;
            var mq=!q||s.name.toLowerCase().indexOf(q)>=0||s.city.toLowerCase().indexOf(q)>=0||s.tags.some(function(t){return t.toLowerCase().indexOf(q)>=0});
            return mf&&mq;
        });
        if(list.length===0){
            grid.innerHTML='<div class="empty-state"><div style="font-size:34px;margin-bottom:10px;">🔍</div><strong>Không tìm thấy nhà cung cấp phù hợp</strong><p style="margin-top:6px;font-size:13.5px;">Thử từ khoá khác như "Hà Nội", "DTG" hoặc "in lụa"</p></div>';
            return;
        }
        grid.innerHTML=list.map(function(s){
            return '<div class="supplier"><div class="supplier-top"><div class="supplier-logo" style="background:'+s.grad+'">'+s.initials+'</div><div><h4>'+s.name+'</h4><div class="loc">📍 '+s.city+'</div></div></div><div class="supplier-meta">'+
                s.tags.map(function(t){return '<span class="pill">'+t+'</span>'}).join('')+
                '<span class="pill teal">⚡ '+s.min+'</span></div><div class="supplier-stat"><span>Đánh giá <b style="color:var(--amber)">★ '+s.rating+'</b></span><span><b>'+s.jobs.toLocaleString('vi-VN')+'</b> đơn hoàn tất</span></div><div class="supplier-actions"><button class="btn-outline" onclick="openSupplierReview(\''+s.name+'\')">★ Đánh giá</button><button class="btn-fill" onclick="openContact(\''+s.name+'\')">Liên hệ</button></div></div>';
        }).join('');
    }
    function openContact(name){
        document.getElementById('contactSupplier').value=name;
        document.getElementById('contactSub').textContent='Gửi yêu cầu trực tiếp tới '+name;
        document.getElementById('contactMsg').value='';
        openModalById('contactModal');
    }
    function submitContact(){
        var name=document.getElementById('contactSupplier').value;
        closeAll();
        toastOk('Đã gửi tin nhắn tới '+name+' — phản hồi trong 2 giờ');
    }
    var currentSupplierForReview='';
    function openSupplierReview(name){
        currentSupplierForReview=name;
        document.getElementById('supRevSub').textContent='Đánh giá xưởng: '+name;
        document.querySelectorAll('#supplierReviewModal .star-input').forEach(function(si){
            si.dataset.value=0;
            si.querySelectorAll('button').forEach(function(b){b.classList.remove('on')});
        });
        document.getElementById('supRevText').value='';
        openModalById('supplierReviewModal');
    }
    function submitSupplierReview(){
        var groups=document.querySelectorAll('#supplierReviewModal .star-input');
        var sum=0,count=0;
        groups.forEach(function(g){
            var v=parseInt(g.dataset.value||0,10);
            if(v>0){sum+=v;count++}
        });
        if(count<groups.length){toastErr('Vui lòng chấm điểm đầy đủ 3 tiêu chí');return}
        var avg=(sum/groups.length).toFixed(1);
        closeAll();
        toastOk('Đã gửi đánh giá '+avg+'★ cho '+currentSupplierForReview);
    }

    /* ---------- STAR INPUT ---------- */
    document.addEventListener('click',function(e){
        var btn=e.target.closest('.star-input button');
        if(!btn)return;
        var si=btn.closest('.star-input');
        var v=parseInt(btn.dataset.v,10);
        si.dataset.value=v;
        si.querySelectorAll('button').forEach(function(b){
            b.classList.toggle('on',parseInt(b.dataset.v,10)<=v);
        });
        var lbl=document.getElementById('starLabel');
        if(lbl&&si.id==='starProduct'){
            var labels=['','Rất tệ 😞','Không hài lòng 😕','Bình thường 😐','Hài lòng 🙂','Tuyệt vời 🤩'];
            lbl.textContent=labels[v];
        }
    });

    /* ---------- PRODUCT REVIEW ---------- */
    var currentProductForReview='';
    function openProductReview(name){
        currentProductForReview=name;
        document.getElementById('reviewSub').textContent='Đánh giá: '+name;
        var si=document.getElementById('starProduct');
        si.dataset.value=0;
        si.querySelectorAll('button').forEach(function(b){b.classList.remove('on')});
        document.getElementById('starLabel').textContent='Chạm để chọn số sao';
        document.getElementById('reviewText').value='';
        openModalById('reviewModal');
    }
    function submitProductReview(){
        var v=parseInt(document.getElementById('starProduct').dataset.value||0,10);
        var text=document.getElementById('reviewText').value.trim();
        if(v===0){toastErr('Vui lòng chọn số sao đánh giá');return}
        if(text.length<5){toastErr('Vui lòng nhập nhận xét của bạn');return}
        var stars='★'.repeat(v)+'☆'.repeat(5-v);
        var list=document.getElementById('reviewList');
        if(list){
            var div=document.createElement('div');
            div.className='review';
            div.innerHTML='<span class="review-tag">Sản phẩm</span><div class="who"><div class="avatar lg">MA</div><div><strong>Nguyễn Minh Anh</strong><span>Vừa xong · Đã xác thực</span></div></div><div class="stars" style="margin-bottom:8px;">'+stars+'</div><p>"'+text.replace(/</g,'&lt;')+'"</p><div class="verified">✓ Đã xác thực đơn hàng</div>';
            list.prepend(div);
        }
        closeAll();
        toastOk('Cảm ơn bạn đã đánh giá '+currentProductForReview+'!');
    }

    /* ---------- ORDERS ---------- */
    var requests=store.get('requests',[]);
    var currentOrderTab='all';
    var statusClass={pending:'st-pending',producing:'st-producing',shipping:'st-shipping',delivered:'st-delivered',cancelled:'st-cancelled'};

    function initOrderPage(){
        var locked=document.getElementById('orderLocked');if(!locked)return;
        if(isLoggedIn()){
            locked.style.display='none';
            document.getElementById('orderPanel').style.display='block';
            updateReqCount();
            renderOrders();
        } else {
            locked.style.display='block';
            document.getElementById('orderPanel').style.display='none';
        }
    }
    function updateReqCount(){
        var el=document.getElementById('reqCount');
        if(el)el.textContent='('+requests.length+')';
    }
    function switchOrderTab(btn,tab){
        currentOrderTab=tab;
        btn.parentElement.querySelectorAll('button').forEach(function(b){b.classList.remove('active')});
        btn.classList.add('active');
        renderOrders();
    }
    function renderOrders(){
        var list=document.getElementById('orderList');if(!list)return;
        if(currentOrderTab==='requests'){
            if(requests.length===0){
                list.innerHTML='<div class="empty-state"><div style="font-size:34px;margin-bottom:10px;">📋</div><strong>Chưa có yêu cầu nào</strong><p style="margin-top:6px;font-size:13.5px;">Các yêu cầu chỉnh sửa, hủy đơn hoặc trả hàng của bạn sẽ hiển thị ở đây.</p></div>';
                return;
            }
            list.innerHTML='<div class="request-list">'+requests.map(function(r){
                return '<div class="request-item '+r.tone+'"><div class="ri-body"><strong>'+r.title+' — #'+r.orderId+'</strong><span>'+r.desc+' · Gửi lúc '+r.time+'</span></div><span class="status-badge '+r.badge+'">'+r.status+'</span></div>';
            }).join('')+'</div>';
            return;
        }
        var filtered=currentOrderTab==='all'?ORDERS:ORDERS.filter(function(o){return o.status===currentOrderTab});
        if(filtered.length===0){
            list.innerHTML='<div class="empty-state"><div style="font-size:34px;margin-bottom:10px;">📦</div><strong>Không có đơn hàng nào</strong></div>';
            return;
        }
        list.innerHTML=filtered.map(function(o){
            return '<div class="order-card"><div class="order-card-top"><div><h4>'+o.product+'</h4><div class="oid">#'+o.id+' · '+o.detail+'</div></div><span class="status-badge '+statusClass[o.status]+'">'+o.statusLabel+'</span></div><div class="order-progress">'+
                [1,2,3,4].map(function(i){return '<div class="bar '+(i<=o.progress?'on':'')+'"></div>'}).join('')+
                '</div><div class="order-info"><span>Tổng tiền: <b>'+o.total+'</b></span><span>Xưởng in: <b>'+o.supplier+'</b></span><span>Dự kiến: <b>'+o.eta+'</b></span></div><div class="order-actions">'+orderActionsFor(o)+'</div></div>';
        }).join('');
    }
    function orderActionsFor(o){
        var html='<button onclick="toast(\'Đang mở chi tiết đơn #'+o.id+'...\')">Xem chi tiết</button>';
        if(o.status==='pending'){
            html+='<button onclick="openOrderAction(\'edit\',\''+o.id+'\',\''+o.product+'\')">✏️ Chỉnh sửa đơn</button>';
            html+='<button class="danger" onclick="openOrderAction(\'cancel\',\''+o.id+'\',\''+o.product+'\')">✕ Hủy đơn</button>';
        }
        if(o.status==='producing'){
            html+='<button onclick="openOrderAction(\'edit\',\''+o.id+'\',\''+o.product+'\')">✏️ Yêu cầu chỉnh sửa</button>';
            html+='<button class="danger" onclick="openOrderAction(\'cancel\',\''+o.id+'\',\''+o.product+'\')">✕ Yêu cầu hủy đơn</button>';
            html+='<button onclick="toast(\'Đã gửi tin nhắn tới xưởng '+o.supplier+'\')">💬 Nhắn xưởng in</button>';
        }
        if(o.status==='shipping'){
            html+='<button onclick="toast(\'Đang mở bản đồ theo dõi vận chuyển...\')">🚚 Theo dõi vận chuyển</button>';
            html+='<button class="danger" onclick="openOrderAction(\'cancel\',\''+o.id+'\',\''+o.product+'\')">✕ Yêu cầu hủy đơn</button>';
        }
        if(o.status==='delivered'){
            html+='<button class="primary" onclick="openOrderAction(\'return\',\''+o.id+'\',\''+o.product+'\')">↩️ Yêu cầu trả hàng</button>';
            html+='<button onclick="openProductReview(\''+o.product+'\')">★ Đánh giá sản phẩm</button>';
            html+='<button onclick="openSupplierReview(\''+o.supplier+'\')">🏭 Đánh giá nhà cung cấp</button>';
        }
        return html;
    }
    var oaContext={};
    function openOrderAction(type,orderId,product){
        oaContext={type:type,orderId:orderId,product:product};
        var cfg={
            edit:{
                title:'Yêu cầu chỉnh sửa đơn hàng',
                sub:'Đơn #'+orderId+' · '+product,
                submit:'Gửi yêu cầu chỉnh sửa',
                body:'<div style="background:#FFF4E0;border-radius:12px;padding:14px;font-size:13px;color:#8A5A00;margin-bottom:18px;line-height:1.6;">⚠️ <b>Lưu ý:</b> Đơn đang trong quá trình sản xuất. Thay đổi về số lượng hoặc chất liệu có thể phát sinh phụ phí và làm chậm tiến độ 1–2 ngày.</div><div class="field"><label>Nội dung cần chỉnh sửa</label><select id="oaEditType"><option>Thay đổi số lượng</option><option>Thay đổi kích thước / size</option><option>Thay đổi màu sản phẩm</option><option>Thay đổi file thiết kế</option><option>Thay đổi địa chỉ giao hàng</option><option>Khác</option></select></div><div class="field"><label>Chi tiết thay đổi</label><textarea rows="3" id="oaEditNote" placeholder="VD: Tăng từ 24 lên 30 áo, thêm size XL..."></textarea></div><div class="field"><label>Mức độ khẩn cấp</label><select id="oaEditUrgency"><option>Bình thường</option><option>Gấp — cần xử lý trong 2 giờ</option></select></div>'
            },
            cancel:{
                title:'Yêu cầu hủy đơn hàng',
                sub:'Đơn #'+orderId+' · '+product,
                submit:'Xác nhận hủy đơn',
                body:'<div style="background:#FFECEC;border-radius:12px;padding:14px;font-size:13px;color:#C0392B;margin-bottom:18px;line-height:1.6;">⚠️ <b>Phí hủy đơn:</b> Nếu xưởng đã bắt đầu sản xuất, phí hủy là <b>30% giá trị đơn hàng</b>. Trước khi xưởng nhận file, bạn được hủy miễn phí hoàn toàn.</div><div class="field"><label>Lý do hủy đơn</label><select id="oaCancelReason"><option>Đặt nhầm sản phẩm</option><option>Đặt nhầm số lượng</option><option>Thay đổi kế hoạch kinh doanh</option><option>Thời gian giao hàng không phù hợp</option><option>Tìm được nhà cung cấp khác</option><option>Lý do khác</option></select></div><div class="field"><label>Ghi chú thêm</label><textarea rows="3" id="oaCancelNote" placeholder="Cho chúng tôi biết thêm để hỗ trợ bạn tốt hơn..."></textarea></div><label style="display:flex;gap:10px;align-items:flex-start;font-size:13px;color:var(--ink-soft);"><input type="checkbox" id="oaCancelAgree" style="margin-top:3px;accent-color:var(--violet);"><span>Tôi hiểu và đồng ý với phí hủy đơn (nếu có).</span></label>'
            },
            return:{
                title:'Yêu cầu trả hàng / hoàn tiền',
                sub:'Đơn #'+orderId+' · '+product,
                submit:'Gửi yêu cầu trả hàng',
                body:'<div style="background:#E1FBF3;border-radius:12px;padding:14px;font-size:13px;color:#0A7A5E;margin-bottom:18px;line-height:1.6;">✓ Bạn có thể yêu cầu trả hàng trong vòng <b>7 ngày</b> kể từ khi nhận. Nếu lỗi thuộc về xưởng, PrintKraft in lại miễn phí hoặc hoàn tiền 100%.</div><div class="field"><label>Lý do trả hàng</label><select id="oaReturnReason"><option>Sản phẩm in bị lỗi / nhoè</option><option>Màu sắc không đúng thiết kế</option><option>Kích thước sai so với đặt hàng</option><option>Sản phẩm bị hư hỏng khi vận chuyển</option><option>Thiếu số lượng so với đơn hàng</option><option>Không đúng chất liệu đã chọn</option></select></div><div class="field"><label>Mô tả chi tiết</label><textarea rows="3" id="oaReturnNote" placeholder="Mô tả tình trạng sản phẩm..."></textarea></div><div class="field"><label>Phương án mong muốn</label><select id="oaReturnSolution"><option>In lại sản phẩm mới (miễn phí)</option><option>Hoàn tiền 100%</option><option>Giảm giá đơn tiếp theo 20%</option></select></div><div class="field"><label>Ảnh sản phẩm lỗi</label><div style="border:1.5px dashed var(--line-strong);border-radius:12px;padding:20px;text-align:center;color:var(--ink-soft);font-size:13px;cursor:pointer;background:#FBF9FF;" onclick="toast(\'Đã mở hộp thoại chọn ảnh\')">📷 Tải lên ảnh sản phẩm lỗi (tối đa 5 ảnh)</div></div>'
            }
        };
        var c=cfg[type];
        document.getElementById('oaTitle').textContent=c.title;
        document.getElementById('oaSub').textContent=c.sub;
        document.getElementById('oaBody').innerHTML=c.body;
        document.getElementById('oaSubmit').textContent=c.submit;
        openModalById('orderActionModal');
    }
    function submitOrderAction(){
        var ctx=oaContext,type=ctx.type,orderId=ctx.orderId;
        var now=new Date().toLocaleTimeString('vi-VN',{hour:'2-digit',minute:'2-digit'});
        var req;
        if(type==='edit'){
            var kind=document.getElementById('oaEditType').value;
            var note=document.getElementById('oaEditNote').value.trim();
            if(!note){toastErr('Vui lòng mô tả chi tiết thay đổi');return}
            req={orderId:orderId,tone:'warn',badge:'st-pending',status:'Chờ xưởng duyệt',title:'Yêu cầu chỉnh sửa: '+kind,desc:'Nội dung: '+note,time:now};
        } else if(type==='cancel'){
            var reason=document.getElementById('oaCancelReason').value;
            if(!document.getElementById('oaCancelAgree').checked){toastErr('Vui lòng xác nhận điều khoản phí hủy đơn');return}
            req={orderId:orderId,tone:'',badge:'st-pending',status:'Đang xử lý',title:'Yêu cầu hủy đơn',desc:'Lý do: '+reason,time:now};
        } else {
            var rreason=document.getElementById('oaReturnReason').value;
            var sol=document.getElementById('oaReturnSolution').value;
            req={orderId:orderId,tone:'ok',badge:'st-shipping',status:'Đang xử lý',title:'Yêu cầu trả hàng: '+rreason,desc:'Phương án: '+sol,time:now};
        }
        requests.unshift(req);
        store.set('requests',requests);
        updateReqCount();
        closeAll();
        var msgs={edit:'Đã gửi yêu cầu chỉnh sửa — xưởng sẽ phản hồi trong 2 giờ',cancel:'Đã gửi yêu cầu hủy đơn — bộ phận CSKH sẽ liên hệ trong 30 phút',return:'Đã gửi yêu cầu trả hàng — chúng tôi sẽ xử lý trong 24 giờ'};
        toastOk(msgs[type]);
    }

    /* ---------- PAYMENT ---------- */
    var payStep=1;
    function openPayment(){closeAll();payStep=1;renderPayStep();openModalById('paymentModal')}
    function gotoPayStep(n){
        if(n===3){
            var name=document.getElementById('shipName').value.trim();
            var phone=document.getElementById('shipPhone').value.trim();
            var addr=document.getElementById('shipAddr').value.trim();
            if(!name||!phone||!addr){toastErr('Vui lòng điền đầy đủ thông tin nhận hàng');return}
            document.getElementById('cfName').textContent=name;
            document.getElementById('cfPhone').textContent=phone;
            document.getElementById('cfAddr').textContent=addr;
            var m=document.querySelector('.pay-method.active');
            document.getElementById('cfMethod').textContent=m?m.querySelector('strong').textContent:'—';
        }
        payStep=n;
        renderPayStep();
    }
    function renderPayStep(){
        [1,2,3].forEach(function(i){
            document.getElementById('payStep'+i).style.display=(payStep===i)?'block':'none';
        });
        document.getElementById('payStepDone').style.display='none';
        document.getElementById('payStepper').style.display='flex';
        document.querySelectorAll('#payStepper .s').forEach(function(s){
            var n=parseInt(s.dataset.s,10);
            s.classList.toggle('active',n===payStep);
            s.classList.toggle('done',n<payStep);
        });
        var titles=['','Thông tin nhận hàng','Phương thức thanh toán','Xác nhận đơn hàng'];
        document.getElementById('payTitle').textContent=titles[payStep];
        document.getElementById('paySub').textContent='Bước '+payStep+' / 3';
    }
    function pickPayMethod(btn){
        document.querySelectorAll('#payMethods .pay-method').forEach(function(b){b.classList.remove('active')});
        btn.classList.add('active');
        var m=btn.dataset.m;
        document.getElementById('cardForm').style.display=(m==='card')?'block':'none';
        document.getElementById('bankInfo').style.display=(m==='bank')?'block':'none';
    }
    function formatCard(el){
        var v=el.value.replace(/\D/g,'').slice(0,16);
        el.value=v.replace(/(.{4})/g,'$1 ').trim();
    }
    function formatExpiry(el){
        var v=el.value.replace(/\D/g,'').slice(0,4);
        if(v.length>=3)v=v.slice(0,2)+'/'+v.slice(2);
        el.value=v;
    }
    function confirmPayment(){
        if(!document.getElementById('agreeTerms').checked){toastErr('Vui lòng đồng ý với điều khoản dịch vụ');return}
        [1,2,3].forEach(function(i){document.getElementById('payStep'+i).style.display='none'});
        document.getElementById('payStepper').style.display='none';
        document.getElementById('payTitle').textContent='';
        document.getElementById('paySub').textContent='';
        document.getElementById('payStepDone').style.display='block';
        setCartCount(0);
        toastOk('Thanh toán thành công!');
    }

    /* ---------- INJECT SHARED UI ---------- */
    function injectSharedUI(){
        var wrap=document.createElement('div');
        wrap.innerHTML=
            '<div class="overlay" id="overlay" onclick="closeAll()"></div>'+

            /* CART DRAWER */
            '<aside class="drawer" id="cartDrawer"><div class="drawer-head"><h3>Giỏ hàng của bạn</h3><button onclick="closeAll()">✕</button></div><div class="drawer-body">'+
            '<div class="cart-item"><div class="thumb" style="background:var(--grad-primary)"></div><div class="info"><strong>Áo thun Oversize Cotton</strong><span>DTG · Size L · Màu Navy</span><div class="qty"><button onclick="toast(\'Đã giảm số lượng\')">−</button><span>24</span><button onclick="toast(\'Đã tăng số lượng\')">+</button></div></div><div style="font-family:\'Space Grotesk\';font-weight:700;font-size:14px;">3.096.000đ</div></div>'+
            '<div class="cart-item"><div class="thumb" style="background:var(--grad-warm)"></div><div class="info"><strong>Cốc sứ trắng 2 mặt</strong><span>Sublimation · 350ml</span><div class="qty"><button onclick="toast(\'Đã giảm số lượng\')">−</button><span>2</span><button onclick="toast(\'Đã tăng số lượng\')">+</button></div></div><div style="font-family:\'Space Grotesk\';font-weight:700;font-size:14px;">130.000đ</div></div>'+
            '<div class="cart-item"><div class="thumb" style="background:var(--grad-cool)"></div><div class="info"><strong>Poster A2 giấy mỹ thuật</strong><span>In UV · 40 tờ</span><div class="qty"><button onclick="toast(\'Đã giảm số lượng\')">−</button><span>40</span><button onclick="toast(\'Đã tăng số lượng\')">+</button></div></div><div style="font-family:\'Space Grotesk\';font-weight:700;font-size:14px;">3.560.000đ</div></div>'+
            '<div style="margin-top:20px;"><div class="field"><label>Mã giảm giá</label><input placeholder="Nhập mã..."></div><button class="btn-secondary" style="width:100%;" onclick="toastErr(\'Mã không hợp lệ hoặc đã hết hạn\')">Áp dụng mã</button></div>'+
            '</div><div class="drawer-foot"><div class="row"><span>Tạm tính</span><span>6.786.000đ</span></div><div class="row"><span>Phí vận chuyển</span><span>Miễn phí</span></div><div class="row total"><span>Tổng cộng</span><span>6.786.000đ</span></div><button class="btn-primary" style="width:100%;" onclick="openPayment()">Tiến hành thanh toán</button></div></aside>'+

            /* PAYMENT MODAL */
            '<div class="modal" id="paymentModal"><div class="modal-box wide"><button class="modal-close" onclick="closeAll()">✕</button><h3 id="payTitle">Thanh toán đơn hàng</h3><div class="sub" id="paySub">Hoàn tất 3 bước để đặt hàng</div>'+
            '<div class="stepper" id="payStepper"><div class="s active" data-s="1"><div class="n">1</div><span>Nhận hàng</span></div><div class="sep"></div><div class="s" data-s="2"><div class="n">2</div><span>Thanh toán</span></div><div class="sep"></div><div class="s" data-s="3"><div class="n">3</div><span>Xác nhận</span></div></div>'+
            '<div id="payStep1"><div class="field-row"><div class="field"><label>Họ và tên</label><input id="shipName" value="Nguyễn Minh Anh"></div><div class="field"><label>Số điện thoại</label><input id="shipPhone" value="0901 234 567"></div></div><div class="field"><label>Email</label><input id="shipEmail" value="minhanh@store.vn"></div><div class="field"><label>Địa chỉ giao hàng</label><input id="shipAddr" value="128 Nguyễn Đình Chiểu, Q.3, TP.HCM"></div><div class="field"><label>Ghi chú đơn hàng</label><textarea rows="2" placeholder="VD: Giao giờ hành chính..."></textarea></div><button class="btn-primary" style="width:100%;" onclick="gotoPayStep(2)">Tiếp tục →</button></div>'+
            '<div id="payStep2" style="display:none;"><div class="pay-methods" id="payMethods">'+
            '<button class="pay-method active" data-m="card" onclick="pickPayMethod(this)"><div class="ic" style="background:var(--grad-primary)">💳</div><div class="pm-body"><strong>Thẻ tín dụng / ghi nợ</strong><span>Visa, Mastercard, JCB</span></div><div class="radio"></div></button>'+
            '<button class="pay-method" data-m="bank" onclick="pickPayMethod(this)"><div class="ic" style="background:var(--grad-sky)">🏦</div><div class="pm-body"><strong>Chuyển khoản ngân hàng</strong><span>Xác nhận tự động trong 5 phút</span></div><div class="radio"></div></button>'+
            '<button class="pay-method" data-m="wallet" onclick="pickPayMethod(this)"><div class="ic" style="background:var(--grad-pink)">📱</div><div class="pm-body"><strong>Ví điện tử</strong><span>MoMo, ZaloPay, ShopeePay</span></div><div class="radio"></div></button>'+
            '<button class="pay-method" data-m="cod" onclick="pickPayMethod(this)"><div class="ic" style="background:var(--grad-cool);color:#063a2e">💵</div><div class="pm-body"><strong>Thanh toán khi nhận hàng (COD)</strong><span>Phụ phí 15.000đ</span></div><div class="radio"></div></button>'+
            '</div>'+
            '<div id="cardForm" style="margin-top:20px;"><div class="field"><label>Số thẻ</label><input id="cardNo" placeholder="1234 5678 9012 3456" maxlength="19" oninput="formatCard(this)"></div><div class="field-row"><div class="field"><label>Ngày hết hạn</label><input placeholder="MM/YY" maxlength="5" oninput="formatExpiry(this)"></div><div class="field"><label>CVC</label><input placeholder="123" maxlength="4"></div></div><div class="field"><label>Tên chủ thẻ</label><input placeholder="NGUYEN VAN A"></div></div>'+
            '<div id="bankInfo" style="display:none;margin-top:20px;"><div class="summary-box"><div class="row"><span>Ngân hàng</span><strong>Vietcombank</strong></div><div class="row"><span>Số tài khoản</span><strong>0071 0009 8877 66</strong></div><div class="row"><span>Chủ tài khoản</span><strong>CONG TY PRINTKRAFT</strong></div><div class="row"><span>Nội dung CK</span><strong>PK-08231</strong></div></div></div>'+
            '<div style="display:flex;gap:10px;margin-top:20px;"><button class="btn-secondary" style="flex:1;" onclick="gotoPayStep(1)">← Quay lại</button><button class="btn-primary" style="flex:2;" onclick="gotoPayStep(3)">Xem lại đơn hàng</button></div></div>'+
            '<div id="payStep3" style="display:none;"><div class="summary-box"><div class="row"><span>Người nhận</span><strong id="cfName">—</strong></div><div class="row"><span>Điện thoại</span><strong id="cfPhone">—</strong></div><div class="row"><span>Địa chỉ</span><strong id="cfAddr" style="text-align:right;max-width:60%;">—</strong></div><div class="row"><span>Phương thức</span><strong id="cfMethod">—</strong></div></div><div class="summary-box"><div class="row"><span>Tạm tính (3 sản phẩm)</span><span>6.786.000đ</span></div><div class="row"><span>Phí vận chuyển</span><span>Miễn phí</span></div><div class="row"><span>Giảm giá</span><span style="color:var(--teal);font-weight:600;">-100.000đ</span></div><div class="row total"><span>Tổng thanh toán</span><span>6.686.000đ</span></div></div><label style="display:flex;gap:10px;align-items:flex-start;font-size:13px;color:var(--ink-soft);margin-bottom:18px;"><input type="checkbox" id="agreeTerms" style="margin-top:3px;accent-color:var(--violet);"><span>Tôi đồng ý với <a href="lien-he.jsp" style="color:var(--violet);font-weight:600;">Điều khoản dịch vụ</a> và <a href="lien-he.jsp" style="color:var(--violet);font-weight:600;">Chính sách đổi trả</a>.</span></label><div style="display:flex;gap:10px;"><button class="btn-secondary" style="flex:1;" onclick="gotoPayStep(2)">← Quay lại</button><button class="btn-primary btn-teal" style="flex:2;" onclick="confirmPayment()">🔒 Thanh toán 6.686.000đ</button></div></div>'+
            '<div id="payStepDone" style="display:none;"><div class="success-screen"><div class="success-icon">✓</div><h3>Đặt hàng thành công!</h3><p>Cảm ơn bạn đã tin tưởng PrintKraft. Xưởng in sẽ xác nhận trong vòng 30 phút.</p><div class="order-code">#PK-08231</div><p style="font-size:13px;">Hóa đơn điện tử đã được gửi tới <b>minhanh@store.vn</b></p><div style="display:flex;gap:10px;margin-top:22px;"><button class="btn-secondary" style="flex:1;" onclick="closeAll()">Đóng</button><button class="btn-primary" style="flex:1;" onclick="closeAll();location.href=\'don_hang_cua_toi_3d.jsp\';">Theo dõi đơn</button></div></div></div>'+
            '</div></div>'+

            /* ORDER ACTION MODAL */
            '<div class="modal" id="orderActionModal"><div class="modal-box"><button class="modal-close" onclick="closeAll()">✕</button><h3 id="oaTitle">Yêu cầu</h3><div class="sub" id="oaSub"></div><div id="oaBody"></div><div style="display:flex;gap:10px;margin-top:6px;"><button class="btn-secondary" style="flex:1;" onclick="closeAll()">Hủy</button><button class="btn-primary" id="oaSubmit" style="flex:2;" onclick="submitOrderAction()">Gửi yêu cầu</button></div></div></div>'+

            /* PRODUCT REVIEW MODAL */
            '<div class="modal" id="reviewModal"><div class="modal-box"><button class="modal-close" onclick="closeAll()">✕</button><h3>Đánh giá sản phẩm</h3><div class="sub" id="reviewSub">Chia sẻ trải nghiệm của bạn</div><div class="field"><label>Chất lượng sản phẩm</label><div class="star-input" id="starProduct" data-value="0"><button data-v="1">★</button><button data-v="2">★</button><button data-v="3">★</button><button data-v="4">★</button><button data-v="5">★</button></div><div class="rate-label" id="starLabel">Chạm để chọn số sao</div></div><div class="field"><label>Nhận xét của bạn</label><textarea rows="4" id="reviewText" placeholder="Chất liệu, màu in, độ bền..."></textarea></div><div class="field"><label>Thêm ảnh (không bắt buộc)</label><div style="border:1.5px dashed var(--line-strong);border-radius:12px;padding:22px;text-align:center;color:var(--ink-soft);font-size:13px;cursor:pointer;background:#FBF9FF;" onclick="toast(\'Đã mở hộp thoại chọn ảnh\')">📷 Kéo ảnh vào đây hoặc nhấp để chọn (tối đa 5 ảnh)</div></div><button class="btn-primary" style="width:100%;" onclick="submitProductReview()">Gửi đánh giá</button></div></div>'+

            /* SUPPLIER CONTACT MODAL */
            '<div class="modal" id="contactModal"><div class="modal-box"><button class="modal-close" onclick="closeAll()">✕</button><h3>Liên hệ nhà cung cấp</h3><div class="sub" id="contactSub">Gửi yêu cầu trực tiếp tới xưởng in</div><div class="field"><label>Xưởng in</label><input id="contactSupplier" readonly style="background:#F2EFFF;font-weight:600;color:var(--violet);"></div><div class="field"><label>Chủ đề</label><select id="contactSubject"><option>Hỏi báo giá số lượng lớn</option><option>Hỏi thời gian sản xuất</option><option>Yêu cầu in mẫu thử</option><option>Hợp tác dài hạn</option><option>Vấn đề về đơn hàng đã đặt</option></select></div><div class="field-row"><div class="field"><label>Số lượng dự kiến</label><input placeholder="VD: 500"></div><div class="field"><label>SĐT liên hệ</label><input placeholder="09xx xxx xxx"></div></div><div class="field"><label>Nội dung</label><textarea rows="4" id="contactMsg" placeholder="Mô tả yêu cầu của bạn..."></textarea></div><button class="btn-primary" style="width:100%;" onclick="submitContact()">Gửi tin nhắn</button></div></div>'+

            /* SUPPLIER REVIEW MODAL */
            '<div class="modal" id="supplierReviewModal"><div class="modal-box"><button class="modal-close" onclick="closeAll()">✕</button><h3>Đánh giá nhà cung cấp</h3><div class="sub" id="supRevSub">Đánh giá xưởng in</div><div class="field"><label>Chất lượng in ấn</label><div class="star-input" data-group="q" data-value="0"><button data-v="1">★</button><button data-v="2">★</button><button data-v="3">★</button><button data-v="4">★</button><button data-v="5">★</button></div></div><div class="field"><label>Đúng tiến độ</label><div class="star-input" data-group="t" data-value="0"><button data-v="1">★</button><button data-v="2">★</button><button data-v="3">★</button><button data-v="4">★</button><button data-v="5">★</button></div></div><div class="field"><label>Thái độ &amp; hỗ trợ</label><div class="star-input" data-group="s" data-value="0"><button data-v="1">★</button><button data-v="2">★</button><button data-v="3">★</button><button data-v="4">★</button><button data-v="5">★</button></div></div><div class="field"><label>Nhận xét</label><textarea rows="3" id="supRevText" placeholder="Chia sẻ trải nghiệm..."></textarea></div><button class="btn-primary" style="width:100%;" onclick="submitSupplierReview()">Gửi đánh giá</button></div></div>'+

            '<div class="toast" id="toast">Đã thực hiện</div>';

        document.body.appendChild(wrap);
    }

    /* ---------- INIT ---------- */
    document.addEventListener('DOMContentLoaded',function(){
        var activePage=document.body.dataset.page||'home';
        renderHeader(activePage);
        renderFooter();
        injectSharedUI();
        renderAuthArea();
        setCartCount(getCartCount());
        if(document.getElementById('supplierGrid'))renderSuppliers();
        if(document.getElementById('qtyRange'))updatePrice();
        initOrderPage();
        var params=new URLSearchParams(location.search);
        var q=params.get('q');
        if(q&&document.getElementById('supplierSearch')){
            document.getElementById('supplierSearch').value=q;
            renderSuppliers();
        }
    });
</script>
</body>
</html>