MODULE InOut;

IMPORT Conversions, Strings, Terminal;

PROCEDURE Write (ch : CHAR);
BEGIN
  Terminal.Write (ch);
END Write;

PROCEDURE WriteString (str : ARRAY OF CHAR);
BEGIN
  Terminal.WriteString (str);
END WriteString;

PROCEDURE WriteLn;
BEGIN
  Terminal.WriteLn;
END WriteLn;

PROCEDURE WriteCard (n: CARDINAL; w: CARDINAL);
  VAR ok : BOOLEAN;
  VAR str : ARRAY [0..80] OF CHAR;
BEGIN
  ok := Conversions.CardToStr(n, str);
  WHILE Strings.Length(str) < w DO
    Strings.Insert(" ", 0, str);
  END;
  Terminal.WriteString(str);
END WriteCard;

PROCEDURE WriteInt (n: INTEGER; w: CARDINAL);
  VAR ok : BOOLEAN;
  VAR str : ARRAY [0..80] OF CHAR;
BEGIN
  ok := Conversions.IntToStr(n, str);
  WHILE Strings.Length(str) < w DO
    Strings.Insert(" ", 0, str);
  END;
  Terminal.WriteString(str);
END WriteInt;

END InOut.
