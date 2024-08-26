##
## Copyright (c) 2018-2024 Stéphane Micheloud
##
## Licensed under the MIT License.
##
##############################################################################

DEBUG ?= 0

TOOLSET ?= adw

include ../Makefile.inc

LIB_DIR = ../lib/$(TOOLSET)

SOURCE_DIR = src
SOURCE_DEF_DIR = src/main/def
SOURCE_MOD_DIR = src/main/mod

TARGET_DIR = target
TARGET_DEF_DIR = $(TARGET_DIR)/def
TARGET_MOD_DIR = $(TARGET_DIR)/mod
## library dependencies
TARGET_BIN_DIR = $(TARGET_DIR)/bin
TARGET_SYM_DIR = $(TARGET_DIR)/sym

##############################################################################
## main rules

DEFS = $(shell [ -d "$(SOURCE_DEF_DIR)" ] && $(FIND) "$(SOURCE_DEF_DIR)" -type f -name "*.def")
MODS = $(shell $(FIND) "$(SOURCE_MOD_DIR)" -type f -name "*.mod")

APP_NAME = estimatePi
TARGET = $(TARGET_DIR)/$(APP_NAME)$(TARGET_EXT)

M2C_OPTS =
LINKER_OPTS_FILE = $(TARGET_DIR)/linker_opts.txt

all: build

build: build_$(TOOLSET)

build_adw: $(DEFS) $(MODS)
	[ -d "$(TARGET_DIR)" ] || "$(MKDIR)" -p "$(TARGET_DIR)"
	if [ -d "$(SOURCE_DEF_DIR)" ]; then \
	    [ -d "$(TARGET_DEF_DIR)" ] || "$(MKDIR)" -p "$(TARGET_DEF_DIR)"; \
	    "$(CP)" "$(SOURCE_DEF_DIR)"/*.def "$(TARGET_DEF_DIR)"; \
	    for f in $(TARGET_DEF_DIR)/*.def; do \
	        if [ $(DEBUG) -eq 1 ]; then $(ECHO) "\"$(M2C)\" $(M2C_OPTS) \"$$f\""; fi; \
	        "$(M2C)" $(M2C_OPTS) "$$f"; \
	    done; \
	fi
	[ -d "$(TARGET_MOD_DIR)" ] || "$(MKDIR)" -p "$(TARGET_MOD_DIR)"
	@$(CP) $(SOURCE_MOD_DIR)/*.mod "$(TARGET_MOD_DIR)"
	[ -d "$(TARGET_SYM_DIR)" ] || "$(MKDIR)" -p "$(TARGET_SYM_DIR)"
	@$(CP) $(ADWM2_SYM_DIR)/*.sym "$(TARGET_SYM_DIR)"
	[ -d "$(TARGET_BIN_DIR)" ] || "$(MKDIR)" -p "$(TARGET_BIN_DIR)"
	if [ -d "$(LIB_DIR)" ]; then \
	    "$(CP)" $(LIB_DIR)/*.obj "$(TARGET_BIN_DIR)"; \
	    "$(CP)" $(LIB_DIR)/*.sym "$(TARGET_SYM_DIR)"; \
	fi
	$(eval M2C_OPTS := -quiet -sym:"$(shell cygpath -w $(TARGET_SYM_DIR)),$(shell cygpath -w $(TARGET_DEF_DIR))")
	for f in $(TARGET_MOD_DIR)/*.mod; do \
	    "$(M2C)" $(M2C_OPTS) "$$f"; \
	done
	$(eval ABS_TARGET_DIR := $(shell realpath $(TARGET_DIR)))
	##$(ECHO) "-EXETYPE:exe"
	@$(ECHO) "-MACHINE:X86_64" > "$(LINKER_OPTS_FILE)"
	@$(ECHO) "-SUBSYSTEM:CONSOLE" >> "$(LINKER_OPTS_FILE)"
	@$(ECHO) "-MAP:$(shell cygpath -w $(ABS_TARGET_DIR))/$(APP_NAME)" >> "$(LINKER_OPTS_FILE)"
	@$(ECHO) "-OUT:$(shell cygpath -w $(ABS_TARGET_DIR))/$(APP_NAME)$(TARGET_EXT)" >> "$(LINKER_OPTS_FILE)"
	@$(ECHO) "-LARGEADDRESSAWARE" >> "$(LINKER_OPTS_FILE)"
	@for f in $(TARGET_MOD_DIR)/*.obj; do \
	    $(ECHO) "$$(shell cygpath -w $$f)" >> "$(LINKER_OPTS_FILE)"; \
	done
	@for f in $(TARGET_BIN_DIR)/*.obj; do \
	    [ -f "$$f" ] || continue; \
	    $(ECHO) "$$(shell cygpath -w $$f)" >> "$(LINKER_OPTS_FILE)"; \
	done
	@$(ECHO) "$(shell cygpath -w $(ADWM2_BIN_DIR))\rtl-win-amd64.lib" >> "$(LINKER_OPTS_FILE)"
	@$(ECHO) "$(shell cygpath -w $(ADWM2_BIN_DIR))\win64api.lib" >> "$(LINKER_OPTS_FILE)"
	"$(SBLINK)" "@$(LINKER_OPTS_FILE)"

build_xds: $(DEFS) $(MODS)
	[ -d "$(TARGET_SYM_DIR)" ] || "$(MKDIR)" -p "$(TARGET_SYM_DIR)"
	if [ -d "$(SOURCE_DEF_DIR)" ]; then \
	    [ -d "$(TARGET_DEF_DIR)" ] || "$(MKDIR)" -p "$(TARGET_DEF_DIR)"; \
	    "$(CP)" "$(SOURCE_DEF_DIR)"/*.def "$(TARGET_DEF_DIR)"; \
	    for f in $(TARGET_DEF_DIR)/*.def; do \
	        cd "$(TARGET_SYM_DIR)" && "$(XC)" =compile "$$(cd ../.. && pwd)\\$$f"; \
	    done; \
	fi
	[ -d "$(TARGET_MOD_DIR)" ] || "$(MKDIR)" -p "$(TARGET_MOD_DIR)"
	@$(CP) $(SOURCE_MOD_DIR)/*.mod "$(TARGET_MOD_DIR)"
	@# we now copy the symbol/object files for library dependencies (if any)
	[ -d "$(TARGET_BIN_DIR)" ] || "$(MKDIR)" -p "$(TARGET_BIN_DIR)"
	if [ -d "$(LIB_DIR)" ]; then \
	    "$(CP)" $(LIB_DIR)/*.dll "$(TARGET_BIN_DIR)"; \
	    "$(CP)" $(LIB_DIR)/*.lib "$(TARGET_BIN_DIR)"; \
	    "$(CP)" $(LIB_DIR)/*.sym "$(TARGET_SYM_DIR)"; \
	fi
	@# we compute the absolute path for PRJ_FILE since we use TARGET_DIR as current directory.
	$(eval ABS_TARGET_DIR := $(shell realpath $(TARGET_DIR)))
	$(eval PRJ_FILE := $(ABS_TARGET_DIR)/$(APP_NAME).prj)
	@$(ECHO) "% generated on $(shell date '+%F %T')" > "$(PRJ_FILE)"
	if [ $(DEBUG) -eq 1 ]; then \
	    @$(ECHO) "% debug ON" >> "$(PRJ_FILE)"; \
	    @$(ECHO) "-gendebug+" >> "$(PRJ_FILE)"; \
	    @$(ECHO) "-genhistory+" >> "$(PRJ_FILE)"; \
	    @$(ECHO) "-lineno+" >> "$(PRJ_FILE)"; \
	fi
	@$(ECHO) "-cpu = 486" >> "$(PRJ_FILE)"
	@$(ECHO) "-lookup = *.sym = sym;$(XDSM2_HOME)\sym" >> "$(PRJ_FILE)"
	@$(ECHO) "-lookup = *.dll|*.lib = bin;$(XDSM2_HOME)\bin" >> "$(PRJ_FILE)"
	@$(ECHO) "-m2" >> "$(PRJ_FILE)"
	@$(ECHO) "% recognize types SHORTINT, LONGINT, SHORTCARD and LONGCARD" >> "$(PRJ_FILE)"
	@$(ECHO) "% -m2addtypes" >> "$(PRJ_FILE)"
	@$(ECHO) "-verbose" >> "$(PRJ_FILE)"
	@$(ECHO) "-werr" >> "$(PRJ_FILE)"
	@$(ECHO) "% disable warning 301 (parameter \"xxx\" is never used)" >> "$(PRJ_FILE)"
	@$(ECHO) "-woff301+" >> "$(PRJ_FILE)"
	@$(ECHO) "% disable warning 303 (procedure \"xxx\" declared but never used)" >> "$(PRJ_FILE)"
	@$(ECHO) "-woff303+" >> "$(PRJ_FILE)"
	for f in $(TARGET_MOD_DIR)/*.mod; do \
	    $(ECHO) "!module $${f/$(TARGET_DIR)\//}" >> "$(PRJ_FILE)"; \
	done
	for f in $(TARGET_BIN_DIR)/*.lib; do \
	    [ -f "$$f" ] || continue; \
	    $(ECHO) "!module $${f/$(TARGET_DIR)\//}" >> "$(PRJ_FILE)"; \
	done
	cd "$(TARGET_DIR)" && "$(XC)" =p "$(PRJ_FILE)"

clean:
	"$(RM)" -rf "$(TARGET_DIR)"
	"$(RM)" -f "linker.err" "errinfo.$$$$$$"

run: build
	"$(TARGET)"

help:
	@$(ECHO) "Usage: make all|build|clean|help|run"
	@$(ECHO) ""
	@$(ECHO) "  Subcommands:"
	@$(ECHO) "    all    alias for build"
	@$(ECHO) "    build  compile Modula-2 source files"
	@$(ECHO) "    clean  delete generated files"
	@$(ECHO) "    help   print this help message"
	@$(ECHO) "    run    execute main program \"$(APP_NAME)$(TARGET_EXT)\""
	@$(ECHO) ""
	@$(ECHO) "  Variables:"
	@$(ECHO) "    TOOLSET=<name> where name=adw,xds"

##############################################################################
## phony

.PHONY: all build clean help run test

.SUFFIXES:
.SUFFIXES: .def .err .exe .map .mod .obj .prj
