MODULE Factorial;

FROM Terminal  IMPORT (*Read,*) WriteLn;
FROM Terminal2 IMPORT WriteCard;

PROCEDURE Fact(n: CARDINAL): CARDINAL;

VAR 
    i, nfact: CARDINAL;

BEGIN
    IF n > 8 THEN RETURN 0 
    END;
    
    nfact := 1;
    FOR i:=n TO 1 BY -1 DO
        nfact := nfact * i
    END;

    RETURN nfact;

END Fact;


VAR
    i: CARDINAL;
    
BEGIN
   FOR i:=0 TO 8 DO 
       WriteCard(i, 3);
       WriteCard(Fact(i), 12);
       WriteLn
   END
END Factorial.
