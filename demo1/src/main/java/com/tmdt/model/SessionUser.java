package com.tmdt.model;

import java.io.Serializable;

/**
 * The identity stored in the HttpSession under key "currentUser".
 * Never contains password_hash or other sensitive fields.
 */
public class SessionUser implements Serializable {
    private final int userId;
    private final String email;
    private final String fullName;
    private final Role role;

    public SessionUser(int userId, String email, String fullName, Role role) {
        this.userId = userId;
        this.email = email;
        this.fullName = fullName;
        this.role = role;
    }

    public int getUserId() {
        return userId;
    }

    public String getEmail() {
        return email;
    }

    public String getFullName() {
        return fullName;
    }

    public Role getRole() {
        return role;
    }

    public static final String SESSION_KEY = "currentUser";
}
