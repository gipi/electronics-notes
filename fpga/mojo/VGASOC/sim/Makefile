ROOT_DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

PATH_MODULES = $(ROOT_DIR)/../modules/
CPU_CXX_SOURCES = cpusim.cpp assembly.cpp loadImpl.cpp jumpImpl.cpp addImpl.cpp


soc: $(PATH_MODULES)/blockrams/boot.rom
	verilator -I$(PATH_MODULES)/cpu/ -I../ -I$(PATH_MODULES)/blockrams/ -CFLAGS '-std=gnu++2a -Wextra -Wall -g -Wpedantic' -Wall --trace -cc soc.v --exe soc.cpp
	make -C obj_dir -j 8 -f V$@.mk V$@

cpu:
	verilator -I$(PATH_MODULES) -CFLAGS '-std=gnu++2a -Wextra -Wall -g -Wpedantic' -Wall --trace -cc cpu/cpu.v --exe $(CPU_CXX_SOURCES)
	make -C obj_dir -j 8 -f V$@.mk V$@

glyph_rom:
	verilator -I$(PATH_MODULES) -Wall --trace -cc blockrams/glyph_rom.v --exe glyph_rom.cpp
	make -C obj_dir -j 8 -f V$@.mk V$@

clean:
	rm -vfr obj_dir
