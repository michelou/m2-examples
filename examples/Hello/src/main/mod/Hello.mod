MODULE Hello;

(*This program prints "Hello world!" on the standard output device*)

FROM InOut IMPORT (*Read,*) WriteString, WriteLn;

(*VAR ch: CHAR;*)

BEGIN
    WriteString('Hello world!');
    WriteLn;
    (*Read(ch);*)
END Hello.
