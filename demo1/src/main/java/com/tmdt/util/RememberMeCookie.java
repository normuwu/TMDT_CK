package com.tmdt.util;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.util.Optional;

/**
 * Remember-me cookie handling. The cookie carries the RAW token; the DB only
 * ever sees its SHA-256 hash. Attributes: HttpOnly, SameSite=Lax,
 * Secure when the request arrived over HTTPS, 30-day max age, Path=/.
 */
public final class RememberMeCookie {

    public static final String NAME = "remember-me";
    public static final int MAX_AGE_SECONDS = 30 * 24 * 60 * 60; // 30 days

    private RememberMeCookie() {
    }

    public static Optional<Cookie> get(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) return Optional.empty();
        for (Cookie c : cookies) {
            if (NAME.equals(c.getName())) {
                return Optional.of(c);
            }
        }
        return Optional.empty();
    }

    /** Issues (or rotates) the cookie for the next 30 days. */
    public static void set(HttpServletResponse response, String rawToken, boolean secure) {
        Cookie cookie = new Cookie(NAME, rawToken);
        cookie.setHttpOnly(true);
        cookie.setSecure(secure); // enable in production behind HTTPS
        cookie.setMaxAge(MAX_AGE_SECONDS);
        cookie.setPath("/");
        cookie.setAttribute("SameSite", "Lax");
        response.addCookie(cookie);
    }

    /** Deletes the cookie client-side; the DB token is revoked separately. */
    public static void clear(HttpServletResponse response) {
        Cookie cookie = new Cookie(NAME, "");
        cookie.setHttpOnly(true);
        cookie.setPath("/");
        cookie.setMaxAge(0);
        cookie.setAttribute("SameSite", "Lax");
        response.addCookie(cookie);
    }
}
