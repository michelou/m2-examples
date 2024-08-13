##
## Copyright (c) 2018-2024 Stéphane Micheloud
##
## Licensed under the MIT License.
##
##############################################################################

include ../Makefile.inc

SOURCE_DIR = src
SOURCE_DEF_DIR = src/def
SOURCE_MOD_DIR = src/mod

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

APP_NAME = MergeSort
TARGET = $(TARGET_DIR)/$(APP_NAME)$(TARGET_EXT)

all: build

build: $(TARGET)
   
$(TARGET): $(DEFS) $(MODS)
	if [ -d "$(SOURCE_DEF_DIR)" ]; then \
	    [ -d "$(TARGET_DEF_DIR)" ] || "$(MKDIR)" -p "$(TARGET_DEF_DIR)"; \
	    "$(CP)" "$(SOURCE_DEF_DIR)"/*.def "$(TARGET_DEF_DIR)"; \
	fi
	[ -d "$(TARGET_MOD_DIR)" ] || "$(MKDIR)" -p "$(TARGET_MOD_DIR)"
	@$(CP) $(SOURCE_MOD_DIR)/*.mod "$(TARGET_MOD_DIR)"
	# we compute the absolute path for PRJ_FILE since we use TARGET_DIR as current directory.
	$(eval ABS_TARGET_DIR := $(shell realpath $(TARGET_DIR)))
	$(eval PRJ_FILE := $(shell cygpath -m $(ABS_TARGET_DIR))/$(APP_NAME).prj)
	@$(ECHO) "-lookup = *.sym = sym;$(XDSM2_HOME)\sym;..\..\lib" > "$(PRJ_FILE)"
	@$(ECHO) "-m2" >> "$(PRJ_FILE)"
	@$(ECHO) "-verbose" >> "$(PRJ_FILE)"
	@$(ECHO) "-werr" >> "$(PRJ_FILE)"
	@$(ECHO) "# disable warning 301 (parameter "xxx" is never used)" >> "$(PRJ_FILE)"
	@$(ECHO) "-woff301+" >> "$(PRJ_FILE)"
	@$(ECHO) "# disable warning 303 (procedure "xxx" declared but never used)" >> "$(PRJ_FILE)"
	@$(ECHO) "-woff303+" >> "$(PRJ_FILE)"
	for f in $(MODS); do \
	    $(ECHO) "!module $${f/$(SOURCE_DIR)\//}" >> "$(PRJ_FILE)"; \
	done
	for f in $(TARGET_BIN_DIR)/*.lib; do \
	    [ -f "$$f" ] || continue; \
	    $(ECHO) "!module $${f/$(TARGET_DIR)\//}" >> "$(PRJ_FILE)"; \
	done
	cd "$(TARGET_DIR)" && "$(XC)" =p "$(PRJ_FILE)"

clean:
	"$(RM)" -rf "$(TARGET_DIR)"

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
