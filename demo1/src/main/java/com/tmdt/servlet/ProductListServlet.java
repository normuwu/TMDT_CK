package com.tmdt.servlet;

import com.tmdt.model.PageResult;
import com.tmdt.model.Product;
import com.tmdt.model.ProductFilter;
import com.tmdt.model.ProductSort;
import com.tmdt.service.ProductService;
import com.tmdt.util.FlashUtil;
import com.tmdt.util.Views;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * GET /KhachHang/san-pham
 *   ?q=&category=&supplier=&material=&minPrice=&maxPrice=&sort=&page=
 * Đặt dưới /KhachHang/ để các link tương đối trong header/footer của trang
 * (trang_chu.jsp, dat_in_3d.jsp...) vẫn trỏ đúng thư mục /KhachHang/.
 */
@WebServlet(name = "ProductListServlet",
        urlPatterns = {"/KhachHang/san_pham.jsp", "/KhachHang/san-pham"})
public class ProductListServlet extends HttpServlet {

    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        FlashUtil.moveToRequest(request);

        ProductFilter filter = parseFilter(request);
        PageResult<Product> result;
        try {
            result = productService.search(filter);
            request.setAttribute("categories", productService.categories());
            request.setAttribute("materials", productService.materials());
            request.setAttribute("suppliers", productService.suppliers());
        } catch (IllegalStateException e) {
            getServletContext().log("Lỗi tải trang sản phẩm", e);
            request.setAttribute("error", "Hệ thống đang bận, vui lòng thử lại sau.");
            result = PageResult.empty(filter.getPageSize());
        }

        request.setAttribute("filter", filter);
        request.setAttribute("result", result);
        request.setAttribute("sorts", ProductSort.values());
        // Chuỗi query (không có page) để JSP ghép link phân trang giữ nguyên bộ lọc.
        request.setAttribute("baseQuery", baseQuery(filter));
        request.getRequestDispatcher(Views.PRODUCT_LIST).forward(request, response);
    }

    // ---------------------------------------------------------------------

    private static ProductFilter parseFilter(HttpServletRequest request) {
        ProductFilter f = new ProductFilter();

        String q = request.getParameter("q");
        if (q != null && !q.isBlank()) {
            q = q.trim();
            f.setKeyword(q.length() > 100 ? q.substring(0, 100) : q);
        }
        f.setCategoryId(positiveInt(request.getParameter("category")));
        f.setSupplierId(positiveInt(request.getParameter("supplier")));
        f.setMaterialId(positiveInt(request.getParameter("material")));

        Long min = nonNegativeLong(request.getParameter("minPrice"));
        Long max = nonNegativeLong(request.getParameter("maxPrice"));
        if (min != null && max != null && min > max) { // người dùng nhập ngược -> đổi chỗ
            Long tmp = min;
            min = max;
            max = tmp;
        }
        f.setMinPrice(min);
        f.setMaxPrice(max);

        f.setSort(ProductSort.fromCode(request.getParameter("sort")));
        Integer page = positiveInt(request.getParameter("page"));
        f.setPage(page == null ? 1 : page);
        return f;
    }

    private static String baseQuery(ProductFilter f) {
        StringBuilder sb = new StringBuilder();
        append(sb, "q", f.getKeyword());
        append(sb, "category", f.getCategoryId());
        append(sb, "supplier", f.getSupplierId());
        append(sb, "material", f.getMaterialId());
        append(sb, "minPrice", f.getMinPrice());
        append(sb, "maxPrice", f.getMaxPrice());
        append(sb, "sort", f.getSort().getCode());
        return sb.toString();
    }

    private static void append(StringBuilder sb, String key, Object value) {
        if (value == null) return;
        if (sb.length() > 0) sb.append('&');
        sb.append(key).append('=').append(URLEncoder.encode(String.valueOf(value), StandardCharsets.UTF_8));
    }

    private static Integer positiveInt(String s) {
        try {
            int v = Integer.parseInt(s == null ? "" : s.trim());
            return v > 0 ? v : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private static Long nonNegativeLong(String s) {
        try {
            long v = Long.parseLong(s == null ? "" : s.trim());
            return v >= 0 ? v : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }
}