       PROCESS CICS,NODYNAM,NSYMBOL(NATIONAL),TRUNC(STD)
       CBL CICS('SP,EDF,DLI')
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
      * 5                                                              *
      ******************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID. CONSENT.
       AUTHOR. Anuprakash M.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER.  IBM-370.
       OBJECT-COMPUTER.  IBM-370.

       INPUT-OUTPUT SECTION.

       DATA DIVISION.
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

      * Get the CONSENT DB2 copybook
           EXEC SQL
             INCLUDE CONSTDB2
           END-EXEC.

      * Pull in the SQL COMMAREA
           EXEC SQL
             INCLUDE SQLCA
           END-EXEC.

      * CONSENT Host variables for DB2
       01 HOST-CONSENT-ROW.
          10 HV-CONSENT-ID           PIC S9(9) USAGE COMP.
          10 HV-CONSENT-STATUS       PIC X(1).
          10 HV-DOMESTIC-PAY-ID      PIC S9(9) USAGE COMP.
          10 HV-DOMESTIC-PAY-STATUS  PIC X(4).
          10 HV-CREDIT-AC            PIC X(16).
          10 HV-CREDIT-AC-SCHEMENAME PIC X(50).
          10 HV-CREDIT-AC-CUSTNAME   PIC X(50).
          10 HV-DEBIT-AC             PIC X(16).
          10 HV-DEBIT-AC-SCHEMENAME  PIC X(50).
          10 HV-DEBIT-AC-CUSTNAME    PIC X(50).
          10 HV-CONSENT-AMOUNT       PIC S9(10)V99 COMP-3.
          10 HV-CURRENCY-CD          PIC X(3).
          10 HV-CREATE-TS            PIC X(26).
          10 HV-LAST-UPDATE-TS       PIC X(26).


      * Get the ACCOUNT DB2 copybook
           EXEC SQL
             INCLUDE ACCDB2
           END-EXEC.

      * ACCOUNT Host variables for DB2
       01 HOST-ACCOUNT-ROW.
          03 HV-ACCOUNT-EYECATCHER      PIC X(4).
          03 HV-ACCOUNT-CUST-NO         PIC X(10).
          03 HV-ACCOUNT-KEY.
             05 HV-ACCOUNT-SORTCODE     PIC X(6).
             05 HV-ACCOUNT-ACC-NO       PIC X(8).
          03 HV-ACCOUNT-ACC-TYPE        PIC X(8).
          03 HV-ACCOUNT-INT-RATE        PIC S9(4)V99 COMP-3.
          03 HV-ACCOUNT-OPENED          PIC X(10).
          03 HV-ACCOUNT-OVERDRAFT-LIM   PIC S9(9) COMP.
          03 HV-ACCOUNT-LAST-STMT       PIC X(10).
          03 HV-ACCOUNT-NEXT-STMT       PIC X(10).
          03 HV-ACCOUNT-AVAIL-BAL       PIC S9(10)V99 COMP-3.
          03 HV-ACCOUNT-ACTUAL-BAL      PIC S9(10)V99 COMP-3.

       LOCAL-STORAGE SECTION.

      *
      * Pull in the input and output data structures
      *
       01 WS-CONSENT-DATA.
          COPY CONSENT.

       01 WS-ACC-DATA.
          COPY ACCOUNT.

       01 WS-CURR-TIMESTAMP             PIC X(26).

       01 WS-ACCOUNT.
          10 ACCOUNT-SORTCODE           PIC X(6).
          10 ACCOUNT-NO                 PIC X(8).
          10 ACCOUNT-FILLER             PIC X(2).

          LINKAGE SECTION.

       01 DFHCOMMAREA.
           COPY CONSTAPI.


       PROCEDURE DIVISION USING DFHCOMMAREA.
       PREMIERE SECTION.
       A010.

           MOVE  0       TO  HV-CONSENT-ID.
           MOVE  SPACES  TO  HV-CONSENT-STATUS.
           MOVE  0       TO  HV-DOMESTIC-PAY-ID.
           MOVE  SPACES  TO  HV-DOMESTIC-PAY-STATUS.
           MOVE  SPACES  TO  HV-CREDIT-AC.
           MOVE  SPACES  TO  HV-CREDIT-AC-SCHEMENAME.
           MOVE  SPACES  TO  HV-CREDIT-AC-CUSTNAME.
           MOVE  SPACES  TO  HV-DEBIT-AC.
           MOVE  SPACES  TO  HV-DEBIT-AC-SCHEMENAME.
           MOVE  SPACES  TO  HV-DEBIT-AC-CUSTNAME.
           MOVE  SPACES  TO  HV-CURRENCY-CD.
           MOVE  0       TO  DFHCA-RETURN-CD.
           MOVE SPACES   TO  DFHCA-ERROR-MSG.
           MOVE SPACES   TO  DFHCA-FUNDS-AVAIL-FLAG.
           MOVE SPACES   TO  DFHCA-CONSENT-STATUS.
           MOVE SPACES   TO  DFHCA-DOMESTIC-PAY-STATUS.
      *  Charge Values
           MOVE 'UK.OBIE.CHAPSOut' TO DFHCA-CHARGE-BEARER.
           MOVE 'BorneByCreditor'  TO DFHCA-CHARGE-TYPE.
           MOVE  10                TO DFHCA-CHARGE-AMT.
           MOVE 'USD'              TO DFHCA-CHARGE-CUR-CD.

           EXEC SQL
              SELECT CURRENT TIMESTAMP
              INTO :WS-CURR-TIMESTAMP
              FROM SYSIBM.SYSDUMMY1
           END-EXEC

      *
      *    Check the type of request:
      *       C - Create Consent
      *       G - Get Consent Status
      *       F - Consent Fund Confirmation
      *
           EVALUATE DFHCA-CONSENT-REQ
              WHEN 'C'
                 PERFORM CREATE-NEW-CONSENT
              WHEN 'G'
                 PERFORM GET-CONSENT-STATUS
              WHEN 'F'
                 PERFORM GET-FUND-CONFIRMATION
              WHEN OTHER
                 MOVE  8  TO DFHCA-RETURN-CD
                 MOVE  'INVALID CONSENT REQUEST, VALID VALUES - C,G,F'
                          TO DFHCA-ERROR-MSG
           END-EVALUATE.

      *
      *    The COMMAREA values have now been set so all we need to do
      *    is finish
      *
           PERFORM GET-ME-OUT-OF-HERE.

       A999.
           EXIT.


       CREATE-NEW-CONSENT SECTION.
       CNC010.

           IF DFHCA-DEBIT-AC = SPACES
              OR DFHCA-CREDIT-AC = SPACES
              MOVE  9  TO DFHCA-RETURN-CD
              MOVE  'CREDIT/DEBIT AC MISSING IN REQUEST'
                          TO DFHCA-ERROR-MSG
              PERFORM GET-ME-OUT-OF-HERE
           END-IF.

           IF DFHCA-CONSENT-AMOUNT <= 0
              MOVE  10  TO DFHCA-RETURN-CD
              MOVE  'REQUESTED AMOUNT LESS THAN OR EQUALS ZERO'
                          TO DFHCA-ERROR-MSG
              PERFORM GET-ME-OUT-OF-HERE
           END-IF.

           EXEC SQL
              SELECT MAX(CONSENT_ID)
              INTO :HV-CONSENT-ID
              FROM CONSENT
           END-EXEC.

      *
      *    Check that select was successful. If it wasn't then set the
      *    COMMAREA return flags accordingly.
      *
           EVALUATE SQLCODE
              WHEN 0
                 ADD 1  TO HV-CONSENT-ID
              WHEN 100
                 MOVE 1 TO HV-CONSENT-ID
              WHEN OTHER
                 MOVE SQLCODE  TO DFHCA-RETURN-CD
                 MOVE 'DATABASE ERROR - WHEN SELECT FROM CONSENT TABLE'
                      TO DFHCA-ERROR-MSG
                 PERFORM GET-ME-OUT-OF-HERE
           END-EVALUATE.

           MOVE    DFHCA-DEBIT-AC          TO WS-ACCOUNT
           PERFORM CHECK-CREDIT-DEBIT-AC

           MOVE DFHCA-CREDIT-AC            TO HV-CREDIT-AC.
           MOVE DFHCA-CREDIT-AC-SCHEMENAME TO HV-CREDIT-AC-SCHEMENAME.
           MOVE DFHCA-CREDIT-AC-CUSTNAME   TO HV-CREDIT-AC-CUSTNAME.

           MOVE DFHCA-DEBIT-AC             TO HV-DEBIT-AC.
           MOVE DFHCA-DEBIT-AC-SCHEMENAME  TO HV-DEBIT-AC-SCHEMENAME.
           MOVE DFHCA-DEBIT-AC-CUSTNAME    TO HV-DEBIT-AC-CUSTNAME.

           MOVE DFHCA-CONSENT-AMOUNT       TO HV-CONSENT-AMOUNT.
           MOVE DFHCA-CURRENCY-CD          TO HV-CURRENCY-CD.

           MOVE 'A'                        TO HV-CONSENT-STATUS.
           COMPUTE HV-DOMESTIC-PAY-ID = HV-CONSENT-ID * 2.
           MOVE 'P   '                     TO HV-DOMESTIC-PAY-STATUS.
           MOVE WS-CURR-TIMESTAMP          TO HV-CREATE-TS.
           MOVE WS-CURR-TIMESTAMP          TO HV-LAST-UPDATE-TS.

           EXEC SQL
                INSERT INTO CONSENT
                (
                  CONSENT_ID           ,
                  CONSENT_STATUS       ,
                  CONSENT_AMOUNT       ,
                  DOMESTIC_PAY_ID      ,
                  DOMESTIC_PAY_STATUS  ,
                  CREDIT_AC            ,
                  CREDIT_AC_SCHEMENAME ,
                  CREDIT_AC_CUSTNAME   ,
                  DEBIT_AC             ,
                  DEBIT_AC_SCHEMENAME  ,
                  DEBIT_AC_CUSTNAME    ,
                  CURRENCY_CD          ,
                  CREATE_TS            ,
                  LAST_UPDATE_TS
                )
                VALUES
                (
                  :HV-CONSENT-ID           ,
                  :HV-CONSENT-STATUS       ,
                  :HV-CONSENT-AMOUNT       ,
                  :HV-DOMESTIC-PAY-ID      ,
                  :HV-DOMESTIC-PAY-STATUS  ,
                  :HV-CREDIT-AC            ,
                  :HV-CREDIT-AC-SCHEMENAME ,
                  :HV-CREDIT-AC-CUSTNAME   ,
                  :HV-DEBIT-AC             ,
                  :HV-DEBIT-AC-SCHEMENAME  ,
                  :HV-DEBIT-AC-CUSTNAME    ,
                  :HV-CURRENCY-CD          ,
                  :HV-CREATE-TS            ,
                  :HV-LAST-UPDATE-TS
                )
           END-EXEC.

      *
      *    Check that select was successful. If it wasn't then set the
      *    COMMAREA return flags accordingly.
      *
           EVALUATE SQLCODE
              WHEN 0
                 MOVE HV-CONSENT-ID  TO DFHCA-CONSENT-ID
                 PERFORM GET-CONSENT-STATUS
              WHEN OTHER
                 MOVE SQLCODE  TO DFHCA-RETURN-CD
                 MOVE 'DATABASE ERROR - WHEN INSERT TO CONSENT TABLE'
                      TO DFHCA-ERROR-MSG
           END-EVALUATE.

       CNC999.
             EXIT.

       GET-CONSENT-STATUS SECTION.
       GCS010.

           IF DFHCA-CONSENT-ID <= 0
              MOVE  11  TO DFHCA-RETURN-CD
              MOVE  'CONSENT ID PASSED IS NOT VALID'
                          TO DFHCA-ERROR-MSG
              PERFORM GET-ME-OUT-OF-HERE
           END-IF.

           MOVE DFHCA-CONSENT-ID TO HV-CONSENT-ID

           EXEC SQL
              SELECT  CONSENT_STATUS       ,
                      CONSENT_AMOUNT       ,
                      DOMESTIC_PAY_ID      ,
                      DOMESTIC_PAY_STATUS  ,
                      CREDIT_AC            ,
                      CREDIT_AC_SCHEMENAME ,
                      CREDIT_AC_CUSTNAME   ,
                      DEBIT_AC             ,
                      DEBIT_AC_SCHEMENAME  ,
                      DEBIT_AC_CUSTNAME    ,
                      CURRENCY_CD          ,
                      CREATE_TS            ,
                      LAST_UPDATE_TS
              INTO   :HV-CONSENT-STATUS       ,
                     :HV-CONSENT-AMOUNT       ,
                     :HV-DOMESTIC-PAY-ID      ,
                     :HV-DOMESTIC-PAY-STATUS  ,
                     :HV-CREDIT-AC            ,
                     :HV-CREDIT-AC-SCHEMENAME ,
                     :HV-CREDIT-AC-CUSTNAME   ,
                     :HV-DEBIT-AC             ,
                     :HV-DEBIT-AC-SCHEMENAME  ,
                     :HV-DEBIT-AC-CUSTNAME    ,
                     :HV-CURRENCY-CD          ,
                     :HV-CREATE-TS            ,
                     :HV-LAST-UPDATE-TS

              FROM   CONSENT
              WHERE  CONSENT_ID = :HV-CONSENT-ID
           END-EXEC.

           EVALUATE SQLCODE
              WHEN 0
                 MOVE HV-CONSENT-ID      TO DFHCA-CONSENT-ID
                 MOVE HV-CONSENT-STATUS  TO DFHCA-CONSENT-STATUS
                 MOVE HV-CONSENT-AMOUNT  TO DFHCA-CONSENT-AMOUNT
                 MOVE HV-DOMESTIC-PAY-ID TO DFHCA-DOMESTIC-PAY-ID
                 MOVE HV-DOMESTIC-PAY-STATUS
                                         TO DFHCA-DOMESTIC-PAY-STATUS
                 MOVE HV-CREDIT-AC       TO DFHCA-CREDIT-AC
                 MOVE HV-CREDIT-AC-SCHEMENAME
                                         TO DFHCA-CREDIT-AC-SCHEMENAME
                 MOVE HV-CREDIT-AC-CUSTNAME
                                         TO DFHCA-CREDIT-AC-CUSTNAME
                 MOVE HV-DEBIT-AC        TO DFHCA-DEBIT-AC
                 MOVE HV-DEBIT-AC-SCHEMENAME
                                         TO DFHCA-DEBIT-AC-SCHEMENAME
                 MOVE HV-DEBIT-AC-CUSTNAME
                                         TO DFHCA-DEBIT-AC-CUSTNAME
                 MOVE HV-CURRENCY-CD     TO DFHCA-CURRENCY-CD
                 MOVE HV-CREATE-TS       TO DFHCA-CREATE-TS
                 MOVE HV-LAST-UPDATE-TS  TO DFHCA-LAST-UPDATE-TS
              WHEN 100
                 MOVE SQLCODE  TO DFHCA-RETURN-CD
                 MOVE 'CONSENT ID PASSED IS NOT VALID'
                      TO DFHCA-ERROR-MSG
                 PERFORM GET-ME-OUT-OF-HERE
              WHEN OTHER
                 MOVE SQLCODE  TO DFHCA-RETURN-CD
                 MOVE 'DATABASE ERROR - WHEN SELECT FROM CONSENT TABLE'
                      TO DFHCA-ERROR-MSG
                 PERFORM GET-ME-OUT-OF-HERE
           END-EVALUATE.

       GCS999.
             EXIT.

       GET-FUND-CONFIRMATION SECTION.
       GFC010.

           PERFORM GET-CONSENT-STATUS.

           MOVE HV-DEBIT-AC       TO DEBIT-AC.
           MOVE DEBIT-AC-SORTCODE TO HV-ACCOUNT-SORTCODE.
           MOVE DEBIT-AC-NO       TO HV-ACCOUNT-ACC-NO.

           EXEC SQL
                SELECT ACCOUNT_AVAILABLE_BALANCE
                INTO   :HV-ACCOUNT-AVAIL-BAL
                FROM ACCOUNT
                WHERE  (ACCOUNT_SORTCODE = :HV-ACCOUNT-SORTCODE AND
                        ACCOUNT_NUMBER   = :HV-ACCOUNT-ACC-NO)
           END-EXEC.

           EVALUATE SQLCODE
              WHEN 0
                 IF HV-ACCOUNT-AVAIL-BAL < HV-CONSENT-AMOUNT
                    MOVE 0        TO DFHCA-FUNDS-AVAIL-FLAG
                 ELSE
                    MOVE 1        TO DFHCA-FUNDS-AVAIL-FLAG
                 END-IF
              WHEN 100
                 MOVE SQLCODE  TO DFHCA-RETURN-CD
                 MOVE 'DEBIT ACCOUNT/SORTCODE IS NOT VALID'
                      TO DFHCA-ERROR-MSG
              WHEN OTHER
                 MOVE SQLCODE  TO DFHCA-RETURN-CD
                 MOVE 'DATABASE ERROR - WHEN SELECT FROM ACCOUNT TABLE'
                      TO DFHCA-ERROR-MSG
           END-EVALUATE.


       GFC999.
             EXIT.


       CHECK-CREDIT-DEBIT-AC SECTION.
       CCDA010.

           MOVE ACCOUNT-SORTCODE TO HV-ACCOUNT-SORTCODE.
           MOVE ACCOUNT-NO       TO HV-ACCOUNT-ACC-NO.

           EXEC SQL
                SELECT ACCOUNT_CUSTOMER_NUMBER
                INTO   :HV-ACCOUNT-CUST-NO
                FROM ACCOUNT
                WHERE  (ACCOUNT_SORTCODE = :HV-ACCOUNT-SORTCODE AND
                        ACCOUNT_NUMBER   = :HV-ACCOUNT-ACC-NO)
           END-EXEC.

           EVALUATE SQLCODE
              WHEN 0
                 MOVE 0        TO DFHCA-RETURN-CD
              WHEN 100
                 MOVE SQLCODE  TO DFHCA-RETURN-CD
                 MOVE 'DEBIT ACCOUNT/SORTCODE IS NOT VALID'
                      TO DFHCA-ERROR-MSG
                 PERFORM GET-ME-OUT-OF-HERE
              WHEN OTHER
                 MOVE SQLCODE  TO DFHCA-RETURN-CD
                 MOVE 'DATABASE ERROR - WHEN SELECT FROM ACCOUNT TABLE'
                      TO DFHCA-ERROR-MSG
                 PERFORM GET-ME-OUT-OF-HERE
           END-EVALUATE.


       CCDA999.
             EXIT.


       GET-ME-OUT-OF-HERE SECTION.
       GMOOH010.
           EXEC CICS RETURN
           END-EXEC.

           GOBACK.

       GMOOH999.
           EXIT.