<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>PrintKraft — Phản hồi khách hàng</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
    <style>
        /* CSS riêng của trang. Phần dùng chung (header, footer, nút, modal, toast...) nằm trong assets/css/site.css */
        .btn-outline { border:1.5px solid var(--line-strong); background:var(--surface); }
        .btn-outline:hover { border-color:var(--violet); color:var(--violet); }
        .btn-sm { padding:9px 16px; font-size:13px; border-radius:9px; }
        .section { max-width:1180px; margin:0 auto; padding:46px 32px 70px; }
        .quote-form { background:var(--surface); border:1px solid var(--line); border-radius:var(--r-lg); padding:28px; box-shadow:var(--shadow-md); }
        .quote-form h4 { font-size:19px; margin-bottom:18px; }
        .dropzone {
            border:1.5px dashed var(--line-strong); border-radius:var(--r-sm); padding:22px; text-align:center; font-size:13.5px; color:var(--ink-soft); background:#FBF9FF; cursor:pointer;
        }
        .dropzone b { color:var(--violet); cursor:pointer; }
        .info-card { background:var(--surface); border:1px solid var(--line); border-radius:var(--r-lg); padding:22px; box-shadow:var(--shadow-xs); }
        .fb-item { display:flex; justify-content:space-between; align-items:flex-start; gap:14px; padding:16px 0; border-bottom:1px solid var(--line); }
        .fb-item:last-child { border-bottom:0; }
        .fb-item .ttl { font-size:14px; font-weight:600; }
        .fb-item .meta { font-size:12px; color:var(--ink-soft); margin-top:3px; }
        .pill {
            display:inline-block; font-size:11.5px; font-weight:600; padding:4px 11px; border-radius:999px; background:#F2EFFF; color:var(--violet); white-space:nowrap;
        }
        .pill.teal { background:#E1FBF3; color:#0A7A5E; }
        .pill.amber { background:#FFF4E0; color:#9A6200; }
        .pill.coral { background:#FFE8E8; color:var(--coral-deep); }
        .empty-state { text-align:center; padding:34px 20px; color:var(--ink-soft); }
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

<jsp:include page="/WEB-INF/views/common/footer.jsp" />


<script src="<%= request.getContextPath() %>/assets/js/site.js"></script>
<script>
    /* toast, modal, lớp phủ (#overlay) và Esc để đóng: dùng từ assets/js/site.js */
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
