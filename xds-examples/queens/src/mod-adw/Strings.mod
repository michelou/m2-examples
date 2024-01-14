MODULE Strings;

PROCEDURE Length (stringVal: ARRAY OF CHAR): CARDINAL;
BEGIN
  RETURN HIGH(stringVal);
END Length;

PROCEDURE Extract (source: ARRAY OF CHAR; startPos, numberToExtract: CARDINAL;
                   VAR destination: ARRAY OF CHAR);
BEGIN
END Extract;

PROCEDURE Delete (VAR stringVar: ARRAY OF CHAR; startPos, numberToDelete: CARDINAL);
BEGIN
END Delete;

PROCEDURE Insert (source: ARRAY OF CHAR; startPos: CARDINAL;
                  VAR destination: ARRAY OF CHAR);
BEGIN
END Insert;

PROCEDURE Replace (source: ARRAY OF CHAR; startPos: CARDINAL;
                   VAR destination: ARRAY OF CHAR);
BEGIN
END Replace;

PROCEDURE Append (source: ARRAY OF CHAR; VAR destination: ARRAY OF CHAR);
BEGIN
END Append;

PROCEDURE Concat (source1, source2: ARRAY OF CHAR; VAR destination: ARRAY OF CHAR);
BEGIN
END Concat;

PROCEDURE Capitalize (VAR stringVar: ARRAY OF CHAR);
BEGIN
END Capitalize;

END Strings.
