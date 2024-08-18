# <span id="top">ADW Modula-2 Quick Reference</span> <span style="font-size:90%;">[↩](README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;;min-width:120px;"><a href="https://www.modula2.org/adwm2/"><img src="docs/imagess/m2.svg" width="120" alt="ADW Modula-2"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This document gathers <a href="https://www.modula2.org/adwm2/" rel="external">ADW Modula-2</a> related informations.
  </td>
  </tr>
</table>

| Command           | Options                          | Examples |
|:------------------|:---------------------------------|:---------|
| **`m2amd64.exe`** | `-nowarn` <sup><b>a)</b></sup>   | |
|                   | `-quiet`                         | hides compiler logo and progress messages |
|                   | `-sym:<relpath>` {`,<relpath>` } | `-sym:target\sym,target\def` |
| **`sblink.exe`**  | { `@<filepath>`<sup><b>b)</b></sup> }                | `@target\linker_opts.txt`| 
<div style="font-size:80%;">
<sup><b>a)</b></sup> For instance : <code>Warning --  Function procedure called as a procedure</code><br/>
<sup><b>b)</b></sup> Most compilers support so-called <i>response files</i> <sup id="anchor_01"><a href="#footnote_01">1</a></sup>.
<div>

<!--=======================================================================-->

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> ***Response files*** [↩](#anchor_01)

<dl><dd>
Compiler arguments specified in response files are either space-separated or line-separated (as with the <a href="https://www.modula2.org/adwm2/">ADW Modula-2</a> compiler).<br/>
For instance the response file <code>target\linker_opts.txt</code> looks as follows :
<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/type" rel="external">type</a> target\linker_opts.txt</b>
-MACHINE:X86_64
-SUBSYSTEM:CONSOLE
-MAP:F:\tutor\Terminal2\target\Terminal2
-OUT:F:\tutor\Terminal2\target\Terminal2.lib
target\mod\Terminal2.obj 
C:\opt\ADW-Modula-2\ASCII\rtl-win-amd64.lib
C:\opt\ADW-Modula-2\ASCII\win64api.lib
</pre>
</dd>
<dd>
Some references :
<ul style="">
<li>GCC Wiki &ndash; <a href="https://gcc.gnu.org/wiki/Response_Files">Response Files</a></li>
<li>Intel oneAPI C++ &ndash; <a href="https://www.intel.com/content/www/us/en/docs/dpcpp-cpp-compiler/developer-guide-reference/2023-0/use-response-files.html">Use Response Files</a></li>
<li>Microsoft C++ &ndash; <a href="https://learn.microsoft.com/en-us/cpp/build/reference/at-specify-a-compiler-response-file">Specify a Compiler Response File</a></li>
</ul>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/August 2024* [**&#9650;**](#top)  <!-- February 2023 -->

<span id="bottom">&nbsp;</span>

<!-- href links -->
