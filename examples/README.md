# <span id="top">Modula-2 examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;">
    <a href="https://link.springer.com/chapter/10.1007/978-3-642-96757-3_1/" rel="external"><img style="border:0;width:100px;" src="../docs/images/pim4.png" width="100" alt="Modula-2"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>examples\</code></strong> contains <a href="https://link.springer.com/chapter/10.1007/978-3-642-96757-3_1" rel="external" title="Modula-2">Modula-2</a> code examples taken from the XDS Modula-2 distribution.
  </td>
  </tr>
</table>

### <span id="factorial">`Factorial` Example</span>

The project directory is organized as follows :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /b /v [A-Z]</b>
|   <a href="./Factorial/build.bat">build.bat</a>
|   <a href="./Factorial/build.sh">build.sh</a>
|   <a href="./Factorial/Makefile">Makefile</a>
|
\---src
    \---main
        +---mod
        |       <a href="./Factorial/src/main/mod/Factorial.mod">Factorial.mod</a>
        |
        \---mod-adw
                <a href="./Factorial/src/main/mod-adw/Factorial.mod">Factorial.mod</a>
</pre>

> **Note**: We maintain two source versions of `Factorial.mod` as the import clauses differ between ADW Modula-2 and XDS Modula-2 (options `-adw` and `-xds` &ndash; the default &ndash; allow us to switch between both versions).

We generate the application using one of the build scripts [`build.bat`](./Factorial/build.bat), [`build.sh`](./Factorial/build.sh) or [`Makefile`](./Factorial/Makefile).

<pre style="font-size:80%;">
<b>&gt; <a href="./Factorial/build.bat">build</a> -verbose clean run</b>
Delete directory "target"
Create XDS project file "target\Factorial.prj"
Compile 1 Modula-2 implementation module into directory "target"
O2/M2 development system v2.60 TS  (c) 1991-2011 Excelsior, LLC. (build 07.06.2012)
Make project "J:\examples\Factorial\target\Factorial.prj"
XDS Modula-2 v2.40 [x86, v1.50] - build 07.06.2012
Compiling "mod\Factorial.mod"
no errors, no warnings, lines   33, time  0.01
New "tmp.lnk" is generated using template "C:/opt/XDS-Modula-2/bin/xc.tem"

XDS Link Version 2.13.3 Copyright (c) Excelsior 1995-2009.
No errors, no warnings
Execute program "target\Factorial.exe"
  0           1
  1           1
  2           2
  3           6
  4          24
  5         120
  6         720
  7        5040
  8       40320
</pre>

The output directory `target\` looks as follows :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f target | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
|   Factorial.exe
|   Factorial.obj
|   Factorial.prj
|   tmp.lnk
\---mod
        Factorial.mod
</pre>

The generated project file `target\Factorial.prj` contains the XDS compiler options and the source files (`mod\Factorial.mod` in this case) :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/type">type</a> target\Factorial.prj</b>
-cpu = 486
-lookup = *.sym = sym;C:\opt\XDS-Modula-2\sym
-m2
% recognize types SHORTINT, LONGINT, SHORTCARD and LONGCARD
% -m2addtypes
-verbose
-werr
% disable warning 301 (parameter "xxx" is never used)
-woff301+
% disable warning 303 (procedure "xxx" declared but never used)
-woff303+
!module mod\Factorial.mod
</pre>

### <span id="hello">`Hello` Example</span>

The project directory is organized as follows :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /b /v [A-Z]</b>
|   <a href="./Hello/build.bat">build.bat</a>
|   <a href="./Hello/build.sh">build.sh</a>
|   <a href="./Hello/Makefile">Makefile</a>
|
\---src
    \---main
        +---mod
        |       <a href="./Hello/src/main/mod/Hello.mod">Hello.mod</a>
        |
        \---mod-adw
                <a href="./Hello/src/main/mod-adw/Hello.mod">hello.mod</a>
</pre>

We generate the application using one of the build scripts such as [`build.bat`](./Hello/build.bat), [`build.sh`](./Hello/build.sh) or [`Makefile`](./Hello/Makefile).

<pre style="font-size:80%;">
<b>&gt; <a href="./Hello/build.bat">build</a> -verbose clean run</b>
Delete directory "target"
Create XDS project file "target\Hello.prj"
Compile  Modula-2 implementation module into directory "target"
O2/M2 development system v2.60 TS  (c) 1991-2011 Excelsior, LLC. (build 07.06.2012)
Make project "J:\examples\Hello\target\Hello.prj"
XDS Modula-2 v2.40 [x86, v1.50] - build 07.06.2012
Compiling "mod\hello.mod"
no errors, no warnings, lines   13, time  0.01
New "tmp.lnk" is generated using template "C:/opt/XDS-Modula-2/bin/xc.tem"

XDS Link Version 2.13.3 Copyright (c) Excelsior 1995-2009.
No errors, no warnings
Execute program "target\Hello.exe"
Hello world!
</pre>

> **Note:** The generated files in output directory `target\` are similar to the ones in example [`Factorial`](#factorial).

### <span id="liste">`Liste` Example</span>

The `Liste` code example is about creating a Modula-2 library; it contains the 3 source files [`Liste.def`](./Liste/src/main/def/Liste.def), [`Liste.mod`](./Liste/src/main/mod/Liste.mod) and [`ListeTest.mod`](./Liste/src/test/mod/ListeTest.mod). We generate the library and the test program using one of the build scripts [`build.bat`](./Hello/build.bat), [`build.sh`](./Hello/build.sh) or [`Makefile`](./Hello/Makefile).

<pre style="font-size:80%;">
<b>&gt; <a href="./Liste/build.bat">build</a> -verbose clean run</b>
Delete directory "target"
Compile Modula-2 definition module "target\def\Liste.def"
XDS Modula-2 v2.40 [x86, v1.50] - build 07.06.2012
Compiling "J:\examples\Liste\target\def\Liste.def"
no errors, no warnings, lines   10, time  0.00, new symfile
Create XDS project file "target\Liste.prj"
Compile 1 Modula-2 implementation module into directory "target"
O2/M2 development system v2.60 TS  (c) 1991-2011 Excelsior, LLC. (build 07.06.2012)
Make project "J:\examples\Liste\target\Liste.prj"
XDS Modula-2 v2.40 [x86, v1.50] - build 07.06.2012
Compiling "mod\Liste.mod"
no errors, no warnings, lines  136, time  0.00
New "tmp.lnk" is generated using template "C:/opt/XDS-Modula-2/bin/xc.tem"

XDS Link Version 2.13.3 Copyright (c) Excelsior 1995-2009.
No errors, no warnings
Create library file into directory "target"
Compile 1 Modula-2 test module into directory "target"
O2/M2 development system v2.60 TS  (c) 1991-2011 Excelsior, LLC. (build 07.06.2012)
Make project "J:\examples\Liste\target\ListeTest.prj"
XDS Modula-2 v2.40 [x86, v1.50] - build 07.06.2012
Compiling "test\ListeTest.mod"
no errors, no warnings, lines   21, time  0.00
New "tmp.lnk" is generated using template "C:/opt/XDS-Modula-2/bin/xc.tem"

XDS Link Version 2.13.3 Copyright (c) Excelsior 1995-2009.
No errors, no warnings
    0     1     2     3     4     5
    0     1     2     3     4     5     6     7     8     9    10    11    12
    6     7     8     8     9    10    11    12
</pre>

The output directory `target\` looks as follows : 
<pre style="font-size:80%;">
<b>&gt; <a href="">tree</a> /a /f target | <a href="">findstr</a> /v /b [A-Z]</b>
|   Liste.dll
|   Liste.lib
|   Liste.obj
|   Liste.prj
|   ListeTest.exe
|   ListeTest.obj
|   ListeTest.prj
|   tmp.lnk
+---def
|       Liste.def
+---mod
|       Liste.mod
+---sym
|       Liste.sym
\---test
        ListeTest.mod
</pre>

The generated project file `target\Liste.prj` contains the XDS compiler options and the source files (`mod\Liste.mod` in this case) :

<pre style="font-size:80%;">
<b>&gt; <a href="">type</a> target\Liste.prj</b>
% debug ON
-gendebug+
-genhistory+
-lineno+
% write -gendll- to generate an .exe
-gendll+
-usedll+
-dllexport+
-implib-
-cpu = 486
-lookup = *.sym = sym;C:\opt\XDS-Modula-2\sym
-m2
% recognize types SHORTINT, LONGINT, SHORTCARD and LONGCARD
% -m2addtypes
-verbose
-werr
% disable warning 301 (parameter "xxx" is never used)
-woff301+
% disable warning 303 (procedure "xxx" declared but never used)
-woff303+
!module mod\Liste.mod
</pre>

### <span id="pascal">`PascalTriangle` Example</span>

The project directory is organized as follows  :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /b /v [A-Z]</b>
|   <a href="./PascalTriangle/build.bat">build.bat</a>
|   <a href="./PascalTriangle/build.sh">build.sh</a>
|   <a href="./PascalTriangle/Makefile">Makefile</a>
|
\---src
    \---main
        \---mod
                <a href="./PascalTriangle/src/main/mod/PascalTriangle.mod">PascalTriangle.mod</a>
</pre>

We generate the application using one of the build scripts [`build.bat`](./PascalTriangle/build.bat), [`build.sh`](./PascalTriangle/build.sh) or [`Makefile`](./PascalTriangle/Makefile).

<pre style="font-size:80%;">
<b>&gt; <a href="./PascalTriangle/build.bat">build</a> -verbose clean run</b>
Delete directory "target"
Create XDS project file "target\PascalTriangle.prj"
Compile  Modula-2 implementation module into directory "target"
O2/M2 development system v2.60 TS  (c) 1991-2011 Excelsior, LLC. (build 07.06.2012)
Make project "J:\examples\PascalTriangle\target\PascalTriangle.prj"
#file "J:\examples\PascalTriangle\target\PascalTriangle.prj" (line 1): syntax error
XDS Modula-2 v2.40 [x86, v1.50] - build 07.06.2012
Compiling "mod\PascalTriangle.mod"
no errors, no warnings, lines   42, time  0.01
New "tmp.lnk" is generated using template "C:/opt/XDS-Modula-2/bin/xc.tem"

XDS Link Version 2.13.3 Copyright (c) Excelsior 1995-2009.
No errors, no warnings
Execute program "target\PascalTriangle.exe"
Triangle height=3
        1
      1   1
    1   2   1

Triangle height=4
          1
        1   1
      1   2   1
    1   3   3   1

Triangle height=5
            1
          1   1
        1   2   1
      1   3   3   1
    1   4   6   4   1

Triangle height=6
              1
            1   1
          1   2   1
        1   3   3   1
      1   4   6   4   1
    1   5  10  10   5   1

Triangle height=7
                1
              1   1
            1   2   1
          1   3   3   1
        1   4   6   4   1
      1   5  10  10   5   1
    1   6  15  20  15   6   1
</pre>

> **Note:** The generated files in output directory `target\` are similar to the ones in example [`Factorial`](#factorial).

***

*[mics](https://lampwww.epfl.ch/~michelou/)/August 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[apache_ant_cli]: https://ant.apache.org/manual/running.html
