# <span id="top">ADW Modula-2 Quick Reference</span> <span style="font-size:90%;">[↩](README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;;min-width:120px;"><a href="https://www.modula2.org/adwm2/"><img src="./docs/images/m2.svg" width="120" alt="ADW Modula-2"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This document gathers <a href="https://www.modula2.org/adwm2/" rel="external">ADW Modula-2</a> related informations.
  </td>
  </tr>
</table>

Build scripts (<a href="https://cloudblogs.microsoft.com/opensource/2023/02/21/introducing-bash-for-beginners/" rel="external">Bash scripts</a>, <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting" rel="external">batch files</a>, <a href="https://makefiletutorial.com/" rel="external">Make scripts</a>) in our code examples simply provide arguments to the following ADW Modula-2 commands :

| Command           | Options                          | Examples |
|:------------------|:---------------------------------|:---------|
| **`m2amd64.exe`** | `-nowarn` <sup><b>a)</b></sup>   | |
|                   | `-quiet`                         | hides compiler logo and progress messages |
|                   | `-sym:<relpath>` {`,<relpath>` } | `-sym:target\sym,target\def` |
| **`sblink.exe`**  | { `@<filepath>`<sup><b>b)</b></sup> }                | `@target\linker_opts.txt`| 
<div style="font-size:80%;">
<sup><b>a)</b></sup> For instance : <code>Warning --  Function procedure called as a procedure</code><br/>
<sup><b>b)</b></sup> Most compilers support so-called <i>response files</i> <sup id="anchor_01"><a href="#footnote_01">1</a></sup>.
</div>

<!--=======================================================================-->

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> ***Response files*** [↩](#anchor_01)

<dl><dd>
<p>Compiler arguments specified in response files are either space-separated or line-separated (as with the <a href="https://www.modula2.org/adwm2/">ADW Modula-2</a> compiler).</p>
For instance, the batch command <a href="./adw-examples/EstimatePi/build.bat"><code>build.bat</code></a> (in project <a href="./adw-examples/EstimatePi/"><code>EstimatePi</code></a>) generates the following response file to be passed to the ADW linker  (<code>sblink.exe</code>) :
<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/type" rel="external">type</a> target\linker_opts.txt</b>
-MACHINE:X86_64
-SUBSYSTEM:CONSOLE
-MAP:F:\adw-examples\EstimatePi\target\EstimatePi
-OUT:F:\adw-examples\EstimatePi\target\EstimatePi.exe
-LARGEADDRESSAWARE
target\mod\EstimatePi.obj
target\mod\Rand.obj
C:\opt\ADW-Modula-2\ASCII\rtl-win-amd64.lib
C:\opt\ADW-Modula-2\ASCII\win64api.lib
</pre>
Let's call <code>sblink.exe</code> directly :
<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/fr-fr/windows-server/administration/windows-commands/del" rel="external">del</a> target\EstimatePi.exe</b>
&nbsp;
<b>&gt; c:\opt\ADW-Modula-2\ASCII\sblink.exe <span style="color:darkviolet;">@target\linker_opts.txt</span></b>
Linker. Build ADW 1.6.879
Copyright (C) 2009, by ADW Software
&nbsp;
Time = 20
Memory = 1816k
&nbsp;
<b>&gt; <a href="https://learn.microsoft.com/fr-fr/windows-server/administration/windows-commands/dir" rel="external">dir</a> /s /b target\*.exe</b>
F:\adw-examples\EstimatePi\target\EstimatePi.exe
</pre>
</dd>
<dd>
Here a some references about response files :
<ul style="">
<li>GCC Wiki &ndash; <a href="https://gcc.gnu.org/wiki/Response_Files">Response Files</a>.</li>
<li>Intel oneAPI C++ &ndash; <a href="https://www.intel.com/content/www/us/en/docs/dpcpp-cpp-compiler/developer-guide-reference/2023-0/use-response-files.html">Use Response Files</a>.</li>
<li>The <code>javac</code> Command &ndash; <a href="https://docs.oracle.com/en/java/javase/17/docs/specs/man/javac.html#command-line-argument-files" rel="external">Command-Line Argument Files</a>.</li>
<li>Microsoft C++ &ndash; <a href="https://learn.microsoft.com/en-us/cpp/build/reference/at-specify-a-compiler-response-file">Specify a Compiler Response File</a>.</li>
</ul>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/November 2025* [**&#9650;**](#top)  <!-- February 2023 -->

<span id="bottom">&nbsp;</span>

<!-- href links -->
