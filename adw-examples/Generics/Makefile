##
## Copyright (c) 2018-2023 Stéphane Micheloud
##
## Licensed under the MIT License.
##
##############################################################################

include ../Makefile.inc

SOURCE_DIR = src
SOURCE_DEF_DIR = src/main/def
SOURCE_MOD_DIR = src/main/mod
TARGET_DIR = target
TARGET_DEF_DIR = $(TARGET_DIR)/def
TARGET_MOD_DIR = $(TARGET_DIR)/mod
TARGET_SYM_DIR = $(TARGET_DIR)/sym

##############################################################################
## main rules

TOOLSET = adw

DEFS = $(shell [ -d "$(SOURCE_DEF_DIR)" ] && $(FIND) "$(SOURCE_DEF_DIR)" -type f -name "*.def")
MODS = $(shell $(FIND) "$(SOURCE_MOD_DIR)" -type f -name "*.mod")

APP_NAME = generics
TARGET = $(TARGET_DIR)/$(APP_NAME)$(TARGET_EXT)

all: build_$(TOOLSET)

build_adw: $(TARGET)
	@$(ECHO) "Not yet implemented"

build_xds: $(TARGET)
	@$(ECHO) "Not supported"
   
$(TARGET): $(DEFS) $(MODS)
	@$(ECHO) "Not yet implemented"

clean:
	"$(RM)" -rf "$(TARGET_DIR)"
	"$(RM)" -f "$(APP_NAME).err" "errinfo.$$$$$$"

run: build_$(TARGET)
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
