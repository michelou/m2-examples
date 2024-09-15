# <span id="top">Winkler's Modula-2 Examples</span> <span style="font-size:90%;">[↩](../README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 8px 0 0;;min-width:160px;">
    <a href="https://en.wikipedia.org/wiki/Modula-2" rel="external"><img src="../docs/images/m2-logo.png" width="160" alt="Modula-2 project"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>winkler-examples\</code></strong> contains <a href="https://en.wikipedia.org/wiki/Modula-2" rel="external">Modula-2</a> code examples from the web page <a href="http://www.eckart-winkler.de/computer/modula2.htm" rel="external">Die Programmiersprache Modula-2</a> which reproduces two articles written by Eckart Winkler (1987 and 1989).
  </td>
  </tr>
</table>

## <span id="code">`Code` Example</span>

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /f /a . | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./Code/build.bat">build.bat</a>
|   <a href="./Code/build.sh">build.sh</a>
|   <a href="./Code/Makefile">Makefile</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>mod</b>
                <a href="./Code/src/main/mod/Code.mod">Code.mod</a>
</pre>

Command [**`build.bat`**](./Code/build.bat)`-verbose clean run` generates and executes the Modula-2 program `target\Code.exe` :

<pre style="font-size:80%;">
(* tbd *)
</pre>

<!--=======================================================================-->

## <span id="felder">`Felder` Example</span>

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /f /a . | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./Felder/build.bat">build.bat</a>
|   <a href="./Felder/build.sh">build.sh</a>
|   <a href="./Felder/Makefile">Makefile</a>
\---src
    \---<b>main</b>
        +---<b>mod</b>
        |       <a href="./Felder/src/main/mod/Felder.mod">Felder.mod</a>
        \---mod-adw
                <a href="./Felder/src/main/mod-adw/Felder.mod">Felder.mod</a>
</pre>

Command [**`build.bat`**](./Felder/build.bat)`-verbose clean run` generates and executes the Modula-2 program `target\Felder.exe` :

<pre style="font-size:80%;">
(* tbd *)
</pre>

<!--=======================================================================-->

## <span id="nullstellen">`Nullstellen` Example</span>

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /f /a . | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./Nullstellen/build.bat">build.bat</a>
|   <a href="./Nullstellen/build.sh">build.sh</a>
|   <a href="./Nullstellen/Makefile">Makefile</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>mod</b>
                <a href="./Nullstellen/src/main/mod/Nullstellen.mod">Nullstellen.mod</a>
</pre>

Command [**`build.bat`**](./Nullstellen/build.bat)`-verbose clean run` generates and executes the Modula-2 program `target\Nullstellen.exe` :

<pre style="font-size:80%;">
(* tbd *)
</pre>

<!--=======================================================================-->

## <span id="wuerfelspiel">`WuerfelSpiel` Example</span>

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /f /a . | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./WuerfelSpiel/00download.txt">00download.txt</a>
|   <a href="./WuerfelSpiel/build.bat">build.bat</a>
|   <a href="./WuerfelSpiel/build.sh">build.sh</a>
|   <a href="./WuerfelSpiel/Makefile">Makefile</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>mod</b>
                <a href="./WuerfelSpiel/src/main/mod/WuerfelSpiel.mod">WuerfelSpiel.mod</a>
</pre>

Command [**`build.bat`**](./WuerfelSpiel/build.bat)`-verbose run` fails to compile the Modula-2 source code; both the ADW and the XDS compiler can't find the identifiers `SIZE`, `PROCESS`, `NEWPROCESS` and `TRANSFER` in the imported module `SYSTEM` :

<pre style="font-size:80%;">
<b>&gt; <a href="">build</a> -verbose clean run</b>
Create XDS project file "target\WuerfelSpiel.prj"
Compile 1 Modula-2 implementation module into directory "target"
O2/M2 development system v2.60 TS  (c) 1991-2011 Excelsior, LLC. (build 07.06.2012)
Make project "F:\winkler-examples\WuerfelSpiel\target\WuerfelSpiel.prj"
XDS Modula-2 v2.40 [x86, v1.50] - build 07.06.2012
Compiling "F:\winkler-examples\WuerfelSpiel\target\mod\WuerfelSpiel.mod"

* [F:\winkler-examples\WuerfelSpiel\target\mod\WuerfelSpiel.mod 3.31 E020]
* undeclared identifier "SIZE"
FROM SYSTEM IMPORT WORD, ADR, <b>$SIZE</b>, PROCESS, NEWPROCESS, TRANSFER;

* [F:\winkler-examples\WuerfelSpiel\target\mod\WuerfelSpiel.mod 3.37 E020]
* undeclared identifier "PROCESS"
FROM SYSTEM IMPORT WORD, ADR, SIZE, <b>$PROCESS</b>, NEWPROCESS, TRANSFER;

* [F:\winkler-examples\WuerfelSpiel\target\mod\WuerfelSpiel.mod 3.46 E020]
* undeclared identifier "NEWPROCESS"
FROM SYSTEM IMPORT WORD, ADR, SIZE, PROCESS, $NEWPROCESS, TRANSFER;

* [F:\winkler-examples\WuerfelSpiel\target\mod\WuerfelSpiel.mod 3.58 E020]
* undeclared identifier "TRANSFER"
FROM SYSTEM IMPORT WORD, ADR, SIZE, PROCESS, NEWPROCESS, <b>$TRANSFER</b>;

* [F:\winkler-examples\WuerfelSpiel\target\mod\WuerfelSpiel.mod 4.06 F425]
* file open error: "Terminal2.sym" no such file
FROM $Terminal2 IMPORT WriteCard, WriteString, WriteLn, ReadCard;
errors  5, no warnings, lines    4, time  0.01
Error: Failed to compile 1 Modula-2 implementation module into directory "target"
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/September 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- href links -->
