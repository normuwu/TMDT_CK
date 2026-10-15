<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Supplier registration UI only. Out of scope of the auth backend (needs extra DB columns: tax code, representative, license). --%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
    <title>PrintKraft Xưởng — Đăng ký nhà cung cấp</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=IBM+Plex+Sans:wght@400;500;600&family=IBM+Plex+Mono:wght@400;500&family=Barlow+Condensed:wght@600;700&family=Barlow:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body data-t="xu">

<main class="screen on xu" id="ncc" data-t="xu">
    <div class="card x">
        <div class="logo"><span class="mark"></span><div>PrintKraft Xưởng<small>Đăng ký nhà cung cấp</small></div></div>
        <h2>Đưa xưởng của bạn lên PrintKraft</h2>
        <p class="sub">Nhận đơn in 3D từ khách hàng trên toàn quốc. Hồ sơ được duyệt trong 1–2 ngày làm việc.</p>
        <form data-msg="Đã gửi hồ sơ. Chúng tôi sẽ phản hồi qua email trong 1–2 ngày làm việc.">
            <div class="row">
                <div class="field"><label for="n1">Tên xưởng</label><input id="n1" type="text" placeholder="Sài Gòn Print" required></div>
                <div class="field"><label for="n2">Mã số thuế</label><input id="n2" type="text" placeholder="0312345678" required></div>
            </div>
            <div class="row">
                <div class="field"><label for="n3">Người đại diện</label><input id="n3" type="text" placeholder="Trần Quốc Bảo" required></div>
                <div class="field"><label for="n4">Số điện thoại</label><input id="n4" type="tel" placeholder="0901 234 567" required></div>
            </div>
            <div class="row">
                <div class="field"><label for="n5">Email đăng nhập</label><input id="n5" type="email" placeholder="xuong@email.com" required></div>
                <div class="field"><label for="n6">Mật khẩu</label><input id="n6" type="password" minlength="8" placeholder="Tối thiểu 8 ký tự" required></div>
            </div>
            <div class="row">
                <div class="field"><label for="n7">Khu vực</label><select id="n7"><option>TP. Hồ Chí Minh</option><option>Hà Nội</option><option>Đà Nẵng</option><option>Khác</option></select></div>
                <div class="field"><label for="n8">Địa chỉ xưởng</label><input id="n8" type="text" placeholder="Số nhà, đường, phường" required></div>
            </div>
            <h3>Năng lực sản xuất</h3>
            <div class="lab">Công nghệ in</div>
            <div class="chips" style="margin-bottom:16px"><button type="button" class="chip on">FDM</button><button type="button" class="chip">Resin</button><button type="button" class="chip">SLS</button></div>
            <div class="lab">Vật liệu</div>
            <div class="chips" style="margin-bottom:16px"><button type="button" class="chip on">PLA</button><button type="button" class="chip on">PETG</button><button type="button" class="chip">ABS</button><button type="button" class="chip">Resin tiêu chuẩn</button><button type="button" class="chip">Nylon</button></div>
            <div class="lab">Giấy phép kinh doanh</div>
            <div class="drop">Kéo thả file vào đây hoặc <b>chọn từ máy</b><br>PDF, JPG hoặc PNG, tối đa 10 MB</div>
            <label class="chk" style="margin-top:16px"><input type="checkbox" required> Tôi đồng ý với <a class="ln">Điều khoản dành cho nhà cung cấp</a></label>
            <button class="btn">Gửi hồ sơ duyệt</button>
        </form>
        <div class="foot"><p>Đã có tài khoản xưởng? <a class="ln" href="Đăng-nhập.jsp">Đăng nhập</a></p></div>
    </div>
</main>

<div class="toast" id="toast" role="status"></div>

<script src="${pageContext.request.contextPath}/assets/js/auth.js"></script>
</body>
</html>
