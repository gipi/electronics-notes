BOOTROM = bootrom.rom

ASM = ../ISA/asm

.PHONY: all bootrom

bootrom: $(BOOTROM)

$(BOOTROM): $(BOOTROM:.rom=.asm) $(ASM)
	$(ASM) $< > $@

clean:
	rm -fv $(BOOTROM)
