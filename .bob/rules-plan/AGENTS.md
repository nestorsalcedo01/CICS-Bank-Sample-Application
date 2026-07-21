# AGENTS.md

This file provides guidance to agents when working with code in this repository.

## Non-Obvious Architectural Constraints for CBSA

### Named Counter is the sole account number generator — it must be ENQed
`CREACC.cbl` uses a CICS Named Counter enqueued with `EXEC CICS ENQ` before incrementing. Any parallel account creation path that bypasses this enqueue will produce duplicate account numbers. This is not obvious from reading a single program.

### PROCTRAN is the audit trail — written by every state-changing program
Every program that modifies ACCOUNT or CUSTOMER data writes a record to `IBMUSER.PROCTRAN` in the same DB2 unit of work. If a new program changes data without writing PROCTRAN, the audit trail is broken. The copybook is `CBSA/copylib/PROCTRAN.cpy`.

### CRDTAGYx programs (1–5) are stubs, not real credit checks
`CRDTAGY1`–`CRDTAGY5` are artificial credit agency simulators that return randomized results. They are called by `CREACC` for account creation scoring. In a real deployment these would be replaced, but the calling interface must stay the same (COMMAREA layout in `CBSA/copylib/CREACC.cpy`).

### Build order is hard-coupled: BMS must precede COBOL
BMS maps generate DSECT copybooks consumed by COBOL programs. The `buildOrder` in [`application.properties`](CBSA/application-conf/application.properties) enforces `BMS.groovy` before `Cobol.groovy`. Any architectural change that moves BMS-derived layouts to a standalone copybook must ensure the copybook exists before COBOL compiles.

### z/OS Connect EE services are 1:1 mapped to CICS programs via COMMAREA
Each of the 10 z/OS Connect EE services calls a specific CICS program by transaction ID and passes data via COMMAREA. Changing a COMMAREA layout in COBOL requires a matching update to the z/OS Connect EE service definition (SAR in `sarfiles/`) and the Spring Boot JSON binding.

### Spring Boot packaging targets Liberty on CICS (not standalone Tomcat)
The WAR is built with `cics-bundle-maven-plugin` for deployment to a CICS Liberty JVM server (`CBSAWLP`). The embedded Tomcat is `provided` scope only. Running `mvn spring-boot:run` locally uses embedded Tomcat — this works for dev/test but the target runtime is CICS Liberty.

### DB2 bind is disabled by default and must be done manually
`bind_performBindPackage=false` in [`bind.properties`](CBSA/application-conf/bind.properties). After adding new SQL statements, the bind step must be run manually via `Db2_jcl_install/DB2BIND.jcl` against subsystem `DBCG`, collection `PCBSA`.
