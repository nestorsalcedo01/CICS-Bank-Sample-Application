---
layout: default
title: Writing a New Test
---

# Writing a New Test

Adding a zUnit test for a new COBOL program requires three files. Use the existing `BNKMENU` test as a reference.

## Step 1 — Create the Test Case Program

Create `CBSA/testcase/T<PROGNAME>.cbl`. Use these compiler options (required for all test case programs):

```cobol
PROCESS NODLL,NODYNAM,TEST(NOSEP),NOCICS,NOSQL,PGMN(LU)
```

Minimum program structure:

```cobol
IDENTIFICATION DIVISION.
PROGRAM-ID. 'TEST_<TESTNAME>'.
DATA DIVISION.
WORKING-STORAGE SECTION.
01 PROGRAM-NAME   PIC X(8)  VALUE '<PROGNAME>'.
01 BZUASSRT       PIC X(8)  VALUE 'BZUASSRT'.
01 BZUTRACE       PIC X(8)  VALUE 'BZUTRACE'.
...
LINKAGE SECTION.
01 AZ-TEST        PIC X(80).
01 AZ-ARG-LIST.
  ...
PROCEDURE DIVISION USING AZ-TEST AZ-ARG-LIST.
    ...
    STOP RUN.
```

## Step 2 — Create the Runner Configuration

Create `CBSA/testcfg/<PROGNAME>.bzucfg`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<runner:RunnerConfiguration
    xmlns:runner="http://www.ibm.com/zUnit/3.0.0.0/TestRunner"
    id="<unique-uuid>">
  <runner:options
      contOnTestCaseError="false"
      contOnTestCaseFail="true"
      contOnTestError="false"
      contOnTestFail="true"/>
  <runner:testCase moduleName="T<PROGNAME>">
    <test name="<TESTNAME>"
          entry="TEST_<TESTNAME>"
          type="CICS"
          init="BZU_INIT"
          term="BZU_TERM"
          program="<PROGNAME>"
          skipTest="false"
          resetFile="true"
          stubCall="true"
          dummy="false"/>
  </runner:testCase>
  <runner:playback moduleName="<PROGNAME>">
    <playbackFile
        name="&lt;HLQ>.ZUNIT.PB.<PROGNAME>"
        localName="<PROGNAME>.plbck"/>
  </runner:playback>
  <runner:fileAttributes hlqDdName="AZUHLQ"/>
</runner:RunnerConfiguration>
```

Key points:
- `id` must be a unique UUID — generate one with `python3 -c "import uuid; print(uuid.uuid4())"`
- `hlqDdName="AZUHLQ"` — do not change this, zAppBuild allocates it at build time
- `stubCall="true"` — stubs CICS LINK calls using the playback file

## Step 3 — Create the Playback File

Create `CBSA/testplayback/<PROGNAME>.plbck` by recording a live CICS session using IBM Developer for z/OS (IDz) zUnit recording capability.

The playback file captures CICS LINK call responses so tests can run without a live backend.

## Step 4 — Register in file.properties

The `cobol_testcase=true` rule in `file.properties` already applies to all files in `testcase/`:

```properties
cobol_testcase = true :: **/testcase/*.cbl
```

No additional entries are needed for the test case program.

## Step 5 — Run the Test

```bash
$DBB_HOME/bin/groovyz dbb-zappbuild/build.groovy \
  --workspace /u/gitlab/CBSA \
  --application CBSA \
  --hlq GITLAB.CBSA \
  --userBuild CBSA/testcfg/<PROGNAME>.bzucfg
```
