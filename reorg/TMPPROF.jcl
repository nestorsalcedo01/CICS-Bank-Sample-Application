//TMPPROF JOB 'DB2',NOTIFY=&SYSUID,CLASS=A,MSGCLASS=H,
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
//*  Define Off load data set for PROCTRAN data, then run the      *
//*  offload program to extract the information.                   *
//*
//*
//*                                                                *
//******************************************************************
//STEP1 EXEC PGM=IDCAMS
//SYSOUT DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
    DELETE CBSA.CICSBSA.TMPPFF
    SET MAXCC=0
    DEFINE CLUSTER (NAME(CBSA.CICSBSA.TMPPFF)-
           CYL(5 5) -
           RECORDSIZE(99,99) -
           FREESPACE(30 30) -
           SHAREOPTIONS(2 3) -
           LOG(UNDO) -
           NONINDEXED -
           )
/*
//*
//OFFLOAD2 EXEC PGM=IKJEFT01,REGION=0M
//STEPLIB  DD DISP=SHR,DSN=CBSA.CICSBSA.DBRM
//         DD DISP=SHR,DSN=CBSA.CICSBSA.LOADLIB
//         DD DISP=SHR,DSN=DSNC10.SDSNLOAD
//ESDS     DD DISP=SHR,DSN=CBSA.CICSBSA.TMPPFF
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
 RUN PROGRAM(PROOFFL)  -
 PLAN(CBSA) -
 LIB('CBSA.CICSBSA.LOADLIB')
 END
/*
