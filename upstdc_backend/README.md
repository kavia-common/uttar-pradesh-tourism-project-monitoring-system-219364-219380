# UPSTDC Backend (Spring Boot)

This is the Spring Boot backend for the Uttar Pradesh Tourism Project Monitoring System (UPSTDC).

## How the preview system starts this container

- The preview system detects a start command via `Procfile`:
  - `web: mvn -q -DskipTests=true spring-boot:run`
- The application listens on `server.port` which is configured to prefer the environment variable `PORT`, defaulting to `3001`.

## Local development

- Prerequisites: Java 17+, Maven 3.9+
- Run:
  ```bash
  export PORT=3001
  mvn spring-boot:run
  ```
- Build an executable jar:
  ```bash
  mvn -DskipTests=true package
  java -jar target/upstdc-backend-0.0.1-SNAPSHOT.jar
  ```

## Endpoints

- `GET /` — basic liveness text: "UPSTDC Backend is running"
- `GET /actuator/health` — health status
- `GET /actuator/info` — app info

## Notes

- The `application.properties` sets `server.port=${PORT:3001}` so there are no hard-coded port conflicts.
- The Maven `spring-boot-maven-plugin` is configured with `repackage` to create an executable jar for production use.
