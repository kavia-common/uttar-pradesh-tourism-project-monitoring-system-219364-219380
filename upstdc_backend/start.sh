#!/usr/bin/env bash
# Start script for UPSTDC backend Spring Boot app.
# - Starts Spring Boot with Maven wrapper if available
# - Honors JAVA_OPTS if provided
# - No database dependency or wait

set -euo pipefail

PORT="${PORT:-3001}"
JAVA_OPTS="${JAVA_OPTS:-}"

echo "[start.sh] Starting UPSTDC backend on port ${PORT} (no-db stub mode)."

# Build if necessary (optional warm cache)
if [ ! -d "target" ]; then
  if [ -x "./mvnw" ]; then
    ./mvnw -q -DskipTests=true -DskipITs package
  else
    mvn -q -DskipTests=true -DskipITs package
  fi
fi

export SERVER_PORT="$PORT"

# Prefer mvnw if present
if [ -x "./mvnw" ]; then
  echo "[start.sh] Starting via ./mvnw spring-boot:run"
  exec ./mvnw -q -DskipTests=true spring-boot:run -Dspring-boot.run.jvmArguments="$JAVA_OPTS"
else
  JAR_FILE=$(ls target/*-SNAPSHOT.jar 2>/dev/null || true)
  if [ -n "${JAR_FILE}" ]; then
    echo "[start.sh] Starting jar ${JAR_FILE}"
    exec java $JAVA_OPTS -jar "${JAR_FILE}"
  else
    echo "[start.sh] Starting via mvn spring-boot:run (no mvnw or jar found)"
    exec mvn -q -DskipTests=true spring-boot:run -Dspring-boot.run.jvmArguments="$JAVA_OPTS"
  fi
fi
