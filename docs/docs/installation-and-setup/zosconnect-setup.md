---
layout: default
title: z/OS Connect EE Deployment
---

# z/OS Connect EE Deployment

CBSA exposes 10 CICS services through z/OS Connect EE 2.0 running on Liberty.

## Liberty Server

The Liberty server configuration is in [`zoseeserver/server.xml`](../../../zoseeserver/server.xml).

**Ports:**
- HTTP: `30701`
- HTTPS: `30702`

**Required Liberty features:**
```xml
<feature>zosconnect:zosConnect-2.0</feature>
<feature>zosconnect:cicsService-1.0</feature>
<feature>zosconnect:zosConnectCommands-1.0</feature>
```

## Deploying SAR and AAR Files

1. Copy the SAR files from `sarfiles/` to the z/OS Connect EE server's `resources/zosconnect/services/` directory.
2. Copy the AAR files from `aarfiles/` to the `resources/zosconnect/apis/` directory.
3. Restart the Liberty server or wait for dynamic refresh.

## Default Credentials

The server ships with a basic registry for demo use only (**not for production**):

```xml
<basicRegistry id="basic1" realm="zosConnect">
  <user name="ibmuser" password="SYS1" />
</basicRegistry>
```

Change these credentials before deploying to any shared environment.

## CORS Configuration

The server is configured to allow all origins — suitable for development only:

```xml
<cors domain="/" allowedOrigins="*" allowedMethods="GET, POST, PUT, DELETE, OPTIONS" />
```

Restrict `allowedOrigins` to the Spring Boot UI hostname in production.

## Verifying Deployment

After deployment, verify the services are available by calling the z/OS Connect EE admin endpoint:

```
GET http://<host>:30701/zosConnect/services
```

Each of the 10 CBSA services (`CSacccre`, `CSaccdel`, etc.) should appear in the response.
