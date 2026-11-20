<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%--
  Quản lý sản phẩm của Người bán (xưởng in).
  Dữ liệu đọc/ghi qua /nhacungcap/api/products (SellerProductApiServlet) và lưu
  trong bảng products — không dùng localStorage. supplier_id luôn lấy từ
  session + DB ở phía server.
--%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Sản phẩm của xưởng — PrintKraft</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="app-ctx" content="${ctx}">
<meta name="csrf-token" content="<c:out value='${sessionScope.csrfToken}'/>">
<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${ctx}/Admin/admin.css">
<style>
    /* Bố cục 4 thẻ số liệu + các thành phần riêng của trang sản phẩm,
       dùng chung biến màu và kiểu chữ với trang bảng sản xuất / đơn hàng. */
    .section-grid.four{grid-template-columns:repeat(4,1fr);}
    .chip-row{display:flex; gap:6px; flex-wrap:wrap; align-items:center;}
    #searchInput{width:320px; max-width:100%;}
    .pname{font-weight:600;}
    .date-cell{font-family:'IBM Plex Mono',monospace; font-size:12px; color:var(--muted);}
    .table-wrap table{min-width:1000px;}
    .pager{display:flex; justify-content:space-between; align-items:center; gap:12px;
        padding:12px 20px; border-top:1px solid var(--line); flex-wrap:wrap;}
    .pager .pager-info{font-size:11.5px; color:var(--muted);}
    .pager .pager-btns{display:flex; gap:6px; align-items:center;}
    .pager .pager-btns .current{
        border:1px solid var(--cobalt); background:var(--cobalt); color:white;
        border-radius:7px; padding:6px 10px; font-size:12px; font-weight:600;}
    .alert.err{background:#FFF0F0; border-color:#FFC9C9; color:#C92A2A;}
    .alert.ok{background:#EBFBEE; border-color:#B2F2BB; color:#2B8A3E;}
    .loading-cell{padding:34px 20px; text-align:center; color:var(--muted); font-size:13px;}
    @media (max-width:1100px){
        .section-grid.four{grid-template-columns:repeat(2,1fr);}
    }
    @media (max-width:600px){
        .section-grid.four{grid-template-columns:1fr;}
    }
</style>
</head>
<body>
<div class="layout">

    <aside class="sidebar">
        <div class="brand"><span class="sq"></span> PrintKraft Xưởng</div>

        <div class="nav-group">
            <div class="nav-label">Vận hành</div>
            <a class="nav-item" href="${ctx}/NhaCungCap/dashBoard.jsp"><span class="ic">▤</span> Bảng sản xuất</a>
            <a class="nav-item active" href="${ctx}/NhaCungCap/quan-ly-san-pham.jsp"><span class="ic">🏷️</span> Sản phẩm</a>
            <a class="nav-item" href="${ctx}/NhaCungCap/don-hang"><span class="ic">📦</span> Đơn hàng</a>
            <a class="nav-item" href="${ctx}/NhaCungCap/thong-ke-doanh-thu.jsp"><span class="ic">📈</span> Doanh thu</a>
        </div>

        <div class="sidebar-foot">
            <div class="avatar">
                <c:out value="${fn:toUpperCase(fn:substring(sessionScope.currentUser.fullName, 0, 1))}"/>
            </div>
            <div>
                <strong><c:out value="${sessionScope.currentUser.fullName}"/></strong>
                <span>Người bán</span>
            </div>
        </div>
    </aside>

    <div class="main">
        <div class="topbar">
            <div>
                <h1>Sản phẩm của xưởng</h1>
                <div class="sub" id="shopName">Sản phẩm thuộc cửa hàng của bạn · đọc và ghi trực tiếp vào bảng products</div>
            </div>
            <div class="topbar-right">
                <a class="btn" href="${ctx}/NhaCungCap/don-hang">📦 Đơn hàng</a>
                <form method="post" action="${ctx}/logout" style="display:inline;">
                    <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>">
                    <button class="btn" type="submit">Đăng xuất</button>
                </form>
            </div>
        </div>

        <div class="content">

            <div class="section-grid four">
                <div class="metric-card">
                    <div>
                        <div class="metric-title">Tổng sản phẩm</div>
                        <div class="metric-value num" id="statTotal">—</div>
                        <div class="metric-note">Toàn bộ sản phẩm của xưởng</div>
                    </div>
                    <div class="metric-icon">🏷️</div>
                </div>
                <div class="metric-card">
                    <div>
                        <div class="metric-title">Đang bán</div>
                        <div class="metric-value num" id="statActive">—</div>
                        <div class="metric-note">Hiển thị trên trang bán hàng</div>
                    </div>
                    <div class="metric-icon green">✓</div>
                </div>
                <div class="metric-card">
                    <div>
                        <div class="metric-title">Đã ẩn</div>
                        <div class="metric-value num" id="statHidden">—</div>
                        <div class="metric-note">Tạm ngừng bán</div>
                    </div>
                    <div class="metric-icon red">◌</div>
                </div>
                <div class="metric-card">
                    <div>
                        <div class="metric-title">Sắp hết hàng</div>
                        <div class="metric-value num" id="statLow">—</div>
                        <div class="metric-note">Tồn kho từ 5 trở xuống</div>
                    </div>
                    <div class="metric-icon amber">⏱</div>
                </div>
            </div>

            <div class="panel">
                <div class="panel-head">
                    <div>
                        <h3>Danh sách sản phẩm</h3>
                        <div class="panel-subtitle"><span id="countHint">Đang tải…</span></div>
                    </div>
                    <div class="inline-actions">
                        <a class="btn" href="${ctx}/NhaCungCap/quan-ly-san-pham.jsp">↻ Tải lại</a>
                        <button class="btn primary" type="button" id="addBtn">+ Thêm sản phẩm</button>
                    </div>
                </div>

                <div class="toolbar">
                    <input class="search-box" type="text" id="searchInput"
                           placeholder="Tìm theo tên sản phẩm hoặc danh mục…" aria-label="Tìm sản phẩm">
                    <div class="chip-row" id="statusFilter">
                        <button class="stats-chip active" type="button" data-status="">Tất cả</button>
                        <button class="stats-chip" type="button" data-status="ACTIVE">Đang bán</button>
                        <button class="stats-chip" type="button" data-status="HIDDEN">Đã ẩn</button>
                    </div>
                </div>

                <div class="table-wrap">
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
                <div class="empty-state" id="emptyState" style="display:none;"></div>
                <div class="pager" id="pager" style="display:none;">
                    <span class="pager-info" id="pageInfo"></span>
                    <div class="pager-btns">
                        <button class="mini-btn" type="button" id="prevPage">← Trước</button>
                        <span class="current" id="pageNow"></span>
                        <button class="mini-btn" type="button" id="nextPage">Sau →</button>
                    </div>
                    <span class="pager-info">Sản phẩm ẩn sẽ không hiển thị trên trang bán hàng.</span>
                </div>
            </div>

        </div>
    </div>
</div>

<div class="overlay" id="overlay"></div>
<div class="modal" id="modal">
    <div class="modal-box">
        <button class="modal-close" type="button" id="closeBtn" aria-label="Đóng">✕</button>
        <h3 id="modalTitle">Thêm sản phẩm</h3>
        <div class="sub" id="modalSub">Sản phẩm sẽ được đăng bán ngay sau khi lưu.</div>
        <div class="alert err" id="formError" style="display:none; margin-bottom:14px;"></div>
        <form id="productForm" autocomplete="off">
            <input type="hidden" id="fId">
            <div class="form-grid modal-form-grid">
                <div class="form-field" style="grid-column:1/-1;">
                    <label for="fName">Tên sản phẩm</label>
                    <input type="text" id="fName" maxlength="200" required placeholder="VD: Móc khóa in 3D theo yêu cầu">
                </div>
                <div class="form-field">
                    <label for="fCategory">Danh mục</label>
                    <select id="fCategory" required></select>
                </div>
                <div class="form-field">
                    <label for="fPrice">Giá bán (₫)</label>
                    <input type="number" id="fPrice" min="0" max="999999999999" step="1" required placeholder="120000">
                </div>
                <div class="form-field">
                    <label for="fStock">Tồn kho</label>
                    <input type="number" id="fStock" min="0" max="1000000" step="1" required placeholder="50">
                </div>
                <div class="form-field">
                    <label for="fThumb">Ảnh đại diện (URL, không bắt buộc)</label>
                    <input type="text" id="fThumb" maxlength="500" placeholder="/images/...">
                </div>
                <div class="form-field" style="grid-column:1/-1;">
                    <label for="fDesc">Mô tả ngắn (không bắt buộc)</label>
                    <textarea id="fDesc" maxlength="500" placeholder="Chất liệu, kích thước, thời gian in..."></textarea>
                </div>
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

  var state = {
    shop: null, categories: [], products: [], stats: { total: 0, active: 0, hidden: 0, lowStock: 0 },
    q: '', status: '', page: 1, size: 10, pages: 0, total: 0, editing: null, loading: false
  };

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
    el.style.display = msg ? 'flex' : 'none';
  }

  function setLoading() {
    state.loading = true;
    $('emptyState').style.display = 'none';
    $('pager').style.display = 'none';
    $('countHint').textContent = 'Đang tải…';
    $('tableBody').innerHTML = '<tr><td colspan="8" class="loading-cell">Đang tải sản phẩm…</td></tr>';
  }

  /** Tải một trang sản phẩm từ server (tìm kiếm + lọc trạng thái + phân trang đều do API xử lý). */
  function load(page) {
    if (page) state.page = page;
    setLoading();
    var qs = new URLSearchParams();
    if (state.q) qs.set('q', state.q);
    if (state.status) qs.set('status', state.status);
    qs.set('page', state.page);
    qs.set('size', state.size);

    fetch(API + '?' + qs.toString(), {
      headers: { 'Accept': 'application/json' }, credentials: 'same-origin'
    })
      .then(function (res) {
        return res.json().catch(function () { return {}; }).then(function (data) {
          if (!res.ok) throw new Error(data.error || 'Không tải được sản phẩm.');
          return data;
        });
      })
      .then(function (data) {
        state.loading = false;
        state.shop = data.shop;
        state.categories = data.categories || [];
        state.products = data.products || [];
        state.stats = data.stats || state.stats;
        state.page = Number(data.page) || 1;
        state.pages = Number(data.pages) || 0;
        state.total = Number(data.total) || 0;
        if (data.shop && data.shop.shopName) {
          $('shopName').textContent = 'Sản phẩm thuộc xưởng ' + data.shop.shopName
            + ' · đọc và ghi trực tiếp vào bảng products';
        }
        render();
      })
      .catch(function (err) {
        state.loading = false;
        $('tableBody').innerHTML = '';
        $('pager').style.display = 'none';
        $('countHint').textContent = 'Không tải được dữ liệu';
        $('emptyState').style.display = 'block';
        $('emptyState').innerHTML = '<strong>Không tải được sản phẩm</strong>' + esc(err.message)
          + '<div class="table-note" style="margin-top:8px;">Nếu phiên đăng nhập đã hết hạn, hãy đăng nhập lại.</div>';
      });
  }

  function render() {
    var list = state.products;
    var stats = state.stats || {};

    $('statTotal').textContent = stats.total || 0;
    $('statActive').textContent = stats.active || 0;
    $('statHidden').textContent = stats.hidden || 0;
    $('statLow').textContent = stats.lowStock || 0;
    $('countHint').textContent = state.total + ' sản phẩm khớp bộ lọc hiện tại';

    if (!list.length) {
      $('tableBody').innerHTML = '';
      $('pager').style.display = 'none';
      $('emptyState').style.display = 'block';
      $('emptyState').innerHTML = (state.q || state.status)
        ? '<strong>Không có sản phẩm phù hợp</strong>Thử từ khóa khác hoặc bỏ bộ lọc trạng thái.'
        : '<strong>Xưởng chưa có sản phẩm</strong>Bấm “Thêm sản phẩm” để tạo sản phẩm đầu tiên.';
      return;
    }
    $('emptyState').style.display = 'none';

    $('tableBody').innerHTML = list.map(function (p) {
      var statusBadge = p.status === 'ACTIVE'
        ? '<span class="pill green"><span class="dot"></span>Đang bán</span>'
        : '<span class="pill gray"><span class="dot"></span>Đã ẩn</span>';
      var stockBadge = p.stock === 0
        ? ' <span class="pill red"><span class="dot"></span>Hết hàng</span>'
        : p.stock <= 5
          ? ' <span class="pill amber"><span class="dot"></span>Sắp hết</span>'
          : '';
      return '<tr>'
        + '<td><div class="pname">' + esc(p.name) + '</div><div class="table-note">' + esc(p.slug) + '</div></td>'
        + '<td>' + esc(p.categoryName) + '</td>'
        + '<td class="mono">' + money(p.price) + '</td>'
        + '<td class="num">' + p.stock + stockBadge + '</td>'
        + '<td class="num">' + p.sold + '</td>'
        + '<td>' + statusBadge + '</td>'
        + '<td class="date-cell">' + esc(p.updatedAt) + '</td>'
        + '<td><div class="action-menu" style="justify-content:flex-end; min-width:0;">'
        + '<button class="mini-btn" type="button" data-edit="' + p.id + '">Sửa</button>'
        + (p.status === 'ACTIVE'
          ? '<button class="mini-btn danger" type="button" data-hide="' + p.id + '">Ẩn</button>'
          : '<button class="mini-btn success" type="button" data-show="' + p.id + '">Bán lại</button>')
        + '</div></td>'
        + '</tr>';
    }).join('');

    $('pager').style.display = 'flex';
    var start = (state.page - 1) * state.size + 1;
    var end = start + list.length - 1;
    $('pageInfo').textContent = 'Hiển thị ' + start + '–' + end + ' / ' + state.total + ' sản phẩm';
    $('pageNow').textContent = 'Trang ' + state.page + (state.pages ? ' / ' + state.pages : '');
    $('prevPage').disabled = state.page <= 1;
    $('nextPage').disabled = state.pages === 0 || state.page >= state.pages;
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

    $('overlay').classList.add('show');
    $('modal').classList.add('show');
    $('fName').focus();
  }

  function closeModal() {
    $('modal').classList.remove('show');
    $('overlay').classList.remove('show');
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
    var editing = !!state.editing;
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
        toast(editing ? 'Đã cập nhật sản phẩm' : 'Đã thêm sản phẩm');
        closeModal();
        // Sản phẩm mới nằm ở trang 1; sửa sản phẩm thì giữ nguyên trang đang xem.
        load(editing ? state.page : 1);
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
          load(state.page);
        })
        .catch(function (err) { toast(err.message); });
    }
  });

  var searchTimer;
  $('searchInput').addEventListener('input', function (e) {
    state.q = e.target.value.trim();
    clearTimeout(searchTimer);
    searchTimer = setTimeout(function () { load(1); }, 300);
  });

  $('statusFilter').addEventListener('click', function (e) {
    var btn = e.target.closest('[data-status]');
    if (!btn) return;
    state.status = btn.getAttribute('data-status') || '';
    $('statusFilter').querySelectorAll('.stats-chip').forEach(function (c) {
      c.classList.toggle('active', c === btn);
    });
    load(1);
  });

  $('prevPage').addEventListener('click', function () {
    if (state.page > 1) load(state.page - 1);
  });
  $('nextPage').addEventListener('click', function () {
    if (state.pages && state.page < state.pages) load(state.page + 1);
  });

  $('addBtn').addEventListener('click', function () {
    if (!state.categories.length) { toast('Chưa tải được danh mục, vui lòng tải lại trang'); return; }
    openModal(null);
  });

  $('closeBtn').addEventListener('click', closeModal);
  $('cancelBtn').addEventListener('click', closeModal);
  $('overlay').addEventListener('click', closeModal);
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
