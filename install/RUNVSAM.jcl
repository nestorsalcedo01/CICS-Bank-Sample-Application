//* Licensed Materials - Property of IBM
//*
//* (c) Copyright IBM Corp. 2020.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract
//* with IBM Corp.
//RUNVSAM JOB ,,CLASS=A,MSGCLASS=H,
//  NOTIFY=&SYSUID,
//  MSGLEVEL=(1,1)
//STEP0001 EXEC PGM=EXTDCUST
//STEPLIB DD DSN=CBSA.CICSBSA.LOADLIB,DISP=SHR
//VSAMIN DD DSN=CBSA.CICSBSA.CUSTOMER,DISP=SHR
//VSAMOUT DD DSN=CBSA.CICSBSA.EXTD.CUSTOMER,DISP=SHR
//OUT DD SYSOUT=*
//SYSPRINT   DD   SYSOUT=*