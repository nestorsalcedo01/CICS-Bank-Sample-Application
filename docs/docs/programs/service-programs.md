---
layout: default
title: Business Service Programs
---

# Business Service Programs

These programs implement core banking business logic. They are called via `EXEC CICS LINK` from both BMS screen handlers and z/OS Connect EE services. All use CICS + DB2 (`isCICS=true`, `isSQL=true`).

## CREACC — Create Account

**Program ID:** `CREACC` | **COMMAREA:** `CBSA/copylib/CREACC.cpy`

Creates a new bank account for a given customer. Workflow:

1. Enqueue CICS Named Counter for `ACCOUNT` — prevents duplicate account numbers under concurrent load.
2. Increment Named Counter to get the next account number.
3. Call `CRDTAGY1`–`CRDTAGY5` (credit agency simulators) for a credit score.
4. Write new row to `IBMUSER.ACCOUNT`.
5. Write audit record to `IBMUSER.PROCTRAN`.
6. Dequeue Named Counter.

If DB2 write fails: decrements Named Counter back to its previous value before dequeuing.

---

## CRECUST — Create Customer

**Program ID:** `CRECUST` | **COMMAREA:** `CBSA/copylib/CRECUST.cpy`

Creates a new customer record in `IBMUSER.CUSTOMER`. Assigns a sequential customer number using a CICS Named Counter.

---

## INQACC — Enquire Account

**Program ID:** `INQACC` | **COMMAREA:** `CBSA/copylib/ACCOUNT.cpy`

Reads a single account record from `IBMUSER.ACCOUNT` by sort code + account number.

---

## INQACCCU — List Accounts for Customer

**Program ID:** `INQACCCU`

Returns all account records for a given customer number. Uses a DB2 cursor to fetch multiple rows.

---

## INQCUST — Enquire Customer

**Program ID:** `INQCUST` | **COMMAREA:** `CBSA/copylib/CUSTOMER.cpy`

Reads a single customer record from `IBMUSER.CUSTOMER`.

---

## UPDACC — Update Account

**Program ID:** `UPDACC` | **COMMAREA:** `CBSA/copylib/ACCOUNT.cpy`

Updates modifiable account fields (interest rate, overdraft limit, type). Writes `IBMUSER.PROCTRAN` audit record on success.

---

## UPDCUST — Update Customer

**Program ID:** `UPDCUST` | **COMMAREA:** `CBSA/copylib/CUSTOMER.cpy`

Updates customer name and address fields in `IBMUSER.CUSTOMER`.

---

## DELACC — Delete Account

**Program ID:** `DELACC` | **COMMAREA:** `CBSA/copylib/DELACC.cpy`

Deletes an account from `IBMUSER.ACCOUNT`. Rejects deletion if account balance is non-zero. Writes `IBMUSER.PROCTRAN` audit record.

---

## DELCUS — Delete Customer

**Program ID:** `DELCUS` | **COMMAREA:** `CBSA/copylib/DELCUS.cpy`

Deletes a customer from `IBMUSER.CUSTOMER`. Rejects deletion if the customer still has active accounts.

---

## DBCRFUN — Debit/Credit Function

**Program ID:** `DBCRFUN` | **Uses:** CICS + DB2 + DLI (`CBL CICS('SP,EDF,DLI')`, `CBL SQL`)

Applies a debit or credit to an account. Updates `ACCOUNT_AVAILABLE_BALANCE` and `ACCOUNT_ACTUAL_BALANCE`, then writes to `IBMUSER.PROCTRAN`.

---

## XFRFUN — Transfer Function

**Program ID:** `XFRFUN` | **Uses:** CICS + DB2 + DLI

Transfers funds between two accounts by calling `DBCRFUN` twice: debit on source account, credit on destination account. Both calls must succeed within the same UoW.

---

## GETCOMPY — Get Company Name

**Program ID:** `GETCOMPY`

Returns the bank company name string. Used by BMS screen programs to populate the display header.

---

## GETSCODE — Get Sort Code

**Program ID:** `GETSCODE`

Returns the bank's sort code from the `IBMUSER.CONTROL` table. Used by programs that need the sort code at runtime.

---

## ABNDPROC — Abend Processor

**Program ID:** `ABNDPROC` | **COMMAREA:** `CBSA/copylib/ABNDINFO.cpy`

CICS abend handler. Captures abend information and writes it to a log. Linked to the CICS error handling mechanism.

---

## CONSENT — Consent Handler

**Program ID:** `CONSENT` | **COMMAREA:** `CBSA/copylib/CONSENT.cpy`

Handles customer consent processing. Reads and updates consent flags in the customer record.

---

## DPAYAPI — Direct Payment API

**Program ID:** `DPAYAPI` | **COMMAREA:** `CBSA/copylib/CONSTAPI.cpy`

Exposes a payment interface called by z/OS Connect EE's `Pay` service. Delegates to `DBCRFUN`.

---

## CRDTAGY1–CRDTAGY5 — Credit Agency Simulators

**Program IDs:** `CRDTAGY1`, `CRDTAGY2`, `CRDTAGY3`, `CRDTAGY4`, `CRDTAGY5`

Artificial credit scoring stubs called by `CREACC` during account creation. Return randomized credit scores. These are **not production-grade** — replace with real implementations for non-demo deployments. The COMMAREA interface must be preserved.
