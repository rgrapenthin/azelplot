#################################################################################
#										#
#			          azelplot MAKEFILE				#
#										#
#################################################################################

# --- Target name
TARGET                  := azelplot 
BIN                     := /usr/local/bin
#--- directory information
export INCLUDE_DIRS    := -I/usr/include -I. -I$(shell pwd) 
export LIB_DIRS        := -L/usr/X11R6/lib

#--- linker options, might be different from plugins', thus local
LINKER_OPT             := -lstdc++ 

#--- debug flag, empty by default, set specifically for each target below
DEBUG                  := 

#--- this directories' sources
SOURCE                 := $(shell ls *.c *.cpp 2>/dev/null)
HEADER                 := $(shell ls *.h 2>/dev/null)
OBJS                   := $(notdir $(SOURCE:%.cpp=%.o))
OBJS                   := $(notdir $(OBJS:%.c=%.o))

#--- flags for make
export M_FLAGS         := --no-print-directory

#--- always do this ...
.PHONY: all clean help plugins

#--- compile sources (C)
.c.o:
	gcc -c -Wall $(INCLUDE_DIRS) $<

#--- compile sources (C++) 
.cpp.o:
	g++ -c -Wall $(DEBUG) $(INCLUDE_DIRS) $<

#--- dependencies of the source files ... see rule for defs.h
#--- need to be included before the rules
include defs.h


# --- help  ---------------------------------------------
help: 		# hope this helps
	@echo '-----------------------------------------------------------------------------------'
	@echo 'this is the makefile for the deformation package'
	@echo "usage: make [option]"
	@echo ;
	@echo "option (without colon) = "
	@egrep '^[^:;=.]*::?[	 ]*#' [mM]akefile
	@echo '-----------------------------------------------------------------------------------'
	echo $(OBJS)

defs.h: $(SOURCE)
	@echo --------------------------------------
	gcc -MM $(INCLUDE_DIRS) $? > defs.h
	@echo --------------------------------------

all: $(TARGET)
	cp $(TARGET) $(BIN)	

# ----- the targets ...
$(TARGET): defs.h $(OBJS) $(HEADER) #creates the binary 
	gcc -o $@ $(OBJS) $(LIB_DIRS) $(LINKER_OPT) 

clean:		# cleans directories
	-rm *.o $(TARGET) defs.h 
