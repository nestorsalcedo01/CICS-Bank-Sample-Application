//* Licensed Materials - Property of IBM
//*
//* (c) Copyright IBM Corp. 2016,2019.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract
//* with IBM Corp.
//*
//*
//* Change @RACF_CLASS@ to the RACF class used to control transaction
//* security for your CICS region. This is controlled by the XTRAN
//* SIT parameter, and the default is GCICSTRN.
//*
//* Change @BANK_USER@ to the RACF userid or group that will be using
//* Hursley Bank
//RACF    EXEC PGM=IKJEFT01,DYNAMNBR=20,REGION=0M
//SYSTSPRT DD SYSOUT=*
//PROFILES DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSTSIN  DD *
RDEFINE @RACF_CLASS@ HURBANKS UACC(NONE) -
ADDMEM(BKB2, -
       LONG, -
       OCAC, -
       OCCA, -
       OCCS, -
       OCRA, -
       ODAC, -
       ODCS, -
       OMEN, -
       OTFN, -
       OUAC)
PERMIT HURBANKS CLASS(@RACF_CLASS@) ID(@BANK_USER@) ACCESS(READ)
RDEFINE @RACF_CLASS@ HURBANKU UACC(READ) -
ADDMEM(HBNK)

