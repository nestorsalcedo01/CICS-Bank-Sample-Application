//DB2REDD JOB 'DB2',NOTIFY=&SYSUID,CLASS=A,MSGCLASS=H,
//          MSGLEVEL=(1,1),REGION=4M
//*
//* Recreates the Db2 artifacts for PROCTRAN with the
//* PROCTRAN_NUMBER as 9 bytes instead of 8.
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

CREATE STOGROUP PROCTRAN VOLUMES('*','*','*','*','*') VCAT DSNV12DP;

CREATE TABLESPACE PROCTRAN IN CBSA USING STOGROUP PROCTRAN;

CREATE TABLE IBMUSER.PROCTRAN
                  (
                    PROCTRAN_EYECATCHER            CHAR(4),
                    PROCTRAN_SORTCODE              CHAR(6) NOT NULL,
                    PROCTRAN_NUMBER                CHAR(9) NOT NULL,
                    PROCTRAN_DATE                  DATE,
                    PROCTRAN_TIME                  CHAR(6),
                    PROCTRAN_REF                   CHAR(12),
                    PROCTRAN_TYPE                  CHAR(3),
                    PROCTRAN_DESC                  CHAR(40),
                    PROCTRAN_AMOUNT                DECIMAL(12, 2)
                   )
IN CBSA.PROCTRAN  NOT VOLATILE
CARDINALITY  AUDIT NONE  DATA CAPTURE NONE;

/*