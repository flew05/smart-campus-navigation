package com.smartcampus.navigation.dto;

import java.util.List;

/**
 * Data Transfer Object for route calculation responses
 */
public class RouteResponse {
    private String from;
    private String to;
    private double distance;
    private int duration;
    private List<String> steps;
    private boolean accessible;

    // Constructors
    public RouteResponse() {
    }

    public RouteResponse(String from, String to, double distance, int duration, List<String> steps, boolean accessible) {
        this.from = from;
        this.to = to;
        this.distance = distance;
        this.duration = duration;
        this.steps = steps;
        this.accessible = accessible;
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

    public double getDistance() {
        return distance;
    }

    public void setDistance(double distance) {
        this.distance = distance;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public List<String> getSteps() {
        return steps;
    }

    public void setSteps(List<String> steps) {
        this.steps = steps;
    }

    public boolean isAccessible() {
        return accessible;
    }

    public void setAccessible(boolean accessible) {
        this.accessible = accessible;
    }

    @Override
    public String toString() {
        return "RouteResponse{" +
                "from='" + from + '\'' +
                ", to='" + to + '\'' +
                ", distance=" + distance +
                ", duration=" + duration +
                ", steps=" + steps +
                ", accessible=" + accessible +
                '}';
    }
}

