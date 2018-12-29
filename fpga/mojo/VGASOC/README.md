# VGA SoC

This is an attempt to build a rudimentary CPU with boot ROM, VRAM and Text RAM.

## Memory layout

Each component can be accessed via its own address space; using 32-bit as address space dimension
we know that we have 4GiB at our disposal. There are three region to be taken into account:
the ``ROM``, ``RAM`` and ``Flash``; we can divide them chunk having size of 1GiB, 1GiB and 2GiB respectively.

| Name           | Size   |Address range | Description |
|------          |--------|--------------|-------------|
| Boot ROM       |   1MiB | 0x00000000 - 0x000fffff | after reset procedures |
| Glyph ROM      |   2KiB | | internal representation of 128 ASCII 8x16 pixels characters used in text mode |
| VRAM           | 300KiB | 0x20000000 - 0x2fffffff | |
| Text RAM       | ~19KiB | 0x30000000 - 0x3fffffff | |
| External RAM   |  32MiB | 0x40000000 - 0x7fffffff | |
| External Flash | 512MiB | 0x80000000 - 0xffffffff | |

## Instruction set

For now we are interested in have only read and write primitive to memory address, without mathematical
operations, maybe jumps.

Memory addresses cannot be accessed directly but instead you have to deference them using a register.
This indicates that we want a **load/store** architecture.

The instructions are

| Instruction | Description | Opcode |
|-------------|-------------|--------|
| ``LDI Rn, I`` | Load an immediate value ``I`` to register ``Rn`` |
| ``LDA Rn, A`` | Load the value at the address ``A`` to register ``Rn`` |
| ``ST  Rn, Rm`` | Store the value contained into register ``Rn`` to location ``A`` |

Take in mind that being the registers and instructions 32-bit long, it's not possible to
store an immediate 32-bit value with only one operation: you can think


## Roadmap

 - [ ] SoC
   - [ ] Memory mapping
     - [ ] ROM
     - [ ] RAM
     - [ ] Flash
     - [ ] peripherals (GPIO)
   - [ ] Instruction set
     - [ ] load/store immediate
     - [ ] load/store from memory
     - [ ] ALU
       - [ ] add
       - [ ] sub
       - [ ] mul
       - [ ] xor
       - [ ] left/right shift
  - [ ] booting from Boot ROM
    - [ ] showing a load screen (with [DOOM fire](http://fabiensanglard.net/doom_fire_psx/))

