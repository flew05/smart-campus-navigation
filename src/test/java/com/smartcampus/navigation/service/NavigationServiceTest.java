package com.smartcampus.navigation.service;

import com.smartcampus.navigation.dto.RouteRequest;
import com.smartcampus.navigation.dto.RouteResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for NavigationService
 */
@SpringBootTest
class NavigationServiceTest {

    @Autowired
    private NavigationService navigationService;

    private RouteRequest routeRequest;

    @BeforeEach
    void setUp() {
        routeRequest = new RouteRequest();
        routeRequest.setFrom("Building A");
        routeRequest.setTo("Building B");
        routeRequest.setUserId("user123");
        routeRequest.setAccessibilityRequired(false);
    }

    @Test
    void testCalculateRoute() {
        RouteResponse response = navigationService.calculateRoute(routeRequest);
        
        assertNotNull(response, "Response should not be null");
        assertEquals("Building A", response.getFrom());
        assertEquals("Building B", response.getTo());
        assertTrue(response.getDistance() > 0, "Distance should be positive");
        assertTrue(response.getDuration() > 0, "Duration should be positive");
        assertNotNull(response.getSteps(), "Steps should not be null");
        assertFalse(response.getSteps().isEmpty(), "Steps should not be empty");
    }

    @Test
    void testCalculateRouteWithAccessibility() {
        routeRequest.setAccessibilityRequired(true);
        RouteResponse response = navigationService.calculateRoute(routeRequest);
        
        assertTrue(response.isAccessible(), "Route should be marked as accessible");
    }

    @Test
    void testGetUserLocation() {
        Map<String, Object> location = navigationService.getUserLocation("user123");
        
        assertNotNull(location, "Location should not be null");
        assertEquals("user123", location.get("userId"));
        assertNotNull(location.get("latitude"));
        assertNotNull(location.get("longitude"));
        assertNotNull(location.get("building"));
    }

    @Test
    void testCheckRoomAvailability() {
        Map<String, Object> availability = navigationService.checkRoomAvailability("room101");
        
        assertNotNull(availability, "Availability should not be null");
        assertEquals("room101", availability.get("roomId"));
        assertTrue((Boolean) availability.get("available"), "Room should be available");
        assertTrue((Integer) availability.get("capacity") > 0, "Capacity should be positive");
    }

    @Test
    void testRouteStepsGeneration() {
        RouteResponse response = navigationService.calculateRoute(routeRequest);
        
        assertNotNull(response.getSteps());
        assertTrue(response.getSteps().size() >= 2, "Should have at least start and end steps");
        assertTrue(response.getSteps().get(0).contains("Start"), "First step should contain 'Start'");
        assertTrue(response.getSteps().get(response.getSteps().size() - 1).contains("Arrive"), 
                  "Last step should contain 'Arrive'");
    }
}

