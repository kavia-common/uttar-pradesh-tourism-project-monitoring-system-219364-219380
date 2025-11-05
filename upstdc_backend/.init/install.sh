#!/usr/bin/env bash
set -euo pipefail
WS="/home/kavia/workspace/code-generation/uttar-pradesh-tourism-project-monitoring-system-219364-219380/upstdc_backend"
sudo mkdir -p "$WS"
# robust java detection: parse java -version and ensure javac exists and point to same home
has_good_jdk=0
if command -v java >/dev/null 2>&1 && command -v javac >/dev/null 2>&1; then
  ver=$(java -XshowSettings:properties -version 2>&1 | awk -F '"' '/java.version/ {print $2; exit}') || true
  if [ -z "$ver" ]; then ver=$(java -version 2>&1 | awk -F '"' '/version/ {print $2; exit}' || true); fi
  major=$(echo "$ver" | sed -E 's/^([0-9]+).*/\1/' || true)
  if [ -n "$major" ] && [ "$major" -ge 17 ]; then
    jb=$(readlink -f "$(command -v java)")
    jc=$(readlink -f "$(command -v javac)")
    jbh=$(dirname "$(dirname "$jb")")
    jch=$(dirname "$(dirname "$jc")")
    if [ "$jbh" = "$jch" ]; then has_good_jdk=1; fi
  fi
fi
if [ "$has_good_jdk" -ne 1 ]; then
  sudo apt-get update -q && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q openjdk-17-jdk
  if ! command -v java >/dev/null 2>&1 || ! command -v javac >/dev/null 2>&1; then echo "JDK install failed" >&2; exit 2; fi
  ver=$(java -version 2>&1 | awk -F '"' '/version/ {print $2; exit}' || true)
  major=$(echo "$ver" | sed -E 's/^([0-9]+).*/\1/' || true)
  if [ -z "$major" ] || [ "$major" -lt 17 ]; then echo "Installed Java <17: $ver" >&2; exit 3; fi
fi
# compute JAVA_HOME from java binary
java_bin=$(readlink -f "$(command -v java)")
JAVA_HOME_DIR=$(dirname "$(dirname "$java_bin")")
PROFILE_FILE=/etc/profile.d/java.sh
TMP="/tmp/java.sh.$$"
MAVEN_OPTS_DEFAULT='-Xmx512m -Dfile.encoding=UTF-8'
existing_maven_opts=''
if [ -f "$PROFILE_FILE" ]; then
  existing_maven_opts=$(grep -E "^\s*export MAVEN_OPTS=" "$PROFILE_FILE" 2>/dev/null | sed -E "s/.*=\"?'?(.*)'?\"?/\1/" || true)
fi
if [ -n "${DEV_USER-}" ]; then CHOWN_USER="$DEV_USER"; else CHOWN_USER=""; fi
# write atomic profile; ensure values are properly quoted and preserve/merge MAVEN_OPTS
cat > "$TMP" <<'EOF'
# Auto-generated: JAVA_HOME and MAVEN_OPTS for headless builds
export JAVA_HOME="${JAVA_HOME_DIR}"
export PATH="${JAVA_HOME}/bin:${PATH}"
if [ -z "${MAVEN_OPTS-}" ]; then
  export MAVEN_OPTS="${MAVEN_OPTS_PRESERVE}"
fi
EOF
# Replace placeholders with safe values without breaking quoting
sudo sed -i "s|\${JAVA_HOME_DIR}|${JAVA_HOME_DIR}|g" "$TMP"
# If existing_maven_opts is empty use default
MAVEN_OPTS_PRESERVE=${existing_maven_opts:-$MAVEN_OPTS_DEFAULT}
# Escape slashes and ampersands for sed
esc=$(printf '%s' "$MAVEN_OPTS_PRESERVE" | sed -e 's/[\/&]/\\&/g')
sudo sed -i "s|\${MAVEN_OPTS_PRESERVE}|$esc|g" "$TMP" || true
if ! sudo cmp -s "$TMP" "$PROFILE_FILE" 2>/dev/null; then
  sudo mv "$TMP" "$PROFILE_FILE" && sudo chmod 644 "$PROFILE_FILE"
else
  rm -f "$TMP"
fi
# Apply to current shell if readable
if [ -r "$PROFILE_FILE" ]; then
  # shellcheck disable=SC1090
  . "$PROFILE_FILE"
fi
# conservative chown: only if DEV_USER provided or 'kavia' user exists
if [ -n "${CHOWN_USER-}" ]; then sudo chown -R "$CHOWN_USER":"$CHOWN_USER" "$WS" || true
else
  if id -u kavia >/dev/null 2>&1; then sudo chown -R kavia:kavia "$WS" || true; fi
fi
# final validation
java -version 2>&1 | head -n1 || true
javac -version 2>&1 | head -n1 || true
exit 0
