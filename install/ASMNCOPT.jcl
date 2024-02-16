//ASMNCOPT JOB ,,CLASS=A,MSGCLASS=H,
//  NOTIFY=&SYSUID,
//  MSGLEVEL=(1,1)
//* TYPRUN=SCAN,
//*
//*
//* Licensed Materials - Property of IBM
//*
//* (c) Copyright IBM Corp. 2017.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract
//* with IBM Corp.
//*
//*
//*------------------------------------------------------------------
//* Sample job to assemble a Named Counter Options Table
//*
//*------------------------------------------------------------------
//*
//*
//* Please change @BANK_LOADLIB@ to the Bank Loadlib
//*
//* Please change @CICS_PREFIX@ to the prefix for CICS
//*
//* Please change @BANK_INSTALL@ to THIS PDS name
//*
//*
//ASM      EXEC PGM=ASMA90,PARM=('RENT,DECK,NOOBJECT,LIST')
//SYSLIB   DD DISP=SHR,DSN=SYS1.MACLIB
//         DD DISP=SHR,DSN=SYS1.MODGEN
//         DD DISP=SHR,DSN=@CICS_PREFIX@.SDFHSAMP
//         DD DISP=SHR,DSN=@CICS_PREFIX@.SDFHMAC
//SYSUT1   DD UNIT=SYSDA,SPACE=(CYL,(10,10))
//SYSUT2   DD UNIT=SYSDA,SPACE=(CYL,(10,10))
//SYSUT3   DD UNIT=SYSDA,SPACE=(CYL,(10,10))
//SYSPUNCH DD DISP=(,PASS),DSN=&&SYSMOD,
//            UNIT=SYSDA,DCB=BLKSIZE=3120,SPACE=(CYL,(1,1))
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DISP=SHR,DSN=@BANK_INSTALL@(DFHNCOPT)
//LKED     EXEC PGM=IEWL,COND=(7,LT,ASM),PARM='RENT,LIST,XREF'
//SYSLMOD  DD DISP=SHR,DSN=@BANK_LOADLIB@
//SYSUT1   DD UNIT=SYSDA,DCB=BLKSIZE=1024,SPACE=(CYL,(1,1))
//SYSPRINT DD SYSOUT=*
//SYSLIN DD DISP=(OLD,DELETE),DSN=&&SYSMOD
//       DD DDNAME=SYSIN
//SYSIN DD *
  NAME DFHNCOPT(R)
/*
