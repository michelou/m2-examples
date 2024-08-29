MODULE TestQsort;

FROM InOut IMPORT WriteInt, WriteLn, WriteString;
FROM Qsort IMPORT qsort;

CONST N = 99;
VAR i: INTEGER;
    x: ARRAY[0..N] OF INTEGER;

PROCEDURE compInt(i, j: INTEGER): BOOLEAN;
BEGIN
    RETURN x[i] <= x[j]
END compInt;

PROCEDURE swapInt(i, j: INTEGER);
VAR t: INTEGER;
BEGIN
    t := x[i]; x[i] := x[j]; x[j] := t
END swapInt;

VAR seed: INTEGER;

(* adapted from https://codebrowser.dev/glibc/glibc/stdlib/random_r.c.html#__random_r *)
PROCEDURE rand(): INTEGER;
VAR hi, lo: INTEGER;
BEGIN
    hi := seed / 127773;
    lo := seed MOD 127773;
    seed := 16807 * lo - 2836 * hi;
    IF seed < 0 THEN seed := seed + 2147483647; END;
    RETURN seed;
END rand;

PROCEDURE WriteArray(a: ARRAY OF INTEGER);
VAR i: CARDINAL;
BEGIN
    FOR i := 0 TO HIGH(a) DO
        WriteInt(a[i], 3);
        IF (i MOD 15) = 14 THEN WriteLn END
    END;
END WriteArray;

BEGIN
    seed := 1;
    FOR i := 0 TO N DO
        x[i] := rand() MOD (N+1);
    END;

    WriteString("Unsorted:"); WriteLn;
    WriteArray(x); WriteLn;

    qsort(0, N, compInt, swapInt);

    WriteString("Sorted:"); WriteLn;
    WriteArray(x); WriteLn
END TestQsort.
