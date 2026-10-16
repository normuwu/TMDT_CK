
(function () {
  'use strict';

  /* ---------- Hằng số & cấu hình dữ liệu mẫu ---------- */
  var DATA_START = '2026-01-01';
  var AVG_ORDER = 561000;
  var CANCEL = 'Hoàn/Hủy';
  var CANCEL_RATE = 0.021;
  // Doanh thu mục tiêu theo tháng 2026 (khớp biểu đồ "Doanh thu theo tháng" cũ). Tháng chưa có -> DEFAULT.
  var MONTH_TARGET = { '2026-01': 1.6e9, '2026-02': 1.4e9, '2026-03': 2.1e9, '2026-04': 2.4e9, '2026-05': 2.7e9,
                       '2026-06': 2.6e9, '2026-07': 3.0e9, '2026-08': 3.2e9, '2026-09': 3.84e9 };
  var DEFAULT_MONTH_REVENUE = 4.0e9;
  var WEEKDAY_FACTOR = [1.0, 1.05, 1.0, 1.1, 1.15, 0.9, 0.8]; // T2..CN

  var CATEGORIES = [
    { name: 'Mô hình Luffy',        w: 38, mult: 1.25 },
    { name: 'Mô hình Zoro',    w: 26, mult: 0.90 },
    { name: 'Mô hình Mixi Gaming',  w: 17, mult: 1.00 },
    { name: 'Chi tiết cơ khí',       w: 12, mult: 0.70 },
    { name: 'Khác',                 w: 7,  mult: 0.80 }
  ];
  var SUPPLIERS = [
    { name: 'Sài Gòn Print',    w: 28 }, { name: 'Hà Nội Digital',   w: 22 },
    { name: 'Đà Nẵng Xpress',   w: 17 }, { name: 'Cần Thơ Print',    w: 12 },
    { name: 'Hải Phòng In Ấn',  w: 9 },  { name: 'Xưởng khác',       w: 12 }
  ];
  var STATUS_COLORS = { 'Hoàn tất': '#2F9E44', 'Đang sản xuất': '#3B5BDB', 'Đang giao': '#15AABF', 'Hoàn/Hủy': '#E03131' };
  var PALETTE = ['#3B5BDB', '#7C5CFC', '#12B886', '#F59F00', '#E03131', '#15AABF', '#868E96'];
  var DIMENSIONS = {
    category: { field: 'cat',    label: 'nhóm sản phẩm' },
    supplier: { field: 'sup',    label: 'xưởng in' },
    status:   { field: 'status', label: 'trạng thái đơn' }
  };

  /* ---------- Tiện ích ngày tháng (dùng chuỗi YYYY-MM-DD, tính theo UTC để tránh lệch múi giờ) ---------- */
  function pad(n) { return n < 10 ? '0' + n : '' + n; }
  function toKey(d) { return d.getUTCFullYear() + '-' + pad(d.getUTCMonth() + 1) + '-' + pad(d.getUTCDate()); }
  function fromKey(k) { var p = k.split('-'); return new Date(Date.UTC(+p[0], +p[1] - 1, +p[2])); }
  function addDays(k, n) { var d = fromKey(k); d.setUTCDate(d.getUTCDate() + n); return toKey(d); }
  function diffDays(a, b) { return Math.round((fromKey(b) - fromKey(a)) / 864e5); }
  function todayKey() { var n = new Date(); return n.getFullYear() + '-' + pad(n.getMonth() + 1) + '-' + pad(n.getDate()); }
  function fmtDMY(k) { var p = k.split('-'); return p[2] + '/' + p[1] + '/' + p[0]; }
  function fmtDM(k) { var p = k.split('-'); return p[2] + '/' + p[1]; }
  function monthLastDay(y, m) { return new Date(Date.UTC(y, m, 0)).getUTCDate(); }
  var mondayCache = {};
  function mondayOf(k) {
    if (mondayCache[k]) return mondayCache[k];
    var d = fromKey(k);
    d.setUTCDate(d.getUTCDate() - ((d.getUTCDay() + 6) % 7));
    return (mondayCache[k] = toKey(d));
  }

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

  /* ---------- Sinh dữ liệu đơn hàng mẫu (deterministic: cùng ngày -> cùng dữ liệu) ---------- */
  function mulberry32(seed) {
    return function () {
      seed |= 0; seed = (seed + 0x6D2B79F5) | 0;
      var t = Math.imul(seed ^ (seed >>> 15), 1 | seed);
      t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
      return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
    };
  }
  function pickWeighted(rand, items) {
    var total = 0, i;
    for (i = 0; i < items.length; i++) total += items[i].w;
    var r = rand() * total;
    for (i = 0; i < items.length; i++) { r -= items[i].w; if (r < 0) return items[i]; }
    return items[items.length - 1];
  }

  function loadOrders(endKey) {
    var orders = [];
    var first = fromKey(DATA_START);
    var y = first.getUTCFullYear(), m = first.getUTCMonth() + 1;
    var endMonth = endKey.slice(0, 7);

    while ((y + '-' + pad(m)) <= endMonth) {
      var monthKey = y + '-' + pad(m);
      var days = monthLastDay(y, m);
      var target = MONTH_TARGET[monthKey] || DEFAULT_MONTH_REVENUE;
      var monthOrders = [], revenue = 0;

      for (var day = 1; day <= days; day++) {
        var key = monthKey + '-' + pad(day);
        var rand = mulberry32(diffDays(DATA_START, key) * 7919 + 12345);
        var wd = (fromKey(key).getUTCDay() + 6) % 7;
        var count = Math.round(target / AVG_ORDER / days * WEEKDAY_FACTOR[wd] * (0.85 + 0.3 * rand()));
        var age = diffDays(key, endKey);

        for (var i = 0; i < count; i++) {
          var cat = pickWeighted(rand, CATEGORIES);
          var sup = pickWeighted(rand, SUPPLIERS);
          var amt = Math.round((80000 + Math.pow(rand(), 2.2) * 1540000) * cat.mult / 1000) * 1000;
          var rc = rand(), rs = rand(), status;
          if (rc < CANCEL_RATE) status = CANCEL;
          else if (age >= 7) status = 'Hoàn tất';
          else if (age >= 3) status = rs < 0.7 ? 'Hoàn tất' : 'Đang giao';
          else status = rs < 0.15 ? 'Hoàn tất' : (rs < 0.5 ? 'Đang giao' : 'Đang sản xuất');
          if (status !== CANCEL) revenue += amt;
          monthOrders.push({ d: key, cat: cat.name, sup: sup.name, status: status, amt: amt });
        }
      }
      // Chuẩn hóa để tổng doanh thu tháng khớp đúng mục tiêu (chỉ với tháng có số liệu chốt)
      var factor = MONTH_TARGET[monthKey] && revenue > 0 ? target / revenue : 1;
      for (var j = 0; j < monthOrders.length; j++) {
        var o = monthOrders[j];
        if (o.d > endKey) break;
        if (factor !== 1) o.amt = Math.round(o.amt * factor / 1000) * 1000;
        orders.push(o);
      }
      if (++m > 12) { m = 1; y++; }
    }
    return orders;
  }

  /* ---------- Truy vấn / tổng hợp ---------- */
  function summarize(orders, from, to) {
    var s = { rev: 0, orders: 0, cancel: 0 };
    for (var i = 0; i < orders.length; i++) {
      var o = orders[i];
      if (o.d < from || o.d > to) continue;
      s.orders++;
      if (o.status === CANCEL) s.cancel++; else s.rev += o.amt;
    }
    s.avg = s.orders - s.cancel > 0 ? s.rev / (s.orders - s.cancel) : 0;
    s.cancelRate = s.orders ? s.cancel / s.orders * 100 : 0;
    return s;
  }

  function resolveGroup(from, to, mode) {
    if (mode !== 'auto') return mode;
    var n = diffDays(from, to) + 1;
    return n <= 31 ? 'day' : (n <= 140 ? 'week' : 'month');
  }

  function buildBuckets(from, to, group) {
    var list = [], k;
    if (group === 'day') {
      for (k = from; k <= to; k = addDays(k, 1)) list.push({ key: k, label: fmtDM(k), title: fmtDMY(k), rev: 0, orders: 0 });
    } else if (group === 'week') {
      for (k = mondayOf(from); k <= to; k = addDays(k, 7)) {
        var s = k < from ? from : k, e = addDays(k, 6) > to ? to : addDays(k, 6);
        list.push({ key: k, label: fmtDM(s), title: fmtDMY(s) + ' – ' + fmtDMY(e), rev: 0, orders: 0 });
      }
    } else {
      var a = fromKey(from), y = a.getUTCFullYear(), m = a.getUTCMonth() + 1;
      var endMonth = to.slice(0, 7);
      while ((y + '-' + pad(m)) <= endMonth) {
        var ms = y + '-' + pad(m) + '-01', me = y + '-' + pad(m) + '-' + pad(monthLastDay(y, m));
        var cs = ms < from ? from : ms, ce = me > to ? to : me;
        var partial = (cs !== ms || ce !== me);
        list.push({ key: y + '-' + pad(m), label: 'T' + m + '/' + String(y).slice(2),
                    title: 'Tháng ' + m + '/' + y + (partial ? ' (' + fmtDM(cs) + ' – ' + fmtDM(ce) + ')' : ''), rev: 0, orders: 0 });
        if (++m > 12) { m = 1; y++; }
      }
    }
    return list;
  }

  function bucketKeyOf(dateKey, group) {
    return group === 'day' ? dateKey : (group === 'week' ? mondayOf(dateKey) : dateKey.slice(0, 7));
  }

  function aggregateByTime(orders, from, to, group) {
    var buckets = buildBuckets(from, to, group), index = {}, i;
    for (i = 0; i < buckets.length; i++) index[buckets[i].key] = buckets[i];
    for (i = 0; i < orders.length; i++) {
      var o = orders[i];
      if (o.d < from || o.d > to) continue;
      var b = index[bucketKeyOf(o.d, group)];
      if (!b) continue;
      b.orders++;
      if (o.status !== CANCEL) b.rev += o.amt;
    }
    return buckets;
  }

  function aggregateByDimension(orders, from, to, dim, metric) {
    var field = DIMENSIONS[dim].field, byCount = (dim === 'status' || metric === 'orders'), map = {}, total = 0;
    for (var i = 0; i < orders.length; i++) {
      var o = orders[i];
      if (o.d < from || o.d > to) continue;
      var v = byCount ? 1 : (o.status === CANCEL ? 0 : o.amt);
      if (!v) continue;
      map[o[field]] = (map[o[field]] || 0) + v;
      total += v;
    }
    var slices = Object.keys(map).map(function (name) { return { name: name, value: map[name] }; });
    slices.sort(function (a, b) { return b.value - a.value; });
    slices.forEach(function (s, idx) {
      s.pct = total ? s.value / total * 100 : 0;
      s.color = (dim === 'status' && STATUS_COLORS[s.name]) || PALETTE[idx % PALETTE.length];
    });
    return { slices: slices, total: total, byCount: byCount };
  }

  /* ---------- Trạng thái giao diện ---------- */
  var TODAY = todayKey();
  var ORDERS = loadOrders(TODAY);
  var ui = { from: null, to: null, groupMode: 'auto', metric: 'revenue', dim: 'category' };
  var $ = function (id) { return document.getElementById(id); };
  var barData = [];

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

  function notify(msg) { if (typeof toast === 'function') toast(msg); }

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
    if (!wrap || !wrap.clientWidth) return; // đang ẩn (tab khác) -> ResizeObserver sẽ gọi lại khi hiện
    var group = resolveGroup(ui.from, ui.to, ui.groupMode);
    barData = aggregateByTime(ORDERS, ui.from, ui.to, group);
    var groupName = { day: 'ngày', week: 'tuần', month: 'tháng' }[group];
    $('statsBarSub').textContent = fmtDMY(ui.from) + ' – ' + fmtDMY(ui.to) + ' · Nhóm theo ' + groupName;

    var metric = ui.metric, vals = barData.map(function (b) { return metric === 'revenue' ? b.rev : b.orders; });
    var total = vals.reduce(function (a, b) { return a + b; }, 0);
    if (!total) {
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
        tip.innerHTML = '<b>' + esc(b.title) + '</b>Doanh thu: ' + fullVND(b.rev) + '<br>Số đơn: ' + thousands(b.orders);
        tip.classList.add('show'); placeTip(tip, wrap, e);
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
    var res = aggregateByDimension(ORDERS, ui.from, ui.to, ui.dim, ui.metric);
    var unit = res.byCount ? 'theo số đơn' : 'theo doanh thu';
    $('statsPieSub').textContent = 'Tỷ trọng ' + DIMENSIONS[ui.dim].label + ' · ' + unit;
    var fmt = res.byCount ? function (v) { return thousands(v) + ' đơn'; } : fullVND;
    var fmtShort = res.byCount ? function (v) { return thousands(v); } : compactVND;

    if (!res.total) {
      wrap.innerHTML = '<div class="stats-empty">Không có dữ liệu trong khoảng thời gian đã chọn.</div>';
      legend.innerHTML = '';
      return;
    }

    var S = 240, c = S / 2, R = 100, angle = -Math.PI / 2, svg = '<svg class="stats-svg stats-pie-svg" width="' + S + '" height="' + S + '" viewBox="0 0 ' + S + ' ' + S + '" role="img" aria-label="Biểu đồ tròn ' + esc(DIMENSIONS[ui.dim].label) + '">';
    res.slices.forEach(function (s, i) {
      var sweep = s.value / res.total * Math.PI * 2, a1 = angle + sweep, mid = angle + sweep / 2;
      var dx = Math.cos(mid) * 7, dy = Math.sin(mid) * 7;
      if (res.slices.length === 1) {
        svg += '<g class="stats-slice" data-i="' + i + '" data-dx="' + dx + '" data-dy="' + dy + '"><circle cx="' + c + '" cy="' + c + '" r="' + R + '" fill="' + s.color + '" stroke="#fff" stroke-width="2"/></g>';
      } else {
        var x0 = c + R * Math.cos(angle), y0 = c + R * Math.sin(angle), x1 = c + R * Math.cos(a1), y1 = c + R * Math.sin(a1);
        svg += '<g class="stats-slice" data-i="' + i + '" data-dx="' + dx + '" data-dy="' + dy + '"><path d="M' + c + ',' + c + 'L' + x0 + ',' + y0 + 'A' + R + ',' + R + ' 0 ' + (sweep > Math.PI ? 1 : 0) + ' 1 ' + x1 + ',' + y1 + 'Z" fill="' + s.color + '" stroke="#fff" stroke-width="2"/></g>';
      }
      if (s.pct >= 6) {
        var lx = c + R * 0.62 * Math.cos(mid), ly = c + R * 0.62 * Math.sin(mid);
        svg += '<text x="' + lx + '" y="' + (ly + 4) + '" text-anchor="middle" font-size="12" font-weight="700" fill="#fff" pointer-events="none">' + dec(s.pct, 1) + '%</text>';
      }
      angle = a1;
    });
    svg += '</svg><div class="stats-tip" id="statsPieTip"></div>';
    wrap.innerHTML = svg;

    legend.innerHTML = res.slices.map(function (s, i) {
      return '<div class="stats-legend-row" data-i="' + i + '"><span class="stats-dot" style="background:' + s.color + '"></span>' +
             '<span class="stats-legend-name">' + esc(s.name) + '</span>' +
             '<span class="stats-legend-val">' + fmtShort(s.value) + '</span>' +
             '<span class="stats-legend-pct">' + dec(s.pct, 1) + '%</span></div>';
    }).join('');

    var tip = $('statsPieTip');
    function setActive(i) {
      wrap.querySelectorAll('.stats-slice').forEach(function (g) {
        var on = i !== null && +g.getAttribute('data-i') === i;
        g.style.transform = on ? 'translate(' + g.getAttribute('data-dx') + 'px,' + g.getAttribute('data-dy') + 'px)' : '';
        g.classList.toggle('dim', i !== null && !on);
      });
      legend.querySelectorAll('.stats-legend-row').forEach(function (r) { r.classList.toggle('active', i !== null && +r.getAttribute('data-i') === i); });
    }
    wrap.querySelectorAll('.stats-slice').forEach(function (g) {
      g.addEventListener('mousemove', function (e) {
        var i = +g.getAttribute('data-i'), s = res.slices[i];
        tip.innerHTML = '<b>' + esc(s.name) + '</b>' + fmt(s.value) + ' · ' + dec(s.pct, 1) + '%';
        tip.classList.add('show'); placeTip(tip, wrap, e); setActive(i);
      });
      g.addEventListener('mouseleave', function () { tip.classList.remove('show'); setActive(null); });
    });
    legend.querySelectorAll('.stats-legend-row').forEach(function (r) {
      r.addEventListener('mouseenter', function () { setActive(+r.getAttribute('data-i')); });
      r.addEventListener('mouseleave', function () { setActive(null); });
    });
  }

  /* ---------- Bảng xếp hạng xưởng in theo khoảng thời gian đã chọn ---------- */
  function renderTopSuppliers() {
    var host = $('statsTopSuppliers');
    if (!host) return;
    var res = aggregateByDimension(ORDERS, ui.from, ui.to, 'supplier', 'revenue'), counts = {}, i;
    for (i = 0; i < ORDERS.length; i++) {
      var o = ORDERS[i];
      if (o.d < ui.from || o.d > ui.to || o.status === CANCEL) continue;
      counts[o.sup] = (counts[o.sup] || 0) + 1;
    }
    if (!res.slices.length) {
      host.innerHTML = '<div class="empty-state"><strong>Chưa có dữ liệu</strong>Không có đơn hàng trong khoảng thời gian đã chọn.</div>';
      return;
    }
    var max = res.slices[0].value || 1;
    host.innerHTML = res.slices.slice(0, 5).map(function (s) {
      var width = Math.max(4, Math.round(s.value / max * 100));
      return '<div class="list-item"><div><div class="name">' + esc(s.name) + '</div><div class="meta">' +
             compactVND(s.value) + ' · ' + thousands(counts[s.name] || 0) + ' đơn · ' + dec(s.pct, 1) + '%</div></div>' +
             '<div><div class="bar-bg"><div class="bar-fill" style="width:' + width + '%"></div></div></div></div>';
    }).join('');
  }

  /* ---------- KPI theo khoảng đã chọn (so với kỳ liền trước cùng độ dài) ---------- */
  function setDelta(id, text, cls) { var el = $(id); if (el) { el.textContent = text; el.className = 'delta' + (cls ? ' ' + cls : ''); } }
  function pctDelta(id, cur, prev, hasPrev) {
    if (!hasPrev || !prev) return setDelta(id, '— chưa có kỳ trước để so sánh', '');
    var p = (cur - prev) / prev * 100;
    setDelta(id, (p >= 0 ? '▲ ' : '▼ ') + dec(Math.abs(p), 1) + '% so với kỳ trước', p >= 0 ? 'up' : 'down');
  }
  function renderKpis() {
    var cur = summarize(ORDERS, ui.from, ui.to), len = diffDays(ui.from, ui.to) + 1;
    var prevTo = addDays(ui.from, -1), prevFrom = addDays(prevTo, -(len - 1));
    var hasPrev = prevFrom >= DATA_START, prev = hasPrev ? summarize(ORDERS, prevFrom, prevTo) : null;

    $('statKpiRevenue').textContent = compactVND(cur.rev);
    $('statKpiOrders').textContent = thousands(cur.orders);
    $('statKpiAvg').textContent = compactVND(cur.avg);
    $('statKpiCancel').textContent = dec(cur.cancelRate, 1) + '%';

    pctDelta('statDeltaRevenue', cur.rev, prev && prev.rev, hasPrev);
    pctDelta('statDeltaOrders', cur.orders, prev && prev.orders, hasPrev);
    pctDelta('statDeltaAvg', cur.avg, prev && prev.avg, hasPrev);
    if (!hasPrev || !prev.orders) setDelta('statDeltaCancel', '— chưa có kỳ trước để so sánh', '');
    else {
      var d = cur.cancelRate - prev.cancelRate; // tỉ lệ hoàn/hủy càng thấp càng tốt
      setDelta('statDeltaCancel', (d > 0 ? '▲ ' : '▼ ') + dec(Math.abs(d), 1) + ' điểm % so với kỳ trước', d > 0 ? 'down' : 'up');
    }
  }

  function markPresets() {
    document.querySelectorAll('.stats-chip').forEach(function (chip) {
      var r = presetRange(chip.getAttribute('data-preset'));
      chip.classList.toggle('active', r[0] === ui.from && r[1] === ui.to);
    });
  }

  function renderAll() {
    $('statsFrom').value = ui.from; $('statsTo').value = ui.to;
    markPresets(); renderKpis(); renderBar(); renderPie(); renderTopSuppliers();
  }

  /* ---------- Sự kiện ---------- */
  function applyRange() {
    var from = $('statsFrom').value, to = $('statsTo').value;
    if (!from || !to) return notify('Vui lòng chọn đầy đủ "Từ ngày" và "Đến ngày"');
    if (from > to) return notify('"Từ ngày" phải nhỏ hơn hoặc bằng "Đến ngày"');
    if (to > TODAY) { to = TODAY; notify('Đã giới hạn "Đến ngày" tối đa là hôm nay (' + fmtDMY(TODAY) + ')'); }
    if (from < DATA_START) { from = DATA_START; notify('Dữ liệu thống kê bắt đầu từ ' + fmtDMY(DATA_START)); }
    if (from > to) return notify('Khoảng thời gian không có dữ liệu');
    ui.from = from; ui.to = to; renderAll();
  }

  function setActiveTab(container, attr, value) {
    container.querySelectorAll('.tab').forEach(function (t) { t.classList.toggle('active', t.getAttribute(attr) === value); });
  }

  function exportCsv() {
    if (typeof downloadCsv !== 'function' || typeof csvCell !== 'function') return notify('Không thể xuất CSV');
    var rows = ['Kỳ,Doanh thu (đ),Số đơn'].concat(barData.map(function (b) { return [b.title, b.rev, b.orders].map(csvCell).join(','); }));
    downloadCsv('thong-ke-doanh-thu_' + ui.from + '_' + ui.to + '.csv', rows);
    notify('Đã xuất dữ liệu thống kê');
  }

  function init() {
    if (!$('statsBarChart')) return;
    var r = presetRange('30'); ui.from = r[0]; ui.to = r[1];
    ['statsFrom', 'statsTo'].forEach(function (id) { $(id).min = DATA_START; $(id).max = TODAY; });

    $('statsApply').addEventListener('click', applyRange);
    ['statsFrom', 'statsTo'].forEach(function (id) {
      $(id).addEventListener('keydown', function (e) { if (e.key === 'Enter') applyRange(); });
    });
    $('statsGroup').addEventListener('change', function (e) { ui.groupMode = e.target.value; renderBar(); });
    document.querySelectorAll('.stats-chip').forEach(function (chip) {
      chip.addEventListener('click', function () {
        var p = presetRange(chip.getAttribute('data-preset')); ui.from = p[0]; ui.to = p[1]; renderAll();
      });
    });
    $('statsMetricTabs').addEventListener('click', function (e) {
      var tab = e.target.closest('.tab'); if (!tab) return;
      ui.metric = tab.getAttribute('data-metric'); setActiveTab($('statsMetricTabs'), 'data-metric', ui.metric); renderBar(); renderPie();
    });
    $('statsDimTabs').addEventListener('click', function (e) {
      var tab = e.target.closest('.tab'); if (!tab) return;
      ui.dim = tab.getAttribute('data-dim'); setActiveTab($('statsDimTabs'), 'data-dim', ui.dim); renderPie();
    });
    $('statsExport').addEventListener('click', exportCsv);

    // Vẽ lại khi tab "Báo cáo" được hiện ra hoặc khi đổi kích thước cửa sổ
    if (window.ResizeObserver) {
      var raf = 0;
      new ResizeObserver(function () { cancelAnimationFrame(raf); raf = requestAnimationFrame(renderBar); }).observe($('statsBarChart'));
    } else {
      window.addEventListener('resize', renderBar);
    }
    renderAll();
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init); else init();
})();
