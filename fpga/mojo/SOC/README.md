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

With a simple ``make`` it's possible to build the simulation programs to test
the design.

```
$ make tests
 <...>
>>>>>>>>>>>>> obj_dir/Vglyph_rom <<<<<<<<<<<<<<<<<<<<<<<
 [+] starting Glyph ROM simulation
[character code 0]
        
        
## ## # 
      # 
#       
#     # 
      # 
#       
#     # 
      # 
#       
# ## ##
 <...>

[character code 83]
######  
######  
######  
######  
######  
######  
######  
######  
##>>>>>>>>>>>>> obj_dir/Vcpu <<<<<<<<<<<<<<<<<<<<<<<
 [+] starting CPU simulation
 [#] instruction 'ldids r7, 1af': 197001af
 [#] instruction 'ld r7, [r10]': 187a0000
 [#] instruction 'jr r8': 30070000
 [#] instruction 'jrl r9': 301f0000
 [#] instruction 'add r9, r7, r10': 497a0000
 [#] instruction 'add r9, r7, r10': 497a0000
 [#] instruction 'pop r7': 90700000
 [#] instruction 'push r7': 80700000
 [#] instruction 'st r7, [r10]': 787a0000
 [#] instruction 'jr r8': 30070000
>>>>>>>>>>>>> obj_dir/Vsoc <<<<<<<<<<<<<<<<<<<<<<<
2020-12-16 12:17:19.050 INFO  [418529] [main@19]  [+] starting SOC simulation
2020-12-16 12:17:19.050 INFO  [418529] [SysCon<T>::init@57]  [+] start tracing into 'soc_trace.vcd'
>>>>>>>>>>>>> obj_dir/Vwb_memory <<<<<<<<<<<<<<<<<<<<<<<
Vwb_memory: ../wb_memory.cpp:72: int main(int, char**): Assertion `uut->o_data == 0x1d34' failed.
Aborted
>>>>>>>>>>>>> obj_dir/Vfetch <<<<<<<<<<<<<<<<<<<<<<<
 [+] starting fetch stage simulation
 [+] out of reset
 [I] start transaction
>>>>>>>>>>>>> obj_dir/Vwb_uart <<<<<<<<<<<<<<<<<<<<<<<
2020-12-16 12:17:19.055 INFO  [418532] [SysCon<T>::init@57]  [+] start tracing into 'wb_uart.vcd'
2020-12-16 12:17:19.055 DEBUG [418532] [SysCon<T>::tickPeripherals@85]  [+] tx starting communications
2020-12-16 12:17:19.055 DEBUG [418532] [SysCon<T>::tickPeripherals@100] transmitted byte: '' (aa)
2020-12-16 12:17:19.055 DEBUG [418532] [SysCon<T>::tickPeripherals@85]  [+] tx starting communications
2020-12-16 12:17:19.055 DEBUG [418532] [SysCon<T>::tickPeripherals@100] transmitted byte: 'U' (55)
2020-12-16 12:17:19.055 DEBUG [418532] [SysCon<T>::tickPeripherals@85]  [+] tx starting communications
2020-12-16 12:17:19.055 DEBUG [418532] [SysCon<T>::tickPeripherals@100] transmitted byte: 'h' (68)
2020-12-16 12:17:19.055 DEBUG [418532] [SysCon<T>::tickPeripherals@85]  [+] tx starting communications
2020-12-16 12:17:19.055 DEBUG [418532] [SysCon<T>::tickPeripherals@100] transmitted byte: '' (1)
>>>>>>>>>>>>> obj_dir/Vuart_tx <<<<<<<<<<<<<<<<<<<<<<<
2020-12-16 12:17:19.056 INFO  [418533] [main@104]  [+] start tracing
2020-12-16 12:17:19.057 DEBUG [418533] [tickPeripherals@32]  [+] tx starting communications
2020-12-16 12:17:19.057 DEBUG [418533] [tickPeripherals@47] transmitted byte: '' (aa)
2020-12-16 12:17:19.057 DEBUG [418533] [tickPeripherals@32]  [+] tx starting communications
2020-12-16 12:17:19.057 DEBUG [418533] [tickPeripherals@47] transmitted byte: 'U' (55)
2020-12-16 12:17:19.057 DEBUG [418533] [tickPeripherals@32]  [+] tx starting communications
2020-12-16 12:17:19.057 DEBUG [418533] [tickPeripherals@47] transmitted byte: 'h' (68)
2020-12-16 12:17:19.057 DEBUG [418533] [tickPeripherals@32]  [+] tx starting communications
2020-12-16 12:17:19.057 DEBUG [418533] [tickPeripherals@47] transmitted byte: '' (1)
```

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
       - [x] add
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

