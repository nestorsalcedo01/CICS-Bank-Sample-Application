---
layout: default
title: CICS Screen Handler Programs
---

# CICS Screen Handler Programs

These programs handle BMS map presentation and user interaction. They all use `PROCESS CICS,NODYNAM,NSYMBOL(NATIONAL),TRUNC(STD)` and are flagged `isCICS=true` in `file.properties`.

## BNKMENU — Main Menu

**Program ID:** `BNKMENU` | **Map:** `BNK1MAI` | **Transaction:** Entry point

Displays the main banking menu. Validates the user's menu selection and routes to the appropriate transaction. First program invoked in the BMS application suite.

**PF Key handling:**

| Key | Action |
|---|---|
| Enter | Process menu selection |
| PF3 | Return / Exit |
| PF12 | Abend (test/debug) |

---

## BNK1CAC — Create Account Screen

**Program ID:** `BNK1CAC` | **Map:** `BNK1CAM` | **LINK to:** `CREACC`

Collects account creation details from the user and calls `CREACC` via `EXEC CICS LINK`. Displays the new account number on success.

---

## BNK1CCA — Create Customer + Account Screen

**Program ID:** `BNK1CCA` | **Map:** `BNK1CCM` | **LINK to:** `CRECUST`, `CREACC`

Two-step operation: creates a customer record first via `CRECUST`, then creates an account for that customer via `CREACC`. Both must succeed; if `CREACC` fails the customer is created but no account is opened.

---

## BNK1CCS — Create Customer Screen

**Program ID:** `BNK1CCS` | **Map:** `BNK1CDM` | **LINK to:** `CRECUST`

Collects new customer details (name, address, date of birth) and calls `CRECUST`.

---

## BNK1CRA — Customer + Accounts List Screen

**Program ID:** `BNK1CRA` | **Map:** `BNK1ACC` | **LINK to:** `INQCUST`, `INQACCCU`

Displays a customer's details and a scrollable list of all their accounts. Calls `INQCUST` for customer data and `INQACCCU` for the account list.

---

## BNK1DAC — Delete Account Screen

**Program ID:** `BNK1DAC` | **Map:** `BNK1DAM` | **LINK to:** `DELACC`

Confirms and deletes a single account. Calls `DELACC`. Requires the account balance to be zero before deletion is permitted.

---

## BNK1DCS — Delete Customer Screen

**Program ID:** `BNK1DCS` | **Map:** `BNK1DCM` | **LINK to:** `DELCUS`

Deletes a customer record. Calls `DELCUS`. All accounts for the customer must already be deleted before the customer can be removed.

---

## BNK1TFN — Transfer Screen

**Program ID:** `BNK1TFN` | **Map:** `BNK1TFM` | **LINK to:** `XFRFUN`

Handles fund transfers between two accounts. Calls `XFRFUN` which internally uses `DBCRFUN` for the debit/credit operations.

---

## BNK1UAC — Update Account Screen

**Program ID:** `BNK1UAC` | **Map:** `BNK1UAM` | **LINK to:** `UPDACC`

Updates account fields (interest rate, overdraft limit). Calls `UPDACC`.
