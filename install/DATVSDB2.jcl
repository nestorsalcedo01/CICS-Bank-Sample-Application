//* Licensed Materials - Property of IBM
//*
//* (c) Copyright IBM Corp. 2016,2019.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract
//* with IBM Corp.
//*
//*
//* Change @BANK_PREFIX@ to the high level qualifiers of your VSAM *
//*
//* Change @DB2_HLQ@  to the high level qualifiers of your DB2  *
//*
//* Change @BANK_DBRMLIB@ to the name of the DBRM Lib              *
//*
//* Change @DB2_SUBSYSTEM@ to the name of the DB2 Subsystem        *
//*
//* Change @DB2_PLAN@ to the name of the DB2 Plan
//*
//* Change @BANK_LOADLIB@ to the name of the load library
//*
//******************************************************************
//*                                                                *
//*                                                                *
//*    Title: Bank - DataStore - Create CUSTOMER and ACCOUNT       *
//*                                                                *
//*  Description: Create and fill with random, but seeded, data    *
//*               the CUSTOMER and ACCOUNT data stores.            *
//*                                                                *
//*               Because the data in CUSTOMER and ACCOUNT is      *
//*               inter-related and at this stage we don't know    *
//*               what type of datastores are going to be used     *
//*               ALL supported data store types will be created   *
//*               and populated using the STBNKDT4 program.        *
//*                                                                *
//*               Program STBNKDT4, generates random data to       *
//*               populate the (VSAM and DB2) CUSTOMER and ACCOUNT *
//*               datastores                                       *
//*                                                                *
//*               These have to be done at the same time as        *
//*               generated Customer data is linked to the         *
//*               generated Account data (e.g. who owns an account *
//*               and account open data must be after create       *
//*               Customer.                                        *
//*                                                                *
//*               Although randomly generated STBNKDT4's 4th input *
//*               parameter is a seed so the same 'random' data    *
//*               can be reproduced and the start point known.     *
//*               This is important when marrying together mixed   *
//*               VSAM and DB2 CUSTOMER and ACCOUNT configurations *
//*                                                                *
//*               STBNKDAT's InOut parameters are:                 *
//*                 BANK_DATASTORE_DATA_START                      *
//*                      the beginning Customer number             *
//*                 BANK_DATASTORE_DATA_END                        *
//*                      the end Customer number                   *
//*                 BANK_DATASTORE_DATA_STEP                       *
//*                      is the STEP                               *
//*                 BANK_DATASTORE_DATA_SEED                       *
//*                      is the SEED value                         *
//*                 BANK_DATASTORE_DATA_SORTCODE                   *
//*                      is the SORTCODE linked to Test + Company  *
//*                                                                *
//*               Only the VSAM data stores will be created, the   *
//*               DB2 tables will be updated with Test+Company     *
//*               specific data.                                   *
//*                                                                *
//*                                                                *
//*  Parameters:  PARM01 - Recoverable = YES or NO                 *
//*               PARM02 - LogReplication = YES or NO              *
//*                                                                *
//*  Elements of JCL:
//*    BANKDAT0: Delete + Create ABNDFILE data store (VSAM)        *
//*    BANKDAT1: Delete + Create CUSTOMER data store (VSAM)        *
//*    BANKDAT2: Delete + Create ACCOUNT  data store (VSAM)        *
//*    BANKDAT5: Populate the DB2 Customer + Account data stores   *
//*    BANKDAT6: Create Alternate index for the DB2 ACCOUNT data   *
//*    BANKDAT7: Create Alternate index for the VSAM ACCOUNT data  *
//*    BANKDAT8: Create PATH for the VSAM ACCOUNT Alternate index  *
//*    BANKDAT9: Build Alternate index for the VSAM ACCOUNT data   *
//******************************************************************
//******************************************************************
//* BANKDAT1                                                       *
//*                                                                *
//*
//*
//*                                                                *
//******************************************************************
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
                       -
                      LOG(UNDO) -
                       -
                       -
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
  DELETE @BANK_PREFIX@.ACCOUNT.SNAPSHOT
  SET MAXCC=0
   DEFINE CLUSTER (NAME(@BANK_PREFIX@.ACCOUNT)-
                      CYL(50 50) -
                      KEYS(14 14) -
                      RECORDSIZE(98,98) -
                      FREESPACE (30 30) -
                      SHAREOPTIONS(2 3) -
                      INDEXED -
                       -
                      LOG(UNDO) -
                       -
                       -
                     ) -
             DATA (NAME(@BANK_PREFIX@.ACCOUNT.DATA) -
                  ) -
             INDEX (NAME(@BANK_PREFIX@.ACCOUNT.INDEX) -
                  )
   DEFINE CLUSTER (NAME(@BANK_PREFIX@.ACCOUNT.SNAPSHOT)-
                      CYL(50 50) -
                      KEYS(14 14) -
                      RECORDSIZE(98,98) -
                      FREESPACE (30 30) -
                      SHAREOPTIONS(2 3) -
                      INDEXED -
                       -
                      LOG(UNDO) -
                       -
                       -
                     ) -
             DATA (NAME(@BANK_PREFIX@.ACCOUNT.SNAPSHOT.DATA) -
                  ) -
             INDEX (NAME(@BANK_PREFIX@.ACCOUNT.SNAPSHOT.INDEX) -
                  )
/*
//******************************************************************
//*
//******************************************************************
//* BANKDAT5                                                       *
//*                                                                *
//* Executes Cobol program STBNKDT4, which generates random data   *
//*                                                                *
//* The parameters are:                                            *
//* 1) Starting Customer Number                                    *
//* 2) Final Customer Number                                       *
//* 3) Customer Number Increment (1 for every number)              *
//* 4) Random number seed                                          *
//* 5) ZZA1 is to help generate the sort code                      *
//* 6) Optionally. supply a named counter pool                     *
//******************************************************************
//******************************************************************
//BANKDAT5 EXEC PGM=IKJEFT01,REGION=0M
//STEPLIB  DD DISP=SHR,DSN=@BANK_DBRMLIB@
//         DD DISP=SHR,DSN=@BANK_LOADLIB@
//         DD DISP=SHR,DSN=@DB2_HLQ@.SDSNLOAD
//VSAM     DD DISP=SHR,DSN=@BANK_PREFIX@.CUSTOMER
//ACC      DD DISP=SHR,DSN=@BANK_PREFIX@.ACCOUNT
//SNAPSHOT DD DISP=SHR,DSN=@BANK_PREFIX@.ACCOUNT.SNAPSHOT
//*INPUT FILES
//*OUTPUT FILES
//SYSPRINT DD SYSOUT=*
//SYSABOUT DD SYSOUT=*
//SYSDBOUT DD SYSOUT=*
//DISPLAY  DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
 DSN SYSTEM(@DB2_SUBSYSTEM@)
 RUN PROGRAM(STBNKDT4)  -
 PLAN(@DB2_PLAN@) -
 PARM('1,10000,1,1000000000000000,ZZA1') -
 LIB('@BANK_LOADLIB@')
 END
/*
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
                      NONINDEXED -
                      REUSE -
                      LOG(UNDO) -
                     )
  DELETE @BANK_PREFIX@.REJTRAN
  SET MAXCC=0
   DEFINE CLUSTER (NAME(@BANK_PREFIX@.REJTRAN)-
                      CYL(50 50) -
                      RECORDSIZE(104,104) -
                      FREESPACE(30 30) -
                      SHAREOPTIONS(2 3) -
                      NONINDEXED -
                      REUSE -
                      LOG(NONE) -
                     )
/*
//*
