GENERIC IMPLEMENTATION MODULE ValidStacks(StackSize : CARDINAL;
					  Element : TYPE;
					  Validate : ValidProcType);

IMPORT Stacks;

MODULE MyStack = Stacks(StackSize, Element);
EXPORT QUALIFIED Push, Pop;
END MyStack;

PROCEDURE Push(item : Element) : BOOLEAN;
BEGIN
    IF Validate(item) THEN
        RETURN MyStack.Push(item);
    END;
    RETURN FALSE;
END Push;

PROCEDURE Pop(VAR item : Element);
BEGIN
    MyStack.Pop(item);
END Pop;

END ValidStacks.
