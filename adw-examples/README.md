# <span id="top">ADW Modula-2 Examples</span> <span style="size:25%;"><a href="../README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 8px 0 0;;min-width:160px;">
    <a href="https://link.springer.com/chapter/10.1007/978-3-642-96757-3_1" rel="external"><img src="../docs/images/pim4.png" width="160" alt="Modula-2 project"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>adw-examples\</code></strong> contains <a href="https://link.springer.com/chapter/10.1007/978-3-642-96757-3_1" rel="external">Modula-2</a> code examples coming from the ADW Modula-2 distribution.
  </td>
  </tr>
</table>

### <span id="clock">`Clock` Example</span>

<pre style="font-size:80%;">
<b>&gt; <a href="./Clock/build.bat">build</a> -verbose clean run</b>
Delete directory "target"
Compile "F:\adw-examples\Clock\target\mod\Clock.MOD" into directory "target\mod"
Modula-2, AMD64. Build ADW 1.6.879
Copyright (c) 2009 by ADW Software

Tokenizing
Reading (.SYM) files
Parsing imported (.SYM) files
Procedure    MAKEINTATOM
Procedure    GlobalDiscard
Procedure    LocalDiscard
Procedure    MAKELANGID
Procedure    PRIMARYLANGID
Procedure    SUBLANGID
Procedure    MAKELCID
Procedure    LANGIDFROMLCID
Procedure    SORTIDFROMLCID
Procedure    ProcThreadAttributeValue
Procedure    PROC_THREAD_ATTRIBUTE_PARENT_PROCESS
Procedure    PROC_THREAD_ATTRIBUTE_HANDLE_LIST
Procedure    PROC_THREAD_ATTRIBUTE_GROUP_AFFINITY
Procedure    PROC_THREAD_ATTRIBUTE_PREFERRED_NODE
Procedure    PROC_THREAD_ATTRIBUTE_IDEAL_PROCESSOR
Procedure    PROC_THREAD_ATTRIBUTE_UMS_THREAD
Procedure    PROC_THREAD_ATTRIBUTE_MITIGATION_POLICY
Procedure    PROC_THREAD_ATTRIBUTE_SECURITY_CAPABILITIES
Procedure    PROC_THREAD_ATTRIBUTE_PROTECTION_LEVEL
Procedure    WT_SET_MAX_THREADPOOL_THREADS
Procedure    TpInitializeCallbackEnviron
Procedure    TpSetCallbackThreadpool
Procedure    TpSetCallbackCleanupGroup
Procedure    TpSetCallbackActivationContext
Procedure    TpSetCallbackNotivationContext
Procedure    TpSetCallbackLongFunction
Procedure    TpSetCallbackRaceWithDll
Procedure    TpSetCallbackFinalizationCallback
Procedure    TpSetCallbackPriority
Procedure    TpSetCallbackPersistent
Procedure    TpDestroyCallbackEnviron
Procedure    InitializeThreadpoolEnvironment
Procedure    SetThreadpoolCallbackPool
Procedure    SetThreadpoolCallbackCleanupGroup
Procedure    SetThreadpoolCallbackRunsLong
Procedure    SetThreadpoolCallbackLibrary
Procedure    SetThreadpoolCallbackPriority
Procedure    SetThreadpoolCallbackPersistent
Procedure    DestroyThreadpoolEnvironment
Procedure    HasOverlappedIoCompleted
Procedure    GetRValue
Procedure    GetGValue
Procedure    GetBValue
Procedure    RGB
Procedure    PALETTEINDEX
Procedure    PALETTERGB
Procedure    GetKValue
Procedure    GetYValue
Procedure    GetMValue
Procedure    GetCValue
Procedure    CMYK
Procedure    MAKEROP4
Procedure    MAKEINTRESOURCEA
Procedure    MAKEINTRESOURCEW
Procedure    MAKEINTRESOURCE
Procedure    PostAppMessageA
Procedure    PostAppMessageW
Procedure    CreateWindowA
Procedure    CreateWindowW
Procedure    CreateDialogA
Procedure    CreateDialogW
Procedure    CreateDialogIndirectW
Procedure    CreateDialogIndirectA
Procedure    DialogBoxA
Procedure    DialogBoxW
Procedure    DialogBoxIndirectA
Procedure    DialogBoxIndirectW
Procedure    DefHookProc
Procedure    ExitWindows
Procedure    GetNextWindow
Procedure    GetSysModalWindow
Procedure    SetSysModalWindow
Procedure    GetWindowTask
Procedure    CopyCursor
Procedure    MAKELONG
Procedure    MAKELPARAM
Procedure    MAKEWPARAM
Procedure    MAKELRESULT
Procedure    MAKEWORD
Procedure    LOWORD
Procedure    HIWORD
Procedure    LOBYTE
Procedure    HIBYTE
Procedure    AnsiToOem
Procedure    OemToAnsi
Procedure    AnsiToOemBuff
Procedure    OemToAnsiBuff
Procedure    AnsiUpper
Procedure    AnsiUpperBuff
Procedure    AnsiLower
Procedure    AnsiLowerBuff
Procedure    AnsiNext
Procedure    AnsiPrev
Procedure    MakeWndProcInstance
Procedure    FreeWndProcInstance
Procedure    WM_ACTIVATE_STATE
Procedure    WM_ACTIVATE_FMINIMIZED
Procedure    WM_ACTIVATE_HWND
Procedure    WM_CHARTOITEM_CHAR
Procedure    WM_CHARTOITEM_CHARW
Procedure    WM_CHARTOITEM_POS
Procedure    WM_CHARTOITEM_HWND
Procedure    WM_COMMAND_ID
Procedure    WM_COMMAND_HWND
Procedure    WM_COMMAND_CMD
Procedure    WM_CTLCOLOR_HDC
Procedure    WM_CTLCOLOR_HWND
Procedure    WM_CTLCOLOR_TYPE
Procedure    WM_MENUSELECT_CMD
Procedure    WM_MENUSELECT_FLAGS
Procedure    WM_MENUSELECT_HMENU
Procedure    WM_MDIACTIVATE_FACTIVATE
Procedure    WM_MDIACTIVATE_HWNDDEACT
Procedure    WM_MDIACTIVATE_HWNDACTIVATE
Procedure    WM_MENUCHAR_CHAR
Procedure    WM_MENUCHAR_CHARW
Procedure    WM_MENUCHAR_HMENU
Procedure    WM_MENUCHAR_FMENU
Procedure    WM_PARENTNOTIFY_MSG
Procedure    WM_PARENTNOTIFY_ID
Procedure    WM_PARENTNOTIFY_HWNDCHILD
Procedure    WM_PARENTNOTIFY_X
Procedure    WM_PARENTNOTIFY_Y
Procedure    WM_VKEYTOITEM_CODE
Procedure    WM_VKEYTOITEM_ITEM
Procedure    WM_VKEYTOITEM_HWND
Procedure    EM_SETSEL_START
Procedure    EM_SETSEL_END
Procedure    WM_CHANGECBCHAIN_HWNDNEXT
Procedure    WM_HSCROLL_CODE
Procedure    WM_HSCROLL_POS
Procedure    WM_HSCROLL_HWND
Procedure    WM_VSCROLL_CODE
Procedure    WM_VSCROLL_POS
Procedure    WM_VSCROLL_HWND
Procedure    MAKE_WM_COMMAND

Procedure    GetTime
Procedure    HourHandPos
Procedure    VertEquiv
Procedure    HorzEquiv
Procedure    CreateTools
Procedure    DeleteTools
Procedure    ClockCreate
Procedure    CircleClock
Procedure    ClockSize
Procedure    DrawFace
Procedure    DrawHand
Procedure    DrawFatHand
Procedure    ClockPaint
Procedure    ClockTimer
Procedure    AboutProc
Procedure    ClockWndProc
Procedure    ClockInit
Main body
Compile memory: 3840
Compile time: 139
Execute ADW linker
Linker. Build ADW 1.6.879
Copyright (C) 2009, by ADW Software

Time = 12
Memory = 1616k
</pre>

<img src="./Clock/Clock.png" width="40%"/>

<pre style="font-size:80%;">
<b>&gt; <a href="">tree</a> /a /f target |findstr /v /b [A-Z]</b>
|   Clock.exe
|   Clock.map
|   linker_opts.txt
|
+---mod
|       Clock.MOD
|       Clock.obj
|
\---sym
        AES.sym
        [...]
        WIN32.sym
        WINUSER.sym
        WINVER.sym
        WINX.sym
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/August 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- href links -->

[apache_ant_cli]: https://ant.apache.org/manual/running.html
[bash_cli]: https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_02_01.html
[cmd_cli]: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/cmd
[flix]: https://flix.dev/
[gradle_cli]: https://docs.gradle.org/current/userguide/command_line_interface.html
[jar_cli]: https://docs.oracle.com/en/java/javase/13/docs/specs/man/jar.html
[make_cli]: https://www.gnu.org/software/make/manual/make.html
[scala]: https://www.scala-lang.org/
[scalac_cli]: https://docs.scala-lang.org/overviews/compiler-options/index.html
[sh_cli]: https://www.man7.org/linux/man-pages/man1/bash.1.html
