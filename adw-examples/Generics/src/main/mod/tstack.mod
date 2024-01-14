MODULE tstack;

IMPORT Stacks, ValidStacks;

FROM STextIO IMPORT
    WriteString, WriteLn;

FROM SWholeIO IMPORT
    WriteInt, WriteCard;


PROCEDURE validate(c : CARDINAL) : BOOLEAN;
BEGIN
    RETURN (c >= 0) AND (c <= 100);
END validate;

MODULE CardStack = ValidStacks(10, CARDINAL, validate);
EXPORT Push, Pop;
END CardStack;

MODULE IntStack = Stacks(10, INTEGER);
EXPORT QUALIFIED Push, Pop;
END IntStack;

VAR
    c   : CARDINAL;
    i   : INTEGER;
BEGIN
    IF Push(23) THEN
        IF Push(32) THEN
            Pop(c); WriteCard(c,1); WriteString("  ");
            Pop(c); WriteCard(c,1);
        END;
        WriteLn;
    END;

    IF IntStack.Push(-23) THEN
        IF IntStack.Push(-32) THEN
            IntStack.Pop(i); WriteInt(i,1); WriteString("  ");
            IntStack.Pop(i); WriteInt(i,1); WriteString("  ");
            WriteLn;
        END;
    END;

END tstack.
