MODULE WuerfelSpiel;

FROM SYSTEM IMPORT WORD, ADR, SIZE, PROCESS, NEWPROCESS, TRANSFER;
FROM Terminal2 IMPORT WriteCard, WriteString, WriteLn, ReadCard;

CONST Gewinn = 11;

VAR Spieler1, Spieler2, Haupt : PROCESS;
    Bereich1, Bereich2 : ARRAY[1..200] OF WORD;
    Start : [1..250];

PROCEDURE Sp1;
  VAR Summe, Wurf : CARDINAL;
  BEGIN
    Summe := 0;
    LOOP
      Wurf := Wuerfel();
      WriteString('Spieler 1 //'); WriteCard(Summe,3); WriteLn;
      WriteString('  gewuerfelt :'); WriteCard(Wurf,2); WriteLn;
      IF Summe+Wurf > Gewinn THEN
        WriteString('  Ich kann nicht...'); WriteLn;
        TRANSFER(Spieler1, Spieler2)
      ELSIF Summe + Wurf = Gewinn THEN
        WriteString('  Ich habe gewonnen!'); WriteLn;
        TRANSFER(Spieler1, Haupt)
      ELSE
        Summe := Summe + Wurf;
        WriteString('  Ich habe jetzt'); WriteCard(Summe, 3); WriteLn;
        TRANSFER(Spieler1, Spieler2)
      END (* IF *)
    END (* LOOP *)
  END Sp1;

PROCEDURE Sp2;
  VAR Summe, Wurf : CARDINAL;
  BEGIN
    Summe := 0;
    LOOP
      Wurf := Wuerfel();
      WriteString('Spieler 2 //'); WriteCard(Summe, 3); WriteLn;
      WriteString('  gewuerfelt :'); WriteCard(Wurf, 2); WriteLn;
      IF Summe+Wurf > Gewinn THEN
        WriteString('  Ich kann nicht...'); WriteLn;
        TRANSFER(Spieler2, Spieler1)
      ELSIF Summe + Wurf = Gewinn THEN
        WriteString('  Ich habe gewonnen!'); WriteLn;
        TRANSFER(Spieler2, Haupt)
      ELSE
        Summe := Summe + Wurf;
        WriteString('  Ich habe jetzt'); WriteCard(Summe, 3); WriteLn;
        TRANSFER(Spieler2, Spieler1)
      END (* IF *)
    END (* LOOP *)
  END Sp2;

PROCEDURE Wuerfel():CARDINAL;
  BEGIN
    Start := (Start*Start) MOD 251;
    RETURN (Start MOD 6)+1
  END Wuerfel;

BEGIN (* Hauptprogramm *)
  WriteString('Startwert :'); WriteLn;
  ReadCard(Start);
  WriteString('*** WUERFELSPIEL ***'); WriteLn; WriteLn;
  WriteString('Gewinnsumme :'); WriteCard(Gewinn, 3); WriteLn;WriteLn;
  NEWPROCESS(Sp1, ADR(Bereich1), SIZE(Bereich1), Spieler1);
  NEWPROCESS(Sp2, ADR(Bereich2), SIZE(Bereich2), Spieler2);
  TRANSFER(Haupt, Spieler1);
  WriteString('*** ENDE DES SPIELS ***'); WriteLn;
  ReadCard(Start)
END WuerfelSpiel.
