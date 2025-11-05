#!/usr/bin/env bash
# Start script for UPSTDC backend Spring Boot app.
# This script is used by the preview system to start the service.
# It prefers running via Maven spring-boot:run for fast iteration.

set -euo pipefail

# Use provided PORT or default to 3001 (application.properties also defaults)
export PORT="${PORT:-3001}"

# If target directory missing, do a quick compile to warm up dependencies (optional)
if [ ! -d "target" ]; then
  mvn -q -DskipTests=true package -DskipTests
fi

# Run the application
exec mvn -q -DskipTests=true spring-boot:run
