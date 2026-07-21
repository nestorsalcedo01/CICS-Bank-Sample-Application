---
layout: default
title: Data Flow
---

# Data Flow

## End-to-End Request Flow — Create Account

The sequence diagram traces a full `createAccount` request from the browser through every layer, including the Named Counter serialization mechanism.

```mermaid
sequenceDiagram
    autonumber
    actor User as 🌐 Browser
    participant UI as Spring Boot UI<br/>(port 19080)
    participant ZC as z/OS Connect EE<br/>(port 30701)
    participant CREACC as CICS · CREACC<br/>(Create Account)
    participant CRDT as CICS · CRDTAGY1-5<br/>(Credit Stubs)
    participant DB2 as DB2 · DBCG<br/>(ACCOUNT + PROCTRAN)

    User->>UI: POST /customerservices-1.0/createAccount
    Note over UI: Validate form input (Spring Validation)
    UI->>ZC: POST /accounts (JSON payload)
    Note over ZC: Map JSON → COMMAREA bytes via CREACC.si

    ZC->>CREACC: EXEC CICS LINK PROGRAM(CREACC) COMMAREA(...)

    Note over CREACC: ENQ Named Counter ACCOUNT
    CREACC->>CREACC: Increment counter → new account number

    CREACC->>CRDT: EXEC CICS LINK PROGRAM(CRDTAGY1)
    CRDT-->>CREACC: Credit score (randomised)
    CREACC->>CRDT: EXEC CICS LINK PROGRAM(CRDTAGY2..5)
    CRDT-->>CREACC: Credit scores (randomised)

    CREACC->>DB2: EXEC SQL INSERT INTO IBMUSER.ACCOUNT
    DB2-->>CREACC: SQLCODE 0 (success)

    CREACC->>DB2: EXEC SQL INSERT INTO IBMUSER.PROCTRAN
    DB2-->>CREACC: SQLCODE 0 (success)

    Note over CREACC: DEQ Named Counter ACCOUNT

    CREACC-->>ZC: COMMAREA (COMM_NUMBER=new acct, COMM_SUCCESS=Y)
    Note over ZC: Map COMMAREA bytes → JSON response

    ZC-->>UI: HTTP 201 Created (JSON with account number)
    UI-->>User: Render confirmation page (Thymeleaf)
```

---

## Error Path — DB2 Failure

```mermaid
sequenceDiagram
    autonumber
    participant CREACC as CICS · CREACC
    participant DB2 as DB2 · DBCG

    Note over CREACC: ENQ Named Counter ACCOUNT
    CREACC->>CREACC: Increment counter → account number N

    CREACC->>DB2: INSERT INTO IBMUSER.ACCOUNT
    DB2-->>CREACC: SQLCODE -803 (duplicate key / error)

    Note over CREACC: EXEC CICS SYNCPOINT ROLLBACK
    CREACC->>CREACC: Decrement Named Counter back to N-1
    Note over CREACC: DEQ Named Counter ACCOUNT

    CREACC-->>CREACC: Set COMM_SUCCESS=N, COMM_FAIL_CODE=2
```

<div class="callout callout-yellow">
<strong>Critical invariant:</strong> If any DB2 write fails, CREACC decrements the Named Counter before DEQ. This prevents account number gaps. The same rollback pattern applies to all mutation programs.
</div>

---

## Data Transformation at Each Layer

Data changes representation at every layer boundary:

```mermaid
flowchart LR
    A["Browser\nHTML form\naccountType=CURRENT\noverdraftLimit=500"]
    B["Spring Boot\nJava POJO → JSON\n{accountType: CURRENT\noverdraftLimit: 500}"]
    C["z/OS Connect EE\nJSON → COMMAREA bytes\nper CREACC.si mapping"]
    D["CICS COBOL\nWorking-Storage\nWS-ACCOUNT-TYPE\nPIC X(8)"]
    E["DB2\nSQL INSERT\nACCOUNT_TYPE='CURRENT '"]

    A -->|"HTTP POST"| B
    B -->|"REST JSON"| C
    C -->|"EXEC CICS LINK"| D
    D -->|"EXEC SQL"| E

    classDef browser   fill:#dde1e7,stroke:#697077,color:#161616
    classDef spring    fill:#d0e2ff,stroke:#0043ce,color:#001d6c
    classDef zosconn   fill:#d9fbfb,stroke:#007d79,color:#004144
    classDef cobol     fill:#defbe6,stroke:#198038,color:#0e3818
    classDef db2       fill:#fff1f1,stroke:#a2191f,color:#570408

    class A browser
    class B spring
    class C zosconn
    class D cobol
    class E db2
```

---

## Named Counter Concurrency

Account and customer numbers are generated without DB2 sequence objects — CICS Named Counters with ENQ/DEQ provide serialization:

```mermaid
sequenceDiagram
    participant TA as Thread A
    participant NC as Named Counter ACCOUNT
    participant TB as Thread B

    TA->>NC: EXEC CICS ENQ RESOURCE(ACCOUNT)
    Note over NC: Counter = 100
    TB->>NC: EXEC CICS ENQ RESOURCE(ACCOUNT)
    Note over TB: Thread B WAITS — ENQ is exclusive

    TA->>NC: Increment → 101
    TA->>NC: EXEC CICS DEQ RESOURCE(ACCOUNT)
    Note over TB: Thread B resumes
    TB->>NC: EXEC CICS ENQ RESOURCE(ACCOUNT)
    Note over NC: Counter = 101
    TB->>NC: Increment → 102
    TB->>NC: EXEC CICS DEQ RESOURCE(ACCOUNT)
```

<div class="callout">
<strong>Why not DB2 IDENTITY/SEQUENCE?</strong> Named Counters allow the counter to be decremented on rollback — CREACC restores the counter value if the DB2 INSERT fails. A DB2 IDENTITY column cannot be rolled back, which would create gaps in account numbering.
</div>

---

## Audit Trail Invariant

Every mutation (INSERT/UPDATE/DELETE) writes to `IBMUSER.PROCTRAN` in the **same DB2 unit of work**:

```mermaid
flowchart LR
    subgraph UoW ["DB2 Unit of Work — single SYNCPOINT scope"]
        OP["Primary operation\ne.g. UPDATE IBMUSER.ACCOUNT"]
        AUDIT["Audit record\nINSERT IBMUSER.PROCTRAN"]
    end
    COMMIT["EXEC CICS SYNCPOINT\nCommit both atomically"]
    ROLLBACK["EXEC CICS SYNCPOINT ROLLBACK\nRoll back both on any error"]

    OP --> AUDIT
    UoW -->|"success"| COMMIT
    UoW -->|"SQLCODE error"| ROLLBACK

    classDef op      fill:#defbe6,stroke:#198038,color:#0e3818
    classDef audit   fill:#d9fbfb,stroke:#007d79,color:#004144
    classDef commit  fill:#d0e2ff,stroke:#0043ce,color:#001d6c
    classDef rollbk  fill:#fff1f1,stroke:#a2191f,color:#570408

    class OP op
    class AUDIT audit
    class COMMIT commit
    class ROLLBACK rollbk
```
