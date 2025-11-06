# uttar-pradesh-tourism-project-monitoring-system-219364-219380

This project contains multiple containers:
- upstdc_backend (Spring Boot backend)
- upstdc_database (PostgreSQL database)
- upstdc_frontend (Angular frontend)

Backend start:
- The backend defines a Procfile with: `web: bash start.sh`
- `start.sh` waits for database readiness before starting Spring Boot.

Environment variables for backend:
- DB_HOST, DB_PORT (default 5000), DB_NAME, DB_USER, DB_PASSWORD