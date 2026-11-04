/* ============================================================
   PRINTKRAFT — SHARED SCRIPT (nhúng trực tiếp)
   ============================================================ */

/* ---------- DATA ---------- */
var SUPPLIERS=[
    {name:'Sài Gòn Print',city:'TP. Hồ Chí Minh',rating:4.9,jobs:1240,min:'24h',tags:['DTG','DTF','In lụa'],grad:'linear-gradient(135deg,#6C5CE7,#A29BFE)',initials:'SP'},
    {name:'Hà Nội In Nhanh',city:'Hà Nội',rating:4.8,jobs:980,min:'12h',tags:['In lụa','DTF'],grad:'linear-gradient(135deg,#FF6B6B,#FFB347)',initials:'HN'},
    {name:'Đà Nẵng Xpress',city:'Đà Nẵng',rating:4.7,jobs:640,min:'24h',tags:['Sublimation','DTG'],grad:'linear-gradient(135deg,#00B894,#55EFC4)',initials:'ĐN'},
    {name:'Cần Thơ Print Hub',city:'Cần Thơ',rating:4.6,jobs:410,min:'36h',tags:['In lụa','Sublimation'],grad:'linear-gradient(135deg,#48A9F8,#6C5CE7)',initials:'CT'},
    {name:'Laser Art Studio',city:'TP. Hồ Chí Minh',rating:4.9,jobs:520,min:'48h',tags:['Khắc laser','DTF'],grad:'linear-gradient(135deg,#FD79A8,#A29BFE)',initials:'LA'},
    {name:'Hải Phòng Canvas',city:'Hải Phòng',rating:4.5,jobs:300,min:'48h',tags:['DTG','Sublimation'],grad:'linear-gradient(135deg,#FFB347,#FF6B6B)',initials:'HP'}
];

var ORDERS=[
    {id:'PK-08231',product:'Áo thun Oversize Cotton',detail:'DTG · Size L · Màu Navy · 24 chiếc',total:'3.096.000đ',status:'producing',statusLabel:'Đang sản xuất',supplier:'Sài Gòn Print',eta:'17/09/2026',progress:2},
    {id:'PK-08228',product:'Namecard giấy mỹ thuật 300gsm',detail:'In offset · 500 tấm · 2 mặt',total:'600.000đ',status:'pending',statusLabel:'Chờ xác nhận',supplier:'Hà Nội In Nhanh',eta:'20/09/2026',progress:1},
    {id:'PK-08204',product:'Cốc sứ trắng 2 mặt',detail:'Sublimation · 30 chiếc · 350ml',total:'1.950.000đ',status:'shipping',statusLabel:'Đang giao',supplier:'Đà Nẵng Xpress',eta:'16/09/2026',progress:3},
    {id:'PK-08180',product:'Túi vải canvas dày',detail:'In lụa · 80 chiếc · Màu kem',total:'3.360.000đ',status:'delivered',statusLabel:'Đã giao',supplier:'Sài Gòn Print',eta:'Đã giao 12/09/2026',progress:4}
];

var NAV_ITEMS=[
    {id:'home',label:'Trang chủ',href:'trang_chu.jsp'},
    {id:'san-pham',label:'Sản phẩm',href:'san_pham.jsp'},
    {id:'studio',label:'Tự thiết kế',href:'dat_in_3d.jsp'},
    {id:'doanh-nghiep',label:'Doanh nghiệp',href:'trang_chu.jsp'},
    {id:'nhacungcap',label:'Nhà cung cấp',href:'tim-kiem-nha-cung-cap.jsp'},
    {id:'donhang',label:'Đơn hàng',href:'don_hang_cua_toi_3d.jsp'},
    {id:'danhgia',label:'Đánh giá',href:'danh-gia.jsp'},
    {id:'faq',label:'Hỗ trợ',href:'lien-he.jsp'}
];

/* ---------- TOAST ---------- */
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

/* ---------- STORAGE ---------- */
var store={
    get:function(k,d){try{var v=localStorage.getItem('pk_'+k);return v===null?d:JSON.parse(v)}catch(e){return d}},
    set:function(k,v){try{localStorage.setItem('pk_'+k,JSON.stringify(v))}catch(e){}}
};

/* ---------- HEADER ---------- */
function renderHeader(active){
    var el=document.getElementById('site-header');if(!el)return;
    el.innerHTML='<div class="utility"><span>🚚 Miễn phí thiết kế mockup cho đơn từ 20 sản phẩm — <b>Voucher 100K</b> cho đơn đầu tiên</span><span>Hỗ trợ: <b>1900 6868</b> · <a href="don_hang_cua_toi_3d.jsp">Theo dõi đơn hàng</a>'+(isLoggedIn()?'':' · <a href="'+PK.ctx+'/login">Đăng nhập</a>')+'</span></div>'+
        '<header><a href="trang_chu.jsp" class="logo"><span class="mark"></span> PrintKraft</a><nav id="mainNav">'+
        NAV_ITEMS.map(function(i){return '<a href="'+i.href+'" class="'+(i.id===active?'active':'')+'">'+i.label+'</a>'}).join('')+
        '</nav><div class="search-wrap"><input type="text" id="globalSearch" placeholder="Tìm áo thun, cốc sứ, poster..."><button onclick="doGlobalSearch()">Tìm</button></div>'+
        '<div class="head-actions"><div id="authArea"></div><button class="cart-btn" onclick="openCart()">🛒 Giỏ hàng <span class="badge" id="cartBadge">0</span></button></div></header>';
}
function doGlobalSearch(){
    var i=document.getElementById('globalSearch');
    var q=i?i.value.trim():'';
    if(!q){toastErr('Nhập từ khoá để tìm kiếm');return}
    location.href='tim-kiem-nha-cung-cap.jsp?q='+encodeURIComponent(q);
}

/* ---------- FOOTER ---------- */
function renderFooter(){
    var el=document.getElementById('site-footer');if(!el)return;
    el.innerHTML='<footer><div class="foot-inner">'+
        '<div><div class="logo" style="margin-bottom:16px;"><span class="mark"></span> PrintKraft</div><p style="font-size:13.5px;color:var(--ink-soft);max-width:34ch;">Nền tảng in theo yêu cầu kết nối khách hàng với hơn 120 xưởng in đối tác trên toàn quốc.</p><div style="display:flex;gap:10px;margin-top:18px;"><span class="chip" style="font-size:12px;padding:7px 14px;">Facebook</span><span class="chip" style="font-size:12px;padding:7px 14px;">Instagram</span><span class="chip" style="font-size:12px;padding:7px 14px;">Zalo</span></div></div>'+
        '<div><h5>Sản phẩm</h5><ul><li onclick="location.href=\'dat_in_3d.jsp\'">Áo thun &amp; Hoodie</li><li onclick="location.href=\'dat_in_3d.jsp\'">Cốc &amp; Bình giữ nhiệt</li><li onclick="location.href=\'dat_in_3d.jsp\'">Poster &amp; Canvas</li><li onclick="location.href=\'dat_in_3d.jsp\'">Bao bì &amp; Nhãn dán</li><li onclick="location.href=\'trang_chu.jsp\'">Quà tặng doanh nghiệp</li></ul></div>'+
        '<div><h5>Hỗ trợ</h5><ul><li onclick="location.href=\'lien-he.jsp\'">Trung tâm trợ giúp</li><li onclick="location.href=\'don_hang_cua_toi_3d.jsp\'">Theo dõi đơn hàng</li><li onclick="location.href=\'lien-he.jsp\'">Chính sách đổi trả</li><li onclick="location.href=\'lien-he.jsp\'">Chính sách bảo mật</li><li onclick="location.href=\'lien-he.jsp\'">Điều khoản sử dụng</li></ul></div>'+
        '<div><h5>Liên hệ</h5><ul><li>Hotline: 1900 6868</li><li>Email: hi@printkraft.vn</li><li>Văn phòng: 128 Nguyễn Đình Chiểu, Q.3, TP.HCM</li><li>Giờ làm việc: 8:00 – 21:00</li></ul></div>'+
        '</div><div class="foot-bottom"><span>© 2026 PrintKraft. Nền tảng in theo yêu cầu.</span><span>Điều khoản · Bảo mật · Hỗ trợ khách hàng</span></div></footer>';
}

/* ---------- AUTH (đăng nhập thật qua session phía server) ---------- */
/* Dữ liệu lấy từ <div id="pk-session"> do WEB-INF/views/common/session-info.jsp in ra */
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
/* Giữ tên hàm cũ để các nút "Đăng nhập" còn sót ở trang khác vẫn chạy: chuyển sang trang đăng nhập thật */
function openLogin(){location.href=PK.ctx+'/login'}

/* ---------- MODAL / DRAWER ---------- */
function openCart(){
    closeAll();
    document.getElementById('cartDrawer').classList.add('show');
    document.getElementById('overlay').classList.add('show');
    document.body.style.overflow='hidden';
}
function openModalById(id){
    var el=document.getElementById(id);if(!el)return;
    closeAll();
    el.classList.add('show');
    document.getElementById('overlay').classList.add('show');
    document.body.style.overflow='hidden';
}
function closeAll(){
    document.querySelectorAll('.drawer, .modal').forEach(function(el){el.classList.remove('show')});
    var ov=document.getElementById('overlay');
    if(ov)ov.classList.remove('show');
    document.body.style.overflow='';
}
document.addEventListener('keydown',function(e){if(e.key==='Escape')closeAll()});

/* ---------- CART ---------- */
function getCartCount(){return store.get('cartCount',3)}
function setCartCount(n){
    store.set('cartCount',n);
    var b=document.getElementById('cartBadge');if(b)b.textContent=n;
}
function addCart(name,price){
    setCartCount(getCartCount()+1);
    toastOk('Đã thêm "'+name+'" vào giỏ hàng');
}

/* ---------- SUPPLIERS ---------- */
var supplierFilter='all';
function setSupplierFilter(btn,f){
    supplierFilter=f;
    btn.parentElement.querySelectorAll('.chip').forEach(function(c){c.classList.remove('active')});
    btn.classList.add('active');
    renderSuppliers();
}
function renderSuppliers(){
    var grid=document.getElementById('supplierGrid');if(!grid)return;
    var input=document.getElementById('supplierSearch');
    var q=(input?input.value:'').toLowerCase().trim();
    var list=SUPPLIERS.filter(function(s){
        var mf=supplierFilter==='all'||s.tags.indexOf(supplierFilter)>=0;
        var mq=!q||s.name.toLowerCase().indexOf(q)>=0||s.city.toLowerCase().indexOf(q)>=0||s.tags.some(function(t){return t.toLowerCase().indexOf(q)>=0});
        return mf&&mq;
    });
    if(list.length===0){
        grid.innerHTML='<div class="empty-state"><div style="font-size:34px;margin-bottom:10px;">🔍</div><strong>Không tìm thấy nhà cung cấp phù hợp</strong><p style="margin-top:6px;font-size:13.5px;">Thử từ khoá khác như "Hà Nội", "DTG" hoặc "in lụa"</p></div>';
        return;
    }
    grid.innerHTML=list.map(function(s){
        return '<div class="supplier"><div class="supplier-top"><div class="supplier-logo" style="background:'+s.grad+'">'+s.initials+'</div><div><h4>'+s.name+'</h4><div class="loc">📍 '+s.city+'</div></div></div><div class="supplier-meta">'+
            s.tags.map(function(t){return '<span class="pill">'+t+'</span>'}).join('')+
            '<span class="pill teal">⚡ '+s.min+'</span></div><div class="supplier-stat"><span>Đánh giá <b style="color:var(--amber)">★ '+s.rating+'</b></span><span><b>'+s.jobs.toLocaleString('vi-VN')+'</b> đơn hoàn tất</span></div><div class="supplier-actions"><button class="btn-outline" onclick="openSupplierReview(\''+s.name+'\')">★ Đánh giá</button><button class="btn-fill" onclick="openContact(\''+s.name+'\')">Liên hệ</button></div></div>';
    }).join('');
}
function openContact(name){
    document.getElementById('contactSupplier').value=name;
    document.getElementById('contactSub').textContent='Gửi yêu cầu trực tiếp tới '+name;
    document.getElementById('contactMsg').value='';
    openModalById('contactModal');
}
function submitContact(){
    var name=document.getElementById('contactSupplier').value;
    closeAll();
    toastOk('Đã gửi tin nhắn tới '+name+' — phản hồi trong 2 giờ');
}
var currentSupplierForReview='';
function openSupplierReview(name){
    currentSupplierForReview=name;
    document.getElementById('supRevSub').textContent='Đánh giá xưởng: '+name;
    document.querySelectorAll('#supplierReviewModal .star-input').forEach(function(si){
        si.dataset.value=0;
        si.querySelectorAll('button').forEach(function(b){b.classList.remove('on')});
    });
    document.getElementById('supRevText').value='';
    openModalById('supplierReviewModal');
}
function submitSupplierReview(){
    var groups=document.querySelectorAll('#supplierReviewModal .star-input');
    var sum=0,count=0;
    groups.forEach(function(g){
        var v=parseInt(g.dataset.value||0,10);
        if(v>0){sum+=v;count++}
    });
    if(count<groups.length){toastErr('Vui lòng chấm điểm đầy đủ 3 tiêu chí');return}
    var avg=(sum/groups.length).toFixed(1);
    closeAll();
    toastOk('Đã gửi đánh giá '+avg+'★ cho '+currentSupplierForReview);
}

/* ---------- STAR INPUT ---------- */
document.addEventListener('click',function(e){
    var btn=e.target.closest('.star-input button');
    if(!btn)return;
    var si=btn.closest('.star-input');
    var v=parseInt(btn.dataset.v,10);
    si.dataset.value=v;
    si.querySelectorAll('button').forEach(function(b){
        b.classList.toggle('on',parseInt(b.dataset.v,10)<=v);
    });
    var lbl=document.getElementById('starLabel');
    if(lbl&&si.id==='starProduct'){
        var labels=['','Rất tệ 😞','Không hài lòng 😕','Bình thường 😐','Hài lòng 🙂','Tuyệt vời 🤩'];
        lbl.textContent=labels[v];
    }
});

/* ---------- PRODUCT REVIEW ---------- */
var currentProductForReview='';
function openProductReview(name){
    currentProductForReview=name;
    document.getElementById('reviewSub').textContent='Đánh giá: '+name;
    var si=document.getElementById('starProduct');
    si.dataset.value=0;
    si.querySelectorAll('button').forEach(function(b){b.classList.remove('on')});
    document.getElementById('starLabel').textContent='Chạm để chọn số sao';
    document.getElementById('reviewText').value='';
    openModalById('reviewModal');
}
function submitProductReview(){
    var v=parseInt(document.getElementById('starProduct').dataset.value||0,10);
    var text=document.getElementById('reviewText').value.trim();
    if(v===0){toastErr('Vui lòng chọn số sao đánh giá');return}
    if(text.length<5){toastErr('Vui lòng nhập nhận xét của bạn');return}
    var stars='★'.repeat(v)+'☆'.repeat(5-v);
    var list=document.getElementById('reviewList');
    if(list){
        var div=document.createElement('div');
        div.className='review';
        div.innerHTML='<span class="review-tag">Sản phẩm</span><div class="who"><div class="avatar lg">MA</div><div><strong>Nguyễn Minh Anh</strong><span>Vừa xong · Đã xác thực</span></div></div><div class="stars" style="margin-bottom:8px;">'+stars+'</div><p>"'+text.replace(/</g,'&lt;')+'"</p><div class="verified">✓ Đã xác thực đơn hàng</div>';
        list.prepend(div);
    }
    closeAll();
    toastOk('Cảm ơn bạn đã đánh giá '+currentProductForReview+'!');
}

/* ---------- ORDERS ---------- */
var requests=store.get('requests',[]);
var currentOrderTab='all';
var statusClass={pending:'st-pending',producing:'st-producing',shipping:'st-shipping',delivered:'st-delivered',cancelled:'st-cancelled'};

function initOrderPage(){
    var locked=document.getElementById('orderLocked');if(!locked)return;
    if(isLoggedIn()){
        locked.style.display='none';
        document.getElementById('orderPanel').style.display='block';
        updateReqCount();
        renderOrders();
    } else {
        locked.style.display='block';
        document.getElementById('orderPanel').style.display='none';
    }
}
function updateReqCount(){
    var el=document.getElementById('reqCount');
    if(el)el.textContent='('+requests.length+')';
}
function switchOrderTab(btn,tab){
    currentOrderTab=tab;
    btn.parentElement.querySelectorAll('button').forEach(function(b){b.classList.remove('active')});
    btn.classList.add('active');
    renderOrders();
}
function renderOrders(){
    var list=document.getElementById('orderList');if(!list)return;
    if(currentOrderTab==='requests'){
        if(requests.length===0){
            list.innerHTML='<div class="empty-state"><div style="font-size:34px;margin-bottom:10px;">📋</div><strong>Chưa có yêu cầu nào</strong><p style="margin-top:6px;font-size:13.5px;">Các yêu cầu chỉnh sửa, hủy đơn hoặc trả hàng của bạn sẽ hiển thị ở đây.</p></div>';
            return;
        }
        list.innerHTML='<div class="request-list">'+requests.map(function(r){
            return '<div class="request-item '+r.tone+'"><div class="ri-body"><strong>'+r.title+' — #'+r.orderId+'</strong><span>'+r.desc+' · Gửi lúc '+r.time+'</span></div><span class="status-badge '+r.badge+'">'+r.status+'</span></div>';
        }).join('')+'</div>';
        return;
    }
    var filtered=currentOrderTab==='all'?ORDERS:ORDERS.filter(function(o){return o.status===currentOrderTab});
    if(filtered.length===0){
        list.innerHTML='<div class="empty-state"><div style="font-size:34px;margin-bottom:10px;">📦</div><strong>Không có đơn hàng nào</strong></div>';
        return;
    }
    list.innerHTML=filtered.map(function(o){
        return '<div class="order-card"><div class="order-card-top"><div><h4>'+o.product+'</h4><div class="oid">#'+o.id+' · '+o.detail+'</div></div><span class="status-badge '+statusClass[o.status]+'">'+o.statusLabel+'</span></div><div class="order-progress">'+
            [1,2,3,4].map(function(i){return '<div class="bar '+(i<=o.progress?'on':'')+'"></div>'}).join('')+
            '</div><div class="order-info"><span>Tổng tiền: <b>'+o.total+'</b></span><span>Xưởng in: <b>'+o.supplier+'</b></span><span>Dự kiến: <b>'+o.eta+'</b></span></div><div class="order-actions">'+orderActionsFor(o)+'</div></div>';
    }).join('');
}
function orderActionsFor(o){
    var html='<button onclick="toast(\'Đang mở chi tiết đơn #'+o.id+'...\')">Xem chi tiết</button>';
    if(o.status==='pending'){
        html+='<button onclick="openOrderAction(\'edit\',\''+o.id+'\',\''+o.product+'\')">✏️ Chỉnh sửa đơn</button>';
        html+='<button class="danger" onclick="openOrderAction(\'cancel\',\''+o.id+'\',\''+o.product+'\')">✕ Hủy đơn</button>';
    }
    if(o.status==='producing'){
        html+='<button onclick="openOrderAction(\'edit\',\''+o.id+'\',\''+o.product+'\')">✏️ Yêu cầu chỉnh sửa</button>';
        html+='<button class="danger" onclick="openOrderAction(\'cancel\',\''+o.id+'\',\''+o.product+'\')">✕ Yêu cầu hủy đơn</button>';
        html+='<button onclick="toast(\'Đã gửi tin nhắn tới xưởng '+o.supplier+'\')">💬 Nhắn xưởng in</button>';
    }
    if(o.status==='shipping'){
        html+='<button onclick="toast(\'Đang mở bản đồ theo dõi vận chuyển...\')">🚚 Theo dõi vận chuyển</button>';
        html+='<button class="danger" onclick="openOrderAction(\'cancel\',\''+o.id+'\',\''+o.product+'\')">✕ Yêu cầu hủy đơn</button>';
    }
    if(o.status==='delivered'){
        html+='<button class="primary" onclick="openOrderAction(\'return\',\''+o.id+'\',\''+o.product+'\')">↩️ Yêu cầu trả hàng</button>';
        html+='<button onclick="openProductReview(\''+o.product+'\')">★ Đánh giá sản phẩm</button>';
        html+='<button onclick="openSupplierReview(\''+o.supplier+'\')">🏭 Đánh giá nhà cung cấp</button>';
    }
    return html;
}
var oaContext={};
function openOrderAction(type,orderId,product){
    oaContext={type:type,orderId:orderId,product:product};
    var cfg={
        edit:{
            title:'Yêu cầu chỉnh sửa đơn hàng',
            sub:'Đơn #'+orderId+' · '+product,
            submit:'Gửi yêu cầu chỉnh sửa',
            body:'<div style="background:#FFF4E0;border-radius:12px;padding:14px;font-size:13px;color:#8A5A00;margin-bottom:18px;line-height:1.6;">⚠️ <b>Lưu ý:</b> Đơn đang trong quá trình sản xuất. Thay đổi về số lượng hoặc chất liệu có thể phát sinh phụ phí và làm chậm tiến độ 1–2 ngày.</div><div class="field"><label>Nội dung cần chỉnh sửa</label><select id="oaEditType"><option>Thay đổi số lượng</option><option>Thay đổi kích thước / size</option><option>Thay đổi màu sản phẩm</option><option>Thay đổi file thiết kế</option><option>Thay đổi địa chỉ giao hàng</option><option>Khác</option></select></div><div class="field"><label>Chi tiết thay đổi</label><textarea rows="3" id="oaEditNote" placeholder="VD: Tăng từ 24 lên 30 áo, thêm size XL..."></textarea></div><div class="field"><label>Mức độ khẩn cấp</label><select id="oaEditUrgency"><option>Bình thường</option><option>Gấp — cần xử lý trong 2 giờ</option></select></div>'
        },
        cancel:{
            title:'Yêu cầu hủy đơn hàng',
            sub:'Đơn #'+orderId+' · '+product,
            submit:'Xác nhận hủy đơn',
            body:'<div style="background:#FFECEC;border-radius:12px;padding:14px;font-size:13px;color:#C0392B;margin-bottom:18px;line-height:1.6;">⚠️ <b>Phí hủy đơn:</b> Nếu xưởng đã bắt đầu sản xuất, phí hủy là <b>30% giá trị đơn hàng</b>. Trước khi xưởng nhận file, bạn được hủy miễn phí hoàn toàn.</div><div class="field"><label>Lý do hủy đơn</label><select id="oaCancelReason"><option>Đặt nhầm sản phẩm</option><option>Đặt nhầm số lượng</option><option>Thay đổi kế hoạch kinh doanh</option><option>Thời gian giao hàng không phù hợp</option><option>Tìm được nhà cung cấp khác</option><option>Lý do khác</option></select></div><div class="field"><label>Ghi chú thêm</label><textarea rows="3" id="oaCancelNote" placeholder="Cho chúng tôi biết thêm để hỗ trợ bạn tốt hơn..."></textarea></div><label style="display:flex;gap:10px;align-items:flex-start;font-size:13px;color:var(--ink-soft);"><input type="checkbox" id="oaCancelAgree" style="margin-top:3px;accent-color:var(--violet);"><span>Tôi hiểu và đồng ý với phí hủy đơn (nếu có).</span></label>'
        },
        return:{
            title:'Yêu cầu trả hàng / hoàn tiền',
            sub:'Đơn #'+orderId+' · '+product,
            submit:'Gửi yêu cầu trả hàng',
            body:'<div style="background:#E1FBF3;border-radius:12px;padding:14px;font-size:13px;color:#0A7A5E;margin-bottom:18px;line-height:1.6;">✓ Bạn có thể yêu cầu trả hàng trong vòng <b>7 ngày</b> kể từ khi nhận. Nếu lỗi thuộc về xưởng, PrintKraft in lại miễn phí hoặc hoàn tiền 100%.</div><div class="field"><label>Lý do trả hàng</label><select id="oaReturnReason"><option>Sản phẩm in bị lỗi / nhoè</option><option>Màu sắc không đúng thiết kế</option><option>Kích thước sai so với đặt hàng</option><option>Sản phẩm bị hư hỏng khi vận chuyển</option><option>Thiếu số lượng so với đơn hàng</option><option>Không đúng chất liệu đã chọn</option></select></div><div class="field"><label>Mô tả chi tiết</label><textarea rows="3" id="oaReturnNote" placeholder="Mô tả tình trạng sản phẩm..."></textarea></div><div class="field"><label>Phương án mong muốn</label><select id="oaReturnSolution"><option>In lại sản phẩm mới (miễn phí)</option><option>Hoàn tiền 100%</option><option>Giảm giá đơn tiếp theo 20%</option></select></div><div class="field"><label>Ảnh sản phẩm lỗi</label><div style="border:1.5px dashed var(--line-strong);border-radius:12px;padding:20px;text-align:center;color:var(--ink-soft);font-size:13px;cursor:pointer;background:#FBF9FF;" onclick="toast(\'Đã mở hộp thoại chọn ảnh\')">📷 Tải lên ảnh sản phẩm lỗi (tối đa 5 ảnh)</div></div>'
        }
    };
    var c=cfg[type];
    document.getElementById('oaTitle').textContent=c.title;
    document.getElementById('oaSub').textContent=c.sub;
    document.getElementById('oaBody').innerHTML=c.body;
    document.getElementById('oaSubmit').textContent=c.submit;
    openModalById('orderActionModal');
}
function submitOrderAction(){
    var ctx=oaContext,type=ctx.type,orderId=ctx.orderId;
    var now=new Date().toLocaleTimeString('vi-VN',{hour:'2-digit',minute:'2-digit'});
    var req;
    if(type==='edit'){
        var kind=document.getElementById('oaEditType').value;
        var note=document.getElementById('oaEditNote').value.trim();
        if(!note){toastErr('Vui lòng mô tả chi tiết thay đổi');return}
        req={orderId:orderId,tone:'warn',badge:'st-pending',status:'Chờ xưởng duyệt',title:'Yêu cầu chỉnh sửa: '+kind,desc:'Nội dung: '+note,time:now};
    } else if(type==='cancel'){
        var reason=document.getElementById('oaCancelReason').value;
        if(!document.getElementById('oaCancelAgree').checked){toastErr('Vui lòng xác nhận điều khoản phí hủy đơn');return}
        req={orderId:orderId,tone:'',badge:'st-pending',status:'Đang xử lý',title:'Yêu cầu hủy đơn',desc:'Lý do: '+reason,time:now};
    } else {
        var rreason=document.getElementById('oaReturnReason').value;
        var sol=document.getElementById('oaReturnSolution').value;
        req={orderId:orderId,tone:'ok',badge:'st-shipping',status:'Đang xử lý',title:'Yêu cầu trả hàng: '+rreason,desc:'Phương án: '+sol,time:now};
    }
    requests.unshift(req);
    store.set('requests',requests);
    updateReqCount();
    closeAll();
    var msgs={edit:'Đã gửi yêu cầu chỉnh sửa — xưởng sẽ phản hồi trong 2 giờ',cancel:'Đã gửi yêu cầu hủy đơn — bộ phận CSKH sẽ liên hệ trong 30 phút',return:'Đã gửi yêu cầu trả hàng — chúng tôi sẽ xử lý trong 24 giờ'};
    toastOk(msgs[type]);
}

/* ---------- PAYMENT ---------- */
var payStep=1;
function openPayment(){closeAll();payStep=1;renderPayStep();openModalById('paymentModal')}
function gotoPayStep(n){
    if(n===3){
        var name=document.getElementById('shipName').value.trim();
        var phone=document.getElementById('shipPhone').value.trim();
        var addr=document.getElementById('shipAddr').value.trim();
        if(!name||!phone||!addr){toastErr('Vui lòng điền đầy đủ thông tin nhận hàng');return}
        document.getElementById('cfName').textContent=name;
        document.getElementById('cfPhone').textContent=phone;
        document.getElementById('cfAddr').textContent=addr;
        var m=document.querySelector('.pay-method.active');
        document.getElementById('cfMethod').textContent=m?m.querySelector('strong').textContent:'—';
    }
    payStep=n;
    renderPayStep();
}
function renderPayStep(){
    [1,2,3].forEach(function(i){
        document.getElementById('payStep'+i).style.display=(payStep===i)?'block':'none';
    });
    document.getElementById('payStepDone').style.display='none';
    document.getElementById('payStepper').style.display='flex';
    document.querySelectorAll('#payStepper .s').forEach(function(s){
        var n=parseInt(s.dataset.s,10);
        s.classList.toggle('active',n===payStep);
        s.classList.toggle('done',n<payStep);
    });
    var titles=['','Thông tin nhận hàng','Phương thức thanh toán','Xác nhận đơn hàng'];
    document.getElementById('payTitle').textContent=titles[payStep];
    document.getElementById('paySub').textContent='Bước '+payStep+' / 3';
}
function pickPayMethod(btn){
    document.querySelectorAll('#payMethods .pay-method').forEach(function(b){b.classList.remove('active')});
    btn.classList.add('active');
    var m=btn.dataset.m;
    document.getElementById('cardForm').style.display=(m==='card')?'block':'none';
    document.getElementById('bankInfo').style.display=(m==='bank')?'block':'none';
}
function formatCard(el){
    var v=el.value.replace(/\D/g,'').slice(0,16);
    el.value=v.replace(/(.{4})/g,'$1 ').trim();
}
function formatExpiry(el){
    var v=el.value.replace(/\D/g,'').slice(0,4);
    if(v.length>=3)v=v.slice(0,2)+'/'+v.slice(2);
    el.value=v;
}
function confirmPayment(){
    if(!document.getElementById('agreeTerms').checked){toastErr('Vui lòng đồng ý với điều khoản dịch vụ');return}
    [1,2,3].forEach(function(i){document.getElementById('payStep'+i).style.display='none'});
    document.getElementById('payStepper').style.display='none';
    document.getElementById('payTitle').textContent='';
    document.getElementById('paySub').textContent='';
    document.getElementById('payStepDone').style.display='block';
    setCartCount(0);
    toastOk('Thanh toán thành công!');
}

/* ---------- INJECT SHARED UI ---------- */
function injectSharedUI(){
    var wrap=document.createElement('div');
    wrap.innerHTML=
        '<div class="overlay" id="overlay" onclick="closeAll()"></div>'+

        /* CART DRAWER: fragment server-side /WEB-INF/views/common/cart-drawer.jsp */

        /* PAYMENT MODAL */
        '<div class="modal" id="paymentModal"><div class="modal-box wide"><button class="modal-close" onclick="closeAll()">✕</button><h3 id="payTitle">Thanh toán đơn hàng</h3><div class="sub" id="paySub">Hoàn tất 3 bước để đặt hàng</div>'+
        '<div class="stepper" id="payStepper"><div class="s active" data-s="1"><div class="n">1</div><span>Nhận hàng</span></div><div class="sep"></div><div class="s" data-s="2"><div class="n">2</div><span>Thanh toán</span></div><div class="sep"></div><div class="s" data-s="3"><div class="n">3</div><span>Xác nhận</span></div></div>'+
        '<div id="payStep1"><div class="field-row"><div class="field"><label>Họ và tên</label><input id="shipName" value="Nguyễn Minh Anh"></div><div class="field"><label>Số điện thoại</label><input id="shipPhone" value="0901 234 567"></div></div><div class="field"><label>Email</label><input id="shipEmail" value="minhanh@store.vn"></div><div class="field"><label>Địa chỉ giao hàng</label><input id="shipAddr" value="128 Nguyễn Đình Chiểu, Q.3, TP.HCM"></div><div class="field"><label>Ghi chú đơn hàng</label><textarea rows="2" placeholder="VD: Giao giờ hành chính..."></textarea></div><button class="btn-primary" style="width:100%;" onclick="gotoPayStep(2)">Tiếp tục →</button></div>'+
        '<div id="payStep2" style="display:none;"><div class="pay-methods" id="payMethods">'+
        '<button class="pay-method active" data-m="card" onclick="pickPayMethod(this)"><div class="ic" style="background:var(--grad-primary)">💳</div><div class="pm-body"><strong>Thẻ tín dụng / ghi nợ</strong><span>Visa, Mastercard, JCB</span></div><div class="radio"></div></button>'+
        '<button class="pay-method" data-m="bank" onclick="pickPayMethod(this)"><div class="ic" style="background:var(--grad-sky)">🏦</div><div class="pm-body"><strong>Chuyển khoản ngân hàng</strong><span>Xác nhận tự động trong 5 phút</span></div><div class="radio"></div></button>'+
        '<button class="pay-method" data-m="wallet" onclick="pickPayMethod(this)"><div class="ic" style="background:var(--grad-pink)">📱</div><div class="pm-body"><strong>Ví điện tử</strong><span>MoMo, ZaloPay, ShopeePay</span></div><div class="radio"></div></button>'+
        '<button class="pay-method" data-m="cod" onclick="pickPayMethod(this)"><div class="ic" style="background:var(--grad-cool);color:#063a2e">💵</div><div class="pm-body"><strong>Thanh toán khi nhận hàng (COD)</strong><span>Phụ phí 15.000đ</span></div><div class="radio"></div></button>'+
        '</div>'+
        '<div id="cardForm" style="margin-top:20px;"><div class="field"><label>Số thẻ</label><input id="cardNo" placeholder="1234 5678 9012 3456" maxlength="19" oninput="formatCard(this)"></div><div class="field-row"><div class="field"><label>Ngày hết hạn</label><input placeholder="MM/YY" maxlength="5" oninput="formatExpiry(this)"></div><div class="field"><label>CVC</label><input placeholder="123" maxlength="4"></div></div><div class="field"><label>Tên chủ thẻ</label><input placeholder="NGUYEN VAN A"></div></div>'+
        '<div id="bankInfo" style="display:none;margin-top:20px;"><div class="summary-box"><div class="row"><span>Ngân hàng</span><strong>Vietcombank</strong></div><div class="row"><span>Số tài khoản</span><strong>0071 0009 8877 66</strong></div><div class="row"><span>Chủ tài khoản</span><strong>CONG TY PRINTKRAFT</strong></div><div class="row"><span>Nội dung CK</span><strong>PK-08231</strong></div></div></div>'+
        '<div style="display:flex;gap:10px;margin-top:20px;"><button class="btn-secondary" style="flex:1;" onclick="gotoPayStep(1)">← Quay lại</button><button class="btn-primary" style="flex:2;" onclick="gotoPayStep(3)">Xem lại đơn hàng</button></div></div>'+
        '<div id="payStep3" style="display:none;"><div class="summary-box"><div class="row"><span>Người nhận</span><strong id="cfName">—</strong></div><div class="row"><span>Điện thoại</span><strong id="cfPhone">—</strong></div><div class="row"><span>Địa chỉ</span><strong id="cfAddr" style="text-align:right;max-width:60%;">—</strong></div><div class="row"><span>Phương thức</span><strong id="cfMethod">—</strong></div></div><div class="summary-box"><div class="row"><span>Tạm tính (3 sản phẩm)</span><span>6.786.000đ</span></div><div class="row"><span>Phí vận chuyển</span><span>Miễn phí</span></div><div class="row"><span>Giảm giá</span><span style="color:var(--teal);font-weight:600;">-100.000đ</span></div><div class="row total"><span>Tổng thanh toán</span><span>6.686.000đ</span></div></div><label style="display:flex;gap:10px;align-items:flex-start;font-size:13px;color:var(--ink-soft);margin-bottom:18px;"><input type="checkbox" id="agreeTerms" style="margin-top:3px;accent-color:var(--violet);"><span>Tôi đồng ý với <a href="lien-he.jsp" style="color:var(--violet);font-weight:600;">Điều khoản dịch vụ</a> và <a href="lien-he.jsp" style="color:var(--violet);font-weight:600;">Chính sách đổi trả</a>.</span></label><div style="display:flex;gap:10px;"><button class="btn-secondary" style="flex:1;" onclick="gotoPayStep(2)">← Quay lại</button><button class="btn-primary btn-teal" style="flex:2;" onclick="confirmPayment()">🔒 Thanh toán 6.686.000đ</button></div></div>'+
        '<div id="payStepDone" style="display:none;"><div class="success-screen"><div class="success-icon">✓</div><h3>Đặt hàng thành công!</h3><p>Cảm ơn bạn đã tin tưởng PrintKraft. Xưởng in sẽ xác nhận trong vòng 30 phút.</p><div class="order-code">#PK-08231</div><p style="font-size:13px;">Hóa đơn điện tử đã được gửi tới <b>minhanh@store.vn</b></p><div style="display:flex;gap:10px;margin-top:22px;"><button class="btn-secondary" style="flex:1;" onclick="closeAll()">Đóng</button><button class="btn-primary" style="flex:1;" onclick="closeAll();location.href=\'don_hang_cua_toi_3d.jsp\';">Theo dõi đơn</button></div></div></div>'+
        '</div></div>'+

        /* ORDER ACTION MODAL */
        '<div class="modal" id="orderActionModal"><div class="modal-box"><button class="modal-close" onclick="closeAll()">✕</button><h3 id="oaTitle">Yêu cầu</h3><div class="sub" id="oaSub"></div><div id="oaBody"></div><div style="display:flex;gap:10px;margin-top:6px;"><button class="btn-secondary" style="flex:1;" onclick="closeAll()">Hủy</button><button class="btn-primary" id="oaSubmit" style="flex:2;" onclick="submitOrderAction()">Gửi yêu cầu</button></div></div></div>'+

        /* PRODUCT REVIEW MODAL */
        '<div class="modal" id="reviewModal"><div class="modal-box"><button class="modal-close" onclick="closeAll()">✕</button><h3>Đánh giá sản phẩm</h3><div class="sub" id="reviewSub">Chia sẻ trải nghiệm của bạn</div><div class="field"><label>Chất lượng sản phẩm</label><div class="star-input" id="starProduct" data-value="0"><button data-v="1">★</button><button data-v="2">★</button><button data-v="3">★</button><button data-v="4">★</button><button data-v="5">★</button></div><div class="rate-label" id="starLabel">Chạm để chọn số sao</div></div><div class="field"><label>Nhận xét của bạn</label><textarea rows="4" id="reviewText" placeholder="Chất liệu, màu in, độ bền..."></textarea></div><div class="field"><label>Thêm ảnh (không bắt buộc)</label><div style="border:1.5px dashed var(--line-strong);border-radius:12px;padding:22px;text-align:center;color:var(--ink-soft);font-size:13px;cursor:pointer;background:#FBF9FF;" onclick="toast(\'Đã mở hộp thoại chọn ảnh\')">📷 Kéo ảnh vào đây hoặc nhấp để chọn (tối đa 5 ảnh)</div></div><button class="btn-primary" style="width:100%;" onclick="submitProductReview()">Gửi đánh giá</button></div></div>'+

        /* SUPPLIER CONTACT MODAL */
        '<div class="modal" id="contactModal"><div class="modal-box"><button class="modal-close" onclick="closeAll()">✕</button><h3>Liên hệ nhà cung cấp</h3><div class="sub" id="contactSub">Gửi yêu cầu trực tiếp tới xưởng in</div><div class="field"><label>Xưởng in</label><input id="contactSupplier" readonly style="background:#F2EFFF;font-weight:600;color:var(--violet);"></div><div class="field"><label>Chủ đề</label><select id="contactSubject"><option>Hỏi báo giá số lượng lớn</option><option>Hỏi thời gian sản xuất</option><option>Yêu cầu in mẫu thử</option><option>Hợp tác dài hạn</option><option>Vấn đề về đơn hàng đã đặt</option></select></div><div class="field-row"><div class="field"><label>Số lượng dự kiến</label><input placeholder="VD: 500"></div><div class="field"><label>SĐT liên hệ</label><input placeholder="09xx xxx xxx"></div></div><div class="field"><label>Nội dung</label><textarea rows="4" id="contactMsg" placeholder="Mô tả yêu cầu của bạn..."></textarea></div><button class="btn-primary" style="width:100%;" onclick="submitContact()">Gửi tin nhắn</button></div></div>'+

        /* SUPPLIER REVIEW MODAL */
        '<div class="modal" id="supplierReviewModal"><div class="modal-box"><button class="modal-close" onclick="closeAll()">✕</button><h3>Đánh giá nhà cung cấp</h3><div class="sub" id="supRevSub">Đánh giá xưởng in</div><div class="field"><label>Chất lượng in ấn</label><div class="star-input" data-group="q" data-value="0"><button data-v="1">★</button><button data-v="2">★</button><button data-v="3">★</button><button data-v="4">★</button><button data-v="5">★</button></div></div><div class="field"><label>Đúng tiến độ</label><div class="star-input" data-group="t" data-value="0"><button data-v="1">★</button><button data-v="2">★</button><button data-v="3">★</button><button data-v="4">★</button><button data-v="5">★</button></div></div><div class="field"><label>Thái độ &amp; hỗ trợ</label><div class="star-input" data-group="s" data-value="0"><button data-v="1">★</button><button data-v="2">★</button><button data-v="3">★</button><button data-v="4">★</button><button data-v="5">★</button></div></div><div class="field"><label>Nhận xét</label><textarea rows="3" id="supRevText" placeholder="Chia sẻ trải nghiệm..."></textarea></div><button class="btn-primary" style="width:100%;" onclick="submitSupplierReview()">Gửi đánh giá</button></div></div>'+

        '<div class="toast" id="toast">Đã thực hiện</div>';

    document.body.appendChild(wrap);
}

/* ---------- INIT ---------- */
document.addEventListener('DOMContentLoaded',function(){
    var activePage=document.body.dataset.page||'home';
    renderHeader(activePage);
    renderFooter();
    injectSharedUI();
    renderAuthArea();
    /* Badge lấy từ giỏ thật trong session (session-info.jsp), không dùng localStorage demo. */
    setCartCount(PK.cartCount||0);
    if(document.getElementById('supplierGrid'))renderSuppliers();
    if(document.getElementById('qtyRange'))updatePrice();
    initOrderPage();
    var params=new URLSearchParams(location.search);
    var q=params.get('q');
    if(q&&document.getElementById('supplierSearch')){
        document.getElementById('supplierSearch').value=q;
        renderSuppliers();
    }
});