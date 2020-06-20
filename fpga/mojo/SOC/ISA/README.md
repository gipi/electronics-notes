# Instruction set

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

