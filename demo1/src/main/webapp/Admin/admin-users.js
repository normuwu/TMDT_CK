/* ===== Trang Quản lý người dùng - gọi API /admin/api/users ===== */
const APP_CTX = document.querySelector('meta[name="app-ctx"]')?.content || '';
const CSRF_TOKEN = document.querySelector('meta[name="csrf-token"]')?.content || '';
const CURRENT_USER_ID = Number(document.querySelector('meta[name="current-user-id"]')?.content || 0);
const USERS_API = APP_CTX + '/admin/api/users';

const ROLE_LABELS = { CUSTOMER: 'Khách hàng', SELLER: 'Nhà cung cấp', ADMIN: 'Quản trị viên' };
const STATUS_LABELS = { ACTIVE: 'Hoạt động', LOCKED: 'Bị khóa' };

let toastTimer;
let confirmHandler = null;
let searchTimer = null;

const userState = {
  q: '', role: '', status: '', page: 1, size: 10,
  total: 0, totalPages: 1, users: [],
  counts: { byRole: {}, byStatus: {}, unverified: 0 }
};

/* ===== Tiện ích dùng chung ===== */
function toast(message) {
  const element = document.getElementById('toast');
  element.textContent = message;
  element.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => element.classList.remove('show'), 2400);
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
  setTimeout(() => document.querySelector('#entityForm input:not([type="hidden"]), #entityForm select')?.focus(), 0);
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

function pill(status) {
  const colors = { 'Hoạt động': 'green', 'Bị khóa': 'red' };
  return '<span class="pill ' + (colors[status] || 'gray') + '"><span class="dot"></span>' + escapeHtml(status) + '</span>';
}

function rolePill(role) {
  const colors = { ADMIN: 'blue', SELLER: 'amber', CUSTOMER: 'gray' };
  return '<span class="pill ' + (colors[role] || 'gray') + '">' + escapeHtml(ROLE_LABELS[role] || role || '—') + '</span>';
}

function emptyRow(columns, title, detail) {
  return '<tr><td colspan="' + columns + '"><div class="empty-state"><strong>' + escapeHtml(title) + '</strong>' + escapeHtml(detail) + '</div></td></tr>';
}

function field(label, control, full = false) {
  return '<div class="form-field' + (full ? ' full-span' : '') + '"><label>' + label + '</label>' + control + '</div>';
}

function select(name, options, selected = '', attributes = '') {
  return '<select name="' + name + '" ' + attributes + '>' + options.map(option => {
    const value = typeof option === 'string' ? option : option.value;
    const text = typeof option === 'string' ? option : option.label;
    return '<option value="' + escapeHtml(value) + '"' + (value === selected ? ' selected' : '') + '>' + escapeHtml(text) + '</option>';
  }).join('') + '</select>';
}

function formatDateTime(value) {
  if (!value) return '—';
  const parts = String(value).split(' ');
  const [year, month, day] = (parts[0] || '').split('-');
  if (!year || !month || !day) return value;
  return (parts[1] || '') + ' ' + day + '/' + month + '/' + year;
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
  const response = await fetch(USERS_API + path, {
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

/* ===== Danh sách + phân trang ===== */
async function loadUsers() {
  const params = new URLSearchParams({
    q: userState.q,
    role: userState.role,
    status: userState.status,
    page: String(userState.page),
    size: String(userState.size)
  });
  setTableLoading();
  try {
    const data = await apiGet(USERS_API + '?' + params.toString());
    userState.users = Array.isArray(data?.users) ? data.users : [];
    userState.total = Number(data?.total || 0);
    userState.page = Number(data?.page || 1);
    userState.totalPages = Number(data?.totalPages || 1);
    userState.size = Number(data?.size || userState.size);
    userState.counts = {
      byRole: data?.counts?.byRole || {},
      byStatus: data?.counts?.byStatus || {},
      unverified: Number(data?.counts?.unverified || 0)
    };
    renderUsers();
  } catch (error) {
    toast(error.message || 'Không tải được danh sách tài khoản.');
    document.getElementById('usersTableBody').innerHTML = emptyRow(6, 'Không tải được dữ liệu', 'Kiểm tra kết nối rồi thử lại.');
  } finally {
    setTableLoading(false);
  }
}

function setTableLoading() {
  const body = document.getElementById('usersTableBody');
  if (body) body.innerHTML = emptyRow(6, 'Đang tải…', 'Vui lòng chờ trong giây lát.');
  const prev = document.getElementById('userPrev');
  const next = document.getElementById('userNext');
  if (prev) prev.disabled = true;
  if (next) next.disabled = true;
}

function renderUsers() {
  const body = document.getElementById('usersTableBody');
  if (!body) return;

  body.innerHTML = userState.users.length ? userState.users.map(user => {
    const isSelf = Number(user.userId) === CURRENT_USER_ID;
    const locked = user.status === 'LOCKED';
    return '<tr>' +
      '<td><div class="supplier-cell"><div class="avatar">' + escapeHtml(initials(user.fullName)) + '</div><div>' +
        '<strong>' + escapeHtml(user.fullName) + '</strong>' +
        '<div class="table-note">#' + escapeHtml(user.userId) + (isSelf ? ' · Bạn' : '') + '</div>' +
      '</div></div></td>' +
      '<td>' + escapeHtml(user.email) +
        '<div class="table-note">' + escapeHtml(user.phone || 'Chưa có SĐT') + ' · ' + (user.emailVerified ? 'Đã xác minh' : 'Chưa xác minh') + '</div></td>' +
      '<td>' + rolePill(user.role) + '</td>' +
      '<td class="mono">' + escapeHtml(formatDateTime(user.createdAt)) + '</td>' +
      '<td>' + pill(STATUS_LABELS[user.status] || user.status) + '</td>' +
      '<td><div class="action-menu">' +
        '<button class="mini-btn" type="button" onclick="openUserDetail(' + Number(user.userId) + ')">Chi tiết</button>' +
        '<button class="mini-btn" type="button" onclick="openRoleForm(' + Number(user.userId) + ')"' + (isSelf ? ' disabled title="Không thể tự đổi vai trò"' : '') + '>Đổi vai trò</button>' +
        '<button class="mini-btn ' + (locked ? 'success' : 'warning') + '" type="button" onclick="toggleUserLock(' + Number(user.userId) + ')"' + (isSelf ? ' disabled title="Không thể tự khóa"' : '') + '>' +
          (locked ? 'Mở khóa' : 'Khóa') + '</button>' +
      '</div></td>' +
    '</tr>';
  }).join('') : emptyRow(6, 'Không tìm thấy tài khoản', 'Thử thay đổi từ khóa hoặc bộ lọc.');

  const byStatus = userState.counts.byStatus || {};
  document.getElementById('userActiveCount').textContent = Number(byStatus.ACTIVE || 0);
  document.getElementById('userLockedCount').textContent = Number(byStatus.LOCKED || 0);
  document.getElementById('userPendingCount').textContent = Number(userState.counts.unverified || 0);

  const start = userState.total === 0 ? 0 : (userState.page - 1) * userState.size + 1;
  const end = Math.min(userState.total, userState.page * userState.size);
  document.getElementById('userResultCount').textContent =
    start + '–' + end + ' / ' + userState.total + ' tài khoản';
  document.getElementById('userPageInfo').textContent = 'Trang ' + userState.page + '/' + userState.totalPages;
  document.getElementById('userPrev').disabled = userState.page <= 1;
  document.getElementById('userNext').disabled = userState.page >= userState.totalPages;

  renderMonitoring();
}

function renderMonitoring() {
  const host = document.getElementById('userMonitoring');
  if (!host) return;
  const byRole = userState.counts.byRole || {};
  const byStatus = userState.counts.byStatus || {};
  const total = userState.total || 0;
  host.innerHTML =
    '<div class="status-row"><div><div class="label">Tổng tài khoản</div><div class="meta">' + total + ' tài khoản trong hệ thống</div></div><span class="pill blue">' + total + '</span></div>' +
    '<div class="status-row"><div><div class="label">Khách hàng</div><div class="meta">Tài khoản mua hàng</div></div><span class="pill gray">' + Number(byRole.CUSTOMER || 0) + '</span></div>' +
    '<div class="status-row"><div><div class="label">Nhà cung cấp</div><div class="meta">Tài khoản xưởng in</div></div><span class="pill amber">' + Number(byRole.SELLER || 0) + '</span></div>' +
    '<div class="status-row"><div><div class="label">Quản trị viên</div><div class="meta">Toàn quyền hệ thống</div></div><span class="pill blue">' + Number(byRole.ADMIN || 0) + '</span></div>' +
    '<div class="status-row"><div><div class="label">Đang hoạt động</div><div class="meta">Có thể đăng nhập</div></div><span class="pill green">' + Number(byStatus.ACTIVE || 0) + '</span></div>' +
    '<div class="status-row"><div><div class="label">Bị khóa</div><div class="meta">Không thể đăng nhập</div></div><span class="pill red">' + Number(byStatus.LOCKED || 0) + '</span></div>' +
    '<div class="status-row"><div><div class="label">Chưa xác minh email</div><div class="meta">Cần xác minh trước khi đăng nhập</div></div><span class="pill amber">' + Number(userState.counts.unverified || 0) + '</span></div>';
}

/* ===== Thao tác ===== */
function findUser(userId) {
  return userState.users.find(user => Number(user.userId) === Number(userId));
}

function toggleUserLock(userId) {
  const user = findUser(userId);
  if (!user) return;
  if (Number(userId) === CURRENT_USER_ID) {
    toast('Bạn không thể tự khóa tài khoản của mình.');
    return;
  }
  const locking = user.status !== 'LOCKED';
  confirmAction(
    locking ? 'Khóa tài khoản' : 'Mở khóa tài khoản',
    (locking ? 'Tài khoản ' : 'Mở lại quyền đăng nhập cho ') + user.email + (locking ? ' sẽ không thể đăng nhập.' : '.'),
    () => updateUserStatus(userId, locking ? 'LOCKED' : 'ACTIVE'),
    locking ? 'Khóa tài khoản' : 'Mở khóa'
  );
}

async function updateUserStatus(userId, status) {
  try {
    await apiPost('/status', { userId: String(userId), status });
    toast(status === 'LOCKED' ? 'Đã khóa tài khoản.' : 'Đã mở khóa tài khoản.');
    await loadUsers();
  } catch (error) {
    toast(error.message || 'Không cập nhật được trạng thái.');
  }
}

function openRoleForm(userId) {
  const user = findUser(userId);
  if (!user) return;
  if (Number(userId) === CURRENT_USER_ID) {
    toast('Bạn không thể tự hạ quyền quản trị của mình.');
    return;
  }
  openEntityModal({
    title: 'Đổi vai trò',
    subtitle: user.fullName + ' · ' + user.email,
    fields: field('Vai trò mới', select('role', [
      { value: 'CUSTOMER', label: ROLE_LABELS.CUSTOMER },
      { value: 'SELLER', label: ROLE_LABELS.SELLER },
      { value: 'ADMIN', label: ROLE_LABELS.ADMIN }
    ], user.role || 'CUSTOMER', 'required'), true),
    submitText: 'Cập nhật vai trò',
    onSubmit: data => updateUserRole(userId, data.get('role'))
  });
}

async function updateUserRole(userId, role) {
  try {
    await apiPost('/role', { userId: String(userId), role });
    closeAll();
    toast('Đã cập nhật vai trò.');
    await loadUsers();
  } catch (error) {
    toast(error.message || 'Không cập nhật được vai trò.');
  }
}

function openUserDetail(userId) {
  const user = findUser(userId);
  if (!user) return;
  openInfoModal('Chi tiết tài khoản', user.fullName + ' · #' + user.userId,
    '<div class="detail-grid">' +
    '<div class="field"><label>Họ và tên</label><strong>' + escapeHtml(user.fullName) + '</strong></div>' +
    '<div class="field"><label>Email</label><strong>' + escapeHtml(user.email) + '</strong></div>' +
    '<div class="field"><label>Số điện thoại</label><strong>' + escapeHtml(user.phone || 'Chưa cập nhật') + '</strong></div>' +
    '<div class="field"><label>Vai trò</label><strong>' + escapeHtml(ROLE_LABELS[user.role] || user.role) + '</strong></div>' +
    '<div class="field"><label>Trạng thái</label><strong>' + escapeHtml(STATUS_LABELS[user.status] || user.status) + '</strong></div>' +
    '<div class="field"><label>Xác minh email</label><strong>' + (user.emailVerified ? 'Đã xác minh' : 'Chưa xác minh') + '</strong></div>' +
    '<div class="field"><label>Ngày tạo</label><strong>' + escapeHtml(formatDateTime(user.createdAt)) + '</strong></div>' +
    '</div>');
}

/* ===== Bộ lọc / tìm kiếm ===== */
function onUserSearchInput() {
  clearTimeout(searchTimer);
  searchTimer = setTimeout(() => {
    userState.q = document.getElementById('userSearch').value.trim();
    userState.page = 1;
    loadUsers();
  }, 300);
}

function onUserFilterChange() {
  userState.role = document.getElementById('userRoleFilter').value;
  userState.status = document.getElementById('userStatusFilter').value;
  userState.page = 1;
  loadUsers();
}

function gotoUserPage(delta) {
  const target = userState.page + delta;
  if (target < 1 || target > userState.totalPages) return;
  userState.page = target;
  loadUsers();
}

/* ===== Xuất CSV (trang hiện tại) ===== */
function csvCell(value) {
  return '"' + String(value ?? '').replace(/"/g, '""') + '"';
}

function downloadCsv(filename, rows) {
  const blob = new Blob(['\uFEFF' + rows.join('\n')], { type: 'text/csv;charset=utf-8' });
  const link = document.createElement('a');
  link.href = URL.createObjectURL(blob);
  link.download = filename;
  document.body.appendChild(link);
  link.click();
  link.remove();
  URL.revokeObjectURL(link.href);
  toast('Đã xuất ' + filename);
}

function exportUsers() {
  if (!userState.users.length) {
    toast('Không có dữ liệu để xuất.');
    return;
  }
  const header = 'Mã,Tên,Email,SĐT,Vai trò,Trạng thái,Xác minh email,Ngày tạo';
  const rows = [header].concat(userState.users.map(user => [
    user.userId, user.fullName, user.email, user.phone || '',
    ROLE_LABELS[user.role] || user.role, STATUS_LABELS[user.status] || user.status,
    user.emailVerified ? 'Đã xác minh' : 'Chưa xác minh', user.createdAt || ''
  ].map(csvCell).join(',')));
  downloadCsv('nguoi-dung.csv', rows);
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', loadUsers);
} else {
  loadUsers();
}
