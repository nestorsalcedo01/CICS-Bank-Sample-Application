---
layout: default
title: BMS Maps
---

# BMS Maps

BMS (Basic Mapping Support) map definitions are in `CBSA/bms/`. Each `.bms` file defines a 3270 terminal screen used by the CICS screen handler programs.

## Map Inventory

| BMS File | Map Set | Used By Program | Description |
|---|---|---|---|
| `BNK1MAI.bms` | `BNK1MAI` / `BNK1ME` | `BNKMENU` | Main menu screen |
| `BNK1CAM.bms` | `BNK1CAM` | `BNK1CAC` | Create account screen |
| `BNK1CCM.bms` | `BNK1CCM` | `BNK1CCA` | Create customer + account screen |
| `BNK1CDM.bms` | `BNK1CDM` | `BNK1CCS` | Create customer screen |
| `BNK1ACC.bms` | `BNK1ACC` | `BNK1CRA` | Account list screen |
| `BNK1DAM.bms` | `BNK1DAM` | `BNK1DAC` | Delete account screen |
| `BNK1DCM.bms` | `BNK1DCM` | `BNK1DCS` | Delete customer screen |
| `BNK1TFM.bms` | `BNK1TFM` | `BNK1TFN` | Transfer screen |
| `BNK1UAM.bms` | `BNK1UAM` | `BNK1UAC` | Update account screen |
| `BNK1B2M.bms` | `BNK1B2M` | (utility) | Secondary account display map |

## Build Artifacts

During the DBB build, each `.bms` file generates two artifacts:

1. **Load module** — the compiled BMS map installed in CICS.
2. **DSECT copybook** (`CBSA/copylib/BNK1*.cpy`) — a COBOL layout of the map fields, included by the corresponding screen handler program.

> Do not hand-edit the generated copybooks in `CBSA/copylib/`. Edit the `.bms` source and rebuild.

## BMS Compile Parameters

From [`CBSA/application-conf/BMS.properties`](../../../CBSA/application-conf/BMS.properties):

```
bms_compileParms=SYSPARM(MAP),DECK,NOOBJECT      ← produces map load module
bms_copyGenParms=SYSPARM(DSECT),DECK,NOOBJECT    ← produces copybook DSECT
bms_linkEditParms=MAP,RENT,COMPAT(PM5)
bms_maxRC=4
```

## Screen Layout Convention

All CBSA BMS maps follow these conventions:
- Size: 24 rows × 80 columns (standard 3270 Model 2)
- Top-left field: transaction identifier (e.g., `BNK1MA`)
- Row 1, col 20–59: company name (populated by `GETCOMPY`)
- PF3: return/cancel on all screens
- PF12: reserved for abend testing (debug only)
