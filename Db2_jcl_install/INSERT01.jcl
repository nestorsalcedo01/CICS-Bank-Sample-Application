//INSERT01 JOB 'DB2',NOTIFY=&SYSUID,CLASS=A,MSGCLASS=H,
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
/*
