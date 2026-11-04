<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>PrintKraft — Liên hệ khách hàng / Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
    <style>
        /* CSS riêng của trang. Phần dùng chung (header, footer, nút, modal, toast...) nằm trong assets/css/site.css */
        .btn-outline { border:1.5px solid var(--line-strong); background:var(--surface); }
        .btn-outline:hover { border-color:var(--violet); color:var(--violet); }
        .btn-fill { background:var(--grad-primary); color:white; box-shadow:0 8px 18px rgba(108,92,231,0.28); }
        .btn-fill:hover { transform:translateY(-2px); }
        .btn-sm { padding:9px 16px; font-size:13px; border-radius:9px; }
        .section { max-width:1180px; margin:0 auto; padding:46px 32px 70px; }
        .avatar {
            width:34px;height:34px;border-radius:50%; background:var(--grad-primary); color:white;
            display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700; flex-shrink:0;
        }

        /* ===== Chat ===== */
        .chat-shell {
            display:grid; grid-template-columns:280px 1fr; background:var(--surface); border:1px solid var(--line); border-radius:var(--r-lg); overflow:hidden; box-shadow:var(--shadow-sm); min-height:560px;
        }
        .chat-contacts { border-right:1px solid var(--line); overflow-y:auto; }
        .chat-contact { display:flex; gap:11px; align-items:center; padding:15px 16px; border-bottom:1px solid var(--line); cursor:pointer; transition:.15s; }
        .chat-contact:hover { background:#FBF9FF; }
        .chat-contact.active { background:#F3F0FF; }
        .chat-contact .name { font-size:13.6px; font-weight:600; }
        .chat-contact .last { font-size:11.8px; color:var(--ink-soft); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; max-width:170px; }
        .chat-window { display:flex; flex-direction:column; min-width:0; }
        .chat-head { padding:16px 20px; border-bottom:1px solid var(--line); display:flex; align-items:center; gap:12px; }
        .chat-head .name { font-size:14.5px; font-weight:700; }
        .chat-head .status { font-size:11.8px; color:var(--teal); }
        .chat-body { flex:1; padding:22px; display:flex; flex-direction:column; gap:12px; background:#FAFAFD; overflow-y:auto; max-height:460px; }
        .msg { max-width:66%; padding:12px 15px; border-radius:15px; background:var(--surface); border:1px solid var(--line); font-size:13.6px; line-height:1.5; }
        .msg .t { display:block; font-size:10.8px; color:var(--ink-soft); margin-top:6px; }
        .msg.me { align-self:flex-end; background:var(--grad-primary); color:white; border:0; }
        .msg.me .t { color:rgba(255,255,255,0.75); }
        .chat-input-row { display:flex; gap:10px; padding:15px; border-top:1px solid var(--line); }
        .chat-input-row input { flex:1; border:1.5px solid var(--line-strong); border-radius:999px; padding:11px 18px; font-size:13.8px; outline:none; }
        .chat-input-row input:focus { border-color:var(--violet); box-shadow:0 0 0 4px rgba(108,92,231,0.12); }
        @media (max-width:900px){
            .chat-shell { grid-template-columns:1fr; min-height:0; }
            .chat-contacts { max-height:220px; }
        }
        @media (max-width:640px){
            .section { padding:34px 18px 60px; }
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="active" value="faq"/>
</jsp:include>

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

<jsp:include page="/WEB-INF/views/common/footer.jsp" />


<script src="<%= request.getContextPath() %>/assets/js/site.js"></script>
<script>
    /* toast, modal, lớp phủ (#overlay) và Esc để đóng: dùng từ assets/js/site.js */
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
