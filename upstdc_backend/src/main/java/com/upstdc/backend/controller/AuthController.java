package com.upstdc.backend.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

/**
 * PUBLIC_INTERFACE
 * AuthController provides stub authentication endpoints returning a static JWT-like token for development.
 */
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    // PUBLIC_INTERFACE
    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> body) {
        /**
         * Stub login endpoint that returns a static token and minimal user info.
         * Request: { "username": "...", "password": "..." }
         * Response: { "token": "stub.jwt.token", "user": { "username": "...", "roles": ["USER"] }, "issuedAt":  ... }
         */
        String username = body.getOrDefault("username", "guest");
        Map<String, Object> res = new HashMap<>();
        res.put("token", "stub.jwt.token");
        Map<String, Object> user = new HashMap<>();
        user.put("username", username);
        user.put("roles", new String[]{"USER"});
        res.put("user", user);
        res.put("issuedAt", Instant.now().toString());
        return ResponseEntity.ok(res);
    }

    // PUBLIC_INTERFACE
    @GetMapping("/me")
    public ResponseEntity<Map<String, Object>> me() {
        /** Returns stub user info for the current session. */
        Map<String, Object> user = new HashMap<>();
        user.put("username", "guest");
        user.put("roles", new String[]{"USER"});
        return ResponseEntity.ok(user);
    }
}
