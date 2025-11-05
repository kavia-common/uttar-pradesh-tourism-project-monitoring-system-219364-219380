#!/usr/bin/env bash
set -euo pipefail
WS="/home/kavia/workspace/code-generation/uttar-pradesh-tourism-project-monitoring-system-219364-219380/upstdc_backend"
cd "$WS"
[ -f /etc/profile.d/java.sh ] && . /etc/profile.d/java.sh || true
if command -v mvn >/dev/null 2>&1; then
  mvn_ver=$(mvn -v 2>/dev/null | awk '/Apache Maven/ {print $3; exit}' || true)
  ver_ok=0
  if [ -n "$mvn_ver" ]; then
    major=$(echo "$mvn_ver" | cut -d. -f1)
    minor=$(echo "$mvn_ver" | cut -d. -f2)
    if [ "$major" -gt 3 ] || { [ "$major" -eq 3 ] && [ "$minor" -ge 6 ]; }; then ver_ok=1; fi
  fi
  if [ "$ver_ok" -eq 1 ]; then MVN_CMD="mvn"; else MVN_CMD="./mvnw"; fi
else
  MVN_CMD="./mvnw"
fi
$MVN_CMD test || { echo "maven tests failed" >&2; exit 5; }
exit 0
