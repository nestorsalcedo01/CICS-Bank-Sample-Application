---
layout: default
title: Services Reference
---

# z/OS Connect EE Services Reference

10 services are defined under `zosconnect_artefacts/services/`. Each maps a REST endpoint to a CICS program via COMMAREA.

## Service Inventory

| Service Name | CICS Program | Operation | HTTP Method |
|---|---|---|---|
| `CSacccre` | CREACC | Create account | POST |
| `CSaccdel` | DELACC | Delete account | DELETE |
| `CSaccenq` | INQACC | Enquire account | GET |
| `CSaccupd` | UPDACC | Update account | PUT |
| `CScustacc` | INQACCCU | List accounts for customer | GET |
| `CScustcre` | CRECUST | Create customer | POST |
| `CScustdel` | DELCUS | Delete customer | DELETE |
| `CScustenq` | INQCUST | Enquire customer | GET |
| `CScustupd` | UPDCUST | Update customer | PUT |
| `Pay` | DPAYAPI | Direct payment | POST |

## Deployable Artifacts

| File Location | Type | Purpose |
|---|---|---|
| `sarfiles/` | SAR (Service Archive) | z/OS Connect EE service definitions |
| `aarfiles/` | AAR (API Archive) | z/OS Connect EE API definitions |

These are pre-built artifacts. They are deployed to the z/OS Connect EE server — not rebuilt by the zAppBuild pipeline.

## Spring Boot → z/OS Connect EE Binding

The Spring Boot UI calls z/OS Connect EE endpoints using Spring `WebClient`. The base URL is configured in `application.properties`:

```properties
server.port=19080
server.servlet.context-path=/customerservices-1.0
```

The z/OS Connect EE host and port are injected via Spring Boot configuration properties at deployment time.

## COMMAREA Contract

Changing a CICS program's COMMAREA layout requires updating:

1. The COBOL copybook in `CBSA/copylib/`
2. The z/OS Connect EE service definition (SAR in `sarfiles/`)
3. The Spring Boot JSON binding model class in `Z-OS-Connect-EE-Customer-Services-Interface/src/`

All three must stay in sync — there is no schema enforcement at the z/OS Connect EE layer.
