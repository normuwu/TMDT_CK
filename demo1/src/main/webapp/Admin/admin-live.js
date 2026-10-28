/*
 * Dữ liệu thật cho 4 màn hình admin: Bảng điều khiển, Sản phẩm, Đơn hàng,
 * Xưởng in. Nạp SAU admin.js để ghi đè các hàm render đang dùng seedData /
 * localStorage. Các màn hình còn lại (tranh chấp, kho, hợp đồng, RBAC...)
 * vẫn giữ nguyên bản demo vì schema tmdt chưa có bảng tương ứng.
 */
(function () {
  'use strict';

  var APP_CTX = (document.querySelector('meta[name="app-ctx"]') || {}).content || '';
  var PAGE_SIZE = 20;
  var ORDER_LABEL = {
    PENDING: 'Chờ xác nhận',
    CONFIRMED: 'Đã xác nhận',
    SHIPPING: 'Đang giao',
    COMPLETED: 'Hoàn tất',
    CANCELLED: 'Đã hủy'
  };
  var ORDER_COLOR = {
    PENDING: 'amber',
    CONFIRMED: 'blue',
    SHIPPING: 'blue',
    COMPLETED: 'green',
    CANCELLED: 'gray'
  };
  var live = {
    products: { items: [], page: 1, totalPages: 0, signature: '', loading: false },
    orders: { items: [], page: 1, totalPages: 0, signature: '', loading: false, shopsLoaded: false },
    suppliers: { items: [], loading: false }
  };

  /* ---------------- Gọi API ---------------- */

  function apiGet(path, params) {
    var query = new URLSearchParams();
    Object.keys(params || {}).forEach(function (key) {
      var value = params[key];
      if (value !== '' && value !== null && value !== undefined) query.append(key, value);
    });
    var url = APP_CTX + path + (query.toString() ? '?' + query.toString() : '');
    return fetch(url, {
      credentials: 'same-origin',
      headers: { 'Accept': 'application/json' }
    }).then(function (response) {
      if (response.status === 401 || response.status === 403) {
        window.location.assign(APP_CTX + '/login?redirect=' + encodeURIComponent('/Admin/admin.jsp'));
        throw new Error('Phiên đăng nhập đã hết hạn.');
      }
      return response.json().catch(function () { return null; }).then(function (payload) {
        if (!response.ok) {
          throw new Error((payload && payload.error) || ('Máy chủ trả lời ' + response.status + '.'));
        }
        if (!payload) throw new Error('Máy chủ trả về dữ liệu không hợp lệ.');
        return payload;
      });
    });
  }

  function fail(body, columns, message) {
    if (body) body.innerHTML = emptyRow(columns, 'Không tải được dữ liệu', message || 'Vui lòng thử lại sau.');
    if (typeof toast === 'function') toast(message || 'Không tải được dữ liệu');
  }

  /* ---------------- Định dạng ---------------- */

  function money(value) {
    return Number(value || 0).toLocaleString('vi-VN') + 'đ';
  }

  function shortMoney(value) {
    var number = Number(value || 0);
    if (number >= 1e9) return (number / 1e9).toFixed(2).replace('.', ',') + ' tỷ';
    if (number >= 1e6) {
      var millions = number / 1e6;
      return (millions >= 100 ? Math.round(millions) : millions.toFixed(1)).replace('.', ',') + ' tr';
    }
    if (number >= 1e3) return Math.round(number / 1e3) + 'K';
    return String(number);
  }

  function number(value) {
    return Number(value || 0).toLocaleString('vi-VN');
  }

  function percent(value) {
    return Number(value || 0).toFixed(1).replace('.', ',') + '%';
  }

  function dayLabel(value) {
    if (!value) return '';
    var parts = String(value).slice(0, 10).split('-');
    return parts.length === 3 ? parts[2] + '/' + parts[1] + '/' + parts[0] : String(value);
  }

  function statusPill(label, color) {
    return '<span class="pill ' + color + '"><span class="dot"></span>' + escapeHtml(label) + '</span>';
  }

  function orderPill(status) {
    return statusPill(ORDER_LABEL[status] || status, ORDER_COLOR[status] || 'gray');
  }

  function productLabel(product) {
    if (product.status === 'HIDDEN') return 'Ngừng bán';
    if (Number(product.stock) <= 10) return 'Sắp hết hàng';
    return 'Đang bán';
  }

  function pager(container, page, totalPages, handlerName) {
    if (!container) return;
    if (!totalPages) { container.innerHTML = ''; return; }
    container.innerHTML =
      '<button class="mini-btn" type="button" onclick="' + handlerName + '(-1)"' +
      (page <= 1 ? ' disabled' : '') + '>‹ Trước</button>' +
      '<span class="table-note" style="margin:0 8px;">Trang ' + page + '/' + totalPages + '</span>' +
      '<button class="mini-btn" type="button" onclick="' + handlerName + '(1)"' +
      (page >= totalPages ? ' disabled' : '') + '>Sau ›</button>';
  }

  /* ---------------- Bảng điều khiển ---------------- */

  function renderDashboard() {
    apiGet('/admin/api/dashboard', {}).then(function (data) {
      var kpi = data.kpi || {};

      setText('dashRevenue', money(kpi.revenueToday));
      var before = Number(kpi.revenueYesterday || 0);
      var today = Number(kpi.revenueToday || 0);
      var delta = before > 0 ? ((today - before) / before * 100) : 0;
      setDelta('dashRevenueDelta', delta, 'so với hôm qua');

      setText('dashOrders', number(kpi.createdToday));
      setText('dashOrdersDelta', 'Tổng ' + number((data.orderCounts || {}).total) + ' đơn trong hệ thống');
      var ordersDelta = document.getElementById('dashOrdersDelta');
      if (ordersDelta) ordersDelta.className = 'delta';

      setText('dashProcessing', number(kpi.processing));
      setText('dashProcessingNote', number((data.orderCounts || {}).cancelled) + ' đơn đã hủy');
      var processingNote = document.getElementById('dashProcessingNote');
      if (processingNote) processingNote.className = 'delta';

      setText('dashCompletion', percent(kpi.completionRate));
      setText('dashCompletionNote', number(kpi.lowStock) + ' sản phẩm tồn kho ≤ 10');
      var completionNote = document.getElementById('dashCompletionNote');
      if (completionNote) completionNote.className = 'delta';

      var alertBox = document.getElementById('dashAlert');
      var alertText = document.getElementById('dashAlertText');
      if (alertBox && alertText) {
        var parts = [];
        if (Number(kpi.lowStock) > 0) parts.push('<strong>' + number(kpi.lowStock) + ' sản phẩm</strong> sắp hết hàng');
        if (Number(kpi.processing) > 0) parts.push('<strong>' + number(kpi.processing) + ' đơn</strong> đang chờ xử lý');
        if (parts.length) {
          alertText.innerHTML = parts.join(' và ') + '.';
          alertBox.hidden = false;
        } else {
          alertBox.hidden = true;
        }
      }

      renderDashChart(data.bars || []);
      renderDashCategories(data.categories || []);
      renderDashTopShops(data.topShops || []);
      renderDashOrders(data.recentOrders || []);
      renderDashPending(data.pendingOrders || []);
    }).catch(function (error) {
      if (typeof toast === 'function') toast(error.message || 'Không tải được bảng điều khiển.');
      setText('dashRevenue', '—');
      setText('dashOrders', '—');
      setText('dashProcessing', '—');
      setText('dashCompletion', '—');
    });
  }

  function setText(id, value) {
    var element = document.getElementById(id);
    if (element) element.textContent = value;
  }

  function setDelta(id, value, suffix) {
    var element = document.getElementById(id);
    if (!element) return;
    var up = value >= 0;
    element.className = 'delta ' + (up ? 'up' : 'down');
    element.textContent = (up ? '▲ ' : '▼ ') + Math.abs(value).toFixed(1).replace('.', ',') + '% ' + suffix;
  }

  function renderDashChart(bars) {
    var box = document.getElementById('dashChart');
    if (!box) return;
    if (!bars.length) {
      box.innerHTML = '<div class="empty-state" style="width:100%;"><strong>Chưa có dữ liệu</strong>Chưa có đơn hoàn tất trong 7 ngày gần đây.</div>';
      return;
    }
    var max = bars.reduce(function (top, bar) { return Math.max(top, Number(bar.revenue || 0)); }, 0) || 1;
    box.innerHTML = bars.map(function (bar) {
      var height = Math.max(4, Math.round(Number(bar.revenue || 0) / max * 100));
      return '<div class="bar" style="height:' + height + '%;" title="' + escapeHtml(bar.title || bar.label) + '">' +
        '<span class="val">' + shortMoney(bar.revenue) + '</span>' +
        '<span>' + escapeHtml(bar.label) + '</span></div>';
    }).join('');
  }

  function renderDashCategories(slices) {
    var box = document.getElementById('dashCategories');
    if (!box) return;
    var total = slices.reduce(function (sum, slice) { return sum + Number(slice.value || 0); }, 0);
    if (!slices.length || total <= 0) {
      box.innerHTML = '<div class="empty-state"><strong>Chưa có doanh thu</strong>Chưa có đơn hoàn tất trong tháng này.</div>';
      return;
    }
    box.innerHTML = slices.slice(0, 5).map(function (slice) {
      var share = Number(slice.value) / total * 100;
      return '<div class="list-item"><div><div class="name">' + escapeHtml(slice.name) + '</div>' +
        '<div class="meta">' + money(slice.value) + ' · ' + percent(share) + '</div></div>' +
        '<div><div class="bar-bg"><div class="bar-fill" style="width:' + Math.max(3, Math.round(share)) + '%"></div></div></div></div>';
    }).join('');
  }

  function renderDashTopShops(slices) {
    var box = document.getElementById('dashTopShops');
    if (!box) return;
    var top = slices.slice(0, 4);
    if (!top.length) {
      box.innerHTML = '<div class="empty-state"><strong>Chưa có dữ liệu</strong>Chưa có đơn hoàn tất trong tháng này.</div>';
      return;
    }
    var max = top.reduce(function (value, slice) { return Math.max(value, Number(slice.value || 0)); }, 0) || 1;
    box.innerHTML = top.map(function (slice) {
      return '<div class="list-item"><div><div class="name">' + escapeHtml(slice.name) + '</div>' +
        '<div class="meta">' + money(slice.value) + ' tháng này</div></div>' +
        '<div><div class="bar-bg"><div class="bar-fill" style="width:' +
        Math.max(4, Math.round(Number(slice.value) / max * 100)) + '%"></div></div></div></div>';
    }).join('');
  }

  function renderDashOrders(orders) {
    var body = document.getElementById('dashboardOrdersBody');
    if (!body) return;
    if (!orders.length) {
      body.innerHTML = emptyRow(5, 'Chưa có đơn hàng', 'Đơn mới sẽ xuất hiện tại đây.');
      return;
    }
    body.innerHTML = orders.map(function (order) {
      return '<tr><td class="order-id">' + escapeHtml(order.code) + '</td>' +
        '<td>' + escapeHtml(order.customer) + '</td>' +
        '<td>' + supplierTag(order.shop) + '</td>' +
        '<td>' + orderPill(order.status) + '</td>' +
        '<td class="num">' + money(order.total) + '</td></tr>';
    }).join('');
  }

  function renderDashPending(orders) {
    var box = document.getElementById('dashPendingOrders');
    if (!box) return;
    if (!orders.length) {
      box.innerHTML = '<div class="empty-state"><strong>Không có đơn chờ</strong>Mọi đơn đã được xác nhận hoặc xử lý.</div>';
      return;
    }
    box.innerHTML = orders.map(function (order) {
      return '<div class="dispute-item" onclick="liveOrderDetail(\'' + escapeHtml(order.code) + '\')">' +
        '<div class="top"><span>#' + escapeHtml(order.code) + '</span>' + orderPill(order.status) + '</div>' +
        '<div class="desc">' + escapeHtml(order.customer) + ' · ' + escapeHtml(order.shop) +
        ' · ' + money(order.total) + '</div></div>';
    }).join('');
  }

  /* ---------------- Sản phẩm ---------------- */

  function currentProductFilters() {
    var search = document.getElementById('productSearch');
    var category = document.getElementById('productCategoryFilter');
    var status = document.getElementById('productStatusFilter');
    return {
      q: search ? search.value.trim() : '',
      category: category ? category.value : '',
      status: status ? status.value : ''
    };
  }

  function renderProducts() {
    var body = document.getElementById('productsTableBody');
    if (!body || live.products.loading) return;

    var filters = currentProductFilters();
    var signature = JSON.stringify(filters);
    if (signature !== live.products.signature) {
      live.products.signature = signature;
      live.products.page = 1;
    }

    var params = { q: filters.q, category: filters.category, page: live.products.page, size: PAGE_SIZE };
    if (filters.status === 'LOW') params.low = '1';
    else if (filters.status) params.status = filters.status;

    live.products.loading = true;
    apiGet('/admin/api/products', params).then(function (data) {
      live.products.page = data.page || 1;
      live.products.totalPages = data.totalPages || 0;
      live.products.items = data.items || [];

      fillCategoryFilter(data.categories || []);

      if (!live.products.items.length) {
        body.innerHTML = emptyRow(7, 'Không tìm thấy sản phẩm', 'Thử thay đổi từ khóa hoặc bộ lọc.');
      } else {
        body.innerHTML = live.products.items.map(function (product) {
          return '<tr><td><strong>' + escapeHtml(product.name) + '</strong>' +
            '<div class="table-note">' + escapeHtml(product.slug || '') + '</div></td>' +
            '<td>' + escapeHtml(product.category) + '</td>' +
            '<td class="num">' + money(product.price) + '</td>' +
            '<td class="num">' + number(product.stock) + '</td>' +
            '<td class="num">' + number(product.sold) + '</td>' +
            '<td>' + pill(productLabel(product)) + '</td>' +
            '<td><button class="mini-btn" type="button" onclick="liveProductDetail(' + Number(product.id) + ')">Chi tiết</button></td></tr>';
        }).join('');
      }

      var counts = data.counts || {};
      setText('productTotalCount', number(counts.total));
      setText('productActiveCount', number(counts.active));
      setText('productLowCount', number(counts.lowStock));
      setText('productResultCount', number(data.total) + ' sản phẩm');
      pager(document.getElementById('productPager'), live.products.page, live.products.totalPages, 'liveProductPage');
      renderProductInsight();
    }).catch(function (error) {
      fail(body, 7, error.message);
    }).finally(function () {
      live.products.loading = false;
    });
  }

  function fillCategoryFilter(categories) {
    var select = document.getElementById('productCategoryFilter');
    if (!select) return;
    var previous = select.value;
    var options = ['<option value="">Tất cả nhóm</option>'];
    categories.forEach(function (category) {
      options.push('<option value="' + category.id + '">' + escapeHtml(category.name) + '</option>');
    });
    select.innerHTML = options.join('');
    select.value = previous;
  }

  function renderProductInsight() {
    var box = document.getElementById('productInsight');
    if (!box) return;
    var ranked = live.products.items.slice().sort(function (a, b) {
      return Number(b.sold || 0) - Number(a.sold || 0);
    }).slice(0, 5);
    if (!ranked.length) {
      box.innerHTML = '<div class="empty-state"><strong>Chưa có sản phẩm</strong>Không có dữ liệu để phân tích.</div>';
      return;
    }
    var max = Number(ranked[0].sold || 0) || 1;
    box.innerHTML = ranked.map(function (product) {
      return '<div class="list-item"><div><div class="name">' + escapeHtml(product.name) + '</div>' +
        '<div class="meta">' + number(product.sold) + ' đã bán · tồn ' + number(product.stock) + '</div></div>' +
        '<div><div class="bar-bg"><div class="bar-fill" style="width:' +
        Math.max(4, Math.round(Number(product.sold || 0) / max * 100)) + '%"></div></div></div></div>';
    }).join('');
  }

  window.openProductInsight = function () {
    var items = live.products.items;
    if (!items.length) { toast('Chưa có dữ liệu sản phẩm'); return; }
    var totalSold = items.reduce(function (sum, product) { return sum + Number(product.sold || 0); }, 0) || 1;
    var byCategory = {};
    items.forEach(function (product) {
      byCategory[product.category] = (byCategory[product.category] || 0) + Number(product.sold || 0);
    });
    var ranked = items.slice().sort(function (a, b) { return Number(b.sold || 0) - Number(a.sold || 0); });
    openInfoModal('Phân tích sản phẩm', 'Theo ' + items.length + ' sản phẩm đang hiển thị',
      '<div class="detail-grid">' +
      '<div class="field"><label>Tổng lượt bán</label><strong>' + number(totalSold) + '</strong></div>' +
      '<div class="field"><label>Bán chạy nhất</label><strong>' + escapeHtml(ranked[0].name) + '</strong></div>' +
      '</div>' +
      Object.keys(byCategory).map(function (name) {
        var share = byCategory[name] / totalSold * 100;
        return '<div class="activity-item"><span class="activity-mark"></span><div><strong>' +
          escapeHtml(name) + '</strong><span>' + number(byCategory[name]) + ' lượt bán · ' +
          percent(share) + ' tổng bán</span></div></div>';
      }).join(''));
  };

  window.liveProductPage = function (delta) {
    var next = live.products.page + delta;
    if (next < 1 || (live.products.totalPages && next > live.products.totalPages)) return;
    live.products.page = next;
    renderProducts();
  };

  window.liveProductDetail = function (id) {
    var product = live.products.items.find(function (item) { return Number(item.id) === Number(id); });
    if (!product) return;
    openInfoModal('Chi tiết sản phẩm', product.name,
      '<div class="detail-grid">' +
      '<div class="field"><label>Nhóm sản phẩm</label><strong>' + escapeHtml(product.category) + '</strong></div>' +
      '<div class="field"><label>Xưởng sản xuất</label><strong>' + escapeHtml(product.supplier) + '</strong></div>' +
      '<div class="field"><label>Giá bán</label><strong>' + money(product.price) + '</strong></div>' +
      '<div class="field"><label>Trạng thái</label><strong>' + escapeHtml(productLabel(product)) + '</strong></div>' +
      '<div class="field"><label>Tồn kho</label><strong>' + number(product.stock) + '</strong></div>' +
      '<div class="field"><label>Đã bán</label><strong>' + number(product.sold) + '</strong></div>' +
      '<div class="field"><label>Doanh thu ước tính</label><strong>' + money(Number(product.price) * Number(product.sold)) + '</strong></div>' +
      '<div class="field"><label>Cập nhật gần nhất</label><strong>' + escapeHtml(product.updatedAt || 'Chưa cập nhật') + '</strong></div>' +
      '</div>');
  };

  /* ---------------- Đơn hàng ---------------- */

  function currentOrderFilters() {
    var search = document.getElementById('orderSearch');
    var status = document.getElementById('orderStatusFilter');
    var shop = document.getElementById('orderSupplierFilter');
    var range = document.getElementById('orderRangeFilter');
    return {
      q: search ? search.value.trim() : '',
      status: status ? status.value : '',
      shop: shop ? shop.value : '',
      days: range ? range.value : ''
    };
  }

  function renderOrders() {
    var body = document.getElementById('ordersTableBody');
    if (!body || live.orders.loading) return;

    var filters = currentOrderFilters();
    var signature = JSON.stringify(filters);
    if (signature !== live.orders.signature) {
      live.orders.signature = signature;
      live.orders.page = 1;
    }

    var params = {
      q: filters.q, status: filters.status, shop: filters.shop,
      days: filters.days, page: live.orders.page, size: PAGE_SIZE
    };

    live.orders.loading = true;
    apiGet('/admin/api/orders', params).then(function (data) {
      live.orders.page = data.page || 1;
      live.orders.totalPages = data.totalPages || 0;
      live.orders.items = data.items || [];

      if (!live.orders.shopsLoaded) {
        fillShopFilter(data.shops || []);
        live.orders.shopsLoaded = true;
      }

      if (!live.orders.items.length) {
        body.innerHTML = emptyRow(7, 'Không tìm thấy đơn hàng', 'Thử thay đổi từ khóa hoặc bộ lọc.');
      } else {
        body.innerHTML = live.orders.items.map(function (order) {
          return '<tr><td class="order-id">' + escapeHtml(order.code) +
            '<div class="table-note">' + number(order.itemCount) + ' sản phẩm</div></td>' +
            '<td>' + escapeHtml(order.customer) + '</td>' +
            '<td>' + supplierTag(order.shop) + '</td>' +
            '<td>' + orderPill(order.status) + '</td>' +
            '<td class="num">' + money(order.total) + '</td>' +
            '<td class="mono">' + escapeHtml(shortDate(order.createdAt)) + '</td>' +
            '<td><button class="mini-btn" type="button" onclick="liveOrderDetail(\'' + escapeHtml(order.code) + '\')">Chi tiết</button></td></tr>';
        }).join('');
      }

      var counts = data.counts || {};
      setText('orderTotalCount', number(counts.total));
      setText('orderTotalValue', 'Tổng giá trị ' + money(counts.value));
      setText('orderActiveCount', number(counts.active));
      setText('orderIssueCount', number(counts.cancelled));
      setText('orderResultCount', number(data.total) + ' đơn hàng');
      pager(document.getElementById('orderPager'), live.orders.page, live.orders.totalPages, 'liveOrderPage');
    }).catch(function (error) {
      fail(body, 7, error.message);
    }).finally(function () {
      live.orders.loading = false;
    });
  }

  function fillShopFilter(shops) {
    var select = document.getElementById('orderSupplierFilter');
    if (!select) return;
    var previous = select.value;
    select.innerHTML = '<option value="">Tất cả xưởng in</option>' + shops.map(function (shop) {
      return '<option value="' + shop.id + '">' + escapeHtml(shop.name) + '</option>';
    }).join('');
    select.value = previous;
  }

  window.liveOrderPage = function (delta) {
    var next = live.orders.page + delta;
    if (next < 1 || (live.orders.totalPages && next > live.orders.totalPages)) return;
    live.orders.page = next;
    renderOrders();
  };

  window.liveOrderDetail = function (code) {
    var order = live.orders.items.find(function (item) { return item.code === code; });
    if (!order) {
      toast('Đơn hàng không còn trong trang hiện tại, hãy tải lại danh sách.');
      return;
    }
    openInfoModal('Chi tiết đơn hàng', order.code + ' · ' + order.customer,
      '<div class="detail-grid">' +
      '<div class="field"><label>Khách hàng</label><strong>' + escapeHtml(order.customer) + '</strong></div>' +
      '<div class="field"><label>Người nhận</label><strong>' + escapeHtml(order.recipient) + '</strong></div>' +
      '<div class="field"><label>Xưởng in</label><strong>' + escapeHtml(order.shop) + '</strong></div>' +
      '<div class="field"><label>Trạng thái</label><strong>' + escapeHtml(ORDER_LABEL[order.status] || order.status) + '</strong></div>' +
      '<div class="field"><label>Số sản phẩm</label><strong>' + number(order.itemCount) + '</strong></div>' +
      '<div class="field"><label>Giá trị đơn</label><strong>' + money(order.total) + '</strong></div>' +
      '<div class="field"><label>Ngày tạo</label><strong>' + escapeHtml(shortDate(order.createdAt)) + '</strong></div>' +
      '</div>');
  };

  /* ---------------- Xưởng in ---------------- */

  function renderSuppliersList() {
    var body = document.getElementById('suppliersListBody');
    if (!body || live.suppliers.loading) return;

    var search = document.getElementById('supplierListSearch');
    var sort = document.getElementById('supplierListSort');

    live.suppliers.loading = true;
    apiGet('/admin/api/suppliers', {
      q: search ? search.value.trim() : '',
      sort: sort ? sort.value : 'revenue',
      size: 50
    }).then(function (data) {
      live.suppliers.items = data.items || [];
      if (!live.suppliers.items.length) {
        body.innerHTML = emptyRow(7, 'Không tìm thấy xưởng in', 'Thử thay đổi từ khóa.');
      } else {
        body.innerHTML = live.suppliers.items.map(function (supplier) {
          var maxOrders = live.suppliers.items.reduce(function (top, item) {
            return Math.max(top, Number(item.orders30 || 0));
          }, 0) || 1;
          var width = Math.max(4, Math.round(Number(supplier.orders30 || 0) / maxOrders * 100));
          return '<tr><td><div class="supplier-cell"><span class="sq">' +
            escapeHtml(String(supplier.name || '?').substring(0, 2).toUpperCase()) + '</span> <strong>' +
            escapeHtml(supplier.name) + '</strong></div>' +
            '<div class="table-note">' + number(supplier.products) + ' sản phẩm</div></td>' +
            '<td>' + escapeHtml(supplier.address || 'Chưa cập nhật') + '</td>' +
            '<td class="num">' + number(supplier.orders30) +
            '<div class="bar-bg" style="width:80px;margin-top:4px;"><div class="bar-fill" style="width:' + width + '%"></div></div></td>' +
            '<td class="num">' + money(supplier.revenue30) + '</td>' +
            '<td class="num">' + Number(supplier.rating || 0).toFixed(1).replace('.', ',') + ' ★' +
            '<div class="table-note">' + number(supplier.reviews) + ' đánh giá</div></td>' +
            '<td>' + (supplier.status === 'ACTIVE' ? pill('Hoạt động') : pill('Tạm dừng')) + '</td>' +
            '<td><span class="action-link" onclick="liveSupplierDetail(' + Number(supplier.id) + ')">Chi tiết</span></td></tr>';
        }).join('');
      }

      var counts = data.counts || {};
      setText('supplierListTotal', number(counts.total));
      setText('supplierListActive', number(counts.active));
      setText('supplierListInactiveNote', number(Number(counts.total) - Number(counts.active)) + ' xưởng tạm dừng');
      setText('supplierListRating', Number(counts.avgRating || 0).toFixed(2).replace('.', ',') + ' ★');
      setText('supplierListProducts', number(counts.products));
      var note = document.getElementById('supplierListInactiveNote');
      if (note) note.className = 'delta';
    }).catch(function (error) {
      fail(body, 7, error.message);
    }).finally(function () {
      live.suppliers.loading = false;
    });
  }

  window.liveSupplierDetail = function (id) {
    var supplier = live.suppliers.items.find(function (item) { return Number(item.id) === Number(id); });
    if (!supplier) return;
    openInfoModal('Chi tiết xưởng in', supplier.name,
      '<div class="detail-grid">' +
      '<div class="field"><label>Địa chỉ</label><strong>' + escapeHtml(supplier.address || 'Chưa cập nhật') + '</strong></div>' +
      '<div class="field"><label>Trạng thái</label><strong>' + (supplier.status === 'ACTIVE' ? 'Hoạt động' : 'Tạm dừng') + '</strong></div>' +
      '<div class="field"><label>Sản phẩm</label><strong>' + number(supplier.products) + '</strong></div>' +
      '<div class="field"><label>Đơn 30 ngày</label><strong>' + number(supplier.orders30) + '</strong></div>' +
      '<div class="field"><label>Doanh thu 30 ngày</label><strong>' + money(supplier.revenue30) + '</strong></div>' +
      '<div class="field"><label>Đánh giá</label><strong>' + Number(supplier.rating || 0).toFixed(2).replace('.', ',') + ' ★ · ' + number(supplier.reviews) + ' lượt</strong></div>' +
      '</div>');
  };

  /* ---------------- Xuất CSV (trang đang hiển thị) ---------------- */

  window.exportProducts = function () {
    if (!live.products.items.length) { toast('Không có dữ liệu để xuất'); return; }
    downloadCsv('san-pham.csv', ['Tên sản phẩm,Nhóm,Xưởng sản xuất,Giá bán,Tồn kho,Đã bán,Trạng thái'].concat(
      live.products.items.map(function (product) {
        return [product.name, product.category, product.supplier, product.price, product.stock, product.sold, productLabel(product)]
          .map(csvCell).join(',');
      })));
  };

  window.exportOrders = function () {
    if (!live.orders.items.length) { toast('Không có dữ liệu để xuất'); return; }
    downloadCsv('don-hang.csv', ['Mã đơn,Khách hàng,Xưởng in,Trạng thái,Giá trị,Số sản phẩm,Ngày tạo'].concat(
      live.orders.items.map(function (order) {
        return [order.code, order.customer, order.shop, ORDER_LABEL[order.status] || order.status,
          order.total, order.itemCount, order.createdAt].map(csvCell).join(',');
      })));
  };

  window.exportSuppliersList = function () {
    if (!live.suppliers.items.length) { toast('Không có dữ liệu để xuất'); return; }
    downloadCsv('xuong-in.csv', ['Xưởng in,Địa chỉ,Sản phẩm,Đơn 30 ngày,Doanh thu 30 ngày,Đánh giá,Trạng thái'].concat(
      live.suppliers.items.map(function (supplier) {
        return [supplier.name, supplier.address || '', supplier.products, supplier.orders30,
          supplier.revenue30, supplier.rating, supplier.status].map(csvCell).join(',');
      })));
  };

  /* ---------------- Ghi đè & khởi động ---------------- */

  window.renderProducts = renderProducts;
  window.renderOrders = renderOrders;
  window.renderSuppliersList = renderSuppliersList;

  function setTodaySubtitle() {
    var sub = document.getElementById('pageSub');
    if (!sub) return;
    sub.textContent = new Intl.DateTimeFormat('vi-VN', {
      weekday: 'long', day: '2-digit', month: 'long', year: 'numeric'
    }).format(new Date());
  }

  var baseSwitchPage = window.switchPage;
  window.switchPage = function (element, page) {
    baseSwitchPage(element, page);
    if (page === 'dashboard') setTodaySubtitle();
  };

  document.addEventListener('DOMContentLoaded', function () {
    setTodaySubtitle();
    renderDashboard();
    renderSuppliersList();
  });
})();
