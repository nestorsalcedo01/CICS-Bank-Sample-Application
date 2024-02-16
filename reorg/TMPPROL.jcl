//TMPPROL JOB 'DB2',NOTIFY=&SYSUID,CLASS=A,MSGCLASS=H,
//          MSGLEVEL=(1,1),REGION=4M
//*
//*
//* Licensed Materials - Property of IBM
//*
//* (c) Copyright IBM Corp. 2019,2020.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract
//* with IBM Corp.
//*
//*
//*
//******************************************************************
//******************************************************************
//******************************************************************
//*  Execute PROLOAD which reads the offloaded PROCTRAN info       *
//*  adds in an additional '0' onto the account number and         *
//*  if it is a TRANSFER type, then also adds in a leading 0 into  *
//*  the account number embedded in the DESCRIPTION. Then          *
//*  INSERTs the record on to the newly revised PROCTRAN table.    *
//*                                                                *
//*                                                                *
//******************************************************************
//*
//RELOAD1  EXEC PGM=IKJEFT01,REGION=0M
//STEPLIB  DD DISP=SHR,DSN=CBSA.CICSBSA.DBRM
//         DD DISP=SHR,DSN=CBSA.CICSBSA.LOADLIB
//         DD DISP=SHR,DSN=DSNC10.SDSNLOAD
//ESDS     DD DISP=SHR,DSN=CBSA.CICSBSA.TMPPFF
//SYSPRINT DD SYSOUT=*
//SYSABOUT DD SYSOUT=*
//SYSDBOUT DD SYSOUT=*
//DISPLAY  DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
 DSN SYSTEM(DBCG)
 RUN PROGRAM(PROLOAD)  -
 PLAN(CBSA) -
 LIB('CBSA.CICSBSA.LOADLIB')
 END
/*
