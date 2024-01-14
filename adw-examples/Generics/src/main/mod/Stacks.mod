GENERIC IMPLEMENTATION MODULE Stacks(StackSize : CARDINAL; element : TYPE);

VAR
    Stack	: ARRAY [1..StackSize] OF element;
    StackSp	: CARDINAL;

PROCEDURE Push(item : element) : BOOLEAN;
BEGIN
    IF StackSp < StackSize THEN
        INC(StackSp);
	Stack[StackSp] := item;
	RETURN TRUE;
    END;
    RETURN FALSE;
END Push;

PROCEDURE Pop(VAR item : element);
BEGIN
    IF StackSp > 0 THEN
        item := Stack[StackSp];
        DEC(StackSp);
    END;
END Pop;

BEGIN
    StackSp := 0;
END Stacks.
