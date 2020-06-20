
ASM_CXX_SOURCES = assembly.cpp loadImpl.cpp jumpImpl.cpp addImpl.cpp mulImpl.cpp source.cpp
ASM_CXX_OBJECTS = $(ASM_CXX_SOURCES:.cpp=.o)
PATH_LOG_INCLUDE = ../plog/include/

CPPFLAGS = -I$(PATH_LOG_INCLUDE) -fPIC

TARGETS = libisa.so asm

all: $(TARGETS)
.PHONY: all

asm: asm.cpp $(ASM_CXX_SOURCES)
	g++ -Wfatal-errors -I$(PATH_LOG_INCLUDE) -g -Wall $^ -o $@

libisa.so: $(ASM_CXX_OBJECTS)
	gcc -shared -o $@ $^

clean:
	rm -vf $(TARGETS) $(ASM_CXX_OBJECTS)
