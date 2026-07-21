---
layout: default
title: Component Interactions
---

# Component Interactions

## CICS Program Call Graph

The following diagram shows how CICS programs call each other. BMS screen handler programs (BNK1xxx) call the business service programs which in turn perform DB2 operations.

```mermaid
flowchart LR
    BNKMENU["BNKMENU\nMain Menu"]

    subgraph Screen_Handlers ["BMS Screen Handlers"]
        BNK1CAC["BNK1CAC\nCreate Account"]
        BNK1CCA["BNK1CCA\nCreate Cust+Acc"]
        BNK1CCS["BNK1CCS\nCreate Customer"]
        BNK1CRA["BNK1CRA\nCust+Acc List"]
        BNK1DAC["BNK1DAC\nDelete Account"]
        BNK1DCS["BNK1DCS\nDelete Customer"]
        BNK1TFN["BNK1TFN\nTransfer"]
        BNK1UAC["BNK1UAC\nUpdate Account"]
    end

    subgraph Services ["Business Service Programs"]
        CREACC["CREACC\nCreate Account"]
        CRECUST["CRECUST\nCreate Customer"]
        DELACC["DELACC\nDelete Account"]
        DELCUS["DELCUS\nDelete Customer"]
        INQACC["INQACC\nEnquire Account"]
        INQACCCU["INQACCCU\nList Accounts"]
        INQCUST["INQCUST\nEnquire Customer"]
        UPDACC["UPDACC\nUpdate Account"]
        UPDCUST["UPDCUST\nUpdate Customer"]
        DBCRFUN["DBCRFUN\nDebit/Credit"]
        XFRFUN["XFRFUN\nTransfer"]
    end

    subgraph Credit ["Credit Agency Stubs"]
        CRDTAGY1 & CRDTAGY2 & CRDTAGY3 & CRDTAGY4 & CRDTAGY5
    end

    BNKMENU --> Screen_Handlers
    BNK1CAC --> CREACC
    BNK1CCA --> CREACC & CRECUST
    BNK1CCS --> CRECUST
    BNK1CRA --> INQCUST & INQACCCU
    BNK1DAC --> DELACC
    BNK1DCS --> DELCUS
    BNK1TFN --> XFRFUN
    BNK1UAC --> UPDACC
    CREACC --> Credit
    XFRFUN --> DBCRFUN
```

## Copybook Dependencies

All inter-program data contracts are defined in `CBSA/copylib/`. Programs share data layouts through these copybooks — changing a copybook layout impacts every program that includes it.

| Copybook | Used By | Purpose |
|---|---|---|
| ACCOUNT.cpy | CREACC, DELACC, INQACC, UPDACC | Account DB2 row layout |
| CUSTOMER.cpy | CRECUST, DELCUS, INQCUST, UPDCUST | Customer DB2 row layout |
| PROCTRAN.cpy | All state-changing programs | Audit transaction record |
| SORTCODE.cpy | All programs | Bank sort code constant |
| DATASTR.cpy | CREACC, CRECUST | Shared data structures |
| BNK1MAI.cpy | BNKMENU | BMS map DSECT (generated) |
| CREACC.cpy | BNK1CAC, BNK1CCA, z/OS Connect | COMMAREA for CREACC LINK |
| CRECUST.cpy | BNK1CCS, BNK1CCA, z/OS Connect | COMMAREA for CRECUST LINK |
