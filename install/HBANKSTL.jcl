//HBANKSTL JOB ,,CLASS=A,MSGCLASS=H,NOTIFY=&SYSUID.
//* Licensed Materials - Property of IBM
//*
//* (c) Copyright IBM Corp. 2018,2019.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract
//* with IBM Corp.
//*********************************************************************
//*                                                                   *
//* This will need a suitable JOB card for your environment           *
//*                                                                   *
//* Sample JCL for translating STL for HBank                          *
//*                                                                   *
//* Change @BANK_PREFIX@ to the prefix of your HBank  datasets        *
//*                                                                   *
//* Change @WSIM_PREFIX@ to the prefix of your SITPLOAD dataset       *
//*                                                                   *
//* On second and subsequent runs, comment out GENERATE SCRIPTS       *
//*                                                                   *
//* Remember to change STL member HBANKON before submitting           *
//*                                                                   *
//*********************************************************************
//         SET INDSN1=@BANK_PREFIX@
//         SET OUTDSN1=@BANK_PREFIX@
//*****************************************
//STL     PROC
//ITPSTL  EXEC PGM=ITPSTL,PARM='SUMMARY,XREF'
//STEPLIB  DD  DSN=@WSIM_PREFIX@.SITPLOAD,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SEQOUT   DD  DUMMY
//SYSIN    DD DISP=SHR,DSN=&INDSN1..STL(&MEM)
//SYSLIB   DD DISP=SHR,DSN=&INDSN1..STL
//MSGDD    DD DISP=SHR,DSN=&OUTDSN1..SCRIPTS
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(10,10,3))
//SYSUT2   DD  UNIT=SYSDA,SPACE=(CYL,(10,10,3))
//SYSUT3   DD  UNIT=SYSDA,SPACE=(CYL,(10,10,3))
// PEND
//SCRIPTS PROC
//SCRIPTS  EXEC PGM=IEFBR14
//SYSPRINT DD  SYSOUT=*
//SCRIPTS  DD DISP=(NEW,CATLG,KEEP),DSN=&OUTDSN1..SCRIPTS,
//         SPACE=(TRK,(10,10,10)),
//         DSNTYPE=LIBRARY,
//         DCB=(RECFM=FB,LRECL=80,BLKSIZE=32720,DSORG=PO)
//NETWORKS DD DISP=(NEW,CATLG,KEEP),DSN=&OUTDSN1..NETWORKS,
//         SPACE=(TRK,(10,10,10)),
//         DSNTYPE=LIBRARY,
//         DCB=(RECFM=FB,LRECL=80,BLKSIZE=32720,DSORG=PO)
//SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(10,10,3))
//SYSUT2   DD  UNIT=SYSDA,SPACE=(CYL,(10,10,3))
//SYSUT3   DD  UNIT=SYSDA,SPACE=(CYL,(10,10,3))
//IEBCOPY EXEC PGM=IEBCOPY,REGION=0M
//SYSPRINT DD SYSOUT=*
//INPUT1 DD DISP=SHR,DSN=&INDSN1..INSTALL
//OUTPUT DD DISP=OLD,DSN=&OUTDSN1..NETWORKS
//SYSUT3 DD UNIT=SYSDA,SPACE=(TRK,(1))
//SYSIN DD *
 COPY OUTDD=OUTPUT
      INDD=INPUT1
      SELECT MEMBER=(HBANKTRM)
      SELECT MEMBER=(HBANKWEB)
      SELECT MEMBER=(HBANKWLP)
/*
// PEND
//**************************
//* Generate SCRIPT dataset*
//**************************
//SCRIPTS EXEC SCRIPTS
//*************************
//* Generate STL         *
//*************************
//CREACCTX EXEC STL,MEM=CREACCTX
//CRECUSTX EXEC STL,MEM=CRECUSTX
//DELACCTX EXEC STL,MEM=DELACCTX
//DELCUSTX EXEC STL,MEM=DELCUSTX
//ENDIT    EXEC STL,MEM=ENDIT
//GETACCTA EXEC STL,MEM=GETACCTA
//GETCUSTA EXEC STL,MEM=GETCUSTA
//GETOUT   EXEC STL,MEM=GETOUT
//HBANKON  EXEC STL,MEM=HBANKON
//INQACCTX EXEC STL,MEM=INQACCTX
//INQCUSTX EXEC STL,MEM=INQCUSTX
//LLIBERTA EXEC STL,MEM=LLIBERTA
//LGETCUSA EXEC STL,MEM=LGETCUSA
//LGETACCA EXEC STL,MEM=LGETACCA
//LUPDACCA EXEC STL,MEM=LUPDACCA
//LXFRACCA EXEC STL,MEM=LXFRACCA
//LOGOFF   EXEC STL,MEM=LOGOFF
//UPDACCTX EXEC STL,MEM=UPDACCTX
//WUPDACCA EXEC STL,MEM=WUPDACCA
//WXFRACCA EXEC STL,MEM=WXFRACCA
//XFRACCTX EXEC STL,MEM=XFRACCTX
//*
