//TMPACCL JOB 'DB2',NOTIFY=&SYSUID,CLASS=A,MSGCLASS=H,
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
//*  Execute ACCLOAD which reads the offloaded ACCOUNT information *
//*  adds in an additional '0' onto the account number and         *
//*  INSERTs the record on to the newly revised ACCOUNT table.     *
//*                                                                *
//*                                                                *
//******************************************************************
//*
//RELOAD1  EXEC PGM=IKJEFT01,REGION=0M
//STEPLIB  DD DISP=SHR,DSN=CBSA.CICSBSA.DBRM
//         DD DISP=SHR,DSN=CBSA.CICSBSA.LOADLIB
//         DD DISP=SHR,DSN=DSNC10.SDSNLOAD
//VSAM     DD DISP=SHR,DSN=CBSA.CICSBSA.TMPAFF
//SYSPRINT DD SYSOUT=*
//SYSABOUT DD SYSOUT=*
//SYSDBOUT DD SYSOUT=*
//DISPLAY  DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
 DSN SYSTEM(DBCG)
 RUN PROGRAM(ACCLOAD)  -
 PLAN(CBSA) -
 LIB('CBSA.CICSBSA.LOADLIB')
 END
/*
