<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%--
  Trang "Xin làm Nhà cung cấp" cho tài khoản CUSTOMER.
  Dữ liệu do SupplierRequestServlet nạp:
    profile        : ProfileView (tên/email đang đăng nhập)
    supplierRequest: SupplierRequestView hoặc null (chưa từng gửi)
    form / errors  : giá trị form + lỗi từng trường
  Trạng thái yêu cầu đọc từ DB (supplier_requests), không dùng JS/localStorage.
--%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <title>PrintKraft — Xin làm Nhà cung cấp</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=IBM+Plex+Sans:wght@400;500;600&family=IBM+Plex+Mono:wght@400;500&family=Barlow+Condensed:wght@600;700&family=Barlow:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/assets/css/auth.css">
</head>
<body data-t="kh">

<main class="screen on kh" id="supplier-request">
    <div class="card w">
        <p style="margin-bottom:16px"><a class="ln" href="${ctx}/profile">← Thông tin tài khoản</a></p>

        <div class="who">
            <div class="av"><c:out value="${profile.initials}"/></div>
            <div style="flex:1">
                <b><c:out value="${profile.displayName}"/></b>
                <span><c:out value="${profile.email}"/></span>
            </div>
        </div>

        <c:if test="${not empty success}">
            <div class="alert success" role="status"><c:out value="${success}"/></div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert error" role="alert"><c:out value="${error}"/></div>
        </c:if>

        <%-- ============ ĐANG CHỜ DUYỆT ============ --%>
        <c:if test="${supplierRequest.status == 'PENDING'}">
            <h3>Yêu cầu đang chờ duyệt</h3>
            <p class="sub">
                PrintKraft đã nhận yêu cầu của bạn. Admin sẽ xem xét và phản hồi, bạn không cần gửi lại.
            </p>
            <div class="field">
                <label>Tên cửa hàng / xưởng in</label>
                <input type="text" value="<c:out value='${supplierRequest.shopName}'/>" readonly>
            </div>
            <div class="row">
                <div class="field">
                    <label>Số điện thoại liên hệ</label>
                    <input type="text" value="<c:out value='${supplierRequest.contactPhone}'/>" readonly>
                </div>
                <div class="field">
                    <label>Ngày gửi</label>
                    <input type="text" value="<c:out value='${supplierRequest.submittedAt}'/>" readonly>
                </div>
            </div>
            <div class="field">
                <label>Địa chỉ xưởng</label>
                <input type="text" value="<c:out value='${supplierRequest.address}'/>" readonly>
            </div>
            <c:if test="${not empty supplierRequest.description}">
                <div class="field">
                    <label>Thông tin bổ sung</label>
                    <textarea rows="3" readonly><c:out value="${supplierRequest.description}"/></textarea>
                </div>
            </c:if>
        </c:if>

        <%-- ============ ĐÃ ĐƯỢC DUYỆT ============ --%>
        <c:if test="${supplierRequest.status == 'APPROVED'}">
            <h3>Bạn đã là Nhà cung cấp</h3>
            <div class="alert success" role="status">
                Yêu cầu cho cửa hàng “<c:out value="${supplierRequest.shopName}"/>” đã được duyệt.
            </div>
            <div class="actions">
                <a class="btn auto" href="${ctx}/NhaCungCap/dashBoard.jsp">Vào trang Nhà cung cấp</a>
            </div>
        </c:if>

        <%-- ============ BỊ TỪ CHỐI ============ --%>
        <c:if test="${supplierRequest.status == 'REJECTED'}">
            <h3>Yêu cầu bị từ chối</h3>
            <div class="alert error" role="alert">
                <strong><c:out value="${supplierRequest.statusLabel}"/></strong>
                <c:if test="${not empty supplierRequest.rejectReason}">
                    — Lý do: <c:out value="${supplierRequest.rejectReason}"/>
                </c:if>
            </div>
            <p class="sub">Bạn có thể bổ sung thông tin và gửi lại yêu cầu bên dưới.</p>
        </c:if>

        <%-- ============ FORM GỬI / GỬI LẠI ============ --%>
        <c:if test="${empty supplierRequest or supplierRequest.status == 'REJECTED'}">
            <form method="post" action="${ctx}/xin-lam-nha-cung-cap">
                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">

                <c:if test="${empty supplierRequest}">
                    <h3>Xin làm Nhà cung cấp</h3>
                    <p class="sub">
                        Gửi hồ sơ xưởng in của bạn để Admin xét duyệt. Tài khoản vẫn giữ vai trò
                        khách hàng cho đến khi yêu cầu được duyệt.
                    </p>
                </c:if>

                <div class="row">
                    <div class="field${not empty errors.shopName ? ' has-err' : ''}">
                        <label for="s1">Tên cửa hàng / xưởng in</label>
                        <input id="s1" name="shopName" type="text" maxlength="150"
                               value="<c:out value='${form.shopName}'/>"
                               placeholder="Ví dụ: Xưởng in 3D Sài Gòn" required>
                        <c:if test="${not empty errors.shopName}"><p class="err"><c:out value="${errors.shopName}"/></p></c:if>
                    </div>
                    <div class="field${not empty errors.contactPhone ? ' has-err' : ''}">
                        <label for="s2">Số điện thoại liên hệ</label>
                        <input id="s2" name="contactPhone" type="tel" maxlength="20"
                               value="<c:out value='${form.contactPhone}'/>"
                               placeholder="0901234567" pattern="0[0-9]{9}"
                               title="10 số, bắt đầu bằng 0" required>
                        <c:if test="${not empty errors.contactPhone}"><p class="err"><c:out value="${errors.contactPhone}"/></p></c:if>
                    </div>
                </div>

                <div class="field${not empty errors.address ? ' has-err' : ''}">
                    <label for="s3">Địa chỉ xưởng</label>
                    <input id="s3" name="address" type="text" maxlength="300"
                           value="<c:out value='${form.address}'/>"
                           placeholder="Số nhà, đường, phường/quận, tỉnh/thành" required>
                    <c:if test="${not empty errors.address}"><p class="err"><c:out value="${errors.address}"/></p></c:if>
                </div>

                <div class="field${not empty errors.description ? ' has-err' : ''}">
                    <label for="s4">Thông tin bổ sung (không bắt buộc)</label>
                    <textarea id="s4" name="description" rows="3" maxlength="2000"
                              placeholder="Năng lực sản xuất, công nghệ in, vật liệu..."><c:out value="${form.description}"/></textarea>
                    <c:if test="${not empty errors.description}"><p class="err"><c:out value="${errors.description}"/></p></c:if>
                </div>

                <div class="actions">
                    <button class="btn auto" type="submit">Gửi yêu cầu duyệt</button>
                </div>
            </form>
        </c:if>
    </div>
</main>

<script src="${ctx}/assets/js/auth.js"></script>
</body>
</html>
