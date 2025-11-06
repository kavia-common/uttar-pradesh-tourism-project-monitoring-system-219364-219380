#!/usr/bin/env bash
# Start script for UPSTDC backend Spring Boot app.
# - Waits for database readiness (upstdc_database)
# - Starts Spring Boot with Maven wrapper if available
# - Honors JAVA_OPTS if provided

set -euo pipefail

# Defaults and env
DB_HOST="${DB_HOST:-upstdc_database}"
DB_PORT="${DB_PORT:-5000}"
PORT="${PORT:-3001}"
JAVA_OPTS="${JAVA_OPTS:-}"

echo "[start.sh] Using DB_HOST=$DB_HOST DB_PORT=$DB_PORT PORT=$PORT"

# Wait for PostgreSQL readiness if pg_isready available; otherwise use TCP wait
wait_for_db() {
  local host="$1"
  local port="$2"
  local timeout="${3:-60}"
  local start_ts
  start_ts=$(date +%s)
  echo "[start.sh] Waiting for database ${host}:${port} (timeout ${timeout}s)..."

  if command -v pg_isready >/dev/null 2>&1; then
    until pg_isready -h "$host" -p "$port" -q; do
      sleep 1
      if [ $(( $(date +%s) - start_ts )) -ge "$timeout" ]; then
        echo "[start.sh] ERROR: Timeout waiting for database ${host}:${port}"
        return 1
      fi
    done
  else
    # Fallback: simple TCP connect using bash and /dev/tcp
    until (echo >"/dev/tcp/${host}/${port}") >/dev/null 2>&1; do
      sleep 1
      if [ $(( $(date +%s) - start_ts )) -ge "$timeout" ]; then
        echo "[start.sh] ERROR: Timeout waiting for database ${host}:${port}"
        return 1
      fi
    done
  fi

  echo "[start.sh] Database is ready."
}

# Only wait if DB_HOST is set (it always is due to default)
wait_for_db "$DB_HOST" "$DB_PORT" "${DB_WAIT_TIMEOUT:-90}"

# Build if necessary (optional warm cache)
if [ ! -d "target" ]; then
  if [ -x "./mvnw" ]; then
    ./mvnw -q -DskipTests=true -DskipITs package
  else
    mvn -q -DskipTests=true -DskipITs package
  fi
fi

# Run the application with Maven spring-boot:run or jar if present
export SERVER_PORT="$PORT"

# Prefer mvnw if present
if [ -x "./mvnw" ]; then
  echo "[start.sh] Starting via ./mvnw spring-boot:run"
  exec ./mvnw -q -DskipTests=true spring-boot:run -Dspring-boot.run.jvmArguments="$JAVA_OPTS"
else
  # If jar exists, run it; else fallback to mvn
  JAR_FILE=$(ls target/*-SNAPSHOT.jar 2>/dev/null || true)
  if [ -n "${JAR_FILE}" ]; then
    echo "[start.sh] Starting jar ${JAR_FILE}"
    exec java $JAVA_OPTS -jar "${JAR_FILE}"
  else
    echo "[start.sh] Starting via mvn spring-boot:run (no mvnw or jar found)"
    exec mvn -q -DskipTests=true spring-boot:run -Dspring-boot.run.jvmArguments="$JAVA_OPTS"
  fi
fi
