package com.smartcampus.navigation.controller;

import com.smartcampus.navigation.dto.RouteRequest;
import com.smartcampus.navigation.dto.RouteResponse;
import com.smartcampus.navigation.service.NavigationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * REST Controller for navigation operations
 */
@RestController
@RequestMapping("/api/navigation")
public class NavigationController {

    @Autowired
    private NavigationService navigationService;

    /**
     * Welcome endpoint
     */
    @GetMapping("/")
    public ResponseEntity<Map<String, Object>> welcome() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Welcome to Smart Campus Navigation System");
        response.put("version", "1.0.0");
        response.put("status", "active");
        return ResponseEntity.ok(response);
    }

    /**
     * Calculate route between two points
     */
    @PostMapping("/route")
    public ResponseEntity<RouteResponse> calculateRoute(@RequestBody RouteRequest request) {
        RouteResponse response = navigationService.calculateRoute(request);
        return ResponseEntity.ok(response);
    }

    /**
     * Get current location
     */
    @GetMapping("/location/{userId}")
    public ResponseEntity<Map<String, Object>> getUserLocation(@PathVariable String userId) {
        Map<String, Object> location = navigationService.getUserLocation(userId);
        return ResponseEntity.ok(location);
    }

    /**
     * Check room availability
     */
    @GetMapping("/room/{roomId}/availability")
    public ResponseEntity<Map<String, Object>> checkRoomAvailability(@PathVariable String roomId) {
        Map<String, Object> availability = navigationService.checkRoomAvailability(roomId);
        return ResponseEntity.ok(availability);
    }

    /**
     * Health check endpoint
     */
    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> health() {
        Map<String, String> health = new HashMap<>();
        health.put("status", "UP");
        health.put("service", "Navigation Service");
        return ResponseEntity.ok(health);
    }
}

