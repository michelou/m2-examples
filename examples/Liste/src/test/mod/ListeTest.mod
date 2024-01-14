MODULE ListeTest;

FROM Liste IMPORT ListenPtr, anhaengen, ausgabe, einfuegen, sortiertEinfuegen;

VAR
  i: INTEGER;
  reihe1, reihe2: ListenPtr;

BEGIN
    FOR i := 5 TO 0 BY -1 DO
        einfuegen(reihe1, i);
	END;
    ausgabe(reihe1);
    FOR i:= 12 TO 6 BY -1 DO
        einfuegen(reihe2, i);
    END;
    anhaengen(reihe1, reihe2);
    ausgabe(reihe1);
    sortiertEinfuegen(reihe2, 8);
    ausgabe(reihe2);
END ListeTest.
