---
layout: default
title: Spring Boot UI Setup
---

# Spring Boot UI Setup

Two Spring Boot web applications provide the browser interface for CBSA.

## Applications

| Directory | Context Path | Purpose |
|---|---|---|
| `Z-OS-Connect-EE-Customer-Services-Interface/` | `/customerservices-1.0` | Customer and account management |
| `Z-OS-Connect-EE-Payment-Interface/` | Configured separately | Payment processing |

## Configuration

Edit `src/main/resources/application.properties` in each project to set the z/OS Connect EE endpoint:

```properties
server.port=19080
server.servlet.context-path=/customerservices-1.0

# z/OS Connect EE connection
zosconnect.host=<your-zos-host>
zosconnect.port=30701
```

## Building

```bash
cd Z-OS-Connect-EE-Customer-Services-Interface
mvn clean package
```

This produces a WAR file and a CICS bundle in `target/`.

## Deployment Options

### Option A — CICS Liberty JVM Server (production)

The `pom.xml` uses `cics-bundle-maven-plugin` to package a CICS bundle targeting JVM server **`CBSAWLP`**. Deploy the generated bundle to your CICS region.

### Option B — Local embedded Tomcat (development)

```bash
mvn spring-boot:run
```

The UI will be available at `http://localhost:19080/customerservices-1.0`.

> **Note:** The embedded Tomcat is `provided` scope — this works for local development but the production target is always the CICS Liberty JVM server.

## Dependencies

| Library | Version | Notes |
|---|---|---|
| Spring Boot | 2.5.4 | Parent POM |
| Thymeleaf | (managed) | Template engine |
| Spring WebFlux | (managed) | `WebClient` for reactive HTTP to z/OS Connect EE |
| Jackson | (managed) | JSON binding |
