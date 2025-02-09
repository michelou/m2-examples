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

Modula-2 examples presented below share two characteristics :
- they can be built/run with 3 different command line tools.
- their source code can be compiled with 2 Modula-2 compilers.

| Build&nbsp;tool | Build&nbsp;script  | Build&nbsp;option | Parent&nbsp;file |
|:----------------|:-------------------|:------|:-----------------|
| [**`cmd.exe`**][cmd_cli] | [`build.bat`](./Factorial/build.bat) | `-adw`, `-xds` | |
| [**`make.exe`**][make_cli] | [`Makefile`](./Factorial/Makefile) | `TOOLSET=adw\|xds` | [`Makefile.inc`](./Makefile.inc) |
| [**`sh.exe`**][sh_cli]  | [`build.sh`](./Factorial/build.sh) | `-adw`, `-xds` | |

<!--=======================================================================-->

### <span id="factorial">`Factorial` Example</span>

This project has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /b /v [A-Z]</b>
|   <a href="./Factorial/build.bat">build.bat</a>
|   <a href="./Factorial/build.sh">build.sh</a>
|   <a href="./Factorial/Makefile">Makefile</a>
\---<b>src</b>
    \---<b>main</b>
        +---<b>mod</b>
        |       <a href="./Factorial/src/main/mod/Factorial.mod">Factorial.mod</a>
        \---<b>mod-adw</b>
                <a href="./Factorial/src/main/mod-adw/Factorial.mod">Factorial.mod</a>
</pre>

> **Note**: We maintain two source versions of `Factorial.mod` as the import clauses differ between ADW Modula-2 and XDS Modula-2 (options `-adw` and `-xds` &ndash; the default &ndash; allow us to switch between both versions).

Batch file [**`build.bat`**](./Factorial/build.bat)`clean run` generates and executes the Modula-2 program `target\Factorial.exe` :

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
Iterative Factorial function
  0           1
  1           1
  2           2
  3           6
  4          24
  5         120
  6         720
  7        5040
  8       40320
&nbsp;
Tail recursive Factorial function
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

> **Note**: The other two build scripts [`build.sh`](./Factorial/build.sh) and [`Makefile`](./Factorial/Makefile) work in the same way.

The output directory `target\` looks as follows when using build option `-xds` (default) :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f target | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
|   Factorial.exe
|   Factorial.obj
|   Factorial.prj
|   tmp.lnk
\---<b>mod</b>
        Factorial.mod
</pre>

We first create the project file `target\Factorial.prj` and then invoke the XDS compiler with option **`=p`**`<project file>` :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/type">type</a> target\Factorial.prj</b>
-cpu = 486
-lookup = *.sym = sym;C:\opt\XDS-Modula-2\sym
-lookup = *.dll|*.lib = bin;C:\opt\XDS-Modula-2\bin
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

The output directory `target\` looks as follows when using build option `-adw` :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f /a target | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
|   Factorial.exe
|   Factorial.map
|   linker_opts.txt
+---<b>mod</b>
|       Factorial.mod
|       Factorial.obj
|       Terminal2.obj
\---<b>sym</b>
        AES.sym
        [...]
        Terminal2.sym
        [...]
        WINX.sym
</pre>

We create the response file `linker_opts.txt` and give it as parameter to the ADW linker :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/type" rel="external">type</a> target\linker_opts.txt</b>
-MACHINE:X86_64
-SUBSYSTEM:CONSOLE
-MAP:G:\examples\Factorial\target\Factorial
-OUT:G:\examples\Factorial\target\Factorial.exe
-LARGEADDRESSAWARE
target\mod\Factorial.obj
target\mod\Terminal2.obj
C:\opt\ADW-Modula-2\ASCII\rtl-win-amd64.lib
C:\opt\ADW-Modula-2\ASCII\win64api.lib
</pre>

<!--=======================================================================-->

### <span id="fibonacci">`Fibonacci` Example</span> [**&#x25B4;**](#top)

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
|   <a href="./Fibonacci/00download.txt">00download.txt</a>
|   <a href="./Fibonacci/build.bat">build.bat</a>
|   <a href="./Fibonacci/build.sh">build.sh</a>
|   <a href="./Fibonacci/Makefile">Makefile</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>mod</b>
                <a href="./Fibonacci/src/main/mod/Fibonacci.mod">Fibonacci.mod</a>
</pre>

Command [**`build.bat`**](./Fibonacci/build.bat)`clean run` generates and execute the Modula-2 program `target\Fibonacci.exe` :

<pre style="font-size:80%;">
Recursive Fibonacci function
  0           0
  1           1
  2           1
  3           2
  4           3
  5           5
  6           8
  7          13
  8          21

Tail recursive Fibonacci function
  0           0
  [...]
  8          21

Iterative Fibonacci function
  0           0
  [...]
  8          21

Matrix Fibonacci function
  0           0
  [...]
  8          21
</pre>

<!--=======================================================================-->

### <span id="generic_sorting">`GenericSorting` Example</span> [**&#x25B4;**](#top)

This code example is presented in Wiener's article "[A generic sorting module in Modula-2"](https://dl.acm.org/doi/10.1145/948576.948588) (ACM SIGPLAN, Vol.19, Issue 3).
It has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
|   <a href="./GenericSorting/00download.txt">00download.txt</a>
|   <a href="./GenericSorting/build.bat">build.bat</a>
|   <a href="./GenericSorting/build.sh">build.sh</a>
|   <a href="./GenericSorting/Makefile">Makefile</a>
\---<b>src</b>
    +---<b>main</b>
    |   +---def</b>
    |   |       GenericSorting.def</a>
    |   \---<b>mod</b>
    |           <a href="./GenericSorting/src/main/mod/GenericSorting.mod">GenericSorting.mod</a>
    \---<b>test</b>
        \---<b>mod</b>
                <a href="./GenericSorting/src/test/mod/TestGenericSorting.mod">TestGenericSorting.mod</a>
</pre>

Command [**`build.bat`**](./GenericSorting/build.bat)`clean run` generates and execute the Modula-2 program `target\TestGenericSorting.exe` :

<pre style="font-size:80%;">
<b>&gt; <a href="./GenericSorting/build.bat">build</a> -verbose clean run</b>
Compile Modula-2 definition module "target\def\GenericSorting.def"
XDS Modula-2 v2.40 [x86, v1.50] - build 07.06.2012
Compiling "N:\examples\GenericSorting\target\def\GenericSorting.def"
no errors, no warnings, lines   14, time  0.01, new symfile
Create XDS project file "target\GenericSorting.prj"
Compile 1 Modula-2 implementation module into directory "target"
O2/M2 development system v2.60 TS  (c) 1991-2011 Excelsior, LLC. (build 07.06.2012)
Make project "N:\examples\GenericSorting\target\GenericSorting.prj"
#file "N:\examples\GenericSorting\target\GenericSorting.prj" (line 8.23): syntax error
XDS Modula-2 v2.40 [x86, v1.50] - build 07.06.2012
Compiling "N:\examples\GenericSorting\target\mod\GenericSorting.mod"
no errors, no warnings, lines   66, time  0.01
New "tmp.lnk" is generated using template "C:/opt/XDS-Modula-2/bin/xc.tem"

XDS Link Version 2.13.3 Copyright (c) Excelsior 1995-2009.
No errors, no warnings
Create library file into directory "target"
Compile 1 Modula-2 test source file into directory "target"
O2/M2 development system v2.60 TS  (c) 1991-2011 Excelsior, LLC. (build 07.06.2012)
Make project "N:\examples\GenericSorting\target\TestGenericSorting.prj"
XDS Modula-2 v2.40 [x86, v1.50] - build 07.06.2012
Compiling "test\TestGenericSorting.mod"
no errors, no warnings, lines  199, time  0.01
New "tmp.lnk" is generated using template "C:/opt/XDS-Modula-2/bin/xc.tem"

XDS Link Version 2.13.3 Copyright (c) Excelsior 1995-2009.
No errors, no warnings
Enter real number 11 :
[...]
</pre>

<!--=======================================================================-->

### <span id="hello">`Hello` Example</span>

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /b /v [A-Z]</b>
|   <a href="./Hello/build.bat">build.bat</a>
|   <a href="./Hello/build.sh">build.sh</a>
|   <a href="./Hello/Makefile">Makefile</a>
\---<b>src</b>
    \---<b>main</b>
        +---<b>mod</b>
        |       <a href="./Hello/src/main/mod/Hello.mod">Hello.mod</a>
        \---<b>mod-adw</b>
                <a href="./Hello/src/main/mod-adw/Hello.mod">hello.mod</a>
</pre>

Command [**`build.bat`**](./Hello/build.bat)`clean run` generates and executes the Modula-2 program `target\Hello.exe` :

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

> **Note:** The other two build scripts [`build.sh`](./Hello/build.sh) and [`Makefile`](./Hello/Makefile).work in the same way and the generated files in output directory `target\` are similar to the ones in example [`Factorial`](#factorial).

<!--=======================================================================-->

### <span id="liste">`Liste` Example</span> [**&#x25B4;**](#top)

This example is about creating a Modula-2 library; it contains the 3 source files [`Liste.def`](./Liste/src/main/def/Liste.def), [`Liste.mod`](./Liste/src/main/mod/Liste.mod) and [`ListeTest.mod`](./Liste/src/test/mod/ListeTest.mod).

Batch file [**`build.bat`**](./Liste/build.bat)`-verbose clean run` generates both the library `target\Liste.lib` and the test program `target\ListeTest.exe` :

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
+---<b>def</b>
|       Liste.def
+---<b>mod</b>
|       Liste.mod
+---<b>sym</b>
|       Liste.sym
\---<b>test</b>
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

<!--=======================================================================-->

### <span id="pascal">`PascalTriangle` Example</span> [**&#x25B4;**](#top)

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /b /v [A-Z]</b>
|   <a href="./PascalTriangle/build.bat">build.bat</a>
|   <a href="./PascalTriangle/build.sh">build.sh</a>
|   <a href="./PascalTriangle/Makefile">Makefile</a>
\---<b>src</b>
    \---<b>main</b>
        \---<b>mod</b>
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

*[mics](https://lampwww.epfl.ch/~michelou/)/February 2025* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[apache_ant_cli]: https://ant.apache.org/manual/running.html
[cmd_cli]: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/cmd
[make_cli]: https://www.gnu.org/software/make/manual/html_node/Running.html
[sh_cli]: https://man7.org/linux/man-pages/man1/sh.1p.html
