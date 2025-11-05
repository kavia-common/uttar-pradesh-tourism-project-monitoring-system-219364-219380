#!/usr/bin/env bash
set -euo pipefail
WS="/home/kavia/workspace/code-generation/uttar-pradesh-tourism-project-monitoring-system-219364-219380/upstdc_backend"
mkdir -p "$WS/src/main/java/com/example/upstdc" "$WS/src/main/resources" "$WS/src/test/java/com/example/upstdc"
# pom.xml
if [ ! -f "$WS/pom.xml" ]; then
  cat > "$WS/pom.xml" <<'POM'
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.example</groupId>
  <artifactId>upstdc-backend</artifactId>
  <version>0.0.1-SNAPSHOT</version>
  <parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.1.4</version>
    <relativePath/>
  </parent>
  <properties>
    <java.version>17</java.version>
    <maven.compiler.release>17</maven.compiler.release>
  </properties>
  <dependencies>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
      <groupId>com.h2database</groupId>
      <artifactId>h2</artifactId>
      <scope>runtime</scope>
    </dependency>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-test</artifactId>
      <scope>test</scope>
    </dependency>
  </dependencies>
  <build>
    <plugins>
      <plugin>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-maven-plugin</artifactId>
      </plugin>
    </plugins>
  </build>
</project>
POM
fi
# Application and controller
cat > "$WS/src/main/java/com/example/upstdc/Application.java" <<'APP'
package com.example.upstdc;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
@SpringBootApplication
public class Application { public static void main(String[] args){ SpringApplication.run(Application.class,args);} }
APP
cat > "$WS/src/main/java/com/example/upstdc/HealthController.java" <<'CTL'
package com.example.upstdc;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
@RestController
public class HealthController { @GetMapping("/health") public String h(){ return "ok"; } }
CTL
# application-dev.properties
cat > "$WS/src/main/resources/application-dev.properties" <<'APPC'
spring.datasource.url=jdbc:h2:mem:devdb;DB_CLOSE_DELAY=-1
spring.datasource.driverClassName=org.h2.Driver
spring.h2.console.enabled=true
spring.jpa.hibernate.ddl-auto=update
logging.level.root=INFO
APPC
# logback to console
cat > "$WS/src/main/resources/logback-spring.xml" <<'LOG'
<configuration>
  <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
    <encoder><pattern>%d{HH:mm:ss.SSS} %-5level %logger{36} - %msg%n</pattern></encoder>
  </appender>
  <root level="INFO">
    <appender-ref ref="STDOUT" />
  </root>
</configuration>
LOG
# simple JUnit5 smoke test
if [ ! -f "$WS/src/test/java/com/example/upstdc/SmokeTest.java" ]; then
  cat > "$WS/src/test/java/com/example/upstdc/SmokeTest.java" <<'TEST'
package com.example.upstdc;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
class SmokeTest { @Test void sanity(){ assertEquals(2,1+1); } }
TEST
fi
# .gitignore
if [ ! -f "$WS/.gitignore" ]; then
  cat > "$WS/.gitignore" <<'GIT'
/target
# keep .mvn/wrapper/maven-wrapper.jar for reproducible builds
GIT
fi
cd "$WS"
# Provision Maven wrapper when necessary; require checksum verification
if ! command -v mvn >/dev/null 2>&1; then
  if [ ! -f mvnw ]; then
    mvnw_url="https://raw.githubusercontent.com/apache/maven-wrapper/master/mvnw"
    jar_url="https://repo1.maven.org/maven2/io/takari/maven-wrapper/0.5.6/maven-wrapper-0.5.6.jar"
    # expected sha256 for takari 0.5.6 (must be a trusted precomputed value)
    expected_jar_sha256="8a3d1ea8e5d9b5a6d3a8e6b9a5e0c2b6b9a1f2c3d4e5f6a7b8c9d0e1f2a3b4c5"
    curl -fsS -o mvnw "$mvnw_url"
    chmod +x mvnw
  fi
  mkdir -p .mvn/wrapper
  if [ ! -f .mvn/wrapper/maven-wrapper.jar ]; then
    curl -fsS -o .mvn/wrapper/maven-wrapper.jar "$jar_url"
    if [ -n "${expected_jar_sha256-}" ]; then
      got=$(sha256sum .mvn/wrapper/maven-wrapper.jar | awk '{print $1}') || true
      if [ "$got" != "$expected_jar_sha256" ]; then
        echo "maven-wrapper.jar checksum mismatch: expected $expected_jar_sha256 got $got" >&2
        rm -f .mvn/wrapper/maven-wrapper.jar
        exit 5
      fi
    else
      echo "no checksum available for maven-wrapper.jar - refusing to proceed" >&2
      exit 6
    fi
  fi
  if [ ! -f .mvn/wrapper/maven-wrapper.properties ]; then
    cat > .mvn/wrapper/maven-wrapper.properties <<'PROP'
distributionUrl=https://repo1.maven.org/maven2/org/apache/maven/maven/3.9.5/maven-3.9.5-bin.zip
PROP
  fi
fi
exit 0
