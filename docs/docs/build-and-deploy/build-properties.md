---
layout: default
title: Build Properties Reference
---

# Build Properties Reference

All build properties live in `CBSA/application-conf/`. They are loaded by zAppBuild at the start of every build.

## application.properties — Core Settings

| Property | Value | Description |
|---|---|---|
| `runzTests` | `true` | Enables zUnit tests after build |
| `mainBuildBranch` | `Development` | Branch used for impact build cloning |
| `buildOrder` | `BMS,Cobol,Assembler,LinkEdit` | Fixed build script sequence |
| `testOrder` | `ZunitConfig.groovy` | Test execution script |
| `excludeFileList` | `.*,**/*.properties,**/*.xml,**/*.json,...` | Files excluded from scanning |

## Cobol.properties — COBOL Compiler Settings

| Property | Default | Description |
|---|---|---|
| `cobol_compilerVersion` | `V6` | Enterprise COBOL version |
| `cobol_compileParms` | `LIB` | Base compile parameters |
| `cobol_compileCICSParms` | `CICS` | Appended when `isCICS=true` |
| `cobol_compileSQLParms` | `SQL` | Appended when `isSQL=true` |
| `cobol_linkEditParms` | `MAP,RENT,COMPAT(PM5)` | Link edit parameters |
| `cobol_compileMaxRC` | `4` | Max RC for compile step |
| `cobol_linkEditMaxRC` | `0` | Max RC for link edit step |
| `cobol_deployType` | `LOAD` | Deploy type for non-CICS programs |
| `cobol_deployTypeCICS` | `CICSLOAD` | Deploy type for CICS programs |
| `cobol_storeSSI` | `true` | Store Git hash in load module SSI field |

## BMS.properties — BMS Map Settings

| Property | Default | Description |
|---|---|---|
| `bms_compileParms` | `SYSPARM(MAP),DECK,NOOBJECT` | Generates map copybooks |
| `bms_copyGenParms` | `SYSPARM(DSECT),DECK,NOOBJECT` | Generates DSECT copybooks |
| `bms_linkEditParms` | `MAP,RENT,COMPAT(PM5)` | Link edit parameters |
| `bms_maxRC` | `4` | Maximum RC allowed |

## bind.properties — DB2 Bind Settings

| Property | Value | Description |
|---|---|---|
| `bind_performBindPackage` | `false` | Set to `true` to auto-bind after build |
| `bind_db2Location` | `DBCG` | DB2 subsystem name |
| `bind_collectionID` | `PCBSA` | Package collection |
| `bind_packageOwner` | `IBMUSER` | Package owner |
| `bind_qualifier` | `IBMUSER` | Implicit qualifier |

## ZunitConfig.properties — Test Settings

| Property | Value | Description |
|---|---|---|
| `zunit_bzuplayParms` | `STOP=E,REPORT=XML` | Runner parameters |
| `zunit_maxPassRC` | `4` | Max RC for pass |
| `zunit_maxWarnRC` | `8` | Max RC for warning (above = fail) |
| `zunit_playbackFileExtension` | `plbck` | Extension for playback files |

## File-Level Overrides (file.properties)

Per-file flags that control which compile translators are invoked:

```properties
# Mark a program as CICS
isCICS=true :: **/cobol/BNKMENU.cbl

# Mark a program as using DB2
isSQL=true :: **/cobol/CREACC.cbl

# Mark a program as using DLI
isDLI=true :: **/cobol/DBCRFUN.cbl

# Mark test case programs to use separate libraries
cobol_testcase=true :: **/testcase/*.cbl
```
