<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>PrintKraft — Trả hàng &amp; Hoàn tiền</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
    <style>
        /* CSS riêng của trang Trả hàng & Hoàn tiền (phần chung đã nằm trong site.css) */
        .main-content { max-width: 1100px; margin: 40px auto; padding: 0 32px; min-height: 60vh; }

        /* Nút nhỏ hơn mặc định của site.css, chỉ áp dụng trong trang này */
        .main-content .btn-primary { padding: 12px 24px; font-size: 14px; }
        .main-content .btn-secondary { padding: 8px 16px; font-size: 13px; }
        .chat-input-area .btn-secondary { padding: 8px 16px; font-size: 13px; }

        /* Hộp modal của trang này */
        #reqModal .modal-box, #chatModal .modal-box {
            background: var(--surface); border-radius: var(--r-lg); padding: 32px; width: 520px;
            box-shadow: var(--shadow-md);
        }

        /* Chat UI */
        .chat-box { display: flex; flex-direction: column; height: 500px; background: #F8FAFC; border-radius: var(--r-md); border: 1px solid var(--line); overflow: hidden; margin-top: 20px; text-align: left; }
        .chat-messages { flex: 1; padding: 20px; overflow-y: auto; display: flex; flex-direction: column; gap: 16px; }
        .chat-msg { display: flex; gap: 12px; max-width: 85%; }
        .chat-msg.self { align-self: flex-end; flex-direction: row-reverse; }
        .chat-avatar { width: 36px; height: 36px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 700; color: white; flex-shrink: 0; box-shadow: var(--shadow-xs); }
        .chat-avatar.kh { background: linear-gradient(135deg, #F59E0B, #D97706); }
        .chat-avatar.xg { background: linear-gradient(135deg, #3B82F6, #2563EB); }
        .chat-avatar.ad { background: linear-gradient(135deg, #10B981, #059669); }
        .chat-bubble { padding: 14px 18px; border-radius: 18px; background: white; border: 1px solid #E2E8F0; box-shadow: var(--shadow-xs); font-size: 14px; line-height: 1.5; color: #0F172A; }
        .chat-msg.self .chat-bubble { background: var(--violet); color: white; border-color: var(--violet); border-bottom-right-radius: 4px; }
        .chat-msg:not(.self) .chat-bubble { border-top-left-radius: 4px; }
        .chat-meta { font-size: 12px; color: var(--ink-soft); margin-bottom: 6px; display: flex; gap: 8px; font-weight: 500; }
        .chat-msg.self .chat-meta { flex-direction: row-reverse; color: #A1A1AA; }
        .chat-input-area { padding: 16px; border-top: 1px solid var(--line); background: white; display: flex; gap: 12px; align-items: center; }
        .chat-input { flex: 1; padding: 12px 20px; border-radius: 100px; border: 1px solid var(--line); outline: none; font-family: inherit; font-size: 14px; background: #FAFAFA; transition: 0.2s; }
        .chat-input:focus { border-color: var(--violet); background: white; }
        .chat-send-btn { background: var(--violet); color: white; border: none; width: 44px; height: 44px; border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: 0.2s; font-size: 18px; }
        .chat-send-btn:hover { background: #5a4bcf; transform: scale(1.05); }
        .attachment { display: inline-flex; align-items: center; gap: 8px; padding: 6px 12px; background: white; border: 1px solid var(--line); border-radius: 8px; font-size: 13px; margin-top: 10px; font-weight: 500; color: var(--ink); cursor: pointer; }
        .chat-msg.self .attachment { background: rgba(255,255,255,0.15); border: none; color: white; }
    </style>
</head>

<body>

<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="active" value="trahang"/>
</jsp:include>

<main>
    <div class="main-content">
        <div style="margin-bottom:20px;">
            <h2 style="font-size:32px;">Yêu cầu Trả hàng / Hoàn tiền</h2>
            <p style="color:var(--ink-soft); font-size:15px;">Theo dõi các yêu cầu khiếu nại, hoàn tiền hoặc đổi trả sản phẩm
                của bạn.</p>
        </div>

        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:24px; gap:10px; flex-wrap:wrap;">
            <div style="display:flex; gap:10px;">
                <button class="btn-secondary" style="border-color:var(--violet); color:var(--violet);">Tất cả</button>
                <button class="btn-secondary">Đang xử lý</button>
                <button class="btn-secondary">Đã hoàn tất</button>
            </div>
            <button class="btn-primary" onclick="openModalById('reqModal')">+ Tạo Yêu cầu mới</button>
        </div>

        <!-- Cards -->
        <div style="background:var(--surface); border:1px solid var(--line); border-radius:var(--r-md); padding:24px; margin-bottom:20px; box-shadow:var(--shadow-xs);">
            <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px dashed var(--line); padding-bottom:16px; margin-bottom:16px;">
                <div>
                    <span style="font-family:'Space Grotesk'; font-size:18px; font-weight:700;">#RE-9921</span>
                    <span style="font-size:13px; color:var(--ink-soft);"> • Tạo ngày 15/09/2026</span>
                </div>
                <span style="background:#FFF4E0; color:#9A6200; padding:6px 12px; border-radius:999px; font-size:12px; font-weight:600;">Chờ Xưởng phản hồi</span>
            </div>
            <div style="display:flex; gap:24px;">
                <div style="width:80px; height:80px; background:var(--cream); border-radius:12px; border:1px solid var(--line); display:flex; align-items:center; justify-content:center; font-size:24px;">👕</div>
                <div style="flex:1;">
                    <h4 style="font-size:16px; margin-bottom:4px;">Áo thun DTG Oversize (Đơn #PK-08230)</h4>
                    <p style="font-size:13.5px; color:var(--ink-soft); margin-bottom:4px;">Lý do: In sai màu so với thiết kế (Màu đỏ bị ám cam).</p>
                    <p style="font-size:13.5px;">Yêu cầu: <strong style="color:var(--violet);">Hoàn tiền 100% (350.000đ)</strong></p>
                </div>
                <div>
                    <button class="btn-secondary">Xem chi tiết</button>
                </div>
            </div>
        </div>

        <div style="background:var(--surface); border:1px solid var(--line); border-radius:var(--r-md); padding:24px; margin-bottom:20px; box-shadow:var(--shadow-xs);">
            <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px dashed var(--line); padding-bottom:16px; margin-bottom:16px;">
                <div>
                    <span style="font-family:'Space Grotesk'; font-size:18px; font-weight:700;">#RE-9800</span>
                    <span style="font-size:13px; color:var(--ink-soft);"> • Tạo ngày 05/09/2026</span>
                </div>
                <span style="background:#FFE9E9; color:#C0392B; padding:6px 12px; border-radius:999px; font-size:12px; font-weight:600;">Admin đang phân xử</span>
            </div>
            <div style="display:flex; gap:24px;">
                <div style="width:80px; height:80px; background:var(--cream); border-radius:12px; border:1px solid var(--line); display:flex; align-items:center; justify-content:center; font-size:24px;">☕</div>
                <div style="flex:1;">
                    <h4 style="font-size:16px; margin-bottom:4px;">Cốc sứ Sublimation x30 (Đơn #PK-08005)</h4>
                    <p style="font-size:13.5px; color:var(--ink-soft); margin-bottom:4px;">Lý do: Vỡ 3 cái do đóng gói sơ sài.</p>
                    <p style="font-size:13.5px;">Yêu cầu: <strong style="color:var(--violet);">Hoàn tiền một phần (450.000đ)</strong></p>
                </div>
                <div>
                    <button class="btn-secondary" onclick="openModalById('chatModal')">Xem tranh chấp</button>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Modal Tạo Yêu Cầu -->
<div class="modal" id="reqModal">
    <div class="modal-box">
        <button type="button" style="position:absolute; top:20px; right:20px; font-size:24px; color:var(--ink-soft); background:transparent; border:none; cursor:pointer;" onclick="closeAll()" aria-label="Đóng">&times;</button>
        <h3 style="font-size:24px; margin-bottom:20px;">Tạo Yêu cầu Hỗ trợ</h3>
        <div style="margin-bottom:16px;">
            <label style="display:block; font-size:13px; font-weight:600; margin-bottom:8px; color:var(--ink-soft);">Chọn Đơn hàng</label>
            <select style="width:100%; padding:12px; border:1.5px solid var(--line); border-radius:var(--r-sm); font-size:14px; outline:none; background:#FBF9FF;">
                <option>#PK-08240 - Túi vải canvas</option>
                <option>#PK-08235 - Cốc sứ</option>
            </select>
        </div>
        <div style="margin-bottom:16px;">
            <label style="display:block; font-size:13px; font-weight:600; margin-bottom:8px; color:var(--ink-soft);">Vấn đề gặp phải</label>
            <select style="width:100%; padding:12px; border:1.5px solid var(--line); border-radius:var(--r-sm); font-size:14px; outline:none; background:#FBF9FF;">
                <option>Hàng lỗi, hỏng hóc, in sai</option>
                <option>Giao thiếu hàng</option>
                <option>Hàng không đúng mô tả</option>
            </select>
        </div>
        <div style="margin-bottom:16px;">
            <label style="display:block; font-size:13px; font-weight:600; margin-bottom:8px; color:var(--ink-soft);">Mô tả chi tiết</label>
            <textarea rows="3" placeholder="Ghi rõ tình trạng sản phẩm..." style="width:100%; padding:12px; border:1.5px solid var(--line); border-radius:var(--r-sm); font-size:14px; outline:none; background:#FBF9FF; resize:vertical;"></textarea>
        </div>
        <div style="margin-bottom:16px;">
            <label style="display:block; font-size:13px; font-weight:600; margin-bottom:8px; color:var(--ink-soft);">Phương án mong muốn</label>
            <select style="width:100%; padding:12px; border:1.5px solid var(--line); border-radius:var(--r-sm); font-size:14px; outline:none; background:#FBF9FF;">
                <option>Hoàn tiền 100%</option>
                <option>Hoàn tiền một phần</option>
                <option>Đổi trả / In lại bù</option>
            </select>
        </div>
        <div style="text-align:right; margin-top:24px;">
            <button type="button" class="btn-primary" style="width:100%;" onclick="closeAll()">Gửi Yêu Cầu</button>
        </div>
    </div>
</div>

<!-- Modal Chat Phân Xử -->
<div class="modal" id="chatModal">
    <div class="modal-box" style="width: 650px; padding: 32px;">
        <button type="button" style="position:absolute; top:20px; right:20px; font-size:24px; color:var(--ink-soft); background:transparent; border:none; cursor:pointer;" onclick="closeAll()" aria-label="Đóng">&times;</button>
        <h3 style="font-size:24px; margin-bottom:8px;">Phòng Chat Phân Xử #RE-9800</h3>
        <p style="color:var(--ink-soft); font-size:14px; margin-bottom:0;">Trao đổi trực tiếp với Quản trị viên và Xưởng in để giải quyết vấn đề.</p>

        <div class="chat-box">
            <div class="chat-messages">
                <div class="chat-msg self">
                    <div class="chat-avatar kh">KH</div>
                    <div>
                        <div class="chat-meta"><span>Bạn (Khách hàng)</span> <span>• 05/09 09:30</span></div>
                        <div class="chat-bubble">
                            Ly sứ bị vỡ 3 cái do đóng gói sơ sài. Tôi yêu cầu hoàn tiền 450.000đ.<br>
                            <div class="attachment">📎 anh_ly_vo.jpg</div>
                        </div>
                    </div>
                </div>

                <div class="chat-msg">
                    <div class="chat-avatar xg">XG</div>
                    <div>
                        <div class="chat-meta"><span>Sài Gòn Print (Xưởng in)</span> <span>• 05/09 10:15</span></div>
                        <div class="chat-bubble">
                            Xưởng đã bọc mút xốp cẩn thận. Đây là do đơn vị vận chuyển làm rơi vỡ. Xưởng không chấp nhận đền bù toàn bộ.<br>
                            <div class="attachment">📎 anh_dong_goi.jpg</div>
                        </div>
                    </div>
                </div>

                <div class="chat-msg">
                    <div class="chat-avatar ad">AD</div>
                    <div>
                        <div class="chat-meta"><span>Quản trị viên PrintKraft</span> <span>• 06/09 14:20</span></div>
                        <div class="chat-bubble">
                            Theo hình ảnh, xốp bọc ly chưa đủ tiêu chuẩn vận chuyển hàng dễ vỡ. <br><br>
                            <strong>Quyết định sơ bộ:</strong> Xưởng chịu 50%, PrintKraft chịu 50% chi phí. Chờ xưởng xác nhận.
                        </div>
                    </div>
                </div>
            </div>
            <div class="chat-input-area">
                <button type="button" class="btn-secondary" style="border-radius:100px;">📎 Đính kèm</button>
                <input type="text" class="chat-input" placeholder="Nhắn tin vào nhóm phản hồi...">
                <button type="button" class="chat-send-btn">➤</button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script>
    // Dam bao co #overlay va #toast (neu footer.jsp chua in ra)
    (function () {
        if (!document.getElementById('overlay')) {
            var o = document.createElement('div'); o.className = 'overlay'; o.id = 'overlay';
            document.body.appendChild(o);
        }
        if (!document.getElementById('toast')) {
            var t = document.createElement('div'); t.className = 'toast'; t.id = 'toast';
            document.body.appendChild(t);
        }
        // Bam vao nen toi hoac vung ngoai hop modal thi dong
        document.getElementById('overlay').addEventListener('click', function () { closeAll(); });
        document.querySelectorAll('.modal').forEach(function (m) {
            m.addEventListener('click', function (e) { if (e.target === m) closeAll(); });
        });
    })();
</script>
<script src="<%= request.getContextPath() %>/assets/js/site.js"></script>
</body>
</html>
