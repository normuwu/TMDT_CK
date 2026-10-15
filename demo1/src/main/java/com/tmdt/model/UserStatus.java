package com.tmdt.model;

/** Mirrors the DB check constraint: status IN ('ACTIVE','LOCKED'). */
public enum UserStatus {
    ACTIVE, LOCKED;

    /** Returns null when the value is not a valid status string. */
    public static UserStatus fromString(String value) {
        if (value == null) return null;
        try {
            return UserStatus.valueOf(value.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
