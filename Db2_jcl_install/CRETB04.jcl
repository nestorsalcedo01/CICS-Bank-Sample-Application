//CRETB04 JOB 'DB2',NOTIFY=&SYSUID,CLASS=A,MSGCLASS=H,
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
           
/*
