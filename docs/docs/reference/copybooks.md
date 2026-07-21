---
layout: default
title: Copybook Inventory
---

# Copybook Inventory

All 51 copybooks are in `CBSA/copylib/`. Copybooks with names matching a BMS map (`BNK1*.cpy`) are **generated artifacts** — do not edit them directly.

## Data Layout Copybooks

| Copybook | Used By | Description |
|---|---|---|
| `ACCOUNT.cpy` | INQACC, UPDACC | IBMUSER.ACCOUNT DB2 row layout |
| `CUSTOMER.cpy` | INQCUST, UPDCUST | IBMUSER.CUSTOMER DB2 row layout |
| `PROCTRAN.cpy` | All state-changing programs | IBMUSER.PROCTRAN audit record |
| `ACCDB2.cpy` | Account programs | DB2 account host variable area |
| `CONTDB2.cpy` | Control programs | DB2 control table host variables |
| `CONSTDB2.cpy` | Multiple | DB2 constant definitions |
| `CONSTAPI.cpy` | DPAYAPI | Payment API COMMAREA |
| `SORTCODE.cpy` | All programs | Bank sort code constant (6-char) |
| `DATASTR.cpy` | CREACC, CRECUST | Shared intermediate data structures |
| `ABNDINFO.cpy` | ABNDPROC | Abend information record |
| `CONSENT.cpy` | CONSENT | Customer consent flags |
| `BANKMAP.cpy` | Multiple | General bank-level map definitions |
| `CUSTMAP.cpy` | Customer programs | Customer screen map definitions |

## COMMAREA Copybooks

These define the interface contract between caller and called programs (and z/OS Connect EE):

| Copybook | Program | Purpose |
|---|---|---|
| `CREACC.cpy` | CREACC | Create account request/response |
| `CRECUST.cpy` | CRECUST | Create customer request/response |
| `DELACC.cpy` | DELACC | Delete account request |
| `DELACCZ.cpy` | DELACC | Delete account response variant |
| `DELCUS.cpy` | DELCUS | Delete customer request/response |
| `ACCTCTRL.cpy` | ACCTCTRL | Account Named Counter control |
| `CUSTCTRL.cpy` | CUSTCTRL | Customer Named Counter control |
| `CONTROLI.cpy` | Control programs | Control interface COMMAREA |
| `PROCISRT.cpy` | All UoW programs | PROCTRAN insert helper |

## BMS Map Copybooks (Generated)

These are generated from `.bms` source during build. Do not hand-edit:

| Copybook | Source Map | Used By |
|---|---|---|
| `BNK1MAI.cpy` | `BNK1MAI.bms` | BNKMENU |
| `BNK1CAM.cpy` | `BNK1CAM.bms` | BNK1CAC |
| `BNK1CCM.cpy` | `BNK1CCM.bms` | BNK1CCA |
| `BNK1CDM.cpy` | `BNK1CDM.bms` | BNK1CCS |
| `BNK1DAM.cpy` | `BNK1DAM.bms` | BNK1DAC |
| `BNK1DCM.cpy` | `BNK1DCM.bms` | BNK1DCS |
| `BNK1TFM.cpy` | `BNK1TFM.bms` | BNK1TFN |
| `BNK1UAM.cpy` | `BNK1UAM.bms` | BNK1UAC |
| `BNK1ACC.cpy` | `BNK1ACC.bms` | BNK1CRA |
