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
      * Title: PROLOAD                                                 *
      *                                                                *
      *                                                                *
      * Description: Batch program to reload the PROCTRAN data from    *
      *              the unload file into Db2, where the PROCTRAN      *
      *              Db2 table has been amended to have a 9 byte       *
      *              account number.                                   *
      *                                                                *
      * Input: The populated VSAM OFFLOAD file.                        *
      *                                                                *
      *                                                                *
      ******************************************************************
       IDENTIFICATION DIVISION.
      *AUTHOR. JON COLLETT.
       PROGRAM-ID. PROLOAD.

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
               PROCTRAN_NUMBER                 CHAR(9) NOT NULL,
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
          03 HV-PROCTRAN-ACC-NUMBER         PIC X(9).
          03 HV-PROCTRAN-DATE               PIC X(10).
          03 HV-PROCTRAN-TIME               PIC X(6).
          03 HV-PROCTRAN-REF                PIC X(12).
          03 HV-PROCTRAN-TYPE               PIC X(3).
          03 HV-PROCTRAN-DESC               PIC X(40).
          03 HV-PROCTRAN-AMOUNT             PIC S9(10)V99 COMP-3.


      * Pull in the SQL COMMAREA
       EXEC SQL
          INCLUDE SQLCA
       END-EXEC.

       01 DISP-LOT.
          03 DISP-SIGN      PIC X.
          03 DISP-SQLCD     PIC 9999.

       01 DISP-REASON-CODE             PIC X(18).

       01  PROC-VSAM-STATUS.
           05 VSAM-STATUS1             PIC X.
           05 VSAM-STATUS2             PIC X.


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

       01 WS-EOF                         PIC X VALUE 'N'.
       01 WS-EXIT                        PIC X VALUE 'N'.

       01 WS-RECORDS-READ                PIC 9(8) VALUE 0.
       01 WS-RECS-WRITTEN                PIC 9(8) VALUE 0.

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
      *   Open the PROCTRAN off load VSAM file.
      *

           OPEN INPUT PROC-FILE.
           IF PROC-VSAM-STATUS NOT EQUAL '00' THEN
               DISPLAY 'Error opening PROCTRAN OFFLOAD file, status='
                       PROC-VSAM-STATUS
               MOVE 12 TO RETURN-CODE
               PERFORM PROGRAM-DONE
           END-IF.

      *
      *    Read the first record from the ACCOUNT OFFLOAD file
      *

           INITIALIZE PROCTRAN-RECORD-STRUCTURE.

      *    START PROC-FILE KEY GREATER THAN PROC-TRAN-ID.
      *
      *    IF PROC-VSAM-STATUS NOT EQUAL '00'
      *       DISPLAY 'START not OK. VSAM STATUS is='
      *               PROC-VSAM-STATUS
      *       MOVE 12 TO RETURN-CODE
      *       PERFORM PROGRAM-DONE
      *    END-IF.


           READ PROC-FILE
           IF PROC-VSAM-STATUS NOT EQUAL '00'

              IF PROC-VSAM-STATUS = '10'
                 DISPLAY 'FIRST REC IS END OF FILE'
                 MOVE 'Y' TO WS-EOF
              ELSE
                 DISPLAY 'Error on the initial read from '
                         'PROCTRAN OFFLOAD file, status='
                         PROC-VSAM-STATUS
                 MOVE 12 TO RETURN-CODE
                 PERFORM PROGRAM-DONE
              END-IF

           END-IF.


           PERFORM UNTIL WS-EOF = 'Y' OR WS-EXIT = 'Y'

              ADD 1 TO WS-RECORDS-READ

              MOVE PROC-TRAN-EYE-CATCHER       TO
                   HV-PROCTRAN-EYECATCHER
              MOVE PROC-TRAN-SORT-CODE         TO
                   HV-PROCTRAN-SORT-CODE
              STRING '0' DELIMITED BY SIZE,
                     PROC-TRAN-NUMBER DELIMITED BY SIZE
                     INTO HV-PROCTRAN-ACC-NUMBER
              END-STRING

              STRING PROC-TRAN-DATE(1:2) DELIMITED BY SIZE,
                     '.' DELIMITED BY SIZE,
                     PROC-TRAN-DATE(3:2) DELIMITED BY SIZE,
                     '.' DELIMITED BY SIZE
                     PROC-TRAN-DATE(5:4) DELIMITED BY SIZE
                     INTO HV-PROCTRAN-DATE
              END-STRING

              MOVE PROC-TRAN-TIME            TO
                 HV-PROCTRAN-TIME
              MOVE PROC-TRAN-REF             TO
                 HV-PROCTRAN-REF
              MOVE PROC-TRAN-TYPE            TO
                 HV-PROCTRAN-TYPE
              MOVE PROC-TRAN-AMOUNT          TO
                 HV-PROCTRAN-AMOUNT

              IF PROC-TRAN-TYPE = 'TFR'
                 STRING PROC-TRAN-DESC(1:25) DELIMITED BY SIZE,
                        PROC-TRAN-DESC(27:6) DELIMITED BY SIZE,
                        '0' DELIMITED BY SIZE,
                        PROC-TRAN-DESC(33:8) DELIMITED BY SIZE
                        INTO HV-PROCTRAN-DESC
                 END-STRING
              ELSE
                 MOVE PROC-TRAN-DESC         TO
                    HV-PROCTRAN-DESC
              END-IF


      *
      *       Insert the row onto the table
      *

              EXEC SQL
                 INSERT INTO PROCTRAN
                        (PROCTRAN_EYECATCHER,
                         PROCTRAN_SORTCODE,
                         PROCTRAN_NUMBER,
                         PROCTRAN_DATE,
                         PROCTRAN_TIME,
                         PROCTRAN_REF,
                         PROCTRAN_TYPE,
                         PROCTRAN_DESC,
                         PROCTRAN_AMOUNT
                        )
                 VALUES (:HV-PROCTRAN-EYECATCHER,
                         :HV-PROCTRAN-SORT-CODE,
                         :HV-PROCTRAN-ACC-NUMBER,
                         :HV-PROCTRAN-DATE,
                         :HV-PROCTRAN-TIME,
                         :HV-PROCTRAN-REF,
                         :HV-PROCTRAN-TYPE,
                         :HV-PROCTRAN-DESC,
                         :HV-PROCTRAN-AMOUNT
                        )
              END-EXEC

      *
      *       Check if the INSERT was unsuccessful and take action.
      *

              IF SQLCODE NOT = 0
                 MOVE SQLCODE TO SQLCODE-DISPLAY
                 DISPLAY 'Unable to insert into PROCTRAN in '
                   'SQLCODE=' SQLCODE-DISPLAY

                 DISPLAY 'Writing row ' HOST-PROCTRAN-ROW

                 PERFORM PROGRAM-DONE

              END-IF

              ADD 1 TO WS-RECS-WRITTEN

      *
      *       Read the NEXT record from the PROCTRAN OFFLOAD file
      *

              INITIALIZE PROCTRAN-RECORD-STRUCTURE

              READ PROC-FILE
              IF PROC-VSAM-STATUS NOT EQUAL '00'

                 IF PROC-VSAM-STATUS = '10'
                    DISPLAY 'REC IS END OF FILE'
                    MOVE 'Y' TO WS-EOF
                 ELSE
                    DISPLAY 'Error reading subsequent rec from '
                            ' PROCTRAN OFFLOAD file, '
                            ' status='
                            PROC-VSAM-STATUS
                    DISPLAY 'Last rec written was ' HOST-PROCTRAN-ROW

                    MOVE 12 TO RETURN-CODE
                    PERFORM PROGRAM-DONE
                 END-IF

              END-IF

           END-PERFORM.

      *
      *    Close the file
      *
           CLOSE PROC-FILE.

           DISPLAY 'PROLOAD Finished successfully. There were '
                   WS-RECORDS-READ ' records READ from the offload'
                   ' file & '
                   WS-RECS-WRITTEN ' records written to the PROCTRAN'
                   ' table'.

           PERFORM PROGRAM-DONE.

       A999.
           EXIT.


      *
      * Finish
      *
       PROGRAM-DONE SECTION.
       PD010.

           GOBACK.
       PD999.
           EXIT.
