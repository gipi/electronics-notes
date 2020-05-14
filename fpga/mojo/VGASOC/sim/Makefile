ROOT_DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

PATH_MODULES = $(ROOT_DIR)/../modules/

cpu:
	verilator -I$(PATH_MODULES) -Wall --trace -cc cpu/cpu.v --exe cpusim.cpp
	make -C obj_dir -j 8 -f V$@.mk V$@

clean:
	rm -vfr obj_dir
