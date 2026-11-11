<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<fmt:setLocale value="vi_VN"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bảng điều khiển xưởng — PrintKraft</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="app-ctx" content="${ctx}">
    <meta name="stats-api" content="${ctx}/nhacungcap/api/stats">
    <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/Admin/admin.css">
    <style>
        .kpi .value.money{font-size:23px;}
        .kpi .note{font-size:11.5px; color:var(--muted); margin-top:6px;}
        .kpi .delta.up{color:var(--green);}
        .kpi .delta.down{color:var(--red);}
        .kpi .delta.flat{color:var(--muted);}
        .range-note{font-size:12px; color:var(--muted); margin:-8px 0 18px;}
        .quick-links{display:grid; grid-template-columns:repeat(3,1fr); gap:12px; margin-bottom:24px;}
        .quick-link{
            display:flex; align-items:center; gap:12px; background:white; border:1px solid var(--line);
            border-radius:12px; padding:14px 16px; font-weight:600; font-size:13.5px; transition:.15s;
        }
        .quick-link:hover{border-color:var(--cobalt); color:var(--cobalt); transform:translateY(-1px);}
        .quick-link span.ic{font-size:18px;}
        .quick-link small{display:block; font-weight:400; color:var(--muted); font-size:11.5px; margin-top:2px;}

        .chart-box{padding:16px 20px 20px; position:relative; min-height:230px;}
        .chart-state{padding:38px 16px; text-align:center; color:var(--muted); font-size:12.5px;}
        .chart-state strong{display:block; color:var(--text); font-size:13.5px; margin-bottom:4px;}
        .bar-chart{display:flex; align-items:flex-end; gap:8px; height:210px; padding-top:10px;}
        .bar-col{flex:1; display:flex; flex-direction:column; align-items:center; gap:6px; min-width:0; height:100%; justify-content:flex-end;}
        .bar-col .bar{
            width:100%; max-width:34px; background:linear-gradient(180deg,#5C7CFA,var(--cobalt));
            border-radius:6px 6px 0 0; min-height:2px; transition:height .35s;
        }
        .bar-col:hover .bar{filter:brightness(1.1);}
        .bar-col .bar-lbl{font-size:10.5px; color:var(--muted); white-space:nowrap;}
        .bar-col .bar-val{font-size:10.5px; font-weight:600; color:var(--text); white-space:nowrap;}
        .donut-wrap{display:flex; align-items:center; gap:20px; flex-wrap:wrap; padding:8px 0 4px;}
        .donut{
            width:150px; height:150px; border-radius:50%; flex-shrink:0;
            background:conic-gradient(var(--bg) 0deg 360deg); position:relative;
        }
        .donut:after{
            content:""; position:absolute; inset:26px; background:white; border-radius:50%;
            box-shadow:inset 0 0 0 1px var(--line);
        }
        .donut-center{
            position:absolute; inset:0; display:flex; flex-direction:column; align-items:center;
            justify-content:center; z-index:1; text-align:center;
        }
        .donut-center strong{font-size:22px; font-family:'IBM Plex Mono',monospace;}
        .donut-center span{font-size:10.5px; color:var(--muted); text-transform:uppercase; letter-spacing:.04em;}
        .legend{flex:1; min-width:170px; display:flex; flex-direction:column; gap:8px;}
        .legend-row{display:flex; align-items:center; gap:8px; font-size:12.5px;}
        .legend-row .sw{width:9px; height:9px; border-radius:2px; flex-shrink:0;}
        .legend-row .lbl{flex:1; color:var(--muted);}
        .legend-row b{font-family:'IBM Plex Mono',monospace; font-size:12px;}

        .attention-row{
            display:flex; align-items:center; gap:12px; padding:12px 20px;
            border-bottom:1px solid var(--line); font-size:13px;
        }
        .attention-row:last-child{border-bottom:none;}
        .attention-row .txt{flex:1; min-width:0;}
        .attention-row .txt strong{display:block; font-size:13px;}
        .attention-row .txt span{font-size:11.5px; color:var(--muted);}
        .money-cell{font-family:'IBM Plex Mono',monospace; white-space:nowrap;}
        .rank{width:22px; height:22px; border-radius:6px; background:var(--bg); color:var(--muted);
            display:inline-flex; align-items:center; justify-content:center; font-size:11.5px; font-weight:600;}
        .rank.top{background:#E7EBFD; color:var(--cobalt);}
        .def-note{font-size:11.5px; color:var(--muted); padding:0 20px 14px;}
        .link-plain{color:var(--cobalt); font-weight:600; font-size:12.5px;}
        @media (max-width:900px){
            .quick-links{grid-template-columns:1fr;}
        }
    </style>
</head>
<body>
<div class="layout">

    <aside class="sidebar">
        <div class="brand"><span class="sq"></span> PrintKraft Xưởng</div>

        <div class="nav-group">
            <div class="nav-label">Vận hành</div>
            <a class="nav-item active" href="${ctx}${baseUrl}"><span class="ic">▤</span> Bảng sản xuất</a>
            <a class="nav-item" href="${ctx}/NhaCungCap/quan-ly-san-pham.jsp"><span class="ic">🏷️</span> Sản phẩm</a>
            <a class="nav-item" href="${ctx}/NhaCungCap/don-hang"><span class="ic">📦</span> Đơn hàng</a>
            <a class="nav-item" href="${ctx}/NhaCungCap/thong-ke-doanh-thu.jsp"><span class="ic">📈</span> Doanh thu</a>
        </div>

        <div class="sidebar-foot">
            <div class="avatar">
                <c:out value="${fn:toUpperCase(fn:substring(sessionScope.currentUser.fullName, 0, 1))}"/>
            </div>
            <div>
                <strong><c:out value="${sessionScope.currentUser.fullName}"/></strong>
                <span>Người bán</span>
            </div>
        </div>
    </aside>

    <div class="main">
        <div class="topbar">
            <div>
                <h1><c:out value="${empty shopName ? 'Bảng điều khiển xưởng' : shopName}"/></h1>
                <div class="sub">Tổng quan hoạt động kinh doanh của xưởng · cập nhật từ cơ sở dữ liệu</div>
            </div>
            <div class="topbar-right">
                <a class="btn" href="${ctx}/NhaCungCap/don-hang">📦 Đơn hàng</a>
                <form method="post" action="${ctx}/logout" style="display:inline;">
                    <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                    <button class="btn" type="submit">Đăng xuất</button>
                </form>
            </div>
        </div>

        <div class="content">

            <c:if test="${not empty loadError}">
                <div class="alert" role="alert">
                    <span>⚠️</span>
                    <span><c:out value="${loadError}"/></span>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${noShop}">
                    <div class="panel">
                        <div class="empty-state">
                            <strong>Tài khoản chưa có xưởng in đang hoạt động</strong>
                            Hồ sơ xưởng (supplier_profiles) hoặc cửa hàng (shops) chưa được duyệt,
                            nên chưa thể xem số liệu kinh doanh. Vui lòng liên hệ quản trị viên.
                        </div>
                    </div>
                </c:when>
                <c:otherwise>

                    <!-- ===== KPI chính ===== -->
                    <div class="kpi-row">
                        <div class="kpi">
                            <div class="label">Sản phẩm đang kinh doanh <span>🏷️</span></div>
                            <div class="value num"><c:out value="${productActive}"/></div>
                            <div class="note">
                                Tổng <b><c:out value="${productTotal}"/></b> sản phẩm
                                <c:if test="${productHidden > 0}"> · <c:out value="${productHidden}"/> đang ẩn</c:if>
                                <c:if test="${productLowStock > 0}"> · <c:out value="${productLowStock}"/> sắp hết hàng</c:if>
                            </div>
                        </div>
                        <div class="kpi">
                            <div class="label">Tổng đơn hàng <span>📦</span></div>
                            <div class="value num"><c:out value="${orderTotal}"/></div>
                            <div class="note">
                                <c:out value="${orderCompleted}"/> đã giao ·
                                <c:out value="${orderCancelled}"/> đã hủy
                            </div>
                        </div>
                        <div class="kpi">
                            <div class="label">Đơn chờ xưởng xử lý <span>⏱</span></div>
                            <div class="value num" style="${orderPending > 0 ? 'color:var(--amber)' : ''}">
                                <c:out value="${orderPending}"/>
                            </div>
                            <div class="note">
                                <c:out value="${orderProcessing}"/> đơn đang xử lý / giao
                            </div>
                        </div>
                        <div class="kpi">
                            <div class="label">Doanh thu thực tế <span>💰</span></div>
                            <div class="value num money"><fmt:formatNumber value="${revenueTotal}" groupingUsed="true"/>đ</div>
                            <div class="note">Chỉ tính đơn đã giao (COMPLETED)</div>
                        </div>
                    </div>

                    <div class="kpi-row">
                        <div class="kpi">
                            <div class="label">Doanh thu hôm nay</div>
                            <div class="value num money"><fmt:formatNumber value="${revenueToday}" groupingUsed="true"/>đ</div>
                            <c:set var="diff" value="${revenueToday - revenueYesterday}"/>
                            <div class="note">
                                <c:choose>
                                    <c:when test="${revenueYesterday > 0}">
                                        <c:choose>
                                            <c:when test="${diff > 0}">
                                                <span class="delta up">▲</span>
                                                <fmt:formatNumber value="${diff}" groupingUsed="true"/>đ so với hôm qua
                                            </c:when>
                                            <c:when test="${diff < 0}">
                                                <span class="delta down">▼</span>
                                                <fmt:formatNumber value="${-diff}" groupingUsed="true"/>đ so với hôm qua
                                            </c:when>
                                            <c:otherwise><span class="delta flat">Bằng hôm qua</span></c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>Hôm qua chưa có đơn hoàn tất</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="kpi">
                            <div class="label">Doanh thu tháng này</div>
                            <div class="value num money"><fmt:formatNumber value="${revenueMonth}" groupingUsed="true"/>đ</div>
                            <div class="note">Từ ngày 01 đến hôm nay</div>
                        </div>
                        <div class="kpi">
                            <div class="label">Đơn hoàn tất</div>
                            <div class="value num"><c:out value="${orderCompleted}"/></div>
                            <div class="note">Đơn đã giao thành công</div>
                        </div>
                        <div class="kpi">
                            <div class="label">Đơn đang xử lý</div>
                            <div class="value num"><c:out value="${orderProcessing}"/></div>
                            <div class="note">Chờ xác nhận + đã xác nhận + đang giao</div>
                        </div>
                    </div>

                    <div class="range-note">
                        Doanh thu được tính từ <b>orders.total_amount</b> của đơn có trạng thái
                        <b>COMPLETED</b>; đơn chưa hoàn thành hoặc đã hủy không được cộng vào doanh thu.
                    </div>

                    <!-- ===== Điều hướng nhanh ===== -->
                    <div class="quick-links">
                        <a class="quick-link" href="${ctx}/NhaCungCap/quan-ly-san-pham.jsp">
                            <span class="ic">🏷️</span>
                            <span>Quản lý sản phẩm<small>Thêm, sửa giá, tồn kho, ẩn/hiện</small></span>
                        </a>
                        <a class="quick-link" href="${ctx}/NhaCungCap/don-hang">
                            <span class="ic">📦</span>
                            <span>Quản lý đơn hàng <c:if test="${orderPending > 0}">· <b>${orderPending}</b> chờ xử lý</c:if>
                                <small>Xem chi tiết, cập nhật trạng thái</small></span>
                        </a>
                        <a class="quick-link" href="${ctx}/NhaCungCap/thong-ke-doanh-thu.jsp">
                            <span class="ic">📈</span>
                            <span>Thống kê doanh thu<small>Lọc theo ngày, tuần, tháng</small></span>
                        </a>
                    </div>

                    <!-- ===== Biểu đồ ===== -->
                    <div class="cols" style="margin-bottom:24px;">
                        <div class="panel">
                            <div class="panel-head">
                                <div>
                                    <h3>Doanh thu 14 ngày gần nhất</h3>
                                    <div class="panel-subtitle">Đơn đã giao, theo ngày hoàn tất</div>
                                </div>
                                <a href="${ctx}/NhaCungCap/thong-ke-doanh-thu.jsp">Chi tiết →</a>
                            </div>
                            <div class="chart-box" id="revenueChart">
                                <div class="chart-state" id="revenueChartState">Đang tải dữ liệu…</div>
                            </div>
                        </div>

                        <div class="panel">
                            <div class="panel-head">
                                <div>
                                    <h3>Đơn hàng theo trạng thái</h3>
                                    <div class="panel-subtitle">Tất cả đơn của xưởng</div>
                                </div>
                            </div>
                            <div class="chart-box">
                                <c:choose>
                                    <c:when test="${orderTotal == 0}">
                                        <div class="chart-state">
                                            <strong>Chưa có đơn hàng</strong>
                                            Khi khách đặt hàng, trạng thái đơn sẽ hiển thị tại đây.
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="donut-wrap">
                                            <div class="donut" id="statusDonut">
                                                <div class="donut-center">
                                                    <strong><c:out value="${orderTotal}"/></strong>
                                                    <span>đơn hàng</span>
                                                </div>
                                            </div>
                                            <div class="legend" id="statusLegend"
                                                 data-pending="${orderPending}"
                                                 data-confirmed="${orderConfirmed}"
                                                 data-shipping="${orderShipping}"
                                                 data-completed="${orderCompleted}"
                                                 data-cancelled="${orderCancelled}"
                                                 data-total="${orderTotal}"></div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- ===== Cần xử lý + đơn mới nhất ===== -->
                    <div class="cols" style="margin-bottom:24px;">
                        <div class="panel">
                            <div class="panel-head">
                                <div>
                                    <h3>Đơn cần xưởng xử lý</h3>
                                    <div class="panel-subtitle">Đơn chờ xác nhận, cũ nhất trước</div>
                                </div>
                                <a href="${ctx}/NhaCungCap/don-hang?status=PENDING">Xem tất cả →</a>
                            </div>
                            <c:choose>
                                <c:when test="${empty pendingOrders}">
                                    <div class="empty-state">
                                        <strong>Không có đơn nào chờ xử lý</strong>
                                        Mọi đơn hàng đã được xưởng tiếp nhận.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${pendingOrders}" var="o">
                                        <div class="attention-row">
                                            <span class="rank top">#</span>
                                            <div class="txt">
                                                <strong><c:out value="${o.orderCode}"/> · <fmt:formatNumber value="${o.totalAmount}" groupingUsed="true"/>đ</strong>
                                                <span><c:out value="${o.recipientName}"/> · <c:out value="${o.createdAtText}"/></span>
                                            </div>
                                            <a class="mini-btn primary" href="${ctx}/NhaCungCap/don-hang?status=PENDING">Xử lý</a>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="panel">
                            <div class="panel-head">
                                <div>
                                    <h3>Đơn hàng mới nhất</h3>
                                    <div class="panel-subtitle">5 đơn gần đây</div>
                                </div>
                                <a href="${ctx}/NhaCungCap/don-hang">Tất cả →</a>
                            </div>
                            <c:choose>
                                <c:when test="${empty recentOrders}">
                                    <div class="empty-state">
                                        <strong>Xưởng chưa có đơn hàng</strong>
                                        Đơn của khách sẽ xuất hiện tại đây ngay khi được đặt.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-wrap">
                                        <table style="min-width:420px;">
                                            <thead>
                                            <tr>
                                                <th>Mã đơn</th>
                                                <th>Khách</th>
                                                <th>Giá trị</th>
                                                <th>Trạng thái</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach items="${recentOrders}" var="o">
                                                <tr>
                                                    <td>
                                                        <a class="link-plain" href="${o.detailUrl}">#<c:out value="${o.orderCode}"/></a>
                                                        <div class="table-note"><c:out value="${o.createdAtText}"/></div>
                                                    </td>
                                                    <td><c:out value="${o.recipientName}"/></td>
                                                    <td class="money-cell"><fmt:formatNumber value="${o.totalAmount}" groupingUsed="true"/>đ</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${o.status == 'PENDING'}"><span class="pill amber"><span class="dot"></span>Chờ xác nhận</span></c:when>
                                                            <c:when test="${o.status == 'CONFIRMED'}"><span class="pill blue"><span class="dot"></span>Đã xác nhận</span></c:when>
                                                            <c:when test="${o.status == 'SHIPPING'}"><span class="pill blue"><span class="dot"></span>Đang giao</span></c:when>
                                                            <c:when test="${o.status == 'COMPLETED'}"><span class="pill green"><span class="dot"></span>Đã giao</span></c:when>
                                                            <c:otherwise><span class="pill red"><span class="dot"></span>Đã hủy</span></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- ===== Sản phẩm ===== -->
                    <div class="cols" style="margin-bottom:24px;">
                        <div class="panel">
                            <div class="panel-head">
                                <div>
                                    <h3>Sản phẩm mới cập nhật</h3>
                                    <div class="panel-subtitle">5 sản phẩm gần đây của xưởng</div>
                                </div>
                                <a href="${ctx}/NhaCungCap/quan-ly-san-pham.jsp">Quản lý →</a>
                            </div>
                            <c:choose>
                                <c:when test="${empty recentProducts}">
                                    <div class="empty-state">
                                        <strong>Xưởng chưa có sản phẩm</strong>
                                        Thêm sản phẩm đầu tiên để bắt đầu bán hàng.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-wrap">
                                        <table style="min-width:420px;">
                                            <thead>
                                            <tr>
                                                <th>Sản phẩm</th>
                                                <th>Giá</th>
                                                <th>Tồn</th>
                                                <th>Trạng thái</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach items="${recentProducts}" var="p">
                                                <tr>
                                                    <td>
                                                        <strong><c:out value="${p.name}"/></strong>
                                                        <div class="table-note"><c:out value="${p.updatedAtText}"/></div>
                                                    </td>
                                                    <td class="money-cell"><fmt:formatNumber value="${p.price}" groupingUsed="true"/>đ</td>
                                                    <td>
                                                        <c:out value="${p.stock}"/>
                                                        <c:if test="${p.status == 'ACTIVE' and p.stock == 0}">
                                                            <span class="pill red"><span class="dot"></span>Hết hàng</span>
                                                        </c:if>
                                                        <c:if test="${p.status == 'ACTIVE' and p.stock > 0 and p.stock <= 5}">
                                                            <span class="pill amber"><span class="dot"></span>Sắp hết</span>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${p.status == 'ACTIVE'}"><span class="pill green"><span class="dot"></span>Đang bán</span></c:when>
                                                            <c:otherwise><span class="pill gray"><span class="dot"></span>Đã ẩn</span></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="panel">
                            <div class="panel-head">
                                <div>
                                    <h3>Sản phẩm bán chạy</h3>
                                    <div class="panel-subtitle">Theo số lượng bán, <c:out value="${topProductDays}"/> ngày gần nhất</div>
                                </div>
                            </div>
                            <c:choose>
                                <c:when test="${empty topProducts}">
                                    <div class="empty-state">
                                        <strong>Chưa có dữ liệu bán hàng</strong>
                                        Thống kê xuất hiện sau khi có đơn đã giao trong <c:out value="${topProductDays}"/> ngày.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-wrap">
                                        <table style="min-width:420px;">
                                            <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Sản phẩm</th>
                                                <th>Đã bán</th>
                                                <th>Doanh thu</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach items="${topProducts}" var="t" varStatus="st">
                                                <tr>
                                                    <td><span class="rank ${st.index == 0 ? 'top' : ''}">${st.index + 1}</span></td>
                                                    <td><strong><c:out value="${t.name}"/></strong></td>
                                                    <td class="num"><c:out value="${t.quantity}"/></td>
                                                    <td class="money-cell"><fmt:formatNumber value="${t.revenue}" groupingUsed="true"/>đ</td>
                                                </tr>
                                            </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                </c:otherwise>
            </c:choose>

        </div>
    </div>
</div>

<script>
(function () {
    'use strict';

    /* ---------- Donut: đơn theo trạng thái (số liệu do servlet truy vấn từ DB) ---------- */
    var legend = document.getElementById('statusLegend');
    if (legend) {
        var total = Number(legend.getAttribute('data-total')) || 0;
        var items = [
            { key: 'pending', label: 'Chờ xác nhận', cls: 'amber' },
            { key: 'confirmed', label: 'Đã xác nhận', cls: 'blue' },
            { key: 'shipping', label: 'Đang giao', cls: 'blue' },
            { key: 'completed', label: 'Đã giao', cls: 'green' },
            { key: 'cancelled', label: 'Đã hủy', cls: 'red' }
        ];
        var palette = {
            pending: '#E8590C', confirmed: '#5C7CFA', shipping: '#22B8CF',
            completed: '#2F9E44', cancelled: '#E03131'
        };
        var stops = [];
        var legendHtml = '';
        var start = 0;
        items.forEach(function (item) {
            var count = Number(legend.getAttribute('data-' + item.key)) || 0;
            if (count <= 0) return;
            var deg = total > 0 ? (count / total) * 360 : 0;
            stops.push(palette[item.key] + ' ' + start + 'deg ' + (start + deg) + 'deg');
            start += deg;
            legendHtml += '<div class="legend-row">'
                + '<span class="sw" style="background:' + palette[item.key] + '"></span>'
                + '<span class="lbl">' + item.label + '</span>'
                + '<b>' + count + ' · ' + Math.round((count / total) * 100) + '%</b>'
                + '</div>';
        });
        legend.innerHTML = legendHtml;
        var donut = document.getElementById('statusDonut');
        if (donut && stops.length) {
            donut.style.background = 'conic-gradient(' + stops.join(',') + ')';
        }
    }

    /* ---------- Biểu đồ doanh thu: lấy từ /nhacungcap/api/stats/revenue ---------- */
    var box = document.getElementById('revenueChart');
    if (!box) return;

    var API = (document.querySelector('meta[name="stats-api"]') || {}).content;
    if (!API) return;

    function isoDate(d) {
        var m = String(d.getMonth() + 1).padStart(2, '0');
        var day = String(d.getDate()).padStart(2, '0');
        return d.getFullYear() + '-' + m + '-' + day;
    }

    function money(v) {
        return Number(v || 0).toLocaleString('vi-VN') + 'đ';
    }

    var to = new Date();
    var from = new Date();
    from.setDate(from.getDate() - 13);

    box.innerHTML = '<div class="chart-state">Đang tải dữ liệu…</div>';

    fetch(API + '/revenue?from=' + isoDate(from) + '&to=' + isoDate(to) + '&group=day',
        { headers: { 'Accept': 'application/json' }, credentials: 'same-origin' })
        .then(function (res) {
            return res.json().catch(function () { return {}; }).then(function (data) {
                if (!res.ok) throw new Error(data.error || 'Không tải được biểu đồ doanh thu.');
                return data;
            });
        })
        .then(function (data) {
            var buckets = data.buckets || [];
            var hasRevenue = buckets.some(function (b) { return Number(b.revenue) > 0; });
            if (!buckets.length || !hasRevenue) {
                box.innerHTML = '<div class="chart-state"><strong>Chưa có doanh thu trong 14 ngày</strong>'
                    + 'Biểu đồ sẽ hiển thị khi có đơn hàng được giao thành công.</div>';
                return;
            }
            var max = 0;
            buckets.forEach(function (b) { max = Math.max(max, Number(b.revenue) || 0); });

            var html = '<div class="bar-chart">';
            buckets.forEach(function (b) {
                var value = Number(b.revenue) || 0;
                var h = max > 0 ? Math.max(2, Math.round((value / max) * 100)) : 2;
                html += '<div class="bar-col" title="' + (b.title || b.label) + ': ' + money(value)
                    + ' · ' + (b.orders || 0) + ' đơn">'
                    + '<span class="bar-val">' + (value > 0 ? (value >= 1000000
                        ? (value / 1000000).toFixed(1) + 'tr' : Math.round(value / 1000) + 'k') : '') + '</span>'
                    + '<div class="bar" style="height:' + h + '%"></div>'
                    + '<span class="bar-lbl">' + b.label + '</span>'
                    + '</div>';
            });
            html += '</div>';
            box.innerHTML = html;
        })
        .catch(function (err) {
            box.innerHTML = '<div class="chart-state"><strong>Không tải được biểu đồ</strong>'
                + String(err.message).replace(/</g, '&lt;')
                + '</div>';
        });
})();
</script>
</body>
</html>
