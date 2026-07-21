---
layout: default
title: CICS Region Configuration
---

# CICS Region Configuration

After building and deploying the COBOL load modules, the CICS region must be configured to run CBSA transactions.

## Program Definitions

Define each COBOL load module as a CICS program resource. All programs use these standard attributes:

```
LANGUAGE(COBOL)
EXECKEY(USER)
CONCURRENCY(QUASIRENT)
DATALOCATION(ANY)
```

Programs requiring dynamic storage: `BNKMENU`, `BNK1CAC`, `BNK1CCA`, `BNK1CCS`, `BNK1CRA`, `BNK1DAC`, `BNK1DCS`, `BNK1TFN`, `BNK1UAC`.

## Transaction Definitions

Define CICS transactions that map to the BMS screen handler programs:

| Transaction | Program | Description |
|---|---|---|
| `BMNU` | `BNKMENU` | Main menu |
| `BCAC` | `BNK1CAC` | Create account |
| `BCCA` | `BNK1CCA` | Create customer + account |
| `BCCS` | `BNK1CCS` | Create customer |
| `BCRA` | `BNK1CRA` | Customer + accounts list |
| `BDAC` | `BNK1DAC` | Delete account |
| `BDCS` | `BNK1DCS` | Delete customer |
| `BTFN` | `BNK1TFN` | Transfer |
| `BUAC` | `BNK1UAC` | Update account |

## JVM Server (Liberty) for Spring Boot

The Spring Boot WAR deploys to a CICS Liberty JVM server named **`CBSAWLP`**. Configure the JVM server with:

- Java 11 or higher
- Minimum heap: 512MB
- Liberty features: `servlet-4.0`, `jaxrs-2.1`

## Named Counters

CBSA uses two CICS Named Counters:

| Counter Name | Used By | Purpose |
|---|---|---|
| `ACCOUNT` | `CREACC` | Sequential account number generation |
| `CUSTOMER` | `CRECUST` | Sequential customer number generation |

Named Counter options are set via `CBSA/asm/DFHNCOPT.assemble` — rebuild and re-install this module if counter initial values need to change.

## Install JCL

Sample CICS install JCL is provided in `jclInstall/`. Review and tailor to your CICS region before submitting.
