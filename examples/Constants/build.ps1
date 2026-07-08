#!/usr/bin/env pwsh
#
# Copyright (c) 2018-2026 Stéphane Micheloud
#
# Licensed under the MIT License.
#

## https://powershellisfun.com/2023/04/24/using-the-requires-statement-in-powershell/
#Requires -Version 5.1

## only for interactive debugging !
$DEBUG = $false

#########################################################################
## Environment setup

$EXITCODE = 0

$EXE = ""
if ($PSVersionTable.PSVersion -lt "6.0" -or $IsWindows) {
  # Fix case when both the Windows and Linux builds of this program
  # are installed in the same directory.
  $EXE = '.exe'
}

$BASENAME = (Get-Item $PSScriptRoot).Basename
$ROOT_DIR = $PSScriptRoot
$PATH_SEP = [IO.Path]::PathSeparator
$SEP      = [IO.Path]::DirectorySeparatorChar

$SOURCE_DIR      = Join-Path -Path $ROOT_DIR   -ChildPath 'src'
$SOURCE_DEF_DIR  = [IO.Path]::Combine($SOURCE_DIR, 'main', 'def')
$SOURCE_MOD_DIR  = [IO.Path]::Combine($SOURCE_DIR, 'main', 'mod')
$TARGET_DIR      = Join-Path -Path $ROOT_DIR   -ChildPath 'target'
$TARGET_DEF_DIR  = Join-Path -Path $TARGET_DIR -ChildPath 'def'
$TARGET_MOD_DIR  = Join-Path -Path $TARGET_DIR -ChildPath 'mod'
# library dependencies
$TARGET_BIN_DIR = Join-Path -Path $TARGET_DIR -ChildPath 'bin'
$TARGET_SYM_DIR = Join-Path -Path $TARGET_DIR -ChildPath 'sym'

# 2 choices: ASCII, Unicode
$ADWM2_HOME = $Env:ADWM2_HOME + $SEP + 'ASCII'
if (! (Test-Path -PathType Container -Path $ADWM2_HOME)) {
    Write-Error "ADW Modula-2 installation not found (check variable ""ADWM2_HOME"")"
    Cleanup 1
}
$M2C_CMD = $ADWM2_HOME + $SEP + 'm2amd64' + $EXE
if (! (Test-Path -PathType Leaf -Path $M2C_CMD)) {
    Write-Error "ADW Modula-2 compiler not found (check variable ""ADWM2_HOME"")"
    Cleanup 1
}
$SBLINK_CMD = $ADWM2_HOME + $SEP + 'sblink' + $EXE
if (! (Test-Path -PathType Leaf -Path $SBLINK_CMD)) {
    Write-Error "ADW Modula-2 linker not found (check variable ""ADWM2_HOME"")"
    Cleanup 1
}
$XC_CMD = $Env:XDSM2_HOME + $SEP + 'bin' + $SEP + 'xc' + $EXE
if (! (Test-Path -PathType Leaf -Path $XC_CMD)) {
    Write-Warning "XDS Modula-2 compiler not found (check variable ""XDSM2_HOME"")"
    $XC_CMD = $null
}
$PROJECT_NAME = $BASENAME
$PROJECT_URL = "github.com/$USER/m2-examples"
$PROJECT_VERSION = "1.0-SNAPSHOT"

$PS_VERSION = $PSVersionTable.PSVersion.ToString() 
$TARGET_NAME = $BASENAME
$TARGET_FILE = $TARGET_DIR + $SEP + $TARGET_NAME + $EXE

#########################################################################
## Script arguments

$COMMANDS = @()

## Possible values: SilentlyContinue, Stop, Continue, Inquire, Ignore, Suspend
$DebugPreference   = 'SilentlyContinue'
$VerbosePreference = 'SilentlyContinue'
$WarningPreference = 'Continue'

$HELP = $false
$TIMER = $false
$TOOLSET = 'xds'
$VERBOSE = $false
$N = 0
foreach ($ARG in $args) {
    if ($ARG.StartsWith('-')) {
        ## option
        if ($ARG -ieq '-adw') { $TOOLSET = 'adw'
        } elseif ($ARG -ieq '-debug') { $DEBUG = $true; $DebugPreference='Continue'
        } elseif ($ARG -ieq '-gm2'    ) { $TOOLSET = 'gnu'
        } elseif ($ARG -ieq '-gnu'    ) { $TOOLSET = 'gnu'
        } elseif ($ARG -ieq '-help'   ) { $HELP = $true
        } elseif ($ARG -ieq '-timer'  ) { $TIMER = $true
        } elseif ($ARG -ieq '-verbose') { $VERBOSE = $true; $VerbosePreference = 'Continue'
        } elseif ($ARG -ieq '-xds'    ) { $TOOLSET = 'xds'
        } else {
            Write-Error "Unknown option ""$ARG"""
            $EXITCODE = 1
            break
        }
    } else {
        ## subcommand
        if ($ARG -ieq 'clean') { $COMMANDS += 'Clean'
        } elseif ($ARG -ieq 'compile') { $COMMANDS += 'Compile'
        } elseif ($ARG -ieq 'help') { $HELP = $true
        } elseif ($ARG -ieq 'run' ) { $COMMANDS += 'Compile', 'Run'
        } else {
            Write-Error "Unknown subcommand ""$ARG"""
            $EXITCODE = 1
            break
        }
        $N++
    }
}
if (Test-Path -PathType Container -Path $($SOURCE_DIR + $SEP + 'main' + $SEP + "mod-$TOOLSET")) {
    $SOURCE_MOD_DIR = $SOURCE_DIR + $SEP + 'main' + $SEP + "mod-$TOOLSET"
}
$LIB_DIR = [IO.Path]::Combine($(Split-Path -Parent $ROOT_DIR), 'lib', $TOOLSET)

Write-Debug "Properties : TOOLSET=$TOOLSET PS_VERSION=$PS_VERSION"
Write-Debug "Options    : DEBUG=$DEBUG TIMER=$TIMER VERBOSE=$VERBOSE"
Write-Debug "Subcommands: $COMMANDS"
Write-Debug "Variables  : ""ADWM2_HOME=$Env:ADWM2_HOME"""
Write-Debug "Variables  : ""XDSM2_HOME=$Env:XDSM2_HOME"""
Write-Debug "Variables  : ""LIB_DIR=$LIB_DIR"""
Write-Debug "Variables  : ""SOURCE_MOD_DIR=$SOURCE_MOD_DIR"""

if ($TIMER) { $TIMER_START = Get-Date }

#########################################################################
## Subroutines

function Main
{
    if ($HELP) {
        Print-Help
        Cleanup 0
    }
    foreach ($COMMAND in $COMMANDS) {
        &$COMMAND
        if ($EXITCODE -ne 0) { exit $EXITCODE }
    }
    if ($TIMER) {
        $DURATION = New-TimeSpan -Start $TIMER_START -End (Get-Date)
        Write-Output "Total execution time: $DURATION"
    }
    Cleanup $EXITCODE
}

function Print-Help
{
    Write-Output "Usage: $BASENAME { <option> | <subcommand> }"
    Write-Output ""
    Write-Output "   Options:"
    Write-Output "     -adw        select ADW Modula-2 toolset"
    Write-Output "     -debug      print commands executed by this script"
    Write-Output "     -gm2, -gnu  select GNU Modula-2 toolset"
    Write-Output "     -timer      print total execution time"
    Write-Output "     -verbose    print progress messages"
    Write-Output "     -xds        select XDS Modula-2 toolset (default)"
    Write-Output ""
    Write-Output "   Subcommands:"
    Write-Output "     clean       delete generated files"
    Write-Output "     compile     compile $(TOOLSET) Modula-2 source files"
    Write-Output "     help        print this help message"
    Write-Output "     run         execute main program ""$TARGET_NAME"""
}

function Clean
{
    Delete-Directory -DirPath $TARGET_DIR
    Remove-Item -Path ($ROOT_DIR + $SEP + '*.err')
    Remove-Item -Path ($ROOT_DIR + $SEP + 'errinfo.*')
}

function Delete-Directory
{
    param (
        [string] $DirPath
    )
    if (Test-Path -PathType Container -Path $DirPath) {
        Write-Debug "[System.IO.Directory]::Delete('$DirPath', $true)"
        Write-Verbose "Delete directory ""$($DirPath.Replace($ROOT_DIR + $SEP, ''))"""
        try {
            #[System.IO.Directory]::Delete($DirPath, $true)
            Remove-Item -Path $DirPath -Force -Recurse
        } catch {
            Write-Error "Failed to delete directory ""$($DirPath.Replace($ROOT_DIR + $SEP, ''))"""
            $EXITCODE = 1
            return
        }
    }
}

function Compile
{
    if (! (Test-Path -PathType Container -Path $TARGET_DIR)) {
        $_ = New-Item -ItemType Directory -Path $TARGET_DIR
    }
    $ACTION_DEF = Test-Action-Required -FilePath "TARGET_FILE" -DirPath "$SOURCE_DIR" -Pattern '*.def'
    $ACTION_MOD = Test-Action-Required -FilePath "TARGET_FILE" -DirPath "$SOURCE_DIR" -Pattern '*.mod'
    if (! ($ACTION_DEF -or $ACTION_MOD)) { return }
    
    if ($TOOLSET -eq 'adw') { Compile-ADW -CompileDefs $ACTION_DEF }
    elseif ($TOOLSET -eq 'gnu') { Compile-GNU -CompileDefs $ACTION_DEF }
    else { Compile-XDS -CompileDefs $ACTION_DEF }
}

function Compile-ADW
{
    param (
        [boolean] $CompileDefs
    )
    $_ = New-Item -ItemType Directory -Path $TARGET_DEF_DIR
    $_ = New-Item -ItemType Directory -Path $TARGET_MOD_DIR
    $_ = New-Item -ItemType Directory -Path $TARGET_SYM_DIR

    Write-Debug "Copy-Item -Path ""$ADWM2_HOME${SEP}winamd64sym$SEP*.sym"" -Destination ""$TARGET_SYM_DIR"""
    Copy-Item -Path ($ADWM2_HOME + $SEP + 'winamd64sym' + $SEP + '*.sym') -Destination $TARGET_SYM_DIR

    Write-Debug "Copy-Item -Path ""$LIB_DIR$SEP*.sym"" -Destination ""$TARGET_SYM_DIR"""
    Copy-Item -Path ($LIB_DIR + $SEP + '*.sym') -Destination $TARGET_SYM_DIR

    Write-Debug "Copy-Item -Path ""$LIB_DIR$SEP*.obj"" -Destination ""$TARGET_MOD_DIR"""
    Copy-Item -Path ($LIB_DIR + $SEP + '*.obj') -Destination $TARGET_MOD_DIR

    if (Test-Path -PathType Container -Path $SOURCE_DEF_DIR) {
        Write-Debug "Copy-Item -Path ""$SOURCE_DEF_DIR$SEP*.def"" -Destination ""$TARGET_DEF_DIR"""
        Copy-Item -Path ($SOURCE_DEF_DIR + $SEP + '*.def') -Destination $TARGET_DEF_DIR
    }
    Write-Debug "Copy-Item -Path ""$SOURCE_MOD_DIR$SEP*.mod"" -Destination ""$TARGET_MOD_DIR"""
    Copy-Item -Path ($SOURCE_MOD_DIR + $SEP + '*.mod') -Destination $TARGET_MOD_DIR

    $M2C_OPTS = @("-sym:""$TARGET_SYM_DIR""")
    if ($DEBUG) { $M2C_OPTS = ,'-quiet' + $M2C_OPTS }

    $N = 0
    ## we generate symbol files for definition modules only if necessary
    if ($CompileDefs) {
        (Get-ChildItem -Path $TARGET_DEF_DIR -Include *.def -Recurse).FullName | ForEach-Object {
            $REL_PATH = $_.Replace($ROOT_DIR + $SEP, '')
            Write-Debug "$M2C_CMD $M2C_OPTS ""$_"""
            Write-Verbose "Compile ""$REL_PATH"" into directory ""$($TARGET_DEF_DIR.Replace($ROOT_DIR, ''))"""
            &"$M2C_CMD" $M2C_OPT "$_"
            if ($LASTEXITCODE -ne 0) {
                Write-Error "Failed to compile ""$REL_PATH"" into directory ""$($TARGET_DEF_DIR.Replace($ROOT_DIR, ''))"""
                $EXITCODE = 1
                return
            }
            $N += 1
        }
    }
    (Get-ChildItem -Path $TARGET_MOD_DIR -Include *.mod -Recurse).FullName | ForEach-Object {
        $REL_PATH = $_.Replace($ROOT_DIR + $SEP, '')
        Write-Debug """$M2C_CMD"" $M2C_OPTS ""$_"""
        Write-Verbose "Compile ""$REL_PATH"" into directory ""$($TARGET_MOD_DIR.Replace($ROOT_DIR + $SEP, ''))"""
        &"$M2C_CMD" $M2C_OPTS "$_"
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Failed to compile ""$REL_PATH"" into directory ""$($TARGET_MOD_DIR.Replace($ROOT_DIR + $SEP, ''))"""
            $EXITCODE = 1
            return
        }
        $N += 1
    }
    $LINKER_OPTS_FILE = $TARGET_DIR + $SEP + 'linker_opts.txt'
    Add-Content -Path $LINKER_OPTS_FILE -Value '-MACHINE:X86_64'
    Add-Content -Path $LINKER_OPTS_FILE -Value '-SUBSYSTEM:WINDOWS'
    Add-Content -Path $LINKER_OPTS_FILE -Value "-MAP:$TARGET_DIR$SEP$TARGET_NAME"
    Add-Content -Path $LINKER_OPTS_FILE -Value "-OUT:$TARGET_FILE"
    Add-Content -Path $LINKER_OPTS_FILE -Value '-LARGEADDRESSAWARE'
    ## object files of current program
    Get-ChildItem -Path $TARGET_MOD_DIR -Include *.obj | ForEach-Object {
        Add-Content -Path $LINKER_OPTS_FILE -Value $_.Name
    }
    ## object files of library depencencies
    Get-ChildItem -Path $TARGET_BIN_DIR -Include *.obj | ForEach-Object {
        Add-Content -Path $LINKER_OPTS_FILE -Value $_.Name
    }
    Add-Content -Path $LINKER_OPTS_FILE -Value $($ADWM2_HOME + $SEP + 'rtl-win-amd64.lib')
    Add-Content -Path $LINKER_OPTS_FILE -Value $($ADWM2_HOME + $SEP + 'win64api.lib')

    Write-Debug """$SBLINK_CMD"" ""@$LINKER_OPTS_FILE"""
    Write-Verbose "Execute ADW linker"
    ## command sblink does NOT support quoted argument file
    &"$SBLINK_CMD" "@$LINKER_OPTS_FILE"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to execute ADW linker"
        $EXITCODE = 1
        return
    }
}

function Compile-GNU
{
    param (
        [boolean] $CompileDefs
    )
    Write-Warning "Not yet implemented"
}

function Compile-XDS
{
    param (
        [boolean] $CompileDefs
    )
    $_ = New-Item -ItemType Directory -Path $TARGET_BIN_DIR
    $_ = New-Item -ItemType Directory -Path $TARGET_DEF_DIR
    $_ = New-Item -ItemType Directory -Path $TARGET_MOD_DIR
    $_ = New-Item -ItemType Directory -Path $TARGET_SYM_DIR

    Write-Debug "Copy-Item -Path ""$LIB_DIR$SEP*.dll"" -Destination ""$TARGET_BIN_DIR"""
    Copy-Item -Path ($LIB_DIR + $SEP + '*.dll') -Destination $TARGET_BIN_DIR

    Write-Debug "Copy-Item -Path ""$LIB_DIR$SEP*.sym"" -Destination ""$TARGET_BIN_DIR"""
    Copy-Item -Path ($LIB_DIR + $SEP + '*.lib') -Destination $TARGET_BIN_DIR

    Write-Debug "Copy-Item -Path ""$LIB_DIR$SEP*.sym"" -Destination ""$TARGET_SYM_DIR"""
    Copy-Item -Path ($LIB_DIR + $SEP + '*.sym') -Destination $TARGET_SYM_DIR

    if (Test-Path -PathType Container -Path $SOURCE_DEF_DIR) {
        Write-Debug "Copy-Item -Path ""$SOURCE_DEF_DIR$SEP*.def"" -Destination ""$TARGET_DEF_DIR"""
        Copy-Item -Path ($SOURCE_DEF_DIR + $SEP + '*.def') -Destination $TARGET_DEF_DIR
    }
    Write-Debug "Copy-Item -Path ""$SOURCE_MOD_DIR$SEP*.mod"" -Destination ""$TARGET_MOD_DIR"""
    Copy-Item -Path ($SOURCE_MOD_DIR + $SEP + '*.mod') -Destination $TARGET_MOD_DIR

    if ($CompileDefs) {
        (Get-ChildItem -Path $TARGET_DEF_DIR -Include *.def -Recurse).FullName | ForEach-Object {
            $REL_PATH = $_.Replace($ROOT_DIR + $SEP, '')
            pushd $TARGET_SYM_DIR
            Write-Debug """$XC_CMD"" ""$_"""
            Write-Verbose "Compile ""$REL_PATH"" into directory ""$($TARGET_DEF_DIR.Replace($ROOT_DIR, ''))"""
            &"$XC_CMD" "$_"
            if ($LASTEXITCODE -ne 0) {
                popd
                Write-Error "Failed to compile ""$REL_PATH"" into directory ""$($TARGET_DEF_DIR.Replace($ROOT_DIR, ''))"""
                $EXITCODE = 1
                return
            }
            popd
            $N += 1
        }
    }
    $PRJ_FILE = $TARGET_DIR + $SEP + $TARGET_NAME + '.prj'
    Write-Debug "# Create XDS project file ""$PRJ_FILE"""
    if ($DEBUG) {
        Add-Content -Path $PRJ_FILE -Value '% debug ON'
        Add-Content -Path $PRJ_FILE -Value '-gendebug+'
        Add-Content -Path $PRJ_FILE -Value '-genhistory+'
        Add-Content -Path $PRJ_FILE -Value '-lineno+'
    }
    Add-Content -Path $PRJ_FILE -Value '-cpu = 486'
    Add-Content -Path $PRJ_FILE -Value "-lookup = *.sym = sym;$XDSM2_HOME${SEP}sym"
    Add-Content -Path $PRJ_FILE -Value "-lookup = *.dll|*.lib = bin;$XDSM2_HOME${SEP}bin"
    Add-Content -Path $PRJ_FILE -Value '-m2'
    Add-Content -Path $PRJ_FILE -Value '%% recognize types SHORTINT, LONGINT, SHORTCARD and LONGCARD'
    Add-Content -Path $PRJ_FILE -Value '%% -m2addtypes'
    Add-Content -Path $PRJ_FILE -Value '-verbose'
    Add-Content -Path $PRJ_FILE -Value '-werr'
    Add-Content -Path $PRJ_FILE -Value '% disable warning 301 (parameter "xxx" is never used)'
    Add-Content -Path $PRJ_FILE -Value '-woff301+'
    Add-Content -Path $PRJ_FILE -Value '% disable warning 303 (procedure "xxx" declared but never used)'
    Add-Content -Path $PRJ_FILE -Value '-woff303+'

    $N = 0
    (Get-ChildItem -Path $TARGET_MOD_DIR -Include *.mod -Recurse).FullName | ForEach-Object {
        Add-Content -Path $PRJ_FILE -Value "!module $_"
        $N += 1
    }
    (Get-ChildItem -Path $TARGET_BIN_DIR -Include *.lib -Recurse).FullName | ForEach-Object {
        Add-Content -Path $PRJ_FILE -Value "!module $_"
        $N += 1
    }
    $S = $null
    $N_FILES = "$N Modula-2 source file$S"

    pushd $TARGET_DIR
    Write-Debug """$XC_CMD"" =p ""$PRJ_FILE"""
    Write-Verbose "Compile $N_FILES into directory ""$TARGET_DIR"""
    &"$XC_CMD" =p "$PRJ_FILE"
    if ($LASTEXITCODE -ne 0) {
       popd
       Write-Error "Failed to compile $N_FILES into directory ""$($TARGET_DIR.Replace($ROOT_DIR, ''))"""
       $EXITCODE = 1
       return
    }
    popd
}

function Test-Action-Required
{
    param (
        [string]$FilePath,
        [string]$DirPath,
        [string]$Pattern
    )
    $REQUIRED = $false
    if (Test-Path -PathType Container -Path $DirPath) {
        $DIR_LAST_TIME = (Get-ChildItem -Path $DirPath -Include $Pattern -Recurse | Sort LastWriteTime | Select -Last 1).LastWriteTime
        if (Test-Path -PathType Leaf -Path $FilePath) {
            $FILE_LAST_TIME = (Get-Item $FilePath).LastWriteTime
            $REQUIRED = $FILE_LAST_TIME -lt $DIR_LAST_TIME
        } else {
            $REQUIRED = $DIR_LAST_TIME -ne $null
        }
    }
    Write-Debug "REQUIRED=$REQUIRED ($Pattern)"
    return $REQUIRED
}

function Run
{
    if (! (Test-Path -PathType Leaf -Path $TARGET_FILE)) {
        Write-Error "Modula2 program ""$($TARGET_FILE.Replace($ROOT_DIR + $SEP, ''))"" not found"
        Cleanup 1
    }
    Write-Debug "$TARGET_FILE"
    Write-Verbose "Execute Modula-2 program ""$($TARGET_FILE.Replace($ROOT_DIR + $SEP, ''))"""
    &"$TARGET_FILE"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to execute Modula-2 program ""$($TARGET_FILE.Replace($ROOT_DIR + $SEP, ''))"""
        Cleanup 1
    }
}

function Cleanup
{
    param (
        [int] $ExitCode
    )
    Write-Debug "ExitCode=$ExitCode"
    exit $ExitCode
}

#########################################################################
## Entry-point

Main
