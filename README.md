# uttar-pradesh-tourism-project-monitoring-system-219364-219380

This project runs with two containers only:
- upstdc_backend (Spring Boot backend)
- upstdc_frontend (Angular frontend)

Database removed (intentional):
- The previous upstdc_database container and all DB-related services, ports, and readiness dependencies have been fully removed from this repository.
- The backend runs in stub/no-DB mode by default with in-memory data (no persistence).
- There is no PostgreSQL service, no DB visualizer, and no DB ports (e.g., 5000/3020) used anywhere in this repository.

Backend start:
- The backend defines a Procfile with: `web: bash start.sh`
- `start.sh` starts Spring Boot directly without waiting for any database or PG env vars.

Backend configuration:
- server.port is fixed at 3001
- Default profile: "stub" (no DB). Optionally, an H2 memory profile "h2" can be used if needed (commented in application.properties).
- No DB environment variables are required anymore.

Frontend configuration:
- Ensure the frontend points to the backend base URL (http://localhost:3001 for local dev). Only dependency is the backend.

Environment variables for backend:
- `JAVA_OPTS` (optional JVM flags)
- `PORT` is not required; server port is fixed to 3001.

Orchestration notes:
- Only two containers are expected (frontend + backend). There is no database container and no services depend on it.
- The frontend may run even if the backend is down; it should target http://localhost:3001 for API calls in local dev.

Notes:
- Stub endpoints provide basic mocked data for auth, projects, and tenders to enable frontend development.