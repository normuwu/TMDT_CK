<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>PrintKraft Admin — Quản lý nền tảng</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<style>
/* ============================================================
   BLOCK A — CSS GỐC admin.css (giữ nguyên)
   ============================================================ */
:root{
    --graphite:#1E2430; --panel:#262E3D; --bg:#F5F6F8;
    --cobalt:#3B5BDB; --green:#2F9E44; --amber:#E8590C; --red:#E03131;
    --line:#E3E5EA; --text:#1E2430; --muted:#6B7280;
}
*{box-sizing:border-box; margin:0; padding:0;}
body{background:var(--bg); color:var(--text); font-family:'IBM Plex Sans', sans-serif; font-size:14px;}
.num, .mono{font-family:'IBM Plex Mono', monospace;}
a{color:inherit; text-decoration:none;}
button{font-family:inherit; cursor:pointer;}

.layout{display:grid; grid-template-columns:236px 1fr; min-height:100vh;}

.sidebar{
    background:var(--graphite); color:rgba(255,255,255,0.7);
    padding:22px 16px; display:flex; flex-direction:column;
    position:sticky; top:0; height:100vh; overflow-y:auto;
}
.brand{display:flex; align-items:center; gap:10px; color:white; font-weight:600; font-size:15px; padding:0 8px 24px;}
.brand .sq{width:20px; height:20px; background:var(--cobalt); border-radius:5px;}
.nav-group{margin-bottom:22px;}
.nav-label{font-size:11px; text-transform:uppercase; letter-spacing:0.06em; color:rgba(255,255,255,0.35); padding:0 8px 8px; font-weight:600;}
.nav-item{display:flex; align-items:center; gap:10px; padding:9px 10px; border-radius:8px; font-size:13.5px; font-weight:500; margin-bottom:2px; cursor:pointer;}
.nav-item .ic{width:16px; text-align:center; opacity:0.8;}
.nav-item:hover{background:rgba(255,255,255,0.06); color:white;}
.nav-item.active{background:var(--cobalt); color:white;}
.sidebar-foot{margin-top:auto; border-top:1px solid rgba(255,255,255,0.1); padding-top:16px; display:flex; align-items:center; gap:10px;}
.avatar{width:32px; height:32px; border-radius:50%; background:var(--cobalt); display:flex; align-items:center; justify-content:center; font-size:12px; font-weight:600; color:white;}
.sidebar-foot div strong{display:block; color:white; font-size:13px;}
.sidebar-foot div span{font-size:11.5px; color:rgba(255,255,255,0.4);}

.main{display:flex; flex-direction:column; min-width:0;}
.topbar{height:64px; background:white; border-bottom:1px solid var(--line); display:flex; align-items:center; justify-content:space-between; padding:0 28px; flex-shrink:0; gap:16px; flex-wrap:wrap;}
.topbar h1{font-size:17px; font-weight:600;}
.topbar .sub{font-size:12px; color:var(--muted); margin-top:1px;}
.topbar-right{display:flex; align-items:center; gap:14px;}
.search-box{background:var(--bg); border:1px solid var(--line); border-radius:8px; padding:8px 12px; font-size:13px; width:260px; color:var(--text); outline:none;}
.search-box:focus{border-color:var(--cobalt);}
.icon-btn{width:36px; height:36px; border-radius:8px; background:var(--bg); display:flex; align-items:center; justify-content:center; font-size:15px; border:1px solid var(--line); position:relative; cursor:pointer;}
.icon-btn .dot{position:absolute; top:6px; right:7px; width:6px; height:6px; background:var(--red); border-radius:50%;}

.content{padding:26px 28px; flex:1;}

.panel{background:white; border:1px solid var(--line); border-radius:12px; overflow:hidden;}
.panel-head{display:flex; justify-content:space-between; align-items:center; padding:16px 20px; border-bottom:1px solid var(--line);}
.panel-head h3{font-size:14.5px; font-weight:600;}
.panel-head a{font-size:12.5px; color:var(--cobalt); font-weight:500; cursor:pointer;}
.panel-subtitle{font-size:12px; color:var(--muted); margin-top:3px;}
.panel-actions{display:flex; justify-content:flex-end; gap:10px; padding:16px 20px; border-top:1px solid var(--line);}

table{width:100%; border-collapse:collapse;}
th{text-align:left; font-size:11.5px; text-transform:uppercase; letter-spacing:0.04em; color:var(--muted); font-weight:600; padding:10px 20px; border-bottom:1px solid var(--line);}
td{padding:12px 20px; border-bottom:1px solid var(--line); font-size:13px; vertical-align:middle;}
tr:last-child td{border-bottom:none;}
tbody tr:hover{background:var(--bg);}
.order-id{font-family:'IBM Plex Mono'; font-size:12.5px; color:var(--muted);}
.pill{display:inline-flex; align-items:center; gap:5px; padding:4px 10px; border-radius:999px; font-size:11.5px; font-weight:600; white-space:nowrap;}
.pill.blue{background:#E7EBFD; color:var(--cobalt);}
.pill.green{background:#EBFBEE; color:var(--green);}
.pill.amber{background:#FFF4E6; color:var(--amber);}
.pill.red{background:#FFF0F0; color:var(--red);}
.pill.gray{background:var(--bg); color:var(--muted);}
.pill .dot{width:6px; height:6px; border-radius:50%; background:currentColor;}
.action-link{color:var(--cobalt); font-weight:500; cursor:pointer; font-size:12.5px;}
.action-link:hover{text-decoration:underline;}

.list-item{display:flex; justify-content:space-between; align-items:center; padding:13px 20px; border-bottom:1px solid var(--line); font-size:13px;}
.list-item:last-child{border-bottom:none;}
.list-item .name{font-weight:500;}
.list-item .meta{font-size:11.5px; color:var(--muted); margin-top:2px;}
.bar-bg{background:var(--bg); height:6px; border-radius:999px; overflow:hidden; margin-top:4px; width:100px;}
.bar-fill{height:100%; background:var(--cobalt); border-radius:999px;}

.tab-content{display:none;}
.tab-content.active{display:block;}

.detail-grid{display:grid; grid-template-columns:1fr 1fr; gap:12px; padding:16px 20px;}
.detail-grid .field{background:var(--bg); border-radius:9px; padding:12px 14px;}
.detail-grid .field label{font-size:11px; text-transform:uppercase; letter-spacing:0.05em; color:var(--muted); display:block; margin-bottom:4px;}
.detail-grid .field strong{font-size:14.5px; color:var(--text); font-weight:600;}

.overlay{position:fixed; inset:0; background:rgba(30,36,48,0.5); opacity:0; pointer-events:none; transition:.2s; z-index:90;}
.overlay.show{opacity:1; pointer-events:auto;}
.modal{position:fixed; inset:0; display:flex; align-items:center; justify-content:center; z-index:100; opacity:0; pointer-events:none; transition:.2s; padding:20px;}
.modal.show{opacity:1; pointer-events:auto;}
.modal-box{background:white; border-radius:14px; padding:26px; width:600px; max-width:100%; max-height:90vh; overflow-y:auto; position:relative;}
.modal-box h3{font-size:20px; margin-bottom:6px;}
.modal-box .sub{font-size:13px; color:var(--muted); margin-bottom:20px;}
.modal-close{position:absolute; top:16px; right:18px; background:none; border:none; font-size:20px; color:var(--muted);}

.toast{position:fixed; bottom:26px; left:50%; transform:translate(-50%,90px); background:var(--graphite); color:white; padding:13px 24px; border-radius:10px; font-size:13.5px; font-weight:500; z-index:200; transition:.25s; opacity:0;}
.toast.show{transform:translate(-50%,0); opacity:1;}

.btn{border:1px solid var(--line); background:white; border-radius:8px; padding:9px 16px; font-size:13px; font-weight:500;}
.btn:hover{background:var(--bg);}
.btn.primary{background:var(--cobalt); color:white; border-color:var(--cobalt);}
.btn.primary:hover{background:#2f4bc4;}
.btn.danger{background:var(--red); color:white; border-color:var(--red);}
.btn.danger:hover{background:#c92a2a;}
.btn.success{background:var(--green); color:white; border-color:var(--green);}
.btn.success:hover{background:#268a38;}

.toolbar{display:flex; gap:10px; padding:14px 20px; border-bottom:1px solid var(--line); flex-wrap:wrap; align-items:center;}
.toolbar input, .toolbar select{border:1px solid var(--line); border-radius:8px; padding:8px 12px; font-size:13px; font-family:inherit; outline:none;}
.toolbar input:focus, .toolbar select:focus{border-color:var(--cobalt);}

.section-grid{display:grid; grid-template-columns:repeat(3,1fr); gap:16px; margin-bottom:18px;}
.metric-card{background:white; border:1px solid var(--line); border-radius:12px; padding:16px 18px; display:flex; justify-content:space-between; align-items:flex-start; gap:14px;}
.metric-card .metric-title{font-size:12.5px; color:var(--muted); margin-bottom:8px;}
.metric-card .metric-value{font-size:24px; font-weight:600;}
.metric-card .metric-note{font-size:12px; color:var(--muted); margin-top:7px;}
.metric-icon{width:38px; height:38px; border-radius:10px; background:#E7EBFD; color:var(--cobalt); display:flex; align-items:center; justify-content:center; font-size:17px; flex-shrink:0;}
.metric-icon.green{background:#EBFBEE; color:var(--green);}
.metric-icon.amber{background:#FFF4E6; color:var(--amber);}
.metric-icon.red{background:#FFF0F0; color:var(--red);}

.table-wrap{overflow-x:auto;}
.inline-actions{display:flex; gap:8px; flex-wrap:wrap; align-items:center;}
.mini-btn{border:1px solid var(--line); background:white; border-radius:7px; padding:6px 10px; font-size:12px; font-weight:500; color:var(--text);}
.mini-btn:hover{background:var(--bg);}
.mini-btn.primary{background:var(--cobalt); border-color:var(--cobalt); color:white;}
.mini-btn.danger{background:#FFF0F0; border-color:#FFC9C9; color:var(--red);}
.mini-btn.success{background:#EBFBEE; border-color:#B2F2BB; color:var(--green);}
.mini-btn.warning{background:#FFF4E6; border-color:#FFD8A8; color:var(--amber);}

.status-stack{display:flex; flex-direction:column; gap:10px; padding:16px 20px;}
.status-row{display:grid; grid-template-columns:1fr auto; gap:14px; align-items:center;}
.status-row .label{font-size:13px; font-weight:500;}
.status-row .meta{font-size:11.5px; color:var(--muted); margin-top:2px;}
.meter{height:8px; background:var(--bg); border-radius:999px; overflow:hidden; margin-top:8px;}
.meter span{display:block; height:100%; background:var(--cobalt); border-radius:999px;}
.meter span.green{background:var(--green);}
.meter span.amber{background:var(--amber);}
.meter span.red{background:var(--red);}

.timeline-item{position:relative; padding-left:22px; padding-bottom:16px; border-left:2px solid var(--line);}
.timeline-item:last-child{padding-bottom:0;}
.timeline-item:before{content:""; position:absolute; left:-7px; top:2px; width:12px; height:12px; border-radius:50%; background:var(--cobalt); border:2px solid white;}
.timeline-item.warn:before{background:var(--amber);}
.timeline-item.done:before{background:var(--green);}
.timeline-item.red:before{background:var(--red);}
.timeline-item strong{display:block; font-size:13px;}
.timeline-item span{display:block; font-size:11.5px; color:var(--muted); margin-top:2px;}

.form-grid{display:grid; grid-template-columns:repeat(2,1fr); gap:12px; padding:16px 20px;}
.form-field label{display:block; font-size:11px; text-transform:uppercase; letter-spacing:0.05em; color:var(--muted); margin-bottom:6px; font-weight:600;}
.form-field input, .form-field select, .form-field textarea{width:100%; border:1px solid var(--line); border-radius:8px; padding:9px 12px; font-size:13px; font-family:inherit; outline:none; background:white;}
.form-field textarea{resize:vertical; min-height:90px;}
.form-field input:focus, .form-field select:focus, .form-field textarea:focus{border-color:var(--cobalt);}

.settings-list{padding:5px 20px 18px;}
.setting-row{display:flex; justify-content:space-between; align-items:center; gap:16px; padding:14px 0; border-bottom:1px solid var(--line); cursor:pointer;}
.setting-row strong{display:block; font-size:13px;}
.setting-row small{display:block; color:var(--muted); margin-top:3px; font-size:11.5px;}
.setting-row input{width:38px; height:20px; accent-color:var(--cobalt);}

.empty-state{padding:34px 20px; text-align:center; color:var(--muted); font-size:13px;}
.empty-state strong{display:block; color:var(--text); font-size:14px; margin-bottom:4px;}

.cols{display:grid; grid-template-columns:1.6fr 1fr; gap:18px; align-items:start;}
.top-gap{margin-top:18px;}

@media (max-width:1100px){
    .layout{grid-template-columns:1fr;}
    .sidebar{display:none;}
    .section-grid{grid-template-columns:repeat(2,1fr);}
    .cols{grid-template-columns:1fr;}
}
@media (max-width:600px){
    .section-grid{grid-template-columns:1fr;}
    .detail-grid{grid-template-columns:1fr;}
    .form-grid{grid-template-columns:1fr;}
}

/* ============================================================
   BLOCK B — CSS MỚI THÊM (scoped trong #page-platform)
   ============================================================ */

/* --- Sub-tabs --- */
#page-platform .plat-subtabs{
    display:flex; gap:4px; margin-bottom:20px; flex-wrap:wrap; align-items:center;
    border-bottom:1px solid var(--line); padding-bottom:0;
}
#page-platform .plat-subtabs > button{
    background:transparent; border:none; color:var(--muted);
    padding:11px 16px; font-size:13.5px; font-weight:500; cursor:pointer;
    border-bottom:2px solid transparent; transition:.16s; position:relative; top:1px;
}
#page-platform .plat-subtabs > button:hover{color:var(--text);}
#page-platform .plat-subtabs > button.active{
    color:var(--cobalt); border-bottom-color:var(--cobalt); font-weight:600;
}
#page-platform .plat-subtabs .env-chip{
    margin-left:auto; display:flex; gap:8px; align-items:center; padding-bottom:8px;
    font-size:11.5px; color:var(--muted); font-weight:600;
}
#page-platform .plat-subtabs .env-chip .env-pill{
    background:#EBFBEE; color:var(--green); padding:4px 10px; border-radius:999px;
    font-size:10.5px; text-transform:uppercase; letter-spacing:.06em; font-weight:700;
}

#page-platform .plat-subtab{display:none;}
#page-platform .plat-subtab.active{display:block; animation:fadeIn .25s ease;}
@keyframes fadeIn{from{opacity:0; transform:translateY(6px);} to{opacity:1; transform:none;}}

/* --- Service cards --- */
#page-platform .svc-grid{display:grid; grid-template-columns:repeat(2,1fr); gap:14px; margin-bottom:18px;}
#page-platform .svc-card{
    background:white; border:1px solid var(--line); border-radius:12px; padding:16px 18px;
    transition:.2s; position:relative; overflow:hidden;
}
#page-platform .svc-card:hover{box-shadow:0 6px 18px rgba(30,36,48,.06);}
#page-platform .svc-card:before{content:""; position:absolute; left:0; top:0; bottom:0; width:4px;}
#page-platform .svc-card.healthy:before{background:var(--green);}
#page-platform .svc-card.warn:before{background:var(--amber);}
#page-platform .svc-card.down:before{background:var(--red);}
#page-platform .svc-card.info:before{background:var(--cobalt);}

#page-platform .svc-head{display:flex; justify-content:space-between; align-items:flex-start; gap:12px; margin-bottom:14px;}
#page-platform .svc-name{display:flex; align-items:center; gap:10px;}
#page-platform .svc-name .pulse{
    width:9px; height:9px; border-radius:50%; background:var(--green); flex-shrink:0;
    box-shadow:0 0 0 0 rgba(47,158,68,.5); animation:svcPulse 1.8s infinite;
}
#page-platform .svc-name .pulse.warn{background:var(--amber); animation:svcPulseAmber 1.8s infinite;}
#page-platform .svc-name .pulse.down{background:var(--red); animation:none;}
#page-platform .svc-name h4{font-size:14.5px; font-weight:600;}
#page-platform .svc-name small{display:block; font-size:11px; color:var(--muted); margin-top:2px; font-family:'IBM Plex Mono';}
@keyframes svcPulse{
    0%{box-shadow:0 0 0 0 rgba(47,158,68,.5);}
    70%{box-shadow:0 0 0 10px rgba(47,158,68,0);}
    100%{box-shadow:0 0 0 0 rgba(47,158,68,0);}
}
@keyframes svcPulseAmber{
    0%{box-shadow:0 0 0 0 rgba(232,89,12,.5);}
    70%{box-shadow:0 0 0 10px rgba(232,89,12,0);}
    100%{box-shadow:0 0 0 0 rgba(232,89,12,0);}
}

#page-platform .svc-metrics{
    display:grid; grid-template-columns:repeat(3,1fr); gap:10px; margin-bottom:12px;
}
#page-platform .svc-metric{
    background:var(--bg); border-radius:8px; padding:10px 12px;
}
#page-platform .svc-metric .lbl{font-size:10px; text-transform:uppercase; letter-spacing:.05em; color:var(--muted); font-weight:600;}
#page-platform .svc-metric .val{font-family:'IBM Plex Mono'; font-size:15px; font-weight:600; margin-top:3px;}
#page-platform .svc-metric .val.green{color:var(--green);}
#page-platform .svc-metric .val.amber{color:var(--amber);}
#page-platform .svc-metric .val.red{color:var(--red);}

#page-platform .svc-uptime{
    display:flex; justify-content:space-between; font-size:11.5px; color:var(--muted); margin-bottom:10px;
}
#page-platform .svc-uptime strong{color:var(--text); font-family:'IBM Plex Mono';}
#page-platform .svc-actions{display:flex; gap:6px; flex-wrap:wrap;}

/* --- Resource gauges --- */
#page-platform .resource-grid{display:grid; grid-template-columns:repeat(4,1fr); gap:14px; margin-bottom:18px;}
#page-platform .resource-card{
    background:white; border:1px solid var(--line); border-radius:12px; padding:16px;
    display:flex; align-items:center; gap:14px;
}
#page-platform .ring{
    width:64px; height:64px; border-radius:50%; flex-shrink:0;
    display:flex; align-items:center; justify-content:center; position:relative;
}
#page-platform .ring:before{
    content:""; position:absolute; inset:7px; border-radius:50%; background:white;
}
#page-platform .ring span{
    position:relative; font-family:'IBM Plex Mono'; font-weight:600; font-size:13px; color:var(--text);
}
#page-platform .resource-info .lbl{font-size:11px; text-transform:uppercase; letter-spacing:.06em; color:var(--muted); font-weight:700;}
#page-platform .resource-info .val{font-family:'IBM Plex Mono'; font-size:20px; font-weight:600; margin-top:3px;}
#page-platform .resource-info .note{font-size:11px; color:var(--muted); margin-top:4px;}

/* --- Incident list --- */
#page-platform .incident-card{
    display:grid; grid-template-columns:auto 1fr auto; gap:14px; align-items:flex-start;
    padding:16px 20px; border-bottom:1px solid var(--line); transition:.15s;
}
#page-platform .incident-card:last-child{border-bottom:none;}
#page-platform .incident-card:hover{background:var(--bg);}
#page-platform .incident-sev{
    width:38px; height:38px; border-radius:10px; display:flex; align-items:center; justify-content:center;
    font-size:16px; font-weight:700; flex-shrink:0;
}
#page-platform .incident-sev.critical{background:#FFF0F0; color:var(--red);}
#page-platform .incident-sev.warning{background:#FFF4E6; color:var(--amber);}
#page-platform .incident-sev.info{background:#E7EBFD; color:var(--cobalt);}
#page-platform .incident-body strong{display:block; font-size:13.5px; font-weight:600;}
#page-platform .incident-body .meta{font-size:11.5px; color:var(--muted); margin-top:3px; font-family:'IBM Plex Mono';}
#page-platform .incident-body p{font-size:12.5px; color:var(--muted); margin-top:6px;}
#page-platform .incident-actions{display:flex; gap:6px; align-items:center;}

/* --- Backup list --- */
#page-platform .backup-row{
    display:grid; grid-template-columns:auto 1fr auto auto; gap:14px; align-items:center;
    padding:14px 20px; border-bottom:1px solid var(--line);
}
#page-platform .backup-row:last-child{border-bottom:none;}
#page-platform .backup-icon{
    width:38px; height:38px; border-radius:10px; background:#EBFBEE; color:var(--green);
    display:flex; align-items:center; justify-content:center; font-size:16px; flex-shrink:0;
}
#page-platform .backup-icon.manual{background:#E7EBFD; color:var(--cobalt);}
#page-platform .backup-icon.failed{background:#FFF0F0; color:var(--red);}
#page-platform .backup-info strong{display:block; font-size:13.5px; font-weight:600;}
#page-platform .backup-info small{font-size:11.5px; color:var(--muted); font-family:'IBM Plex Mono';}
#page-platform .backup-size{font-family:'IBM Plex Mono'; font-size:13px; color:var(--text); font-weight:600; text-align:right;}
#page-platform .backup-dur{font-size:11px; color:var(--muted); text-align:right; margin-top:2px;}

/* --- Config sections --- */
#page-platform .config-section{
    padding:18px 20px; border-bottom:1px solid var(--line);
}
#page-platform .config-section:last-child{border-bottom:none;}
#page-platform .config-section h4{
    font-size:12px; text-transform:uppercase; letter-spacing:.06em;
    color:var(--muted); font-weight:700; margin-bottom:14px;
    display:flex; align-items:center; gap:8px;
}
#page-platform .config-grid{display:grid; grid-template-columns:repeat(2,1fr); gap:14px;}
#page-platform .env-var{
    display:flex; justify-content:space-between; align-items:center; gap:12px;
    padding:10px 14px; background:var(--bg); border-radius:8px; font-size:12.5px;
}
#page-platform .env-var .key{font-family:'IBM Plex Mono'; font-weight:600; color:var(--cobalt);}
#page-platform .env-var .val{font-family:'IBM Plex Mono'; color:var(--muted); font-size:12px;}

#page-platform .feature-flag{
    display:flex; justify-content:space-between; align-items:center; gap:14px;
    padding:12px 14px; border:1px solid var(--line); border-radius:8px;
    margin-bottom:8px; background:white;
}
#page-platform .feature-flag:last-child{margin-bottom:0;}
#page-platform .feature-flag .ff-name{font-size:13px; font-weight:500;}
#page-platform .feature-flag .ff-desc{font-size:11.5px; color:var(--muted); margin-top:2px;}
#page-platform .feature-flag input{width:38px; height:20px; accent-color:var(--cobalt);}

/* --- Deployment timeline --- */
#page-platform .deploy-row{
    display:grid; grid-template-columns:auto 1fr auto; gap:14px; align-items:center;
    padding:14px 20px; border-bottom:1px solid var(--line);
}
#page-platform .deploy-row:last-child{border-bottom:none;}
#page-platform .deploy-ver{
    font-family:'IBM Plex Mono'; font-weight:700; font-size:12.5px;
    background:#E7EBFD; color:var(--cobalt); padding:5px 10px; border-radius:6px;
}
#page-platform .deploy-ver.hotfix{background:#FFF0F0; color:var(--red);}
#page-platform .deploy-ver.minor{background:#EBFBEE; color:var(--green);}
#page-platform .deploy-info strong{display:block; font-size:13.5px; font-weight:600;}
#page-platform .deploy-info small{font-size:11.5px; color:var(--muted); font-family:'IBM Plex Mono'; margin-top:2px; display:block;}
#page-platform .deploy-by{font-size:11.5px; color:var(--muted); text-align:right;}

/* --- Log viewer --- */
#page-platform .log-viewer{
    background:var(--graphite); color:#D0D6E4; border-radius:10px;
    padding:16px 18px; font-family:'IBM Plex Mono'; font-size:12px; line-height:1.7;
    max-height:340px; overflow-y:auto;
}
#page-platform .log-viewer .line{white-space:pre-wrap; word-break:break-all;}
#page-platform .log-viewer .ts{color:#6B7280; margin-right:10px;}
#page-platform .log-viewer .lvl{font-weight:600; margin-right:8px;}
#page-platform .log-viewer .lvl.info{color:#6AA3FF;}
#page-platform .log-viewer .lvl.warn{color:#FFB84D;}
#page-platform .log-viewer .lvl.error{color:#FF6B6B;}

/* --- Responsive --- */
@media (max-width:1200px){
    #page-platform .svc-grid{grid-template-columns:1fr;}
    #page-platform .resource-grid{grid-template-columns:repeat(2,1fr);}
    #page-platform .config-grid{grid-template-columns:1fr;}
}
@media (max-width:760px){
    #page-platform .plat-subtabs{flex-direction:column; align-items:stretch;}
    #page-platform .plat-subtabs .env-chip{margin-left:0;}
    #page-platform .resource-grid{grid-template-columns:1fr;}
    #page-platform .backup-row{grid-template-columns:auto 1fr;}
    #page-platform .backup-row .backup-size,
    #page-platform .backup-row .backup-dur{grid-column:2; text-align:left;}
}
</style>
</head>
<body>
<div class="layout">

  <!-- ===== SIDEBAR ===== -->
  <aside class="sidebar">
    <div class="brand"><span class="sq"></span> PrintKraft Admin</div>

    <div class="nav-group">
      <div class="nav-label">Tổng quan</div>
      <div class="nav-item" onclick="toast('Quay lại Bảng điều khiển')"><span class="ic">▤</span> Bảng điều khiển</div>
      <div class="nav-item" onclick="toast('Quay lại Báo cáo & Doanh thu')"><span class="ic">📈</span> Báo cáo &amp; Doanh thu</div>
    </div>
    <div class="nav-group">
      <div class="nav-label">Vận hành</div>
      <div class="nav-item" onclick="toast('Quay lại Đơn hàng')"><span class="ic">📦</span> Đơn hàng</div>
      <div class="nav-item" onclick="toast('Quay lại Xưởng in đối tác')"><span class="ic">🏭</span> Xưởng in đối tác</div>
      <div class="nav-item" onclick="toast('Quay lại Nhà cung cấp')"><span class="ic">🏢</span> Nhà cung cấp</div>
      <div class="nav-item" onclick="toast('Quay lại Quản lý kho')"><span class="ic">▦</span> Quản lý kho</div>
      <div class="nav-item" onclick="toast('Quay lại Hợp đồng')"><span class="ic">§</span> Hợp đồng</div>
      <div class="nav-item" onclick="toast('Quay lại Tranh chấp')"><span class="ic">⚠️</span> Tranh chấp <span style="margin-left:auto; background:var(--red); color:white; font-size:10px; padding:1px 6px; border-radius:999px;">4</span></div>
    </div>
    <div class="nav-group">
      <div class="nav-label">Truy cập</div>
      <div class="nav-item" onclick="toast('Quay lại Quản lý người dùng')"><span class="ic">👥</span> Quản lý người dùng</div>
      <div class="nav-item" onclick="toast('Quay lại Phân quyền RBAC')"><span class="ic">🔐</span> Phân quyền RBAC</div>
      <div class="nav-item" onclick="toast('Quay lại Người mua')"><span class="ic">🛍️</span> Người mua</div>
      <div class="nav-item" onclick="toast('Quay lại Nhân sự nội bộ')"><span class="ic">🧑‍💼</span> Nhân sự nội bộ</div>
    </div>
    <div class="nav-group">
      <div class="nav-label">Hệ thống</div>
      <div class="nav-item active"><span class="ic">◈</span> Quản lý nền tảng</div>
      <div class="nav-item" onclick="toast('Quay lại Thông báo')"><span class="ic">🔔</span> Thông báo</div>
      <div class="nav-item" onclick="toast('Quay lại Cấu hình')"><span class="ic">⚙️</span> Cấu hình</div>
      <div class="nav-item" onclick="toast('Quay lại Nhật ký hoạt động')"><span class="ic">📜</span> Nhật ký hoạt động</div>
    </div>

    <div class="sidebar-foot">
      <div class="avatar">TH</div>
      <div><strong>Trần Hòa</strong><span>Quản trị viên</span></div>
    </div>
  </aside>

  <!-- ===== MAIN ===== -->
  <div class="main">
    <div class="topbar">
      <div>
        <h1 id="pageTitle">Quản lý nền tảng</h1>
        <div class="sub" id="pageSub">Vận hành, cấu hình và giám sát hệ thống chung</div>
      </div>
      <div class="topbar-right">
        <input class="search-box" placeholder="Tìm dịch vụ, sự cố, log...">
        <div class="icon-btn" onclick="toast('Bạn có 3 thông báo mới')">🔔<span class="dot"></span></div>
        <div class="icon-btn" onclick="toast('Hộp thư đến: 5 tin nhắn chưa đọc')">✉️</div>
      </div>
    </div>

    <div class="content">

<!-- ============================================================
     BLOCK C — HTML TAB PLATFORM NÂNG CẤP
     Thay thế toàn bộ <div class="tab-content" id="page-platform"> cũ
     ============================================================ -->
<div class="tab-content active" id="page-platform">

    <!-- Sub-tabs -->
    <div class="plat-subtabs">
        <button class="active" onclick="platTab(this,'overview')">Tổng quan</button>
        <button onclick="platTab(this,'services')">Dịch vụ</button>
        <button onclick="platTab(this,'incidents')">Sự cố</button>
        <button onclick="platTab(this,'backups')">Backup &amp; Khôi phục</button>
        <button onclick="platTab(this,'config')">Cấu hình</button>
        <div class="env-chip">
            <span>Môi trường:</span>
            <span class="env-pill" id="envPill">Production</span>
            <span>· v2.8.4</span>
        </div>
    </div>

    <!-- ========================================================
         SUB-TAB 1: TỔNG QUAN
         ======================================================== -->
    <div class="plat-subtab active" id="plat-overview">

        <div class="section-grid">
            <div class="metric-card">
                <div>
                    <div class="metric-title">Dịch vụ ổn định</div>
                    <div class="metric-value num" id="healthyServiceCount">0/0</div>
                    <div class="metric-note" id="healthyNote">Đang kiểm tra...</div>
                </div>
                <div class="metric-icon green">✓</div>
            </div>
            <div class="metric-card">
                <div>
                    <div class="metric-title">Tác vụ đang chạy</div>
                    <div class="metric-value num" id="runningJobCount">0</div>
                    <div class="metric-note">Đồng bộ, gửi tin và sao lưu</div>
                </div>
                <div class="metric-icon">◈</div>
            </div>
            <div class="metric-card">
                <div>
                    <div class="metric-title">Sự cố chưa xử lý</div>
                    <div class="metric-value num" id="openIncidentCount">0</div>
                    <div class="metric-note">Cần theo dõi hoặc xác nhận</div>
                </div>
                <div class="metric-icon amber">!</div>
            </div>
        </div>

        <!-- Resources -->
        <div class="resource-grid">
            <div class="resource-card">
                <div class="ring" style="background:conic-gradient(var(--cobalt) 0% 34%, #EDEFF5 34% 100%);">
                    <span>34%</span>
                </div>
                <div class="resource-info">
                    <div class="lbl">CPU</div>
                    <div class="val">34%</div>
                    <div class="note">8 vCPU · 2.7 GHz</div>
                </div>
            </div>
            <div class="resource-card">
                <div class="ring" style="background:conic-gradient(var(--green) 0% 62%, #EDEFF5 62% 100%);">
                    <span>62%</span>
                </div>
                <div class="resource-info">
                    <div class="lbl">RAM</div>
                    <div class="val">9.9 GB</div>
                    <div class="note">Tổng 16 GB</div>
                </div>
            </div>
            <div class="resource-card">
                <div class="ring" style="background:conic-gradient(var(--amber) 0% 78%, #EDEFF5 78% 100%);">
                    <span>78%</span>
                </div>
                <div class="resource-info">
                    <div class="lbl">DISK</div>
                    <div class="val">312 GB</div>
                    <div class="note">Tổng 400 GB</div>
                </div>
            </div>
            <div class="resource-card">
                <div class="ring" style="background:conic-gradient(var(--green) 0% 22%, #EDEFF5 22% 100%);">
                    <span>22%</span>
                </div>
                <div class="resource-info">
                    <div class="lbl">NETWORK</div>
                    <div class="val">88 Mbps</div>
                    <div class="note">Upload / Download</div>
                </div>
            </div>
        </div>

        <div class="cols">
            <div>
                <div class="panel">
                    <div class="panel-head">
                        <div>
                            <h3>Giám sát dịch vụ</h3>
                            <div class="panel-subtitle" id="platformLastCheck">Chưa kiểm tra</div>
                        </div>
                        <button class="btn" type="button" onclick="refreshServices()">Làm mới</button>
                    </div>
                    <div class="status-stack" id="serviceList"></div>
                </div>

                <div class="panel top-gap">
                    <div class="panel-head">
                        <h3>Sự cố và tác vụ vận hành</h3>
                        <div class="inline-actions">
                            <button class="btn" type="button" onclick="runBackup()">Chạy backup</button>
                            <button class="btn primary" type="button" onclick="platTabTo('incidents')">Quản lý sự cố</button>
                        </div>
                    </div>
                    <div id="incidentList"></div>
                </div>
            </div>

            <div>
                <div class="panel">
                    <div class="panel-head">
                        <h3>Cấu hình nhanh</h3>
                        <span class="pill blue">Admin</span>
                    </div>
                    <div class="settings-list">
                        <label class="setting-row">
                            <span><strong>Bảo trì theo lịch</strong><small>Tự động chuyển sang chế độ hạn chế</small></span>
                            <input type="checkbox" id="configScheduledMaintenance">
                        </label>
                        <label class="setting-row">
                            <span><strong>Tự động backup</strong><small>Lưu tối đa 30 bản gần nhất</small></span>
                            <input type="checkbox" id="configAutoBackup">
                        </label>
                        <label class="setting-row">
                            <span><strong>Tự động mở rộng</strong><small>Tăng tài nguyên khi tải vượt 80%</small></span>
                            <input type="checkbox" id="configAutoScale">
                        </label>
                        <label class="setting-row" style="border-bottom:none;">
                            <span><strong>Chế độ bảo trì</strong><small>Dừng nhận đơn mới khi bật</small></span>
                            <input type="checkbox" id="configMaintenanceMode">
                        </label>
                    </div>
                    <div class="panel-actions">
                        <button class="btn" type="button" onclick="platTabTo('config')">Cấu hình đầy đủ</button>
                        <button class="btn primary" type="button" onclick="saveQuickConfig()">Lưu nhanh</button>
                    </div>
                </div>

                <div class="panel top-gap">
                    <div class="panel-head">
                        <h3>Deploy gần đây</h3>
                        <a onclick="platTabTo('services')">Xem tất cả</a>
                    </div>
                    <div id="deployList"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- ========================================================
         SUB-TAB 2: DỊCH VỤ
         ======================================================== -->
    <div class="plat-subtab" id="plat-services">
        <div class="section-grid">
            <div class="metric-card">
                <div>
                    <div class="metric-title">Tổng dịch vụ</div>
                    <div class="metric-value num" id="totalSvcCount">0</div>
                    <div class="metric-note">Đang được giám sát</div>
                </div>
                <div class="metric-icon">◈</div>
            </div>
            <div class="metric-card">
                <div>
                    <div class="metric-title">Uptime 30 ngày</div>
                    <div class="metric-value num" id="avgUptime">99.8%</div>
                    <div class="metric-note">Trung bình toàn hệ thống</div>
                </div>
                <div class="metric-icon green">✓</div>
            </div>
            <div class="metric-card">
                <div>
                    <div class="metric-title">Latency P95</div>
                    <div class="metric-value num" id="avgLatency">0ms</div>
                    <div class="metric-note">Trung bình các dịch vụ</div>
                </div>
                <div class="metric-icon amber">⏱</div>
            </div>
        </div>

        <div class="svc-grid" id="svcGrid"></div>

        <div class="panel top-gap">
            <div class="panel-head">
                <h3>Log hệ thống gần đây</h3>
                <div class="inline-actions">
                    <select class="btn" id="logLevelFilter" onchange="renderLogs()" style="padding:8px 12px; border:1px solid var(--line); border-radius:8px; background:white; font-size:12.5px;">
                        <option value="">Tất cả mức</option>
                        <option value="info">Info</option>
                        <option value="warn">Warn</option>
                        <option value="error">Error</option>
                    </select>
                    <button class="btn" type="button" onclick="toast('Đã tải log mới nhất')">Tải lại</button>
                </div>
            </div>
            <div style="padding:16px 20px;">
                <div class="log-viewer" id="logViewer"></div>
            </div>
        </div>
    </div>

    <!-- ========================================================
         SUB-TAB 3: SỰ CỐ
         ======================================================== -->
    <div class="plat-subtab" id="plat-incidents">
        <div class="section-grid">
            <div class="metric-card">
                <div>
                    <div class="metric-title">Đang mở</div>
                    <div class="metric-value num" id="openIncidentCount2">0</div>
                    <div class="metric-note">Chưa được xác nhận xử lý</div>
                </div>
                <div class="metric-icon red">!</div>
            </div>
            <div class="metric-card">
                <div>
                    <div class="metric-title">Đã xử lý hôm nay</div>
                    <div class="metric-value num" id="resolvedTodayCount">0</div>
                    <div class="metric-note">Trong 24 giờ gần nhất</div>
                </div>
                <div class="metric-icon green">✓</div>
            </div>
            <div class="metric-card">
                <div>
                    <div class="metric-title">Thời gian xử lý TB</div>
                    <div class="metric-value num" id="avgResolutionTime">14 phút</div>
                    <div class="metric-note">Từ khi phát hiện đến khi đóng</div>
                </div>
                <div class="metric-icon">⏱</div>
            </div>
        </div>

        <div class="panel">
            <div class="panel-head">
                <div>
                    <h3>Danh sách sự cố</h3>
                    <div class="panel-subtitle">Theo dõi và xử lý sự cố hệ thống theo mức độ ưu tiên</div>
                </div>
                <div class="inline-actions">
                    <select class="btn" id="incidentSevFilter" onchange="renderIncidents()" style="padding:8px 12px; border:1px solid var(--line); border-radius:8px; background:white; font-size:12.5px;">
                        <option value="">Tất cả mức độ</option>
                        <option value="critical">Nghiêm trọng</option>
                        <option value="warning">Cảnh báo</option>
                        <option value="info">Thông tin</option>
                    </select>
                    <select class="btn" id="incidentStatusFilter" onchange="renderIncidents()" style="padding:8px 12px; border:1px solid var(--line); border-radius:8px; background:white; font-size:12.5px;">
                        <option value="">Tất cả trạng thái</option>
                        <option value="open">Đang mở</option>
                        <option value="resolved">Đã xử lý</option>
                    </select>
                    <button class="btn primary" type="button" onclick="openIncidentForm()">+ Tạo sự cố</button>
                </div>
            </div>
            <div id="incidentTable"></div>
        </div>
    </div>

    <!-- ========================================================
         SUB-TAB 4: BACKUP & KHÔI PHỤC
         ======================================================== -->
    <div class="plat-subtab" id="plat-backups">
        <div class="section-grid">
            <div class="metric-card">
                <div>
                    <div class="metric-title">Backup tự động</div>
                    <div class="metric-value" id="autoBackupStatus">Đang bật</div>
                    <div class="metric-note">Khoảng cách: <span id="backupIntervalNote">6 giờ</span></div>
                </div>
                <div class="metric-icon green">✓</div>
            </div>
            <div class="metric-card">
                <div>
                    <div class="metric-title">Backup gần nhất</div>
                    <div class="metric-value num" id="lastBackupSize">4.8 GB</div>
                    <div class="metric-note" id="lastBackupTime">—</div>
                </div>
                <div class="metric-icon">📦</div>
            </div>
            <div class="metric-card">
                <div>
                    <div class="metric-title">Số bản lưu trữ</div>
                    <div class="metric-value num" id="totalBackups">0</div>
                    <div class="metric-note">Tối đa 30 bản gần nhất</div>
                </div>
                <div class="metric-icon amber">⏱</div>
            </div>
        </div>

        <div class="panel">
            <div class="panel-head">
                <div>
                    <h3>Lịch sử backup</h3>
                    <div class="panel-subtitle">Tự động và thủ công · Có thể tải về hoặc khôi phục</div>
                </div>
                <div class="inline-actions">
                    <button class="btn" type="button" onclick="openBackupSchedule()">Lịch trình</button>
                    <button class="btn primary" type="button" onclick="runBackup()">+ Tạo backup ngay</button>
                </div>
            </div>
            <div id="backupList"></div>
        </div>

        <div class="panel top-gap">
            <div class="panel-head">
                <h3>Khôi phục dữ liệu</h3>
                <span class="pill amber">Cẩn trọng</span>
            </div>
            <div style="padding:18px 20px; font-size:13px; color:var(--muted); line-height:1.7;">
                Khôi phục sẽ ghi đè dữ liệu hiện tại bằng snapshot đã chọn. Hệ thống sẽ tạm chuyển sang chế độ bảo trì trong suốt quá trình. <strong style="color:var(--text);">Khuyến nghị tạo backup mới trước khi khôi phục.</strong>
            </div>
            <div class="panel-actions">
                <button class="btn" type="button" onclick="toast('Đã tải hướng dẫn khôi phục')">Hướng dẫn</button>
                <button class="btn danger" type="button" onclick="openRestoreDialog()">Khôi phục từ snapshot...</button>
            </div>
        </div>
    </div>

    <!-- ========================================================
         SUB-TAB 5: CẤU HÌNH
         ======================================================== -->
    <div class="plat-subtab" id="plat-config">
        <form id="platformConfigForm" onsubmit="savePlatformConfig(event)">

            <div class="panel" style="margin-bottom:18px;">
                <div class="panel-head">
                    <div>
                        <h3>Thông tin môi trường</h3>
                        <div class="panel-subtitle">Các thông số vận hành cơ bản</div>
                    </div>
                    <span class="pill blue" id="envTag">Production</span>
                </div>

                <div class="config-section">
                    <h4>⚙️ Runtime</h4>
                    <div class="config-grid">
                        <div class="env-var"><span class="key">NODE_ENV</span><span class="val">production</span></div>
                        <div class="env-var"><span class="key">APP_VERSION</span><span class="val">v2.8.4</span></div>
                        <div class="env-var"><span class="key">REGION</span><span class="val">ap-southeast-1</span></div>
                        <div class="env-var"><span class="key">TIMEZONE</span><span class="val">Asia/Ho_Chi_Minh</span></div>
                    </div>
                </div>

                <div class="config-section">
                    <h4>📊 Giới hạn hệ thống</h4>
                    <div class="config-grid">
                        <div class="form-field">
                            <label>Giới hạn upload (MB)</label>
                            <input type="number" id="configUploadLimit" min="10" max="2048" required>
                        </div>
                        <div class="form-field">
                            <label>Khoảng cách backup (giờ)</label>
                            <input type="number" id="configBackupInterval" min="1" max="24" required>
                        </div>
                        <div class="form-field">
                            <label>Ngưỡng CPU cảnh báo (%)</label>
                            <input type="number" id="configCpuThreshold" min="50" max="99" value="80">
                        </div>
                        <div class="form-field">
                            <label>Ngưỡng RAM cảnh báo (%)</label>
                            <input type="number" id="configRamThreshold" min="50" max="99" value="85">
                        </div>
                        <div class="form-field">
                            <label>Timeout API (giây)</label>
                            <input type="number" id="configApiTimeout" min="5" max="120" value="30">
                        </div>
                        <div class="form-field">
                            <label>Số kết nối tối đa</label>
                            <input type="number" id="configMaxConnections" min="10" max="10000" value="500">
                        </div>
                    </div>
                </div>

                <div class="config-section">
                    <h4>🚦 Chế độ vận hành</h4>
                    <label class="setting-row" style="padding:12px 0;">
                        <span><strong>Bảo trì theo lịch</strong><small>Tự động chuyển sang chế độ hạn chế</small></span>
                        <input type="checkbox" id="configScheduledMaintenance2">
                    </label>
                    <label class="setting-row" style="padding:12px 0;">
                        <span><strong>Tự động backup</strong><small>Lưu tối đa 30 bản gần nhất</small></span>
                        <input type="checkbox" id="configAutoBackup2">
                    </label>
                    <label class="setting-row" style="padding:12px 0;">
                        <span><strong>Tự động mở rộng</strong><small>Tăng tài nguyên khi tải vượt 80%</small></span>
                        <input type="checkbox" id="configAutoScale2">
                    </label>
                    <label class="setting-row" style="padding:12px 0; border-bottom:none;">
                        <span><strong>Chế độ bảo trì</strong><small>Dừng nhận đơn mới khi bật</small></span>
                        <input type="checkbox" id="configMaintenanceMode2">
                    </label>
                </div>

                <div class="config-section">
                    <h4>🚩 Feature Flags</h4>
                    <div id="featureFlagsList"></div>
                </div>

                <div class="panel-actions">
                    <button class="btn" type="button" onclick="resetPlatformConfig()">Khôi phục mặc định</button>
                    <button class="btn primary" type="submit">Lưu cấu hình</button>
                </div>
            </div>

            <div class="panel">
                <div class="panel-head">
                    <h3>Hành động khẩn cấp</h3>
                    <span class="pill red">Cẩn trọng</span>
                </div>
                <div class="config-section">
                    <div class="config-grid">
                        <button class="btn danger" type="button" onclick="emergencyAction('restart')" style="padding:14px;">🔄 Khởi động lại toàn hệ thống</button>
                        <button class="btn danger" type="button" onclick="emergencyAction('clear-cache')" style="padding:14px;">🗑️ Xóa toàn bộ cache</button>
                        <button class="btn danger" type="button" onclick="emergencyAction('maintenance')" style="padding:14px;">🔧 Bật chế độ bảo trì ngay</button>
                        <button class="btn danger" type="button" onclick="emergencyAction('rollback')" style="padding:14px;">↩️ Rollback version gần nhất</button>
                    </div>
                </div>
            </div>
        </form>
    </div>

</div><!-- /#page-platform -->

    </div>
  </div>
</div>

<!-- ===== MODALS ===== -->
<div class="overlay" id="overlay" onclick="closeAll()"></div>

<div class="modal" id="incidentFormModal">
  <div class="modal-box">
    <button class="modal-close" onclick="closeAll()">✕</button>
    <h3>Tạo sự cố mới</h3>
    <div class="sub">Ghi nhận sự cố hệ thống để theo dõi và xử lý</div>
    <form id="incidentForm" onsubmit="submitIncident(event)">
      <div class="form-grid">
        <div class="form-field">
          <label>Tiêu đề</label>
          <input id="incTitle" required maxlength="120" placeholder="VD: API thanh toán chậm">
        </div>
        <div class="form-field">
          <label>Mức độ</label>
          <select id="incSeverity" required>
            <option value="info">Thông tin</option>
            <option value="warning">Cảnh báo</option>
            <option value="critical">Nghiêm trọng</option>
          </select>
        </div>
        <div class="form-field">
          <label>Dịch vụ ảnh hưởng</label>
          <select id="incService">
            <option>API đơn hàng</option>
            <option>Thanh toán</option>
            <option>Đồng bộ kho</option>
            <option>Email / SMS</option>
            <option>Khác</option>
          </select>
        </div>
        <div class="form-field">
          <label>Người phụ trách</label>
          <input id="incOwner" value="Trần Hòa" required>
        </div>
        <div class="form-field" style="grid-column:1/-1;">
          <label>Mô tả chi tiết</label>
          <textarea id="incDetail" required placeholder="Mô tả triệu chứng, phạm vi ảnh hưởng..."></textarea>
        </div>
      </div>
      <div class="panel-actions" style="padding:0; border:none; margin-top:14px;">
        <button class="btn" type="button" onclick="closeAll()">Hủy</button>
        <button class="btn primary" type="submit">Tạo sự cố</button>
      </div>
    </form>
  </div>
</div>

<div class="modal" id="restoreModal">
  <div class="modal-box" style="width:460px;">
    <button class="modal-close" onclick="closeAll()">✕</button>
    <h3 style="color:var(--red);">Khôi phục từ snapshot</h3>
    <div class="sub">Thao tác này sẽ ghi đè dữ liệu hiện tại</div>
    <div style="background:#FFF0F0; border:1px solid #FFC9C9; border-radius:9px; padding:14px 16px; font-size:13px; color:#A51111; line-height:1.6; margin-bottom:18px;">
      ⚠️ Hệ thống sẽ tạm dừng trong 5–10 phút. Người dùng đang online sẽ bị ngắt kết nối.
    </div>
    <div class="form-field" style="margin-bottom:18px;">
      <label>Chọn snapshot</label>
      <select id="restoreSnapshot"></select>
    </div>
    <div class="panel-actions" style="padding:0; border:none;">
      <button class="btn" type="button" onclick="closeAll()">Hủy</button>
      <button class="btn danger" type="button" onclick="confirmRestore()">Xác nhận khôi phục</button>
    </div>
  </div>
</div>

<div class="modal" id="confirmModal">
  <div class="modal-box" style="width:440px; text-align:center;">
    <button class="modal-close" onclick="closeAll()">✕</button>
    <div style="width:48px; height:48px; border-radius:50%; background:#FFF0F0; color:var(--red); display:flex; align-items:center; justify-content:center; font-size:22px; font-weight:700; margin:0 auto 14px;">!</div>
    <h3 id="confirmTitle">Xác nhận</h3>
    <div class="sub" id="confirmMessage" style="margin-bottom:20px;"></div>
    <div style="display:flex; gap:10px; justify-content:center;">
      <button class="btn" type="button" onclick="closeAll()">Hủy</button>
      <button class="btn danger" type="button" id="confirmBtn">Xác nhận</button>
    </div>
  </div>
</div>

<div class="toast" id="toast">Đã thực hiện</div>

<script>
/* ============================================================
   BLOCK D — JS (giữ helper gốc + mở rộng platform)
   ============================================================ */

/* --- Helpers gốc --- */
let toastTimer;
function toast(msg){
  const t = document.getElementById('toast');
  t.textContent = msg;
  t.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(()=>t.classList.remove('show'), 2200);
}
function escapeHtml(v=''){
  return String(v).replace(/[&<>"']/g, c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#039;'}[c]));
}
function pill(status){
  const colors = {
    'Ổn định':'green','Đang chạy':'blue','Đã xử lý':'green','Đã gửi':'green','Thành công':'green','Đang bật':'green',
    'Chậm':'amber','Cảnh báo':'amber','Đang xử lý':'amber','Chờ':'amber',
    'Gián đoạn':'red','Lỗi':'red','Thất bại':'red','Nghiêm trọng':'red','Đang mở':'red',
    'Thông tin':'blue'
  };
  return '<span class="pill ' + (colors[status] || 'gray') + '"><span class="dot"></span>' + escapeHtml(status) + '</span>';
}
function nowLabel(){
  return new Intl.DateTimeFormat('vi-VN',{day:'2-digit',month:'2-digit',year:'numeric',hour:'2-digit',minute:'2-digit'}).format(new Date());
}
function uid(prefix){
  return prefix + '-' + Date.now().toString(36).toUpperCase() + Math.random().toString(36).slice(2,5).toUpperCase();
}
function openModal(id){
  document.getElementById(id).classList.add('show');
  document.getElementById('overlay').classList.add('show');
}
function closeAll(){
  document.querySelectorAll('.modal, .overlay').forEach(el=>el.classList.remove('show'));
}
document.addEventListener('keydown', e=>{ if(e.key === 'Escape') closeAll(); });

/* --- State --- */
const state = {
  env: 'Production',
  version: 'v2.8.4',
  lastCheck: null,
  services: [
    { id:'SVC-ORDERS',   name:'API đơn hàng',  code:'orders-api',   detail:'24.812 request/giờ',  metric:92, latency:184, uptime:99.98, status:'Ổn định',  version:'v2.8.4', instance:'api-orders-01' },
    { id:'SVC-PAYMENT',  name:'Thanh toán',    code:'payment-svc',  detail:'Tỉ lệ thành công 98,2%', metric:98, latency:210, uptime:99.95, status:'Ổn định',  version:'v2.8.2', instance:'pay-prod-02' },
    { id:'SVC-INVENTORY',name:'Đồng bộ kho',   code:'inventory-sync', detail:'Queue còn 128 bản ghi', metric:64, latency:860, uptime:99.42, status:'Chậm',   version:'v2.8.1', instance:'inv-sync-01' },
    { id:'SVC-NOTIFY',   name:'Email / SMS',   code:'notify-svc',   detail:'Đang xử lý 3.420 thông báo', metric:76, latency:340, uptime:99.87, status:'Đang chạy', version:'v2.8.3', instance:'notify-01' },
    { id:'SVC-STORAGE',  name:'Lưu trữ file',  code:'storage-svc',  detail:'42 TB đã sử dụng',     metric:68, latency:120, uptime:99.99, status:'Ổn định',  version:'v2.8.0', instance:'storage-01' },
    { id:'SVC-AUTH',     name:'Xác thực',      code:'auth-svc',     detail:'1.2k phiên hoạt động', metric:88, latency:95,  uptime:99.99, status:'Ổn định',  version:'v2.8.4', instance:'auth-prod-01' }
  ],
  incidents: [
    { id:'INC-001', title:'Đồng bộ kho chậm',       detail:'Queue vượt ngưỡng 100 bản ghi', severity:'warning',  status:'Đang xử lý', time:'26/09/2026 09:38', owner:'Trần Hòa',  service:'Đồng bộ kho' },
    { id:'INC-002', title:'Backup định kỳ hoàn tất', detail:'Dung lượng 4,8GB, thời gian 11 phút', severity:'info', status:'Đã xử lý', time:'26/09/2026 06:12', owner:'Hệ thống', service:'Storage' },
    { id:'INC-003', title:'Tăng latency API thanh toán', detail:'P95 vượt 400ms trong 8 phút', severity:'critical', status:'Đang xử lý', time:'26/09/2026 08:22', owner:'Lê Phương', service:'Thanh toán' },
    { id:'INC-004', title:'Email queue backlog',     detail:'1.200 email chờ gửi do nhà cung cấp chậm', severity:'warning', status:'Đã xử lý', time:'25/09/2026 17:40', owner:'Nguyễn Linh', service:'Email / SMS' }
  ],
  backups: [
    { id:'BKP-0008', type:'auto',   size:'4.8 GB', duration:'11 phút', status:'Thành công', time:'26/09/2026 06:12', by:'Hệ thống' },
    { id:'BKP-0007', type:'manual', size:'4.8 GB', duration:'12 phút', status:'Thành công', time:'25/09/2026 22:00', by:'Trần Hòa' },
    { id:'BKP-0006', type:'auto',   size:'4.7 GB', duration:'10 phút', status:'Thành công', time:'25/09/2026 18:00', by:'Hệ thống' },
    { id:'BKP-0005', type:'auto',   size:'4.7 GB', duration:'11 phút', status:'Thành công', time:'25/09/2026 12:00', by:'Hệ thống' },
    { id:'BKP-0004', type:'auto',   size:'4.6 GB', duration:'24 phút', status:'Thất bại',   time:'25/09/2026 06:00', by:'Hệ thống' }
  ],
  deploys: [
    { version:'v2.8.4', type:'minor',   info:'Tối ưu cache, sửa lỗi upload', time:'26/09/2026 04:00', by:'Trần Hòa' },
    { version:'v2.8.3', type:'hotfix',  info:'Hotfix API thanh toán timeout', time:'24/09/2026 14:30', by:'Lê Phương' },
    { version:'v2.8.2', type:'minor',   info:'Nâng cấp thư viện, cải thiện log', time:'20/09/2026 04:00', by:'Trần Hòa' },
    { version:'v2.8.1', type:'patch',   info:'Sửa lỗi validate email', time:'18/09/2026 04:00', by:'Nguyễn Linh' },
    { version:'v2.8.0', type:'minor',   info:'Ra mắt module báo cáo mới', time:'15/09/2026 04:00', by:'Trần Hòa' }
  ],
  logs: [
    { ts:'10:42:18', level:'info',  msg:'Request GET /api/orders completed in 128ms' },
    { ts:'10:42:15', level:'info',  msg:'Cache hit ratio: 94.2%' },
    { ts:'10:42:09', level:'warn',  msg:'Inventory sync queue size: 128 (threshold: 100)' },
    { ts:'10:41:58', level:'info',  msg:'User session refreshed: usr_a8f9e2' },
    { ts:'10:41:44', level:'info',  msg:'Payment webhook processed: order PK-08231' },
    { ts:'10:41:30', level:'error', msg:'Failed to send SMS: timeout after 5s (retry 1/3)' },
    { ts:'10:41:18', level:'info',  msg:'Backup snapshot created: BKP-0008' },
    { ts:'10:40:55', level:'warn',  msg:'API payment P95 latency: 412ms (threshold: 400ms)' },
    { ts:'10:40:42', level:'info',  msg:'New WebSocket connection from 113.161.x.x' },
    { ts:'10:40:28', level:'info',  msg:'Cron job "cleanup_temp" completed in 2.1s' },
    { ts:'10:40:12', level:'info',  msg:'DB connection pool: 42/500 active' },
    { ts:'10:39:58', level:'error', msg:'Timeout connecting to sms-provider.vn (retry 2/3)' },
    { ts:'10:39:44', level:'info',  msg:'File uploaded: design_v3.ai (24.8 MB)' },
    { ts:'10:39:20', level:'info',  msg:'Order PK-08242 created by Minh Anh Store' },
    { ts:'10:39:05', level:'warn',  msg:'High memory usage on worker-03: 87%' }
  ],
  config: {
    scheduledMaintenance: true,
    autoBackup: true,
    autoScale: true,
    maintenanceMode: false,
    uploadLimit: 250,
    backupInterval: 6,
    cpuThreshold: 80,
    ramThreshold: 85,
    apiTimeout: 30,
    maxConnections: 500
  },
  featureFlags: [
    { id:'ff_ai_mockup',    name:'AI Mockup Generator', desc:'Tự động tạo mockup từ file thiết kế', enabled:true },
    { id:'ff_auto_match',   name:'Tự động ghép xưởng in', desc:'Hệ thống tự chọn xưởng tối ưu theo giá và thời gian', enabled:true },
    { id:'ff_new_checkout', name:'Checkout flow mới', desc:'Luồng thanh toán 3 bước mới', enabled:true },
    { id:'ff_bulk_import',  name:'Import đơn hàng hàng loạt', desc:'Upload Excel để tạo nhiều đơn cùng lúc', enabled:false },
    { id:'ff_2fa_enforce',  name:'Bắt buộc 2FA cho admin', desc:'Tất cả tài khoản admin phải bật xác thực 2 lớp', enabled:false }
  ]
};

/* --- Sub-tab navigation --- */
function platTab(btn, id){
  document.querySelectorAll('#page-platform .plat-subtabs > button').forEach(b=>b.classList.remove('active'));
  btn.classList.add('active');
  document.querySelectorAll('#page-platform .plat-subtab').forEach(c=>c.classList.remove('active'));
  document.getElementById('plat-' + id).classList.add('active');
}
function platTabTo(id){
  const btn = Array.from(document.querySelectorAll('#page-platform .plat-subtabs > button'))
    .find(b => b.getAttribute('onclick') && b.getAttribute('onclick').includes("'" + id + "'"));
  if(btn) platTab(btn, id);
}

/* --- Overview: service list --- */
function renderServiceList(){
  const list = document.getElementById('serviceList');
  if(!list) return;
  list.innerHTML = state.services.slice(0,4).map(s=>{
    const statusClass = s.status === 'Ổn định' ? 'green'
      : s.status === 'Chậm' ? 'amber' : '';
    return `<div>
      <div class="status-row">
        <div>
          <div class="label">${escapeHtml(s.name)}</div>
          <div class="meta">${escapeHtml(s.detail)} · P95 ${s.latency}ms · Uptime ${s.uptime}%</div>
        </div>
        <div class="inline-actions">
          ${pill(s.status)}
          <button class="mini-btn" onclick="restartService('${s.id}')">Khởi động lại</button>
        </div>
      </div>
      <div class="meter"><span class="${statusClass}" style="width:${s.metric}%"></span></div>
    </div>`;
  }).join('');
  const healthy = state.services.filter(s=>s.status==='Ổn định').length;
  document.getElementById('healthyServiceCount').textContent = healthy + '/' + state.services.length;
  document.getElementById('healthyNote').textContent = state.lastCheck
    ? 'Kiểm tra lúc ' + state.lastCheck
    : 'Đang kiểm tra...';
}

/* --- Overview: incident list --- */
function renderIncidentList(){
  const list = document.getElementById('incidentList');
  if(!list) return;
  const open = state.incidents.filter(i=>i.status !== 'Đã xử lý');
  list.innerHTML = open.length
    ? open.slice(0,5).map(i => `
        <div class="incident-card">
          <div class="incident-sev ${i.severity}">${i.severity==='critical'?'!':i.severity==='warning'?'⚠':'i'}</div>
          <div class="incident-body">
            <strong>${escapeHtml(i.title)}</strong>
            <div class="meta">${escapeHtml(i.id)} · ${escapeHtml(i.service)} · ${escapeHtml(i.time)}</div>
            <p>${escapeHtml(i.detail)}</p>
          </div>
          <div class="incident-actions">
            ${pill(i.status)}
            <button class="mini-btn success" onclick="resolveIncident('${i.id}')">Đã xử lý</button>
          </div>
        </div>`).join('')
    : '<div class="empty-state"><strong>Không có sự cố</strong>Hệ thống đang vận hành bình thường.</div>';

  document.getElementById('openIncidentCount').textContent = open.length;
  document.getElementById('runningJobCount').textContent = state.services.filter(s=>s.status==='Đang chạy').length;
}

/* --- Overview: deploy list --- */
function renderDeployList(){
  const list = document.getElementById('deployList');
  if(!list) return;
  list.innerHTML = state.deploys.slice(0,4).map(d => `
    <div class="deploy-row">
      <span class="deploy-ver ${d.type}">${escapeHtml(d.version)}</span>
      <div class="deploy-info">
        <strong>${escapeHtml(d.info)}</strong>
        <small>${escapeHtml(d.time)}</small>
      </div>
      <div class="deploy-by">${escapeHtml(d.by)}</div>
    </div>
  `).join('');
}

/* --- Services tab: service grid --- */
function renderSvcGrid(){
  const grid = document.getElementById('svcGrid');
  if(!grid) return;
  grid.innerHTML = state.services.map(s=>{
    const cls = s.status==='Ổn định' ? 'healthy'
      : s.status==='Chậm' ? 'warn'
      : s.status==='Đang chạy' ? 'info' : 'down';
    const pulseCls = s.status==='Ổn định' ? '' : s.status==='Chậm' ? 'warn' : s.status==='Đang chạy' ? '' : 'down';
    const latencyCls = s.latency < 300 ? 'green' : s.latency < 600 ? 'amber' : 'red';
    return `
      <div class="svc-card ${cls}">
        <div class="svc-head">
          <div class="svc-name">
            <span class="pulse ${pulseCls}"></span>
            <div>
              <h4>${escapeHtml(s.name)}</h4>
              <small>${escapeHtml(s.code)} · ${escapeHtml(s.instance)}</small>
            </div>
          </div>
          ${pill(s.status)}
        </div>
        <div class="svc-metrics">
          <div class="svc-metric">
            <div class="lbl">Uptime</div>
            <div class="val green">${s.uptime}%</div>
          </div>
          <div class="svc-metric">
            <div class="lbl">P95 Latency</div>
            <div class="val ${latencyCls}">${s.latency}ms</div>
          </div>
          <div class="svc-metric">
            <div class="lbl">Version</div>
            <div class="val">${escapeHtml(s.version)}</div>
          </div>
        </div>
        <div class="svc-uptime">
          <span>${escapeHtml(s.detail)}</span>
          <strong>${s.metric}%</strong>
        </div>
        <div class="meter"><span class="${cls==='healthy'?'green':cls==='warn'?'amber':'red'}" style="width:${s.metric}%"></span></div>
        <div class="svc-actions" style="margin-top:14px;">
          <button class="mini-btn" onclick="restartService('${s.id}')">Khởi động lại</button>
          <button class="mini-btn" onclick="viewService('${s.id}')">Chi tiết</button>
          <button class="mini-btn warning" onclick="toast('Đã tạm dừng ${s.name}')">Tạm dừng</button>
        </div>
      </div>`;
  }).join('');

  document.getElementById('totalSvcCount').textContent = state.services.length;
  const avgUp = (state.services.reduce((sum,s)=>sum+s.uptime,0)/state.services.length).toFixed(2);
  document.getElementById('avgUptime').textContent = avgUp + '%';
  const avgLat = Math.round(state.services.reduce((sum,s)=>sum+s.latency,0)/state.services.length);
  document.getElementById('avgLatency').textContent = avgLat + 'ms';
}

/* --- Services tab: log viewer --- */
function renderLogs(){
  const viewer = document.getElementById('logViewer');
  if(!viewer) return;
  const filter = document.getElementById('logLevelFilter').value;
  const logs = filter ? state.logs.filter(l=>l.level===filter) : state.logs;
  viewer.innerHTML = logs.map(l => `<div class="line"><span class="ts">${l.ts}</span><span class="lvl ${l.level}">[${l.level.toUpperCase()}]</span>${escapeHtml(l.msg)}</div>`).join('');
}

/* --- Incidents tab --- */
function renderIncidents(){
  const list = document.getElementById('incidentTable');
  if(!list) return;
  const sevFilter = document.getElementById('incidentSevFilter').value;
  const statusFilter = document.getElementById('incidentStatusFilter').value;
  const filtered = state.incidents.filter(i =>
    (!sevFilter || i.severity === sevFilter) &&
    (!statusFilter || (statusFilter==='open' ? i.status!=='Đã xử lý' : i.status==='Đã xử lý'))
  );
  list.innerHTML = filtered.length ? filtered.map(i => `
    <div class="incident-card">
      <div class="incident-sev ${i.severity}">${i.severity==='critical'?'!':i.severity==='warning'?'⚠':'i'}</div>
      <div class="incident-body">
        <strong>${escapeHtml(i.title)}</strong>
        <div class="meta">${escapeHtml(i.id)} · ${escapeHtml(i.service)} · ${escapeHtml(i.owner)} · ${escapeHtml(i.time)}</div>
        <p>${escapeHtml(i.detail)}</p>
      </div>
      <div class="incident-actions">
        ${pill(i.status)}
        ${i.status !== 'Đã xử lý'
          ? `<button class="mini-btn success" onclick="resolveIncident('${i.id}')">Đã xử lý</button>
             <button class="mini-btn" onclick="toast('Đang mở ${i.id}...')">Chi tiết</button>`
          : `<button class="mini-btn" onclick="toast('Đang mở ${i.id}...')">Xem</button>`}
      </div>
    </div>
  `).join('') : '<div class="empty-state"><strong>Không có sự cố</strong>Không tìm thấy sự cố phù hợp với bộ lọc.</div>';

  const open = state.incidents.filter(i=>i.status !== 'Đã xử lý').length;
  const resolved = state.incidents.filter(i=>i.status === 'Đã xử lý').length;
  document.getElementById('openIncidentCount2').textContent = open;
  document.getElementById('resolvedTodayCount').textContent = resolved;
}

/* --- Backups tab --- */
function renderBackups(){
  const list = document.getElementById('backupList');
  if(!list) return;
  list.innerHTML = state.backups.length ? state.backups.map(b => `
    <div class="backup-row">
      <div class="backup-icon ${b.type==='manual'?'manual':b.status==='Thất bại'?'failed':''}">
        ${b.status==='Thất bại'?'✕':b.type==='manual'?'⚡':'📦'}
      </div>
      <div class="backup-info">
        <strong>${escapeHtml(b.id)} · ${b.type==='manual'?'Thủ công':'Tự động'}</strong>
        <small>${escapeHtml(b.time)} · ${escapeHtml(b.by)}</small>
      </div>
      <div>
        <div class="backup-size">${escapeHtml(b.size)}</div>
        <div class="backup-dur">${escapeHtml(b.duration)}</div>
      </div>
      <div class="inline-actions">
        ${pill(b.status)}
        <button class="mini-btn" onclick="toast('Đang tải ${b.id}...')">Tải về</button>
        ${b.status==='Thành công' ? `<button class="mini-btn warning" onclick="restoreBackup('${b.id}')">Khôi phục</button>` : ''}
      </div>
    </div>
  `).join('') : '<div class="empty-state"><strong>Chưa có backup nào</strong>Tạo backup đầu tiên để bắt đầu.</div>';

  document.getElementById('totalBackups').textContent = state.backups.length;
  const last = state.backups[0];
  if(last){
    document.getElementById('lastBackupSize').textContent = last.size;
    document.getElementById('lastBackupTime').textContent = last.time;
  }
  document.getElementById('autoBackupStatus').textContent = state.config.autoBackup ? 'Đang bật' : 'Đang tắt';
  document.getElementById('backupIntervalNote').textContent = state.config.backupInterval + ' giờ';
}

/* --- Config tab --- */
function renderConfig(){
  const c = state.config;
  // Overview quick config
  document.getElementById('configScheduledMaintenance').checked = c.scheduledMaintenance;
  document.getElementById('configAutoBackup').checked = c.autoBackup;
  document.getElementById('configAutoScale').checked = c.autoScale;
  document.getElementById('configMaintenanceMode').checked = c.maintenanceMode;
  // Full config
  document.getElementById('configScheduledMaintenance2').checked = c.scheduledMaintenance;
  document.getElementById('configAutoBackup2').checked = c.autoBackup;
  document.getElementById('configAutoScale2').checked = c.autoScale;
  document.getElementById('configMaintenanceMode2').checked = c.maintenanceMode;
  document.getElementById('configUploadLimit').value = c.uploadLimit;
  document.getElementById('configBackupInterval').value = c.backupInterval;
  document.getElementById('configCpuThreshold').value = c.cpuThreshold;
  document.getElementById('configRamThreshold').value = c.ramThreshold;
  document.getElementById('configApiTimeout').value = c.apiTimeout;
  document.getElementById('configMaxConnections').value = c.maxConnections;
  // Feature flags
  const flagsList = document.getElementById('featureFlagsList');
  flagsList.innerHTML = state.featureFlags.map(f => `
    <label class="feature-flag">
      <div>
        <div class="ff-name">${escapeHtml(f.name)}</div>
        <div class="ff-desc">${escapeHtml(f.desc)} · <span style="font-family:'IBM Plex Mono';">${f.id}</span></div>
      </div>
      <input type="checkbox" data-flag="${f.id}" ${f.enabled?'checked':''} onchange="toggleFeatureFlag('${f.id}', this.checked)">
    </label>
  `).join('');
}

function toggleFeatureFlag(id, enabled){
  const flag = state.featureFlags.find(f=>f.id===id);
  if(flag){
    flag.enabled = enabled;
    toast((enabled?'Đã bật':'Đã tắt') + ' feature flag "' + flag.name + '"');
  }
}

/* --- Actions --- */
function refreshServices(){
  state.services.forEach(s=>{
    s.latency = Math.max(80, s.latency + Math.round((Math.random()-.5) * 80));
    if(s.status === 'Chậm' && s.latency < 500) s.status = 'Ổn định';
    if(s.status === 'Ổn định' && s.latency > 700) s.status = 'Chậm';
    s.metric = Math.max(30, Math.min(99, s.metric + Math.round((Math.random()-.5) * 10)));
  });
  state.lastCheck = nowLabel();
  document.getElementById('platformLastCheck').textContent = 'Kiểm tra lúc ' + state.lastCheck;
  renderServiceList();
  renderSvcGrid();
  toast('Đã làm mới trạng thái dịch vụ');
}

function restartService(id){
  const s = state.services.find(item => item.id === id);
  if(!s) return;
  confirmAction(
    'Khởi động lại dịch vụ',
    'Dịch vụ "' + s.name + '" có thể gián đoạn trong vài giây.',
    () => {
      s.status = 'Đang chạy';
      s.metric = 30;
      renderServiceList();
      renderSvcGrid();
      toast('Đang khởi động lại ' + s.name);
      setTimeout(()=>{
        s.status = 'Ổn định';
        s.metric = 96;
        s.latency = 160;
        renderServiceList();
        renderSvcGrid();
        toast(s.name + ' đã hoạt động ổn định');
      }, 1500);
    },
    'Khởi động lại'
  );
}

function viewService(id){
  const s = state.services.find(item => item.id === id);
  if(!s) return;
  openModal('incidentFormModal'); // placeholder, keep simple
  closeAll();
  toast('Đang mở chi tiết ' + s.name);
}

function resolveIncident(id){
  const inc = state.incidents.find(item => item.id === id);
  if(inc){
    inc.status = 'Đã xử lý';
    renderIncidentList();
    renderIncidents();
    toast('Đã đóng sự cố ' + id);
  }
}

function runBackup(){
  const newBackup = {
    id: 'BKP-' + String(state.backups.length + 1).padStart(4,'0'),
    type: 'manual',
    size: '—',
    duration: 'Đang chạy',
    status: 'Đang chạy',
    time: nowLabel(),
    by: 'Trần Hòa'
  };
  state.backups.unshift(newBackup);
  renderBackups();
  toast('Đã bắt đầu tạo backup');
  setTimeout(()=>{
    newBackup.size = '4.9 GB';
    newBackup.duration = '12 phút';
    newBackup.status = 'Thành công';
    renderBackups();
    toast('Backup đã hoàn tất');
  }, 2000);
}

function openBackupSchedule(){
  toast('Lịch backup: mỗi ' + state.config.backupInterval + ' giờ');
}

function restoreBackup(id){
  openRestoreDialog(id);
}

function openRestoreDialog(preselect){
  const select = document.getElementById('restoreSnapshot');
  select.innerHTML = state.backups
    .filter(b=>b.status==='Thành công')
    .map(b => `<option value="${b.id}" ${preselect===b.id?'selected':''}>${b.id} · ${b.time} · ${b.size}</option>`).join('');
  openModal('restoreModal');
}

function confirmRestore(){
  const snap = document.getElementById('restoreSnapshot').value;
  closeAll();
  toast('Đang khôi phục từ ' + snap + '...');
  setTimeout(()=>toast('Khôi phục thành công từ ' + snap), 1800);
}

function saveQuickConfig(){
  state.config.scheduledMaintenance = document.getElementById('configScheduledMaintenance').checked;
  state.config.autoBackup = document.getElementById('configAutoBackup').checked;
  state.config.autoScale = document.getElementById('configAutoScale').checked;
  state.config.maintenanceMode = document.getElementById('configMaintenanceMode').checked;
  renderConfig();
  renderBackups();
  toast('Đã lưu cấu hình nhanh');
}

function savePlatformConfig(e){
  e.preventDefault();
  state.config = {
    scheduledMaintenance: document.getElementById('configScheduledMaintenance2').checked,
    autoBackup: document.getElementById('configAutoBackup2').checked,
    autoScale: document.getElementById('configAutoScale2').checked,
    maintenanceMode: document.getElementById('configMaintenanceMode2').checked,
    uploadLimit: Number(document.getElementById('configUploadLimit').value),
    backupInterval: Number(document.getElementById('configBackupInterval').value),
    cpuThreshold: Number(document.getElementById('configCpuThreshold').value),
    ramThreshold: Number(document.getElementById('configRamThreshold').value),
    apiTimeout: Number(document.getElementById('configApiTimeout').value),
    maxConnections: Number(document.getElementById('configMaxConnections').value)
  };
  renderConfig();
  renderBackups();
  toast('Đã lưu cấu hình nền tảng');
}

function resetPlatformConfig(){
  confirmAction(
    'Khôi phục cấu hình mặc định',
    'Các thiết lập vận hành sẽ trở về giá trị mặc định ban đầu.',
    () => {
      state.config = {
        scheduledMaintenance: true,
        autoBackup: true,
        autoScale: true,
        maintenanceMode: false,
        uploadLimit: 250,
        backupInterval: 6,
        cpuThreshold: 80,
        ramThreshold: 85,
        apiTimeout: 30,
        maxConnections: 500
      };
      renderConfig();
      renderBackups();
      toast('Đã khôi phục cấu hình mặc định');
    },
    'Khôi phục'
  );
}

function emergencyAction(type){
  const actions = {
    restart: ['Khởi động lại toàn hệ thống', 'Toàn bộ dịch vụ sẽ tạm dừng trong 1–2 phút.'],
    'clear-cache': ['Xóa toàn bộ cache', 'Người dùng có thể thấy dữ liệu cũ trong vài phút đầu.'],
    maintenance: ['Bật chế độ bảo trì ngay', 'Hệ thống sẽ ngừng nhận đơn mới cho đến khi tắt.'],
    rollback: ['Rollback version', 'Hệ thống sẽ quay về version v2.8.3. Dữ liệu v2.8.4 có thể bị mất.']
  };
  const [title, msg] = actions[type] || ['Hành động khẩn cấp', 'Vui lòng xác nhận.'];
  confirmAction(title, msg, () => toast('Đã thực hiện: ' + title), 'Xác nhận');
}

/* --- Incident form --- */
function openIncidentForm(){ openModal('incidentFormModal'); }

function submitIncident(e){
  e.preventDefault();
  const inc = {
    id: 'INC-' + String(state.incidents.length + 1).padStart(3,'0'),
    title: document.getElementById('incTitle').value.trim(),
    detail: document.getElementById('incDetail').value.trim(),
    severity: document.getElementById('incSeverity').value,
    status: 'Đang xử lý',
    time: nowLabel(),
    owner: document.getElementById('incOwner').value.trim(),
    service: document.getElementById('incService').value
  };
  state.incidents.unshift(inc);
  renderIncidentList();
  renderIncidents();
  closeAll();
  document.getElementById('incidentForm').reset();
  toast('Đã tạo sự cố ' + inc.id);
}

/* --- Confirm modal helper --- */
let confirmCb = null;
function confirmAction(title, message, cb, btnText='Xác nhận'){
  document.getElementById('confirmTitle').textContent = title;
  document.getElementById('confirmMessage').textContent = message;
  document.getElementById('confirmBtn').textContent = btnText;
  confirmCb = cb;
  document.getElementById('confirmBtn').onclick = () => {
    closeAll();
    if(confirmCb) confirmCb();
    confirmCb = null;
  };
  openModal('confirmModal');
}

/* --- Init --- */
function renderAll(){
  renderServiceList();
  renderIncidentList();
  renderDeployList();
  renderSvcGrid();
  renderLogs();
  renderIncidents();
  renderBackups();
  renderConfig();
}
renderAll();
</script>
</body>
</html>