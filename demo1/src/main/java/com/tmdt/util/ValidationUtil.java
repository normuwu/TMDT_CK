package com.tmdt.util;

import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * Server-side validation helpers. Field max lengths mirror the real
 * `users` columns: email 150, full_name 100, phone 20, avatar_url 500,
 * default_address 300.
 */
public final class ValidationUtil {

    public static final int EMAIL_MAX = 150;
    public static final int FULL_NAME_MAX = 100;
    public static final int PHONE_MAX = 20;
    public static final int AVATAR_URL_MAX = 500;
    public static final int DEFAULT_ADDRESS_MAX = 300;

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");
    /** Vietnamese mobile: 10 digits starting with 0. */
    private static final Pattern VN_PHONE_PATTERN = Pattern.compile("^0\\d{9}$");

    private ValidationUtil() {
    }

    /** Trim + lowercase; email is stored unique so the format must be canonical. */
    public static String normalizeEmail(String email) {
        return email == null ? null : email.trim().toLowerCase();
    }

    /** Strips spaces, '.' and '-' before the VN mobile check. */
    public static String normalizePhone(String phone) {
        if (phone == null) return null;
        return phone.replaceAll("[\\s.\\-]", "");
    }

    public static boolean isValidEmail(String email) {
        return email != null && email.length() <= EMAIL_MAX && EMAIL_PATTERN.matcher(email).matches();
    }

    public static boolean isValidVnPhone(String normalizedPhone) {
        return normalizedPhone != null && normalizedPhone.length() <= PHONE_MAX
                && VN_PHONE_PATTERN.matcher(normalizedPhone).matches();
    }

    public static boolean isValidFullName(String fullName) {
        return fullName != null && !fullName.isBlank() && fullName.length() <= FULL_NAME_MAX;
    }

    /** Between 8 and 72 bytes (bcrypt limit). */
    public static boolean isValidPassword(String password) {
        if (password == null) return false;
        int bytes = password.getBytes(StandardCharsets.UTF_8).length;
        return bytes >= 8 && bytes <= 72;
    }

    /**
     * Internal redirect targets only: starts with a single '/', never '//',
     * and never contains path-breaking characters (':' backslash, CR/LF).
     * Blocks open redirects like //evil.com and https://evil.com.
     */
    public static boolean isSafeRedirect(String target) {
        if (target == null || target.isEmpty() || target.length() > 500) return false;
        if (target.charAt(0) != '/' || target.startsWith("//")) return false;
        for (int i = 0; i < target.length(); i++) {
            char c = target.charAt(i);
            if (c == ':' || c == '\\' || c == '\r' || c == '\n') return false;
        }
        return true;
    }

    /** Adds an error to the map under the field name when the check fails. */
    public static void addFieldError(Map<String, String> errors, String field, String message) {
        if (message != null) {
            errors.put(field, message);
        }
    }
}
