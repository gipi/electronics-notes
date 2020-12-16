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

| Instruction | Opcode |
|-------------|--------|
| ``nop`` | 00 |
| ``ld`` | 01 |
| ``jr`` | 03 |
| ``add`` | 04 |
| ``mul`` | 06 |
| ``st`` | 07 |
| ``push`` | 08 |
| ``pop`` | 09 |
| ``xor`` | 0a |
| ``hl`` | 0b |


## Calling convention

When a function is called the registers ``r1``, ``r2``, ``r3`` and ``r4`` are
used to pass arguments to it, if more that four arguments are needed the
remaining are stored in the stack. ``r1`` will contain the return value (if
any). These registers can be modified by the callee as ``r5``, ``r6``, ``r7``
and ``r8``; the remaining seven registers must be preserved by the call.

Some registers are used directly to interact with the memory, like ``r0`` is the
**program counter** (``pc``) and ``r14`` is the **stack pointer** (``sp``).
These **must** be aligned to 4 bytes.

## Tests

In the simulations there is the ``Vcpu`` module that is intended in the near
future to work as unit tests for the single instructions.
