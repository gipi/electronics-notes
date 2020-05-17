ROOT_DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

PATH_MODULES = $(ROOT_DIR)/../modules/

cpu:
	verilator -I$(PATH_MODULES) -CFLAGS '-Wall -g -Wpedantic' -Wall --trace -cc cpu/cpu.v --exe cpusim.cpp assembly.cpp loadImpl.cpp
	make -C obj_dir -j 8 -f V$@.mk V$@

glyph_rom:
	verilator -I$(PATH_MODULES) -Wall --trace -cc blockrams/glyph_rom.v --exe glyph_rom.cpp
	make -C obj_dir -j 8 -f V$@.mk V$@

clean:
	rm -vfr obj_dir
