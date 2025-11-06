# uttar-pradesh-tourism-project-monitoring-system-219364-219380

This project now runs with two containers:
- upstdc_backend (Spring Boot backend)
- upstdc_frontend (Angular frontend)

Database container removed:
- The previous upstdc_database (PostgreSQL) container and dependency checks have been removed from the repo and orchestration.
- The backend runs without a real database by default using an in-memory stub profile (no persistence).

Backend start:
- The backend defines a Procfile with: `web: bash start.sh`
- `start.sh` starts Spring Boot directly without waiting for any database.

Backend configuration:
- server.port is fixed at 3001
- Default profile: "stub" (no DB). Optionally, an H2 memory profile "h2" can be used if needed.
- No DB environment variables are required anymore.

Frontend configuration:
- Ensure the frontend points to the backend base URL (http://localhost:3001 for local dev).

Environment variables for backend:
- `JAVA_OPTS` (optional JVM flags)
- `PORT` is not required; server port is fixed to 3001.

Orchestration notes:
- Only two containers are expected (frontend + backend). There is no database container in this repository and no services depend on it.
- The frontend may run even if the backend is down; it should target http://localhost:3001 for API calls in local dev.

Notes:
- Stub endpoints provide basic mocked data for auth, projects, and tenders to enable frontend development.