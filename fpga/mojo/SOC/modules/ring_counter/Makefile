
verilator:
	verilator -Wall --trace -cc ring_counter.v --exe vl_main.c
	make -C obj_dir -j 8 -f Vring_counter.mk Vring_counter
