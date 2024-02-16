      * Licensed Materials - Property of IBM
      *
      * (c) Copyright IBM Corp. 2015,2018.
      *
      * US Government Users Restricted Rights - Use, duplication or
      * disclosure restricted by GSA ADP Schedule Contract
      * with IBM Corp.
           EXEC SQL DECLARE CONSENT TABLE
           ( CONSENT_ID                     INTEGER NOT NULL,
             CONSENT_STATUS                 CHAR(1),
             DOMESTIC_PAY_ID                INTEGER NOT NULL,
             DOMESTIC_PAY_STATUS            CHAR(4),
             CREDIT_AC                      CHAR(16) NOT NULL,
             CREDIT_AC_SCHEMENAME           CHAR(50),
             CREDIT_AC_CUSTNAME             CHAR(50),
             DEBIT_AC                       CHAR(16) NOT NULL,
             DEBIT_AC_SCHEMENAME            CHAR(50),
             DEBIT_AC_CUSTNAME              CHAR(50),
             CONSENT_AMOUNT                 DECIMAL(12, 2),
             CURRENCY_CD                    CHAR(3),
             CREATE_TS                      TIMESTAMP NOT NULL,
             LAST_UPDATE_TS                 TIMESTAMP NOT NULL
           ) END-EXEC.