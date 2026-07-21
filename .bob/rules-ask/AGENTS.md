# AGENTS.md

This file provides guidance to agents when working with code in this repository.

## Non-Obvious Documentation Context for CBSA

### "copylib" contains both hand-written and generated copybooks
`CBSA/copylib/` contains 51 `.cpy` files. Those matching a BMS map name (`BNK1MAI`, `BNK1CAM`, etc.) are **generated** from `CBSA/bms/` during build. All others are hand-authored shared data layouts. Do not conflate them.

### Program naming encodes function, not technology
- `BNK1xxx` = BMS screen handler (CICS, has a paired `.bms` map)
- `CREAxx` / `CRECxx` = Create Account / Create Customer
- `INQACx` / `INQCUSx` = Enquiry programs
- `DELACx` / `DELCUSx` = Delete programs
- `UPDACx` / `UPDCUSx` = Update programs
- `DBCRFUx` = Debit/Credit function
- `XFRFUx` = Transfer function
- `CRDTAGYx` = Credit agency simulators (1–5, for stress testing)
- `ACCLOAx` / `PROLOAx` = Batch data loaders
- `ACCOFFx` / `PROOFFx` = Offline processing

### `aarfiles/` and `sarfiles/` contain pre-built z/OS Connect EE artifacts
These are the deployable API Archive (AAR) and Service Archive (SAR) files. They are **not rebuilt by zAppBuild** — they are pre-packaged Liberty/z/OS Connect artifacts deployed separately.

### `WaziAnalyze/` contains Wazi Analyze configuration
Used for application discovery analysis — separate from the zAppBuild pipeline. Not part of normal build/test.

### Spring Boot web UI connects to z/OS Connect EE, not directly to CICS
The Spring Boot app (`Z-OS-Connect-EE-Customer-Services-Interface/`) calls REST endpoints exposed by z/OS Connect EE (port 30701/30702 on z/OS). It does **not** connect to CICS directly. The z/OS Connect EE layer is the intermediary.

### `buildjcl/` and `jclInstall/` serve different purposes
- `buildjcl/` — JCL used by the zAppBuild pipeline during compile/link on z/OS
- `jclInstall/` — one-time installation JCL for the CICS region setup
- `Db2_jcl_install/` — DB2 schema setup/teardown JCL (run independently)
