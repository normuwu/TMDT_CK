package com.tmdt.util;

import at.favre.lib.crypto.bcrypt.BCrypt;

/**
 * Password hashing with BCrypt (cost 12). Never log inputs or hashes.
 */
public final class PasswordUtil {

    public static final int BCRYPT_COST = 12;
    /** bcrypt() rejects plaintext longer than 72 bytes — validate before hashing. */
    public static final int MAX_PLAINTEXT_BYTES = 72;

    private PasswordUtil() {
    }

    /** Hash a plaintext password with BCrypt cost 12. */
    public static String hash(String plaintext) {
        return BCrypt.withDefaults().hashToString(BCRYPT_COST, plaintext.toCharArray());
    }

    /** Constant-time verification inside the library; returns true only on a match. */
    public static boolean verify(String plaintext, String bcryptHash) {
        return BCrypt.verifyer().verify(plaintext.toCharArray(), bcryptHash).verified;
    }

    /** BCrypt accepts at most 72 input bytes. */
    public static boolean isLengthSafe(String plaintext) {
        return plaintext != null && plaintext.getBytes(java.nio.charset.StandardCharsets.UTF_8).length <= MAX_PLAINTEXT_BYTES;
    }
}
