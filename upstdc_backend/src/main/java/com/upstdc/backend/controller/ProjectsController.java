package com.upstdc.backend.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/**
 * PUBLIC_INTERFACE
 * ProjectsController provides stubbed read-only endpoints for projects using in-memory data.
 */
@RestController
@RequestMapping("/api/projects")
public class ProjectsController {

    private static final List<Map<String, Object>> PROJECTS = new ArrayList<>();

    static {
        Map<String, Object> p1 = new HashMap<>();
        p1.put("id", 1);
        p1.put("name", "Heritage Walkway Renovation");
        p1.put("status", "In Progress");
        p1.put("location", "Varanasi");
        PROJECTS.add(p1);

        Map<String, Object> p2 = new HashMap<>();
        p2.put("id", 2);
        p2.put("name", "Eco-Tourism Park Development");
        p2.put("status", "Planned");
        p2.put("location", "Dudhwa");
        PROJECTS.add(p2);
    }

    // PUBLIC_INTERFACE
    @GetMapping
    public ResponseEntity<List<Map<String, Object>>> list() {
        /** Returns a list of stubbed projects. */
        return ResponseEntity.ok(PROJECTS);
    }

    // PUBLIC_INTERFACE
    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> get(@PathVariable("id") Integer id) {
        /** Returns a single project by id if present, 404 otherwise. */
        return PROJECTS.stream()
                .filter(p -> Objects.equals(p.get("id"), id))
                .findFirst()
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}
