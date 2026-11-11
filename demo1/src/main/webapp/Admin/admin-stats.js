/*
 * Thống kê doanh thu & cơ cấu cho trang Admin.
 * Dữ liệu lấy từ 2 API (không còn sinh dữ liệu mẫu trong JS):
 *   GET /admin/api/stats/revenue?from=&to=&group=day|week|month
 *   GET /admin/api/stats/breakdown?from=&to=&by=category|shop|status&metric=revenue|orders
 */
(function () {
  'use strict';

  var APP_CTX = (document.querySelector('meta[name="app-ctx"]') || {}).content || '';
  // Đường dẫn API thống kê: Admin dùng mặc định, Người bán khai báo qua <meta name="stats-api">.
  var STATS_PATH = (document.querySelector('meta[name="stats-api"]') || {}).content || '/admin/api/stats';
  var DATA_START = '2026-01-01';

  var STATUS_COLORS = {
    'Hoàn tất': '#2F9E44',
    'Đang giao': '#15AABF',
    'Đã xác nhận': '#3B5BDB',
    'Chờ xác nhận': '#F59F00',
    'Hoàn/Hủy': '#E03131'
  };
  var PALETTE = ['#3B5BDB', '#7C5CFC', '#12B886', '#F59F00', '#E03131', '#15AABF', '#868E96'];
  var DIM_LABELS = { category: 'nhóm sản phẩm', shop: 'xưởng in', status: 'trạng thái đơn' };

  /* ---------- Tiện ích ngày tháng (chuỗi YYYY-MM-DD, tính theo UTC) ---------- */
  function pad(n) { return n < 10 ? '0' + n : '' + n; }
  function toKey(d) { return d.getUTCFullYear() + '-' + pad(d.getUTCMonth() + 1) + '-' + pad(d.getUTCDate()); }
  function fromKey(k) { var p = k.split('-'); return new Date(Date.UTC(+p[0], +p[1] - 1, +p[2])); }
  function addDays(k, n) { var d = fromKey(k); d.setUTCDate(d.getUTCDate() + n); return toKey(d); }
  function diffDays(a, b) { return Math.round((fromKey(b) - fromKey(a)) / 864e5); }
  function todayKey() { var n = new Date(); return n.getFullYear() + '-' + pad(n.getMonth() + 1) + '-' + pad(n.getDate()); }
  function fmtDMY(k) { var p = k.split('-'); return p[2] + '/' + p[1] + '/' + p[0]; }
  function monthLastDay(y, m) { return new Date(Date.UTC(y, m, 0)).getUTCDate(); }

  /* ---------- Định dạng số (kiểu Việt Nam) ---------- */
  function dec(x, digits) {
    var f = Math.pow(10, digits);
    return (Math.round(x * f) / f).toString().replace('.', ',');
  }
  function thousands(n) { return String(Math.round(n)).replace(/\B(?=(\d{3})+(?!\d))/g, '.'); }
  function compactVND(v) {
    if (v >= 1e9) return dec(v / 1e9, 2) + ' tỷ';
    if (v >= 1e6) return dec(v / 1e6, 1) + ' tr';
    if (v >= 1e3) return Math.round(v / 1e3) + 'K';
    return String(Math.round(v));
  }
  function fullVND(v) { return thousands(v) + 'đ'; }
  function esc(s) {
    return String(s).replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
    });
  }
  function notify(msg) { if (typeof toast === 'function') toast(msg); }

  /* ---------- Gọi API ---------- */
  function apiGet(path, params) {
    var qs = new URLSearchParams(params).toString();
    return fetch(APP_CTX + path + '?' + qs, {
      credentials: 'same-origin',
      headers: { 'Accept': 'application/json' }
    }).then(function (response) {
      var type = response.headers.get('content-type') || '';
      if (response.status === 401 || response.status === 403) {
        window.location.assign(APP_CTX + '/login');
        throw new Error('Phiên đăng nhập đã hết hạn.');
      }
      if (!type.includes('json')) {
        if (!response.ok) throw new Error('Máy chủ trả về lỗi ' + response.status + '.');
        return null;
      }
      return response.json().then(function (payload) {
        if (!response.ok) throw new Error(payload && payload.error ? payload.error : 'Không tải được dữ liệu thống kê.');
        return payload;
      });
    });
  }

  /* ---------- Trạng thái giao diện ---------- */
  var TODAY = todayKey();
  var ui = { from: null, to: null, groupMode: 'auto', metric: 'revenue', dim: 'category' };
  var $ = function (id) { return document.getElementById(id); };
  var barData = [];
  var pieData = { by: 'category', metric: 'revenue', total: 0, slices: [] };
  var topShops = [];
  var loading = false;

  function apiDim(dim) { return dim === 'supplier' ? 'shop' : dim; }

  function setLoading(isLoading) {
    loading = isLoading;
    var apply = $('statsApply');
    if (apply) apply.disabled = isLoading;
    if (isLoading) {
      if ($('statsBarSub')) $('statsBarSub').textContent = 'Đang tải dữ liệu…';
      if ($('statsPieSub')) $('statsPieSub').textContent = 'Đang tải dữ liệu…';
    }
  }

  function presetRange(name) {
    var t = TODAY, y = +t.slice(0, 4), m = +t.slice(5, 7), from = t, to = t;
    if (name === '7') from = addDays(t, -6);
    else if (name === '30') from = addDays(t, -29);
    else if (name === 'month') from = y + '-' + pad(m) + '-01';
    else if (name === 'lastmonth') {
      var py = m === 1 ? y - 1 : y, pm = m === 1 ? 12 : m - 1;
      from = py + '-' + pad(pm) + '-01'; to = py + '-' + pad(pm) + '-' + pad(monthLastDay(py, pm));
    } else if (name === 'quarter') from = y + '-' + pad(Math.floor((m - 1) / 3) * 3 + 1) + '-01';
    else if (name === 'year') from = y + '-01-01';
    if (from < DATA_START) from = DATA_START;
    if (to < DATA_START) to = DATA_START;
    return [from, to];
  }

  function resolveGroup(from, to, mode) {
    if (mode !== 'auto') return mode;
    var n = diffDays(from, to) + 1;
    return n <= 31 ? 'day' : (n <= 140 ? 'week' : 'month');
  }

  /* ---------- Nạp dữ liệu ---------- */
  function refreshAll() {
    if (loading) return;
    var group = resolveGroup(ui.from, ui.to, ui.groupMode);
    setLoading(true);
    Promise.all([
      apiGet(STATS_PATH + '/revenue', { from: ui.from, to: ui.to, group: group }),
      apiGet(STATS_PATH + '/breakdown', { from: ui.from, to: ui.to, by: apiDim(ui.dim), metric: ui.metric }),
      apiGet(STATS_PATH + '/breakdown', { from: ui.from, to: ui.to, by: 'shop', metric: 'revenue' })
    ]).then(function (results) {
      barData = Array.isArray(results[0].buckets) ? results[0].buckets : [];
      pieData = results[1] || pieData;
      topShops = (results[2] && Array.isArray(results[2].slices)) ? results[2].slices : [];
      renderKpis(results[0].kpi);
      renderBar();
      renderPie();
      renderTopSuppliers();
    }).catch(function (error) {
      notify(error.message || 'Không tải được dữ liệu thống kê.');
      if ($('statsBarSub')) $('statsBarSub').textContent = 'Không tải được dữ liệu';
      if ($('statsPieSub')) $('statsPieSub').textContent = 'Không tải được dữ liệu';
    }).finally(function () {
      setLoading(false);
    });
  }

  function refreshPie() {
    if (loading) return;
    setLoading(true);
    apiGet(STATS_PATH + '/breakdown',
        { from: ui.from, to: ui.to, by: apiDim(ui.dim), metric: ui.metric })
      .then(function (result) {
        pieData = result;
        renderBar();
        renderPie();
      })
      .catch(function (error) { notify(error.message || 'Không tải được dữ liệu cơ cấu.'); })
      .finally(function () { setLoading(false); });
  }

  /* ---------- Biểu đồ cột ---------- */
  function niceScale(max) {
    if (max <= 0) return { max: 4, step: 1 };
    var raw = max / 4, pow = Math.pow(10, Math.floor(Math.log(raw) / Math.LN10)), f = raw / pow;
    var nf = f <= 1 ? 1 : f <= 2 ? 2 : f <= 2.5 ? 2.5 : f <= 5 ? 5 : 10;
    var step = nf * pow;
    return { max: Math.ceil(max / step) * step, step: step };
  }
  function topRoundedBar(x, y, w, h, r) {
    r = Math.min(r, w / 2, h);
    return 'M' + x + ',' + (y + h) + 'V' + (y + r) + 'Q' + x + ',' + y + ' ' + (x + r) + ',' + y +
      'H' + (x + w - r) + 'Q' + (x + w) + ',' + y + ' ' + (x + w) + ',' + (y + r) + 'V' + (y + h) + 'Z';
  }
  function placeTip(tip, wrap, evt) {
    var box = wrap.getBoundingClientRect();
    var x = evt.clientX - box.left + 14, y = evt.clientY - box.top + 14;
    if (x + tip.offsetWidth > box.width - 4) x = evt.clientX - box.left - tip.offsetWidth - 14;
    if (y + tip.offsetHeight > box.height - 4) y = evt.clientY - box.top - tip.offsetHeight - 14;
    tip.style.left = Math.max(4, x) + 'px';
    tip.style.top = Math.max(4, y) + 'px';
  }

  function renderBar() {
    var wrap = $('statsBarChart');
    if (!wrap || !wrap.clientWidth) return; // đang ẩn -> ResizeObserver gọi lại khi hiện

    var group = resolveGroup(ui.from, ui.to, ui.groupMode);
    var groupName = { day: 'ngày', week: 'tuần', month: 'tháng' }[group];
    $('statsBarSub').textContent = fmtDMY(ui.from) + ' – ' + fmtDMY(ui.to) + ' · Nhóm theo ' + groupName;

    var metric = ui.metric;
    var vals = barData.map(function (b) { return Number(metric === 'revenue' ? b.revenue : b.orders) || 0; });
    var total = vals.reduce(function (a, b) { return a + b; }, 0);
    if (!barData.length || !total) {
      wrap.innerHTML = '<div class="stats-empty">Không có dữ liệu trong khoảng thời gian đã chọn.</div>';
      return;
    }

    var W = wrap.clientWidth, H = 300, pl = 58, pr = 14, pt = 26, pb = 36;
    var pw = W - pl - pr, ph = H - pt - pb, n = barData.length;
    var sc = niceScale(Math.max.apply(null, vals));
    var band = pw / n, bw = Math.max(3, Math.min(band * 0.68, 56));
    var fmtAxis = metric === 'revenue' ? compactVND : function (v) { return thousands(v); };
    var svg = '<svg class="stats-svg" width="' + W + '" height="' + H + '" viewBox="0 0 ' + W + ' ' + H + '" role="img" aria-label="Biểu đồ cột ' +
      (metric === 'revenue' ? 'doanh thu' : 'số đơn') + ' theo ' + groupName + '">' +
      '<defs><linearGradient id="statsBarGrad" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#7C5CFC"/><stop offset="1" stop-color="#3B5BDB"/></linearGradient></defs>';

    for (var t = 0; t * sc.step <= sc.max + 1e-9; t++) {
      var gy = pt + ph - ph * (t * sc.step) / sc.max;
      svg += '<line x1="' + pl + '" x2="' + (W - pr) + '" y1="' + gy + '" y2="' + gy + '" stroke="' + (t ? '#EDEFF4' : '#CBD0DA') + '"/>' +
        '<text x="' + (pl - 8) + '" y="' + (gy + 4) + '" text-anchor="end" font-size="11" fill="#6B7280">' + (t ? fmtAxis(t * sc.step) : '0') + '</text>';
    }

    var labelStep = Math.max(1, Math.ceil(n / Math.max(1, Math.floor(pw / 52))));
    var showValues = n <= 14;
    for (var i = 0; i < n; i++) {
      var v = vals[i], bh = ph * v / sc.max, bx = pl + band * i + (band - bw) / 2, by = pt + ph - bh, cx = pl + band * i + band / 2;
      if (v > 0) svg += '<path class="stats-bar" data-i="' + i + '" d="' + topRoundedBar(bx, by, bw, bh, 4) + '" fill="url(#statsBarGrad)"/>';
      if (showValues && v > 0) svg += '<text x="' + cx + '" y="' + (by - 6) + '" text-anchor="middle" font-size="11" font-weight="600" fill="#1E2430">' + fmtAxis(v) + '</text>';
      if (i % labelStep === 0) svg += '<text x="' + cx + '" y="' + (H - 14) + '" text-anchor="middle" font-size="11" fill="#6B7280">' + esc(barData[i].label) + '</text>';
      svg += '<rect class="stats-hit" data-i="' + i + '" x="' + (pl + band * i) + '" y="' + pt + '" width="' + band + '" height="' + ph + '" fill="transparent"/>';
    }
    svg += '</svg><div class="stats-tip" id="statsBarTip"></div>';
    wrap.innerHTML = svg;

    var tip = $('statsBarTip');
    wrap.querySelectorAll('.stats-hit').forEach(function (hit) {
      hit.addEventListener('mousemove', function (e) {
        var b = barData[+hit.getAttribute('data-i')];
        tip.innerHTML = '<b>' + esc(b.title) + '</b>Doanh thu: ' + fullVND(Number(b.revenue) || 0) +
          '<br>Số đơn: ' + thousands(Number(b.orders) || 0);
        tip.classList.add('show');
        placeTip(tip, wrap, e);
        wrap.querySelectorAll('.stats-bar').forEach(function (p) { p.classList.toggle('dim', p.getAttribute('data-i') !== hit.getAttribute('data-i')); });
      });
      hit.addEventListener('mouseleave', function () {
        tip.classList.remove('show');
        wrap.querySelectorAll('.stats-bar').forEach(function (p) { p.classList.remove('dim'); });
      });
    });
  }

  /* ---------- Biểu đồ tròn ---------- */
  function renderPie() {
    var wrap = $('statsPieChart'), legend = $('statsPieLegend');
    if (!wrap) return;

    var res = pieData || { total: 0, slices: [] };
    var by = res.by || apiDim(ui.dim);
    var byCount = res.metric === 'orders';
    var slices = Array.isArray(res.slices) ? res.slices : [];
    var total = Number(res.total) || 0;
    var fmt = byCount ? function (v) { return thousands(v) + ' đơn'; } : fullVND;
    var fmtShort = byCount ? function (v) { return thousands(v); } : compactVND;

    $('statsPieSub').textContent = 'Tỷ trọng ' + (DIM_LABELS[by] || by) + ' · ' + (byCount ? 'theo số đơn' : 'theo doanh thu');

    if (!slices.length || !total) {
      wrap.innerHTML = '<div class="stats-empty">Không có dữ liệu trong khoảng thời gian đã chọn.</div>';
      legend.innerHTML = '';
      return;
    }

    var S = 240, c = S / 2, R = 100, angle = -Math.PI / 2, i;
    var svg = '<svg class="stats-svg stats-pie-svg" width="' + S + '" height="' + S + '" viewBox="0 0 ' + S + ' ' + S + '" role="img" aria-label="Biểu đồ tròn ' + esc(DIM_LABELS[by] || by) + '">';
    var parts = slices.map(function (slice, index) {
      var value = Number(slice.value) || 0;
      return {
        name: slice.name,
        value: value,
        pct: total ? value / total * 100 : 0,
        color: (by === 'status' && STATUS_COLORS[slice.name]) || PALETTE[index % PALETTE.length]
      };
    });

    parts.forEach(function (s, index) {
      var sweep = s.value / total * Math.PI * 2, a1 = angle + sweep, mid = angle + sweep / 2;
      var dx = Math.cos(mid) * 7, dy = Math.sin(mid) * 7;
      if (parts.length === 1) {
        svg += '<g class="stats-slice" data-i="' + index + '" data-dx="' + dx + '" data-dy="' + dy + '"><circle cx="' + c + '" cy="' + c + '" r="' + R + '" fill="' + s.color + '" stroke="#fff" stroke-width="2"/></g>';
      } else {
        var x0 = c + R * Math.cos(angle), y0 = c + R * Math.sin(angle), x1 = c + R * Math.cos(a1), y1 = c + R * Math.sin(a1);
        svg += '<g class="stats-slice" data-i="' + index + '" data-dx="' + dx + '" data-dy="' + dy + '"><path d="M' + c + ',' + c + 'L' + x0 + ',' + y0 + 'A' + R + ',' + R + ' 0 ' + (sweep > Math.PI ? 1 : 0) + ' 1 ' + x1 + ',' + y1 + 'Z" fill="' + s.color + '" stroke="#fff" stroke-width="2"/></g>';
      }
      if (s.pct >= 6) {
        var lx = c + R * 0.62 * Math.cos(mid), ly = c + R * 0.62 * Math.sin(mid);
        svg += '<text x="' + lx + '" y="' + (ly + 4) + '" text-anchor="middle" font-size="12" font-weight="700" fill="#fff" pointer-events="none">' + dec(s.pct, 1) + '%</text>';
      }
      angle = a1;
    });
    svg += '</svg><div class="stats-tip" id="statsPieTip"></div>';
    wrap.innerHTML = svg;

    legend.innerHTML = parts.map(function (s, index) {
      return '<div class="stats-legend-row" data-i="' + index + '"><span class="stats-dot" style="background:' + s.color + '"></span>' +
        '<span class="stats-legend-name">' + esc(s.name) + '</span>' +
        '<span class="stats-legend-val">' + fmtShort(s.value) + '</span>' +
        '<span class="stats-legend-pct">' + dec(s.pct, 1) + '%</span></div>';
    }).join('');

    var tip = $('statsPieTip');
    function setActive(index) {
      wrap.querySelectorAll('.stats-slice').forEach(function (g) {
        var on = index !== null && +g.getAttribute('data-i') === index;
        g.style.transform = on ? 'translate(' + g.getAttribute('data-dx') + 'px,' + g.getAttribute('data-dy') + 'px)' : '';
        g.classList.toggle('dim', index !== null && !on);
      });
      legend.querySelectorAll('.stats-legend-row').forEach(function (row) {
        row.classList.toggle('active', index !== null && +row.getAttribute('data-i') === index);
      });
    }
    wrap.querySelectorAll('.stats-slice').forEach(function (g) {
      g.addEventListener('mousemove', function (e) {
        var index = +g.getAttribute('data-i'), s = parts[index];
        tip.innerHTML = '<b>' + esc(s.name) + '</b>' + fmt(s.value) + ' · ' + dec(s.pct, 1) + '%';
        tip.classList.add('show');
        placeTip(tip, wrap, e);
        setActive(index);
      });
      g.addEventListener('mouseleave', function () { tip.classList.remove('show'); setActive(null); });
    });
    legend.querySelectorAll('.stats-legend-row').forEach(function (row) {
      row.addEventListener('mouseenter', function () { setActive(+row.getAttribute('data-i')); });
      row.addEventListener('mouseleave', function () { setActive(null); });
    });
  }

  /* ---------- Top xưởng in ---------- */
  function renderTopSuppliers() {
    var host = $('statsTopSuppliers');
    if (!host) return;
    if (!topShops.length) {
      host.innerHTML = '<div class="empty-state"><strong>Chưa có dữ liệu</strong>Không có đơn COMPLETED trong khoảng thời gian đã chọn.</div>';
      return;
    }
    var total = topShops.reduce(function (sum, item) { return sum + (Number(item.value) || 0); }, 0);
    var max = Number(topShops[0].value) || 1;
    host.innerHTML = topShops.slice(0, 5).map(function (item) {
      var width = Math.max(4, Math.round((Number(item.value) || 0) / max * 100));
      var pct = total ? (Number(item.value) || 0) / total * 100 : 0;
      return '<div class="list-item"><div><div class="name">' + esc(item.name) + '</div><div class="meta">' +
        compactVND(Number(item.value) || 0) + ' · ' + dec(pct, 1) + '%</div></div>' +
        '<div><div class="bar-bg"><div class="bar-fill" style="width:' + width + '%"></div></div></div></div>';
    }).join('');
  }

  /* ---------- KPI ---------- */
  function setDelta(id, text, cls) {
    var el = $(id);
    if (el) { el.textContent = text; el.className = 'delta' + (cls ? ' ' + cls : ''); }
  }
  function pctDelta(id, cur, prev, hasPrev) {
    if (!hasPrev || !prev) return setDelta(id, '— chưa có kỳ trước để so sánh', '');
    var change = (cur - prev) / prev * 100;
    setDelta(id, (change >= 0 ? '▲ ' : '▼ ') + dec(Math.abs(change), 1) + '% so với kỳ trước', change >= 0 ? 'up' : 'down');
  }
  function renderKpis(kpi) {
    if (!kpi) return;
    var cur = {
      revenue: Number(kpi.revenue) || 0,
      orders: Number(kpi.orders) || 0,
      avg: Number(kpi.avgOrder) || 0,
      cancelRate: Number(kpi.cancelRate) || 0
    };
    var prev = kpi.prev ? {
      revenue: Number(kpi.prev.revenue) || 0,
      orders: Number(kpi.prev.orders) || 0,
      avg: Number(kpi.prev.avgOrder) || 0,
      cancelRate: Number(kpi.prev.cancelRate) || 0
    } : null;
    var hasPrev = !!prev && (prev.orders > 0 || prev.revenue > 0);

    $('statKpiRevenue').textContent = compactVND(cur.revenue);
    $('statKpiOrders').textContent = thousands(cur.orders);
    $('statKpiAvg').textContent = compactVND(cur.avg);
    $('statKpiCancel').textContent = dec(cur.cancelRate, 1) + '%';

    pctDelta('statDeltaRevenue', cur.revenue, prev && prev.revenue, hasPrev);
    pctDelta('statDeltaOrders', cur.orders, prev && prev.orders, hasPrev);
    pctDelta('statDeltaAvg', cur.avg, prev && prev.avg, hasPrev);
    if (!hasPrev || !prev.orders) {
      setDelta('statDeltaCancel', '— chưa có kỳ trước để so sánh', '');
    } else {
      var diff = cur.cancelRate - prev.cancelRate; // tỉ lệ hủy càng thấp càng tốt
      setDelta('statDeltaCancel', (diff > 0 ? '▲ ' : '▼ ') + dec(Math.abs(diff), 1) + ' điểm % so với kỳ trước', diff > 0 ? 'down' : 'up');
    }
  }

  /* ---------- Điều khiển ---------- */
  function markPresets() {
    document.querySelectorAll('.stats-chip').forEach(function (chip) {
      var range = presetRange(chip.getAttribute('data-preset'));
      chip.classList.toggle('active', range[0] === ui.from && range[1] === ui.to);
    });
  }

  function syncInputs() {
    $('statsFrom').value = ui.from;
    $('statsTo').value = ui.to;
    $('statsGroup').value = ui.groupMode;
    markPresets();
  }

  function applyRange() {
    var from = $('statsFrom').value, to = $('statsTo').value;
    if (!from || !to) return notify('Vui lòng chọn đầy đủ "Từ ngày" và "Đến ngày"');
    if (from > to) return notify('"Từ ngày" phải nhỏ hơn hoặc bằng "Đến ngày"');
    if (to > TODAY) return notify('"Đến ngày" không được vượt quá hôm nay (' + fmtDMY(TODAY) + ')');
    if (diffDays(from, to) + 1 > 366) return notify('Khoảng thời gian tối đa là 366 ngày');
    ui.from = from;
    ui.to = to;
    markPresets();
    refreshAll();
  }

  function setActiveTab(container, attr, value) {
    container.querySelectorAll('.tab').forEach(function (tab) {
      tab.classList.toggle('active', tab.getAttribute(attr) === value);
    });
  }

  function exportCsv() {
    if (typeof downloadCsv !== 'function' || typeof csvCell !== 'function') return notify('Không thể xuất CSV');
    if (!barData.length) return notify('Không có dữ liệu để xuất');
    var rows = ['Kỳ,Doanh thu (đ),Số đơn'].concat(barData.map(function (bucket) {
      return [bucket.title, Number(bucket.revenue) || 0, Number(bucket.orders) || 0].map(csvCell).join(',');
    }));
    downloadCsv('thong-ke-doanh-thu_' + ui.from + '_' + ui.to + '.csv', rows);
    notify('Đã xuất dữ liệu thống kê');
  }

  function init() {
    if (!$('statsBarChart')) return;
    var range = presetRange('30');
    ui.from = range[0];
    ui.to = range[1];
    ['statsFrom', 'statsTo'].forEach(function (id) {
      $(id).min = DATA_START;
      $(id).max = TODAY;
    });
    syncInputs();

    $('statsApply').addEventListener('click', applyRange);
    ['statsFrom', 'statsTo'].forEach(function (id) {
      $(id).addEventListener('keydown', function (e) { if (e.key === 'Enter') applyRange(); });
    });
    $('statsGroup').addEventListener('change', function (e) {
      ui.groupMode = e.target.value;
      refreshAll();
    });
    document.querySelectorAll('.stats-chip').forEach(function (chip) {
      chip.addEventListener('click', function () {
        var range = presetRange(chip.getAttribute('data-preset'));
        ui.from = range[0];
        ui.to = range[1];
        syncInputs();
        refreshAll();
      });
    });
    $('statsMetricTabs').addEventListener('click', function (e) {
      var tab = e.target.closest('.tab');
      if (!tab) return;
      ui.metric = tab.getAttribute('data-metric');
      setActiveTab($('statsMetricTabs'), 'data-metric', ui.metric);
      refreshPie();
    });
    $('statsDimTabs').addEventListener('click', function (e) {
      var tab = e.target.closest('.tab');
      if (!tab) return;
      ui.dim = tab.getAttribute('data-dim');
      setActiveTab($('statsDimTabs'), 'data-dim', ui.dim);
      refreshPie();
    });
    $('statsExport').addEventListener('click', exportCsv);

    // Vẽ lại khi tab "Báo cáo" được hiện ra hoặc khi đổi kích thước cửa sổ
    if (window.ResizeObserver) {
      var raf = 0;
      new ResizeObserver(function () { cancelAnimationFrame(raf); raf = requestAnimationFrame(renderBar); }).observe($('statsBarChart'));
    } else {
      window.addEventListener('resize', renderBar);
    }
    refreshAll();
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init); else init();
})();
