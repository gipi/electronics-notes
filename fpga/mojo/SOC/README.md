# SoC

This is an attempt to build a rudimentary CPU with boot ROM, VRAM and Text RAM.

## Memory layout

Each component can be accessed via its own address space; using 32-bit as address space dimension
we know that we have 4GiB at our disposal. There are three regions to be taken into account:
the ``ROM``, ``RAM`` and ``Flash``; we can divide them chunk having size of 1GiB, 1GiB and 2GiB respectively.

| Name           | Size   |Address range | Description |
|------          |--------|--------------|-------------|
| Boot ROM       |  32KiB | ``0xb0000000`` - ``0xb0007fff`` | after reset procedures |
| internal RAM   |  32KiB | ``0xb0008000`` - ``0xb000ffff`` |  |
| VGA controller |        |              | a wishbone slave with a memory interface containing the glyph ROM |
| External RAM   |  32MiB | ``0x40000000`` - ``0x7fffffff`` | |
| External Flash | 512MiB | ``0x80000000`` - ``0xffffffff`` | |

## Getting started

From the directory containing this file you can compile with a simple ``make``;
internally the project is divided into three main sub-sections

 - simulation in the ``sim/`` directory
 - instruction set in the ``ISA/`` directory
 - hdl in the ``modules/`` directory

## Roadmap

 - [ ] SoC
   - [ ] Memory mapping
     - [x] ROM
     - [x] internal SRAM
     - [ ] external SDRAM
     - [ ] external Flash
     - [ ] peripherals
       - [ ] GPIO
       - [ ] UART
         - [x] TX
         - [ ] RX
         - [ ] real baudrate generator
       - [ ] VGA
   - [ ] Instruction set
     - [ ] move
     - [ ] load
         - [ ] different sizes (byte, short, word)
         - [x] immediate
         - [x] from memory
     - [ ] store to memory
         - [x] word
         - [ ] byte
         - [ ] short
     - [ ] push
       - [ ] byte
       - [ ] short
       - [x] word
     - [ ] pop
       - [ ] byte
       - [ ] short
       - [x] word
     - [ ] jumps
       - [x] relative
       - [x] absolute
       - [ ] conditional
       - [x] save the return address
     - [ ] ALU
       - [ ] add
       - [ ] sub
       - [ ] mul
       - [ ] xor
       - [ ] left/right shift
   - [ ] traps/interrupts/exceptions
     - [ ] instructions (enable/disable)
     - [ ] signals
     - [ ] vector table
   - [x] booting from Boot ROM
     - [ ] showing a load screen (with [DOOM fire](http://fabiensanglard.net/doom_fire_psx/))
   - [ ] debug (live dump of registers and memory access)

