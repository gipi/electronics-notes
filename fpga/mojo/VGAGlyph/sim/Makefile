ROOT_DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

PATH_DESIGN = $(ROOT_DIR)/../source/
SOURCE = hvsync_generator.v
SOURCE_MAIN = vgasim.cpp
DMODULE_NAME = hvsync_generator

verilator:
	verilator -Wall --trace -cc $(PATH_DESIGN)$(SOURCE) --exe $(SOURCE_MAIN)
	make -C obj_dir -j 8 -f V$(DESIGN_NAME).mk $(DESIGN_NAME)
