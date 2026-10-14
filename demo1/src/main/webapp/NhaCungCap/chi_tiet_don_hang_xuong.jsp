<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Chi tiết đơn hàng #3DP-20260926-00125 — PrintKraft Xưởng</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@600;700&family=Barlow:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
/* ============================================================
   TOKENS — sao chép nguyên vẹn từ hệ thống Xưởng (Sài Gòn Print)
   ============================================================ */
:root{
    --charcoal:#171920;
    --steel:#2C3140;
    --steel-2:#20232C;
    --steel-3:#262A35;
    --orange:#FF8A1F;
    --amber:#FFB020;
    --violet:#8B5CF6;
    --teal:#22D3EE;
    --pink:#F472B6;
    --green:#34D399;
    --red:#FB5A6A;
    --blue:#60A5FA;
    --off:#EDEFF5;
    --muted:#9AA0B0;
    --orange-glow:rgba(255,138,31,.35);
    --grad-hot:linear-gradient(135deg,#FF8A1F,#FFB020);
    --grad-cool:linear-gradient(135deg,#8B5CF6,#22D3EE);
    --grad-money:linear-gradient(135deg,#34D399,#22D3EE);
}
*{box-sizing:border-box; margin:0; padding:0;}
body{
    background:
            radial-gradient(900px 520px at 8% -8%, rgba(255,138,31,.10), transparent 60%),
            radial-gradient(820px 520px at 95% -4%, rgba(139,92,246,.12), transparent 62%),
            radial-gradient(700px 500px at 50% 110%, rgba(34,211,238,.07), transparent 60%),
            var(--charcoal);
    color:var(--off);
    font-family:'Barlow', sans-serif;
    font-size:15px;
    min-height:100vh;
}
h1,h2,h3,.cond{font-family:'Barlow Condensed', sans-serif; letter-spacing:0.01em;}
a{color:inherit; text-decoration:none;}
button{font-family:inherit; cursor:pointer;}
input,select,textarea{font-family:inherit;}
::-webkit-scrollbar{width:9px;height:9px;}
::-webkit-scrollbar-track{background:var(--steel-2);}
::-webkit-scrollbar-thumb{background:#3A4052;border-radius:9px;}
::-webkit-scrollbar-thumb:hover{background:var(--orange);}
:focus-visible{outline:2px solid var(--orange); outline-offset:2px;}

/* ===== Top bar (tái sử dụng) ===== */
.topbar{
    background:linear-gradient(180deg,#262A35,#1D2028);
    padding:14px 28px;
    display:flex; align-items:center; justify-content:space-between;
    position:sticky; top:0; z-index:50; flex-wrap:wrap; gap:12px;
    box-shadow:0 6px 24px rgba(0,0,0,.35);
}
.topbar:after{
    content:""; position:absolute; left:0; right:0; bottom:0; height:3px;
    background:linear-gradient(90deg,var(--orange),var(--amber),var(--pink),var(--violet),var(--teal));
}
.brand{display:flex; align-items:center; gap:12px;}
.brand .mark{
    width:34px; height:34px; border-radius:9px;
    background:var(--grad-hot);
    clip-path: polygon(50% 0%, 100% 100%, 0% 100%);
    filter:drop-shadow(0 0 12px var(--orange-glow));
}
.brand h1{font-size:24px; font-weight:700; color:white;}
.brand span{font-size:12.5px; color:var(--muted); display:block; margin-top:-2px;}
.shift-info{display:flex; align-items:center; gap:22px; font-size:13px; color:var(--muted); flex-wrap:wrap;}
.op-avatar{
    width:38px; height:38px; border-radius:50%; background:var(--grad-hot);
    display:flex; align-items:center; justify-content:center; font-weight:700; color:#1A1C22;
    cursor:pointer; transition:.18s;
}
.op-avatar:hover{transform:scale(1.06); box-shadow:0 0 0 5px var(--orange-glow);}

/* ===== Breadcrumb ===== */
.breadcrumb-bar{
    background:linear-gradient(180deg,#1F222B,#1B1E26);
    border-bottom:1px solid var(--steel);
    padding:14px 28px; display:flex; align-items:center; gap:14px; flex-wrap:wrap;
}
.back-link{
    display:inline-flex; align-items:center; gap:7px; color:var(--off); font-weight:600; font-size:13.5px;
    background:var(--steel-2); border:1px solid var(--steel); padding:8px 14px; border-radius:9px; transition:.16s;
}
.back-link:hover{border-color:var(--orange); color:var(--orange);}
.crumbs{font-size:12.5px; color:var(--muted);}
.crumbs b{color:var(--off); font-weight:600;}

.content{padding:26px 28px 120px; max-width:1480px; margin:0 auto;}

/* ===== Order header ===== */
.order-head{
    display:flex; justify-content:space-between; align-items:flex-start; gap:20px; flex-wrap:wrap; margin-bottom:22px;
}
.order-head h2{font-size:30px; color:white; font-weight:700;}
.order-head .oid{font-size:14px; color:var(--muted); margin-top:2px;}
.order-head .meta-r{text-align:right; font-size:12.5px; color:var(--muted);}
.status-pill{
    display:inline-flex; align-items:center; gap:8px; font-size:13px; font-weight:700;
    padding:7px 15px; border-radius:999px; margin-bottom:6px;
}
.status-pill .dot{width:8px; height:8px; border-radius:50%;}
.status-pill.pending{background:rgba(255,138,31,.16); color:var(--orange);}
.status-pill.pending .dot{background:var(--orange); box-shadow:0 0 8px var(--orange-glow);}
.status-pill.confirmed{background:rgba(52,211,153,.16); color:var(--green);}
.status-pill.confirmed .dot{background:var(--green);}
.deadline-chip{
    display:inline-block; font-size:12.5px; font-weight:600; color:var(--red);
    background:rgba(251,90,106,.1); border:1px solid rgba(251,90,106,.35);
    padding:6px 13px; border-radius:999px; margin-top:6px;
}

/* ===== Stepper (order status) ===== */
.panel{
    background:linear-gradient(180deg,var(--steel-3),var(--steel-2));
    border:1px solid var(--steel); border-radius:14px; padding:18px 20px;
    margin-bottom:18px;
}
.panel h3{font-size:19px; color:white; font-weight:700; margin-bottom:14px; text-transform:uppercase; letter-spacing:0.03em;}
.panel-head{display:flex; justify-content:space-between; align-items:center; margin-bottom:14px; flex-wrap:wrap; gap:10px;}
.panel-head h3{margin-bottom:0;}
.panel-head .hint{font-size:12px; color:var(--muted);}

.status-track{display:flex; gap:2px; overflow-x:auto; padding-bottom:6px;}
.status-step{flex:1; min-width:104px; text-align:center; position:relative; padding-top:22px;}
.status-step:before{
    content:""; position:absolute; top:8px; left:-50%; width:100%; height:2px; background:var(--steel); z-index:0;
}
.status-step:first-child:before{display:none;}
.status-step .node{
    width:16px; height:16px; border-radius:50%; background:var(--steel-2); border:2px solid var(--steel);
    margin:0 auto 8px; position:relative; z-index:1;
}
.status-step.done .node{background:var(--green); border-color:var(--green); box-shadow:0 0 10px rgba(52,211,153,.5);}
.status-step.done:before{background:var(--green);}
.status-step.active .node{background:var(--orange); border-color:var(--orange); box-shadow:0 0 0 4px rgba(255,138,31,.18);}
.status-step span{font-size:11.5px; color:var(--muted); display:block; line-height:1.3;}
.status-step.active span, .status-step.done span{color:var(--off); font-weight:600;}

/* ===== Layout grid ===== */
.layout-2{display:grid; grid-template-columns:1fr 1fr; gap:18px;}
.layout-main{display:grid; grid-template-columns:1.35fr 1fr; gap:18px; align-items:start;}

/* ===== Info fields (tái sử dụng detail-grid) ===== */
.detail-grid{display:grid; grid-template-columns:1fr 1fr; gap:14px;}
.detail-grid .field{background:#181B22; border-radius:10px; padding:12px 14px; border:1px solid #232734;}
.detail-grid .field label{font-size:11px; text-transform:uppercase; letter-spacing:0.05em; color:var(--muted); display:block; margin-bottom:4px;}
.detail-grid .field strong{font-size:14.5px; color:white; font-weight:600;}

/* ===== Customer card ===== */
.cust-row{display:flex; align-items:center; gap:14px; margin-bottom:16px;}
.cust-avatar{
    width:52px; height:52px; border-radius:50%; background:var(--grad-cool); color:white;
    display:flex; align-items:center; justify-content:center; font-weight:700; font-size:18px; flex-shrink:0;
}
.cust-row div strong{display:block; font-size:16.5px; color:white; font-weight:700;}
.cust-row div span{font-size:12.5px; color:var(--muted);}
.contact-line{display:flex; align-items:center; gap:10px; padding:9px 0; border-bottom:1px solid var(--steel); font-size:13.5px;}
.contact-line:last-of-type{border-bottom:none;}
.contact-line .ic{width:20px; text-align:center; color:var(--muted); flex-shrink:0;}

/* ===== Model viewer ===== */
.viewer-panel{padding:0; overflow:hidden;}
.viewer-panel .ph{padding:18px 20px 0;}
.stage{
    height:420px; position:relative; margin:14px 20px 0; border-radius:12px; overflow:hidden;
    background:
        radial-gradient(420px 260px at 50% 35%, rgba(139,92,246,0.10), transparent 70%),
        repeating-linear-gradient(45deg, rgba(255,255,255,0.02) 0 12px, transparent 12px 24px),
        #14161C;
    border:1px solid var(--steel);
}
.stage canvas{width:100%; height:100%; touch-action:none; cursor:grab;}
.stage canvas:active{cursor:grabbing;}
.stage-badge{
    position:absolute; top:12px; left:12px; z-index:3; font-size:11.5px; font-weight:700;
    padding:5px 12px; border-radius:999px; background:rgba(20,22,28,.82); border:1px solid var(--steel); color:var(--off);
}
.stage-badge.ok{color:var(--green); border-color:rgba(52,211,153,.4);}
.stage-badge.warn{color:var(--red); border-color:rgba(251,90,106,.4);}
.stage-hint{
    position:absolute; bottom:12px; right:12px; z-index:3; font-size:11px; color:var(--muted);
    background:rgba(20,22,28,.82); border:1px solid var(--steel); border-radius:999px; padding:5px 12px;
}
.stage-empty{position:absolute; inset:0; display:flex; flex-direction:column; align-items:center; justify-content:center; gap:8px; text-align:center; padding:20px;}
.stage-empty .ic{width:52px; height:52px; border-radius:16px; background:var(--grad-cool); display:flex; align-items:center; justify-content:center; font-size:22px; margin-bottom:6px;}
.stage-empty h4{font-size:16px; color:white;}
.stage-empty p{font-size:13px; color:var(--muted); max-width:32ch;}
.viewer-tools{display:flex; gap:8px; flex-wrap:wrap; padding:14px 20px;}
.viewer-tools button{
    background:var(--steel-2); border:1px solid var(--steel); color:var(--off);
    padding:8px 13px; border-radius:8px; font-size:12.5px; font-weight:600; transition:.16s;
}
.viewer-tools button:hover:not(:disabled){border-color:var(--orange); color:var(--orange);}
.viewer-tools button:disabled{opacity:.4; cursor:not-allowed;}
.viewer-tools button.on{background:var(--grad-hot); color:#1A1C22; border-color:transparent;}
.viewer-tools .spacer{flex:1;}
.file-strip{
    display:flex; justify-content:space-between; align-items:center; gap:12px; flex-wrap:wrap;
    padding:14px 20px 20px; border-top:1px solid var(--steel); margin-top:4px;
}
.file-strip .fi{font-size:13px; color:var(--muted);}
.file-strip .fi strong{color:white; font-weight:600;}
.file-strip .fa{display:flex; gap:8px;}

/* ===== Analysis dims ===== */
.dims-row{display:grid; grid-template-columns:repeat(4,1fr); gap:10px; margin-bottom:14px;}
.dim{background:#181B22; border:1px solid #232734; border-radius:10px; padding:12px 13px;}
.dim span{display:block; font-size:10.5px; font-weight:700; letter-spacing:.06em; text-transform:uppercase; color:var(--muted);}
.dim strong{display:block; font-family:'Barlow Condensed'; font-size:19px; font-weight:700; margin-top:3px; color:white;}
.dim.vol strong{color:var(--teal);}

.warn-list{display:flex; flex-direction:column; gap:9px;}
.alert-row{
    display:flex; align-items:center; gap:12px; padding:12px 14px;
    background:rgba(251,90,106,0.08); border:1px solid rgba(251,90,106,0.3);
    border-radius:11px; font-size:13px;
}
.alert-row.warn{background:rgba(255,138,31,0.08); border-color:rgba(255,138,31,0.3);}
.alert-row.info{background:rgba(96,165,250,0.08); border-color:rgba(96,165,250,0.3);}
.alert-row.good{background:rgba(52,211,153,0.08); border-color:rgba(52,211,153,0.3);}
.alert-row .ic{font-size:18px; flex-shrink:0;}
.alert-row .txt{flex:1; color:var(--off); min-width:0;}
.alert-row .txt strong{color:white; display:block; font-size:13.5px;}
.alert-row .txt span{font-size:12px; color:var(--muted);}

/* ===== Feasibility ===== */
.feas-result{
    display:flex; align-items:center; gap:14px; padding:14px 16px; border-radius:12px; margin-bottom:14px;
}
.feas-result.pass{background:rgba(52,211,153,.1); border:1px solid rgba(52,211,153,.35);}
.feas-result.fail{background:rgba(251,90,106,.1); border:1px solid rgba(251,90,106,.35);}
.feas-result .ic{font-size:26px;}
.feas-result strong{display:block; font-size:16px; color:white;}
.feas-result span{font-size:12.5px; color:var(--muted);}
.feas-list{display:flex; flex-direction:column; gap:0;}
.feas-item{display:flex; align-items:center; gap:12px; padding:10px 0; border-bottom:1px solid var(--steel); font-size:13.5px;}
.feas-item:last-child{border-bottom:none;}
.feas-item .ic{width:20px; text-align:center; flex-shrink:0; font-weight:700;}
.feas-item.ok .ic{color:var(--green);}
.feas-item.warn .ic{color:var(--orange);}
.feas-item.err .ic{color:var(--red);}
.feas-item .lbl{color:var(--muted); min-width:150px;}
.feas-item .val{flex:1; color:var(--off); font-weight:500;}

/* ===== Compare table (khách yêu cầu vs xưởng xác nhận) ===== */
.compare-table{width:100%; border-collapse:collapse; font-size:13.5px;}
.compare-table th{
    text-align:left; padding:10px; color:var(--muted); font-weight:600; font-size:11.5px;
    text-transform:uppercase; letter-spacing:.05em; border-bottom:1px solid var(--steel);
}
.compare-table td{padding:12px 10px; border-bottom:1px solid #232734; vertical-align:top;}
.compare-table tr:last-child td{border-bottom:none;}
.compare-table td.lbl{color:var(--muted); font-weight:600; white-space:nowrap;}
.compare-table td.changed{position:relative;}
.changed-tag{
    display:inline-block; font-size:10.5px; font-weight:700; color:var(--orange);
    background:rgba(255,138,31,.14); padding:2px 8px; border-radius:999px; margin-left:8px; vertical-align:middle;
}
.reason-row td{background:#181B22; padding:12px 14px; border-radius:0 0 10px 10px;}
.reason-row textarea{width:100%; min-height:56px;}

/* ===== Option cards ===== */
.opt-cards{display:grid; grid-template-columns:repeat(3,1fr); gap:10px;}
.opt-card{
    display:flex; gap:10px; align-items:flex-start; text-align:left; width:100%;
    border:1.5px solid var(--steel); border-radius:10px; background:#181B22;
    padding:12px 13px; transition:.16s;
}
.opt-card:hover{border-color:var(--orange);}
.opt-card.active{border-color:var(--orange); background:rgba(255,138,31,.08); box-shadow:0 0 0 3px rgba(255,138,31,.1);}
.opt-card .radio{width:17px;height:17px;border-radius:50%; border:2px solid var(--steel); flex-shrink:0; margin-top:2px; position:relative;}
.opt-card.active .radio{border-color:var(--orange);}
.opt-card.active .radio:after{content:""; position:absolute; inset:2px; border-radius:50%; background:var(--orange);}
.opt-card .radio.sq{border-radius:5px;}
.opt-card.active .radio.sq:after{border-radius:2px;}
.opt-card strong{display:block; font-size:13.5px; font-family:'Barlow Condensed'; color:white; font-weight:700;}
.opt-card span{display:block; font-size:11.5px; color:var(--muted); margin-top:2px; line-height:1.4;}
.badge-inline{
    display:inline-block; font-size:10px; font-weight:700; padding:2px 7px; border-radius:999px;
    background:rgba(96,165,250,.16); color:var(--blue); margin-top:4px;
}

.swatches{display:flex; gap:9px; flex-wrap:wrap;}
.swatch{width:34px; height:34px; border-radius:50%; border:2px solid transparent; outline:1.5px solid var(--steel); transition:.16s;}
.swatch:hover{transform:scale(1.08);}
.swatch.active{border-color:white; outline-color:white; transform:scale(1.08);}
.color-custom{display:flex; align-items:center; gap:10px; margin-top:14px; flex-wrap:wrap;}
.color-custom input[type=color]{width:42px; height:38px; border:1px solid var(--steel); border-radius:8px; background:#181B22; padding:2px;}
.color-custom input[type=text]{width:120px; text-transform:uppercase; font-family:'Barlow Condensed'; font-weight:700;}

/* ===== Change reason box ===== */
.reason-box{
    margin-top:14px; background:rgba(255,138,31,.06); border:1px dashed rgba(255,138,31,.4);
    border-radius:10px; padding:14px; display:none;
}
.reason-box.show{display:block;}
.reason-box label{font-size:11.5px; text-transform:uppercase; letter-spacing:.06em; color:var(--orange); font-weight:700; display:block; margin-bottom:8px;}

/* ===== Form fields (tái sử dụng) ===== */
.form-field{margin-bottom:14px;}
.form-field label{display:block; font-size:11.5px; text-transform:uppercase; letter-spacing:.06em; color:var(--muted); margin-bottom:6px; font-weight:600;}
.form-field input, .form-field select, .form-field textarea{
    width:100%; background:#181B22; border:1px solid var(--steel); border-radius:9px;
    padding:11px 13px; color:var(--off); font-family:inherit; font-size:13.5px; outline:none; transition:.16s;
}
.form-field input:focus, .form-field select:focus, .form-field textarea:focus{
    border-color:var(--orange); box-shadow:0 0 0 3px rgba(255,138,31,.15);
}
.form-field textarea{resize:vertical; min-height:78px;}
.form-row{display:grid; grid-template-columns:repeat(2,1fr); gap:12px;}
.form-row.three{grid-template-columns:repeat(3,1fr);}
.radio-list{display:flex; flex-direction:column; gap:8px;}
.radio-list label{
    display:flex; align-items:center; gap:10px; background:#181B22; border:1px solid var(--steel);
    padding:11px 13px; border-radius:9px; font-size:13.5px; cursor:pointer; transition:.16s;
    text-transform:none; letter-spacing:0; font-weight:400; color:var(--off); margin-bottom:0;
}
.radio-list label:hover{border-color:var(--orange);}
.radio-list input{accent-color:var(--orange); width:16px; height:16px;}

/* ===== Machine row ===== */
.machine-row{display:flex; align-items:center; gap:14px; padding:12px 0; border-bottom:1px solid var(--steel);}
.machine-row:last-child{border-bottom:none;}
.machine-icon{width:42px; height:42px; border-radius:10px; background:#16181F; display:flex; align-items:center; justify-content:center; font-size:19px; flex-shrink:0; border:1px solid var(--steel);}
.machine-info{flex:1; min-width:0;}
.machine-info strong{display:block; font-size:14.5px; color:white; font-weight:600;}
.machine-info span{font-size:12px; color:var(--muted);}
.status-tag{font-size:11.5px; font-weight:700; padding:4px 10px; border-radius:999px; white-space:nowrap;}
.status-tag.run{background:rgba(52,211,153,0.16); color:var(--green);}
.status-tag.idle{background:rgba(154,160,176,0.16); color:var(--muted);}
.status-tag.maint{background:rgba(251,90,106,0.16); color:var(--red);}
.status-tag.sell{background:rgba(255,138,31,0.16); color:var(--orange);}

/* ===== Estimate rows ===== */
.est-row{display:flex; justify-content:space-between; font-size:13.5px; padding:8px 0; border-bottom:1px dashed var(--steel); color:var(--muted);}
.est-row:last-child{border-bottom:none;}
.est-row b{color:var(--off); font-weight:600;}
.est-row.total{border-top:1px solid var(--steel); border-bottom:none; margin-top:6px; padding-top:12px; font-size:15px;}
.est-row.total b{color:white; font-family:'Barlow Condensed'; font-size:19px;}
.est-tag{font-size:10.5px; font-weight:700; color:var(--muted); text-transform:uppercase; letter-spacing:.06em; margin-bottom:8px; display:block;}

/* ===== Pricing ===== */
.price-compare{display:flex; gap:14px; flex-wrap:wrap; margin-bottom:16px;}
.price-chip{flex:1; min-width:150px; background:#181B22; border:1px solid #232734; border-radius:10px; padding:14px;}
.price-chip span{display:block; font-size:11px; text-transform:uppercase; letter-spacing:.05em; color:var(--muted); margin-bottom:6px;}
.price-chip strong{font-family:'Barlow Condensed'; font-size:22px; color:white; font-weight:700;}
.price-chip.diff strong{color:var(--orange);}
.price-chip.pending strong{color:var(--muted); font-size:14px; font-family:'Barlow'; font-weight:600;}

/* ===== Schedule ===== */
.timeline{position:relative; padding-left:22px;}
.timeline:before{content:""; position:absolute; left:5px; top:4px; bottom:4px; width:2px; background:var(--steel);}
.tl-item{position:relative; padding-bottom:16px;}
.tl-item:last-child{padding-bottom:0;}
.tl-item:before{content:""; position:absolute; left:-22px; top:4px; width:12px; height:12px; border-radius:50%; background:var(--steel); border:2px solid var(--steel-2);}
.tl-item.done:before{background:var(--green); box-shadow:0 0 10px rgba(52,211,153,.6);}
.tl-item.active:before{background:var(--orange); box-shadow:0 0 0 4px rgba(255,138,31,0.15);}
.tl-item .tl-txt{font-size:13.5px; color:var(--off);}
.tl-item .tl-time{font-size:11.5px; color:var(--muted); margin-top:2px;}

/* ===== QC checklist (tái sử dụng) ===== */
.qc-item{display:flex; align-items:center; gap:12px; padding:11px 0; border-bottom:1px solid var(--steel);}
.qc-item:last-child{border-bottom:none;}
.qc-check{
    width:22px; height:22px; border-radius:7px; border:2px solid var(--steel);
    display:flex; align-items:center; justify-content:center; flex-shrink:0; cursor:pointer;
    font-size:12px; color:transparent; transition:.16s;
}
.qc-check:hover{border-color:var(--orange);}
.qc-check.checked{background:var(--grad-money); border-color:transparent; color:#0F1A15;}
.qc-item .qc-txt{flex:1; font-size:13.5px;}
.qc-item .qc-txt span{display:block; font-size:11.5px; color:var(--red); margin-top:1px;}
.qc-item.optional .qc-txt span{color:var(--muted);}

/* ===== Requirement quote ===== */
.req-quote{
    background:#181B22; border-left:3px solid var(--violet); border-radius:0 10px 10px 0;
    padding:14px 16px; font-size:13.5px; color:var(--off); line-height:1.6; white-space:pre-line;
}
.ref-file-row{display:flex; align-items:center; gap:12px; padding:10px 0; border-bottom:1px solid var(--steel); font-size:13px;}
.ref-file-row:last-child{border-bottom:none;}
.ref-file-row .ic{width:36px; height:36px; border-radius:9px; background:var(--steel-2); display:flex; align-items:center; justify-content:center; font-size:16px; flex-shrink:0;}
.ref-file-row .fn{flex:1; color:var(--off); font-weight:500;}
.ref-file-row .fa button{background:transparent; border:1px solid var(--steel); color:var(--off); padding:6px 11px; border-radius:7px; font-size:12px; font-weight:600;}
.ref-file-row .fa button:hover{border-color:var(--orange); color:var(--orange);}

/* ===== Activity log ===== */
.activity-row{display:flex; gap:12px; padding:10px 0; border-bottom:1px solid var(--steel); font-size:13px;}
.activity-row:last-child{border-bottom:none;}
.activity-row .t{color:var(--muted); font-size:11.5px; white-space:nowrap; padding-top:1px;}
.activity-row .m{color:var(--off);}
.activity-row .m b{color:white;}

/* ===== Buttons ===== */
.btn-start{background:var(--grad-hot); color:#1A1C22; box-shadow:0 4px 14px rgba(255,138,31,.28); padding:12px 20px; border-radius:9px; font-weight:700; font-size:13.5px; border:none;}
.btn-start:hover{filter:brightness(1.1); transform:translateY(-1px);}
.btn-done{background:var(--grad-money); color:#0F1A15; box-shadow:0 4px 14px rgba(52,211,153,.25); padding:12px 20px; border-radius:9px; font-weight:700; font-size:13.5px; border:none;}
.btn-done:hover{filter:brightness(1.1); transform:translateY(-1px);}
.btn-danger{background:rgba(251,90,106,.15); color:var(--red); border:1px solid rgba(251,90,106,.4); padding:12px 20px; border-radius:9px; font-weight:700; font-size:13.5px;}
.btn-danger:hover{background:var(--red); color:#fff;}
.btn-edit{background:rgba(139,92,246,.16); color:#B79BFF; border:1px solid rgba(139,92,246,.4); padding:10px 16px; border-radius:9px; font-weight:700; font-size:13px;}
.btn-edit:hover{background:var(--violet); color:#fff;}
.btn-ghost{background:transparent; border:1px solid var(--steel); color:var(--off); padding:12px 20px; border-radius:9px; font-weight:700; font-size:13.5px;}
.btn-ghost:hover{border-color:var(--orange); color:var(--orange);}
.btn-sm{padding:8px 13px !important; font-size:12.5px !important;}
button:disabled{opacity:.45; cursor:not-allowed !important; filter:none !important; transform:none !important;}

/* ===== Sticky action bar ===== */
.action-bar{
    position:fixed; left:0; right:0; bottom:0; z-index:60;
    background:linear-gradient(180deg,#1D2028,#171920); border-top:1px solid var(--steel);
    padding:14px 28px; display:flex; align-items:center; justify-content:space-between; gap:16px; flex-wrap:wrap;
    box-shadow:0 -10px 30px rgba(0,0,0,.35);
}
.action-bar .checklist-status{font-size:12.5px; color:var(--muted);}
.action-bar .checklist-status b{color:var(--off);}
.action-bar .btns{display:flex; gap:10px; flex-wrap:wrap;}

/* ===== Modal (tái sử dụng) ===== */
.overlay{position:fixed; inset:0; background:rgba(8,9,13,0.72); backdrop-filter:blur(3px); opacity:0; pointer-events:none; transition:.2s; z-index:90;}
.overlay.show{opacity:1; pointer-events:auto;}
.modal{position:fixed; inset:0; display:flex; align-items:center; justify-content:center; z-index:100; opacity:0; pointer-events:none; transition:.2s; padding:20px;}
.modal.show{opacity:1; pointer-events:auto;}
.modal-box{
    background:linear-gradient(180deg,#262A35,#1E2129); border:1px solid var(--steel); border-radius:16px;
    padding:26px; width:560px; max-width:100%; max-height:90vh; overflow-y:auto;
    box-shadow:0 24px 60px rgba(0,0,0,.6); position:relative;
}
.modal-box h3{font-size:24px; color:white; margin-bottom:6px;}
.modal-box .sub{font-size:13px; color:var(--muted); margin-bottom:20px;}
.modal-close{position:absolute; top:16px; right:18px; background:none; border:none; font-size:20px; color:var(--muted); transition:.15s;}
.modal-close:hover{color:var(--red);}
.modal-head{position:relative;}
.modal-actions{display:flex; gap:10px; justify-content:flex-end; margin-top:20px;}
.confirm-check{display:flex; align-items:flex-start; gap:10px; font-size:13.5px; margin-top:16px; cursor:pointer; background:#181B22; border:1px solid var(--steel); border-radius:9px; padding:12px 14px;}
.confirm-check input{margin-top:2px; accent-color:var(--orange); width:16px; height:16px; flex-shrink:0;}

/* ===== Toast (tái sử dụng) ===== */
.toast{
    position:fixed; bottom:96px; left:50%; transform:translate(-50%,90px);
    background:var(--grad-hot); color:#1A1C22; padding:13px 24px; border-radius:11px;
    font-size:14px; font-weight:700; z-index:200; transition:.25s; opacity:0;
    box-shadow:0 12px 34px rgba(255,138,31,.4); max-width:90vw; text-align:center;
}
.toast.show{transform:translate(-50%,0); opacity:1;}
.toast.danger{background:linear-gradient(135deg,#FB5A6A,#D6455A); color:white;}

/* ===== Responsive ===== */
@media (max-width:1200px){
    .layout-main{grid-template-columns:1fr;}
    .layout-2{grid-template-columns:1fr;}
    .opt-cards{grid-template-columns:repeat(2,1fr);}
}
@media (max-width:900px){
    .topbar, .breadcrumb-bar{padding:12px 16px;}
    .content{padding:20px 16px 130px;}
    .detail-grid{grid-template-columns:1fr;}
    .dims-row{grid-template-columns:repeat(2,1fr);}
    .form-row, .form-row.three{grid-template-columns:1fr;}
    .opt-cards{grid-template-columns:1fr;}
    .compare-table{display:block; overflow-x:auto; white-space:nowrap;}
    .status-track{gap:0;}
    .status-step{min-width:90px;}
    .action-bar{padding:12px 16px; flex-direction:column; align-items:stretch;}
    .action-bar .btns{width:100%;}
    .action-bar .btns button{flex:1;}
    .price-compare{flex-direction:column;}
}
</style>
</head>
<body>

<!-- ============ TOPBAR (tái sử dụng nguyên bản) ============ -->
<div class="topbar">
    <div class="brand">
        <span class="mark"></span>
        <div><h1>Sài Gòn Print</h1><span>Cổng xưởng sản xuất · PrintKraft</span></div>
    </div>
    <div class="shift-info">
        <div>Thứ Bảy, 26/09/2026 — <span id="clock">19:10</span></div>
        <div class="op-avatar" title="Đặng Long">ĐL</div>
    </div>
</div>

<!-- ============ BREADCRUMB ============ -->
<div class="breadcrumb-bar">
    <a href="danh-sach-don-hang-xuong.jsp" class="back-link">← Quay lại danh sách đơn</a>
    <div class="crumbs">Đơn hàng &nbsp;/&nbsp; Chi tiết đơn &nbsp;/&nbsp; <b>#3DP-20260926-00125</b></div>
</div>

<div class="content">

    <!-- ============ ORDER HEAD ============ -->
    <div class="order-head">
        <div>
            <h2>Chi tiết đơn hàng</h2>
            <div class="oid">#3DP-20260926-00125 · Đặt lúc 26/09/2026 18:32</div>
        </div>
        <div class="meta-r">
            <div class="status-pill pending" id="statusPill"><span class="dot"></span> Chờ xưởng xác nhận</div>
            <div class="deadline-chip" id="deadlineChip">Còn lại: 17 giờ 42 phút để xác nhận</div>
        </div>
    </div>

    <!-- ============ ORDER STATUS TRACK ============ -->
    <div class="panel">
        <h3>Trạng thái đơn hàng</h3>
        <div class="status-track" id="statusTrack"></div>
    </div>

    <!-- ============ ORDER INFO + CUSTOMER + DELIVERY ============ -->
    <div class="layout-2">
        <div class="panel">
            <h3>Thông tin đơn hàng</h3>
            <div class="detail-grid">
                <div class="field"><label>Mã đơn</label><strong>#3DP-20260926-00125</strong></div>
                <div class="field"><label>Ngày đặt</label><strong>26/09/2026 18:32</strong></div>
                <div class="field"><label>Số lượng</label><strong>10 sản phẩm</strong></div>
                <div class="field"><label>Số mô hình</label><strong>1 model</strong></div>
                <div class="field"><label>Deadline khách yêu cầu</label><strong style="color:var(--red);">29/09/2026</strong></div>
                <div class="field"><label>Mức ưu tiên</label><strong>Tiêu chuẩn</strong></div>
                <div class="field" style="grid-column:1/-1;"><label>Phương thức giao hàng</label><strong>Giao hàng tiêu chuẩn</strong></div>
            </div>
        </div>

        <div class="panel">
            <h3>Khách hàng</h3>
            <div class="cust-row">
                <div class="cust-avatar">NA</div>
                <div><strong>Nguyễn Văn A</strong><span>Mã khách hàng: KH-004821</span></div>
            </div>
            <div class="contact-line"><span class="ic">☎</span> 09xx xxx xxx</div>
            <div class="contact-line"><span class="ic">✉</span> customer@example.com</div>
            <button class="btn-edit" style="margin-top:12px; width:100%;" onclick="openModal('chatModal')">💬 Chat với khách</button>
        </div>
    </div>

    <div class="panel">
        <h3>Địa chỉ giao hàng</h3>
        <div class="detail-grid">
            <div class="field"><label>Người nhận</label><strong>Nguyễn Văn A</strong></div>
            <div class="field"><label>Số điện thoại</label><strong>09xx xxx xxx</strong></div>
            <div class="field" style="grid-column:1/-1;"><label>Địa chỉ</label><strong>123 Nguyễn Văn Cừ, Phường An Khánh, TP. Thủ Đức, TP. Hồ Chí Minh</strong></div>
            <div class="field"><label>Phương thức</label><strong>Giao hàng tiêu chuẩn</strong></div>
            <div class="field"><label>Ngày mong muốn nhận</label><strong>29/09/2026</strong></div>
        </div>
    </div>

    <!-- ============ 3D MODEL VIEWER + FILE ============ -->
    <div class="panel viewer-panel">
        <div class="panel-head ph">
            <h3>Xem mô hình 3D</h3>
            <span class="hint">Kéo để xoay · Lăn chuột để zoom · Giữ Shift để di chuyển</span>
        </div>
        <div class="stage" id="stage">
            <div class="stage-badge" id="stageBadge">Đang tải…</div>
            <div class="stage-empty" id="stageEmpty" style="display:none;">
                <div class="ic">⬆</div>
                <h4>Không thể hiển thị model</h4>
                <p>File có thể lỗi hoặc định dạng chưa hỗ trợ xem trước. Tải file gốc để kiểm tra bằng phần mềm CAD.</p>
            </div>
            <div class="stage-hint" id="stageHint" style="display:none;"></div>
        </div>
        <div class="viewer-tools">
            <button type="button" id="btnSpin" disabled>Auto Rotate</button>
            <button type="button" id="btnZoomIn" disabled>Zoom +</button>
            <button type="button" id="btnZoomOut" disabled>Zoom −</button>
            <button type="button" id="btnReset" disabled>Reset View</button>
            <button type="button" id="btnFull" disabled>⛶ Fullscreen</button>
            <div class="spacer"></div>
        </div>
        <div class="file-strip">
            <div class="fi">File: <strong id="fName">dragon.stl</strong> · <span id="fMeta">STL · 8.4 MB</span> · v1</div>
            <div class="fa">
                <button class="btn-ghost btn-sm" id="btnFocusView">Xem 3D</button>
                <button class="btn-ghost btn-sm" id="btnDownload">⬇ Tải xuống</button>
                <button class="btn-edit btn-sm" onclick="openModal('askUpdateModal')">Yêu cầu upload lại</button>
            </div>
        </div>
    </div>

    <!-- ============ MODEL ANALYSIS ============ -->
    <div class="panel">
        <h3>Phân tích mô hình</h3>
        <div class="dims-row">
            <div class="dim"><span>X</span><strong id="dimX">120 mm</strong></div>
            <div class="dim"><span>Y</span><strong id="dimY">80 mm</strong></div>
            <div class="dim"><span>Z</span><strong id="dimZ">50 mm</strong></div>
            <div class="dim vol"><span>Thể tích</span><strong id="dimV">125.4 cm³</strong></div>
        </div>
        <div class="dims-row" style="grid-template-columns:repeat(3,1fr); margin-bottom:18px;">
            <div class="dim"><span>Diện tích bề mặt</span><strong>342.8 cm²</strong></div>
            <div class="dim"><span>Số mesh</span><strong>1</strong></div>
            <div class="dim"><span>Trạng thái model</span><strong style="color:var(--green);">✓ Hợp lệ</strong></div>
        </div>
        <div class="warn-list" id="analysisWarnings">
            <div class="alert-row warn"><span class="ic">⚠</span><div class="txt"><strong>Model có overhang lớn</strong><span>Ước tính (mock) — cần tree support ở phần cánh để tránh sụp khi in.</span></div></div>
            <div class="alert-row info"><span class="ic">ℹ</span><div class="txt"><strong>Model gần giới hạn build volume của một số máy nhỏ</strong><span>Kiểm tra kỹ khi chọn máy in bên dưới.</span></div></div>
        </div>
    </div>

    <!-- ============ PRODUCTION FEASIBILITY ============ -->
    <div class="panel">
        <h3>Kiểm tra khả năng sản xuất</h3>
        <div class="feas-result pass" id="feasResult">
            <span class="ic">✓</span>
            <div><strong id="feasTitle">Có thể in</strong><span id="feasSub">Model 120 × 80 × 50 mm nằm trong vùng in 256 × 256 × 256 mm của máy đã chọn.</span></div>
        </div>
        <div class="feas-list" id="feasList"></div>
    </div>

    <!-- ============ PRINT CONFIGURATION ============ -->
    <div class="panel">
        <div class="panel-head">
            <h3>Cấu hình sản xuất</h3>
            <span class="hint">Mọi thay đổi so với yêu cầu của khách đều cần ghi rõ lý do</span>
        </div>

        <table class="compare-table" id="compareTable">
            <thead><tr><th style="width:170px;">Thông số</th><th>Khách yêu cầu</th><th>Xưởng xác nhận</th></tr></thead>
            <tbody id="compareBody"></tbody>
        </table>

        <!-- Công nghệ -->
        <div style="margin-top:22px;">
            <span class="hint" style="display:block; margin-bottom:10px; text-transform:uppercase; font-size:11.5px; letter-spacing:.06em; color:var(--muted); font-weight:700;">Công nghệ in</span>
            <div class="opt-cards" id="techList"></div>
            <div class="reason-box" id="techReasonBox">
                <label>Lý do thay đổi công nghệ</label>
                <textarea id="techReason" placeholder="Ví dụ: Model yêu cầu độ chi tiết cao hơn, phù hợp với SLA hơn FDM."></textarea>
            </div>
        </div>

        <!-- Máy in -->
        <div style="margin-top:22px;">
            <span class="hint" style="display:block; margin-bottom:10px; text-transform:uppercase; font-size:11.5px; letter-spacing:.06em; color:var(--muted); font-weight:700;">Máy in</span>
            <div class="form-field" style="max-width:340px;">
                <select id="printerSelect"></select>
            </div>
            <div class="detail-grid" style="margin-top:4px;">
                <div class="field"><label>Build volume</label><strong id="pV">—</strong></div>
                <div class="field"><label>Nozzle</label><strong id="pN">—</strong></div>
                <div class="field"><label>Trạng thái</label><strong id="pS">—</strong></div>
                <div class="field"><label>Hàng chờ</label><strong id="pQ">—</strong></div>
            </div>
        </div>

        <!-- Vật liệu -->
        <div style="margin-top:22px;">
            <span class="hint" style="display:block; margin-bottom:10px; text-transform:uppercase; font-size:11.5px; letter-spacing:.06em; color:var(--muted); font-weight:700;">Vật liệu</span>
            <div class="opt-cards" id="materialList"></div>
            <div class="reason-box" id="matReasonBox">
                <label>Lý do thay đổi vật liệu</label>
                <textarea id="matReason" placeholder="Ví dụ: PETG phù hợp hơn với yêu cầu chịu lực."></textarea>
            </div>
        </div>

        <!-- Màu -->
        <div style="margin-top:22px;">
            <span class="hint" style="display:block; margin-bottom:10px; text-transform:uppercase; font-size:11.5px; letter-spacing:.06em; color:var(--muted); font-weight:700;">Màu sắc</span>
            <div class="swatches" id="swatches"></div>
            <div class="color-custom">
                <input type="color" id="colorPicker" value="#1A1A1A">
                <input type="text" id="colorHex" value="#1A1A1A" maxlength="7">
                <span class="hint">Màu thực tế có thể khác với màu hiển thị trên màn hình.</span>
            </div>
            <div class="reason-box" id="colorReasonBox">
                <label>Lý do thay đổi màu</label>
                <textarea id="colorReason" placeholder="Ví dụ: Không có sẵn nguyên liệu màu khách yêu cầu."></textarea>
            </div>
        </div>

        <!-- Chất lượng -->
        <div style="margin-top:22px;">
            <span class="hint" style="display:block; margin-bottom:10px; text-transform:uppercase; font-size:11.5px; letter-spacing:.06em; color:var(--muted); font-weight:700;">Chất lượng bề mặt</span>
            <div class="opt-cards" id="qualityList"></div>
            <div class="reason-box" id="qualReasonBox">
                <label>Lý do thay đổi chất lượng</label>
                <textarea id="qualReason" placeholder="Ví dụ: Fine không cần thiết cho chi tiết này, đề xuất Normal để giảm thời gian in."></textarea>
            </div>
        </div>

        <!-- Cấu hình nâng cao -->
        <details style="margin-top:22px; background:#181B22; border:1px solid var(--steel); border-radius:10px; padding:14px 16px;">
            <summary style="cursor:pointer; font-weight:700; font-size:13.5px; list-style:none;">Cấu hình nâng cao (Infill / Wall / Support)</summary>
            <div class="form-row three" style="margin-top:16px;">
                <div class="form-field"><label>Infill (%)</label><input type="number" id="advInfill" value="30" min="0" max="100"></div>
                <div class="form-field"><label>Wall count</label><input type="number" id="advWall" value="3" min="1"></div>
                <div class="form-field"><label>Layer height (mm)</label><input type="text" id="advLayer" value="0.12" readonly></div>
            </div>
            <div class="form-row three">
                <div class="form-field"><label>Top layers</label><input type="number" id="advTop" value="4" min="0"></div>
                <div class="form-field"><label>Bottom layers</label><input type="number" id="advBottom" value="4" min="0"></div>
                <div class="form-field">
                    <label>Support</label>
                    <select id="advSupport">
                        <option>Tree Support</option>
                        <option>Normal Support</option>
                        <option>Không dùng support</option>
                    </select>
                </div>
            </div>
            <span class="hint" id="advChangedNote" style="display:none; color:var(--orange);">Đã thay đổi so với cấu hình khách yêu cầu.</span>
        </details>

        <!-- Hướng đặt model -->
        <div style="margin-top:22px;">
            <span class="hint" style="display:block; margin-bottom:10px; text-transform:uppercase; font-size:11.5px; letter-spacing:.06em; color:var(--muted); font-weight:700;">Hướng đặt model</span>
            <div class="form-row three">
                <div class="form-field"><label>Rotation X</label><input type="number" id="rotX" value="0">°</div>
                <div class="form-field"><label>Rotation Y</label><input type="number" id="rotY" value="15">°</div>
                <div class="form-field"><label>Rotation Z</label><input type="number" id="rotZ" value="90">°</div>
            </div>
            <button class="btn-ghost btn-sm" id="btnAutoOrient">↻ Auto Orient (đề xuất tự động)</button>
        </div>

        <!-- Hậu xử lý -->
        <div style="margin-top:22px;">
            <span class="hint" style="display:block; margin-bottom:10px; text-transform:uppercase; font-size:11.5px; letter-spacing:.06em; color:var(--muted); font-weight:700;">Gia công sau in</span>
            <div class="opt-cards" id="postList" style="grid-template-columns:repeat(3,1fr);"></div>
            <div class="reason-box" id="postReasonBox">
                <label>Lý do điều chỉnh gia công</label>
                <textarea id="postReason" placeholder="Ví dụ: Xưởng đề xuất thêm bước chà nhám để bề mặt mịn hơn."></textarea>
            </div>
        </div>
    </div>

    <!-- ============ ESTIMATED PRODUCTION + COST ============ -->
    <div class="layout-2">
        <div class="panel">
            <h3>Ước tính sản xuất</h3>
            <span class="est-tag">Estimated — chưa phải kết quả chính xác</span>
            <div class="est-row"><span>Thời gian in</span><b>4h 32m</b></div>
            <div class="est-row"><span>Chuẩn bị</span><b>20m</b></div>
            <div class="est-row"><span>Hậu xử lý</span><b>40m</b></div>
            <div class="est-row"><span>Kiểm tra QC</span><b>15m</b></div>
            <div class="est-row total"><span>Tổng thời gian</span><b>5h 47m</b></div>
            <div style="margin-top:16px;">
                <div class="est-row"><span>Vật liệu model</span><b>72 g</b></div>
                <div class="est-row"><span>Support</span><b>18 g</b></div>
                <div class="est-row"><span>Hao hụt</span><b>5 g</b></div>
                <div class="est-row total"><span>Tổng vật liệu</span><b>95 g</b></div>
            </div>
        </div>

        <div class="panel">
            <h3>Chi phí sản xuất</h3>
            <span class="est-tag">Xưởng có thể điều chỉnh từng khoản</span>
            <div class="form-field" style="display:flex; justify-content:space-between; align-items:center; gap:10px; margin-bottom:10px;">
                <label style="margin:0; flex:1;">Vật liệu</label><input type="text" value="65.000đ" style="max-width:120px; text-align:right;">
            </div>
            <div class="form-field" style="display:flex; justify-content:space-between; align-items:center; gap:10px; margin-bottom:10px;">
                <label style="margin:0; flex:1;">Máy</label><input type="text" value="80.000đ" style="max-width:120px; text-align:right;">
            </div>
            <div class="form-field" style="display:flex; justify-content:space-between; align-items:center; gap:10px; margin-bottom:10px;">
                <label style="margin:0; flex:1;">Nhân công</label><input type="text" value="30.000đ" style="max-width:120px; text-align:right;">
            </div>
            <div class="form-field" style="display:flex; justify-content:space-between; align-items:center; gap:10px; margin-bottom:10px;">
                <label style="margin:0; flex:1;">Gia công</label><input type="text" value="40.000đ" style="max-width:120px; text-align:right;">
            </div>
            <div class="form-field" style="display:flex; justify-content:space-between; align-items:center; gap:10px; margin-bottom:10px;">
                <label style="margin:0; flex:1;">Đóng gói</label><input type="text" value="15.000đ" style="max-width:120px; text-align:right;">
            </div>
            <div class="form-field" style="display:flex; justify-content:space-between; align-items:center; gap:10px; margin-bottom:0;">
                <label style="margin:0; flex:1;">Vận chuyển</label><input type="text" value="25.000đ" style="max-width:120px; text-align:right;">
            </div>
            <div class="est-row total" style="margin-top:14px;"><span>Tạm tính xưởng</span><b>255.000đ</b></div>

            <div class="price-compare" style="margin-top:18px;">
                <div class="price-chip"><span>Giá khách đặt</span><strong>350.000đ</strong></div>
                <div class="price-chip"><span>Giá xưởng đề xuất</span><strong>370.000đ</strong></div>
                <div class="price-chip diff"><span>Chênh lệch</span><strong>+20.000đ</strong></div>
            </div>
            <div class="reason-box show" style="margin-top:0;">
                <label>Lý do thay đổi giá</label>
                <textarea placeholder="Ví dụ: Chi phí gia công bề mặt cao hơn so với ước tính ban đầu.">Chi phí gia công bề mặt cao hơn so với ước tính ban đầu.</textarea>
            </div>
        </div>
    </div>

    <!-- ============ PRODUCTION SCHEDULE ============ -->
    <div class="panel">
        <h3>Lịch sản xuất</h3>
        <div class="alert-row warn" style="margin-bottom:16px;" id="scheduleWarning">
            <span class="ic">⚠</span>
            <div class="txt"><strong>Thời gian dự kiến hoàn thành sát deadline khách yêu cầu</strong><span>Chỉ còn 0 ngày dự phòng — cân nhắc ưu tiên đơn này.</span></div>
        </div>
        <div class="detail-grid">
            <div class="field"><label>Ngày bắt đầu</label><strong>27/09/2026</strong></div>
            <div class="field"><label>Thời gian in</label><strong>1 ngày</strong></div>
            <div class="field"><label>Hậu xử lý</label><strong>1 ngày</strong></div>
            <div class="field"><label>QC</label><strong>1 ngày</strong></div>
            <div class="field"><label>Dự kiến hoàn thành</label><strong>29/09/2026</strong></div>
            <div class="field"><label>Dự kiến giao</label><strong style="color:var(--orange);">30/09/2026</strong></div>
        </div>
    </div>

    <!-- ============ CUSTOMER REQUIREMENTS ============ -->
    <div class="layout-2">
        <div class="panel">
            <div class="panel-head">
                <h3>Yêu cầu đặc biệt của khách hàng</h3>
                <button class="btn-ghost btn-sm" onclick="openModal('chatModal')">💬 Chat với khách</button>
            </div>
            <div class="req-quote">Phần lỗ này cần giữ đường kính 10 mm.
Vui lòng kiểm tra kỹ trước khi in.</div>

            <div style="margin-top:18px;">
                <span class="hint" style="display:block; margin-bottom:8px; text-transform:uppercase; font-size:11px; letter-spacing:.05em; color:var(--muted); font-weight:700;">File / hình ảnh tham khảo</span>
                <div class="ref-file-row">
                    <span class="ic">📄</span><span class="fn">technical-drawing.pdf</span>
                    <div class="fa"><button>Xem</button><button>Tải xuống</button></div>
                </div>
                <div class="ref-file-row">
                    <span class="ic">🖼️</span><span class="fn">reference.jpg</span>
                    <div class="fa"><button>Xem</button><button>Tải xuống</button></div>
                </div>
            </div>
        </div>

        <div class="panel">
            <h3>Ghi chú của xưởng</h3>
            <div class="form-field" style="margin-bottom:0;">
                <textarea id="supplierNote" rows="7" placeholder="Ghi chú nội bộ hoặc thông tin muốn gửi cho khách...">Model có overhang lớn. Xưởng sử dụng tree support. Có thể để lại dấu support nhỏ ở mặt dưới.</textarea>
            </div>
        </div>
    </div>

    <!-- ============ CONFIRMATION CHECKLIST ============ -->
    <div class="panel">
        <h3>Checklist trước khi xác nhận</h3>
        <div id="checklist"></div>
    </div>

    <!-- ============ ACTIVITY HISTORY ============ -->
    <div class="panel">
        <h3>Lịch sử đơn hàng</h3>
        <div id="activityLog"></div>
    </div>

</div>

<!-- ============ STICKY ACTION BAR ============ -->
<div class="action-bar">
    <div class="checklist-status" id="checklistStatus">Đã hoàn thành <b>0/9</b> mục checklist bắt buộc</div>
    <div class="btns">
        <button class="btn-ghost" id="btnSaveDraft">Lưu nháp</button>
        <button class="btn-danger" id="btnReject">✕ Từ chối đơn</button>
        <button class="btn-edit" id="btnRevision" style="background:rgba(255,138,31,.14); color:var(--orange); border-color:rgba(255,138,31,.4);">Yêu cầu chỉnh sửa</button>
        <button class="btn-done" id="btnConfirm" disabled>✓ Xác nhận nhận đơn</button>
    </div>
</div>

<!-- ============ MODAL: CHAT (đơn giản, tái sử dụng khung modal) ============ -->
<div class="overlay" id="chatModalOverlay" onclick="closeModal('chatModal')"></div>
<div class="modal" id="chatModal">
    <div class="modal-box">
        <div class="modal-head">
            <button class="modal-close" onclick="closeModal('chatModal')">×</button>
            <h3>Chat với Nguyễn Văn A</h3>
            <p class="sub">Trao đổi trực tiếp về đơn #3DP-20260926-00125.</p>
        </div>
        <div class="form-field"><textarea placeholder="Nhập tin nhắn..." rows="4"></textarea></div>
        <div class="modal-actions">
            <button class="btn-ghost" onclick="closeModal('chatModal')">Đóng</button>
            <button class="btn-start" onclick="toast('Đã gửi tin nhắn cho khách'); closeModal('chatModal')">Gửi</button>
        </div>
    </div>
</div>

<!-- ============ MODAL: YÊU CẦU KHÁCH UPLOAD LẠI ============ -->
<div class="overlay" id="askUpdateModalOverlay" onclick="closeModal('askUpdateModal')"></div>
<div class="modal" id="askUpdateModal">
    <div class="modal-box">
        <div class="modal-head">
            <button class="modal-close" onclick="closeModal('askUpdateModal')">×</button>
            <h3>Yêu cầu khách upload lại file</h3>
            <p class="sub">Xưởng không thể chỉnh sửa file gốc — gửi yêu cầu để khách tải file mới.</p>
        </div>
        <div class="form-field"><label>Lý do</label><textarea placeholder="Ví dụ: File hiện tại bị lỗi mesh ở phần đế, vui lòng xuất lại và tải lên." rows="4"></textarea></div>
        <div class="modal-actions">
            <button class="btn-ghost" onclick="closeModal('askUpdateModal')">Hủy</button>
            <button class="btn-start" onclick="toast('Đã gửi yêu cầu upload lại file'); closeModal('askUpdateModal')">Gửi yêu cầu</button>
        </div>
    </div>
</div>

<!-- ============ MODAL: XÁC NHẬN NHẬN ĐƠN ============ -->
<div class="overlay" id="confirmModalOverlay" onclick="closeModal('confirmModal')"></div>
<div class="modal" id="confirmModal">
    <div class="modal-box">
        <div class="modal-head">
            <button class="modal-close" onclick="closeModal('confirmModal')">×</button>
            <h3>Xác nhận nhận đơn?</h3>
            <p class="sub">Kiểm tra lại tóm tắt trước khi xác nhận với khách hàng.</p>
        </div>
        <div class="detail-grid" id="confirmSummary"></div>
        <label class="confirm-check">
            <input type="checkbox" id="confirmCheckbox">
            Tôi đã kiểm tra thông tin đơn hàng và xác nhận có thể sản xuất.
        </label>
        <div class="modal-actions">
            <button class="btn-ghost" onclick="closeModal('confirmModal')">Hủy</button>
            <button class="btn-done" id="btnConfirmFinal" disabled>Xác nhận nhận đơn</button>
        </div>
    </div>
</div>

<!-- ============ MODAL: YÊU CẦU CHỈNH SỬA ============ -->
<div class="overlay" id="revisionModalOverlay" onclick="closeModal('revisionModal')"></div>
<div class="modal" id="revisionModal">
    <div class="modal-box">
        <div class="modal-head">
            <button class="modal-close" onclick="closeModal('revisionModal')">×</button>
            <h3>Yêu cầu chỉnh sửa</h3>
            <p class="sub">Đơn sẽ chuyển về trạng thái chờ khách cập nhật.</p>
        </div>
        <div class="radio-list" id="revisionReasons">
            <label><input type="radio" name="revReason" value="file"> File model không hợp lệ</label>
            <label><input type="radio" name="revReason" value="size"> Kích thước không phù hợp</label>
            <label><input type="radio" name="revReason" value="info"> Thiếu thông tin</label>
            <label><input type="radio" name="revReason" value="material"> Yêu cầu vật liệu không phù hợp</label>
            <label><input type="radio" name="revReason" value="deadline"> Deadline không khả thi</label>
            <label><input type="radio" name="revReason" value="config"> Cần khách xác nhận lại cấu hình</label>
            <label><input type="radio" name="revReason" value="other"> Khác</label>
        </div>
        <div class="form-field" style="margin-top:14px;"><label>Chi tiết yêu cầu</label><textarea id="revisionDetail" rows="4" placeholder="Mô tả cụ thể vấn đề để khách dễ chỉnh sửa..."></textarea></div>
        <div class="modal-actions">
            <button class="btn-ghost" onclick="closeModal('revisionModal')">Hủy</button>
            <button class="btn-start" id="btnSendRevision">Gửi yêu cầu</button>
        </div>
    </div>
</div>

<!-- ============ MODAL: TỪ CHỐI ĐƠN ============ -->
<div class="overlay" id="rejectModalOverlay" onclick="closeModal('rejectModal')"></div>
<div class="modal" id="rejectModal">
    <div class="modal-box">
        <div class="modal-head">
            <button class="modal-close" onclick="closeModal('rejectModal')">×</button>
            <h3>Từ chối đơn hàng</h3>
            <p class="sub">Hành động này không thể hoàn tác — đơn sẽ được chuyển cho xưởng khác.</p>
        </div>
        <div class="radio-list" id="rejectReasons">
            <label><input type="radio" name="rejReason" value="cannot"> Không thể sản xuất</label>
            <label><input type="radio" name="rejReason" value="model"> Model không phù hợp</label>
            <label><input type="radio" name="rejReason" value="machine"> Không có máy phù hợp</label>
            <label><input type="radio" name="rejReason" value="material"> Không có vật liệu</label>
            <label><input type="radio" name="rejReason" value="deadline"> Không đáp ứng deadline</label>
            <label><input type="radio" name="rejReason" value="technical"> Yêu cầu kỹ thuật không khả thi</label>
            <label><input type="radio" name="rejReason" value="other"> Khác</label>
        </div>
        <div class="form-field" style="margin-top:14px;"><label>Lý do chi tiết (bắt buộc)</label><textarea id="rejectDetail" rows="4" placeholder="Bắt buộc nhập lý do trước khi từ chối đơn..."></textarea></div>
        <div class="modal-actions">
            <button class="btn-ghost" onclick="closeModal('rejectModal')">Hủy</button>
            <button class="btn-danger" id="btnSendReject">Từ chối đơn</button>
        </div>
    </div>
</div>

<div class="toast" id="toast"></div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
<script>
/* ============================================================
   1. DỮ LIỆU (mock — thay bằng API sau này)
   ============================================================ */
const order = {
    id:'#3DP-20260926-00125', status:'PENDING_SUPPLIER_CONFIRMATION',
    createdAt:'26/09/2026 18:32', deadline:'29/09/2026', quantity:10
};

const STATUS_FLOW = [
    {id:'pending',  label:'Chờ xác nhận'},
    {id:'confirmed',label:'Đã xác nhận'},
    {id:'preparing',label:'Chuẩn bị SX'},
    {id:'printing', label:'Đang in'},
    {id:'post',     label:'Hậu xử lý'},
    {id:'qc',       label:'Kiểm tra QC'},
    {id:'packaging',label:'Đóng gói'},
    {id:'shipping', label:'Đang giao'},
    {id:'done',     label:'Hoàn thành'}
];
const CURRENT_STATUS_INDEX = 0; // "Chờ xác nhận"

const customerRequest = {
    technology:'fdm', material:'pla', color:{id:'black', hex:'#1A1A1A', name:'Đen'},
    quality:'fine', layer:0.12
};

const TECHNOLOGIES = [
    {id:'fdm', name:'FDM', build:{x:256,y:256,z:256}, desc:'Phổ biến, chi phí thấp.', materials:['pla','plap','petg','abs','asa','tpu','nylon','pc']},
    {id:'sla', name:'SLA', build:{x:145,y:145,z:175}, desc:'Resin, chi tiết cao.', materials:'resin'},
    {id:'msla',name:'MSLA',build:{x:218,y:123,z:230}, desc:'Resin, chi phí hợp lý.', materials:'resin'},
    {id:'dlp', name:'DLP', build:{x:192,y:120,z:280}, desc:'Resin, bề mặt mịn.', materials:'resin'},
    {id:'sls', name:'SLS', build:{x:300,y:300,z:300}, desc:'Bột nylon, không cần support.', materials:['pa12','pa11']},
    {id:'mjf', name:'MJF', build:{x:380,y:284,z:380}, desc:'Sản xuất loạt, đồng nhất cao.', materials:['pa12','pa11']}
];
const MATERIAL_NAMES = {
    pla:'PLA', plap:'PLA+', petg:'PETG', abs:'ABS', asa:'ASA', tpu:'TPU', nylon:'Nylon', pc:'PC',
    pa12:'PA12', pa11:'PA11',
    'std-resin':'Standard Resin','tough-resin':'Tough Resin','abs-resin':'ABS-like Resin','flex-resin':'Flexible Resin','eng-resin':'Engineering Resin'
};
const RESIN_MATERIALS = ['std-resin','tough-resin','abs-resin','flex-resin','eng-resin'];
const QUALITY_SETS = {
    fdm:[{id:'standard',name:'Standard',layer:0.28},{id:'normal',name:'Normal',layer:0.20},{id:'fine',name:'Fine',layer:0.12},{id:'ultra',name:'Ultra Fine',layer:0.08}],
    resin:[{id:'r-normal',name:'Normal',layer:0.10},{id:'r-fine',name:'Fine',layer:0.05},{id:'r-ultra',name:'Ultra Fine',layer:0.03}],
    powder:[{id:'p-standard',name:'Standard',layer:0.12},{id:'p-fine',name:'Fine',layer:0.08}]
};
const TECH_QUALITY_SET = {fdm:'fdm', sla:'resin', msla:'resin', dlp:'resin', sls:'powder', mjf:'powder'};
const COLORS = [
    {id:'black',name:'Đen',hex:'#1A1A1A'},{id:'white',name:'Trắng',hex:'#F5F5F5'},{id:'gray',name:'Xám',hex:'#8A8A99'},
    {id:'red',name:'Đỏ',hex:'#E03131'},{id:'blue',name:'Xanh dương',hex:'#1C7ED6'},{id:'yellow',name:'Vàng',hex:'#FAB005'},
    {id:'orange',name:'Cam',hex:'#FD7E14'},{id:'green',name:'Xanh lá',hex:'#2F9E44'}
];
const POST_OPTIONS = [
    {id:'support', name:'Remove Support', desc:'Tháo bỏ support sau khi in.'},
    {id:'cleaning',name:'Cleaning',       desc:'Vệ sinh bề mặt cơ bản.'},
    {id:'sanding', name:'Sanding',        desc:'Chà nhám làm mịn bề mặt.'},
    {id:'painting',name:'Painting',       desc:'Sơn theo màu yêu cầu.'},
    {id:'polishing',name:'Polishing',     desc:'Đánh bóng bề mặt.'},
    {id:'assembly', name:'Assembly',      desc:'Lắp ráp nhiều bộ phận.'}
];
const customerPost = ['support','cleaning'];

const PRINTERS = [
    {id:'x1c-01', name:'Bambu Lab X1 Carbon #1', build:{x:256,y:256,z:256}, nozzle:'0.4 mm', status:'Available', queue:2},
    {id:'x1c-02', name:'Bambu Lab X1 Carbon #2', build:{x:256,y:256,z:256}, nozzle:'0.4 mm', status:'Đang bận',  queue:5},
    {id:'sla-01', name:'Elegoo Saturn 3 Ultra',  build:{x:218,y:123,z:230}, nozzle:'—',      status:'Available', queue:1},
    {id:'sls-01', name:'Sinterit Lisa X',        build:{x:150,y:200,z:150}, nozzle:'—',      status:'Available', queue:0}
];

const model = {
    fileName:'dragon.stl', format:'STL', size:'8.4 MB', version:1,
    dimensions:{x:120,y:80,z:50}, volume:125.4
};

const ACTIVITY = [
    {t:'26/09 18:32', m:'Khách tạo đơn.'},
    {t:'26/09 18:35', m:'Hệ thống chuyển đơn đến xưởng.'},
    {t:'26/09 19:02', m:'Xưởng mở đơn.'}
];

const CHECKLIST_ITEMS = [
    'Đã kiểm tra file 3D', 'Model có thể sản xuất', 'Đã kiểm tra kích thước',
    'Đã kiểm tra máy in', 'Đã kiểm tra vật liệu', 'Đã kiểm tra deadline',
    'Đã kiểm tra yêu cầu khách', 'Đã xác nhận chi phí', 'Đã xác nhận thời gian sản xuất'
];

/* ============================================================
   2. TRẠNG THÁI XƯỞNG (những gì xưởng đang chỉnh)
   ============================================================ */
const supplier = {
    technology: customerRequest.technology,
    material: customerRequest.material,
    color: {...customerRequest.color},
    quality: customerRequest.quality,
    post: [...customerPost],
    printer: 'x1c-01'
};
const checklist = new Set();

const $ = id => document.getElementById(id);

/* ============================================================
   3. TOAST + MODAL (tái sử dụng cách đặt tên của hệ thống)
   ============================================================ */
function toast(msg, danger){
    const t = $('toast');
    t.textContent = msg;
    t.className = 'toast show' + (danger ? ' danger' : '');
    clearTimeout(t._t);
    t._t = setTimeout(() => t.className = 'toast' + (danger ? ' danger' : ''), 3000);
}
function openModal(id){ $(id).classList.add('show'); $(id + 'Overlay').classList.add('show'); }
function closeModal(id){ $(id).classList.remove('show'); $(id + 'Overlay').classList.remove('show'); }
document.addEventListener('keydown', e => {
    if(e.key !== 'Escape') return;
    ['chatModal','askUpdateModal','confirmModal','revisionModal','rejectModal'].forEach(closeModal);
});

/* ============================================================
   4. HELPERS
   ============================================================ */
const getTech = id => TECHNOLOGIES.find(t => t.id === id);
const matName = id => MATERIAL_NAMES[id] || id;
const getMaterials = techId => { const t = getTech(techId); return t.materials === 'resin' ? RESIN_MATERIALS : t.materials; };
const getQualities = techId => QUALITY_SETS[TECH_QUALITY_SET[techId]];
const qualityName = (techId, qId) => { const q = getQualities(techId).find(x => x.id === qId); return q ? `${q.name} – ${q.layer.toFixed(2)} mm` : '—'; };

function optCard(active, title, sub, square){
    return `<span class="radio${square ? ' sq' : ''}"></span>
      <span><strong>${title}</strong>${sub ? `<span>${sub}</span>` : ''}</span>`.replace('<span><strong>', '<span class="oc-body"><strong>');
}

/* ============================================================
   5. RENDER: STATUS TRACK
   ============================================================ */
function renderStatusTrack(){
    $('statusTrack').innerHTML = STATUS_FLOW.map((s, i) => `
        <div class="status-step ${i < CURRENT_STATUS_INDEX ? 'done' : i === CURRENT_STATUS_INDEX ? 'active' : ''}">
            <div class="node"></div><span>${s.label}</span>
        </div>`).join('');
}

/* ============================================================
   6. RENDER: 3D VIEWER (STL demo mesh — mô phỏng model khách gửi)
   ============================================================ */
const Viewer = (() => {
    const stage = $('stage');
    let renderer, scene, camera, mesh, raf = null, spin = false, ready = false;
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
        scene.add(new THREE.HemisphereLight(0xffffff, 0x2C3140, 1.0));
        const key = new THREE.DirectionalLight(0xffffff, 0.9); key.position.set(1.4,2,1.6); scene.add(key);
        const rim = new THREE.DirectionalLight(0xFF8A1F, 0.4); rim.position.set(-2,1,-1.4); scene.add(rim);
        bindControls();
        new ResizeObserver(resize).observe(stage);
        ready = true;
        return true;
    }
    function resize(){
        if(!renderer) return;
        const w = stage.clientWidth, h = stage.clientHeight;
        if(!w || !h) return;
        renderer.setSize(w, h); camera.aspect = w/h; camera.updateProjectionMatrix(); render();
    }
    function bindControls(){
        const el = renderer.domElement;
        let drag = null;
        const pos = e => ({x:e.touches ? e.touches[0].clientX : e.clientX, y:e.touches ? e.touches[0].clientY : e.clientY});
        const down = e => { const p = pos(e); drag = {x:p.x, y:p.y, pan:e.shiftKey}; };
        const move = e => {
            if(!drag || !mesh) return;
            const p = pos(e), dx = p.x - drag.x, dy = p.y - drag.y;
            if(drag.pan){
                const s = cam.dist * 0.0016;
                const right = new THREE.Vector3().subVectors(camera.position, cam.target).cross(camera.up).normalize();
                cam.target.addScaledVector(right, -dx*s); cam.target.addScaledVector(camera.up, dy*s);
            } else {
                cam.theta -= dx * 0.008;
                cam.phi = Math.max(0.08, Math.min(Math.PI - 0.08, cam.phi - dy*0.008));
            }
            drag.x = p.x; drag.y = p.y; render(); e.preventDefault();
        };
        const up = () => drag = null;
        el.addEventListener('mousedown', down); window.addEventListener('mousemove', move); window.addEventListener('mouseup', up);
        el.addEventListener('touchstart', down, {passive:false}); el.addEventListener('touchmove', move, {passive:false}); el.addEventListener('touchend', up);
        el.addEventListener('wheel', e => { if(!mesh) return; cam.dist *= e.deltaY > 0 ? 1.1 : 0.9; clampDist(); render(); e.preventDefault(); }, {passive:false});
    }
    const clampDist = () => cam.dist = Math.max(radius*1.2, Math.min(radius*14, cam.dist));
    function render(){
        if(!renderer) return;
        const s = Math.sin(cam.phi), c = Math.cos(cam.phi);
        camera.position.set(cam.target.x + cam.dist*s*Math.sin(cam.theta), cam.target.y + cam.dist*c, cam.target.z + cam.dist*s*Math.cos(cam.theta));
        camera.lookAt(cam.target); renderer.render(scene, camera);
    }
    function loop(){ if(!spin){ raf = null; return; } cam.theta += 0.006; render(); raf = requestAnimationFrame(loop); }

    return {
        available: () => typeof THREE !== 'undefined',
        showDemo(colorHex){
            if(!init()) return false;
            const geo = new THREE.DodecahedronGeometry(1, 0);
            const pos = geo.attributes.position;
            radius = 1.3;
            const mat = new THREE.MeshStandardMaterial({color:new THREE.Color(colorHex || '#FF8A1F'), roughness:0.5, metalness:0.1});
            mesh = new THREE.Mesh(geo, mat);
            scene.add(mesh);
            const grid = new THREE.GridHelper(radius*4, 12, 0x3A4052, 0x232734);
            grid.position.y = -radius*1.05; grid.name = 'grid';
            scene.add(grid);
            this.reset();
            return true;
        },
        setColor(hex){ if(mesh){ mesh.material.color.set(hex); render(); } },
        reset(){ cam.theta=-0.9; cam.phi=1.05; cam.dist=radius*2.8; cam.target.set(0,0,0); render(); },
        zoom(f){ if(!mesh) return; cam.dist *= f; clampDist(); render(); },
        toggleSpin(){ spin = !spin; if(spin && !raf) raf = requestAnimationFrame(loop); return spin; },
        fullscreen(){ if(stage.requestFullscreen) stage.requestFullscreen(); setTimeout(resize, 250); }
    };
})();

function toolsEnabled(on){
    ['btnSpin','btnZoomIn','btnZoomOut','btnReset','btnFull'].forEach(id => $(id).disabled = !on);
}

/* ============================================================
   7. RENDER: MODEL ANALYSIS + FEASIBILITY
   ============================================================ */
function renderFeasibility(){
    const printer = PRINTERS.find(p => p.id === supplier.printer);
    const b = printer.build, d = model.dimensions;
    const fits = d.x <= b.x && d.y <= b.y && d.z <= b.z;
    const box = $('feasResult');
    box.className = 'feas-result ' + (fits ? 'pass' : 'fail');
    box.querySelector('.ic').textContent = fits ? '✓' : '✕';
    $('feasTitle').textContent = fits ? 'Có thể in' : 'Không thể in';
    $('feasSub').textContent = fits
        ? `Model ${d.x} × ${d.y} × ${d.z} mm nằm trong vùng in ${b.x} × ${b.y} × ${b.z} mm của ${printer.name}.`
        : `Model ${d.x} × ${d.y} × ${d.z} mm vượt vùng in ${b.x} × ${b.y} × ${b.z} mm của ${printer.name}. Đề xuất chia model thành nhiều phần hoặc chọn máy có vùng in lớn hơn.`;

    const deadlineOk = true; // mock — 29/09 khả thi với lịch hiện tại
    const items = [
        {t: fits ? 'ok' : 'err', l:'Kích thước model', v: fits ? 'Phù hợp vùng in' : 'Vượt vùng in'},
        {t:'ok', l:'Build volume', v:`${b.x} × ${b.y} × ${b.z} mm`},
        {t: printer.status === 'Available' ? 'ok' : 'warn', l:'Tình trạng máy in', v:printer.status + ` (hàng chờ ${printer.queue})`},
        {t:'ok', l:'Vật liệu', v: matName(supplier.material) + ' — còn hàng'},
        {t:'ok', l:'Công nghệ tương thích', v: getTech(supplier.technology).name},
        {t: deadlineOk ? 'ok' : 'err', l:'Deadline khách yêu cầu', v: order.deadline + (deadlineOk ? ' — khả thi' : ' — có nguy cơ trễ')},
        {t:'ok', l:'Thời gian in ước tính', v:'~5h 47m (bao gồm hậu xử lý & QC)'}
    ];
    $('feasList').innerHTML = items.map(i => `
        <div class="feas-item ${i.t}"><span class="ic">${i.t==='ok'?'✓':i.t==='warn'?'⚠':'✕'}</span><span class="lbl">${i.l}</span><span class="val">${i.v}</span></div>`).join('');
}

/* ============================================================
   8. RENDER: PRINT CONFIGURATION (compare table + option cards)
   ============================================================ */
function changedTag(){ return '<span class="changed-tag">Đã thay đổi</span>'; }

function renderCompareTable(){
    const rows = [
        ['Công nghệ', getTech(customerRequest.technology).name, getTech(supplier.technology).name, customerRequest.technology !== supplier.technology],
        ['Vật liệu', matName(customerRequest.material), matName(supplier.material), customerRequest.material !== supplier.material],
        ['Màu', customerRequest.color.name, supplier.color.name, customerRequest.color.hex.toLowerCase() !== supplier.color.hex.toLowerCase()],
        ['Chất lượng', qualityName(customerRequest.technology, customerRequest.quality), qualityName(supplier.technology, supplier.quality), customerRequest.quality !== supplier.quality || customerRequest.technology !== supplier.technology]
    ];
    $('compareBody').innerHTML = rows.map(([label, cust, sup, changed]) => `
        <tr>
            <td class="lbl">${label}</td>
            <td>${cust}</td>
            <td class="${changed ? 'changed' : ''}">${sup}${changed ? changedTag() : ''}</td>
        </tr>`).join('');
}

function renderTech(){
    $('techList').innerHTML = TECHNOLOGIES.map(t => `
        <button type="button" class="opt-card ${t.id === supplier.technology ? 'active' : ''}" data-tech="${t.id}">
            <span class="radio sq"></span>
            <span class="oc-body">
                <strong>${t.name}</strong>
                <span>${t.desc}</span>
                ${t.id === customerRequest.technology ? '<span class="badge-inline">Khách yêu cầu</span>' : ''}
            </span>
        </button>`).join('');
    $('techList').querySelectorAll('[data-tech]').forEach(b => {
        b.onclick = () => {
            if(supplier.technology === b.dataset.tech) return;
            supplier.technology = b.dataset.tech;
            supplier.material = getMaterials(supplier.technology)[0];
            const qs = getQualities(supplier.technology);
            supplier.quality = qs[Math.min(1, qs.length-1)].id;
            renderAll();
            $('techReasonBox').classList.add('show');
            toast('Đã đổi công nghệ in — vui lòng nhập lý do');
        };
    });
    $('techReasonBox').classList.toggle('show', supplier.technology !== customerRequest.technology);
}

function renderMaterials(){
    const mats = getMaterials(supplier.technology);
    $('materialList').innerHTML = mats.map(id => `
        <button type="button" class="opt-card ${id === supplier.material ? 'active' : ''}" data-mat="${id}">
            <span class="radio sq"></span>
            <span class="oc-body"><strong>${matName(id)}</strong>${id === customerRequest.material ? '<span class="badge-inline">Khách yêu cầu</span>' : ''}</span>
        </button>`).join('');
    $('materialList').querySelectorAll('[data-mat]').forEach(b => {
        b.onclick = () => {
            supplier.material = b.dataset.mat;
            renderMaterials(); renderCompareTable(); renderFeasibility(); updateChecklistState();
            $('matReasonBox').classList.toggle('show', supplier.material !== customerRequest.material || supplier.technology !== customerRequest.technology);
            if(supplier.material !== customerRequest.material) toast('Đã đổi vật liệu — vui lòng nhập lý do');
        };
    });
    $('matReasonBox').classList.toggle('show', supplier.material !== customerRequest.material && supplier.technology === customerRequest.technology);
}

function renderColors(){
    $('swatches').innerHTML = COLORS.map(c => `
        <button type="button" class="swatch ${c.id === supplier.color.id ? 'active' : ''}" data-c="${c.id}" style="background:${c.hex}" title="${c.name}"></button>`).join('');
    $('swatches').querySelectorAll('[data-c]').forEach(b => {
        b.onclick = () => {
            const c = COLORS.find(x => x.id === b.dataset.c);
            supplier.color = {...c};
            $('colorPicker').value = c.hex; $('colorHex').value = c.hex.toUpperCase();
            renderColors(); Viewer.setColor(c.hex); renderCompareTable();
            $('colorReasonBox').classList.toggle('show', c.hex.toLowerCase() !== customerRequest.color.hex.toLowerCase());
            if(c.hex.toLowerCase() !== customerRequest.color.hex.toLowerCase()) toast('Đã đổi màu — vui lòng nhập lý do');
        };
    });
}

function renderQuality(){
    const qs = getQualities(supplier.technology);
    $('qualityList').innerHTML = qs.map(q => `
        <button type="button" class="opt-card ${q.id === supplier.quality ? 'active' : ''}" data-q="${q.id}">
            <span class="radio sq"></span>
            <span class="oc-body"><strong>${q.name}</strong><span>${q.layer.toFixed(2)} mm</span>${q.id === customerRequest.quality && supplier.technology === customerRequest.technology ? '<span class="badge-inline">Khách yêu cầu</span>' : ''}</span>
        </button>`).join('');
    $('qualityList').querySelectorAll('[data-q]').forEach(b => {
        b.onclick = () => {
            supplier.quality = b.dataset.q;
            renderQuality(); renderCompareTable(); updateChecklistState();
            $('advLayer').value = qs.find(q => q.id === supplier.quality).layer.toFixed(2);
            const changed = supplier.quality !== customerRequest.quality || supplier.technology !== customerRequest.technology;
            $('qualReasonBox').classList.toggle('show', changed);
            if(changed) toast('Đã đổi chất lượng — vui lòng nhập lý do');
        };
    });
}

function renderPost(){
    $('postList').innerHTML = POST_OPTIONS.map(p => `
        <button type="button" class="opt-card ${supplier.post.includes(p.id) ? 'active' : ''}" data-p="${p.id}">
            <span class="radio sq"></span>
            <span class="oc-body"><strong>${p.name}</strong><span>${p.desc}</span>${customerPost.includes(p.id) ? '<span class="badge-inline">Khách yêu cầu</span>' : ''}</span>
        </button>`).join('');
    $('postList').querySelectorAll('[data-p]').forEach(b => {
        b.onclick = () => {
            const id = b.dataset.p;
            supplier.post.includes(id) ? supplier.post = supplier.post.filter(x => x !== id) : supplier.post.push(id);
            renderPost();
            const changed = JSON.stringify([...supplier.post].sort()) !== JSON.stringify([...customerPost].sort());
            $('postReasonBox').classList.toggle('show', changed);
            if(changed) toast('Đã điều chỉnh gia công — vui lòng nhập lý do');
        };
    });
}

function renderPrinterSelect(){
    $('printerSelect').innerHTML = PRINTERS.map(p => `<option value="${p.id}" ${p.id === supplier.printer ? 'selected' : ''}>${p.name}</option>`).join('');
    updatePrinterInfo();
}
function updatePrinterInfo(){
    const p = PRINTERS.find(x => x.id === supplier.printer);
    $('pV').textContent = `${p.build.x} × ${p.build.y} × ${p.build.z} mm`;
    $('pN').textContent = p.nozzle;
    $('pS').innerHTML = p.status === 'Available' ? '<span style="color:var(--green);">✓ Sẵn sàng</span>' : '<span style="color:var(--orange);">⚠ Đang bận</span>';
    $('pQ').textContent = p.queue + ' đơn';
}

/* ============================================================
   9. CHECKLIST + VALIDATION + ACTION BAR
   ============================================================ */
function renderChecklist(){
    $('checklist').innerHTML = CHECKLIST_ITEMS.map((label, i) => `
        <div class="qc-item">
            <div class="qc-check" data-i="${i}">✓</div>
            <div class="qc-txt">${label}</div>
        </div>`).join('');
    $('checklist').querySelectorAll('.qc-check').forEach(el => {
        el.onclick = () => {
            const i = el.dataset.i;
            el.classList.toggle('checked');
            el.classList.contains('checked') ? checklist.add(i) : checklist.delete(i);
            updateChecklistState();
        };
    });
}
function updateChecklistState(){
    const done = checklist.size, total = CHECKLIST_ITEMS.length;
    $('checklistStatus').innerHTML = `Đã hoàn thành <b>${done}/${total}</b> mục checklist bắt buộc`;
    $('btnConfirm').disabled = done < total;
}

function renderActivity(){
    $('activityLog').innerHTML = ACTIVITY.map(a => `<div class="activity-row"><span class="t">${a.t}</span><span class="m">${a.m}</span></div>`).join('');
}
function logActivity(msg){
    ACTIVITY.push({t:'26/09 ' + new Date().toTimeString().slice(0,5), m:msg});
    renderActivity();
}

/* ============================================================
   10. GẮN SỰ KIỆN
   ============================================================ */
$('btnSpin').onclick = e => e.currentTarget.classList.toggle('on', Viewer.toggleSpin());
$('btnZoomIn').onclick = () => Viewer.zoom(0.85);
$('btnZoomOut').onclick = () => Viewer.zoom(1.18);
$('btnReset').onclick = () => Viewer.reset();
$('btnFull').onclick = () => Viewer.fullscreen();
$('btnFocusView').onclick = () => $('stage').scrollIntoView({behavior:'smooth', block:'center'});
$('btnDownload').onclick = () => toast('Đang tải file gốc… (demo)');

$('colorPicker').oninput = e => {
    const hex = e.target.value;
    supplier.color = {id:'custom', name:'Tuỳ chỉnh ' + hex.toUpperCase(), hex};
    $('colorHex').value = hex.toUpperCase();
    renderColors(); Viewer.setColor(hex); renderCompareTable();
    $('colorReasonBox').classList.add('show');
};
$('colorHex').oninput = e => {
    let v = e.target.value.trim(); if(!v.startsWith('#')) v = '#' + v;
    if(/^#[0-9a-fA-F]{6}$/.test(v)){ $('colorPicker').value = v; $('colorPicker').dispatchEvent(new Event('input')); }
};

$('printerSelect').onchange = e => { supplier.printer = e.target.value; updatePrinterInfo(); renderFeasibility(); updateChecklistState(); };

$('btnAutoOrient').onclick = () => {
    $('rotX').value = 0; $('rotY').value = 12; $('rotZ').value = 78;
    toast('Đã áp dụng hướng đặt tự động (mock)');
};

['advInfill','advWall','advTop','advBottom','advSupport'].forEach(id => {
    $(id).addEventListener('input', () => $('advChangedNote').style.display = 'inline');
    $(id).addEventListener('change', () => $('advChangedNote').style.display = 'inline');
});

$('btnSaveDraft').onclick = () => { logActivity('Xưởng lưu nháp cấu hình.'); toast('Đã lưu nháp'); };

/* Xác nhận nhận đơn */
$('btnConfirm').onclick = () => {
    $('confirmSummary').innerHTML = [
        ['Công nghệ', getTech(supplier.technology).name],
        ['Vật liệu', matName(supplier.material)],
        ['Số lượng', order.quantity],
        ['Giá', '370.000đ'],
        ['Thời gian', '2 ngày'],
        ['Deadline', order.deadline]
    ].map(([k,v]) => `<div class="field"><label>${k}</label><strong>${v}</strong></div>`).join('');
    $('confirmCheckbox').checked = false; $('btnConfirmFinal').disabled = true;
    openModal('confirmModal');
};
$('confirmCheckbox').onchange = e => $('btnConfirmFinal').disabled = !e.target.checked;
$('btnConfirmFinal').onclick = () => {
    closeModal('confirmModal');
    $('statusPill').className = 'status-pill confirmed'; $('statusPill').innerHTML = '<span class="dot"></span> Đã xác nhận';
    $('deadlineChip').textContent = 'Bắt đầu sản xuất: 27/09/2026';
    logActivity('Xưởng xác nhận nhận đơn.');
    toast('Đã xác nhận nhận đơn thành công');
};

/* Yêu cầu chỉnh sửa */
$('btnRevision').onclick = () => openModal('revisionModal');
$('btnSendRevision').onclick = () => {
    const reason = document.querySelector('input[name="revReason"]:checked');
    if(!reason){ toast('Vui lòng chọn lý do yêu cầu chỉnh sửa', true); return; }
    closeModal('revisionModal');
    logActivity('Xưởng gửi yêu cầu chỉnh sửa cho khách: ' + reason.parentElement.textContent.trim());
    toast('Đã gửi yêu cầu chỉnh sửa tới khách hàng');
    $('revisionDetail').value = '';
};

/* Từ chối đơn */
$('btnReject').onclick = () => openModal('rejectModal');
$('btnSendReject').onclick = () => {
    const reason = document.querySelector('input[name="rejReason"]:checked');
    const detail = $('rejectDetail').value.trim();
    if(!reason){ toast('Vui lòng chọn lý do từ chối', true); return; }
    if(!detail){ toast('Vui lòng nhập lý do chi tiết trước khi từ chối', true); return; }
    closeModal('rejectModal');
    logActivity('Xưởng từ chối đơn: ' + reason.parentElement.textContent.trim());
    toast('Đã từ chối đơn hàng', true);
    $('btnConfirm').disabled = true; $('btnRevision').disabled = true; $('btnReject').disabled = true;
};

/* ============================================================
   11. KHỞI TẠO
   ============================================================ */
function renderAll(){
    renderCompareTable(); renderTech(); renderMaterials(); renderColors(); renderQuality(); renderPost();
    renderPrinterSelect(); renderFeasibility();
}
renderStatusTrack();
renderAll();
renderChecklist(); updateChecklistState();
renderActivity();
$('colorPicker').value = supplier.color.hex; $('colorHex').value = supplier.color.hex.toUpperCase();
$('advLayer').value = getQualities(supplier.technology).find(q => q.id === supplier.quality).layer.toFixed(2);

const okShow = Viewer.showDemo(supplier.color.hex);
$('stageBadge').textContent = okShow ? '✓ Model đã tải thành công' : '⚠ Không thể hiển thị model';
$('stageBadge').className = 'stage-badge ' + (okShow ? 'ok' : 'warn');
$('stageEmpty').style.display = okShow ? 'none' : 'flex';
$('stageHint').style.display = okShow ? 'block' : 'none';
$('stageHint').textContent = 'Preview minh hoạ (dựng hình mẫu) — model thật hiển thị khi kết nối API xưởng.';
toolsEnabled(okShow);
if(!Viewer.available()){
    $('stageEmpty').querySelector('p').textContent = 'Không tải được thư viện 3D. Tải file gốc để kiểm tra bằng phần mềm CAD.';
}
</script>
</body>
</html>
