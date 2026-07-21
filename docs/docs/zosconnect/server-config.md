---
layout: default
title: Liberty Server Configuration
---

# Liberty Server Configuration

The z/OS Connect EE Liberty server configuration is in [`zoseeserver/server.xml`](../../../zoseeserver/server.xml).

## Features

```xml
<featureManager>
    <feature>zosconnect:zosConnect-2.0</feature>
    <feature>zosconnect:cicsService-1.0</feature>
    <feature>zosconnect:zosConnectCommands-1.0</feature>
</featureManager>
```

## HTTP Endpoints

```xml
<httpEndpoint id="defaultHttpEndpoint"
              host="*"
              httpPort="30701"
              httpsPort="30702" />
```

> The `host="*"` setting binds to all interfaces. For production, restrict to a specific hostname.

## Security

### KeyStore

```xml
<keyStore id="defaultKeyStore" password="Liberty"/>
```

Change this password before deploying to any non-development environment.

### Basic Registry

```xml
<basicRegistry id="basic1" realm="zosConnect">
    <user name="ibmuser" password="SYS1" />
</basicRegistry>
```

### Authorization Role

Only users assigned `zosConnectAccess` role can invoke services:

```xml
<authorization-roles id="zos.connect.access.roles">
    <security-role name="zosConnectAccess">
        <user name="ibmuser"/>
    </security-role>
</authorization-roles>
```

## CORS Configuration

```xml
<cors id="defaultCORSConfig"
      domain="/"
      allowedOrigins="*"
      allowedMethods="GET, POST, PUT, DELETE, OPTIONS"
      allowedHeaders="Origin, Content-Type, Authorization"
      allowCredentials="true"
      maxAge="3600"/>
```

This open CORS policy is for development convenience only. Restrict `allowedOrigins` to the Spring Boot UI host in production.

## Configuration File Polling

The server has automatic polling for configuration changes disabled (noted in `server.xml` comments). Restart the Liberty server after changing `server.xml` to apply updates.
