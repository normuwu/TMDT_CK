<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>PrintKraft — Danh mục yêu thích</title>
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
  .btn-outline{border:1.5px solid var(--line-strong); background:var(--surface);}
  .btn-outline:hover{border-color:var(--violet); color:var(--violet);}
  .btn-fill{background:var(--grad-primary); color:white; box-shadow:0 8px 18px rgba(108,92,231,0.28);}
  .btn-sm{padding:9px 16px; font-size:13px; border-radius:9px;}

  .section{max-width:1280px; margin:0 auto; padding:46px 32px 70px;}
  .section-head{display:flex; justify-content:space-between; align-items:flex-end; margin-bottom:32px; gap:20px; flex-wrap:wrap;}
  .section-head h2{font-size:32px;}
  .section-head p{color:var(--ink-soft); font-size:14px; margin-top:8px;}
  .eyebrow-line{display:inline-block; font-size:12px; font-weight:700; letter-spacing:.12em; text-transform:uppercase; color:var(--violet); margin-bottom:10px;}

  .grid{display:grid; grid-template-columns:repeat(4, 1fr); gap:22px;}
  .card{background:var(--surface); border:1px solid var(--line); border-radius:var(--r-md); overflow:hidden; position:relative; box-shadow:var(--shadow-xs); transition:.22s;}
  .card:hover{transform:translateY(-6px); box-shadow:var(--shadow-md); border-color:transparent;}
  .card-thumb{height:150px; display:flex; align-items:center; justify-content:center; font-family:'Space Grotesk'; font-weight:700; font-size:30px; color:white;}
  .card-body{padding:16px;}
  .card-body h4{font-size:15px; font-weight:600; margin-bottom:4px;}
  .card-body .meta{font-size:12.5px; color:var(--ink-soft); margin-bottom:8px;}
  .stars{font-size:12px; color:var(--amber); letter-spacing:1.5px;}
  .empty-state{grid-column:1/-1; text-align:center; padding:50px 20px; color:var(--ink-soft);
    border:1.5px dashed var(--line-strong); border-radius:var(--r-md); background:rgba(255,255,255,0.5);}

  .fav-tabs{display:flex; gap:8px; margin-bottom:22px; flex-wrap:wrap;}
  .fav-tabs button{border:1.5px solid var(--line-strong); background:var(--surface); padding:9px 16px; border-radius:999px; font-size:13.5px; font-weight:600; transition:.18s;}
  .fav-tabs button:hover{border-color:var(--violet); color:var(--violet);}
  .fav-tabs button.active{background:var(--grad-primary); color:white; border-color:transparent;}
  .fav-card{position:relative;}
  .fav-remove{position:absolute; top:12px; right:12px; width:32px; height:32px; border-radius:50%; background:rgba(255,255,255,0.92); color:var(--coral-deep); display:flex; align-items:center; justify-content:center; font-size:15px; box-shadow:var(--shadow-xs); transition:.18s;}
  .fav-remove:hover{background:var(--coral); color:white;}
  .card-actions{display:flex; gap:8px; margin-top:12px;}
  .card-actions a, .card-actions button{flex:1; padding:9px; border-radius:9px; font-size:12.5px; font-weight:600; text-align:center;}

  .toast{position:fixed; bottom:28px; left:50%; transform:translate(-50%, 100px); background:var(--ink); color:var(--cream);
    padding:14px 24px; border-radius:999px; font-size:13.5px; font-weight:500; z-index:300; transition:.3s cubic-bezier(.4,0,.2,1); opacity:0; box-shadow:var(--shadow-lg); max-width:90vw; text-align:center;}
  .toast.show{transform:translate(-50%,0); opacity:1;}
  .toast.ok{background:linear-gradient(135deg,#00B894,#0A7A5E);}
  .toast.err{background:linear-gradient(135deg,#FF6B6B,#C0392B);}

  @media (max-width:1080px){ .grid{grid-template-columns:repeat(3,1fr);} }
  @media (max-width:900px){ header{padding:10px 18px;} .utility{padding:8px 18px;} .grid{grid-template-columns:repeat(2,1fr);} }
  @media (max-width:640px){ .grid{grid-template-columns:1fr;} .section{padding:34px 18px 60px;} }
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
      <a href="tim-kiem-nha-cung-cap.jsp">Nhà cung cấp</a>
      <a href="danh-muc-yeu-thich.jsp" class="active">Yêu thích</a>
      <a href="lien-he.jsp">Liên hệ</a>
      <a href="phan-hoi.jsp">Phản hồi</a>
      <a href="danh-gia.jsp">Đánh giá</a>
    </nav>
    <div class="head-actions">
      <a class="btn-outline btn-sm" href="trang_chu.jsp">← Trang chủ</a>
    </div>
  </header>

  <main>
    <section class="section">
      <div class="section-head">
        <div>
          <div class="eyebrow-line">Đã lưu</div>
          <h2>Danh mục yêu thích</h2>
          <p>Nhà cung cấp và sản phẩm bạn đã lưu để xem lại nhanh</p>
        </div>
      </div>

      <div class="fav-tabs">
        <button class="active" onclick="setFavFilter(this,'all')">Tất cả</button>
        <button onclick="setFavFilter(this,'supplier')">Nhà cung cấp</button>
        <button onclick="setFavFilter(this,'product')">Sản phẩm</button>
      </div>

      <div class="grid" id="favGrid"></div>
    </section>
  </main>

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

/* ============================================================
   DỮ LIỆU
   ============================================================ */
const suppliers = [
  { name:'Sài Gòn Print', city:'TP. Hồ Chí Minh', rating:4.9, grad:'linear-gradient(135deg,#6C5CE7,#A29BFE)', initials:'SP' },
  { name:'Hà Nội In Nhanh', city:'Hà Nội', rating:4.8, grad:'linear-gradient(135deg,#FF6B6B,#FFB347)', initials:'HN' },
  { name:'Đà Nẵng Xpress', city:'Đà Nẵng', rating:4.7, grad:'linear-gradient(135deg,#00B894,#55EFC4)', initials:'ĐN' },
  { name:'Cần Thơ Print Hub', city:'Cần Thơ', rating:4.6, grad:'linear-gradient(135deg,#48A9F8,#6C5CE7)', initials:'CT' },
  { name:'Laser Art Studio', city:'TP. Hồ Chí Minh', rating:4.9, grad:'linear-gradient(135deg,#FD79A8,#A29BFE)', initials:'LA' },
  { name:'Hải Phòng Lithophane', city:'Hải Phòng', rating:4.5, grad:'linear-gradient(135deg,#FFB347,#FF6B6B)', initials:'HP' }
];

const products = [
  { name:'Mô hình Naruto Uzumaki 15cm', price:'129.000đ', grad:'var(--grad-primary)', initials:'📦' },
  { name:'Đèn ngủ Lithophane ảnh gia đình', price:'89.000đ', grad:'var(--grad-cool)', initials:'💡' },
  { name:'Chậu cây mini họa tiết hình học', price:'65.000đ', grad:'var(--grad-warm)', initials:'🪴' },
  { name:'Khung ảnh in 3D viền hoa văn', price:'42.000đ', grad:'linear-gradient(135deg,#1B1B2F,#4A4A6A)', initials:'🖼️' }
];

/* ============================================================
   YÊU THÍCH — localStorage (chia sẻ với trang NCC)
   ============================================================ */
const DEF_SUPPLIERS = ['Sài Gòn Print'];
const DEF_PRODUCTS = ['Mô hình Naruto Uzumaki 15cm','Đèn ngủ Lithophane ảnh gia đình'];

function read(key, def){
  const raw = localStorage.getItem(key);
  if(raw === null){ localStorage.setItem(key, JSON.stringify(def)); return def.slice(); }
  try{ return JSON.parse(raw) || []; }catch(e){ return []; }
}
function write(key, arr){ localStorage.setItem(key, JSON.stringify(arr)); }

function getFavSuppliers(){ return read('pk_fav_suppliers', DEF_SUPPLIERS); }
function getFavProducts(){ return read('pk_fav_products', DEF_PRODUCTS); }
function removeFavSupplier(name){
  write('pk_fav_suppliers', getFavSuppliers().filter(n=>n!==name));
  renderFavorites();
  toast('Đã bỏ lưu ' + name);
}
function removeFavProduct(name){
  write('pk_fav_products', getFavProducts().filter(n=>n!==name));
  renderFavorites();
  toastOk('Đã bỏ khỏi Yêu thích');
}

/* ============================================================
   RENDER
   ============================================================ */
let favFilter = 'all';
function setFavFilter(btn, f){
  favFilter = f;
  btn.parentElement.querySelectorAll('button').forEach(b=>b.classList.remove('active'));
  btn.classList.add('active');
  renderFavorites();
}

function renderFavorites(){
  const wrap = document.getElementById('favGrid');
  if(!wrap) return;

  const supList = getFavSuppliers().map(n=>suppliers.find(s=>s.name===n)).filter(Boolean);
  const prodList = getFavProducts().map(n=>products.find(p=>p.name===n)).filter(Boolean);

  let html = '';
  if(favFilter !== 'product'){
    html += supList.map(s=>`
      <div class="card fav-card">
        <div class="card-thumb" style="background:${s.grad}">${s.initials}</div>
        <div class="card-body">
          <h4>${s.name}</h4>
          <div class="meta">Nhà cung cấp · ${s.city}</div>
          <div class="stars">★★★★★ ${s.rating}</div>
          <div class="card-actions">
            <a class="btn-outline" href="tim-kiem-nha-cung-cap.jsp?sup=${encodeURIComponent(s.name)}">Xem chi tiết</a>
            <a class="btn-fill" href="lien-he.jsp?chat=${encodeURIComponent(s.name)}">Liên hệ</a>
          </div>
        </div>
        <button class="fav-remove" title="Bỏ lưu" onclick="removeFavSupplier('${s.name}')">✕</button>
      </div>`).join('');
  }
  if(favFilter !== 'supplier'){
    html += prodList.map(p=>`
      <div class="card fav-card">
        <div class="card-thumb" style="background:${p.grad}">${p.initials}</div>
        <div class="card-body">
          <h4>${p.name}</h4>
          <div class="meta">Sản phẩm · ${p.price}</div>
          <div class="stars">★★★★★</div>
          <div class="card-actions">
            <a class="btn-outline" href="danh-gia.jsp">Xem đánh giá</a>
          </div>
        </div>
        <button class="fav-remove" title="Bỏ lưu" onclick="removeFavProduct('${p.name}')">✕</button>
      </div>`).join('');
  }

  wrap.innerHTML = html || `<div class="empty-state">
    <div style="font-size:34px; margin-bottom:10px;">♡</div>
    <strong>Chưa có mục yêu thích nào</strong>
    <p style="margin-top:6px; font-size:13.5px;">Nhấn biểu tượng trái tim trên nhà cung cấp hoặc sản phẩm để lưu lại.</p>
  </div>`;
}

/* ============================================================
   INIT
   ============================================================ */
renderFavorites();
</script>
</body>
</html>
