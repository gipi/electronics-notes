
SUBPROJECTS = firmwares ISA sim

.PHONY: subprojects $(SUBPROJECTS)

subprojects: $(SUBPROJECTS)

$(SUBPROJECTS):
	$(MAKE) -C $@

all: subprojects

firmwares: ISA
sim: ISA firmwares

clean:
	make -C sim clean && make -C ISA clean && make -C firmwares clean
	rm -vf *.vcd
