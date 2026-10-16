package com.tmdt.model;

import java.time.Duration;

/**
 * Mirrors the real DB check constraint on user_tokens.token_type:
 * EMAIL_VERIFICATION | PASSWORD_RESET (REMEMBER_ME appears after the V2
 * migration). Each type carries its own lifetime, aligned with the UI copy:
 * EMAIL_VERIFICATION mentions 24h, PASSWORD_RESET “30 phút”.
 */
public enum TokenType {
    EMAIL_VERIFICATION(Duration.ofHours(24)),
    PASSWORD_RESET(Duration.ofMinutes(30)),
    REMEMBER_ME(Duration.ofDays(30));

    private final Duration ttl;

    TokenType(Duration ttl) {
        this.ttl = ttl;
    }

    public Duration ttl() {
        return ttl;
    }

    /** Returns null when the value is not a valid token type string. */
    public static TokenType fromString(String value) {
        if (value == null) return null;
        try {
            return TokenType.valueOf(value.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
