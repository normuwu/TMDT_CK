<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>PrintKraft Xưởng — Sài Gòn Print</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@600;700&family=Barlow:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
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
        ::-webkit-scrollbar{width:9px;height:9px;}
        ::-webkit-scrollbar-track{background:var(--steel-2);}
        ::-webkit-scrollbar-thumb{background:#3A4052;border-radius:9px;}
        ::-webkit-scrollbar-thumb:hover{background:var(--orange);}

        /* ===== Top bar ===== */
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
        .shift-info{
            display:flex; align-items:center; gap:22px; font-size:13px; color:var(--muted); flex-wrap:wrap;
        }
        .shift-info .live{
            display:flex; align-items:center; gap:7px; color:var(--green); font-weight:600;
        }
        .shift-info .live .dot{width:8px; height:8px; border-radius:50%; background:var(--green); animation:pulse 1.6s infinite; box-shadow:0 0 10px var(--green);}
        @keyframes pulse{0%,100%{opacity:1; transform:scale(1);}50%{opacity:0.35; transform:scale(.8);}}
        .op-avatar{
            width:38px; height:38px; border-radius:50%; background:var(--grad-hot);
            display:flex; align-items:center; justify-content:center; font-weight:700; color:#1A1C22;
            cursor:pointer; transition:.18s; box-shadow:0 0 0 0 var(--orange-glow);
        }
        .op-avatar:hover{transform:scale(1.06); box-shadow:0 0 0 5px var(--orange-glow);}

        /* ===== Nav tabs ===== */
        .nav-tabs{
            background:linear-gradient(180deg,#1F222B,#1B1E26);
            border-bottom:1px solid var(--steel);
            padding:0 28px;
            display:flex; gap:4px; overflow-x:auto;
        }
        .nav-tabs button{
            background:transparent; border:none; color:var(--muted);
            padding:14px 18px; font-size:13.5px; font-weight:600;
            border-bottom:3px solid transparent; white-space:nowrap; transition:.18s;
        }
        .nav-tabs button.active{
            color:white; border-image:var(--grad-hot) 1;
            border-bottom:3px solid var(--orange);
            text-shadow:0 0 18px var(--orange-glow);
        }
        .nav-tabs button:hover{color:var(--off);}

        /* ===== Stat strip ===== */
        .stat-strip{
            display:grid; grid-template-columns:repeat(5,1fr);
            border-bottom:1px solid var(--steel);
            background:rgba(32,35,44,.5);
        }
        .stat{padding:20px 28px; border-right:1px solid var(--steel); position:relative; overflow:hidden;}
        .stat:last-child{border-right:none;}
        .stat:before{content:""; position:absolute; left:0; top:0; width:100%; height:2px; background:transparent; transition:.2s;}
        .stat:hover:before{background:var(--grad-hot);}
        .stat .cond{font-size:15px; color:var(--muted); text-transform:uppercase; letter-spacing:0.06em;}
        .stat .val{font-size:38px; font-weight:700; color:white; margin-top:4px;}
        .stat .val.orange{color:var(--orange); text-shadow:0 0 26px var(--orange-glow);}
        .stat .val.red{color:var(--red); text-shadow:0 0 26px rgba(251,90,106,.35);}
        .stat .val.green{color:var(--green); text-shadow:0 0 26px rgba(52,211,153,.35);}
        .stat .val.violet{color:var(--violet); text-shadow:0 0 26px rgba(139,92,246,.4);}
        .stat .sub{font-size:12.5px; color:var(--muted); margin-top:4px;}

        .content{padding:26px 28px 90px;}

        .section-title{
            display:flex; justify-content:space-between; align-items:center; margin-bottom:16px; flex-wrap:wrap; gap:12px;
        }
        .section-title h2{font-size:26px; color:white; font-weight:700;}
        .filter-tabs{display:flex; gap:8px; flex-wrap:wrap;}
        .filter-tabs button{
            background:var(--steel-2); border:1px solid var(--steel); color:var(--muted);
            padding:9px 16px; border-radius:8px; font-weight:600; font-size:13.5px; cursor:pointer; transition:.16s;
        }
        .filter-tabs button:hover{color:var(--off); border-color:#3C4358;}
        .filter-tabs button.active{background:var(--grad-hot); color:#1A1C22; border-color:transparent; box-shadow:0 4px 16px var(--orange-glow);}

        /* ===== Job queue kanban ===== */
        .queue{display:grid; grid-template-columns:repeat(5,1fr); gap:16px; margin-bottom:36px;}
        .queue-col{background:linear-gradient(180deg,var(--steel-3),var(--steel-2)); border-radius:14px; padding:16px; border:1px solid var(--steel);}
        .queue-col-head{display:flex; justify-content:space-between; align-items:center; margin-bottom:14px;}
        .queue-col-head h3{font-size:19px; color:white; font-weight:700; text-transform:uppercase; letter-spacing:0.03em;}
        .count-chip{background:var(--steel); color:var(--off); font-size:12px; font-weight:700; padding:3px 10px; border-radius:999px;}
        .queue-col.urgent-col .count-chip{background:var(--red); color:white; box-shadow:0 0 14px rgba(251,90,106,.5);}
        .queue-col.new-col .count-chip{background:var(--violet); color:white; box-shadow:0 0 14px rgba(139,92,246,.5);}

        .job-card{
            background:linear-gradient(180deg,#1D2029,#191C24);
            border:1px solid var(--steel); border-radius:11px;
            padding:14px; margin-bottom:12px; transition:.18s;
        }
        .job-card:hover{border-color:var(--orange); transform:translateY(-2px); box-shadow:0 8px 22px rgba(0,0,0,.35), 0 0 0 1px rgba(255,138,31,.15);}
        .job-card.urgent{border-color:var(--red); border-width:1.5px; box-shadow:0 0 0 1px rgba(251,90,106,.12);}
        .job-card.done-card{border-color:rgba(52,211,153,.55);}
        .job-card.done-card:hover{border-color:var(--green); box-shadow:0 8px 22px rgba(0,0,0,.35), 0 0 0 1px rgba(52,211,153,.2);}
        .job-top{display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:8px; gap:8px;}
        .job-id{font-family:'Barlow Condensed'; font-size:17px; font-weight:700; color:white;}
        .due{font-size:11.5px; font-weight:700; padding:3px 9px; border-radius:6px; white-space:nowrap;}
        .due.ok{background:rgba(52,211,153,0.16); color:var(--green);}
        .due.soon{background:rgba(255,138,31,0.16); color:var(--orange);}
        .due.late{background:rgba(251,90,106,0.16); color:var(--red);}
        .due.new{background:rgba(139,92,246,0.16); color:var(--violet);}
        .job-desc{font-size:13.5px; color:var(--off); margin-bottom:8px;}
        .job-meta{display:flex; justify-content:space-between; font-size:12px; color:var(--muted); margin-bottom:10px; flex-wrap:wrap; gap:4px;}
        .job-actions{display:flex; gap:8px; flex-wrap:wrap;}
        .job-actions button{
            flex:1; min-width:88px; padding:10px; border-radius:8px; font-weight:700; font-size:13px; cursor:pointer; border:none; transition:.16s;
        }
        .btn-start{background:var(--grad-hot); color:#1A1C22; box-shadow:0 4px 14px rgba(255,138,31,.28);}
        .btn-start:hover{filter:brightness(1.1); transform:translateY(-1px);}
        .btn-done{background:var(--grad-money); color:#0F1A15; box-shadow:0 4px 14px rgba(52,211,153,.25);}
        .btn-done:hover{filter:brightness(1.1); transform:translateY(-1px);}
        .btn-danger{background:rgba(251,90,106,.15); color:var(--red); border:1px solid rgba(251,90,106,.4) !important;}
        .btn-danger:hover{background:var(--red); color:#fff;}
        .btn-edit{background:rgba(139,92,246,.16); color:#B79BFF; border:1px solid rgba(139,92,246,.4) !important;}
        .btn-edit:hover{background:var(--violet); color:#fff;}
        .btn-ghost{background:transparent; border:1px solid var(--steel) !important; color:var(--off);}
        .btn-ghost:hover{border-color:var(--orange) !important; color:var(--orange);}

        /* ===== Equipment / material status ===== */
        .bottom-grid{display:grid; grid-template-columns:1.3fr 1fr; gap:18px; margin-bottom:18px;}
        .panel{
            background:linear-gradient(180deg,var(--steel-3),var(--steel-2));
            border:1px solid var(--steel); border-radius:14px; padding:18px 20px;
        }
        .panel h3{font-size:19px; color:white; font-weight:700; margin-bottom:14px; text-transform:uppercase; letter-spacing:0.03em;}
        .panel-head{display:flex; justify-content:space-between; align-items:center; margin-bottom:14px;}
        .panel-head h3{margin-bottom:0;}
        .panel-head a{font-size:12.5px; color:var(--orange); font-weight:600;}
        .panel-head a:hover{text-decoration:underline;}

        .machine-row{
            display:flex; align-items:center; gap:14px; padding:12px 0; border-bottom:1px solid var(--steel);
        }
        .machine-row:last-child{border-bottom:none;}
        .machine-icon{
            width:42px; height:42px; border-radius:10px; background:#16181F;
            display:flex; align-items:center; justify-content:center; font-size:19px; flex-shrink:0;
            border:1px solid var(--steel);
        }
        .machine-info{flex:1; min-width:0;}
        .machine-info strong{display:block; font-size:14.5px; color:white; font-weight:600;}
        .machine-info span{font-size:12px; color:var(--muted);}
        .machine-meter{width:90px; height:6px; background:#14161C; border-radius:999px; overflow:hidden; margin-top:5px;}
        .machine-meter div{height:100%; border-radius:999px; transition:width .4s;}
        .status-tag{font-size:11.5px; font-weight:700; padding:4px 10px; border-radius:999px; white-space:nowrap;}
        .status-tag.run{background:rgba(52,211,153,0.16); color:var(--green);}
        .status-tag.idle{background:rgba(154,160,176,0.16); color:var(--muted);}
        .status-tag.maint{background:rgba(251,90,106,0.16); color:var(--red);}
        .status-tag.sell{background:rgba(255,138,31,0.16); color:var(--orange);}

        .material-row{display:flex; justify-content:space-between; align-items:center; padding:11px 0; border-bottom:1px solid var(--steel); font-size:13.5px; gap:12px;}
        .material-row:last-child{border-bottom:none;}
        .material-row .name{flex:1; min-width:0;}
        .material-row .name span{display:block; font-size:11.5px; color:var(--muted); margin-top:2px;}
        .stock-bar{width:110px; height:8px; border-radius:999px; background:#14161C; overflow:hidden; flex-shrink:0;}
        .stock-fill{height:100%; border-radius:999px; transition:width .4s;}
        .stock-pct{font-size:12px; font-weight:700; width:38px; text-align:right;}

        /* ===== Alerts ===== */
        .alert-row{
            display:flex; align-items:center; gap:12px; padding:12px 14px;
            background:rgba(251,90,106,0.08); border:1px solid rgba(251,90,106,0.3);
            border-radius:11px; margin-bottom:10px; font-size:13px;
        }
        .alert-row.warn{background:rgba(255,138,31,0.08); border-color:rgba(255,138,31,0.3);}
        .alert-row.info{background:rgba(96,165,250,0.08); border-color:rgba(96,165,250,0.3);}
        .alert-row.good{background:rgba(52,211,153,0.08); border-color:rgba(52,211,153,0.3);}
        .alert-row .ic{font-size:18px; flex-shrink:0;}
        .alert-row .txt{flex:1; color:var(--off); min-width:0;}
        .alert-row .txt strong{color:white; display:block; font-size:13.5px;}
        .alert-row .txt span{font-size:12px; color:var(--muted);}
        .alert-row button{
            background:transparent; border:1px solid var(--steel); color:var(--off);
            padding:6px 12px; border-radius:8px; font-size:12px; font-weight:600; transition:.16s; white-space:nowrap;
        }
        .alert-row button:hover{border-color:var(--orange); color:var(--orange);}

        /* ===== QC checks ===== */
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
        .qc-item .qc-txt span{display:block; font-size:11.5px; color:var(--muted);}

        /* ===== Timeline ===== */
        .timeline{position:relative; padding-left:22px;}
        .timeline:before{content:""; position:absolute; left:5px; top:4px; bottom:4px; width:2px; background:var(--steel);}
        .tl-item{position:relative; padding-bottom:16px;}
        .tl-item:last-child{padding-bottom:0;}
        .tl-item:before{content:""; position:absolute; left:-22px; top:4px; width:12px; height:12px; border-radius:50%; background:var(--steel); border:2px solid var(--steel-2);}
        .tl-item.done:before{background:var(--green); box-shadow:0 0 10px rgba(52,211,153,.6);}
        .tl-item.active:before{background:var(--orange); box-shadow:0 0 0 4px rgba(255,138,31,0.15), 0 0 14px var(--orange-glow);}
        .tl-item .tl-txt{font-size:13.5px; color:var(--off);}
        .tl-item .tl-time{font-size:11.5px; color:var(--muted); margin-top:2px;}

        /* ===== Modal ===== */
        .overlay{position:fixed; inset:0; background:rgba(8,9,13,0.72); backdrop-filter:blur(3px); opacity:0; pointer-events:none; transition:.2s; z-index:90;}
        .overlay.show{opacity:1; pointer-events:auto;}
        .modal{
            position:fixed; inset:0; display:flex; align-items:center; justify-content:center; z-index:100;
            opacity:0; pointer-events:none; transition:.2s; padding:20px;
        }
        .modal.show{opacity:1; pointer-events:auto;}
        .modal-box{
            background:linear-gradient(180deg,#262A35,#1E2129);
            border:1px solid var(--steel); border-radius:16px;
            padding:26px; width:560px; max-width:100%; max-height:90vh; overflow-y:auto;
            box-shadow:0 24px 60px rgba(0,0,0,.6);
        }
        .modal-box h3{font-size:24px; color:white; margin-bottom:6px;}
        .modal-box .sub{font-size:13px; color:var(--muted); margin-bottom:20px;}
        .modal-close{position:absolute; top:16px; right:18px; background:none; border:none; font-size:20px; color:var(--muted); transition:.15s;}
        .modal-close:hover{color:var(--red);}
        .modal-head{position:relative;}
        .detail-grid{display:grid; grid-template-columns:1fr 1fr; gap:14px; margin-bottom:18px;}
        .detail-grid .field{background:#181B22; border-radius:10px; padding:12px 14px; border:1px solid #232734;}
        .detail-grid .field label{font-size:11px; text-transform:uppercase; letter-spacing:0.05em; color:var(--muted); display:block; margin-bottom:4px;}
        .detail-grid .field strong{font-size:14.5px; color:white; font-weight:600;}

        /* ===== Form fields ===== */
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
        .radio-list{display:flex; flex-direction:column; gap:8px;}
        .radio-list label{
            display:flex; align-items:center; gap:10px; background:#181B22; border:1px solid var(--steel);
            padding:11px 13px; border-radius:9px; font-size:13.5px; cursor:pointer; transition:.16s;
            text-transform:none; letter-spacing:0; font-weight:400; color:var(--off); margin-bottom:0;
        }
        .radio-list label:hover{border-color:var(--orange);}
        .radio-list input{accent-color:var(--orange); width:16px; height:16px;}

        /* ===== Toast ===== */
        .toast{
            position:fixed; bottom:26px; left:50%; transform:translate(-50%,90px);
            background:var(--grad-hot); color:#1A1C22; padding:13px 24px; border-radius:11px;
            font-size:14px; font-weight:700; z-index:200; transition:.25s; opacity:0;
            box-shadow:0 12px 34px rgba(255,138,31,.4); max-width:90vw; text-align:center;
        }
        .toast.show{transform:translate(-50%,0); opacity:1;}

        /* ===== Progress ring ===== */
        .ring-row{display:flex; align-items:center; gap:18px; flex-wrap:wrap;}
        .ring{
            width:84px; height:84px; border-radius:50%;
            background:conic-gradient(var(--green) 0% 94%, var(--steel) 94% 100%);
            display:flex; align-items:center; justify-content:center; position:relative;
            filter:drop-shadow(0 0 12px rgba(52,211,153,.3));
        }
        .ring:before{content:""; position:absolute; inset:9px; border-radius:50%; background:var(--steel-2);}
        .ring span{position:relative; font-family:'Barlow Condensed'; font-weight:700; font-size:20px; color:white;}
        .ring.violet{background:conic-gradient(var(--violet) 0% 80%, var(--steel) 80% 100%); filter:drop-shadow(0 0 12px rgba(139,92,246,.35));}

        /* ===== Tabs content ===== */
        .tab-content{display:none;}
        .tab-content.active{display:block; animation:fadeUp .25s ease;}
        @keyframes fadeUp{from{opacity:0; transform:translateY(8px);} to{opacity:1; transform:none;}}

        /* ===== REVENUE ===== */
        .rev-cards{display:grid; grid-template-columns:repeat(4,1fr); gap:16px; margin-bottom:20px;}
        .rev-card{
            border-radius:14px; padding:18px 20px; border:1px solid var(--steel);
            background:linear-gradient(180deg,var(--steel-3),var(--steel-2)); position:relative; overflow:hidden;
        }
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

        .chart{
            display:flex; align-items:flex-end; gap:12px; height:190px; padding:16px 4px 0;
        }
        .chart-col{flex:1; display:flex; flex-direction:column; align-items:center; justify-content:flex-end; height:100%; gap:8px;}
        .chart-bar{
            width:100%; max-width:56px; border-radius:8px 8px 4px 4px;
            background:linear-gradient(180deg,var(--orange),rgba(255,138,31,.25));
            position:relative; transition:.3s; min-height:6px;
        }
        .chart-bar:hover{filter:brightness(1.15);}
        .chart-bar.hi{background:linear-gradient(180deg,var(--green),rgba(52,211,153,.22));}
        .chart-bar span{
            position:absolute; top:-20px; left:50%; transform:translateX(-50%);
            font-size:11px; font-weight:700; color:var(--off); white-space:nowrap;
        }
        .chart-lbl{font-size:11.5px; color:var(--muted); font-weight:600;}

        .table{width:100%; border-collapse:collapse; font-size:13.5px;}
        .table th{
            text-align:left; font-size:11px; text-transform:uppercase; letter-spacing:.06em;
            color:var(--muted); padding:8px 10px; border-bottom:1px solid var(--steel); font-weight:700;
        }
        .table td{padding:11px 10px; border-bottom:1px solid #232734;}
        .table tr:last-child td{border-bottom:none;}
        .table tr:hover td{background:rgba(255,138,31,.05);}
        .badge{font-size:11px; font-weight:700; padding:3px 9px; border-radius:999px; white-space:nowrap;}
        .badge.paid{background:rgba(52,211,153,.16); color:var(--green);}
        .badge.pending{background:rgba(255,138,31,.16); color:var(--orange);}
        .badge.debt{background:rgba(251,90,106,.16); color:var(--red);}
        .money{font-family:'Barlow Condensed'; font-weight:700; font-size:15px; color:white;}

        /* ===== SHOP ===== */
        .shop-grid{display:grid; grid-template-columns:repeat(auto-fill,minmax(250px,1fr)); gap:16px;}
        .shop-card{
            background:linear-gradient(180deg,var(--steel-3),var(--steel-2));
            border:1px solid var(--steel); border-radius:14px; overflow:hidden; transition:.2s;
        }
        .shop-card:hover{transform:translateY(-4px); border-color:var(--orange); box-shadow:0 14px 32px rgba(0,0,0,.45);}
        .shop-thumb{
            height:130px; display:flex; align-items:center; justify-content:center; font-size:48px;
            background:linear-gradient(135deg,rgba(255,138,31,.16),rgba(139,92,246,.16));
            border-bottom:1px solid var(--steel); position:relative;
        }
        .shop-thumb .off-tag{
            position:absolute; top:10px; left:10px; font-size:11px; font-weight:700; padding:3px 9px;
            border-radius:999px; background:rgba(154,160,176,.25); color:var(--off);
        }
        .shop-thumb .on-tag{
            position:absolute; top:10px; left:10px; font-size:11px; font-weight:700; padding:3px 9px;
            border-radius:999px; background:rgba(52,211,153,.2); color:var(--green);
        }
        .shop-body{padding:14px;}
        .shop-cat{font-size:11px; text-transform:uppercase; letter-spacing:.06em; color:var(--orange); font-weight:700;}
        .shop-body h4{font-size:16.5px; color:white; margin:5px 0 8px; font-weight:600;}
        .shop-price{font-family:'Barlow Condensed'; font-size:22px; font-weight:700; color:var(--green);}
        .shop-price span{font-size:12px; color:var(--muted); font-family:'Barlow'; font-weight:500;}
        .shop-meta{font-size:12px; color:var(--muted); margin:8px 0 12px;}
        .shop-actions{display:flex; gap:8px;}
        .shop-actions button{flex:1; padding:9px; border-radius:8px; font-weight:700; font-size:12.5px; border:none; transition:.16s;}
        .shop-actions .btn-ghost{flex:0 0 auto; padding:9px 12px;}

        /* ===== SUPPORT ===== */
        .support-grid{display:grid; grid-template-columns:repeat(auto-fit,minmax(230px,1fr)); gap:14px; margin-bottom:20px;}
        .support-card{
            background:linear-gradient(180deg,var(--steel-3),var(--steel-2));
            border:1px solid var(--steel); border-radius:14px; padding:20px; text-align:center; transition:.2s; cursor:pointer;
        }
        .support-card:hover{border-color:var(--orange); transform:translateY(-3px); box-shadow:0 12px 28px rgba(0,0,0,.4);}
        .support-card .ic{
            width:52px; height:52px; margin:0 auto 12px; border-radius:14px; font-size:24px;
            display:flex; align-items:center; justify-content:center;
            background:linear-gradient(135deg,rgba(255,138,31,.2),rgba(139,92,246,.2));
            border:1px solid var(--steel);
        }
        .support-card strong{display:block; color:white; font-size:15.5px; margin-bottom:5px;}
        .support-card span{font-size:12.5px; color:var(--muted); line-height:1.5; display:block;}

        /* ===== FAB & Chat ===== */
        .fab-wrap{position:fixed; right:24px; bottom:24px; display:flex; flex-direction:column; gap:12px; z-index:80;}
        .fab{
            width:54px; height:54px; border-radius:50%; border:none; font-size:22px;
            display:flex; align-items:center; justify-content:center; transition:.2s;
            box-shadow:0 10px 26px rgba(0,0,0,.45);
        }
        .fab:hover{transform:scale(1.09);}
        .fab-chat{background:var(--grad-hot); color:#1A1C22;}
        .fab-help{background:var(--grad-cool); color:white;}

        .chat-panel{
            position:fixed; right:24px; bottom:96px; width:340px; max-width:calc(100vw - 48px);
            background:linear-gradient(180deg,#262A35,#1E2129); border:1px solid var(--steel);
            border-radius:16px; overflow:hidden; z-index:85;
            box-shadow:0 24px 60px rgba(0,0,0,.6);
            opacity:0; pointer-events:none; transform:translateY(16px) scale(.97); transition:.22s;
        }
        .chat-panel.show{opacity:1; pointer-events:auto; transform:none;}
        .chat-head{
            padding:14px 16px; background:linear-gradient(135deg,rgba(255,138,31,.2),rgba(139,92,246,.2));
            border-bottom:1px solid var(--steel); display:flex; align-items:center; gap:11px;
        }
        .chat-head .av{
            width:36px; height:36px; border-radius:50%; background:var(--grad-hot); color:#1A1C22;
            display:flex; align-items:center; justify-content:center; font-weight:700; font-size:13px;
        }
        .chat-head strong{display:block; color:white; font-size:14px;}
        .chat-head span{font-size:11.5px; color:var(--green);}
        .chat-body{padding:14px; height:230px; overflow-y:auto; display:flex; flex-direction:column; gap:10px;}
        .msg{max-width:82%; padding:9px 13px; border-radius:12px; font-size:13px; line-height:1.45;}
        .msg.them{background:var(--steel-3); color:var(--off); border-bottom-left-radius:4px; align-self:flex-start;}
        .msg.me{background:var(--grad-hot); color:#1A1C22; font-weight:500; border-bottom-right-radius:4px; align-self:flex-end;}
        .chat-foot{display:flex; gap:8px; padding:12px; border-top:1px solid var(--steel);}
        .chat-foot input{
            flex:1; background:#181B22; border:1px solid var(--steel); border-radius:9px;
            padding:10px 12px; color:var(--off); font-family:inherit; font-size:13px; outline:none;
        }
        .chat-foot input:focus{border-color:var(--orange);}
        .chat-foot button{
            background:var(--grad-hot); border:none; color:#1A1C22; font-weight:700;
            padding:0 16px; border-radius:9px; font-size:13px;
        }

        /* ===== Responsive ===== */
        @media (max-width:1200px){
            .queue{grid-template-columns:repeat(2,1fr);}
            .stat-strip{grid-template-columns:repeat(2,1fr);}
            .stat{border-bottom:1px solid var(--steel);}
            .rev-cards{grid-template-columns:repeat(2,1fr);}
        }
        @media (max-width:760px){
            .queue{grid-template-columns:1fr;}
            .bottom-grid{grid-template-columns:1fr !important;}
            .stat-strip{grid-template-columns:1fr;}
            .detail-grid{grid-template-columns:1fr;}
            .rev-cards{grid-template-columns:1fr;}
            .content{padding:20px 16px 100px;}
            .topbar{padding:12px 16px;}
            .nav-tabs{padding:0 16px;}
        }
    </style>
</head>
<body>

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

<!-- Nav tabs -->
<div class="nav-tabs">
    <button class="active" onclick="switchTab(this,'board')">Bảng sản xuất</button>
    <button onclick="switchTab(this,'requests')">📋 Đơn yêu cầu <span id="reqTabCount" style="opacity:.75;">(2)</span></button>
    <button onclick="switchTab(this,'machines')">Máy móc</button>
    <button onclick="switchTab(this,'materials')">Vật tư</button>
    <button onclick="switchTab(this,'qc')">Kiểm tra chất lượng</button>
    <button onclick="switchTab(this,'schedule')">Lịch ca</button>
    <button onclick="switchTab(this,'revenue')">💰 Doanh thu</button>
    <button onclick="switchTab(this,'shop')">🛍️ Mẫu bán sẵn</button>
    <button onclick="switchTab(this,'support')">🎧 Hỗ trợ &amp; Đổi trả</button>
</div>

<div class="stat-strip">
    <div class="stat">
        <div class="cond">Việc chờ xử lý</div>
        <div class="val">18</div>
        <div class="sub">4 đơn ưu tiên cao</div>
    </div>
    <div class="stat">
        <div class="cond">Đang sản xuất</div>
        <div class="val orange">7</div>
        <div class="sub">3 máy in đang chạy</div>
    </div>
    <div class="stat">
        <div class="cond">Trễ hạn giao</div>
        <div class="val red">2</div>
        <div class="sub">Cần xử lý ngay</div>
    </div>
    <div class="stat">
        <div class="cond">Hoàn tất hôm nay</div>
        <div class="val green">24</div>
        <div class="sub">Mục tiêu ca: 30</div>
    </div>
    <div class="stat">
        <div class="cond">Doanh thu hôm nay</div>
        <div class="val violet">18.4tr</div>
        <div class="sub">▲ 12% so với hôm qua</div>
    </div>
</div>

<div class="content">

    <!-- ===== TAB: BOARD ===== -->
    <div class="tab-content active" id="tab-board">

        <div class="section-title">
            <h2>Hàng đợi sản xuất</h2>
            <div class="filter-tabs">
                <button class="active" onclick="pickFilter(this)">Tất cả</button>
                <button onclick="pickFilter(this)">Ưu tiên cao</button>
                <button onclick="pickFilter(this)">Áo thun</button>
                <button onclick="pickFilter(this)">Cốc sứ</button>
                <button onclick="pickFilter(this)">Poster</button>
            </div>
        </div>

        <div class="queue">
            <!-- Đơn hàng mới -->
            <div class="queue-col new-col">
                <div class="queue-col-head"><h3>Đơn hàng mới</h3><span class="count-chip">3</span></div>

                <div class="job-card" data-job="#PK-08242">
                    <div class="job-top"><span class="job-id">#PK-08242</span><span class="due new">Mới · 5 phút trước</span></div>
                    <div class="job-desc">Ốp lưng điện thoại in UV — 50 chiếc</div>
                    <div class="job-meta"><span>Thảo Nguyên Shop</span><span>Hẹn giao: 18/09</span></div>
                    <div class="job-actions">
                        <button class="btn-done" onclick="acceptOrder(this,'#PK-08242')">✓ Nhận đơn</button>
                        <button class="btn-ghost" onclick="openJobModal('#PK-08242','Ốp lưng điện thoại in UV — 50 chiếc','Thảo Nguyên Shop','Chưa gán máy','Đơn mới · chờ nhận','new')">Chi tiết</button>
                    </div>
                    <div class="job-actions" style="margin-top:8px;">
                        <button class="btn-danger" style="flex:1;" onclick="rejectOrder(this,'#PK-08242')">✕ Từ chối đơn</button>
                    </div>
                </div>

                <div class="job-card" data-job="#PK-08243">
                    <div class="job-top"><span class="job-id">#PK-08243</span><span class="due new">Mới · 20 phút trước</span></div>
                    <div class="job-desc">Bình giữ nhiệt in logo — 100 chiếc</div>
                    <div class="job-meta"><span>Xanh Coffee</span><span>Hẹn giao: 20/09</span></div>
                    <div class="job-actions">
                        <button class="btn-done" onclick="acceptOrder(this,'#PK-08243')">✓ Nhận đơn</button>
                        <button class="btn-ghost" onclick="openJobModal('#PK-08243','Bình giữ nhiệt in logo — 100 chiếc','Xanh Coffee','Chưa gán máy','Đơn mới · chờ nhận','new')">Chi tiết</button>
                    </div>
                    <div class="job-actions" style="margin-top:8px;">
                        <button class="btn-danger" style="flex:1;" onclick="rejectOrder(this,'#PK-08243')">✕ Từ chối đơn</button>
                    </div>
                </div>

                <div class="job-card" data-job="#PK-08244">
                    <div class="job-top"><span class="job-id">#PK-08244</span><span class="due new">Mới · 1 giờ trước</span></div>
                    <div class="job-desc">Sổ tay bìa da khắc laser — 30 quyển</div>
                    <div class="job-meta"><span>Gia Hân Boutique</span><span>Hẹn giao: 22/09</span></div>
                    <div class="job-actions">
                        <button class="btn-done" onclick="acceptOrder(this,'#PK-08244')">✓ Nhận đơn</button>
                        <button class="btn-ghost" onclick="openJobModal('#PK-08244','Sổ tay bìa da khắc laser — 30 quyển','Gia Hân Boutique','Chưa gán máy','Đơn mới · chờ nhận','new')">Chi tiết</button>
                    </div>
                    <div class="job-actions" style="margin-top:8px;">
                        <button class="btn-danger" style="flex:1;" onclick="rejectOrder(this,'#PK-08244')">✕ Từ chối đơn</button>
                    </div>
                </div>
            </div>

            <!-- Chờ xử lý -->
            <div class="queue-col urgent-col">
                <div class="queue-col-head"><h3>Chờ xử lý</h3><span class="count-chip">18</span></div>

                <div class="job-card urgent" data-job="#PK-08230">
                    <div class="job-top"><span class="job-id">#PK-08230</span><span class="due late">Trễ 6h</span></div>
                    <div class="job-desc">Áo thun DTG — 120 chiếc, 3 màu size</div>
                    <div class="job-meta"><span>Local Brand Co.</span><span>Máy: DTG-02</span></div>
                    <div class="job-actions">
                        <button class="btn-start" onclick="startJob(this,'#PK-08230')">Bắt đầu in</button>
                        <button class="btn-ghost" onclick="openJobModal('#PK-08230','Áo thun DTG — 120 chiếc, 3 màu size','Local Brand Co.','DTG-02','Trễ 6h','late')">Chi tiết</button>
                    </div>
                    <div class="job-actions" style="margin-top:8px;">
                        <button class="btn-edit" onclick="openEditJob('#PK-08230','Áo thun DTG — 120 chiếc, 3 màu size')">✎ Sửa đơn</button>
                        <button class="btn-danger" onclick="openCancelJob('#PK-08230','Áo thun DTG — 120 chiếc')">✕ Hủy đơn</button>
                    </div>
                </div>

                <div class="job-card" data-job="#PK-08235">
                    <div class="job-top"><span class="job-id">#PK-08235</span><span class="due soon">Còn 2h</span></div>
                    <div class="job-desc">Cốc sứ Sublimation — 200 chiếc</div>
                    <div class="job-meta"><span>Quà Tặng Việt</span><span>Máy: SUB-01</span></div>
                    <div class="job-actions">
                        <button class="btn-start" onclick="startJob(this,'#PK-08235')">Bắt đầu in</button>
                        <button class="btn-ghost" onclick="openJobModal('#PK-08235','Cốc sứ Sublimation — 200 chiếc','Quà Tặng Việt','SUB-01','Còn 2h','soon')">Chi tiết</button>
                    </div>
                    <div class="job-actions" style="margin-top:8px;">
                        <button class="btn-edit" onclick="openEditJob('#PK-08235','Cốc sứ Sublimation — 200 chiếc')">✎ Sửa đơn</button>
                        <button class="btn-danger" onclick="openCancelJob('#PK-08235','Cốc sứ Sublimation — 200 chiếc')">✕ Hủy đơn</button>
                    </div>
                </div>

                <div class="job-card" data-job="#PK-08237">
                    <div class="job-top"><span class="job-id">#PK-08237</span><span class="due ok">Còn 8h</span></div>
                    <div class="job-desc">Poster A2 UV — 40 tờ</div>
                    <div class="job-meta"><span>Minh Anh Store</span><span>Máy: UV-01</span></div>
                    <div class="job-actions">
                        <button class="btn-start" onclick="startJob(this,'#PK-08237')">Bắt đầu in</button>
                        <button class="btn-ghost" onclick="openJobModal('#PK-08237','Poster A2 UV — 40 tờ','Minh Anh Store','UV-01','Còn 8h','ok')">Chi tiết</button>
                    </div>
                    <div class="job-actions" style="margin-top:8px;">
                        <button class="btn-edit" onclick="openEditJob('#PK-08237','Poster A2 UV — 40 tờ')">✎ Sửa đơn</button>
                        <button class="btn-danger" onclick="openCancelJob('#PK-08237','Poster A2 UV — 40 tờ')">✕ Hủy đơn</button>
                    </div>
                </div>

                <div class="job-card" data-job="#PK-08240">
                    <div class="job-top"><span class="job-id">#PK-08240</span><span class="due ok">Còn 12h</span></div>
                    <div class="job-desc">Túi vải canvas — 60 chiếc</div>
                    <div class="job-meta"><span>The Coffee House X</span><span>Máy: SILK-01</span></div>
                    <div class="job-actions">
                        <button class="btn-start" onclick="startJob(this,'#PK-08240')">Bắt đầu in</button>
                        <button class="btn-ghost" onclick="openJobModal('#PK-08240','Túi vải canvas — 60 chiếc','The Coffee House X','SILK-01','Còn 12h','ok')">Chi tiết</button>
                    </div>
                    <div class="job-actions" style="margin-top:8px;">
                        <button class="btn-edit" onclick="openEditJob('#PK-08240','Túi vải canvas — 60 chiếc')">✎ Sửa đơn</button>
                        <button class="btn-danger" onclick="openCancelJob('#PK-08240','Túi vải canvas — 60 chiếc')">✕ Hủy đơn</button>
                    </div>
                </div>
            </div>

            <!-- Đang sản xuất -->
            <div class="queue-col">
                <div class="queue-col-head"><h3>Đang sản xuất</h3><span class="count-chip">7</span></div>

                <div class="job-card" data-job="#PK-08231">
                    <div class="job-top"><span class="job-id">#PK-08231</span><span class="due ok">Còn 3h</span></div>
                    <div class="job-desc">Áo thun Oversize — 24 chiếc</div>
                    <div class="job-meta"><span>Minh Anh Store</span><span>Máy: DTG-01</span></div>
                    <div class="machine-meter" style="width:100%;"><div style="width:62%; background:var(--green);"></div></div>
                    <div class="job-actions" style="margin-top:10px;">
                        <button class="btn-done" onclick="finishJob(this,'#PK-08231')">Đánh dấu xong</button>
                        <button class="btn-ghost" onclick="openJobModal('#PK-08231','Áo thun Oversize — 24 chiếc','Minh Anh Store','DTG-01','Còn 3h','ok')">Chi tiết</button>
                    </div>
                    <div class="job-actions" style="margin-top:8px;">
                        <button class="btn-edit" onclick="openEditJob('#PK-08231','Áo thun Oversize — 24 chiếc')">✎ Sửa giữa chừng</button>
                        <button class="btn-danger" onclick="openCancelJob('#PK-08231','Áo thun Oversize — 24 chiếc')">✕ Hủy</button>
                    </div>
                </div>

                <div class="job-card" data-job="#PK-08233">
                    <div class="job-top"><span class="job-id">#PK-08233</span><span class="due ok">Còn 5h</span></div>
                    <div class="job-desc">Túi vải canvas — 80 chiếc</div>
                    <div class="job-meta"><span>The Coffee House X</span><span>Máy: SILK-01</span></div>
                    <div class="machine-meter" style="width:100%;"><div style="width:38%; background:var(--green);"></div></div>
                    <div class="job-actions" style="margin-top:10px;">
                        <button class="btn-done" onclick="finishJob(this,'#PK-08233')">Đánh dấu xong</button>
                        <button class="btn-ghost" onclick="openJobModal('#PK-08233','Túi vải canvas — 80 chiếc','The Coffee House X','SILK-01','Còn 5h','ok')">Chi tiết</button>
                    </div>
                    <div class="job-actions" style="margin-top:8px;">
                        <button class="btn-edit" onclick="openEditJob('#PK-08233','Túi vải canvas — 80 chiếc')">✎ Sửa giữa chừng</button>
                        <button class="btn-danger" onclick="openCancelJob('#PK-08233','Túi vải canvas — 80 chiếc')">✕ Hủy</button>
                    </div>
                </div>

                <div class="job-card" data-job="#PK-08232">
                    <div class="job-top"><span class="job-id">#PK-08232</span><span class="due soon">Còn 1.5h</span></div>
                    <div class="job-desc">Cốc sứ Sublimation — 150 chiếc</div>
                    <div class="job-meta"><span>Quà Tặng Việt</span><span>Máy: SUB-01</span></div>
                    <div class="machine-meter" style="width:100%;"><div style="width:85%; background:var(--orange);"></div></div>
                    <div class="job-actions" style="margin-top:10px;">
                        <button class="btn-done" onclick="finishJob(this,'#PK-08232')">Đánh dấu xong</button>
                        <button class="btn-ghost" onclick="openJobModal('#PK-08232','Cốc sứ Sublimation — 150 chiếc','Quà Tặng Việt','SUB-01','Còn 1.5h','soon')">Chi tiết</button>
                    </div>
                    <div class="job-actions" style="margin-top:8px;">
                        <button class="btn-edit" onclick="openEditJob('#PK-08232','Cốc sứ Sublimation — 150 chiếc')">✎ Sửa giữa chừng</button>
                        <button class="btn-danger" onclick="openCancelJob('#PK-08232','Cốc sứ Sublimation — 150 chiếc')">✕ Hủy</button>
                    </div>
                </div>
            </div>

            <!-- Kiểm tra chất lượng -->
            <div class="queue-col">
                <div class="queue-col-head"><h3>Kiểm tra chất lượng</h3><span class="count-chip">3</span></div>

                <div class="job-card" data-job="#PK-08229">
                    <div class="job-top"><span class="job-id">#PK-08229</span><span class="due ok">Sẵn sàng</span></div>
                    <div class="job-desc">Cốc sứ — 30 chiếc</div>
                    <div class="job-meta"><span>Nguyễn Thảo</span><span>QC: Chờ duyệt</span></div>
                    <div class="job-actions">
                        <button class="btn-done" onclick="approveQC(this,'#PK-08229')">Duyệt &amp; đóng gói</button>
                        <button class="btn-ghost" onclick="openJobModal('#PK-08229','Cốc sứ — 30 chiếc','Nguyễn Thảo','SUB-01','Sẵn sàng','ok')">Chi tiết</button>
                    </div>
                    <div class="job-actions" style="margin-top:8px;">
                        <button class="btn-danger" onclick="openReturnModal('#PK-08229','Cốc sứ — 30 chiếc')">↩ Yêu cầu trả hàng</button>
                    </div>
                </div>

                <div class="job-card" data-job="#PK-08226">
                    <div class="job-top"><span class="job-id">#PK-08226</span><span class="due ok">Sẵn sàng</span></div>
                    <div class="job-desc">Namecard — 500 tấm</div>
                    <div class="job-meta"><span>Cần Thơ Store</span><span>QC: Chờ duyệt</span></div>
                    <div class="job-actions">
                        <button class="btn-done" onclick="approveQC(this,'#PK-08226')">Duyệt &amp; đóng gói</button>
                        <button class="btn-ghost" onclick="openJobModal('#PK-08226','Namecard — 500 tấm','Cần Thơ Store','UV-01','Sẵn sàng','ok')">Chi tiết</button>
                    </div>
                    <div class="job-actions" style="margin-top:8px;">
                        <button class="btn-danger" onclick="openReturnModal('#PK-08226','Namecard — 500 tấm')">↩ Yêu cầu trả hàng</button>
                    </div>
                </div>
            </div>

            <!-- Hoàn tất hôm nay -->
            <div class="queue-col">
                <div class="queue-col-head"><h3>Hoàn tất hôm nay</h3><span class="count-chip">24</span></div>

                <div class="job-card done-card" data-job="#PK-08238">
                    <div class="job-top"><span class="job-id">#PK-08238</span><span class="due new">Chờ bàn giao</span></div>
                    <div class="job-desc">Cốc sứ 350ml — 60 chiếc</div>
                    <div class="job-meta"><span>Cần Thơ Store</span><span>SUB-01 · 11:20</span></div>
                    <div class="job-actions" style="margin-top:8px;">
                        <button class="btn-start" onclick="openHandoverModal('#PK-08238','Cốc sứ 350ml — 60 chiếc')">📦 Bàn giao đơn</button>
                        <button class="btn-ghost" onclick="openJobModal('#PK-08238','Cốc sứ 350ml — 60 chiếc','Cần Thơ Store','SUB-01','Chờ bàn giao','new')">Chi tiết</button>
                    </div>
                </div>

                <div class="job-card done-card">
                    <div class="job-top"><span class="job-id">#PK-08225</span><span class="due ok">Đã giao</span></div>
                    <div class="job-desc">Poster A2 — 100 tờ</div>
                    <div class="job-meta"><span>Minh Anh Store</span><span>UV-01 · 10:15</span></div>
                    <div class="job-actions" style="margin-top:8px;">
                        <button class="btn-ghost" onclick="openReturnModal('#PK-08225','Poster A2 — 100 tờ')">↩ Đổi/Trả</button>
                        <button class="btn-ghost" onclick="openJobModal('#PK-08225','Poster A2 — 100 tờ','Minh Anh Store','UV-01','Đã giao','ok')">Chi tiết</button>
                    </div>
                </div>

                <div class="job-card done-card">
                    <div class="job-top"><span class="job-id">#PK-08224</span><span class="due ok">Đã giao</span></div>
                    <div class="job-desc">Áo thun DTG — 36 chiếc</div>
                    <div class="job-meta"><span>Local Brand Co.</span><span>DTG-01 · 09:40</span></div>
                    <div class="job-actions" style="margin-top:8px;">
                        <button class="btn-ghost" onclick="openReturnModal('#PK-08224','Áo thun DTG — 36 chiếc')">↩ Đổi/Trả</button>
                        <button class="btn-ghost" onclick="openJobModal('#PK-08224','Áo thun DTG — 36 chiếc','Local Brand Co.','DTG-01','Đã giao','ok')">Chi tiết</button>
                    </div>
                </div>

                <div class="job-card done-card">
                    <div class="job-top"><span class="job-id">#PK-08223</span><span class="due ok">Đã giao</span></div>
                    <div class="job-desc">Cốc sứ — 80 chiếc</div>
                    <div class="job-meta"><span>Quà Tặng Việt</span><span>SUB-01 · 08:55</span></div>
                    <div class="job-actions" style="margin-top:8px;">
                        <button class="btn-ghost" onclick="openReturnModal('#PK-08223','Cốc sứ — 80 chiếc')">↩ Đổi/Trả</button>
                        <button class="btn-ghost" onclick="openJobModal('#PK-08223','Cốc sứ — 80 chiếc','Quà Tặng Việt','SUB-01','Đã giao','ok')">Chi tiết</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Alerts + Timeline -->
        <div class="bottom-grid">
            <div class="panel">
                <div class="panel-head"><h3>Cảnh báo vận hành</h3><a href="#" onclick="toast('Đã đánh dấu tất cả đã đọc');return false;">Đánh dấu đã đọc</a></div>

                <div class="alert-row">
                    <span class="ic">⚠️</span>
                    <div class="txt"><strong>#PK-08230 trễ hạn 6 giờ</strong><span>Áo thun DTG · 120 chiếc · Local Brand Co.</span></div>
                    <button onclick="openEditJob('#PK-08230','Áo thun DTG — 120 chiếc')">Xử lý</button>
                </div>

                <div class="alert-row warn">
                    <span class="ic">🖨️</span>
                    <div class="txt"><strong>UV-01 đang bảo trì</strong><span>Dự kiến hoàn tất 13:00 · 2 đơn bị ảnh hưởng</span></div>
                    <button onclick="toast('Đã mở lịch bảo trì')">Xem</button>
                </div>

                <div class="alert-row warn">
                    <span class="ic">📦</span>
                    <div class="txt"><strong>Phôi áo Cotton (L) sắp hết</strong><span>Còn 38% · Đề xuất đặt thêm 500 chiếc</span></div>
                    <button onclick="toast('Đã gửi yêu cầu nhập vật tư')">Đặt hàng</button>
                </div>

                <div class="alert-row info">
                    <span class="ic">↩️</span>
                    <div class="txt"><strong>1 yêu cầu đổi/trả mới</strong><span>#PK-08220 · Sai màu · Chờ xử lý</span></div>
                    <button onclick="switchTabTo('support')">Xem ngay</button>
                </div>
            </div>

            <div class="panel">
                <h3>Hoạt động gần đây</h3>
                <div class="timeline">
                    <div class="tl-item done">
                        <div class="tl-txt">Hoàn tất in <strong>#PK-08225</strong> · Poster A2, 100 tờ</div>
                        <div class="tl-time">10:15 · UV-01</div>
                    </div>
                    <div class="tl-item done">
                        <div class="tl-txt">Bắt đầu in <strong>#PK-08232</strong> · Cốc sứ, 150 chiếc</div>
                        <div class="tl-time">10:02 · SUB-01</div>
                    </div>
                    <div class="tl-item active">
                        <div class="tl-txt">Đang in <strong>#PK-08231</strong> · Áo thun, 24 chiếc</div>
                        <div class="tl-time">09:40 · DTG-01 · 62%</div>
                    </div>
                    <div class="tl-item done">
                        <div class="tl-txt">QC duyệt <strong>#PK-08224</strong> · 36 áo thun</div>
                        <div class="tl-time">09:35 · Trần Hòa</div>
                    </div>
                    <div class="tl-item">
                        <div class="tl-txt">Nhận đơn mới <strong>#PK-08240</strong> · Túi vải, 60 chiếc</div>
                        <div class="tl-time">09:10 · Hệ thống</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== TAB: ORDER REQUESTS (edit/cancel giữa quy trình sản xuất) ===== -->
    <div class="tab-content" id="tab-requests">
        <div class="section-title">
            <h2>Đơn yêu cầu chỉnh sửa / hủy</h2>
            <div class="filter-tabs">
                <button class="active" onclick="pickFilter(this)">Chờ duyệt (2)</button>
                <button onclick="pickFilter(this)">Đã xử lý</button>
            </div>
        </div>

        <div class="bottom-grid" style="grid-template-columns:1.4fr 1fr;">
            <div class="panel">
                <h3>Yêu cầu đang chờ duyệt</h3>

                <div class="job-card" data-req="#PK-08231" style="margin-bottom:14px;">
                    <div class="job-top"><span class="job-id">#PK-08231</span><span class="due new">Yêu cầu chỉnh sửa</span></div>
                    <div class="job-desc">Áo thun Oversize — 24 chiếc · Minh Anh Store</div>
                    <div class="job-meta"><span>Nội dung: Tăng từ 24 lên 30 áo, thêm size XL</span><span>Gửi lúc: 10:12</span></div>
                    <div class="job-actions">
                        <button class="btn-done" onclick="approveOrderRequest(this,'#PK-08231','edit')">✓ Duyệt chỉnh sửa</button>
                        <button class="btn-danger" onclick="rejectOrderRequest(this,'#PK-08231','edit')">✕ Từ chối</button>
                        <button class="btn-ghost" onclick="openModal('contactModal')">Liên hệ khách</button>
                    </div>
                </div>

                <div class="job-card" data-req="#PK-08233">
                    <div class="job-top"><span class="job-id">#PK-08233</span><span class="due late">Yêu cầu hủy đơn</span></div>
                    <div class="job-desc">Túi vải canvas — 80 chiếc · The Coffee House X</div>
                    <div class="job-meta"><span>Lý do: Tìm được nhà cung cấp khác</span><span>Phí hủy: 30% (đã sản xuất)</span></div>
                    <div class="job-actions">
                        <button class="btn-done" onclick="approveOrderRequest(this,'#PK-08233','cancel')">✓ Duyệt hủy đơn</button>
                        <button class="btn-danger" onclick="rejectOrderRequest(this,'#PK-08233','cancel')">✕ Từ chối</button>
                        <button class="btn-ghost" onclick="openModal('contactModal')">Liên hệ khách</button>
                    </div>
                </div>
            </div>

            <div style="display:flex; flex-direction:column; gap:18px;">
                <div class="panel">
                    <h3>Thống kê yêu cầu hôm nay</h3>
                    <div class="detail-grid" style="grid-template-columns:1fr 1fr;">
                        <div class="field"><label>Tổng yêu cầu</label><strong>2</strong></div>
                        <div class="field"><label>Đã duyệt</label><strong style="color:var(--green);">0</strong></div>
                        <div class="field"><label>Đã từ chối</label><strong style="color:var(--red);">0</strong></div>
                        <div class="field"><label>Chờ xử lý</label><strong style="color:var(--violet);">2</strong></div>
                    </div>
                </div>

                <div class="panel">
                    <h3>Lưu ý duyệt yêu cầu</h3>
                    <div class="machine-row">
                        <div class="machine-icon">✎</div>
                        <div class="machine-info"><strong>Yêu cầu chỉnh sửa</strong><span>Kiểm tra máy còn kịp đổi vật tư/thiết kế trước khi duyệt</span></div>
                    </div>
                    <div class="machine-row">
                        <div class="machine-icon">✕</div>
                        <div class="machine-info"><strong>Yêu cầu hủy đơn</strong><span>Nếu đã sản xuất, khách chịu phí hủy 30% theo chính sách</span></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== TAB: MACHINES ===== -->
    <div class="tab-content" id="tab-machines">
        <div class="section-title">
            <h2>Tình trạng máy móc</h2>
            <div class="filter-tabs">
                <button class="active" onclick="pickFilter(this)">Tất cả (6)</button>
                <button onclick="pickFilter(this)">Đang chạy</button>
                <button onclick="pickFilter(this)">Chờ việc</button>
                <button onclick="pickFilter(this)">Bảo trì</button>
            </div>
        </div>

        <div class="bottom-grid" style="grid-template-columns:1.6fr 1fr;">
            <div class="panel">
                <h3>Danh sách thiết bị</h3>

                <div class="machine-row">
                    <div class="machine-icon">🖨️</div>
                    <div class="machine-info">
                        <strong>DTG-01 · In áo thun kỹ thuật số</strong>
                        <span>Đang in #PK-08231 · 62% · Tốc độ 28 áo/giờ</span>
                        <div class="machine-meter"><div style="width:62%; background:var(--green);"></div></div>
                    </div>
                    <span class="status-tag run">Đang chạy</span>
                </div>

                <div class="machine-row">
                    <div class="machine-icon">🖨️</div>
                    <div class="machine-info">
                        <strong>DTG-02 · In áo thun kỹ thuật số</strong>
                        <span>Chờ việc · Đầu in sạch · Mực đen 82%</span>
                        <div class="machine-meter"><div style="width:0%; background:var(--muted);"></div></div>
                    </div>
                    <span class="status-tag idle">Chờ việc</span>
                </div>

                <div class="machine-row">
                    <div class="machine-icon">☕</div>
                    <div class="machine-info">
                        <strong>SUB-01 · Ép nhiệt Sublimation</strong>
                        <span>Đang in #PK-08232 · 85% · Nhiệt độ 190°C</span>
                        <div class="machine-meter"><div style="width:85%; background:var(--orange);"></div></div>
                    </div>
                    <span class="status-tag run">Đang chạy</span>
                </div>

                <div class="machine-row">
                    <div class="machine-icon">🎨</div>
                    <div class="machine-info">
                        <strong>UV-01 · In UV khổ lớn</strong>
                        <span>Bảo trì đầu phun · Dự kiến xong 13:00</span>
                        <div class="machine-meter"><div style="width:100%; background:var(--red);"></div></div>
                    </div>
                    <span class="status-tag maint">Bảo trì</span>
                </div>

                <div class="machine-row">
                    <div class="machine-icon">🧵</div>
                    <div class="machine-info">
                        <strong>SILK-01 · In lụa thủ công</strong>
                        <span>Đang in #PK-08233 · 38% · 2 khung lụa</span>
                        <div class="machine-meter"><div style="width:38%; background:var(--green);"></div></div>
                    </div>
                    <span class="status-tag run">Đang chạy</span>
                </div>

                <div class="machine-row">
                    <div class="machine-icon">🔥</div>
                    <div class="machine-info">
                        <strong>HEAT-01 · Máy ép nhiệt phẳng</strong>
                        <span>Chờ việc · Nhiệt độ ổn định 180°C</span>
                        <div class="machine-meter"><div style="width:0%; background:var(--muted);"></div></div>
                    </div>
                    <span class="status-tag idle">Chờ việc</span>
                </div>
            </div>

            <div style="display:flex; flex-direction:column; gap:18px;">
                <div class="panel">
                    <h3>Hiệu suất tuần</h3>
                    <div class="ring-row">
                        <div class="ring"><span>94%</span></div>
                        <div>
                            <div style="font-size:13.5px; color:var(--off);">Tỉ lệ đúng hạn</div>
                            <div style="font-size:12px; color:var(--muted); margin-top:4px;">142/151 đơn đúng hạn</div>
                            <div style="font-size:12px; color:var(--green); margin-top:8px;">▲ 2% so với tuần trước</div>
                        </div>
                    </div>
                </div>

                <div class="panel">
                    <h3>Bảo trì sắp tới</h3>
                    <div class="machine-row">
                        <div class="machine-icon">🎨</div>
                        <div class="machine-info"><strong>UV-01</strong><span>Hôm nay 13:00 · Vệ sinh đầu phun</span></div>
                    </div>
                    <div class="machine-row">
                        <div class="machine-icon">🖨️</div>
                        <div class="machine-info"><strong>DTG-01</strong><span>Thứ Năm 18/09 · Thay dây curoa</span></div>
                    </div>
                    <div class="machine-row">
                        <div class="machine-icon">☕</div>
                        <div class="machine-info"><strong>SUB-01</strong><span>Thứ Sáu 19/09 · Kiểm tra nhiệt</span></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== TAB: MATERIALS ===== -->
    <div class="tab-content" id="tab-materials">
        <div class="section-title">
            <h2>Vật tư tồn kho</h2>
            <button class="btn-start" style="padding:10px 18px; border-radius:8px; font-weight:700; border:none;" onclick="toast('Đã mở phiếu nhập vật tư')">+ Nhập vật tư</button>
        </div>

        <div class="bottom-grid" style="grid-template-columns:1.4fr 1fr;">
            <div class="panel">
                <h3>Mức tồn kho hiện tại</h3>

                <div class="material-row">
                    <div class="name">Mực DTG — Đen<span>Còn 82 lọ · Ngưỡng tối thiểu 20 lọ</span></div>
                    <div class="stock-bar"><div class="stock-fill" style="width:82%; background:var(--green);"></div></div>
                    <div class="stock-pct" style="color:var(--green);">82%</div>
                </div>

                <div class="material-row">
                    <div class="name">Phôi áo Cotton (L)<span>Còn 190/500 chiếc · Cần nhập thêm</span></div>
                    <div class="stock-bar"><div class="stock-fill" style="width:38%; background:var(--orange);"></div></div>
                    <div class="stock-pct" style="color:var(--orange);">38%</div>
                </div>

                <div class="material-row">
                    <div class="name">Cốc sứ trắng 350ml<span>Còn 320/500 chiếc</span></div>
                    <div class="stock-bar"><div class="stock-fill" style="width:64%; background:var(--green);"></div></div>
                    <div class="stock-pct" style="color:var(--green);">64%</div>
                </div>

                <div class="material-row">
                    <div class="name">Giấy mỹ thuật A2<span>Còn 60/500 tờ · Nguy cấp</span></div>
                    <div class="stock-bar"><div class="stock-fill" style="width:12%; background:var(--red);"></div></div>
                    <div class="stock-pct" style="color:var(--red);">12%</div>
                </div>

                <div class="material-row">
                    <div class="name">Mực UV — 4 màu<span>Còn 45/60 lọ</span></div>
                    <div class="stock-bar"><div class="stock-fill" style="width:75%; background:var(--green);"></div></div>
                    <div class="stock-pct" style="color:var(--green);">75%</div>
                </div>

                <div class="material-row">
                    <div class="name">Vải canvas cuộn<span>Còn 8/20 cuộn</span></div>
                    <div class="stock-bar"><div class="stock-fill" style="width:40%; background:var(--orange);"></div></div>
                    <div class="stock-pct" style="color:var(--orange);">40%</div>
                </div>

                <div class="material-row">
                    <div class="name">Giấy namecard 300gsm<span>Còn 1.200/2.000 tấm</span></div>
                    <div class="stock-bar"><div class="stock-fill" style="width:60%; background:var(--green);"></div></div>
                    <div class="stock-pct" style="color:var(--green);">60%</div>
                </div>
            </div>

            <div style="display:flex; flex-direction:column; gap:18px;">
                <div class="panel">
                    <h3>Đề xuất nhập hàng</h3>
                    <div class="alert-row warn">
                        <span class="ic">📦</span>
                        <div class="txt"><strong>Giấy mỹ thuật A2</strong><span>Còn 60 tờ — đủ dùng ~1 ngày</span></div>
                        <button onclick="toast('Đã tạo đơn nhập 500 tờ giấy A2')">Đặt 500</button>
                    </div>
                    <div class="alert-row warn">
                        <span class="ic">👕</span>
                        <div class="txt"><strong>Phôi áo Cotton (L)</strong><span>Còn 190 chiếc — đủ dùng ~2 ngày</span></div>
                        <button onclick="toast('Đã tạo đơn nhập 500 phôi áo')">Đặt 500</button>
                    </div>
                    <div class="alert-row">
                        <span class="ic">🎨</span>
                        <div class="txt"><strong>Mực UV — Magenta</strong><span>Còn 9 lọ — dưới ngưỡng tối thiểu</span></div>
                        <button onclick="toast('Đã tạo đơn nhập 20 lọ mực UV')">Đặt 20</button>
                    </div>
                </div>

                <div class="panel">
                    <h3>Lịch sử nhập kho</h3>
                    <div class="timeline">
                        <div class="tl-item done">
                            <div class="tl-txt">Nhập <strong>200 lọ mực DTG Đen</strong></div>
                            <div class="tl-time">Hôm nay 08:30 · NCC: InkPro VN</div>
                        </div>
                        <div class="tl-item done">
                            <div class="tl-txt">Nhập <strong>1.000 phôi áo Cotton</strong></div>
                            <div class="tl-time">13/09 · NCC: Vải Sài Gòn</div>
                        </div>
                        <div class="tl-item done">
                            <div class="tl-txt">Nhập <strong>500 cốc sứ trắng</strong></div>
                            <div class="tl-time">11/09 · NCC: Ceramic Bình Dương</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== TAB: QC ===== -->
    <div class="tab-content" id="tab-qc">
        <div class="section-title">
            <h2>Kiểm tra chất lượng</h2>
            <div class="filter-tabs">
                <button class="active" onclick="pickFilter(this)">Chờ duyệt (3)</button>
                <button onclick="pickFilter(this)">Đã duyệt hôm nay</button>
                <button onclick="pickFilter(this)">Bị từ chối</button>
            </div>
        </div>

        <div class="bottom-grid" style="grid-template-columns:1.3fr 1fr;">
            <div class="panel">
                <h3>Đơn chờ kiểm tra</h3>

                <div class="job-card" style="margin-bottom:14px;">
                    <div class="job-top"><span class="job-id">#PK-08229</span><span class="due ok">Sẵn sàng</span></div>
                    <div class="job-desc">Cốc sứ — 30 chiếc · Khách: Nguyễn Thảo</div>
                    <div class="qc-item">
                        <div class="qc-check checked" onclick="toggleQC(this)">✓</div>
                        <div class="qc-txt">Màu in đúng file thiết kế<span>Kiểm tra 10/30 mẫu ngẫu nhiên</span></div>
                    </div>
                    <div class="qc-item">
                        <div class="qc-check checked" onclick="toggleQC(this)">✓</div>
                        <div class="qc-txt">Không bong tróc, nứt men<span>Kiểm tra nhiệt độ ép</span></div>
                    </div>
                    <div class="qc-item">
                        <div class="qc-check" onclick="toggleQC(this)">✓</div>
                        <div class="qc-txt">Đóng gói đúng quy cách<span>Hộp carton + xốp chèn</span></div>
                    </div>
                    <div class="job-actions" style="margin-top:12px;">
                        <button class="btn-done" onclick="toast('Đã duyệt #PK-08229 — chuyển đóng gói')">Duyệt</button>
                        <button class="btn-danger" onclick="openReturnModal('#PK-08229','Cốc sứ — 30 chiếc')">Từ chối / Trả hàng</button>
                    </div>
                </div>

                <div class="job-card" style="margin-bottom:14px;">
                    <div class="job-top"><span class="job-id">#PK-08226</span><span class="due ok">Sẵn sàng</span></div>
                    <div class="job-desc">Namecard — 500 tấm · Khách: Cần Thơ Store</div>
                    <div class="qc-item">
                        <div class="qc-check checked" onclick="toggleQC(this)">✓</div>
                        <div class="qc-txt">Màu sắc đồng đều<span>Đối chiếu với bản mẫu đã duyệt</span></div>
                    </div>
                    <div class="qc-item">
                        <div class="qc-check checked" onclick="toggleQC(this)">✓</div>
                        <div class="qc-txt">Cắt xén chính xác<span>Sai số cho phép ±0.5mm</span></div>
                    </div>
                    <div class="job-actions" style="margin-top:12px;">
                        <button class="btn-done" onclick="toast('Đã duyệt #PK-08226 — chuyển đóng gói')">Duyệt</button>
                        <button class="btn-danger" onclick="openReturnModal('#PK-08226','Namecard — 500 tấm')">Từ chối / Trả hàng</button>
                    </div>
                </div>

                <div class="job-card">
                    <div class="job-top"><span class="job-id">#PK-08238</span><span class="due soon">Chờ 1h</span></div>
                    <div class="job-desc">Áo thun DTG — 36 chiếc · Khách: Local Brand Co.</div>
                    <div class="qc-item">
                        <div class="qc-check" onclick="toggleQC(this)">✓</div>
                        <div class="qc-txt">Màu in đúng file thiết kế<span>Chưa kiểm tra</span></div>
                    </div>
                    <div class="qc-item">
                        <div class="qc-check" onclick="toggleQC(this)">✓</div>
                        <div class="qc-txt">Đường may, form áo đạt<span>Chưa kiểm tra</span></div>
                    </div>
                    <div class="job-actions" style="margin-top:12px;">
                        <button class="btn-done" onclick="toast('Đã duyệt #PK-08238 — chuyển đóng gói')">Duyệt</button>
                        <button class="btn-danger" onclick="openReturnModal('#PK-08238','Áo thun DTG — 36 chiếc')">Từ chối / Trả hàng</button>
                    </div>
                </div>
            </div>

            <div style="display:flex; flex-direction:column; gap:18px;">
                <div class="panel">
                    <h3>Thống kê QC hôm nay</h3>
                    <div class="detail-grid" style="grid-template-columns:1fr 1fr;">
                        <div class="field"><label>Đã kiểm tra</label><strong>21 đơn</strong></div>
                        <div class="field"><label>Đạt</label><strong style="color:var(--green);">19 đơn</strong></div>
                        <div class="field"><label>Từ chối</label><strong style="color:var(--red);">2 đơn</strong></div>
                        <div class="field"><label>Tỉ lệ đạt</label><strong>90.5%</strong></div>
                    </div>
                </div>

                <div class="panel">
                    <h3>Lý do từ chối gần đây</h3>
                    <div class="alert-row">
                        <span class="ic">🎨</span>
                        <div class="txt"><strong>#PK-08220 · Sai màu</strong><span>Màu đỏ nhạt hơn file 15%</span></div>
                    </div>
                    <div class="alert-row warn">
                        <span class="ic">📐</span>
                        <div class="txt"><strong>#PK-08214 · Lệch vị trí in</strong><span>Logo lệch 8mm so với mẫu</span></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== TAB: SCHEDULE ===== -->
    <div class="tab-content" id="tab-schedule">
        <div class="section-title">
            <h2>Lịch ca &amp; phân công</h2>
            <div class="filter-tabs">
                <button class="active" onclick="pickFilter(this)">Hôm nay</button>
                <button onclick="pickFilter(this)">Tuần này</button>
            </div>
        </div>

        <div class="bottom-grid" style="grid-template-columns:1.4fr 1fr;">
            <div class="panel">
                <h3>Ca làm việc hôm nay</h3>

                <div class="machine-row">
                    <div class="machine-icon">🌅</div>
                    <div class="machine-info">
                        <strong>Ca sáng · 06:00 – 14:00</strong>
                        <span>12 công nhân · Đang diễn ra · Còn 3h18p</span>
                    </div>
                    <span class="status-tag run">Đang chạy</span>
                </div>

                <div class="machine-row">
                    <div class="machine-icon">🌇</div>
                    <div class="machine-info">
                        <strong>Ca chiều · 14:00 – 22:00</strong>
                        <span>10 công nhân · Bắt đầu sau 3h18p</span>
                    </div>
                    <span class="status-tag idle">Sắp tới</span>
                </div>

                <div class="machine-row">
                    <div class="machine-icon">🌙</div>
                    <div class="machine-info">
                        <strong>Ca đêm · 22:00 – 06:00</strong>
                        <span>6 công nhân · Chỉ chạy máy tự động</span>
                    </div>
                    <span class="status-tag idle">Sắp tới</span>
                </div>

                <h3 style="margin-top:22px;">Phân công theo máy</h3>
                <div class="machine-row">
                    <div class="machine-icon">🖨️</div>
                    <div class="machine-info"><strong>DTG-01</strong><span>Nguyễn Văn Hùng · Ca sáng</span></div>
                    <span class="status-tag run">Đang chạy</span>
                </div>
                <div class="machine-row">
                    <div class="machine-icon">☕</div>
                    <div class="machine-info"><strong>SUB-01</strong><span>Trần Thị Mai · Ca sáng</span></div>
                    <span class="status-tag run">Đang chạy</span>
                </div>
                <div class="machine-row">
                    <div class="machine-icon">🧵</div>
                    <div class="machine-info"><strong>SILK-01</strong><span>Lê Minh Tuấn · Ca sáng</span></div>
                    <span class="status-tag run">Đang chạy</span>
                </div>
                <div class="machine-row">
                    <div class="machine-icon">🎨</div>
                    <div class="machine-info"><strong>UV-01</strong><span>Phạm Quốc Bảo · Bảo trì</span></div>
                    <span class="status-tag maint">Bảo trì</span>
                </div>
            </div>

            <div style="display:flex; flex-direction:column; gap:18px;">
                <div class="panel">
                    <h3>Mục tiêu ca sáng</h3>
                    <div class="ring-row">
                        <div class="ring violet"><span>80%</span></div>
                        <div>
                            <div style="font-size:13.5px; color:var(--off);">24/30 đơn hoàn tất</div>
                            <div style="font-size:12px; color:var(--muted); margin-top:4px;">Còn 3h18p để hoàn thành 6 đơn</div>
                            <div style="font-size:12px; color:var(--orange); margin-top:8px;">Cần tăng tốc thêm 15%</div>
                        </div>
                    </div>
                </div>

                <div class="panel">
                    <h3>Nhân sự ca sáng</h3>
                    <div class="machine-row">
                        <div class="op-avatar" style="width:32px;height:32px;font-size:12px;">ĐL</div>
                        <div class="machine-info"><strong>Đặng Long</strong><span>Quản lý ca · 06:00–14:00</span></div>
                    </div>
                    <div class="machine-row">
                        <div class="op-avatar" style="width:32px;height:32px;font-size:12px;background:var(--blue);color:#0F1A15;">NH</div>
                        <div class="machine-info"><strong>Nguyễn Văn Hùng</strong><span>Vận hành DTG-01</span></div>
                    </div>
                    <div class="machine-row">
                        <div class="op-avatar" style="width:32px;height:32px;font-size:12px;background:var(--green);color:#0F1A15;">TM</div>
                        <div class="machine-info"><strong>Trần Thị Mai</strong><span>Vận hành SUB-01</span></div>
                    </div>
                    <div class="machine-row">
                        <div class="op-avatar" style="width:32px;height:32px;font-size:12px;background:var(--red);color:#fff;">MT</div>
                        <div class="machine-info"><strong>Lê Minh Tuấn</strong><span>Vận hành SILK-01</span></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== TAB: REVENUE ===== -->
    <div class="tab-content" id="tab-revenue">
        <div class="section-title">
            <h2>Quản lý doanh thu xưởng</h2>
            <div class="filter-tabs">
                <button class="active" onclick="pickFilter(this);setRevenue('day')">Hôm nay</button>
                <button onclick="pickFilter(this);setRevenue('week')">Tuần này</button>
                <button onclick="pickFilter(this);setRevenue('month')">Tháng này</button>
            </div>
        </div>

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
                <div class="panel-head"><h3>Doanh thu 7 ngày gần nhất</h3><a href="#" onclick="toast('Đã xuất báo cáo Excel');return false;">Xuất báo cáo</a></div>
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

            <div style="display:flex; flex-direction:column; gap:18px;">
                <div class="panel">
                    <h3>Top sản phẩm theo doanh thu</h3>
                    <div class="material-row">
                        <div class="name">Áo thun DTG<span>156 sản phẩm</span></div>
                        <div class="stock-bar" style="width:90px;"><div class="stock-fill" style="width:100%; background:var(--grad-hot);"></div></div>
                        <div class="money" style="width:78px; text-align:right;">6.4tr</div>
                    </div>
                    <div class="material-row">
                        <div class="name">Cốc sứ Sublimation<span>410 sản phẩm</span></div>
                        <div class="stock-bar" style="width:90px;"><div class="stock-fill" style="width:74%; background:var(--grad-cool);"></div></div>
                        <div class="money" style="width:78px; text-align:right;">4.9tr</div>
                    </div>
                    <div class="material-row">
                        <div class="name">Poster A2 UV<span>180 tờ</span></div>
                        <div class="stock-bar" style="width:90px;"><div class="stock-fill" style="width:48%; background:var(--grad-money);"></div></div>
                        <div class="money" style="width:78px; text-align:right;">3.1tr</div>
                    </div>
                    <div class="material-row">
                        <div class="name">Túi vải canvas<span>140 chiếc</span></div>
                        <div class="stock-bar" style="width:90px;"><div class="stock-fill" style="width:32%; background:linear-gradient(135deg,#FB5A6A,#F472B6);"></div></div>
                        <div class="money" style="width:78px; text-align:right;">2.2tr</div>
                    </div>
                </div>

                <div class="panel">
                    <h3>Ghi nhận thanh toán</h3>
                    <div class="form-field" style="margin-bottom:10px;">
                        <label>Mã đơn hàng</label>
                        <input id="payOrder" placeholder="VD: #PK-08231">
                    </div>
                    <div class="form-field" style="margin-bottom:12px;">
                        <label>Số tiền thu (₫)</label>
                        <input id="payAmount" placeholder="VD: 1500000">
                    </div>
                    <button class="btn-done" style="width:100%; padding:12px; border-radius:9px; font-weight:700; border:none;" onclick="recordPayment()">+ Ghi nhận thanh toán</button>
                </div>
            </div>
        </div>

        <div class="panel" style="margin-top:18px;">
            <h3>Giao dịch gần đây</h3>
            <div style="overflow-x:auto;">
                <table class="table">
                    <thead>
                    <tr><th>Mã đơn</th><th>Khách hàng</th><th>Sản phẩm</th><th>Số tiền</th><th>Trạng thái</th><th></th></tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td><strong>#PK-08225</strong></td><td>Minh Anh Store</td><td>Poster A2 — 100 tờ</td>
                        <td class="money">3.100.000₫</td><td><span class="badge paid">Đã thu</span></td>
                        <td><button class="btn-ghost" style="padding:6px 12px;border-radius:7px;font-size:12px;font-weight:600;" onclick="toast('Đã mở hoá đơn #PK-08225')">Hoá đơn</button></td>
                    </tr>
                    <tr>
                        <td><strong>#PK-08224</strong></td><td>Local Brand Co.</td><td>Áo thun DTG — 36 chiếc</td>
                        <td class="money">2.880.000₫</td><td><span class="badge paid">Đã thu</span></td>
                        <td><button class="btn-ghost" style="padding:6px 12px;border-radius:7px;font-size:12px;font-weight:600;" onclick="toast('Đã mở hoá đơn #PK-08224')">Hoá đơn</button></td>
                    </tr>
                    <tr>
                        <td><strong>#PK-08232</strong></td><td>Quà Tặng Việt</td><td>Cốc sứ — 150 chiếc</td>
                        <td class="money">4.200.000₫</td><td><span class="badge pending">Chờ thu</span></td>
                        <td><button class="btn-ghost" style="padding:6px 12px;border-radius:7px;font-size:12px;font-weight:600;" onclick="prefillPay('#PK-08232','4200000')">Thu tiền</button></td>
                    </tr>
                    <tr>
                        <td><strong>#PK-08230</strong></td><td>Local Brand Co.</td><td>Áo thun DTG — 120 chiếc</td>
                        <td class="money">9.600.000₫</td><td><span class="badge debt">Còn nợ</span></td>
                        <td><button class="btn-ghost" style="padding:6px 12px;border-radius:7px;font-size:12px;font-weight:600;" onclick="prefillPay('#PK-08230','9600000')">Thu tiền</button></td>
                    </tr>
                    <tr>
                        <td><strong>#PK-08223</strong></td><td>Quà Tặng Việt</td><td>Cốc sứ — 80 chiếc</td>
                        <td class="money">2.240.000₫</td><td><span class="badge paid">Đã thu</span></td>
                        <td><button class="btn-ghost" style="padding:6px 12px;border-radius:7px;font-size:12px;font-weight:600;" onclick="toast('Đã mở hoá đơn #PK-08223')">Hoá đơn</button></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- ===== TAB: SHOP ===== -->
    <div class="tab-content" id="tab-shop">
        <div class="section-title">
            <h2>Mẫu có sẵn — Đăng bán</h2>
            <button class="btn-start" style="padding:10px 18px; border-radius:9px; font-weight:700; border:none;" onclick="openModal('shopModal')">+ Đăng mẫu mới</button>
        </div>

        <div class="alert-row info" style="margin-bottom:18px;">
            <span class="ic">🛍️</span>
            <div class="txt"><strong>6 mẫu đang bán · 1 mẫu nháp</strong><span>Doanh thu từ mẫu bán sẵn hôm nay: 2.450.000₫</span></div>
            <button onclick="toast('Đã mở gian hàng PrintKraft')">Xem gian hàng</button>
        </div>

        <div class="shop-grid">
            <div class="shop-card">
                <div class="shop-thumb">👕<span class="on-tag">● Đang bán</span></div>
                <div class="shop-body">
                    <div class="shop-cat">Áo thun</div>
                    <h4>Áo thun Oversize in DTG</h4>
                    <div class="shop-price">189.000₫ <span>/ chiếc</span></div>
                    <div class="shop-meta">Tồn mẫu: 24 · Đã bán: 156</div>
                    <div class="shop-actions">
                        <button class="btn-start" onclick="toggleShop(this,'Áo thun Oversize')">Ngừng bán</button>
                        <button class="btn-ghost" onclick="toast('Đã mở chi tiết mẫu áo thun Oversize')">Xem</button>
                    </div>
                </div>
            </div>

            <div class="shop-card">
                <div class="shop-thumb">☕<span class="on-tag">● Đang bán</span></div>
                <div class="shop-body">
                    <div class="shop-cat">Cốc sứ</div>
                    <h4>Cốc sứ Sublimation 350ml</h4>
                    <div class="shop-price">95.000₫ <span>/ chiếc</span></div>
                    <div class="shop-meta">Tồn mẫu: 82 · Đã bán: 410</div>
                    <div class="shop-actions">
                        <button class="btn-start" onclick="toggleShop(this,'Cốc sứ 350ml')">Ngừng bán</button>
                        <button class="btn-ghost" onclick="toast('Đã mở chi tiết mẫu cốc sứ')">Xem</button>
                    </div>
                </div>
            </div>

            <div class="shop-card">
                <div class="shop-thumb">🖼️<span class="on-tag">● Đang bán</span></div>
                <div class="shop-body">
                    <div class="shop-cat">Poster</div>
                    <h4>Poster A2 in UV mờ</h4>
                    <div class="shop-price">72.000₫ <span>/ tờ</span></div>
                    <div class="shop-meta">Tồn mẫu: 40 · Đã bán: 180</div>
                    <div class="shop-actions">
                        <button class="btn-start" onclick="toggleShop(this,'Poster A2 UV')">Ngừng bán</button>
                        <button class="btn-ghost" onclick="toast('Đã mở chi tiết mẫu poster A2')">Xem</button>
                    </div>
                </div>
            </div>

            <div class="shop-card">
                <div class="shop-thumb">👜<span class="on-tag">● Đang bán</span></div>
                <div class="shop-body">
                    <div class="shop-cat">Túi vải</div>
                    <h4>Túi canvas in lụa</h4>
                    <div class="shop-price">68.000₫ <span>/ chiếc</span></div>
                    <div class="shop-meta">Tồn mẫu: 60 · Đã bán: 140</div>
                    <div class="shop-actions">
                        <button class="btn-start" onclick="toggleShop(this,'Túi canvas')">Ngừng bán</button>
                        <button class="btn-ghost" onclick="toast('Đã mở chi tiết mẫu túi canvas')">Xem</button>
                    </div>
                </div>
            </div>

            <div class="shop-card">
                <div class="shop-thumb">💳<span class="on-tag">● Đang bán</span></div>
                <div class="shop-body">
                    <div class="shop-cat">Namecard</div>
                    <h4>Namecard 300gsm — 500 tấm</h4>
                    <div class="shop-price">420.000₫ <span>/ hộp</span></div>
                    <div class="shop-meta">Tồn mẫu: 12 · Đã bán: 88</div>
                    <div class="shop-actions">
                        <button class="btn-start" onclick="toggleShop(this,'Namecard 300gsm')">Ngừng bán</button>
                        <button class="btn-ghost" onclick="toast('Đã mở chi tiết mẫu namecard')">Xem</button>
                    </div>
                </div>
            </div>

            <div class="shop-card">
                <div class="shop-thumb">🎁<span class="off-tag">● Bản nháp</span></div>
                <div class="shop-body">
                    <div class="shop-cat">Combo quà tặng</div>
                    <h4>Combo Cốc + Áo theo yêu cầu</h4>
                    <div class="shop-price">265.000₫ <span>/ set</span></div>
                    <div class="shop-meta">Tồn mẫu: 0 · Chưa đăng bán</div>
                    <div class="shop-actions">
                        <button class="btn-start" onclick="toggleShop(this,'Combo Cốc + Áo')">Đăng bán</button>
                        <button class="btn-ghost" onclick="toast('Đã mở chi tiết mẫu combo')">Xem</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== TAB: SUPPORT ===== -->
    <div class="tab-content" id="tab-support">
        <div class="section-title">
            <h2>Hỗ trợ &amp; Đổi trả</h2>
            <div class="filter-tabs">
                <button class="active" onclick="pickFilter(this)">Yêu cầu đổi/trả (2)</button>
                <button onclick="pickFilter(this)">Đã xử lý</button>
            </div>
        </div>

        <div class="support-grid">
            <div class="support-card" onclick="openModal('contactModal')">
                <div class="ic">☎️</div>
                <strong>Liên hệ quản trị viên</strong>
                <span>Hotline, Zalo, email — hỗ trợ trong 5 phút</span>
            </div>
            <div class="support-card" onclick="toggleChat()">
                <div class="ic">💬</div>
                <strong>Chat trực tuyến</strong>
                <span>Trò chuyện trực tiếp với admin đang trực</span>
            </div>
            <div class="support-card" onclick="openReturnModal('','')">
                <div class="ic">↩️</div>
                <strong>Tạo yêu cầu đổi/trả</strong>
                <span>Gửi yêu cầu hoàn tiền hoặc in lại đơn lỗi</span>
            </div>
            <div class="support-card" onclick="toast('Đã mở trung tâm trợ giúp')">
                <div class="ic">📚</div>
                <strong>Trung tâm trợ giúp</strong>
                <span>Hướng dẫn quy trình, biểu mẫu, chính sách</span>
            </div>
        </div>

        <div class="bottom-grid" style="grid-template-columns:1.4fr 1fr;">
            <div class="panel">
                <h3>Yêu cầu đổi / trả đang chờ</h3>

                <div class="job-card" style="margin-bottom:14px;">
                    <div class="job-top"><span class="job-id">#PK-08220</span><span class="due late">Quá hạn 1 ngày</span></div>
                    <div class="job-desc">Áo thun DTG — 36 chiếc · Local Brand Co.</div>
                    <div class="job-meta"><span>Lý do: Sai màu (đỏ nhạt hơn 15%)</span><span>Yêu cầu: In lại</span></div>
                    <div class="job-actions">
                        <button class="btn-done" onclick="toast('Đã chấp nhận yêu cầu in lại #PK-08220')">Chấp nhận in lại</button>
                        <button class="btn-danger" onclick="toast('Đã từ chối yêu cầu — gửi phản hồi cho khách')">Từ chối</button>
                        <button class="btn-ghost" onclick="openModal('contactModal')">Liên hệ khách</button>
                    </div>
                </div>

                <div class="job-card">
                    <div class="job-top"><span class="job-id">#PK-08214</span><span class="due soon">Chờ 3h</span></div>
                    <div class="job-desc">Namecard — 500 tấm · Cần Thơ Store</div>
                    <div class="job-meta"><span>Lý do: Lệch vị trí in 8mm</span><span>Yêu cầu: Hoàn tiền 30%</span></div>
                    <div class="job-actions">
                        <button class="btn-done" onclick="toast('Đã duyệt hoàn tiền 30% cho #PK-08214')">Duyệt hoàn tiền</button>
                        <button class="btn-danger" onclick="toast('Đã từ chối yêu cầu hoàn tiền')">Từ chối</button>
                        <button class="btn-ghost" onclick="openModal('contactModal')">Liên hệ khách</button>
                    </div>
                </div>
            </div>

            <div style="display:flex; flex-direction:column; gap:18px;">
                <div class="panel">
                    <h3>Thống kê đổi/trả tháng này</h3>
                    <div class="detail-grid" style="grid-template-columns:1fr 1fr;">
                        <div class="field"><label>Tổng yêu cầu</label><strong>14</strong></div>
                        <div class="field"><label>Đã xử lý</label><strong style="color:var(--green);">12</strong></div>
                        <div class="field"><label>Hoàn tiền</label><strong style="color:var(--red);">3.8tr</strong></div>
                        <div class="field"><label>Tỉ lệ đổi/trả</label><strong>2.1%</strong></div>
                    </div>
                </div>

                <div class="panel">
                    <h3>Liên hệ nhanh</h3>
                    <div class="machine-row">
                        <div class="machine-icon">☎️</div>
                        <div class="machine-info"><strong>Hotline xưởng</strong><span>1900 6789 · 24/7</span></div>
                        <button class="btn-ghost" style="padding:7px 12px;border-radius:8px;font-size:12px;font-weight:600;" onclick="toast('Đang gọi 1900 6789...')">Gọi</button>
                    </div>
                    <div class="machine-row">
                        <div class="machine-icon">💬</div>
                        <div class="machine-info"><strong>Zalo quản trị viên</strong><span>Đặng Long · Quản lý ca</span></div>
                        <button class="btn-ghost" style="padding:7px 12px;border-radius:8px;font-size:12px;font-weight:600;" onclick="toggleChat()">Chat</button>
                    </div>
                    <div class="machine-row">
                        <div class="machine-icon">✉️</div>
                        <div class="machine-info"><strong>Email hỗ trợ</strong><span>hotro@saigonprint.vn</span></div>
                        <button class="btn-ghost" style="padding:7px 12px;border-radius:8px;font-size:12px;font-weight:600;" onclick="toast('Đã sao chép email hỗ trợ')">Sao chép</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>

<!-- ===== JOB DETAIL MODAL ===== -->
<div class="overlay" id="overlay" onclick="closeAll()"></div>

<div class="modal" id="jobModal">
    <div class="modal-box">
        <div class="modal-head">
            <button class="modal-close" onclick="closeAll()">✕</button>
            <h3 id="jmId">#PK-08230</h3>
            <div class="sub" id="jmDesc">Áo thun DTG — 120 chiếc, 3 màu size</div>
        </div>

        <div class="detail-grid">
            <div class="field"><label>Khách hàng</label><strong id="jmCustomer">Local Brand Co.</strong></div>
            <div class="field"><label>Máy</label><strong id="jmMachine">DTG-02</strong></div>
            <div class="field"><label>Trạng thái</label><strong id="jmStatus">Trễ 6h</strong></div>
            <div class="field"><label>Số lượng</label><strong>120 chiếc</strong></div>
            <div class="field"><label>Chất liệu</label><strong>Cotton 100%</strong></div>
            <div class="field"><label>Phương pháp in</label><strong>DTG</strong></div>
        </div>

        <h3 style="font-size:16px; margin-bottom:12px; color:white;">Tiến độ sản xuất</h3>
        <div class="timeline" style="margin-bottom:20px;">
            <div class="tl-item done">
                <div class="tl-txt">Nhận file thiết kế</div>
                <div class="tl-time">08:15 · Từ hệ thống PrintKraft</div>
            </div>
            <div class="tl-item done">
                <div class="tl-txt">Duyệt mẫu in</div>
                <div class="tl-time">08:40 · Khách hàng xác nhận</div>
            </div>
            <div class="tl-item active">
                <div class="tl-txt">Đang in DTG</div>
                <div class="tl-time">62% · Dự kiến xong 11:30</div>
            </div>
            <div class="tl-item">
                <div class="tl-txt">Kiểm tra chất lượng</div>
                <div class="tl-time">Chờ xử lý</div>
            </div>
            <div class="tl-item">
                <div class="tl-txt">Đóng gói &amp; bàn giao</div>
                <div class="tl-time">Chờ xử lý</div>
            </div>
        </div>

        <div style="display:flex; gap:10px; flex-wrap:wrap;">
            <button class="btn-start" style="flex:1; min-width:130px; padding:12px; border-radius:9px; font-weight:700; border:none;" onclick="toast('Đã cập nhật tiến độ đơn hàng')">Cập nhật tiến độ</button>
            <button class="btn-edit" style="flex:1; min-width:110px; padding:12px; border-radius:9px; font-weight:700;" onclick="closeAll();openEditJob(document.getElementById('jmId').textContent, document.getElementById('jmDesc').textContent)">✎ Chỉnh sửa</button>
            <button class="btn-danger" style="flex:1; min-width:110px; padding:12px; border-radius:9px; font-weight:700;" onclick="closeAll();openCancelJob(document.getElementById('jmId').textContent, document.getElementById('jmDesc').textContent)">✕ Hủy đơn</button>
            <button class="btn-ghost" style="flex:1; min-width:110px; padding:12px; border-radius:9px; font-weight:700;" onclick="toast('Đã in phiếu công việc')">In phiếu</button>
        </div>
    </div>
</div>

<!-- ===== EDIT JOB MODAL ===== -->
<div class="modal" id="editModal">
    <div class="modal-box" style="width:520px;">
        <div class="modal-head">
            <button class="modal-close" onclick="closeAll()">✕</button>
            <h3>Chỉnh sửa đơn sản xuất</h3>
            <div class="sub" id="emSub">#PK-08230 · Áo thun DTG — 120 chiếc</div>
        </div>

        <div class="form-field">
            <label>Số lượng</label>
            <input id="emQty" type="number" value="120" min="1">
        </div>
        <div class="form-field">
            <label>Máy sản xuất</label>
            <select id="emMachine">
                <option>DTG-01</option>
                <option selected>DTG-02</option>
                <option>SUB-01</option>
                <option>UV-01</option>
                <option>SILK-01</option>
                <option>HEAT-01</option>
            </select>
        </div>
        <div class="form-field">
            <label>Hạn giao mới</label>
            <input id="emDue" type="text" value="15/09/2026 — 18:00">
        </div>
        <div class="form-field">
            <label>Mức ưu tiên</label>
            <select id="emPriority">
                <option>Bình thường</option>
                <option selected>Ưu tiên cao</option>
                <option>Hỏa tốc</option>
            </select>
        </div>
        <div class="form-field">
            <label>Ghi chú cho xưởng</label>
            <textarea id="emNote" placeholder="VD: Đổi sang mực bền màu hơn, giữ nguyên form oversize..."></textarea>
        </div>

        <div style="display:flex; gap:10px; margin-top:6px;">
            <button class="btn-ghost" style="flex:1; padding:12px; border-radius:9px; font-weight:700;" onclick="closeAll()">Huỷ</button>
            <button class="btn-start" style="flex:1.4; padding:12px; border-radius:9px; font-weight:700; border:none;" onclick="saveEditJob()">Lưu thay đổi</button>
        </div>
    </div>
</div>

<!-- ===== CANCEL JOB MODAL ===== -->
<div class="modal" id="cancelModal">
    <div class="modal-box" style="width:500px;">
        <div class="modal-head">
            <button class="modal-close" onclick="closeAll()">✕</button>
            <h3 style="color:var(--red);">Hủy đơn sản xuất</h3>
            <div class="sub" id="cmSub">#PK-08230 · Áo thun DTG — 120 chiếc</div>
        </div>

        <div class="alert-row" style="margin-bottom:16px;">
            <span class="ic">⚠️</span>
            <div class="txt"><strong>Hành động này không thể hoàn tác</strong><span>Vật tư đã dùng sẽ được ghi nhận vào chi phí xưởng.</span></div>
        </div>

        <div class="form-field">
            <label>Lý do hủy đơn</label>
            <div class="radio-list">
                <label><input type="radio" name="cancelReason" checked> Khách hàng yêu cầu hủy</label>
                <label><input type="radio" name="cancelReason"> Không đủ vật tư / phôi</label>
                <label><input type="radio" name="cancelReason"> Máy hỏng, không kịp tiến độ</label>
                <label><input type="radio" name="cancelReason"> File thiết kế lỗi, khách chưa xác nhận</label>
                <label><input type="radio" name="cancelReason"> Lý do khác</label>
            </div>
        </div>

        <div class="form-field">
            <label>Ghi chú thêm</label>
            <textarea placeholder="Nhập ghi chú nội bộ..."></textarea>
        </div>

        <div style="display:flex; gap:10px;">
            <button class="btn-ghost" style="flex:1; padding:12px; border-radius:9px; font-weight:700;" onclick="closeAll()">Giữ đơn</button>
            <button class="btn-danger" style="flex:1.3; padding:12px; border-radius:9px; font-weight:700;" onclick="confirmCancel()">Xác nhận hủy đơn</button>
        </div>
    </div>
</div>

<!-- ===== RETURN MODAL ===== -->
<div class="modal" id="returnModal">
    <div class="modal-box" style="width:520px;">
        <div class="modal-head">
            <button class="modal-close" onclick="closeAll()">✕</button>
            <h3>Yêu cầu đổi / trả hàng</h3>
            <div class="sub" id="rmSub">Tạo phiếu đổi trả cho đơn hàng</div>
        </div>

        <div class="form-field">
            <label>Mã đơn hàng</label>
            <input id="rmOrder" placeholder="VD: #PK-08229">
        </div>
        <div class="form-field">
            <label>Số lượng đổi/trả</label>
            <input id="rmQty" type="number" value="1" min="1">
        </div>
        <div class="form-field">
            <label>Lý do</label>
            <div class="radio-list">
                <label><input type="radio" name="returnReason" checked> In sai màu so với file</label>
                <label><input type="radio" name="returnReason"> Lệch vị trí in / lỗi hình</label>
                <label><input type="radio" name="returnReason"> Sản phẩm bị lỗi, bong tróc</label>
                <label><input type="radio" name="returnReason"> Giao sai số lượng / sai mẫu</label>
                <label><input type="radio" name="returnReason"> Khách đổi ý</label>
            </div>
        </div>
        <div class="form-field">
            <label>Hình thức xử lý</label>
            <select id="rmMethod">
                <option>In lại sản phẩm</option>
                <option>Hoàn tiền toàn phần</option>
                <option>Hoàn tiền một phần</option>
                <option>Đổi sang mẫu khác</option>
            </select>
        </div>
        <div class="form-field">
            <label>Mô tả chi tiết</label>
            <textarea placeholder="Mô tả tình trạng lỗi để bộ phận QC xử lý..."></textarea>
        </div>

        <div style="display:flex; gap:10px;">
            <button class="btn-ghost" style="flex:1; padding:12px; border-radius:9px; font-weight:700;" onclick="closeAll()">Huỷ</button>
            <button class="btn-start" style="flex:1.4; padding:12px; border-radius:9px; font-weight:700; border:none;" onclick="submitReturn()">Gửi yêu cầu</button>
        </div>
    </div>
</div>

<!-- ===== HANDOVER MODAL (form bàn giao đơn / gửi đơn hàng) ===== -->
<div class="modal" id="handoverModal">
    <div class="modal-box" style="width:520px;">
        <div class="modal-head">
            <button class="modal-close" onclick="closeAll()">✕</button>
            <h3>Bàn giao đơn hàng</h3>
            <div class="sub" id="hmSub">#PK-08238 · Cốc sứ 350ml — 60 chiếc</div>
        </div>

        <div class="form-field">
            <label>Đơn vị vận chuyển</label>
            <select id="hmCarrier">
                <option>Giao Hàng Nhanh</option>
                <option>Giao Hàng Tiết Kiệm</option>
                <option>Viettel Post</option>
                <option>Ninja Van</option>
                <option>Khách tự đến lấy</option>
            </select>
        </div>
        <div class="form-field">
            <label>Mã vận đơn</label>
            <input id="hmTracking" placeholder="VD: GHN123456789">
        </div>
        <div class="form-field">
            <label>Số kiện hàng</label>
            <input id="hmPackages" type="number" value="1" min="1">
        </div>
        <div class="form-field">
            <label>Người bàn giao</label>
            <input id="hmStaff" value="Đặng Long">
        </div>
        <div class="form-field">
            <label>Ghi chú tình trạng đóng gói</label>
            <textarea id="hmNote" placeholder="VD: Đóng thùng carton, có lót xốp chống vỡ..."></textarea>
        </div>

        <div style="display:flex; gap:10px;">
            <button class="btn-ghost" style="flex:1; padding:12px; border-radius:9px; font-weight:700;" onclick="closeAll()">Huỷ</button>
            <button class="btn-start" style="flex:1.4; padding:12px; border-radius:9px; font-weight:700; border:none;" onclick="confirmHandover()">📦 Xác nhận bàn giao</button>
        </div>
    </div>
</div>

<!-- ===== SHOP LISTING MODAL ===== -->
<div class="modal" id="shopModal">
    <div class="modal-box" style="width:520px;">
        <div class="modal-head">
            <button class="modal-close" onclick="closeAll()">✕</button>
            <h3>Đăng bán mẫu có sẵn</h3>
            <div class="sub">Mẫu sẽ hiển thị trên gian hàng PrintKraft</div>
        </div>

        <div class="form-field">
            <label>Tên mẫu sản phẩm</label>
            <input placeholder="VD: Áo thun Oversize in DTG">
        </div>
        <div class="form-field">
            <label>Danh mục</label>
            <select>
                <option>Áo thun</option>
                <option>Cốc sứ</option>
                <option>Poster</option>
                <option>Túi vải</option>
                <option>Namecard</option>
                <option>Combo quà tặng</option>
            </select>
        </div>
        <div class="detail-grid" style="grid-template-columns:1fr 1fr; margin-bottom:14px;">
            <div class="form-field" style="margin-bottom:0;">
                <label>Giá bán (₫)</label>
                <input type="number" placeholder="189000">
            </div>
            <div class="form-field" style="margin-bottom:0;">
                <label>Số lượng có sẵn</label>
                <input type="number" placeholder="24">
            </div>
        </div>
        <div class="form-field">
            <label>Mô tả mẫu</label>
            <textarea placeholder="Chất liệu, kích thước, phương pháp in, thời gian sản xuất..."></textarea>
        </div>

        <div style="display:flex; gap:10px;">
            <button class="btn-ghost" style="flex:1; padding:12px; border-radius:9px; font-weight:700;" onclick="closeAll()">Huỷ</button>
            <button class="btn-start" style="flex:1.4; padding:12px; border-radius:9px; font-weight:700; border:none;" onclick="toast('Đã đăng bán mẫu mới lên gian hàng');closeAll()">Đăng bán ngay</button>
        </div>
    </div>
</div>

<!-- ===== CONTACT ADMIN MODAL ===== -->
<div class="modal" id="contactModal">
    <div class="modal-box" style="width:540px;">
        <div class="modal-head">
            <button class="modal-close" onclick="closeAll()">✕</button>
            <h3>Liên hệ quản trị viên</h3>
            <div class="sub">Phản hồi trung bình trong 5 phút · Hỗ trợ 24/7</div>
        </div>

        <div class="support-grid" style="grid-template-columns:repeat(3,1fr); margin-bottom:20px;">
            <div class="support-card" style="padding:14px;" onclick="toast('Đang gọi hotline 1900 6789...')">
                <div class="ic" style="width:40px;height:40px;font-size:18px;margin-bottom:8px;">☎️</div>
                <strong style="font-size:13.5px;">1900 6789</strong>
                <span style="font-size:11.5px;">Hotline xưởng</span>
            </div>
            <div class="support-card" style="padding:14px;" onclick="closeAll();toggleChat()">
                <div class="ic" style="width:40px;height:40px;font-size:18px;margin-bottom:8px;">💬</div>
                <strong style="font-size:13.5px;">Zalo chat</strong>
                <span style="font-size:11.5px;">Đặng Long</span>
            </div>
            <div class="support-card" style="padding:14px;" onclick="toast('Đã sao chép hotro@saigonprint.vn')">
                <div class="ic" style="width:40px;height:40px;font-size:18px;margin-bottom:8px;">✉️</div>
                <strong style="font-size:13.5px;">Email</strong>
                <span style="font-size:11.5px;">hotro@sgprint.vn</span>
            </div>
        </div>

        <div class="form-field">
            <label>Chủ đề</label>
            <select id="ctTopic">
                <option>Sự cố máy móc / thiết bị</option>
                <option>Đơn hàng gấp / trễ hạn</option>
                <option>Vật tư / nhập kho</option>
                <option>Khiếu nại của khách hàng</option>
                <option>Đổi trả &amp; hoàn tiền</option>
                <option>Khác</option>
            </select>
        </div>
        <div class="form-field">
            <label>Mức độ khẩn cấp</label>
            <select id="ctLevel">
                <option>Bình thường</option>
                <option>Khẩn — xử lý trong 1 giờ</option>
                <option>Hỏa tốc — dừng dây chuyền</option>
            </select>
        </div>
        <div class="form-field">
            <label>Nội dung</label>
            <textarea id="ctMsg" placeholder="Mô tả vấn đề bạn đang gặp..."></textarea>
        </div>

        <div style="display:flex; gap:10px;">
            <button class="btn-ghost" style="flex:1; padding:12px; border-radius:9px; font-weight:700;" onclick="closeAll()">Đóng</button>
            <button class="btn-start" style="flex:1.4; padding:12px; border-radius:9px; font-weight:700; border:none;" onclick="sendContact()">Gửi yêu cầu</button>
        </div>
    </div>
</div>

<!-- ===== PROFILE MODAL ===== -->
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

<!-- ===== FAB + CHAT ===== -->
<div class="fab-wrap">
    <button class="fab fab-help" onclick="openModal('contactModal')" title="Liên hệ quản trị viên">☎</button>
    <button class="fab fab-chat" onclick="toggleChat()" title="Chat trực tuyến">💬</button>
</div>

<div class="chat-panel" id="chatPanel">
    <div class="chat-head">
        <div class="av">ĐL</div>
        <div style="flex:1;">
            <strong>Đặng Long · Quản lý ca</strong>
            <span>● Đang trực tuyến</span>
        </div>
        <button class="modal-close" style="position:static; font-size:17px;" onclick="toggleChat()">✕</button>
    </div>
    <div class="chat-body" id="chatBody">
        <div class="msg them">Chào bạn 👋 Mình là Long, quản lý ca sáng. Cần hỗ trợ gì cứ nhắn nhé!</div>
        <div class="msg them">Nếu là sự cố máy móc, bạn ghi rõ mã máy giúp mình (VD: UV-01).</div>
    </div>
    <div class="chat-foot">
        <input id="chatInput" placeholder="Nhập tin nhắn..." onkeydown="if(event.key==='Enter')sendChat()">
        <button onclick="sendChat()">Gửi</button>
    </div>
</div>

<div class="toast" id="toast">Đã thực hiện</div>

<script>
    /* ---------- Clock ---------- */
    function tick(){
        const d = new Date();
        const hh = String(d.getHours()).padStart(2,'0');
        const mm = String(d.getMinutes()).padStart(2,'0');
        document.getElementById('clock').textContent = hh + ':' + mm;
    }
    tick(); setInterval(tick, 30000);

    /* ---------- Toast ---------- */
    let toastTimer;
    function toast(msg){
        const t = document.getElementById('toast');
        t.textContent = msg;
        t.classList.add('show');
        clearTimeout(toastTimer);
        toastTimer = setTimeout(()=>t.classList.remove('show'), 2400);
    }

    /* ---------- Tabs ---------- */
    function switchTab(btn, id){
        document.querySelectorAll('.nav-tabs button').forEach(b=>b.classList.remove('active'));
        btn.classList.add('active');
        document.querySelectorAll('.tab-content').forEach(c=>c.classList.remove('active'));
        document.getElementById('tab-' + id).classList.add('active');
        window.scrollTo({top:0, behavior:'smooth'});
    }
    function switchTabTo(id){
        const btn = Array.from(document.querySelectorAll('.nav-tabs button'))
            .find(b => b.getAttribute('onclick') && b.getAttribute('onclick').includes("'" + id + "'"));
        if(btn) switchTab(btn, id);
    }

    function pickFilter(btn){
        btn.parentElement.querySelectorAll('button').forEach(b=>b.classList.remove('active'));
        btn.classList.add('active');
    }

    /* ---------- Job actions ---------- */
    function approveOrderRequest(btn, id, type){
        const card = btn.closest('.job-card');
        card.style.opacity = '0.4';
        card.style.pointerEvents = 'none';
        toast(type === 'edit'
            ? 'Đã duyệt yêu cầu chỉnh sửa ' + id + ' — đơn sẽ được cập nhật'
            : 'Đã duyệt hủy đơn ' + id + ' — dừng sản xuất, khách hàng sẽ được thông báo');
    }

    function rejectOrderRequest(btn, id, type){
        const card = btn.closest('.job-card');
        card.style.opacity = '0.3';
        card.style.pointerEvents = 'none';
        card.style.filter = 'grayscale(.7)';
        toast(type === 'edit'
            ? 'Đã từ chối yêu cầu chỉnh sửa ' + id + ' — đơn tiếp tục theo kế hoạch ban đầu'
            : 'Đã từ chối yêu cầu hủy ' + id + ' — đơn tiếp tục sản xuất');
    }

    function acceptOrder(btn, id){
        toast('Đã nhận đơn ' + id + ' — chuyển sang mục Chờ xử lý');
        const card = btn.closest('.job-card');
        card.style.opacity = '0.4';
        card.style.pointerEvents = 'none';
    }

    function rejectOrder(btn, id){
        const card = btn.closest('.job-card');
        card.style.opacity = '0.3';
        card.style.pointerEvents = 'none';
        card.style.filter = 'grayscale(.7)';
        toast('Đã từ chối đơn ' + id + ' — khách hàng sẽ được thông báo');
    }

    function startJob(btn, id){
        toast('Đã bắt đầu in ' + id + ' — chuyển sang mục Đang sản xuất');
        const card = btn.closest('.job-card');
        card.style.opacity = '0.4';
        card.style.pointerEvents = 'none';
    }

    function finishJob(btn, id){
        toast('Đã hoàn tất ' + id + ' — chuyển sang Kiểm tra chất lượng');
        const card = btn.closest('.job-card');
        card.style.opacity = '0.4';
        card.style.pointerEvents = 'none';
    }

    function approveQC(btn, id){
        toast('Đã duyệt ' + id + ' — chuyển đóng gói & giao hàng');
        const card = btn.closest('.job-card');
        card.style.opacity = '0.4';
        card.style.pointerEvents = 'none';
    }

    function toggleQC(el){
        el.classList.toggle('checked');
        el.textContent = el.classList.contains('checked') ? '✓' : '';
    }

    /* ---------- Modal ---------- */
    function openModal(id){
        document.getElementById(id).classList.add('show');
        document.getElementById('overlay').classList.add('show');
    }
    function closeAll(){
        document.querySelectorAll('.modal, .overlay').forEach(el=>el.classList.remove('show'));
    }
    document.addEventListener('keydown', e=>{ if(e.key === 'Escape') closeAll(); });

    function openJobModal(id, desc, customer, machine, status, statusType){
        document.getElementById('jmId').textContent = id;
        document.getElementById('jmDesc').textContent = desc;
        document.getElementById('jmCustomer').textContent = customer;
        document.getElementById('jmMachine').textContent = machine;
        const statusEl = document.getElementById('jmStatus');
        statusEl.textContent = status;
        statusEl.style.color = statusType === 'late' ? 'var(--red)'
            : statusType === 'soon' ? 'var(--orange)'
                : statusType === 'new' ? 'var(--violet)'
                    : 'var(--green)';
        openModal('jobModal');
    }

    /* ---------- EDIT JOB (chỉnh sửa giữa quá trình SX) ---------- */
    let editingJobId = '';
    function openEditJob(id, desc){
        editingJobId = id;
        document.getElementById('emSub').textContent = id + ' · ' + desc;
        openModal('editModal');
    }
    function saveEditJob(){
        closeAll();
        toast('Đã lưu thay đổi cho ' + editingJobId + ' — xưởng sẽ nhận thông báo');
    }

    /* ---------- CANCEL JOB ---------- */
    let cancellingJobId = '';
    function openCancelJob(id, desc){
        cancellingJobId = id;
        document.getElementById('cmSub').textContent = id + ' · ' + desc;
        openModal('cancelModal');
    }
    function confirmCancel(){
        const card = document.querySelector('.job-card[data-job="' + cancellingJobId + '"]');
        if(card){
            card.style.opacity = '0.3';
            card.style.pointerEvents = 'none';
            card.style.filter = 'grayscale(.7)';
        }
        closeAll();
        toast('Đã hủy đơn ' + cancellingJobId + ' — khách hàng sẽ được thông báo');
    }

    /* ---------- RETURN / ĐỔI TRẢ ---------- */
    function openReturnModal(id, desc){
        document.getElementById('rmOrder').value = id || '';
        document.getElementById('rmSub').textContent = id
            ? 'Tạo phiếu đổi trả cho ' + id + (desc ? ' · ' + desc : '')
            : 'Tạo phiếu đổi trả cho đơn hàng';
        openModal('returnModal');
    }
    function submitReturn(){
        const order = document.getElementById('rmOrder').value.trim() || 'đơn hàng';
        const method = document.getElementById('rmMethod').value;
        closeAll();
        toast('Đã gửi yêu cầu ' + method.toLowerCase() + ' cho ' + order);
    }

    /* ---------- HANDOVER (gửi đơn hàng / bàn giao cho vận chuyển) ---------- */
    let handoverJobId = '';
    function openHandoverModal(id, desc){
        handoverJobId = id;
        document.getElementById('hmSub').textContent = id + ' · ' + desc;
        openModal('handoverModal');
    }
    function confirmHandover(){
        const carrier = document.getElementById('hmCarrier').value;
        const tracking = document.getElementById('hmTracking').value.trim();
        if(!tracking){ toast('Vui lòng nhập mã vận đơn'); return; }
        closeAll();
        toast('Đã bàn giao ' + handoverJobId + ' cho ' + carrier + ' — mã vận đơn ' + tracking);
        const card = document.querySelector('.job-card[data-job="' + handoverJobId + '"]');
        if(card){
            const badge = card.querySelector('.due');
            if(badge){ badge.textContent = 'Đã giao'; badge.className = 'due ok'; }
            const actionsRow = card.querySelector('.job-actions');
            if(actionsRow) actionsRow.innerHTML = '<button class="btn-ghost" onclick="openReturnModal(\'' + handoverJobId + '\',\'\')">↩ Đổi/Trả</button><button class="btn-ghost" onclick="closeAll()">Chi tiết</button>';
        }
    }

    /* ---------- REVENUE ---------- */
    const revData = {
        day:   {period:'hôm nay',  total:'18.400.000₫', profit:'7.120.000₫', orders:'21 đơn', delta:'▲ 12% so với hôm qua'},
        week:  {period:'tuần này', total:'109.100.000₫', profit:'42.300.000₫', orders:'142 đơn', delta:'▲ 8% so với tuần trước'},
        month: {period:'tháng này',total:'438.600.000₫', profit:'169.800.000₫', orders:'586 đơn', delta:'▲ 15% so với tháng trước'}
    };
    function setRevenue(key){
        const d = revData[key];
        document.getElementById('revPeriod').textContent = d.period;
        document.getElementById('revTotal').textContent = d.total;
        document.getElementById('revProfit').textContent = d.profit;
        document.getElementById('revOrders').textContent = d.orders;
        document.getElementById('revDelta').textContent = d.delta;
    }
    function recordPayment(){
        const order = document.getElementById('payOrder').value.trim();
        const amount = document.getElementById('payAmount').value.trim();
        if(!order || !amount){
            toast('Vui lòng nhập mã đơn và số tiền');
            return;
        }
        document.getElementById('payOrder').value = '';
        document.getElementById('payAmount').value = '';
        toast('Đã ghi nhận thanh toán ' + Number(amount).toLocaleString('vi-VN') + '₫ cho ' + order);
    }
    function prefillPay(order, amount){
        document.getElementById('payOrder').value = order;
        document.getElementById('payAmount').value = amount;
        toast('Đã điền thông tin ' + order + ' — bấm "Ghi nhận thanh toán"');
        document.getElementById('payOrder').scrollIntoView({behavior:'smooth', block:'center'});
    }

    /* ---------- SHOP ---------- */
    function toggleShop(btn, name){
        const card = btn.closest('.shop-card');
        const thumb = card.querySelector('.shop-thumb');
        const tag = thumb.querySelector('.on-tag, .off-tag');
        const isSelling = !!thumb.querySelector('.on-tag');

        if(isSelling){
            tag.className = 'off-tag';
            tag.textContent = '● Bản nháp';
            btn.textContent = 'Đăng bán';
            toast('Đã ngừng bán mẫu "' + name + '"');
        } else {
            tag.className = 'on-tag';
            tag.textContent = '● Đang bán';
            btn.textContent = 'Ngừng bán';
            toast('Đã đăng bán mẫu "' + name + '" lên gian hàng');
        }
    }

    /* ---------- CONTACT ADMIN ---------- */
    function sendContact(){
        const topic = document.getElementById('ctTopic').value;
        const level = document.getElementById('ctLevel').value;
        const msg = document.getElementById('ctMsg').value.trim();
        if(!msg){
            toast('Vui lòng nhập nội dung cần hỗ trợ');
            return;
        }
        document.getElementById('ctMsg').value = '';
        closeAll();
        toast('Đã gửi yêu cầu "' + topic + '" (' + level + ') tới quản trị viên');
    }

    /* ---------- CHAT ---------- */
    function toggleChat(){
        document.getElementById('chatPanel').classList.toggle('show');
    }
    function sendChat(){
        const input = document.getElementById('chatInput');
        const text = input.value.trim();
        if(!text) return;
        const body = document.getElementById('chatBody');
        const mine = document.createElement('div');
        mine.className = 'msg me';
        mine.textContent = text;
        body.appendChild(mine);
        input.value = '';
        body.scrollTop = body.scrollHeight;

        setTimeout(()=>{
            const reply = document.createElement('div');
            reply.className = 'msg them';
            reply.textContent = 'Đã ghi nhận nội dung của bạn. Mình sẽ kiểm tra và phản hồi trong ít phút nhé!';
            body.appendChild(reply);
            body.scrollTop = body.scrollHeight;
        }, 900);
    }
</script>
</body>
</html>