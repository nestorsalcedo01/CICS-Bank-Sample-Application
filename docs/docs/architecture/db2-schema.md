---
layout: default
title: DB2 Schema
---

# DB2 Schema

All tables are owned by `IBMUSER` in DB2 subsystem **`DBCG`**, collection **`PCBSA`**.

## IBMUSER.ACCOUNT

Stores all bank account records.

| Column | Type | Description |
|---|---|---|
| ACCOUNT_EYECATCHER | CHAR(4) | Always `ACCT` — used for storage validation |
| ACCOUNT_CUSTOMER_NUMBER | CHAR(10) | Owner customer number |
| ACCOUNT_SORTCODE | CHAR(6) NOT NULL | Bank sort code |
| ACCOUNT_NUMBER | CHAR(8) NOT NULL | Unique account number (from Named Counter) |
| ACCOUNT_TYPE | CHAR(8) | Account type (e.g., CURRENT, SAVING) |
| ACCOUNT_INTEREST_RATE | DECIMAL(6,2) | Annual interest rate |
| ACCOUNT_OPENED | DATE | Date account was opened |
| ACCOUNT_OVERDRAFT_LIMIT | INTEGER | Overdraft limit in pence |
| ACCOUNT_LAST_STATEMENT | DATE | Date of last statement |
| ACCOUNT_NEXT_STATEMENT | DATE | Date of next statement |
| ACCOUNT_AVAILABLE_BALANCE | DECIMAL(12,2) | Available balance |
| ACCOUNT_ACTUAL_BALANCE | DECIMAL(12,2) | Actual balance |

## IBMUSER.CUSTOMER

Stores customer master records.

| Column | Type | Description |
|---|---|---|
| CUSTOMER_EYECATCHER | CHAR(4) | Always `CUST` |
| CUSTOMER_SORTCODE | CHAR(6) NOT NULL | Bank sort code |
| CUSTOMER_NUMBER | CHAR(10) NOT NULL | Unique customer number |
| CUSTOMER_NAME | CHAR(60) | Full customer name |
| CUSTOMER_ADDRESS | CHAR(160) | Customer address |
| CUSTOMER_DATE_OF_BIRTH | DATE | Date of birth |
| CUSTOMER_CREDIT_SCORE | SMALLINT | Credit score (0–999) |
| CUSTOMER_CS_REVIEW_DATE | DATE | Credit score review date |

## IBMUSER.PROCTRAN

Audit log of all banking transactions.

| Column | Type | Description |
|---|---|---|
| PROCTRAN_EYECATCHER | CHAR(4) | Always `PROC` |
| PROCTRAN_SORTCODE | CHAR(6) | Bank sort code |
| PROCTRAN_NUMBER | CHAR(8) | Account number |
| PROCTRAN_DATE | DATE | Transaction date |
| PROCTRAN_TIME | TIME | Transaction time |
| PROCTRAN_REF | CHAR(12) | Transaction reference |
| PROCTRAN_TYPE | CHAR(3) | Transaction type code |
| PROCTRAN_DESC | CHAR(40) | Description |
| PROCTRAN_AMOUNT | DECIMAL(12,2) | Amount |

## IBMUSER.CONTROL

Single-row control record used for counters and configuration.

## Setup and Teardown JCL

All DB2 JCL jobs are in `Db2_jcl_install/`. They must be submitted on z/OS.

| Job | Purpose |
|---|---|
| `CREDB00.jcl` | Create database |
| `CRETB01–04.jcl` | Create tables (ACCOUNT, CUSTOMER, PROCTRAN, CONTROL) |
| `CRETS01–04.jcl` | Create table spaces |
| `CREI101–301.jcl` | Create indexes |
| `CRESG01–04.jcl` | Create storage groups |
| `DB2BIND.jcl` | Bind packages (`bind_collectionID=PCBSA`) |
| `DROPDB2.jcl` | Drop everything (use with caution) |
