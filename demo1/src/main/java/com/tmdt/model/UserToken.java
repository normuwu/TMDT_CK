package com.tmdt.model;

import java.time.LocalDateTime;

/**
 * One row of the `user_tokens` table. token_code always stores the SHA-256
 * hex hash of a raw token; the raw token lives only in the email link or
 * remember-me cookie and is never persisted.
 */
public class UserToken {
    private long tokenId;
    private int userId;
    private String tokenCode;
    private TokenType tokenType;
    private LocalDateTime expiresAt;
    private boolean used;
    private LocalDateTime createdAt;

    public UserToken() {
    }

    public long getTokenId() {
        return tokenId;
    }

    public void setTokenId(long tokenId) {
        this.tokenId = tokenId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTokenCode() {
        return tokenCode;
    }

    public void setTokenCode(String tokenCode) {
        this.tokenCode = tokenCode;
    }

    public TokenType getTokenType() {
        return tokenType;
    }

    public void setTokenType(TokenType tokenType) {
        this.tokenType = tokenType;
    }

    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }

    public boolean isUsed() {
        return used;
    }

    public void setUsed(boolean used) {
        this.used = used;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    /** Convenience: has this token already expired (checked against `now`)? */
    public boolean isExpired() {
        return expiresAt != null && expiresAt.isBefore(LocalDateTime.now());
    }
}
