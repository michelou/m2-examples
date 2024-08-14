@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging !
set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

for %%i in (%_COMMANDS%) do (
    call :%%i
    if not !_EXITCODE!==0 goto end
)
goto end

@rem #########################################################################
@rem ## Subroutines

:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:

set "_SOURCE_DIR=%_ROOT_DIR%src"
set "_SOURCE_DEF_DIR=%_SOURCE_DIR%\main\def"
set "_SOURCE_MOD_DIR=%_SOURCE_DIR%\main\mod"

set "_TARGET_DIR=%_ROOT_DIR%target"
set "_TARGET_DEF_DIR=%_TARGET_DIR%\def"
set "_TARGET_MOD_DIR=%_TARGET_DIR%\mod"
@rem library dependencies
set "_TARGET_BIN_DIR=%_TARGET_DIR%\bin"
set "_TARGET_SYM_DIR=%_TARGET_DIR%\sym"

for /f "delims=" %%i in ("%~dp0.") do set "_APP_NAME=%%~ni"
set "_TARGET_FILE=%_TARGET_DIR%\%_APP_NAME%.exe"

@rem ADWM2 gives us 2 choices: ASCII, Unicode
set "_ADWM2_HOME=%ADWM2_HOME%\ASCII"

if not exist "%_ADWM2_HOME%\m2amd64.exe" (
    echo %_ERROR_LABEL% ADW Modula-2 installation not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_M2C_CMD=%_ADWM2_HOME%\m2amd64.exe"

if not exist "%_ADWM2_HOME%\sblink.exe" (
    echo %_ERROR_LABEL% ADW Modula-2 installation not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_SBLINK_CMD=%_ADWM2_HOME%\sblink.exe"

if not exist "%XDSM2_HOME%\bin\xc.exe" (
    echo %_ERROR_LABEL% XDS Modula-2 installation not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_XC_CMD=%XDSM2_HOME%\bin\xc.exe"
set "_HIS_CMD=%XDSM2_HOME%\bin\his.exe"
set "_XLIB_CMD=%XDSM2_HOME%\bin\xlib.exe"

@rem we use the newer PowerShell version if available
where /q pwsh.exe
if %ERRORLEVEL%==0 ( set _PWSH_CMD=pwsh.exe
) else ( set _PWSH_CMD=powershell.exe
)
goto :eof

:env_colors
@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd

@rem normal foreground colors
set _NORMAL_FG_BLACK=[30m
set _NORMAL_FG_RED=[31m
set _NORMAL_FG_GREEN=[32m
set _NORMAL_FG_YELLOW=[33m
set _NORMAL_FG_BLUE=[34m
set _NORMAL_FG_MAGENTA=[35m
set _NORMAL_FG_CYAN=[36m
set _NORMAL_FG_WHITE=[37m

@rem normal background colors
set _NORMAL_BG_BLACK=[40m
set _NORMAL_BG_RED=[41m
set _NORMAL_BG_GREEN=[42m
set _NORMAL_BG_YELLOW=[43m
set _NORMAL_BG_BLUE=[44m
set _NORMAL_BG_MAGENTA=[45m
set _NORMAL_BG_CYAN=[46m
set _NORMAL_BG_WHITE=[47m

@rem strong foreground colors
set _STRONG_FG_BLACK=[90m
set _STRONG_FG_RED=[91m
set _STRONG_FG_GREEN=[92m
set _STRONG_FG_YELLOW=[93m
set _STRONG_FG_BLUE=[94m
set _STRONG_FG_MAGENTA=[95m
set _STRONG_FG_CYAN=[96m
set _STRONG_FG_WHITE=[97m

@rem strong background colors
set _STRONG_BG_BLACK=[100m
set _STRONG_BG_RED=[101m
set _STRONG_BG_GREEN=[102m
set _STRONG_BG_YELLOW=[103m
set _STRONG_BG_BLUE=[104m

@rem we define _RESET in last position to avoid crazy console output with type command
set _BOLD=[1m
set _UNDERSCORE=[4m
set _INVERSE=[7m
goto :eof

@rem input parameter: %*
:args
set _COMMANDS=
set _TOOLSET=xds
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG (
    if !__N!==0 set _COMMANDS=help
    goto args_done
)
if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-adw" ( set _TOOLSET=adw
    ) else if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-gm2" ( set _TOOLSET=gm2
    ) else if "%__ARG%"=="-help" ( set _HELP=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else if "%__ARG%"=="-xds" ( set _TOOLSET=xds
    ) else (
        echo %_ERROR_LABEL% Unknown option "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="clean" ( set _COMMANDS=!_COMMANDS! clean
    ) else if "%__ARG%"=="compile" ( set _COMMANDS=!_COMMANDS! compile
    ) else if "%__ARG%"=="help" ( set _COMMANDS=help
    ) else if "%__ARG%"=="run" ( set _COMMANDS=!_COMMANDS! compile run
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
    )
    set /a __N+=1
)
shift
goto args_loop
:args_done
set _STDOUT_REDIRECT=1^>NUL
if %_DEBUG%==1 set _STDOUT_REDIRECT=

if exist "%_SOURCE_DIR%\main\mod-%_TOOLSET%" (
    set "_SOURCE_MOD_DIR=%_SOURCE_DIR%\main\mod-%_TOOLSET%"
)
for /f "delims=" %%f in ("%~dp0.") do set "_LIB_DIR=%%~dpflib\%_TOOLSET%"

if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _TOOLSET=%_TOOLSET% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: %_COMMANDS% 1>&2
    echo %_DEBUG_LABEL% Variables  : "ADWM2_HOME=%ADWM2_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "XDSM2_HOME=%XDSM2_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "_LIB_DIR=%_LIB_DIR%"
)
goto :eof

:help
if %_VERBOSE%==1 (
    set __BEG_P=%_STRONG_FG_CYAN%
    set __BEG_O=%_STRONG_FG_GREEN%
    set __BEG_N=%_NORMAL_FG_YELLOW%
    set __END=%_RESET%
) else (
    set __BEG_P=
    set __BEG_O=
    set __BEG_N=
    set __END=
)
echo Usage: %__BEG_O%%_BASENAME% { ^<option^> ^| ^<subcommand^> }%__END%
echo.
echo   %__BEG_P%Options:%__END%
echo     %__BEG_O%-adw%__END%         select ADW Modula-2 toolset
echo     %__BEG_O%-debug%__END%       print commands executed by this script
echo     %__BEG_O%-gm2%__END%         select GNU Modula-2 toolset
echo     %__BEG_O%-verbose%__END%     print progress messages
echo     %__BEG_O%-xds%__END%         select XDS Modula-2 toolset ^(default^)
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%clean%__END%        delete generated object files
echo     %__BEG_O%compile%__END%      compile Modula-2 source files
echo     %__BEG_O%run%__END%          execute program "%__BEG_O%%_APP_NAME%%__END%"
goto :eof

:clean
call :rmdir "%_TARGET_DIR%"
goto :eof

@rem input parameter: %1=directory path
:rmdir
set "__DIR=%~1"
if not exist "%__DIR%\" goto :eof
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% rmdir /s /q "%__DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Delete directory "!__DIR:%_ROOT_DIR%=!" 1>&2
)
rmdir /s /q "%__DIR%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to delete directory "!__DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile
call :action_required "%_TARGET_FILE%" "%_SOURCE_DEF_DIR%\*.def"
set __ACTION_DEF=%_ACTION_REQUIRED%

call :action_required "%_TARGET_FILE%" "%_SOURCE_MOD_DIR%\*.mod"
if %_ACTION_REQUIRED%==0 if %__ACTION_DEF%==0 goto :eof

call :compile_%_TOOLSET% %__ACTION_DEF%
if not %_EXITCODE%==0 goto :eof

goto :eof

@rem input parameter: %1=.def files are out of date
:compile_adw
set __ACTION_DEF=%~1

if %_DEBUG%==1 echo %_DEBUG_LABEL% xcopy /i /q /y "%_ADWM2_HOME%\winamd64sym\*.sym" "%_TARGET_SYM_DIR%" 1>&2
xcopy /i /q /y "%_ADWM2_HOME%\winamd64sym\*.sym" "%_TARGET_SYM_DIR%" 1>NUL
if %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to copy XDS symbol files 1>&2
    set _EXITCODE=1
    goto :eof
)
if exist "%_LIB_DIR%\*.sym" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% xcopy /i /q /y "%_LIB_DIR%\*.sym" "%_TARGET_SYM_DIR%\" 1>&2
    xcopy /i /q /y "%_LIB_DIR%\*.sym" "%_TARGET_SYM_DIR%\" %_STDOUT_REDIRECT%
)
if exist "%_LIB_DIR%\*.obj" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% xcopy /i /q /y "%_LIB_DIR%\*.obj" "%_TARGET_BIN_DIR%\" 1>&2
    xcopy /i /q /y "%_LIB_DIR%\*.obj" "%_TARGET_BIN_DIR%\" %_STDOUT_REDIRECT%
)
if exist "%_SOURCE_DEF_DIR%\*.def" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% xcopy /i /q /y "%_SOURCE_DEF_DIR%\*.def" "%_TARGET_DEF_DIR%\" 1>&2
    xcopy /i /q /y "%_SOURCE_DEF_DIR%\*.def" "%_TARGET_DEF_DIR%\" %_STDOUT_REDIRECT%
)
if exist "%_SOURCE_MOD_DIR%\*.mod" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% xcopy /i /q /y "%_SOURCE_MOD_DIR%\*.mod" "%_TARGET_MOD_DIR%\" 1>&2
    xcopy /i /q /y "%_SOURCE_MOD_DIR%\*.mod" "%_TARGET_MOD_DIR%\" %_STDOUT_REDIRECT%
) else (
    echo %_WARNING_LABEL% No Modula-2 implementation module found 1>&2
    goto :eof
)
@rem We must specify a relative path for the SYM directories
set __M2C_OPTS=-sym:"!_TARGET_SYM_DIR:%_ROOT_DIR%\=!,!_TARGET_DEF_DIR:%_ROOT_DIR%\=!"
if %_DEBUG%==0 set __M2C_OPTS=-quiet %__M2C_OPTS%

set __N=0
if %__ACTION_DEF%==0 goto compile_adw_mod
for /f "delims=" %%f in ('dir /s /b "%_TARGET_DEF_DIR%\*.def" 2^>NUL') do (
    set "__DEF_FILE=%%f"
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_M2C_CMD%" %__M2C_OPTS% "!__DEF_FILE!" 1>&2
    ) else if %_VERBOSE%==1 ( echo Compile "!__DEF_FILE!" 1>&2
    )
    call "%_M2C_CMD%" %__M2C_OPTS% "!__DEF_FILE!"
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Failed to compile "!__DEF_FILE!" 1>&2
        set _EXITCODE=1
        goto :eof
    )
    set /a __N+=1
)
:compile_adw_mod
for /f "delims=" %%f in ('dir /s /b "%_TARGET_MOD_DIR%\*.mod" 2^>NUL') do (
    set "__MOD_FILE=%%f"
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_M2C_CMD%" %__M2C_OPTS% "!__MOD_FILE!" 1>&2
    ) else if %_VERBOSE%==1 ( echo Compile "!__MOD_FILE!" 1>&2
    )
    call "%_M2C_CMD%" %__M2C_OPTS% "!__MOD_FILE!"
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Failed to compile "!__MOD_FILE!" 1>&2
        set _EXITCODE=1
        goto :eof
    )
    set /a __N+=1
)
set "__LINKER_OPTS_FILE=%_TARGET_DIR%\linker_opts.txt"
(
    @rem echo -EXETYPE:exe
    echo -MACHINE:X86_64
    echo -SUBSYSTEM:CONSOLE
    echo -MAP:%_TARGET_DIR%\%_APP_NAME%
    echo -OUT:%_TARGET_FILE%
    echo -LARGEADDRESSAWARE
) > "%__LINKER_OPTS_FILE%"
for /f "delims=" %%f in ('dir /b "%_TARGET_MOD_DIR%\*.obj" 2^>NUL') do (
    echo !_TARGET_MOD_DIR:%_ROOT_DIR%=!\%%f >> "%__LINKER_OPTS_FILE%"
)
for /f "delims=" %%f in ('dir /b "%_TARGET_BIN_DIR%\*.obj" 2^>NUL') do (
    echo !_TARGET_BIN_DIR:%_ROOT_DIR%=!\%%f >> "%__LINKER_OPTS_FILE%"
)
(
    echo %_ADWM2_HOME%\rtl-win-amd64.lib
    echo %_ADWM2_HOME%\win64api.lib
) >> "%__LINKER_OPTS_FILE%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SBLINK_CMD%" @%__LINKER_OPTS_FILE% 1>&2
) else if %_VERBOSE%==1 ( echo Execute ADW linker 1>&2
)
call "%_SBLINK_CMD%" @%__LINKER_OPTS_FILE%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to execute ADW linker 1>&2
    if %_DEBUG%==1 ( if exist "%_ROOT_DIR%linker.err" type "%_ROOT_DIR%linker.err"
    ) else if %_VERBOSE%==1 ( if exist "%_ROOT_DIR%linker.err" type "%_ROOT_DIR%linker.err"
    )
    set _EXITCODE=1
	goto :eof
)
goto :eof

:compile_gm2
echo %_WARNING_LABEL% Not yet implemented
goto :eof

:compile_xds
set __ACTION_DEF=%~1

if exist "%_LIB_DIR%\*.dll" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% xcopy /i /q /y "%_LIB_DIR%\*.dll" "%_TARGET_BIN_DIR%\" 1>&2
    xcopy /i /q /y "%_LIB_DIR%\*.dll" "%_TARGET_BIN_DIR%\" %_STDOUT_REDIRECT%
)
if exist "%_LIB_DIR%\*.lib" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% xcopy /i /q /y "%_LIB_DIR%\*.lib" "%_TARGET_BIN_DIR%\" 1>&2
    xcopy /i /q /y "%_LIB_DIR%\*.lib" "%_TARGET_BIN_DIR%\" %_STDOUT_REDIRECT%
)
if exist "%_LIB_DIR%\*.sym" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% xcopy /i /q /y "%_LIB_DIR%\*.sym" "%_TARGET_SYM_DIR%\" 1>&2
    xcopy /i /q /y "%_LIB_DIR%\*.sym" "%_TARGET_SYM_DIR%\" %_STDOUT_REDIRECT%
)
if exist "%_SOURCE_DEF_DIR%\*.def" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% xcopy /i /q /y "%_SOURCE_DEF_DIR%\*.def" "%_TARGET_DEF_DIR%\" 1>&2
    xcopy /i /q /y "%_SOURCE_DEF_DIR%\*.def" "%_TARGET_DEF_DIR%\" %_STDOUT_REDIRECT%
)
if exist "%_SOURCE_MOD_DIR%\*.mod" (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% xcopy /i /q /y "%_SOURCE_MOD_DIR%\*.mod" "%_TARGET_MOD_DIR%\" 1>&2
    xcopy /i /q /y "%_SOURCE_MOD_DIR%\*.mod" "%_TARGET_MOD_DIR%\" %_STDOUT_REDIRECT%
) else (
    echo %_WARNING_LABEL% No Modula-2 implementation module found 1>&2
    goto :eof
)
set "__PRJ_FILE=%_TARGET_DIR%\%_APP_NAME%.prj"
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% @rem Create XDS project file "!__PRJ_FILE:%_ROOT_DIR%=!" 1>&2
) else if %_VERBOSE%==1 ( echo Create XDS project file "!__PRJ_FILE:%_ROOT_DIR%=!" 1>&2
)
(
    if %_DEBUG%==1 (
        echo %% debug ON
        echo -gendebug+
        echo -genhistory+
        echo -lineno+
    )
    echo -cpu = 486
    echo -lookup = *.sym = sym;%XDSM2_HOME%\sym
    echo -lookup = *.dll^|*.lib = bin;%XDSM2_HOME%\bin
    echo -m2
    echo %% recognize types SHORTINT, LONGINT, SHORTCARD and LONGCARD
    echo %% -m2addtypes
    echo -verbose
    echo -werr
    echo %% disable warning 301 ^(parameter "xxx" is never used^)
    echo -woff301+
    echo %% disable warning 303 ^(procedure "xxx" declared but never used^)
    echo -woff303+
) > "%__PRJ_FILE%"
set __N=0
for /f "delims=" %%f in ('dir /s /b "%_TARGET_MOD_DIR%\*.mod" 2^>NUL') do (
    set "__MOD_FILE=%%f"
    echo ^^!module !__MOD_FILE!
    set /a __N+=1
) >> "%__PRJ_FILE%"
for /f "delims=" %%f in ('dir /s /b "%_TARGET_BIN_DIR%\*.lib" 2^>NUL') do (
    set "__LIB_FILE=%%f"
    echo ^^!module !__LIB_FILE:%_TARGET_DIR%\=!
) >> "%__PRJ_FILE%"
if %__N%==0 (
    echo %_WARNING_LABEL% No Modula-2 implementation module found 1>&2
    goto :eof
) else if %__N%==1 ( set __N_FILES=%__% Modula-2 implementation module
) else ( set __N_FILES=%__% Modula-2 implementation modules
)
pushd "%_TARGET_DIR%"
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_XC_CMD%" =p "%__PRJ_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Compile %__N_FILES% into directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_XC_CMD%" =p "%__PRJ_FILE%"
if not %ERRORLEVEL%==0 (
    popd
    echo %_ERROR_LABEL% Failed to compile %__N_FILES% into directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
popd
goto :eof

@rem input parameter: 1=target file 2,3,..=path (wildcards accepted)
@rem output parameter: _ACTION_REQUIRED
:action_required
set "__TARGET_FILE=%~1"

set __PATH_ARRAY=
set __PATH_ARRAY1=
:action_path
shift
set __PATH=%~1
if not defined __PATH goto action_next
set __PATH_ARRAY=%__PATH_ARRAY%,'%__PATH%'
set __PATH_ARRAY1=%__PATH_ARRAY1%,'!__PATH:%_ROOT_DIR%=!'
goto action_path

:action_next
set __TARGET_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`call "%_PWSH_CMD%" -c "gci -path '%__TARGET_FILE%' -ea Stop | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
     set __TARGET_TIMESTAMP=%%i
)
set __SOURCE_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`call "%_PWSH_CMD%" -c "gci -recurse -path %__PATH_ARRAY:~1% -ea Stop | sort LastWriteTime | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
    set __SOURCE_TIMESTAMP=%%i
)
call :newer %__SOURCE_TIMESTAMP% %__TARGET_TIMESTAMP%
set _ACTION_REQUIRED=%_NEWER%
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% %__TARGET_TIMESTAMP% Target : '%__TARGET_FILE%' 1>&2
    echo %_DEBUG_LABEL% %__SOURCE_TIMESTAMP% Sources: %__PATH_ARRAY:~1% 1>&2
    echo %_DEBUG_LABEL% _ACTION_REQUIRED=%_ACTION_REQUIRED% 1>&2
) else if %_VERBOSE%==1 if %_ACTION_REQUIRED%==0 if %__SOURCE_TIMESTAMP% gtr 0 (
    echo No action required ^(%__PATH_ARRAY1:~1%^) 1>&2
)
goto :eof

@rem input parameters: %1=source timestamp, %2=target timestamp
@rem output parameter: _NEWER
:newer
set __TIMESTAMP1=%~1
set __TIMESTAMP2=%~2

set __DATE1=%__TIMESTAMP1:~0,8%
set __TIME1=%__TIMESTAMP1:~-6%

set __DATE2=%__TIMESTAMP2:~0,8%
set __TIME2=%__TIMESTAMP2:~-6%

if %__DATE1% gtr %__DATE2% ( set _NEWER=1
) else if %__DATE1% lss %__DATE2% ( set _NEWER=0
) else if %__TIME1% gtr %__TIME2% ( set _NEWER=1
) else ( set _NEWER=0
)
goto :eof

:run
if not exist "%_TARGET_FILE%" (
    echo %_ERROR_LABEL% Program "!_TARGET_FILE:%_ROOT_DIR%=!" not found 1>&2
    set _EXITCODE=1
    goto :eof
)
"%_TARGET_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to execute program "!_TARGET_FILE:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    if %_DEBUG%==1 if exist "%_ROOT_DIR%errinfo.$$$" (
        echo %_DEBUG_LABEL% "%_HIS_CMD%" "%_ROOT_DIR%errinfo.$$$" 1>&2
        call "%_HIS_CMD%" "%_ROOT_DIR%errinfo.$$$"
    )
    goto :eof
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL%_EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal
