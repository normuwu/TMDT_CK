package com.tmdt.model;

import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * Read-only data for the profile page. A plain class with JavaBean getters
 * (not a record) because EL in Tomcat 10.1 reads getXxx() only.
 * Never carries the password hash.
 */
public class ProfileView {

    private static final DateTimeFormatter MEMBER_SINCE = DateTimeFormatter.ofPattern("MM/yyyy");

    private final String displayName;
    private final String initials;
    private final String email;
    private final String memberSince;

    private ProfileView(String displayName, String initials, String email, String memberSince) {
        this.displayName = displayName;
        this.initials = initials;
        this.email = email;
        this.memberSince = memberSince;
    }

    public static ProfileView from(User user) {
        String name = user.getFullName() == null ? "" : user.getFullName().trim();
        String since = user.getCreatedAt() == null ? "" : user.getCreatedAt().format(MEMBER_SINCE);
        return new ProfileView(name, initialsOf(name), user.getEmail(), since);
    }

    /** First letter of the last two words, upper-case ("Nguyễn Minh Anh" -> "MA"). */
    static String initialsOf(String fullName) {
        List<String> words = new ArrayList<>();
        for (String w : fullName.trim().split("\\s+")) {
            if (!w.isEmpty()) {
                words.add(w);
            }
        }
        if (words.isEmpty()) {
            return "U";
        }
        StringBuilder sb = new StringBuilder();
        for (String w : words.subList(Math.max(0, words.size() - 2), words.size())) {
            sb.append(w.substring(0, 1).toUpperCase());
        }
        return sb.toString();
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getInitials() {
        return initials;
    }

    public String getEmail() {
        return email;
    }

    public String getMemberSince() {
        return memberSince;
    }
}
