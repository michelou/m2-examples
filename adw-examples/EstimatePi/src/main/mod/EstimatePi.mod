MODULE EstimatePi;

FROM STextIO  IMPORT WriteString,WriteLn; (*,ReadChar,SkipLine;*)
FROM SLongIO  IMPORT WriteFixed;
FROM LongMath IMPORT pi;

FROM Rand     IMPORT RANDOM;

VAR cIn,cTot,counter : CARDINAL;
    x,y,d   : LONGREAL;
    pi_est  : LONGREAL;(*
    ch      : CHAR;*)
BEGIN
    cTot:=1000000; cIn:=0;
    FOR counter:=1 TO cTot DO
        x := VAL(LONGREAL,RANDOM());
        y := VAL(LONGREAL,RANDOM());
        d := x*x+y*y;
        IF d<=1.0 THEN INC(cIn); END;
    END;
    pi_est:=4.0*VAL(LONGREAL,cIn)/VAL(LONGREAL,cTot);
    WriteString("PI by Monte Carlo simulation = ");
    WriteFixed(pi_est,5,7);
    WriteLn;
    WriteString("PI true value                = ");
    WriteFixed(pi,5,7);
    WriteLn;
    (*
    WriteLn;
    WriteString("Press Enter to continue");
    ReadChar(ch); SkipLine;
    *)
END EstimatePi.
