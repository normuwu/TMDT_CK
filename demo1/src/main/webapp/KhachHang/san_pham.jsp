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
<c:set var="hasFilter" value="${not empty filter.keyword or filter.categoryId != null or filter.supplierId != null or filter.materialId != null or filter.minPrice != null or filter.maxPrice != null}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sản phẩm — PrintKraft</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root{
            --ink:#1B1B2F;--ink-soft:#4A4A6A;--cream:#FDF9F3;--surface:#FFF;
            --violet:#6C5CE7;--violet-soft:#A29BFE;--coral:#FF6B6B;--coral-deep:#EE5253;
            --amber:#FFB347;--teal:#00B894;--teal-soft:#55EFC4;--pink:#FD79A8;--sky:#48A9F8;
            --grad-primary:linear-gradient(135deg,#6C5CE7,#A29BFE);
            --grad-warm:linear-gradient(135deg,#FF6B6B,#FFB347);
            --grad-cool:linear-gradient(135deg,#00B894,#55EFC4);
            --grad-sky:linear-gradient(135deg,#48A9F8,#6C5CE7);
            --grad-pink:linear-gradient(135deg,#FD79A8,#A29BFE);
            --line:rgba(27,27,47,.10);--line-strong:rgba(27,27,47,.18);
            --shadow-xs:0 1px 3px rgba(27,27,47,.06);
            --shadow-sm:0 4px 14px rgba(27,27,47,.07);
            --shadow-md:0 12px 32px rgba(27,27,47,.11);
            --shadow-lg:0 24px 60px rgba(27,27,47,.18);
            --shadow-glow:0 12px 34px rgba(108,92,231,.32);
            --r-sm:10px;--r-md:16px;--r-lg:22px;--r-xl:28px;
        }
        *{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth}
        body{
            color:var(--ink);font-family:'IBM Plex Sans',sans-serif;line-height:1.55;
            background:
                    radial-gradient(1100px 620px at 8% -8%,rgba(108,92,231,.13),transparent 62%),
                    radial-gradient(880px 520px at 96% -4%,rgba(255,107,107,.13),transparent 58%),
                    radial-gradient(900px 640px at 50% 104%,rgba(0,184,148,.10),transparent 62%),
                    var(--cream);
            background-attachment:fixed;
        }
        h1,h2,h3,h4,h5,.display{font-family:'Space Grotesk',sans-serif;letter-spacing:-.02em;line-height:1.15}
        a{color:inherit;text-decoration:none}
        img,svg{display:block}
        button{font-family:inherit;cursor:pointer;border:none;background:none;color:inherit}
        input,select,textarea{font-family:inherit}
        :focus-visible{outline:3px solid rgba(108,92,231,.5);outline-offset:2px}

        /* ===== Utility bar ===== */
        .utility{
            background:linear-gradient(90deg,#1B1B2F,#2D2B55 50%,#1B1B2F);
            color:rgba(253,249,243,.82);font-size:12.5px;padding:9px 32px;
            display:flex;justify-content:space-between;flex-wrap:wrap;gap:8px;
        }
        .utility b{color:var(--amber);font-weight:600}

        /* ===== Header ===== */
        header{
            background:rgba(253,249,243,.88);
            backdrop-filter:blur(14px);-webkit-backdrop-filter:blur(14px);
            border-bottom:1px solid var(--line);
            padding:12px 32px;display:flex;align-items:center;gap:16px;
            position:sticky;top:0;z-index:50;
        }
        .logo{font-size:22px;font-weight:700;display:flex;align-items:center;gap:10px;white-space:nowrap;flex-shrink:0}
        .logo .mark{
            width:28px;height:28px;background:var(--grad-warm);
            display:inline-block;transform:rotate(45deg);border-radius:8px;
            box-shadow:0 6px 16px rgba(255,107,107,.4);
        }
        nav{
            display:flex;gap:4px;font-size:14px;font-weight:500;
            overflow-x:auto;scrollbar-width:none;-ms-overflow-style:none;
            flex:1;min-width:0;padding:2px;
        }
        nav::-webkit-scrollbar{display:none}
        nav a{
            padding:9px 14px;border-radius:999px;white-space:nowrap;
            color:var(--ink-soft);transition:.18s;flex-shrink:0;
        }
        nav a:hover{background:rgba(108,92,231,.10);color:var(--violet)}
        nav a.active{background:var(--grad-primary);color:#fff;box-shadow:0 6px 16px rgba(108,92,231,.30)}
        .search-wrap{
            flex:0 1 250px;display:flex;min-width:0;
            background:var(--surface);border:1.5px solid var(--line-strong);border-radius:999px;
            overflow:hidden;transition:.2s;box-shadow:var(--shadow-xs);
        }
        .search-wrap:focus-within{border-color:var(--violet);box-shadow:0 0 0 4px rgba(108,92,231,.14)}
        .search-wrap input{border:none;outline:none;background:transparent;padding:10px 18px;font-size:14px;flex:1;min-width:0}
        .search-wrap button{background:var(--grad-primary);color:#fff;padding:0 18px;font-weight:600;font-size:13.5px}
        .head-actions{display:flex;align-items:center;gap:14px;font-size:13px;font-weight:500;flex-shrink:0;margin-left:auto}
        .cart-btn{
            display:flex;align-items:center;gap:7px;background:var(--grad-warm);color:#fff;
            padding:10px 16px;border-radius:999px;font-weight:600;font-size:13.5px;
            box-shadow:0 8px 20px rgba(255,107,107,.32);transition:.18s;white-space:nowrap;
        }
        .cart-btn:hover{transform:translateY(-2px);box-shadow:0 12px 26px rgba(255,107,107,.42)}
        .badge{background:rgba(255,255,255,.28);border-radius:999px;padding:1px 8px;font-size:11.5px}
        .user-chip{
            display:flex;align-items:center;gap:9px;padding:6px 14px 6px 6px;
            background:var(--surface);border:1.5px solid var(--line-strong);border-radius:999px;
            font-weight:600;font-size:13px;transition:.18s;
        }
        .user-chip:hover{border-color:var(--violet);box-shadow:0 0 0 4px rgba(108,92,231,.12)}
        .avatar{
            width:28px;height:28px;border-radius:50%;background:var(--grad-primary);color:#fff;
            display:flex;align-items:center;justify-content:center;font-size:11.5px;font-weight:700;
        }

        /* ===== Buttons ===== */
        .btn-primary{
            background:var(--grad-primary);color:#fff;padding:12px 22px;border-radius:var(--r-sm);
            font-weight:600;font-size:14px;display:inline-block;text-align:center;
            box-shadow:var(--shadow-glow);transition:.2s;
        }
        .btn-primary:hover{transform:translateY(-2px);box-shadow:0 18px 40px rgba(108,92,231,.42)}
        .btn-secondary{
            border:1.5px solid var(--line-strong);padding:12px 22px;border-radius:var(--r-sm);
            font-weight:600;font-size:14px;background:var(--surface);color:var(--ink);
            display:inline-block;text-align:center;transition:.2s;
        }
        .btn-secondary:hover{border-color:var(--violet);color:var(--violet)}
        .chip{border:1.5px solid var(--line-strong);border-radius:999px;background:#fff;font-weight:500;color:var(--ink-soft)}

        /* ===== Footer ===== */
        footer{border-top:1px solid var(--line);padding:56px 32px 26px;background:rgba(255,255,255,.6);margin-top:40px}
        .foot-inner{max-width:1280px;margin:0 auto;display:grid;grid-template-columns:1.4fr repeat(3,1fr);gap:34px}
        .foot-inner h5{font-family:'Space Grotesk';font-size:12.5px;text-transform:uppercase;letter-spacing:.1em;margin-bottom:16px;color:var(--ink)}
        .foot-inner ul{list-style:none}
        .foot-inner li{padding:6px 0;font-size:13.5px;color:var(--ink-soft);transition:.16s;cursor:pointer}
        .foot-inner li:hover{color:var(--violet);transform:translateX(3px)}
        .foot-bottom{max-width:1280px;margin:34px auto 0;padding-top:22px;border-top:1px solid var(--line);display:flex;justify-content:space-between;font-size:12.5px;color:var(--ink-soft);flex-wrap:wrap;gap:10px}

        /* ===== Toast ===== */
        .toast{
            position:fixed;bottom:28px;left:50%;transform:translate(-50%,100px);
            background:var(--ink);color:var(--cream);padding:14px 24px;border-radius:999px;
            font-size:13.5px;font-weight:500;z-index:300;transition:.3s cubic-bezier(.4,0,.2,1);
            opacity:0;box-shadow:var(--shadow-lg);max-width:90vw;text-align:center;
        }
        .toast.show{transform:translate(-50%,0);opacity:1}
        .toast.ok{background:linear-gradient(135deg,#00B894,#0A7A5E)}
        .toast.err{background:linear-gradient(135deg,#FF6B6B,#C0392B)}

        /* ===== Trang sản phẩm ===== */
        main{min-height:62vh}
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

        /* ===== Responsive ===== */
        @media (max-width:1240px){.search-wrap{display:none}}
        @media (max-width:980px){
            header{padding:10px 18px;gap:12px;flex-wrap:wrap}
            nav{order:3;flex-basis:100%;width:100%}
            .utility{padding:8px 20px;font-size:11.5px}
            .shop{padding:28px 20px 10px}
            .shop-layout{grid-template-columns:1fr}
            .filters{position:static}
            .foot-inner{grid-template-columns:1fr 1fr}
        }
        @media (max-width:640px){
            .foot-inner{grid-template-columns:1fr}
            .shop-head h1{font-size:28px}
            .shop-search{flex-basis:100%}
            .grid{grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:16px}
        }
        @media (prefers-reduced-motion:reduce){*{transition:none !important;scroll-behavior:auto !important}}
    </style>
</head>
<body data-page="san-pham">
<jsp:include page="/WEB-INF/views/common/session-info.jsp" />

<div id="site-header"></div>

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
                                            <a class="btn-primary" href="${detailUrl}?id=${p.productId}">Xem chi tiết</a>
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
<div class="toast" id="toast">Đã thực hiện</div>

<script>
    /* ============================================================
       Script dùng chung rút gọn cho trang sản phẩm
       (header, footer, đăng nhập/đăng xuất, toast, số lượng giỏ hàng).
       Giữ cùng cách làm với các trang trong KhachHang/.
       ============================================================ */

    /* Lưu trữ cục bộ (cùng khóa pk_ với các trang khác) */
    var store={
        get:function(k,d){try{var v=localStorage.getItem('pk_'+k);return v===null?d:JSON.parse(v)}catch(e){return d}},
        set:function(k,v){try{localStorage.setItem('pk_'+k,JSON.stringify(v))}catch(e){}}
    };

    /* Toast */
    var toastTimer;
    function toast(msg,type){
        var t=document.getElementById('toast');if(!t)return;
        t.textContent=msg;
        t.className='toast show'+(type?' '+type:'');
        clearTimeout(toastTimer);
        toastTimer=setTimeout(function(){t.classList.remove('show')},2400);
    }
    function toastOk(m){toast(m,'ok')}
    function toastErr(m){toast(m,'err')}

    /* Phiên đăng nhập: đọc từ <div id="pk-session"> do session-info.jsp in ra */
    var PK=(function(){
        var el=document.getElementById('pk-session'),d=el?el.dataset:{};
        return {ctx:d.ctx||'',csrf:d.csrf||'',loggedIn:d.loggedIn==='true',name:d.name||'',role:d.role||''};
    })();
    function isLoggedIn(){return PK.loggedIn}
    function escHtml(s){return String(s).replace(/[&<>"']/g,function(c){return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]})}
    function nameParts(n){return String(n).trim().split(/\s+/).filter(Boolean).slice(-2)}
    function initialsOf(n){return nameParts(n).map(function(w){return w.charAt(0)}).join('').toUpperCase()||'U'}
    function shortName(n){return nameParts(n).join(' ')||'Tài khoản'}

    function renderAuthArea(){
        var area=document.getElementById('authArea');if(!area)return;
        if(isLoggedIn()){
            area.innerHTML='<div style="display:flex;align-items:center;gap:8px;">'+
                '<button class="user-chip" onclick="location.href=\'don_hang_cua_toi_3d.jsp\'"><span class="avatar">'+escHtml(initialsOf(PK.name))+'</span> '+escHtml(shortName(PK.name))+'</button>'+
                '<button onclick="logout()" style="font-size:12.5px;font-weight:600;color:var(--ink-soft);">Thoát</button></div>';
        } else {
            area.innerHTML='<a href="'+PK.ctx+'/login" style="font-weight:600;">Tài khoản</a>';
        }
    }
    /* Đăng xuất: POST + CSRF token tới LogoutServlet */
    function logout(){
        var f=document.createElement('form');f.method='post';f.action=PK.ctx+'/logout';
        var t=document.createElement('input');t.type='hidden';t.name='csrfToken';t.value=PK.csrf;
        f.appendChild(t);document.body.appendChild(f);f.submit();
    }

    /* Menu: link tương đối vì trang nằm ở /KhachHang/san-pham (cùng thư mục các trang .jsp khác) */
    var NAV_ITEMS=[
        {id:'home',label:'Trang chủ',href:'trang_chu.jsp'},
        {id:'san-pham',label:'Sản phẩm',href:'san-pham'},
        {id:'studio',label:'Tự thiết kế',href:'dat_in_3d.jsp'},
        {id:'doanh-nghiep',label:'Doanh nghiệp',href:'trang_chu.jsp'},
        {id:'nhacungcap',label:'Nhà cung cấp',href:'tim-kiem-nha-cung-cap.jsp'},
        {id:'donhang',label:'Đơn hàng',href:'don_hang_cua_toi_3d.jsp'},
        {id:'danhgia',label:'Đánh giá',href:'danh-gia.jsp'},
        {id:'faq',label:'Hỗ trợ',href:'lien-he.jsp'}
    ];

    function renderHeader(active){
        var el=document.getElementById('site-header');if(!el)return;
        el.innerHTML='<div class="utility"><span>🚚 Miễn phí thiết kế mockup cho đơn từ 20 sản phẩm — <b>Voucher 100K</b> cho đơn đầu tiên</span><span>Hỗ trợ: <b>1900 6868</b> · <a href="don_hang_cua_toi_3d.jsp">Theo dõi đơn hàng</a>'+(isLoggedIn()?'':' · <a href="'+PK.ctx+'/login">Đăng nhập</a>')+'</span></div>'+
            '<header><a href="trang_chu.jsp" class="logo"><span class="mark"></span> PrintKraft</a><nav id="mainNav">'+
            NAV_ITEMS.map(function(i){return '<a href="'+i.href+'" class="'+(i.id===active?'active':'')+'">'+i.label+'</a>'}).join('')+
            '</nav><div class="search-wrap"><input type="text" id="globalSearch" placeholder="Tìm áo thun, cốc sứ, poster..."><button onclick="doGlobalSearch()">Tìm</button></div>'+
            '<div class="head-actions"><div id="authArea"></div><button class="cart-btn" onclick="location.href=\'Thanh_toan_gio_hang.jsp\'">🛒 Giỏ hàng <span class="badge" id="cartBadge">0</span></button></div></header>';
        var gs=document.getElementById('globalSearch');
        if(gs)gs.addEventListener('keydown',function(e){if(e.key==='Enter')doGlobalSearch()});
    }
    /* Ở trang này, ô tìm trên header tìm sản phẩm */
    function doGlobalSearch(){
        var i=document.getElementById('globalSearch');
        var q=i?i.value.trim():'';
        if(!q){toastErr('Nhập từ khoá để tìm kiếm');return}
        location.href='san-pham?q='+encodeURIComponent(q);
    }

    function renderFooter(){
        var el=document.getElementById('site-footer');if(!el)return;
        el.innerHTML='<footer><div class="foot-inner">'+
            '<div><div class="logo" style="margin-bottom:16px;"><span class="mark"></span> PrintKraft</div><p style="font-size:13.5px;color:var(--ink-soft);max-width:34ch;">Nền tảng in theo yêu cầu kết nối khách hàng với hơn 120 xưởng in đối tác trên toàn quốc.</p><div style="display:flex;gap:10px;margin-top:18px;"><span class="chip" style="font-size:12px;padding:7px 14px;">Facebook</span><span class="chip" style="font-size:12px;padding:7px 14px;">Instagram</span><span class="chip" style="font-size:12px;padding:7px 14px;">Zalo</span></div></div>'+
            '<div><h5>Sản phẩm</h5><ul><li onclick="location.href=\'san-pham\'">Tất cả sản phẩm</li><li onclick="location.href=\'dat_in_3d.jsp\'">Tự thiết kế</li><li onclick="location.href=\'tim-kiem-nha-cung-cap.jsp\'">Tìm xưởng in</li><li onclick="location.href=\'trang_chu.jsp\'">Quà tặng doanh nghiệp</li></ul></div>'+
            '<div><h5>Hỗ trợ</h5><ul><li onclick="location.href=\'lien-he.jsp\'">Trung tâm trợ giúp</li><li onclick="location.href=\'don_hang_cua_toi_3d.jsp\'">Theo dõi đơn hàng</li><li onclick="location.href=\'lien-he.jsp\'">Chính sách đổi trả</li><li onclick="location.href=\'lien-he.jsp\'">Chính sách bảo mật</li><li onclick="location.href=\'lien-he.jsp\'">Điều khoản sử dụng</li></ul></div>'+
            '<div><h5>Liên hệ</h5><ul><li>Hotline: 1900 6868</li><li>Email: hi@printkraft.vn</li><li>Văn phòng: 128 Nguyễn Đình Chiểu, Q.3, TP.HCM</li><li>Giờ làm việc: 8:00 – 21:00</li></ul></div>'+
            '</div><div class="foot-bottom"><span>© 2026 PrintKraft. Nền tảng in theo yêu cầu.</span><span>Điều khoản · Bảo mật · Hỗ trợ khách hàng</span></div></footer>';
    }

    /* Số lượng giỏ hàng (cùng khóa với các trang khác) */
    function getCartCount(){return store.get('cartCount',3)}
    function setCartCount(n){
        store.set('cartCount',n);
        var b=document.getElementById('cartBadge');if(b)b.textContent=n;
    }

    document.addEventListener('DOMContentLoaded',function(){
        renderHeader(document.body.dataset.page||'san-pham');
        renderFooter();
        renderAuthArea();
        setCartCount(getCartCount());
    });
</script>
</body>
</html>
