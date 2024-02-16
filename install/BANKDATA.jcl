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
/*
//******************************************************************
//*
//******************************************************************
//* BANKDAT5                                                       *
//*                                                                *
//* Executes Cobol program BANKDATA, which generates random data   *
//*                                                                *
//* The parameters are:                                            *
//* 1) Starting Customer Number                                    *
//* 2) Final Customer Number                                       *
//* 3) Customer Number Increment (1 for every number)              *
//* 4) Random number seed                                          *
//* 6) Optionally. supply a named counter pool                     *
//******************************************************************
//******************************************************************
//BANKDAT5 EXEC PGM=IKJEFT01,REGION=0M
//STEPLIB  DD DISP=SHR,DSN=@BANK_DBRMLIB@
//         DD DISP=SHR,DSN=@BANK_LOADLIB@
//         DD DISP=SHR,DSN=@DB2_HLQ@.SDSNLOAD
//VSAM     DD DISP=SHR,DSN=@BANK_PREFIX@.CUSTOMER
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
 RUN PROGRAM(BANKDATA)  -
 PLAN(@DB2_PLAN@) -
 PARM('1,10000,1,1000000000000000') -
 LIB('@BANK_LOADLIB@')
 END
/*
