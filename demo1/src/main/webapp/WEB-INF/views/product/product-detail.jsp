<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<fmt:setLocale value="vi_VN"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="listUrl" value="${ctx}/KhachHang/san_pham.jsp"/>
<c:set var="logged" value="${not empty sessionScope.currentUser}"/>
<c:set var="startPrice" value="${not empty product.materials ? product.materials[0].price : product.price}"/>
<c:set var="backPath" value="/KhachHang/chi-tiet-san-pham?id=${product.productId}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><c:out value="${product.name}"/> — PrintKraft</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="<c:out value='${product.shortDescription}'/>">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/assets/css/printkraft.css">
    <link rel="stylesheet" href="${ctx}/assets/css/product.css">
    <link rel="stylesheet" href="${ctx}/assets/css/product-detail.css">
</head>
<body data-page="san-pham" data-search="san_pham.jsp">
<jsp:include page="/WEB-INF/views/common/session-info.jsp" />

<div id="site-header"></div>
<jsp:include page="/WEB-INF/views/common/cart-drawer.jsp" />

<main>
    <nav class="breadcrumb" aria-label="Đường dẫn">
        <a href="${listUrl}">Sản phẩm</a><span class="sep">›</span>
        <a href="${listUrl}?category=${product.categoryId}"><c:out value="${product.categoryName}"/></a><span class="sep">›</span>
        <span><c:out value="${product.name}"/></span>
    </nav>

    <c:if test="${not empty success or not empty error}">
        <div class="alerts">
            <c:if test="${not empty success}"><div class="alert ok" role="status"><c:out value="${success}"/></div></c:if>
            <c:if test="${not empty error}"><div class="alert err" role="alert"><c:out value="${error}"/></div></c:if>
        </div>
    </c:if>

    <%-- ================= PHẦN TRÊN: ẢNH + THÔNG TIN MUA HÀNG ================= --%>
    <section class="detail">
        <div class="gallery">
            <c:choose>
                <c:when test="${not empty product.images}">
                    <c:set var="u0" value="${product.images[0].imageUrl}"/>
                    <c:choose>
                        <c:when test="${fn:startsWith(u0, 'http')}"><c:set var="s0" value="${u0}"/></c:when>
                        <c:when test="${fn:startsWith(u0, '/')}"><c:set var="s0" value="${ctx}${u0}"/></c:when>
                        <c:otherwise><c:set var="s0" value="${ctx}/${u0}"/></c:otherwise>
                    </c:choose>
                    <div class="gallery-main" id="galleryMain">
                        <img id="mainImg" src="<c:out value='${s0}'/>" alt="<c:out value='${product.name}'/>">
                    </div>
                    <c:if test="${fn:length(product.images) > 1}">
                        <div class="gallery-thumbs">
                            <c:forEach items="${product.images}" var="im" varStatus="st">
                                <c:set var="u" value="${im.imageUrl}"/>
                                <c:choose>
                                    <c:when test="${fn:startsWith(u, 'http')}"><c:set var="s" value="${u}"/></c:when>
                                    <c:when test="${fn:startsWith(u, '/')}"><c:set var="s" value="${ctx}${u}"/></c:when>
                                    <c:otherwise><c:set var="s" value="${ctx}/${u}"/></c:otherwise>
                                </c:choose>
                                <button type="button" class="gallery-thumb ${st.first ? 'active' : ''}"
                                        data-src="<c:out value='${s}'/>" aria-label="Xem ảnh ${st.count}">
                                    <img src="<c:out value='${s}'/>" alt="" loading="lazy">
                                </button>
                            </c:forEach>
                        </div>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <div class="gallery-main placeholder g${product.productId % 5}" id="galleryMain">
                        <span><c:out value="${fn:substring(product.name, 0, 1)}"/></span>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="detail-info">
            <div class="product-cat"><c:out value="${product.categoryName}"/></div>
            <h1><c:out value="${product.name}"/></h1>

            <p class="detail-supplier">
                Bởi <a href="#supplier-reviews"><c:out value="${product.supplierName}"/></a>
                <c:if test="${product.supplierReviewCount > 0}">
                    · <span class="star">★ <fmt:formatNumber value="${product.supplierAvgRating}" pattern="0.0"/></span>
                </c:if>
            </p>

            <div class="rating-line">
                <c:choose>
                    <c:when test="${product.reviewCount > 0}">
                        <span><span class="star">★ <fmt:formatNumber value="${product.avgRating}" pattern="0.0"/></span>
                            <a href="#reviews">(${product.reviewCount} đánh giá)</a></span>
                    </c:when>
                    <c:otherwise><a href="#reviews">Chưa có đánh giá</a></c:otherwise>
                </c:choose>
                <c:if test="${product.soldCount > 0}">
                    <span>Đã bán <fmt:formatNumber value="${product.soldCount}" groupingUsed="true"/></span>
                </c:if>
            </div>

            <c:if test="${not empty product.shortDescription}">
                <p class="detail-short"><c:out value="${product.shortDescription}"/></p>
            </c:if>

            <div class="detail-price">
                <span id="priceValue" data-base="${product.price}"><fmt:formatNumber value="${startPrice}" groupingUsed="true"/></span>đ
                <c:if test="${fn:length(product.materials) > 1}"><small>Giá thay đổi theo vật liệu</small></c:if>
            </div>

            <form class="buy-box" method="post" action="${ctx}/KhachHang/them-vao-gio">
                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                <input type="hidden" name="productId" value="${product.productId}">
                <input type="hidden" name="redirect" value="<c:out value='${backPath}'/>">
                <c:if test="${not empty product.materials}">
                    <span class="buy-label">Vật liệu</span>
                    <div class="material-options" role="radiogroup" aria-label="Chọn vật liệu">
                        <c:forEach items="${product.materials}" var="m" varStatus="st">
                            <label class="material-opt">
                                <input type="radio" name="materialId" value="${m.materialId}"
                                       data-price="${m.price}" data-name="<c:out value='${m.name}'/>"
                                       <c:if test="${st.first}">checked</c:if>>
                                <span><c:out value="${m.name}"/><small><fmt:formatNumber value="${m.price}" groupingUsed="true"/>đ</small></span>
                            </label>
                        </c:forEach>
                    </div>
                </c:if>

                <span class="buy-label">Số lượng</span>
                <div class="qty-row">
                    <div class="qty-box">
                        <button type="button" id="qtyMinus" aria-label="Giảm số lượng">−</button>
                        <input type="number" id="qtyInput" name="quantity" value="1" min="1" max="${product.stockQuantity}" inputmode="numeric" aria-label="Số lượng">
                        <button type="button" id="qtyPlus" aria-label="Tăng số lượng">+</button>
                    </div>
                    <c:choose>
                        <c:when test="${product.stockQuantity > 0}">
                            <span class="stock">Còn <b>${product.stockQuantity}</b> sản phẩm</span>
                        </c:when>
                        <c:otherwise><span class="stock out">Tạm hết hàng</span></c:otherwise>
                    </c:choose>
                </div>

                <p class="subtotal">Tạm tính: <b><span id="subtotalValue">0</span>đ</b></p>

                <div class="detail-actions">
                    <button type="submit" id="addToCartBtn" class="btn-primary"
                            <c:if test="${product.stockQuantity <= 0}">disabled</c:if>>Thêm vào giỏ</button>
                    <%-- Link tương đối: trang này nằm dưới /KhachHang/ cùng thư mục với dat_in_3d.jsp --%>
                    <a class="btn-secondary" href="dat_in_3d.jsp">Đặt in ngay</a>
                </div>
            </form>

            <div class="detail-meta">
                <span>🚚 Xưởng xác nhận đơn trong vòng 30 phút</span>
                <span>↩ Đổi trả trong 7 ngày nếu lỗi do xưởng</span>
            </div>
        </div>
    </section>

    <%-- ================= PHẦN DƯỚI: MÔ TẢ, THÔNG SỐ, ĐÁNH GIÁ ================= --%>
    <div class="detail-sections">

        <section class="d-card" id="desc">
            <h2>Mô tả sản phẩm</h2>
            <c:choose>
                <c:when test="${not empty product.description}"><p class="desc"><c:out value="${product.description}"/></p></c:when>
                <c:when test="${not empty product.shortDescription}"><p class="desc"><c:out value="${product.shortDescription}"/></p></c:when>
                <c:otherwise><p class="desc">Nhà cung cấp chưa cập nhật mô tả cho sản phẩm này.</p></c:otherwise>
            </c:choose>

            <h3>Thông số</h3>
            <table class="spec-table">
                <tr><th>Danh mục</th><td><c:out value="${product.categoryName}"/></td></tr>
                <tr><th>Nhà cung cấp</th><td><c:out value="${product.supplierName}"/></td></tr>
                <c:if test="${not empty product.materials}">
                    <tr><th>Vật liệu</th><td>
                        <c:forEach items="${product.materials}" var="m" varStatus="st"><c:out value="${m.name}"/><c:if test="${not st.last}">, </c:if></c:forEach>
                    </td></tr>
                </c:if>
                <c:forEach items="${product.attributes}" var="a">
                    <tr><th><c:out value="${a.name}"/></th><td><c:out value="${a.value}"/></td></tr>
                </c:forEach>
            </table>
        </section>

        <%-- ---------- Đánh giá sản phẩm ---------- --%>
        <section class="d-card" id="reviews">
            <h2>Đánh giá sản phẩm</h2>
            <div class="review-summary">
                <c:choose>
                    <c:when test="${product.reviewCount > 0}">
                        <div class="big-score"><fmt:formatNumber value="${product.avgRating}" pattern="0.0"/></div>
                        <div>
                            <div class="stars">
                                <c:forEach begin="1" end="5" var="i">${i <= product.avgRating + 0.5 ? '★' : '☆'}</c:forEach>
                            </div>
                            <div class="meta">${product.reviewCount} đánh giá</div>
                        </div>
                    </c:when>
                    <c:otherwise><div class="meta">Chưa có đánh giá nào. Hãy là người đầu tiên đánh giá sản phẩm này.</div></c:otherwise>
                </c:choose>
            </div>

            <c:choose>
                <c:when test="${logged}">
                    <form class="review-form" method="post" action="${ctx}/KhachHang/danh-gia-san-pham">
                        <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                        <input type="hidden" name="productId" value="${product.productId}">
                        <h3>Viết đánh giá của bạn</h3>
                        <span class="lbl" style="display:block;font-size:12.5px;font-weight:600;color:var(--ink-soft);margin-bottom:4px;">Chấm điểm</span>
                        <div class="star-rate" role="radiogroup" aria-label="Số sao">
                            <input type="radio" id="pr5" name="rating" value="5"><label for="pr5" title="5 sao">★</label>
                            <input type="radio" id="pr4" name="rating" value="4"><label for="pr4" title="4 sao">★</label>
                            <input type="radio" id="pr3" name="rating" value="3"><label for="pr3" title="3 sao">★</label>
                            <input type="radio" id="pr2" name="rating" value="2"><label for="pr2" title="2 sao">★</label>
                            <input type="radio" id="pr1" name="rating" value="1"><label for="pr1" title="1 sao">★</label>
                        </div>
                        <label class="lbl" for="prComment">Nhận xét</label>
                        <textarea id="prComment" name="comment" maxlength="1000" minlength="5" required
                                  placeholder="Chất liệu, độ chi tiết, độ bền... (gửi lại sẽ cập nhật đánh giá cũ của bạn)"></textarea>
                        <button type="submit" class="btn-primary">Gửi đánh giá</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <div class="login-hint"><a href="<c:out value='${loginUrl}'/>">Đăng nhập</a> để gửi đánh giá cho sản phẩm này.</div>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${not empty product.productReviews}">
                    <div class="review-list">
                        <c:forEach items="${product.productReviews}" var="r">
                            <article class="review-item">
                                <div class="review-head">
                                    <div class="avatar"><c:out value="${r.initials}"/></div>
                                    <div class="who"><strong><c:out value="${r.userName}"/></strong><span>${r.createdDate}</span></div>
                                    <div class="stars" style="margin-left:auto;"><c:forEach begin="1" end="5" var="i">${i <= r.rating ? '★' : '☆'}</c:forEach></div>
                                </div>
                                <p><c:out value="${r.comment}"/></p>
                            </article>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise><div class="no-review">Chưa có nhận xét nào để hiển thị.</div></c:otherwise>
            </c:choose>
        </section>

        <%-- ---------- Đánh giá nhà cung cấp ---------- --%>
        <section class="d-card" id="supplier-reviews">
            <h2>Đánh giá nhà cung cấp</h2>
            <div class="supplier-card">
                <div class="logo-badge"><c:out value="${fn:toUpperCase(fn:substring(product.supplierName, 0, 2))}"/></div>
                <div>
                    <strong><c:out value="${product.supplierName}"/></strong>
                    <c:if test="${not empty product.supplierAddress}"><span>📍 <c:out value="${product.supplierAddress}"/></span><br></c:if>
                    <c:choose>
                        <c:when test="${product.supplierReviewCount > 0}">
                            <span><span class="star">★ <fmt:formatNumber value="${product.supplierAvgRating}" pattern="0.0"/></span> (${product.supplierReviewCount} đánh giá)</span>
                        </c:when>
                        <c:otherwise><span>Chưa có đánh giá</span></c:otherwise>
                    </c:choose>
                </div>
                <a class="btn-secondary" style="margin-left:auto;padding:10px 18px;font-size:13.5px;"
                   href="${listUrl}?supplier=${product.supplierId}">Xem sản phẩm của xưởng</a>
            </div>

            <c:choose>
                <c:when test="${logged}">
                    <form class="review-form" method="post" action="${ctx}/KhachHang/danh-gia-nha-cung-cap">
                        <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                        <input type="hidden" name="productId" value="${product.productId}">
                        <input type="hidden" name="supplierId" value="${product.supplierId}">
                        <h3>Đánh giá nhà cung cấp</h3>
                        <span class="lbl" style="display:block;font-size:12.5px;font-weight:600;color:var(--ink-soft);margin-bottom:4px;">Chấm điểm</span>
                        <div class="star-rate" role="radiogroup" aria-label="Số sao nhà cung cấp">
                            <input type="radio" id="sr5" name="rating" value="5"><label for="sr5" title="5 sao">★</label>
                            <input type="radio" id="sr4" name="rating" value="4"><label for="sr4" title="4 sao">★</label>
                            <input type="radio" id="sr3" name="rating" value="3"><label for="sr3" title="3 sao">★</label>
                            <input type="radio" id="sr2" name="rating" value="2"><label for="sr2" title="2 sao">★</label>
                            <input type="radio" id="sr1" name="rating" value="1"><label for="sr1" title="1 sao">★</label>
                        </div>
                        <label class="lbl" for="srComment">Nhận xét</label>
                        <textarea id="srComment" name="comment" maxlength="1000" minlength="5" required
                                  placeholder="Chất lượng in, đúng tiến độ, thái độ hỗ trợ..."></textarea>
                        <button type="submit" class="btn-primary">Gửi đánh giá</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <div class="login-hint"><a href="<c:out value='${loginUrl}'/>">Đăng nhập</a> để đánh giá nhà cung cấp này.</div>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${not empty product.supplierReviews}">
                    <div class="review-list">
                        <c:forEach items="${product.supplierReviews}" var="r">
                            <article class="review-item">
                                <div class="review-head">
                                    <div class="avatar"><c:out value="${r.initials}"/></div>
                                    <div class="who"><strong><c:out value="${r.userName}"/></strong><span>${r.createdDate}</span></div>
                                    <div class="stars" style="margin-left:auto;"><c:forEach begin="1" end="5" var="i">${i <= r.rating ? '★' : '☆'}</c:forEach></div>
                                </div>
                                <p><c:out value="${r.comment}"/></p>
                            </article>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise><div class="no-review">Chưa có nhận xét nào về nhà cung cấp này.</div></c:otherwise>
            </c:choose>
        </section>
    </div>
</main>

<div id="site-footer"></div>

<script src="${ctx}/assets/js/printkraft.js"></script>
<script src="${ctx}/assets/js/product-detail.js"></script>
</body>
</html>
