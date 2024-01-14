MODULE PascalTriangle;

FROM InOut IMPORT WriteCard, WriteLn, WriteString;
FROM Strings IMPORT Extract;
 
PROCEDURE WriteTriangle(n: CARDINAL);
VAR 
    i, j, num, w: CARDINAL;
    s1, s2: ARRAY [0..6] OF CHAR;
BEGIN
    IF n < 10 THEN w := 3;
    ELSIF n < 18 THEN w := 4;
    ELSIF n < 23 THEN w := 5;
    ELSIF n < 28 THEN w := 6;
    ELSE w := 7;
    END;
    Extract('       ', 0, w-1, s1);
    Extract('       ', 0, w-2, s2);
    FOR i := 0 TO n-1 DO
        num := 1;
        FOR j := 0 TO (n-1)-i DO
            WriteString(s1);
        END;
        FOR j := 0 TO i DO
            WriteCard(num, w);
            WriteString(s2);
            num := num * (i-j)/(j+1);
        END;
        WriteLn
    END;
    WriteLn
END WriteTriangle;

VAR
    h: CARDINAL;
    
BEGIN
    FOR h := 3 TO 7 DO
        WriteString('Triangle height='); WriteCard(h, 1); WriteLn;
        WriteTriangle(h);
    END;
END PascalTriangle.
