-- Licensed Materials - Property of IBM
--
-- (c) Copyright IBM Corp. 2016,2019.
--
-- US Government Users Restricted Rights - Use, duplication or
-- disclosure restricted by GSA ADP Schedule Contract
-- with IBM Corp.
SET CURRENT SQLID = '@DB2_OWNER@';
CREATE STOGROUP ACCOUNT VOLUMES(@DB2_VOL@) VCAT @DB2_VCAT@;
CREATE TABLESPACE ACCOUNT USING STOGROUP ACCOUNT;

CREATE TABLE @DB2_OWNER@.ACCOUNT (
                    ACCOUNT_EYECATCHER             CHAR(4),
                    ACCOUNT_CUSTOMER_NUMBER        CHAR(10),
                    ACCOUNT_SORTCODE               CHAR(6) NOT NULL,
                    ACCOUNT_NUMBER                 CHAR(8) NOT NULL,
                    ACCOUNT_TYPE                   CHAR(8),
                    ACCOUNT_INTEREST_RATE          DECIMAL(6, 2),
                    ACCOUNT_OPENED                 DATE,
                    ACCOUNT_OVERDRAFT_LIMIT        INTEGER,
                    ACCOUNT_LAST_STATEMENT         DATE,
                    ACCOUNT_NEXT_STATEMENT         DATE,
                    ACCOUNT_AVAILABLE_BALANCE      DECIMAL(12, 2),
                    ACCOUNT_ACTUAL_BALANCE         DECIMAL(12, 2)
                   )
IN ACCOUNT   NOT VOLATILE
CARDINALITY  AUDIT NONE  DATA CAPTURE NONE;

CREATE UNIQUE INDEX @DB2_OWNER@.ACCTINDX
 ON @DB2_OWNER@.ACCOUNT(ACCOUNT_SORTCODE,ACCOUNT_NUMBER)
 USING STOGROUP ACCOUNT;

CREATE INDEX @DB2_OWNER@.ACCTCUST
 ON @DB2_OWNER@.ACCOUNT(ACCOUNT_SORTCODE,ACCOUNT_CUSTOMER_NUMBER)
 USING STOGROUP ACCOUNT;

CREATE STOGROUP CONTROL VOLUMES(@DB2_VOL@) VCAT @DB2_VCAT@;
CREATE TABLESPACE CONTROL USING STOGROUP CONTROL;

CREATE TABLE @DB2_OWNER@.CONTROL (
                    CONTROL_NAME                   CHAR(32),
                    CONTROL_VALUE_NUM              INTEGER,
                    CONTROL_VALUE_STR              CHAR(40)
                   )
IN CONTROL   NOT VOLATILE

CARDINALITY  AUDIT NONE  DATA CAPTURE NONE;

CREATE UNIQUE INDEX @DB2_OWNER@.CONTINDX
 ON @DB2_OWNER@.CONTROL(CONTROL_NAME)
 USING STOGROUP CONTROL;


CREATE STOGROUP CUSTOMER VOLUMES(@DB2_VOL@) VCAT @DB2_VCAT@;
CREATE TABLESPACE CUSTOMER USING STOGROUP CUSTOMER;


CREATE TABLE @DB2_OWNER@.CUSTOMER (
                    CUSTOMER_EYECATCHER CHAR(4),
                    CUSTOMER_SORTCODE CHAR(6) NOT NULL,
                    CUSTOMER_NUMBER CHAR(10) NOT NULL,
                    CUSTOMER_NAME CHAR(60),
                    CUSTOMER_ADDRESS CHAR(160),
                    CUSTOMER_DOB DATE,
                    CUSTOMER_CREDIT_SCORE CHAR(3),
                    CUSTOMER_CS_REVIEW_DATE DATE,
                    PRIMARY KEY (CUSTOMER_SORTCODE,CUSTOMER_NUMBER))

IN CUSTOMER  NOT VOLATILE

CARDINALITY  AUDIT NONE  DATA CAPTURE NONE;

CREATE UNIQUE INDEX @DB2_OWNER@.CUSTINDX
 ON @DB2_OWNER@.CUSTOMER(CUSTOMER_SORTCODE,CUSTOMER_NUMBER)
 USING STOGROUP CUSTOMER;


CREATE STOGROUP PROCTRAN VOLUMES(@DB2_VOL@) VCAT @DB2_VCAT@;
CREATE TABLESPACE PROCTRAN USING STOGROUP PROCTRAN;



CREATE TABLE @DB2_OWNER@.PROCTRAN
                  (
                    PROCTRAN_EYECATCHER            CHAR(4),
                    PROCTRAN_SORTCODE              CHAR(6) NOT NULL,
                    PROCTRAN_NUMBER                CHAR(8) NOT NULL,
                    PROCTRAN_DATE                  DATE,
                    PROCTRAN_TIME                  CHAR(6),
                    PROCTRAN_REF                   CHAR(12),
                    PROCTRAN_TYPE                  CHAR(3),
                    PROCTRAN_DESC                  CHAR(40),
                    PROCTRAN_AMOUNT                DECIMAL(12, 2)
                   )
IN PROCTRAN  NOT VOLATILE

CARDINALITY  AUDIT NONE  DATA CAPTURE NONE;


CREATE STOGROUP REJTRAN VOLUMES(@DB2_VOL@) VCAT @DB2_VCAT@;
CREATE TABLESPACE REJTRAN NOT LOGGED USING STOGROUP REJTRAN;

CREATE TABLE @DB2_OWNER@.REJTRAN
                  (
                    REJTRAN_EYECATCHER             CHAR(4),
                    REJTRAN_SORTCODE               CHAR(6) NOT NULL,
                    REJTRAN_NUMBER                 CHAR(8) NOT NULL,
                    REJTRAN_DATE                   DATE,
                    REJTRAN_TIME                   CHAR(6),
                    REJTRAN_REF                    CHAR(12),
                    REJTRAN_ORIG_IDENT             CHAR(3),
                    REJTRAN_TYPE                   CHAR(3),
                    REJTRAN_DESC                   CHAR(40),
                    REJTRAN_AMOUNT                 DECIMAL(12, 2),
                    REJTRAN_REASON                 CHAR(2)
                   )
IN REJTRAN   NOT VOLATILE

CARDINALITY  AUDIT NONE  DATA CAPTURE NONE;

CREATE STOGROUP SODD VOLUMES(@DB2_VOL@) VCAT @DB2_VCAT@;
CREATE TABLESPACE SODD USING STOGROUP SODD;


CREATE TABLE @DB2_OWNER@.SODD (
                    SODD_EYECATCHER         CHAR(4),
                    SODD_SORTCODE           CHAR(6) NOT NULL,
                    SODD_NUMBER             CHAR(8) NOT NULL,
                    SODD_TYPE               CHAR(2) NOT NULL,
                    SODD_ACTIVE             CHAR(1) NOT NULL,
                    SODD_START_DATE         CHAR(8),
                    SODD_END_DATE           CHAR(8),
                    SODD_PERIOD_TYPE        CHAR(1),
                    SODD_PAYMENT_PERIOD     CHAR(3),
                    SODD_REFERENCE          CHAR(20),
                    SODD_AMOUNT             DECIMAL(12,2),
                    SODD_TO_SORTCODE        CHAR(6) NOT NULL,
                    SODD_TO_ACCNO           CHAR(8) NOT NULL
                   )
IN SODD NOT VOLATILE

CARDINALITY  AUDIT NONE  DATA CAPTURE NONE;


CREATE STOGROUP STMNT VOLUMES(@DB2_VOL@) VCAT @DB2_VCAT@;
CREATE TABLESPACE STMNT USING STOGROUP STMNT;



CREATE TABLE @DB2_OWNER@.STMNT (
                  STMNT_SORTCODE CHAR(6) NOT NULL,
                  STMNT_ACCNO    CHAR(8) NOT NULL,
                  STMNT_DATE     DATE    NOT NULL,
                  STMNT_ENTRY    INTEGER NOT NULL,
                  STMNT_TYPE     CHAR(3) NOT NULL,
                  STMNT_REF      CHAR(12) NOT NULL,
                  STMNT_TIME     CHAR(6)  NOT NULL,
                  STMNT_DESC     CHAR(40),
                  STMNT_AMT      DECIMAL(12, 2) NOT NULL
                  )
IN STMNT  NOT VOLATILE
CARDINALITY  AUDIT NONE  DATA CAPTURE NONE;

CREATE INDEX @DB2_OWNER@.STMNTIX2
 ON @DB2_OWNER@.STMNT(STMNT_SORTCODE,STMNT_ACCNO,STMNT_DATE)
 USING STOGROUP STMNT;


CREATE STOGROUP WORKLOAD VOLUMES(@DB2_VOL@) VCAT @DB2_VCAT@;
CREATE TABLESPACE WORKLOAD USING STOGROUP WORKLOAD;

CREATE TABLE @DB2_OWNER@.WORKLOAD(
                    WORKLOAD_NAME     CHAR(8) NOT NULL,
                    WORKLOAD_DAY      CHAR(9) NOT NULL,
                    WORKLOAD_TYPE     CHAR(2) NOT NULL,
                    WORKLOAD_AT       TIME NOT NULL,
                    WORKLOAD_WHAT     CHAR(5),
                    WORKLOAD_UTI      INTEGER,
                    WORKLOAD_TERMINAL INTEGER,
                    WORKLOAD_RANDOM   CHAR(1),
       PRIMARY KEY (WORKLOAD_NAME, WORKLOAD_DAY,WORKLOAD_TYPE,
                    WORKLOAD_AT))
IN WORKLOAD  NOT VOLATILE
CARDINALITY  AUDIT NONE  DATA CAPTURE NONE;

CREATE UNIQUE INDEX @DB2_OWNER@.WORKINDX
  ON WORKLOAD(WORKLOAD_NAME,WORKLOAD_DAY,WORKLOAD_TYPE,
                     WORKLOAD_AT)
   USING STOGROUP WORKLOAD;

