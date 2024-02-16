       CBL CICS('SP,EDF')
      ******************************************************************
      *                                                                *
      * Licensed Materials - Property of IBM                           *
      *                                                                *
      * (c) Copyright IBM Corp. 2016,2020.                             *
      *                                                                *
      * US Government Users Restricted Rights - Use, duplication or    *
      * disclosure restricted by GSA ADP Schedule Contract with        *
      * IBM Corp.                                                      *
      *                                                                *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. GETSCODE.
       AUTHOR. James O'Grady.


       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
      *SOURCE-COMPUTER.   IBM-370 WITH DEBUGGING MODE.
       SOURCE-COMPUTER.  IBM-370.
       OBJECT-COMPUTER.  IBM-370.

       INPUT-OUTPUT SECTION.


       DATA DIVISION.
       FILE SECTION.


       WORKING-STORAGE SECTION.
      * Copyright statement as a literal to go into the load module
       77 FILLER PIC X(80) VALUE
           'Licensed Materials - Property of IBM'.
       77 FILLER PIC X(80) VALUE
           '(c) Copyright IBM Corp. 2016,2020. All Rights Reserved.'.
       77 FILLER PIC X(80) VALUE
           'US Government Users Restricted Rights - Use, duplication '.
       77 FILLER PIC X(80) VALUE
           'or disclosure restricted by GSA ADP Schedule Contract '.
       77 FILLER PIC X(80) VALUE
           'with IBM Corp.'.

       COPY SORTCODE REPLACING ==SORTCODE== BY ==LITERAL-SORTCODE==.


       LINKAGE SECTION.
       01 DFHCOMMAREA.
           COPY GETSCODE.


       PROCEDURE DIVISION USING DFHCOMMAREA.
       PREMIERE SECTION.
       A010.
           MOVE LITERAL-SORTCODE
           TO SORTCODE OF DFHCOMMAREA.


           EXEC CICS RETURN
           END-EXEC.

           GOBACK.

