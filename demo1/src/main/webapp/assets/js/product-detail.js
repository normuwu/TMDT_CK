
document.addEventListener('DOMContentLoaded', function () {

    var nf = new Intl.NumberFormat('vi-VN');

    /* ---------- Thư viện ảnh: bấm ảnh nhỏ thì đổi ảnh lớn ---------- */
    var mainImg = document.getElementById('mainImg');
    var thumbs = document.querySelectorAll('.gallery-thumb');
    thumbs.forEach(function (t) {
        t.addEventListener('click', function () {
            if (mainImg && t.dataset.src) mainImg.src = t.dataset.src;
            thumbs.forEach(function (x) { x.classList.remove('active'); });
            t.classList.add('active');
        });
    });

    /* ---------- Giá theo vật liệu + số lượng ---------- */
    var priceEl = document.getElementById('priceValue');
    var subtotalEl = document.getElementById('subtotalValue');
    var qtyInput = document.getElementById('qtyInput');

    function selectedMaterial() {
        return document.querySelector('input[name="material"]:checked');
    }
    function unitPrice() {
        var r = selectedMaterial();
        if (r) return Number(r.dataset.price) || 0;
        return priceEl ? Number(priceEl.dataset.base) || 0 : 0;
    }
    function qty() {
        var n = parseInt(qtyInput && qtyInput.value, 10);
        return n >= 1 ? n : 1;
    }
    function refresh() {
        if (priceEl) priceEl.textContent = nf.format(unitPrice());
        if (subtotalEl) subtotalEl.textContent = nf.format(unitPrice() * qty());
    }
    document.querySelectorAll('input[name="material"]').forEach(function (r) {
        r.addEventListener('change', refresh);
    });

    /* ---------- Ô số lượng ---------- */
    function setQty(n) {
        var max = parseInt(qtyInput.max, 10);
        n = Math.max(1, n || 1);
        if (max > 0) n = Math.min(n, max);
        qtyInput.value = n;
        refresh();
    }
    if (qtyInput) {
        var minus = document.getElementById('qtyMinus');
        var plus = document.getElementById('qtyPlus');
        if (minus) minus.addEventListener('click', function () { setQty(qty() - 1); });
        if (plus) plus.addEventListener('click', function () { setQty(qty() + 1); });
        qtyInput.addEventListener('input', refresh);
        qtyInput.addEventListener('blur', function () { setQty(qty()); });
    }

    /* ---------- Thêm vào giỏ (demo: tăng số trên biểu tượng giỏ) ---------- */
    var addBtn = document.getElementById('addToCartBtn');
    if (addBtn) {
        addBtn.addEventListener('click', function () {
            var n = qty();
            var r = selectedMaterial();
            setCartCount(getCartCount() + n);
            var label = '"' + addBtn.dataset.name + '"' + (r ? ' (' + r.dataset.name + ')' : '');
            toastOk('Đã thêm ' + n + ' × ' + label + ' vào giỏ hàng');
        });
    }

    /* ---------- Form đánh giá: kiểm tra sơ bộ trước khi gửi ---------- */
    document.querySelectorAll('.review-form').forEach(function (form) {
        form.addEventListener('submit', function (e) {
            if (!form.querySelector('input[name="rating"]:checked')) {
                e.preventDefault();
                toastErr('Vui lòng chọn số sao đánh giá');
                return;
            }
            var c = form.querySelector('textarea[name="comment"]');
            if (c && c.value.trim().length < 5) {
                e.preventDefault();
                toastErr('Vui lòng nhập nhận xét (ít nhất 5 ký tự)');
            }
        });
    });

    refresh();
});