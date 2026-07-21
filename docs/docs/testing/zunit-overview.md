---
layout: default
title: zUnit Overview
---

# zUnit Overview

IBM zUnit (IBM Z Automated Unit Testing Framework) provides COBOL unit testing on z/OS. Tests are driven by the `BZUPLAY` runner and orchestrated by DBB via `ZunitConfig.groovy`.

## Test Triad

Each CICS COBOL program under test requires **exactly three files**:

| File | Location | Purpose |
|---|---|---|
| `T<PROGNAME>.cbl` | `CBSA/testcase/` | zUnit test case program |
| `<PROGNAME>.bzucfg` | `CBSA/testcfg/` | Runner configuration (XML) |
| `<PROGNAME>.plbck` | `CBSA/testplayback/` | Recorded I/O playback file |

**Currently only one test exists:** `TBNKMENU` / `BNKMENU.bzucfg` / `BNKMENU.plbck`.

## Test Case Programs

Test programs in `CBSA/testcase/` are compiled with different compiler options than production COBOL:

```cobol
PROCESS NODLL,NODYNAM,TEST(NOSEP),NOCICS,NOSQL,PGMN(LU)
```

This is enforced by `cobol_testcase=true` in `file.properties`, which routes the test program to a separate set of z/OS compile libraries.

## Runner Configuration (`.bzucfg`)

The `.bzucfg` file is XML (`runner:RunnerConfiguration`). Key elements:

```xml
<runner:testCase moduleName="TBNKMENU">
  <test name="TEST2" entry="TEST_TEST2" type="CICS"
        init="BZU_INIT" term="BZU_TERM"
        program="BNKMENU" skipTest="false"
        resetFile="true" stubCall="true"/>
</runner:testCase>
<runner:playback moduleName="BNKMENU">
  <playbackFile name="&lt;HLQ>.ZUNIT.PB.BNKMENU"
                localName="BNKMENU.plbck"/>
</runner:playback>
<runner:fileAttributes hlqDdName="AZUHLQ"/>
```

- `hlqDdName="AZUHLQ"` — zAppBuild allocates this DD at build time using the build HLQ.
- `stubCall="true"` — CICS LINK calls are stubbed using the playback file.
- `type="CICS"` — indicates this is a CICS program test (requires CICS stub environment).

## Runner Parameters

Configured in [`CBSA/application-conf/ZunitConfig.properties`](../../../CBSA/application-conf/ZunitConfig.properties):

```
zunit_bzuplayParms=STOP=E,REPORT=XML
zunit_maxPassRC=4
zunit_maxWarnRC=8
```

- `STOP=E` — stops execution on error (not on failure)
- `REPORT=XML` — outputs test results as XML for GitLab CI parsing
- RC ≤ 4 = pass; RC 5–8 = warning; RC > 8 = fail
