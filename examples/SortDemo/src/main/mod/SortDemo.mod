MODULE SortDemo;

FROM InOut  IMPORT WriteCard, Write, WriteString, WriteLn;
FROM Lib    IMPORT RANDOM, RANDOMIZE;
FROM Sort   IMPORT SelectSort, MAXSIZE;
 
VAR
  Numbers, SortedNumbers: ARRAY[0..MAXSIZE] OF CARDINAL;
  x : CARDINAL;

BEGIN
  Write(CHR(27)); Write("E");  (* Clear the screen*)
  WriteLn;                     (* Skip a line *)

  RANDOMIZE;
  FOR x := 0 TO MAXSIZE DO     (* Fill the array with random values *)
    Numbers[x] := RANDOM(200);
  END;

  SelectSort(Numbers, SortedNumbers);

  WriteString(" UNSORTED ARRAY  SORTED ARRAY"); WriteLn;
  FOR x := 0 TO MAXSIZE DO
    WriteString("    "); WriteCard(Numbers[x], 5);
    WriteString("         "); WriteCard(SortedNumbers[x], 5); WriteLn;
  END;
END SortDemo.
