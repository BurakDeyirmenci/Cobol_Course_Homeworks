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
         01  IDX-REX.
           03 IDX-KEY.
              05 IDX-ID         PIC S9(5) COMP-3.
              05 IDX-DVZ        PIC S9(3) COMP.
           03 IDX-NAME          PIC X(30).
           03 IDX-DATE          PIC S9(07) COMP-3.
           03 IDX-BALANCE       PIC S9(15) COMP-3.
       FD  OUT-FILE RECORDING MODE F.
         01  PRINT-REC.
           03 REC-ID-O          PIC X(5).
           03 REC-DVZ-O         PIC X(3).
           03 REC-NAME-O        PIC X(30).
           03 REC-DATE-O        PIC X(8).
           03 REC-BALANCE-O     PIC 9(15).
       FD  INP-FILE RECORDING MODE F.
         01  FLTIN.
           03 REC-ID            PIC X(5).
           03 REC-DVZ           PIC X(3).
       WORKING-STORAGE SECTION.
         01  WS-WORK-AREA.
           03 ST-INP            PIC 9(2).
              88 INP-FILE-EOF                   VALUE 10.
              88 INP-FILE-SUCCESS               VALUE 0 97.
              88 INP-FILE-NOTFND                VALUE 23.
           03 ST-IDX            PIC 9(2).
              88 IDX-FILE-SUCCESS               VALUE 0 97.
              88 IDX-FILE-NOTFND                VALUE 23.
           03 ST-OUT            PIC 9(2).
              88 OUT-FILE-SUCCESS               VALUE 0 97.
           03 REC-KEY           PIC 9(8).
           03 INT-DATE          PIC 9(7).
           03 GREG-DATE         PIC 9(8).

      *--------------------
       PROCEDURE DIVISION.
       0000-MAIN.
           PERFORM H100-OPEN-FILES
           PERFORM H200-READ-FIRST
           PERFORM H201-READ-NEXT-RECORD UNTIL INP-FILE-EOF
           PERFORM H999-PROGRAM-EXIT.
       0000-END. EXIT.

       H100-OPEN-FILES.
           OPEN INPUT  INP-FILE.
           OPEN INPUT  IDX-FILE.
           OPEN OUTPUT OUT-FILE.
           IF (ST-IDX NOT = 0) AND (ST-IDX NOT = 97)
           DISPLAY 'UNABLE TO OPEN INPFILE: ' ST-IDX
           MOVE ST-IDX TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.

           IF (ST-INP NOT = 0) AND (ST-INP NOT = 97)
           DISPLAY 'UNABLE TO OPEN INPFILE: ' ST-INP
           MOVE ST-INP TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.

           IF (ST-OUT NOT = 0) AND (ST-OUT NOT = 97)
           DISPLAY 'UNABLE TO OPEN OUTFILE: ' ST-OUT
           MOVE ST-OUT TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
       H100-END. EXIT.

       H200-READ-FIRST.
           READ INP-FILE.
           IF (ST-INP NOT = 0) AND (ST-INP NOT = 97)
           DISPLAY 'UNABLE TO READ INPFILE: ' ST-INP
           MOVE ST-INP TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
           COMPUTE IDX-ID = FUNCTION NUMVAL-C (REC-ID)
           COMPUTE IDX-DVZ = FUNCTION NUMVAL (REC-DVZ)
           READ IDX-FILE KEY IDX-KEY
             INVALID KEY PERFORM WRNG-RECORD
             NOT INVALID KEY PERFORM WRITE-RECORD.
       H200-END. EXIT.

       H201-READ-NEXT-RECORD.
           READ INP-FILE.
           COMPUTE IDX-ID = FUNCTION NUMVAL-C (REC-ID)
           COMPUTE IDX-DVZ = FUNCTION NUMVAL (REC-DVZ)
           READ IDX-FILE KEY IDX-KEY
             INVALID KEY PERFORM WRNG-RECORD
             NOT INVALID KEY PERFORM WRITE-RECORD.
       H201-END. EXIT.

       DATE-CONVERT.
           COMPUTE INT-DATE = FUNCTION INTEGER-OF-DAY(IDX-DATE)
           COMPUTE GREG-DATE = FUNCTION DATE-OF-INTEGER(INT-DATE).
       DATE-END. EXIT.

       WRNG-RECORD.
               DISPLAY "record undefined: " REC-ID.
       WRNG-END. EXIT.

       WRITE-RECORD.
           PERFORM DATE-CONVERT.
           MOVE IDX-ID       TO  REC-ID-O.
           MOVE IDX-DVZ      TO  REC-DVZ-O.
           MOVE IDX-NAME     TO  REC-NAME-O.
           MOVE GREG-DATE    TO  REC-DATE-O.
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
