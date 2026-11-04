/* ===== Shared UI ===== */
let toastTimer;
let confirmHandler = null;
let editingNotificationId = null;

function toast(message){
  const element = document.getElementById('toast');
  element.textContent = message;
  element.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => element.classList.remove('show'), 2200);
}

const pageTitles = {
  dashboard:['Bảng điều khiển vận hành','Thứ Bảy, 26 tháng 9, 2026'],
  reports:['Báo cáo & Doanh thu','Phân tích hiệu suất kinh doanh'],
  orders:['Quản lý đơn hàng','Toàn bộ đơn hàng trên hệ thống'],
  suppliers:['Xưởng in đối tác','120 xưởng in trên toàn quốc'],
  disputes:['Tranh chấp','Xử lý khiếu nại giữa khách hàng và xưởng in'],
  ncc:['Nhà cung cấp','Thêm, xóa và cấp quyền cho NCC'],
  inventory:['Quản lý kho','Theo dõi hàng hóa, xuất nhập tồn và lưu trữ'],
  contracts:['Quản lý hợp đồng','Lưu trữ, theo dõi và cập nhật trạng thái hợp đồng'],
  users:['Quản lý người dùng','Thêm, sửa, xóa và theo dõi tài khoản thành viên'],
  rbac:['Phân quyền RBAC','Phân chia quyền truy cập theo vai trò và bộ phận'],
  platform:['Quản lý nền tảng','Vận hành, cấu hình và giám sát hệ thống chung'],
  notifications:['Thông báo','Gửi tin nhắn, cảnh báo và cập nhật đến người dùng'],
  buyers:['Người mua','Quản lý tài khoản khách hàng'],
  staff:['Nhân sự nội bộ','Quản lý đội ngũ vận hành PrintKraft'],
  settings:['Cấu hình hệ thống','Thiết lập tham số và phân quyền'],
  logs:['Nhật ký hoạt động','Toàn bộ thao tác trên hệ thống']
};

function switchPage(element, page){
  document.querySelectorAll('.nav-item').forEach(item => item.classList.remove('active'));
  element.classList.add('active');
  document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
  const target = document.getElementById('page-' + page);
  if(!target) return;
  target.classList.add('active');
  document.getElementById('pageTitle').textContent = pageTitles[page][0];
  document.getElementById('pageSub').textContent = pageTitles[page][1];
  window.scrollTo({top:0, behavior:'smooth'});
}

function switchPageByName(page){
  const item = [...document.querySelectorAll('.nav-item')].find(nav => nav.getAttribute('onclick')?.includes("'" + page + "'"));
  if(item) switchPage(item, page);
}

function pickTab(element){
  element.parentElement.querySelectorAll('.tab').forEach(tab => tab.classList.remove('active'));
  element.classList.add('active');
}

function showModal(id){
  const modal = document.getElementById(id);
  document.getElementById('overlay').classList.add('show');
  modal.classList.add('show');
  modal.setAttribute('aria-hidden','false');
}

function closeAll(){
  document.querySelectorAll('.modal, .overlay').forEach(element => element.classList.remove('show'));
  document.querySelectorAll('.modal').forEach(element => element.setAttribute('aria-hidden','true'));
  confirmHandler = null;
}

function openEntityModal({title, subtitle='', fields, submitText='Lưu thay đổi', onSubmit}){
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

function openInfoModal(title, subtitle, content){
  document.getElementById('entityModalTitle').textContent = title;
  document.getElementById('entityModalSubtitle').textContent = subtitle;
  document.getElementById('entityForm').hidden = true;
  const info = document.getElementById('entityInfoContent');
  info.hidden = false;
  info.innerHTML = content + '<div class="modal-actions"><button class="btn primary" type="button" onclick="closeAll()">Đóng</button></div>';
  showModal('entityModal');
}

function confirmAction(title, message, action, buttonText='Xác nhận'){
  document.getElementById('confirmTitle').textContent = title;
  document.getElementById('confirmMessage').textContent = message;
  const button = document.getElementById('confirmButton');
  button.textContent = buttonText;
  confirmHandler = action;
  button.onclick = () => {
    const handler = confirmHandler;
    closeAll();
    if(handler) handler();
  };
  showModal('confirmModal');
}

function escapeHtml(value=''){
  return String(value).replace(/[&<>"']/g, char => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#039;'}[char]));
}

function normalize(value=''){
  return String(value).toLocaleLowerCase('vi').normalize('NFD').replace(/[\u0300-\u036f]/g,'').replace(/đ/g,'d');
}

function uid(prefix){
  return prefix + '-' + Date.now().toString(36).toUpperCase() + Math.random().toString(36).slice(2,5).toUpperCase();
}

function nowLabel(){
  return new Intl.DateTimeFormat('vi-VN',{day:'2-digit',month:'2-digit',year:'numeric',hour:'2-digit',minute:'2-digit'}).format(new Date());
}

function pill(status){
  const colors = {'Hoạt động':'green','Đang làm':'green','Hiệu lực':'green','Đủ hàng':'green','Đã gửi':'green','Đã xử lý':'green','Ổn định':'green','Chờ duyệt':'amber','Theo dõi':'amber','Sắp thiếu':'amber','Sắp hết hạn':'amber','Tạm nghỉ':'amber','Đã lên lịch':'blue','Chờ ký':'blue','Bản nháp':'gray','Bị khóa':'red','Tạm dừng':'red','Đã nghỉ việc':'red','Cần nhập':'red','Hết hiệu lực':'gray','Gián đoạn':'red','Chậm':'amber','Đang chạy':'blue'};
  return '<span class="pill ' + (colors[status] || 'gray') + '"><span class="dot"></span>' + escapeHtml(status) + '</span>';
}

function emptyRow(columns, title, detail){
  return '<tr><td colspan="' + columns + '"><div class="empty-state"><strong>' + escapeHtml(title) + '</strong>' + escapeHtml(detail) + '</div></td></tr>';
}

function field(label, control, full=false){
  return '<div class="form-field' + (full ? ' full-span' : '') + '"><label>' + label + '</label>' + control + '</div>';
}

function input(name, value='', type='text', attributes=''){
  return '<input type="' + type + '" name="' + name + '" value="' + escapeHtml(value) + '" ' + attributes + '>';
}

function select(name, options, selected='', attributes=''){
  return '<select name="' + name + '" ' + attributes + '>' + options.map(option => {
    const value = typeof option === 'string' ? option : option.value;
    const label = typeof option === 'string' ? option : option.label;
    return '<option value="' + escapeHtml(value) + '"' + (value === selected ? ' selected' : '') + '>' + escapeHtml(label) + '</option>';
  }).join('') + '</select>';
}

function checkboxOptions(name, options, selected=[]){
  return '<div class="checkbox-grid">' + options.map(option => '<label class="checkbox-option"><input type="checkbox" name="' + name + '" value="' + escapeHtml(option) + '"' + (selected.includes(option) ? ' checked' : '') + '> ' + escapeHtml(option) + '</label>').join('') + '</div>';
}

/* ===== Persistent demo data ===== */
const STORAGE_KEY = 'printkraft-admin-functional-v1';
const resources = [
  {key:'users',label:'Người dùng'},
  {key:'orders',label:'Đơn hàng'},
  {key:'suppliers',label:'Nhà cung cấp'},
  {key:'inventory',label:'Kho'},
  {key:'contracts',label:'Hợp đồng'},
  {key:'platform',label:'Nền tảng'},
  {key:'notifications',label:'Thông báo'}
];

const seedData = {
  users:[
    {id:'USR-001',employeeCode:'NV-001',name:'Trần Hòa',email:'hoa.tran@printkraft.vn',phone:'0901234567',type:'Nội bộ',department:'Nền tảng',position:'Quản trị hệ thống',startDate:'2024-01-08',employmentStatus:'Đang làm',roleId:'ROLE-ADMIN',status:'Hoạt động',lastLogin:'26/09/2026 10:44',twoFactor:true},
    {id:'USR-002',employeeCode:'NV-002',name:'Lê Phương',email:'phuong.le@printkraft.vn',phone:'0912456789',type:'Nội bộ',department:'Kho vận',position:'Quản lý kho',startDate:'2024-06-17',employmentStatus:'Đang làm',roleId:'ROLE-WAREHOUSE',status:'Hoạt động',lastLogin:'26/09/2026 09:10',twoFactor:true},
    {id:'USR-005',employeeCode:'NV-003',name:'Nguyễn Linh',email:'linh.nguyen@printkraft.vn',phone:'0903555777',type:'Nội bộ',department:'Vận hành',position:'Quản lý đơn hàng',startDate:'2025-02-10',employmentStatus:'Đang làm',roleId:'ROLE-OPS',status:'Hoạt động',lastLogin:'26/09/2026 08:55',twoFactor:true},
    {id:'USR-006',employeeCode:'NV-004',name:'Phạm Minh',email:'minh.pham@printkraft.vn',phone:'0938111222',type:'Nội bộ',department:'Hỗ trợ',position:'Chuyên viên CSKH',startDate:'2025-05-12',employmentStatus:'Đang làm',roleId:'ROLE-OPS',status:'Hoạt động',lastLogin:'25/09/2026 17:40',twoFactor:true},
    {id:'USR-007',employeeCode:'NV-005',name:'Lê Trang',email:'trang.le@printkraft.vn',phone:'0988222111',type:'Nội bộ',department:'Tài chính',position:'Kế toán hợp đồng',startDate:'2025-03-03',employmentStatus:'Đang làm',roleId:'ROLE-OPS',status:'Hoạt động',lastLogin:'26/09/2026 08:20',twoFactor:true},
    {id:'USR-008',employeeCode:'NV-006',name:'Vũ Hùng',email:'hung.vu@printkraft.vn',phone:'0977666555',type:'Nội bộ',department:'Vận hành',position:'Giám sát xưởng',startDate:'2024-11-18',employmentStatus:'Tạm nghỉ',roleId:'ROLE-OPS',status:'Bị khóa',lastLogin:'20/09/2026 15:15',twoFactor:false},
    {id:'USR-003',name:'Sài Gòn Print',email:'ops@sgprint.vn',phone:'02838123456',type:'NCC',department:'Đối tác',roleId:'ROLE-SUPPLIER',status:'Chờ duyệt',lastLogin:'Chưa đăng nhập',twoFactor:false},
    {id:'USR-004',name:'Quà Tặng An',email:'contact@quatang-an.vn',phone:'0909777666',type:'Khách hàng',department:'Doanh nghiệp',roleId:'ROLE-CUSTOMER',status:'Bị khóa',lastLogin:'22/09/2026 17:22',twoFactor:false}
  ],
  roles:[
    {id:'ROLE-ADMIN',name:'Quản trị viên',scope:'Toàn quyền hệ thống',system:true,permissions:{users:true,orders:true,suppliers:true,inventory:true,contracts:true,platform:true,notifications:true}},
    {id:'ROLE-OPS',name:'Quản lý vận hành',scope:'Đơn hàng, NCC, tranh chấp và thông báo',system:false,permissions:{users:true,orders:true,suppliers:true,inventory:true,contracts:true,platform:false,notifications:true}},
    {id:'ROLE-WAREHOUSE',name:'Quản lý kho',scope:'Nhập xuất tồn và kiểm kê kho',system:false,permissions:{users:false,orders:true,suppliers:false,inventory:true,contracts:false,platform:false,notifications:false}},
    {id:'ROLE-SUPPLIER',name:'Nhà cung cấp',scope:'Đơn được phân công và vật tư liên quan',system:true,permissions:{users:false,orders:true,suppliers:false,inventory:true,contracts:false,platform:false,notifications:false}},
    {id:'ROLE-CUSTOMER',name:'Khách hàng doanh nghiệp',scope:'Theo dõi đơn và hợp đồng của doanh nghiệp',system:true,permissions:{users:false,orders:true,suppliers:false,inventory:false,contracts:true,platform:false,notifications:false}}
  ],
  accessRequests:[
    {id:'REQ-001',user:'Nguyễn Linh',roleId:'ROLE-OPS',reason:'Phụ trách điều phối miền Nam',status:'Chờ duyệt'},
    {id:'REQ-002',user:'Phạm Minh',roleId:'ROLE-WAREHOUSE',reason:'Hỗ trợ kiểm kê cuối tháng',status:'Chờ duyệt'}
  ],
  suppliers:[
    {id:'NCC-001',name:'Sài Gòn Print',taxCode:'0312345678',area:'TP.HCM',region:'Miền Nam',email:'ops@sgprint.vn',phone:'02838123456',permissions:['Nhận đơn','Tự báo giá'],sla:96,contract:'HD-2026-014',status:'Hoạt động'},
    {id:'NCC-002',name:'Hà Nội Digital',taxCode:'0109988776',area:'Hà Nội',region:'Miền Bắc',email:'contact@hndigital.vn',phone:'02438881234',permissions:['Nhận đơn'],sla:81,contract:'HD-2025-088',status:'Theo dõi'},
    {id:'NCC-003',name:'Đà Nẵng Xpress',taxCode:'0401234987',area:'Đà Nẵng',region:'Miền Trung',email:'hello@dnxpress.vn',phone:'02363888999',permissions:['Nhận đơn','Truy cập kho'],sla:92,contract:'HD-2026-021',status:'Hoạt động'},
    {id:'NCC-004',name:'Mekong Gift',taxCode:'1801122334',area:'Cần Thơ',region:'Miền Nam',email:'sales@mekonggift.vn',phone:'02923888777',permissions:[],sla:0,contract:'Chưa có',status:'Chờ duyệt'}
  ],
  inventory:[
    {id:'VT-INK-CMYK',name:'Mực DTG CMYK 1L',stock:126,reserved:32,min:80,warehouse:'Kho A',unit:'chai'},
    {id:'VT-TS-WHT-L',name:'Áo thun trắng size L',stock:214,reserved:188,min:250,warehouse:'Kho B',unit:'áo'},
    {id:'VT-MUG-350',name:'Cốc sứ trắng 350ml',stock:48,reserved:40,min:100,warehouse:'Kho C',unit:'cốc'},
    {id:'VT-CANVAS-A3',name:'Canvas A3 cán mờ',stock:390,reserved:75,min:120,warehouse:'Kho A',unit:'tấm'}
  ],
  movements:[
    {id:'MOV-001',itemId:'VT-INK-CMYK',type:'Nhập kho',quantity:40,note:'Phiếu nhập PN-2609-12',time:'26/09/2026 09:20'},
    {id:'MOV-002',itemId:'VT-TS-WHT-L',type:'Xuất kho',quantity:25,note:'Cấp cho đơn PK-08310',time:'26/09/2026 08:45'},
    {id:'MOV-003',itemId:'VT-MUG-350',type:'Kiểm kê',quantity:48,note:'Khớp số lượng thực tế',time:'25/09/2026 17:10'}
  ],
  contracts:[
    {id:'HD-2026-014',partner:'Sài Gòn Print',type:'NCC sản xuất',value:'1,2 tỷ/năm',start:'2026-01-01',end:'2026-12-31',status:'Hiệu lực',owner:'Trần Hòa',updated:'26/09/2026 09:45'},
    {id:'HD-2025-088',partner:'Hà Nội Digital',type:'NCC sản xuất',value:'680 triệu/năm',start:'2025-10-01',end:'2026-09-30',status:'Sắp hết hạn',owner:'Lê Trang',updated:'26/09/2026 08:15'},
    {id:'HD-2026-033',partner:'The Coffee House X',type:'Khách B2B',value:'420 triệu',start:'2026-09-15',end:'2026-12-15',status:'Chờ ký',owner:'Phạm Minh',updated:'25/09/2026 16:30'},
    {id:'HD-2026-041',partner:'Mekong Gift',type:'NCC sản xuất',value:'300 triệu/năm',start:'2026-10-01',end:'2027-09-30',status:'Chờ ký',owner:'Nguyễn Linh',updated:'25/09/2026 14:05'}
  ],
  services:[
    {id:'SVC-ORDERS',name:'API đơn hàng',detail:'24.812 request/giờ',metric:92,latency:184,status:'Ổn định'},
    {id:'SVC-PAYMENT',name:'Thanh toán',detail:'Tỉ lệ thành công 98,2%',metric:98,latency:210,status:'Ổn định'},
    {id:'SVC-INVENTORY',name:'Đồng bộ kho',detail:'Queue còn 128 bản ghi',metric:64,latency:860,status:'Chậm'},
    {id:'SVC-NOTIFY',name:'Email / SMS',detail:'Đang xử lý 3.420 thông báo',metric:76,latency:340,status:'Đang chạy'}
  ],
  incidents:[
    {id:'INC-001',title:'Đồng bộ kho chậm',detail:'Queue vượt ngưỡng 100 bản ghi',severity:'Cảnh báo',status:'Đang xử lý',time:'26/09/2026 09:38'},
    {id:'INC-002',title:'Backup định kỳ hoàn tất',detail:'Dung lượng 4,8GB, thời gian 11 phút',severity:'Thông tin',status:'Đã xử lý',time:'26/09/2026 06:12'}
  ],
  config:{scheduledMaintenance:true,autoBackup:true,autoScale:true,maintenanceMode:false,uploadLimit:250,backupInterval:6},
  notifications:[
    {id:'NTF-001',title:'Cảnh báo tồn kho thấp',message:'Cốc sứ trắng 350ml đã xuống dưới ngưỡng an toàn.',audience:'Quản lý kho',channel:'In-app + Email',level:'Cảnh báo',status:'Đã gửi',time:'26/09/2026 10:20'},
    {id:'NTF-002',title:'Hợp đồng sắp hết hạn',message:'Có 9 hợp đồng cần gia hạn trong 30 ngày tới.',audience:'Nhân sự nội bộ',channel:'In-app + Email',level:'Thông tin',status:'Đã gửi',time:'26/09/2026 09:00'},
    {id:'NTF-003',title:'Bảo trì hệ thống',message:'Hệ thống sẽ bảo trì vào 02:00 Chủ nhật.',audience:'Tất cả người dùng',channel:'In-app + Email',level:'Thông tin',status:'Đã lên lịch',time:'27/09/2026 02:00'},
    {id:'NTF-004',title:'Cập nhật chính sách NCC',message:'Nội dung đang được phòng pháp chế rà soát.',audience:'Nhà cung cấp',channel:'Email',level:'Thông tin',status:'Bản nháp',time:'26/09/2026 08:10'}
  ]
};

function cloneSeed(){
  return JSON.parse(JSON.stringify(seedData));
}

function loadState(){
  try{
    const stored = JSON.parse(localStorage.getItem(STORAGE_KEY));
    return stored ? {...cloneSeed(), ...stored} : cloneSeed();
  }catch(error){
    return cloneSeed();
  }
}

let state = loadState();
state.suppliers = []; // NCC lấy từ API /admin/api/supplier-accounts, không dùng seed/localStorage


function persist(message){
  localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
  if(message) toast(message);
}

function roleName(roleId){
  return state.roles.find(role => role.id === roleId)?.name || 'Chưa gán';
}

function refreshAll(){
  renderUsers();
  renderStaff();
  renderRoles();
  renderSuppliers();
  renderInventory();
  renderContracts();
  renderPlatform();
  renderNotifications();
}

/* ===== User management ===== */
function renderUsers(){
  const body = document.getElementById('usersTableBody');
  if(!body) return;
  const search = normalize(document.getElementById('userSearch')?.value);
  const roleFilter = document.getElementById('userRoleFilter');
  const previousRole = roleFilter.value;
  roleFilter.innerHTML = '<option value="">Tất cả vai trò</option>' + state.roles.map(role => '<option value="' + role.id + '">' + escapeHtml(role.name) + '</option>').join('');
  roleFilter.value = previousRole;
  const status = document.getElementById('userStatusFilter').value;
  const filtered = state.users.filter(user => (!search || normalize([user.name,user.email,user.phone,user.id].join(' ')).includes(search)) && (!roleFilter.value || user.roleId === roleFilter.value) && (!status || user.status === status));
  body.innerHTML = filtered.length ? filtered.map(user => {
    const initials = user.name.split(' ').slice(-2).map(part => part[0]).join('').toUpperCase();
    return '<tr><td><div class="supplier-cell"><div class="avatar">' + escapeHtml(initials) + '</div><div><strong>' + escapeHtml(user.name) + '</strong><div class="table-note">' + escapeHtml(user.email) + '</div></div></div></td><td>' + escapeHtml(user.type) + '<div class="table-note">' + escapeHtml(user.department) + '</div></td><td>' + escapeHtml(roleName(user.roleId)) + '</td><td class="mono">' + escapeHtml(user.lastLogin) + '</td><td>' + pill(user.status) + '<div class="table-note">2FA: ' + (user.twoFactor ? 'Đã bật' : 'Chưa bật') + '</div></td><td><div class="action-menu"><button class="mini-btn" onclick="openUserForm(\'' + user.id + '\')">Sửa</button><button class="mini-btn" onclick="openUserActivity(\'' + user.id + '\')">Theo dõi</button>' + (user.status === 'Chờ duyệt' ? '<button class="mini-btn success" onclick="approveUser(\'' + user.id + '\')">Duyệt</button>' : '<button class="mini-btn warning" onclick="toggleUserLock(\'' + user.id + '\')">' + (user.status === 'Bị khóa' ? 'Mở khóa' : 'Khóa') + '</button>') + '<button class="mini-btn danger" onclick="deleteUser(\'' + user.id + '\')">Xóa</button></div></td></tr>';
  }).join('') : emptyRow(6,'Không tìm thấy tài khoản','Thử thay đổi từ khóa hoặc bộ lọc.');
  document.getElementById('userResultCount').textContent = filtered.length + ' tài khoản';
  document.getElementById('userActiveCount').textContent = state.users.filter(user => user.status === 'Hoạt động').length;
  document.getElementById('userPendingCount').textContent = state.users.filter(user => user.status === 'Chờ duyệt').length;
  document.getElementById('userLockedCount').textContent = state.users.filter(user => user.status === 'Bị khóa').length;
  const internal = state.users.filter(user => user.type === 'Nội bộ');
  const twoFactorRate = internal.length ? Math.round(internal.filter(user => user.twoFactor).length / internal.length * 100) : 0;
  document.getElementById('userMonitoring').innerHTML =
    '<div class="status-row"><div><div class="label">Tài khoản cần phê duyệt</div><div class="meta">' + state.users.filter(user => user.status === 'Chờ duyệt').length + ' hồ sơ đang chờ</div><div class="meter"><span class="amber" style="width:' + Math.min(100,state.users.filter(user => user.status === 'Chờ duyệt').length * 12) + '%"></span></div></div>' + pill('Chờ duyệt') + '</div>' +
    '<div class="status-row"><div><div class="label">Xác thực 2 lớp</div><div class="meta">' + twoFactorRate + '% tài khoản nội bộ đã bật</div><div class="meter"><span class="green" style="width:' + twoFactorRate + '%"></span></div></div><span class="pill green">' + twoFactorRate + '%</span></div>' +
    '<div class="status-row"><div><div class="label">Tài khoản bị khóa</div><div class="meta">Theo dõi dấu hiệu truy cập bất thường</div><div class="meter"><span class="red" style="width:' + Math.min(100,state.users.filter(user => user.status === 'Bị khóa').length * 15) + '%"></span></div></div>' + pill('Bị khóa') + '</div>';
}

function openUserForm(id){
  const user = state.users.find(item => item.id === id);
  const roles = state.roles.map(role => ({value:role.id,label:role.name}));
  openEntityModal({
    title:user ? 'Sửa tài khoản' : 'Thêm người dùng',
    subtitle:user ? user.id + ' · Cập nhật hồ sơ và quyền truy cập' : 'Tạo tài khoản thành viên mới',
    fields:
      field('Họ và tên',input('name',user?.name,'text','required maxlength="80"')) +
      field('Email',input('email',user?.email,'email','required')) +
      field('Số điện thoại',input('phone',user?.phone,'tel','required')) +
      field('Loại tài khoản',select('type',['Nội bộ','NCC','Khách hàng'],user?.type || 'Nội bộ')) +
      field('Bộ phận / Đơn vị',input('department',user?.department,'text','required')) +
      field('Vai trò',select('roleId',roles,user?.roleId || state.roles[0]?.id,'required')) +
      field('Trạng thái',select('status',['Hoạt động','Chờ duyệt','Bị khóa'],user?.status || 'Chờ duyệt')) +
      field('Bảo mật','<label class="checkbox-option"><input type="checkbox" name="twoFactor"' + (user?.twoFactor ? ' checked' : '') + '> Bật xác thực hai lớp</label>'),
    submitText:user ? 'Cập nhật tài khoản' : 'Tạo tài khoản',
    onSubmit:data => {
      const email = data.get('email').trim();
      if(state.users.some(item => item.email.toLowerCase() === email.toLowerCase() && item.id !== id)){ toast('Email đã được sử dụng'); return; }
      const type=data.get('type');
      const accountStatus=data.get('status');
      const record = {id:user?.id || uid('USR'),name:data.get('name').trim(),email,phone:data.get('phone').trim(),type,department:data.get('department').trim(),roleId:data.get('roleId'),status:accountStatus,lastLogin:user?.lastLogin || 'Chưa đăng nhập',twoFactor:data.get('twoFactor') === 'on'};
      if(type==='Nội bộ') record.employmentStatus=accountStatus==='Hoạt động'?'Đang làm':accountStatus==='Bị khóa'?'Tạm nghỉ':user?.employmentStatus||'Đang làm';
      if(user) Object.assign(user,record); else state.users.unshift(record);
      persist(user ? 'Đã cập nhật tài khoản' : 'Đã tạo tài khoản mới');
      closeAll(); renderUsers(); renderStaff(); renderRoles();
    }
  });
}

function approveUser(id){ const user=state.users.find(item=>item.id===id); if(user){user.status='Hoạt động';if(user.type==='Nội bộ')user.employmentStatus='Đang làm';persist('Đã phê duyệt tài khoản');renderUsers();renderStaff();} }
function toggleUserLock(id){
  const user=state.users.find(item=>item.id===id);
  if(!user)return;
  if(user.roleId==='ROLE-ADMIN'&&user.status!=='Bị khóa'){toast('Không thể khóa tài khoản quản trị viên');return;}
  user.status=user.status==='Bị khóa'?'Hoạt động':'Bị khóa';
  if(user.type==='Nội bộ')user.employmentStatus=user.status==='Hoạt động'?'Đang làm':'Tạm nghỉ';
  persist(user.status==='Bị khóa'?'Đã khóa tài khoản':'Đã mở khóa tài khoản');renderUsers();renderStaff();
}
function deleteUser(id){
  const user=state.users.find(item=>item.id===id);if(!user)return;
  if(user.roleId==='ROLE-ADMIN'){toast('Không thể xóa tài khoản quản trị viên');return;}
  confirmAction('Xóa tài khoản','Tài khoản '+user.name+' sẽ bị xóa khỏi danh sách.',()=>{state.users=state.users.filter(item=>item.id!==id);persist('Đã xóa tài khoản');renderUsers();renderStaff();renderRoles();},'Xóa tài khoản');
}

function openUserActivity(id){
  const user=state.users.find(item=>item.id===id); if(!user)return;
  openInfoModal('Theo dõi tài khoản',user.name + ' · ' + user.id,
    '<div class="detail-grid"><div class="field"><label>Đăng nhập gần nhất</label><strong>' + escapeHtml(user.lastLogin) + '</strong></div><div class="field"><label>Trạng thái</label><strong>' + escapeHtml(user.status) + '</strong></div><div class="field"><label>Xác thực 2 lớp</label><strong>' + (user.twoFactor?'Đã bật':'Chưa bật') + '</strong></div><div class="field"><label>Vai trò</label><strong>' + escapeHtml(roleName(user.roleId)) + '</strong></div></div><div class="activity-item"><span class="activity-mark green"></span><div><strong>Phiên đăng nhập hợp lệ</strong><span>Thiết bị Windows · IP 113.161.xxx.xxx</span></div></div><div class="activity-item"><span class="activity-mark"></span><div><strong>Cập nhật hồ sơ</strong><span>Thông tin liên hệ đã được đồng bộ</span></div></div>');
}

function openAccessReview(){
  const without2FA=state.users.filter(user=>user.type==='Nội bộ'&&!user.twoFactor);
  openInfoModal('Rà soát truy cập','Các điểm cần xử lý trong tài khoản thành viên','<div class="activity-item"><span class="activity-mark amber"></span><div><strong>' + without2FA.length + ' tài khoản nội bộ chưa bật 2FA</strong><span>' + escapeHtml(without2FA.map(user=>user.name).join(', ') || 'Không có') + '</span></div></div><div class="activity-item"><span class="activity-mark red"></span><div><strong>' + state.users.filter(user=>user.status==='Bị khóa').length + ' tài khoản đang bị khóa</strong><span>Cần kiểm tra trước khi mở lại quyền truy cập.</span></div></div>');
}

function exportUsers(){ downloadCsv('nguoi-dung.csv',['Mã,Tên,Email,SĐT,Loại,Vai trò,Trạng thái',...state.users.map(user=>[user.id,user.name,user.email,user.phone,user.type,roleName(user.roleId),user.status].map(csvCell).join(','))]); }

/* ===== Internal staff ===== */
function staffStatus(user){
  return user.employmentStatus || (user.status==='Hoạt động'?'Đang làm':'Tạm nghỉ');
}

function renderStaff(){
  const body=document.getElementById('staffTableBody');if(!body)return;
  const staff=state.users.filter(user=>user.type==='Nội bộ');
  const search=normalize(document.getElementById('staffSearch').value);
  const departmentFilter=document.getElementById('staffDepartmentFilter');
  const previousDepartment=departmentFilter.value;
  const departments=[...new Set(staff.map(user=>user.department).filter(Boolean))].sort((a,b)=>a.localeCompare(b,'vi'));
  departmentFilter.innerHTML='<option value="">Tất cả bộ phận</option>'+departments.map(department=>'<option>'+escapeHtml(department)+'</option>').join('');
  departmentFilter.value=previousDepartment;
  const status=document.getElementById('staffStatusFilter').value;
  const filtered=staff.filter(user=>(!search||normalize([user.name,user.employeeCode,user.email,user.phone].join(' ')).includes(search))&&(!departmentFilter.value||user.department===departmentFilter.value)&&(!status||staffStatus(user)===status));
  body.innerHTML=filtered.length?filtered.map(user=>{
    const initials=user.name.split(' ').slice(-2).map(part=>part[0]).join('').toUpperCase();
    const employment=staffStatus(user);
    return '<tr><td><div class="supplier-cell"><div class="avatar">'+escapeHtml(initials)+'</div><div><strong>'+escapeHtml(user.name)+'</strong><div class="table-note">'+escapeHtml(user.employeeCode||user.id)+'</div></div></div></td><td><strong>'+escapeHtml(user.position||roleName(user.roleId))+'</strong><div class="table-note">'+escapeHtml(roleName(user.roleId))+'</div></td><td>'+escapeHtml(user.department||'Chưa phân công')+'</td><td>'+escapeHtml(user.email)+'<div class="table-note">'+escapeHtml(user.phone||'Chưa có SĐT')+'</div></td><td class="mono">'+escapeHtml(formatDate(user.startDate)||'Chưa cập nhật')+'</td><td>'+pill(employment)+'</td><td><div class="action-menu"><button class="mini-btn" onclick="viewStaff(\''+user.id+'\')">Chi tiết</button><button class="mini-btn" onclick="openStaffForm(\''+user.id+'\')">Sửa</button><button class="mini-btn warning" onclick="toggleStaffStatus(\''+user.id+'\')">'+(employment==='Đang làm'?'Tạm nghỉ':'Kích hoạt')+'</button><button class="mini-btn danger" onclick="deleteStaff(\''+user.id+'\')">Xóa</button></div></td></tr>';
  }).join(''):emptyRow(7,'Không tìm thấy nhân sự','Thử thay đổi từ khóa hoặc bộ lọc.');
  document.getElementById('staffActiveCount').textContent=staff.filter(user=>staffStatus(user)==='Đang làm').length;
  document.getElementById('staffLeaveCount').textContent=staff.filter(user=>staffStatus(user)==='Tạm nghỉ').length;
  document.getElementById('staffDepartmentCount').textContent=departments.length;
  document.getElementById('staffResultCount').textContent=filtered.length+' nhân sự';
}

function openStaffForm(id){
  const employee=state.users.find(user=>user.id===id&&user.type==='Nội bộ');
  const nextNumber=Math.max(0,...state.users.filter(user=>user.type==='Nội bộ').map(user=>Number((user.employeeCode||'').match(/\d+/)?.[0]||0)))+1;
  const defaultCode='NV-'+String(nextNumber).padStart(3,'0');
  openEntityModal({
    title:employee?'Sửa hồ sơ nhân sự':'Thêm nhân sự',
    subtitle:employee?(employee.employeeCode||employee.id)+' · Cập nhật hồ sơ công việc':'Tạo hồ sơ và tài khoản nội bộ mới',
    fields:
      field('Mã nhân viên',input('employeeCode',employee?.employeeCode||defaultCode,'text','required maxlength="20"'))+
      field('Họ và tên',input('name',employee?.name,'text','required maxlength="80"'))+
      field('Email công việc',input('email',employee?.email,'email','required'))+
      field('Số điện thoại',input('phone',employee?.phone,'tel','required'))+
      field('Chức danh',input('position',employee?.position,'text','required'))+
      field('Bộ phận',input('department',employee?.department,'text','required'))+
      field('Vai trò hệ thống',select('roleId',state.roles.map(role=>({value:role.id,label:role.name})),employee?.roleId||'ROLE-OPS','required'))+
      field('Ngày vào làm',input('startDate',employee?.startDate,'date','required'))+
      field('Trạng thái làm việc',select('employmentStatus',['Đang làm','Tạm nghỉ','Đã nghỉ việc'],staffStatus(employee||{status:'Hoạt động'}))),
    submitText:employee?'Cập nhật nhân sự':'Thêm nhân sự',
    onSubmit:data=>{
      const email=data.get('email').trim();
      const employeeCode=data.get('employeeCode').trim().toUpperCase();
      if(state.users.some(user=>user.email.toLowerCase()===email.toLowerCase()&&user.id!==id)){toast('Email đã được sử dụng');return;}
      if(state.users.some(user=>user.employeeCode===employeeCode&&user.id!==id)){toast('Mã nhân viên đã tồn tại');return;}
      const employmentStatus=data.get('employmentStatus');
      const record={id:employee?.id||uid('USR'),employeeCode,name:data.get('name').trim(),email,phone:data.get('phone').trim(),type:'Nội bộ',department:data.get('department').trim(),position:data.get('position').trim(),startDate:data.get('startDate'),employmentStatus,roleId:data.get('roleId'),status:employmentStatus==='Đang làm'?'Hoạt động':'Bị khóa',lastLogin:employee?.lastLogin||'Chưa đăng nhập',twoFactor:employee?.twoFactor||false};
      if(employee)Object.assign(employee,record);else state.users.unshift(record);
      persist(employee?'Đã cập nhật hồ sơ nhân sự':'Đã thêm nhân sự mới');
      closeAll();renderStaff();renderUsers();renderRoles();
    }
  });
}

function viewStaff(id){
  const employee=state.users.find(user=>user.id===id&&user.type==='Nội bộ');if(!employee)return;
  openInfoModal('Hồ sơ nhân sự',(employee.employeeCode||employee.id)+' · '+employee.name,'<div class="detail-grid"><div class="field"><label>Chức danh</label><strong>'+escapeHtml(employee.position||roleName(employee.roleId))+'</strong></div><div class="field"><label>Bộ phận</label><strong>'+escapeHtml(employee.department)+'</strong></div><div class="field"><label>Email</label><strong>'+escapeHtml(employee.email)+'</strong></div><div class="field"><label>Số điện thoại</label><strong>'+escapeHtml(employee.phone)+'</strong></div><div class="field"><label>Ngày vào làm</label><strong>'+escapeHtml(formatDate(employee.startDate)||'Chưa cập nhật')+'</strong></div><div class="field"><label>Vai trò hệ thống</label><strong>'+escapeHtml(roleName(employee.roleId))+'</strong></div><div class="field"><label>Trạng thái</label><strong>'+escapeHtml(staffStatus(employee))+'</strong></div><div class="field"><label>Đăng nhập cuối</label><strong>'+escapeHtml(employee.lastLogin)+'</strong></div></div>');
}

function toggleStaffStatus(id){
  const employee=state.users.find(user=>user.id===id&&user.type==='Nội bộ');if(!employee)return;
  if(employee.roleId==='ROLE-ADMIN'&&staffStatus(employee)==='Đang làm'){toast('Không thể tạm nghỉ tài khoản quản trị viên');return;}
  employee.employmentStatus=staffStatus(employee)==='Đang làm'?'Tạm nghỉ':'Đang làm';
  employee.status=employee.employmentStatus==='Đang làm'?'Hoạt động':'Bị khóa';
  persist(employee.employmentStatus==='Đang làm'?'Đã kích hoạt nhân sự':'Đã chuyển nhân sự sang tạm nghỉ');renderStaff();renderUsers();
}

function deleteStaff(id){
  const employee=state.users.find(user=>user.id===id&&user.type==='Nội bộ');if(!employee)return;
  if(employee.roleId==='ROLE-ADMIN'){toast('Không thể xóa nhân sự quản trị viên');return;}
  confirmAction('Xóa nhân sự','Hồ sơ và tài khoản của '+employee.name+' sẽ bị xóa khỏi hệ thống.',()=>{state.users=state.users.filter(user=>user.id!==id);persist('Đã xóa nhân sự');renderStaff();renderUsers();renderRoles();},'Xóa nhân sự');
}

function exportStaff(){
  const staff=state.users.filter(user=>user.type==='Nội bộ');
  downloadCsv('nhan-su-noi-bo.csv',['Mã nhân viên,Họ tên,Chức danh,Bộ phận,Email,SĐT,Ngày vào làm,Vai trò,Trạng thái',...staff.map(user=>[user.employeeCode||user.id,user.name,user.position||'',user.department,user.email,user.phone||'',user.startDate||'',roleName(user.roleId),staffStatus(user)].map(csvCell).join(','))]);
}

/* ===== RBAC ===== */
function renderRoles(){
  const matrix=document.getElementById('permissionMatrix'); if(!matrix)return;
  matrix.innerHTML='<thead><tr><th>Chức năng</th>'+state.roles.map(role=>'<th>'+escapeHtml(role.name)+'</th>').join('')+'</tr></thead><tbody>'+resources.map(resource=>'<tr><td><strong>'+escapeHtml(resource.label)+'</strong><div class="table-note">Truy cập và thao tác dữ liệu</div></td>'+state.roles.map(role=>{const on=!!role.permissions[resource.key];return '<td><button class="permission-check '+(on?'on ':'')+(role.id==='ROLE-ADMIN'?'locked':'')+'" '+(role.id==='ROLE-ADMIN'?'disabled':'onclick="toggleRolePermission(\''+role.id+'\',\''+resource.key+'\')"')+'>'+(on?'✓':'')+'</button></td>';}).join('')+'</tr>').join('')+'</tbody>';
  document.getElementById('roleList').innerHTML=state.roles.map(role=>'<div class="role-card"><div><strong>'+escapeHtml(role.name)+'</strong><p>'+escapeHtml(role.scope)+'</p></div><div class="inline-actions"><span class="pill blue">'+state.users.filter(user=>user.roleId===role.id).length+' người</span><button class="mini-btn" onclick="openRoleForm(\''+role.id+'\')">Sửa</button><button class="mini-btn danger" onclick="deleteRole(\''+role.id+'\')" '+(role.system?'disabled':'')+'>Xóa</button></div></div>').join('');
  const pending=state.accessRequests.filter(request=>request.status==='Chờ duyệt');
  document.getElementById('accessRequestList').innerHTML=pending.length?pending.map(request=>'<div class="role-card"><div><strong>'+escapeHtml(request.user)+'</strong><p>'+escapeHtml(roleName(request.roleId))+' · '+escapeHtml(request.reason)+'</p></div><div class="inline-actions"><button class="mini-btn success" onclick="resolveAccessRequest(\''+request.id+'\',true)">Duyệt</button><button class="mini-btn danger" onclick="resolveAccessRequest(\''+request.id+'\',false)">Từ chối</button></div></div>').join(''):'<div class="empty-state"><strong>Không có yêu cầu chờ duyệt</strong>Mọi yêu cầu truy cập đã được xử lý.</div>';
  document.getElementById('roleCount').textContent=state.roles.length;
  document.getElementById('permissionCount').textContent=state.roles.reduce((sum,role)=>sum+Object.values(role.permissions).filter(Boolean).length,0);
  document.getElementById('accessRequestCount').textContent=pending.length;
  document.getElementById('pendingRequestPill').textContent=pending.length+' chờ duyệt';
}

function toggleRolePermission(roleId,key){const role=state.roles.find(item=>item.id===roleId);if(!role||role.id==='ROLE-ADMIN')return;role.permissions[key]=!role.permissions[key];renderRoles();}
function savePermissions(){persist('Đã lưu ma trận phân quyền');}
function resolveAccessRequest(id,approved){const request=state.accessRequests.find(item=>item.id===id);if(request){request.status=approved?'Đã duyệt':'Từ chối';persist(approved?'Đã phê duyệt yêu cầu':'Đã từ chối yêu cầu');renderRoles();}}

function openRoleForm(id){
  const role=state.roles.find(item=>item.id===id);
  openEntityModal({title:role?'Sửa vai trò':'Tạo vai trò',subtitle:'Định nghĩa phạm vi và nhóm quyền',fields:field('Tên vai trò',input('name',role?.name,'text','required'))+field('Mô tả phạm vi',input('scope',role?.scope,'text','required'),true)+field('Nhóm quyền',checkboxOptions('permissions',resources.map(item=>item.key),role?Object.keys(role.permissions).filter(key=>role.permissions[key]):[]),true),submitText:role?'Cập nhật vai trò':'Tạo vai trò',onSubmit:data=>{const permissions={};resources.forEach(item=>permissions[item.key]=data.getAll('permissions').includes(item.key));if(role){role.name=data.get('name').trim();role.scope=data.get('scope').trim();role.permissions=permissions;}else state.roles.push({id:uid('ROLE'),name:data.get('name').trim(),scope:data.get('scope').trim(),system:false,permissions});persist(role?'Đã cập nhật vai trò':'Đã tạo vai trò');closeAll();renderRoles();renderUsers();renderStaff();}});
}

function deleteRole(id){const role=state.roles.find(item=>item.id===id);if(!role||role.system)return;const members=state.users.filter(user=>user.roleId===id).length;if(members){toast('Cần chuyển '+members+' thành viên sang vai trò khác');return;}confirmAction('Xóa vai trò','Vai trò '+role.name+' sẽ bị xóa vĩnh viễn.',()=>{state.roles=state.roles.filter(item=>item.id!==id);persist('Đã xóa vai trò');renderRoles();},'Xóa vai trò');}

function openRoleAssignment(){
  const departments=[...new Set(state.users.map(user=>user.department))];
  const targets=[...state.users.map(user=>({value:'user:'+user.id,label:'Cá nhân · '+user.name})),...departments.map(department=>({value:'department:'+department,label:'Bộ phận · '+department}))];
  openEntityModal({title:'Gán vai trò',subtitle:'Áp dụng cho một cá nhân hoặc toàn bộ bộ phận',fields:field('Cá nhân / Bộ phận',select('target',targets,'','required'))+field('Vai trò mới',select('roleId',state.roles.map(role=>({value:role.id,label:role.name})),'','required')),submitText:'Gán vai trò',onSubmit:data=>{const [type,value]=data.get('target').split(':');const affected=type==='user'?state.users.filter(user=>user.id===value):state.users.filter(user=>user.department===value);affected.forEach(user=>user.roleId=data.get('roleId'));persist('Đã cập nhật vai trò cho '+affected.length+' tài khoản');closeAll();renderUsers();renderStaff();renderRoles();}});
}

/* ===== Tải NCC thật từ API ===== */
async function loadSuppliers(){
  const ctx = document.querySelector('meta[name="app-ctx"]')?.content || '';
  try{
    const response = await fetch(ctx + '/admin/api/supplier-accounts', {credentials:'same-origin', headers:{'Accept':'application/json'}});
    const type = response.headers.get('content-type') || '';
    const data = type.includes('json') ? await response.json() : null;
    if(!response.ok || !data) throw new Error(data?.error || 'Không tải được danh sách nhà cung cấp.');
    state.suppliers = (data.suppliers || []).map(item => ({
      id: String(item.userId),
      name: item.shopName,
      taxCode: '',
      email: item.email,
      area: item.address || '',
      region: '',
      permissions: [],
      sla: null,
      contract: '—',
      status: item.status === 'ACTIVE' ? 'Hoạt động' : 'Tạm dừng'
    }));
    state.supplierPending = Number(data.counts?.pendingRequests || 0);
    document.querySelectorAll('button').forEach(button => {
      if (button.textContent.trim() === '+ Thêm NCC') button.hidden = true;
    });
    renderSuppliers();
  }catch(error){
    toast(error.message || 'Không tải được danh sách nhà cung cấp.');
  }
}

/* ===== Supplier access ===== */
function renderSuppliers(){
  const body=document.getElementById('suppliersTableBody');if(!body)return;
  const search=normalize(document.getElementById('supplierSearch').value),region=document.getElementById('supplierRegionFilter').value,status=document.getElementById('supplierStatusFilter').value;
  const filtered=state.suppliers.filter(supplier=>(!search||normalize([supplier.name,supplier.taxCode,supplier.area].join(' ')).includes(search))&&(!region||supplier.region===region)&&(!status||supplier.status===status));
  body.innerHTML=filtered.length?filtered.map(supplier=>'<tr><td><strong>'+escapeHtml(supplier.name)+'</strong><div class="table-note">'+escapeHtml(supplier.taxCode)+' · '+escapeHtml(supplier.email)+'</div></td><td>'+escapeHtml(supplier.area)+'<div class="table-note">'+escapeHtml(supplier.region)+'</div></td><td>'+(supplier.permissions.length?supplier.permissions.map(permission=>'<span class="pill blue">'+escapeHtml(permission)+'</span>').join(' '):'<span class="table-note">Chưa cấp quyền</span>')+'</td><td class="num">'+(supplier.sla==null?'—':supplier.sla+'%')+'</td><td class="mono">'+escapeHtml(supplier.contract)+'</td><td>'+pill(supplier.status)+'</td><td><span class="table-note">Duyệt/khóa tại trang Yêu cầu NCC</span></td></tr>').join(''):emptyRow(7,'Không tìm thấy nhà cung cấp','Thử thay đổi bộ lọc.');
  document.getElementById('supplierCount').textContent=state.suppliers.length;
  document.getElementById('supplierPendingCount').textContent=state.supplierPending||0;
  document.getElementById('supplierSuspendedCount').textContent=state.suppliers.filter(item=>item.status==='Tạm dừng').length;
  document.getElementById('supplierResultCount').textContent=filtered.length+' nhà cung cấp';
}

function openSupplierAccessForm(id){
  const supplier=state.suppliers.find(item=>item.id===id);
  openEntityModal({title:supplier?'Sửa nhà cung cấp':'Thêm nhà cung cấp',subtitle:'Hồ sơ pháp lý và thông tin liên hệ',fields:field('Tên nhà cung cấp',input('name',supplier?.name,'text','required'))+field('Mã số thuế',input('taxCode',supplier?.taxCode,'text','required'))+field('Email',input('email',supplier?.email,'email','required'))+field('Số điện thoại',input('phone',supplier?.phone,'tel','required'))+field('Tỉnh / Thành phố',input('area',supplier?.area,'text','required'))+field('Khu vực',select('region',['Miền Bắc','Miền Trung','Miền Nam'],supplier?.region||'Miền Nam'))+field('Mã hợp đồng',input('contract',supplier?.contract||'Chưa có'))+field('Trạng thái',select('status',['Hoạt động','Chờ duyệt','Theo dõi','Tạm dừng'],supplier?.status||'Chờ duyệt')),submitText:supplier?'Cập nhật NCC':'Tạo hồ sơ NCC',onSubmit:data=>{const record={id:supplier?.id||uid('NCC'),name:data.get('name').trim(),taxCode:data.get('taxCode').trim(),email:data.get('email').trim(),phone:data.get('phone').trim(),area:data.get('area').trim(),region:data.get('region'),contract:data.get('contract').trim(),status:data.get('status'),permissions:supplier?.permissions||[],sla:supplier?.sla||0};if(supplier)Object.assign(supplier,record);else state.suppliers.unshift(record);persist(supplier?'Đã cập nhật NCC':'Đã thêm nhà cung cấp');closeAll();renderSuppliers();}});
}

function openSupplierPermissions(id){const supplier=state.suppliers.find(item=>item.id===id);if(!supplier)return;const permissions=['Nhận đơn','Tự báo giá','Truy cập kho','Xem hợp đồng','Xuất báo cáo'];openEntityModal({title:'Cấp quyền NCC',subtitle:supplier.name+' · Quyền chỉ áp dụng cho dữ liệu được phân công',fields:field('Quyền được cấp',checkboxOptions('permissions',permissions,supplier.permissions),true),submitText:'Lưu quyền',onSubmit:data=>{supplier.permissions=data.getAll('permissions');persist('Đã cập nhật quyền NCC');closeAll();renderSuppliers();}});}
function approveSupplier(id){const supplier=state.suppliers.find(item=>item.id===id);if(supplier){supplier.status='Hoạt động';supplier.permissions=supplier.permissions.length?supplier.permissions:['Nhận đơn'];persist('Đã phê duyệt nhà cung cấp');renderSuppliers();}}
function toggleSupplierStatus(id){const supplier=state.suppliers.find(item=>item.id===id);if(supplier){supplier.status=supplier.status==='Tạm dừng'?'Hoạt động':'Tạm dừng';persist('Đã cập nhật trạng thái NCC');renderSuppliers();}}
function deleteSupplierAccess(id){const supplier=state.suppliers.find(item=>item.id===id);if(!supplier)return;confirmAction('Xóa nhà cung cấp','Hồ sơ '+supplier.name+' và toàn bộ quyền truy cập sẽ bị xóa.',()=>{state.suppliers=state.suppliers.filter(item=>item.id!==id);persist('Đã xóa nhà cung cấp');renderSuppliers();},'Xóa NCC');}
function exportSuppliers(){downloadCsv('nha-cung-cap.csv',['Mã,Tên,MST,Khu vực,Quyền,SLA,Hợp đồng,Trạng thái',...state.suppliers.map(item=>[item.id,item.name,item.taxCode,item.area,item.permissions.join(' | '),item.sla+'%',item.contract,item.status].map(csvCell).join(','))]);}

/* ===== Inventory ===== */
function inventoryStatus(item){const available=item.stock-item.reserved;if(available<=item.min*.5)return'Cần nhập';if(available<item.min)return'Sắp thiếu';return'Đủ hàng';}

function renderInventory(){
  const body=document.getElementById('inventoryTableBody');if(!body)return;
  const search=normalize(document.getElementById('inventorySearch').value),warehouse=document.getElementById('inventoryWarehouseFilter').value,status=document.getElementById('inventoryStateFilter').value;
  const filtered=state.inventory.filter(item=>(!search||normalize(item.id+' '+item.name).includes(search))&&(!warehouse||item.warehouse===warehouse)&&(!status||inventoryStatus(item)===status));
  body.innerHTML=filtered.length?filtered.map(item=>{const available=item.stock-item.reserved;return'<tr><td class="order-id">'+escapeHtml(item.id)+'</td><td><strong>'+escapeHtml(item.name)+'</strong><div class="table-note">Đơn vị: '+escapeHtml(item.unit)+'</div></td><td class="num">'+item.stock+'</td><td class="num">'+item.reserved+'</td><td class="num">'+available+'</td><td>'+escapeHtml(item.warehouse)+'</td><td>'+pill(inventoryStatus(item))+'<div class="table-note">Ngưỡng '+item.min+'</div></td><td><div class="action-menu"><button class="mini-btn" onclick="openInventoryItemForm(\''+item.id+'\')">Sửa</button><button class="mini-btn" onclick="openStockMovement(\'in\',\''+item.id+'\')">Nhập</button><button class="mini-btn warning" onclick="openStockMovement(\'out\',\''+item.id+'\')">Xuất</button><button class="mini-btn danger" onclick="deleteInventoryItem(\''+item.id+'\')">Xóa</button></div></td></tr>';}).join(''):emptyRow(8,'Không tìm thấy vật tư','Thử thay đổi từ khóa hoặc bộ lọc.');
  document.getElementById('inventorySkuCount').textContent=state.inventory.length;
  document.getElementById('inventoryLowCount').textContent=state.inventory.filter(item=>inventoryStatus(item)!=='Đủ hàng').length;
  document.getElementById('inventoryAvailableCount').textContent=state.inventory.reduce((sum,item)=>sum+item.stock-item.reserved,0).toLocaleString('vi-VN');
  document.getElementById('movementList').innerHTML=state.movements.slice(0,8).map(move=>{const item=state.inventory.find(entry=>entry.id===move.itemId);const color=move.type==='Nhập kho'?'green':move.type==='Xuất kho'?'amber':'';return'<div class="activity-item"><span class="activity-mark '+color+'"></span><div><strong>'+escapeHtml(move.type)+' · '+escapeHtml(item?.name||move.itemId)+'</strong><span>'+escapeHtml(move.note)+' · '+move.quantity+' · '+escapeHtml(move.time)+'</span></div></div>';}).join('')||'<div class="empty-state"><strong>Chưa có giao dịch</strong>Phiếu kho mới sẽ xuất hiện tại đây.</div>';
}

function openInventoryItemForm(id){
  const item=state.inventory.find(entry=>entry.id===id);
  openEntityModal({title:item?'Sửa vật tư':'Thêm vật tư',subtitle:'Cấu hình mã hàng, kho lưu và ngưỡng cảnh báo',fields:field('Mã vật tư',input('id',item?.id,'text','required '+(item?'readonly':'')))+field('Tên vật tư',input('name',item?.name,'text','required'))+field('Tồn hiện tại',input('stock',item?.stock||0,'number','required min="0"'))+field('Đã giữ',input('reserved',item?.reserved||0,'number','required min="0"'))+field('Ngưỡng tối thiểu',input('min',item?.min||0,'number','required min="0"'))+field('Kho lưu',select('warehouse',['Kho A','Kho B','Kho C'],item?.warehouse||'Kho A'))+field('Đơn vị tính',input('unit',item?.unit,'text','required')),submitText:item?'Cập nhật vật tư':'Thêm vật tư',onSubmit:data=>{const code=data.get('id').trim().toUpperCase();if(!item&&state.inventory.some(entry=>entry.id===code)){toast('Mã vật tư đã tồn tại');return;}const record={id:code,name:data.get('name').trim(),stock:Number(data.get('stock')),reserved:Number(data.get('reserved')),min:Number(data.get('min')),warehouse:data.get('warehouse'),unit:data.get('unit').trim()};if(record.reserved>record.stock){toast('Số lượng đã giữ không thể lớn hơn tồn kho');return;}if(item)Object.assign(item,record);else state.inventory.unshift(record);persist(item?'Đã cập nhật vật tư':'Đã thêm vật tư');closeAll();renderInventory();}});
}

function openStockMovement(type,itemId=''){
  const labels={in:'Nhập kho',out:'Xuất kho',audit:'Kiểm kê'};
  openEntityModal({title:labels[type],subtitle:type==='audit'?'Điều chỉnh tồn kho theo số lượng thực tế':'Tạo phiếu '+labels[type].toLowerCase(),fields:field('Vật tư',select('itemId',state.inventory.map(item=>({value:item.id,label:item.id+' · '+item.name})),itemId,'required'))+field(type==='audit'?'Tồn thực tế':'Số lượng',input('quantity','','number','required min="0"'))+field('Ghi chú / Chứng từ',input('note','','text','required'),true),submitText:'Xác nhận '+labels[type].toLowerCase(),onSubmit:data=>{const item=state.inventory.find(entry=>entry.id===data.get('itemId'));const quantity=Number(data.get('quantity'));if(!item)return;if(type==='out'&&quantity>item.stock-item.reserved){toast('Số lượng xuất vượt tồn khả dụng');return;}if(type==='in')item.stock+=quantity;else if(type==='out')item.stock-=quantity;else{if(quantity<item.reserved){toast('Tồn thực tế không thể thấp hơn lượng đang giữ');return;}item.stock=quantity;}state.movements.unshift({id:uid('MOV'),itemId:item.id,type:labels[type],quantity,note:data.get('note').trim(),time:nowLabel()});persist('Đã ghi nhận phiếu '+labels[type].toLowerCase());closeAll();renderInventory();}});
}

function deleteInventoryItem(id){const item=state.inventory.find(entry=>entry.id===id);if(!item)return;if(item.reserved>0){toast('Không thể xóa vật tư đang giữ cho đơn hàng');return;}confirmAction('Xóa vật tư','Vật tư '+item.name+' sẽ bị xóa khỏi danh mục. Lịch sử giao dịch vẫn được giữ.',()=>{state.inventory=state.inventory.filter(entry=>entry.id!==id);persist('Đã xóa vật tư');renderInventory();},'Xóa vật tư');}

/* ===== Contracts ===== */
function formatDate(value){if(!value)return'';const [year,month,day]=value.split('-');return day+'/'+month+'/'+year;}

function renderContracts(){
  const body=document.getElementById('contractsTableBody');if(!body)return;
  const search=normalize(document.getElementById('contractSearch').value),status=document.getElementById('contractStatusFilter').value;
  const filtered=state.contracts.filter(contract=>(!search||normalize(contract.id+' '+contract.partner).includes(search))&&(!status||contract.status===status));
  body.innerHTML=filtered.length?filtered.map(contract=>'<tr><td class="order-id">'+escapeHtml(contract.id)+'</td><td><strong>'+escapeHtml(contract.partner)+'</strong><div class="table-note">Phụ trách: '+escapeHtml(contract.owner)+'</div></td><td>'+escapeHtml(contract.type)+'</td><td class="num">'+escapeHtml(contract.value)+'</td><td class="mono">'+formatDate(contract.start)+' - '+formatDate(contract.end)+'</td><td>'+pill(contract.status)+'</td><td><div class="action-menu"><button class="mini-btn" onclick="viewContract(\''+contract.id+'\')">Chi tiết</button><button class="mini-btn" onclick="openContractForm(\''+contract.id+'\')">Sửa</button>'+(contract.status==='Sắp hết hạn'?'<button class="mini-btn success" onclick="renewContract(\''+contract.id+'\')">Gia hạn</button>':'')+(contract.status==='Chờ ký'?'<button class="mini-btn warning" onclick="remindContract(\''+contract.id+'\')">Nhắc ký</button>':'')+'<button class="mini-btn danger" onclick="deleteContract(\''+contract.id+'\')">Xóa</button></div></td></tr>').join(''):emptyRow(7,'Không tìm thấy hợp đồng','Thử thay đổi từ khóa hoặc trạng thái.');
  document.getElementById('contractActiveCount').textContent=state.contracts.filter(item=>item.status==='Hiệu lực').length;
  document.getElementById('contractExpiringCount').textContent=state.contracts.filter(item=>item.status==='Sắp hết hạn').length;
  document.getElementById('contractSigningCount').textContent=state.contracts.filter(item=>item.status==='Chờ ký').length;
  document.getElementById('contractTimeline').innerHTML=[...state.contracts].sort((a,b)=>b.updated.localeCompare(a.updated)).slice(0,6).map(contract=>'<div class="timeline-item '+(contract.status==='Hiệu lực'?'done':contract.status==='Sắp hết hạn'?'warn':'')+'"><strong>'+escapeHtml(contract.id)+' · '+escapeHtml(contract.status)+'</strong><span>'+escapeHtml(contract.partner)+' · '+escapeHtml(contract.owner)+' · '+escapeHtml(contract.updated)+'</span></div>').join('');
}

function openContractForm(id){
  const contract=state.contracts.find(item=>item.id===id);
  openEntityModal({title:contract?'Cập nhật hợp đồng':'Tạo hợp đồng',subtitle:'Thông tin pháp lý và vòng đời hợp đồng',fields:field('Mã hợp đồng',input('id',contract?.id||('HD-'+new Date().getFullYear()+'-'),'text','required '+(contract?'readonly':'')))+field('Đối tác',input('partner',contract?.partner,'text','required'))+field('Loại hợp đồng',select('type',['NCC sản xuất','Khách B2B','Dịch vụ nền tảng','Mua vật tư'],contract?.type||'NCC sản xuất'))+field('Giá trị',input('value',contract?.value,'text','required'))+field('Ngày bắt đầu',input('start',contract?.start,'date','required'))+field('Ngày kết thúc',input('end',contract?.end,'date','required'))+field('Người phụ trách',input('owner',contract?.owner||'Trần Hòa','text','required'))+field('Trạng thái',select('status',['Chờ ký','Hiệu lực','Sắp hết hạn','Hết hiệu lực'],contract?.status||'Chờ ký')),submitText:contract?'Cập nhật hợp đồng':'Tạo hợp đồng',onSubmit:data=>{if(data.get('end')<data.get('start')){toast('Ngày kết thúc phải sau ngày bắt đầu');return;}const code=data.get('id').trim().toUpperCase();if(!contract&&state.contracts.some(item=>item.id===code)){toast('Mã hợp đồng đã tồn tại');return;}const record={id:code,partner:data.get('partner').trim(),type:data.get('type'),value:data.get('value').trim(),start:data.get('start'),end:data.get('end'),owner:data.get('owner').trim(),status:data.get('status'),updated:nowLabel()};if(contract)Object.assign(contract,record);else state.contracts.unshift(record);persist(contract?'Đã cập nhật hợp đồng':'Đã tạo hợp đồng');closeAll();renderContracts();}});
}

function viewContract(id){const contract=state.contracts.find(item=>item.id===id);if(!contract)return;openInfoModal('Chi tiết hợp đồng',contract.id+' · '+contract.partner,'<div class="detail-grid"><div class="field"><label>Loại hợp đồng</label><strong>'+escapeHtml(contract.type)+'</strong></div><div class="field"><label>Giá trị</label><strong>'+escapeHtml(contract.value)+'</strong></div><div class="field"><label>Hiệu lực</label><strong>'+formatDate(contract.start)+' - '+formatDate(contract.end)+'</strong></div><div class="field"><label>Trạng thái</label><strong>'+escapeHtml(contract.status)+'</strong></div><div class="field"><label>Người phụ trách</label><strong>'+escapeHtml(contract.owner)+'</strong></div><div class="field"><label>Cập nhật gần nhất</label><strong>'+escapeHtml(contract.updated)+'</strong></div></div>');}
function renewContract(id){const contract=state.contracts.find(item=>item.id===id);if(!contract)return;openEntityModal({title:'Gia hạn hợp đồng',subtitle:contract.id+' · '+contract.partner,fields:field('Ngày kết thúc mới',input('end',contract.end,'date','required'))+field('Ghi chú gia hạn',input('note','','text','required'),true),submitText:'Xác nhận gia hạn',onSubmit:data=>{if(data.get('end')<=contract.end){toast('Ngày gia hạn phải sau ngày kết thúc hiện tại');return;}contract.end=data.get('end');contract.status='Hiệu lực';contract.updated=nowLabel();persist('Đã gia hạn hợp đồng');closeAll();renderContracts();}});}
function remindContract(id){const contract=state.contracts.find(item=>item.id===id);if(contract){contract.updated=nowLabel();state.notifications.unshift({id:uid('NTF'),title:'Nhắc ký '+contract.id,message:'Vui lòng hoàn tất ký số hợp đồng với '+contract.partner+'.',audience:contract.partner,channel:'Email',level:'Cảnh báo',status:'Đã gửi',time:nowLabel()});persist('Đã gửi nhắc ký hợp đồng');renderContracts();renderNotifications();}}
function deleteContract(id){const contract=state.contracts.find(item=>item.id===id);if(!contract)return;confirmAction('Xóa hợp đồng','Hợp đồng '+contract.id+' sẽ bị xóa khỏi kho lưu trữ.',()=>{state.contracts=state.contracts.filter(item=>item.id!==id);persist('Đã xóa hợp đồng');renderContracts();},'Xóa hợp đồng');}
function exportContracts(){downloadCsv('hop-dong.csv',['Mã,Đối tác,Loại,Giá trị,Bắt đầu,Kết thúc,Trạng thái,Phụ trách',...state.contracts.map(item=>[item.id,item.partner,item.type,item.value,item.start,item.end,item.status,item.owner].map(csvCell).join(','))]);}

/* ===== Platform ===== */
function renderPlatform(){
  const list=document.getElementById('serviceList');if(!list)return;
  list.innerHTML=state.services.map(service=>'<div><div class="status-row"><div><div class="label">'+escapeHtml(service.name)+'</div><div class="meta">'+escapeHtml(service.detail)+' · P95 '+service.latency+'ms</div></div><div class="inline-actions">'+pill(service.status)+'<button class="mini-btn" onclick="restartService(\''+service.id+'\')">Khởi động lại</button></div></div><div class="meter"><span class="'+(service.status==='Ổn định'?'green':service.status==='Chậm'?'amber':'')+'" style="width:'+service.metric+'%"></span></div></div>').join('');
  document.getElementById('incidentList').innerHTML=state.incidents.slice(0,6).map(incident=>'<div class="role-card"><div><strong>'+escapeHtml(incident.title)+'</strong><p>'+escapeHtml(incident.detail)+' · '+escapeHtml(incident.time)+'</p></div><div class="inline-actions">'+pill(incident.status)+(incident.status!=='Đã xử lý'?'<button class="mini-btn success" onclick="resolveIncident(\''+incident.id+'\')">Đã xử lý</button>':'')+'</div></div>').join('')||'<div class="empty-state"><strong>Không có sự cố</strong>Hệ thống đang vận hành bình thường.</div>';
  document.getElementById('healthyServiceCount').textContent=state.services.filter(service=>service.status==='Ổn định').length+'/'+state.services.length;
  document.getElementById('runningJobCount').textContent=state.services.filter(service=>service.status==='Đang chạy').length;
  document.getElementById('openIncidentCount').textContent=state.incidents.filter(incident=>incident.status!=='Đã xử lý').length;
  document.getElementById('configScheduledMaintenance').checked=state.config.scheduledMaintenance;
  document.getElementById('configAutoBackup').checked=state.config.autoBackup;
  document.getElementById('configAutoScale').checked=state.config.autoScale;
  document.getElementById('configMaintenanceMode').checked=state.config.maintenanceMode;
  document.getElementById('configUploadLimit').value=state.config.uploadLimit;
  document.getElementById('configBackupInterval').value=state.config.backupInterval;
}

function refreshServices(){state.services.forEach(service=>{service.latency=Math.max(80,service.latency+Math.round((Math.random()-.5)*80));if(service.status==='Chậm'&&service.latency<500)service.status='Ổn định';});document.getElementById('platformLastCheck').textContent='Kiểm tra lúc '+nowLabel();persist('Đã làm mới trạng thái dịch vụ');renderPlatform();}
function restartService(id){const service=state.services.find(item=>item.id===id);if(!service)return;confirmAction('Khởi động lại dịch vụ','Dịch vụ '+service.name+' có thể gián đoạn trong vài giây.',()=>{service.status='Đang chạy';service.metric=30;persist('Đang khởi động lại '+service.name);renderPlatform();setTimeout(()=>{service.status='Ổn định';service.metric=96;service.latency=160;persist();renderPlatform();toast(service.name+' đã hoạt động ổn định');},1200);},'Khởi động lại');}
function resolveIncident(id){const incident=state.incidents.find(item=>item.id===id);if(incident){incident.status='Đã xử lý';persist('Đã đóng sự cố');renderPlatform();}}
function runBackup(){const task={id:uid('INC'),title:'Backup thủ công',detail:'Đang tạo bản sao lưu dữ liệu',severity:'Thông tin',status:'Đang xử lý',time:nowLabel()};state.incidents.unshift(task);persist('Đã bắt đầu sao lưu');renderPlatform();setTimeout(()=>{task.status='Đã xử lý';task.detail='Sao lưu hoàn tất và đã kiểm tra toàn vẹn';persist();renderPlatform();toast('Backup đã hoàn tất');},1500);}
function savePlatformConfig(event){event.preventDefault();state.config={scheduledMaintenance:document.getElementById('configScheduledMaintenance').checked,autoBackup:document.getElementById('configAutoBackup').checked,autoScale:document.getElementById('configAutoScale').checked,maintenanceMode:document.getElementById('configMaintenanceMode').checked,uploadLimit:Number(document.getElementById('configUploadLimit').value),backupInterval:Number(document.getElementById('configBackupInterval').value)};persist('Đã lưu cấu hình nền tảng');renderPlatform();}
function resetPlatformConfig(){confirmAction('Khôi phục cấu hình','Các thiết lập vận hành sẽ trở về giá trị mặc định.',()=>{state.config=cloneSeed().config;persist('Đã khôi phục cấu hình');renderPlatform();},'Khôi phục');}

/* ===== Notifications ===== */
function toggleScheduleField(){const scheduled=document.getElementById('notificationTiming').value==='schedule';document.getElementById('notificationScheduleField').hidden=!scheduled;document.getElementById('notificationScheduleAt').required=scheduled;}

function notificationPayload(status){
  const timing=document.getElementById('notificationTiming').value;
  const schedule=document.getElementById('notificationScheduleAt').value;
  return {id:editingNotificationId||uid('NTF'),title:document.getElementById('notificationTitle').value.trim(),message:document.getElementById('notificationMessage').value.trim(),audience:document.getElementById('notificationAudience').value,channel:document.getElementById('notificationChannel').value,level:document.getElementById('notificationLevel').value,status,time:timing==='schedule'&&schedule?new Intl.DateTimeFormat('vi-VN',{dateStyle:'short',timeStyle:'short'}).format(new Date(schedule)):nowLabel()};
}

function upsertNotification(record){const index=state.notifications.findIndex(item=>item.id===record.id);if(index>=0)state.notifications[index]=record;else state.notifications.unshift(record);editingNotificationId=null;persist();renderNotifications();resetNotificationForm();}

function submitNotification(event){
  event.preventDefault();
  const timing=document.getElementById('notificationTiming').value;
  if(timing==='schedule'&&!document.getElementById('notificationScheduleAt').value){toast('Vui lòng chọn thời điểm gửi');return;}
  if(timing==='schedule'&&new Date(document.getElementById('notificationScheduleAt').value)<=new Date()){toast('Thời điểm gửi phải ở trong tương lai');return;}
  const status=timing==='schedule'?'Đã lên lịch':'Đã gửi';
  upsertNotification(notificationPayload(status));
  toast(status==='Đã gửi'?'Đã gửi thông báo':'Đã lên lịch thông báo');
}

function saveNotificationDraft(){
  const title=document.getElementById('notificationTitle').value.trim(),message=document.getElementById('notificationMessage').value.trim();
  if(!title||!message){toast('Cần nhập tiêu đề và nội dung trước khi lưu');return;}
  upsertNotification(notificationPayload('Bản nháp'));toast('Đã lưu bản nháp');
}

function renderNotifications(){
  const list=document.getElementById('notificationList');if(!list)return;
  const search=normalize(document.getElementById('notificationSearch').value),status=document.getElementById('notificationStatusFilter').value;
  const filtered=state.notifications.filter(item=>(!search||normalize(item.title).includes(search))&&(!status||item.status===status));
  list.innerHTML=filtered.length?filtered.map(item=>'<div class="notification-card '+(item.status==='Bản nháp'?'is-draft':item.status==='Đã lên lịch'?'is-scheduled':'')+'"><div class="bubble">'+(item.level==='Khẩn cấp'?'!':item.level==='Cảnh báo'?'⚠':'i')+'</div><div><strong>'+escapeHtml(item.title)+'</strong><p class="notification-message">'+escapeHtml(item.message)+'</p><p>'+escapeHtml(item.audience)+' · '+escapeHtml(item.channel)+' · '+escapeHtml(item.time)+'</p></div><div class="notification-actions">'+pill(item.status)+(item.status==='Bản nháp'?'<button class="mini-btn" onclick="editNotification(\''+item.id+'\')">Sửa</button>':'<button class="mini-btn" onclick="resendNotification(\''+item.id+'\')">Gửi lại</button>')+'<button class="mini-btn danger" onclick="deleteNotification(\''+item.id+'\')">Xóa</button></div></div>').join(''):'<div class="empty-state"><strong>Không có thông báo</strong>Không tìm thấy bản ghi phù hợp.</div>';
  document.getElementById('sentNotificationCount').textContent=state.notifications.filter(item=>item.status==='Đã gửi').length;
  document.getElementById('scheduledNotificationCount').textContent=state.notifications.filter(item=>item.status==='Đã lên lịch').length;
  document.getElementById('draftNotificationCount').textContent=state.notifications.filter(item=>item.status==='Bản nháp').length;
}

function editNotification(id){const item=state.notifications.find(entry=>entry.id===id);if(!item)return;editingNotificationId=id;document.getElementById('notificationAudience').value=item.audience;document.getElementById('notificationChannel').value=item.channel;document.getElementById('notificationTitle').value=item.title;document.getElementById('notificationLevel').value=item.level;document.getElementById('notificationMessage').value=item.message;document.getElementById('notificationCharCount').textContent=item.message.length;document.getElementById('notificationTiming').value='now';toggleScheduleField();document.getElementById('notificationTitle').focus();toast('Đã tải bản nháp để chỉnh sửa');}
function resendNotification(id){const item=state.notifications.find(entry=>entry.id===id);if(item){state.notifications.unshift({...item,id:uid('NTF'),status:'Đã gửi',time:nowLabel()});persist('Đã gửi lại thông báo');renderNotifications();}}
function deleteNotification(id){const item=state.notifications.find(entry=>entry.id===id);if(!item)return;confirmAction('Xóa thông báo','Thông báo “'+item.title+'” sẽ bị xóa khỏi lịch sử.',()=>{state.notifications=state.notifications.filter(entry=>entry.id!==id);persist('Đã xóa thông báo');renderNotifications();},'Xóa thông báo');}
function resetNotificationForm(){document.getElementById('notificationForm').reset();document.getElementById('notificationCharCount').textContent='0';editingNotificationId=null;toggleScheduleField();}

/* ===== Existing detail modals ===== */
function openDisputeModal(id,desc,status){
  document.getElementById('dmId').textContent=id;
  document.getElementById('dmDesc').textContent=desc;
  const statusElement=document.getElementById('dmStatus');
  statusElement.textContent=status;
  statusElement.style.color=status==='Khẩn cấp'?'var(--red)':status==='Đang xử lý'?'var(--amber)':'var(--cobalt)';
  showModal('disputeModal');
}

function openSupplierModal(name,region,orders,performance,rating){
  document.getElementById('smName').textContent=name;
  document.getElementById('smRegion').textContent=region+' · Đối tác từ 2024';
  document.getElementById('smOrders').textContent=orders;
  document.getElementById('smPerf').textContent=performance;
  document.getElementById('smRating').textContent=rating+' ★';
  showModal('supplierModal');
}

/* ===== Export helpers and startup ===== */
function csvCell(value){return '"' + String(value ?? '').replace(/"/g,'""') + '"';}
function downloadCsv(filename,rows){const blob=new Blob(['\uFEFF'+rows.join('\n')],{type:'text/csv;charset=utf-8'});const link=document.createElement('a');link.href=URL.createObjectURL(blob);link.download=filename;document.body.appendChild(link);link.click();link.remove();URL.revokeObjectURL(link.href);toast('Đã xuất '+filename);}

document.addEventListener('keydown',event=>{if(event.key==='Escape')closeAll();});
document.addEventListener('DOMContentLoaded',()=>{
  refreshAll();
  loadSuppliers();
  document.getElementById('notificationMessage')?.addEventListener('input',event=>{document.getElementById('notificationCharCount').textContent=event.target.value.length;});
});
