//* Licensed Materials - Property of IBM
//*
//* (c) Copyright IBM Corp. 2020.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract
//* with IBM Corp.
//EXTCUST JOB ,,CLASS=A,MSGCLASS=H,
//  NOTIFY=&SYSUID,
//  MSGLEVEL=(1,1)
//BANKDAT1 EXEC PGM=IDCAMS
//SYSOUT DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
  DELETE CTSSVT.CICSBSA.EXTD.CUSTOMER
  SET MAXCC=0
   DEFINE CLUSTER (NAME(CBSA.CICSBSA.EXTD.CUSTOMER)-
                      CYL(50 50) -
                      KEYS(16 4) -
                      RECORDSIZE(329,329) -
                      SHAREOPTIONS(2 3) -
                      INDEXED -
                      VOLUMES(B3SYS1) -
                      LOG(UNDO) -
                      BWO(NO) -
                     ) -
             DATA (NAME(CBSA.CICSBSA.EXTD.CUSTOMER.DATA) -
                   ) -
             INDEX (NAME(CBSA.CICSBSA.EXTD.CUSTOMER.INDEX) -
                   )
/*