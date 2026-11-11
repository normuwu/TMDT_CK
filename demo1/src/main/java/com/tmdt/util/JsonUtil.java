package com.tmdt.util;

import java.math.BigDecimal;

/**
 * JSON tối giản cho các API admin (dự án không dùng thư viện JSON).
 * Có escape đúng theo RFC 8259 và 2 builder nhỏ để ghép object/array an toàn:
 *
 * <pre>
 *   String body = new JsonUtil.Obj()
 *           .putNumber("total", 12)
 *           .putString("name", "Tên có \"nháy\"")
 *           .put("slices", new JsonUtil.Arr().addString("A").end())
 *           .end();
 * </pre>
 *
 * Giá trị null được ghi thành JSON null (không phải chuỗi "null").
 */
public final class JsonUtil {

    private JsonUtil() {
    }

    /** Escape một chuỗi thành nội dung bên trong cặp nháy kép. */
    public static String escape(String raw) {
        if (raw == null) {
            return "";
        }
        StringBuilder sb = new StringBuilder(raw.length() + 16);
        for (int i = 0; i < raw.length(); i++) {
            char c = raw.charAt(i);
            switch (c) {
                case '"' -> sb.append("\\\"");
                case '\\' -> sb.append("\\\\");
                case '\n' -> sb.append("\\n");
                case '\r' -> sb.append("\\r");
                case '\t' -> sb.append("\\t");
                case '\b' -> sb.append("\\b");
                case '\f' -> sb.append("\\f");
                default -> {
                    if (c < 0x20) {
                        sb.append(String.format("\\u%04x", (int) c));
                    } else {
                        sb.append(c);
                    }
                }
            }
        }
        return sb.toString();
    }

    /** Chuỗi JSON đã bọc nháy; null -> null (literal). */
    public static String quote(String value) {
        return value == null ? "null" : '"' + escape(value) + '"';
    }

    /** Số JSON không dùng ký hiệu mũ (BigDecimal#toPlainString). */
    public static String number(BigDecimal value) {
        if (value == null) {
            return "0";
        }
        BigDecimal normalized = value.stripTrailingZeros();
        if (normalized.scale() < 0) {
            normalized = normalized.setScale(0);
        }
        return normalized.toPlainString();
    }

    public static String number(long value) {
        return Long.toString(value);
    }

    /** Builder object: put() nhận JSON đã serialize, các putX() tự serialize. */
    public static final class Obj {
        private final StringBuilder sb = new StringBuilder(64);
        private boolean empty = true;

        public Obj put(String key, String rawJson) {
            if (!empty) {
                sb.append(',');
            }
            empty = false;
            sb.append('"').append(escape(key)).append("\":").append(rawJson);
            return this;
        }

        public Obj putString(String key, String value) {
            return put(key, quote(value));
        }

        public Obj putNumber(String key, long value) {
            return put(key, number(value));
        }

        public Obj putNumber(String key, BigDecimal value) {
            return put(key, number(value));
        }

        public Obj putBoolean(String key, boolean value) {
            return put(key, value ? "true" : "false");
        }

        public String end() {
            return '{' + sb.toString() + '}';
        }
    }

    /** Builder array. */
    public static final class Arr {
        private final StringBuilder sb = new StringBuilder(64);
        private boolean empty = true;

        public Arr add(String rawJson) {
            if (!empty) {
                sb.append(',');
            }
            empty = false;
            sb.append(rawJson);
            return this;
        }

        public Arr addString(String value) {
            return add(quote(value));
        }

        public String end() {
            return '[' + sb.toString() + ']';
        }
    }
}
