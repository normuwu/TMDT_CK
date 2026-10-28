package com.tmdt.util;

import com.tmdt.model.Role;

/**
 * Single place for view paths and auth URLs. Context path is NOT included
 * here — servlets must always prepend request.getContextPath().
 */
public final class Views {

    // --- JSP forwards (servlet-internal) ---
    public static final String LOGIN = "/WEB-INF/views/auth/login.jsp";
    public static final String REGISTER = "/WEB-INF/views/auth/register.jsp";
    public static final String FORGOT_PASSWORD = "/WEB-INF/views/auth/forgot-password.jsp";
    public static final String RESET_PASSWORD = "/WEB-INF/views/auth/reset-password.jsp";
    public static final String VERIFY_RESULT = "/WEB-INF/views/auth/verify-result.jsp";

    public static final String PRODUCT_LIST = "/WEB-INF/views/product/san_pham.jsp";
    public static final String PRODUCT_LIST_URL = "/KhachHang/san_pham.jsp";
    public static final String PRODUCT_DETAIL = "/WEB-INF/views/product/product-detail.jsp";
    public static final String PRODUCT_DETAIL_URL = "/KhachHang/chi-tiet-san-pham";

    // --- Giỏ hàng / đơn hàng ---
    public static final String CART = "/WEB-INF/views/cart/cart.jsp";
    public static final String CHECKOUT = "/WEB-INF/views/cart/checkout.jsp";
    public static final String ORDER_SUCCESS = "/WEB-INF/views/cart/success.jsp";
    public static final String ORDER_HISTORY = "/WEB-INF/views/cart/history.jsp";
    public static final String ORDER_DETAIL = "/WEB-INF/views/cart/order-detail.jsp";

    public static final String CART_URL = "/KhachHang/gio-hang";
    public static final String ADD_TO_CART_URL = "/KhachHang/them-vao-gio";
    public static final String CHECKOUT_URL = "/KhachHang/thanh-toan";
    public static final String ORDER_SUCCESS_URL = "/KhachHang/dat-hang-thanh-cong";
    public static final String ORDER_HISTORY_URL = "/KhachHang/lich-su-mua-hang";
    public static final String ORDER_DETAIL_URL = "/KhachHang/chi-tiet-don-hang";
    // --- Browser-facing URLs (context path prepended by the caller) ---
    public static final String LOGIN_URL = "/login";
    public static final String REGISTER_URL = "/register";
    public static final String FORGOT_PASSWORD_URL = "/forgot-password";
    public static final String RESET_PASSWORD_URL = "/reset-password";
    public static final String VERIFY_EMAIL_URL = "/verify-email";

    // --- Landing pages after login (existing demo pages; revisit targets
    //     when those screens are wired to real backend features). ---
    public static final String HOME_CUSTOMER = "/KhachHang/trang_chu.jsp";
    public static final String HOME_SELLER = "/NhaCungCap/dashBoard.jsp"; // TODO: confirm the seller dashboard target
    public static final String HOME_ADMIN = "/Admin/admin.jsp";           // giao diện thống kê thật (mục #reports)

    /** Landing page after a successful login, by role. */
    public static String homeFor(Role role) {
        if (role == null) return LOGIN_URL;
        return switch (role) {
            case SELLER -> HOME_SELLER;
            case ADMIN -> HOME_ADMIN;
            case CUSTOMER -> HOME_CUSTOMER;
        };
    }

    private Views() {
    }
}
