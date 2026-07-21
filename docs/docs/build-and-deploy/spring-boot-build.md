---
layout: default
title: Spring Boot WAR Build
---

# Spring Boot WAR Build

The Spring Boot UI is built with Maven and packaged as a WAR for deployment to a CICS Liberty JVM server.

## Build Command

```bash
cd Z-OS-Connect-EE-Customer-Services-Interface
mvn clean package -DskipTests
```

Output: `target/customerservices-1.0.war` and `target/customerservices-1.0.zip` (CICS bundle).

## Maven Plugins

### cics-bundle-maven-plugin

Packages the WAR into a CICS bundle for deployment:

```xml
<plugin>
    <groupId>com.ibm.cics</groupId>
    <artifactId>cics-bundle-maven-plugin</artifactId>
    <version>1.0.4-SNAPSHOT</version>
    <configuration>
        <jvmserver>CBSAWLP</jvmserver>
    </configuration>
</plugin>
```

> **Important:** The JVM server name `CBSAWLP` is hardcoded. Change this value before deploying to a region with a different JVM server name.

### spring-boot-maven-plugin

Standard Spring Boot repackaging. The embedded Tomcat is `provided` scope — the WAR runs on Liberty, not standalone Tomcat.

## Key Dependencies

| Dependency | Scope | Purpose |
|---|---|---|
| `spring-boot-starter-web` | compile | MVC framework |
| `spring-boot-starter-thymeleaf` | compile | HTML template engine |
| `spring-boot-starter-webflux` | compile | `WebClient` for calls to z/OS Connect EE |
| `spring-boot-starter-validation` | provided | Bean validation |
| `spring-boot-starter-tomcat` | provided | Servlet container (provided by Liberty) |
| `jackson-databind` | compile | JSON serialization for z/OS Connect EE responses |

## Running Locally

```bash
mvn spring-boot:run
# Available at: http://localhost:19080/customerservices-1.0
```

When running locally, the app uses embedded Tomcat. Ensure `zosconnect.host` in `application.properties` points to a running z/OS Connect EE instance.
