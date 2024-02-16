      * Licensed Materials - Property of IBM
      *
      * (c) Copyright IBM Corp. 2020.
      *
      * US Government Users Restricted Rights - Use, duplication or
      * disclosure restricted by GSA ADP Schedule Contract
      * with IBM Corp.
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