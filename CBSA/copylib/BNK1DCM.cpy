       01  BNK1DCI.
           02  FILLER PIC X(12).
           02  COMPANYL    COMP  PIC  S9(4).
           02  COMPANYF    PICTURE X.
           02  FILLER REDEFINES COMPANYF.
             03 COMPANYA    PICTURE X.
           02  FILLER   PICTURE X(6).
           02  COMPANYI  PIC X(52).
           02  CUSTNOL    COMP  PIC  S9(4).
           02  CUSTNOF    PICTURE X.
           02  FILLER REDEFINES CUSTNOF.
             03 CUSTNOA    PICTURE X.
           02  FILLER   PICTURE X(6).
           02  CUSTNOI  PIC X(10).
           02  SORTCL    COMP  PIC  S9(4).
           02  SORTCF    PICTURE X.
           02  FILLER REDEFINES SORTCF.
             03 SORTCA    PICTURE X.
           02  FILLER   PICTURE X(6).
           02  SORTCI  PIC X(6).
           02  CUSTNO2L    COMP  PIC  S9(4).
           02  CUSTNO2F    PICTURE X.
           02  FILLER REDEFINES CUSTNO2F.
             03 CUSTNO2A    PICTURE X.
           02  FILLER   PICTURE X(6).
           02  CUSTNO2I  PIC X(10).
           02  CUSTNAML    COMP  PIC  S9(4).
           02  CUSTNAMF    PICTURE X.
           02  FILLER REDEFINES CUSTNAMF.
             03 CUSTNAMA    PICTURE X.
           02  FILLER   PICTURE X(6).
           02  CUSTNAMI  PIC X(60).
           02  CUSTAD1L    COMP  PIC  S9(4).
           02  CUSTAD1F    PICTURE X.
           02  FILLER REDEFINES CUSTAD1F.
             03 CUSTAD1A    PICTURE X.
           02  FILLER   PICTURE X(6).
           02  CUSTAD1I  PIC X(60).
           02  CUSTAD2L    COMP  PIC  S9(4).
           02  CUSTAD2F    PICTURE X.
           02  FILLER REDEFINES CUSTAD2F.
             03 CUSTAD2A    PICTURE X.
           02  FILLER   PICTURE X(6).
           02  CUSTAD2I  PIC X(60).
           02  CUSTAD3L    COMP  PIC  S9(4).
           02  CUSTAD3F    PICTURE X.
           02  FILLER REDEFINES CUSTAD3F.
             03 CUSTAD3A    PICTURE X.
           02  FILLER   PICTURE X(6).
           02  CUSTAD3I  PIC X(40).
           02  DOBDDL    COMP  PIC  S9(4).
           02  DOBDDF    PICTURE X.
           02  FILLER REDEFINES DOBDDF.
             03 DOBDDA    PICTURE X.
           02  FILLER   PICTURE X(6).
           02  DOBDDI  PIC X(2).
           02  DOBMML    COMP  PIC  S9(4).
           02  DOBMMF    PICTURE X.
           02  FILLER REDEFINES DOBMMF.
             03 DOBMMA    PICTURE X.
           02  FILLER   PICTURE X(6).
           02  DOBMMI  PIC X(2).
           02  DOBYYL    COMP  PIC  S9(4).
           02  DOBYYF    PICTURE X.
           02  FILLER REDEFINES DOBYYF.
             03 DOBYYA    PICTURE X.
           02  FILLER   PICTURE X(6).
           02  DOBYYI  PIC X(4).
           02  CREDSCL    COMP  PIC  S9(4).
           02  CREDSCF    PICTURE X.
           02  FILLER REDEFINES CREDSCF.
             03 CREDSCA    PICTURE X.
           02  FILLER   PICTURE X(6).
           02  CREDSCI  PIC X(3).
           02  SCRDTDDL    COMP  PIC  S9(4).
           02  SCRDTDDF    PICTURE X.
           02  FILLER REDEFINES SCRDTDDF.
             03 SCRDTDDA    PICTURE X.
           02  FILLER   PICTURE X(6).
           02  SCRDTDDI  PIC X(2).
           02  SCRDTMML    COMP  PIC  S9(4).
           02  SCRDTMMF    PICTURE X.
           02  FILLER REDEFINES SCRDTMMF.
             03 SCRDTMMA    PICTURE X.
           02  FILLER   PICTURE X(6).
           02  SCRDTMMI  PIC X(2).
           02  SCRDTYYL    COMP  PIC  S9(4).
           02  SCRDTYYF    PICTURE X.
           02  FILLER REDEFINES SCRDTYYF.
             03 SCRDTYYA    PICTURE X.
           02  FILLER   PICTURE X(6).
           02  SCRDTYYI  PIC X(4).
           02  MESSAGEL    COMP  PIC  S9(4).
           02  MESSAGEF    PICTURE X.
           02  FILLER REDEFINES MESSAGEF.
             03 MESSAGEA    PICTURE X.
           02  FILLER   PICTURE X(6).
           02  MESSAGEI  PIC X(79).
           02  DUMMYL    COMP  PIC  S9(4).
           02  DUMMYF    PICTURE X.
           02  FILLER REDEFINES DUMMYF.
             03 DUMMYA    PICTURE X.
           02  FILLER   PICTURE X(6).
           02  DUMMYI  PIC X(1).
       01  BNK1DCO REDEFINES BNK1DCI.
           02  FILLER PIC X(12).
           02  FILLER PICTURE X(3).
           02  COMPANYC    PICTURE X.
           02  COMPANYP    PICTURE X.
           02  COMPANYH    PICTURE X.
           02  COMPANYV    PICTURE X.
           02  COMPANYU    PICTURE X.
           02  COMPANYM    PICTURE X.
           02  COMPANYO  PIC X(52).
           02  FILLER PICTURE X(3).
           02  CUSTNOC    PICTURE X.
           02  CUSTNOP    PICTURE X.
           02  CUSTNOH    PICTURE X.
           02  CUSTNOV    PICTURE X.
           02  CUSTNOU    PICTURE X.
           02  CUSTNOM    PICTURE X.
           02  CUSTNOO  PIC X(10).
           02  FILLER PICTURE X(3).
           02  SORTCC    PICTURE X.
           02  SORTCP    PICTURE X.
           02  SORTCH    PICTURE X.
           02  SORTCV    PICTURE X.
           02  SORTCU    PICTURE X.
           02  SORTCM    PICTURE X.
           02  SORTCO  PIC X(6).
           02  FILLER PICTURE X(3).
           02  CUSTNO2C    PICTURE X.
           02  CUSTNO2P    PICTURE X.
           02  CUSTNO2H    PICTURE X.
           02  CUSTNO2V    PICTURE X.
           02  CUSTNO2U    PICTURE X.
           02  CUSTNO2M    PICTURE X.
           02  CUSTNO2O  PIC X(10).
           02  FILLER PICTURE X(3).
           02  CUSTNAMC    PICTURE X.
           02  CUSTNAMP    PICTURE X.
           02  CUSTNAMH    PICTURE X.
           02  CUSTNAMV    PICTURE X.
           02  CUSTNAMU    PICTURE X.
           02  CUSTNAMM    PICTURE X.
           02  CUSTNAMO  PIC X(60).
           02  FILLER PICTURE X(3).
           02  CUSTAD1C    PICTURE X.
           02  CUSTAD1P    PICTURE X.
           02  CUSTAD1H    PICTURE X.
           02  CUSTAD1V    PICTURE X.
           02  CUSTAD1U    PICTURE X.
           02  CUSTAD1M    PICTURE X.
           02  CUSTAD1O  PIC X(60).
           02  FILLER PICTURE X(3).
           02  CUSTAD2C    PICTURE X.
           02  CUSTAD2P    PICTURE X.
           02  CUSTAD2H    PICTURE X.
           02  CUSTAD2V    PICTURE X.
           02  CUSTAD2U    PICTURE X.
           02  CUSTAD2M    PICTURE X.
           02  CUSTAD2O  PIC X(60).
           02  FILLER PICTURE X(3).
           02  CUSTAD3C    PICTURE X.
           02  CUSTAD3P    PICTURE X.
           02  CUSTAD3H    PICTURE X.
           02  CUSTAD3V    PICTURE X.
           02  CUSTAD3U    PICTURE X.
           02  CUSTAD3M    PICTURE X.
           02  CUSTAD3O  PIC X(40).
           02  FILLER PICTURE X(3).
           02  DOBDDC    PICTURE X.
           02  DOBDDP    PICTURE X.
           02  DOBDDH    PICTURE X.
           02  DOBDDV    PICTURE X.
           02  DOBDDU    PICTURE X.
           02  DOBDDM    PICTURE X.
           02  DOBDDO  PIC X(2).
           02  FILLER PICTURE X(3).
           02  DOBMMC    PICTURE X.
           02  DOBMMP    PICTURE X.
           02  DOBMMH    PICTURE X.
           02  DOBMMV    PICTURE X.
           02  DOBMMU    PICTURE X.
           02  DOBMMM    PICTURE X.
           02  DOBMMO  PIC X(2).
           02  FILLER PICTURE X(3).
           02  DOBYYC    PICTURE X.
           02  DOBYYP    PICTURE X.
           02  DOBYYH    PICTURE X.
           02  DOBYYV    PICTURE X.
           02  DOBYYU    PICTURE X.
           02  DOBYYM    PICTURE X.
           02  DOBYYO  PIC X(4).
           02  FILLER PICTURE X(3).
           02  CREDSCC    PICTURE X.
           02  CREDSCP    PICTURE X.
           02  CREDSCH    PICTURE X.
           02  CREDSCV    PICTURE X.
           02  CREDSCU    PICTURE X.
           02  CREDSCM    PICTURE X.
           02  CREDSCO  PIC X(3).
           02  FILLER PICTURE X(3).
           02  SCRDTDDC    PICTURE X.
           02  SCRDTDDP    PICTURE X.
           02  SCRDTDDH    PICTURE X.
           02  SCRDTDDV    PICTURE X.
           02  SCRDTDDU    PICTURE X.
           02  SCRDTDDM    PICTURE X.
           02  SCRDTDDO  PIC X(2).
           02  FILLER PICTURE X(3).
           02  SCRDTMMC    PICTURE X.
           02  SCRDTMMP    PICTURE X.
           02  SCRDTMMH    PICTURE X.
           02  SCRDTMMV    PICTURE X.
           02  SCRDTMMU    PICTURE X.
           02  SCRDTMMM    PICTURE X.
           02  SCRDTMMO  PIC X(2).
           02  FILLER PICTURE X(3).
           02  SCRDTYYC    PICTURE X.
           02  SCRDTYYP    PICTURE X.
           02  SCRDTYYH    PICTURE X.
           02  SCRDTYYV    PICTURE X.
           02  SCRDTYYU    PICTURE X.
           02  SCRDTYYM    PICTURE X.
           02  SCRDTYYO  PIC X(4).
           02  FILLER PICTURE X(3).
           02  MESSAGEC    PICTURE X.
           02  MESSAGEP    PICTURE X.
           02  MESSAGEH    PICTURE X.
           02  MESSAGEV    PICTURE X.
           02  MESSAGEU    PICTURE X.
           02  MESSAGEM    PICTURE X.
           02  MESSAGEO  PIC X(79).
           02  FILLER PICTURE X(3).
           02  DUMMYC    PICTURE X.
           02  DUMMYP    PICTURE X.
           02  DUMMYH    PICTURE X.
           02  DUMMYV    PICTURE X.
           02  DUMMYU    PICTURE X.
           02  DUMMYM    PICTURE X.
           02  DUMMYO  PIC X(1).