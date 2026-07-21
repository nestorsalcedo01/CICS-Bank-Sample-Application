# AGENTS.md

This file provides guidance to agents when working with code in this repository.

## Non-Obvious Coding Rules for CBSA

### File flags are mandatory — silent build failures otherwise
When adding a new COBOL program that uses CICS, SQL, DLI, or MQ, you **must** add a file property override in [`CBSA/application-conf/file.properties`](CBSA/application-conf/file.properties):
```
isCICS=true :: **/cobol/YOURPROG.cbl
isSQL=true  :: **/cobol/YOURPROG.cbl
```
Without these, zAppBuild skips the translator step — the program compiles but fails at runtime.

### Compiler directives belong in the source file, not just JCL
The first 1–2 lines of every `.cbl` must declare compile options (see root `AGENTS.md`). Omitting `CBL SQL` from a DB2 program will cause precompile to fail even if `isSQL=true` is set in file.properties.

### BMS copybooks are generated artifacts
Files in `CBSA/copylib/BNK1*.cpy` that match a BMS map name are generated from `CBSA/bms/`. Do not edit them directly — changes will be overwritten. Edit the `.bms` source and rebuild.

### zUnit test triad — all 3 files required
Adding a new zUnit test requires exactly 3 files:
1. `CBSA/testcase/T<PROGNAME>.cbl` — test program
2. `CBSA/testcfg/<PROGNAME>.bzucfg` — runner config (XML, references `<HLQ>.ZUNIT.PB.<PROGNAME>`)
3. `CBSA/testplayback/<PROGNAME>.plbck` — recorded playback

The `.bzucfg` uses `AZUHLQ` as the DD name for the HLQ — this DD is allocated by zAppBuild at build time.

### Spring Boot pom.xml targets CICS JVM server `CBSAWLP`
The `cics-bundle-maven-plugin` in [`Z-OS-Connect-EE-Customer-Services-Interface/pom.xml`](Z-OS-Connect-EE-Customer-Services-Interface/pom.xml) hardcodes `<jvmserver>CBSAWLP</jvmserver>`. Any deployment to a different CICS region must change this value.

### excludeFileList skips `.json` files
[`application.properties`](CBSA/application-conf/application.properties) excludes `**/*.json` from scanning. If you add JSON config files that need dependency tracking, remove the `**/*.json` exclusion.

### Impact build uses `mainBuildBranch=Development`
Topic branch builds clone collections from the `Development` branch. If working on a branch off `master`, the impact build may miss dependency data — use `--fullBuild` for the first build on a new branch.
