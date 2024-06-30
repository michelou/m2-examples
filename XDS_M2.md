# <span id="top">XDS Modula-2 Quick Reference</span> <span style="font-size:90%;">[↩](README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;;min-width:120px;"><a href="https://"><img src="docs/imagess/m2.svg" width="120" alt="XDS Modula-2"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This document gathers <a href="https://" rel="external">XDS Modula-2</a> related informations.
  </td>
  </tr>
</table>

In this project we deal with two build scenarios :
- we build a *Modula-2 application*.
- we build a *Modula-2 library*.

In most cases our code will depend on some other Modula-2 libraries :
- XDS standard libraries such as **`InOut`**,
- user-defined libraries such as **`Terminal2`** (see below).

### <span id="application">Application builds</span>

This scenario is the simple one :
1. We only need the XDS compiler **`xc.exe`**.
2. **`xc.exe`** works relative to the current working directory so we define **`target`** as our build directory
   - where we copy resp. generate the input files &ndash; e.g. the project file &ndash; and
   - which we set as the working directory before running **`xc.exe`**.

The project directory for the **`Hello`** application is organized as follows :

<pre style="font-size:80%;border:1px solid #cccccc;">
<b>&gt; <a href="https://learn.microsoft.com/fr-fr/windows-server/administration/windows-commands/cd">cd</a></b>
F:\examples\Hello
&nbsp;
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f /a . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
|   <a href="./examples/Hello/build.bat">build.bat</a>
|   <a href="./examples/Hello/build.sh">build.sh</a>
|   <a href="./examples/Hello/Makefile">Makefile</a>
\---src
    \---main
        +---mod
        |       <a href="./examples/Hello/src/main/mod/hello.mod">hello.mod</a>
        \---mod-adw
                <a href="./examples/Hello/src/main/mod-adw/hello.mod">hello.mod</a>
</pre>

Let's now have a closer look at the build directory **`target`** :

<pre style="font-size:80%;border:1px solid #cccccc;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f /a target | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
|   Hello.exe
|   Hello.obj
|   Hello.prj
|   tmp.lnk
|
\---mod
        hello.mod
</pre>

- Input files for the **`Hello`** application are just one top-level module (**`target\mod\`**).
- The XDS compiler provides option **`=p <project_file>`** to specify the build configuration; we generate the project file **`Hello.prj`** during the build process and pass it as argument to the XDS compiler. For instance :
  <pre style="font-size:80%;border:1px solid #cccccc">
    <b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/type">type</a> target\Hello.prj</b>
    -cpu = 486
    -lookup = *.sym = sym;C:\opt\XDS-Modula-2\sym
    -m2
    -verbose
    -werr
    <span style="color:green;">% main module of the program</span>
    !module mod\Hello.mod
    </pre>

> **Note:** See the PDF document **`C:\opt\XDS-Modula-2\pdf\xc.pdf`** for more details.

<!--=================================================================-->

### <span id="library">Library builds</span> 

This scenario is more involved :
1. We need both the XDS compiler **`xc.exe`** and the XDS library manager **`xlib.exe`**.
2. As for the [application builds](#application) we define **`target`** as our build directory
   - where we copy resp. generate the input files &ndash; e.g. the project files &ndash; and
   - which we set as the working directory before running the tools.

The project directory for the **`Terminal2`** library looks as follows  :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/fr-fr/windows-server/administration/windows-commands/cd">cd</a></b>
F:\examples\Terminal2
&nbsp;
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f /a . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
|   <a href="./examples/Terminal2/build.bat">build.bat</a>
|   <a href="./examples/Terminal2/build.sh">build.sh</a>
|   <a href="./examples/Terminal2/Makefile">Makefile</a>
\---src
    +---main
    |   +---def
    |   |       <a href="./examples/Terminal2/src/main/def/Terminal2.def">Terminal2.def</a>
    |   +---mod
    |   |       <a href="./examples/Terminal2/src/main/mod/Terminal2.mod">Terminal2.mod</a>
    |   \---mod-adw
    |           <a href="./examples/Terminal2/src/main/mod-adw/Terminal2.mod">Terminal2.mod</a>
    \---test
        \---mod
                <a href="./examples/Terminal2/src/test/mod/Terminal2Test.mod">Terminal2Test.mod</a>
</pre>

Let's again have a closer look at the build directory **`target`** :

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
  +---def
  |       Terminal2.def
  +---mod
  |       Terminal2.mod
  +---sym
  |       Terminal2.sym
  \---test
          Terminal2Test.mod
</pre>

- Input files include at least a definition module (**`target\def\`**), an implementation module (**`target\mod\`**) and a test module (**`target\test\`**).
- The XDS compiler provides option **`=p <project_file>`** to specify the build configuration; we generate the two project files **`Terminal2.prj`** and **`Terminal2Test.prj`** during the build process and pass them to the XDS compiler. For instance :
  <pre style="font-size:80%;border:1px solid #cccccc">
    <b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/type">type</a> target\Terminal2.prj</b>
    <span style="color:green;">% write -gendll- to generate an .exe</span>
    -gendll+
    -usedll+
    -dllexport+
    -implib-
    -cpu = 486
    -lookup = *.sym = sym;C:\opt\XDS-Modula-2\sym
    -m2
    <span style="color:green;">% main module of the program</span>
    !module mod\Terminal2.mod
    </pre>

Finally we support 3 ways to build a Modula-2 library, namely with a batch file (**`build.bat`**), a shell script (**`build.sh`**) or a GNU make file (**`Makefile`**). For instance :
<pre style="font-size:80%;">
<b>&gt; build</b>
Usage: build { &lt;option&gt; | &lt;subcommand&gt; }
&nbsp;
  Options:
    -adw         select ADW Modula-2 toolset
    -debug       print commands executed by this script
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

***

*[mics](https://lampwww.epfl.ch/~michelou/)/November 2023* [**&#9650;**](#top)  <!-- February 2023 -->

<span id="bottom">&nbsp;</span>

<!-- href links -->
