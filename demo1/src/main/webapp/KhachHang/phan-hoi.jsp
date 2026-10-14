<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>PrintKraft — Phản hồi khách hàng</title>
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
  .btn-sm{padding:9px 16px; font-size:13px; border-radius:9px;}

  .section{max-width:1180px; margin:0 auto; padding:46px 32px 70px;}
  .section-head{display:flex; justify-content:space-between; align-items:flex-end; margin-bottom:32px; gap:20px; flex-wrap:wrap;}
  .section-head h2{font-size:32px;}
  .section-head p{color:var(--ink-soft); font-size:14px; margin-top:8px;}
  .eyebrow-line{display:inline-block; font-size:12px; font-weight:700; letter-spacing:.12em; text-transform:uppercase; color:var(--violet); margin-bottom:10px;}

  .field{margin-bottom:14px;}
  .field label{display:block; font-size:12.5px; font-weight:600; margin-bottom:6px; color:var(--ink-soft);}
  .field input, .field select, .field textarea{width:100%; border:1.5px solid var(--line); border-radius:var(--r-sm); padding:12px 14px;
    font-size:14px; background:#FBF9FF; outline:none; transition:.18s; color:var(--ink);}
  .field input:focus, .field select:focus, .field textarea:focus{border-color:var(--violet); background:white; box-shadow:0 0 0 4px rgba(108,92,231,0.12);}
  .field-row{display:grid; grid-template-columns:1fr 1fr; gap:14px;}
  .quote-form{background:var(--surface); border:1px solid var(--line); border-radius:var(--r-lg); padding:28px; box-shadow:var(--shadow-md);}
  .quote-form h4{font-size:19px; margin-bottom:18px;}
  .dropzone{border:1.5px dashed var(--line-strong); border-radius:var(--r-sm); padding:22px; text-align:center; font-size:13.5px; color:var(--ink-soft); background:#FBF9FF; cursor:pointer;}
  .dropzone b{color:var(--violet); cursor:pointer;}

  .info-card{background:var(--surface); border:1px solid var(--line); border-radius:var(--r-lg); padding:22px; box-shadow:var(--shadow-xs);}
  .fb-item{display:flex; justify-content:space-between; align-items:flex-start; gap:14px; padding:16px 0; border-bottom:1px solid var(--line);}
  .fb-item:last-child{border-bottom:0;}
  .fb-item .ttl{font-size:14px; font-weight:600;}
  .fb-item .meta{font-size:12px; color:var(--ink-soft); margin-top:3px;}
  .pill{display:inline-block; font-size:11.5px; font-weight:600; padding:4px 11px; border-radius:999px; background:#F2EFFF; color:var(--violet); white-space:nowrap;}
  .pill.teal{background:#E1FBF3; color:#0A7A5E;}
  .pill.amber{background:#FFF4E0; color:#9A6200;}
  .pill.coral{background:#FFE8E8; color:var(--coral-deep);}
  .empty-state{text-align:center; padding:34px 20px; color:var(--ink-soft);}

  .toast{position:fixed; bottom:28px; left:50%; transform:translate(-50%, 100px); background:var(--ink); color:var(--cream);
    padding:14px 24px; border-radius:999px; font-size:13.5px; font-weight:500; z-index:300; transition:.3s cubic-bezier(.4,0,.2,1); opacity:0; box-shadow:var(--shadow-lg); max-width:90vw; text-align:center;}
  .toast.show{transform:translate(-50%,0); opacity:1;}
  .toast.ok{background:linear-gradient(135deg,#00B894,#0A7A5E);}
  .toast.err{background:linear-gradient(135deg,#FF6B6B,#C0392B);}

  @media (max-width:900px){ header{padding:10px 18px;} .utility{padding:8px 18px;} }
  @media (max-width:640px){ .section{padding:34px 18px 60px;} .field-row{grid-template-columns:1fr;} }
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
      <a href="danh-muc-yeu-thich.jsp">Yêu thích</a>
      <a href="lien-he.jsp">Liên hệ</a>
      <a href="phan-hoi.jsp" class="active">Phản hồi</a>
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
          <div class="eyebrow-line">Hỗ trợ</div>
          <h2>Phản hồi khách hàng</h2>
          <p>Gửi phản hồi, báo lỗi hoặc yêu cầu hỗ trợ tới đội ngũ PrintKraft</p>
        </div>
      </div>

      <div class="quote-form" style="max-width:720px;">
        <h4>Gửi phản hồi mới</h4>
        <div class="field-row">
          <div class="field"><label>Loại phản hồi</label>
            <select id="fbType">
              <option>Khiếu nại đơn hàng</option>
              <option>Góp ý dịch vụ</option>
              <option>Báo lỗi hệ thống</option>
              <option>Yêu cầu hỗ trợ</option>
            </select>
          </div>
          <div class="field"><label>Mã đơn hàng (nếu có)</label><input type="text" id="fbOrder" placeholder="#PK-08228"></div>
        </div>
        <div class="field"><label>Tiêu đề</label><input type="text" id="fbTitle" placeholder="Tóm tắt vấn đề bạn muốn phản hồi"></div>
        <div class="field"><label>Nội dung</label><textarea id="fbContent" rows="4" placeholder="Mô tả chi tiết vấn đề, thời gian xảy ra và mong muốn của bạn..."></textarea></div>
        <div class="field"><label>Đính kèm</label><div class="dropzone" onclick="toast('Đã mở hộp thoại chọn tệp')">📎 Kéo thả ảnh / tệp vào đây hoặc <b>chọn tệp</b></div></div>
        <button class="btn-primary" onclick="submitFeedback()">Gửi phản hồi</button>
      </div>

      <div class="info-card" style="max-width:720px; margin-top:26px;">
        <h4 style="font-size:16px; margin-bottom:6px;">Lịch sử phản hồi</h4>
        <div id="feedbackList"></div>
      </div>
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
function toastErr(msg){ toast(msg, 'err'); }

/* ============================================================
   PHẢN HỒI KHÁCH HÀNG
   ============================================================ */
const feedbackHistory = [
  { id:'TK-1842', title:'Chậm giao hàng', date:'14/09/2026', status:'Đang xử lý' },
  { id:'TK-1790', title:'Hỏi về file thiết kế', date:'08/09/2026', status:'Đã giải quyết' }
];

function renderFeedbackHistory(){
  const wrap = document.getElementById('feedbackList');
  if(!wrap) return;
  if(feedbackHistory.length === 0){
    wrap.innerHTML = `<div class="empty-state">Chưa có phản hồi nào</div>`;
    return;
  }
  wrap.innerHTML = feedbackHistory.map(f=>{
    const pillClass = f.status==='Đã giải quyết' ? 'teal' : (f.status==='Đang xử lý' ? 'amber' : 'coral');
    return `<div class="fb-item">
      <div><div class="ttl">#${f.id} · ${f.title}</div><div class="meta">Gửi ${f.date}</div></div>
      <span class="pill ${pillClass}">${f.status}</span>
    </div>`;
  }).join('');
}

function submitFeedback(){
  const order = document.getElementById('fbOrder').value.trim();
  const title = document.getElementById('fbTitle').value.trim();
  const content = document.getElementById('fbContent').value.trim();
  if(!title || !content){ toastErr('Vui lòng nhập tiêu đề và nội dung phản hồi'); return; }
  const id = 'TK-' + (1800 + Math.floor(Math.random()*200));
  feedbackHistory.unshift({ id, title: title + (order ? ' (' + order + ')' : ''), date:'Hôm nay', status:'Đang xử lý' });
  document.getElementById('fbTitle').value = '';
  document.getElementById('fbContent').value = '';
  document.getElementById('fbOrder').value = '';
  renderFeedbackHistory();
  toastOk('Đã gửi phản hồi #' + id + ' — PrintKraft sẽ phản hồi trong 24 giờ');
}

/* ============================================================
   INIT
   ============================================================ */
renderFeedbackHistory();
</script>
</body>
</html>
