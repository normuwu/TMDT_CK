<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>PrintKraft — Đánh giá nhà cung cấp &amp; sản phẩm</title>
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
        .section { max-width:1280px; margin:0 auto; padding:46px 32px 70px; }
        .section-head { display:flex; justify-content:space-between; align-items:flex-end; margin-bottom:28px; gap:20px; flex-wrap:wrap; }
        .kpi-row { display:grid; grid-template-columns:repeat(4,1fr); gap:16px; margin-bottom:26px; }
        .kpi { background:var(--surface); border:1px solid var(--line); border-radius:var(--r-md); padding:18px 20px; box-shadow:var(--shadow-xs); }
        .kpi .label { font-size:12.5px; color:var(--ink-soft); margin-bottom:8px; }
        .kpi .value { font-family:'Space Grotesk'; font-size:26px; font-weight:700; }
        .kpi .value.amber { color:#9A6200; }
        .kpi .value.coral { color:var(--coral-deep); }
        .toolbar { display:flex; gap:10px; flex-wrap:wrap; margin-bottom:24px; align-items:center; }
        .toolbar input, .toolbar select { border:1.5px solid var(--line-strong); border-radius:999px; padding:10px 16px; font-size:13.5px; outline:none; background:var(--surface); }
        .toolbar input { flex:1; min-width:200px; }
        .toolbar input:focus, .toolbar select:focus { border-color:var(--violet); box-shadow:0 0 0 4px rgba(108,92,231,0.12); }
        .reviews { display:grid; grid-template-columns:repeat(3,1fr); gap:22px; }
        .review {
            background:var(--surface); border:1px solid var(--line); border-radius:var(--r-md); padding:22px; box-shadow:var(--shadow-xs); transition:.2s; position:relative;
        }
        .review:hover { transform:translateY(-4px); box-shadow:var(--shadow-md); }
        .review-tag {
            position:absolute; top:18px; right:18px; font-size:10.5px; font-weight:700; padding:4px 10px; border-radius:999px; background:#EDE9FF; color:var(--violet);
        }
        .review-tag.supplier { background:#E1FBF3; color:#0A7A5E; }
        .review .who { display:flex; align-items:center; gap:12px; margin-bottom:12px; padding-right:80px; }
        .review .who strong { display:block; font-size:14px; }
        .review .who span { font-size:11.5px; color:var(--ink-soft); }
        .review p { font-size:13.5px; color:var(--ink-soft); margin:8px 0 12px; }
        .stars { font-size:14px; color:var(--amber); letter-spacing:1.5px; }
        .avatar {
            width:34px;height:34px;border-radius:50%; background:var(--grad-primary); color:white;
            display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700; flex-shrink:0;
        }
        .pill { display:inline-block; font-size:11.5px; font-weight:600; padding:4px 11px; border-radius:999px; white-space:nowrap; }
        .pill.green { background:#E1FBF3; color:#0A7A5E; }
        .pill.amber { background:#FFF4E0; color:#9A6200; }
        .pill.red { background:#FFE8E8; color:var(--coral-deep); }
        .review-actions { display:flex; gap:14px; flex-wrap:wrap; border-top:1px solid var(--line); padding-top:12px; margin-top:6px; }
        .action-link { font-size:12.5px; font-weight:600; color:var(--violet); cursor:pointer; }
        .action-link:hover { text-decoration:underline; }
        .action-link.danger { color:var(--coral-deep); }
        .empty-state {
            grid-column:1/-1; text-align:center; padding:50px 20px; color:var(--ink-soft);
            border:1.5px dashed var(--line-strong); border-radius:var(--r-md); background:rgba(255,255,255,0.5);
        }
        .modal-box {
            background:var(--cream); border-radius:var(--r-xl); padding:34px; width:520px; max-width:100%;
            position:relative; box-shadow:var(--shadow-lg); transform:translateY(14px) scale(.98); transition:.25s; max-height:92vh; overflow-y:auto; margin:auto;
        }
        .modal-box .sub { font-size:13.5px; color:var(--ink-soft); margin-bottom:22px; }
        .star-input { display:flex; gap:6px; }
        .star-input button { font-size:32px; line-height:1; color:#E4E2EF; transition:.14s; }
        .star-input button.on { color:var(--amber); transform:scale(1.06); }
        .star-input button:hover { transform:scale(1.18); }
        @media (max-width:1080px){
            .reviews { grid-template-columns:repeat(2,1fr); }
            .kpi-row { grid-template-columns:repeat(2,1fr); }
        }
        @media (max-width:640px){
            .reviews { grid-template-columns:1fr; }
            .kpi-row { grid-template-columns:1fr; }
            .section { padding:34px 18px 60px; }
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="active" value="danhgia"/>
</jsp:include>

<main>
    <section class="section">
        <div class="section-head">
            <div>
                <div class="eyebrow-line">Cộng đồng &amp; kiểm duyệt</div>
                <h2>Đánh giá nhà cung cấp &amp; sản phẩm</h2>
                <p>Thêm, sửa, xóa và duyệt đánh giá — thao tác trực tiếp trên từng thẻ bên dưới</p>
            </div>
            <button class="btn-primary" onclick="openReviewModal('add')">＋ Thêm đánh giá</button>
        </div>

        <div class="kpi-row">
            <div class="kpi"><div class="label">Tổng đánh giá</div><div class="value" id="kpiTotal">0</div></div>
            <div class="kpi"><div class="label">Điểm trung bình</div><div class="value" id="kpiAvg">0.0 ★</div></div>
            <div class="kpi"><div class="label">Chờ duyệt</div><div class="value amber" id="kpiPending">0</div></div>
            <div class="kpi"><div class="label">Đã ẩn</div><div class="value coral" id="kpiHidden">0</div></div>
        </div>

        <div class="toolbar">
            <input type="text" id="revSearch" placeholder="Tìm theo tên NCC, sản phẩm hoặc người đánh giá..." oninput="renderReviews()">
            <select id="revTypeFilter" onchange="renderReviews()">
                <option value="all">Tất cả loại</option>
                <option value="supplier">Nhà cung cấp</option>
                <option value="product">Sản phẩm</option>
            </select>
            <select id="revStatusFilter" onchange="renderReviews()">
                <option value="all">Tất cả trạng thái</option>
                <option value="pending">Chờ duyệt</option>
                <option value="approved">Đã duyệt</option>
                <option value="hidden">Đã ẩn</option>
            </select>
        </div>

        <div class="reviews" id="reviewGrid"></div>
    </section>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />


<!-- ===== REVIEW MODAL (Thêm / Sửa) ===== -->
<div class="modal" id="reviewModal">
    <div class="modal-box">
        <button class="modal-close" onclick="closeAll()">✕</button>
        <h3 id="rmTitle">Thêm đánh giá</h3>
        <div class="sub">Áp dụng cho đánh giá nhà cung cấp hoặc sản phẩm</div>

        <div class="form-error" id="rmError">Vui lòng nhập đầy đủ tên đối tượng và nội dung đánh giá.</div>

        <div class="field-row">
            <div class="field"><label>Loại đối tượng</label>
                <select id="rmType">
                    <option value="supplier">Nhà cung cấp</option>
                    <option value="product">Sản phẩm</option>
                </select>
            </div>
            <div class="field"><label>Trạng thái</label>
                <select id="rmStatus">
                    <option value="approved">Đã duyệt</option>
                    <option value="pending">Chờ duyệt</option>
                    <option value="hidden">Đã ẩn</option>
                </select>
            </div>
        </div>
        <div class="field"><label>Tên đối tượng (NCC / sản phẩm)</label>
            <input type="text" id="rmTarget" placeholder="VD: Sài Gòn Print">
        </div>
        <div class="field"><label>Người đánh giá</label>
            <input type="text" id="rmReviewer" placeholder="VD: Nguyễn An">
        </div>
        <div class="field"><label>Số sao</label>
            <div class="star-input" id="rmStars">
                <button type="button" data-v="1">★</button><button type="button" data-v="2">★</button><button type="button" data-v="3">★</button><button type="button" data-v="4">★</button><button type="button" data-v="5">★</button>
            </div>
        </div>
        <div class="field"><label>Nội dung đánh giá</label>
            <textarea id="rmContent" rows="3" placeholder="Nội dung đánh giá..."></textarea>
        </div>

        <div style="display:flex; gap:10px; margin-top:8px;">
            <button class="btn-outline btn-sm" style="flex:1;" onclick="closeAll()">Hủy</button>
            <button class="btn-primary" style="flex:2; padding:12px;" onclick="saveReviewModal()">Lưu đánh giá</button>
        </div>
    </div>
</div>


<script src="<%= request.getContextPath() %>/assets/js/site.js"></script>
<script>
    /* toast, modal, lớp phủ (#overlay) và Esc để đóng: dùng từ assets/js/site.js */
    /* ============================================================
       DỮ LIỆU ĐÁNH GIÁ
       ============================================================ */
    let reviews = [
        { id:1, target:'Sài Gòn Print', type:'supplier', reviewer:'Nguyễn An', rating:5, content:'Giao đúng hẹn, màu in đẹp, xưởng tư vấn nhanh.', status:'approved' },
        { id:2, target:'Mô hình Naruto Uzumaki 15cm', type:'product', reviewer:'Minh Trí', rating:4, content:'Chất lượng ổn, đóng gói tốt, giao lâu hơn dự kiến 1 ngày.', status:'approved' },
        { id:3, target:'Hà Nội In Nhanh', type:'supplier', reviewer:'Quà Tặng Việt', rating:5, content:'Giao gấp 200 chậu cây trong 3 ngày, đúng deadline, giá tốt.', status:'pending' },
        { id:4, target:'Đèn ngủ Lithophane ảnh gia đình', type:'product', reviewer:'The Coffee House X', rating:4, content:'Chia hàng gọn theo 12 điểm, trễ 1 ngày.', status:'pending' },
        { id:5, target:'Đà Nẵng Xpress', type:'supplier', reviewer:'ẩn danh', rating:1, content:'Nội dung spam quảng cáo, không liên quan đến đơn hàng.', status:'hidden' },
        { id:6, target:'Mô hình kiến trúc thu nhỏ', type:'product', reviewer:'Lê Thảo', rating:5, content:'In sắc nét, chi tiết rõ ràng, đóng gói cẩn thận, sẽ ủng hộ tiếp.', status:'approved' }
    ];
    let reviewSeq = reviews.length;
    let editingId = null;

    const STATUS_PILL = { approved:'green', pending:'amber', hidden:'red' };
    const STATUS_LABEL = { approved:'Đã duyệt', pending:'Chờ duyệt', hidden:'Đã ẩn' };
    const TYPE_LABEL = { supplier:'Nhà cung cấp', product:'Sản phẩm' };

    function starStr(n){ return '★'.repeat(n) + '☆'.repeat(5-n); }

    /* ============================================================
       RENDER
       ============================================================ */
    function renderReviews(){
        const grid = document.getElementById('reviewGrid');
        const q = (document.getElementById('revSearch').value || '').toLowerCase().trim();
        const typeF = document.getElementById('revTypeFilter').value;
        const statusF = document.getElementById('revStatusFilter').value;

        const list = reviews.filter(r=>{
            const matchType = typeF === 'all' || r.type === typeF;
            const matchStatus = statusF === 'all' || r.status === statusF;
            const matchQ = !q || r.target.toLowerCase().includes(q) || r.reviewer.toLowerCase().includes(q) || r.content.toLowerCase().includes(q);
            return matchType && matchStatus && matchQ;
        });

        if(list.length === 0){
            grid.innerHTML = `<div class="empty-state">
      <div style="font-size:34px; margin-bottom:10px;">⭐</div>
      <strong>Không có đánh giá nào phù hợp</strong>
    </div>`;
        } else {
            grid.innerHTML = list.map(r=>`
      <div class="review">
        <span class="review-tag ${r.type==='supplier'?'supplier':''}">${TYPE_LABEL[r.type]}</span>
        <div class="who">
          <div class="avatar">${r.reviewer.trim().slice(0,2).toUpperCase()}</div>
          <div>
            <strong>${r.reviewer}</strong>
            <span>${r.target}</span>
          </div>
        </div>
        <div class="stars">${starStr(r.rating)} ${r.rating}</div>
        <p>${r.content}</p>
        <span class="pill ${STATUS_PILL[r.status]}">${STATUS_LABEL[r.status]}</span>
        <div class="review-actions">
          ${r.status === 'pending' ? `<span class="action-link" onclick="setReviewStatus(${r.id},'approved')">Duyệt</span>` : ''}
          ${r.status === 'approved' ? `<span class="action-link" onclick="setReviewStatus(${r.id},'hidden')">Ẩn</span>` : ''}
          ${r.status === 'hidden' ? `<span class="action-link" onclick="setReviewStatus(${r.id},'approved')">Khôi phục</span>` : ''}
          <span class="action-link" onclick="openReviewModal('edit', ${r.id})">Sửa</span>
          <span class="action-link danger" onclick="deleteReview(${r.id})">Xóa</span>
        </div>
      </div>`).join('');
        }

        updateCounters();
    }

    function updateCounters(){
        document.getElementById('kpiTotal').textContent = reviews.length;
        const rated = reviews.filter(r=>r.status !== 'hidden');
        const avg = rated.length ? (rated.reduce((s,r)=>s+r.rating,0) / rated.length) : 0;
        document.getElementById('kpiAvg').textContent = avg.toFixed(1) + ' ★';
        document.getElementById('kpiPending').textContent = reviews.filter(r=>r.status === 'pending').length;
        document.getElementById('kpiHidden').textContent = reviews.filter(r=>r.status === 'hidden').length;
    }

    /* ============================================================
       DUYỆT / XÓA
       ============================================================ */
    function setReviewStatus(id, status){
        const r = reviews.find(x=>x.id === id);
        if(!r) return;
        r.status = status;
        renderReviews();
        const msgs = { approved:'Đã duyệt / khôi phục đánh giá', hidden:'Đã ẩn đánh giá', pending:'Đã chuyển sang chờ duyệt' };
        toastOk(msgs[status] || 'Đã cập nhật trạng thái');
    }

    function deleteReview(id){
        if(!confirm('Xóa đánh giá này khỏi hệ thống?')) return;
        reviews = reviews.filter(r=>r.id !== id);
        renderReviews();
        toast('Đã xóa đánh giá');
    }

    /* ============================================================
       THÊM / SỬA
       ============================================================ */
    let modalRating = 5;
    function setModalRating(v){
        modalRating = v;
        document.querySelectorAll('#rmStars button').forEach(b=>{
            b.classList.toggle('on', parseInt(b.dataset.v,10) <= v);
        });
    }
    document.querySelectorAll('#rmStars button').forEach(b=>{
        b.addEventListener('click', ()=>setModalRating(parseInt(b.dataset.v,10)));
    });

    function openReviewModal(mode, id){
        editingId = null;
        document.getElementById('rmError').classList.remove('show');
        document.getElementById('rmTitle').textContent = mode === 'edit' ? 'Sửa đánh giá' : 'Thêm đánh giá';

        if(mode === 'edit' && id){
            const r = reviews.find(x=>x.id === id);
            if(!r) return;
            editingId = id;
            document.getElementById('rmType').value = r.type;
            document.getElementById('rmStatus').value = r.status;
            document.getElementById('rmTarget').value = r.target;
            document.getElementById('rmReviewer').value = r.reviewer;
            document.getElementById('rmContent').value = r.content;
            setModalRating(r.rating);
        } else {
            document.getElementById('rmType').value = 'supplier';
            document.getElementById('rmStatus').value = 'pending';
            document.getElementById('rmTarget').value = '';
            document.getElementById('rmReviewer').value = '';
            document.getElementById('rmContent').value = '';
            setModalRating(5);
        }
        openModalById('reviewModal');
    }

    function saveReviewModal(){
        const target = document.getElementById('rmTarget').value.trim();
        const type = document.getElementById('rmType').value;
        const reviewer = document.getElementById('rmReviewer').value.trim() || 'ẩn danh';
        const content = document.getElementById('rmContent').value.trim();
        const status = document.getElementById('rmStatus').value;

        if(!target || !content){
            document.getElementById('rmError').classList.add('show');
            return;
        }

        if(editingId){
            const r = reviews.find(x=>x.id === editingId);
            Object.assign(r, { target, type, reviewer, content, status, rating: modalRating });
            toastOk('Đã cập nhật đánh giá');
        } else {
            reviews.unshift({ id: ++reviewSeq, target, type, reviewer, content, status, rating: modalRating });
            toastOk('Đã thêm đánh giá mới');
        }
        closeAll();
        renderReviews();
    }

    /* ============================================================
       INIT
       ============================================================ */
    renderReviews();
</script>
</body>
</html>
