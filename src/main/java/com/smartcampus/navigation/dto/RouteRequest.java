package com.smartcampus.navigation.dto;

/**
 * Data Transfer Object for route calculation requests
 */
public class RouteRequest {
    private String from;
    private String to;
    private String userId;
    private boolean accessibilityRequired;

    // Constructors
    public RouteRequest() {
    }

    public RouteRequest(String from, String to, String userId, boolean accessibilityRequired) {
        this.from = from;
        this.to = to;
        this.userId = userId;
        this.accessibilityRequired = accessibilityRequired;
    }

    // Getters and Setters
    public String getFrom() {
        return from;
    }

    public void setFrom(String from) {
        this.from = from;
    }

    public String getTo() {
        return to;
    }

    public void setTo(String to) {
        this.to = to;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public boolean isAccessibilityRequired() {
        return accessibilityRequired;
    }

    public void setAccessibilityRequired(boolean accessibilityRequired) {
        this.accessibilityRequired = accessibilityRequired;
    }

    @Override
    public String toString() {
        return "RouteRequest{" +
                "from='" + from + '\'' +
                ", to='" + to + '\'' +
                ", userId='" + userId + '\'' +
                ", accessibilityRequired=" + accessibilityRequired +
                '}';
    }
}

