# <span id="top">XDS Modula-2 Quick Reference</span> <span style="font-size:90%;">[↩](README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;;min-width:120px;"><a href="https://"><img src="docs/imagess/m2.svg" width="120" alt="XDS Modula-2"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This document gathers <a href="https://" rel="external">XDS Modula-2</a> related informations.
  </td>
  </tr>
</table>

## <span id="scenarios">Build scenarios</span>

We typically have to deal with one of the following build scenarios :
- we build a Modula-2 *application*.
- we build a Modula-2 *library*.

In most cases our program will depend on one or more Modula-2 libraries :
- XDS standard libraries such as **`InOut`**,
- user-defined libraries such as **`Terminal2`** (see below).

### <span id="application">Scenario 1 &ndash; Building an application</span>

This scenario is the simple one :
1. We just need the XDS compiler **`xc.exe`**.
2. **`xc.exe`** works relative to the current working directory so we define **`target`** as our working directory
   - where we copy resp. generate the input files &ndash; e.g. the project file &ndash; and
   - which we set as the working directory before running **`xc.exe`**.

Example **`Hello`** has the following directory structure :

<pre style="font-size:80%;border:1px solid #cccccc;">
<b>&gt; <a href="https://learn.microsoft.com/fr-fr/windows-server/administration/windows-commands/cd">cd</a></b>
F:\examples\Hello
&nbsp;
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f /a . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
|   <a href="./examples/Hello/build.bat">build.bat</a>
|   <a href="./examples/Hello/build.sh">build.sh</a>
|   <a href="./examples/Hello/Makefile">Makefile</a>
\---<b>src</b>
    \---<b>main</b>
        +---<b>mod</b>
        |       <a href="./examples/Hello/src/main/mod/hello.mod">hello.mod</a>
        \---<b>mod-adw</b>
                <a href="./examples/Hello/src/main/mod-adw/hello.mod">hello.mod</a>
</pre>

The working directory **`target\`** looks as follows after executing the build command :

<pre style="font-size:80%;border:1px solid #cccccc;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f /a target | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
|   Hello.exe
|   Hello.obj
|   Hello.prj
|   tmp.lnk
\---<b>mod</b>
        hello.mod
</pre>

- The input files are :
  - 1 source file `mod\hello.mod` we simply copy from our source directory.
  - 1 project file `Hello.prj` we create before invoking the XDS compiler with option **`=p`**`<project_file>`. For instance <sup id="anchor_01">[1](#footnote_01)</sup> :
  <pre style="font-size:80%;border:1px solid #cccccc">
    <b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/type">type</a> target\Hello.prj</b>
    -cpu = 486
    -lookup = *.sym = sym;C:\opt\XDS-Modula-2\sym
    -lookup = *.dll|*.lib = bin;C:\opt\XDS-Modula-2\bin
    -m2
    <span style="color:green;">% -verbose</span>
    -werr
    <span style="color:green;">% main module of the program</span>
    !module mod\Hello.mod
    </pre>
- The output files are `Hello.obj` and `Hello.exe`.

> **Note:** See the PDF document **`C:\opt\XDS-Modula-2\pdf\xc.pdf`** for more details.

<!--=================================================================-->

### <span id="library">Scenario 2 &ndash; Building a library</span> 

This scenario is more involved :
1. We need both the XDS compiler **`xc.exe`** and the XDS library manager **`xlib.exe`**.
2. Again we define **`target`** as our build directory
   - where we copy resp. generate the input files &ndash; e.g. the project files &ndash; and
   - which we set as the working directory before running the XDS tools.

The project directory for the **`Terminal2`** library looks as follows  :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/fr-fr/windows-server/administration/windows-commands/cd">cd</a></b>
F:\examples\Terminal2
&nbsp;
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /f /a . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./examples/Terminal2/build.bat">build.bat</a>
|   <a href="./examples/Terminal2/build.sh">build.sh</a>
|   <a href="./examples/Terminal2/Makefile">Makefile</a>
\---<b>src</b>
    +---<b>main</b>
    |   +---<b>def</b>
    |   |       <a href="./examples/Terminal2/src/main/def/Terminal2.def">Terminal2.def</a>
    |   +---<b>mod</b>
    |   |       <a href="./examples/Terminal2/src/main/mod/Terminal2.mod">Terminal2.mod</a>
    |   \---<b>mod-adw</b>
    |           <a href="./examples/Terminal2/src/main/mod-adw/Terminal2.mod">Terminal2.mod</a>
    \---<b>test</b>
        \---<b>mod</b>
                <a href="./examples/Terminal2/src/test/mod/Terminal2Test.mod">Terminal2Test.mod</a>
</pre>

The working directory **`target\`** looks as follows after executing the build command :

<pre style="font-size:80%;border:1px solid #cccccc;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f /a target | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
  |   Terminal2.dll
  |   Terminal2.lib
  |   Terminal2.obj
  |   Terminal2.prj
  |   Terminal2Test.exe
  |   Terminal2Test.obj
  |   Terminal2Test.prj
  |   tmp.lnk
  +---<b>def</b>
  |       Terminal2.def
  +---<b>mod</b>
  |       Terminal2.mod
  +---<b>sym</b>
  |       Terminal2.sym
  \---<b>test</b>
          Terminal2Test.mod
</pre>

- The input files are :
  - 3 source files `def\Terminal2.def`, `mod\Terminal2.mod` and  `test\Terminal2Test.mod` (test module) we simply copy from our source directory.
  - 2 project files `Terminal2.prj` and `Terminal2Test.prj` we create before invoking the XDS compiler with option **`=p`**`<project_file>`. For instance <sup>[1](#footnote_01)</sup>  :
  <pre style="font-size:80%;border:1px solid #cccccc">
    <b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/type">type</a> target\Terminal2.prj</b>
    <span style="color:green;">% write -gendll- to generate an .exe</span>
    -gendll+
    -usedll+
    -dllexport+
    -implib-
    -cpu = 486
    -lookup = *.sym = sym;C:\opt\XDS-Modula-2\sym
    -lookup = *.dll|*.lib = bin;C:\opt\XDS-Modula-2\bin
    -m2
    <span style="color:green;">% -verbose</span>
    -werr
    <span style="color:green;">% main module of the program</span>
    !module mod\Terminal2.mod
    </pre>
- The output files are `Terminal2.dll`, `Terminal2.lib`, `Terminal2.obj`, `Terminal2Text.obj`and `Terminal2Text.exe`.

Finally we support 3 ways to build a Modula-2 library, namely with a batch file (**`build.bat`**), a shell script (**`build.sh`**) or a GNU make file (**`Makefile`**). For instance :
<pre style="font-size:80%;">
<b>&gt; <a href="./examples/Terminal2/build.bat">build</a></b>
Usage: build { &lt;option&gt; | &lt;subcommand&gt; }
&nbsp;
  Options:
    -adw         select ADW Modula-2 toolset
    -debug       print commands executed by this script
    -gm2         select GNU Modula-2 toolset
    -verbose     print progress messages
    -xds         select XDS Modula-2 toolset (default)
&nbsp;
  Subcommands:
    clean        delete generated object files
    compile      compile Modula-2 source files
    install      install library into directory "..\lib\xds"
    run          execute program "Terminal2Test"
</pre> 

We execute the subcommand **`install`** to install the generated files into directory **`lib\xds\`** such that Modula-2 application can refer to them via an **`IMPORT`** clause :

<pre style="font-size:80%;">
<b>&gt; cd</b>
F:\examples\lib
&nbsp;
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f /a . | findstr /v /b [A-Z]</b>
\---xds
        Liste.dll
        Liste.lib
        Liste.obj
        Liste.sym
        Terminal2.dll
        Terminal2.lib
        Terminal2.sym
</pre>

<!--=======================================================================-->

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> ***Additional MSYS packages*** [↩](#anchor_01)

<dl><dd style="margin:6px;">
The following command prints the full list of compiler options :
<pre style="font-size:80%;">
<b>&gt; "%XDS_HOME%\bin\xc.exe" =compile =options</b>
  Options:
  -ALWAYSINLINE      +ASSERT            -BSALPHA           -BSCLOSURE
  -BSREDEFINE        -CHANGESYM         +CHECKDINDEX       +CHECKDIV
[...]
</pre>
</dl></dd>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/August 2024* [**&#9650;**](#top)  <!-- February 2023 -->

<span id="bottom">&nbsp;</span>

<!-- href links -->
