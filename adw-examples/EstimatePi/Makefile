##
## Copyright (c) 2018-2024 Stéphane Micheloud
##
## Licensed under the MIT License.
##
##############################################################################

TOOLSET ?= adw

include ../Makefile.inc

ADWM2_SYM_DIR = $(subst \,/,$(ADWM2_HOME))/ascii/winamd64sym

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
TARGET_FILE = $(TARGET_DIR)/$(APP_NAME)$(TARGET_EXT)

M2C_OPTS =
LINKER_OPTS_FILE = $(TARGET_DIR)/linker_opts.txt

all: build

build: build_$(TOOLSET)
   
build_adw: $(DEFS) $(MODS)
	[ -d "$(TARGET_DIR)" ] || "$(MKDIR)" -p "$(TARGET_DIR)"
	$(eval ABS_TARGET_DIR := $(shell realpath $(TARGET_DIR)))
	if [ -d "$(SOURCE_DEF_DIR)" ]; then \
	    [ -d "$(TARGET_DEF_DIR)" ] || "$(MKDIR)" -p "$(TARGET_DEF_DIR)"; \
	    "$(CP)" "$(SOURCE_DEF_DIR)"/*.def "$(TARGET_DEF_DIR)"; \
	    for f in $(ABS_TARGET_DIR)/def/*.def; do \
	        "$(M2C)" $(M2C_OPTS) $$f; \
	    done; \
	fi
	[ -d "$(TARGET_MOD_DIR)" ] || "$(MKDIR)" -p "$(TARGET_MOD_DIR)"
	@$(CP) $(SOURCE_MOD_DIR)/*.mod "$(TARGET_MOD_DIR)"
	[ -d "$(TARGET_SYM_DIR)" ] || "$(MKDIR)" -p "$(TARGET_SYM_DIR)"
	@$(CP) $(ADWM2_SYM_DIR)/*.sym "$(TARGET_SYM_DIR)"
	[ -d "$(TARGET_BIN_DIR)" ] || "$(MKDIR)" -p "$(TARGET_BIN_DIR)"
	if [ -d "$(LIB_DIR)" ]; then \
	    @$(CP) $(LIB_DIR)/*.obj "$(TARGET_BIN_DIR)"; \
	    @$(CP) $(LIB_DIR)/*.sym "$(TARGET_SYM_DIR)"; \
	fi
	$(eval ABS_TARGET_SYM_DIR := $(shell realpath $(TARGET_SYM_DIR)))
	$(eval M2C_OPTS := "-sym:\"$(shell cygpath -w $(ABS_TARGET_SYM_DIR))\"")
	##for f in $(TARGET_MOD_DIR)/*.mod; do \
	##    @$(ECHO) $$f \
	"$(M2C)" $(M2C_OPTS) "$(shell cygpath -w $(TARGET_MOD_DIR)/$(APP_NAME).mod)"
	##done
	##@$(ECHO) "-EXETYPE:exe"
	@$(ECHO) "-MACHINE:X86_64" > "$(LINKER_OPTS_FILE)"
	@$(ECHO) "-SUBSYSTEM:CONSOLE" >> "$(LINKER_OPTS_FILE)"
	@$(ECHO) "-MAP:$(TARGET_DIR)/$(APP_NAME)" >> "$(LINKER_OPTS_FILE)"
	@$(ECHO) "-OUT:$(TARGET_FILE)" >> "$(LINKER_OPTS_FILE)"
	@$(ECHO) "-LARGEADDRESSAWARE" >> "$(LINKER_OPTS_FILE)"
	@for f in $(TARGET_MOD_DIR)/*.obj; do \
	    $(ECHO) $$f >> "$(LINKER_OPTS_FILE)"; \
	done
	@for f in $(TARGET_BIN_DIR)/*.obj; do \
	    $(ECHO) $$f >> "$(LINKER_OPTS_FILE)"; \
	done
	@$(ECHO) "$(ADWM2_HOME)\rtl-win-amd64.lib" >> "$(LINKER_OPTS_FILE)"
	@$(ECHO) "$(ADWM2_HOME)\win64api.lib" >> "$(LINKER_OPTS_FILE)"
	"$(SBLINK)" "@$(LINKER_OPTS_FILE)"

build_xds: $(DEFS) $(MODS)
	if [ -d "$(SOURCE_DEF_DIR)" ]; then \
	    [ -d "$(TARGET_DEF_DIR)" ] || "$(MKDIR)" -p "$(TARGET_DEF_DIR)"; \
	    "$(CP)" "$(SOURCE_DEF_DIR)"/*.def "$(TARGET_DEF_DIR)"; \
	fi
	[ -d "$(TARGET_MOD_DIR)" ] || "$(MKDIR)" -p "$(TARGET_MOD_DIR)"
	@$(CP) $(SOURCE_MOD_DIR)/*.mod "$(TARGET_MOD_DIR)"
	[ -d "$(TARGET_BIN_DIR)" ] || "$(MKDIR)" -p "$(TARGET_BIN_DIR)"
	@$(CP) $(LIB_DIR)/*.dll "$(TARGET_BIN_DIR)"
	@$(CP) $(LIB_DIR)/*.lib "$(TARGET_BIN_DIR)"
	[ -d "$(TARGET_SYM_DIR)" ] || "$(MKDIR)" -p "$(TARGET_SYM_DIR)"
	@$(CP) $(LIB_DIR)/*.sym "$(TARGET_SYM_DIR)"
	@# we compute the absolute path for PRJ_FILE since we use TARGET_DIR as current directory.
	$(eval ABS_TARGET_DIR := $(shell realpath $(TARGET_DIR)))
	$(eval PRJ_FILE := $(ABS_TARGET_DIR)/$(APP_NAME).prj)
	@##[ -f "$(PRJ_FILE)" ] || "$(RM)" "$(PRJ_FILE)"
	@##if $DEBUG; then
	@##    @$(ECHO) "%% debug ON" >> "$(PRJ_FILE)"
	@##    @$(ECHO) "-gendebug+" >> "$(PRJ_FILE)"
	@##    @$(ECHO) "-genhistory+" >> "$(PRJ_FILE)"
	@##    @$(ECHO) "-lineno+" >> "$(PRJ_FILE)"
	@##fi
	@$(ECHO) "-cpu = 486" > "$(PRJ_FILE)"
	@$(ECHO) "-lookup = *.sym = sym;$(XDSM2_HOME)\sym" >> "$(PRJ_FILE)"
	@$(ECHO) "-lookup = *.dll|*.lib = bin;$(XDSM2_HOME)\bin" >> "$(PRJ_FILE)"
	@$(ECHO) "-m2" >> "$(PRJ_FILE)"
	@$(ECHO) "-verbose" >> "$(PRJ_FILE)"
	@$(ECHO) "-werr" >> "$(PRJ_FILE)"
	for f in $(TARGET_MOD_DIR)/*.mod; do \
	    $(ECHO) "!module $${f/$(TARGET_DIR)\//}" >> "$(PRJ_FILE)"; \
	done
	for f in $(TARGET_BIN_DIR)/*.lib; do \
	    $(ECHO) "!module $${f/$(TARGET_DIR)\//}" >> "$(PRJ_FILE)"; \
	done
	cd "$(TARGET_DIR)" && "$(XC)" =p "$(PRJ_FILE)"

clean:
	"$(RM)" -rf "$(TARGET_DIR)"
	"$(RM)" -f "$(APP_NAME).err" "errinfo.$$$$$$"

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

##############################################################################
## phony

.PHONY: all build clean help run test

.SUFFIXES:
.SUFFIXES: .def .exe .mod .obj .prj
