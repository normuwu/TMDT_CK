<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
  <meta charset="UTF-8">
  <title>PrintKraft — Trả hàng & Hoàn tiền</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link
    href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap"
    rel="stylesheet">
  <style>
    :root {
      --ink: #1B1B2F;
      --ink-soft: #4A4A6A;
      --cream: #FDF9F3;
      --surface: #FFFFFF;
      --violet: #6C5CE7;
      --violet-soft: #A29BFE;
      --coral: #FF6B6B;
      --amber: #FFB347;
      --teal: #00B894;
      --pink: #FD79A8;
      --sky: #48A9F8;
      --grad-primary: linear-gradient(135deg, #6C5CE7 0%, #A29BFE 100%);
      --grad-warm: linear-gradient(135deg, #FF6B6B 0%, #FFB347 100%);
      --line: rgba(27, 27, 47, 0.10);
      --line-strong: rgba(27, 27, 47, 0.18);
      --shadow-xs: 0 1px 3px rgba(27, 27, 47, 0.06);
      --shadow-sm: 0 4px 14px rgba(27, 27, 47, 0.07);
      --shadow-md: 0 12px 32px rgba(27, 27, 47, 0.11);
      --r-sm: 10px;
      --r-md: 16px;
      --r-lg: 22px;
    }

    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }

    body {
      color: var(--ink);
      font-family: 'IBM Plex Sans', sans-serif;
      line-height: 1.55;
      background: var(--cream);
    }

    h1,
    h2,
    h3,
    h4,
    h5 {
      font-family: 'Space Grotesk', sans-serif;
      letter-spacing: -0.02em;
      line-height: 1.15;
    }

    a {
      color: inherit;
      text-decoration: none;
    }

    button {
      font-family: inherit;
      cursor: pointer;
      border: none;
      background: none;
      color: inherit;
    }

    /* Utility & Header (Exact from Khách hàng.html) */
    .utility {
      background: linear-gradient(90deg, #1B1B2F 0%, #2D2B55 50%, #1B1B2F 100%);
      color: rgba(253, 249, 243, 0.82);
      font-size: 12.5px;
      padding: 9px 32px;
      display: flex;
      justify-content: space-between;
    }

    header {
      background: rgba(253, 249, 243, 0.88);
      backdrop-filter: blur(14px);
      border-bottom: 1px solid var(--line);
      padding: 12px 32px;
      display: flex;
      align-items: center;
      gap: 16px;
      position: sticky;
      top: 0;
      z-index: 50;
    }

    .logo {
      font-size: 22px;
      font-weight: 700;
      display: flex;
      align-items: center;
      gap: 10px;
      white-space: nowrap;
      flex-shrink: 0;
    }

    .logo .mark {
      width: 28px;
      height: 28px;
      background: var(--grad-warm);
      display: inline-block;
      transform: rotate(45deg);
      border-radius: 8px;
    }

    nav {
      display: flex;
      gap: 4px;
      font-size: 14px;
      font-weight: 500;
      overflow-x: auto;
      flex: 1;
      min-width: 0;
      padding: 2px;
    }

    nav a {
      padding: 9px 14px;
      border-radius: 999px;
      white-space: nowrap;
      color: var(--ink-soft);
      transition: .18s;
      border: none;
      flex-shrink: 0;
    }
    
    nav a:hover{background:rgba(108,92,231,0.10); color:var(--violet);}

    nav a.active {
      background: var(--grad-primary);
      color: #fff;
      box-shadow: 0 6px 16px rgba(108, 92, 231, 0.30);
    }
    
    .search-wrap{
      flex:0 1 250px; display:flex; min-width:0;
      background:var(--surface); border:1.5px solid var(--line-strong); border-radius:999px;
      overflow:hidden; transition:.2s; box-shadow:var(--shadow-xs);
    }
    .search-wrap:focus-within{border-color:var(--violet); box-shadow:0 0 0 4px rgba(108,92,231,0.14);}
    .search-wrap input{border:none; outline:none; background:transparent; padding:10px 18px; font-size:14px; flex:1; min-width:0;}
    .search-wrap button{background:var(--grad-primary); color:white; border:none; padding:0 18px; font-weight:600; font-size:13.5px;}

    .head-actions {
      display: flex;
      align-items: center;
      gap: 14px;
      font-size: 13px;
      font-weight: 500;
      flex-shrink: 0;
      margin-left: auto;
    }

    .cart-btn {
      display: flex;
      align-items: center;
      gap: 7px;
      background: var(--grad-warm);
      color: white;
      border: none;
      padding: 10px 16px;
      border-radius: 999px;
      font-weight: 600;
      font-size: 13.5px;
    }

    .badge {
      background: rgba(255, 255, 255, 0.28);
      border-radius: 999px;
      padding: 1px 8px;
      font-size: 11.5px;
    }

    /* Main Content: Returns & Refunds */
    .main-content {
      max-width: 1100px;
      margin: 40px auto;
      padding: 0 32px;
      min-height: 60vh;
    }

    .btn-primary {
      background: var(--grad-primary);
      color: white;
      padding: 12px 24px;
      border-radius: var(--r-sm);
      font-weight: 600;
      font-size: 14px;
      transition: .2s;
    }

    .btn-secondary {
      border: 1.5px solid var(--line-strong);
      background: var(--surface);
      padding: 8px 16px;
      border-radius: var(--r-sm);
      font-weight: 600;
      font-size: 13px;
      transition: .2s;
    }

    /* Modal */
    .overlay {
      position: fixed;
      inset: 0;
      background: rgba(27, 27, 47, 0.5);
      backdrop-filter: blur(3px);
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
      padding: 20px;
    }

    .modal.show {
      opacity: 1;
      pointer-events: auto;
    }

    .modal-box {
      background: var(--surface);
      border-radius: var(--r-lg);
      padding: 32px;
      width: 520px;
      max-width: 100%;
      box-shadow: var(--shadow-md);
      position: relative;
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

  <!-- ============ UTILITY BAR ============ -->
  <div class="utility">
    <span>🚚 Miễn phí thiết kế mockup cho đơn từ 20 sản phẩm — <b>Voucher 100K</b> cho đơn đầu tiên</span>
    <span>Hỗ trợ: <b>1900 6868</b> · Theo dõi đơn hàng · <a href="../Auth/Đăng-nhập.jsp" onclick="openLogin();return false;">Đăng nhập</a></span>
  </div>

  <!-- ============ HEADER ============ -->
  <header>
    <a href="trang_chu.jsp" class="logo"><span class="mark"></span> PrintKraft</a>
    <nav id="mainNav">
      <a href="trang_chu.jsp"        data-tab="home">Trang chủ</a>
      <a href="dat_in_3d.jsp"    data-tab="san-pham">Sản phẩm</a>
      <a href="dat_in_3d.jsp"      data-tab="studio">Tự thiết kế</a>
      <a href="trang_chu.jsp" data-tab="doanh-nghiep">Doanh nghiệp</a>
      <a href="tim-kiem-nha-cung-cap.jsp"  data-tab="nhacungcap">Nhà cung cấp</a>
      <a href="don_hang_cua_toi_3d.jsp"     data-tab="donhang">Đơn hàng</a>
      <a href="tra_hang_hoan_tien_custom.jsp"     data-tab="trahang" class="active">Trả hàng & Hoàn tiền</a>
      <a href="danh-gia.jsp"     data-tab="danhgia">Đánh giá</a>
      <a href="lien-he.jsp"         data-tab="faq">Hỗ trợ</a>
    </nav>
    <div class="search-wrap">
      <input type="text" placeholder="Tìm áo thun, cốc sứ, poster...">
      <button>Tìm</button>
    </div>
    <div class="head-actions">
      <div id="authArea">
        <a href="../Auth/Đăng-nhập.jsp" onclick="openLogin();return false;" style="font-weight:600;">Tài khoản</a>
      </div>
      <button class="cart-btn" onclick="openCart()">🛒 Giỏ hàng <span class="badge" id="cartBadge">3</span></button>
    </div>
  </header>

  <!-- ============ MAIN CONTENT ============ -->
  <div class="main-content">
    <div style="margin-bottom:20px;">
      <h2 style="font-size:32px;">Yêu cầu Trả hàng / Hoàn tiền</h2>
      <p style="color:var(--ink-soft); font-size:15px;">Theo dõi các yêu cầu khiếu nại, hoàn tiền hoặc đổi trả sản phẩm
        của bạn.</p>
    </div>

    <div
      style="display:flex; justify-content:space-between; align-items:center; margin-bottom:24px; gap:10px; flex-wrap:wrap;">
      <div style="display:flex; gap:10px;">
        <button class="btn-secondary" style="border-color:var(--violet); color:var(--violet);">Tất cả</button>
        <button class="btn-secondary">Đang xử lý</button>
        <button class="btn-secondary">Đã hoàn tất</button>
      </div>
      <button class="btn-primary"
        onclick="document.getElementById('reqModal').classList.add('show'); document.getElementById('overlayReq').classList.add('show');">+
        Tạo Yêu cầu mới</button>
    </div>

    <!-- Cards -->
    <div
      style="background:var(--surface); border:1px solid var(--line); border-radius:var(--r-md); padding:24px; margin-bottom:20px; box-shadow:var(--shadow-xs);">
      <div
        style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px dashed var(--line); padding-bottom:16px; margin-bottom:16px;">
        <div>
          <span style="font-family:'Space Grotesk'; font-size:18px; font-weight:700;">#RE-9921</span>
          <span style="font-size:13px; color:var(--ink-soft);"> • Tạo ngày 15/09/2026</span>
        </div>
        <span
          style="background:#FFF4E0; color:#9A6200; padding:6px 12px; border-radius:999px; font-size:12px; font-weight:600;">Chờ
          Xưởng phản hồi</span>
      </div>
      <div style="display:flex; gap:24px;">
        <div
          style="width:80px; height:80px; background:var(--cream); border-radius:12px; border:1px solid var(--line); display:flex; align-items:center; justify-content:center; font-size:24px;">
          👕</div>
        <div style="flex:1;">
          <h4 style="font-size:16px; margin-bottom:4px;">Áo thun DTG Oversize (Đơn #PK-08230)</h4>
          <p style="font-size:13.5px; color:var(--ink-soft); margin-bottom:4px;">Lý do: In sai màu so với thiết kế (Màu
            đỏ bị ám cam).</p>
          <p style="font-size:13.5px;">Yêu cầu: <strong style="color:var(--violet);">Hoàn tiền 100% (350.000đ)</strong>
          </p>
        </div>
        <div>
          <button class="btn-secondary">Xem chi tiết</button>
        </div>
      </div>
    </div>

    <div
      style="background:var(--surface); border:1px solid var(--line); border-radius:var(--r-md); padding:24px; margin-bottom:20px; box-shadow:var(--shadow-xs);">
      <div
        style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px dashed var(--line); padding-bottom:16px; margin-bottom:16px;">
        <div>
          <span style="font-family:'Space Grotesk'; font-size:18px; font-weight:700;">#RE-9800</span>
          <span style="font-size:13px; color:var(--ink-soft);"> • Tạo ngày 05/09/2026</span>
        </div>
        <span
          style="background:#FFE9E9; color:#C0392B; padding:6px 12px; border-radius:999px; font-size:12px; font-weight:600;">Admin
          đang phân xử</span>
      </div>
      <div style="display:flex; gap:24px;">
        <div
          style="width:80px; height:80px; background:var(--cream); border-radius:12px; border:1px solid var(--line); display:flex; align-items:center; justify-content:center; font-size:24px;">
          ☕</div>
        <div style="flex:1;">
          <h4 style="font-size:16px; margin-bottom:4px;">Cốc sứ Sublimation x30 (Đơn #PK-08005)</h4>
          <p style="font-size:13.5px; color:var(--ink-soft); margin-bottom:4px;">Lý do: Vỡ 3 cái do đóng gói sơ sài.</p>
          <p style="font-size:13.5px;">Yêu cầu: <strong style="color:var(--violet);">Hoàn tiền một phần
              (450.000đ)</strong></p>
        </div>
        <div>
          <button class="btn-secondary" onclick="document.getElementById('chatModal').classList.add('show'); document.getElementById('overlayReq').classList.add('show');">Xem tranh chấp</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Modal Tạo Yêu Cầu -->
  <div class="overlay" id="overlayReq"></div>
  <div class="modal" id="reqModal">
    <div class="modal-box">
      <button
        style="position:absolute; top:20px; right:20px; font-size:24px; color:var(--ink-soft); background:transparent; border:none; cursor:pointer;"
        onclick="document.getElementById('reqModal').classList.remove('show'); document.getElementById('overlayReq').classList.remove('show');">&times;</button>
      <h3 style="font-size:24px; margin-bottom:20px;">Tạo Yêu cầu Hỗ trợ</h3>
      <div style="margin-bottom:16px;">
        <label style="display:block; font-size:13px; font-weight:600; margin-bottom:8px; color:var(--ink-soft);">Chọn
          Đơn hàng</label>
        <select
          style="width:100%; padding:12px; border:1.5px solid var(--line); border-radius:var(--r-sm); font-size:14px; outline:none; background:#FBF9FF;">
          <option>#PK-08240 - Túi vải canvas</option>
          <option>#PK-08235 - Cốc sứ</option>
        </select>
      </div>
      <div style="margin-bottom:16px;">
        <label style="display:block; font-size:13px; font-weight:600; margin-bottom:8px; color:var(--ink-soft);">Vấn đề
          gặp phải</label>
        <select
          style="width:100%; padding:12px; border:1.5px solid var(--line); border-radius:var(--r-sm); font-size:14px; outline:none; background:#FBF9FF;">
          <option>Hàng lỗi, hỏng hóc, in sai</option>
          <option>Giao thiếu hàng</option>
          <option>Hàng không đúng mô tả</option>
        </select>
      </div>
      <div style="margin-bottom:16px;">
        <label style="display:block; font-size:13px; font-weight:600; margin-bottom:8px; color:var(--ink-soft);">Mô tả
          chi tiết</label>
        <textarea rows="3" placeholder="Ghi rõ tình trạng sản phẩm..."
          style="width:100%; padding:12px; border:1.5px solid var(--line); border-radius:var(--r-sm); font-size:14px; outline:none; background:#FBF9FF; resize:vertical;"></textarea>
      </div>
      <div style="margin-bottom:16px;">
        <label style="display:block; font-size:13px; font-weight:600; margin-bottom:8px; color:var(--ink-soft);">Phương
          án mong muốn</label>
        <select
          style="width:100%; padding:12px; border:1.5px solid var(--line); border-radius:var(--r-sm); font-size:14px; outline:none; background:#FBF9FF;">
          <option>Hoàn tiền 100%</option>
          <option>Hoàn tiền một phần</option>
          <option>Đổi trả / In lại bù</option>
        </select>
      </div>
      <div style="text-align:right; margin-top:24px;">
        <button class="btn-primary" style="width:100%;"
          onclick="document.getElementById('reqModal').classList.remove('show'); document.getElementById('overlayReq').classList.remove('show');">Gửi
          Yêu Cầu</button>
      </div>
    </div>
  </div>

  <!-- Modal Chat Phân Xử -->
  <div class="modal" id="chatModal">
    <div class="modal-box" style="width: 650px; padding: 32px;">
      <button
        style="position:absolute; top:20px; right:20px; font-size:24px; color:var(--ink-soft); background:transparent; border:none; cursor:pointer;"
        onclick="document.getElementById('chatModal').classList.remove('show'); document.getElementById('overlayReq').classList.remove('show');">&times;</button>
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
          <button class="btn-secondary" style="border-radius:100px;">📎 Đính kèm</button>
          <input type="text" class="chat-input" placeholder="Nhắn tin vào nhóm phản hồi...">
          <button class="chat-send-btn">➤</button>
        </div>
      </div>
    </div>
  </div>

</body>

</html>