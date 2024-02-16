//BANKTPNS JOB ,,CLASS=A,MSGCLASS=H,TIME=1440
//* Licensed Materials - Property of IBM
//*
//* (c) Copyright IBM Corp. 2018,2019.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract
//* with IBM Corp.
//*
//*
//*
//* Please change @WSIM_PREFIX@ to the high level qualifier of your
//* TPNS/WSim datasets
//*
//* Please change @BANK_PREFIX@ to the high level qualifier of your
//* NETWORKS and SCRIPTS datasets
//*
//* Please change @BANKMON@ to your chosen TPNS Display Monitor
//* The sample VTAM node uses HBANKMON
//*
//* Uncomment the following line if you wish to activate the sample
//* VTAM major node
//*V NET,ACT,ID=HBNKVTAM
//TPNS    EXEC PGM=ITPENTER,PARM='DMAPPL=@BANKMON@',
//       REGION=0K
//STEPLIB  DD DSN=@WSIM_PREFIX@.SITPLOAD,DISP=SHR
//         DD DSN=@BANK_PREFIX@.LOADLIB,DISP=SHR
//INITDD   DD DSN=@BANK_PREFIX@.NETWORKS,DISP=SHR
//*
//MSGDD    DD DSN=@BANK_PREFIX@.SCRIPTS,DISP=SHR
//*
//LOGDD    DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
