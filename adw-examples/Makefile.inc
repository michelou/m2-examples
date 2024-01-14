ifndef ADWM2_HOME
$(error Variable ADWM2_HOME is not set)
endif
ifndef XDSM2_HOME
$(error Variable XDSM2_HOME is not set)
endif

ifeq ($(OS),Windows_NT)
M2C        = $(subst \,/,$(ADWM2_HOME))/Unicode/m2amd.exe
XC         = $(subst \,/,$(XDSM2_HOME))/bin/xc.exe
LOCAL_REPO = $(subst \,/,$(USERPROFILE))/.m2/repository
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
LOCAL_REPO = $(HOME)/.m2/repository
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
