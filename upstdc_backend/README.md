# UPSTDC Backend (Spring Boot)

This is the Spring Boot backend for the Uttar Pradesh Tourism Project Monitoring System (UPSTDC).

## How the preview/orchestrator starts this container

- The preview system detects a start command via `Procfile`:
  - `web: bash start.sh`
- `start.sh`:
  - Starts the Spring Boot app using Maven wrapper if available (no DB wait).
  - Builds if needed.
  - Applies `JAVA_OPTS` if provided.

## Ports

- The backend listens on `server.port=3001` (configured in `application.properties`).

## Environment variables

No database environment variables are required (no PG_ or JDBC_ values needed).
- `JAVA_OPTS` (optional JVM flags)
- `PORT` is not required; server port is fixed to 3001.

## Profiles

- Default: stub/no-db mode (datasource and JPA autoconfiguration disabled).
- Optional: H2 memory mode (`--spring.profiles.active=h2`) if needed for future development; H2 config is commented in application.properties.

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
- `GET /actuator/readiness` and `/actuator/liveness` — readiness/liveness probes
- Stub API endpoints:
  - `POST /api/auth/login` — returns a static token and user info
  - `GET /api/auth/me` — returns stub user info
  - `GET /api/projects` — returns in-memory list of projects
  - `GET /api/projects/{id}` — returns project by id
  - `GET /api/tenders` — returns in-memory list of tenders
  - `GET /api/tenders/{id}` — returns tender by id

## Notes

- The `application.properties` sets server port to `3001` and disables datasource/JPA autoconfiguration by default.
- The Maven `spring-boot-maven-plugin` is configured with `repackage` to create an executable jar for production use.
