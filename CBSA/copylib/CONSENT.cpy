      * Licensed Materials - Property of IBM
      *
      * (c) Copyright IBM Corp. 2015,2018.
      *
      * US Government Users Restricted Rights - Use, duplication or
      * disclosure restricted by GSA ADP Schedule Contract
      * with IBM Corp.

      ******************************************************************
      * COBOL DECLARATION FOR TABLE IBMUSER.CONSENT                    *
      ******************************************************************
              05 CONSENT-DATA.
                 10 CONSENT-ID           PIC S9(9) USAGE COMP.
                 10 CONSENT-STATUS       PIC X(1).
                 10 DOMESTIC-PAY-ID      PIC S9(9) USAGE COMP.
                 10 DOMESTIC-PAY-STATUS  PIC X(4).
                 10 CREDIT-AC.
                    15 CREDIT-AC-SORTCODE PIC X(6).
                    15 CREDIT-AC-NO      PIC X(8).
                    15 CREDIT-AC-FILLER  PIC X(2).
                 10 CREDIT-AC-SCHEMENAME PIC X(50).
                 10 CREDIT-AC-CUSTNAME   PIC X(50).
                 10 DEBIT-AC.
                    15 DEBIT-AC-SORTCODE PIC X(6).
                    15 DEBIT-AC-NO       PIC X(8).
                    15 DEBIT-AC-FILLER   PIC X(2).
                 10 DEBIT-AC-SCHEMENAME  PIC X(50).
                 10 DEBIT-AC-CUSTNAME    PIC X(50).
                 10 CONSENT-AMOUNT       PIC S9(10)V9(2) USAGE COMP-3.
                 10 CURRENCY-CD          PIC X(3).
                 10 CREATE-TS            PIC X(26).
                 10 LAST-UPDATE-TS       PIC X(26).

      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 14      *
      ******************************************************************