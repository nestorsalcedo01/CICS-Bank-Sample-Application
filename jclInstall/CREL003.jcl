//*CREL003 JOB ,,CLASS=A,MSGCLASS=H,                                    00000107
//*  NOTIFY=&SYSUID,                                                    00000207
//*  MSGLEVEL=(1,1)                                                     00000307
//**********************************************************            00001000
//**           CREATE THE PDSE                            **            00002000
//**********************************************************            00003000
//STEP10  EXEC PGM=IEFBR14                                              00004000
//DD01      DD DSN=CBSA.CICSBSA.LOADLIB,                                00005005
//            DISP=(NEW,CATLG,DELETE),                                  00006005
//            UNIT=SYSDA,SPACE=(CYL,(5,1)),                             00007005
//            DCB=(LRECL=0,BLKSIZE=32760,DSORG=PO,RECFM=U),             00008005
//            DSNTYPE=LIBRARY                                           00009005