/* ===== Trang Yêu cầu Nhà cung cấp - gọi API /admin/api/supplier-requests ===== */
const APP_CTX = document.querySelector('meta[name="app-ctx"]')?.content || '';
const CSRF_TOKEN = document.querySelector('meta[name="csrf-token"]')?.content || '';
const REQUESTS_API = APP_CTX + '/admin/api/supplier-requests';

const STATUS_LABELS = { PENDING: 'Đang chờ duyệt', APPROVED: 'Đã duyệt', REJECTED: 'Bị từ chối' };
const STATUS_COLORS = { PENDING: 'amber', APPROVED: 'green', REJECTED: 'red' };
const ROLE_LABELS = { CUSTOMER: 'Khách hàng', SELLER: 'Nhà cung cấp', ADMIN: 'Quản trị viên' };

const requestState = {
  q: '', status: '', page: 1, size: 10,
  total: 0, totalPages: 1, requests: [],
  counts: { PENDING: 0, APPROVED: 0, REJECTED: 0 }
};

let toastTimer;
let confirmHandler = null;
let searchTimer = null;

/* ===== Tiện ích dùng chung ===== */
function toast(message) {
  const element = document.getElementById('toast');
  element.textContent = message;
  element.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => element.classList.remove('show'), 2600);
}

function escapeHtml(value) {
  return String(value ?? '').replace(/[&<>"']/g, char => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' }[char]));
}

function showModal(id) {
  const modal = document.getElementById(id);
  document.getElementById('overlay').classList.add('show');
  modal.classList.add('show');
  modal.setAttribute('aria-hidden', 'false');
}

function closeAll() {
  document.querySelectorAll('.modal, .overlay').forEach(element => element.classList.remove('show'));
  document.querySelectorAll('.modal').forEach(element => element.setAttribute('aria-hidden', 'true'));
  confirmHandler = null;
}

function openEntityModal({ title, subtitle = '', fields, submitText = 'Lưu thay đổi', onSubmit }) {
  document.getElementById('entityModalTitle').textContent = title;
  document.getElementById('entityModalSubtitle').textContent = subtitle;
  document.getElementById('entityFormFields').innerHTML = fields;
  document.getElementById('entitySubmitButton').textContent = submitText;
  document.getElementById('entityForm').hidden = false;
  document.getElementById('entityInfoContent').hidden = true;
  document.getElementById('entityForm').onsubmit = event => {
    event.preventDefault();
    onSubmit(new FormData(event.currentTarget), event.currentTarget);
  };
  showModal('entityModal');
  setTimeout(() => document.querySelector('#entityForm textarea, #entityForm input:not([type="hidden"])')?.focus(), 0);
}

function openInfoModal(title, subtitle, content) {
  document.getElementById('entityModalTitle').textContent = title;
  document.getElementById('entityModalSubtitle').textContent = subtitle;
  document.getElementById('entityForm').hidden = true;
  const info = document.getElementById('entityInfoContent');
  info.hidden = false;
  info.innerHTML = content + '<div class="modal-actions"><button class="btn primary" type="button" onclick="closeAll()">Đóng</button></div>';
  showModal('entityModal');
}

function confirmAction(title, message, action, buttonText = 'Xác nhận') {
  document.getElementById('confirmTitle').textContent = title;
  document.getElementById('confirmMessage').textContent = message;
  const button = document.getElementById('confirmButton');
  button.textContent = buttonText;
  confirmHandler = action;
  button.onclick = () => {
    const handler = confirmHandler;
    closeAll();
    if (handler) handler();
  };
  showModal('confirmModal');
}

function statusPill(status) {
  const label = STATUS_LABELS[status] || status || '—';
  return '<span class="pill ' + (STATUS_COLORS[status] || 'gray') + '"><span class="dot"></span>' + escapeHtml(label) + '</span>';
}

function emptyRow(columns, title, detail) {
  return '<tr><td colspan="' + columns + '"><div class="empty-state"><strong>' + escapeHtml(title) + '</strong>' + escapeHtml(detail) + '</div></td></tr>';
}

function field(label, control, full = false) {
  return '<div class="form-field' + (full ? ' full-span' : '') + '"><label>' + label + '</label>' + control + '</div>';
}

function formatDateTime(value) {
  if (!value) return '—';
  const parts = String(value).split(' ');
  const [year, month, day] = (parts[0] || '').split('-');
  if (!year || !month || !day) return value;
  return (parts[1] || '').slice(0, 5) + ' ' + day + '/' + month + '/' + year;
}

function initials(name) {
  return String(name || '?').trim().split(/\s+/).slice(-2).map(part => part[0] || '').join('').toUpperCase();
}

/* ===== Gọi API ===== */
async function readJson(response) {
  const type = response.headers.get('content-type') || '';
  if (!type.includes('json')) return null;
  try { return await response.json(); } catch (error) { return null; }
}

async function apiGet(url) {
  const response = await fetch(url, {
    credentials: 'same-origin',
    headers: { 'Accept': 'application/json' }
  });
  const payload = await readJson(response);
  if (response.status === 401 || (response.status === 403 && payload?.error)) {
    window.location.assign(APP_CTX + '/login');
    throw new Error('Phiên đăng nhập đã hết hạn.');
  }
  if (!response.ok) throw new Error(payload?.error || 'Không tải được dữ liệu từ máy chủ.');
  return payload;
}

async function apiPost(path, data) {
  if (!CSRF_TOKEN) throw new Error('Thiếu mã CSRF, vui lòng tải lại trang.');
  const body = new URLSearchParams({ ...data, csrfToken: CSRF_TOKEN });
  const response = await fetch(REQUESTS_API + path, {
    method: 'POST',
    credentials: 'same-origin',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
    },
    body
  });
  const payload = await readJson(response);
  if (response.status === 401 || (response.status === 403 && payload?.error)) {
    window.location.assign(APP_CTX + '/login');
    throw new Error('Phiên đăng nhập đã hết hạn.');
  }
  if (!response.ok) throw new Error(payload?.error || 'Thao tác không thành công.');
  return payload;
}

/* ===== Danh sách ===== */
async function loadRequests() {
  const params = new URLSearchParams({
    q: requestState.q,
    status: requestState.status,
    page: String(requestState.page),
    size: String(requestState.size)
  });
  setTableLoading();
  try {
    const data = await apiGet(REQUESTS_API + '?' + params.toString());
    requestState.requests = Array.isArray(data?.requests) ? data.requests : [];
    requestState.total = Number(data?.total || 0);
    requestState.page = Number(data?.page || 1);
    requestState.totalPages = Number(data?.totalPages || 1);
    requestState.size = Number(data?.size || requestState.size);
    requestState.counts = {
      PENDING: Number(data?.counts?.PENDING || 0),
      APPROVED: Number(data?.counts?.APPROVED || 0),
      REJECTED: Number(data?.counts?.REJECTED || 0)
    };
    renderRequests();
  } catch (error) {
    toast(error.message || 'Không tải được danh sách yêu cầu.');
    document.getElementById('requestsTableBody').innerHTML =
      emptyRow(6, 'Không tải được dữ liệu', 'Kiểm tra kết nối rồi thử lại.');
  } finally {
    // Không cần đặt lại trạng thái bảng ở đây: renderRequests() đã xử lý.
  }
}

function setTableLoading(isLoading = true) {
  // Chỉ hiện trạng thái "Đang tải" khi bắt đầu gọi API. Khi kết thúc, renderRequests()
  // (hoặc thông báo lỗi) đã ghi nội dung bảng, nên không được ghi đè ở đây.
  if (!isLoading) return;
  const body = document.getElementById('requestsTableBody');
  if (body) body.innerHTML = emptyRow(6, 'Đang tải…', 'Vui lòng chờ trong giây lát.');
  const prev = document.getElementById('requestPrev');
  const next = document.getElementById('requestNext');
  if (prev) prev.disabled = true;
  if (next) next.disabled = true;
}

function renderRequests() {
  const body = document.getElementById('requestsTableBody');
  if (!body) return;

  body.innerHTML = requestState.requests.length ? requestState.requests.map(item => {
    const pending = item.status === 'PENDING';
    const actions = '<div class="action-menu">' +
      '<button class="mini-btn" type="button" onclick="openDetail(' + Number(item.requestId) + ')">Chi tiết</button>' +
      (pending
        ? '<button class="mini-btn success" type="button" onclick="askApprove(' + Number(item.requestId) + ')">Duyệt</button>' +
          '<button class="mini-btn warning" type="button" onclick="askReject(' + Number(item.requestId) + ')">Từ chối</button>'
        : '') +
      '</div>';
    return '<tr>' +
      '<td><div class="supplier-cell"><div class="avatar">' + escapeHtml(initials(item.fullName)) + '</div><div>' +
        '<strong>' + escapeHtml(item.fullName) + '</strong>' +
        '<div class="table-note">#' + escapeHtml(item.userId) + ' · ' + escapeHtml(item.email) + '</div>' +
      '</div></div></td>' +
      '<td><strong>' + escapeHtml(item.shopName) + '</strong>' +
        '<div class="table-note">' + escapeHtml(item.address || 'Chưa có địa chỉ') + '</div></td>' +
      '<td>' + escapeHtml(item.contactPhone) +
        '<div class="table-note">' + escapeHtml(ROLE_LABELS[item.userRole] || item.userRole || '—') + '</div></td>' +
      '<td>' + statusPill(item.status) +
        (item.rejectReason ? '<div class="table-note">' + escapeHtml(item.rejectReason) + '</div>' : '') + '</td>' +
      '<td class="mono">' + escapeHtml(formatDateTime(item.createdAt)) +
        (item.reviewedAt ? '<div class="table-note">Xử lý: ' + escapeHtml(formatDateTime(item.reviewedAt)) + '</div>' : '') + '</td>' +
      '<td>' + actions + '</td>' +
    '</tr>';
  }).join('') : emptyRow(6, 'Không có yêu cầu nào', 'Thử đổi bộ lọc trạng thái hoặc từ khóa.');

  document.getElementById('requestPendingCount').textContent = requestState.counts.PENDING;
  document.getElementById('requestApprovedCount').textContent = requestState.counts.APPROVED;
  document.getElementById('requestRejectedCount').textContent = requestState.counts.REJECTED;

  const start = requestState.total === 0 ? 0 : (requestState.page - 1) * requestState.size + 1;
  const end = Math.min(requestState.total, requestState.page * requestState.size);
  document.getElementById('requestResultCount').textContent =
    start + '–' + end + ' / ' + requestState.total + ' yêu cầu';
  document.getElementById('requestPageInfo').textContent =
    'Trang ' + requestState.page + '/' + requestState.totalPages;
  document.getElementById('requestPrev').disabled = requestState.page <= 1;
  document.getElementById('requestNext').disabled = requestState.page >= requestState.totalPages;
}

/* ===== Thao tác ===== */
function findRequest(requestId) {
  return requestState.requests.find(item => Number(item.requestId) === Number(requestId));
}

function openDetail(requestId) {
  const item = findRequest(requestId);
  if (!item) return;
  openInfoModal('Chi tiết yêu cầu', '#' + item.requestId + ' · ' + item.shopName,
    '<div class="detail-grid">' +
    '<div class="field"><label>Người gửi</label><strong>' + escapeHtml(item.fullName) + '</strong></div>' +
    '<div class="field"><label>Email tài khoản</label><strong>' + escapeHtml(item.email) + '</strong></div>' +
    '<div class="field"><label>SĐT tài khoản</label><strong>' + escapeHtml(item.userPhone || 'Chưa cập nhật') + '</strong></div>' +
    '<div class="field"><label>Vai trò hiện tại</label><strong>' + escapeHtml(ROLE_LABELS[item.userRole] || item.userRole || '—') + '</strong></div>' +
    '<div class="field"><label>Trạng thái tài khoản</label><strong>' + escapeHtml(item.userStatus || '—') + '</strong></div>' +
    '<div class="field"><label>Trạng thái yêu cầu</label><strong>' + escapeHtml(STATUS_LABELS[item.status] || item.status) + '</strong></div>' +
    '<div class="field"><label>Cửa hàng / xưởng in</label><strong>' + escapeHtml(item.shopName) + '</strong></div>' +
    '<div class="field"><label>SĐT liên hệ</label><strong>' + escapeHtml(item.contactPhone) + '</strong></div>' +
    '<div class="field"><label>Địa chỉ xưởng</label><strong>' + escapeHtml(item.address || '—') + '</strong></div>' +
    '<div class="field"><label>Ngày gửi</label><strong>' + escapeHtml(formatDateTime(item.createdAt)) + '</strong></div>' +
    '<div class="field"><label>Người xử lý</label><strong>' + escapeHtml(item.reviewerName || '—') + '</strong></div>' +
    '<div class="field"><label>Ngày xử lý</label><strong>' + escapeHtml(formatDateTime(item.reviewedAt)) + '</strong></div>' +
    '</div>' +
    (item.description
      ? '<div class="form-field full-span"><label>Thông tin bổ sung</label><div class="table-note" style="white-space:pre-wrap">' + escapeHtml(item.description) + '</div></div>'
      : '') +
    (item.rejectReason
      ? '<div class="form-field full-span"><label>Lý do từ chối</label><div class="table-note">' + escapeHtml(item.rejectReason) + '</div></div>'
      : ''));
}

function askApprove(requestId) {
  const item = findRequest(requestId);
  if (!item) return;
  confirmAction(
    'Duyệt yêu cầu',
    'Cấp quyền Nhà cung cấp cho ' + item.fullName + ' (' + item.shopName + '). Tài khoản sẽ được chuyển sang vai trò Nhà cung cấp.',
    () => approveRequest(requestId),
    'Duyệt'
  );
}

async function approveRequest(requestId) {
  try {
    await apiPost('/approve', { requestId: String(requestId) });
    toast('Đã duyệt yêu cầu và cấp quyền Nhà cung cấp.');
    await loadRequests();
  } catch (error) {
    toast(error.message || 'Không duyệt được yêu cầu.');
    await loadRequests();
  }
}

function askReject(requestId) {
  const item = findRequest(requestId);
  if (!item) return;
  openEntityModal({
    title: 'Từ chối yêu cầu',
    subtitle: item.fullName + ' · ' + item.shopName,
    fields: field('Lý do từ chối',
      '<textarea name="reason" rows="3" maxlength="500" placeholder="Ví dụ: thông tin địa chỉ chưa rõ ràng" required></textarea>', true),
    submitText: 'Từ chối yêu cầu',
    onSubmit: data => rejectRequest(requestId, data.get('reason'))
  });
}

async function rejectRequest(requestId, reason) {
  const value = String(reason || '').trim();
  if (!value) {
    toast('Vui lòng nhập lý do từ chối.');
    return;
  }
  try {
    await apiPost('/reject', { requestId: String(requestId), reason: value });
    closeAll();
    toast('Đã từ chối yêu cầu.');
    await loadRequests();
  } catch (error) {
    toast(error.message || 'Không từ chối được yêu cầu.');
  }
}

/* ===== Bộ lọc / tìm kiếm / phân trang ===== */
function onSearchInput() {
  clearTimeout(searchTimer);
  searchTimer = setTimeout(() => {
    requestState.q = document.getElementById('requestSearch').value.trim();
    requestState.page = 1;
    loadRequests();
  }, 300);
}

function onFilterChange() {
  requestState.status = document.getElementById('requestStatusFilter').value;
  requestState.page = 1;
  loadRequests();
}

function gotoPage(delta) {
  const target = requestState.page + delta;
  if (target < 1 || target > requestState.totalPages) return;
  requestState.page = target;
  loadRequests();
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', loadRequests);
} else {
  loadRequests();
}
