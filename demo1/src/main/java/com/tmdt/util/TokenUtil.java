package com.tmdt.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Secure token generation and hashing.
 * Raw tokens are Base64 URL-safe (32 random bytes -> 43 chars) and are only
 * delivered through email links / cookies. The DB stores the SHA-256 hex
 * (exactly 64 chars, fits users_tokens.token_code varchar(64)).
 */
public final class TokenUtil {

    public static final int RAW_TOKEN_BYTES = 32;
    public static final int SHA256_HEX_LENGTH = 64;

    private static final SecureRandom RANDOM = new SecureRandom();

    private TokenUtil() {
    }

    /** Random, URL-safe token (reversible: it is the value sent to the user). */
    public static String generateRawToken() {
        byte[] bytes = new byte[RAW_TOKEN_BYTES];
        RANDOM.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    /** SHA-256 of the raw token, hex encoded (this is what goes to the DB). */
    public static String sha256Hex(String rawToken) {
        try {
            byte[] digest = MessageDigest.getInstance("SHA-256")
                    .digest(rawToken.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(digest.length * 2);
            for (byte b : digest) {
                sb.append(Character.forDigit((b >> 4) & 0xF, 16))
                        .append(Character.forDigit(b & 0xF, 16));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 not available", e);
        }
    }

    /** Constant-time equality for secrets (never use String.equals). */
    public static boolean constantTimeEquals(String a, String b) {
        if (a == null || b == null) return false;
        return MessageDigest.isEqual(a.getBytes(StandardCharsets.UTF_8), b.getBytes(StandardCharsets.UTF_8));
    }
}
