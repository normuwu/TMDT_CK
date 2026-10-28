<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%--
  Trang danh sách sản phẩm.
  Đường dẫn: /WEB-INF/views/product/products.jsp (Views.PRODUCT_LIST)
  Dữ liệu từ ProductListServlet: result (PageResult<Product>), filter (ProductFilter),
  categories / materials / suppliers (List<FilterOption>), sorts (ProductSort[]),
  baseQuery (chuỗi query đã mã hóa, không có page), error (tùy chọn).
--%>
<fmt:setLocale value="vi_VN"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="listUrl" value="${ctx}/KhachHang/san-pham"/>
<c:set var="detailUrl" value="${ctx}/KhachHang/chi-tiet-san-pham"/>
<%-- Tiền tố link phân trang: giữ nguyên bộ lọc, chỉ nối số trang phía sau --%>
<c:set var="pgBase"><c:out value="${listUrl}?${baseQuery}&page="/></c:set>
<%-- Đường dẫn quay lại (tính từ context path) sau khi thêm vào giỏ: giữ nguyên bộ lọc và trang hiện tại.
     AddToCartServlet chỉ nhận đường dẫn nội bộ bắt đầu bằng "/" (ValidationUtil.isSafeRedirect). --%>
<c:set var="backUrl"><c:out value="/KhachHang/san-pham?${baseQuery}&page=${result.page}"/></c:set>
<c:set var="hasFilter" value="${not empty filter.keyword or filter.categoryId != null or filter.supplierId != null or filter.materialId != null or filter.minPrice != null or filter.maxPrice != null}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sản phẩm — PrintKraft</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${ctx}/assets/css/site.css">
    <style>
        /* Nút trong trang sản phẩm nhỏ gọn hơn mặc định */
        .shop .btn-primary,.shop .btn-secondary{padding:12px 22px;font-size:14px}
        .shop .btn-primary{box-shadow:var(--shadow-glow)}

        /* ===== Trang sản phẩm ===== */
        .shop{max-width:1280px;margin:0 auto;padding:40px 32px 20px}
        .shop-head{display:flex;justify-content:space-between;align-items:flex-end;gap:24px;flex-wrap:wrap;margin-bottom:28px}
        .shop-head h1{font-size:36px}
        .shop-head p{color:var(--ink-soft);font-size:14.5px;margin-top:8px;max-width:52ch}
        .shop-search{
            display:flex;flex:0 1 380px;min-width:260px;background:var(--surface);
            border:1.5px solid var(--line-strong);border-radius:999px;overflow:hidden;
            transition:.2s;box-shadow:var(--shadow-xs);
        }
        .shop-search:focus-within{border-color:var(--violet);box-shadow:0 0 0 4px rgba(108,92,231,.14)}
        .shop-search input{border:none;outline:none;background:transparent;padding:12px 18px;font-size:14px;flex:1;min-width:0}
        .shop-search button{background:var(--grad-primary);color:#fff;padding:0 22px;font-weight:600;font-size:13.5px}

        .shop-layout{display:grid;grid-template-columns:270px 1fr;gap:28px;align-items:start}

        .filters{
            background:var(--surface);border:1px solid var(--line);border-radius:var(--r-lg);
            padding:22px;position:sticky;top:84px;box-shadow:var(--shadow-sm);
        }
        .filters h3{font-size:16px;margin-bottom:16px}
        .f-field{margin-bottom:16px}
        .f-field label{display:block;font-size:12.5px;font-weight:600;color:var(--ink-soft);margin-bottom:6px}
        .f-field select,.f-field input{
            width:100%;border:1.5px solid var(--line);border-radius:var(--r-sm);padding:10px 12px;
            font-size:13.5px;background:#FBF9FF;outline:none;transition:.18s;color:var(--ink);
        }
        .f-field select:focus,.f-field input:focus{border-color:var(--violet);background:#fff;box-shadow:0 0 0 4px rgba(108,92,231,.12)}
        .f-price{display:grid;grid-template-columns:1fr 1fr;gap:10px}
        .f-hint{font-size:12px;color:var(--ink-soft);margin-top:6px;line-height:1.45}
        .f-actions{display:flex;flex-direction:column;gap:10px;margin-top:6px}
        .f-actions .btn-primary,.f-actions .btn-secondary{width:100%}

        .toolbar{display:flex;justify-content:space-between;align-items:center;gap:16px;flex-wrap:wrap;margin-bottom:20px}
        .toolbar .count{font-size:14px;color:var(--ink-soft)}
        .toolbar .count b{color:var(--ink);font-weight:600}
        .sort-box{display:flex;align-items:center;gap:10px;font-size:13.5px;color:var(--ink-soft);font-weight:500}
        .sort-box select{
            border:1.5px solid var(--line-strong);border-radius:999px;padding:9px 16px;font-size:13.5px;
            background:var(--surface);outline:none;color:var(--ink);font-weight:600;
        }
        .sort-box select:focus{border-color:var(--violet);box-shadow:0 0 0 4px rgba(108,92,231,.12)}

        .alert-success{background:#E1FBF3;color:#0A7A5E;border-radius:var(--r-sm);padding:12px 16px;font-size:13.5px;font-weight:500;margin-bottom:18px}
        .alert-error{background:#FFECEC;color:#C0392B;border-radius:var(--r-sm);padding:12px 16px;font-size:13.5px;font-weight:500;margin-bottom:18px}

        .grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(240px,1fr));gap:22px}
        .pcard{
            background:var(--surface);border:1px solid var(--line);border-radius:var(--r-lg);overflow:hidden;
            display:flex;flex-direction:column;box-shadow:var(--shadow-xs);transition:box-shadow .2s,transform .2s;
        }
        .pcard:hover{box-shadow:var(--shadow-md);transform:translateY(-3px)}
        .thumb{position:relative;aspect-ratio:4/3;display:flex;align-items:center;justify-content:center;
            color:#fff;font-family:'Space Grotesk';font-weight:600;font-size:15px;text-align:center;padding:16px;overflow:hidden}
        .thumb img{position:absolute;inset:0;width:100%;height:100%;object-fit:cover}
        .thumb.g0{background:var(--grad-primary)}
        .thumb.g1{background:var(--grad-warm)}
        .thumb.g2{background:var(--grad-cool);color:#063a2e}
        .thumb.g3{background:var(--grad-sky)}
        .thumb.g4{background:var(--grad-pink)}
        .pbody{padding:16px 18px 18px;display:flex;flex-direction:column;flex:1;gap:8px}
        .pcat{font-size:12px;font-weight:600;color:var(--violet)}
        .pname{font-size:16.5px;font-weight:600;line-height:1.3}
        .pname a:hover{color:var(--violet)}
        .pdesc{font-size:13px;color:var(--ink-soft);display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden}
        .mats{display:flex;flex-wrap:wrap;gap:6px}
        .pill{font-size:11.5px;font-weight:600;padding:3px 10px;border-radius:999px;background:#F2EFFF;color:var(--violet)}
        .pill.more{background:#F1F1F6;color:var(--ink-soft)}
        .pmeta{font-size:12.5px;color:var(--ink-soft);display:flex;flex-wrap:wrap;gap:4px 12px;align-items:center}
        .pmeta .star{color:var(--amber);font-weight:700}
        .pfoot{margin-top:auto;padding-top:12px;display:flex;justify-content:space-between;align-items:flex-end;gap:10px;border-top:1px dashed var(--line)}
        .price small{display:block;font-size:11.5px;color:var(--ink-soft)}
        .price strong{font-family:'Space Grotesk';font-size:19px;font-weight:700}
        .pfoot .btn-primary{padding:9px 16px;font-size:13px;box-shadow:none}
        .add-form{margin:0}
        .add-form button:disabled{opacity:.6;cursor:wait}

        .empty{
            grid-column:1/-1;text-align:center;padding:60px 20px;background:var(--surface);
            border:1.5px dashed var(--line-strong);border-radius:var(--r-lg);color:var(--ink-soft);
        }
        .empty strong{display:block;color:var(--ink);font-size:17px;margin-bottom:6px;font-family:'Space Grotesk'}
        .empty .btn-primary{margin-top:18px}

        .pager{display:flex;justify-content:center;align-items:center;gap:6px;margin:34px 0 10px;flex-wrap:wrap}
        .pager a,.pager span{
            min-width:40px;height:40px;padding:0 12px;border-radius:12px;display:flex;align-items:center;justify-content:center;
            font-size:14px;font-weight:600;border:1.5px solid var(--line-strong);background:var(--surface);color:var(--ink-soft);transition:.18s;
        }
        .pager a:hover{border-color:var(--violet);color:var(--violet)}
        .pager .cur{background:var(--grad-primary);color:#fff;border-color:transparent;box-shadow:0 6px 16px rgba(108,92,231,.30)}
        .pager .off{opacity:.4;pointer-events:none}

        /* ===== Responsive (riêng trang sản phẩm) ===== */
        @media (max-width:980px){
            .shop{padding:28px 20px 10px}
            .shop-layout{grid-template-columns:1fr}
            .filters{position:static}
        }
        @media (max-width:640px){
            .shop-head h1{font-size:28px}
            .shop-search{flex-basis:100%}
            .grid{grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:16px}
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp">
    <jsp:param name="active" value="san-pham"/>
</jsp:include>

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

        <c:if test="${not empty success}">
            <div class="alert-success" role="status"><c:out value="${success}"/></div>
        </c:if>
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
                        <select id="fCategory" name="category" onchange="this.form.submit()">
                            <option value="">Tất cả danh mục</option>
                            <c:forEach var="o" items="${categories}">
                                <option value="${o.id}" ${filter.categoryId == o.id ? 'selected' : ''}><c:out value="${o.name}"/></option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="f-field">
                        <label for="fMaterial">Vật liệu</label>
                        <select id="fMaterial" name="material" onchange="this.form.submit()">
                            <option value="">Tất cả vật liệu</option>
                            <c:forEach var="o" items="${materials}">
                                <option value="${o.id}" ${filter.materialId == o.id ? 'selected' : ''}><c:out value="${o.name}"/></option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="f-field">
                        <label for="fSupplier">Xưởng in</label>
                        <select id="fSupplier" name="supplier" onchange="this.form.submit()">
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
                        <select id="fSort" name="sort" form="filterForm" onchange="this.form.submit()">
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
                                                <%-- POST /KhachHang/them-vao-gio: cần csrfToken; chỉ gửi materialId khi đang lọc theo vật liệu --%>
                                            <form class="add-form" method="post" action="${ctx}/KhachHang/them-vao-gio">
                                                <input type="hidden" name="csrfToken" value="<c:out value='${sessionScope.csrfToken}'/>">
                                                <input type="hidden" name="productId" value="${p.productId}">
                                                <input type="hidden" name="quantity" value="1">
                                                <c:if test="${filter.materialId != null}">
                                                    <input type="hidden" name="materialId" value="${filter.materialId}">
                                                </c:if>
                                                <input type="hidden" name="redirect" value="${backUrl}">
                                                <button type="submit" class="btn-primary">🛒 Thêm vào giỏ</button>
                                            </form>
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

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script src="${ctx}/assets/js/site.js"></script>
<script>
    /* Chống bấm đúp "Thêm vào giỏ": khóa nút sau lần bấm đầu, mở lại khi trang được khôi phục từ lịch sử */
    document.querySelectorAll('.add-form').forEach(function(f){
        f.addEventListener('submit',function(){
            var b=f.querySelector('button');b.disabled=true;b.textContent='Đang thêm...';
        });
    });
    window.addEventListener('pageshow',function(){
        document.querySelectorAll('.add-form button').forEach(function(b){b.disabled=false;b.textContent='🛒 Thêm vào giỏ'});
    });
</script>
</body>
</html>
