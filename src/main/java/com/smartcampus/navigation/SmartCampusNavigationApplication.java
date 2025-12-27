package com.smartcampus.navigation;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Smart Campus Navigation System - Main Application
 * 
 * This application provides navigation services for university campus,
 * including route calculation, room availability checking, and real-time updates.
 * 
 * @author Smart Campus Team
 * @version 1.0.0
 */
@SpringBootApplication
public class SmartCampusNavigationApplication {

    public static void main(String[] args) {
        System.out.println("==============================================");
        System.out.println("  Smart Campus Navigation System Starting... ");
        System.out.println("==============================================");
        
        SpringApplication.run(SmartCampusNavigationApplication.class, args);
        
        System.out.println("==============================================");
        System.out.println("  Smart Campus Navigation System Started!    ");
        System.out.println("  Access at: http://localhost:8888           ");
        System.out.println("  Health: http://localhost:8888/actuator/health");
        System.out.println("==============================================");
    }

    /**
     * Configure CORS for cross-origin requests
     */
    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**")
                        .allowedOrigins("*")
                        .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                        .allowedHeaders("*");
            }
        };
    }
}

