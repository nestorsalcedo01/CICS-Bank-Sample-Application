---
layout: default
title: System Overview
---

# System Overview

CBSA is a three-tier application running entirely on or connected to IBM Z. Each tier has a distinct technology role — the diagram below uses color-coding to distinguish frontend, API, runtime, and data layers.

```mermaid
flowchart TD
    Browser(["🌐 Browser\nEnd User"])

    subgraph TIER1 ["Tier 1 — Web UI  |  Spring Boot on CICS Liberty"]
        SpringBoot["Spring Boot WAR\nThymeleaf Templates\nport 19080"]
        SpringBoot2["Spring Boot WAR\nPayment Interface"]
    end

    subgraph TIER2 ["Tier 2 — API Gateway  |  z/OS Connect EE"]
        ZOSConnect["z/OS Connect EE 2.0\nLiberty Server\nHTTP 30701 · HTTPS 30702"]
    end

    subgraph TIER3 ["Tier 3 — Transaction Processing  |  CICS + DB2"]
        subgraph BMS ["BMS Screen Handlers"]
            BNKMENU["BNKMENU"]
            BNK1xxx["BNK1CAC · BNK1CCA\nBNK1CCS · BNK1CRA\nBNK1DAC · BNK1DCS\nBNK1TFN · BNK1UAC"]
        end
        subgraph SVC ["Business Service Programs"]
            AccSvc["CREACC · INQACC\nUPDACC · DELACC\nINQACCCU"]
            CustSvc["CRECUST · INQCUST\nUPDCUST · DELCUS"]
            PaySvc["DBCRFUN · XFRFUN\nDPAYAPI"]
        end
        subgraph DB2L ["DB2 Subsystem DBCG"]
            ACCOUNT[("IBMUSER.ACCOUNT")]
            CUSTOMER[("IBMUSER.CUSTOMER")]
            PROCTRAN[("IBMUSER.PROCTRAN\nAudit Log")]
            CONTROL[("IBMUSER.CONTROL")]
        end
    end

    Browser -->|"HTTP"| SpringBoot
    Browser -->|"HTTP"| SpringBoot2
    SpringBoot -->|"REST JSON\nWebClient"| ZOSConnect
    SpringBoot2 -->|"REST JSON\nWebClient"| ZOSConnect
    ZOSConnect -->|"EXEC CICS LINK\nCOMMARCA"| AccSvc
    ZOSConnect -->|"EXEC CICS LINK\nCOMMARCA"| CustSvc
    ZOSConnect -->|"EXEC CICS LINK\nCOMMARCA"| PaySvc
    BNKMENU --> BNK1xxx
    BNK1xxx -->|"EXEC CICS LINK"| AccSvc
    BNK1xxx -->|"EXEC CICS LINK"| CustSvc
    BNK1xxx -->|"EXEC CICS LINK"| PaySvc
    AccSvc -->|"EXEC SQL"| ACCOUNT
    AccSvc -->|"EXEC SQL"| PROCTRAN
    CustSvc -->|"EXEC SQL"| CUSTOMER
    CustSvc -->|"EXEC SQL"| PROCTRAN
    PaySvc -->|"EXEC SQL"| ACCOUNT
    PaySvc -->|"EXEC SQL"| PROCTRAN

    classDef browser    fill:#dde1e7,stroke:#697077,color:#161616,font-weight:bold
    classDef springboot fill:#d0e2ff,stroke:#0043ce,color:#001d6c,font-weight:bold
    classDef zosconnect fill:#d9fbfb,stroke:#007d79,color:#004144,font-weight:bold
    classDef bms        fill:#e8daff,stroke:#6929c4,color:#31135e,font-weight:bold
    classDef service    fill:#defbe6,stroke:#198038,color:#0e3818,font-weight:bold
    classDef database   fill:#fff1f1,stroke:#a2191f,color:#570408,font-weight:bold

    class Browser browser
    class SpringBoot,SpringBoot2 springboot
    class ZOSConnect zosconnect
    class BNKMENU,BNK1xxx bms
    class AccSvc,CustSvc,PaySvc service
    class ACCOUNT,CUSTOMER,PROCTRAN,CONTROL database
```

**Colour legend:**

| Colour | Layer | Technology |
|---|---|---|
| ![#d0e2ff](https://placehold.co/12x12/d0e2ff/d0e2ff.png) Blue | Web UI | Spring Boot on CICS Liberty JVM Server (`CBSAWLP`) |
| ![#d9fbfb](https://placehold.co/12x12/d9fbfb/d9fbfb.png) Teal | API Gateway | z/OS Connect EE — JSON ↔ COMMAREA bridge |
| ![#e8daff](https://placehold.co/12x12/e8daff/e8daff.png) Purple | BMS Screens | CICS 3270 screen handler programs |
| ![#defbe6](https://placehold.co/12x12/defbe6/defbe6.png) Green | Business Logic | CICS COBOL service programs + DB2 SQL |
| ![#fff1f1](https://placehold.co/12x12/fff1f1/fff1f1.png) Red | Data | DB2 tables under `IBMUSER` schema |

---

## Tier 1 — Spring Boot Web UI

Two Spring Boot WAR applications provide the browser interface, both deployed to CICS Liberty JVM server **`CBSAWLP`**:

| Application | Directory | Context Path | Purpose |
|---|---|---|---|
| Customer Services | `Z-OS-Connect-EE-Customer-Services-Interface/` | `/customerservices-1.0` | Customer + account operations |
| Payment Interface | `Z-OS-Connect-EE-Payment-Interface/` | Configured separately | Payment processing |

Both use Spring `WebClient` (reactive HTTP) to call z/OS Connect EE. The embedded Tomcat is `provided` scope — production runs on Liberty, not standalone Tomcat.

---

## Tier 2 — z/OS Connect EE API Gateway

Maps 10 REST endpoints to CICS programs via COMMAREA. Each service definition translates JSON request fields to COMMAREA byte positions using `.si` (Service Interface) files.

| Service | CICS Program | HTTP Method | REST Route (OAS3) |
|---|---|---|---|
| CSacccre | CREACC | POST | `/accounts` |
| CSaccenq | INQACC | GET | `/accounts/{id}` |
| CSaccupd | UPDACC | PUT | `/accounts/{id}` |
| CSaccdel | DELACC | DELETE | `/accounts/{id}` |
| CScustacc | INQACCCU | GET | `/customers/{id}/accounts` |
| CScustcre | CRECUST | POST | `/customers` |
| CScustenq | INQCUST | GET | `/customers/{id}` |
| CScustupd | UPDCUST | PUT | `/customers/{id}` |
| CScustdel | DELCUS | DELETE | `/customers/{id}` |
| Pay | DPAYAPI | POST | `/payments` |

---

## Tier 3 — CICS + DB2

Business logic runs exclusively in CICS COBOL programs. There are **two entry paths** into Tier 3:

1. **API path** — z/OS Connect EE calls programs directly via `EXEC CICS LINK` (no BMS involved)
2. **Terminal path** — `BNKMENU` drives BMS screen handlers which then call the same service programs

Both paths reach the **same COBOL service programs** — there is no duplicate business logic.

---

## Key Design Decisions

- **Named Counter for account numbering:** `CREACC` uses `EXEC CICS ENQ` on a Named Counter before incrementing — prevents duplicate account numbers under concurrent load without DB2 table locks.
- **PROCTRAN as audit trail:** Every state-changing program writes to `IBMUSER.PROCTRAN` in the **same DB2 unit of work** as the primary table change. PROCTRAN write failure rolls back the entire transaction.
- **Credit agency simulation:** `CRDTAGY1`–`CRDTAGY5` return randomised scores — not production-grade. The COMMAREA interface must be preserved if replacing them.
- **Shared COBOL, two frontends:** Both the Spring Boot UI and the BMS 3270 terminal use the same COBOL service programs — CBSA runs as a hybrid modern + traditional application simultaneously.
