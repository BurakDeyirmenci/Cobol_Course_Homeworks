       IDENTIFICATION DIVISION.
       PROGRAM-ID. FILTER01.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IDX-FILE  ASSIGN TO IDXFILE
                            ORGANIZATION INDEXED
                            ACCESS RANDOM
                            RECORD KEY IDX-KEY
                            STATUS ST-IDX.
           SELECT OUT-FILE  ASSIGN TO OUTFILE
                            STATUS ST-OUT.
           SELECT INP-FILE  ASSIGN TO INPFILE
                            STATUS ST-INP.
       DATA DIVISION.
       FILE SECTION.
       FD  IDX-FILE.
         01  IDX-REC.
           05 IDX-KEY.
              07 IDX-ID      PIC S9(5) COMP-3.
              07 IDX-DVZ     PIC S9(3) COMP.
           05 IDX-NAME       PIC X(30).
           05 IDX-DATE       PIC S9(7) COMP-3.
           05 IDX-BALANCE    PIC S9(15) COMP-3.
       FD  OUT-FILE RECORDING MODE F.
         01  PRINT-REC.
           05 REC-PID-O      PIC 9(10).
           05 FILLER         PIC X(01) VALUE '|'.
           05 REC-ID-O       PIC X(5).
           05 FILLER         PIC X(01) VALUE '|'.
           05 REC-DVZ-O      PIC X(3).
           05 FILLER         PIC X(01) VALUE '|'.
           05 REC-NAME-O     PIC X(30).
           05 FILLER         PIC X(01) VALUE '|'.
           05 REC-DATE-O     PIC X(8).
           05 FILLER         PIC X(01) VALUE '|'.
           05 REC-BALANCE-O  PIC ZZZ,ZZZ,ZZZ,ZZ9.
       FD  INP-FILE RECORDING MODE F.
         01  FLTIN.
           05 REC-ID         PIC X(5).
           05 REC-DVZ        PIC X(3).
       WORKING-STORAGE SECTION.
         01  WS-WORK-AREA.
           05 ST-INP         PIC 9(2).
              88 INP-FILE-EOF                   VALUE 10.
              88 INP-FILE-SUCCESS               VALUE 0 97.
              88 INP-FILE-NOTFND                VALUE 23.
           05 ST-IDX         PIC 9(2).
              88 IDX-FILE-SUCCESS               VALUE 0 97.
              88 IDX-FILE-NOTFND                VALUE 23.
           05 ST-OUT         PIC 9(2).
              88 OUT-FILE-SUCCESS               VALUE 0 97.

           05 TEMP-PID       PIC 9(2).
           05 TEMP-ID        PIC 9(5).
           05 TEMP-DVZ       PIC 9(3).
           05 TEMP-BALANCE   PIC 9(15).
           05 CHANGE-BLNC    PIC S9(15).
           05 INT-DATE       PIC 9(7).
           05 GREG-DATE      PIC 9(8).

         01  HEADER-1.
           05  FILLER         PIC X(10) VALUE 'Prosses id'.
           05  FILLER         PIC X(01) VALUE '|'.
           05  FILLER         PIC X(05) VALUE 'Id   '.
           05  FILLER         PIC X(01) VALUE '|'.
           05  FILLER         PIC X(03) VALUE 'Dvz'.
           05  FILLER         PIC X(01) VALUE '|'.
           05  FILLER         PIC X(30) VALUE 'Name Surname'.
           05  FILLER         PIC X(01) VALUE '|'.
           05  FILLER         PIC X(08) VALUE 'Date '.
           05  FILLER         PIC X(01) VALUE '|'.
           05  FILLER         PIC X(15) VALUE 'Balance '.
      *
         01  HEADER-2.
           05  FILLER         PIC X(10) VALUE '----------'.
           05  FILLER         PIC X(01) VALUE '|'.
           05  FILLER         PIC X(05) VALUE '-----'.
           05  FILLER         PIC X(01) VALUE '|'.
           05  FILLER         PIC X(03) VALUE '---'.
           05  FILLER         PIC X(01) VALUE '|'.
           05  FILLER         PIC X(30)
                                VALUE '------------------------------'.
           05  FILLER         PIC X(01) VALUE '|'.
           05  FILLER         PIC X(08) VALUE '--------'.
           05  FILLER         PIC X(01) VALUE '|'.
           05  FILLER         PIC X(15) VALUE '---------------'.


      *--------------------
       PROCEDURE DIVISION.
       0000-MAIN.
           MOVE 0 TO TEMP-PID
           PERFORM H100-OPEN-FILES
           WRITE PRINT-REC FROM HEADER-1.
           WRITE PRINT-REC FROM HEADER-2.
           PERFORM H200-READ-NEXT-RECORD UNTIL INP-FILE-EOF
      *-----------------------------------------------------------------
           MOVE 1000 TO CHANGE-BLNC
           MOVE 10001 TO TEMP-ID
           MOVE 949 TO TEMP-DVZ
           PERFORM CHANGE-BALANCE
           MOVE -20 TO CHANGE-BLNC
           PERFORM CHANGE-BALANCE
           MOVE 2000 TO CHANGE-BLNC
           MOVE 10002 TO TEMP-ID
           MOVE 978 TO TEMP-DVZ
           PERFORM CHANGE-BALANCE
      *-----------------------------------------------------------------
           PERFORM H999-PROGRAM-EXIT.
       0000-END. EXIT.

       H100-OPEN-FILES.
           OPEN INPUT  INP-FILE.
           OPEN I-O    IDX-FILE.
           OPEN OUTPUT OUT-FILE.
           IF NOT IDX-FILE-SUCCESS
           DISPLAY 'UNABLE TO OPEN IDXFILE: ' ST-IDX
           MOVE ST-IDX TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.

           IF NOT INP-FILE-SUCCESS
           DISPLAY 'UNABLE TO OPEN INPFILE: ' ST-INP
           MOVE ST-INP TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.

           IF NOT OUT-FILE-SUCCESS
           DISPLAY 'UNABLE TO OPEN OUTFILE: ' ST-OUT
           MOVE ST-OUT TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
       H100-END. EXIT.

       H200-READ-NEXT-RECORD.
           READ INP-FILE.
           IF (NOT INP-FILE-SUCCESS) AND (INP-FILE-NOTFND)
           DISPLAY 'UNABLE TO READ INPFILE: ' ST-INP
           MOVE ST-INP TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
           IF (NOT INP-FILE-EOF)
           COMPUTE IDX-ID = FUNCTION NUMVAL (REC-ID)
           COMPUTE IDX-DVZ = FUNCTION NUMVAL (REC-DVZ)
           READ IDX-FILE KEY IDX-KEY
             INVALID KEY PERFORM WRNG-RECORD
             NOT INVALID KEY PERFORM WRITE-RECORD
           END-IF.
       H200-END. EXIT.

       CHANGE-BALANCE.
           MOVE TEMP-ID TO IDX-ID
           MOVE TEMP-DVZ TO IDX-DVZ
           READ IDX-FILE KEY IDX-KEY
             INVALID KEY PERFORM WRNG-RECORD
             NOT INVALID KEY PERFORM ADD-BALANCE.
       CHANGE-END. EXIT.

       ADD-BALANCE.
           COMPUTE TEMP-BALANCE = IDX-BALANCE
           COMPUTE IDX-BALANCE = TEMP-BALANCE + CHANGE-BLNC
           REWRITE IDX-REC
           PERFORM WRITE-RECORD.
       ADD-END. EXIT.

       DATE-CONVERT.
           COMPUTE INT-DATE = FUNCTION INTEGER-OF-DAY(IDX-DATE)
           COMPUTE GREG-DATE = FUNCTION DATE-OF-INTEGER(INT-DATE).
       DATE-END. EXIT.

       WRNG-RECORD.
               DISPLAY "record undefined: " REC-ID.
       WRNG-END. EXIT.

       WRITE-RECORD.
           PERFORM DATE-CONVERT.
           COMPUTE TEMP-PID = TEMP-PID + 1
           MOVE TEMP-PID     TO  REC-PID-O.
           MOVE '|'          TO PRINT-REC(11:1).
           MOVE IDX-ID       TO  REC-ID-O.
           MOVE '|'          TO PRINT-REC(17:1).
           MOVE IDX-DVZ      TO  REC-DVZ-O.
           MOVE '|'          TO PRINT-REC(21:1).
           MOVE IDX-NAME     TO  REC-NAME-O.
           MOVE '|'          TO PRINT-REC(52:1).
           MOVE GREG-DATE    TO  REC-DATE-O.
           MOVE '|'          TO PRINT-REC(61:1).
           MOVE IDX-BALANCE  TO  REC-BALANCE-O.
           WRITE PRINT-REC.
       WRITE-END. EXIT.

       H999-PROGRAM-EXIT.
           CLOSE INP-FILE.
           CLOSE IDX-FILE.
           CLOSE OUT-FILE.
           GOBACK.
       H999-EXIT.

      *
