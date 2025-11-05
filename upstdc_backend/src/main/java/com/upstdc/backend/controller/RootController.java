package com.upstdc.backend.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * PUBLIC_INTERFACE
 * RootController provides a minimal root endpoint to verify that the application is running.
 */
@RestController
public class RootController {

    // PUBLIC_INTERFACE
    @GetMapping("/")
    public String root() {
        /** Returns a simple message indicating the backend is up. */
        return "UPSTDC Backend is running";
    }
}
