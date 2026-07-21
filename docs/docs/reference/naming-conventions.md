---
layout: default
title: Naming Conventions
---

# Naming Conventions

## COBOL Program Names

All program names are 8 characters, uppercase. The naming convention encodes the function:

| Prefix | Meaning | Examples |
|---|---|---|
| `BNK1` | BMS screen handler (has a paired BMS map) | `BNK1CAC`, `BNK1TFN` |
| `BNKMENU` | Main menu | `BNKMENU` |
| `CREA` | Create Account | `CREACC` |
| `CREC` | Create Customer | `CRECUST` |
| `INQA` | Enquire Account | `INQACC`, `INQACCCU` |
| `INQC` | Enquire Customer | `INQCUST` |
| `UPDA` | Update Account | `UPDACC` |
| `UPDC` | Update Customer | `UPDCUST` |
| `DELA` | Delete Account | `DELACC` |
| `DELC` | Delete Customer | `DELCUS` |
| `DBCR` | Debit/Credit function | `DBCRFUN` |
| `XFR` | Transfer function | `XFRFUN` |
| `CRDT` | Credit agency stub | `CRDTAGY1`–`CRDTAGY5` |
| `ABND` | Abend handler | `ABNDPROC` |
| `GET` | Getter utility | `GETCOMPY`, `GETSCODE` |
| `T` (prefix, in testcase/) | zUnit test case | `TBNKMENU` |

## BMS Map Names

BMS map sets follow the pattern `BNK1xxx` where `xxx` identifies the screen:

| Suffix | Screen purpose |
|---|---|
| `MAI` | Main menu |
| `CAM` | Create account |
| `CCM` | Create customer + account |
| `CDM` | Create customer (display) |
| `ACC` | Account list |
| `DAM` | Delete account |
| `DCM` | Delete customer |
| `TFM` | Transfer |
| `UAM` | Update account |
| `B2M` | Secondary account map |

## Working-Storage Field Naming

| Prefix | Area |
|---|---|
| `WS-` | Working-Storage fields |
| `LS-` | Linkage Section fields |
| `IO-` | File I/O record areas |
| `DB-` | DB2 host variable areas |
| `ERR-` | Error handling fields |

## Copybook Names

Copybooks match their primary program or data structure name (max 8 chars, uppercase). Generated BMS DSECT copybooks match the map set name exactly.

## DB2 Column Names

All column names use the pattern `<TABLE>_<FIELD>` in uppercase:
- `ACCOUNT_NUMBER`, `ACCOUNT_TYPE`, `ACCOUNT_ACTUAL_BALANCE`
- `CUSTOMER_NUMBER`, `CUSTOMER_NAME`, `CUSTOMER_DATE_OF_BIRTH`
- `PROCTRAN_DATE`, `PROCTRAN_AMOUNT`, `PROCTRAN_TYPE`

## JCL Job Names

| Pattern | Purpose |
|---|---|
| `CRExx##.jcl` | Create DB2 object (xx=type, ##=sequence) |
|`DRPxx##.jcl` | Drop DB2 object |
| `RUNZUNIT.jcl` | Job card for zUnit test execution |
