//DATAVSAM JOB ,,CLASS=A,MSGCLASS=H,NOTIFY=&SYSUID.
//*
//* Licensed Materials - Property of IBM
//*
//* (c) Copyright IBM Corp. 2016,2019.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract
//* with IBM Corp.
//*
//*
//* Amend/correct the job card as appropriate to your site
//*
//* Change @BANK_PREFIX@ to the high level qualifiers of your VSAM
//*
//* Change @BANK_LOADLIB@ to the name of the load library
//*
//BANKDAT0 EXEC PGM=IDCAMS
//SYSOUT DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
  DELETE @BANK_PREFIX@.ABNDFILE
  SET MAXCC=0
  DEFINE CLUSTER (NAME(@BANK_PREFIX@.ABNDFILE)-
                     CYL(6 6) -
                     KEYS(12 0) -
                     RECORDSIZE(681 681) -
                     SHAREOPTIONS(2 3) -
                     INDEXED -
                     LOG(NONE) -
                     REUSE -
                     FREESPACE(3 3))-
            DATA (NAME(@BANK_PREFIX@.ABNDFLE.DATA) -
                 ) -
            INDEX (NAME(@BANK_PREFIX@.ABNDFILE.INDEX) -
                 )
/*
//*
//BANKDAT1 EXEC PGM=IDCAMS
//SYSOUT DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
  DELETE @BANK_PREFIX@.CUSTOMER
  SET MAXCC=0
   DEFINE CLUSTER (NAME(@BANK_PREFIX@.CUSTOMER)-
                      CYL(50 50) -
                      KEYS(16 4) -
                      RECORDSIZE(259,259) -
                      SHAREOPTIONS(2 3) -
                      INDEXED -
                      LOG(UNDO) -
                      BWO(NO) -
                     ) -
             DATA (NAME(@BANK_PREFIX@.CUSTOMER.DATA) -
                  ) -
             INDEX (NAME(@BANK_PREFIX@.CUSTOMER.INDEX) -
                  )
/*
//*
//******************************************************************
//* BANKDAT2                                                       *
//*                                                                *
//* Delete and Create a clean version of the VSAM ACCOUNT  dataset *
//*                                                                *
//******************************************************************
//BANKDAT2 EXEC PGM=IDCAMS
//SYSOUT DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
  DELETE @BANK_PREFIX@.ACCOUNT
  SET MAXCC=0
   DEFINE CLUSTER (NAME(@BANK_PREFIX@.ACCOUNT)-
                      CYL(50 50) -
                      KEYS(14 14) -
                      RECORDSIZE(98,98) -
                      FREESPACE (30 30) -
                      SHAREOPTIONS(2 3) -
                      INDEXED -
                      LOG(UNDO) -
                      BWO(NO) -
                     ) -
             DATA (NAME(@BANK_PREFIX@.ACCOUNT.DATA) -
                  ) -
             INDEX (NAME(@BANK_PREFIX@.ACCOUNT.INDEX) -
                  )
/*
//*
//******************************************************************
//* BANKDAT5                                                       *
//*                                                                *
//* Executes Cobol program STBNKDTV, which generates random data   *
//*                                                                *
//* The parameters are:                                            *
//* 1) Starting Customer Number                                    *
//* 2) Final Customer Number                                       *
//* 3) Customer Number Increment (1 for every number)              *
//* 4) Random number seed                                          *
//* 5) ZZA1 is to help generate the sort code                      *
//* 6) Optionally. supply a named counter pool                     *
//******************************************************************
//BANKDAT5 EXEC PGM=STBNKDTV,REGION=0M,
// PARM='1,10000,1,1000000000000000,ZZA1'
//STEPLIB  DD DISP=SHR,DSN=@BANK_LOADLIB@
//VSAM     DD DISP=SHR,DSN=@BANK_PREFIX@.CUSTOMER
//ACC      DD DISP=SHR,DSN=@BANK_PREFIX@.ACCOUNT
//*INPUT FILES
//*OUTPUT FILES
//SYSPRINT DD SYSOUT=*
//SYSABOUT DD SYSOUT=*
//SYSDBOUT DD SYSOUT=*
//DISPLAY  DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//******************************************************************
//* BANKDAT6                                                       *
//*                                                                *
//* Create the Alternate index for the VSAM ACCOUNT data           *
//*                                                                *
//* - Based on the 10 byte CUSTOMER number                         *
//* - RECORDSIZE calculated by  5+ 10 bytes + (10 * 14), which     *
//*   allows up to 10 accounts to be held by a customer            *
//*                                                                *
//******************************************************************
//BANKDAT6 EXEC  PGM=IDCAMS,REGION=0M
//SYSPRINT DD    SYSOUT=*
//SYSIN    DD    *
     DEFINE ALTERNATEINDEX -
           (NAME(@BANK_PREFIX@.ACCOUNT.AIX) -
           RELATE(@BANK_PREFIX@.ACCOUNT) -
           KEYS(16 4) -
           RECORDSIZE(161 161) -
           CYLINDERS(3 1) -
           SHAREOPTIONS(2 3) -
           NONUNIQUEKEY -
           UPGRADE -
           )
/*
//******************************************************************
//* BANKDAT7                                                       *
//*                                                                *
//* Create the PATH for the VSAM ACCOUNT Alternate index           *
//*                                                                *
//******************************************************************
//BANKDAT7 EXEC  PGM=IDCAMS,REGION=0M
//*
//* Builds the PATH
//*
//SYSPRINT DD    SYSOUT=*
//SYSIN    DD    *
     DEFINE PATH -
           (NAME(@BANK_PREFIX@.ACCOUNT.PATH)-
           PATHENTRY(@BANK_PREFIX@.ACCOUNT.AIX)-
           )
/*
//******************************************************************
//* BANKDAT8                                                       *
//*                                                                *
//* Build alternate index for the VSAM ACCOUNT data                *
//*                                                                *
//******************************************************************
//BANKDAT8 EXEC PGM=IDCAMS,REGION=0M
//SYSOUT DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//BASEDD   DD DISP=OLD,DSNAME=@BANK_PREFIX@.ACCOUNT
//AIXDD    DD DISP=OLD,DSNAME=@BANK_PREFIX@.ACCOUNT.AIX
//WORK01   DD UNIT=SYSDA,SPACE=(CYL,(1,1))
//WORK02   DD UNIT=SYSDA,SPACE=(CYL,(1,1))
//SYSIN DD *
  BLDINDEX INFILE(BASEDD)-
           OUTFILE(AIXDD)-
           SORTCALL -
           EXTERNALSORT -
           WORKFILES(WORK01 WORK02)
/*
//PROCREJ  EXEC PGM=IDCAMS
//SYSOUT DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
  DELETE @BANK_PREFIX@.PROCTRAN
  SET MAXCC=0
   DEFINE CLUSTER (NAME(@BANK_PREFIX@.PROCTRAN)-
                      CYL(50 50) -
                      RECORDSIZE(99,99) -
                      FREESPACE(30 30) -
                      SHAREOPTIONS(2 3) -
                      REUSE -
                      LOG(UNDO) -
                      NONINDEXED -
                      BWO(NO) -
                     )
  DELETE @BANK_PREFIX@.REJTRAN
  SET MAXCC=0
   DEFINE CLUSTER (NAME(@BANK_PREFIX@.REJTRAN)-
                      CYL(50 50) -
                      RECORDSIZE(104,104) -
                      FREESPACE(30 30) -
                      SHAREOPTIONS(2 3) -
                      LOG(NONE) -
                      REUSE -
                      NONINDEXED -
                      BWO(NO) -
                     )
/*
//*
