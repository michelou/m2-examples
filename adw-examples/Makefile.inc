ifndef ADWM2_HOME
$(error Variable ADWM2_HOME is not set)
endif
ifndef XDSM2_HOME
$(error Variable XDSM2_HOME is not set)
endif

## ADWM2 gives us 2 choices: ASCII, Unicode
ADWM2_ENCODING = ASCII

ifeq ($(OS),Windows_NT)
ADWM2_BIN_DIR = $(subst \,/,$(ADWM2_HOME))/$(ADWM2_ENCODING)
ADWM2_SYM_DIR = $(ADWM2_BIN_DIR)/winamd64sym

M2C        = $(ADWM2_BIN_DIR)/m2amd64.exe
SBLINK     = $(ADWM2_BIN_DIR)/sblink.exe
XC         = $(subst \,/,$(XDSM2_HOME))/bin/xc.exe
#
PSEP       = ;
## $(MSYS_HOME)\usr\bin\{cp.exe, make.exe, wget.exe}
CP         = /usr/bin/cp.exe
ECHO       = /usr/bin/echo.exe
FIND       = /usr/bin/find.exe
MKDIR      = /usr/bin/mkdir.exe
RM         = /usr/bin/rm.exe
TOUCH      = /usr/bin/touch.exe
WGET       = /usr/bin/wget
#
TARGET_EXT = .exe
else
M2C        = m2amd64
SBLINK     = sblink
XC         = xc
#
PSEP       = :
CP         = cp
ECHO       = echo
FIND       = find
MKDIR      = mkdir
MVN        = mvn
RM         = rm
TOUCH      = touch
WGET       = wget
#
TARGET_EXT =
endif
