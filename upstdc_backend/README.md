# UPSTDC Backend (Spring Boot)

This is the Spring Boot backend for the Uttar Pradesh Tourism Project Monitoring System (UPSTDC).

## How the preview/orchestrator starts this container

- The preview system detects a start command via `Procfile`:
  - `web: bash start.sh`
- `start.sh`:
  - Waits for the PostgreSQL database (upstdc_database) to be ready using `pg_isready` (or TCP fallback).
  - Builds if needed and starts the Spring Boot app using Maven wrapper if available.
  - Applies `JAVA_OPTS` if provided.

## Ports

- The backend listens on `server.port=3001` (configured in `application.properties`).

## Environment variables

The backend reads database configuration from environment variables:
- `DB_HOST` (default: `upstdc_database`)
- `DB_PORT` (default: `5000`)
- `DB_NAME` (default: `upstdc`)
- `DB_USER` (default: `upstdc`)
- `DB_PASSWORD` (default: `upstdc`)
- `JAVA_OPTS` (optional JVM flags)
- `PORT` is not required; server port is fixed to 3001.

Example:
```bash
export DB_HOST=upstdc_database
export DB_PORT=5000
export DB_NAME=upstdc
export DB_USER=upstdc
export DB_PASSWORD=secret
bash start.sh
```

## Local development

- Prerequisites: Java 17+, Maven 3.9+
- Run:
  ```bash
  bash start.sh
  ```
- Build an executable jar:
  ```bash
  mvn -DskipTests=true package
  java -jar target/upstdc-backend-0.0.1-SNAPSHOT.jar
  ```

## Endpoints

- `GET /` — basic liveness text: "UPSTDC Backend is running"
- `GET /healthz` — simple OK text
- `GET /actuator/health` — health status (includes probes)
- `GET /actuator/info` — app info
- `GET /actuator/readiness` and `/actuator/liveness` — readiness/liveness probes (enabled via actuator probes)

## Notes

- The `application.properties` sets server port to `3001` and reads DB settings from environment variables.
- The Maven `spring-boot-maven-plugin` is configured with `repackage` to create an executable jar for production use.
