---
layout: default
title: Batch and Utility Programs
---

# Batch and Utility Programs

## BANKDATA — Bank Data Generator

**Program ID:** `BANKDATA` | **Type:** Batch COBOL

Generates synthetic bank data (customers and accounts) for initial population of the DB2 tables. Run once during environment setup.

---

## ACCLOAD — Account Loader

**Program ID:** `ACCLOAD` | **Type:** Batch COBOL + DB2 (`CBL SQL`)

Bulk-loads account records into `IBMUSER.ACCOUNT` from a sequential file. Used for initial data load or reload scenarios.

---

## ACCOFFL — Account Offline Processing

**Program ID:** `ACCOFFL` | **Type:** Batch COBOL

Performs offline processing on account records — applies interest calculations and statement generation. Run periodically as a batch job.

---

## ACCTCTRL — Account Control

**Program ID:** `ACCTCTRL` | **Copybook:** `CBSA/copylib/ACCTCTRL.cpy`

Manages account control records. Acts as a shared utility called by account programs to read/update the Named Counter state.

---

## CUSTCTRL — Customer Control

**Program ID:** `CUSTCTRL` | **Copybook:** `CBSA/copylib/CUSTCTRL.cpy`

Manages customer control records. Companion to `ACCTCTRL` for the customer number Named Counter.

---

## PROLOAD — PROCTRAN Loader

**Program ID:** `PROLOAD` | **Type:** Batch COBOL + DB2

Loads initial transaction history records into `IBMUSER.PROCTRAN`. Used for demo environment seeding.

---

## PROOFFL — PROCTRAN Offline

**Program ID:** `PROOFFL` | **Type:** Batch COBOL + DB2

Archives or purges old PROCTRAN records. Companion batch job to `PROLOAD`.

---

## CONSTTST — Constants Test

**Program ID:** `CONSTTST`

Test/diagnostic program that verifies CBSA constants (sort code, company name) are correctly defined and accessible. Used during environment validation.

---

## DPAYTST — Direct Payment Test

**Program ID:** `DPAYTST`

Test driver for `DPAYAPI`. Exercises the payment API with test data. Used for unit-level verification without going through z/OS Connect EE.

---

## DFHNCOPT — CICS Options (Assembler)

**File:** `CBSA/asm/DFHNCOPT.assemble` | **Type:** HLASM

CICS system initialization options table override. Built by `Assembler.groovy` in the DBB pipeline. Controls CICS region-level Named Counter settings.
