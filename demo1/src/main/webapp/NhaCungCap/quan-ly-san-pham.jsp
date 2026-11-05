<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
  Quản lý sản phẩm của Người bán (xưởng in).
  Dữ liệu đọc/ghi qua /nhacungcap/api/products (SellerProductApiServlet) và lưu
  trong bảng products — không dùng localStorage. supplier_id luôn lấy từ
  session + DB ở phía server.
--%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>PrintKraft Xưởng — Sản phẩm của xưởng</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="app-ctx" content="<%= request.getContextPath() %>">
<meta name="csrf-token" content="<%= session.getAttribute("csrfToken") %>">
<link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@600;700&family=Barlow:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
:root{
  --charcoal:#171920; --steel:#2C3140; --steel-2:#20232C; --steel-3:#262A35;
  --orange:#FF8A1F; --amber:#FFB020; --violet:#8B5CF6; --teal:#22D3EE;
  --green:#34D399; --red:#FB5A6A; --blue:#60A5FA; --off:#EDEFF5; --muted:#9AA0B0;
  --orange-glow:rgba(255,138,31,.35);
  --grad-hot:linear-gradient(135deg,#FF8A1F,#FFB020);
  --grad-money:linear-gradient(135deg,#34D399,#22D3EE);
  --grad-cool:linear-gradient(135deg,#8B5CF6,#22D3EE);
}
*{box-sizing:border-box;margin:0;padding:0;}
body{
  background:
    radial-gradient(900px 520px at 8% -8%, rgba(255,138,31,.10), transparent 60%),
    radial-gradient(820px 520px at 95% -4%, rgba(139,92,246,.12), transparent 62%),
    var(--charcoal);
  color:var(--off); font-family:'Barlow',sans-serif; font-size:15px; min-height:100vh;
}
h1,h2,h3{font-family:'Barlow Condensed',sans-serif;letter-spacing:.01em;}
a{color:inherit;text-decoration:none;}
button{font-family:inherit;cursor:pointer;}
input,select,textarea{font-family:inherit;}
::-webkit-scrollbar{width:9px;height:9px;}
::-webkit-scrollbar-track{background:var(--steel-2);}
::-webkit-scrollbar-thumb{background:#3A4052;border-radius:9px;}
:focus-visible{outline:2px solid var(--orange);outline-offset:2px;}

.topbar{
  background:linear-gradient(180deg,#262A35,#1D2028); padding:14px 28px;
  display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap;
  position:sticky;top:0;z-index:50;box-shadow:0 6px 24px rgba(0,0,0,.35);
}
.topbar:after{content:"";position:absolute;left:0;right:0;bottom:0;height:3px;
  background:linear-gradient(90deg,var(--orange),var(--amber),#F472B6,var(--violet),var(--teal));}
.brand{display:flex;align-items:center;gap:12px;}
.brand .mark{width:34px;height:34px;border-radius:9px;background:var(--grad-hot);
  clip-path:polygon(50% 0%,100% 100%,0% 100%);filter:drop-shadow(0 0 12px var(--orange-glow));}
.brand h1{font-size:24px;font-weight:700;color:#fff;}
.brand span{font-size:12.5px;color:var(--muted);display:block;margin-top:-2px;}
.topbar-right{display:flex;gap:9px;align-items:center;}
.btn{
  background:var(--steel-2);border:1px solid var(--steel);color:var(--off);
  padding:9px 15px;border-radius:9px;font-size:13px;font-weight:600;transition:.16s;
}
.btn:hover{border-color:#3C4358;}
.btn.primary{background:var(--grad-hot);color:#1A1C22;border:none;box-shadow:0 4px 16px var(--orange-glow);}
.btn.primary:hover{filter:brightness(1.07);}

.content{max-width:1400px;margin:0 auto;padding:26px 28px 80px;}
.page-head{display:flex;justify-content:space-between;align-items:flex-start;gap:18px;flex-wrap:wrap;margin-bottom:20px;}
.crumbs{font-size:12px;color:var(--muted);margin-bottom:6px;}
.page-head h2{font-size:28px;color:#fff;font-weight:700;}
.page-head p{font-size:13.5px;color:var(--muted);margin-top:4px;}

.stats{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;margin-bottom:18px;}
.stat{
  background:linear-gradient(180deg,var(--steel-3),var(--steel-2));
  border:1px solid var(--steel);border-radius:14px;padding:16px 18px;position:relative;overflow:hidden;
}
.stat:before{content:"";position:absolute;left:0;top:0;width:100%;height:2px;background:var(--grad-hot);}
.stat .lbl{font-family:'Barlow Condensed';font-size:13px;color:var(--muted);text-transform:uppercase;letter-spacing:.06em;}
.stat .val{font-size:30px;font-weight:700;color:#fff;margin-top:4px;}
.stat .val.orange{color:var(--orange);}
.stat .val.green{color:var(--green);}
.stat .val.red{color:var(--red);}

.toolbar{
  display:flex;gap:12px;align-items:center;flex-wrap:wrap;margin-bottom:16px;
  background:linear-gradient(180deg,var(--steel-3),var(--steel-2));
  border:1px solid var(--steel);border-radius:14px;padding:13px 16px;
}
.search{flex:1;min-width:220px;display:flex;align-items:center;gap:9px;
  background:#181B22;border:1px solid var(--steel);border-radius:10px;padding:0 13px;}
.search input{flex:1;background:transparent;border:none;outline:none;color:var(--off);padding:11px 0;font-size:13.5px;}
.search .ic{color:var(--muted);}

.table-wrap{background:linear-gradient(180deg,var(--steel-3),var(--steel-2));
  border:1px solid var(--steel);border-radius:14px;overflow:hidden;}
.table-scroll{overflow-x:auto;}
table{width:100%;border-collapse:collapse;font-size:13.5px;min-width:900px;}
th{text-align:left;padding:13px 14px;color:var(--muted);font-weight:600;font-size:11.5px;
  text-transform:uppercase;letter-spacing:.04em;border-bottom:1px solid var(--steel);white-space:nowrap;}
td{padding:13px 14px;border-bottom:1px solid #232734;vertical-align:middle;}
tr:last-child td{border-bottom:none;}
tbody tr:hover{background:rgba(255,138,31,.05);}
.pname{font-weight:600;color:#fff;}
.pslug{font-size:11.5px;color:var(--muted);margin-top:2px;}
.money{font-family:'Barlow Condensed';font-weight:700;font-size:15.5px;color:#fff;}
.badge{font-size:11px;font-weight:700;padding:4px 10px;border-radius:999px;display:inline-block;white-space:nowrap;}
.badge.active{background:rgba(52,211,153,.16);color:var(--green);}
.badge.hidden{background:rgba(251,90,106,.16);color:var(--red);}
.badge.low{background:rgba(255,176,32,.16);color:var(--amber);}
.row-actions{display:flex;gap:7px;justify-content:flex-end;flex-wrap:wrap;}
.mini-btn{
  background:var(--steel-2);border:1px solid var(--steel);color:var(--off);
  padding:6px 11px;border-radius:7px;font-size:12px;font-weight:600;white-space:nowrap;
}
.mini-btn:hover{border-color:var(--orange);color:var(--orange);}
.mini-btn.danger:hover{border-color:var(--red);color:var(--red);}
.empty{padding:60px 20px;text-align:center;color:var(--muted);}
.empty strong{display:block;color:#fff;font-size:18px;margin-bottom:7px;}
.hint{font-size:12.5px;color:var(--muted);}

.modal{position:fixed;inset:0;background:rgba(5,6,9,.66);display:none;align-items:center;
  justify-content:center;padding:20px;z-index:100;}
.modal.show{display:flex;}
.modal-box{width:560px;max-width:100%;max-height:92vh;overflow:auto;border-radius:16px;
  background:linear-gradient(180deg,#262A35,#1D2029);border:1px solid var(--steel);
  box-shadow:0 30px 80px rgba(0,0,0,.6);padding:22px;}
.modal-head{display:flex;justify-content:space-between;align-items:flex-start;gap:12px;margin-bottom:16px;}
.modal-head h3{font-size:22px;color:#fff;}
.modal-head p{font-size:12.5px;color:var(--muted);margin-top:2px;}
.close{background:none;border:none;color:var(--muted);font-size:20px;line-height:1;}
.close:hover{color:var(--red);}
.field{margin-bottom:13px;}
.field label{display:block;font-size:12px;font-weight:600;color:var(--muted);margin-bottom:6px;text-transform:uppercase;letter-spacing:.04em;}
.field input,.field select,.field textarea{
  width:100%;background:#181B22;border:1px solid var(--steel);color:var(--off);
  border-radius:9px;padding:10px 12px;font-size:13.5px;outline:none;
}
.field textarea{resize:vertical;min-height:74px;}
.field input:focus,.field select:focus,.field textarea:focus{border-color:var(--orange);}
.grid-2{display:grid;grid-template-columns:1fr 1fr;gap:12px;}
.modal-actions{display:flex;gap:10px;justify-content:flex-end;margin-top:18px;}
.form-error{background:rgba(251,90,106,.12);border:1px solid rgba(251,90,106,.35);color:#FFB4BC;
  border-radius:9px;padding:10px 12px;font-size:13px;margin-bottom:13px;display:none;}

.toast{position:fixed;bottom:26px;left:50%;transform:translate(-50%,90px);
  background:var(--grad-hot);color:#1A1C22;padding:13px 24px;border-radius:11px;
  font-size:14px;font-weight:700;z-index:200;transition:.25s;opacity:0;
  box-shadow:0 12px 34px rgba(255,138,31,.4);max-width:90vw;text-align:center;}
.toast.show{transform:translate(-50%,0);opacity:1;}

@media (max-width:900px){
  .stats{grid-template-columns:repeat(2,1fr);}
  .content{padding:18px 16px 70px;}
  .topbar{padding-left:16px;padding-right:16px;}
  .grid-2{grid-template-columns:1fr;}
}
</style>
</head>
<body>

<div class="topbar">
  <div class="brand">
    <span class="mark"></span>
    <div><h1>PrintKraft Xưởng</h1><span id="shopName">Sản phẩm của xưởng</span></div>
  </div>
  <div class="topbar-right">
    <a class="btn" href="dashBoard.jsp">← Bảng điều khiển</a>
    <a class="btn" href="thong-ke-doanh-thu.jsp">📈 Doanh thu</a>
  </div>
</div>

<div class="content">
  <div class="page-head">
    <div>
      <div class="crumbs">Trang chủ / Sản phẩm</div>
      <h2>Sản phẩm của xưởng</h2>
      <p>Thêm, sửa và ẩn/hiện sản phẩm. Dữ liệu lưu trực tiếp trong cơ sở dữ liệu và hiển thị ngay trên trang bán hàng.</p>
    </div>
    <button class="btn primary" type="button" id="addBtn">+ Thêm sản phẩm</button>
  </div>

  <div class="stats">
    <div class="stat"><div class="lbl">Tổng sản phẩm</div><div class="val" id="statTotal">—</div></div>
    <div class="stat"><div class="lbl">Đang bán</div><div class="val green" id="statActive">—</div></div>
    <div class="stat"><div class="lbl">Đã ẩn</div><div class="val red" id="statHidden">—</div></div>
    <div class="stat"><div class="lbl">Sắp hết hàng</div><div class="val orange" id="statLow">—</div></div>
  </div>

  <div class="toolbar">
    <div class="search">
      <span class="ic">🔍</span>
      <input type="text" id="searchInput" placeholder="Tìm theo tên sản phẩm hoặc danh mục...">
    </div>
    <span class="hint" id="countHint"></span>
  </div>

  <div class="table-wrap">
    <div class="table-scroll">
      <table>
        <thead>
        <tr>
          <th>Sản phẩm</th>
          <th>Danh mục</th>
          <th>Giá bán</th>
          <th>Tồn kho</th>
          <th>Đã bán</th>
          <th>Trạng thái</th>
          <th>Cập nhật</th>
          <th style="text-align:right;">Thao tác</th>
        </tr>
        </thead>
        <tbody id="tableBody"></tbody>
      </table>
    </div>
    <div class="empty" id="emptyState" style="display:none;"></div>
  </div>
</div>

<div class="modal" id="modal">
  <div class="modal-box">
    <div class="modal-head">
      <div>
        <h3 id="modalTitle">Thêm sản phẩm</h3>
        <p id="modalSub">Sản phẩm sẽ được đăng bán ngay sau khi lưu.</p>
      </div>
      <button class="close" type="button" id="closeBtn" aria-label="Đóng">✕</button>
    </div>
    <div class="form-error" id="formError"></div>
    <form id="productForm" autocomplete="off">
      <input type="hidden" id="fId">
      <div class="field">
        <label for="fName">Tên sản phẩm</label>
        <input type="text" id="fName" maxlength="200" required placeholder="VD: Móc khóa in 3D theo yêu cầu">
      </div>
      <div class="grid-2">
        <div class="field">
          <label for="fCategory">Danh mục</label>
          <select id="fCategory" required></select>
        </div>
        <div class="field">
          <label for="fPrice">Giá bán (₫)</label>
          <input type="number" id="fPrice" min="0" max="999999999999" step="1" required placeholder="120000">
        </div>
      </div>
      <div class="grid-2">
        <div class="field">
          <label for="fStock">Tồn kho</label>
          <input type="number" id="fStock" min="0" max="1000000" step="1" required placeholder="50">
        </div>
        <div class="field">
          <label for="fThumb">Ảnh đại diện (URL, không bắt buộc)</label>
          <input type="text" id="fThumb" maxlength="500" placeholder="/images/...">
        </div>
      </div>
      <div class="field">
        <label for="fDesc">Mô tả ngắn (không bắt buộc)</label>
        <textarea id="fDesc" maxlength="500" placeholder="Chất liệu, kích thước, thời gian in..."></textarea>
      </div>
      <div class="modal-actions">
        <button class="btn" type="button" id="cancelBtn">Hủy</button>
        <button class="btn primary" type="submit" id="saveBtn">Lưu sản phẩm</button>
      </div>
    </form>
  </div>
</div>

<div class="toast" id="toast">Đã thực hiện</div>

<script>
(function () {
  'use strict';

  var CTX = document.querySelector('meta[name="app-ctx"]').content;
  var CSRF = document.querySelector('meta[name="csrf-token"]').content;
  var API = CTX + '/nhacungcap/api/products';

  var state = { shop: null, categories: [], products: [], q: '', editing: null };

  var $ = function (id) { return document.getElementById(id); };

  function esc(value) {
    return String(value == null ? '' : value)
      .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;').replace(/'/g, '&#39;');
  }
  function money(n) { return Number(n || 0).toLocaleString('vi-VN') + '₫'; }

  var toastTimer;
  function toast(msg) {
    var el = $('toast');
    el.textContent = msg;
    el.classList.add('show');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(function () { el.classList.remove('show'); }, 2300);
  }

  function showFormError(msg) {
    var el = $('formError');
    el.textContent = msg || '';
    el.style.display = msg ? 'block' : 'none';
  }

  function load() {
    fetch(API, { headers: { 'Accept': 'application/json' }, credentials: 'same-origin' })
      .then(function (res) {
        return res.json().catch(function () { return {}; }).then(function (data) {
          if (!res.ok) throw new Error(data.error || 'Không tải được sản phẩm.');
          return data;
        });
      })
      .then(function (data) {
        state.shop = data.shop;
        state.categories = data.categories || [];
        state.products = data.products || [];
        if (data.shop && data.shop.shopName) {
          $('shopName').textContent = data.shop.shopName;
        }
        render();
      })
      .catch(function (err) {
        $('tableBody').innerHTML = '';
        $('emptyState').style.display = 'block';
        $('emptyState').innerHTML = '<strong>Không tải được sản phẩm</strong>' + esc(err.message)
          + '<div class="hint" style="margin-top:8px;">Nếu phiên đăng nhập đã hết hạn, hãy đăng nhập lại.</div>';
      });
  }

  function filtered() {
    var q = state.q;
    if (!q) return state.products;
    return state.products.filter(function (p) {
      return (p.name + ' ' + p.categoryName + ' ' + p.slug).toLowerCase().indexOf(q) !== -1;
    });
  }

  function render() {
    var list = filtered();
    var total = state.products.length;
    var active = state.products.filter(function (p) { return p.status === 'ACTIVE'; }).length;
    var hidden = total - active;
    var low = state.products.filter(function (p) { return p.status === 'ACTIVE' && p.stock <= 5; }).length;

    $('statTotal').textContent = total;
    $('statActive').textContent = active;
    $('statHidden').textContent = hidden;
    $('statLow').textContent = low;
    $('countHint').textContent = list.length + ' / ' + total + ' sản phẩm';

    if (!list.length) {
      $('tableBody').innerHTML = '';
      $('emptyState').style.display = 'block';
      $('emptyState').innerHTML = total
        ? '<strong>Không có sản phẩm phù hợp</strong>Thử từ khóa khác.'
        : '<strong>Xưởng chưa có sản phẩm</strong>Bấm “Thêm sản phẩm” để tạo sản phẩm đầu tiên.';
      return;
    }
    $('emptyState').style.display = 'none';

    $('tableBody').innerHTML = list.map(function (p) {
      var statusBadge = p.status === 'ACTIVE'
        ? '<span class="badge active">Đang bán</span>'
        : '<span class="badge hidden">Đã ẩn</span>';
      var stockBadge = p.stock <= 5
        ? ' <span class="badge low">Sắp hết</span>'
        : '';
      return '<tr>'
        + '<td><div class="pname">' + esc(p.name) + '</div><div class="pslug">' + esc(p.slug) + '</div></td>'
        + '<td>' + esc(p.categoryName) + '</td>'
        + '<td class="money">' + money(p.price) + '</td>'
        + '<td>' + p.stock + stockBadge + '</td>'
        + '<td>' + p.sold + '</td>'
        + '<td>' + statusBadge + '</td>'
        + '<td class="hint">' + esc(p.updatedAt) + '</td>'
        + '<td><div class="row-actions">'
        + '<button class="mini-btn" type="button" data-edit="' + p.id + '">Sửa</button>'
        + (p.status === 'ACTIVE'
          ? '<button class="mini-btn danger" type="button" data-hide="' + p.id + '">Ẩn</button>'
          : '<button class="mini-btn" type="button" data-show="' + p.id + '">Bán lại</button>')
        + '</div></td>'
        + '</tr>';
    }).join('');
  }

  function openModal(product) {
    state.editing = product || null;
    showFormError('');
    $('modalTitle').textContent = product ? 'Sửa sản phẩm' : 'Thêm sản phẩm';
    $('modalSub').textContent = product
      ? 'Cập nhật thông tin, giá và tồn kho của sản phẩm.'
      : 'Sản phẩm sẽ được đăng bán ngay sau khi lưu.';
    $('fId').value = product ? product.id : '';
    $('fName').value = product ? product.name : '';
    $('fPrice').value = product ? product.price : '';
    $('fStock').value = product ? product.stock : '';
    $('fThumb').value = product && product.thumbnail ? product.thumbnail : '';
    $('fDesc').value = product && product.description ? product.description : '';

    $('fCategory').innerHTML = state.categories.map(function (c) {
      return '<option value="' + c.id + '">' + esc(c.name) + '</option>';
    }).join('');
    if (product) $('fCategory').value = String(product.categoryId);

    $('modal').classList.add('show');
    $('fName').focus();
  }

  function closeModal() {
    $('modal').classList.remove('show');
    state.editing = null;
  }

  function post(params) {
    return fetch(API, {
      method: 'POST',
      credentials: 'same-origin',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
        'Accept': 'application/json',
        'X-Requested-With': CSRF
      },
      body: params.toString()
    }).then(function (res) {
      return res.json().catch(function () { return {}; }).then(function (data) {
        if (!res.ok) throw new Error(data.error || 'Không lưu được sản phẩm.');
        return data;
      });
    });
  }

  $('productForm').addEventListener('submit', function (e) {
    e.preventDefault();
    showFormError('');
    var btn = $('saveBtn');
    var params = new URLSearchParams();
    params.set('action', state.editing ? 'update' : 'create');
    if (state.editing) params.set('id', state.editing.id);
    params.set('name', $('fName').value.trim());
    params.set('categoryId', $('fCategory').value);
    params.set('price', $('fPrice').value);
    params.set('stock', $('fStock').value);
    params.set('description', $('fDesc').value.trim());
    params.set('thumbnail', $('fThumb').value.trim());

    btn.disabled = true;
    btn.textContent = 'Đang lưu…';
    post(params)
      .then(function () {
        toast(state.editing ? 'Đã cập nhật sản phẩm' : 'Đã thêm sản phẩm');
        closeModal();
        load();
      })
      .catch(function (err) { showFormError(err.message); })
      .finally(function () {
        btn.disabled = false;
        btn.textContent = 'Lưu sản phẩm';
      });
  });

  $('tableBody').addEventListener('click', function (e) {
    var editId = e.target.getAttribute('data-edit');
    var hideId = e.target.getAttribute('data-hide');
    var showId = e.target.getAttribute('data-show');
    if (editId) {
      var product = state.products.find(function (p) { return String(p.id) === editId; });
      if (product) openModal(product);
      return;
    }
    if (hideId || showId) {
      var id = hideId || showId;
      var next = hideId ? 'HIDDEN' : 'ACTIVE';
      var label = hideId ? 'Ẩn sản phẩm này khỏi trang bán hàng?' : 'Đăng bán lại sản phẩm này?';
      if (!window.confirm(label)) return;
      var params = new URLSearchParams();
      params.set('action', 'status');
      params.set('id', id);
      params.set('status', next);
      post(params)
        .then(function () {
          toast(next === 'ACTIVE' ? 'Đã đăng bán lại sản phẩm' : 'Đã ẩn sản phẩm');
          load();
        })
        .catch(function (err) { toast(err.message); });
    }
  });

  $('searchInput').addEventListener('input', function (e) {
    state.q = e.target.value.trim().toLowerCase();
    render();
  });

  $('addBtn').addEventListener('click', function () {
    if (!state.categories.length) { toast('Chưa tải được danh mục, vui lòng tải lại trang'); return; }
    openModal(null);
  });
  $('closeBtn').addEventListener('click', closeModal);
  $('cancelBtn').addEventListener('click', closeModal);
  $('modal').addEventListener('click', function (e) {
    if (e.target === $('modal')) closeModal();
  });
  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') closeModal();
  });

  load();
})();
</script>
</body>
</html>
