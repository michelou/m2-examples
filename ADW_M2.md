# <span id="top">ADW Modula-2 Quick Reference</span> <span style="font-size:90%;">[↩](README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;;min-width:120px;"><a href="https://"><img src="docs/imagess/m2.svg" width="120" alt="ADW Modula-2"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This document gathers <a href="https://" rel="external">ADW Modula-2</a> related informations.
  </td>
  </tr>
</table>

| Tool              | Options                      |
|:------------------|:-----------------------------|
| **`m2amd64.exe`** | `-nowarn` <sup><b>a)</b></sup> |
|                   | `-sym:target\sym,target\def` |
| **`sblink.exe`**  | `@target\linker_opts.txt`<sup><b>b)</b></sup>| 

<div style="font-size:80%;">
<sup><b>a)</b></sup> For instance : <code>Warning --  Function procedure called as a procedure</code><br/>
<sup><b>b)</b></sup> Where the so-called response file <code>target\linker_opts.txt</code> is :
<pre style="font-size:80%;">
-MACHINE:X86_64
-SUBSYSTEM:CONSOLE
-MAP:F:\tutor\Terminal2\target\Terminal2
-OUT:F:\tutor\Terminal2\target\Terminal2.lib
target\mod\Terminal2.obj 
C:\opt\ADW-Modula-2\ASCII\rtl-win-amd64.lib
C:\opt\ADW-Modula-2\ASCII\win64api.lib
</pre>
<div>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/July 2024* [**&#9650;**](#top)  <!-- February 2023 -->

<span id="bottom">&nbsp;</span>

<!-- href links -->
