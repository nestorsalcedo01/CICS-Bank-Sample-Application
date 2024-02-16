       PROCESS CICS,NODYNAM,NSYMBOL(NATIONAL),TRUNC(STD)
       CBL CICS('SP,EDF')

       IDENTIFICATION DIVISION.
       PROGRAM-ID. CONSTTST.
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
       01 WS-ERR-RET-CD                 PIC -ZZZ9.

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
           PERFORM TEST-DPAYAPI.

           EXEC CICS RETURN
           END-EXEC.

       A999.
           EXIT.

       TEST-CONSENT SECTION.
       TCT000.

           INITIALIZE WS-COMMAREA.
           DISPLAY '001 CONSENT TEST CASE : CREATE CONSENT FOR L-AMT'
           MOVE 'C'               TO  DFHCA-CONSENT-REQ.
           MOVE '98765400000001'  TO  DFHCA-CREDIT-AC.
           MOVE 'FROM CONSTTST2'  TO  DFHCA-CREDIT-AC-SCHEMENAME.
           MOVE 'ANUPRAKASH'      TO  DFHCA-CREDIT-AC-CUSTNAME.
           MOVE '98765400000002'  TO  DFHCA-DEBIT-AC.
           MOVE 'FROM CONSTTST1'  TO  DFHCA-DEBIT-AC-SCHEMENAME.
           MOVE 'ANNAPURNA'       TO  DFHCA-DEBIT-AC-CUSTNAME.
           MOVE 100000.95         TO  DFHCA-CONSENT-AMOUNT.
           MOVE 'INR'             TO  DFHCA-CURRENCY-CD.
           PERFORM TEST-CALL.
           MOVE DFHCA-CONSENT-ID  TO WS-CONSENT-ID-L.
           COMPUTE WS-CONSENT-ID-ERR = WS-CONSENT-ID-L + 1.

           INITIALIZE WS-COMMAREA.
           DISPLAY '002 CONSENT TEST CASE : GET valid CONSENT Status'
           MOVE 'G'               TO  DFHCA-CONSENT-REQ.
           MOVE WS-CONSENT-ID-L   TO  DFHCA-CONSENT-ID.
           PERFORM TEST-CALL.

           INITIALIZE WS-COMMAREA.
           DISPLAY '003 CONSENT TEST CASE : Invalid CONSENT ID'
           MOVE 'G'               TO  DFHCA-CONSENT-REQ.
           MOVE WS-CONSENT-ID-ERR TO  DFHCA-CONSENT-ID.
           PERFORM TEST-CALL.

           INITIALIZE WS-COMMAREA.
           DISPLAY '004 CONSENT TEST CASE : GET FUND AVAIL STATUS L-AMT'
           MOVE 'F'               TO  DFHCA-CONSENT-REQ.
           MOVE WS-CONSENT-ID-L   TO  DFHCA-CONSENT-ID.
           PERFORM TEST-CALL.

           INITIALIZE WS-COMMAREA.
           DISPLAY '005 CONSENT TEST CASE : INVALID CONSENT REQUEST'
           MOVE 'X'               TO  DFHCA-CONSENT-REQ.
           MOVE WS-CONSENT-ID-L   TO  DFHCA-CONSENT-ID.
           PERFORM TEST-CALL.

           DISPLAY '006 CONSENT TEST CASE : CREATE CONSENT FOR S-AMT'
           MOVE 'C'               TO  DFHCA-CONSENT-REQ.
           MOVE '98765400000001'  TO  DFHCA-CREDIT-AC.
           MOVE 'FROM CONSTTST2'  TO  DFHCA-CREDIT-AC-SCHEMENAME.
           MOVE 'ANUPRAKASH'      TO  DFHCA-CREDIT-AC-CUSTNAME.
           MOVE '98765400000002'  TO  DFHCA-DEBIT-AC.
           MOVE 'FROM CONSTTST1'  TO  DFHCA-DEBIT-AC-SCHEMENAME.
           MOVE 'ANNAPURNA'       TO  DFHCA-DEBIT-AC-CUSTNAME.
           MOVE 10.99             TO  DFHCA-CONSENT-AMOUNT.
           MOVE 'INR'             TO  DFHCA-CURRENCY-CD.
           PERFORM TEST-CALL.
           MOVE DFHCA-CONSENT-ID  TO WS-CONSENT-ID-S.

           INITIALIZE WS-COMMAREA.
           DISPLAY '007 CONSENT TEST CASE : GET FUND AVAIL STATUS S-AMT'
           MOVE 'F'               TO  DFHCA-CONSENT-REQ.
           MOVE WS-CONSENT-ID-S   TO  DFHCA-CONSENT-ID.
           PERFORM TEST-CALL.


       TCT999.
           EXIT.

       TEST-DPAYAPI SECTION.
       TD000.
           INITIALIZE WS-COMMAREA.
           DISPLAY '001 DPAYAPI TEST CASE : Domestic Pay S-AMT'.
           MOVE 'P'               TO  DFHCA-CONSENT-REQ.
           MOVE WS-CONSENT-ID-S   TO  DFHCA-CONSENT-ID.
           PERFORM TEST-CALL.

           INITIALIZE WS-COMMAREA.
           DISPLAY '002 DPAYAPI TEST CASE : Domestic Pay L-AMT'.
           MOVE 'P'               TO  DFHCA-CONSENT-REQ.
           MOVE WS-CONSENT-ID-L   TO  DFHCA-CONSENT-ID.
           PERFORM TEST-CALL.

           INITIALIZE WS-COMMAREA.
           DISPLAY '003 DPAYAPI TEST CASE : Domestic Pay Status S-AMT'.
           MOVE 'S'               TO  DFHCA-CONSENT-REQ.
           COMPUTE DFHCA-DOMESTIC-PAY-ID = WS-CONSENT-ID-S * 2 .
           PERFORM TEST-CALL.

           INITIALIZE WS-COMMAREA.
           DISPLAY '004 DPAYAPI TEST CASE : Domestic Pay Status L-AMT'.
           MOVE 'S'               TO  DFHCA-CONSENT-REQ.
           COMPUTE DFHCA-DOMESTIC-PAY-ID = WS-CONSENT-ID-L * 2 .
           PERFORM TEST-CALL.

           INITIALIZE WS-COMMAREA.
           DISPLAY '005 DPAYAPI TEST CASE : Domestic Pay S-AMT AGAIN'.
           MOVE 'P'               TO  DFHCA-CONSENT-REQ.
           MOVE WS-CONSENT-ID-S   TO  DFHCA-CONSENT-ID.
           PERFORM TEST-CALL.

           DISPLAY '006 DPAYAPI TEST CASE : Domestic Pay INVALID REQ'.
           MOVE 'X'               TO  DFHCA-CONSENT-REQ.
           MOVE 8                 TO  DFHCA-CONSENT-ID.
           PERFORM TEST-CALL.

           DISPLAY '007 DPAYAPI TEST CASE : INVALID CONSENT ID'.
           MOVE 'P'               TO  DFHCA-CONSENT-REQ.
           MOVE 9999999           TO  DFHCA-CONSENT-ID.
           PERFORM TEST-CALL.

           DISPLAY '008 DPAYAPI TEST CASE : INVALID PAYMENT ID'.
           MOVE 'S'               TO  DFHCA-CONSENT-REQ.
           MOVE 9999999           TO  DFHCA-DOMESTIC-PAY-ID.
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

           DISPLAY 'DFHCA-CONSENT-ID           :',
                                         DFHCA-CONSENT-ID
           DISPLAY 'DFHCA-CONSENT-STATUS       :',
                                         DFHCA-CONSENT-STATUS.
           DISPLAY 'DFHCA-DOMESTIC-PAY-ID      :',
                                         DFHCA-DOMESTIC-PAY-ID.
           DISPLAY 'DFHCA-DOMESTIC-PAY-STATUS  :',
                                         DFHCA-DOMESTIC-PAY-STATUS.
           DISPLAY 'DFHCA-CREDIT-AC            :',
                                         DFHCA-CREDIT-AC.
           DISPLAY 'DFHCA-CREDIT-AC-SCHEMENAME :',
                                         DFHCA-CREDIT-AC-SCHEMENAME.
           DISPLAY 'DFHCA-CREDIT-AC-CUSTNAME   :',
                                         DFHCA-CREDIT-AC-CUSTNAME.
           DISPLAY 'DFHCA-DEBIT-AC             :',
                                         DFHCA-DEBIT-AC.
           DISPLAY 'DFHCA-DEBIT-AC-SCHEMENAME  :',
                                         DFHCA-DEBIT-AC-SCHEMENAME.
           DISPLAY 'DFHCA-DEBIT-AC-CUSTNAME    :',
                                         DFHCA-DEBIT-AC-CUSTNAME.
           DISPLAY 'DFHCA-CONSENT-AMOUNT       :',
                                         DFHCA-CONSENT-AMOUNT.
           DISPLAY 'DFHCA-CURRENCY-CD          :',
                                         DFHCA-CURRENCY-CD.
           DISPLAY 'DFHCA-CREATE-TS            :',
                                         DFHCA-CREATE-TS.
           DISPLAY 'DFHCA-LAST-UPDATE-TS       :',
                                         DFHCA-LAST-UPDATE-TS.
           DISPLAY 'DFHCA-FUNDS-AVAIL-FLAG     :',
                                         DFHCA-FUNDS-AVAIL-FLAG.
           MOVE DFHCA-RETURN-CD          TO WS-ERR-RET-CD.
           DISPLAY 'DFHCA-RETURN-CD            :',  WS-ERR-RET-CD.
           DISPLAY 'DFHCA-ERROR-MSG            :',  DFHCA-ERROR-MSG.

           EXEC CICS SEND TEXT
                     FROM(DFHCA-CONSENT-ID)
                     LENGTH(LENGTH OF DFHCA-CONSENT-ID)
                     ERASE
                     FREEKB
           END-EXEC.

       TC999.
           EXIT.