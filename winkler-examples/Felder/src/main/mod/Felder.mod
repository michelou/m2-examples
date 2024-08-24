MODULE Felder;

FROM InOut IMPORT Write, WriteInt, WriteLn;

CONST N = 20;

TYPE Bedingung = PROCEDURE(INTEGER): BOOLEAN;

VAR A : ARRAY[1..N] OF INTEGER;

PROCEDURE sum(VAR A: ARRAY OF INTEGER; B: Bedingung): INTEGER;
VAR i, s : INTEGER;
BEGIN
    s := 0;
    FOR i := 0 TO N DO
        IF B(A[i]) THEN s := s + A[i] END
    END; (* FOR *)
    RETURN s
END sum;

PROCEDURE out(VAR A: ARRAY OF INTEGER; B: Bedingung);
VAR i : INTEGER;
BEGIN
    Write('[');
    FOR i := 0 TO N DO
        IF B(A[i]) THEN WriteInt(A[i], 3) END
    END; (* FOR *)
    Write(']')
END out;

PROCEDURE all(x: INTEGER): BOOLEAN;
BEGIN
    RETURN TRUE
END all;

PROCEDURE odd(x: INTEGER): BOOLEAN;
  (* x ungerade? *)
BEGIN
    RETURN ODD(x)
END odd;

PROCEDURE positiv(x: INTEGER): BOOLEAN;
  (* x positiv? *)
BEGIN
    RETURN x > 0
END positiv;

PROCEDURE prim(x: INTEGER): BOOLEAN;
  (* x prim? *)
VAR i : INTEGER;
BEGIN
    IF x < 2 THEN RETURN FALSE END;
    FOR i := 2 TO (x DIV 2) DO
        IF (x DIV i)*i = x THEN RETURN FALSE END
    END; (* FOR *)
    RETURN TRUE;
END prim;

PROCEDURE Init(VAR A: ARRAY OF INTEGER);
VAR i : INTEGER;
BEGIN
    FOR i := 0 TO N DO
        IF ODD(i) THEN A[i] := i*i DIV 9 ELSE A[i] := 2*i-13 END
    END (* FOR *)
END Init;

BEGIN (* Hauptprogramm *)
    Init(A);
    out(A, all); WriteLn;                 (* Ausgabe aller Elemente *)
    out(A, prim); WriteLn;                (* Ausgabe der primen Elemente *)
    WriteInt(sum(A, odd), 3); WriteLn;    (* Summe der ungeraden Elemente *)
    WriteInt(sum(A, positiv), 3); WriteLn (* Summe der positiven Elemente *)
END Felder.
