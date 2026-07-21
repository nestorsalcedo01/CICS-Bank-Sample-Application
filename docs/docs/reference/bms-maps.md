---
layout: default
title: BMS Maps Reference
---

# BMS Maps Reference

Quick reference for all BMS map definitions. For detailed screen descriptions see [Program Reference — BMS Maps](../programs/bms-maps.html).

## Map Set Summary

| Map Set Name | File | Screen Size | Program |
|---|---|---|---|
| `BNK1MAI` | `BNK1MAI.bms` | 24×80 | BNKMENU |
| `BNK1CAM` | `BNK1CAM.bms` | 24×80 | BNK1CAC |
| `BNK1CCM` | `BNK1CCM.bms` | 24×80 | BNK1CCA |
| `BNK1CDM` | `BNK1CDM.bms` | 24×80 | BNK1CCS |
| `BNK1ACC` | `BNK1ACC.bms` | 24×80 | BNK1CRA |
| `BNK1DAM` | `BNK1DAM.bms` | 24×80 | BNK1DAC |
| `BNK1DCM` | `BNK1DCM.bms` | 24×80 | BNK1DCS |
| `BNK1TFM` | `BNK1TFM.bms` | 24×80 | BNK1TFN |
| `BNK1UAM` | `BNK1UAM.bms` | 24×80 | BNK1UAC |
| `BNK1B2M` | `BNK1B2M.bms` | 24×80 | (secondary display) |

## Generated Copybooks

Each BMS map generates a DSECT copybook in `CBSA/copylib/` during build:

| Map File | Generated Copybook |
|---|---|
| `BNK1MAI.bms` | `BNK1MAI.cpy` |
| `BNK1CAM.bms` | `BNK1CAM.cpy` |
| `BNK1CCM.bms` | `BNK1CCM.cpy` |
| `BNK1CDM.bms` | `BNK1CDM.cpy` — note: map is `BNK1CDM`, copybook name matches |
| `BNK1ACC.bms` | `BNK1ACC.cpy` |
| `BNK1DAM.bms` | `BNK1DAM.cpy` |
| `BNK1DCM.bms` | `BNK1DCM.cpy` |
| `BNK1TFM.bms` | `BNK1TFM.cpy` |
| `BNK1UAM.bms` | `BNK1UAM.cpy` |

> These copybooks are **generated artifacts**. Do not edit them directly — changes will be overwritten on the next BMS build.
