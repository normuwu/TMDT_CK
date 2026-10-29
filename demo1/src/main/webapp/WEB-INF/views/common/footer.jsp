<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
  Footer dùng chung, kèm lớp phủ (#overlay) và thông báo (#toast) mà site.js cần.
  Cách dùng (đặt cuối <body>, TRƯỚC thẻ <script src=".../site.js">):
      <jsp:include page="/WEB-INF/views/common/footer.jsp"/>
--%>
<c:set var="kh" value="${pageContext.request.contextPath}/KhachHang"/>

<footer>
    <div class="foot-inner">
        <div>
            <div class="logo" style="margin-bottom:16px;"><span class="mark"></span> PrintKraft</div>
            <p style="font-size:13.5px;color:var(--ink-soft);max-width:34ch;">Nền tảng in theo yêu cầu kết nối khách hàng với hơn 120 xưởng in đối tác trên toàn quốc.</p>
            <div class="foot-social"><span>Facebook</span><span>Instagram</span><span>Zalo</span></div>
        </div>
        <div>
            <h5>Sản phẩm</h5>
            <ul>
                <li><a href="${kh}/san-pham">Tất cả sản phẩm</a></li>
                <li><a href="${kh}/dat_in_3d.jsp">Áo thun &amp; Hoodie</a></li>
                <li><a href="${kh}/dat_in_3d.jsp">Cốc &amp; Bình giữ nhiệt</a></li>
                <li><a href="${kh}/dat_in_3d.jsp">Poster &amp; Canvas</a></li>
                <li><a href="${kh}/dat_in_3d.jsp">Bao bì &amp; Nhãn dán</a></li>
                <li><a href="${kh}/trang_chu.jsp">Quà tặng doanh nghiệp</a></li>
            </ul>
        </div>
        <div>
            <h5>Hỗ trợ</h5>
            <ul>
                <li><a href="${kh}/lien-he.jsp">Trung tâm trợ giúp</a></li>
                <li><a href="${ctx}/KhachHang/lich-su-mua-hang">Theo dõi đơn hàng</a></li>
                <li><a href="${kh}/phan-hoi.jsp">Gửi phản hồi</a></li>
                <li><a href="${kh}/danh-muc-yeu-thich.jsp">Danh mục yêu thích</a></li>
                <li><a href="${kh}/lien-he.jsp">Chính sách đổi trả</a></li>
                <li><a href="${kh}/lien-he.jsp">Chính sách bảo mật</a></li>
                <li><a href="${kh}/lien-he.jsp">Điều khoản sử dụng</a></li>
            </ul>
        </div>
        <div>
            <h5>Liên hệ</h5>
            <ul>
                <li>Hotline: 1900 6868</li>
                <li>Email: hi@printkraft.vn</li>
                <li>Văn phòng: 128 Nguyễn Đình Chiểu, Q.3, TP.HCM</li>
                <li>Giờ làm việc: 8:00 – 21:00</li>
            </ul>
        </div>
    </div>
    <div class="foot-bottom">
        <span>© 2026 PrintKraft. Nền tảng in theo yêu cầu.</span>
        <span>Điều khoản · Bảo mật · Hỗ trợ khách hàng</span>
    </div>
</footer>

<%-- Lớp phủ mờ cho ngăn kéo giỏ hàng và các modal; thông báo nổi --%>
<div class="overlay" id="overlay" onclick="closeAll()"></div>
<div class="toast" id="toast" role="status" aria-live="polite"></div>
