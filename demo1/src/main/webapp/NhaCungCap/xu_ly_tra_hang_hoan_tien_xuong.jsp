<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
  <meta charset="UTF-8">
  <title>PrintKraft Xưởng — Xử lý trả hàng, hoàn tiền</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link
    href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@600;700&family=Barlow:wght@400;500;600;700&display=swap"
    rel="stylesheet">
  <style>
    :root {
      --charcoal: #171920;
      --steel: #2C3140;
      --steel-2: #20232C;
      --steel-3: #262A35;
      --orange: #FF8A1F;
      --amber: #FFB020;
      --violet: #8B5CF6;
      --teal: #22D3EE;
      --green: #34D399;
      --red: #FB5A6A;
      --blue: #60A5FA;
      --off: #EDEFF5;
      --muted: #9AA0B0;
      --grad-hot: linear-gradient(135deg, #FF8A1F, #FFB020);
      --orange-glow: rgba(255, 138, 31, .35);
    }

    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }

    body {
      background: radial-gradient(900px 520px at 8% -8%, rgba(255, 138, 31, .10), transparent 60%), var(--charcoal);
      color: var(--off);
      font-family: 'Barlow', sans-serif;
      font-size: 15px;
      min-height: 100vh;
    }

    h1,
    h2,
    h3,
    .cond {
      font-family: 'Barlow Condensed', sans-serif;
      letter-spacing: 0.01em;
    }

    /* Topbar (Exact from Xưởng.html) */
    .topbar {
      background: linear-gradient(180deg, #262A35, #1D2028);
      padding: 14px 28px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      box-shadow: 0 6px 24px rgba(0, 0, 0, .35);
    }

    .topbar:after {
      content: "";
      position: absolute;
      left: 0;
      right: 0;
      bottom: 0;
      height: 3px;
      background: linear-gradient(90deg, var(--orange), var(--amber), var(--pink), var(--violet), var(--teal));
    }

    .brand {
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .brand .mark {
      width: 34px;
      height: 34px;
      border-radius: 9px;
      background: var(--grad-hot);
      clip-path: polygon(50% 0%, 100% 100%, 0% 100%);
    }

    .brand h1 {
      font-size: 24px;
      font-weight: 700;
      color: white;
    }

    .brand span {
      font-size: 12.5px;
      color: var(--muted);
      display: block;
      margin-top: -2px;
    }

    .shift-info {
      display: flex;
      align-items: center;
      gap: 22px;
      font-size: 13px;
      color: var(--muted);
    }

    .shift-info .live {
      display: flex;
      align-items: center;
      gap: 7px;
      color: var(--green);
      font-weight: 600;
    }

    .shift-info .live .dot {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background: var(--green);
    }

    .op-avatar {
      width: 38px;
      height: 38px;
      border-radius: 50%;
      background: var(--grad-hot);
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 700;
      color: #1A1C22;
    }

    /* Nav tabs */
    .nav-tabs {
      background: linear-gradient(180deg, #1F222B, #1B1E26);
      border-bottom: 1px solid var(--steel);
      padding: 0 28px;
      display: flex;
      gap: 4px;
    }

    .nav-tabs button {
      background: transparent;
      border: none;
      color: var(--muted);
      padding: 14px 18px;
      font-size: 13.5px;
      font-weight: 600;
      border-bottom: 3px solid transparent;
      cursor: pointer;
    }

    .nav-tabs button.active {
      color: white;
      border-bottom: 3px solid var(--orange);
      text-shadow: 0 0 18px var(--orange-glow);
    }

    .content {
      padding: 26px 28px;
      max-width: 860px;
      margin: 0 auto;
    }

    /* Main View */
    .req-card {
      background: linear-gradient(180deg, #1D2029, #191C24);
      border: 1px solid var(--steel);
      border-radius: 11px;
      padding: 20px;
      margin-bottom: 14px;
    }

    /* Modal */
    .overlay {
      position: fixed;
      inset: 0;
      background: rgba(8, 9, 13, 0.72);
      opacity: 0;
      pointer-events: none;
      transition: .2s;
      z-index: 90;
    }

    .overlay.show {
      opacity: 1;
      pointer-events: auto;
    }

    .modal {
      position: fixed;
      inset: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      z-index: 100;
      opacity: 0;
      pointer-events: none;
      transition: .2s;
    }

    .modal.show {
      opacity: 1;
      pointer-events: auto;
    }

    .modal-box {
      background: linear-gradient(180deg, #262A35, #1E2129);
      border: 1px solid var(--steel);
      border-radius: 16px;
      padding: 26px;
      width: 500px;
      box-shadow: 0 24px 60px rgba(0, 0, 0, .6);
    }
    
    /* Chat UI */
    .chat-box { display: flex; flex-direction: column; height: 500px; background: var(--steel-2); border-radius: 12px; border: 1px solid var(--steel); overflow: hidden; margin-top: 20px; }
    .chat-messages { flex: 1; padding: 20px; overflow-y: auto; display: flex; flex-direction: column; gap: 16px; }
    .chat-msg { display: flex; gap: 12px; max-width: 85%; }
    .chat-msg.self { align-self: flex-end; flex-direction: row-reverse; }
    .chat-avatar { width: 36px; height: 36px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 700; color: white; flex-shrink: 0; font-family: 'Inter'; box-shadow: 0 4px 10px rgba(0,0,0,0.3); }
    .chat-avatar.kh { background: linear-gradient(135deg, #F59E0B, #D97706); }
    .chat-avatar.xg { background: linear-gradient(135deg, #3B82F6, #2563EB); }
    .chat-avatar.ad { background: linear-gradient(135deg, #10B981, #059669); }
    .chat-bubble { padding: 14px 18px; border-radius: 18px; background: var(--steel-3); border: 1px solid var(--steel); box-shadow: 0 4px 10px rgba(0,0,0,0.2); font-size: 14px; line-height: 1.5; color: var(--off); }
    .chat-msg.self .chat-bubble { background: rgba(255, 138, 31, 0.15); color: white; border-color: var(--orange); border-bottom-right-radius: 4px; }
    .chat-msg:not(.self) .chat-bubble { border-top-left-radius: 4px; }
    .chat-meta { font-size: 12px; color: var(--muted); margin-bottom: 6px; display: flex; gap: 8px; font-weight: 500; font-family: 'Inter'; }
    .chat-msg.self .chat-meta { flex-direction: row-reverse; }
    .chat-input-area { padding: 16px; border-top: 1px solid var(--steel); background: var(--steel-3); display: flex; gap: 12px; align-items: center; }
    .chat-input { flex: 1; padding: 12px 20px; border-radius: 100px; border: 1px solid var(--steel); outline: none; font-family: 'Inter'; font-size: 14px; background: var(--charcoal); color: white; transition: 0.2s; }
    .chat-input:focus { border-color: var(--orange); box-shadow: 0 0 0 2px rgba(255,138,31,0.2); }
    .chat-send-btn { background: var(--orange); color: #000; border: none; width: 44px; height: 44px; border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: 0.2s; font-size: 18px; box-shadow: 0 4px 12px var(--orange-glow); }
    .chat-send-btn:hover { background: #EA580C; transform: scale(1.05); }
    .attachment { display: inline-flex; align-items: center; gap: 8px; padding: 6px 12px; background: var(--charcoal); border: 1px solid var(--steel); border-radius: 8px; font-size: 13px; margin-top: 10px; font-weight: 500; color: white; cursor: pointer; }
    .chat-msg.self .attachment { border-color: var(--orange); }
  </style>
</head>

<body>

  <div class="topbar">
    <div class="brand">
      <span class="mark"></span>
      <div><h1>Sài Gòn Print</h1><span>Cổng xưởng sản xuất · PrintKraft</span></div>
    </div>
    <div class="shift-info">
      <div class="live"><span class="dot"></span> Ca sáng · 06:00–14:00</div>
      <div>Thứ Ba, 15/09/2026 — <span id="clock">10:42</span></div>
      <div class="op-avatar" onclick="openModal('profileModal')">ĐL</div>
    </div>
  </div>

  <!-- Nav tabs -->
  <div class="nav-tabs">
    <button onclick="switchTab(this,'board')">Bảng sản xuất</button>
    <button onclick="switchTab(this,'machines')">Máy móc</button>
    <button onclick="switchTab(this,'materials')">Vật tư</button>
    <button onclick="switchTab(this,'qc')">Kiểm tra chất lượng</button>
    <button onclick="switchTab(this,'schedule')">Lịch ca</button>
    <button onclick="switchTab(this,'revenue')">💰 Doanh thu</button>
    <button onclick="switchTab(this,'shop')">🛍️ Mẫu bán sẵn</button>
    <button class="active" onclick="switchTab(this,'support')">🎧 Hỗ trợ &amp; Đổi trả</button>
  </div>

  <div class="content">
    <h2 style="font-size:26px; color:white; font-weight:700; margin-bottom:20px; font-family:'Barlow Condensed';">Xử lý
      Trả hàng / Hoàn tiền</h2>

    <div
      style="background:linear-gradient(180deg,var(--steel-3),var(--steel-2)); border:1px solid var(--steel); border-radius:14px; padding:20px; max-width:800px;">
      <h3
        style="font-size:19px; color:white; font-weight:700; margin-bottom:14px; text-transform:uppercase; font-family:'Barlow Condensed';">
        Yêu cầu đổi / trả đang chờ</h3>

      <div class="req-card">
        <div
          style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid var(--steel); padding-bottom:12px; margin-bottom:12px;">
          <h3 style="font-size:18px; color:white; font-family:'Barlow Condensed';">Yêu cầu #RE-9921 (Đơn #PK-08230)</h3>
          <span
            style="padding:4px 10px; border-radius:6px; font-size:12px; font-weight:700; background:rgba(255,138,31,0.16); color:var(--orange);">Cần
            xử lý</span>
        </div>
        <div>
          <p style="font-size:14px; color:var(--off); margin-bottom:6px;"><strong>Khách hàng:</strong> Minh Anh Store
          </p>
          <p style="font-size:14px; color:var(--off); margin-bottom:6px;"><strong>Sản phẩm:</strong> Áo thun DTG (120
            chiếc)</p>
          <p style="font-size:14px; color:var(--off); margin-bottom:6px;"><strong>Lý do từ khách:</strong> In sai màu
            (màu đỏ bị ám cam).</p>
          <p style="font-size:14px; color:var(--off); margin-bottom:6px;"><strong>Yêu cầu:</strong> Hoàn tiền 100%
            (350.000đ)</p>
          <div style="display:flex; gap:10px; margin-top:20px;">
            <button
              style="padding:10px 16px; border-radius:8px; font-weight:700; font-size:13.5px; border:none; background:var(--grad-hot); color:#1A1C22; cursor:pointer;"
              onclick="document.getElementById('resModal').classList.add('show'); document.getElementById('overlayRes').classList.add('show');">Phản
              hồi Yêu cầu</button>
            <button
              style="padding:10px 16px; border-radius:8px; font-weight:700; font-size:13.5px; background:transparent; border:1px solid var(--steel); color:white; cursor:pointer;">Xem
              hình ảnh</button>
          </div>
        </div>
      </div>

      <div class="req-card">
        <div
          style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid var(--steel); padding-bottom:12px; margin-bottom:12px;">
          <h3 style="font-size:18px; color:white; font-family:'Barlow Condensed';">Yêu cầu #RE-9800 (Đơn #PK-08005)</h3>
          <span
            style="padding:4px 10px; border-radius:6px; font-size:12px; font-weight:700; background:rgba(251,90,106,0.16); color:var(--red);">Admin
            đang xử lý</span>
        </div>
        <div>
          <p style="font-size:14px; color:var(--off); margin-bottom:6px;"><strong>Khách hàng:</strong> Nguyễn Thảo</p>
          <p style="font-size:14px; color:var(--off); margin-bottom:6px;"><strong>Sản phẩm:</strong> Cốc sứ Sublimation
            (30 chiếc)</p>
          <p style="font-size:14px; color:var(--off); margin-bottom:6px;"><strong>Lý do từ khách:</strong> Hàng vỡ do
            đóng gói sơ sài.</p>
          <p style="font-size:14px; color:var(--off); margin-bottom:6px;"><strong>Yêu cầu:</strong> Hoàn 450.000đ</p>
          <div style="display:flex; gap:10px; margin-top:20px;">
            <button
              style="padding:10px 16px; border-radius:8px; font-weight:700; font-size:13.5px; background:transparent; border:1px solid var(--steel); color:white; cursor:pointer;"
              onclick="document.getElementById('chatModal').classList.add('show'); document.getElementById('overlayRes').classList.add('show');">Xem
              tranh chấp</button>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="overlay" id="overlayRes"
    onclick="document.getElementById('resModal').classList.remove('show'); document.getElementById('overlayRes').classList.remove('show');">
  </div>
  <div class="modal" id="resModal">
    <div class="modal-box">
      <h3 style="font-size:24px; color:white; margin-bottom:20px;">Phản hồi Yêu cầu #RE-9921</h3>
      <div style="margin-bottom:16px;">
        <label
          style="display:block; font-size:12px; font-weight:600; color:var(--muted); margin-bottom:8px; text-transform:uppercase;">Quyết
          định của Xưởng</label>
        <select
          style="width:100%; background:#181B22; border:1px solid var(--steel); border-radius:9px; padding:12px; color:white; font-family:inherit; outline:none; font-size:14px;">
          <option>Chấp nhận hoàn tiền 100%</option>
          <option>Đồng ý in lại và giao bù</option>
          <option>Thỏa thuận hoàn một phần</option>
          <option>Từ chối (Đưa Admin phân xử)</option>
        </select>
      </div>
      <div style="margin-bottom:16px;">
        <label
          style="display:block; font-size:12px; font-weight:600; color:var(--muted); margin-bottom:8px; text-transform:uppercase;">Lời
          nhắn cho khách hàng</label>
        <textarea rows="4" placeholder="Nhập lý do hoặc lời xin lỗi..."
          style="width:100%; background:#181B22; border:1px solid var(--steel); border-radius:9px; padding:12px; color:white; font-family:inherit; outline:none; font-size:14px; resize:vertical;"></textarea>
      </div>
      <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:20px;">
        <button
          style="padding:10px 16px; border-radius:8px; font-weight:700; font-size:13.5px; background:transparent; border:1px solid var(--steel); color:white; cursor:pointer;"
          onclick="document.getElementById('resModal').classList.remove('show'); document.getElementById('overlayRes').classList.remove('show');">Hủy</button>
        <button
          style="padding:10px 16px; border-radius:8px; font-weight:700; font-size:13.5px; border:none; background:var(--grad-hot); color:#1A1C22; cursor:pointer;"
          onclick="document.getElementById('resModal').classList.remove('show'); document.getElementById('overlayRes').classList.remove('show');">Gửi
          Quyết Định</button>
      </div>
    </div>
  </div>

  <div class="modal" id="chatModal">
    <div class="modal-box" style="width: 650px; padding: 32px;">
      <h3 style="font-size:28px; color:white; margin-bottom:8px; line-height: 1.2;">Phòng Chat Phân Xử #RE-9800</h3>
      <p style="color:var(--muted); font-size:14px; margin-bottom:0; font-family: 'Inter';">Trao đổi trực tiếp với Admin và Khách hàng để giải quyết.</p>
      
      <div class="chat-box">
        <div class="chat-messages">
          <div class="chat-msg">
            <div class="chat-avatar kh">KH</div>
            <div>
              <div class="chat-meta"><span>Nguyễn Thảo (Khách hàng)</span> <span>• 05/09 09:30</span></div>
              <div class="chat-bubble">
                Ly sứ bị vỡ 3 cái do đóng gói sơ sài. Tôi yêu cầu hoàn tiền 450.000đ.<br>
                <div class="attachment">📎 anh_ly_vo.jpg</div>
              </div>
            </div>
          </div>

          <div class="chat-msg self">
            <div class="chat-avatar xg">XG</div>
            <div>
              <div class="chat-meta"><span>Bạn (Xưởng in)</span> <span>• 05/09 10:15</span></div>
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
          <button style="padding:10px 16px; border-radius:100px; font-weight:700; font-size:13.5px; background:transparent; border:1px solid var(--steel); color:white; cursor:pointer;" onclick="document.getElementById('chatModal').classList.remove('show'); document.getElementById('overlayRes').classList.remove('show');">Đóng</button>
          <input type="text" class="chat-input" placeholder="Nhắn tin vào nhóm phản hồi...">
          <button class="chat-send-btn">➤</button>
        </div>
      </div>
    </div>
  </div>

</body>

</html>