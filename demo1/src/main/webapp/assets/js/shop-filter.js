/* ============================================================
   PRINTKRAFT — LỌC SẢN PHẨM KHÔNG RELOAD (assets/js/shop-filter.js)
   Chỉ dùng ở trang danh sách sản phẩm (san_pham.jsp).

   Server vẫn render JSP như bình thường; script fetch cùng URL rồi thay
   các fragment .grid / .pager / .toolbar .count. Nhờ vậy chỉ có MỘT nguồn
   render (JSP), không sợ JSON và JSP hiển thị lệch nhau.

   Mọi lỗi mạng/parse đều rơi về điều hướng cổ điển (location.href).
   ============================================================ */
(function () {
  var form = document.getElementById('filterForm');
  var grid = document.querySelector('.shop .grid');
  if (!form || !grid) return;

  var controller = null;

  function urlFromForm() {
    var url = new URL(form.action, location.href);
    new FormData(form).forEach(function (v, k) {
      if (k === 'csrfToken') return;
      if (String(v).trim() === '') url.searchParams.delete(k);
      else url.searchParams.set(k, v);
    });
    /* Ô tìm kiếm nằm ngoài <form>, liên kết qua thuộc tính form="filterForm" */
    var q = document.querySelector('input[name="q"][form="filterForm"]');
    if (q) {
      if (q.value.trim()) url.searchParams.set('q', q.value.trim());
      else url.searchParams.delete('q');
    }
    url.searchParams.delete('page');   /* đổi bộ lọc -> quay về trang 1 */
    return url;
  }

  function load(url, push) {
    if (controller) controller.abort();
    controller = new AbortController();
    grid.setAttribute('aria-busy', 'true');

    fetch(url.toString(), { signal: controller.signal, headers: { 'Accept': 'text/html' } })
      .then(function (r) {
        if (!r.ok) throw new Error('HTTP ' + r.status);
        return r.text();
      })
      .then(function (html) {
        var doc = new DOMParser().parseFromString(html, 'text/html');
        var freshGrid = doc.querySelector('.shop .grid');
        if (!freshGrid) throw new Error('Không tìm thấy .grid');

        grid.innerHTML = freshGrid.innerHTML;

        var freshCount = doc.querySelector('.toolbar .count');
        var oldCount = document.querySelector('.toolbar .count');
        if (freshCount && oldCount) oldCount.innerHTML = freshCount.innerHTML;

        /* Nút "Xóa bộ lọc" trong sidebar cũng phải theo trạng thái mới */
        var freshActions = doc.querySelector('#filterForm .f-actions');
        var oldActions = document.querySelector('#filterForm .f-actions');
        if (freshActions && oldActions) oldActions.innerHTML = freshActions.innerHTML;

        var freshPager = doc.querySelector('.pager');
        var oldPager = document.querySelector('.pager');
        if (freshPager && oldPager) oldPager.replaceWith(freshPager);
        else if (freshPager && !oldPager) grid.insertAdjacentElement('afterend', freshPager);
        else if (!freshPager && oldPager) oldPager.parentNode.removeChild(oldPager);

        if (push) history.pushState({ shop: true }, '', url.toString());
      })
      .catch(function (err) {
        if (err && err.name === 'AbortError') return;
        location.href = url.toString();
      })
      .then(function () {
        grid.removeAttribute('aria-busy');
      });
  }

  form.addEventListener('submit', function (e) {
    e.preventDefault();
    load(urlFromForm(), true);
  });

  ['fCategory', 'fMaterial', 'fSupplier', 'fSort'].forEach(function (id) {
    var el = document.getElementById(id);
    if (el) el.addEventListener('change', function () { load(urlFromForm(), true); });
  });

  /* Phân trang cũng không reload */
  document.addEventListener('click', function (e) {
    var a = e.target.closest ? e.target.closest('.pager a') : null;
    if (!a) return;
    e.preventDefault();
    load(new URL(a.href, location.href), true);
  });

  window.addEventListener('popstate', function () {
    load(new URL(location.href), false);
  });
})();
