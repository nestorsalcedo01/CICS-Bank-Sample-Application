---
layout: default
title: Prerequisites
---

# Prerequisites

Before installing CBSA, ensure the following z/OS components are available and configured.

## z/OS Components Required

| Component | Minimum Version | Notes |
|---|---|---|
| z/OS | 2.4 | USS support required |
| CICS TS | 5.5 | JVM server support for Liberty |
| DB2 for z/OS | 12 | Subsystem `DBCG` |
| z/OS Connect EE | 2.0 | Liberty feature `zosConnect-2.0` |
| IBM MQ | 9.2 | Optional — not required for core banking |

## z/OS Datasets Required

The following datasets must be allocated on z/OS before running the build:

| Dataset | Purpose |
|---|---|
| `<HLQ>.COBOL.COPYLIB` | Copybook library |
| `<HLQ>.CICSLOAD` | CICS load module library |
| `<HLQ>.LOAD` | Non-CICS load module library |
| `<HLQ>.DB2DBRM` | DB2 DBRM library |
| `<HLQ>.COBOL.SYSDEBUG` | Debug information |

Replace `<HLQ>` with your site's high-level qualifier (e.g., `GITLAB.CBSA`).

## Local Workstation Requirements

| Tool | Version | Purpose |
|---|---|---|
| Git | Any | Source control |
| IBM Developer for z/OS (IDz) | 16+ | Optional — COBOL editing |
| Java | 11+ | Spring Boot UI build |
| Maven | 3.6+ | Spring Boot UI build |

## Access Requirements

- z/OS USS access with write permissions to the build workspace directory
- DB2 SYSADM or authority to create tables under `IBMUSER` schema
- CICS authority to define and install programs and transactions
- z/OS Connect EE administrator access to deploy SAR/AAR files
