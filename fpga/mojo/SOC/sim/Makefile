ROOT_DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

PATH_MODULES = $(ROOT_DIR)/../modules/
CPU_CXX_SOURCES = cpusim.cpp
BOOTROM = $(ROOT_DIR)/../firmwares/bootrom.rom
PATH_LOG_INCLUDE = $(ROOT_DIR)/../plog/include/
# with respect to the obj_dir/
PATH_ASM_INCLUDE = $(ROOT_DIR)/../ISA/
PATH_ASM_LIBRARY = $(ROOT_DIR)/../ISA/
ASM = $(ROOT_DIR)/../ISA/asm

.PHONY : all


all: soc fetch cpu glyph_rom wb_memory uart_tx wb_uart

soc: $(BOOTROM)
	verilator -I$(PATH_MODULES)/cpu/ -I../ -I$(PATH_MODULES)/blockrams/ -CFLAGS '-std=gnu++2a -Wextra -Wall -g -Wpedantic' -Wall --trace -cc soc.v --exe soc.cpp
	make -C obj_dir -j 8 -f V$@.mk V$@

fetch:
	verilator -I$(PATH_MODULES) -CFLAGS '-std=gnu++2a -Wextra -Wall -g -Wpedantic' -Wall --trace -cc cpu/fetch.v --exe fetch.cpp
	make -C obj_dir -j 8 -f V$@.mk V$@

cpu:
	verilator -I$(PATH_MODULES)/cpu/ -CFLAGS '-std=gnu++2a -Wextra -Wall -g -Wpedantic -I$(PATH_LOG_INCLUDE) -I$(PATH_ASM_INCLUDE)' -LDFLAGS '-L$(PATH_ASM_LIBRARY) -Wl,-rpath=$(PATH_ASM_LIBRARY) -lisa' -Wall --trace -cc cpu.v --exe $(CPU_CXX_SOURCES)
	make -C obj_dir -j 8 -f V$@.mk V$@

glyph_rom:
	verilator -I$(PATH_MODULES) -Wall --trace -cc blockrams/glyph_rom.v --exe glyph_rom.cpp
	make -C obj_dir -j 8 -f V$@.mk V$@

wb_memory:
	verilator -I$(PATH_MODULES) -Wall --trace -cc blockrams/wb_memory.v --exe wb_memory.cpp
	make -C obj_dir -j 8 -f V$@.mk V$@

uart_tx:
	verilator -I$(PATH_MODULES) -CFLAGS '-std=gnu++2a -Wextra -Wall -g -Wpedantic -I$(PATH_LOG_INCLUDE)' -Wall --trace -cc UART/uart_tx.v --exe uart_tx.cpp
	make -C obj_dir -j 8 -f V$@.mk V$@

wb_uart:
	verilator -I$(PATH_MODULES)/UART/ -CFLAGS '-std=gnu++2a -Wextra -Wall -g -Wpedantic -I$(PATH_LOG_INCLUDE)' -Wall --trace -cc wb_uart.v --exe uart_tx.cpp
	make -C obj_dir -j 8 -f V$@.mk V$@

clean:
	rm -vfr obj_dir $(BOOTROM)
