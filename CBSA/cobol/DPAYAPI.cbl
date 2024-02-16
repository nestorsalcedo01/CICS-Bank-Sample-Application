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
      *                                                                *
      ******************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID. DPAYAPI.
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

       01 SUBPGM-PARMS.
          03 SUBPGM-FACCNO              PIC 9(8).
          03 SUBPGM-FSCODE              PIC 9(6).
          03 SUBPGM-TACCNO              PIC 9(8).
          03 SUBPGM-TSCODE              PIC 9(6).
          03 SUBPGM-AMT                 PIC S9(10)V99.
          03 SUBPGM-FAVBAL              PIC S9(10)V99.
          03 SUBPGM-FACTBAL             PIC S9(10)V99.
          03 SUBPGM-TAVBAL              PIC S9(10)V99.
          03 SUBPGM-TACTBAL             PIC S9(10)V99.
          03 SUBPGM-FAIL-CODE           PIC X.
          03 SUBPGM-SUCCESS             PIC X.

       LOCAL-STORAGE SECTION.
      *
      * Pull in the input and output data structures
      *
       01 WS-CONSENT-DATA.
          COPY CONSENT.

       01 WS-CICS-WORK-AREA.
          03 WS-CICS-RESP               PIC S9(8) COMP
                                                      VALUE 0.
          03 WS-CICS-RESP2              PIC S9(8) COMP
                                                      VALUE 0.
       01 WS-CURR-TIMESTAMP             PIC X(26).

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
           MOVE  0       TO  DFHCA-RETURN-CD
           MOVE SPACES   TO  DFHCA-ERROR-MSG
           MOVE SPACES   TO  DFHCA-FUNDS-AVAIL-FLAG
           MOVE SPACES   TO  DFHCA-CONSENT-STATUS
           MOVE SPACES   TO  DFHCA-DOMESTIC-PAY-STATUS
      *  Charge Values
           MOVE 'UK.OBIE.CHAPSOut' TO DFHCA-CHARGE-BEARER.
           MOVE 'BorneByCreditor'  TO DFHCA-CHARGE-TYPE.
           MOVE  10                TO DFHCA-CHARGE-AMT.
           MOVE 'USD'              TO DFHCA-CHARGE-CUR-CD.

      *
      *    Check the type of request:
      *       P - Authorize payment
      *       G - Get Payment status
      *
           EVALUATE DFHCA-CONSENT-REQ
              WHEN 'P'
                 PERFORM GET-CONSENT-DETAILS
                 PERFORM GET-FUND-AVAILABILITY
                 IF DFHCA-FUNDS-AVAIL-FLAG = 0
                    PERFORM UPDATE-PAYMENT-FAILURE
                    MOVE  100  TO DFHCA-RETURN-CD
                    MOVE  'Funds not available in the account'
                          TO DFHCA-ERROR-MSG
                    PERFORM GET-ME-OUT-OF-HERE
                 END-IF

                 IF HV-DOMESTIC-PAY-STATUS = 'P   '
                    PERFORM PROCESS-PAYMENT
                 ELSE
                    MOVE  101  TO DFHCA-RETURN-CD
                    IF HV-DOMESTIC-PAY-STATUS = 'R   '
                      MOVE  'Payment rejected for this consent'
                          TO DFHCA-ERROR-MSG
                    ELSE
                      MOVE  'Payment already processed for this consent'
                          TO DFHCA-ERROR-MSG
                    END-IF
                 END-IF
              WHEN 'S'
                 PERFORM GET-PAYMENT-STATUS
              WHEN OTHER
                 MOVE  8  TO DFHCA-RETURN-CD
                 MOVE  'INVALID CONSENT REQUEST, VALID VALUES - P,S'
                          TO DFHCA-ERROR-MSG
           END-EVALUATE.

      *
      *    The COMMAREA values have now been set so all we need to do
      *    is finish
      *
           PERFORM GET-ME-OUT-OF-HERE.

       A999.
           EXIT.

       PROCESS-PAYMENT SECTION.
       PP010.

      *
      *    Set up the fields required by XFRFUN then link to it to
      *    get account information and perform the transfer, then
      *    check what gets returned.
      *
           INITIALIZE SUBPGM-PARMS.

           MOVE DEBIT-AC-NO   TO  SUBPGM-FACCNO.
           MOVE CREDIT-AC-NO  TO  SUBPGM-TACCNO.
           MOVE 'N'           TO  SUBPGM-SUCCESS.

      *
      * Provide the correct Amount
      *
           COMPUTE SUBPGM-AMT =  HV-CONSENT-AMOUNT.

           EXEC CICS LINK
              PROGRAM('XFRFUN')
              COMMAREA(SUBPGM-PARMS)
              RESP(WS-CICS-RESP)
              RESP2(WS-CICS-RESP2)
              SYNCONRETURN
           END-EXEC.

           IF WS-CICS-RESP NOT = DFHRESP(NORMAL)
              MOVE  WS-CICS-RESP  TO DFHCA-RETURN-CD
              MOVE  'PAYMENT FAILED IN XFRFUN MODULE'
                          TO DFHCA-ERROR-MSG
              PERFORM UPDATE-PAYMENT-FAILURE
           ELSE
              PERFORM UPDATE-PAYMENT-SUCCESS
           END-IF.

       PP999.
           EXIT.


       UPDATE-PAYMENT-FAILURE SECTION.
       UPF010.

           MOVE 'R   '                TO HV-DOMESTIC-PAY-STATUS
           MOVE 'A'                   TO HV-CONSENT-STATUS
           PERFORM UPDATE-CONSENT-TABLE.

       UPF999.
           EXIT.

       UPDATE-PAYMENT-SUCCESS SECTION.
       UPS010.

           MOVE 'ASC '                TO HV-DOMESTIC-PAY-STATUS
           MOVE 'C'                   TO HV-CONSENT-STATUS
           PERFORM UPDATE-CONSENT-TABLE.

       UPS999.
           EXIT.


       GET-CONSENT-DETAILS SECTION.
       GCD010.

           IF DFHCA-CONSENT-ID <= 0
              MOVE  11  TO DFHCA-RETURN-CD
              MOVE  'CONSENT ID PASSED IS NOT VALID'
                          TO DFHCA-ERROR-MSG
              PERFORM GET-ME-OUT-OF-HERE
           END-IF.

           MOVE DFHCA-CONSENT-ID TO HV-CONSENT-ID

           EXEC SQL
              SELECT CONSENT_ID           ,
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
               INTO  :HV-CONSENT-ID           ,
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
              FROM   CONSENT
              WHERE  CONSENT_ID = :HV-CONSENT-ID
           END-EXEC.

           EVALUATE SQLCODE
              WHEN 0
                 MOVE HV-CREDIT-AC       TO CREDIT-AC
                 MOVE HV-DEBIT-AC        TO DEBIT-AC
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

       GCD999.
           EXIT.


       GET-PAYMENT-STATUS SECTION.
       GPS010.

           IF DFHCA-DOMESTIC-PAY-ID <= 0
              MOVE  11  TO DFHCA-RETURN-CD
              MOVE  'PAYMENT ID PASSED IS NOT VALID'
                          TO DFHCA-ERROR-MSG
              PERFORM GET-ME-OUT-OF-HERE
           END-IF.

           MOVE DFHCA-DOMESTIC-PAY-ID TO HV-DOMESTIC-PAY-ID

           EXEC SQL
              SELECT CONSENT_ID           ,
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
               INTO  :HV-CONSENT-ID           ,
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
              FROM   CONSENT
              WHERE  DOMESTIC_PAY_ID = :HV-DOMESTIC-PAY-ID
           END-EXEC.

           EVALUATE SQLCODE
              WHEN 0
                 MOVE HV-CREDIT-AC       TO CREDIT-AC
                 MOVE HV-DEBIT-AC        TO DEBIT-AC
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
                 MOVE 'PAYMENT ID PASSED IS NOT VALID'
                      TO DFHCA-ERROR-MSG
                 PERFORM GET-ME-OUT-OF-HERE
              WHEN OTHER
                 MOVE SQLCODE  TO DFHCA-RETURN-CD
                 MOVE 'DATABASE ERROR - WHEN SELECT FROM CONSENT TABLE'
                      TO DFHCA-ERROR-MSG
                 PERFORM GET-ME-OUT-OF-HERE
           END-EVALUATE.

       GPS999.
           EXIT.


       UPDATE-CONSENT-TABLE SECTION.
       UPT010.

           EXEC SQL
              SELECT CURRENT TIMESTAMP
              INTO :HV-LAST-UPDATE-TS
              FROM SYSIBM.SYSDUMMY1
           END-EXEC

           EXEC SQL
              UPDATE CONSENT
              SET CONSENT_STATUS  = :HV-CONSENT-STATUS,
              DOMESTIC_PAY_STATUS = :HV-DOMESTIC-PAY-STATUS,
              LAST_UPDATE_TS      = :HV-LAST-UPDATE-TS
              WHERE CONSENT_ID    = :HV-CONSENT-ID
           END-EXEC.

           EVALUATE SQLCODE
              WHEN 0
                 EXEC CICS SYNCPOINT
                       RESP(WS-CICS-RESP)
                       RESP2(WS-CICS-RESP2)
                 END-EXEC
                 MOVE HV-DOMESTIC-PAY-ID TO DFHCA-DOMESTIC-PAY-ID
                 MOVE HV-CONSENT-STATUS  TO DFHCA-CONSENT-STATUS
                 MOVE HV-DOMESTIC-PAY-STATUS
                                         TO DFHCA-DOMESTIC-PAY-STATUS
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

       UPT999.
           EXIT.

       GET-FUND-AVAILABILITY SECTION.
       GFA000.

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

       GFA010.
           EXIT.


       GET-ME-OUT-OF-HERE SECTION.
       GMOOH010.
           EXEC CICS RETURN
           END-EXEC.

           GOBACK.

       GMOOH999.
           EXIT.