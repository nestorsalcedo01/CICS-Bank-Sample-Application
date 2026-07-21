# AGENTS.md

This file provides guidance to agents when working with code in this repository.

## Project Overview

**CICS Bank Sample Application (CBSA)** — IBM internal only, not licensed for external use.  
Multi-component project: COBOL/CICS/DB2 mainframe core + z/OS Connect EE REST layer + Spring Boot web UI.

## Repository Structure

| Directory | Contents |
|---|---|
| `CBSA/` | Mainframe application source — the primary component |
| `CBSA/cobol/` | CICS COBOL programs (39 programs, `.cbl`) |
| `CBSA/copylib/` | 51 shared copybooks (`.cpy`) — always use these; never duplicate data layouts |
| `CBSA/bms/` | BMS map definitions (`.bms`) — generate both DSECT copybooks and map objects |
| `CBSA/asm/` | HLASM (one file: `DFHNCOPT.assemble`) |
| `CBSA/testcase/` | zUnit test programs (`.cbl`) — compiled with separate libs via `cobol_testcase=true` |
| `CBSA/testcfg/` | zUnit runner configs (`.bzucfg`) — paired 1:1 with test programs |
| `CBSA/testplayback/` | zUnit playback files (`.plbck`) |
| `CBSA/application-conf/` | zAppBuild configuration — all build/test settings live here |
| `Db2_jcl_install/` | 34 JCL jobs for DB2 schema setup/teardown — run on z/OS, not locally |
| `zosconnect_artefacts/services/` | 10 z/OS Connect EE service definitions (SAR files referenced) |
| `zoseeserver/` | z/OS Connect EE Liberty `server.xml` |
| `Z-OS-Connect-EE-Customer-Services-Interface/` | Spring Boot 2.5.4 / Maven web UI (WAR, Java 8) |
| `Z-OS-Connect-EE-Payment-Interface/` | Spring Boot web UI for payment operations |

## Build System

**Mainframe (z/OS only):** IBM Dependency Based Build (DBB) via zAppBuild.  
CI/CD: GitLab CI (`.gitlab-ci.yml`) — runs on a DAT Linux machine targeting z/OS.

Build order is fixed: `BMS.groovy → Cobol.groovy → Assembler.groovy → LinkEdit.groovy`  
Test order: `ZunitConfig.groovy` (runs after build when `runzTests=true`).

**Key build variables (from `.gitlab-ci.yml`):**
```
HLQ=GITLAB.CBSA
APPLICATION_NAME=CBSA
```

**Spring Boot web UIs:** Standard Maven — run from each project directory:
```bash
cd Z-OS-Connect-EE-Customer-Services-Interface && mvn spring-boot:run
cd Z-OS-Connect-EE-Payment-Interface && mvn spring-boot:run
```
Spring Boot UI runs on port `19080` with context path `/customerservices-1.0`.

## Testing

**zUnit (mainframe):** Tests run only on z/OS via DBB. Enabled by `runzTests=true` in [`CBSA/application-conf/application.properties`](CBSA/application-conf/application.properties).

- Test programs live in `CBSA/testcase/` and are flagged with `cobol_testcase=true` in [`file.properties`](CBSA/application-conf/file.properties) — they compile against different z/OS libraries than production programs.
- Each test requires 3 files: `testcase/<PROG>.cbl` + `testcfg/<PROG>.bzucfg` + `testplayback/<PROG>.plbck`.
- The `.bzucfg` XML file (`runner:RunnerConfiguration`) references the HLQ via `<runner:fileAttributes hlqDdName="AZUHLQ"/>` — the HLQ must match the z/OS dataset prefix.
- zUnit runner params: `STOP=E,REPORT=XML` (stops on error, outputs XML results).
- Only 1 test program exists currently: `TBNKMENU` testing `BNKMENU`.

To run a **single test** on z/OS DBB:
```bash
$DBB_HOME/bin/groovyz dbb-zappbuild/build.groovy \
  --workspace <ws> --application CBSA --hlq GITLAB.CBSA \
  --userBuild CBSA/testcfg/BNKMENU.bzucfg
```

## Critical COBOL Conventions

**Compiler options are declared at the top of each `.cbl` file** — not in JCL only:
- All CICS programs: `PROCESS CICS,NODYNAM,NSYMBOL(NATIONAL),TRUNC(STD)` + `CBL CICS('SP,EDF')`
- Programs with DLI: `CBL CICS('SP,EDF,DLI')`
- Programs with DB2: `CBL SQL`
- zUnit test cases: `PROCESS NODLL,NODYNAM,TEST(NOSEP),NOCICS,NOSQL,PGMN(LU)`

**File flags required in [`file.properties`](CBSA/application-conf/file.properties)** for programs using CICS/SQL/DLI/MQ — without these, the compiler won't add the correct translator steps:
```
isCICS=true, isSQL=true, isDLI=true, isMQ=true
```

**Copybooks from BMS maps** are generated into `CBSA/copylib/` with the same base name as the `.bms` file (e.g. `BNK1MAI.bms` → `BNK1MAI.cpy`). The `.cpy` files in `copylib/` are the copybook versions; do not hand-edit them separately.

**DB2 bind:** Controlled by `bind_performBindPackage=false` in [`bind.properties`](CBSA/application-conf/bind.properties). Subsystem=`DBCG`, collection=`PCBSA`, qualifier=`IBMUSER`.

**Naming conventions:**
- COBOL programs: 8-char uppercase (e.g. `BNKMENU`, `CREACC`, `INQACC`)
- BMS maps: `BNK1xxx` prefix
- Copybooks: match program name or data structure name (uppercase, max 8 chars)
- Working-storage: `WS-` prefix; Linkage: `LS-` prefix
- Copyright 77-level FILLER literals are required at the top of Working-Storage in every program

## z/OS Connect EE

- Liberty server config: [`zoseeserver/server.xml`](zoseeserver/server.xml) — HTTP port `30701`, HTTPS `30702`
- Default credentials (non-production only): `ibmuser` / `SYS1`
- 10 services map to CICS programs: `CSacccre`, `CSaccdel`, `CSaccenq`, `CSaccupd`, `CScustacc`, `CScustcre`, `CScustdel`, `CScustenq`, `CScustupd`, `Pay`
- CICS JVM server name: `CBSAWLP` (referenced in Spring Boot `pom.xml` for `cics-bundle-maven-plugin`)

## DB2 Schema (z/OS only)

Tables: `IBMUSER.ACCOUNT`, `IBMUSER.CUSTOMER`, `IBMUSER.PROCTRAN`, `IBMUSER.CONTROL`.  
All JCL install jobs are in `Db2_jcl_install/` — must be submitted on z/OS, not run locally.  
Drop/recreate: `DROPDB2.jcl` drops all, then run `CREDB00.jcl` → table JCLs → `DB2BIND.jcl`.
