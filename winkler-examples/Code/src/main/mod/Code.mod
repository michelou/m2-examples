MODULE Code;

FROM InOut IMPORT ReadString, WriteString, WriteLn;

TYPE MethTyp = PROCEDURE(VAR CARDINAL, CARDINAL);

VAR E, Z : ARRAY[0..59] OF CHAR;

PROCEDURE code(Meth: MethTyp; VAR E, Z: ARRAY OF CHAR);
  VAR a, i : CARDINAL;
BEGIN
  FOR i := 0 TO HIGH(Z) DO
    a := ORD(E[i]);
    IF (a >= 65) AND (a <= 90) THEN
      Meth(a, i);
      WHILE a > 90 DO a := a-26 END
    ELSIF (a >= 97) AND (a <= 122) THEN
      Meth(a, i);
      WHILE a > 122 DO a := a-26 END
    END; (* IF *)
    Z[i] := CHR(a)
  END (* FOR *)
END code;

PROCEDURE Meth1(VAR a: CARDINAL; i: CARDINAL);
  CONST n = 5;
BEGIN
  a := a + n
END Meth1;

PROCEDURE Meth2(VAR a: CARDINAL; i: CARDINAL);
BEGIN
  a := a + i
END Meth2;

PROCEDURE Meth3(VAR a: CARDINAL; i: CARDINAL);
  CONST n = 5;
BEGIN
  IF ODD(a+i) THEN a := a + n ELSE a := a + i END
END Meth3;

BEGIN (* Hauptprogramm *)
  LOOP
    WriteString('Eingabe : '); ReadString(E); WriteLn;
    IF LENGTH(E) = 0 THEN EXIT; END;
    code(Meth1, E, Z); WriteString('Meth.1  : '); WriteString(Z); WriteLn;
    code(Meth2, E, Z); WriteString('Meth.2  : '); WriteString(Z); WriteLn;
    code(Meth3, E, Z); WriteString('Meth.3  : '); WriteString(Z); WriteLn;
    WriteLn; WriteLn;
  END (* LOOP *)
END Code.
