MODULE Constants;

FROM InOut IMPORT Write, WriteLn, WriteString;

CONST
    ESC   = 33C;
    SPACE = 40C;
    TAB   = 11C;

    BOLD      = ESC + "[1m";
    INVERSE   = ESC + "[7m";
    RESET     = ESC + "[0m";
    UNDERLINE = ESC + "[4m";
    
    Logical1 = TRUE;

    Logical2 = NOT Logical1;
    Logical3 = NOT TRUE;

    Logical4 = (1 = 0);
    Logical5 = (1 = 1);

BEGIN (* Constants *)
    Write(ESC); WriteString("[2J");  (* clear screen *)
    Write(TAB); WriteString("Text after TAB character"); WriteLn;

    WriteString(BOLD + "Bold text" + RESET); WriteLn;
    WriteString(INVERSE + "Inversed text" + RESET); WriteLn;
    WriteString(UNDERLINE + "Underlined text" + RESET); WriteLn;
END Constants.
