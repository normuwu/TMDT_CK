<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>PrintKraft Xưởng — Quản lý doanh thu (nâng cấp)</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@600;700&family=Barlow:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
/* ============================================================
   BLOCK A — CSS GỐC Xưởng.html (giữ nguyên, không đổi)
   ============================================================ */
:root{
    --charcoal:#171920; --steel:#2C3140; --steel-2:#20232C; --steel-3:#262A35;
    --orange:#FF8A1F; --amber:#FFB020; --violet:#8B5CF6; --teal:#22D3EE;
    --pink:#F472B6; --green:#34D399; --red:#FB5A6A; --blue:#60A5FA;
    --off:#EDEFF5; --muted:#9AA0B0;
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
    color:var(--off); font-family:'Barlow', sans-serif; font-size:15px; min-height:100vh;
}
h1,h2,h3,.cond{font-family:'Barlow Condensed', sans-serif; letter-spacing:0.01em;}
a{color:inherit; text-decoration:none;}
button{font-family:inherit; cursor:pointer;}
::-webkit-scrollbar{width:9px;height:9px;}
::-webkit-scrollbar-track{background:var(--steel-2);}
::-webkit-scrollbar-thumb{background:#3A4052;border-radius:9px;}
::-webkit-scrollbar-thumb:hover{background:var(--orange);}

.topbar{
    background:linear-gradient(180deg,#262A35,#1D2028); padding:14px 28px;
    display:flex; align-items:center; justify-content:space-between;
    position:sticky; top:0; z-index:50; flex-wrap:wrap; gap:12px;
    box-shadow:0 6px 24px rgba(0,0,0,.35);
}
.topbar:after{content:""; position:absolute; left:0; right:0; bottom:0; height:3px;
    background:linear-gradient(90deg,var(--orange),var(--amber),var(--pink),var(--violet),var(--teal));}
.brand{display:flex; align-items:center; gap:12px;}
.brand .mark{width:34px; height:34px; border-radius:9px; background:var(--grad-hot);
    clip-path: polygon(50% 0%, 100% 100%, 0% 100%); filter:drop-shadow(0 0 12px var(--orange-glow));}
.brand h1{font-size:24px; font-weight:700; color:white;}
.brand span{font-size:12.5px; color:var(--muted); display:block; margin-top:-2px;}
.shift-info{display:flex; align-items:center; gap:22px; font-size:13px; color:var(--muted); flex-wrap:wrap;}
.shift-info .live{display:flex; align-items:center; gap:7px; color:var(--green); font-weight:600;}
.shift-info .live .dot{width:8px; height:8px; border-radius:50%; background:var(--green);
    animation:pulse 1.6s infinite; box-shadow:0 0 10px var(--green);}
@keyframes pulse{0%,100%{opacity:1; transform:scale(1);}50%{opacity:.35; transform:scale(.8);}}
.op-avatar{width:38px; height:38px; border-radius:50%; background:var(--grad-hot);
    display:flex; align-items:center; justify-content:center; font-weight:700; color:#1A1C22;
    cursor:pointer; transition:.18s; box-shadow:0 0 0 0 var(--orange-glow);}
.op-avatar:hover{transform:scale(1.06); box-shadow:0 0 0 5px var(--orange-glow);}

.nav-tabs{background:linear-gradient(180deg,#1F222B,#1B1E26); border-bottom:1px solid var(--steel);
    padding:0 28px; display:flex; gap:4px; overflow-x:auto;}
.nav-tabs button{background:transparent; border:none; color:var(--muted); padding:14px 18px;
    font-size:13.5px; font-weight:600; border-bottom:3px solid transparent; white-space:nowrap; transition:.18s;}
.nav-tabs button.active{color:white; border-bottom:3px solid var(--orange); text-shadow:0 0 18px var(--orange-glow);}
.nav-tabs button:hover{color:var(--off);}

.stat-strip{display:grid; grid-template-columns:repeat(5,1fr); border-bottom:1px solid var(--steel);
    background:rgba(32,35,44,.5);}
.stat{padding:20px 28px; border-right:1px solid var(--steel); position:relative; overflow:hidden;}
.stat:last-child{border-right:none;}
.stat:before{content:""; position:absolute; left:0; top:0; width:100%; height:2px; background:transparent; transition:.2s;}
.stat:hover:before{background:var(--grad-hot);}
.stat .cond{font-size:15px; color:var(--muted); text-transform:uppercase; letter-spacing:0.06em;
    font-family:'Barlow Condensed'; font-weight:600;}
.stat .val{font-size:38px; font-weight:700; color:white; margin-top:4px; font-family:'Barlow Condensed';}
.stat .val.orange{color:var(--orange); text-shadow:0 0 26px var(--orange-glow);}
.stat .val.red{color:var(--red); text-shadow:0 0 26px rgba(251,90,106,.35);}
.stat .val.green{color:var(--green); text-shadow:0 0 26px rgba(52,211,153,.35);}
.stat .val.violet{color:var(--violet); text-shadow:0 0 26px rgba(139,92,246,.4);}
.stat .sub{font-size:12.5px; color:var(--muted); margin-top:4px;}

.content{padding:26px 28px 90px;}

.section-title{display:flex; justify-content:space-between; align-items:center; margin-bottom:16px; flex-wrap:wrap; gap:12px;}
.section-title h2{font-size:26px; color:white; font-weight:700;}
.filter-tabs{display:flex; gap:8px; flex-wrap:wrap;}
.filter-tabs button{background:var(--steel-2); border:1px solid var(--steel); color:var(--muted);
    padding:9px 16px; border-radius:8px; font-weight:600; font-size:13.5px; cursor:pointer; transition:.16s;}
.filter-tabs button:hover{color:var(--off); border-color:#3C4358;}
.filter-tabs button.active{background:var(--grad-hot); color:#1A1C22; border-color:transparent; box-shadow:0 4px 16px var(--orange-glow);}

.bottom-grid{display:grid; grid-template-columns:1.3fr 1fr; gap:18px; margin-bottom:18px;}
.panel{background:linear-gradient(180deg,var(--steel-3),var(--steel-2)); border:1px solid var(--steel);
    border-radius:14px; padding:18px 20px;}
.panel h3{font-size:19px; color:white; font-weight:700; margin-bottom:14px; text-transform:uppercase; letter-spacing:0.03em;}
.panel-head{display:flex; justify-content:space-between; align-items:center; margin-bottom:14px;}
.panel-head h3{margin-bottom:0;}
.panel-head a{font-size:12.5px; color:var(--orange); font-weight:600;}
.panel-head a:hover{text-decoration:underline;}

.material-row{display:flex; justify-content:space-between; align-items:center; padding:11px 0;
    border-bottom:1px solid var(--steel); font-size:13.5px; gap:12px;}
.material-row:last-child{border-bottom:none;}
.material-row .name{flex:1; min-width:0;}
.material-row .name span{display:block; font-size:11.5px; color:var(--muted); margin-top:2px;}
.stock-bar{width:110px; height:8px; border-radius:999px; background:#14161C; overflow:hidden; flex-shrink:0;}
.stock-fill{height:100%; border-radius:999px; transition:width .4s;}

.rev-cards{display:grid; grid-template-columns:repeat(4,1fr); gap:16px; margin-bottom:20px;}
.rev-card{border-radius:14px; padding:18px 20px; border:1px solid var(--steel);
    background:linear-gradient(180deg,var(--steel-3),var(--steel-2)); position:relative; overflow:hidden;}
.rev-card:before{content:""; position:absolute; top:0; left:0; right:0; height:3px;}
.rev-card.c1:before{background:var(--grad-hot);}
.rev-card.c2:before{background:var(--grad-money);}
.rev-card.c3:before{background:var(--grad-cool);}
.rev-card.c4:before{background:linear-gradient(135deg,#FB5A6A,#F472B6);}
.rev-card .lbl{font-size:12px; text-transform:uppercase; letter-spacing:.07em; color:var(--muted); font-weight:600;}
.rev-card .num{font-family:'Barlow Condensed'; font-size:34px; font-weight:700; color:white; margin-top:6px; line-height:1;}
.rev-card .delta{font-size:12px; margin-top:7px; font-weight:600;}
.rev-card .delta.up{color:var(--green);}
.rev-card .delta.down{color:var(--red);}

.chart{display:flex; align-items:flex-end; gap:12px; height:190px; padding:16px 4px 0;}
.chart-col{flex:1; display:flex; flex-direction:column; align-items:center; justify-content:flex-end; height:100%; gap:8px;}
.chart-bar{width:100%; max-width:56px; border-radius:8px 8px 4px 4px;
    background:linear-gradient(180deg,var(--orange),rgba(255,138,31,.25));
    position:relative; transition:.3s; min-height:6px;}
.chart-bar:hover{filter:brightness(1.15);}
.chart-bar.hi{background:linear-gradient(180deg,var(--green),rgba(52,211,153,.22));}
.chart-bar span{position:absolute; top:-20px; left:50%; transform:translateX(-50%);
    font-size:11px; font-weight:700; color:var(--off); white-space:nowrap;}
.chart-lbl{font-size:11.5px; color:var(--muted); font-weight:600;}

.table{width:100%; border-collapse:collapse; font-size:13.5px;}
.table th{text-align:left; font-size:11px; text-transform:uppercase; letter-spacing:.06em;
    color:var(--muted); padding:8px 10px; border-bottom:1px solid var(--steel); font-weight:700;}
.table td{padding:11px 10px; border-bottom:1px solid #232734;}
.table tr:last-child td{border-bottom:none;}
.table tr:hover td{background:rgba(255,138,31,.05);}
.badge{font-size:11px; font-weight:700; padding:3px 9px; border-radius:999px; white-space:nowrap; display:inline-block;}
.badge.paid{background:rgba(52,211,153,.16); color:var(--green);}
.badge.pending{background:rgba(255,138,31,.16); color:var(--orange);}
.badge.debt{background:rgba(251,90,106,.16); color:var(--red);}
.money{font-family:'Barlow Condensed'; font-weight:700; font-size:15px; color:white;}

.form-field{margin-bottom:14px;}
.form-field label{display:block; font-size:11.5px; text-transform:uppercase; letter-spacing:.06em;
    color:var(--muted); margin-bottom:6px; font-weight:600;}
.form-field input, .form-field select, .form-field textarea{
    width:100%; background:#181B22; border:1px solid var(--steel); border-radius:9px;
    padding:11px 13px; color:var(--off); font-family:inherit; font-size:13.5px; outline:none; transition:.16s;}
.form-field input:focus, .form-field select:focus, .form-field textarea:focus{
    border-color:var(--orange); box-shadow:0 0 0 3px rgba(255,138,31,.15);}
.form-field textarea{resize:vertical; min-height:78px;}

.btn-start{background:var(--grad-hot); color:#1A1C22; box-shadow:0 4px 14px rgba(255,138,31,.28);}
.btn-start:hover{filter:brightness(1.1); transform:translateY(-1px);}
.btn-done{background:var(--grad-money); color:#0F1A15; box-shadow:0 4px 14px rgba(52,211,153,.25);}
.btn-done:hover{filter:brightness(1.1); transform:translateY(-1px);}
.btn-ghost{background:transparent; border:1px solid var(--steel) !important; color:var(--off);}
.btn-ghost:hover{border-color:var(--orange) !important; color:var(--orange);}

.alert-row{display:flex; align-items:center; gap:12px; padding:12px 14px;
    background:rgba(251,90,106,0.08); border:1px solid rgba(251,90,106,0.3);
    border-radius:11px; margin-bottom:10px; font-size:13px;}
.alert-row.info{background:rgba(96,165,250,0.08); border-color:rgba(96,165,250,0.3);}
.alert-row.warn{background:rgba(255,138,31,0.08); border-color:rgba(255,138,31,0.3);}
.alert-row .ic{font-size:18px; flex-shrink:0;}
.alert-row .txt{flex:1; color:var(--off); min-width:0;}
.alert-row .txt strong{color:white; display:block; font-size:13.5px;}
.alert-row .txt span{font-size:12px; color:var(--muted);}

.overlay{position:fixed; inset:0; background:rgba(8,9,13,0.72); backdrop-filter:blur(3px);
    opacity:0; pointer-events:none; transition:.2s; z-index:90;}
.overlay.show{opacity:1; pointer-events:auto;}
.modal{position:fixed; inset:0; display:flex; align-items:center; justify-content:center; z-index:100;
    opacity:0; pointer-events:none; transition:.2s; padding:20px;}
.modal.show{opacity:1; pointer-events:auto;}
.modal-box{background:linear-gradient(180deg,#262A35,#1E2129); border:1px solid var(--steel);
    border-radius:16px; padding:26px; width:560px; max-width:100%; max-height:90vh; overflow-y:auto;
    box-shadow:0 24px 60px rgba(0,0,0,.6);}
.modal-box h3{font-size:24px; color:white; margin-bottom:6px;}
.modal-box .sub{font-size:13px; color:var(--muted); margin-bottom:20px;}
.modal-close{position:absolute; top:16px; right:18px; background:none; border:none; font-size:20px; color:var(--muted); transition:.15s;}
.modal-close:hover{color:var(--red);}
.modal-head{position:relative;}
.detail-grid{display:grid; grid-template-columns:1fr 1fr; gap:14px; margin-bottom:18px;}
.detail-grid .field{background:#181B22; border-radius:10px; padding:12px 14px; border:1px solid #232734;}
.detail-grid .field label{font-size:11px; text-transform:uppercase; letter-spacing:0.05em; color:var(--muted); display:block; margin-bottom:4px;}
.detail-grid .field strong{font-size:14.5px; color:white; font-weight:600;}

.toast{position:fixed; bottom:26px; left:50%; transform:translate(-50%,90px);
    background:var(--grad-hot); color:#1A1C22; padding:13px 24px; border-radius:11px;
    font-size:14px; font-weight:700; z-index:200; transition:.25s; opacity:0;
    box-shadow:0 12px 34px rgba(255,138,31,.4); max-width:90vw; text-align:center;}
.toast.show{transform:translate(-50%,0); opacity:1;}

/* ============================================================
   BLOCK B — CSS MỚI THÊM (scoped trong #tab-revenue)
   Copy nguyên khối này vào <style> của Xưởng.html
   ============================================================ */

/* --- Sub-tabs trong tab Doanh thu --- */
#tab-revenue .rev-subtabs{
    display:flex; gap:6px; margin-bottom:20px; flex-wrap:wrap; align-items:center;
    border-bottom:1px solid var(--steel); padding-bottom:0;
}
#tab-revenue .rev-subtabs > button{
    background:transparent; border:none; color:var(--muted);
    padding:11px 16px; font-size:13.5px; font-weight:600; cursor:pointer;
    border-bottom:3px solid transparent; transition:.16s; position:relative; top:1px;
}
#tab-revenue .rev-subtabs > button:hover{color:var(--off);}
#tab-revenue .rev-subtabs > button.active{
    color:var(--orange); border-bottom-color:var(--orange);
    text-shadow:0 0 14px var(--orange-glow);
}
#tab-revenue .rev-period{
    margin-left:auto; display:flex; gap:6px; align-items:center; padding-bottom:8px;
}
#tab-revenue .rev-period::before{
    content:"Kỳ:"; font-size:12px; color:var(--muted); font-weight:600;
    text-transform:uppercase; letter-spacing:.06em; margin-right:4px;
    font-family:'Barlow Condensed';
}
#tab-revenue .rev-period button{
    background:var(--steel-2); border:1px solid var(--steel); color:var(--muted);
    padding:6px 13px; border-radius:7px; font-weight:600; font-size:12.5px; transition:.16s;
}
#tab-revenue .rev-period button:hover{color:var(--off); border-color:#3C4358;}
#tab-revenue .rev-period button.active{
    background:var(--grad-hot); color:#1A1C22; border-color:transparent;
    box-shadow:0 4px 12px var(--orange-glow);
}

/* --- Sub-tab content --- */
#tab-revenue .rev-subtab{display:none;}
#tab-revenue .rev-subtab.active{display:block; animation:fadeUp .25s ease;}
@keyframes fadeUp{from{opacity:0; transform:translateY(8px);} to{opacity:1; transform:none;}}

/* --- KPI strip có sparkline --- */
#tab-revenue .rev-kpi-strip{
    display:grid; grid-template-columns:repeat(5,1fr); gap:0;
    border:1px solid var(--steel); border-radius:14px; overflow:hidden;
    background:linear-gradient(180deg,var(--steel-3),var(--steel-2));
    margin-bottom:20px;
}
#tab-revenue .rev-kpi{
    padding:16px 20px; border-right:1px solid var(--steel); position:relative;
}
#tab-revenue .rev-kpi:last-child{border-right:none;}
#tab-revenue .rev-kpi .lbl{
    font-family:'Barlow Condensed'; font-size:13px; color:var(--muted);
    text-transform:uppercase; letter-spacing:.07em; font-weight:600;
}
#tab-revenue .rev-kpi .val{
    font-family:'Barlow Condensed'; font-size:28px; font-weight:700; color:white;
    margin-top:4px; line-height:1;
}
#tab-revenue .rev-kpi .val.orange{color:var(--orange); text-shadow:0 0 22px var(--orange-glow);}
#tab-revenue .rev-kpi .val.green{color:var(--green); text-shadow:0 0 22px rgba(52,211,153,.3);}
#tab-revenue .rev-kpi .val.violet{color:var(--violet); text-shadow:0 0 22px rgba(139,92,246,.4);}
#tab-revenue .rev-kpi .val.red{color:var(--red); text-shadow:0 0 22px rgba(251,90,106,.3);}
#tab-revenue .rev-kpi .sub{font-size:11.5px; color:var(--muted); margin-top:5px; display:flex; align-items:center; gap:5px;}
#tab-revenue .rev-kpi .sub .up{color:var(--green); font-weight:700;}
#tab-revenue .rev-kpi .sub .down{color:var(--red); font-weight:700;}
#tab-revenue .sparkline{display:flex; align-items:flex-end; gap:2px; height:18px; margin-top:8px;}
#tab-revenue .sparkline span{flex:1; border-radius:2px; background:var(--steel); transition:.3s;}
#tab-revenue .sparkline span.hi{background:var(--grad-hot);}

/* --- Donut chart --- */
#tab-revenue .donut-wrap{display:flex; align-items:center; gap:24px; flex-wrap:wrap;}
#tab-revenue .donut{
    width:160px; height:160px; border-radius:50%; position:relative; flex-shrink:0;
    background:conic-gradient(
        var(--orange) 0% 35%,
        var(--teal) 35% 62%,
        var(--violet) 62% 79%,
        var(--pink) 79% 91%,
        var(--blue) 91% 100%
    );
    filter:drop-shadow(0 0 22px rgba(255,138,31,.16));
}
#tab-revenue .donut:before{content:""; position:absolute; inset:24px; border-radius:50%; background:var(--steel-2);}
#tab-revenue .donut-center{
    position:absolute; inset:0; display:flex; flex-direction:column;
    align-items:center; justify-content:center; z-index:1;
}
#tab-revenue .donut-center .num{font-family:'Barlow Condensed'; font-weight:700; font-size:22px; color:white; line-height:1;}
#tab-revenue .donut-center .lbl{font-size:10.5px; color:var(--muted); text-transform:uppercase; letter-spacing:.06em; margin-top:3px;}
#tab-revenue .legend{flex:1; min-width:180px;}
#tab-revenue .legend-item{display:flex; align-items:center; gap:10px; padding:7px 0;
    border-bottom:1px solid var(--steel); font-size:13px;}
#tab-revenue .legend-item:last-child{border-bottom:none;}
#tab-revenue .legend-dot{width:11px; height:11px; border-radius:3px; flex-shrink:0;}
#tab-revenue .legend-item .name{flex:1; color:var(--off);}
#tab-revenue .legend-item .pct{font-family:'Barlow Condensed'; font-weight:700; color:white; font-size:14.5px;}
#tab-revenue .legend-item .val{font-size:11.5px; color:var(--muted); width:66px; text-align:right; font-family:'Barlow Condensed'; font-weight:700;}

/* --- Top lists có rank --- */
#tab-revenue .top-list{display:flex; flex-direction:column; gap:2px;}
#tab-revenue .top-row{display:flex; align-items:center; gap:12px; padding:11px 0; border-bottom:1px solid var(--steel);}
#tab-revenue .top-row:last-child{border-bottom:none;}
#tab-revenue .rank{
    width:24px; height:24px; border-radius:6px; display:flex; align-items:center; justify-content:center;
    font-family:'Barlow Condensed'; font-weight:700; font-size:13px; flex-shrink:0;
    background:var(--steel); color:var(--muted);
}
#tab-revenue .rank.top1{background:var(--grad-hot); color:#1A1C22; box-shadow:0 0 12px var(--orange-glow);}
#tab-revenue .rank.top2{background:linear-gradient(135deg,#B8C0D0,#7E8AA0); color:#1A1C22;}
#tab-revenue .rank.top3{background:linear-gradient(135deg,#C08552,#8B5E3C); color:#fff;}
#tab-revenue .top-info{flex:1; min-width:0;}
#tab-revenue .top-info strong{display:block; font-size:13.5px; color:white; font-weight:600;}
#tab-revenue .top-info span{font-size:11.5px; color:var(--muted);}
#tab-revenue .top-meter{width:70px; height:6px; background:#14161C; border-radius:999px; overflow:hidden; flex-shrink:0;}
#tab-revenue .top-meter div{height:100%; border-radius:999px;}
#tab-revenue .top-amount{font-family:'Barlow Condensed'; font-weight:700; font-size:15px; color:var(--green); width:80px; text-align:right;}

/* --- Filter bar (cho sub-tab Giao dịch) --- */
#tab-revenue .rev-filter{
    display:flex; gap:12px; margin-bottom:16px; flex-wrap:wrap; align-items:flex-end;
    background:linear-gradient(180deg,var(--steel-3),var(--steel-2));
    border:1px solid var(--steel); border-radius:12px; padding:14px 16px;
}
#tab-revenue .rev-filter .fg{display:flex; flex-direction:column; gap:4px;}
#tab-revenue .rev-filter .fg label{font-size:10.5px; text-transform:uppercase; letter-spacing:.06em;
    color:var(--muted); font-weight:700; font-family:'Barlow Condensed';}
#tab-revenue .rev-filter select, #tab-revenue .rev-filter input{
    background:#181B22; border:1px solid var(--steel); border-radius:8px;
    padding:8px 12px; color:var(--off); font-family:inherit; font-size:13px; outline:none;
    min-width:130px; transition:.16s;
}
#tab-revenue .rev-filter select:focus, #tab-revenue .rev-filter input:focus{
    border-color:var(--orange); box-shadow:0 0 0 3px rgba(255,138,31,.15);
}
#tab-revenue .rev-filter .search{flex:1; min-width:180px;}
#tab-revenue .rev-filter .search input{width:100%; min-width:0;}
#tab-revenue .rev-filter .actions{margin-left:auto; display:flex; gap:8px;}

/* --- Aging buckets (Công nợ) --- */
#tab-revenue .aging-grid{display:grid; grid-template-columns:repeat(4,1fr); gap:12px; margin-bottom:18px;}
#tab-revenue .aging{
    background:linear-gradient(180deg,var(--steel-3),var(--steel-2));
    border:1px solid var(--steel); border-radius:12px; padding:16px;
    position:relative; overflow:hidden;
}
#tab-revenue .aging:before{content:""; position:absolute; top:0; left:0; right:0; height:3px;}
#tab-revenue .aging.a1:before{background:var(--grad-money);}
#tab-revenue .aging.a2:before{background:var(--grad-hot);}
#tab-revenue .aging.a3:before{background:linear-gradient(135deg,#FB5A6A,#FF8A1F);}
#tab-revenue .aging.a4:before{background:linear-gradient(135deg,#FB5A6A,#F472B6);}
#tab-revenue .aging .lbl{font-family:'Barlow Condensed'; font-size:11.5px; color:var(--muted);
    text-transform:uppercase; letter-spacing:.06em; font-weight:700;}
#tab-revenue .aging .num{font-family:'Barlow Condensed'; font-size:26px; font-weight:700; color:white; margin-top:5px; line-height:1;}
#tab-revenue .aging .sub{font-size:11.5px; color:var(--muted); margin-top:4px;}

/* --- Debt rows --- */
#tab-revenue .debt-row{display:flex; align-items:center; gap:14px; padding:14px 0; border-bottom:1px solid var(--steel);}
#tab-revenue .debt-row:last-child{border-bottom:none;}
#tab-revenue .debt-avatar{
    width:42px; height:42px; border-radius:50%; display:flex; align-items:center; justify-content:center;
    font-family:'Barlow Condensed'; font-weight:700; font-size:14px; flex-shrink:0; color:#1A1C22;
}
#tab-revenue .debt-info{flex:1; min-width:0;}
#tab-revenue .debt-info strong{display:block; font-size:14px; color:white; font-weight:600;}
#tab-revenue .debt-info span{font-size:12px; color:var(--muted);}
#tab-revenue .debt-bar{width:110px; height:8px; background:#14161C; border-radius:999px; overflow:hidden; flex-shrink:0;}
#tab-revenue .debt-bar div{height:100%; border-radius:999px;}
#tab-revenue .debt-amt{font-family:'Barlow Condensed'; font-weight:700; font-size:16px; color:var(--red); width:96px; text-align:right;}
#tab-revenue .debt-actions{display:flex; gap:6px;}

/* --- Cost rows --- */
#tab-revenue .cost-row{display:flex; align-items:center; gap:14px; padding:12px 0; border-bottom:1px solid var(--steel);}
#tab-revenue .cost-row:last-child{border-bottom:none;}
#tab-revenue .cost-ic{
    width:38px; height:38px; border-radius:10px; display:flex; align-items:center; justify-content:center;
    font-size:17px; flex-shrink:0; background:#16181F; border:1px solid var(--steel);
}
#tab-revenue .cost-info{flex:1; min-width:0;}
#tab-revenue .cost-info strong{display:block; font-size:13.5px; color:white; font-weight:600;}
#tab-revenue .cost-info span{font-size:11.5px; color:var(--muted);}
#tab-revenue .cost-meter{width:120px; height:8px; background:#14161C; border-radius:999px; overflow:hidden; flex-shrink:0;}
#tab-revenue .cost-meter div{height:100%; border-radius:999px; transition:width .4s;}
#tab-revenue .cost-pct{font-family:'Barlow Condensed'; font-weight:700; font-size:13.5px; width:44px; text-align:right;}
#tab-revenue .cost-amt{font-family:'Barlow Condensed'; font-weight:700; font-size:14.5px; color:var(--off); width:84px; text-align:right;}

/* --- Report cards --- */
#tab-revenue .report-grid{display:grid; grid-template-columns:repeat(3,1fr); gap:14px; margin-bottom:18px;}
#tab-revenue .report-card{
    background:linear-gradient(180deg,var(--steel-3),var(--steel-2));
    border:1px solid var(--steel); border-radius:14px; padding:18px;
    transition:.2s; cursor:pointer; position:relative; overflow:hidden;
}
#tab-revenue .report-card:hover{transform:translateY(-3px); border-color:var(--orange); box-shadow:0 14px 32px rgba(0,0,0,.45);}
#tab-revenue .report-card:before{content:""; position:absolute; top:0; left:0; right:0; height:3px;}
#tab-revenue .report-card.rc1:before{background:var(--grad-hot);}
#tab-revenue .report-card.rc2:before{background:var(--grad-money);}
#tab-revenue .report-card.rc3:before{background:var(--grad-cool);}
#tab-revenue .report-card.rc4:before{background:linear-gradient(135deg,#FB5A6A,#F472B6);}
#tab-revenue .report-card .ric{
    width:44px; height:44px; border-radius:11px; display:flex; align-items:center; justify-content:center;
    font-size:20px; margin-bottom:12px; background:#16181F; border:1px solid var(--steel);
}
#tab-revenue .report-card h4{font-size:15px; color:white; margin-bottom:5px; font-weight:600;}
#tab-revenue .report-card p{font-size:12px; color:var(--muted); line-height:1.5; margin-bottom:12px;}
#tab-revenue .report-card .dl{font-size:12px; color:var(--orange); font-weight:700;}

/* --- Responsive cho phần mới --- */
@media (max-width:1200px){
    #tab-revenue .rev-kpi-strip{grid-template-columns:repeat(2,1fr);}
    #tab-revenue .rev-kpi{border-bottom:1px solid var(--steel);}
    #tab-revenue .aging-grid{grid-template-columns:1fr 1fr;}
    #tab-revenue .report-grid{grid-template-columns:1fr 1fr;}
}
@media (max-width:760px){
    #tab-revenue .rev-kpi-strip{grid-template-columns:1fr;}
    #tab-revenue .aging-grid{grid-template-columns:1fr;}
    #tab-revenue .report-grid{grid-template-columns:1fr;}
    #tab-revenue .rev-subtabs{flex-direction:column; align-items:stretch;}
    #tab-revenue .rev-period{margin-left:0;}
}
</style>
</head>
<body>

<!-- ===== Top bar (giữ nguyên) ===== -->
<div class="topbar">
    <div class="brand">
        <span class="mark"></span>
        <div><h1>Sài Gòn Print</h1><span>Cổng xưởng sản xuất · PrintKraft</span></div>
    </div>
    <div class="shift-info">
        <div class="live"><span class="dot"></span> Ca sáng · 06:00–14:00</div>
        <div>Thứ Ba, 15/09/2026 — <span id="clock">10:42</span></div>
        <div class="op-avatar" onclick="openModal('profileModal')">ĐL</div>
    </div>
</div>

<!-- ===== Nav tabs (giữ nguyên) ===== -->
<div class="nav-tabs">
    <button onclick="toast('Quay lại Bảng sản xuất')">Bảng sản xuất</button>
    <button onclick="toast('Quay lại Đơn yêu cầu')">📋 Đơn yêu cầu <span style="opacity:.75;">(2)</span></button>
    <button onclick="toast('Quay lại Máy móc')">Máy móc</button>
    <button onclick="toast('Quay lại Vật tư')">Vật tư</button>
    <button onclick="toast('Quay lại Kiểm tra chất lượng')">Kiểm tra chất lượng</button>
    <button onclick="toast('Quay lại Lịch ca')">Lịch ca</button>
    <button class="active">💰 Doanh thu</button>
    <button onclick="toast('Quay lại Mẫu bán sẵn')">🛍️ Mẫu bán sẵn</button>
    <button onclick="toast('Quay lại Hỗ trợ & Đổi trả')">🎧 Hỗ trợ &amp; Đổi trả</button>
</div>

<!-- ===== Stat strip (giữ nguyên) ===== -->
<div class="stat-strip">
    <div class="stat"><div class="cond">Việc chờ xử lý</div><div class="val">18</div><div class="sub">4 đơn ưu tiên cao</div></div>
    <div class="stat"><div class="cond">Đang sản xuất</div><div class="val orange">7</div><div class="sub">3 máy in đang chạy</div></div>
    <div class="stat"><div class="cond">Trễ hạn giao</div><div class="val red">2</div><div class="sub">Cần xử lý ngay</div></div>
    <div class="stat"><div class="cond">Hoàn tất hôm nay</div><div class="val green">24</div><div class="sub">Mục tiêu ca: 30</div></div>
    <div class="stat"><div class="cond">Doanh thu hôm nay</div><div class="val violet">18.4tr</div><div class="sub">▲ 12% so với hôm qua</div></div>
</div>

<div class="content">

<!-- ============================================================
     BLOCK C — HTML TAB DOANH THU NÂNG CẤP
     Thay thế toàn bộ <div class="tab-content" id="tab-revenue"> cũ
     ============================================================ -->
<div class="tab-content active" id="tab-revenue">

    <!-- Sub-tabs + chọn kỳ -->
    <div class="rev-subtabs">
        <button class="active" onclick="revTab(this,'overview')">Tổng quan</button>
        <button onclick="revTab(this,'transactions')">Giao dịch</button>
        <button onclick="revTab(this,'debt')">Công nợ</button>
        <button onclick="revTab(this,'costs')">Chi phí &amp; Lợi nhuận</button>
        <button onclick="revTab(this,'reports')">Báo cáo</button>
        <div class="rev-period">
            <button class="active" onclick="setPeriod(this,'day')">Hôm nay</button>
            <button onclick="setPeriod(this,'week')">Tuần</button>
            <button onclick="setPeriod(this,'month')">Tháng</button>
        </div>
    </div>

    <!-- KPI strip có sparkline -->
    <div class="rev-kpi-strip">
        <div class="rev-kpi">
            <div class="lbl">Doanh thu</div>
            <div class="val orange" id="kpiRevenue">18.4tr</div>
            <div class="sub"><span class="up">▲ 12%</span> so với kỳ trước</div>
            <div class="sparkline">
                <span style="height:40%"></span><span style="height:55%"></span><span style="height:35%"></span>
                <span style="height:70%"></span><span style="height:50%"></span><span style="height:80%"></span>
                <span class="hi" style="height:72%"></span>
            </div>
        </div>
        <div class="rev-kpi">
            <div class="lbl">Lợi nhuận gộp</div>
            <div class="val green" id="kpiProfit">7.12tr</div>
            <div class="sub">Biên LN <span class="up">38.7%</span></div>
            <div class="sparkline">
                <span style="height:48%"></span><span style="height:62%"></span><span style="height:42%"></span>
                <span style="height:74%"></span><span style="height:58%"></span><span style="height:84%"></span>
                <span class="hi" style="height:78%"></span>
            </div>
        </div>
        <div class="rev-kpi">
            <div class="lbl">Đơn hoàn tất</div>
            <div class="val" id="kpiOrders">21</div>
            <div class="sub"><span class="up">▲ 3</span> so với kỳ trước</div>
            <div class="sparkline">
                <span style="height:55%"></span><span style="height:70%"></span><span style="height:45%"></span>
                <span style="height:60%"></span><span style="height:75%"></span><span style="height:65%"></span>
                <span class="hi" style="height:88%"></span>
            </div>
        </div>
        <div class="rev-kpi">
            <div class="lbl">Công nợ chưa thu</div>
            <div class="val red" id="kpiDebt">5.25tr</div>
            <div class="sub">4 khách hàng còn nợ</div>
            <div class="sparkline">
                <span style="height:70%"></span><span style="height:62%"></span><span style="height:55%"></span>
                <span style="height:48%"></span><span style="height:42%"></span><span style="height:38%"></span>
                <span class="hi" style="height:35%"></span>
            </div>
        </div>
        <div class="rev-kpi">
            <div class="lbl">Tỉ lệ thu hồi</div>
            <div class="val violet" id="kpiCollection">92.4%</div>
            <div class="sub"><span class="up">▲ 1.8%</span> so với kỳ trước</div>
            <div class="sparkline">
                <span style="height:75%"></span><span style="height:78%"></span><span style="height:82%"></span>
                <span style="height:85%"></span><span style="height:88%"></span><span style="height:90%"></span>
                <span class="hi" style="height:92%"></span>
            </div>
        </div>
    </div>

    <!-- ========================================================
         SUB-TAB 1: TỔNG QUAN
         ======================================================== -->
    <div class="rev-subtab active" id="rev-overview">

        <div class="rev-cards">
            <div class="rev-card c1">
                <div class="lbl">Doanh thu <span id="revPeriod">hôm nay</span></div>
                <div class="num" id="revTotal">18.400.000₫</div>
                <div class="delta up" id="revDelta">▲ 12% so với kỳ trước</div>
            </div>
            <div class="rev-card c2">
                <div class="lbl">Lợi nhuận gộp</div>
                <div class="num" id="revProfit">7.120.000₫</div>
                <div class="delta up">Biên LN 38.7%</div>
            </div>
            <div class="rev-card c3">
                <div class="lbl">Đơn đã thanh toán</div>
                <div class="num" id="revOrders">21 đơn</div>
                <div class="delta up">▲ 3 đơn so với kỳ trước</div>
            </div>
            <div class="rev-card c4">
                <div class="lbl">Công nợ chưa thu</div>
                <div class="num" style="color:var(--red);">5.250.000₫</div>
                <div class="delta down">4 khách hàng còn nợ</div>
            </div>
        </div>

        <div class="bottom-grid" style="grid-template-columns:1.5fr 1fr;">
            <div class="panel">
                <div class="panel-head">
                    <h3>Doanh thu 7 ngày gần nhất</h3>
                    <a href="#" onclick="toast('Đã xuất báo cáo Excel');return false;">Xuất báo cáo</a>
                </div>
                <div class="chart">
                    <div class="chart-col"><div class="chart-bar" style="height:52%"><span>12.1tr</span></div><div class="chart-lbl">T2</div></div>
                    <div class="chart-col"><div class="chart-bar" style="height:68%"><span>15.8tr</span></div><div class="chart-lbl">T3</div></div>
                    <div class="chart-col"><div class="chart-bar" style="height:44%"><span>10.2tr</span></div><div class="chart-lbl">T4</div></div>
                    <div class="chart-col"><div class="chart-bar" style="height:78%"><span>18.0tr</span></div><div class="chart-lbl">T5</div></div>
                    <div class="chart-col"><div class="chart-bar" style="height:61%"><span>14.2tr</span></div><div class="chart-lbl">T6</div></div>
                    <div class="chart-col"><div class="chart-bar" style="height:88%"><span>20.4tr</span></div><div class="chart-lbl">T7</div></div>
                    <div class="chart-col"><div class="chart-bar hi" style="height:80%"><span>18.4tr</span></div><div class="chart-lbl">CN</div></div>
                </div>
            </div>

            <div class="panel">
                <div class="panel-head"><h3>Doanh thu theo sản phẩm</h3></div>
                <div class="donut-wrap">
                    <div class="donut">
                        <div class="donut-center">
                            <div class="num" id="donutTotal">18.4tr</div>
                            <div class="lbl">Tổng kỳ</div>
                        </div>
                    </div>
                    <div class="legend">
                        <div class="legend-item">
                            <span class="legend-dot" style="background:var(--orange);"></span>
                            <span class="name">Áo thun DTG</span>
                            <span class="pct">35%</span><span class="val">6.4tr</span>
                        </div>
                        <div class="legend-item">
                            <span class="legend-dot" style="background:var(--teal);"></span>
                            <span class="name">Cốc sứ Sublimation</span>
                            <span class="pct">27%</span><span class="val">4.9tr</span>
                        </div>
                        <div class="legend-item">
                            <span class="legend-dot" style="background:var(--violet);"></span>
                            <span class="name">Poster A2 UV</span>
                            <span class="pct">17%</span><span class="val">3.1tr</span>
                        </div>
                        <div class="legend-item">
                            <span class="legend-dot" style="background:var(--pink);"></span>
                            <span class="name">Túi vải canvas</span>
                            <span class="pct">12%</span><span class="val">2.2tr</span>
                        </div>
                        <div class="legend-item">
                            <span class="legend-dot" style="background:var(--blue);"></span>
                            <span class="name">Khác</span>
                            <span class="pct">9%</span><span class="val">1.8tr</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="bottom-grid" style="grid-template-columns:1fr 1fr;">
            <div class="panel">
                <div class="panel-head">
                    <h3>Top sản phẩm</h3>
                    <a href="#" onclick="revTabTo('transactions');return false;">Xem tất cả →</a>
                </div>
                <div class="top-list" id="topProducts"></div>
            </div>

            <div class="panel">
                <div class="panel-head">
                    <h3>Top khách hàng</h3>
                    <a href="#" onclick="revTabTo('debt');return false;">Xem công nợ →</a>
                </div>
                <div class="top-list" id="topCustomers"></div>
            </div>
        </div>

        <div class="panel" style="margin-top:18px;">
            <div class="panel-head">
                <h3>Giao dịch gần đây</h3>
                <a href="#" onclick="revTabTo('transactions');return false;">Xem tất cả →</a>
            </div>
            <div style="overflow-x:auto;">
                <table class="table">
                    <thead><tr><th>Mã đơn</th><th>Khách hàng</th><th>Sản phẩm</th><th>Số tiền</th><th>Trạng thái</th><th></th></tr></thead>
                    <tbody id="recentTable"></tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- ========================================================
         SUB-TAB 2: GIAO DỊCH
         ======================================================== -->
    <div class="rev-subtab" id="rev-transactions">
        <div class="rev-filter">
            <div class="fg"><label>Từ ngày</label><input type="date" id="fltFrom" value="2026-09-08"></div>
            <div class="fg"><label>Đến ngày</label><input type="date" id="fltTo" value="2026-09-15"></div>
            <div class="fg"><label>Trạng thái</label>
                <select id="fltStatus" onchange="renderTransactions()">
                    <option value="all">Tất cả</option>
                    <option value="paid">Đã thu</option>
                    <option value="partial">Thu một phần</option>
                    <option value="pending">Chờ thu</option>
                    <option value="debt">Còn nợ</option>
                    <option value="refund">Hoàn tiền</option>
                </select>
            </div>
            <div class="fg"><label>Phương thức</label>
                <select id="fltMethod" onchange="renderTransactions()">
                    <option value="all">Tất cả</option>
                    <option>Chuyển khoản</option>
                    <option>Tiền mặt</option>
                    <option>Ví điện tử</option>
                    <option>Thẻ</option>
                </select>
            </div>
            <div class="fg search"><label>Tìm kiếm</label>
                <input id="fltSearch" placeholder="Mã đơn, khách hàng, sản phẩm..." oninput="renderTransactions()">
            </div>
            <div class="actions">
                <button class="btn-ghost" style="padding:9px 16px; border-radius:8px; font-weight:700;" onclick="toast('Đã xuất file Excel giao dịch')">📥 Xuất</button>
                <button class="btn-start" style="padding:9px 16px; border-radius:8px; font-weight:700; border:none;" onclick="toast('Mở form ghi nhận thu')">+ Ghi nhận thu</button>
            </div>
        </div>

        <div class="panel">
            <div class="panel-head">
                <h3>Danh sách giao dịch</h3>
                <span style="font-size:12.5px; color:var(--muted);" id="txCount">23 giao dịch</span>
            </div>
            <div style="overflow-x:auto;">
                <table class="table">
                    <thead>
                    <tr>
                        <th>Mã đơn</th><th>Ngày</th><th>Khách hàng</th><th>Sản phẩm</th>
                        <th>Tổng tiền</th><th>Đã thu</th><th>Còn lại</th><th>PT</th><th>Trạng thái</th><th></th>
                    </tr>
                    </thead>
                    <tbody id="txTable"></tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- ========================================================
         SUB-TAB 3: CÔNG NỢ
         ======================================================== -->
    <div class="rev-subtab" id="rev-debt">
        <div class="aging-grid">
            <div class="aging a1"><div class="lbl">0 – 7 ngày</div><div class="num">18.2tr</div><div class="sub">3 khách · Trong hạn</div></div>
            <div class="aging a2"><div class="lbl">8 – 30 ngày</div><div class="num">14.8tr</div><div class="sub">2 khách · Nhắc nhở</div></div>
            <div class="aging a3"><div class="lbl">31 – 60 ngày</div><div class="num">6.5tr</div><div class="sub">1 khách · Cần xử lý</div></div>
            <div class="aging a4"><div class="lbl">Trên 60 ngày</div><div class="num">3.0tr</div><div class="sub">1 khách · Nguy cơ mất</div></div>
        </div>

        <div class="panel">
            <div class="panel-head">
                <h3>Danh sách công nợ theo khách hàng</h3>
                <div class="filter-tabs">
                    <button class="active" onclick="pickFilter(this)">Tất cả</button>
                    <button onclick="pickFilter(this)">Quá hạn</button>
                    <button onclick="pickFilter(this)">Sắp đến hạn</button>
                </div>
            </div>
            <div id="debtList"></div>
        </div>

        <div class="bottom-grid" style="margin-top:18px; grid-template-columns:1fr 1fr;">
            <div class="panel">
                <div class="panel-head"><h3>Nhắc nợ tự động</h3></div>
                <div style="font-size:13px; color:var(--muted); line-height:1.6; margin-bottom:14px;">
                    Gửi email/Zalo nhắc thanh toán tự động cho khách hàng có công nợ quá hạn.
                </div>
                <div class="form-field">
                    <label>Mẫu nhắc nợ</label>
                    <select>
                        <option>Nhắc nhở nhẹ nhàng (trước hạn 3 ngày)</option>
                        <option>Nhắc lần 1 (quá hạn 1–7 ngày)</option>
                        <option>Nhắc lần 2 (quá hạn 8–30 ngày)</option>
                        <option>Cảnh báo (quá hạn trên 30 ngày)</option>
                    </select>
                </div>
                <button class="btn-done" style="width:100%; padding:12px; border-radius:9px; font-weight:700; border:none;" onclick="toast('Đã gửi 6 email nhắc nợ tự động')">📧 Gửi nhắc nợ ngay</button>
            </div>

            <div class="panel">
                <div class="panel-head"><h3>Lịch sử thu nợ</h3></div>
                <div class="top-list">
                    <div class="top-row">
                        <div class="rank top1">✓</div>
                        <div class="top-info"><strong>Minh Anh Store</strong><span>Thu 12.4tr · Chuyển khoản · 14/09</span></div>
                        <div class="top-amount">+12.4tr</div>
                    </div>
                    <div class="top-row">
                        <div class="rank top2">✓</div>
                        <div class="top-info"><strong>Local Brand Co.</strong><span>Thu 8.2tr · Tiền mặt · 13/09</span></div>
                        <div class="top-amount">+8.2tr</div>
                    </div>
                    <div class="top-row">
                        <div class="rank top3">✓</div>
                        <div class="top-info"><strong>Quà Tặng Việt</strong><span>Thu 4.5tr · Ví điện tử · 12/09</span></div>
                        <div class="top-amount">+4.5tr</div>
                    </div>
                    <div class="top-row">
                        <div class="rank">✓</div>
                        <div class="top-info"><strong>Cần Thơ Store</strong><span>Thu 2.1tr · Chuyển khoản · 11/09</span></div>
                        <div class="top-amount">+2.1tr</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ========================================================
         SUB-TAB 4: CHI PHÍ & LỢI NHUẬN
         ======================================================== -->
    <div class="rev-subtab" id="rev-costs">
        <div class="bottom-grid" style="grid-template-columns:1.4fr 1fr;">
            <div class="panel">
                <div class="panel-head">
                    <h3>Cơ cấu chi phí</h3>
                    <span style="font-size:12.5px; color:var(--muted);">Tổng chi phí: 278.8tr (61.3%)</span>
                </div>

                <div class="cost-row">
                    <div class="cost-ic">🧵</div>
                    <div class="cost-info"><strong>Vật tư / Nguyên liệu</strong><span>Mực, phôi áo, giấy, cốc sứ...</span></div>
                    <div class="cost-meter"><div style="width:100%; background:var(--grad-hot);"></div></div>
                    <div class="cost-pct" style="color:var(--orange);">33%</div>
                    <div class="cost-amt">145.2tr</div>
                </div>

                <div class="cost-row">
                    <div class="cost-ic">👷</div>
                    <div class="cost-info"><strong>Nhân công</strong><span>Lương CN, thợ vận hành máy</span></div>
                    <div class="cost-meter"><div style="width:57%; background:var(--grad-cool);"></div></div>
                    <div class="cost-pct" style="color:var(--violet);">19%</div>
                    <div class="cost-amt">82.4tr</div>
                </div>

                <div class="cost-row">
                    <div class="cost-ic">🖨️</div>
                    <div class="cost-info"><strong>Khấu hao máy móc</strong><span>DTG, SUB, UV, SILK...</span></div>
                    <div class="cost-meter"><div style="width:17%; background:var(--grad-money);"></div></div>
                    <div class="cost-pct" style="color:var(--green);">5.6%</div>
                    <div class="cost-amt">24.6tr</div>
                </div>

                <div class="cost-row">
                    <div class="cost-ic">⚡</div>
                    <div class="cost-info"><strong>Điện nước</strong><span>Vận hành máy + chiếu sáng</span></div>
                    <div class="cost-meter"><div style="width:9%; background:linear-gradient(135deg,#FFB020,#FF8A1F);"></div></div>
                    <div class="cost-pct" style="color:var(--amber);">2.9%</div>
                    <div class="cost-amt">12.8tr</div>
                </div>

                <div class="cost-row">
                    <div class="cost-ic">🚚</div>
                    <div class="cost-info"><strong>Vận chuyển</strong><span>Giao hàng nội thành + tỉnh</span></div>
                    <div class="cost-meter"><div style="width:6%; background:linear-gradient(135deg,#FB5A6A,#F472B6);"></div></div>
                    <div class="cost-pct" style="color:var(--red);">1.9%</div>
                    <div class="cost-amt">8.2tr</div>
                </div>

                <div class="cost-row">
                    <div class="cost-ic">📦</div>
                    <div class="cost-info"><strong>Chi phí khác</strong><span>Bao bì, marketing, hành chính</span></div>
                    <div class="cost-meter"><div style="width:4%; background:var(--steel);"></div></div>
                    <div class="cost-pct" style="color:var(--muted);">1.3%</div>
                    <div class="cost-amt">5.6tr</div>
                </div>
            </div>

            <div style="display:flex; flex-direction:column; gap:18px;">
                <div class="panel">
                    <div class="panel-head"><h3>Biên lợi nhuận theo sản phẩm</h3></div>
                    <div class="top-list">
                        <div class="top-row">
                            <div class="rank top1">1</div>
                            <div class="top-info"><strong>Poster A2 UV</strong><span>DT 3.1tr · CP 1.4tr</span></div>
                            <div class="top-meter"><div style="width:55%; background:var(--grad-money);"></div></div>
                            <div class="top-amount">54.8%</div>
                        </div>
                        <div class="top-row">
                            <div class="rank top2">2</div>
                            <div class="top-info"><strong>Cốc sứ Sublimation</strong><span>DT 4.9tr · CP 2.4tr</span></div>
                            <div class="top-meter"><div style="width:51%; background:var(--grad-money);"></div></div>
                            <div class="top-amount">51.0%</div>
                        </div>
                        <div class="top-row">
                            <div class="rank top3">3</div>
                            <div class="top-info"><strong>Túi vải canvas</strong><span>DT 2.2tr · CP 1.2tr</span></div>
                            <div class="top-meter"><div style="width:45%; background:var(--grad-money);"></div></div>
                            <div class="top-amount">45.5%</div>
                        </div>
                        <div class="top-row">
                            <div class="rank">4</div>
                            <div class="top-info"><strong>Áo thun DTG</strong><span>DT 6.4tr · CP 4.0tr</span></div>
                            <div class="top-meter"><div style="width:37%; background:var(--grad-hot);"></div></div>
                            <div class="top-amount" style="color:var(--orange);">37.5%</div>
                        </div>
                        <div class="top-row">
                            <div class="rank">5</div>
                            <div class="top-info"><strong>Namecard 300gsm</strong><span>DT 1.8tr · CP 1.2tr</span></div>
                            <div class="top-meter"><div style="width:33%; background:var(--grad-hot);"></div></div>
                            <div class="top-amount" style="color:var(--orange);">33.3%</div>
                        </div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-head"><h3>Ghi nhận chi phí phát sinh</h3></div>
                    <div class="form-field">
                        <label>Loại chi phí</label>
                        <select>
                            <option>Vật tư / Nguyên liệu</option>
                            <option>Nhân công ngoài giờ</option>
                            <option>Sửa chữa máy móc</option>
                            <option>Vận chuyển phát sinh</option>
                            <option>Chi phí khác</option>
                        </select>
                    </div>
                    <div class="form-field">
                        <label>Số tiền (₫)</label>
                        <input type="number" placeholder="VD: 500000">
                    </div>
                    <button class="btn-start" style="width:100%; padding:12px; border-radius:9px; font-weight:700; border:none;" onclick="toast('Đã ghi nhận chi phí phát sinh')">+ Ghi nhận chi phí</button>
                </div>
            </div>
        </div>
    </div>

    <!-- ========================================================
         SUB-TAB 5: BÁO CÁO
         ======================================================== -->
    <div class="rev-subtab" id="rev-reports">
        <div class="report-grid">
            <div class="report-card rc1" onclick="generateReport('Doanh thu chi tiết')">
                <div class="ric">📊</div><h4>Báo cáo doanh thu</h4>
                <p>Chi tiết doanh thu theo ngày, sản phẩm, khách hàng và phương thức thanh toán.</p>
                <span class="dl">Xuất PDF / Excel →</span>
            </div>
            <div class="report-card rc2" onclick="generateReport('Báo cáo lợi nhuận')">
                <div class="ric">💰</div><h4>Báo cáo lợi nhuận</h4>
                <p>Phân tích biên lợi nhuận theo sản phẩm, đơn hàng và khách hàng.</p>
                <span class="dl">Xuất PDF / Excel →</span>
            </div>
            <div class="report-card rc3" onclick="generateReport('Báo cáo công nợ')">
                <div class="ric">📋</div><h4>Báo cáo công nợ</h4>
                <p>Danh sách khách hàng còn nợ, phân nhóm tuổi nợ và tình trạng thu hồi.</p>
                <span class="dl">Xuất PDF / Excel →</span>
            </div>
            <div class="report-card rc4" onclick="generateReport('Báo cáo chi phí')">
                <div class="ric">📉</div><h4>Báo cáo chi phí</h4>
                <p>Cơ cấu chi phí vận hành xưởng theo từng loại và theo kỳ.</p>
                <span class="dl">Xuất PDF / Excel →</span>
            </div>
            <div class="report-card rc1" onclick="generateReport('Báo cáo thuế GTGT')">
                <div class="ric">🧾</div><h4>Báo cáo thuế GTGT</h4>
                <p>Tổng hợp hóa đơn đầu vào – đầu ra, thuế GTGT phải nộp theo kỳ.</p>
                <span class="dl">Xuất PDF / Excel →</span>
            </div>
            <div class="report-card rc2" onclick="generateReport('Hiệu suất máy móc')">
                <div class="ric">🖨️</div><h4>Hiệu suất máy móc</h4>
                <p>Thời gian hoạt động, năng suất và chi phí vận hành từng máy.</p>
                <span class="dl">Xuất PDF / Excel →</span>
            </div>
        </div>

        <div class="panel" style="margin-top:18px;">
            <div class="panel-head">
                <h3>So sánh kỳ</h3>
                <div class="filter-tabs">
                    <button class="active" onclick="pickFilter(this)">Tháng 9 vs Tháng 8</button>
                    <button onclick="pickFilter(this)">Tuần này vs tuần trước</button>
                </div>
            </div>
            <div style="overflow-x:auto;">
                <table class="table">
                    <thead>
                    <tr><th>Chỉ số</th><th>Kỳ này</th><th>Kỳ trước</th><th>Chênh lệch</th><th>Tăng trưởng</th></tr>
                    </thead>
                    <tbody>
                    <tr><td><strong>Doanh thu</strong></td><td class="money" style="color:var(--green);">438.6tr</td><td class="money">380.5tr</td><td class="money" style="color:var(--green);">+58.1tr</td><td><span class="badge paid">▲ 15.3%</span></td></tr>
                    <tr><td><strong>Lợi nhuận gộp</strong></td><td class="money" style="color:var(--green);">169.8tr</td><td class="money">142.7tr</td><td class="money" style="color:var(--green);">+27.1tr</td><td><span class="badge paid">▲ 19.0%</span></td></tr>
                    <tr><td><strong>Số đơn</strong></td><td class="money">586</td><td class="money">528</td><td class="money" style="color:var(--green);">+58</td><td><span class="badge paid">▲ 11.0%</span></td></tr>
                    <tr><td><strong>Giá trị đơn TB</strong></td><td class="money">748.500₫</td><td class="money">720.600₫</td><td class="money" style="color:var(--green);">+27.900₫</td><td><span class="badge paid">▲ 3.9%</span></td></tr>
                    <tr><td><strong>Công nợ cuối kỳ</strong></td><td class="money" style="color:var(--red);">42.5tr</td><td class="money">38.2tr</td><td class="money" style="color:var(--red);">+4.3tr</td><td><span class="badge debt">▲ 11.3%</span></td></tr>
                    <tr><td><strong>Tỉ lệ thu hồi</strong></td><td class="money" style="color:var(--green);">92.4%</td><td class="money">90.6%</td><td class="money" style="color:var(--green);">+1.8%</td><td><span class="badge paid">▲ 2.0%</span></td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div><!-- /#tab-revenue -->

</div><!-- /.content -->

<!-- ===== Profile modal + overlay + toast (giữ nguyên) ===== -->
<div class="overlay" id="overlay" onclick="closeAll()"></div>

<div class="modal" id="profileModal">
    <div class="modal-box" style="width:420px;">
        <div class="modal-head">
            <button class="modal-close" onclick="closeAll()">✕</button>
            <h3>Đặng Long</h3>
            <div class="sub">Quản lý ca sản xuất · Sài Gòn Print</div>
        </div>
        <div class="detail-grid" style="grid-template-columns:1fr 1fr;">
            <div class="field"><label>Ca hiện tại</label><strong>Ca sáng</strong></div>
            <div class="field"><label>Bắt đầu</label><strong>06:00</strong></div>
            <div class="field"><label>Đơn đã xử lý</label><strong>24 hôm nay</strong></div>
            <div class="field"><label>Hiệu suất</label><strong style="color:var(--green);">96%</strong></div>
        </div>
        <div style="display:flex; gap:10px; margin-top:6px;">
            <button class="btn-ghost" style="flex:1; padding:11px; border-radius:9px; font-weight:700;" onclick="toast('Đã đăng xuất')">Đăng xuất</button>
            <button class="btn-start" style="flex:1; padding:11px; border-radius:9px; font-weight:700; border:none;" onclick="closeAll()">Đóng</button>
        </div>
    </div>
</div>

<div class="toast" id="toast">Đã thực hiện</div>

<script>
/* ============================================================
   JS GỐC (giữ nguyên)
   ============================================================ */
function tick(){
    const d = new Date();
    const hh = String(d.getHours()).padStart(2,'0');
    const mm = String(d.getMinutes()).padStart(2,'0');
    document.getElementById('clock').textContent = hh + ':' + mm;
}
tick(); setInterval(tick, 30000);

let toastTimer;
function toast(msg){
    const t = document.getElementById('toast');
    t.textContent = msg;
    t.classList.add('show');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(()=>t.classList.remove('show'), 2400);
}

function pickFilter(btn){
    btn.parentElement.querySelectorAll('button').forEach(b=>b.classList.remove('active'));
    btn.classList.add('active');
}

function openModal(id){
    document.getElementById(id).classList.add('show');
    document.getElementById('overlay').classList.add('show');
}
function closeAll(){
    document.querySelectorAll('.modal, .overlay').forEach(el=>el.classList.remove('show'));
}
document.addEventListener('keydown', e=>{ if(e.key === 'Escape') closeAll(); });

/* ============================================================
   BLOCK D — JS MỚI THÊM
   Copy nguyên khối này vào <script> của Xưởng.html
   ============================================================ */

/* --- Sub-tab navigation trong tab Doanh thu --- */
function revTab(btn, id){
    document.querySelectorAll('#tab-revenue .rev-subtabs > button').forEach(b=>b.classList.remove('active'));
    btn.classList.add('active');
    document.querySelectorAll('#tab-revenue .rev-subtab').forEach(c=>c.classList.remove('active'));
    document.getElementById('rev-' + id).classList.add('active');
}
function revTabTo(id){
    const btn = Array.from(document.querySelectorAll('#tab-revenue .rev-subtabs > button'))
        .find(b => b.getAttribute('onclick') && b.getAttribute('onclick').includes("'" + id + "'"));
    if(btn) revTab(btn, id);
}

/* --- Period selector --- */
const PERIODS = {
    day:   { revenue:'18.4tr',  profit:'7.12tr',  orders:'21',    debt:'5.25tr', collection:'92.4%',
             revPeriod:'hôm nay', revTotal:'18.400.000₫', revProfit:'7.120.000₫', revOrders:'21 đơn',
             revDelta:'▲ 12% so với hôm qua', donutTotal:'18.4tr' },
    week:  { revenue:'109.1tr', profit:'42.3tr',  orders:'142',   debt:'18.2tr', collection:'91.2%',
             revPeriod:'tuần này', revTotal:'109.100.000₫', revProfit:'42.300.000₫', revOrders:'142 đơn',
             revDelta:'▲ 8% so với tuần trước', donutTotal:'109.1tr' },
    month: { revenue:'438.6tr', profit:'169.8tr', orders:'586',   debt:'42.5tr', collection:'90.8%',
             revPeriod:'tháng này', revTotal:'438.600.000₫', revProfit:'169.800.000₫', revOrders:'586 đơn',
             revDelta:'▲ 15% so với tháng trước', donutTotal:'438.6tr' }
};

function setPeriod(btn, key){
    btn.parentElement.querySelectorAll('button').forEach(b=>b.classList.remove('active'));
    btn.classList.add('active');
    const p = PERIODS[key];
    // KPI strip
    document.getElementById('kpiRevenue').textContent = p.revenue;
    document.getElementById('kpiProfit').textContent = p.profit;
    document.getElementById('kpiOrders').textContent = p.orders;
    document.getElementById('kpiDebt').textContent = p.debt;
    document.getElementById('kpiCollection').textContent = p.collection;
    // Rev cards
    document.getElementById('revPeriod').textContent = p.revPeriod;
    document.getElementById('revTotal').textContent = p.revTotal;
    document.getElementById('revProfit').textContent = p.revProfit;
    document.getElementById('revOrders').textContent = p.revOrders;
    document.getElementById('revDelta').textContent = p.revDelta;
    // Donut
    document.getElementById('donutTotal').textContent = p.donutTotal;
}

/* --- Top lists --- */
const TOP_PRODUCTS = [
    { name:'Áo thun DTG', qty:'156 sản phẩm', amount:'6.4tr', pct:100, grad:'var(--grad-hot)' },
    { name:'Cốc sứ Sublimation', qty:'410 sản phẩm', amount:'4.9tr', pct:76, grad:'var(--grad-cool)' },
    { name:'Poster A2 UV', qty:'180 tờ', amount:'3.1tr', pct:48, grad:'var(--grad-money)' },
    { name:'Túi vải canvas', qty:'140 chiếc', amount:'2.2tr', pct:34, grad:'linear-gradient(135deg,#FB5A6A,#F472B6)' },
    { name:'Namecard 300gsm', qty:'88 hộp', amount:'1.8tr', pct:28, grad:'linear-gradient(135deg,#60A5FA,#8B5CF6)' }
];
const TOP_CUSTOMERS = [
    { name:'Minh Anh Store', orders:'48 đơn', amount:'82.4tr', pct:100, grad:'var(--grad-hot)' },
    { name:'Local Brand Co.', orders:'36 đơn', amount:'68.2tr', pct:83, grad:'var(--grad-cool)' },
    { name:'Quà Tặng Việt', orders:'28 đơn', amount:'54.6tr', pct:66, grad:'var(--grad-money)' },
    { name:'The Coffee House X', orders:'22 đơn', amount:'42.1tr', pct:51, grad:'linear-gradient(135deg,#FB5A6A,#F472B6)' },
    { name:'Cần Thơ Store', orders:'18 đơn', amount:'28.9tr', pct:35, grad:'linear-gradient(135deg,#60A5FA,#8B5CF6)' }
];

function renderTopProducts(){
    document.getElementById('topProducts').innerHTML = TOP_PRODUCTS.map((p,i)=>`
        <div class="top-row">
            <div class="rank ${i===0?'top1':i===1?'top2':i===2?'top3':''}">${i+1}</div>
            <div class="top-info"><strong>${p.name}</strong><span>${p.qty}</span></div>
            <div class="top-meter"><div style="width:${p.pct}%; background:${p.grad};"></div></div>
            <div class="top-amount">${p.amount}</div>
        </div>
    `).join('');
}
function renderTopCustomers(){
    document.getElementById('topCustomers').innerHTML = TOP_CUSTOMERS.map((c,i)=>`
        <div class="top-row">
            <div class="rank ${i===0?'top1':i===1?'top2':i===2?'top3':''}">${i+1}</div>
            <div class="top-info"><strong>${c.name}</strong><span>${c.orders}</span></div>
            <div class="top-meter"><div style="width:${c.pct}%; background:${c.grad};"></div></div>
            <div class="top-amount">${c.amount}</div>
        </div>
    `).join('');
}

/* --- Transactions --- */
const TRANSACTIONS = [
    { id:'#PK-08238', date:'15/09/2026', customer:'Cần Thơ Store',    product:'Cốc sứ 350ml — 60 chiếc',     total:2240000, paid:2240000, method:'Chuyển khoản', status:'paid' },
    { id:'#PK-08237', date:'15/09/2026', customer:'Minh Anh Store',   product:'Poster A2 — 40 tờ',           total:3100000, paid:1500000, method:'Chuyển khoản', status:'partial' },
    { id:'#PK-08236', date:'15/09/2026', customer:'Xanh Coffee',      product:'Bình giữ nhiệt — 100 chiếc',  total:12500000, paid:0,       method:'Chuyển khoản', status:'pending' },
    { id:'#PK-08235', date:'15/09/2026', customer:'Quà Tặng Việt',    product:'Cốc sứ Sublimation — 200 chiếc', total:5600000, paid:5600000, method:'Tiền mặt',    status:'paid' },
    { id:'#PK-08234', date:'14/09/2026', customer:'Minh Anh Store',   product:'Áo thun Oversize — 24 chiếc',  total:3096000, paid:3096000, method:'Ví điện tử',   status:'paid' },
    { id:'#PK-08233', date:'14/09/2026', customer:'The Coffee House X', product:'Túi vải canvas — 80 chiếc',  total:3360000, paid:3360000, method:'Chuyển khoản', status:'paid' },
    { id:'#PK-08232', date:'14/09/2026', customer:'Quà Tặng Việt',    product:'Cốc sứ — 150 chiếc',          total:4200000, paid:0,       method:'Chuyển khoản', status:'pending' },
    { id:'#PK-08231', date:'14/09/2026', customer:'Minh Anh Store',   product:'Áo thun Oversize — 24 chiếc',  total:3096000, paid:3096000, method:'Chuyển khoản', status:'paid' },
    { id:'#PK-08230', date:'13/09/2026', customer:'Local Brand Co.', product:'Áo thun DTG — 120 chiếc',      total:9600000, paid:0,       method:'Chuyển khoản', status:'debt' },
    { id:'#PK-08229', date:'13/09/2026', customer:'Nguyễn Thảo',      product:'Cốc sứ — 30 chiếc',            total:1950000, paid:1950000, method:'Ví điện tử',   status:'paid' },
    { id:'#PK-08228', date:'13/09/2026', customer:'Cần Thơ Store',    product:'Namecard — 500 tấm',           total:600000,  paid:600000,  method:'Tiền mặt',     status:'paid' },
    { id:'#PK-08227', date:'12/09/2026', customer:'Local Brand Co.', product:'Áo thun DTG — 36 chiếc',       total:2880000, paid:2880000, method:'Chuyển khoản', status:'paid' },
    { id:'#PK-08226', date:'12/09/2026', customer:'Cần Thơ Store',    product:'Namecard — 500 tấm',           total:600000,  paid:600000,  method:'Chuyển khoản', status:'paid' },
    { id:'#PK-08225', date:'12/09/2026', customer:'Minh Anh Store',   product:'Poster A2 — 100 tờ',           total:3100000, paid:3100000, method:'Thẻ',          status:'paid' },
    { id:'#PK-08224', date:'11/09/2026', customer:'Local Brand Co.', product:'Áo thun DTG — 36 chiếc',       total:2880000, paid:2880000, method:'Chuyển khoản', status:'paid' },
    { id:'#PK-08223', date:'11/09/2026', customer:'Quà Tặng Việt',    product:'Cốc sứ — 80 chiếc',            total:2240000, paid:2240000, method:'Ví điện tử',   status:'paid' },
    { id:'#PK-08222', date:'10/09/2026', customer:'Minh Anh Store',   product:'Áo thun Oversize — 24 chiếc',  total:3096000, paid:3096000, method:'Chuyển khoản', status:'paid' },
    { id:'#PK-08221', date:'10/09/2026', customer:'Xanh Coffee',      product:'Bình giữ nhiệt — 50 chiếc',    total:6250000, paid:3125000, method:'Chuyển khoản', status:'partial' },
    { id:'#PK-08220', date:'09/09/2026', customer:'Local Brand Co.', product:'Áo thun DTG — 36 chiếc',       total:2880000, paid:0,       method:'—',            status:'refund' },
    { id:'#PK-08219', date:'09/09/2026', customer:'The Coffee House X', product:'Túi vải canvas — 60 chiếc',  total:2520000, paid:2520000, method:'Tiền mặt',     status:'paid' },
    { id:'#PK-08218', date:'08/09/2026', customer:'Quà Tặng Việt',    product:'Cốc sứ — 100 chiếc',           total:2800000, paid:2800000, method:'Chuyển khoản', status:'paid' },
    { id:'#PK-08217', date:'08/09/2026', customer:'Cần Thơ Store',    product:'Namecard — 1.000 tấm',         total:1100000, paid:1100000, method:'Tiền mặt',     status:'paid' },
    { id:'#PK-08216', date:'08/09/2026', customer:'Minh Anh Store',   product:'Poster A2 — 60 tờ',            total:1860000, paid:1860000, method:'Chuyển khoản', status:'paid' }
];

const STATUS_META = {
    paid:    { label:'Đã thu',        cls:'paid' },
    pending: { label:'Chờ thu',       cls:'pending' },
    partial: { label:'Thu một phần',  cls:'pending' },
    debt:    { label:'Còn nợ',        cls:'debt' },
    refund:  { label:'Hoàn tiền',     cls:'pending' }
};
const fmt = n => n.toLocaleString('vi-VN') + '₫';

function renderTransactions(){
    const status = document.getElementById('fltStatus').value;
    const method = document.getElementById('fltMethod').value;
    const q = document.getElementById('fltSearch').value.toLowerCase().trim();

    const list = TRANSACTIONS.filter(t=>{
        const matchStatus = status === 'all' || t.status === status;
        const matchMethod = method === 'all' || t.method === method;
        const matchQ = !q ||
            t.id.toLowerCase().includes(q) ||
            t.customer.toLowerCase().includes(q) ||
            t.product.toLowerCase().includes(q);
        return matchStatus && matchMethod && matchQ;
    });

    document.getElementById('txCount').textContent = list.length + ' giao dịch';
    const tbody = document.getElementById('txTable');
    if(list.length === 0){
        tbody.innerHTML = `<tr><td colspan="10" style="text-align:center; padding:36px; color:var(--muted);">Không có giao dịch phù hợp</td></tr>`;
        return;
    }
    tbody.innerHTML = list.map(t=>{
        const remaining = t.total - t.paid;
        const meta = STATUS_META[t.status];
        return `
            <tr>
                <td><strong style="color:var(--orange); font-family:'Barlow Condensed';">${t.id}</strong></td>
                <td>${t.date}</td>
                <td><strong style="color:white;">${t.customer}</strong></td>
                <td style="color:var(--muted);">${t.product}</td>
                <td class="money">${fmt(t.total)}</td>
                <td class="money" style="color:var(--green);">${fmt(t.paid)}</td>
                <td class="money" style="${remaining>0?'color:var(--red);':''}">${remaining>0?fmt(remaining):'—'}</td>
                <td style="font-size:12.5px; color:var(--muted);">${t.method}</td>
                <td><span class="badge ${meta.cls}">${meta.label}</span></td>
                <td><button class="btn-ghost" style="padding:5px 11px;border-radius:7px;font-size:12px;font-weight:600;" onclick="toast('Mở chi tiết ${t.id}')">Xem</button></td>
            </tr>`;
    }).join('');
}

function renderRecentTable(){
    const recent = TRANSACTIONS.slice(0,5);
    document.getElementById('recentTable').innerHTML = recent.map(t=>{
        const meta = STATUS_META[t.status];
        return `
            <tr>
                <td><strong style="color:var(--orange); font-family:'Barlow Condensed';">${t.id}</strong></td>
                <td><strong style="color:white;">${t.customer}</strong></td>
                <td style="color:var(--muted);">${t.product}</td>
                <td class="money">${fmt(t.total)}</td>
                <td><span class="badge ${meta.cls}">${meta.label}</span></td>
                <td><button class="btn-ghost" style="padding:5px 11px;border-radius:7px;font-size:12px;font-weight:600;" onclick="toast('Mở chi tiết ${t.id}')">Chi tiết</button></td>
            </tr>`;
    }).join('');
}

/* --- Debt --- */
const DEBTORS = [
    { name:'Local Brand Co.', initials:'LB', grad:'var(--grad-cool)', total:12500000, paid:3200000, overdue:'Quá hạn 12 ngày', color:'var(--red)' },
    { name:'Minh Anh Store',  initials:'MA', grad:'var(--grad-hot)',  total:3096000,  paid:2000000, overdue:'Còn 5 ngày',       color:'var(--orange)' },
    { name:'Xanh Coffee',     initials:'XC', grad:'linear-gradient(135deg,#22D3EE,#34D399)', total:6250000, paid:3125000, overdue:'Còn 8 ngày', color:'var(--orange)' },
    { name:'Cần Thơ Store',   initials:'CT', grad:'linear-gradient(135deg,#60A5FA,#8B5CF6)', total:2800000, paid:1400000, overdue:'Quá hạn 34 ngày', color:'var(--red)' },
    { name:'Quà Tặng Việt',   initials:'QT', grad:'var(--grad-money)', total:4200000,  paid:0,       overdue:'Còn 3 ngày',       color:'var(--orange)' }
];

function renderDebt(){
    document.getElementById('debtList').innerHTML = DEBTORS.map(d=>{
        const remaining = d.total - d.paid;
        const pct = Math.round((d.paid / d.total) * 100);
        return `
            <div class="debt-row">
                <div class="debt-avatar" style="background:${d.grad};">${d.initials}</div>
                <div class="debt-info">
                    <strong>${d.name}</strong>
                    <span>Đã thu ${fmt(d.paid)} / ${fmt(d.total)} · <span style="color:${d.color}; font-weight:600;">${d.overdue}</span></span>
                </div>
                <div class="debt-bar">
                    <div style="width:${pct}%; background:${pct >= 80 ? 'var(--grad-money)' : pct >= 40 ? 'var(--grad-hot)' : 'linear-gradient(135deg,#FB5A6A,#F472B6)'};"></div>
                </div>
                <div class="debt-amt">${fmt(remaining)}</div>
                <div class="debt-actions">
                    <button class="btn-ghost" style="padding:5px 10px;border-radius:7px;font-size:11.5px;font-weight:600;" onclick="toast('Đã gửi nhắc nợ tới ${d.name}')">Nhắc</button>
                    <button class="btn-start" style="padding:5px 10px;border-radius:7px;font-size:11.5px;font-weight:700;border:none;" onclick="toast('Mở form thu tiền của ${d.name}')">Thu</button>
                </div>
            </div>`;
    }).join('');
}

/* --- Report --- */
function generateReport(name){
    toast('Đang tạo "' + name + '" — file sẽ tải xuống trong giây lát');
}

/* --- Init toàn bộ phần mới --- */
renderTopProducts();
renderTopCustomers();
renderRecentTable();
renderTransactions();
renderDebt();
</script>
</body>
</html>