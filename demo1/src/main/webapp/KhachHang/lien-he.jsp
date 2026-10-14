<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>PrintKraft — Liên hệ khách hàng / Admin</title>
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
  .btn-fill{background:var(--grad-primary); color:white; box-shadow:0 8px 18px rgba(108,92,231,0.28);}
  .btn-fill:hover{transform:translateY(-2px);}
  .btn-sm{padding:9px 16px; font-size:13px; border-radius:9px;}

  .section{max-width:1180px; margin:0 auto; padding:46px 32px 70px;}
  .section-head{display:flex; justify-content:space-between; align-items:flex-end; margin-bottom:32px; gap:20px; flex-wrap:wrap;}
  .section-head h2{font-size:32px;}
  .section-head p{color:var(--ink-soft); font-size:14px; margin-top:8px;}
  .eyebrow-line{display:inline-block; font-size:12px; font-weight:700; letter-spacing:.12em; text-transform:uppercase; color:var(--violet); margin-bottom:10px;}

  .avatar{width:34px;height:34px;border-radius:50%; background:var(--grad-primary); color:white;
    display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700; flex-shrink:0;}

  /* ===== Chat ===== */
  .chat-shell{display:grid; grid-template-columns:280px 1fr; background:var(--surface); border:1px solid var(--line); border-radius:var(--r-lg); overflow:hidden; box-shadow:var(--shadow-sm); min-height:560px;}
  .chat-contacts{border-right:1px solid var(--line); overflow-y:auto;}
  .chat-contact{display:flex; gap:11px; align-items:center; padding:15px 16px; border-bottom:1px solid var(--line); cursor:pointer; transition:.15s;}
  .chat-contact:hover{background:#FBF9FF;}
  .chat-contact.active{background:#F3F0FF;}
  .chat-contact .name{font-size:13.6px; font-weight:600;}
  .chat-contact .last{font-size:11.8px; color:var(--ink-soft); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; max-width:170px;}
  .chat-window{display:flex; flex-direction:column; min-width:0;}
  .chat-head{padding:16px 20px; border-bottom:1px solid var(--line); display:flex; align-items:center; gap:12px;}
  .chat-head .name{font-size:14.5px; font-weight:700;}
  .chat-head .status{font-size:11.8px; color:var(--teal);}
  .chat-body{flex:1; padding:22px; display:flex; flex-direction:column; gap:12px; background:#FAFAFD; overflow-y:auto; max-height:460px;}
  .msg{max-width:66%; padding:12px 15px; border-radius:15px; background:var(--surface); border:1px solid var(--line); font-size:13.6px; line-height:1.5;}
  .msg .t{display:block; font-size:10.8px; color:var(--ink-soft); margin-top:6px;}
  .msg.me{align-self:flex-end; background:var(--grad-primary); color:white; border:0;}
  .msg.me .t{color:rgba(255,255,255,0.75);}
  .chat-input-row{display:flex; gap:10px; padding:15px; border-top:1px solid var(--line);}
  .chat-input-row input{flex:1; border:1.5px solid var(--line-strong); border-radius:999px; padding:11px 18px; font-size:13.8px; outline:none;}
  .chat-input-row input:focus{border-color:var(--violet); box-shadow:0 0 0 4px rgba(108,92,231,0.12);}

  .toast{position:fixed; bottom:28px; left:50%; transform:translate(-50%, 100px); background:var(--ink); color:var(--cream);
    padding:14px 24px; border-radius:999px; font-size:13.5px; font-weight:500; z-index:300; transition:.3s cubic-bezier(.4,0,.2,1); opacity:0; box-shadow:var(--shadow-lg); max-width:90vw; text-align:center;}
  .toast.show{transform:translate(-50%,0); opacity:1;}
  .toast.ok{background:linear-gradient(135deg,#00B894,#0A7A5E);}

  @media (max-width:900px){ header{padding:10px 18px;} .utility{padding:8px 18px;} .chat-shell{grid-template-columns:1fr; min-height:0;} .chat-contacts{max-height:220px;} }
  @media (max-width:640px){ .section{padding:34px 18px 60px;} }
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
      <a href="lien-he.jsp" class="active">Liên hệ</a>
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
          <div class="eyebrow-line">Hộp thư</div>
          <h2>Liên hệ khách hàng / Admin</h2>
          <p>Trao đổi trực tiếp với nhà cung cấp hoặc đội ngũ hỗ trợ PrintKraft</p>
        </div>
      </div>

      <div class="chat-shell">
        <aside class="chat-contacts" id="chatContactList"></aside>
        <div class="chat-window">
          <div class="chat-head">
            <div>
              <div class="name" id="chatHeadName">PrintKraft Support</div>
              <div class="status" id="chatHeadRole">Đội ngũ hỗ trợ · Admin</div>
            </div>
          </div>
          <div class="chat-body" id="chatBody"></div>
          <div class="chat-input-row">
            <input type="text" id="chatInput" placeholder="Nhập tin nhắn..." onkeydown="if(event.key==='Enter') sendChatMessage()">
            <button class="btn-fill btn-sm" onclick="sendChatMessage()">Gửi</button>
          </div>
        </div>
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

/* ============================================================
   DỮ LIỆU HỘI THOẠI
   ============================================================ */
const chatContacts = [
  { name:'PrintKraft Support', role:'Đội ngũ hỗ trợ · Admin', initials:'AD', grad:'var(--grad-cool)',
    messages:[
      {me:false, text:'Chào bạn, PrintKraft có thể hỗ trợ gì cho đơn hàng của bạn?', t:'Hôm qua'},
      {me:true,  text:'Mình muốn hỏi về đơn #PK-08228, khi nào giao vậy ạ?', t:'Hôm qua'},
      {me:false, text:'Đơn của bạn dự kiến giao trước 18/09, mình sẽ cập nhật khi có tiến độ mới.', t:'Hôm qua'}
    ]},
  { name:'Sài Gòn Print', role:'Nhà cung cấp · Đơn #PK-08228', initials:'SP', grad:'var(--grad-primary)',
    messages:[
      {me:false, text:'Chào bạn, file thiết kế đã được kiểm tra. Xưởng có thể sản xuất 100 mô hình trong 3 ngày.', t:'10:12'},
      {me:true,  text:'Cảm ơn xưởng. Bạn xác nhận giúp mình thời gian giao dự kiến nhé.', t:'10:15'},
      {me:false, text:'Dự kiến giao trước 18/09. Mình sẽ cập nhật trạng thái trên hệ thống.', t:'10:20'}
    ]},
  { name:'Hà Nội In Nhanh', role:'Nhà cung cấp · Báo giá', initials:'HN', grad:'var(--grad-warm)',
    messages:[
      {me:false, text:'Chào bạn, báo giá 50 mô hình là 289.000đ/chiếc, đã gồm in logo 1 màu.', t:'2 ngày trước'}
    ]}
];

let activeChatIndex = 0;

function renderChat(){
  const list = document.getElementById('chatContactList');
  if(!list) return;
  list.innerHTML = chatContacts.map((c,i)=>`
    <div class="chat-contact ${i===activeChatIndex?'active':''}" onclick="selectChatContact(${i})">
      <div class="avatar" style="width:38px;height:38px;font-size:13px;background:${c.grad}">${c.initials}</div>
      <div style="min-width:0;">
        <div class="name">${c.name}</div>
        <div class="last">${c.messages[c.messages.length-1].text}</div>
      </div>
    </div>`).join('');
  renderChatWindow();
}

function selectChatContact(i){
  activeChatIndex = i;
  renderChat();
}

function renderChatWindow(){
  const c = chatContacts[activeChatIndex];
  document.getElementById('chatHeadName').textContent = c.name;
  document.getElementById('chatHeadRole').textContent = c.role;
  const body = document.getElementById('chatBody');
  body.innerHTML = c.messages.map(m=>`
    <div class="msg ${m.me?'me':''}">${m.text}<span class="t">${m.t}</span></div>`).join('');
  body.scrollTop = body.scrollHeight;
}

function sendChatMessage(){
  const input = document.getElementById('chatInput');
  const text = input.value.trim();
  if(!text) return;
  const c = chatContacts[activeChatIndex];
  c.messages.push({me:true, text, t:'Vừa xong'});
  input.value = '';
  renderChat();
  setTimeout(()=>{
    c.messages.push({me:false, text:'Đã nhận được tin nhắn của bạn, chúng tôi sẽ phản hồi trong ít phút.', t:'Vừa xong'});
    renderChat();
  }, 900);
}

/* ============================================================
   INIT — mở đúng hội thoại nếu có ?chat=Tên
   ============================================================ */
(function initChat(){
  const params = new URLSearchParams(location.search);
  const target = params.get('chat');
  if(target){
    let idx = chatContacts.findIndex(c=>c.name === target);
    if(idx < 0){
      // Tạo hội thoại mới cho nhà cung cấp được chọn từ trang danh sách
      chatContacts.push({
        name: target, role:'Nhà cung cấp', initials: target.trim().slice(0,2).toUpperCase(),
        grad:'var(--grad-primary)',
        messages:[{me:false, text:'Chào bạn, mình là đại diện ' + target + '. Bạn cần tư vấn gì ạ?', t:'Vừa xong'}]
      });
      idx = chatContacts.length - 1;
    }
    activeChatIndex = idx;
  }
  renderChat();
})();
</script>
</body>
</html>
