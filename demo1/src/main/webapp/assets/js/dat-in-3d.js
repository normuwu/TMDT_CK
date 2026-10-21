/* =====================================================================
   PrintKraft - JS RIÊNG của trang ĐẶT IN 3D (dat_in_3d.jsp).
   Thứ tự nạp trong JSP: three.min.js -> printkraft.js -> dat-in-3d.js
   Dùng chung từ printkraft.js: toast(), toastOk(), toastErr(), header, đăng nhập.
   KHÔNG khai báo lại các hàm toast ở đây (khai báo trùng sẽ gây lỗi).
   ===================================================================== */

/* ============================================================
   1. DỮ LIỆU CẤU HÌNH — thêm/bớt công nghệ, vật liệu tại đây
   ============================================================ */
const QUALITY_SETS = {
    fdm: [
        {id:'standard', name:'Standard', layer:0.28, desc:'Prototype, sản phẩm ưu tiên chi phí.'},
        {id:'normal',   name:'Normal',   layer:0.20, desc:'Cân bằng cho nhu cầu thông thường.'},
        {id:'fine',     name:'Fine',     layer:0.12, desc:'Nhiều chi tiết, bề mặt mịn hơn.'},
        {id:'ultra',    name:'Ultra Fine', layer:0.08, desc:'Chi tiết cao, thời gian in dài hơn.'}
    ],
    resin: [
        {id:'r-normal', name:'Normal',     layer:0.10, desc:'Mô hình thông thường, in nhanh.'},
        {id:'r-fine',   name:'Fine',       layer:0.05, desc:'Chi tiết sắc nét cho mô hình trưng bày.'},
        {id:'r-ultra',  name:'Ultra Fine', layer:0.03, desc:'Chi tiết rất nhỏ như trang sức, nha khoa.'}
    ],
    powder: [
        {id:'p-standard', name:'Standard', layer:0.12, desc:'Mặc định của máy, phù hợp đa số chi tiết.'},
        {id:'p-fine',     name:'Fine',     layer:0.08, desc:'Bề mặt mịn hơn, dùng cho chi tiết nhỏ.'}
    ]
};

const TECHNOLOGIES = [
    {
        id:'fdm', name:'FDM', tagline:'Phổ biến nhất',
        desc:'Phù hợp prototype, đồ dùng, mô hình lớn và các sản phẩm ưu tiên chi phí.',
        build:{x:300,y:300,z:400}, quality:'fdm',
        materials:[
            {id:'pla',   name:'PLA',   desc:'Dễ in, giá tốt, nhiều màu — dùng trong nhà.'},
            {id:'plap',  name:'PLA+',  desc:'Bền và dai hơn PLA thường.'},
            {id:'petg',  name:'PETG',  desc:'Chịu ẩm và va đập tốt, hơi dẻo.'},
            {id:'abs',   name:'ABS',   desc:'Chịu nhiệt, gia công và sơn dễ.'},
            {id:'asa',   name:'ASA',   desc:'Chịu nắng mưa, dùng ngoài trời.'},
            {id:'tpu',   name:'TPU',   desc:'Dẻo như cao su, làm ron, vỏ bọc.'},
            {id:'nylon', name:'Nylon', desc:'Dai, chịu mài mòn cho chi tiết cơ khí.'},
            {id:'pc',    name:'PC',    desc:'Cứng và chịu nhiệt cao.'}
        ]
    },
    {
        id:'sla', name:'SLA', tagline:'Resin',
        desc:'Mô hình cần độ chi tiết cao và bề mặt mịn.',
        build:{x:145,y:145,z:175}, quality:'resin', materials:'resin'
    },
    {
        id:'msla', name:'MSLA', tagline:'Resin',
        desc:'Chi tiết cao, chi phí hợp lý cho mô hình nhỏ và vừa.',
        build:{x:218,y:123,z:230}, quality:'resin', materials:'resin'
    },
    {
        id:'dlp', name:'DLP', tagline:'Resin',
        desc:'Bề mặt mịn, in nhanh cho chi tiết nhỏ chính xác.',
        build:{x:192,y:120,z:280}, quality:'resin', materials:'resin'
    },
    {
        id:'sls', name:'SLS', tagline:'Bột nylon',
        desc:'Hình dạng phức tạp, không cần support truyền thống.',
        build:{x:300,y:300,z:300}, quality:'powder',
        materials:[
            {id:'pa12', name:'Nylon PA12', desc:'Bền, ổn định — lựa chọn mặc định của SLS.'},
            {id:'pa11', name:'PA11',       desc:'Dai hơn PA12, chịu va đập tốt.'},
            {id:'pa12gf', name:'PA12-GF',  desc:'Pha sợi thuỷ tinh, cứng và ổn định nhiệt.'}
        ]
    },
    {
        id:'mjf', name:'MJF', tagline:'Sản xuất loạt',
        desc:'Chi tiết có độ bền và độ đồng nhất cao, hợp sản xuất số lượng.',
        build:{x:380,y:284,z:380}, quality:'powder',
        materials:[
            {id:'mjf-pa12', name:'PA12',      desc:'Chi tiết chức năng, bền và đồng nhất.'},
            {id:'mjf-pa11', name:'PA11',      desc:'Dẻo dai hơn, chịu va đập.'},
            {id:'mjf-tpu',  name:'TPU',       desc:'Đàn hồi — tuỳ khả năng của xưởng.'}
        ]
    }
];

const RESIN_MATERIALS = [
    {id:'std-resin',  name:'Standard Resin',    desc:'Mô hình trưng bày, chi tiết sắc nét.'},
    {id:'tough-resin',name:'Tough Resin',       desc:'Chịu lực tốt hơn, ít giòn.'},
    {id:'abs-resin',  name:'ABS-like Resin',    desc:'Tính chất gần ABS, dùng cho chi tiết chức năng.'},
    {id:'flex-resin', name:'Flexible Resin',    desc:'Dẻo, đàn hồi nhẹ.'},
    {id:'eng-resin',  name:'Engineering Resin', desc:'Chịu nhiệt và tải cho chi tiết kỹ thuật.'}
];

const COLORS = [
    {id:'black', name:'Đen',     hex:'#1A1A1A'},
    {id:'white', name:'Trắng',   hex:'#F5F5F5'},
    {id:'gray',  name:'Xám',     hex:'#8A8A99'},
    {id:'red',   name:'Đỏ',      hex:'#E03131'},
    {id:'blue',  name:'Xanh dương', hex:'#1C7ED6'},
    {id:'yellow',name:'Vàng',    hex:'#FAB005'},
    {id:'orange',name:'Cam',     hex:'#FD7E14'},
    {id:'green', name:'Xanh lá', hex:'#2F9E44'}
];

const POST_OPTIONS = [
    {id:'none',    name:'Không xử lý', desc:'Giữ nguyên sau khi in, làm sạch cơ bản.', exclusive:true},
    {id:'sanding', name:'Chà nhám',    desc:'Làm mịn bề mặt bằng sanding.'},
    {id:'paint',   name:'Sơn màu',     desc:'Sơn theo màu bạn chọn.'},
    {id:'gloss',   name:'Sơn bóng',    desc:'Hoàn thiện bề mặt bóng.'},
    {id:'matte',   name:'Sơn mờ',      desc:'Hoàn thiện bề mặt matte.'},
    {id:'polish',  name:'Đánh bóng',   desc:'Tăng độ mịn và độ bóng.'},
    {id:'special', name:'Xử lý đặc biệt', desc:'Mô tả trong ghi chú, xưởng báo giá riêng.'}
];

const TOLERANCES = [
    {id:'std',  name:'Tiêu chuẩn', value:0.3, desc:'Đủ cho hầu hết mô hình và đồ dùng.'},
    {id:'high', name:'Cao',        value:0.2, desc:'Chi tiết cần lắp ghép với nhau.'},
    {id:'vhigh',name:'Rất cao',    value:0.1, desc:'Chi tiết kỹ thuật, dung sai chặt.'},
    {id:'custom',name:'Dung sai riêng', value:null, desc:'Tự nhập mức dung sai bạn cần.'}
];

const ACCEPTED_EXT = ['stl','obj','3mf','step','stp'];
const PREVIEWABLE  = ['stl','obj'];
const MAX_SIZE_MB  = 60;

/* ============================================================
   2. TRẠNG THÁI
   ============================================================ */
const state = {
    file:null, ext:'', previewable:false,
    base:null,            // {x,y,z} mm gốc từ file
    volume:null,          // cm³ gốc
    sizeMode:'default',
    scale:100,
    custom:{x:null,y:null,z:null},
    lockRatio:true,
    qty:1,
    tech:'fdm', material:'pla',
    colorId:'black', colorHex:'#1A1A1A', colorName:'Đen', refImage:null,
    quality:'normal',
    post:['none'],
    tol:'std', tolCustom:null,
    notes:''
};

const $ = (id) => document.getElementById(id);

/* ============================================================
   3. TIỆN ÍCH  (toast / toastOk / toastErr lấy từ printkraft.js)
   ============================================================ */
const fmt = n => (Math.round(n * 10) / 10).toLocaleString('vi-VN');
const fileSize = b => b < 1024*1024 ? (b/1024).toFixed(0) + ' KB' : (b/1024/1024).toFixed(1) + ' MB';
const getTech = () => TECHNOLOGIES.find(t => t.id === state.tech);
const getMaterials = () => {
    const t = getTech();
    return t.materials === 'resin' ? RESIN_MATERIALS : t.materials;
};
const getQualities = () => QUALITY_SETS[getTech().quality];
const matName = () => (getMaterials().find(m => m.id === state.material) || {}).name || '—';

/** Kích thước cuối cùng sau khi áp size mode */
function finalSize(){
    if(!state.base) return null;
    if(state.sizeMode === 'scale'){
        const k = (state.scale || 100) / 100;
        return {x:state.base.x*k, y:state.base.y*k, z:state.base.z*k, k};
    }
    if(state.sizeMode === 'custom' && state.custom.x && state.custom.y && state.custom.z){
        return {x:state.custom.x, y:state.custom.y, z:state.custom.z, k:state.custom.x/state.base.x};
    }
    return {x:state.base.x, y:state.base.y, z:state.base.z, k:1};
}
function finalVolume(){
    const s = finalSize();
    if(!s || state.volume == null) return null;
    return state.volume * Math.pow(s.k || 1, 3);
}

/* ============================================================
   4. PARSER FILE 3D (STL nhị phân / ASCII, OBJ)
   ============================================================ */
function parseSTL(buffer){
    const view = new DataView(buffer);
    const isBinary = (() => {
        if(buffer.byteLength < 84) return false;
        const tris = view.getUint32(80, true);
        if(84 + tris * 50 === buffer.byteLength) return true;
        const head = new TextDecoder().decode(new Uint8Array(buffer, 0, 5)).toLowerCase();
        return head !== 'solid';
    })();

    const verts = [];
    if(isBinary){
        const tris = view.getUint32(80, true);
        let off = 84;
        for(let i=0; i<tris; i++){
            off += 12; // bỏ normal
            for(let v=0; v<3; v++){
                verts.push(view.getFloat32(off, true), view.getFloat32(off+4, true), view.getFloat32(off+8, true));
                off += 12;
            }
            off += 2;
        }
    } else {
        const text = new TextDecoder().decode(new Uint8Array(buffer));
        const re = /vertex\s+([-\d.eE+]+)\s+([-\d.eE+]+)\s+([-\d.eE+]+)/g;
        let m;
        while((m = re.exec(text)) !== null) verts.push(+m[1], +m[2], +m[3]);
    }
    if(verts.length < 9) throw new Error('empty');
    return new Float32Array(verts);
}

function parseOBJ(buffer){
    const text = new TextDecoder().decode(new Uint8Array(buffer));
    const pts = [], out = [];
    const lines = text.split('\n');
    for(const raw of lines){
        const line = raw.trim();
        if(line.startsWith('v ')){
            const p = line.split(/\s+/);
            pts.push([+p[1], +p[2], +p[3]]);
        } else if(line.startsWith('f ')){
            const idx = line.split(/\s+/).slice(1).map(tok => {
                let i = parseInt(tok.split('/')[0], 10);
                return i < 0 ? pts.length + i : i - 1;
            }).filter(i => !isNaN(i) && pts[i]);
            for(let i=1; i<idx.length-1; i++){           // fan-triangulate
                [idx[0], idx[i], idx[i+1]].forEach(k => out.push(pts[k][0], pts[k][1], pts[k][2]));
            }
        }
    }
    if(out.length < 9) throw new Error('empty');
    return new Float32Array(out);
}

/** Thể tích mesh (mm³) bằng tổng tetrahedron có dấu */
function meshVolume(pos){
    let v = 0;
    for(let i=0; i<pos.length; i+=9){
        const ax=pos[i],   ay=pos[i+1], az=pos[i+2];
        const bx=pos[i+3], by=pos[i+4], bz=pos[i+5];
        const cx=pos[i+6], cy=pos[i+7], cz=pos[i+8];
        v += (ax*(by*cz - bz*cy) - ay*(bx*cz - bz*cx) + az*(bx*cy - by*cx)) / 6;
    }
    return Math.abs(v);
}

/* ============================================================
   5. VIEWER 3D (Three.js + điều khiển tự viết)
   ============================================================ */
const Viewer = (() => {
    const stage = $('stage');
    let renderer, scene, camera, mesh, raf = null, ready = false;
    let spin = false;
    const cam = {theta:-0.9, phi:1.05, dist:3, target:new THREE.Vector3()};
    let radius = 1;

    function init(){
        if(ready || typeof THREE === 'undefined') return ready;
        renderer = new THREE.WebGLRenderer({antialias:true, alpha:true});
        renderer.setPixelRatio(Math.min(devicePixelRatio, 2));
        renderer.setSize(stage.clientWidth, stage.clientHeight);
        stage.appendChild(renderer.domElement);

        scene = new THREE.Scene();
        camera = new THREE.PerspectiveCamera(42, stage.clientWidth/stage.clientHeight, 0.01, 5000);

        scene.add(new THREE.HemisphereLight(0xffffff, 0xC8C2E8, 0.95));
        const key = new THREE.DirectionalLight(0xffffff, 0.85); key.position.set(1.4, 2, 1.6); scene.add(key);
        const rim = new THREE.DirectionalLight(0xA29BFE, 0.5);  rim.position.set(-2, 1, -1.4);  scene.add(rim);

        bindControls();
        new ResizeObserver(resize).observe(stage);
        ready = true;
        return true;
    }

    function resize(){
        if(!renderer) return;
        const w = stage.clientWidth, h = stage.clientHeight;
        if(!w || !h) return;
        renderer.setSize(w, h);
        camera.aspect = w/h; camera.updateProjectionMatrix();
        render();
    }

    function bindControls(){
        const el = renderer.domElement;
        let drag = null;
        const pos = e => ({x:e.touches ? e.touches[0].clientX : e.clientX, y:e.touches ? e.touches[0].clientY : e.clientY});

        const down = e => {
            if(e.touches && e.touches.length === 2){ drag = {pinch:pinchDist(e)}; return; }
            const p = pos(e); drag = {x:p.x, y:p.y, pan:e.shiftKey || e.button === 2};
        };
        const move = e => {
            if(!drag || !mesh) return;
            if(e.touches && e.touches.length === 2 && drag.pinch){
                const d = pinchDist(e);
                cam.dist *= drag.pinch / d; clampDist(); drag.pinch = d; render(); e.preventDefault(); return;
            }
            const p = pos(e), dx = p.x - drag.x, dy = p.y - drag.y;
            if(drag.pan){
                const s = cam.dist * 0.0016;
                const right = new THREE.Vector3().subVectors(camera.position, cam.target).cross(camera.up).normalize();
                cam.target.addScaledVector(right, -dx * s);
                cam.target.addScaledVector(camera.up, dy * s);
            } else {
                cam.theta -= dx * 0.008;
                cam.phi = Math.max(0.08, Math.min(Math.PI - 0.08, cam.phi - dy * 0.008));
            }
            drag.x = p.x; drag.y = p.y;
            render(); e.preventDefault();
        };
        const up = () => { drag = null; };
        const pinchDist = e => Math.hypot(e.touches[0].clientX - e.touches[1].clientX, e.touches[0].clientY - e.touches[1].clientY);

        el.addEventListener('mousedown', down);
        window.addEventListener('mousemove', move);
        window.addEventListener('mouseup', up);
        el.addEventListener('touchstart', down, {passive:false});
        el.addEventListener('touchmove', move, {passive:false});
        el.addEventListener('touchend', up);
        el.addEventListener('contextmenu', e => e.preventDefault());
        el.addEventListener('wheel', e => {
            if(!mesh) return;
            cam.dist *= e.deltaY > 0 ? 1.1 : 0.9; clampDist(); render(); e.preventDefault();
        }, {passive:false});
    }

    const clampDist = () => { cam.dist = Math.max(radius*1.2, Math.min(radius*14, cam.dist)); };

    function render(){
        if(!renderer || !scene) return;
        const s = Math.sin(cam.phi), c = Math.cos(cam.phi);
        camera.position.set(
            cam.target.x + cam.dist * s * Math.sin(cam.theta),
            cam.target.y + cam.dist * c,
            cam.target.z + cam.dist * s * Math.cos(cam.theta)
        );
        camera.lookAt(cam.target);
        renderer.render(scene, camera);
    }

    function loop(){
        if(!spin){ raf = null; return; }
        cam.theta += 0.006; render();
        raf = requestAnimationFrame(loop);
    }

    return {
        available: () => typeof THREE !== 'undefined',
        show(positions, colorHex){
            if(!init()) return false;
            this.clear();
            const geo = new THREE.BufferGeometry();
            geo.setAttribute('position', new THREE.BufferAttribute(positions, 3));
            geo.computeVertexNormals();
            geo.computeBoundingBox();
            const box = geo.boundingBox;
            const center = new THREE.Vector3(); box.getCenter(center);
            geo.translate(-center.x, -center.y, -center.z);

            const size = new THREE.Vector3(); box.getSize(size);
            radius = Math.max(size.x, size.y, size.z) || 1;

            const mat = new THREE.MeshStandardMaterial({
                color:new THREE.Color(colorHex || '#6C5CE7'), roughness:0.55, metalness:0.08, flatShading:false
            });
            mesh = new THREE.Mesh(geo, mat);
            scene.add(mesh);

            const grid = new THREE.GridHelper(radius*3, 14, 0xC9C3E8, 0xE6E2F5);
            grid.position.y = -size.y/2 - radius*0.02;
            grid.name = 'grid';
            scene.add(grid);

            this.reset();
            return true;
        },
        setColor(hex){ if(mesh) { mesh.material.color.set(hex); render(); } },
        reset(){
            cam.theta = -0.9; cam.phi = 1.05; cam.dist = radius * 2.6;
            cam.target.set(0,0,0); render();
        },
        top(){ cam.theta = 0; cam.phi = 0.2; render(); },
        zoom(f){ if(!mesh) return; cam.dist *= f; clampDist(); render(); },
        toggleSpin(){
            spin = !spin;
            if(spin && !raf) raf = requestAnimationFrame(loop);
            return spin;
        },
        clear(){
            spin = false; if(raf){ cancelAnimationFrame(raf); raf = null; }
            if(!scene) return;
            [mesh, scene.getObjectByName('grid')].forEach(o => {
                if(!o) return;
                scene.remove(o);
                if(o.geometry) o.geometry.dispose();
                if(o.material) o.material.dispose();
            });
            mesh = null;
            if(renderer) renderer.clear();
        }
    };
})();

/* ============================================================
   6. RENDER CÁC NHÓM LỰA CHỌN
   ============================================================ */
function optCard(active, title, sub, desc, square){
    return `<span class="radio${square ? ' sq' : ''}"></span>
    <span class="oc-body"><strong>${title}</strong>${sub ? `<em>${sub}</em>` : ''}${desc ? `<span>${desc}</span>` : ''}</span>`;
}

function renderTech(){
    $('techList').innerHTML = TECHNOLOGIES.map(t => `
    <button type="button" class="opt-card ${t.id === state.tech ? 'active' : ''}" data-tech="${t.id}">
      ${optCard(true, t.name, t.tagline, t.desc)}
    </button>`).join('');
    $('techList').querySelectorAll('[data-tech]').forEach(b => {
        b.onclick = () => {
            if(state.tech === b.dataset.tech) return;
            state.tech = b.dataset.tech;
            const mats = getMaterials();
            state.material = mats[0].id;                              // vật liệu đổi theo công nghệ
            const qs = getQualities();
            state.quality = (qs.find(q => q.id === state.quality) || qs[Math.min(1, qs.length-1)]).id;
            renderTech(); renderMaterials(); renderQuality(); update();
        };
    });
}

function renderMaterials(){
    const mats = getMaterials();
    $('materialList').innerHTML = mats.map(m => `
    <button type="button" class="opt-card ${m.id === state.material ? 'active' : ''}" data-mat="${m.id}">
      ${optCard(true, m.name, '', m.desc)}
    </button>`).join('');
    $('materialList').querySelectorAll('[data-mat]').forEach(b => {
        b.onclick = () => { state.material = b.dataset.mat; renderMaterials(); update(); };
    });
    const t = getTech();
    $('materialNote').textContent = t.materials === 'resin'
        ? 'Danh sách resin dùng chung cho SLA, MSLA và DLP. Cần loại resin đặc thù? Ghi trong yêu cầu đặc biệt.'
        : (t.quality === 'powder'
            ? 'Vật liệu bột phụ thuộc máy của từng xưởng — xưởng sẽ xác nhận khi nhận đơn.'
            : 'Chưa thấy vật liệu bạn cần? Ghi rõ trong phần yêu cầu đặc biệt.');
}

function renderQuality(){
    const qs = getQualities();
    $('qualityList').innerHTML = qs.map(q => `
    <button type="button" class="opt-card ${q.id === state.quality ? 'active' : ''}" data-q="${q.id}">
      ${optCard(true, q.name, q.layer.toFixed(2) + ' mm', q.desc)}
    </button>`).join('');
    $('qualityList').querySelectorAll('[data-q]').forEach(b => {
        b.onclick = () => { state.quality = b.dataset.q; renderQuality(); update(); };
    });
    const set = getTech().quality;
    $('qualitySub').textContent = set === 'resin'
        ? 'Với công nghệ resin, độ dày lớp nhỏ hơn nhiều so với FDM nên chi tiết mịn hơn hẳn.'
        : set === 'powder'
            ? 'Độ dày lớp của SLS/MJF cố định theo máy, chủ yếu ảnh hưởng tới bề mặt chi tiết nhỏ.'
            : 'Lớp in càng mỏng, chi tiết càng mịn — thời gian in và chi phí cũng tăng theo.';
}

function renderColors(){
    $('swatches').innerHTML = COLORS.map(c => `
    <button type="button" class="swatch ${c.id === state.colorId ? 'active' : ''}"
      data-color="${c.id}" style="background:${c.hex}" title="${c.name}" aria-label="${c.name}"></button>`).join('');
    $('swatches').querySelectorAll('[data-color]').forEach(b => {
        b.onclick = () => {
            const c = COLORS.find(x => x.id === b.dataset.color);
            state.colorId = c.id; state.colorHex = c.hex; state.colorName = c.name;
            $('colorPicker').value = c.hex; $('colorHex').value = c.hex.toUpperCase();
            renderColors(); Viewer.setColor(c.hex); update();
        };
    });
}

function renderPost(){
    $('postList').innerHTML = POST_OPTIONS.map(p => `
    <button type="button" class="opt-card ${state.post.includes(p.id) ? 'active' : ''}" data-post="${p.id}">
      ${optCard(true, p.name, '', p.desc, true)}
    </button>`).join('');
    $('postList').querySelectorAll('[data-post]').forEach(b => {
        b.onclick = () => {
            const id = b.dataset.post;
            if(id === 'none'){ state.post = ['none']; }
            else {
                state.post = state.post.filter(x => x !== 'none');
                state.post.includes(id) ? state.post = state.post.filter(x => x !== id) : state.post.push(id);
                if(!state.post.length) state.post = ['none'];
            }
            renderPost(); update();
        };
    });
}

function renderTol(){
    $('tolList').innerHTML = TOLERANCES.map(t => `
    <button type="button" class="opt-card ${t.id === state.tol ? 'active' : ''}" data-tol="${t.id}">
      ${optCard(true, t.name, t.value ? '±' + t.value.toFixed(1) + ' mm' : '', t.desc)}
    </button>`).join('');
    $('tolList').querySelectorAll('[data-tol]').forEach(b => {
        b.onclick = () => {
            state.tol = b.dataset.tol;
            $('tolCustom').disabled = state.tol !== 'custom';
            if(state.tol === 'custom') $('tolCustom').focus();
            renderTol(); update();
        };
    });
}

function tolText(){
    if(state.tol === 'custom') return state.tolCustom ? '±' + state.tolCustom + ' mm' : 'Chưa nhập';
    const t = TOLERANCES.find(x => x.id === state.tol);
    return '±' + t.value.toFixed(1) + ' mm';
}
function postText(){
    return state.post.map(id => POST_OPTIONS.find(p => p.id === id).name).join(', ');
}
function qualityText(){
    const q = getQualities().find(x => x.id === state.quality);
    return q ? `${q.name} – ${q.layer.toFixed(2)} mm` : '—';
}

/* ============================================================
   7. XỬ LÝ FILE
   ============================================================ */
function handleFile(file){
    const ext = (file.name.split('.').pop() || '').toLowerCase();
    if(!ACCEPTED_EXT.includes(ext)){
        toastErr('Định dạng file không được hỗ trợ.');
        return;
    }
    if(file.size > MAX_SIZE_MB * 1024 * 1024){
        toastErr(`Dung lượng file vượt quá giới hạn ${MAX_SIZE_MB} MB.`);
        return;
    }

    state.file = file; state.ext = ext;
    state.previewable = PREVIEWABLE.includes(ext) && Viewer.available();

    $('fileCard').style.display = 'flex';
    $('fileExt').textContent = ext.toUpperCase();
    $('fileName').textContent = file.name;
    $('fileMeta').textContent = `${ext.toUpperCase()} · ${fileSize(file.size)}`;
    $('dropzone').querySelector('h4').textContent = 'Đổi mô hình khác';
    $('dropzone').querySelector('p').textContent = 'Tải file mới để thay thế mô hình hiện tại. Kích thước và thể tích sẽ được tính lại.';

    if(!state.previewable){
        state.base = null; state.volume = null;
        Viewer.clear();
        $('stageEmpty').style.display = 'flex';
        $('stageEmpty').querySelector('h4').textContent = 'Chưa xem trước được định dạng này';
        $('stageEmpty').querySelector('p').textContent = ext.toUpperCase() + ' cần xưởng mở bằng phần mềm CAD. Bạn nhập kích thước mong muốn ở mục “Kích thước sản phẩm”.';
        $('stageBadge').textContent = 'Không có preview';
        state.sizeMode = 'custom';
        syncSizeMode();
        toolsEnabled(false);
        update();
        return;
    }

    const reader = new FileReader();
    reader.onload = e => {
        try{
            const pos = ext === 'stl' ? parseSTL(e.target.result) : parseOBJ(e.target.result);

            let minX=Infinity,minY=Infinity,minZ=Infinity,maxX=-Infinity,maxY=-Infinity,maxZ=-Infinity;
            for(let i=0; i<pos.length; i+=3){
                if(pos[i]<minX) minX=pos[i];     if(pos[i]>maxX) maxX=pos[i];
                if(pos[i+1]<minY) minY=pos[i+1]; if(pos[i+1]>maxY) maxY=pos[i+1];
                if(pos[i+2]<minZ) minZ=pos[i+2]; if(pos[i+2]>maxZ) maxZ=pos[i+2];
            }
            // STL/OBJ không có đơn vị — quy ước 1 unit = 1 mm như đa số phần mềm CAD
            state.base = {x:maxX-minX, y:maxY-minY, z:maxZ-minZ};
            state.volume = meshVolume(pos) / 1000;   // mm³ → cm³
            state.triangles = pos.length / 9;

            const ok = Viewer.show(pos, state.colorHex);
            $('stageEmpty').style.display = ok ? 'none' : 'flex';
            $('stageHint').style.display = ok ? 'block' : 'none';
            $('stage').classList.toggle('loaded', ok);
            $('stageBadge').textContent = ok ? state.triangles.toLocaleString('vi-VN') + ' tam giác' : 'Không hiển thị được';
            toolsEnabled(ok);

            state.custom = {x:+state.base.x.toFixed(1), y:+state.base.y.toFixed(1), z:+state.base.z.toFixed(1)};
            $('cusX').value = state.custom.x; $('cusY').value = state.custom.y; $('cusZ').value = state.custom.z;
            state.sizeMode = 'default'; state.scale = 100; $('scaleInput').value = 100;
            syncSizeMode();
            update();
            toastOk('Đã tải mô hình lên');
        } catch(err){
            state.base = null; state.volume = null;
            Viewer.clear();
            $('stageEmpty').style.display = 'flex';
            $('stageEmpty').querySelector('h4').textContent = 'Không đọc được file';
            $('stageEmpty').querySelector('p').textContent = 'File có thể bị lỗi hoặc rỗng. Thử xuất lại từ phần mềm thiết kế rồi tải lên lần nữa.';
            $('stageBadge').textContent = 'Lỗi đọc file';
            toolsEnabled(false);
            state.sizeMode = 'custom'; syncSizeMode();
            update();
            toastErr('Không đọc được nội dung mô hình.');
        }
    };
    reader.onerror = () => toastErr('Không đọc được file. Thử lại nhé.');
    reader.readAsArrayBuffer(file);
}

function clearFile(){
    state.file = null; state.ext = ''; state.base = null; state.volume = null;
    state.custom = {x:null,y:null,z:null}; state.sizeMode = 'default'; state.scale = 100;
    Viewer.clear();
    $('fileCard').style.display = 'none';
    $('fileInput').value = '';
    $('stage').classList.remove('loaded');
    $('stageEmpty').style.display = 'flex';
    $('stageEmpty').querySelector('h4').textContent = 'Chưa có mô hình để hiển thị';
    $('stageEmpty').querySelector('p').textContent = 'Tải file 3D ở cột bên phải để xem trước, đo kích thước và thể tích.';
    $('stageHint').style.display = 'none';
    $('stageBadge').textContent = 'Chưa có mô hình';
    $('dropzone').querySelector('h4').textContent = 'Tải lên mô hình 3D';
    $('dropzone').querySelector('p').textContent = 'Kéo thả file vào đây, hoặc chọn file từ máy để bắt đầu đặt in.';
    $('cusX').value = ''; $('cusY').value = ''; $('cusZ').value = '';
    $('scaleInput').value = 100;
    toolsEnabled(false);
    syncSizeMode();
    update();
}

function toolsEnabled(on){
    ['btnSpin','btnZoomIn','btnZoomOut','btnTop','btnReset'].forEach(id => $(id).disabled = !on);
    if(!on) $('btnSpin').classList.remove('on');
}

/* ============================================================
   8. KIỂM TRA MÔ HÌNH
   ============================================================ */
function runChecks(){
    const rows = [];
    if(!state.file){
        rows.push({t:'', ic:'·', m:'Chưa có file để kiểm tra.'});
    } else {
        rows.push({t:'ok', ic:'✓', m:`Đọc được file ${state.ext.toUpperCase()} (${fileSize(state.file.size)}).`});

        if(!state.previewable){
            rows.push({t:'warn', ic:'⚠', m:'Định dạng này cần xưởng mở bằng CAD — chưa kiểm tra tự động được kích thước.'});
        } else if(!state.base){
            rows.push({t:'err', ic:'✕', m:'Không đọc được hình học trong file.'});
        } else {
            const s = finalSize(), b = getTech().build;
            const over = s.x > b.x || s.y > b.y || s.z > b.z;
            rows.push(over
                ? {t:'err', ic:'✕', m:`Mô hình ${fmt(s.x)}×${fmt(s.y)}×${fmt(s.z)} mm vượt vùng in ${b.x}×${b.y}×${b.z} mm của ${getTech().name}. Thu nhỏ lại, đổi công nghệ, hoặc để xưởng cắt ghép.`}
                : {t:'ok', ic:'✓', m:`Kích thước nằm trong vùng in ${b.x}×${b.y}×${b.z} mm của ${getTech().name}.`});

            const min = Math.min(s.x, s.y, s.z);
            const layer = (getQualities().find(q => q.id === state.quality) || {}).layer || 0.2;
            if(min < layer * 6){
                rows.push({t:'warn', ic:'⚠', m:`Chi tiết mỏng nhất khoảng ${fmt(min)} mm — khá mỏng so với lớp in ${layer} mm, có thể gãy khi in.`});
            }
            if(state.volume != null && state.volume < 0.01){
                rows.push({t:'warn', ic:'⚠', m:'Thể tích rất nhỏ — kiểm tra lại đơn vị của file (có thể file đang ở cm hoặc inch).'});
            }
            if(state.triangles && state.triangles < 60){
                rows.push({t:'warn', ic:'⚠', m:'Lưới mô hình khá thô, bề mặt cong có thể bị gãy khúc khi in.'});
            }
            if(rows.every(r => r.t === 'ok')){
                rows.push({t:'ok', ic:'✓', m:'Mô hình hợp lệ, sẵn sàng gửi xưởng kiểm tra chi tiết.'});
            }
        }
    }
    $('checkList').innerHTML = rows.map(r => `
    <div class="check-row ${r.t}"><span class="ic">${r.ic}</span><span>${r.m}</span></div>`).join('');
    return rows;
}

/* ============================================================
   9. CẬP NHẬT GIAO DIỆN
   ============================================================ */
function syncSizeMode(){
    $('sizeModes').querySelectorAll('.chip').forEach(c => c.classList.toggle('active', c.dataset.mode === state.sizeMode));
    $('sizeDefault').style.display = state.sizeMode === 'default' ? 'block' : 'none';
    $('sizeScale').style.display   = state.sizeMode === 'scale'   ? 'block' : 'none';
    $('sizeCustom').style.display  = state.sizeMode === 'custom'  ? 'block' : 'none';
}

function update(){
    const s = finalSize(), v = finalVolume();

    // kích thước hiển thị
    $('dimX').textContent = s ? fmt(s.x) + ' mm' : '—';
    $('dimY').textContent = s ? fmt(s.y) + ' mm' : '—';
    $('dimZ').textContent = s ? fmt(s.z) + ' mm' : '—';
    $('dimV').textContent = v != null ? fmt(v) + ' cm³' : '—';

    $('defX').value = state.base ? fmt(state.base.x) + ' mm' : '—';
    $('defY').value = state.base ? fmt(state.base.y) + ' mm' : '—';
    $('defZ').value = state.base ? fmt(state.base.z) + ' mm' : '—';
    $('scaleResult').textContent = (state.base && state.sizeMode === 'scale')
        ? `${fmt(s.x)} × ${fmt(s.y)} × ${fmt(s.z)} mm` : '—';
    $('scalePresets').querySelectorAll('.chip').forEach(c => c.classList.toggle('active', +c.dataset.scale === +state.scale));

    // tổng quan
    $('sModel').textContent = state.file ? state.file.name : 'Chưa tải file';
    $('sModel').className = state.file ? '' : 'muted';
    $('sQty').textContent = state.qty;
    $('sSize').textContent = s ? `${fmt(s.x)} × ${fmt(s.y)} × ${fmt(s.z)} mm` : '—';
    $('sSize').className = s ? '' : 'muted';
    $('sTech').textContent = getTech().name;
    $('sMat').textContent = matName();
    $('sColor').innerHTML = `<i class="sum-dot" style="background:${state.colorHex}"></i>${state.colorName}`;
    $('sQuality').textContent = qualityText();
    $('sPost').textContent = postText();
    $('sPost').className = state.post[0] === 'none' && state.post.length === 1 ? 'muted' : '';
    $('sTol').textContent = tolText();

    // giá dự kiến
    $('pMat').textContent = v != null ? `${matName()} · ~${fmt(v * state.qty)} cm³` : matName();
    $('pTime').textContent = qualityText();
    $('pPost').textContent = postText();
    $('pQty').textContent = '× ' + state.qty;

    runChecks();
}

/* ============================================================
   10. VALIDATION + GỬI ĐƠN
   ============================================================ */
function validate(){
    const errs = [];
    if(!state.file) errs.push('Vui lòng tải mô hình 3D trước khi tiếp tục.');
    if(!(state.qty >= 1)) errs.push('Số lượng phải lớn hơn hoặc bằng 1.');

    const s = finalSize();
    if(state.sizeMode === 'custom' && state.file){
        if(!(state.custom.x > 0 && state.custom.y > 0 && state.custom.z > 0))
            errs.push('Kích thước X, Y, Z phải lớn hơn 0.');
    }
    if(state.sizeMode === 'scale' && !(state.scale > 0)) errs.push('Tỷ lệ phóng phải lớn hơn 0.');
    if(!state.tech) errs.push('Vui lòng chọn công nghệ in.');
    if(!state.material) errs.push('Vui lòng chọn vật liệu.');
    if(!state.quality) errs.push('Vui lòng chọn chất lượng bề mặt.');
    if(state.tol === 'custom' && !(state.tolCustom > 0)) errs.push('Vui lòng nhập mức dung sai lớn hơn 0.');

    if(s){
        const b = getTech().build;
        if(s.x > b.x || s.y > b.y || s.z > b.z)
            errs.push(`Cấu hình hiện tại có thể không phù hợp với mô hình: kích thước vượt vùng in của ${getTech().name}. Chọn công nghệ khác, thu nhỏ mô hình, hoặc để xưởng kiểm tra.`);
    }
    return errs;
}

function submit(e){
    e.preventDefault();
    const errs = validate();
    const box = $('formError');
    if(errs.length){
        box.className = 'form-error show';
        box.innerHTML = `<strong>Cần bổ sung trước khi gửi yêu cầu:</strong><ul>${errs.map(x => `<li>${x}</li>`).join('')}</ul>`;
        box.scrollIntoView({behavior:'smooth', block:'center'});
        toastErr(errs[0]);
        return;
    }
    box.className = 'form-error';

    const s = finalSize();
    $('orderCode').textContent = '#3D-' + Math.floor(100000 + Math.random()*900000);
    $('confirmSummary').innerHTML = [
        ['Mô hình', state.file.name],
        ['Số lượng', state.qty],
        ['Kích thước', s ? `${fmt(s.x)} × ${fmt(s.y)} × ${fmt(s.z)} mm` : 'Xưởng xác nhận'],
        ['Công nghệ', getTech().name],
        ['Vật liệu', matName()],
        ['Màu', state.colorName],
        ['Chất lượng', qualityText()],
        ['Xử lý bề mặt', postText()],
        ['Dung sai', tolText()]
    ].map(([k,v]) => `<div class="sum-row"><span>${k}</span><b>${v}</b></div>`).join('');

    $('confirmModal').classList.add('show');
    toastOk('Đã gửi yêu cầu in');
}

function saveConfig(){
    const data = {...state, file: state.file ? state.file.name : null, refImage: null};
    try{ localStorage.setItem('printkraft:3d-config', JSON.stringify(data)); } catch(err){ /* bỏ qua */ }
    toastOk('Đã lưu cấu hình vào tài khoản của bạn');
}

/* ============================================================
   11. GẮN SỰ KIỆN
   ============================================================ */
// Upload
$('dropzone').onclick = () => $('fileInput').click();
$('dropzone').onkeydown = e => { if(e.key === 'Enter' || e.key === ' '){ e.preventDefault(); $('fileInput').click(); } };
$('fileInput').onchange = e => { if(e.target.files[0]) handleFile(e.target.files[0]); };
['dragenter','dragover'].forEach(ev => $('dropzone').addEventListener(ev, e => {
    e.preventDefault(); $('dropzone').classList.add('drag');
}));
['dragleave','drop'].forEach(ev => $('dropzone').addEventListener(ev, e => {
    e.preventDefault(); $('dropzone').classList.remove('drag');
}));
$('dropzone').addEventListener('drop', e => { if(e.dataTransfer.files[0]) handleFile(e.dataTransfer.files[0]); });
$('btnReplace').onclick = () => $('fileInput').click();
$('btnRemove').onclick = () => { clearFile(); toast('Đã xoá mô hình'); };

// Viewer tools
$('btnSpin').onclick    = e => e.currentTarget.classList.toggle('on', Viewer.toggleSpin());
$('btnZoomIn').onclick  = () => Viewer.zoom(0.85);
$('btnZoomOut').onclick = () => Viewer.zoom(1.18);
$('btnTop').onclick     = () => Viewer.top();
$('btnReset').onclick   = () => Viewer.reset();

// Số lượng
const setQty = n => {
    state.qty = Math.max(1, Math.floor(n || 1));
    $('qtyInput').value = state.qty;
    update();
};
$('qtyMinus').onclick = () => setQty(state.qty - 1);
$('qtyPlus').onclick  = () => setQty(state.qty + 1);
$('qtyInput').oninput = e => { const v = parseInt(e.target.value, 10); if(v >= 1) { state.qty = v; update(); } };
$('qtyInput').onblur  = e => setQty(parseInt(e.target.value, 10));

// Kích thước
$('sizeModes').querySelectorAll('.chip').forEach(c => {
    c.onclick = () => { state.sizeMode = c.dataset.mode; syncSizeMode(); update(); };
});
$('scaleInput').oninput = e => { state.scale = parseFloat(e.target.value) || 0; update(); };
$('scalePresets').querySelectorAll('.chip').forEach(c => {
    c.onclick = () => { state.scale = +c.dataset.scale; $('scaleInput').value = state.scale; update(); };
});
$('lockRatio').onchange = e => state.lockRatio = e.target.checked;

['x','y','z'].forEach(axis => {
    const el = $('cus' + axis.toUpperCase());
    el.oninput = e => {
        const v = parseFloat(e.target.value);
        state.custom[axis] = v > 0 ? v : null;
        if(state.lockRatio && state.base && v > 0){
            const k = v / state.base[axis];
            ['x','y','z'].forEach(other => {
                if(other === axis) return;
                state.custom[other] = +(state.base[other] * k).toFixed(1);
                $('cus' + other.toUpperCase()).value = state.custom[other];
            });
        }
        update();
    };
});

// Màu
$('colorPicker').oninput = e => setCustomColor(e.target.value);
$('colorHex').oninput = e => {
    let v = e.target.value.trim();
    if(!v.startsWith('#')) v = '#' + v;
    if(/^#[0-9a-fA-F]{6}$/.test(v)){ $('colorPicker').value = v; setCustomColor(v); }
};
function setCustomColor(hex){
    state.colorId = 'custom'; state.colorHex = hex.toUpperCase(); state.colorName = 'Màu tuỳ chỉnh ' + hex.toUpperCase();
    $('colorHex').value = hex.toUpperCase();
    renderColors(); Viewer.setColor(hex); update();
}
$('refBtn').onclick = () => $('refInput').click();
$('refInput').onchange = e => {
    const f = e.target.files[0];
    if(!f) return;
    state.refImage = f.name;
    const url = URL.createObjectURL(f);
    $('refThumb').outerHTML = `<img class="thumb" id="refThumb" src="${url}" alt="Hình mẫu màu">`;
    $('refTitle').textContent = f.name;
    $('refDesc').textContent = 'Xưởng sẽ tham khảo ảnh này khi pha màu.';
    $('refBtn').textContent = 'Đổi ảnh';
    toastOk('Đã thêm hình mẫu màu');
};

// Dung sai
$('tolCustom').oninput = e => { state.tolCustom = parseFloat(e.target.value) || null; update(); };

// Ghi chú
$('notes').oninput = e => state.notes = e.target.value;

// Gửi / lưu
$('orderForm').onsubmit = submit;
$('btnSave').onclick = saveConfig;

// Modal
$('confirmModal').querySelectorAll('[data-close]').forEach(b => b.onclick = () => $('confirmModal').classList.remove('show'));
$('confirmModal').onclick = e => { if(e.target === $('confirmModal')) $('confirmModal').classList.remove('show'); };
document.addEventListener('keydown', e => { if(e.key === 'Escape') $('confirmModal').classList.remove('show'); });

/* ============================================================
   12. KHỞI TẠO
   ============================================================ */
renderTech(); renderMaterials(); renderQuality(); renderColors(); renderPost(); renderTol();
syncSizeMode(); update();

if(!Viewer.available()){
    $('stageEmpty').querySelector('p').textContent = 'Không tải được thư viện 3D. Bạn vẫn đặt in được — nhập kích thước mong muốn ở mục “Kích thước sản phẩm”.';
}