<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, com.tmdt.model.Product" %>
<%
    // Mở thẳng trang_chu.jsp mà chưa có dữ liệu → nhờ HomeServlet nạp rồi quay lại đây.
    if (request.getAttribute("newestProducts") == null) {
        request.getRequestDispatcher("/trang-chu").forward(request, response);
        return;
    }
    String ctx = request.getContextPath();
    List<Product> newestProducts = (List<Product>) request.getAttribute("newestProducts");
    List<Product> bestSellingProducts = (List<Product>) request.getAttribute("bestSellingProducts");
%>
<%!
    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }

    private static String money(long v) {
        return String.format("%,d", v).replace(',', '.') + "đ";
    }

    /** Vẽ một thẻ sản phẩm. */
    private static String card(Product p, String ctx, boolean showSold) {
        String thumb = p.getThumbnailUrl();
        String img;
        if (thumb == null || thumb.isBlank()) {
            img = "<div class=\"prod-noimg\">PrintKraft</div>";
        } else {
            String src = thumb.startsWith("http") ? thumb
                    : ctx + (thumb.startsWith("/") ? "" : "/") + thumb;
            img = "<img src=\"" + esc(src) + "\" alt=\"" + esc(p.getName()) + "\" loading=\"lazy\">";
        }
        // TODO: đổi đường dẫn trang chi tiết cho đúng với project của bạn.
        String href = ctx + "/chi-tiet-san-pham?id=" + p.getProductId();

        StringBuilder sb = new StringBuilder();
        sb.append("<a class=\"prod-card\" href=\"").append(href).append("\">");
        sb.append("<div class=\"prod-thumb\">").append(img).append("</div>");
        sb.append("<div class=\"prod-body\">");
        sb.append("<div class=\"prod-shop\">").append(esc(p.getSupplierName())).append("</div>");
        sb.append("<h3 class=\"prod-name\">").append(esc(p.getName())).append("</h3>");
        sb.append("<div class=\"prod-meta\">");
        if (p.getReviewCount() > 0) {
            sb.append("<span>★ ").append(String.format("%.1f", p.getAvgRating())).append("</span>");
        }
        if (showSold) {
            sb.append("<span>Đã bán ").append(p.getSoldCount()).append("</span>");
        }
        sb.append("</div>");
        sb.append("<div class=\"prod-price\"><small>Từ</small> ").append(money(p.getPrice())).append("</div>");
        sb.append("</div></a>");
        return sb.toString();
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <!-- Giu cho link tuong doi (dat_in_3d.jsp, san-pham) chay dung du trang mo qua /trang-chu -->
    <base href="<%= ctx %>/KhachHang/">
    <title>PrintKraft — In theo yêu cầu</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/assets/css/site.css">
    <link rel="stylesheet" href="<%= ctx %>/assets/css/trang-chu.css">
    <link rel="stylesheet" href="<%= ctx %>/assets/css/home-products.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="active" value="home"/>
</jsp:include>

<main>
    <div class="page">
        <section class="hero">
            <div>
                <div class="hero-eyebrow">⚡ Giao mẫu thử trong 48 giờ</div>
                <h1>In ấn của bạn, <span class="accent">theo cách của bạn.</span></h1>
                <p>Tải thiết kế lên, chọn chất liệu và số lượng — xưởng in đối tác của chúng tôi lo phần còn lại. Từ 1 chiếc áo đến 10.000 sản phẩm.</p>
                <div class="hero-cta">
                    <a class="btn-primary" href="dat_in_3d.jsp">Bắt đầu thiết kế</a>
                    <a class="btn-secondary" href="san-pham">Xem sản phẩm mẫu</a>
                </div>
                <div class="hero-stats">
                    <div><strong>4.9/5</strong><span>Đánh giá khách hàng</span></div>
                    <div><strong>120+</strong><span>Xưởng in đối tác</span></div>
                    <div><strong>48h</strong><span>Thời gian sản xuất TB</span></div>
                    <div><strong>63</strong><span>Tỉnh thành giao hàng</span></div>
                </div>
            </div>
            <div class="hero-visual">
                <div class="blob b1"></div><div class="blob b2"></div><div class="blob b3"></div>
                <div class="mockup m3">POSTER<br>A2 GLOSS</div>
                <div class="mockup m1">ÁO THUN<br>COTTON 100%</div>
                <div class="mockup m2">CỐC SỨ<br>350ML</div>
                <div class="mockup m4">STICKER<br>DECAL</div>
            </div>
        </section>

        <div class="cat-strip">
            <div class="inner">
                <a href="dat_in_3d.jsp">Áo thun &amp; Hoodie</a>
                <a href="dat_in_3d.jsp">Cốc &amp; Bình giữ nhiệt</a>
                <a href="dat_in_3d.jsp">Poster &amp; Canvas</a>
                <a href="dat_in_3d.jsp">Bao bì &amp; Nhãn dán</a>
                <a href="dat_in_3d.jsp">Namecard &amp; Văn phòng phẩm</a>
                <a href="trang_chu.jsp">Quà tặng doanh nghiệp</a>
                <a href="dat_in_3d.jsp">Túi vải &amp; Phụ kiện</a>
                <a href="dat_in_3d.jsp">Đồng phục team</a>
            </div>
        </div>

        <!-- ============ SẢN PHẨM MỚI NHẤT ============ -->
        <section class="home-products">
            <div class="section">
                <div class="section-head">
                    <div>
                        <h2>Sản phẩm mới nhất</h2>
                        <p>Những mẫu in vừa được xưởng đối tác đăng bán</p>
                    </div>
                    <a class="see-all" href="<%= ctx %>/san-pham">Xem tất cả →</a>
                </div>
                <% if (newestProducts == null || newestProducts.isEmpty()) { %>
                <p class="prod-empty">Chưa có sản phẩm nào.</p>
                <% } else { %>
                <div class="prod-grid">
                    <% for (Product p : newestProducts) { %>
                    <%= card(p, ctx, false) %>
                    <% } %>
                </div>
                <% } %>
            </div>
        </section>

        <!-- ============ SẢN PHẨM BÁN CHẠY ============ -->
        <section class="home-products alt">
            <div class="section">
                <div class="section-head">
                    <div>
                        <h2>Sản phẩm bán chạy</h2>
                        <p>Được khách hàng đặt nhiều nhất</p>
                    </div>
                    <a class="see-all" href="<%= ctx %>/san-pham">Xem tất cả →</a>
                </div>
                <% if (bestSellingProducts == null || bestSellingProducts.isEmpty()) { %>
                <p class="prod-empty">Chưa có sản phẩm nào.</p>
                <% } else { %>
                <div class="prod-grid">
                    <% for (Product p : bestSellingProducts) { %>
                    <%= card(p, ctx, true) %>
                    <% } %>
                </div>
                <% } %>
            </div>
        </section>

        <section class="how">
            <div class="section">
                <div class="section-head">
                    <div>
                        <div class="eyebrow-line" style="color:var(--violet-soft);">Quy trình</div>
                        <h2>Đặt hàng chỉ với 3 bước</h2>
                        <p>Không cần kinh nghiệm thiết kế — công cụ của chúng tôi lo phần khó</p>
                    </div>
                </div>
                <div class="steps">
                    <div class="step">
                        <div class="num">1</div>
                        <h4>Tải thiết kế lên</h4>
                        <p>Dùng công cụ kéo-thả hoặc tải file có sẵn. Xem trước mockup ngay lập tức.</p>
                    </div>
                    <div class="step">
                        <div class="num">2</div>
                        <h4>Chọn xưởng in phù hợp</h4>
                        <p>Hệ thống gợi ý xưởng in gần bạn nhất, đánh giá cao và đúng thời hạn.</p>
                    </div>
                    <div class="step">
                        <div class="num">3</div>
                        <h4>Theo dõi &amp; nhận hàng</h4>
                        <p>Cập nhật trạng thái theo thời gian thực, từ sản xuất đến giao hàng.</p>
                    </div>
                </div>
            </div>
        </section>

        <section class="cta-band">
            <div class="section">
                <div>
                    <h2>Sẵn sàng in đơn đầu tiên?</h2>
                    <p>Đăng ký nhận voucher 100.000đ cho đơn từ 500.000đ và bảng giá số lượng lớn.</p>
                    <div class="newsletter">
                        <input type="email" placeholder="Email của bạn">
                        <button class="btn-primary" onclick="toastOk('Đã đăng ký — kiểm tra email để nhận voucher')">Nhận voucher</button>
                    </div>
                </div>
                <div style="text-align:right;">
                    <div style="font-family:'Space Grotesk';font-size:52px;font-weight:700;line-height:1;">100K</div>
                    <div style="opacity:.9;font-size:14px;margin-top:6px;">voucher cho đơn đầu tiên</div>
                </div>
            </div>
        </section>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script src="<%= ctx %>/assets/js/site.js"></script>
</body>
</html>
