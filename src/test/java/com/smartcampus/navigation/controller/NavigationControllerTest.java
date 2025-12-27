package com.smartcampus.navigation.controller;

import com.smartcampus.navigation.dto.RouteRequest;
import com.smartcampus.navigation.service.NavigationService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.HashMap;
import java.util.Map;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Unit tests for NavigationController
 */
@WebMvcTest(NavigationController.class)
class NavigationControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private NavigationService navigationService;

    @Test
    void testWelcomeEndpoint() throws Exception {
        mockMvc.perform(get("/api/navigation/"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").exists())
                .andExpect(jsonPath("$.version").value("1.0.0"))
                .andExpect(jsonPath("$.status").value("active"));
    }

    @Test
    void testHealthEndpoint() throws Exception {
        mockMvc.perform(get("/api/navigation/health"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("UP"))
                .andExpect(jsonPath("$.service").value("Navigation Service"));
    }

    @Test
    void testGetUserLocation() throws Exception {
        Map<String, Object> mockLocation = new HashMap<>();
        mockLocation.put("userId", "user123");
        mockLocation.put("latitude", 40.7128);
        mockLocation.put("longitude", -74.0060);
        
        when(navigationService.getUserLocation("user123")).thenReturn(mockLocation);
        
        mockMvc.perform(get("/api/navigation/location/user123"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.userId").value("user123"))
                .andExpect(jsonPath("$.latitude").exists())
                .andExpect(jsonPath("$.longitude").exists());
    }

    @Test
    void testCheckRoomAvailability() throws Exception {
        Map<String, Object> mockAvailability = new HashMap<>();
        mockAvailability.put("roomId", "room101");
        mockAvailability.put("available", true);
        mockAvailability.put("capacity", 50);
        
        when(navigationService.checkRoomAvailability("room101")).thenReturn(mockAvailability);
        
        mockMvc.perform(get("/api/navigation/room/room101/availability"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.roomId").value("room101"))
                .andExpect(jsonPath("$.available").value(true))
                .andExpect(jsonPath("$.capacity").value(50));
    }
}

