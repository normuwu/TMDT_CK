/* ============================================================
   PRINTKRAFT — SCRIPT DÙNG CHUNG (assets/js/site.js)
   Nạp ở CUỐI <body>, sau khi trang đã include header.jsp và footer.jsp.
   Cần các phần tử do hai fragment đó in ra: #pk-session, #cartDrawer,
   #authArea, #cartBadge, #globalSearch, #overlay, #toast.
   Script riêng của từng trang chỉ chứa phần việc của trang đó.
   ============================================================ */

/* ---------- Lưu trữ cục bộ (khóa có tiền tố pk_) ---------- */
var store={
    get:function(k,d){try{var v=localStorage.getItem('pk_'+k);return v===null?d:JSON.parse(v)}catch(e){return d}},
    set:function(k,v){try{localStorage.setItem('pk_'+k,JSON.stringify(v))}catch(e){}}
};

/* ---------- Toast ---------- */
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

/* ---------- Phiên đăng nhập ----------
   Dữ liệu lấy từ <div id="pk-session"> do session-info.jsp in ra
   (header.jsp đã include sẵn). */
var PK=(function(){
    var el=document.getElementById('pk-session'),d=el?el.dataset:{};
    return {
        ctx:d.ctx||'',
        csrf:d.csrf||'',
        loggedIn:d.loggedIn==='true',
        name:d.name||'',
        role:d.role||'',
        cartCount:parseInt(d.cartCount,10)||0
    };
})();
function isLoggedIn(){return PK.loggedIn}
function escHtml(s){return String(s).replace(/[&<>"']/g,function(c){return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]})}
function nameParts(n){return String(n).trim().split(/\s+/).filter(Boolean).slice(-2)}
function initialsOf(n){return nameParts(n).map(function(w){return w.charAt(0)}).join('').toUpperCase()||'U'}
function shortName(n){return nameParts(n).join(' ')||'Tài khoản'}

/* Khu vực tài khoản trên header: đã đăng nhập thì hiện tên + nút Thoát */
function renderAuthArea(){
    var area=document.getElementById('authArea');if(!area)return;
    if(isLoggedIn()){
        area.innerHTML='<div style="display:flex;align-items:center;gap:8px;">'+
            '<button type="button" class="user-chip" onclick="location.href=\''+PK.ctx+'/KhachHang/lich-su-mua-hang\'">'+
            '<span class="avatar">'+escHtml(initialsOf(PK.name))+'</span> '+escHtml(shortName(PK.name))+'</button>'+
            '<button type="button" onclick="logout()" style="font-size:12.5px;font-weight:600;color:var(--ink-soft);">Thoát</button></div>';
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
/* Giữ tên hàm cũ: các nút "Đăng nhập" còn sót chuyển sang trang đăng nhập thật */
function openLogin(){location.href=PK.ctx+'/login'}

/* ---------- Tìm kiếm trên header: tìm sản phẩm ---------- */
function doGlobalSearch(){
    var i=document.getElementById('globalSearch');
    var q=i?i.value.trim():'';
    if(!q){toastErr('Nhập từ khoá để tìm kiếm');return}
    location.href=PK.ctx+'/KhachHang/san-pham?q='+encodeURIComponent(q);
}

/* ---------- Ngăn kéo giỏ hàng / modal / lớp phủ ---------- */
function openCart(){
    var d=document.getElementById('cartDrawer'),ov=document.getElementById('overlay');
    if(!d||!ov)return;
    closeAll();
    d.classList.add('show');
    ov.classList.add('show');
    document.body.style.overflow='hidden';
}
function openModalById(id){
    var el=document.getElementById(id),ov=document.getElementById('overlay');
    if(!el||!ov)return;
    closeAll();
    el.classList.add('show');
    ov.classList.add('show');
    document.body.style.overflow='hidden';
}
function closeAll(){
    document.querySelectorAll('.drawer, .modal').forEach(function(el){el.classList.remove('show')});
    var ov=document.getElementById('overlay');
    if(ov)ov.classList.remove('show');
    document.body.style.overflow='';
}
document.addEventListener('keydown',function(e){if(e.key==='Escape')closeAll()});

/* ---------- Số lượng giỏ hàng ----------
   Badge được in sẵn từ session (header.jsp); hàm này dùng khi cần cập nhật bằng JS. */
function setCartCount(n){
    var b=document.getElementById('cartBadge');if(b)b.textContent=n;
}

/* ---------- Khởi tạo ---------- */
document.addEventListener('DOMContentLoaded',function(){
    renderAuthArea();
    setCartCount(PK.cartCount);
    var gs=document.getElementById('globalSearch');
    if(gs)gs.addEventListener('keydown',function(e){if(e.key==='Enter')doGlobalSearch()});
});
