
SUBPROJECTS = firmwares ISA sim

.PHONY: subprojects $(SUBPROJECTS)

subprojects: $(SUBPROJECTS)

$(SUBPROJECTS):
	$(MAKE) -C $@

all: subprojects

firmwares: ISA
sim: ISA firmwares

tests: subprojects
	cd sim && find obj_dir/ ! -name '*.*' -type f | while read f; do echo '>>>>>>>>>>>>> '$$f' <<<<<<<<<<<<<<<<<<<<<<<';./$$f;done

clean:
	make -C sim clean && make -C ISA clean && make -C firmwares clean
	rm -vf *.vcd
