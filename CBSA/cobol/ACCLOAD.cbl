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
      * Description: Batch program to reload the account data from     *
      *              the unload file into Db2, where the ACCOUNT       *
      *              Db2 table has been amended to have a 9 byte       *
      *              account number.                                   *
      *                                                                *
      * Input: The populated VSAM OFFLOAD fileL                        *
      *                                                                *
      *                                                                *
      ******************************************************************
       IDENTIFICATION DIVISION.
      *AUTHOR. JON COLLETT.
       PROGRAM-ID. ACCLOAD.

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
                  ACCESS MODE  IS SEQUENTIAL
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
                ACCOUNT_NUMBER                 CHAR(9) NOT NULL,
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
                 07 HV-ACCOUNT-NUMBER          PIC X(9).
              05 HV-ACCOUNT-TYPE               PIC X(8).
              05 HV-ACCOUNT-INTEREST-RATE      PIC S9(4)V99 COMP-3.
              05 HV-ACCOUNT-OPENED             PIC X(10).
              05 HV-ACCOUNT-OPENED-GROUP REDEFINES HV-ACCOUNT-OPENED.
                 07 HV-ACCOUNT-OPENED-DAY      PIC XX.
                 07 HV-ACCOUNT-OPENED-DELIM1   PIC X.
                 07 HV-ACCOUNT-OPENED-MONTH    PIC XX.
                 07 HV-ACCOUNT-OPENED-DELIM2   PIC X.
                 07 HV-ACCOUNT-OPENED-YEAR     PIC X(4).
              05 HV-ACCOUNT-OVERDRAFT-LIMIT    PIC S9(9) COMP.
              05 HV-ACCOUNT-LAST-STMT-DATE     PIC X(10).
              05 HV-ACCOUNT-LAST-STMT-GROUP
                 REDEFINES HV-ACCOUNT-LAST-STMT-DATE.
                  07 HV-ACCOUNT-LAST-STMT-DAY   PIC XX.
                  07 HV-ACCOUNT-LAST-STMT-DELIM1 PIC X.
                  07 HV-ACCOUNT-LAST-STMT-MONTH  PIC XX.
                  07 HV-ACCOUNT-LAST-STMT-DELIM2 PIC X.
                  07 HV-ACCOUNT-LAST-STMT-YEAR   PIC X(4).
              05 HV-ACCOUNT-NEXT-STMT-DATE     PIC X(10).
              05 HV-ACCOUNT-NEXT-STMT-GROUP
                 REDEFINES HV-ACCOUNT-NEXT-STMT-DATE.
                 07 HV-ACCOUNT-NEXT-STMT-DAY    PIC XX.
                 07 HV-ACCOUNT-NEXT-STMT-DELIM1 PIC X.
                 07 HV-ACCOUNT-NEXT-STMT-MONTH  PIC XX.
                 07 HV-ACCOUNT-NEXT-STMT-DELIM2 PIC X.
                 07 HV-ACCOUNT-NEXT-STMT-YEAR   PIC X(4).
              05 HV-ACCOUNT-AVAILABLE-BALANCE  PIC S9(10)V99 COMP-3.
              05 HV-ACCOUNT-ACTUAL-BALANCE     PIC S9(10)V99 COMP-3.


      * Pull in the SQL COMMAREA
       EXEC SQL
          INCLUDE SQLCA
       END-EXEC.

       01 DISP-LOT.
          03 DISP-SIGN      PIC X.
          03 DISP-SQLCD     PIC 9999.

       01 DISP-REASON-CODE             PIC X(18).

       01  ACC-VSAM-STATUS.
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
      *   Open the ACCOUNT off load VSAM file.
      *

           OPEN INPUT ACC-FILE.
           IF ACC-VSAM-STATUS NOT EQUAL '00' THEN
               DISPLAY 'Error opening ACCOUNT OFFLOAD file, status='
                       ACC-VSAM-STATUS
               MOVE 12 TO RETURN-CODE
               PERFORM PROGRAM-DONE
           END-IF.

      *
      *    Read the first record from the ACCOUNT OFFLOAD file
      *

           INITIALIZE ACCOUNT-RECORD-STRUCTURE.

           START ACC-FILE KEY GREATER THAN ACCOUNT-KEY.

           IF ACC-VSAM-STATUS NOT EQUAL '00'
              DISPLAY 'START not OK. VSAM STATUS is='
                      ACC-VSAM-STATUS
              MOVE 12 TO RETURN-CODE
              PERFORM PROGRAM-DONE
           END-IF.


           READ ACC-FILE
           IF ACC-VSAM-STATUS NOT EQUAL '00'

              IF ACC-VSAM-STATUS = '10'
                 DISPLAY 'FIRST REC IS END OF FILE'
                 MOVE 'Y' TO WS-EOF
              ELSE
                 DISPLAY 'Error on the initial read from '
                         'ACCOUNT OFFLOAD file, status='
                         ACC-VSAM-STATUS
                 MOVE 12 TO RETURN-CODE
                 PERFORM PROGRAM-DONE
              END-IF

           END-IF.


           PERFORM UNTIL WS-EOF = 'Y' OR WS-EXIT = 'Y'

              ADD 1 TO WS-RECORDS-READ

              MOVE ACCOUNT-EYE-CATCHER     TO
                   HV-ACCOUNT-EYECATCHER
              MOVE ACCOUNT-CUST-NO         TO
                   HV-ACCOUNT-CUST-NO
              MOVE ACCOUNT-SORT-CODE       TO
                   HV-ACCOUNT-SORT-CODE
              STRING '0' DELIMITED BY SIZE,
                     ACCOUNT-NUMBER DELIMITED BY SIZE
                     INTO HV-ACCOUNT-NUMBER
              END-STRING

              MOVE ACCOUNT-TYPE              TO
                   HV-ACCOUNT-TYPE
              MOVE ACCOUNT-INTEREST-RATE     TO
                   HV-ACCOUNT-INTEREST-RATE
              MOVE ACCOUNT-OPENED-DAY        TO
                   HV-ACCOUNT-OPENED-DAY
              MOVE '.' TO HV-ACCOUNT-OPENED-DELIM1
              MOVE ACCOUNT-OPENED-MONTH      TO
                   HV-ACCOUNT-OPENED-MONTH
              MOVE '.' TO HV-ACCOUNT-OPENED-DELIM2
              MOVE ACCOUNT-OPENED-YEAR       TO
                   HV-ACCOUNT-OPENED-YEAR
              MOVE ACCOUNT-OVERDRAFT-LIMIT   TO
                   HV-ACCOUNT-OVERDRAFT-LIMIT
              MOVE ACCOUNT-LAST-STMT-DAY     TO
                   HV-ACCOUNT-LAST-STMT-DAY
              MOVE '.' TO HV-ACCOUNT-LAST-STMT-DELIM1
              MOVE ACCOUNT-LAST-STMT-MONTH   TO
                   HV-ACCOUNT-LAST-STMT-MONTH
              MOVE '.' TO HV-ACCOUNT-LAST-STMT-DELIM2
              MOVE ACCOUNT-LAST-STMT-YEAR    TO
                   HV-ACCOUNT-LAST-STMT-YEAR
              MOVE ACCOUNT-NEXT-STMT-DAY     TO
                   HV-ACCOUNT-NEXT-STMT-DAY
              MOVE '.' TO HV-ACCOUNT-NEXT-STMT-DELIM1
              MOVE ACCOUNT-NEXT-STMT-MONTH   TO
                   HV-ACCOUNT-NEXT-STMT-MONTH
              MOVE '.' TO HV-ACCOUNT-NEXT-STMT-DELIM2
              MOVE ACCOUNT-NEXT-STMT-YEAR    TO
                   HV-ACCOUNT-NEXT-STMT-YEAR
              MOVE ACCOUNT-AVAILABLE-BALANCE TO
                   HV-ACCOUNT-AVAILABLE-BALANCE
              MOVE ACCOUNT-ACTUAL-BALANCE    TO
                   HV-ACCOUNT-ACTUAL-BALANCE

      *
      *       Insert the row onto the table

              EXEC SQL
                 INSERT INTO ACCOUNT
                        (ACCOUNT_EYECATCHER,
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
                        )
                 VALUES (:HV-ACCOUNT-EYECATCHER,
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
                        )
              END-EXEC

      *
      *       Check if the INSERT was unsuccessful and take action.
      *

              IF SQLCODE NOT = 0
                 MOVE SQLCODE TO SQLCODE-DISPLAY
                 DISPLAY 'Unable to insert into ACCOUNT in '
                   'SQLCODE=' SQLCODE-DISPLAY

                 DISPLAY 'Writing ACCOUNT ' HV-ACCOUNT-NUMBER

                 PERFORM PROGRAM-DONE

              END-IF

              ADD 1 TO WS-RECS-WRITTEN


      *
      *       Read the NEXT record from the ACCOUNT OFFLOAD file
      *

              INITIALIZE ACCOUNT-RECORD-STRUCTURE

              READ ACC-FILE
              IF ACC-VSAM-STATUS NOT EQUAL '00'

                 IF ACC-VSAM-STATUS = '10'
                    DISPLAY 'FIRST REC IS END OF FILE'
                    MOVE 'Y' TO WS-EOF
                 ELSE
                    DISPLAY 'Error reading subsequent rec from ACCOUNT'
                            ' OFFLOAD file, '
                            ' status='
                            ACC-VSAM-STATUS
                    DISPLAY 'Last rec written was ' HV-ACCOUNT-NUMBER

                    MOVE 12 TO RETURN-CODE
                    PERFORM PROGRAM-DONE
                 END-IF

              END-IF

           END-PERFORM.

      *
      *    Close the file
      *
           CLOSE ACC-FILE.

           DISPLAY 'ACCLOAD Finished successfully. There were '
                   WS-RECORDS-READ 'records READ from the offload'
                   ' file & '
                   WS-RECS-WRITTEN 'recs written to the ACCOUNT table'.

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
