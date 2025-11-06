package com.upstdc.backend.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/**
 * PUBLIC_INTERFACE
 * TendersController provides stubbed read-only endpoints for tenders using in-memory data.
 */
@RestController
@RequestMapping("/api/tenders")
public class TendersController {

    private static final List<Map<String, Object>> TENDERS = new ArrayList<>();

    static {
        Map<String, Object> t1 = new HashMap<>();
        t1.put("id", 1001);
        t1.put("title", "Construction of Visitor Center");
        t1.put("status", "Open");
        t1.put("projectId", 1);
        TENDERS.add(t1);

        Map<String, Object> t2 = new HashMap<>();
        t2.put("id", 1002);
        t2.put("title", "Landscape and Beautification");
        t2.put("status", "Closed");
        t2.put("projectId", 2);
        TENDERS.add(t2);
    }

    // PUBLIC_INTERFACE
    @GetMapping
    public ResponseEntity<List<Map<String, Object>>> list() {
        /** Returns a list of stubbed tenders. */
        return ResponseEntity.ok(TENDERS);
    }

    // PUBLIC_INTERFACE
    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> get(@PathVariable("id") Integer id) {
        /** Returns a single tender by id if present, 404 otherwise. */
        return TENDERS.stream()
                .filter(t -> Objects.equals(t.get("id"), id))
                .findFirst()
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}
