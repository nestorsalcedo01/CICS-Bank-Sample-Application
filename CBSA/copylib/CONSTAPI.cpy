      * Licensed Materials - Property of IBM
      *
      * (c) Copyright IBM Corp. 2017.
      *
      * US Government Users Restricted Rights - Use, duplication or
      * disclosure restricted by GSA ADP Schedule Contract
      * with IBM Corp.
           10 DFHCA-CONSENT-REQ          PIC X(1).
           10 DFHCA-CONSENT-ID           PIC 9(9).
           10 DFHCA-CONSENT-STATUS       PIC X(1).
           10 DFHCA-DOMESTIC-PAY-ID      PIC 9(9).
           10 DFHCA-DOMESTIC-PAY-STATUS  PIC X(4).
           10 DFHCA-CREDIT-AC            PIC X(16).
           10 DFHCA-CREDIT-AC-SCHEMENAME PIC X(50).
           10 DFHCA-CREDIT-AC-CUSTNAME   PIC X(50).
           10 DFHCA-DEBIT-AC             PIC X(16).
           10 DFHCA-DEBIT-AC-SCHEMENAME  PIC X(50).
           10 DFHCA-DEBIT-AC-CUSTNAME    PIC X(50).
           10 DFHCA-CONSENT-AMOUNT       PIC S9(10)V99.
           10 DFHCA-CURRENCY-CD          PIC X(3).
           10 DFHCA-CHARGES.
              15 DFHCA-CHARGE-BEARER     PIC X(20).
              15 DFHCA-CHARGE-TYPE       PIC X(20).
              15 DFHCA-CHARGE-AMOUNT.
                 20 DFHCA-CHARGE-AMT     PIC S9(10)v99.
                 20 DFHCA-CHARGE-CUR-CD  PIC X(3).
           10 DFHCA-CREATE-TS            PIC X(32).
           10 DFHCA-LAST-UPDATE-TS       PIC X(32).
           10 DFHCA-FUNDS-AVAIL-FLAG     PIC X(1).
           10 DFHCA-RETURN-CD            PIC S9(4).
           10 DFHCA-ERROR-MSG            PIC X(200).
