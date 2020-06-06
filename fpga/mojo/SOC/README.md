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
     - [x] ROM
     - [x] internal SRAM
     - [ ] external SDRAM
     - [ ] external Flash
     - [ ] peripherals
       - [ ] GPIO
       - [ ] UART
       - [ ] VGA
   - [ ] Instruction set
     - [ ] move
     - [x] load immediate
     - [ ] load from memory
     - [ ] store to memory
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

