# <span id="top">XDS Modula-2 examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;">
    <a href="https://link.springer.com/chapter/10.1007/978-3-642-96757-3_1" rel="external"><img style="border:0;width:100px;" src="../docs/images/pim4.png" width="100" alt="Modula-2"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>xds-examples\</code></strong> contains <a href="https://link.springer.com/chapter/10.1007/978-3-642-96757-3_1" rel="external" title="Modula-2">Modula-2</a> code examples taken from the XDS Modula-2 distribution.
  </td>
  </tr>
</table>

### <span id="exp">`exp` Example</span>

<pre style="font-size:80%;border:1px solid #cccccc;">
<b>&gt; <a href="./build.bat">build</a> -verbose clean run</b>
Create XDS project file "target\exp.prj"
Compile  Modula-2 source file into directory "target"
O2/M2 development system v2.60 TS  (c) 1991-2011 Excelsior, LLC. (build 07.06.2012)
Make project "F:\xds-examples\exp\target\exp.prj"
XDS Modula-2 v2.40 [x86, v1.50] - build 07.06.2012
Compiling "mod\exp.mod"
no errors, no warnings, lines  103, time  0.00
New "tmp.lnk" is generated using template "C:/opt/XDS-Modula-2/bin/xc.tem"

XDS Link Version 2.13.3 Copyright (c) Excelsior 1995-2009.
No errors, no warnings

   e = 2.7182818284590452353602874713526624977572470936999595749669676277
   64    2407663035354759457138217852516642742746639193200305992181741359
  128    6629043572900334295260595630738132328627943490763233829880753195
  192    2510190115738341879307021540891499348841675092447614606680822648
  256    0016847741185374234544243710753907774499206955170276183860626133
  320    1384583000752044933826560297606737113200709328709127443747047230
  384    6969772093101416928368190255151086574637721112523897844250569536
  448    9677078544996996794686445490598793163688923009879312773617821542
  512    4999229576351482208269895193668033182528869398496465105820939239
  576    8294887933203625094431173012381970684161403970198376793206832823
  640    7646480429531180232878250981945581530175671736133206981125099618
  704    1881593041690351598888519345807273866738589422879228499892086805
  768    8257492796104841984443634632449684875602336248270419786232090021
  832    6099023530436994184914631409343173814364054625315209618369088870
  896    7016768396424378140592714563549061303107208510383750510115747704
  960    1718986106873969655212671546889570350354021234078498193343210681
 1024
 </pre>

### <span id="queens">`queens` Example</span>

<pre style="font-size:80%;border:1px solid #cccccc;">
<b>&gt; <a href="./queens/build.bat">build</a> -verbose clean run</b>
Delete directory "target"
Create XDS project file "target\queens.prj"
Compile  Modula-2 source file into directory "target"
O2/M2 development system v2.60 TS  (c) 1991-2011 Excelsior, LLC. (build 07.06.2012)
Make project "F:\xds-examples\queens\target\queens.prj"
XDS Modula-2 v2.40 [x86, v1.50] - build 07.06.2012
Compiling "mod\queens.mod"
no errors, no warnings, lines   43, time  0.01
New "tmp.lnk" is generated using template "C:/opt/XDS-Modula-2/bin/xc.tem"

XDS Link Version 2.13.3 Copyright (c) Excelsior 1995-2009.
No errors, no warnings
Eight Queens Problem Benchmark
------------------------------

There are 92 solutions
</pre>

<pre style="font-size:80%;border:1px solid #cccccc;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [a-z]</b>
|   <a href="./queens/build.bat">build.bat</a>
|
+---src
|   \---mod
|           <a href="./queens/src/mod/queens.mod">queens.mod</a>
|
\---target
    |   queens.exe
    |   queens.obj
    |   queens.prj
    |   tmp.lnk
    |
    \---mod
            queens.mod
&nbsp;
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/type" rel="external">type</a> target\queens.prj</b>
-lookup = *.sym = sym;C:\opt\XDS-Modula-2\sym
-m2
-verbose
-werr
!module mod\queens.mod
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/January 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[apache_ant_cli]: https://ant.apache.org/manual/running.html
