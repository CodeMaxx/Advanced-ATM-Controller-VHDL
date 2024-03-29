
ROOT    := $(realpath ../..)
DEPS    := buffer fpgalink error dump argtable2 readline
TYPE    := exe
SUBDIRS :=

# Determine branch:
ifndef BRANCH
	BRANCH := $(shell TRY=$(CURDIR); BRANCH=dev; while [ "$${TRY}" != "$(ROOT)" -a "$${TRY}" != "/" ]; do if [ -e "$${TRY}/.branch" ]; then BRANCH=$$(cat "$${TRY}/.branch"); break; fi; TRY=$$(dirname $${TRY}); done; echo $${BRANCH})
endif


PLATFORM := $(shell uname | tr [A-Z] [a-z])
OBJ      := o
EXE      :=
MACHINE := $(shell uname -m)
ifeq ($(PLATFORM),linux)
	PLATFORM := lin
endif
ifeq ($(MACHINE),x86_64)
	MACHINE := x64
else ifeq ($(MACHINE),i686)
	MACHINE := x86
endif
ifeq ($(MACHINE),x64)
	ARCHFLAGS := -m64 -DBYTE_ORDER=1234
else ifeq ($(MACHINE),x86)
	ARCHFLAGS := -m32 -DBYTE_ORDER=1234
endif

DLL := so
PM := $(PLATFORM).$(MACHINE)

# Config-agnostic defines:
CWD       := $(subst $(ROOT),$${ROOT},$(realpath .))
ifeq ($(strip $(LOCALNAME)),)
	LOCALNAME := $(notdir $(CWD))
endif


INCLUDES  := -I$(ROOT)/common $(subst $${ROOT},$(ROOT),$(EXTRA_INCS) $(shell for i in $(DEPS:%=$(ROOT)/libs/lib%/$(PM)/incs.txt); do cat $$i 2>/dev/null; done))
ifeq ($(strip $(CC_SRCS)),)
	CC_SRCS   := $(wildcard *.c) $(foreach ESD,$(EXTRA_SRC_DIRS),$(wildcard $(ESD)/*.c)) $(EXTRA_CC_SRCS)
endif
ifeq ($(strip $(CPP_SRCS)),)
	CPP_SRCS  := $(wildcard *.cpp) $(foreach ESD,$(EXTRA_SRC_DIRS),$(wildcard $(ESD)/*.cpp)) $(EXTRA_CPP_SRCS)
endif
GENINCS   := echo '-I$(CWD) $(EXTRA_INCS)'
DEPDIRS   := $(DEPS:%=$(ROOT)/libs/lib%)
ifeq ($(strip $(CONFIGS)),)
	CONFIGS = dbg rel
endif



# Release config defines:
OUTDIR_REL    := $(PM)/rel/
OBJDIR_REL    := $(OUTDIR_REL)/.build
EXTRA_OBJ_REL := $(foreach ESD,$(EXTRA_SRC_DIRS),$(OBJDIR_REL)/$(ESD)) $(sort $(foreach ESD,$(EXTRA_CC_SRCS) $(EXTRA_CPP_SRCS),$(OBJDIR_REL)/$(dir $(ESD))))
OBJS_REL      := $(CC_SRCS:%.c=$(OBJDIR_REL)/%.$(OBJ)) $(CPP_SRCS:%.cpp=$(OBJDIR_REL)/%.$(OBJ))
GENDEPS_REL   := for i in $(DEPS:%=$(ROOT)/libs/lib%/$(PM)/rel/libs.txt); do cat $$i 2>/dev/null; done
DLLS_REL      := $(foreach DEP,$(DEPS),$(wildcard $(ROOT)/libs/lib$(DEP)/$(OUTDIR_REL)/*.$(DLL))) $(EXTRADLLS_REL)

# Debug config defines:
OUTDIR_DBG    := $(PM)/dbg
OBJDIR_DBG    := $(OUTDIR_DBG)/.build
EXTRA_OBJ_DBG := $(foreach ESD,$(EXTRA_SRC_DIRS),$(OBJDIR_DBG)/$(ESD)) $(sort $(foreach ESD,$(EXTRA_CC_SRCS) $(EXTRA_CPP_SRCS),$(OBJDIR_DBG)/$(dir $(ESD))))
OBJS_DBG      := $(CC_SRCS:%.c=$(OBJDIR_DBG)/%.$(OBJ)) $(CPP_SRCS:%.cpp=$(OBJDIR_DBG)/%.$(OBJ))
GENDEPS_DBG   := for i in $(DEPS:%=$(ROOT)/libs/lib%/$(PM)/dbg/libs.txt); do cat $$i 2>/dev/null; done
DLLS_DBG      := $(foreach DEP,$(DEPS),$(wildcard $(ROOT)/libs/lib$(DEP)/$(OUTDIR_DBG)/*.$(DLL))) $(EXTRADLLS_DBG)


# Platform-specific stuff:
ifeq ($(PLATFORM),lin)
	ifeq ($(strip $(ALIASING)),)
		ALIASING := -Wstrict-aliasing=3 -fstrict-aliasing
	endif
	ifeq ($(strip $(CSTD)),)
		CSTD := c99
	endif
	ifeq ($(strip $(CPPSTD)),)
		CPPSTD := c++98
	endif
	ifeq ($(strip $(CFLAGS)),)
		CFLAGS := -c $(ARCHFLAGS) -Wall -Wextra -Wundef -pedantic -std=$(CSTD) -Wstrict-prototypes -Wno-missing-field-initializers $(ALIASING) -Warray-bounds $(EXTRA_CFLAGS) -I.
	endif
	CLINE = $(CFLAGS) $(INCLUDES) -MMD -MP -MF $@.d -Wa,-adhlns=$@.lst $< -o $@
	ifeq ($(strip $(CPPFLAGS)),)
		CPPFLAGS := -c $(ARCHFLAGS) -Wall -Wextra -Wundef -Wno-variadic-macros -pedantic $(ALIASING) -Warray-bounds -std=$(CPPSTD) $(EXTRA_CPPFLAGS) -I.
	endif
	CPPLINE = $(CPPFLAGS) $(INCLUDES) -MMD -MP -MF $@.d -Wa,-adhlns=$@.lst $< -o $@
	ifeq ($(TYPE),lib)
		TARGET      := $(LOCALNAME).a
		GENLIBS_REL := (echo '-L$(CWD)/$(OUTDIR_REL) -l$(LOCALNAME:lib%=%)'; $(GENDEPS_REL))
		LINK1_REL   := ar cr $(OUTDIR_REL)/$(TARGET) $(OBJS_REL)
		LINK2_REL   := for i in $(DLLS_REL); do cp -rp $$i $(OUTDIR_REL); done
		LINK3_REL   :=
		CC_REL       = gcc -fPIC -O3 -DNDEBUG $(CLINE)
		CPP_REL      = g++ -fPIC -O3 -DNDEBUG $(CPPLINE)
		GENLIBS_DBG := (echo '-L$(CWD)/$(OUTDIR_DBG) -l$(LOCALNAME:lib%=%)'; $(GENDEPS_DBG))
		LINK1_DBG   := ar cr $(OUTDIR_DBG)/$(TARGET) $(OBJS_DBG)
		LINK2_DBG   := for i in $(DLLS_DBG); do cp -rp $$i $(OUTDIR_DBG); done
		LINK3_DBG   :=
		CC_DBG       = gcc -fPIC -g -D_DEBUG $(CLINE)
		CPP_DBG      = g++ -fPIC -g -D_DEBUG $(CPPLINE)
	else ifeq ($(TYPE),dll)
		TARGET      := $(LOCALNAME).so
		GENLIBS_REL := echo '-L$(CWD)/$(OUTDIR_REL) -l$(LOCALNAME:lib%=%)'
		LINK1_REL   := gcc -shared $(ARCHFLAGS) -Wl,-soname,$(TARGET),-rpath,\$$ORIGIN -o $(OUTDIR_REL)/$(TARGET) $(OBJS_REL) $(subst $${ROOT},$(ROOT),$(shell $(GENDEPS_REL))) $(LINK_EXTRALIBS_REL)
		LINK2_REL   := for i in $(DLLS_REL); do cp -rp $$i $(OUTDIR_REL); done
		LINK3_REL   :=
		CC_REL       = gcc -fPIC -O3 -DNDEBUG $(CLINE)
		CPP_REL      = g++ -fPIC -O3 -DNDEBUG $(CPPLINE)
		GENLIBS_DBG := echo '-L$(CWD)/$(OUTDIR_DBG) -l$(LOCALNAME:lib%=%)'
		LINK1_DBG   := gcc -shared $(ARCHFLAGS) -Wl,-soname,$(TARGET),-rpath,\$$ORIGIN -o $(OUTDIR_DBG)/$(TARGET) $(OBJS_DBG) $(subst $${ROOT},$(ROOT),$(shell $(GENDEPS_DBG))) $(LINK_EXTRALIBS_DBG)
		LINK2_DBG   := for i in $(DLLS_DBG); do cp -rp $$i $(OUTDIR_DBG); done
		LINK3_DBG   :=
		CC_DBG       = gcc -fPIC -g -D_DEBUG $(CLINE)
		CPP_DBG      = g++ -fPIC -g -D_DEBUG $(CPPLINE)
	else ifeq ($(TYPE),exe)
		ifneq (,$(findstring tests,$(LOCALNAME)))
			TESTINCS     := $(shell cat ../$(PM)/incs.txt 2>/dev/null) -I$(ROOT)/libs/libutpp
			ifneq ($(notdir $(realpath ..)),libutpp)
				PRE_BUILD    := $(ROOT)/libs/libutpp/$(PM) $(PRE_BUILD)
			endif
			TESTOBJS_REL := $(patsubst %/main.$(OBJ),,$(shell find ../$(OBJDIR_REL) -name "*.$(OBJ)" 2>/dev/null)) $(ROOT)/libs/libutpp/$(OUTDIR_REL)/libutpp.a
			TESTEXE_REL  := $(OUTDIR_REL)/$(LOCALNAME)
			TESTOBJS_DBG := $(patsubst %/main.$(OBJ),,$(shell find ../$(OBJDIR_DBG) -name "*.$(OBJ)" 2>/dev/null)) $(ROOT)/libs/libutpp/$(OUTDIR_DBG)/libutpp.a
			TESTEXE_DBG  := $(OUTDIR_DBG)/$(LOCALNAME)
		else
			TESTINCS     :=
			TESTOBJS_REL :=
			TESTEXE_REL  :=
			TESTOBJS_DBG :=
			TESTEXE_DBG  :=
		endif
		TARGET      := $(LOCALNAME)
		GENLIBS_REL := $(GENDEPS_REL)
		LINK1_REL   := for i in $(DLLS_REL); do cp -rp $$i $(OUTDIR_REL); done
		LINK2_REL   := $(if $(strip $(CPP_SRCS)),g++,gcc) $(ARCHFLAGS) -Wl,--relax,--gc-sections,-Map=$(OBJDIR_REL)/$(TARGET).map,--cref,-rpath,\$$ORIGIN,-rpath-link,$(OUTDIR_REL) -o $(OUTDIR_REL)/$(TARGET) $(OBJS_REL) $(TESTOBJS_REL) $(subst $${ROOT},$(ROOT),$(shell $(GENDEPS_REL))) $(LINK_EXTRALIBS_REL)
		LINK3_REL   := strip $(OUTDIR_REL)/$(TARGET)
		CC_REL       = gcc -O3 -DNDEBUG $(TESTINCS) $(CLINE)
		CPP_REL      = g++ -O3 -DNDEBUG $(TESTINCS) $(CPPLINE)
		GENLIBS_DBG := $(GENDEPS_DBG)
		LINK1_DBG   := for i in $(DLLS_DBG); do cp -rp $$i $(OUTDIR_DBG); done
		LINK2_DBG   := $(if $(strip $(CPP_SRCS)),g++,gcc) $(ARCHFLAGS) -Wl,--relax,--gc-sections,-Map=$(OBJDIR_DBG)/$(TARGET).map,--cref,-rpath,\$$ORIGIN,-rpath-link,$(OUTDIR_DBG) -o $(OUTDIR_DBG)/$(TARGET) $(OBJS_DBG) $(TESTOBJS_DBG) $(subst $${ROOT},$(ROOT),$(shell $(GENDEPS_DBG))) $(LINK_EXTRALIBS_DBG)
		LINK3_DBG   :=
		CC_DBG       = gcc -g -D_DEBUG $(TESTINCS) $(CLINE)
		CPP_DBG      = g++ -g -D_DEBUG $(TESTINCS) $(CPPLINE)
	endif
endif


# Config-agnostic rules:
all: $() $(CONFIGS) $(POST_BUILD) depend
	@for i in $(SUBDIRS); do make -C $$i BRANCH=$(BRANCH); done

$(PM)/incs.txt: $(PM)
	$(GENINCS) > $@

clean: FORCE
	@for i in $(SUBDIRS) $(EXTRA_CLEAN_DIRS); do make -C $$i clean; done
	rm -rf $(PM) $(EXTRA_CLEAN)

FORCE:

depend: $(DEPDIRS:%=%/$(PM))
	# make BRANCH=$(BRANCH)
	cp $(OUTDIR_REL)/$(LOCALNAME) ATM.out
	cp -r $(OUTDIR_REL)/*.so .



depclean: $(DEPDIRS) clean
	@for i in $(DEPDIRS); do make -C $$i clean; done

# All-config rules
$(PM) $(OBJDIR_REL) $(OUTDIR_REL) $(EXTRA_OBJ_REL) $(OBJDIR_DBG) $(OUTDIR_DBG) $(EXTRA_OBJ_DBG):
	mkdir -p $@


# Release config rules:
rel: $(PM)/incs.txt $(OUTDIR_REL)/libs.txt $(OBJDIR_REL) $(EXTRA_OBJ_REL) $(OUTDIR_REL)/$(TARGET)
	$(TESTEXE_REL)

$(OUTDIR_REL)/libs.txt: $(OUTDIR_REL)
	($(GENLIBS_REL); $(GENEXTRALIBS_REL)) > $@

$(OUTDIR_REL)/$(TARGET): $(OBJDIR_REL) $(OBJS_REL)
	$(LINK1_REL)
	$(LINK2_REL)
	$(LINK3_REL)

$(OBJDIR_REL)/%.$(OBJ) : %.c
	$(CC_REL)

$(OBJDIR_REL)/%.$(OBJ) : %.cpp
	$(CPP_REL)


# Debug config rules:
dbg: $(PM)/incs.txt $(OUTDIR_DBG)/libs.txt $(OBJDIR_DBG) $(EXTRA_OBJ_DBG) $(OUTDIR_DBG)/$(TARGET)
	$(TESTEXE_DBG)

$(OUTDIR_DBG)/libs.txt: $(OUTDIR_DBG)
	($(GENLIBS_DBG); $(GENEXTRALIBS_DBG)) > $@

$(OUTDIR_DBG)/$(TARGET): $(OBJDIR_DBG) $(OBJS_DBG)
	$(LINK1_DBG)
	$(LINK2_DBG)
	$(LINK3_DBG)

$(OBJDIR_DBG)/%.$(OBJ) : %.c
	$(CC_DBG)

$(OBJDIR_DBG)/%.$(OBJ) : %.cpp
	$(CPP_DBG)

FX2LIB_VER := 20140310

$(ROOT)/3rd/fx2lib:
	@echo Fetching makestuff/fx2lib/$(FX2LIB_VER) from GitHub...
	wget -qO fx2lib.tgz --no-check-certificate https://github.com/makestuff/fx2lib/archive/$(FX2LIB_VER).tar.gz
	tar xvzf fx2lib.tgz
	rm fx2lib.tgz
	mv fx2lib-$(FX2LIB_VER) $(ROOT)/3rd/fx2lib

$(ROOT)/3rd/libusb-%-win:
	@echo Fetching libusb Windows binary from SourceForge...
	wget -qO libusb-1.0.7z --no-check-certificate 'http://sourceforge.net/projects/libusb/files/libusb-1.0/$(patsubst libusb-%-win,libusb-%,$(@F))/$(@F).7z/download'
	mkdir -p $@
	7za x -o$@ libusb-1.0.7z
	rm -f libusb-1.0.7z

$(ROOT)/3rd/libusb-win32-bin-%:
	@echo Fetching libusb-win32 from SourceForge...
	wget -qO libusb-win32.zip --no-check-certificate 'http://sourceforge.net/projects/libusb-win32/files/libusb-win32-releases/$(patsubst libusb-win32-bin-%,%,$(@F))/$(@F).zip/download'
	unzip libusb-win32.zip
	rm libusb-win32.zip
	mv $(@F) $(ROOT)/3rd/

$(ROOT)/libs/lib%/Makefile:
	@echo Fetching $(notdir $(@D))/$(BRANCH) from GitHub...
	wget -qO $(notdir $(@D)).tgz --no-check-certificate https://github.com/makestuff/$(notdir $(@D))/archive/$(BRANCH).tar.gz
	tar xvzf $(notdir $(@D)).tgz
	rm $(notdir $(@D)).tgz
	mv $(notdir $(@D))-$(BRANCH) $(ROOT)/libs/$(notdir $(@D))
	echo $(BRANCH) > $(ROOT)/libs/$(notdir $(@D))/.branch

$(ROOT)/libs/lib%/$(PM): $(ROOT)/libs/lib%/Makefile
	make -C $(dir $<) BRANCH=$(BRANCH) deps

.PRECIOUS: $(ROOT)/libs/lib%/Makefile
