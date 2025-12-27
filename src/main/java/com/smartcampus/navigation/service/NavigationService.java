package com.smartcampus.navigation.service;

import com.smartcampus.navigation.dto.RouteRequest;
import com.smartcampus.navigation.dto.RouteResponse;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * Service for navigation operations
 */
@Service
public class NavigationService {

    /**
     * Calculate route between two points
     */
    public RouteResponse calculateRoute(RouteRequest request) {
        RouteResponse response = new RouteResponse();
        response.setFrom(request.getFrom());
        response.setTo(request.getTo());
        response.setDistance(calculateDistance(request.getFrom(), request.getTo()));
        response.setDuration(estimateDuration(response.getDistance()));
        response.setSteps(generateRouteSteps(request.getFrom(), request.getTo()));
        response.setAccessible(request.isAccessibilityRequired());
        
        return response;
    }

    /**
     * Get user location
     */
    public Map<String, Object> getUserLocation(String userId) {
        Map<String, Object> location = new HashMap<>();
        location.put("userId", userId);
        location.put("latitude", 40.7128);
        location.put("longitude", -74.0060);
        location.put("building", "Main Building");
        location.put("floor", 1);
        location.put("timestamp", new Date());
        
        return location;
    }

    /**
     * Check room availability
     */
    public Map<String, Object> checkRoomAvailability(String roomId) {
        Map<String, Object> availability = new HashMap<>();
        availability.put("roomId", roomId);
        availability.put("available", true);
        availability.put("capacity", 50);
        availability.put("currentOccupancy", 0);
        availability.put("nextBooking", "14:00");
        
        return availability;
    }

    /**
     * Calculate distance between two points (simplified)
     */
    private double calculateDistance(String from, String to) {
        // Simplified calculation - in real system would use actual coordinates
        return Math.random() * 1000 + 100;
    }

    /**
     * Estimate duration based on distance
     */
    private int estimateDuration(double distance) {
        // Assume walking speed of 1.4 m/s (5 km/h)
        return (int) (distance / 1.4);
    }

    /**
     * Generate route steps
     */
    private List<String> generateRouteSteps(String from, String to) {
        List<String> steps = new ArrayList<>();
        steps.add("Start at " + from);
        steps.add("Walk straight for 100 meters");
        steps.add("Turn right at the main entrance");
        steps.add("Continue for 200 meters");
        steps.add("Arrive at " + to);
        
        return steps;
    }
}

