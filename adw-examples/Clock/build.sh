#!/usr/bin/env bash
#
# Copyright (c) 2018-2024 Stéphane Micheloud
#
# Licensed under the MIT License.
#

##############################################################################
## Subroutines

getHome() {
    local source="${BASH_SOURCE[0]}"
    while [[ -h "$source" ]]; do
        local linked="$(readlink "$source")"
        local dir="$( cd -P $(dirname "$source") && cd -P $(dirname "$linked") && pwd )"
        source="$dir/$(basename "$linked")"
    done
    ( cd -P "$(dirname "$source")" && pwd )
}

debug() {
    local DEBUG_LABEL="[46m[DEBUG][0m"
    [[ $DEBUG -eq 1 ]] && echo "$DEBUG_LABEL $1" 1>&2
}

warning() {
    local WARNING_LABEL="[46m[WARNING][0m"
    echo "$WARNING_LABEL $1" 1>&2
}

error() {
    local ERROR_LABEL="[91mError:[0m"
    echo "$ERROR_LABEL $1" 1>&2
}

# use variables EXITCODE, TIMER_START
cleanup() {
    [[ $1 =~ ^[0-1]$ ]] && EXITCODE=$1

    debug "EXITCODE=$EXITCODE"
    exit $EXITCODE
}

args() {
    [[ $# -eq 0 ]] && HELP=1 && return 1

    for arg in "$@"; do
        case "$arg" in
        ## options
        -adw)      TOOLSET=adw ;;
        -debug)    DEBUG=1 ;;
        -help)     HELP=1 ;;
        -verbose)  VERBOSE=1 ;;
        -xds)      TOOLSET=xds ;;
        -*)
            error "Unknown option $arg"
            EXITCODE=1 && return 0
            ;;
        ## subcommands
        clean)     CLEAN=1 ;;
        compile)   COMPILE=1 ;;
        help)      HELP=1 ;;
        run)       COMPILE=1 && RUN=1 ;;
        *)
            error "Unknown subcommand $arg"
            EXITCODE=1 && return 0
            ;;
        esac
    done
    debug "Options    : TOOLSET=$TOOLSET VERBOSE=$VERBOSE"
    debug "Subcommands: CLEAN=$CLEAN COMPILE=$COMPILE HELP=$HELP RUN=$RUN"
    debug "Variables  : ADWM2_HOME=$ADWM2_HOME"
    debug "Variables  : GIT_HOME=$GIT_HOME"
    debug "Variables  : XDSM2_HOME=$XDSM2_HOME"
}

help() {
    cat << EOS
Usage: $BASENAME { <option> | <subcommand> }

  Options:
    -adw         select ADW Modula-2 toolset
    -debug       print commands executed by this script
    -verbose     print progress messages
    -xds         select XDS Modula-2 toolset

  Subcommands:
    clean        delete generated files
    compile      compile Modula-2 source files
    help         print this help message
    run          execute main class "$APP_NAME"
EOS
}

clean() {
    if [[ -d "$TARGET_DIR" ]]; then
        if [[ $DEBUG -eq 1 ]]; then
            debug "Delete directory \"$(mixed_path $TARGET_DIR)\""
        elif [[ $VERBOSE -eq 1 ]]; then
            echo "Delete directory \"${TARGET_DIR/$ROOT_DIR\//}\"" 1>&2
        fi
        rm -rf "$(mixed_path $TARGET_DIR)"
        [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )
    fi
    rm -f "$ROOT_DIR/errinfo.\$\$\$"
}

compile() {
    [[ -d "$TARGET_DEF_DIR" ]] || mkdir -p "$TARGET_DEF_DIR"
    [[ -d "$TARGET_MOD_DIR" ]] || mkdir -p "$TARGET_MOD_DIR"
    [[ -d "$TARGET_SYM_DIR" ]] || mkdir -p "$TARGET_SYM_DIR"

    local is_required_def="$(action_required "$TARGET_FILE" "$SOURCE_DEF_DIR/" "*.def")"

    local is_required_mod="$(action_required "$TARGET_FILE" "$SOURCE_MOD_DIR/" "*.mod")"
    [[ $is_required_def -eq 0 ]] && [[ $is_required_mod -eq 0 ]] && return

    compile_$TOOLSET $is_required_def
    [[ $? -eq 0 ]] || ( EXITCODE=1 && return )
}

action_required() {
    local target_file=$1
    local search_path=$2
    local search_pattern=$3
    local source_file=
    for f in $(find "$search_path" -type f -name "$search_pattern" 2>/dev/null); do
        [[ $f -nt $source_file ]] && source_file=$f
    done
    if [[ -z "$source_file" ]]; then
        ## Do not compile if no source file
        echo 0
    elif [[ ! -f "$target_file" ]]; then
        ## Do compile if target file doesn't exist
        echo 1
    else
        ## Do compile if target file is older than most recent source file
        [[ $source_file -nt $target_file ]] && echo 1 || echo 0
    fi
}

compile_adw() {
    if [[ $DEBUG -eq 1 ]]; then
        debug "cp \"$(mixed_path $ADWM2_HOME1)/winamd64sym/*.sym\" \"$(mixed_path $TARGET_SYM_DIR)\""
    fi
    cp "$(mixed_path $ADWM2_HOME1)/winamd64sym/"*.sym "$(mixed_path $TARGET_SYM_DIR)"

    if [[ -n "$(ls -A $SOURCE_DEF_DIR/*.def 2>/dev/null)" ]]; then
        if [[ $DEBUG -eq 1 ]]; then
            debug "cp \"$SOURCE_DEF_DIR*.def\" \"$TARGET_DEF_DIR\""
        fi
        cp "$(mixed_path $SOURCE_DEF_DIR)/"*.def "$(mixed_path $TARGET_DEF_DIR)"
    fi
    if [[ $DEBUG -eq 1 ]]; then
        debug "cp \"$(mixed_path $SOURCE_MOD_DIR)/*.mod\" \"$(mixed_path $TARGET_MOD_DIR)\""
    fi
    cp "$(mixed_path $SOURCE_MOD_DIR)/"*.mod "$(mixed_path $TARGET_MOD_DIR)"

    # We must specify a relative path to the SYM directory
    local m2c_opts="-sym:\"$(win_path $TARGET_SYM_DIR)\""

    local n=0
    for f in $(find "$TARGET_DEF_DIR/" -type f -name "*.def" 2>/dev/null); do
        eval "$M2C_CMD" $m2c_opts "$(win_path $f)"
        n=$((n + 1))
    done
    for f in $(find "$TARGET_MOD_DIR/" -type f -name "*.mod" 2>/dev/null); do
        if [[ $DEBUG -eq 1 ]]; then
            debug "\"$M2C_CMD\" $m2c_opts \"$(win_path $f)\""
        fi
        eval "$M2C_CMD" $m2c_opts "$(win_path $f)"
        n=$((n + 1))
    done
    local linker_opts_file="$(mixed_path $TARGET_DIR)/linker_opts.txt"
    (
        ## echo -EXETYPE:exe
        echo "-MACHINE:X86_64"
        echo "-SUBSYSTEM:WINDOWS"
        echo "-MAP:$(win_path $TARGET_DIR)\\$APP_NAME"
        echo "-OUT:$(win_path $TARGET_FILE)"
    ) > "$linker_opts_file"
    for f in $(find "$TARGET_MOD_DIR/" -type f -name "*.obj" 2>/dev/null); do
        local x="${f/$ROOT_DIR\///}"
        echo "target\\mod\\Hello.obj" >> "$linker_opts_file"
    done
    (
        echo "$(win_path $ADWM2_HOME1)\\rtl-win-amd64.lib"
        echo "$(win_path $ADWM2_HOME1)\\win64api.lib"
    ) >> "$linker_opts_file"
    if [[ $DEBUG -eq 1 ]]; then
        debug "\"$SBLINK_CMD\" @${linker_opts_file/$ROOT_DIR\///}"
    fi
    eval "\"$SBLINK_CMD\" @${linker_opts_file/$ROOT_DIR\///}"
    if [[ $? -ne 0 ]]; then
        error "Failed to execute ADW linker"
        cleanup 1
    fi
}

## input parameter: %1=.def files are out of date
compile_xds() {
    local is_required_def=$1

    if [[ -n "$(ls -A $SOURCE_DEF_DIR/*.def 2>/dev/null)" ]]; then
        if [[ $DEBUG -eq 1 ]]; then
            debug "cp \"$SOURCE_DEF_DIR*.def\" \"$TARGET_DEF_DIR\""
        fi
        cp "$(mixed_path $SOURCE_DEF_DIR)/"*.def "$(mixed_path $TARGET_DEF_DIR)"
    fi
    if [[ -n "$(ls -A $SOURCE_MOD_DIR/*.mod 2>/dev/null)" ]]; then
       if [[ $DEBUG -eq 1 ]]; then
           debug "cp \"$(mixed_path $SOURCE_MOD_DIR)/*.mod\" \"$(mixed_path $TARGET_MOD_DIR)\""
       fi
       cp "$(mixed_path $SOURCE_MOD_DIR)/"*.mod "$(mixed_path $TARGET_MOD_DIR)"
    else
        warning "No Modula-2 source file found"
        return 1
    fi
    if [[ $is_required_def -eq 1 ]]; then
        [[ -d "$TARGET_SYM_DIR" ]] || mkdir "$TARGET_SYM_DIR"
        for f in $(find "$TARGET_DEF_DIR/" -type f -name "*.def" 2>/dev/null); do
            local def_file=$f
            pushd "$TARGET_SYM_DIR"
            [[ $DEBUG -eq 1 ]] && debug "Current directory is \"$(pwd)\""

            if [[ $DEBUG -eq 1 ]]; then
                debug "\"$XC_CMD\" \"$(mixed_path $f)\""
            elif [[ $VERBOSE -eq 1 ]]; then
                echo "Compile Modula-2 definition module \"$(def_file/$ROOT_DIR//)\"" 1>&2
            fi
            eval "$XC_CMD" "$(mixed_path $f)"
            if [[ $? -ne 0 ]]; then
                popd
                error "Failed to compile Modula-2 definition module \"$(def_file/$ROOT_DIR//)\""
                cleanup 1
            fi
            popd 1>/dev/null
        done
    fi
    local prj_file="$(mixed_path $TARGET_DIR)/${APP_NAME}.prj"
    [[ $DEBUG -eq 1 ]] && debug "# Create XDS project file \"$prj_file\""
    (
        if [[ $DEBUG -eq 1 ]]; then
            echo "% debug ON" && \
            echo "-gendebug+" && \
            echo "-genhistory+" && \
            echo "-lineno+"
        fi
        echo "-cpu = 486" && \
        echo "-lookup = *.sym = sym;$(mixed_path $XDSM2_HOME)/sym" && \
        echo "-m2" && \
        echo "-verbose" && \
        echo "-werr"
    ) > "$prj_file"
    local n=0
    for f in $(find "$TARGET_MOD_DIR/" -type f -name "*.mod" 2>/dev/null); do
        echo "!module $(mixed_path $f)" >> "$prj_file"
        n=$((n + 1))
    done
    if [[ $n -eq 0 ]]; then
        warning "No Modula-2 source file found"
        return 1
    fi
    local s=; [[ $n -gt 1 ]] && s="s"
    local n_files="$n Modula-2 source file$s"
    pushd "$(mixed_path $TARGET_DIR)" 1>/dev/null
    if [[ $DEBUG -eq 1 ]]; then
        debug "$XC_CMD =p \"$prj_file\""
    elif [[ $VERBOSE -eq 1 ]]; then
        echo "Compile $n_files into directory \"$TARGET_DIR\"" 1>&2
    fi
    eval "$XC_CMD" =p "$prj_file"
    if [[ $? -ne 0 ]]; then
        popd 1>/dev/null
        error "Failed to compile $n_files into directory \"$TARGET_DIR\""
        cleanup 1
    fi
    popd 1>/dev/null
}

mixed_path() {
    if [[ -x "$CYGPATH_CMD" ]]; then
        $CYGPATH_CMD -am $1
    elif [[ $(($mingw + $msys)) -gt 0 ]]; then
        echo $1 | sed 's|/|\\\\|g'
    else
        echo $1
    fi
}

run() {
    if [[ ! -f "$TARGET_FILE" ]]; then
        error "Program \"$TARGET_FILE\" not found"
        cleanup 1
    fi
    eval "$(mixed_path $TARGET_FILE)"
    if [[ $? -ne 0 ]]; then
        error "Failed to execute program \"$TARGET_FILE\""
        cleanup 1
    fi
}

##############################################################################
## Environment setup

BASENAME=$(basename "${BASH_SOURCE[0]}")

EXITCODE=0

ROOT_DIR="$(getHome)"

SOURCE_DIR="$ROOT_DIR/src"
SOURCE_DEF_DIR="$SOURCE_DIR/main/def"
SOURCE_MOD_DIR="$SOURCE_DIR/main/mod"
TARGET_DIR="$ROOT_DIR/target"
TARGET_DEF_DIR="$TARGET_DIR/def"
TARGET_MOD_DIR="$TARGET_DIR/mod"
TARGET_SYM_DIR="$TARGET_DIR/sym"

## We refrain from using `true` and `false` which are Bash commands
## (see https://man7.org/linux/man-pages/man1/false.1.html)
CLEAN=0
COMPILE=0
DEBUG=0
HELP=0
RUN=0
TOOLSET=xds
VERBOSE=0

COLOR_START="[32m"
COLOR_END="[0m"

cygwin=0
mingw=0
msys=0
darwin=0
case "$(uname -s)" in
    CYGWIN*) cygwin=1 ;;
    MINGW*)  mingw=1 ;;
    MSYS*)   msys=1 ;;
    Darwin*) darwin=1
esac
unset CYGPATH_CMD
PSEP=":"
if [[ $(($cygwin + $mingw + $msys)) -gt 0 ]]; then
    CYGPATH_CMD="$(which cygpath 2>/dev/null)"
    PSEP=";"
    [[ -n "$ADWM2_HOME" ]] && ADWM2_HOME="$(mixed_path $ADWM2_HOME)"
    [[ -n "$GIT_HOME" ]] && GIT_HOME="$(mixed_path $GIT_HOME)"
    [[ -n "$XDSM2_HOME" ]] && XDSM2_HOME="$(mixed_path $XDSM2_HOME)"
fi
ADWM2_BIN_DIR="$ADWM2_HOME/ASCII"
if [[ ! -x "$ADWM2_BIN_DIR/m2amd64.exe" ]]; then
    error "ADW Modula-2 installation not found"
    cleanup 1
fi
M2C_CMD="$ADWM2_BIN_DIR/m2amd64.exe"
SBLINK_CMD="$ADWM2_BIN_DIR/sblink.exe"

if [[ ! -x "$XDSM2_HOME/bin/xc.exe" ]]; then
    error "XDS Modula-2 installation not found"
    cleanup 1
fi
XC_CMD="$XDSM2_HOME/bin/xc.exe"

APP_NAME="$(basename $ROOT_DIR)"
TARGET_FILE="$TARGET_DIR/$APP_NAME.exe"

args "$@"
[[ $EXITCODE -eq 0 ]] || cleanup 1

##############################################################################
## Main

[[ $HELP -eq 1 ]] && help && cleanup

if [[ $CLEAN -eq 1 ]]; then
    clean || cleanup 1
fi
if [[ $COMPILE -eq 1 ]]; then
    compile || cleanup 1
fi
if [[ $RUN -eq 1 ]]; then
    run || cleanup 1
fi
cleanup
