package com.tmdt.util;

import jakarta.servlet.http.HttpServletRequest;

/**
 * Best-effort client IP extraction behind reverse proxies.
 * Only used for brute-force throttling keys; never trusted for security
 * decisions on its own.
 */
public final class ClientIpUtil {

    private ClientIpUtil() {
    }

    public static String getIp(HttpServletRequest request) {
        String forwarded = request.getHeader("X-Forwarded-For");
        if (forwarded != null && !forwarded.isBlank()) {
            // The first entry is the original client.
            int comma = forwarded.indexOf(',');
            return (comma > 0 ? forwarded.substring(0, comma) : forwarded).trim();
        }
        String real = request.getHeader("X-Real-IP");
        if (real != null && !real.isBlank()) {
            return real.trim();
        }
        return request.getRemoteAddr();
    }
}
