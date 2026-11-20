/* ============================================================
   PRINTKRAFT — THÊM VÀO GIỎ BẰNG AJAX (assets/js/cart-ajax.js)
   Nạp SAU site.js (hoặc printkraft.js) ở các trang có form thêm vào giỏ.

   Nguyên tắc: form vẫn là form POST thật (có csrfToken). Script chỉ chặn
   submit, gửi FormData bằng fetch và nhận JSON. JS lỗi/tắt -> form submit
   bình thường theo luồng PRG cũ.

   Lưu ý CSRF: CsrfFilter đọc token từ param csrfToken hoặc header
   X-Requested-With, nên KHÔNG gửi header X-Requested-With: XMLHttpRequest.
   ============================================================ */
(function () {
  var sessionEl = document.getElementById('pk-session');
  var ctx = sessionEl ? sessionEl.dataset.ctx : '';
  var toastTimer;

  function notify(msg, ok) {
    if (ok && typeof window.toastOk === 'function') { window.toastOk(msg); return; }
    if (!ok && typeof window.toastErr === 'function') { window.toastErr(msg); return; }

    var t = document.getElementById('toast');
    if (!t) { window.alert(msg); return; }
    t.textContent = msg;
    t.className = 'toast show ' + (ok ? 'ok' : 'err');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(function () { t.classList.remove('show'); }, 2600);
  }

  function setCount(n) {
    if (typeof window.setCartCount === 'function') { window.setCartCount(n); return; }
    var b = document.getElementById('cartBadge');
    if (b) b.textContent = n;
  }

  /* Ngăn kéo giỏ là HTML render từ session -> nạp lại riêng fragment cho khớp */
  function refreshDrawer() {
    var drawer = document.getElementById('cartDrawer');
    if (!drawer || !ctx) return;
    fetch(ctx + '/KhachHang/gio-hang-fragment', { headers: { 'Accept': 'text/html' } })
      .then(function (r) { return r.ok ? r.text() : Promise.reject(r.status); })
      .then(function (html) {
        var doc = new DOMParser().parseFromString(html, 'text/html');
        var fresh = doc.getElementById('cartDrawer');
        if (fresh) drawer.replaceWith(fresh);
      })
      .catch(function () { /* im lặng: badge + toast đã đủ thông tin */ });
  }

  document.addEventListener('submit', function (e) {
    var form = e.target.closest ? e.target.closest('form[action$="/them-vao-gio"]') : null;
    if (!form) return;

    e.preventDefault();
    var btn = form.querySelector('button[type="submit"]');
    var oldText = btn ? btn.textContent : '';

    if (btn) { btn.disabled = true; btn.textContent = 'Đang thêm...'; }

    fetch(form.action, {
      method: 'POST',
      body: new FormData(form),          /* đã chứa csrfToken -> CsrfFilter cho qua */
      headers: { 'Accept': 'application/json' },
      credentials: 'same-origin'
    })
      .then(function (r) {
        if (r.status === 403) throw new Error('Phiên làm việc đã hết hạn. Vui lòng tải lại trang.');
        if (!r.ok) throw new Error('Máy chủ trả về lỗi ' + r.status);
        return r.json();
      })
      .then(function (data) {
        notify(data.message || 'Đã thêm vào giỏ hàng.', !!data.ok);
        if (data.ok) {
          setCount(data.cartCount);
          refreshDrawer();
        }
      })
      .catch(function (err) {
        notify(err.message || 'Không thêm được vào giỏ hàng.', false);
      })
      .then(function () {
        if (btn) { btn.disabled = false; btn.textContent = oldText; }
      });
  });
})();
