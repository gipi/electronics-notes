ROOT_DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

PATH_DESIGN = $(ROOT_DIR)/../source/
SOURCE = hvsync_generator.v glyph_rom.v
SOURCE_MAIN = vgasim.cpp
MODULE_NAME = hvsync_generator

verilator:
	verilator -I$(PATH_DESIGN)  -Wall --trace -cc $(SOURCE) --exe $(SOURCE_MAIN)
	make -C obj_dir -j 8 -f V$(MODULE_NAME).mk V$(MODULE_NAME)

glyph_rom: $(PATH_DESIGN)glyph_rom.v
	verilator -I$(PATH_DESIGN)  -Wall --trace -cc $^ --exe $@.cpp
	make -C obj_dir -j 8 -f V$@.mk V$@
