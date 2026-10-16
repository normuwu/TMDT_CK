package com.tmdt.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * Flash messages: survive one redirect, are shown on the next request, then
 * removed. Keys in session: flash.success / flash.error; they are copied to
 * request attributes success / error before rendering a JSP.
 */
public final class FlashUtil {

    public static final String KEY_SUCCESS = "flash.success";
    public static final String KEY_ERROR = "flash.error";

    private FlashUtil() {
    }

    public static void flashSuccess(HttpSession session, String message) {
        session.setAttribute(KEY_SUCCESS, message);
    }

    public static void flashError(HttpSession session, String message) {
        session.setAttribute(KEY_ERROR, message);
    }

    /**
     * Moves any pending flash from the session into request attributes
     * (success / error) and clears the session so it shows only once.
     * Call this on every GET that forwards to a JSP.
     */
    public static void moveToRequest(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return;

        String success = (String) session.getAttribute(KEY_SUCCESS);
        if (success != null) {
            request.setAttribute("success", success);
            session.removeAttribute(KEY_SUCCESS);
        }
        String error = (String) session.getAttribute(KEY_ERROR);
        if (error != null) {
            request.setAttribute("error", error);
            session.removeAttribute(KEY_ERROR);
        }
    }
}
