       PROCESS CICS,NODYNAM,NSYMBOL(NATIONAL),TRUNC(STD)
       CBL CICS('SP,EDF')
       CBL SQL

       IDENTIFICATION DIVISION.
       PROGRAM-ID. DPAYTST.
       AUTHOR. Anuprakash M.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER.  IBM-370.
       OBJECT-COMPUTER.  IBM-370.

       INPUT-OUTPUT SECTION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       01 WS-CICS-WORK-AREA.
          03 WS-CICS-RESP               PIC S9(8) COMP
                                                      VALUE 0.
          03 WS-CICS-RESP2              PIC S9(8) COMP
                                                      VALUE 0.
       01 WS-CONSENT-ID-L               PIC 9(9).
       01 WS-CONSENT-ID-S               PIC 9(9).
       01 WS-CONSENT-ID-ERR             PIC 9(9).
       01 WS-PGM-NAME                   PIC X(8).

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

       01 WS-AVAIL-BAL                  PIC -ZZZZZZZZZ9.99.
       01 WS-ACT-BAL                    PIC -ZZZZZZZZZ9.99.
       01 WS-AVAIL-BAL-B                PIC -ZZZZZZZZZ9.99.
       01 WS-ACT-BAL-B                  PIC -ZZZZZZZZZ9.99.
       01 WS-AVAIL-BAL-A                PIC -ZZZZZZZZZ9.99.
       01 WS-ACT-BAL-A                  PIC -ZZZZZZZZZ9.99.
       01 WS-PAY-AMT                    PIC -ZZZZZZZZZ9.99.
       01 WS-ERR-RET-CD                 PIC -ZZZ9.
       01 WS-SCREEN-OUT.
          05 WS-AVAIL-BEFORE            PIC X(79) VALUE SPACES.
          05 WS-ACTUAL-BEFORE           PIC X(79) VALUE SPACES.
          05 WS-FILLER-1                PIC X(79) VALUE SPACES.
          05 WS-CICSD-CONSTID           PIC X(79) VALUE SPACES.
          05 WS-CICSD-CONSTST           PIC X(79) VALUE SPACES.
          05 WS-CICSD-PAY-ID            PIC X(79) VALUE SPACES.
          05 WS-CICSD-PAY-ST            PIC X(79) VALUE SPACES.
          05 WS-CICSD-DEB-AC            PIC X(79) VALUE SPACES.
          05 WS-CICSD-DEB-NM            PIC X(79) VALUE SPACES.
          05 WS-CICSD-CRE-AC            PIC X(79) VALUE SPACES.
          05 WS-CICSD-CRE-NM            PIC X(79) VALUE SPACES.
          05 WS-CICSD-AMT               PIC X(79) VALUE SPACES.
          05 WS-CICSD-CUR-CD            PIC X(79) VALUE SPACES.
          05 WS-CICSD-RET-CD            PIC X(79) VALUE SPACES.
          05 WS-CICSD-RET-MSG           PIC X(79) VALUE SPACES.
          05 WS-FILLER-2                PIC X(79) VALUE SPACES.
          05 WS-AVAIL-AFTER             PIC X(79) VALUE SPACES.
          05 WS-ACTUAL-AFTER            PIC X(79) VALUE SPACES.

           EXEC SQL
             INCLUDE SQLCA
           END-EXEC.

      * Get the ACCOUNT DB2 copybook
           EXEC SQL
             INCLUDE ACCDB2
           END-EXEC.

       01 WS-ACC-DATA.
          COPY ACCOUNT.

       01 WS-CONSENT-DATA.
          COPY CONSENT.

       01 WS-COMMAREA.
          COPY CONSTAPI.

       LINKAGE SECTION.
       01 DFHCOMMAREA.
          03 WS-DUMMY                   PIC S9(8).


       PROCEDURE DIVISION.
       PREMIERE SECTION.
       A010.

           MOVE 'CONSENT' TO WS-PGM-NAME.
           PERFORM TEST-CONSENT.
           MOVE 'DPAYAPI' TO WS-PGM-NAME.
           MOVE 'DPAYAPI' TO WS-PGM-NAME.

           DISPLAY 'BEFORE PAYMENT: '
           PERFORM GET-FUNDS-BALANCE.
           DISPLAY '********************************************** '.
           MOVE WS-AVAIL-BAL    TO WS-AVAIL-BAL-B.
           MOVE WS-ACT-BAL      TO WS-ACT-BAL-B.

           PERFORM TEST-DPAYAPI.

           DISPLAY 'AFTER PAYMENT: '
           PERFORM GET-FUNDS-BALANCE.
           DISPLAY '********************************************** '.
           MOVE WS-AVAIL-BAL    TO WS-AVAIL-BAL-A.
           MOVE WS-ACT-BAL      TO WS-ACT-BAL-A.

           STRING 'AVAILABLE BALANCE in A/C #00000002 (BEFORE): '
                              DELIMITED BY SIZE
               WS-AVAIL-BAL-B DELIMITED BY SIZE
               INTO WS-AVAIL-BEFORE
           END-STRING.

           STRING 'ACTUAL BALANCE in A/C #00000002 (BEFORE)   : '
                            DELIMITED BY SIZE
               WS-ACT-BAL-B DELIMITED BY SIZE
               INTO WS-ACTUAL-BEFORE
           END-STRING.

           STRING 'AVAILABLE BALANCE in A/C #00000002 (AFTER): '
                              DELIMITED BY SIZE
               WS-AVAIL-BAL-A DELIMITED BY SIZE
               INTO WS-AVAIL-AFTER
           END-STRING.

           STRING 'ACTUAL BALANCE in A/C #00000002 (AFTER)   : '
                            DELIMITED BY SIZE
               WS-ACT-BAL-A DELIMITED BY SIZE
               INTO WS-ACTUAL-AFTER
           END-STRING.


           EXEC CICS SEND TEXT
                     FROM(WS-SCREEN-OUT)
                     LENGTH(LENGTH OF WS-SCREEN-OUT)
                     ERASE
                     FREEKB
           END-EXEC.

           EXEC CICS RETURN
           END-EXEC.

       A999.
           EXIT.

       TEST-CONSENT SECTION.
       TCT000.

           INITIALIZE WS-COMMAREA.
           MOVE 'C'               TO  DFHCA-CONSENT-REQ.
           MOVE '98765400000001'  TO  DFHCA-CREDIT-AC.
           MOVE 'FROM CONSTTST2'  TO  DFHCA-CREDIT-AC-SCHEMENAME.
           MOVE 'IBM Z SHOP'      TO  DFHCA-CREDIT-AC-CUSTNAME.
           MOVE '98765400000002'  TO  DFHCA-DEBIT-AC,
                                      DEBIT-AC.
           MOVE 'FROM CONSTTST1'  TO  DFHCA-DEBIT-AC-SCHEMENAME.
           MOVE 'David Jr'        TO  DFHCA-DEBIT-AC-CUSTNAME.
           MOVE 50                TO  DFHCA-CONSENT-AMOUNT.
           MOVE 'USD'             TO  DFHCA-CURRENCY-CD.
           PERFORM TEST-CALL.
           MOVE DFHCA-CONSENT-ID  TO WS-CONSENT-ID-S.

       TCT999.
           EXIT.

       TEST-DPAYAPI SECTION.
       TD000.
           INITIALIZE WS-COMMAREA.
           DISPLAY '001 DPAYAPI TEST CASE : Domestic Pay $50.00'.
           MOVE 'P'               TO  DFHCA-CONSENT-REQ.
           MOVE WS-CONSENT-ID-S   TO  DFHCA-CONSENT-ID.
           PERFORM TEST-CALL.

       TD999.
           EXIT.


       TEST-CALL SECTION.
       TC010.

           EXEC CICS LINK
              PROGRAM(WS-PGM-NAME)
              COMMAREA(WS-COMMAREA)
              SYNCONRETURN
           END-EXEC.

           IF WS-PGM-NAME = 'DPAYAPI'
             DISPLAY 'DFHCA-CONSENT-ID           :',
                                         DFHCA-CONSENT-ID
             DISPLAY 'DFHCA-CONSENT-STATUS       :',
                                         DFHCA-CONSENT-STATUS
             DISPLAY 'DFHCA-DOMESTIC-PAY-ID      :',
                                         DFHCA-DOMESTIC-PAY-ID
             DISPLAY 'DFHCA-DOMESTIC-PAY-STATUS  :',
                                         DFHCA-DOMESTIC-PAY-STATUS
             DISPLAY 'DFHCA-DEBIT-AC             :',
                                         DFHCA-DEBIT-AC
             DISPLAY 'DFHCA-DEBIT-AC-CUSTNAME    :',
                                         DFHCA-DEBIT-AC-CUSTNAME
             DISPLAY 'DFHCA-CREDIT-AC            :',
                                         DFHCA-CREDIT-AC
             DISPLAY 'DFHCA-CREDIT-AC-CUSTNAME   :',
                                         DFHCA-CREDIT-AC-CUSTNAME
             MOVE DFHCA-CONSENT-AMOUNT TO WS-PAY-AMT
             DISPLAY 'DFHCA-CONSENT-AMOUNT       :',
                                         WS-PAY-AMT
             DISPLAY 'DFHCA-CURRENCY-CD          :',
                                         DFHCA-CURRENCY-CD
             MOVE DFHCA-RETURN-CD        TO WS-ERR-RET-CD
             DISPLAY 'DFHCA-RETURN-CD            :',  WS-ERR-RET-CD
             DISPLAY 'DFHCA-ERROR-MSG            :',  DFHCA-ERROR-MSG
           END-IF.

           STRING 'DFHCA-CONSENT-ID           :'
                              DELIMITED BY SIZE
               DFHCA-CONSENT-ID DELIMITED BY SIZE
               INTO WS-CICSD-CONSTID
           END-STRING.

           STRING 'DFHCA-CONSENT-STATUS       :'
                            DELIMITED BY SIZE
               DFHCA-CONSENT-STATUS DELIMITED BY SIZE
               INTO WS-CICSD-CONSTST
           END-STRING.

           STRING 'DFHCA-DOMESTIC-PAY-ID      :'
                              DELIMITED BY SIZE
               DFHCA-DOMESTIC-PAY-ID DELIMITED BY SIZE
               INTO WS-CICSD-PAY-ID
           END-STRING.

           STRING 'DFHCA-DOMESTIC-PAY-STATUS  :'
                            DELIMITED BY SIZE
               DFHCA-DOMESTIC-PAY-STATUS DELIMITED BY SIZE
               INTO WS-CICSD-PAY-ST
           END-STRING.


           STRING 'DFHCA-DEBIT-AC             :'
                            DELIMITED BY SIZE
               DFHCA-DEBIT-AC DELIMITED BY SIZE
               INTO WS-CICSD-DEB-AC
           END-STRING.


           STRING 'DFHCA-DEBIT-AC-CUSTNAME    :'
                            DELIMITED BY SIZE
               DFHCA-DEBIT-AC-CUSTNAME DELIMITED BY SIZE
               INTO WS-CICSD-DEB-NM
           END-STRING.


           STRING 'DFHCA-CREDIT-AC            :'
                            DELIMITED BY SIZE
               DFHCA-CREDIT-AC DELIMITED BY SIZE
               INTO WS-CICSD-CRE-AC
           END-STRING.


           STRING 'DFHCA-CREDIT-AC-CUSTNAME   :'
                            DELIMITED BY SIZE
               DFHCA-CREDIT-AC-CUSTNAME DELIMITED BY SIZE
               INTO WS-CICSD-CRE-NM
           END-STRING.


           STRING 'DFHCA-CONSENT-AMOUNT       :'
                            DELIMITED BY SIZE
               WS-PAY-AMT DELIMITED BY SIZE
               INTO WS-CICSD-AMT
           END-STRING.


           STRING 'DFHCA-CURRENCY-CD          :'
                            DELIMITED BY SIZE
               DFHCA-CURRENCY-CD DELIMITED BY SIZE
               INTO WS-CICSD-CUR-CD
           END-STRING.


           STRING 'DFHCA-RETURN-CD            :'
                            DELIMITED BY SIZE
               WS-ERR-RET-CD DELIMITED BY SIZE
               INTO WS-CICSD-RET-CD
           END-STRING.


           STRING 'DFHCA-ERROR-MSG            :'
                            DELIMITED BY SIZE
               DFHCA-ERROR-MSG DELIMITED BY SIZE
               INTO WS-CICSD-RET-MSG
           END-STRING.

       TC999.
           EXIT.

       GET-FUNDS-BALANCE SECTION.
       GFB010.

           MOVE DEBIT-AC-SORTCODE TO HV-ACCOUNT-SORTCODE.
           MOVE DEBIT-AC-NO       TO HV-ACCOUNT-ACC-NO.

           EXEC SQL
                SELECT ACCOUNT_AVAILABLE_BALANCE,
                       ACCOUNT_ACTUAL_BALANCE
                INTO   :HV-ACCOUNT-AVAIL-BAL,
                       :HV-ACCOUNT-ACTUAL-BAL
                FROM ACCOUNT
                WHERE  (ACCOUNT_SORTCODE = :HV-ACCOUNT-SORTCODE AND
                        ACCOUNT_NUMBER   = :HV-ACCOUNT-ACC-NO)
           END-EXEC.

           EVALUATE SQLCODE
              WHEN 0
                 MOVE HV-ACCOUNT-AVAIL-BAL  TO WS-AVAIL-BAL
                 MOVE HV-ACCOUNT-ACTUAL-BAL TO WS-ACT-BAL
                 DISPLAY 'AVAILABLE BALANCE in A/C #00000002: ' ,
                          WS-AVAIL-BAL
                 DISPLAY 'ACTUAL BALANCE in A/C #00000002   : ' ,
                          WS-ACT-BAL
              WHEN 100
                 MOVE SQLCODE  TO DFHCA-RETURN-CD
                 MOVE 'DEBIT ACCOUNT/SORTCODE IS NOT VALID'
                      TO DFHCA-ERROR-MSG
              WHEN OTHER
                 MOVE SQLCODE  TO DFHCA-RETURN-CD
                 MOVE 'DATABASE ERROR - WHEN SELECT FROM ACCOUNT TABLE'
                      TO DFHCA-ERROR-MSG
           END-EVALUATE.


       GFB999.
             EXIT.