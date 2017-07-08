#             __________               __   ___.
#   Open      \______   \ ____   ____ |  | _\_ |__   _______  ___
#   Source     |       _//  _ \_/ ___\|  |/ /| __ \ /  _ \  \/  /
#   Jukebox    |    |   (  <_> )  \___|    < | \_\ (  <_> > <  <
#   Firmware   |____|_  /\____/ \___  >__|_ \|___  /\____/__/\_ \
#                     \/            \/     \/    \/            \/
# $Id$
#

include $(TOOLSDIR)/functions.make

DEFINES = -DROCKBOX -DMEMORYSIZE=$(MEMORYSIZE) $(TARGET) \
	-DTARGET_ID=$(TARGET_ID) -DTARGET_NAME=\"$(MODELNAME)\" $(BUILDDATE) 
INCLUDES = -I$(BUILDDIR) 

CFLAGS = $(INCLUDES) $(DEFINES) $(GCCOPTS) 
PPCFLAGS = $(filter-out -g -Dmain=SDL_main,$(CFLAGS)) # cygwin sdl-config fix
ASMFLAGS = -D__ASSEMBLER__      # work around gcc 3.4.x bug with -std=gnu99, only meant for .S files
CORE_LDOPTS = $(GLOBAL_LDOPTS)  # linker ops specifically for core build


# list suffixes to be understood by $*
.SUFFIXES: .rock .codec .map .elf .c .S .o .bmp .a

.PHONY: all clean tags zip tools manual bin build info langs

# none of the above
DEPFILE = $(BUILDDIR)/make.dep

all: $(DEPFILE) build

INCLUDES += -I$(ROOTDIR)/test
INCLUDES += -I$(ROOTDIR)/lib/rockbox_sys	
INCLUDES += -I$(ROOTDIR)/lib/rbcodec
include $(ROOTDIR)/lib/tlsf/libtlsf.make
include $(ROOTDIR)/lib/fixedpoint/fixedpoint.make
include $(ROOTDIR)/test/warble.make
include $(ROOTDIR)/lib/rbcodec/rbcodec.make

OBJ := $(SRC:.c=.o)
OBJ := $(OBJ:.S=.o)
OBJ += $(BMP:.bmp=.o)
OBJ := $(subst $(ROOTDIR),$(BUILDDIR),$(OBJ))

build: $(TOOLS) $(BUILDDIR)/$(BINARY) $(CODECS) $(ROCKS)

$(DEPFILE) dep:
	$(call PRINTS,Generating dependencies)
	$(call mkdepfile,$(DEPFILE)_,$(SRC))
	$(call mkdepfile,$(DEPFILE)_,$(OTHER_SRC:%.lua=))
	$(call mkdepfile,$(DEPFILE)_,$(ASMDEFS_SRC))
	$(call bmpdepfile,$(DEPFILE)_,$(BMP) $(PBMP))
	@mv $(DEPFILE)_ $(DEPFILE)

codecs: $(DEPFILE) $(TOOLS) $(CODECS)

-include $(DEPFILE)

clean::
	$(SILENT)echo Cleaning build directory
	$(SILENT)rm -rf rockbox.zip rockbox.7z rockbox.tar rockbox.tar.gz \
		rockbox.tar.bz2 TAGS apps firmware tools comsim sim lang lib \
		manual *.pdf *.a credits.raw rockbox.ipod bitmaps \
		pluginbitmaps UI256.bmp rockbox-full.zip html txt \
		rockbox-manual*.zip sysfont.h rockbox-info.txt voicefontids \
		*.wav *.mp3 *.voice $(CLEANOBJS) \
		$(LINKRAM) $(LINKROM) rockbox.elf rockbox.map rockbox.bin \
		make.dep rombox.elf rombox.map rombox.bin rombox.ucl romstart.txt \
		$(BINARY) $(FLASHFILE) uisimulator bootloader flash $(BOOTLINK) \
		rockbox.apk

#### linking the binaries: ####

.SECONDEXPANSION:

# when source and object are in different locations (normal):
$(BUILDDIR)/%.o: $(ROOTDIR)/%.c
	$(SILENT)mkdir -p $(dir $@)
	$(call PRINTS,CC $(subst $(ROOTDIR)/,,$<))$(CC) $(CFLAGS) -c $< -o $@

$(BUILDDIR)/%.o: $(ROOTDIR)/%.S
	$(SILENT)mkdir -p $(dir $@)
	$(call PRINTS,CC $(subst $(ROOTDIR)/,,$<))$(CC) $(CFLAGS) $(ASMFLAGS) -c $< -o $@

# generated definitions for use in .S files
$(BUILDDIR)/%_asmdefs.h: $(ROOTDIR)/%_asmdefs.c
	$(call PRINTS,ASMDEFS $(@F))
	$(SILENT)mkdir -p $(dir $@)
	$(call asmdefs2file,$<,$@)

# when source and object are both in BUILDDIR (generated code):
%.o: %.c
	$(SILENT)mkdir -p $(dir $@)
	$(call PRINTS,CC $(subst $(ROOTDIR)/,,$<))$(CC) $(CFLAGS) -c $< -o $@

%.o: %.S
	$(SILENT)mkdir -p $(dir $@)
	$(call PRINTS,CC $(subst $(ROOTDIR)/,,$<))$(CC) $(CFLAGS) $(ASMFLAGS) -c $< -o $@
