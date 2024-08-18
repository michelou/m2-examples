MODULE RealSpeedTest;

IMPORT RealMath, STextIO, SRealIO, SLWholeIO , WIN32;

CONST LOOPS=100000000;

VAR
    r  : REAL;
    R  : LONGREAL;
    i  : LONGINT;
    ch : CHAR;
    t  : CARDINAL;
BEGIN
    t:=WIN32.GetTickCount();
    r:=0.0;
    FOR i:=0 TO LOOPS DO
        r:=r*3.14;
    END;
    STextIO.WriteString("REAL     : ");
    SLWholeIO.WriteLongInt(WIN32.GetTickCount()-t,5);
    STextIO.WriteLn;

    r:=0.0;
    t:=WIN32.GetTickCount();
    R:=0.0;
    FOR i:=0 TO LOOPS DO
        R:=R*3.14;
    END;
    STextIO.WriteString("LONGREAL : ");
    SLWholeIO.WriteLongInt(WIN32.GetTickCount()-t,5);
    STextIO.WriteLn;

    STextIO.ReadChar(ch);
END RealSpeedTest.
