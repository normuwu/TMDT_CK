<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<fmt:setLocale value="vi_VN"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="listUrl" value="${ctx}/KhachHang/san_pham.jsp"/>
<c:set var="detailUrl" value="${ctx}/KhachHang/chi-tiet-san-pham"/>
<c:set var="backPath" value="/KhachHang/san_pham.jsp${empty pageContext.request.queryString ? '' : '?'}${pageContext.request.queryString}"/>
<c:set var="pgBase"><c:out value="${listUrl}?${baseQuery}&page="/></c:set>
<c:set var="hasFilter" value="${not empty filter.keyword or filter.categoryId != null or filter.supplierId != null or filter.materialId != null or filter.minPrice != null or filter.maxPrice != null}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sản phẩm — PrintKraft</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/assets/css/printkraft.css">
    <link rel="stylesheet" href="${ctx}/assets/css/product.css">
</head>
<body data-page="san-pham" data-search="san_pham.jsp">
<jsp:include page="/WEB-INF/views/common/session-info.jsp" />

<div id="site-header"></div>
<jsp:include page="/WEB-INF/views/common/cart-drawer.jsp" />

<main>
    <div class="shop">
        <div class="shop-head">
            <div>
                <h1>Sản phẩm in theo yêu cầu</h1>
                <p>Chọn sản phẩm, vật liệu và xưởng in phù hợp, rồi thêm thiết kế của bạn ở bước đặt hàng.</p>
            </div>
            <%-- Ô tìm kiếm thuộc form lọc (thuộc tính form="filterForm") --%>
            <div class="shop-search">
                <input type="search" name="q" form="filterForm" maxlength="100"
                       placeholder="Tìm áo thun, cốc sứ, poster..."
                       value="<c:out value='${filter.keyword}'/>" aria-label="Tìm sản phẩm">
                <button type="submit" form="filterForm">Tìm</button>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert-error" role="alert"><c:out value="${error}"/></div>
        </c:if>

        <div class="shop-layout">

            <%-- ===== Bộ lọc ===== --%>
            <aside class="filters">
                <h3>Bộ lọc</h3>
                <form id="filterForm" method="get" action="${listUrl}">
                    <div class="f-field">
                        <label for="fCategory">Danh mục</label>
                        <select id="fCategory" name="category" class="js-auto-submit">
                            <option value="">Tất cả danh mục</option>
                            <c:forEach var="o" items="${categories}">
                                <option value="${o.id}" ${filter.categoryId == o.id ? 'selected' : ''}><c:out value="${o.name}"/></option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="f-field">
                        <label for="fMaterial">Vật liệu</label>
                        <select id="fMaterial" name="material" class="js-auto-submit">
                            <option value="">Tất cả vật liệu</option>
                            <c:forEach var="o" items="${materials}">
                                <option value="${o.id}" ${filter.materialId == o.id ? 'selected' : ''}><c:out value="${o.name}"/></option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="f-field">
                        <label for="fSupplier">Xưởng in</label>
                        <select id="fSupplier" name="supplier" class="js-auto-submit">
                            <option value="">Tất cả xưởng in</option>
                            <c:forEach var="o" items="${suppliers}">
                                <option value="${o.id}" ${filter.supplierId == o.id ? 'selected' : ''}><c:out value="${o.name}"/></option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="f-field">
                        <label for="fMin">Khoảng giá (đồng)</label>
                        <div class="f-price">
                            <input id="fMin" type="number" name="minPrice" min="0" step="1000" inputmode="numeric"
                                   placeholder="Từ" value="${filter.minPrice}">
                            <input id="fMax" type="number" name="maxPrice" min="0" step="1000" inputmode="numeric"
                                   placeholder="Đến" value="${filter.maxPrice}" aria-label="Giá tối đa">
                        </div>
                        <c:if test="${filter.materialId != null}">
                            <div class="f-hint">Đang lọc theo vật liệu nên khoảng giá áp dụng cho giá của vật liệu đó.</div>
                        </c:if>
                    </div>

                    <div class="f-actions">
                        <button type="submit" class="btn-primary">Áp dụng bộ lọc</button>
                        <c:if test="${hasFilter}">
                            <a class="btn-secondary" href="${listUrl}">Xóa bộ lọc</a>
                        </c:if>
                    </div>
                </form>
            </aside>

            <%-- ===== Kết quả ===== --%>
            <section aria-live="polite">
                <div class="toolbar">
                    <div class="count">
                        <b><fmt:formatNumber value="${result.totalItems}" groupingUsed="true"/></b> sản phẩm
                        <c:if test="${result.totalPages > 1}"> · trang ${result.page}/${result.totalPages}</c:if>
                    </div>
                    <div class="sort-box">
                        <label for="fSort">Sắp xếp</label>
                        <select id="fSort" name="sort" form="filterForm" class="js-auto-submit">
                            <c:forEach var="s" items="${sorts}">
                                <option value="${s.code}" ${filter.sort == s ? 'selected' : ''}><c:out value="${s.label}"/></option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="grid">
                    <c:choose>
                        <c:when test="${empty result.items}">
                            <div class="empty">
                                <strong>Không tìm thấy sản phẩm phù hợp</strong>
                                <c:choose>
                                    <c:when test="${hasFilter}">
                                        Thử bỏ bớt điều kiện lọc hoặc dùng từ khóa khác.
                                        <div><a class="btn-primary" href="${listUrl}">Xóa bộ lọc</a></div>
                                    </c:when>
                                    <c:otherwise>Chưa có sản phẩm nào đang bán. Vui lòng quay lại sau.</c:otherwise>
                                </c:choose>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="p" items="${result.items}">
                                <article class="pcard">
                                    <a class="thumb g${p.productId % 5}" href="${detailUrl}?id=${p.productId}" tabindex="-1" aria-hidden="true">
                                        <c:choose>
                                            <c:when test="${empty p.thumbnailUrl}">
                                                <span><c:out value="${p.categoryName}"/></span>
                                            </c:when>
                                            <c:when test="${fn:startsWith(p.thumbnailUrl, 'http')}">
                                                <img src="<c:out value='${p.thumbnailUrl}'/>" alt="" loading="lazy">
                                            </c:when>
                                            <c:when test="${fn:startsWith(p.thumbnailUrl, '/')}">
                                                <img src="${ctx}<c:out value='${p.thumbnailUrl}'/>" alt="" loading="lazy">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${ctx}/<c:out value='${p.thumbnailUrl}'/>" alt="" loading="lazy">
                                            </c:otherwise>
                                        </c:choose>
                                    </a>
                                    <div class="pbody">
                                        <div class="pcat"><c:out value="${p.categoryName}"/></div>
                                        <h3 class="pname"><a href="${detailUrl}?id=${p.productId}"><c:out value="${p.name}"/></a></h3>
                                        <c:if test="${not empty p.shortDescription}">
                                            <p class="pdesc"><c:out value="${p.shortDescription}"/></p>
                                        </c:if>
                                        <c:if test="${not empty p.materialNames}">
                                            <div class="mats">
                                                <c:forEach var="m" items="${p.materialNames}" varStatus="vs" end="2">
                                                    <span class="pill"><c:out value="${m}"/></span>
                                                </c:forEach>
                                                <c:if test="${fn:length(p.materialNames) > 3}">
                                                    <span class="pill more">+${fn:length(p.materialNames) - 3}</span>
                                                </c:if>
                                            </div>
                                        </c:if>
                                        <div class="pmeta">
                                            <span><c:out value="${p.supplierName}"/></span>
                                            <c:choose>
                                                <c:when test="${p.reviewCount > 0}">
                                                    <span><span class="star">★ <fmt:formatNumber value="${p.avgRating}" pattern="0.0"/></span> (${p.reviewCount})</span>
                                                </c:when>
                                                <c:otherwise><span>Chưa có đánh giá</span></c:otherwise>
                                            </c:choose>
                                            <c:if test="${p.soldCount > 0}">
                                                <span>Đã bán <fmt:formatNumber value="${p.soldCount}" groupingUsed="true"/></span>
                                            </c:if>
                                        </div>
                                        <div class="pfoot">
                                            <div class="price">
                                                    <%-- Lọc theo vật liệu: giá của vật liệu đó; ngược lại: giá thấp nhất --%>
                                                <small>${filter.materialId != null ? 'Giá' : 'Giá từ'}</small>
                                                <strong><fmt:formatNumber value="${p.price}" groupingUsed="true"/>đ</strong>
                                            </div>
                                            <div class="pfoot-actions">
                                                <form method="post" action="${ctx}/KhachHang/them-vao-gio" class="add-cart-form">
                                                    <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">
                                                    <input type="hidden" name="productId" value="${p.productId}">
                                                    <input type="hidden" name="quantity" value="1">
                                                    <input type="hidden" name="redirect" value="<c:out value='${backPath}'/>">
                                                    <button type="submit" class="btn-add">🛒 Thêm vào giỏ</button>
                                                </form>
                                                <a class="btn-primary" href="${detailUrl}?id=${p.productId}">Xem chi tiết</a>
                                            </div>
                                        </div>
                                    </div>
                                </article>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <%-- ===== Phân trang (hiện tối đa 5 số trang quanh trang hiện tại) ===== --%>
                <c:if test="${result.totalPages > 1}">
                    <c:set var="pStart" value="${result.page - 2 < 1 ? 1 : result.page - 2}"/>
                    <c:set var="pEnd" value="${pStart + 4 > result.totalPages ? result.totalPages : pStart + 4}"/>
                    <c:set var="pStart" value="${pEnd - 4 < 1 ? 1 : pEnd - 4}"/>
                    <nav class="pager" aria-label="Phân trang">
                        <c:choose>
                            <c:when test="${result.hasPrev}"><a href="${pgBase}${result.page - 1}" rel="prev">Trước</a></c:when>
                            <c:otherwise><span class="off">Trước</span></c:otherwise>
                        </c:choose>
                        <c:if test="${pStart > 1}">
                            <a href="${pgBase}1">1</a>
                            <c:if test="${pStart > 2}"><span class="off">…</span></c:if>
                        </c:if>
                        <c:forEach var="n" begin="${pStart}" end="${pEnd}">
                            <c:choose>
                                <c:when test="${n == result.page}"><span class="cur" aria-current="page">${n}</span></c:when>
                                <c:otherwise><a href="${pgBase}${n}">${n}</a></c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <c:if test="${pEnd < result.totalPages}">
                            <c:if test="${pEnd < result.totalPages - 1}"><span class="off">…</span></c:if>
                            <a href="${pgBase}${result.totalPages}">${result.totalPages}</a>
                        </c:if>
                        <c:choose>
                            <c:when test="${result.hasNext}"><a href="${pgBase}${result.page + 1}" rel="next">Sau</a></c:when>
                            <c:otherwise><span class="off">Sau</span></c:otherwise>
                        </c:choose>
                    </nav>
                </c:if>
            </section>
        </div>
    </div>
</main>

<div id="site-footer"></div>

<script src="${ctx}/assets/js/printkraft.js"></script>
<script src="${ctx}/assets/js/product.js"></script>
</body>
</html>
