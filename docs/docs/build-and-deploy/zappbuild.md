---
layout: default
title: zAppBuild Pipeline
---

# zAppBuild Pipeline

CBSA uses IBM Dependency Based Build (DBB) with the **zAppBuild** framework. All mainframe builds run on z/OS USS — there is no local mainframe build.

## Build Order

The build processes source in this fixed order, controlled by `buildOrder` in [`CBSA/application-conf/application.properties`](../../../CBSA/application-conf/application.properties):

```
BMS.groovy → Cobol.groovy → Assembler.groovy → LinkEdit.groovy
```

BMS must precede COBOL because BMS generates DSECT copybooks consumed by COBOL programs.

## Test Order

```
ZunitConfig.groovy
```

Tests run after the build when `runzTests=true` in `application.properties`.

## Script Mappings

Defined in [`CBSA/application-conf/file.properties`](../../../CBSA/application-conf/file.properties):

| Pattern | Script |
|---|---|
| `**/*.bms` | BMS.groovy |
| `**/*.cbl` | Cobol.groovy |
| `**/*.asm` | Assembler.groovy |
| `**/*.link` | LinkEdit.groovy |
| `**/*.pli` | PLI.groovy |
| `**/*.bzucfg` | ZunitConfig.groovy |

## Build Types

| Type | Flag | When to Use |
|---|---|---|
| Full build | `--fullBuild` | First build or after major changes |
| Impact build | `--impactBuild` | Normal pipeline runs — only rebuilds impacted files |
| User build | `--userBuild <file>` | Rebuild a single source file |

## Running a Full Build (z/OS USS)

```bash
$DBB_HOME/bin/groovyz dbb-zappbuild/build.groovy \
  --workspace /u/gitlab/CBSA \
  --application CBSA \
  --hlq GITLAB.CBSA \
  --fullBuild \
  --logEncoding UTF-8
```

## Running a Single Program Build (User Build)

```bash
$DBB_HOME/bin/groovyz dbb-zappbuild/build.groovy \
  --workspace /u/gitlab/CBSA \
  --application CBSA \
  --hlq GITLAB.CBSA \
  --userBuild CBSA/cobol/CREACC.cbl
```

## Running a Single zUnit Test

```bash
$DBB_HOME/bin/groovyz dbb-zappbuild/build.groovy \
  --workspace /u/gitlab/CBSA \
  --application CBSA \
  --hlq GITLAB.CBSA \
  --userBuild CBSA/testcfg/BNKMENU.bzucfg
```

## Critical Properties

| Property | Value | Notes |
|---|---|---|
| `runzTests` | `true` | Enables zUnit tests in pipeline |
| `mainBuildBranch` | `Development` | Impact builds clone from this branch |
| `bind_performBindPackage` | `false` | DB2 bind must be run manually after SQL changes |
| `cobol_compilerVersion` | `V6` | Enterprise COBOL V6 |
| `cobol_deployType` | `LOAD` | Non-CICS load modules |
| `cobol_deployTypeCICS` | `CICSLOAD` | CICS load modules |

## File Flags (Critical)

Programs requiring special compile steps must declare flags in `file.properties`. Without these, the compile succeeds but the program fails at runtime:

```
# Example entries in CBSA/application-conf/file.properties
isCICS=true :: **/cobol/BNKMENU.cbl
isSQL=true  :: **/cobol/CREACC.cbl
isDLI=true  :: **/cobol/DBCRFUN.cbl
```
