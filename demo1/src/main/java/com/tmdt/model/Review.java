package com.tmdt.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Review {
    private static final DateTimeFormatter DATE = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private int reviewId;
    private int userId;
    private String userName;
    private int rating;
    private String comment;
    private LocalDateTime createdAt;

    public int getReviewId() { return reviewId; }
    public void setReviewId(int reviewId) { this.reviewId = reviewId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    /** dd/MM/yyyy, để JSP khỏi phải định dạng java.time. */
    public String getCreatedDate() {
        return createdAt == null ? "" : createdAt.format(DATE);
    }

    /** Chữ cái đầu của tối đa 2 từ cuối trong tên, viết hoa (ảnh đại diện chữ). */
    public String getInitials() {
        if (userName == null || userName.isBlank()) return "U";
        String[] parts = userName.trim().split("\\s+");
        StringBuilder sb = new StringBuilder();
        for (int i = Math.max(0, parts.length - 2); i < parts.length; i++) {
            sb.append(Character.toUpperCase(parts[i].charAt(0)));
        }
        return sb.toString();
    }
}