MODULE Factorial;

FROM InOut IMPORT WriteCard, WriteLn, WriteString;

  PROCEDURE Fact(n: CARDINAL): CARDINAL;
    VAR i, nfact: CARDINAL;
  BEGIN
    IF n > 8 THEN
      RETURN 0 
    END;
    
    nfact := 1;
    FOR i := n TO 1 BY -1 DO
      nfact := nfact * i
    END;

    RETURN nfact;
  END Fact;

  PROCEDURE TailRecFact(n: CARDINAL): CARDINAL;
    PROCEDURE Helper(i: CARDINAL; acc: CARDINAL): CARDINAL;
    BEGIN
      IF i = 0 THEN
        RETURN acc;
      ELSE
        RETURN Helper(i - 1, i * acc);
      END;
    END Helper;
  BEGIN
    RETURN Helper(n, 1);
  END TailRecFact;

VAR
  i: CARDINAL;
    
BEGIN
  WriteString("Iterative Factorial function"); WriteLn;
  FOR i := 0 TO 8 DO 
    WriteCard(i, 3);
    WriteCard(Fact(i), 12);
    WriteLn
  END;
  WriteLn;

  WriteString("Tail recursive Factorial function"); WriteLn;
  FOR i := 0 TO 8 DO 
    WriteCard(i, 3);
    WriteCard(TailRecFact(i), 12);
    WriteLn
  END
END Factorial.
