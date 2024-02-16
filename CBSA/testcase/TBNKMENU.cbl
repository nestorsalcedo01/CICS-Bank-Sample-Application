       PROCESS NODLL,NODYNAM,TEST(NOSEP),NOCICS,NOSQL,PGMN(LU)
      *+---------------------------------------------------------------+
      *| TBNKMENU                                                      |
      *| PRODUCT: IBM DEVELOPER FOR Z/OS                               |
      *| COMPONENT: IBM Z/OS AUTOMATED UNIT TESTING FRAMEWORK (ZUNIT)  |
      *|   FOR ENTERPRISE COBOL AND PL/I                               |
      *| PROGRAM: ENTERPRISE COBOL ZUNIT TEST CASE FOR DYNAMIC RUNNER  |
      *| DATE GENERATED: 10/11/2022 17:19                              |
      *| ID: 958b1790-1a36-4e5a-a00f-8a4ee1d4a235                      |
      *+---------------------------------------------------------------+
      *+---------------------------------------------------------------+
      *| TEST_TEST2                                                    |
      *|     THIS PROGRAM IS FOR TEST TEST2                            |
      *+---------------------------------------------------------------+
       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'TEST_TEST2'.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 PROGRAM-NAME   PIC X(8)  VALUE 'BNKMENU'.
       01 BZ-ASSERT.
         03 MESSAGE-LEN PIC S9(4) COMP-4 VALUE 24.
         03 MESSAGE-TXT PIC X(254) VALUE 'HELLO FROM TEST CALLBACK'.
       01  BZ-P1 PIC S9(9) COMP-4 VALUE 4.
       01  BZ-P2 PIC S9(9) COMP-4 VALUE 2001.
       01  BZ-P3 PIC X(3) VALUE 'AZU'.
       01 BZ-TRACE.
         03 TRACE-LEN       PIC S9(4) COMP-4 VALUE 5.
         03 TRACE-TXT       PIC X(254) VALUE 'TRACE'.
       01 BZUASSRT          PIC X(8) VALUE 'BZUASSRT'.
       01 BZUTRACE          PIC X(8) VALUE 'BZUTRACE'.
       01 AZ-TRACE-PTR      POINTER.
       01 ASSERT-ST.
         03 ASSERT-RC PIC 9(9) BINARY VALUE 4.
         03 ASSERT-TEXT PIC 9(4) BINARY VALUE 0.
       01 AZ-TEST-NAME-LEN       PIC S9(9) COMP-5.
       01 AZ-RC-WORK             PIC S9(4) USAGE BINARY.
       LOCAL-STORAGE SECTION.
       LINKAGE SECTION.
       01 AZ-TEST                   PIC X(80).
       01 AZ-ARG-LIST.
         03 ARG-LENGTH PIC 9(4) COMP-4.
         03 ARG-DATA PIC X(256).
      *  *** DFHEIBLK : ZUT000000A1
       1 ZUT000000A1.
      *    *** EIBTIME : ZUT000000A2
         2 ZUT000000A2 PICTURE S9(7) USAGE COMPUTATIONAL-3.
      *    *** EIBDATE : ZUT000000A3
         2 ZUT000000A3 PICTURE S9(7) USAGE COMPUTATIONAL-3.
      *    *** EIBTRNID : ZUT000000A4
         2 ZUT000000A4 PICTURE X(4).
      *    *** EIBTASKN : ZUT000000A5
         2 ZUT000000A5 PICTURE S9(7) USAGE COMPUTATIONAL-3.
      *    *** EIBTRMID : ZUT000000A6
         2 ZUT000000A6 PICTURE X(4).
      *    *** DFHEIGDI : ZUT000000A7
         2 ZUT000000A7 PICTURE S9(4) USAGE COMPUTATIONAL-5.
      *    *** EIBCPOSN : ZUT000000A8
         2 ZUT000000A8 PICTURE S9(4) USAGE COMPUTATIONAL-5.
      *    *** EIBCALEN : ZUT000000A9
         2 ZUT000000A9 PICTURE S9(4) USAGE COMPUTATIONAL-5.
      *    *** EIBAID : ZUT000000AA
         2 ZUT000000AA PICTURE X(1).
      *    *** EIBFN : ZUT000000AB
         2 ZUT000000AB PICTURE X(2).
      *    *** EIBRCODE : ZUT000000AC
         2 ZUT000000AC PICTURE X(6).
      *    *** EIBDS : ZUT000000AD
         2 ZUT000000AD PICTURE X(8).
      *    *** EIBREQID : ZUT000000AE
         2 ZUT000000AE PICTURE X(8).
      *    *** EIBRSRCE : ZUT000000AF
         2 ZUT000000AF PICTURE X(8).
      *    *** EIBSYNC : ZUT000000B0
         2 ZUT000000B0 PICTURE X.
      *    *** EIBFREE : ZUT000000B1
         2 ZUT000000B1 PICTURE X.
      *    *** EIBRECV : ZUT000000B2
         2 ZUT000000B2 PICTURE X.
      *    *** EIBSEND : ZUT000000B3
         2 ZUT000000B3 PICTURE X.
      *    *** EIBATT : ZUT000000B4
         2 ZUT000000B4 PICTURE X.
      *    *** EIBEOC : ZUT000000B5
         2 ZUT000000B5 PICTURE X.
      *    *** EIBFMH : ZUT000000B6
         2 ZUT000000B6 PICTURE X.
      *    *** EIBCOMPL : ZUT000000B7
         2 ZUT000000B7 PICTURE X(1).
      *    *** EIBSIG : ZUT000000B8
         2 ZUT000000B8 PICTURE X(1).
      *    *** EIBCONF : ZUT000000B9
         2 ZUT000000B9 PICTURE X(1).
      *    *** EIBERR : ZUT000000BA
         2 ZUT000000BA PICTURE X(1).
      *    *** EIBERRCD : ZUT000000BB
         2 ZUT000000BB PICTURE X(4).
      *    *** EIBSYNRB : ZUT000000BC
         2 ZUT000000BC PICTURE X.
      *    *** EIBNODAT : ZUT000000BD
         2 ZUT000000BD PICTURE X.
      *    *** EIBRESP : ZUT000000BE
         2 ZUT000000BE PICTURE S9(8) USAGE COMPUTATIONAL.
      *    *** EIBRESP2 : ZUT000000BF
         2 ZUT000000BF PICTURE S9(8) USAGE COMPUTATIONAL.
      *    *** EIBRLDBK : ZUT000000C0
         2 ZUT000000C0 PICTURE X(1).
      *  *** DFHCOMMAREA : ZUT000000C1
       1 ZUT000000C1 PIC X.
       PROCEDURE DIVISION USING AZ-TEST
           ZUT000000A1 ZUT000000C1.
      * START
           DISPLAY 'TEST_TEST2 STARTED...'
           MOVE 0 TO AZ-TEST-NAME-LEN.
           INSPECT AZ-TEST TALLYING AZ-TEST-NAME-LEN FOR
           CHARACTERS BEFORE INITIAL SPACE.
      * INITIALIZE PARAMETER
           PERFORM INITIALIZE-PARM
      * SET AREA ADDRESS TO POINTER
      * SET INPUT VALUE
           MOVE 0 TO RETURN-CODE.
      * CALL TEST PROGRAM
           DISPLAY 'CALL BNKMENU'
           CALL PROGRAM-NAME
           USING ZUT000000A1 ZUT000000C1
           .
      * EVALUATE OUTPUT VALUE
           MOVE 4 TO RETURN-CODE
      * END
           DISPLAY 'TEST_TEST2 SUCCESSFUL.'
           GOBACK.
       INITIALIZE-PARM.
           EXIT.
       END PROGRAM TEST_TEST2.
      *+---------------------------------------------------------------+
      *| BZU_TEST                                                      |
      *|     THIS PROGRAM IS CALLBACK DEFINITION FOR TEST              |
      *+---------------------------------------------------------------+
       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'BZU_TEST'.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 PROGRAM-NAME   PIC X(8)  VALUE 'BNKMENU'.
       01 BZ-ASSERT.
         03 MESSAGE-LEN PIC S9(4) COMP-4 VALUE 24.
         03 MESSAGE-TXT PIC X(254) VALUE 'HELLO FROM TEST CALLBACK'.
       01  BZ-P1 PIC S9(9) COMP-4 VALUE 4.
       01  BZ-P2 PIC S9(9) COMP-4 VALUE 2001.
       01  BZ-P3 PIC X(3) VALUE 'AZU'.
       01 BZ-TRACE.
         03 TRACE-LEN       PIC S9(4) COMP-4 VALUE 5.
         03 TRACE-TXT       PIC X(254) VALUE 'TRACE'.
       01 BZUASSRT          PIC X(8) VALUE 'BZUASSRT'.
       01 BZUTRACE          PIC X(8) VALUE 'BZUTRACE'.
       01 AZ-TRACE-PTR      POINTER.
       01 ASSERT-ST.
         03 ASSERT-RC PIC 9(9) BINARY VALUE 4.
         03 ASSERT-TEXT PIC 9(4) BINARY VALUE 0.
       01 AZ-TEST-NAME-LEN       PIC S9(9) COMP-5.
       LOCAL-STORAGE SECTION.
       LINKAGE SECTION.
       01 AZ-TEST                   PIC X(80).
       01 AZ-INFO-BLOCK.
          COPY BZUITERC.
       01 AZ-ARG-LIST.
         03 ARG-LENGTH PIC 9(4) COMP-4.
         03 ARG-DATA PIC X(256).
      *  *** DFHEIBLK : ZUT000000A1
       1 ZUT000000A1.
      *    *** EIBTIME : ZUT000000A2
         2 ZUT000000A2 PICTURE S9(7) USAGE COMPUTATIONAL-3.
      *    *** EIBDATE : ZUT000000A3
         2 ZUT000000A3 PICTURE S9(7) USAGE COMPUTATIONAL-3.
      *    *** EIBTRNID : ZUT000000A4
         2 ZUT000000A4 PICTURE X(4).
      *    *** EIBTASKN : ZUT000000A5
         2 ZUT000000A5 PICTURE S9(7) USAGE COMPUTATIONAL-3.
      *    *** EIBTRMID : ZUT000000A6
         2 ZUT000000A6 PICTURE X(4).
      *    *** DFHEIGDI : ZUT000000A7
         2 ZUT000000A7 PICTURE S9(4) USAGE COMPUTATIONAL-5.
      *    *** EIBCPOSN : ZUT000000A8
         2 ZUT000000A8 PICTURE S9(4) USAGE COMPUTATIONAL-5.
      *    *** EIBCALEN : ZUT000000A9
         2 ZUT000000A9 PICTURE S9(4) USAGE COMPUTATIONAL-5.
      *    *** EIBAID : ZUT000000AA
         2 ZUT000000AA PICTURE X(1).
      *    *** EIBFN : ZUT000000AB
         2 ZUT000000AB PICTURE X(2).
      *    *** EIBRCODE : ZUT000000AC
         2 ZUT000000AC PICTURE X(6).
      *    *** EIBDS : ZUT000000AD
         2 ZUT000000AD PICTURE X(8).
      *    *** EIBREQID : ZUT000000AE
         2 ZUT000000AE PICTURE X(8).
      *    *** EIBRSRCE : ZUT000000AF
         2 ZUT000000AF PICTURE X(8).
      *    *** EIBSYNC : ZUT000000B0
         2 ZUT000000B0 PICTURE X.
      *    *** EIBFREE : ZUT000000B1
         2 ZUT000000B1 PICTURE X.
      *    *** EIBRECV : ZUT000000B2
         2 ZUT000000B2 PICTURE X.
      *    *** EIBSEND : ZUT000000B3
         2 ZUT000000B3 PICTURE X.
      *    *** EIBATT : ZUT000000B4
         2 ZUT000000B4 PICTURE X.
      *    *** EIBEOC : ZUT000000B5
         2 ZUT000000B5 PICTURE X.
      *    *** EIBFMH : ZUT000000B6
         2 ZUT000000B6 PICTURE X.
      *    *** EIBCOMPL : ZUT000000B7
         2 ZUT000000B7 PICTURE X(1).
      *    *** EIBSIG : ZUT000000B8
         2 ZUT000000B8 PICTURE X(1).
      *    *** EIBCONF : ZUT000000B9
         2 ZUT000000B9 PICTURE X(1).
      *    *** EIBERR : ZUT000000BA
         2 ZUT000000BA PICTURE X(1).
      *    *** EIBERRCD : ZUT000000BB
         2 ZUT000000BB PICTURE X(4).
      *    *** EIBSYNRB : ZUT000000BC
         2 ZUT000000BC PICTURE X.
      *    *** EIBNODAT : ZUT000000BD
         2 ZUT000000BD PICTURE X.
      *    *** EIBRESP : ZUT000000BE
         2 ZUT000000BE PICTURE S9(8) USAGE COMPUTATIONAL.
      *    *** EIBRESP2 : ZUT000000BF
         2 ZUT000000BF PICTURE S9(8) USAGE COMPUTATIONAL.
      *    *** EIBRLDBK : ZUT000000C0
         2 ZUT000000C0 PICTURE X(1).
      *  *** DFHCOMMAREA : ZUT000000C1
       1 ZUT000000C1 PIC X.
       PROCEDURE DIVISION.
      * SET INPUT VALUE
           ENTRY "PGM_INPT_BNKMENU" USING AZ-TEST AZ-INFO-BLOCK
           ZUT000000A1 ZUT000000C1.
           DISPLAY 'PGM_INPT_BNKMENU INPUT VALUES...'.
           MOVE 0 TO RETURN-CODE.
           INSPECT AZ-TEST TALLYING AZ-TEST-NAME-LEN FOR CHARACTERS
             BEFORE INITIAL SPACE.
           EVALUATE AZ-TEST(1:AZ-TEST-NAME-LEN)
           WHEN SPACE
             CONTINUE
           WHEN OTHER
             CONTINUE
           END-EVALUATE.
           PERFORM TEARDOWN.
      * EVALUATE OUTPUT VALUE
           ENTRY "PGM_OUTP_BNKMENU" USING AZ-TEST AZ-INFO-BLOCK
           ZUT000000A1 ZUT000000C1.
           DISPLAY 'PGM_OUTP_BNKMENU CHECK VALUES...'.
           MOVE 4 TO RETURN-CODE.
           INSPECT AZ-TEST TALLYING AZ-TEST-NAME-LEN FOR CHARACTERS
             BEFORE INITIAL SPACE.
           EVALUATE AZ-TEST(1:AZ-TEST-NAME-LEN)
           WHEN SPACE
             CONTINUE
           WHEN 'TEST2'
             MOVE 4 TO RETURN-CODE
           WHEN OTHER
             CONTINUE
           END-EVALUATE.
           PERFORM TEARDOWN.
       TEARDOWN.
           DISPLAY 'BZU_TEST SUCCESSFUL.'
           GOBACK.
       END PROGRAM BZU_TEST.
      *+---------------------------------------------------------------+
      *| BZU_INIT                                                      |
      *|     INITIAL PROCEDURE                                         |
      *+---------------------------------------------------------------+
       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'BZU_INIT'.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 AZ-TEST-NAME-LEN      PIC S9(9) COMP-5.
       01 AZ-TESTCASE-ID        PIC X(36)
           VALUE '958b1790-1a36-4e5a-a00f-8a4ee1d4a235'.
       LINKAGE SECTION.
       01 AZ-TEST               PIC X(80).
       01 AZ-TEST-ID            PIC X(80).
       PROCEDURE DIVISION USING AZ-TEST AZ-TEST-ID.
           MOVE 0 TO AZ-TEST-NAME-LEN.
           INSPECT AZ-TEST TALLYING AZ-TEST-NAME-LEN FOR
           CHARACTERS BEFORE INITIAL SPACE.
           DISPLAY 'BZU_INIT : ' AZ-TEST(1:AZ-TEST-NAME-LEN)
           MOVE AZ-TESTCASE-ID TO AZ-TEST-ID
           GOBACK.
       END PROGRAM BZU_INIT.
      *+---------------------------------------------------------------+
      *| BZU_TERM                                                      |
      *|     TERMINATION PROCEDURE                                     |
      *+---------------------------------------------------------------+
       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'BZU_TERM'.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 AZ-TEST-NAME-LEN      PIC S9(9) COMP-5.
       LINKAGE SECTION.
       01 AZ-TEST               PIC X(80).
       PROCEDURE DIVISION USING AZ-TEST.
           MOVE 0 TO AZ-TEST-NAME-LEN.
           INSPECT AZ-TEST TALLYING AZ-TEST-NAME-LEN FOR
           CHARACTERS BEFORE INITIAL SPACE.
           DISPLAY 'BZU_TERM : ' AZ-TEST(1:AZ-TEST-NAME-LEN)
           GOBACK.
       END PROGRAM BZU_TERM.
      *+---------------------------------------------------------------+
      *| EVALOPT                                                       |
      *|   FUNCTION TO EVALUATE THAT THE BIT OF OPTION DATA            |
      *|   (1) TAKE AND OF GROUP COMMON MASK AND OPTION IN ARG0        |
      *|   (2) CHECK IF THE GROUP MASK IS EQUAL TO (1)                 |
      *|       IF EQUAL,    RTN01 IS 0                                 |
      *|       IF NO EQUAL, RTN01 IS 1                                 |
      *+---------------------------------------------------------------+
       ID DIVISION.
       PROGRAM-ID. EVALOPT.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  OUT1-REC.
         05 OUT1-DATA                PIC X(1) OCCURS 8.
       01 OUT1-DATA-R REDEFINES OUT1-REC.
         05 OUT1-DATA-UP             PIC X(4).
         05 OUT1-DATA-DOWN           PIC X(4).
       01  OUT2-REC.
         05  OUT2-DATA               PIC X(1) OCCURS 8.
       01  OUT2-DATA-R REDEFINES OUT2-REC.
         05 OUT2-DATA-UP             PIC X(4).
         05 OUT2-DATA-DOWN           PIC X(4).
       01  WORK1-REC.
         05  WORK1-DATA              PIC X(1) OCCURS 8.
       01  WORK1-DATA-R REDEFINES WORK1-REC.
         05 WORK1-DATA-UP            PIC X(4).
         05 WORK1-DATA-DOWN          PIC X(4).
       01  WORK-AREA.
         05  WORK-HEX-UP             PIC 9(4)  COMP.
         05  WORK-HEX-DOWN           PIC 9(4)  COMP.
       01  HEX-CHG-BEF.
         05  HEX-CHANGE-LV           PIC X(1) VALUE LOW-VALUE.
         05  HEX-CHANGE-BEFORE       PIC X(1).
       01  HEX-CHG-AFT      REDEFINES  HEX-CHG-BEF.
         05  HEX-CHANGE-AFTER        PIC 9(4)  COMP.
       01  TBL-CHANGE-DATA.
          05  FILLER                 PIC  X(004) VALUE '0000'.
          05  FILLER                 PIC  X(001) VALUE '0'.
          05  FILLER                 PIC  X(004) VALUE '0001'.
          05  FILLER                 PIC  X(001) VALUE '1'.
          05  FILLER                 PIC  X(004) VALUE '0010'.
          05  FILLER                 PIC  X(001) VALUE '2'.
          05  FILLER                 PIC  X(004) VALUE '0011'.
          05  FILLER                 PIC  X(001) VALUE '3'.
          05  FILLER                 PIC  X(004) VALUE '0100'.
          05  FILLER                 PIC  X(001) VALUE '4'.
          05  FILLER                 PIC  X(004) VALUE '0101'.
          05  FILLER                 PIC  X(001) VALUE '5'.
          05  FILLER                 PIC  X(004) VALUE '0110'.
          05  FILLER                 PIC  X(001) VALUE '6'.
          05  FILLER                 PIC  X(004) VALUE '0111'.
          05  FILLER                 PIC  X(001) VALUE '7'.
          05  FILLER                 PIC  X(004) VALUE '1000'.
          05  FILLER                 PIC  X(001) VALUE '8'.
          05  FILLER                 PIC  X(004) VALUE '1001'.
          05  FILLER                 PIC  X(001) VALUE '9'.
          05  FILLER                 PIC  X(004) VALUE '1010'.
          05  FILLER                 PIC  X(001) VALUE 'A'.
          05  FILLER                 PIC  X(004) VALUE '1011'.
          05  FILLER                 PIC  X(001) VALUE 'B'.
          05  FILLER                 PIC  X(004) VALUE '1100'.
          05  FILLER                 PIC  X(001) VALUE 'C'.
          05  FILLER                 PIC  X(004) VALUE '1101'.
          05  FILLER                 PIC  X(001) VALUE 'D'.
          05  FILLER                 PIC  X(004) VALUE '1110'.
          05  FILLER                 PIC  X(001) VALUE 'E'.
          05  FILLER                 PIC  X(004) VALUE '1111'.
          05  FILLER                 PIC  X(001) VALUE 'F'.
          01  TBL-DATA REDEFINES TBL-CHANGE-DATA.
           05  TBL-CHG  OCCURS  16 TIMES.
             10  TBL-BIT-CHAR        PIC  X(004).
             10  TBL-HEX-CHAR        PIC  X(001).
       01 BIT-COUNT                  PIC 9(1).
       01 I                          PIC S9(8) COMP.
       LINKAGE SECTION.
       01 G-MASK.
         03 D-G-MASK                 PIC X(1) OCCURS 19.
       01 COM-MASK.
         03 D-COM-MASK               PIC X(1) OCCURS 19.
       01 O-ARG0.
         03 D-O-ARG0                 PIC X(1) OCCURS 19.
       01 BYTE-COUNT                 PIC S9(8) COMP.
       01 RTN01                      PIC 9(1).
       PROCEDURE DIVISION USING G-MASK COM-MASK O-ARG0 BYTE-COUNT
            RTN01.
            MOVE 0 TO RTN01
            PERFORM VARYING I FROM 1 BY 1 UNTIL I > BYTE-COUNT
              PERFORM ANDCOMMASK
              IF RTN01 = 1 THEN
                GOBACK
              END-IF
            END-PERFORM.
            EXIT PROGRAM.
       ANDCOMMASK.
      * CONVERT GROUP COMMON MASK TO BIT
            MOVE D-COM-MASK(I) TO HEX-CHANGE-BEFORE.
            DIVIDE 16 INTO HEX-CHANGE-AFTER GIVING WORK-HEX-UP
                                         REMAINDER WORK-HEX-DOWN.
            MOVE TBL-BIT-CHAR(WORK-HEX-UP + 1)   TO OUT1-DATA-UP.
            MOVE TBL-BIT-CHAR(WORK-HEX-DOWN + 1) TO OUT1-DATA-DOWN.
      * CONVERT OPTION IN ARG0 TO BIT
            MOVE D-O-ARG0(I) TO HEX-CHANGE-BEFORE.
            DIVIDE 16 INTO HEX-CHANGE-AFTER GIVING WORK-HEX-UP
                                         REMAINDER WORK-HEX-DOWN.
            MOVE TBL-BIT-CHAR(WORK-HEX-UP + 1)   TO OUT2-DATA-UP.
            MOVE TBL-BIT-CHAR(WORK-HEX-DOWN + 1) TO OUT2-DATA-DOWN.
      * CREATE EVAL BIT FROM GROUP COMMON MASK BIT AND ARG0 BIT
            PERFORM VARYING BIT-COUNT FROM 1 BY 1 UNTIL BIT-COUNT > 8
              IF OUT1-DATA(BIT-COUNT) = '1' AND
                 OUT2-DATA(BIT-COUNT) = '1' THEN
                MOVE '1' TO WORK1-DATA(BIT-COUNT)
              ELSE
                MOVE '0' TO WORK1-DATA(BIT-COUNT)
              END-IF
            END-PERFORM.
      * CONVERT GROUP MASK TO BIT DATA
            MOVE D-G-MASK(I) TO HEX-CHANGE-BEFORE.
            DIVIDE 16 INTO HEX-CHANGE-AFTER GIVING WORK-HEX-UP
                                         REMAINDER WORK-HEX-DOWN.
            MOVE TBL-BIT-CHAR(WORK-HEX-UP + 1)   TO OUT1-DATA-UP.
            MOVE TBL-BIT-CHAR(WORK-HEX-DOWN + 1) TO OUT1-DATA-DOWN.
      * CHECK IF EQUAL BETWEEN EVAL BIT AND GROUP MASK BIT
            IF WORK1-DATA-UP = OUT1-DATA-UP AND
               WORK1-DATA-DOWN = OUT1-DATA-DOWN THEN
              CONTINUE
            ELSE
              MOVE 1 TO RTN01
            END-IF
            EXIT.
       END PROGRAM 'EVALOPT'.
      *+---------------------------------------------------------------+
      *| GTMEMRC                                                       |
      *|     GET DATA AREA FOR RECORD COUNT OF SUBSYSTEM GROUP         |
      *+---------------------------------------------------------------+
       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'GTMEMRC'.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 BZUGTMEM            PIC X(8) VALUE 'BZUGTMEM'.
       01 DATA-SIZE           PIC 9(8) COMP-4.
       LINKAGE SECTION.
       01 TC-WORK-AREA        PIC X(256).
       01 AZ-GRP-INDEX        PIC 9(8).
       01 AZ-FLAG-IN          PIC 9(1).
       01 AZ-RECORD-PTR       POINTER.
       01 AZ-RECORD-PTR-VALUE
            REDEFINES AZ-RECORD-PTR  PIC S9(9) COMP-5.
       01 DATA-PTR            POINTER.
       01 DATA-PTR-VALUE
            REDEFINES DATA-PTR  PIC S9(9) COMP-5.
       01 DATA-AREA.
         03 RECORD-COUNT-IO OCCURS 12.
           05 RECORD-COUNT-OT PIC 9(5) COMP-5.
           05 RECORD-COUNT-IN PIC 9(5) COMP-5.
       01 WK-RECORD-COUNT     PIC 9(5) COMP-5.
       PROCEDURE DIVISION USING TC-WORK-AREA AZ-GRP-INDEX AZ-FLAG-IN
           AZ-RECORD-PTR.
           SET ADDRESS OF DATA-PTR TO ADDRESS OF TC-WORK-AREA.
           IF DATA-PTR-VALUE = 0 THEN
             COMPUTE DATA-SIZE = LENGTH OF WK-RECORD-COUNT * 2 * 12
             CALL BZUGTMEM USING DATA-SIZE RETURNING DATA-PTR
             SET ADDRESS OF DATA-AREA TO DATA-PTR
             DISPLAY 'AREA ALLOCATED FOR RECORD COUNT:' DATA-SIZE
           END-IF
           SET AZ-RECORD-PTR TO DATA-PTR
           COMPUTE AZ-RECORD-PTR-VALUE = AZ-RECORD-PTR-VALUE +
                 LENGTH OF WK-RECORD-COUNT * 2 * (AZ-GRP-INDEX - 1)
           IF AZ-FLAG-IN = 1 THEN
             ADD LENGTH OF WK-RECORD-COUNT TO AZ-RECORD-PTR-VALUE
           END-IF
           SET ADDRESS OF WK-RECORD-COUNT TO AZ-RECORD-PTR
           GOBACK.
       END PROGRAM 'GTMEMRC'.
      *+---------------------------------------------------------------+
      *| AZU_GENERIC_CICS                                              |
      *|   GENERIC CICS CALLBACK EXIT POINT                            |
      *+---------------------------------------------------------------+
       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'AZU_GENERIC_CICS'.
       PROCEDURE DIVISION.
      * CHECK OUTPUT VALUE
      * CICS_INPT.
           ENTRY 'CICS_INPT'.
           DISPLAY 'CICS_INPT ...'
           MOVE 4 TO RETURN-CODE.
           GOBACK.
      * CICS_OUTP.
           ENTRY 'CICS_OUTP'.
           DISPLAY 'CICS_OUTP ...'
           MOVE 4 TO RETURN-CODE.
           GOBACK.
      * CICS_INPT_0E08 FOR RETURN.
           ENTRY 'CICS_INPT_0E08'.
           DISPLAY 'CICS_INPT_0E08 ...'
           MOVE 0 TO RETURN-CODE.
           GOBACK.
       END PROGRAM 'AZU_GENERIC_CICS'.
