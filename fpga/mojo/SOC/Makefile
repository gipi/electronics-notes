all: ISA sim
.PHONY: all sim ISA bootrom

bootrom: ISA
	make -C firmwares bootrom

sim: ISA bootrom
	make -C sim

ISA:
	make -C ISA

clean:
	make -C sim clean && make -C ISA clean && make -C firmwares clean
