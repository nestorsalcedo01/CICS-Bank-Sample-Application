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
      * Title: ACCOFFL                                                 *
      *                                                                *
      *                                                                *
      * Description: Batch program to unload the account data from Db2 *
      *              to a file, in readiness for the reaload program.  *
      *                                                                *
      * Output: The populated VSAM file ACCOFFL                        *
      *                                                                *
      *                                                                *
      ******************************************************************
       IDENTIFICATION DIVISION.
      *AUTHOR. JON COLLETT.
       PROGRAM-ID. ACCOFFL.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
      * SOURCE-COMPUTER. MAINFRAME WITH DEBUGGING MODE.
       SOURCE-COMPUTER. MAINFRAME.
      *****************************************************************
      *** File Control                                              ***
      *****************************************************************
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACC-FILE
                  ASSIGN TO VSAM
                  ORGANIZATION IS INDEXED
                  ACCESS MODE  IS RANDOM
                  RECORD KEY   IS ACCOUNT-KEY
                  FILE STATUS  IS ACC-VSAM-STATUS.

       DATA DIVISION.
      *****************************************************************
      *** File Section                                              ***
      *****************************************************************
       FILE SECTION.

       FD  ACC-FILE.
       01  ACCOUNT-RECORD-STRUCTURE.
              03 ACCOUNT-DATA.
                 05 ACCOUNT-EYE-CATCHER        PIC X(4).
                 05 ACCOUNT-CUST-NO            PIC 9(10).
                 05 ACCOUNT-KEY.
                    07 ACCOUNT-SORT-CODE       PIC 9(6).
                    07 ACCOUNT-NUMBER          PIC 9(8).
                 05 ACCOUNT-TYPE               PIC X(8).
                 05 ACCOUNT-INTEREST-RATE      PIC 9(4)V99.
                 05 ACCOUNT-OPENED             PIC 9(8).
                 05 ACCOUNT-OPENED-GROUP REDEFINES ACCOUNT-OPENED.
                    07 ACCOUNT-OPENED-DAY       PIC 99.
                    07 ACCOUNT-OPENED-MONTH     PIC 99.
                    07 ACCOUNT-OPENED-YEAR      PIC 9999.
                 05 ACCOUNT-OVERDRAFT-LIMIT    PIC 9(8).
                 05 ACCOUNT-LAST-STMT-DATE     PIC 9(8).
                 05 ACCOUNT-LAST-STMT-GROUP
                    REDEFINES ACCOUNT-LAST-STMT-DATE.
                    07 ACCOUNT-LAST-STMT-DAY   PIC 99.
                    07 ACCOUNT-LAST-STMT-MONTH PIC 99.
                    07 ACCOUNT-LAST-STMT-YEAR  PIC 9999.
                 05 ACCOUNT-NEXT-STMT-DATE     PIC 9(8).
                 05 ACCOUNT-NEXT-STMT-GROUP
                   REDEFINES ACCOUNT-NEXT-STMT-DATE.
                    07 ACCOUNT-NEXT-STMT-DAY   PIC 99.
                    07 ACCOUNT-NEXT-STMT-MONTH PIC 99.
                    07 ACCOUNT-NEXT-STMT-YEAR  PIC 9999.
                 05 ACCOUNT-AVAILABLE-BALANCE  PIC S9(10)V99.
                 05 ACCOUNT-ACTUAL-BALANCE     PIC S9(10)V99.


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

      * Declare the ACCOUNT table

           EXEC SQL DECLARE ACCOUNT TABLE
              ( ACCOUNT_EYECATCHER             CHAR(4),
                ACCOUNT_CUSTOMER_NUMBER        CHAR(10),
                ACCOUNT_SORTCODE               CHAR(6) NOT NULL,
                ACCOUNT_NUMBER                 CHAR(8) NOT NULL,
                ACCOUNT_TYPE                   CHAR(8),
                ACCOUNT_INTEREST_RATE          DECIMAL(4, 2),
                ACCOUNT_OPENED                 DATE,
                ACCOUNT_OVERDRAFT_LIMIT        INTEGER,
                ACCOUNT_LAST_STATEMENT         DATE,
                ACCOUNT_NEXT_STATEMENT         DATE,
                ACCOUNT_AVAILABLE_BALANCE      DECIMAL(10, 2),
                ACCOUNT_ACTUAL_BALANCE         DECIMAL(10, 2) )
           END-EXEC.

      * ACCOUNT Host variables for DB2
       01 HOST-ACCOUNT-ROW.
           03 HV-ACCOUNT-DATA.
              05 HV-ACCOUNT-EYECATCHER         PIC X(4).
              05 HV-ACCOUNT-CUST-NO            PIC X(10).
              05 HV-ACCOUNT-KEY.
                 07 HV-ACCOUNT-SORT-CODE       PIC X(6).
                 07 HV-ACCOUNT-NUMBER          PIC X(8).
              05 HV-ACCOUNT-TYPE               PIC X(8).
              05 HV-ACCOUNT-INTEREST-RATE      PIC S9(4)V99 COMP-3.
              05 HV-ACCOUNT-OPENED             PIC X(10).
              05 HV-ACCOUNT-OPENED-GROUP REDEFINES HV-ACCOUNT-OPENED.
                 07 HV-ACCOUNT-OPENED-YEAR     PIC X(4).
                 07 HV-ACCOUNT-OPENED-DELIM1   PIC X.
                 07 HV-ACCOUNT-OPENED-MONTH    PIC XX.
                 07 HV-ACCOUNT-OPENED-DELIM2   PIC X.
                 07 HV-ACCOUNT-OPENED-DAY      PIC XX.

              05 HV-ACCOUNT-OVERDRAFT-LIMIT    PIC S9(9) COMP.
              05 HV-ACCOUNT-LAST-STMT-DATE     PIC X(10).
              05 HV-ACCOUNT-LAST-STMT-GROUP
                 REDEFINES HV-ACCOUNT-LAST-STMT-DATE.
                  07 HV-ACCOUNT-LAST-STMT-YEAR   PIC X(4).
                  07 HV-ACCOUNT-LAST-STMT-DELIM1 PIC X.
                  07 HV-ACCOUNT-LAST-STMT-MONTH  PIC XX.
                  07 HV-ACCOUNT-LAST-STMT-DELIM2 PIC X.
                  07 HV-ACCOUNT-LAST-STMT-DAY    PIC XX.
              05 HV-ACCOUNT-NEXT-STMT-DATE     PIC X(10).
              05 HV-ACCOUNT-NEXT-STMT-GROUP
                 REDEFINES HV-ACCOUNT-NEXT-STMT-DATE.
                 07 HV-ACCOUNT-NEXT-STMT-YEAR   PIC X(4).
                 07 HV-ACCOUNT-NEXT-STMT-DELIM1 PIC X.
                 07 HV-ACCOUNT-NEXT-STMT-MONTH  PIC XX.
                 07 HV-ACCOUNT-NEXT-STMT-DELIM2 PIC X.
                 07 HV-ACCOUNT-NEXT-STMT-DAY    PIC XX.
              05 HV-ACCOUNT-AVAILABLE-BALANCE  PIC S9(10)V99 COMP-3.
              05 HV-ACCOUNT-ACTUAL-BALANCE     PIC S9(10)V99 COMP-3.

      * Declare the CURSOR for ACCOUNT table
           EXEC SQL DECLARE ACC-CURSOR CURSOR FOR
              SELECT ACCOUNT_EYECATCHER,
                     ACCOUNT_CUSTOMER_NUMBER,
                     ACCOUNT_SORTCODE,
                     ACCOUNT_NUMBER,
                     ACCOUNT_TYPE,
                     ACCOUNT_INTEREST_RATE,
                     ACCOUNT_OPENED,
                     ACCOUNT_OVERDRAFT_LIMIT,
                     ACCOUNT_LAST_STATEMENT,
                     ACCOUNT_NEXT_STATEMENT,
                     ACCOUNT_AVAILABLE_BALANCE,
                     ACCOUNT_ACTUAL_BALANCE
                     FROM ACCOUNT
                     WHERE ACCOUNT_SORTCODE =
                      :HV-ACCOUNT-SORT-CODE
                     AND ACCOUNT_NUMBER >
                      :HV-ACCOUNT-NUMBER
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

       01  ACC-VSAM-STATUS.
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

       01 NUMBER-OF-ACCOUNTS             PIC 9(8) VALUE 0.
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
      *   Open the DB2 CURSOR
      *

           MOVE '00000000' TO HV-ACCOUNT-NUMBER.
           MOVE  SORTCODE TO HV-ACCOUNT-SORT-CODE.

           EXEC SQL OPEN
              ACC-CURSOR
           END-EXEC.

           MOVE SQLCODE TO SQLCODE-DISPLAY.

           IF SQLCODE NOT = 0
              MOVE SQLCODE TO SQLCODE-DISPLAY
              DISPLAY 'FAILED TO OPEN ACC-CURSOR IN PGM ACCOFFL.'
              DISPLAY 'The SQLCODE returned is ' SQLCODE-DISPLAY
              DISPLAY SQLCA
              MOVE 12 TO RETURN-CODE
              PERFORM PROGRAM-DONE
           END-IF.

      *
      * Open the ACCOUNT offload file
      *
           OPEN OUTPUT ACC-FILE.
           IF ACC-VSAM-STATUS NOT EQUAL '00' THEN
               DISPLAY 'Error opening the ACCOUNT offload file, '
                       ' status='
                       ACC-VSAM-STATUS
               MOVE 12 TO RETURN-CODE
               PERFORM PROGRAM-DONE
           END-IF.

           MOVE 0 TO NUMBER-OF-ACCOUNTS.

           PERFORM FETCH-DATA.

           EXEC SQL CLOSE
                ACC-CURSOR
           END-EXEC.


      *
      * Close the ACCOUNT offload file
      *
           CLOSE ACC-FILE.

           DISPLAY 'The number of records written to the ACCOUNT'
                   ' off load file is ' NUMBER-OF-ACCOUNTS.

           PERFORM PROGRAM-DONE.

       A999.
           EXIT.


       FETCH-DATA SECTION.
       FD010.


           PERFORM UNTIL SQLCODE NOT = 0

              EXEC SQL FETCH FROM ACC-CURSOR
              INTO :HV-ACCOUNT-EYECATCHER,
                   :HV-ACCOUNT-CUST-NO,
                   :HV-ACCOUNT-SORT-CODE,
                   :HV-ACCOUNT-NUMBER,
                   :HV-ACCOUNT-TYPE,
                   :HV-ACCOUNT-INTEREST-RATE,
                   :HV-ACCOUNT-OPENED,
                   :HV-ACCOUNT-OVERDRAFT-LIMIT,
                   :HV-ACCOUNT-LAST-STMT-DATE,
                   :HV-ACCOUNT-NEXT-STMT-DATE,
                   :HV-ACCOUNT-AVAILABLE-BALANCE,
                   :HV-ACCOUNT-ACTUAL-BALANCE
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
                    ' DB2 CURSOR ACC-CURSOR. With SQL code='
                    SQLCODE-DISPLAY

                 GO TO FD999
              END-IF

      *
      *       If we find a matching customer
      *

              ADD 1 TO NUMBER-OF-ACCOUNTS GIVING NUMBER-OF-ACCOUNTS

              MOVE HV-ACCOUNT-EYECATCHER
                 TO ACCOUNT-EYE-CATCHER
              MOVE HV-ACCOUNT-CUST-NO
                 TO ACCOUNT-CUST-NO
              MOVE HV-ACCOUNT-SORT-CODE
                 TO ACCOUNT-SORT-CODE
              MOVE HV-ACCOUNT-NUMBER
                 TO ACCOUNT-NUMBER
              MOVE HV-ACCOUNT-TYPE
                 TO ACCOUNT-TYPE
              MOVE HV-ACCOUNT-INTEREST-RATE
                 TO ACCOUNT-INTEREST-RATE
              MOVE HV-ACCOUNT-OPENED-DAY
                 TO ACCOUNT-OPENED-DAY
              MOVE HV-ACCOUNT-OPENED-MONTH
                 TO ACCOUNT-OPENED-MONTH
              MOVE HV-ACCOUNT-OPENED-YEAR
                 TO ACCOUNT-OPENED-YEAR
              MOVE HV-ACCOUNT-OVERDRAFT-LIMIT
                 TO ACCOUNT-OVERDRAFT-LIMIT
              MOVE HV-ACCOUNT-LAST-STMT-DAY
                 TO ACCOUNT-LAST-STMT-DAY
              MOVE HV-ACCOUNT-LAST-STMT-MONTH
                 TO ACCOUNT-LAST-STMT-MONTH
              MOVE HV-ACCOUNT-LAST-STMT-YEAR
                 TO ACCOUNT-LAST-STMT-YEAR
              MOVE HV-ACCOUNT-NEXT-STMT-DAY
                 TO ACCOUNT-NEXT-STMT-DAY
              MOVE HV-ACCOUNT-NEXT-STMT-MONTH
                 TO ACCOUNT-NEXT-STMT-MONTH
              MOVE HV-ACCOUNT-NEXT-STMT-YEAR
                 TO ACCOUNT-NEXT-STMT-YEAR
              MOVE HV-ACCOUNT-AVAILABLE-BALANCE
                 TO ACCOUNT-AVAILABLE-BALANCE
              MOVE HV-ACCOUNT-ACTUAL-BALANCE
                 TO ACCOUNT-ACTUAL-BALANCE

              PERFORM WRITE-TO-FILE

           END-PERFORM.

       FD999.
           EXIT.


       WRITE-TO-FILE SECTION.
       WTF010.

           WRITE ACCOUNT-RECORD-STRUCTURE.

           IF ACC-VSAM-STATUS NOT EQUAL '00' THEN
                   DISPLAY 'Error writing to ACCOUNT offload file.'
                   ', status=' ACC-VSAM-STATUS
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
