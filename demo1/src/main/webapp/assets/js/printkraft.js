/* =====================================================================
   PrintKraft - JS DÙNG CHUNG: header, footer, đăng nhập/đăng xuất,
   toast, số lượng giỏ hàng. Cùng cách làm với các trang trong KhachHang/.
   Phải nạp SAU <jsp:include .../session-info.jsp> để đọc được #pk-session.
   Link tương đối (trang_chu.jsp, san-pham...) đúng vì trang nằm dưới /KhachHang/.
   Dùng hàm toàn cục vì HTML do JS sinh ra gọi trực tiếp (onclick="logout()"...).
   ===================================================================== */

/* Lưu trữ cục bộ (cùng khóa pk_ với các trang khác) */
var store={
    get:function(k,d){try{var v=localStorage.getItem('pk_'+k);return v===null?d:JSON.parse(v)}catch(e){return d}},
    set:function(k,v){try{localStorage.setItem('pk_'+k,JSON.stringify(v))}catch(e){}}
};

/* Toast */
var toastTimer;
function toast(msg,type){
    var t=document.getElementById('toast');if(!t)return;
    t.textContent=msg;
    t.className='toast show'+(type?' '+type:'');
    clearTimeout(toastTimer);
    toastTimer=setTimeout(function(){t.classList.remove('show')},2400);
}
function toastOk(m){toast(m,'ok')}
function toastErr(m){toast(m,'err')}

/* Phiên đăng nhập: đọc từ <div id="pk-session"> do session-info.jsp in ra */
var PK=(function(){
    var el=document.getElementById('pk-session'),d=el?el.dataset:{};
    return {ctx:d.ctx||'',csrf:d.csrf||'',loggedIn:d.loggedIn==='true',name:d.name||'',role:d.role||''};
})();
function isLoggedIn(){return PK.loggedIn}
function escHtml(s){return String(s).replace(/[&<>"']/g,function(c){return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]})}
function nameParts(n){return String(n).trim().split(/\s+/).filter(Boolean).slice(-2)}
function initialsOf(n){return nameParts(n).map(function(w){return w.charAt(0)}).join('').toUpperCase()||'U'}
function shortName(n){return nameParts(n).join(' ')||'Tài khoản'}

function renderAuthArea(){
    var area=document.getElementById('authArea');if(!area)return;
    if(isLoggedIn()){
        area.innerHTML='<div style="display:flex;align-items:center;gap:8px;">'+
            '<button class="user-chip" onclick="location.href=\'don_hang_cua_toi_3d.jsp\'"><span class="avatar">'+escHtml(initialsOf(PK.name))+'</span> '+escHtml(shortName(PK.name))+'</button>'+
            '<button onclick="logout()" style="font-size:12.5px;font-weight:600;color:var(--ink-soft);">Thoát</button></div>';
    } else {
        area.innerHTML='<a href="'+PK.ctx+'/login" style="font-weight:600;">Tài khoản</a>';
    }
}
/* Đăng xuất: POST + CSRF token tới LogoutServlet */
function logout(){
    var f=document.createElement('form');f.method='post';f.action=PK.ctx+'/logout';
    var t=document.createElement('input');t.type='hidden';t.name='csrfToken';t.value=PK.csrf;
    f.appendChild(t);document.body.appendChild(f);f.submit();
}

/* Menu */
var NAV_ITEMS=[
    {id:'home',label:'Trang chủ',href:'trang_chu.jsp'},
    {id:'san-pham',label:'Sản phẩm',href:'san-pham'},
    {id:'studio',label:'Tự thiết kế',href:'dat_in_3d.jsp'},
    {id:'doanh-nghiep',label:'Doanh nghiệp',href:'trang_chu.jsp'},
    {id:'nhacungcap',label:'Nhà cung cấp',href:'tim-kiem-nha-cung-cap.jsp'},
    {id:'donhang',label:'Đơn hàng',href:'don_hang_cua_toi_3d.jsp'},
    {id:'danhgia',label:'Đánh giá',href:'danh-gia.jsp'},
    {id:'faq',label:'Hỗ trợ',href:'lien-he.jsp'}
];

function renderHeader(active){
    var el=document.getElementById('site-header');if(!el)return;
    el.innerHTML='<div class="utility"><span>🚚 Miễn phí thiết kế mockup cho đơn từ 20 sản phẩm — <b>Voucher 100K</b> cho đơn đầu tiên</span><span>Hỗ trợ: <b>1900 6868</b> · <a href="don_hang_cua_toi_3d.jsp">Theo dõi đơn hàng</a>'+(isLoggedIn()?'':' · <a href="'+PK.ctx+'/login">Đăng nhập</a>')+'</span></div>'+
        '<header><a href="trang_chu.jsp" class="logo"><span class="mark"></span> PrintKraft</a><nav id="mainNav">'+
        NAV_ITEMS.map(function(i){return '<a href="'+i.href+'" class="'+(i.id===active?'active':'')+'">'+i.label+'</a>'}).join('')+
        '</nav><div class="search-wrap"><input type="text" id="globalSearch" placeholder="Tìm áo thun, cốc sứ, poster..."><button onclick="doGlobalSearch()">Tìm</button></div>'+
        '<div class="head-actions"><div id="authArea"></div><button class="cart-btn" onclick="location.href=\'Thanh_toan_gio_hang.jsp\'">🛒 Giỏ hàng <span class="badge" id="cartBadge">0</span></button></div></header>';
    var gs=document.getElementById('globalSearch');
    if(gs)gs.addEventListener('keydown',function(e){if(e.key==='Enter')doGlobalSearch()});
}
/* Ô tìm trên header: tìm sản phẩm */
function doGlobalSearch(){
    var i=document.getElementById('globalSearch');
    var q=i?i.value.trim():'';
    if(!q){toastErr('Nhập từ khoá để tìm kiếm');return}
    location.href='san-pham?q='+encodeURIComponent(q);
}

function renderFooter(){
    var el=document.getElementById('site-footer');if(!el)return;
    el.innerHTML='<footer><div class="foot-inner">'+
        '<div><div class="logo" style="margin-bottom:16px;"><span class="mark"></span> PrintKraft</div><p style="font-size:13.5px;color:var(--ink-soft);max-width:34ch;">Nền tảng in theo yêu cầu kết nối khách hàng với hơn 120 xưởng in đối tác trên toàn quốc.</p><div style="display:flex;gap:10px;margin-top:18px;"><span class="chip" style="font-size:12px;padding:7px 14px;">Facebook</span><span class="chip" style="font-size:12px;padding:7px 14px;">Instagram</span><span class="chip" style="font-size:12px;padding:7px 14px;">Zalo</span></div></div>'+
        '<div><h5>Sản phẩm</h5><ul><li onclick="location.href=\'san-pham\'">Tất cả sản phẩm</li><li onclick="location.href=\'dat_in_3d.jsp\'">Tự thiết kế</li><li onclick="location.href=\'tim-kiem-nha-cung-cap.jsp\'">Tìm xưởng in</li><li onclick="location.href=\'trang_chu.jsp\'">Quà tặng doanh nghiệp</li></ul></div>'+
        '<div><h5>Hỗ trợ</h5><ul><li onclick="location.href=\'lien-he.jsp\'">Trung tâm trợ giúp</li><li onclick="location.href=\'don_hang_cua_toi_3d.jsp\'">Theo dõi đơn hàng</li><li onclick="location.href=\'lien-he.jsp\'">Chính sách đổi trả</li><li onclick="location.href=\'lien-he.jsp\'">Chính sách bảo mật</li><li onclick="location.href=\'lien-he.jsp\'">Điều khoản sử dụng</li></ul></div>'+
        '<div><h5>Liên hệ</h5><ul><li>Hotline: 1900 6868</li><li>Email: hi@printkraft.vn</li><li>Văn phòng: 128 Nguyễn Đình Chiểu, Q.3, TP.HCM</li><li>Giờ làm việc: 8:00 – 21:00</li></ul></div>'+
        '</div><div class="foot-bottom"><span>© 2026 PrintKraft. Nền tảng in theo yêu cầu.</span><span>Điều khoản · Bảo mật · Hỗ trợ khách hàng</span></div></footer>';
}

/* Số lượng giỏ hàng (cùng khóa với các trang khác) */
function getCartCount(){return store.get('cartCount',3)}
function setCartCount(n){
    store.set('cartCount',n);
    var b=document.getElementById('cartBadge');if(b)b.textContent=n;
}
/* Thêm n sản phẩm vào giỏ (demo: chỉ tăng số trên biểu tượng giỏ) */
function addToCart(n){
    var c=getCartCount()+(n>0?n:1);
    setCartCount(c);
    return c;
}

document.addEventListener('DOMContentLoaded',function(){
    renderHeader(document.body.dataset.page||'home');
    renderFooter();
    renderAuthArea();
    setCartCount(getCartCount());
});