       CBL SQL
      ******************************************************************
      *                                                                *
      * Licensed Materials - Property of IBM                           *
      *                                                                *
      * (c) Copyright IBM Corp. 2015,2020.                             *
      *                                                                *
      * US Government Users Restricted Rights - Use, duplication       *
      * or disclosure restricted by GSA ADP Schedule Contract          *
      * with IBM Corp.                                                 *
      *                                                                *
      ******************************************************************

      ******************************************************************
      *                                                                *
      * Title: PROOFFL                                                 *
      *                                                                *
      *                                                                *
      * Description: Batch program to unload the PROCTRAN data from    *
      *              Db2 to a file, in readiness for the reload        *
      *              program.                                          *
      *                                                                *
      * Output: The populated VSAM file PROOFFL                        *
      *                                                                *
      *                                                                *
      ******************************************************************
       IDENTIFICATION DIVISION.
      *AUTHOR. JON COLLETT.
       PROGRAM-ID. PROOFFL.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
      * SOURCE-COMPUTER. MAINFRAME WITH DEBUGGING MODE.
       SOURCE-COMPUTER. MAINFRAME.
      *****************************************************************
      *** File Control                                              ***
      *****************************************************************
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PROC-FILE
                  ASSIGN TO AS-ESDS
                  ORGANIZATION IS SEQUENTIAL
                  ACCESS MODE  IS SEQUENTIAL
      *           RECORD KEY   IS ACCOUNT-KEY
                  FILE STATUS  IS PROC-VSAM-STATUS.

       DATA DIVISION.
      *****************************************************************
      *** File Section                                              ***
      *****************************************************************
       FILE SECTION.

       FD  PROC-FILE.
       01  PROCTRAN-RECORD-STRUCTURE.
           03 PROC-TRAN-DATA.
              05 PROC-TRAN-EYE-CATCHER        PIC X(4).
              05 PROC-TRAN-ID.
                 07 PROC-TRAN-SORT-CODE       PIC 9(6).
                 07 PROC-TRAN-NUMBER          PIC 9(8).
              05 PROC-TRAN-DATE               PIC 9(8).
              05 PROC-TRAN-DATE-GRP REDEFINES PROC-TRAN-DATE.
                 07 PROC-TRAN-DATE-GRP-DD     PIC 99.
                 07 PROC-TRAN-DATE-GRP-MM     PIC 99.
                 07 PROC-TRAN-DATE-GRP-YYYY   PIC 9999.
              05 PROC-TRAN-TIME               PIC 9(6).
              05 PROC-TRAN-TIME-GRP REDEFINES PROC-TRAN-TIME.
                 07 PROC-TRAN-TIME-GRP-HH     PIC 99.
                 07 PROC-TRAN-TIME-GRP-MM     PIC 99.
                 07 PROC-TRAN-TIME-GRP-SS     PIC 99.
              05 PROC-TRAN-REF                PIC 9(12).
              05 PROC-TRAN-TYPE               PIC X(3).
              05 PROC-TRAN-DESC               PIC X(40).
              05 PROC-TRAN-AMOUNT             PIC S9(10)V99.



      *****************************************************************
      *** Working storage                                           ***
      *****************************************************************
       WORKING-STORAGE SECTION.
      * Copyright statement as a literal to go into the load module
       77 FILLER PIC X(80) VALUE
           'Licensed Materials - Property of IBM'.
       77 FILLER PIC X(80) VALUE
           '(c) Copyright IBM Corp. 2015,2020. All Rights Reserved.'.
       77 FILLER PIC X(80) VALUE
           'US Government Users Restricted Rights - Use, duplication '.
       77 FILLER PIC X(80) VALUE
           'or disclosure restricted by GSA ADP Schedule Contract '.
       77 FILLER PIC X(80) VALUE
           'with IBM Corp.'.

      * Declare the PROCTRAN table

           EXEC SQL DECLARE PROCTRAN TABLE
              (
               PROCTRAN_EYECATCHER             CHAR(4),
               PROCTRAN_SORTCODE               CHAR(6) NOT NULL,
               PROCTRAN_NUMBER                 CHAR(8) NOT NULL,
               PROCTRAN_DATE                   DATE,
               PROCTRAN_TIME                   CHAR(6),
               PROCTRAN_REF                    CHAR(12),
               PROCTRAN_TYPE                   CHAR(3),
               PROCTRAN_DESC                   CHAR(40),
               PROCTRAN_AMOUNT                 DECIMAL(12, 2)
              )
           END-EXEC.

      * PROCTRAN host variables for DB2
       01 HOST-PROCTRAN-ROW.
          03 HV-PROCTRAN-EYECATCHER         PIC X(4).
          03 HV-PROCTRAN-SORT-CODE          PIC X(6).
          03 HV-PROCTRAN-ACC-NUMBER         PIC X(8).
          03 HV-PROCTRAN-DATE               PIC X(10).
          03 HV-PROCTRAN-TIME               PIC X(6).
          03 HV-PROCTRAN-REF                PIC X(12).
          03 HV-PROCTRAN-TYPE               PIC X(3).
          03 HV-PROCTRAN-DESC               PIC X(40).
          03 HV-PROCTRAN-AMOUNT             PIC S9(10)V99 COMP-3.


      * Declare the CURSOR for PROCTRAN the table
           EXEC SQL DECLARE PROC-CURSOR CURSOR FOR
              SELECT PROCTRAN_EYECATCHER,
                     PROCTRAN_SORTCODE,
                     PROCTRAN_NUMBER,
                     PROCTRAN_DATE,
                     PROCTRAN_TIME,
                     PROCTRAN_REF,
                     PROCTRAN_TYPE,
                     PROCTRAN_DESC,
                     PROCTRAN_AMOUNT
                     FROM PROCTRAN
      *              WHERE PROCTRAN_DATE >
      *               :HV-PROCTRAN-DATE
      *              AND PROCTRAN_TIME >
      *               :HV-PROCTRAN-TIME
                     ORDER BY PROCTRAN_DATE,
                              PROCTRAN_TIME
                     FOR FETCH ONLY
           END-EXEC.


      * Pull in the SQL COMMAREA
           EXEC SQL
              INCLUDE SQLCA
           END-EXEC.

       01 DISP-LOT.
          03 DISP-SIGN      PIC X.
          03 DISP-SQLCD     PIC 9999.

       01 DISP-REASON-CODE             PIC X(18).

       01  START-KEY                   PIC 9(10) DISPLAY.
       01  END-KEY                     PIC 9(10) DISPLAY.
       01  STEP-KEY                    PIC 9(10) DISPLAY.
       01  TESTNM                      PIC 9(4)  DISPLAY.

       01  PROC-VSAM-STATUS.
           05 VSAM-STATUS1             PIC X.
           05 VSAM-STATUS2             PIC X.

       01  NEXT-KEY                    PIC 9(10) DISPLAY.


       01 WS-CNT                       PIC 9    VALUE 0.
       01 SORTCODE                     PIC 9(6) VALUE 987654.

       01 DATASTR.
          03 BANK-DATASTORE-FLAGS.
             05 CUSTOMER-FLAG              PIC X VALUE 'V'.
             05 ACCOUNT-FLAG               PIC X VALUE '2'.
             05 PROCTRAN-FLAG              PIC X VALUE '2'.
             05 NAMED-COUNTER-FLAG         PIC X VALUE 'Y'.
             05 LIBERTY-DATA-ACCESS-FLAG   PIC X VALUE 'L'.
             05 CREDIT-AGENCY-CNT          PIC 9 VALUE 5.
          03 NAMED-COUNTER-POOL            PIC X(8) VALUE 'ST1     '.
          03 TXN-OVERRIDE                  PIC X VALUE 'O'.


       01 WS-SQLCODE-DISPLAY             PIC S9(8) DISPLAY
           SIGN LEADING SEPARATE.

       01 SQLCODE-DISPLAY                PIC S9(8) DISPLAY
           SIGN LEADING SEPARATE.

       01 NUMBER-OF-RECS                 PIC 9(8) VALUE 0.
      *****************************************************************
      *** Linkage Storage                                           ***
      *****************************************************************
       LINKAGE SECTION.


      *****************************************************************
      *** Main Processing                                           ***
      *****************************************************************
       PROCEDURE DIVISION.
       PREMIERE SECTION.
       A010.

      *
      *    Set the date to be 00000/01/01 and the time to zeros
      *
           STRING '0000' DELIMITED BY SIZE,
                  '/'  DELIMITED BY SIZE,
                  '01' DELIMITED BY SIZE,
                  '/'  DELIMITED BY SIZE,
                  '01' DELIMITED BY SIZE
                  INTO HV-PROCTRAN-DATE
           END-STRING

           MOVE '000000' TO HV-PROCTRAN-TIME.

      *
      *   Open the DB2 CURSOR
      *
           EXEC SQL OPEN
              PROC-CURSOR
           END-EXEC.

           MOVE SQLCODE TO SQLCODE-DISPLAY.

           IF SQLCODE NOT = 0
              MOVE SQLCODE TO SQLCODE-DISPLAY
              DISPLAY 'FAILED TO OPEN PROC-CURSOR IN PGM PROOFFL.'
              DISPLAY 'The SQLCODE returned is ' SQLCODE-DISPLAY
              DISPLAY SQLCA
              MOVE 12 TO RETURN-CODE
              PERFORM PROGRAM-DONE
           END-IF.

      *
      * Open the PROCTRAN offload file
      *
           OPEN OUTPUT PROC-FILE.
           IF PROC-VSAM-STATUS NOT EQUAL '00' THEN
               DISPLAY 'Error opening the PROCTRAN offload file, '
                       ' status='
                       PROC-VSAM-STATUS
               MOVE 12 TO RETURN-CODE
               PERFORM PROGRAM-DONE
           END-IF.

           MOVE 0 TO NUMBER-OF-RECS.

           PERFORM FETCH-DATA.

           EXEC SQL CLOSE
                PROC-CURSOR
           END-EXEC.


      *
      * Close the PROCTRAN offload file
      *
           CLOSE PROC-FILE.

           DISPLAY 'The number of records written to the PROCTRAN'
                   ' off load file is ' NUMBER-OF-RECS.

           PERFORM PROGRAM-DONE.

       A999.
           EXIT.


       FETCH-DATA SECTION.
       FD010.


           PERFORM UNTIL SQLCODE NOT = 0

              EXEC SQL FETCH FROM PROC-CURSOR
              INTO :HV-PROCTRAN-EYECATCHER,
                   :HV-PROCTRAN-SORT-CODE,
                   :HV-PROCTRAN-ACC-NUMBER,
                   :HV-PROCTRAN-DATE,
                   :HV-PROCTRAN-TIME,
                   :HV-PROCTRAN-REF,
                   :HV-PROCTRAN-TYPE,
                   :HV-PROCTRAN-DESC,
                   :HV-PROCTRAN-AMOUNT
              END-EXEC

      *
      *       If there is no data found at all, then return a
      *       low value record
      *
              IF SQLCODE = +100
                  GO TO FD999
              END-IF

              IF SQLCODE NOT = 0
                 MOVE SQLCODE TO SQLCODE-DISPLAY

                 DISPLAY 'Failure when attempting to FETCH from the'
                    ' DB2 CURSOR PROC-CURSOR. With SQL code='
                    SQLCODE-DISPLAY

                 GO TO FD999
              END-IF

      *
      *       If we find a row
      *

              ADD 1 TO NUMBER-OF-RECS

              MOVE HV-PROCTRAN-EYECATCHER
                 TO PROC-TRAN-EYE-CATCHER
              MOVE HV-PROCTRAN-SORT-CODE
                 TO PROC-TRAN-SORT-CODE
              MOVE HV-PROCTRAN-ACC-NUMBER
                 TO PROC-TRAN-NUMBER

              STRING HV-PROCTRAN-DATE(9:2) DELIMITED BY SIZE,
                     HV-PROCTRAN-DATE(6:2) DELIMITED BY SIZE,
                     HV-PROCTRAN-DATE(1:4) DELIMITED BY SIZE
                     INTO PROC-TRAN-DATE
              END-STRING

              MOVE HV-PROCTRAN-TIME
                 TO PROC-TRAN-TIME
              MOVE HV-PROCTRAN-REF
                 TO PROC-TRAN-REF
              MOVE HV-PROCTRAN-TYPE
                 TO PROC-TRAN-TYPE
              MOVE HV-PROCTRAN-DESC
                 TO PROC-TRAN-DESC
              MOVE HV-PROCTRAN-AMOUNT
                 TO PROC-TRAN-AMOUNT

              PERFORM WRITE-TO-FILE

           END-PERFORM.

       FD999.
           EXIT.


       WRITE-TO-FILE SECTION.
       WTF010.

           WRITE PROCTRAN-RECORD-STRUCTURE.

           IF PROC-VSAM-STATUS NOT EQUAL '00' THEN
                   DISPLAY 'Error writing to PROCTRAN offload file.'
                   ', status=' PROC-VSAM-STATUS
                   MOVE 12 TO RETURN-CODE
                   PERFORM PROGRAM-DONE
           END-IF.
       WTF999.
           EXIT.


      *
      * Finish
      *
       PROGRAM-DONE SECTION.
       PD010.

           GOBACK.
       PD999.
           EXIT.
