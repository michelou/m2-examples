<*/OPT/OPT:TN/INLINE:Y/INLINE:0/ALIGN:8/NOPACK/NOCHECK/NODEBUG*>

MODULE Whetstone;

FROM STextIO IMPORT
    WriteString, WriteLn, ReadChar;

FROM SWholeIO IMPORT
    WriteCard;

FROM SLongIO IMPORT
    WriteFixed;

FROM SysClock IMPORT
    DateTime, GetClock, maxSecondParts;

FROM LongMath IMPORT
    sin, cos, arctan, sqrt, exp, ln;

(**********************************************************************
C     Benchmark #2 -- Double  Precision Whetstone (A001)
C
C     o This is a LONGREAL*8 version of
C   the Whetstone benchmark program.
C     o FOR-loop semantics are ANSI-66 compatible.
C     o Final measurements are to be made with all
C   WRITE statements and FORMAT sttements removed.
C
C**********************************************************************)

VAR
    LoopTimes         : ARRAY [1..11] OF CARDINAL;
    LoopTimeOverhead  : CARDINAL;
    TotalTime         : CARDINAL;
    LoopStart         : CARDINAL;
    ch                : CHAR;

(* returns time is thousands of a second *)
(* handles times returned in tenths, hundredths and thousands *)
(* we ignore a midnight crossing *)

PROCEDURE Time() : CARDINAL;
VAR
    t   : DateTime;
    tm  : CARDINAL;
BEGIN
    GetClock(t);
    tm := (((t.hour * 60) + t.minute) * 60) + t.second;

    tm := tm * 1000;
    IF maxSecondParts = 999 THEN
    tm := tm + t.fractions;
    ELSIF maxSecondParts = 99 THEN
    tm := tm + (t.fractions * 10);
    ELSIF maxSecondParts = 9 THEN
        tm := tm * (t.fractions * 100);
    ELSE
        (* ??? what to do *)
    END;

    RETURN tm;
END Time;

PROCEDURE InitLoopTimes(numLoops : CARDINAL);
VAR
    i       : CARDINAL;
    start, end  : CARDINAL;
    count   : CARDINAL;
BEGIN
    FOR i := 1 TO 11 DO
        LoopTimes[i] := 0;
    END;

    count := 0;
    start := Time();
    REPEAT
    end := Time();
        INC(count);
    UNTIL (end-start > 1000);

    LoopTimeOverhead :=
        VAL(CARDINAL,
            (FLOAT(end-start) / FLOAT(count)) * FLOAT(numLoops)
           );
END InitLoopTimes;

TYPE
    ARRAY4 = ARRAY [1..4] OF LONGREAL;

VAR
    E1                  : ARRAY4;
    T, T1, T2           : LONGREAL;
    J, K, L             : INTEGER;

PROCEDURE PA(VAR E : ARRAY4);
VAR
    J1 : INTEGER;
BEGIN
    J1 := 0;
    REPEAT
    E[1] := ( E[1] + E[2] + E[3] - E[4]) * T;
    E[2] := ( E[1] + E[2] - E[3] + E[4]) * T;
    E[3] := ( E[1] - E[2] + E[3] + E[4]) * T;
    E[4] := (-E[1] + E[2] + E[3] + E[4]) / T2;
    J1 := J1 + 1;
    UNTIL J1 >= 6;
END PA;

PROCEDURE P0;
BEGIN
    E1[J] := E1[K];
    E1[K] := E1[L];
    E1[L] := E1[J];
END P0;

PROCEDURE P3(X, Y : LONGREAL; VAR Z : LONGREAL);
VAR
    X1, Y1 : LONGREAL;
BEGIN
    X1 := X;
    Y1 := Y;
    X1 := T * (X1 + Y1);
    Y1 := T * (X1 + Y1);
    Z := (X1 + Y1) / T2;
END P3;

PROCEDURE POUT(loopNum, N, J, K : INTEGER;
           X1, X2, X3, X4 : LONGREAL);
VAR
    loopTime    : CARDINAL;
BEGIN
    WriteString("#");
    WriteCard(loopNum, 2);

    IF LoopTimes[loopNum] >= LoopTimeOverhead THEN
    loopTime := LoopTimes[loopNum] - LoopTimeOverhead;
    ELSE
        loopTime := 0;
    END;
    WriteFixed(VAL(LONGREAL, loopTime) / 1000.0, 3, 8);
    WriteCard(N, 6);
    WriteCard(J, 6);
    WriteCard(K, 6);
    WriteFixed(X1, 3, 10);
    WriteFixed(X2, 3, 10);
    WriteFixed(X3, 3, 10);
    WriteFixed(X4, 3, 10);
    WriteLn;
END POUT;

PROCEDURE WriteResults(NLoop, II : CARDINAL);
BEGIN
    TotalTime := TotalTime - (LoopTimeOverhead * 2 * 11);

    WriteFixed(VAL(LONGREAL, TotalTime) / 1000.0, 3, 11);
    WriteLn;

    (*----------------------------------------------------------------
      Performance in Whetstone KIP's per second is given by
       (100*NLoop*II)/TIME
      where TIME is in seconds.
    --------------------------------------------------------------------*)

    TotalTime := TotalTime / 1000;

    WriteLn;
    WriteString("Whetstone KIPS ");
    WriteCard(TRUNC((100.0 * FLOAT(NLoop) * FLOAT(II)) /
             FLOAT(TotalTime)), 0);
    WriteLn;
    WriteString("Whetstone MIPS ");
    WriteFixed(FLOAT(NLoop) * FLOAT(II) /
             FLOAT(TotalTime * 10), 3, 10);
    WriteLn;
END WriteResults;

PROCEDURE Do;
VAR
    NLoop, I, II, JJ                    : INTEGER;
    N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11    : INTEGER;
    X1, X2, X3, X4, X, Y, Z             : LONGREAL;
BEGIN
    InitLoopTimes(3200);
    WriteString("LOOP   TIME  ITER");
    WriteLn;

    TotalTime := Time();

    (* The actual benchmark starts here. *)

    T  := 0.499975;
    T1 := 0.50025;
    T2 := 2.0;

    (* With loopcount NLoop=10, one million Whetstone instructions
       will be executed in each major loop.
       A major loop is executed 'II' times to increase
       wall-clock timing accuracy *)

    NLoop := 10;
    II := 3200;
    FOR JJ := 1 TO II DO
        (* Establish the relative loop counts of each module. *)

        N1 := 2 * NLoop;
        N2 := 12 * NLoop;
        N3 := 14 * NLoop;
        N4 := 345 * NLoop;
        N5 := 0;
        N6 := 210 * NLoop;
        N7 := 32 * NLoop;
        N8 := 899 * NLoop;
        N9 := 616 * NLoop;
        N10 := 0;
        N11 := 93 * NLoop;

        (* Module 1: Simple identifiers *)

        LoopStart := Time();
        X1 := 1.0;
        X2 := -1.0;
        X3 := -1.0;
        X4 := -1.0;
        FOR I := 1 TO N1 DO
            X1 := (X1 + X2 + X3 - X4)*T;
            X2 := (X1 + X2 - X3 + X4)*T;
            X3 := (X1 - X2 + X3 + X4)*T;
            X4 := (-X1 + X2 + X3 + X4)*T;
        END;
        LoopTimes[1] := (Time() - LoopStart) + LoopTimes[1];
        IF JJ = II THEN
            POUT(1, N1, 0, 0, X1, X2, X3, X4);
        END;

        (* Module 2: Array elements *)

        LoopStart := Time();
        E1[1] :=  1.0;
        E1[2] := -1.0;
        E1[3] := -1.0;
        E1[4] := -1.0;
        FOR I := 1 TO N2 DO
            E1[1] := ( E1[1] + E1[2] + E1[3] - E1[4])*T;
            E1[2] := ( E1[1] + E1[2] - E1[3] + E1[4])*T;
            E1[3] := ( E1[1] - E1[2] + E1[3] + E1[4])*T;
            E1[4] := (-E1[1] + E1[2] + E1[3] + E1[4])*T;
        END;
        LoopTimes[2] := (Time() - LoopStart) + LoopTimes[2];
        IF JJ = II THEN
            POUT(2, N2, 0, 0, E1[1], E1[2], E1[3], E1[4]);
        END;

        (* Module 3: Array as parameter *)

        LoopStart := Time();
        FOR I := 1 TO N3 DO
            PA(E1);
        END;
        LoopTimes[3] := (Time() - LoopStart) + LoopTimes[3];
        IF JJ = II THEN
            POUT(3, N3, 0, 0, E1[1], E1[2], E1[3], E1[4]);
        END;

        (* Module 4: Conditional jumps *)

        LoopStart := Time();
        J := 1;
        FOR I := 1 TO N4 DO
            IF J <> 1 THEN
                J := 3;
            ELSE
                J := 2;
            END;
            IF J <= 2 THEN
                J := 1;
            ELSE
                J := 0;
            END;
            IF J >= 1 THEN
                J := 0;
            ELSE
                J := 1;
            END;
        END;
        LoopTimes[4] := (Time() - LoopStart) + LoopTimes[4];
        IF JJ = II THEN
            POUT(4, N4, J, J, 0.0, 0.0, 0.0, 0.0);
        END;

        (* Module 5: Omitted *)
        LoopStart := Time();
        LoopTimes[5] := (Time() - LoopStart) + LoopTimes[5];

        (* Module 6: Integer arithmetic *)

            LoopStart := Time();
        J := 1;
        K := 2;
        L := 3;
        FOR I := 1 TO N6 DO
            J := J * (K-J) * (L-K);
            K := L * K - (L-J) * K;
            L := (L - K) * (K + J);
            E1[L-1] := VAL(LONGREAL, (J + K + L));
            E1[K-1] := VAL(LONGREAL, (J * K * L));
        END;
        LoopTimes[6] := (Time() - LoopStart) + LoopTimes[6];
        IF JJ = II THEN
            POUT(6, N6, J, K, E1[1], E1[2], E1[3], E1[4]);
        END;

        (* Module 7: Trigonometric functions *)

            LoopStart := Time();
        X := 0.5;
        Y := 0.5;
        FOR I:=1 TO N7 DO
            X := T*arctan(T2*sin(X)*cos(X)/(cos(X+Y)+cos(X-Y)-1.0));
            Y := T*arctan(T2*sin(Y)*cos(Y)/(cos(X+Y)+cos(X-Y)-1.0));
        END;
        LoopTimes[7] := (Time() - LoopStart) + LoopTimes[7];
        IF JJ = II THEN
            POUT(7, N7, 0, 0, X, X, Y, Y);
        END;

        (* Module 8: Procedure calls *)

        LoopStart := Time();
        X := 1.0;
        Y := 1.0;
        Z := 1.0;
        FOR I := 1 TO N8 DO
            P3(X,Y,Z);
        END;
        LoopTimes[8] := (Time() - LoopStart) + LoopTimes[8];
        IF JJ = II THEN
            POUT(8, N8, 0, 0, X, Y, Z, Z);
        END;

        (* Module 9: Array references *)

        LoopStart := Time();
        J := 1;
        K := 2;
        L := 3;
        E1[1] := 1.0;
        E1[2] := 2.0;
        E1[3] := 3.0;
        FOR I := 1 TO N9 DO
            P0;
        END;
        LoopTimes[9] := (Time() - LoopStart) + LoopTimes[9];
        IF JJ = II THEN
            POUT(9, N9, J, K, E1[1], E1[2], E1[3], E1[4]);
        END;

        (* Module 10: Integer arithmetic *)

        LoopStart := Time();
        J := 2;
        K := 3;
        FOR I := 1 TO N10 DO
            J := J + K;
            K := J + K;
            J := K - J;
            K := K - J - J;
        END;
        LoopTimes[10] := (Time() - LoopStart) + LoopTimes[10];
        IF JJ = II THEN
            POUT(10, N10, J, K, 0.0, 0.0, 0.0, 0.0);
        END;

        (* Module 11: Standard functions *)

        LoopStart := Time();
        X := 0.75;
        FOR I := 1 TO N11 DO
            X := sqrt(exp(ln(X)/T1));
        END;
        LoopTimes[11] := (Time() - LoopStart) + LoopTimes[11];
        IF JJ = II THEN
            POUT(11, N11, 0, 0, X, X, X, X);
        END;

    (* THIS IS THE END OF THE MAJOR LOOP. *)
    END;

    TotalTime := Time() - TotalTime;

    WriteResults(NLoop, II);
END Do;

BEGIN
    Do;

    WriteLn;
    WriteString("Press any key to exit");
    ReadChar(ch);
END Whetstone.
