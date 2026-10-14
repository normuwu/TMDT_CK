<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>PrintKraft — Tìm &amp; xem nhà cung cấp</title>
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
    color:var(--ink); font-family:'IBM Plex Sans', sans-serif; line-height:1.55;
    background:
      radial-gradient(1100px 620px at 8% -8%, rgba(108,92,231,0.13), transparent 62%),
      radial-gradient(880px 520px at 96% -4%, rgba(255,107,107,0.13), transparent 58%),
      radial-gradient(900px 640px at 50% 104%, rgba(0,184,148,0.10), transparent 62%),
      var(--cream);
    background-attachment:fixed; min-height:100vh;
  }
  h1,h2,h3,h4,h5,.display{font-family:'Space Grotesk', sans-serif; letter-spacing:-0.02em; line-height:1.15;}
  a{color:inherit; text-decoration:none;}
  img,svg{display:block;}
  button{font-family:inherit; cursor:pointer; border:none; background:none; color:inherit;}
  input,select,textarea{font-family:inherit;}

  .utility{background:linear-gradient(90deg,#1B1B2F 0%,#2D2B55 50%,#1B1B2F 100%); color:rgba(253,249,243,0.82);
    font-size:12.5px; padding:9px 32px; display:flex; justify-content:space-between; flex-wrap:wrap; gap:8px;}
  .utility b, .utility a{color:var(--amber); font-weight:600;}

  header{background:rgba(253,249,243,0.9); backdrop-filter:blur(14px); border-bottom:1px solid var(--line);
    padding:12px 32px; display:flex; align-items:center; gap:16px; position:sticky; top:0; z-index:50; flex-wrap:wrap;}
  .logo{font-size:22px; font-weight:700; display:flex; align-items:center; gap:10px; white-space:nowrap;}
  .logo .mark{width:28px; height:28px; background:var(--grad-warm); display:inline-block; transform:rotate(45deg); border-radius:8px; box-shadow:0 6px 16px rgba(255,107,107,0.4);}
  nav{display:flex; gap:4px; font-size:14px; font-weight:500; flex:1; min-width:0; overflow-x:auto;}
  nav a{padding:9px 14px; border-radius:999px; white-space:nowrap; color:var(--ink-soft); transition:.18s;}
  nav a:hover{background:rgba(108,92,231,0.10); color:var(--violet);}
  nav a.active{background:var(--grad-primary); color:#fff; box-shadow:0 6px 16px rgba(108,92,231,0.30);}
  .head-actions{margin-left:auto; display:flex; align-items:center; gap:12px;}

  .btn-primary{background:var(--grad-primary); color:white; padding:14px 26px; border-radius:var(--r-sm); font-weight:600; font-size:14.5px; display:inline-block; text-align:center; box-shadow:var(--shadow-glow); transition:.2s;}
  .btn-primary:hover{transform:translateY(-2px); box-shadow:0 18px 40px rgba(108,92,231,0.42);}
  .btn-secondary{border:1.5px solid var(--line-strong); padding:14px 26px; border-radius:var(--r-sm); font-weight:600; font-size:14.5px; background:var(--surface); color:var(--ink); display:inline-block; text-align:center; transition:.2s;}
  .btn-secondary:hover{border-color:var(--violet); color:var(--violet); transform:translateY(-2px);}
  .btn-outline{border:1.5px solid var(--line-strong); background:var(--surface);}
  .btn-outline:hover{border-color:var(--violet); color:var(--violet);}
  .btn-fill{background:var(--grad-primary); color:white; box-shadow:0 8px 18px rgba(108,92,231,0.28);}
  .btn-fill:hover{transform:translateY(-2px);}
  .btn-sm{padding:9px 16px; font-size:13px; border-radius:9px;}

  .section{max-width:1280px; margin:0 auto; padding:46px 32px 70px;}
  .section-head{display:flex; justify-content:space-between; align-items:flex-end; margin-bottom:32px; gap:20px; flex-wrap:wrap;}
  .section-head h2{font-size:32px;}
  .section-head p{color:var(--ink-soft); font-size:14px; margin-top:8px;}
  .eyebrow-line{display:inline-block; font-size:12px; font-weight:700; letter-spacing:.12em; text-transform:uppercase; color:var(--violet); margin-bottom:10px;}

  .pill{display:inline-block; font-size:11.5px; font-weight:600; padding:4px 11px; border-radius:999px; background:#F2EFFF; color:var(--violet);}
  .pill.teal{background:#E1FBF3; color:#0A7A5E;}
  .pill.amber{background:#FFF4E0; color:#9A6200;}
  .pill.coral{background:#FFE8E8; color:var(--coral-deep);}

  .stars{font-size:12px; color:var(--amber); letter-spacing:1.5px;}
  .avatar{width:34px;height:34px;border-radius:50%; background:var(--grad-primary); color:white;
    display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700; flex-shrink:0;}
  .avatar.coral{background:var(--grad-warm);} .avatar.teal{background:var(--grad-cool);} .avatar.pink{background:var(--grad-pink);}

  /* ===== Suppliers ===== */
  .supplier-tools{display:flex; gap:12px; flex-wrap:wrap; margin-bottom:26px;}
  .supplier-search{flex:1; min-width:240px; display:flex; align-items:center; gap:10px;
    background:var(--surface); border:1.5px solid var(--line-strong); border-radius:999px; padding:0 18px;
    box-shadow:var(--shadow-xs); transition:.2s;}
  .supplier-search:focus-within{border-color:var(--violet); box-shadow:0 0 0 4px rgba(108,92,231,0.13);}
  .supplier-search input{border:none; outline:none; background:transparent; padding:13px 0; flex:1; font-size:14px;}
  .chips{display:flex; gap:9px; flex-wrap:wrap;}
  .chip{border:1.5px solid var(--line-strong); background:var(--surface); border-radius:999px; padding:9px 17px; font-size:13px; font-weight:500; transition:.18s;}
  .chip:hover{border-color:var(--violet); color:var(--violet);}
  .chip.active{background:var(--grad-primary); color:white; border-color:transparent; box-shadow:0 8px 18px rgba(108,92,231,0.3);}
  .supplier-grid{display:grid; grid-template-columns:repeat(3,1fr); gap:22px;}
  .supplier{background:var(--surface); border:1px solid var(--line); border-radius:var(--r-md); padding:22px;
    box-shadow:var(--shadow-xs); transition:.22s; display:flex; flex-direction:column; gap:14px;}
  .supplier:hover{transform:translateY(-5px); box-shadow:var(--shadow-md);}
  .supplier-top{display:flex; gap:14px; align-items:center;}
  .supplier-logo{width:52px;height:52px;border-radius:14px; display:flex;align-items:center;justify-content:center;
    font-family:'Space Grotesk'; font-weight:700; color:white; font-size:17px; flex-shrink:0; box-shadow:var(--shadow-sm);}
  .supplier-top h4{font-size:15.5px;}
  .supplier-top .loc{font-size:12.5px; color:var(--ink-soft);}
  .supplier-meta{display:flex; gap:8px; flex-wrap:wrap;}
  .supplier-stat{display:flex; justify-content:space-between; font-size:12.5px; color:var(--ink-soft); border-top:1px solid var(--line); padding-top:12px;}
  .supplier-stat b{color:var(--ink); font-family:'Space Grotesk';}
  .supplier-actions{display:flex; gap:9px; flex-wrap:wrap;}
  .supplier-actions button, .supplier-actions a{flex:1; min-width:96px; padding:10px; border-radius:9px; font-size:13px; font-weight:600; transition:.18s; text-align:center;}
  .empty-state{grid-column:1/-1; text-align:center; padding:50px 20px; color:var(--ink-soft);
    border:1.5px dashed var(--line-strong); border-radius:var(--r-md); background:rgba(255,255,255,0.5);}

  /* ===== Supplier detail ===== */
  .back-link{display:inline-flex; align-items:center; gap:7px; font-size:13.5px; font-weight:600; color:var(--ink-soft); margin-bottom:18px; cursor:pointer;}
  .back-link:hover{color:var(--violet);}
  .sup-hero{display:flex; gap:22px; align-items:center; flex-wrap:wrap; background:var(--surface); border:1px solid var(--line); border-radius:var(--r-lg); padding:26px; box-shadow:var(--shadow-sm);}
  .sup-hero .supplier-logo{width:74px; height:74px; font-size:24px; border-radius:20px;}
  .sup-hero-stats{display:grid; grid-template-columns:repeat(3,1fr); gap:12px; margin:20px 0;}
  .sup-hero-stats .stat{background:#F8F7FC; border-radius:12px; padding:14px; text-align:center;}
  .sup-hero-stats .stat b{display:block; font-family:'Space Grotesk'; font-size:20px;}
  .sup-hero-stats .stat span{font-size:11.5px; color:var(--ink-soft);}
  .detail-grid{display:grid; grid-template-columns:1.4fr 1fr; gap:20px; margin-top:20px; align-items:start;}
  .info-card{background:var(--surface); border:1px solid var(--line); border-radius:var(--r-lg); padding:22px; box-shadow:var(--shadow-xs);}
  .info-row{display:flex; justify-content:space-between; gap:14px; padding:11px 0; border-bottom:1px solid var(--line); font-size:13.5px;}
  .info-row:last-child{border-bottom:0;}
  .info-row span{color:var(--ink-soft);}
  .mini-review{padding:14px 0; border-bottom:1px solid var(--line);}
  .mini-review:last-child{border-bottom:0;}
  .mini-review .who{display:flex; align-items:center; gap:12px;}
  .mini-review .who strong{display:block; font-size:14px;}
  .mini-review .who span{font-size:11.5px; color:var(--ink-soft);}

  /* ===== Modal / Toast ===== */
  .overlay{position:fixed; inset:0; background:rgba(27,27,47,0.5); backdrop-filter:blur(3px); opacity:0; pointer-events:none; transition:.25s; z-index:90;}
  .overlay.show{opacity:1; pointer-events:auto;}
  .modal{position:fixed; inset:0; display:flex; align-items:center; justify-content:center; z-index:110;
    opacity:0; pointer-events:none; transition:.22s; padding:20px; overflow-y:auto;}
  .modal.show{opacity:1; pointer-events:auto;}
  .modal-box{background:var(--cream); border-radius:var(--r-xl); padding:34px; width:460px; max-width:100%;
    position:relative; box-shadow:var(--shadow-lg); transform:translateY(14px) scale(.98); transition:.25s; max-height:92vh; overflow-y:auto; margin:auto;}
  .modal.show .modal-box{transform:translateY(0) scale(1);}
  .modal-box.wide{width:620px;}
  .modal-box h3{font-size:23px; margin-bottom:6px;}
  .modal-box .sub{font-size:13.5px; color:var(--ink-soft); margin-bottom:24px;}
  .modal-close{position:absolute; top:18px; right:20px; font-size:20px; width:36px;height:36px;border-radius:50%; color:var(--ink-soft); transition:.18s;}
  .modal-close:hover{background:var(--line); color:var(--ink);}
  .field{margin-bottom:14px;}
  .field label{display:block; font-size:12.5px; font-weight:600; margin-bottom:6px; color:var(--ink-soft);}
  .field input, .field select, .field textarea{width:100%; border:1.5px solid var(--line); border-radius:var(--r-sm); padding:12px 14px;
    font-size:14px; background:#FBF9FF; outline:none; transition:.18s; color:var(--ink);}
  .field input:focus, .field select:focus, .field textarea:focus{border-color:var(--violet); background:white; box-shadow:0 0 0 4px rgba(108,92,231,0.12);}
  .field-row{display:grid; grid-template-columns:1fr 1fr; gap:14px;}
  .star-input{display:flex; gap:6px; margin-bottom:6px;}
  .star-input button{font-size:34px; line-height:1; color:#E4E2EF; transition:.14s;}
  .star-input button.on{color:var(--amber); transform:scale(1.06);}
  .star-input button:hover{transform:scale(1.18);}
  .toast{position:fixed; bottom:28px; left:50%; transform:translate(-50%, 100px); background:var(--ink); color:var(--cream);
    padding:14px 24px; border-radius:999px; font-size:13.5px; font-weight:500; z-index:300; transition:.3s cubic-bezier(.4,0,.2,1); opacity:0; box-shadow:var(--shadow-lg); max-width:90vw; text-align:center;}
  .toast.show{transform:translate(-50%,0); opacity:1;}
  .toast.ok{background:linear-gradient(135deg,#00B894,#0A7A5E);}
  .toast.err{background:linear-gradient(135deg,#FF6B6B,#C0392B);}

  @media (max-width:1080px){ .supplier-grid{grid-template-columns:repeat(2,1fr);} }
  @media (max-width:900px){ .detail-grid{grid-template-columns:1fr;} header{padding:10px 18px;} .utility{padding:8px 18px;} }
  @media (max-width:640px){ .supplier-grid{grid-template-columns:1fr;} .field-row{grid-template-columns:1fr;} .sup-hero-stats{grid-template-columns:1fr;} .section{padding:34px 18px 60px;} }
</style>
</head>
<body>

  <div class="utility">
    <span>🚚 Miễn phí thiết kế mockup cho đơn từ 20 sản phẩm — <b>Voucher 100K</b> cho đơn đầu tiên</span>
    <span>Hỗ trợ: <b>1900 6868</b> · <a href="trang_chu.jsp">Về trang chủ PrintKraft</a></span>
  </div>

  <header>
    <a class="logo" href="trang_chu.jsp"><span class="mark"></span> PrintKraft</a>
    <nav>
      <a href="tim-kiem-nha-cung-cap.jsp" class="active">Nhà cung cấp</a>
      <a href="danh-muc-yeu-thich.jsp">Yêu thích</a>
      <a href="lien-he.jsp">Liên hệ</a>
      <a href="phan-hoi.jsp">Phản hồi</a>
      <a href="danh-gia.jsp">Đánh giá</a>
    </nav>
    <div class="head-actions">
      <a class="btn-outline btn-sm" href="trang_chu.jsp">← Trang chủ</a>
    </div>
  </header>

  <main>
    <!-- ============ DANH SÁCH / TÌM KIẾM NCC ============ -->
    <section class="section" id="supListView">
      <div class="section-head">
        <div>
          <div class="eyebrow-line">Mạng lưới đối tác</div>
          <h2>Tìm &amp; liên hệ nhà cung cấp</h2>
          <p>120+ xưởng in đã kiểm duyệt trên toàn quốc — tìm theo khu vực, chất liệu hoặc năng lực sản xuất</p>
        </div>
      </div>

      <div class="supplier-tools">
        <div class="supplier-search">
          <span style="font-size:16px;">🔍</span>
          <input type="text" id="supplierSearch" placeholder="Tìm theo tên xưởng, thành phố hoặc chất liệu (VD: Hà Nội, FDM, SLS...)" oninput="renderSuppliers()">
        </div>
        <div class="chips" data-single id="supplierFilters">
          <button class="chip active" data-filter="all" onclick="setSupplierFilter(this,'all')">Tất cả</button>
          <button class="chip" data-filter="FDM" onclick="setSupplierFilter(this,'FDM')">FDM</button>
          <button class="chip" data-filter="SLS" onclick="setSupplierFilter(this,'SLS')">SLS</button>
          <button class="chip" data-filter="Full-color" onclick="setSupplierFilter(this,'Full-color')">Full-color</button>
          <button class="chip" data-filter="CNC hậu xử lý" onclick="setSupplierFilter(this,'CNC hậu xử lý')">CNC hậu xử lý</button>
        </div>
      </div>

      <div class="supplier-grid" id="supplierGrid"></div>
    </section>

    <!-- ============ CHI TIẾT NCC ============ -->
    <section class="section" id="supDetailView" style="display:none;">
      <span class="back-link" onclick="backToSuppliers()">← Quay lại danh sách nhà cung cấp</span>
      <div class="sup-hero">
        <div class="supplier-logo" id="supDetailLogo">SP</div>
        <div>
          <h2 id="supDetailName" style="font-size:24px;">Sài Gòn Print</h2>
          <div class="loc" id="supDetailLoc" style="margin:4px 0; color:var(--ink-soft); font-size:13px;">📍 TP. Hồ Chí Minh</div>
          <div class="stars" id="supDetailRating">★★★★★ <span style="color:var(--ink-soft)">4.9</span></div>
        </div>
        <div style="display:flex; gap:9px; flex-wrap:wrap; margin-left:auto;">
          <button class="btn-outline btn-sm" id="supDetailReviewBtn" onclick="openSupplierReview('Sài Gòn Print')">★ Viết đánh giá</button>
          <button class="btn-outline btn-sm" id="supDetailFavBtn" onclick="toggleFavoriteSupplierDetail('Sài Gòn Print')">♡ Thêm vào yêu thích</button>
          <a class="btn-fill btn-sm" id="supDetailContactBtn" href="lien-he.jsp">💬 Liên hệ ngay</a>
        </div>
      </div>

      <div class="supplier-meta" id="supDetailTags" style="margin-top:16px;"></div>
      <div class="sup-hero-stats" id="supDetailStats"></div>

      <div class="detail-grid">
        <div class="info-card">
          <h4 style="font-size:16px; margin-bottom:14px;">Đánh giá gần đây</h4>
          <div class="mini-review">
            <div class="who"><div class="avatar coral">NA</div><div><strong>Nguyễn An</strong><span> · <span class="stars">★★★★★</span></span></div></div>
            <p style="font-size:13px; color:var(--ink-soft); margin-top:8px;">Giao đúng hẹn, màu in đẹp, xưởng tư vấn nhanh và đúng mẫu đã duyệt.</p>
          </div>
          <div class="mini-review">
            <div class="who"><div class="avatar teal">MT</div><div><strong>Minh Trí</strong><span> · <span class="stars">★★★★☆</span></span></div></div>
            <p style="font-size:13px; color:var(--ink-soft); margin-top:8px;">Chất lượng ổn, đóng gói tốt. Giao lâu hơn dự kiến một ngày.</p>
          </div>
        </div>
        <div class="info-card">
          <h4 style="font-size:16px; margin-bottom:6px;">Thông tin liên hệ</h4>
          <div id="supDetailInfo"></div>
        </div>
      </div>
    </section>
  </main>

  <div class="overlay" id="overlay" onclick="closeAll()"></div>

  <!-- ===== SUPPLIER REVIEW MODAL ===== -->
  <div class="modal" id="supplierReviewModal">
    <div class="modal-box">
      <button class="modal-close" onclick="closeAll()">✕</button>
      <h3>Đánh giá nhà cung cấp</h3>
      <div class="sub" id="supRevSub">Đánh giá xưởng in</div>

      <div class="field"><label>Chất lượng in ấn</label>
        <div class="star-input" data-group="q" data-value="0">
          <button data-v="1">★</button><button data-v="2">★</button><button data-v="3">★</button><button data-v="4">★</button><button data-v="5">★</button>
        </div>
      </div>
      <div class="field"><label>Đúng tiến độ</label>
        <div class="star-input" data-group="t" data-value="0">
          <button data-v="1">★</button><button data-v="2">★</button><button data-v="3">★</button><button data-v="4">★</button><button data-v="5">★</button>
        </div>
      </div>
      <div class="field"><label>Thái độ &amp; hỗ trợ</label>
        <div class="star-input" data-group="s" data-value="0">
          <button data-v="1">★</button><button data-v="2">★</button><button data-v="3">★</button><button data-v="4">★</button><button data-v="5">★</button>
        </div>
      </div>
      <div class="field"><label>Nhận xét</label><textarea rows="3" id="supRevText" placeholder="Chia sẻ trải nghiệm làm việc với xưởng này..."></textarea></div>
      <button class="btn-primary" style="width:100%;" onclick="submitSupplierReview()">Gửi đánh giá</button>
    </div>
  </div>

  <div class="toast" id="toast">Đã thực hiện</div>

<script>
/* ============================================================
   TOAST
   ============================================================ */
let toastTimer;
function toast(msg, type){
  const t = document.getElementById('toast');
  t.textContent = msg;
  t.className = 'toast show' + (type ? ' ' + type : '');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(()=>t.classList.remove('show'), 2400);
}
function toastOk(msg){ toast(msg, 'ok'); }
function toastErr(msg){ toast(msg, 'err'); }

/* ============================================================
   MODAL
   ============================================================ */
function openModalById(id){
  closeAll();
  document.getElementById(id).classList.add('show');
  document.getElementById('overlay').classList.add('show');
  document.body.style.overflow = 'hidden';
}
function closeAll(){
  document.querySelectorAll('.modal').forEach(el=>el.classList.remove('show'));
  document.getElementById('overlay').classList.remove('show');
  document.body.style.overflow = '';
}
document.addEventListener('keydown', e=>{ if(e.key === 'Escape') closeAll(); });

/* ============================================================
   DỮ LIỆU NHÀ CUNG CẤP
   ============================================================ */
const suppliers = [
  { name:'Sài Gòn Print', city:'TP. Hồ Chí Minh', rating:4.9, jobs:1240, min:'24h', tags:['FDM','Resin SLA','SLS'], grad:'linear-gradient(135deg,#6C5CE7,#A29BFE)', initials:'SP', phone:'090 123 4567', email:'contact@saigonprint.vn', founded:2019, onTime:98 },
  { name:'Hà Nội In Nhanh', city:'Hà Nội', rating:4.8, jobs:980, min:'12h', tags:['SLS','Resin SLA'], grad:'linear-gradient(135deg,#FF6B6B,#FFB347)', initials:'HN', phone:'098 222 1188', email:'lienhe@hanoiinnhanh.vn', founded:2020, onTime:96 },
  { name:'Đà Nẵng Xpress', city:'Đà Nẵng', rating:4.7, jobs:640, min:'24h', tags:['Full-color','FDM'], grad:'linear-gradient(135deg,#00B894,#55EFC4)', initials:'ĐN', phone:'091 555 3344', email:'hotro@danangxpress.vn', founded:2021, onTime:94 },
  { name:'Cần Thơ Print Hub', city:'Cần Thơ', rating:4.6, jobs:410, min:'36h', tags:['SLS','Full-color'], grad:'linear-gradient(135deg,#48A9F8,#6C5CE7)', initials:'CT', phone:'094 777 8899', email:'info@cantho-printhub.vn', founded:2021, onTime:92 },
  { name:'Laser Art Studio', city:'TP. Hồ Chí Minh', rating:4.9, jobs:520, min:'48h', tags:['CNC hậu xử lý','Resin SLA'], grad:'linear-gradient(135deg,#FD79A8,#A29BFE)', initials:'LA', phone:'093 444 2211', email:'hello@laserartstudio.vn', founded:2022, onTime:95 },
  { name:'Hải Phòng Lithophane', city:'Hải Phòng', rating:4.5, jobs:300, min:'48h', tags:['FDM','Full-color'], grad:'linear-gradient(135deg,#FFB347,#FF6B6B)', initials:'HP', phone:'097 666 5522', email:'sales@haiphonglithophane.vn', founded:2022, onTime:90 }
];

/* ============================================================
   YÊU THÍCH — lưu bằng localStorage, chia sẻ giữa các trang
   ============================================================ */
function getFavSuppliers(){
  try{ return JSON.parse(localStorage.getItem('pk_fav_suppliers') || '[]'); }catch(e){ return []; }
}
function setFavSuppliers(arr){ localStorage.setItem('pk_fav_suppliers', JSON.stringify(arr)); }
function isFavoriteSupplier(name){ return getFavSuppliers().includes(name); }
function toggleFavoriteSupplier(name, btn){
  let arr = getFavSuppliers();
  if(arr.includes(name)){
    arr = arr.filter(n=>n!==name);
    toast('Đã bỏ lưu ' + name);
  } else {
    arr.push(name);
    toastOk('Đã lưu ' + name + ' vào Yêu thích');
  }
  setFavSuppliers(arr);
  if(btn) btn.textContent = isFavoriteSupplier(name) ? '♥ Đã lưu' : '♡ Lưu';
}

/* ============================================================
   TÌM KIẾM / DANH SÁCH NCC
   ============================================================ */
let supplierFilter = 'all';

function setSupplierFilter(btn, f){
  supplierFilter = f;
  btn.parentElement.querySelectorAll('.chip').forEach(c=>c.classList.remove('active'));
  btn.classList.add('active');
  renderSuppliers();
}

function renderSuppliers(){
  const input = document.getElementById('supplierSearch');
  const q = (input ? input.value : '').toLowerCase().trim();
  const grid = document.getElementById('supplierGrid');

  const list = suppliers.filter(s=>{
    const matchFilter = supplierFilter === 'all' || s.tags.includes(supplierFilter);
    const matchQuery = !q ||
      s.name.toLowerCase().includes(q) ||
      s.city.toLowerCase().includes(q) ||
      s.tags.some(t=>t.toLowerCase().includes(q));
    return matchFilter && matchQuery;
  });

  if(list.length === 0){
    grid.innerHTML = `<div class="empty-state">
      <div style="font-size:34px; margin-bottom:10px;">🔍</div>
      <strong>Không tìm thấy nhà cung cấp phù hợp</strong>
      <p style="margin-top:6px; font-size:13.5px;">Thử từ khoá khác như "Hà Nội", "FDM" hoặc "SLS"</p>
    </div>`;
    return;
  }

  grid.innerHTML = list.map(s=>`
    <div class="supplier">
      <div class="supplier-top">
        <div class="supplier-logo" style="background:${s.grad}">${s.initials}</div>
        <div>
          <h4>${s.name}</h4>
          <div class="loc">📍 ${s.city}</div>
        </div>
      </div>
      <div class="supplier-meta">
        ${s.tags.map(t=>`<span class="pill">${t}</span>`).join('')}
        <span class="pill teal">⚡ ${s.min}</span>
      </div>
      <div class="supplier-stat">
        <span>Đánh giá <b style="color:var(--amber)">★ ${s.rating}</b></span>
        <span><b>${s.jobs.toLocaleString('vi-VN')}</b> đơn hoàn tất</span>
      </div>
      <div class="supplier-actions">
        <button class="btn-outline" onclick="openSupplierDetail('${s.name}')">Xem chi tiết</button>
        <button class="btn-outline" onclick="toggleFavoriteSupplier('${s.name}', this)">${isFavoriteSupplier(s.name) ? '♥ Đã lưu' : '♡ Lưu'}</button>
        <a class="btn-fill" href="lien-he.jsp?chat=${encodeURIComponent(s.name)}">Liên hệ</a>
      </div>
    </div>
  `).join('');
}

/* ============================================================
   XEM CHI TIẾT NHÀ CUNG CẤP
   ============================================================ */
function openSupplierDetail(name){
  const s = suppliers.find(x=>x.name===name);
  if(!s) return;
  document.getElementById('supDetailLogo').style.background = s.grad;
  document.getElementById('supDetailLogo').textContent = s.initials;
  document.getElementById('supDetailName').textContent = s.name;
  document.getElementById('supDetailLoc').textContent = '📍 ' + s.city + ' · Đối tác từ ' + s.founded;
  document.getElementById('supDetailRating').innerHTML = '★★★★★ <span style="color:var(--ink-soft)">' + s.rating + ' · ' + s.jobs.toLocaleString('vi-VN') + ' đơn hoàn tất</span>';
  document.getElementById('supDetailTags').innerHTML = s.tags.map(t=>`<span class="pill">${t}</span>`).join('') + `<span class="pill teal">⚡ Tối thiểu ${s.min}</span>`;
  document.getElementById('supDetailStats').innerHTML = `
    <div class="stat"><b>${s.min}</b><span>Thời gian sản xuất</span></div>
    <div class="stat"><b>${s.onTime}%</b><span>Đúng hạn</span></div>
    <div class="stat"><b>${s.jobs.toLocaleString('vi-VN')}</b><span>Đơn đã hoàn tất</span></div>`;
  document.getElementById('supDetailInfo').innerHTML = `
    <div class="info-row"><span>Điện thoại</span><b>${s.phone}</b></div>
    <div class="info-row"><span>Email</span><b>${s.email}</b></div>
    <div class="info-row"><span>Địa chỉ</span><b>${s.city}</b></div>
    <div class="info-row"><span>Năm hoạt động</span><b>${s.founded}</b></div>
    <div class="info-row"><span>Chứng nhận</span><b>PrintKraft Verified</b></div>`;
  document.getElementById('supDetailContactBtn').setAttribute('href', 'lien-he.jsp?chat=' + encodeURIComponent(s.name));
  document.getElementById('supDetailFavBtn').textContent = isFavoriteSupplier(s.name) ? '♥ Đã lưu vào yêu thích' : '♡ Thêm vào yêu thích';
  document.getElementById('supDetailReviewBtn').setAttribute('onclick', `openSupplierReview('${s.name}')`);
  document.getElementById('supListView').style.display = 'none';
  document.getElementById('supDetailView').style.display = 'block';
  window.scrollTo(0,0);
}
function toggleFavoriteSupplierDetail(name){
  toggleFavoriteSupplier(name);
  document.getElementById('supDetailFavBtn').textContent = isFavoriteSupplier(name) ? '♥ Đã lưu vào yêu thích' : '♡ Thêm vào yêu thích';
}
function backToSuppliers(){
  document.getElementById('supDetailView').style.display = 'none';
  document.getElementById('supListView').style.display = 'block';
  window.scrollTo(0,0);
}

/* ============================================================
   ĐÁNH GIÁ NCC
   ============================================================ */
let currentSupplierForReview = '';
function openSupplierReview(name){
  currentSupplierForReview = name;
  document.getElementById('supRevSub').textContent = 'Đánh giá xưởng: ' + name;
  document.querySelectorAll('#supplierReviewModal .star-input').forEach(si=>{
    si.dataset.value = 0;
    si.querySelectorAll('button').forEach(b=>b.classList.remove('on'));
  });
  document.getElementById('supRevText').value = '';
  openModalById('supplierReviewModal');
}
function submitSupplierReview(){
  const groups = document.querySelectorAll('#supplierReviewModal .star-input');
  let sum = 0, count = 0;
  groups.forEach(g=>{ const v = parseInt(g.dataset.value||0,10); if(v>0){ sum += v; count++; } });
  if(count < groups.length){ toastErr('Vui lòng chấm điểm đầy đủ 3 tiêu chí'); return; }
  const avg = (sum / groups.length).toFixed(1);
  closeAll();
  toastOk('Đã gửi đánh giá ' + avg + '★ cho ' + currentSupplierForReview);
}

/* ============================================================
   STAR INPUT
   ============================================================ */
document.querySelectorAll('.star-input').forEach(si=>{
  si.addEventListener('click', e=>{
    const btn = e.target.closest('button');
    if(!btn) return;
    const v = parseInt(btn.dataset.v, 10);
    si.dataset.value = v;
    si.querySelectorAll('button').forEach(b=>{
      b.classList.toggle('on', parseInt(b.dataset.v,10) <= v);
    });
  });
});

/* ============================================================
   INIT
   ============================================================ */
renderSuppliers();
(function initFromQuery(){
  const params = new URLSearchParams(location.search);
  const sup = params.get('sup');
  if(sup && suppliers.some(s=>s.name === sup)) openSupplierDetail(sup);
})();
</script>
</body>
</html>
