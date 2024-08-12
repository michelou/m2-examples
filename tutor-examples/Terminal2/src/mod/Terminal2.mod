IMPLEMENTATION MODULE Terminal2;

IMPORT InOut, RealInOut;

PROCEDURE ReadChar(VAR v: CHAR);
BEGIN
  InOut.Read(v);
END ReadChar;

PROCEDURE ReadString(VAR v: ARRAY OF CHAR);
BEGIN
  InOut.ReadString(v);
END ReadString;

PROCEDURE ReadCard(VAR v: CARDINAL);
BEGIN
  InOut.ReadCard(v);
END ReadCard;

PROCEDURE ReadInt(VAR v: INTEGER);
BEGIN
  InOut.ReadInt(v);
END ReadInt;

PROCEDURE ReadReal(VAR r: REAL);
VAR ch: CHAR;
BEGIN
  RealInOut.ReadReal(r);
END ReadReal;

PROCEDURE WriteChar(v: CHAR);
BEGIN
  InOut.Write(v);
END WriteChar;

PROCEDURE WriteLn;
BEGIN
  InOut.WriteLn;
END WriteLn;

PROCEDURE WriteString(v: ARRAY OF CHAR);
BEGIN
  InOut.WriteString(v);
END WriteString;

PROCEDURE WriteInt(v: INTEGER;  w: CARDINAL);
BEGIN
  InOut.WriteInt(v, w);
END WriteInt;

PROCEDURE WriteCard(v: CARDINAL; w: CARDINAL);
BEGIN
  InOut.WriteCard(v, w);
END WriteCard;

PROCEDURE WriteOct(v: CARDINAL; w: CARDINAL);
BEGIN
  InOut.WriteCard(v, w);
END WriteOct;

PROCEDURE WriteHex(v: CARDINAL; w: CARDINAL);
BEGIN
  InOut.WriteHex(v, w);
END WriteHex;

PROCEDURE WriteReal0(r: REAL; w: CARDINAL);
BEGIN
  RealInOut.WriteReal(r, w);
END WriteReal0;

PROCEDURE SplitReal(r: REAL;
                    VAR integralPart: CARDINAL;
                    VAR decimalPart: CARDINAL;
                    VAR exponent: INTEGER);
BEGIN
  integralPart := TRUNC(r);
  decimalPart := TRUNC((r - FLOAT(integralPart)) * 1.0E9);
  exponent := 1;
END SplitReal;

(* https://blog.benoitblanchon.fr/lightweight-float-to-string/ *)
PROCEDURE WriteReal(r: REAL; w: CARDINAL);
VAR
  s, t: ARRAY[0..31] OF CHAR;
  j, k: CARDINAL;
  i, d: CARDINAL;
  e: INTEGER;
BEGIN
  j := 0;
  IF r < 0.0 THEN
    s[j] := '-'; INC(j);
    r := -r;
  END;
  SplitReal(r, i, d, e);
  k := 0;
  REPEAT
    t[k] := CHR((i MOD 10) + 48); INC(k);
    i := i DIV 10;
  UNTIL i = 0;
  REPEAT (* fill 's' with elements of 't' in reverse order *)
    DEC(k);
    s[j] := t[k]; INC(j);
  UNTIL k = 0;
  s[j] := '.'; INC(j);
  IF d > 0 THEN
    k := 0;
    REPEAT
      t[k] := CHR((d MOD 10) + 48); INC(k);
      d := d DIV 10;
    UNTIL d = 0;
    REPEAT
        DEC(k);
        s[j] := t[k]; INC(j);
    UNTIL k = 0;
  ELSE
    s[j] := '0'; INC(j);
  END;
  s[j] := 00C;
  WriteString(s);
  Done := TRUE;
END WriteReal;

BEGIN
END Terminal2.
