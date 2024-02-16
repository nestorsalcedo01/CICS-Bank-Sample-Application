//TMPACCF JOB 'DB2',NOTIFY=&SYSUID,CLASS=A,MSGCLASS=H,
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
//*  Define Off load data set for ACCOUNT data, then run the       *
//*  offload program to extract the information.                   *
//*
//*
//*                                                                *
//******************************************************************
//STEP1 EXEC PGM=IDCAMS
//SYSOUT DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
    DELETE CBSA.CICSBSA.TMPAFF
    SET MAXCC=0
    DEFINE CLUSTER (NAME(CBSA.CICSBSA.TMPAFF)-
           CYL(50 50) -
           KEYS(14 14) -
           RECORDSIZE(98,98) -
           FREESPACE(30 30) -
           SHAREOPTIONS(2 3) -
           INDEXED -
           LOG(UNDO) -
           ) -
           DATA (NAME(CBSA.CICSBSA.TMPAFF.DATA) -
           ) -
           INDEX (NAME(CBSA.CICSBSA.TMPAFF.INDEX) -
           )
/*
//*
//OFFLOAD1 EXEC PGM=IKJEFT01,REGION=0M
//STEPLIB  DD DISP=SHR,DSN=CBSA.CICSBSA.DBRM
//         DD DISP=SHR,DSN=CBSA.CICSBSA.LOADLIB
//         DD DISP=SHR,DSN=DSNC10.SDSNLOAD
//VSAM     DD DISP=SHR,DSN=CBSA.CICSBSA.TMPAFF
//*INPUT FILES
//*OUTPUT FILES
//SYSPRINT DD SYSOUT=*
//SYSABOUT DD SYSOUT=*
//SYSDBOUT DD SYSOUT=*
//DISPLAY  DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
 DSN SYSTEM(DBCG)
 RUN PROGRAM(ACCOFFL)  -
 PLAN(CBSA) -
 LIB('CBSA.CICSBSA.LOADLIB')
 END
/*
