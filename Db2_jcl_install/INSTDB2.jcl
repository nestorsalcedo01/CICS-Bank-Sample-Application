//INSTDB2 JOB 'DB2',NOTIFY=&SYSUID,CLASS=A,MSGCLASS=H,
//          MSGLEVEL=(1,1),REGION=4M
//*
//JCLLIB  JCLLIB ORDER=DSNC10.PROCLIB
//JOBLIB  DD  DISP=SHR,DSN=DSNC10.SDSNLOAD
//GRANT   EXEC PGM=IKJEFT01,DYNAMNBR=20
//SYSTSPRT DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//SYSTSIN  DD  *
  DSN SYSTEM(DBCG)
  RUN PROGRAM(DSNTEP2)  PLAN(DSNTEP12) -
       LIB('DSNC10.DBCG.RUNLIB.LOAD') PARMS('/ALIGN(MID)')
  END
//SYSIN    DD  *
SET CURRENT SQLID = 'IBMUSER';
--DROP DATABASE CBSA;

CREATE DATABASE CBSA
       BUFFERPOOL BP1
       INDEXBP BP2;

--DROP STOGROUP ACCOUNT;

CREATE STOGROUP ACCOUNT VOLUMES('*','*','*','*','*') VCAT DSNV12DP;

--DROP TABLESPACE ACCOUNT;

CREATE TABLESPACE ACCOUNT IN CBSA USING STOGROUP ACCOUNT;

--DROP TABLE IBMUSER.ACCOUNT;

CREATE TABLE IBMUSER.ACCOUNT (
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
IN CBSA.ACCOUNT   NOT VOLATILE
CARDINALITY  AUDIT NONE  DATA CAPTURE NONE;

--DROP STOGROUP CONSENT;

CREATE STOGROUP CONSENT VOLUMES('*','*','*','*','*') VCAT DSNV12DP;

--DROP TABLESPACE CONSENT;

CREATE TABLESPACE CONSENT IN CBSA USING STOGROUP CONSENT;

--DROP TABLE IBMUSER.CONSENT;

CREATE TABLE IBMUSER.CONSENT (
             CONSENT_ID                     INTEGER NOT NULL,
             CONSENT_STATUS                 CHAR(1),
             DOMESTIC_PAY_ID                INTEGER NOT NULL,
             DOMESTIC_PAY_STATUS            CHAR(4),
             CREDIT_AC                      CHAR(16) NOT NULL,
             CREDIT_AC_SCHEMENAME           CHAR(50),
             CREDIT_AC_CUSTNAME             CHAR(50),
             DEBIT_AC                       CHAR(16) NOT NULL,
             DEBIT_AC_SCHEMENAME            CHAR(50),
             DEBIT_AC_CUSTNAME              CHAR(50),
             CONSENT_AMOUNT                 DECIMAL(12, 2),
             CURRENCY_CD                    CHAR(3),
             CREATE_TS                      TIMESTAMP NOT NULL,
             LAST_UPDATE_TS                 TIMESTAMP NOT NULL
                   )
IN CBSA.CONSENT  NOT VOLATILE
CARDINALITY  AUDIT NONE  DATA CAPTURE NONE;

INSERT INTO IBMUSER.CONSENT
                (
                  CONSENT_ID           ,
                  CONSENT_STATUS       ,
                  CONSENT_AMOUNT       ,
                  DOMESTIC_PAY_ID      ,
                  DOMESTIC_PAY_STATUS  ,
                  CREDIT_AC            ,
                  CREDIT_AC_SCHEMENAME ,
                  CREDIT_AC_CUSTNAME   ,
                  DEBIT_AC             ,
                  DEBIT_AC_SCHEMENAME  ,
                  DEBIT_AC_CUSTNAME    ,
                  CURRENCY_CD          ,
                  CREATE_TS            ,
                  LAST_UPDATE_TS
                )
                VALUES
                (
                  1 ,
                  'C' ,
                  999.99 ,
                  2 ,
                  'ASC ' ,
                  '98765400000001' ,
                  'FROM CONSTTST2' ,
                  'John Jr.' ,
                  '98765400000002' ,
                  'FROM CONSTTST1' ,
                  'Andrew Hopkins' ,
                  'USD' ,
                  CURRENT TIMESTAMP ,
                  CURRENT TIMESTAMP
                );

--DROP INDEX IBMUSER.ACCTINDX;

CREATE UNIQUE INDEX IBMUSER.ACCTINDX
  ON IBMUSER.ACCOUNT(ACCOUNT_SORTCODE,ACCOUNT_NUMBER)
  USING STOGROUP ACCOUNT;

--DROP INDEX IBMUSER.ACCTCUST;

CREATE INDEX IBMUSER.ACCTCUST
   ON IBMUSER.ACCOUNT(ACCOUNT_SORTCODE,ACCOUNT_CUSTOMER_NUMBER)
   USING STOGROUP ACCOUNT;

--DROP STOGROUP PROCTRAN;

CREATE STOGROUP PROCTRAN VOLUMES('*','*','*','*','*') VCAT DSNV12DP;

--DROP TABLESPACE PROCTRAN;

CREATE TABLESPACE PROCTRAN IN CBSA USING STOGROUP PROCTRAN;

--DROP TABLE PROCTRAN;

CREATE TABLE IBMUSER.PROCTRAN
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
IN CBSA.PROCTRAN  NOT VOLATILE
CARDINALITY  AUDIT NONE  DATA CAPTURE NONE;

--DROP STOGROUP CONTROL;

CREATE STOGROUP CONTROL VOLUMES('*','*','*','*','*') VCAT DSNV12DP;

--DROP TABLESPACE CONTROL;

CREATE TABLESPACE CONTROL IN CBSA USING STOGROUP CONTROL;

--DROP TABLE CONTROL;

CREATE TABLE IBMUSER.CONTROL (
                    CONTROL_NAME                   CHAR(32),
                    CONTROL_VALUE_NUM              INTEGER,
                    CONTROL_VALUE_STR              CHAR(40)
                   )
IN CBSA.CONTROL  NOT VOLATILE
CARDINALITY  AUDIT NONE  DATA CAPTURE NONE;

--DROP INDEX IBMUSER.CONTINDX;

CREATE UNIQUE INDEX IBMUSER.CONTINDX
 ON IBMUSER.CONTROL(CONTROL_NAME)
 USING STOGROUP CONTROL;

/*
