MODULE Nullstellen;

FROM MathLib0 IMPORT sin;
FROM InOut IMPORT WriteString, WriteLn;
FROM RealInOut IMPORT ReadReal, WriteReal;

TYPE FUNC = PROCEDURE(REAL): REAL;

VAR a, b, y : REAL;
    m : BOOLEAN;
    f : FUNC;

PROCEDURE RegFal(a, b: REAL; f: FUNC; VAR y: REAL; VAR m: BOOLEAN);
  (* Berechnet eine Nullstelle y der Funktion f mit den Anfangswerten
  a und b mittels der Regula Falsi. Bei Erfolg wird in m TRUE zurueck-
  geliefert, sonst FALSE. In diesem Fall wird sich ein zufaelliger Wert
  in y befinden. Die angestrebte Genauigkeit ist auf 1E-6 festgelegt,
  und es werden hoechstens 20 Iterationen durchgefuehrt. *)
  CONST eps = 1.0E-6; n = 20;
  VAR x0, x1, r : REAL;
      i : INTEGER;
BEGIN
  x0 := a; x1 := b;
  FOR i := 1 TO n DO
    r := x1 - f(x1)*(x1-x0) / (f(x1)-f(x0));
    x0 := x1; x1 := r;
    IF ABS(x1 - x0) < eps THEN
      m := TRUE; y := x1; RETURN
    END (* IF *)
  END; (* FOR *)
  m := FALSE
END RegFal;

BEGIN (* Hauptprogramm *)
  f := sin;
  WriteString('a='); ReadReal(a); WriteLn;
  WriteString('b='); ReadReal(b); WriteLn;
  WHILE a < b DO
    RegFal(a, b, f, y, m);
    IF m THEN
      WriteReal(y, 15)  (* WriteReal(y,15,8) *)
    ELSE
      WriteString('Keine Nullstelle')
    END; (* IF *)
    WriteLn;
    WriteString('a='); ReadReal(a); WriteLn;
    WriteString('b='); ReadReal(b); WriteLn;
  END (* WHILE *)
END Nullstellen.
