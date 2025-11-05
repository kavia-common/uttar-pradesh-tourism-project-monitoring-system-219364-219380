package com.upstdc.backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * PUBLIC_INTERFACE
 * UpstdcBackendApplication is the Spring Boot entry point for the UPSTDC Project Monitoring System backend.
 * This class bootstraps the application.
 */
@SpringBootApplication
public class UpstdcBackendApplication {

    // PUBLIC_INTERFACE
    public static void main(String[] args) {
        /**
         * This is the main method that launches the Spring Boot application.
         * It reads standard Spring configuration including server.port from environment or application properties.
         */
        SpringApplication.run(UpstdcBackendApplication.class, args);
    }
}
