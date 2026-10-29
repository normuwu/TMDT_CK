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
    <title>Quản lý đơn hàng — PrintKraft Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/Admin/admin.css">
    <style>
        .alert.ok{background:#EBFBEE; border-color:#B2F2BB; color:#2B8A3E;}
        .alert.err{background:#FFF0F0; border-color:#FFC9C9; color:#C92A2A;}
        .status-form{display:flex; gap:6px; align-items:center; flex-wrap:wrap;}
        .status-form select,
        .status-form input{border:1px solid var(--line); border-radius:7px; padding:6px 8px; font-size:12px; background:white; font-family:inherit;}
        .status-form input{width:130px;}
        .status-form select:focus,
        .status-form input:focus{outline:none; border-color:var(--cobalt);}
        .table-wrap table{min-width:980px;}
        .thanks-note{font-size:12px; color:var(--muted); font-style:italic;}
    </style>
</head>
<body>
<div class="layout">

    <aside class="sidebar">
        <div class="brand"><span class="sq"></span> PrintKraft Admin</div>

        <div class="nav-group">
            <div class="nav-label">Tổng quan</div>
            <a class="nav-item" href="admin.jsp#dashboard"><span class="ic">▤</span> Bảng điều khiển</a>
            <a class="nav-item" href="admin.jsp#reports"><span class="ic">📈</span> Báo cáo &amp; Doanh thu</a>
        </div>
        <div class="nav-group">
            <div class="nav-label">Vận hành</div>
            <a class="nav-item" href="admin.jsp#products"><span class="ic">🏷️</span> Sản phẩm</a>
            <a class="nav-item active" href="${ctx}/Admin/quan-ly-don-hang"><span class="ic">📦</span> Đơn hàng</a>
            <a class="nav-item" href="admin.jsp#suppliers"><span class="ic">🏭</span> Xưởng in đối tác</a>
            <a class="nav-item" href="admin-ncc.jsp"><span class="ic">🏢</span> Nhà cung cấp</a>
            <a class="nav-item" href="admin-inventory.jsp"><span class="ic">▦</span> Quản lý kho</a>
            <a class="nav-item" href="admin-contracts.jsp"><span class="ic">§</span> Hợp đồng</a>
            <a class="nav-item" href="admin.jsp#disputes"><span class="ic">⚠️</span> Tranh chấp
                <span style="margin-left:auto; background:var(--red); color:white; font-size:10px; padding:1px 6px; border-radius:999px;">4</span>
            </a>
        </div>
        <div class="nav-group">
            <div class="nav-label">Truy cập</div>
            <a class="nav-item" href="admin-users.jsp"><span class="ic">👥</span> Quản lý người dùng</a>
            <a class="nav-item" href="admin-rbac.jsp"><span class="ic">🔐</span> Phân quyền RBAC</a>
            <a class="nav-item" href="admin.jsp#buyers"><span class="ic">🛍️</span> Người mua</a>
            <a class="nav-item" href="admin.jsp#staff"><span class="ic">🧑‍💼</span> Nhân sự nội bộ</a>
        </div>
        <div class="nav-group">
            <div class="nav-label">Hệ thống</div>
            <a class="nav-item" href="admin-platform.jsp"><span class="ic">◈</span> Quản lý nền tảng</a>
            <a class="nav-item" href="admin-notifications.jsp"><span class="ic">🔔</span> Thông báo</a>
            <a class="nav-item" href="admin.jsp#settings"><span class="ic">⚙️</span> Cấu hình</a>
            <a class="nav-item" href="admin.jsp#logs"><span class="ic">📜</span> Nhật ký hoạt động</a>
        </div>

        <div class="sidebar-foot">
            <div class="avatar">
                <c:out value="${fn:toUpperCase(fn:substring(sessionScope.currentUser.fullName, 0, 1))}"/>
            </div>
            <div>
                <strong><c:out value="${sessionScope.currentUser.fullName}"/></strong>
                <span><c:out value="${sessionScope.currentUser.role}"/></span>
            </div>
        </div>
    </aside>

    <div class="main">
        <div class="topbar">
            <div>
                <h1>Quản lý đơn hàng</h1>
                <div class="sub">
                    <c:choose>
                        <c:when test="${isAdmin}">Toàn bộ đơn hàng trên hệ thống</c:when>
                        <c:otherwise>Đơn hàng thuộc cửa hàng của bạn</c:otherwise>
                    </c:choose>
                    · Chờ xác nhận → Đã xác nhận → Đang giao hàng → Đã giao hàng (có thể hủy khi chưa giao)
                </div>
            </div>
            <div class="topbar-right">
                <a class="btn" href="${ctx}/KhachHang/trang_chu.jsp">← Trang bán hàng</a>
                <form method="post" action="${ctx}/logout" style="display:inline;">
                    <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                    <button class="btn" type="submit">Đăng xuất</button>
                </form>
            </div>
        </div>

        <div class="content">

            <c:if test="${not empty success or not empty error}">
                <c:if test="${not empty success}">
                    <div class="alert ok" role="status"><span>✓</span><span><c:out value="${success}"/></span></div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert err" role="alert"><span>⚠️</span><span><c:out value="${error}"/></span></div>
                </c:if>
            </c:if>

            <div class="section-grid">
                <div class="metric-card">
                    <div>
                        <div class="metric-title">Tổng đơn hàng</div>
                        <div class="metric-value num"><c:out value="${totalCount}"/></div>
                        <div class="metric-note">Tất cả đơn đang có trong hệ thống</div>
                    </div>
                    <div class="metric-icon">📦</div>
                </div>
                <div class="metric-card">
                    <div>
                        <div class="metric-title">Chờ xác nhận</div>
                        <div class="metric-value num"><c:out value="${pendingCount}"/></div>
                        <div class="metric-note">Đơn mới cần Admin duyệt</div>
                    </div>
                    <div class="metric-icon amber">⏱</div>
                </div>
                <div class="metric-card">
                    <div>
                        <div class="metric-title">Đang xử lý / giao</div>
                        <div class="metric-value num"><c:out value="${activeCount}"/></div>
                        <div class="metric-note">Đơn đã xác nhận hoặc đang giao</div>
                    </div>
                    <div class="metric-icon green">✓</div>
                </div>
            </div>

            <div class="panel">
                <div class="panel-head">
                    <div>
                        <h3>Danh sách đơn hàng</h3>
                        <div class="panel-subtitle">Dữ liệu đọc trực tiếp từ bảng orders / order_items</div>
                    </div>
                    <div class="inline-actions">
                        <a class="btn" href="${ctx}/Admin/quan-ly-don-hang">↻ Tải lại</a>
                    </div>
                </div>

                <form method="get" action="${ctx}/Admin/quan-ly-don-hang" class="toolbar">
                    <label for="statusFilter" style="font-size:12.5px; color:var(--muted); font-weight:600;">Lọc theo trạng thái</label>
                    <select id="statusFilter" name="status">
                        <option value="">Tất cả trạng thái</option>
                        <c:forEach items="${statuses}" var="s">
                            <option value="${s.code}" <c:if test="${selectedStatus == s.code}">selected</c:if>>
                                <c:out value="${s.label}"/>
                            </option>
                        </c:forEach>
                    </select>
                    <button type="submit" class="btn primary">Lọc</button>
                </form>

                <c:choose>
                    <c:when test="${empty orders}">
                        <div class="empty-state">
                            <strong>Không có đơn hàng nào</strong>
                            Chưa có đơn phù hợp với bộ lọc hiện tại.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-wrap">
                            <table>
                                <thead>
                                <tr>
                                    <th>Mã đơn</th>
                                    <th>Khách hàng</th>
                                    <th>Xưởng in</th>
                                    <th>Trạng thái</th>
                                    <th>Giá trị</th>
                                    <th>Ngày tạo</th>
                                    <th>Thao tác</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${orders}" var="o">
                                    <tr>
                                        <td>
                                            <div class="order-id">#<c:out value="${o.orderCode}"/></div>
                                            <div class="table-note">
                                                <a href="${ctx}/KhachHang/chi-tiet-don-hang?id=${o.orderId}"
                                                   style="color:var(--cobalt); font-weight:600;">Xem chi tiết →</a>
                                            </div>
                                        </td>
                                        <td>
                                            <strong><c:out value="${o.customerName}"/></strong>
                                            <div class="table-note"><c:out value="${o.recipientName}"/> · <c:out value="${o.recipientPhone}"/></div>
                                        </td>
                                        <td>
                                            <div class="supplier-cell">
                                                <span class="sq"><c:out value="${fn:toUpperCase(fn:substring(o.shopName, 0, 1))}"/></span>
                                                <c:out value="${o.shopName}"/>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${o.status.code == 'PENDING'}"><span class="pill amber"><span class="dot"></span><c:out value="${o.status.label}"/></span></c:when>
                                                <c:when test="${o.status.code == 'CONFIRMED'}"><span class="pill blue"><span class="dot"></span><c:out value="${o.status.label}"/></span></c:when>
                                                <c:when test="${o.status.code == 'SHIPPING'}"><span class="pill blue"><span class="dot"></span><c:out value="${o.status.label}"/></span></c:when>
                                                <c:when test="${o.status.code == 'COMPLETED'}"><span class="pill green"><span class="dot"></span><c:out value="${o.status.label}"/></span></c:when>
                                                <c:otherwise><span class="pill red"><span class="dot"></span><c:out value="${o.status.label}"/></span></c:otherwise>
                                            </c:choose>
                                            <div class="table-note">
                                                <c:choose>
                                                    <c:when test="${o.paymentMethod.code == 'BANK_TRANSFER'}">Chuyển khoản</c:when>
                                                    <c:otherwise>COD</c:otherwise>
                                                </c:choose>
                                                · <c:out value="${o.paymentStatus.label}"/>
                                            </div>
                                        </td>
                                        <td class="num">
                                            <b><fmt:formatNumber value="${o.totalAmount}" groupingUsed="true"/>đ</b>
                                            <c:if test="${o.discountAmount > 0}">
                                                <div class="table-note">Đã giảm <fmt:formatNumber value="${o.discountAmount}" groupingUsed="true"/>đ</div>
                                            </c:if>
                                        </td>
                                        <td class="mono"><c:out value="${o.createdAtText}"/></td>
                                        <td>
                                            <div class="action-menu">
                                                <c:choose>
                                                    <c:when test="${empty nextStatusMap[o.orderId]}">
                                                        <span class="thanks-note">Không còn bước tiếp theo</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form method="post" action="${ctx}/Admin/quan-ly-don-hang" class="status-form js-status-form">
                                                            <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                                                            <input type="hidden" name="action" value="update">
                                                            <input type="hidden" name="orderId" value="${o.orderId}">
                                                            <input type="hidden" name="filter" value="<c:out value='${selectedStatus}'/>">
                                                            <select name="status" aria-label="Trạng thái mới cho đơn #<c:out value='${o.orderCode}'/>">
                                                                <c:forEach items="${nextStatusMap[o.orderId]}" var="s">
                                                                    <option value="${s.code}"><c:out value="${s.label}"/></option>
                                                                </c:forEach>
                                                            </select>
                                                            <input type="text" name="note" maxlength="300" placeholder="Ghi chú (không bắt buộc)">
                                                            <button type="submit" class="mini-btn primary">Cập nhật</button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <div class="table-footer">
                            <span><c:out value="${fn:length(orders)}"/> đơn hàng</span>
                            <span>Trạng thái đơn và trạng thái thanh toán là hai nghiệp vụ riêng; mọi thay đổi được ghi vào order_status_history.</span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
    </div>
</div>

<script>
    /* Tránh bấm đúp: lần gửi thứ hai sẽ bị từ chối vì trạng thái đã đổi. */
    document.querySelectorAll('.js-status-form').forEach(function (form) {
        form.addEventListener('submit', function () {
            var btn = form.querySelector('button[type="submit"]');
            if (btn) {
                btn.disabled = true;
                btn.textContent = 'Đang cập nhật…';
            }
        });
    });
</script>
</body>
</html>
