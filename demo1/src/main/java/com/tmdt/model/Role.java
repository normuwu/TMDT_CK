package com.tmdt.model;

/**
 * Mirrors the DB check constraint: role IN ('CUSTOMER','SELLER','ADMIN').
 * Note: the plan mentioned "SUPPLIER" but the real schema uses SELLER.
 */
public enum Role {
    CUSTOMER, SELLER, ADMIN;

    /** Returns null when the value is not a valid role string. */
    public static Role fromString(String value) {
        if (value == null) return null;
        try {
            return Role.valueOf(value.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
