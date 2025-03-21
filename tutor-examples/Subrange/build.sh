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
    $DEBUG && echo "$DEBUG_LABEL $1" 1>&2
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
    [[ $# -eq 0 ]] && HELP=true && return 1

    for arg in "$@"; do
        case "$arg" in
        ## options
        -adw)      TOOLSET=adw ;;
        -debug)    DEBUG=true ;;
        -help)     HELP=true ;;
        -verbose)  VERBOSE=true ;;
        -xds)      TOOLSET=xds ;;
        -*)
            error "Unknown option $arg"
            EXITCODE=1 && return 0
            ;;
        ## subcommands
        clean)     CLEAN=true ;;
        compile)   COMPILE=true ;;
        help)      HELP=true ;;
        run)       COMPILE=true && RUN=true ;;
        *)
            error "Unknown subcommand $arg"
            EXITCODE=1 && return 0
            ;;
        esac
    done
    if [[ -d "$SOURCE_DIR/main/mod-$TOOLSET" ]]; then
        SOURCE_MOD_DIR="$SOURCE_DIR/main/mod-$TOOLSET"
    fi
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
    -debug       print commands executed by this script
    -verbose     print progress messages

  Subcommands:
    clean        delete generated files
    compile      compile Modula-2 source files
    help         print this help message
    run          execute main class "$APP_NAME"
EOS
}

clean() {
    if [[ -d "$TARGET_DIR" ]]; then
        if $DEBUG; then
            debug "Delete directory \"$(mixed_path $TARGET_DIR)\""
        elif $VERBOSE; then
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

compile_xds() {
    if [[ -n "$(ls -A $SOURCE_DEF_DIR/*.def 2>/dev/null)" ]]; then
        if $DEBUG; then
            debug "cp \"$SOURCE_DEF_DIR*.def\" \"$TARGET_DEF_DIR\""
        fi
        cp "$(mixed_path $SOURCE_DEF_DIR)/"*.def "$(mixed_path $TARGET_DEF_DIR)"
    fi
    if $DEBUG; then
        debug "cp \"$(mixed_path $SOURCE_MOD_DIR)/*.mod\" \"$(mixed_path $TARGET_MOD_DIR)\""
    fi
    cp "$(mixed_path $SOURCE_MOD_DIR)/"*.mod "$(mixed_path $TARGET_MOD_DIR)"

    local prj_file="$(mixed_path $TARGET_DIR)/${APP_NAME}.prj"
    $DEBUG && debug "# Create XDS project file \"$prj_file\""
    (
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
    if $DEBUG; then
        debug "$XC_CMD =p \"$prj_file\""
    elif $VERBOSE; then
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
    elif $mingw || $msys; then
        echo $1 | sed 's|/|\\\\|g'
    else
        echo $1
    fi
}

win_path() {
    if [[ -x "$CYGPATH_CMD" ]]; then
        $CYGPATH_CMD -aw $1 | sed 's|\\|\\\\|g'
    elif $mingw || $msys; then
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

CLEAN=false
COMPILE=false
DEBUG=false
HELP=false
RUN=false
TOOLSET=xds
VERBOSE=false

COLOR_START="[32m"
COLOR_END="[0m"

cygwin=false
mingw=false
msys=false
darwin=false
case "$(uname -s)" in
    CYGWIN*) cygwin=true ;;
    MINGW*)  mingw=true ;;
    MSYS*)   msys=true ;;
    Darwin*) darwin=true
esac
unset CYGPATH_CMD
PSEP=":"
if $cygwin || $mingw || $msys; then
    CYGPATH_CMD="$(which cygpath 2>/dev/null)"
    PSEP=";"
    [[ -n "$ADWM2_HOME" ]] && ADWM2_HOME="$(mixed_path $ADWM2_HOME)"
    [[ -n "$GIT_HOME" ]] && GIT_HOME="$(mixed_path $GIT_HOME)"
    [[ -n "$XDSM2_HOME" ]] && XDSM2_HOME="$(mixed_path $XDSM2_HOME)"
fi

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

$HELP && help && cleanup

if $CLEAN; then
    clean || cleanup 1
fi
if $COMPILE; then
    compile || cleanup 1
fi
if $RUN; then
    run || cleanup 1
fi
cleanup
