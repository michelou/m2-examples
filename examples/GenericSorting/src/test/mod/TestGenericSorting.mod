MODULE TestGenericSorting;

FROM GenericSorting IMPORT GenericSort;
FROM InOut          IMPORT ReadInt, ReadString, WriteCard, WriteInt, WriteLn, WriteString;
FROM RealInOut      IMPORT ReadReal, WriteReal;
FROM SYSTEM         IMPORT ADR, WORD;

  TYPE String60 = ARRAY [0..59] OF CHAR;

  TYPE Person = RECORD
                  name: String60;
                  age : INTEGER;
                END; (* record *)

  VAR
    k                 : INTEGER;
    RealNumberArray   : ARRAY [11..15] OF REAL;
    IntegerNumberArray: ARRAY[-11..-5] OF INTEGER;
    StringArray       : ARRAY[35..38] OF String60;
    PersonArray       : ARRAY[1..5] OF Person;
    s                 : String60; (* Sample object *)
    r                 : REAL;
    i                 : INTEGER;
    p                 : Person;

  PROCEDURE RealGreaterThan(r1, r2: ARRAY OF WORD): BOOLEAN;
    VAR
      p1: POINTER TO REAL;
      p2: POINTER TO REAL;
  BEGIN
    p1 := ADR(r1);
    p2 := ADR(r2);
    RETURN (p1^ > p2^);
  END RealGreaterThan;

  PROCEDURE IntegerGreaterThan(i1, i2: ARRAY OF WORD): BOOLEAN;
    VAR
      p1: POINTER TO INTEGER;
      p2: POINTER TO INTEGER;
  BEGIN
    p1 := ADR(i1);
    p2 := ADR(i2);
    RETURN (p1^ > p2^);
  END IntegerGreaterThan;

  PROCEDURE StringGreaterThan(s1, s2: ARRAY OF WORD): BOOLEAN;
    VAR
      p1: POINTER TO String60;
      p2: POINTER TO String60;
      i: CARDINAL;
  BEGIN
    p1 := ADR(s1);
    p2 := ADR(s2);
    i := 0;
    WHILE (i < 59) AND (p1^[i] = p2^[i]) DO
      INC(i);
    END; (* while *)
    RETURN (p1^[i] > p2^[i]);
  END StringGreaterThan;

  PROCEDURE PersonGreaterThanByName(per1, per2: ARRAY OF WORD): BOOLEAN;
    VAR
      p1: POINTER TO Person;
      p2: POINTER TO Person;
  BEGIN
    p1 := ADR(per1);
    p2 := ADR(per2);
    RETURN StringGreaterThan(p1^.name, p2^.name);
  END PersonGreaterThanByName;

  PROCEDURE PersonGreaterThanByAge(per1, per2: ARRAY OF WORD): BOOLEAN;
    VAR
      p1: POINTER TO Person;
      p2: POINTER TO Person;
  BEGIN
    p1 := ADR(per1);
    p2 := ADR(per2);
    RETURN IntegerGreaterThan(p1^.age, p2^.age);
  END PersonGreaterThanByAge;

  PROCEDURE InputReals();
    VAR i: CARDINAL;
  BEGIN
    FOR i := 11 TO 15 DO
      WriteString("Enter real number ");
      WriteCard(i, 1);
      WriteString(" : ");
      ReadReal(RealNumberArray[i]);
    END; (* for loop *)
  END InputReals;

  PROCEDURE InputIntegers();
    VAR i: INTEGER;
  BEGIN
    FOR i := -11 TO -5 DO
      WriteString("Enter integer ");
      WriteInt(i, 1);
      WriteString(" : ");
      ReadInt(IntegerNumberArray[i]);
    END; (* for loop *)
  END InputIntegers;

  PROCEDURE InputStrings();
    VAR i: CARDINAL;
  BEGIN
    FOR i := 35 TO 38 DO
      WriteString("Enter string ");
      WriteCard(i, 1);
      WriteString(" : ");
      ReadString(StringArray[i]);
    END;
  END InputStrings;

  PROCEDURE InputPersons();
    VAR i: CARDINAL;
  BEGIN
    FOR i := 1 TO 5 DO
      WriteLn;
      WriteString("Enter name of person: ");
      ReadString(PersonArray[i].name);
      WriteString("Enter the age of person: ");
      ReadInt(PersonArray[i].age);
    END; (* for loop *)
  END InputPersons;

BEGIN (* TestGenericSort *)
  InputReals();
  GenericSort(RealNumberArray, r, r, RealGreaterThan);
  WriteLn;
  WriteString("      The Sorted Numbers");
  WriteLn;
  WriteString("      ------------------");
  WriteLn;
  FOR k := 11 TO 15 DO
    WriteReal(RealNumberArray[k], 15);
    WriteLn
  END;
  WriteLn;

  InputIntegers();
  GenericSort(IntegerNumberArray, i, i, IntegerGreaterThan);
  WriteLn;
  WriteString("      The Sorted Numbers");
  WriteLn;
  WriteString("      ------------------");
  WriteLn;
  FOR k := -11 TO -5 DO
    WriteInt(IntegerNumberArray[k], 15);
    WriteLn
  END;
  WriteLn;

  InputStrings();
  GenericSort(StringArray, s, s, StringGreaterThan);
  WriteLn;
  WriteString("      The Sorted Strings");
  WriteLn;
  WriteString("      ------------------");
  WriteLn;
  FOR k := 35 TO 38 DO
    WriteString(StringArray[k]);
    WriteLn
  END;
  WriteLn;

  InputPersons();
  GenericSort(PersonArray, p, p, PersonGreaterThanByName);
  WriteLn;
  WriteString("      Sorted People By Name");
  WriteLn;
  WriteString("      ---------------------");
  WriteLn;
  FOR k := 1 TO 5 DO
    WriteLn;
    WriteString("Name --> ");
    WriteString(PersonArray[k].name);
    WriteLn;
    WriteString("Age  --> ");
    WriteInt(PersonArray[k].age, 1);
  END; (* for loop *)
  WriteLn;

  GenericSort(PersonArray, p, p, PersonGreaterThanByAge);
  WriteLn;
  WriteString("      Sorted People By Age");
  WriteLn;
  WriteString("      --------------------");
  WriteLn;
  FOR k := 1 TO 5 DO
    WriteLn;
    WriteString("Name --> ");
    WriteString(PersonArray[k].name);
    WriteLn;
    WriteString("Age  --> ");
    WriteInt(PersonArray[k].age, 1);
  END; (* for loop *)
  WriteLn;

END TestGenericSorting.
