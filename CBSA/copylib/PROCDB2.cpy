      * Licensed Materials - Property of IBM
      *
      * (c) Copyright IBM Corp. 2015,2018.
      *
      * US Government Users Restricted Rights - Use, duplication or
      * disclosure restricted by GSA ADP Schedule Contract
      * with IBM Corp.
           EXEC SQL DECLARE PROCTRAN TABLE
              (
               PROCTRAN_EYECATCHER             CHAR(4),
               PROCTRAN_SORTCODE               CHAR(6) NOT NULL,
               PROCTRAN_NUMBER                 CHAR(8) NOT NULL,
               PROCTRAN_DATE                   CHAR(8),
               PROCTRAN_TIME                   CHAR(6),
               PROCTRAN_REF                    CHAR(12),
               PROCTRAN_TYPE                   CHAR(3),
               PROCTRAN_DESC                   CHAR(40),
               PROCTRAN_AMOUNT                 DECIMAL(12, 2)
              )
           END-EXEC.
