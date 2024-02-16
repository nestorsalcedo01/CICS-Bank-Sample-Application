      * Licensed Materials - Property of IBM
      *
      * (c) Copyright IBM Corp. 2017.
      *
      * US Government Users Restricted Rights - Use, duplication or
      * disclosure restricted by GSA ADP Schedule Contract
      * with IBM Corp.
          03 NEWACCNO-FUNCTION  PIC X.
          88 NEWACCNO-FUNCTION-GETNEW VALUE 'G'.
          88 NEWACCNO-FUNCTION-ROLLBACK VALUE 'R'.
          88 NEWACCNO-FUNCTION-CURRENT VALUE 'C'.
          03 ACCOUNT-NUMBER                  PIC 9(8) DISPLAY.
          03 NEWACCNO-SUCCESS                    PIC X.
          03 NEWACCNO-FAIL-CODE                  PIC X.
