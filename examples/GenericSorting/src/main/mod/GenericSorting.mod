IMPLEMENTATION MODULE GenericSorting;

FROM SYSTEM IMPORT WORD;

  PROCEDURE GenericSort(VAR objectArray: ARRAY OF WORD;
                        object1, object2: ARRAY OF WORD;
                        Gtr: UserProc);
    VAR
      WordSizeOfObject: CARDINAL;
      NumberOfObjects : CARDINAL;
      index           : CARDINAL;
      pos             : CARDINAL;

    PROCEDURE Interchange(index1, index2: CARDINAL);
      VAR wordCount: CARDINAL;
    BEGIN
      FOR wordCount := 1 TO WordSizeOfObject DO
        object1[wordCount-1] := objectArray[index1 * WordSizeOfObject+wordCount-1];
        object2[wordCount-1] := objectArray[index2 * WordSizeOfObject+wordCount-1];
      END; (* for loop *)
      FOR wordCount := 1 TO WordSizeOfObject DO
        objectArray[index1 * WordSizeOfObject+wordCount-1] := object2[wordCount-1];
        objectArray[index2 * WordSizeOfObject+wordCount-1] := object1[wordCount-1];
      END; (* for loop *)
    END Interchange;

    PROCEDURE Maximum(upper: CARDINAL; VAR pos: CARDINAL);
      VAR
        index: CARDINAL;
        wordCount: CARDINAL;

      PROCEDURE GetObject(index: CARDINAL; VAR object: ARRAY OF WORD);
        VAR wordCount: CARDINAL;
      BEGIN
        FOR wordCount := 1 TO WordSizeOfObject DO
          object[wordCount-1] := objectArray[index * WordSizeOfObject+wordCount-1];
        END; (* for loop *)
      END GetObject;

    BEGIN (* Maximum *)
      pos := 0;
      (*index := 0;*)
      GetObject((*index*)0, object1);
      FOR index := 1 TO upper DO
        GetObject(index, object2);
        IF Gtr(object2, object1) THEN
          FOR wordCount := 1 TO WordSizeOfObject DO
            object1[wordCount-1] := object2[wordCount-1];
          END; (* for loop *)
          pos := index;
        END (* if *)
      END; (* for loop *)
    END Maximum;
  
  BEGIN (* GenericSort *)
    WordSizeOfObject := HIGH(object1) + 1;
    NumberOfObjects := (HIGH(objectArray) + 1) DIV WordSizeOfObject;
    index := NumberOfObjects;
    REPEAT
      DEC(index);
      Maximum(index, pos);
      Interchange(pos, index);
    UNTIL index = 0;
  END GenericSort;

END GenericSorting.

