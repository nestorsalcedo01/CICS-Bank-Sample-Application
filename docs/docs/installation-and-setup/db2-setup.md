---
layout: default
title: DB2 Schema Setup
---

# DB2 Schema Setup

All DB2 setup JCL is in `Db2_jcl_install/`. Jobs must be submitted on z/OS — they cannot be run locally.

## Setup Sequence

Run the JCL jobs in this order:

| Step | JCL Job | Purpose |
|---|---|---|
| 1 | `CREDB00.jcl` | Create database `CBSA` |
| 2 | `CRESG01–04.jcl` | Create storage groups |
| 3 | `CRETS01–04.jcl` | Create table spaces |
| 4 | `CRETB01.jcl` | Create `IBMUSER.ACCOUNT` table |
| 5 | `CRETB02.jcl` | Create `IBMUSER.CUSTOMER` table |
| 6 | `CRETB03.jcl` | Create `IBMUSER.PROCTRAN` table |
| 7 | `CRETB04.jcl` | Create `IBMUSER.CONTROL` table |
| 8 | `CREI101–301.jcl` | Create indexes |
| 9 | `DB2BIND.jcl` | Bind packages (collection `PCBSA`) |

## Before Running JCL

Edit each JCL file and replace the following placeholders with your site values:

```jcl
//CRETB01 JOB 'DB2',NOTIFY=&SYSUID,CLASS=A,MSGCLASS=H
//JCLLIB  JCLLIB ORDER=DSNC10.PROCLIB       ← your DB2 PROCLIB
//JOBLIB  DD DISP=SHR,DSN=DSNC10.SDSNLOAD   ← your DB2 load library
```

## DB2 Bind

After tables are created and programs are compiled, run `DB2BIND.jcl` to bind the DB2 packages:

- **Subsystem:** `DBCG`
- **Collection:** `PCBSA`
- **Owner:** `IBMUSER`
- **Qualifier:** `IBMUSER`

These values are configured in [`CBSA/application-conf/bind.properties`](../../../CBSA/application-conf/bind.properties).

## Teardown

To drop all CBSA DB2 objects, submit `DROPDB2.jcl`. This is destructive and irreversible — all data will be lost.
