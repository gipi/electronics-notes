/*
 * Simple 32bit cpu with load/store operations.
 */
`timescale 1ns/1ps
`default_nettype none


module cpu(
    input wire clk,
    input wire reset,
/* verilator lint_off UNUSED */
    input wire [31:0] i_data,
    output wire [31:0] o_addr
);

/*
 * Registers
 *
 * We have 16 registers (r0 - r15), some are preassigned to specific use
 *
 *  - r0 is the program counter
 *  - r14 the stack pointer
 *  - r15 is the comeback register used by the jump
 */
parameter opcode_size = 4;        // size of opcode in bits
parameter n_reg       = 16;       // number of registers
parameter width_reg   = 32;       // width in bits of the registers
parameter width_flags_reg = 16;

reg [width_reg - 1:0] registers[n_reg - 1:0]; // here our registers
reg [width_reg - 1:0] _registers[n_reg - 1:0]; // here our copy to store final writes
/*
 * FLAGS
 *
 *  - carry
 *  - sign
 *  - zero
 *  - overflow
 */
/* verilator lint_off UNUSED */
reg [width_flags_reg - 1:0] flags;
/*
 * Layout instructions
 *
 * |              |
 * '..............'
 *
 * > Loads
 *
 *  - 4bits: opcode
 *  - 1bit:  direct/memory
 *  - 1bit:  immediate/register [ldi/ldr]
 *  - 2bits: width of the operation (byte, short, word).
 *  - 4bits: destination register idx
 *  - 4bits: if immediate: msb indicate lower/upper else source register idx
 *  - 16bits: value (when reg as source use msb to indicate relative addressing)
 *
 *  ldrw  r8, r9              r8 = r9
 *  ldis  r8, #0x100          r8 = 0x....0100
 *  ldius r8, #0x100          r8 = 0x01000000
 *  ldimw  r8, [0xcafababe]   r8 = *0xcafababe
 *  ldrmw  r8, [r10 + 0x1d34] r8 = *(r10 + 0x1d34)
 *
 * > Jumps
 *
 * - 4bits: indicate the register containing the address where jump to
 * - 4bits: indicate the condition for the jump
 * - 1bit:  conditional or not
 * - 1bit:  relative
 * - 1bit:  save the return address to r15
 *
 *   |  op  |    cond   |   reg source  |  reg return  |    offset   |
 *    31  28 27       24 23           20 19          16 15          0
 *
 *
 *  jr r7               pc = r7
 *  jrl r7              r15 = pc, pc = r7
 *  jrl r7, r6          r6 = pc, pc = r7
 *
 * Note that mov r0, rX is like a jump so we could save the conditional bit
 */

parameter HALT = 4'b0000; /* 0 */
parameter LOAD = 4'b0001; /* 1 */
parameter JUMP = 4'b0011; /* 3 */
parameter ADD  = 4'b0100; /* 4 */
parameter SUB  = 4'b0101; /* 5 */
parameter MUL  = 4'b0110; /* 6 */
parameter STR  = 4'b0111; /* 7 */
parameter PUSH = 4'b1000; /* 8 */
parameter POP  = 4'b1001; /* 9 */

// the cycle states of our cpu, i.e. the Control Unit states
parameter s_fetch   = 2'b00;    // fetch next instruction from memory
parameter s_decode  = 2'b01;    // decode instruction into opcode and operands
parameter s_execute = 2'b10;    // execute the instruction inside the ALU
parameter s_store   = 2'b11;    // store the result back to memory

reg [1:0] current_state;
reg [1:0] next_state;

/* Initialize internals */
initial begin
        registers[0] = 32'hb0000000;
        next_pc = 32'hb0000000;
end

integer i;
/* Sequential part */
always @(posedge clk)
begin
    if (~reset)
    begin
        current_state <= s_fetch;
        registers[0] <= 32'hb0000000;
    end
    else
        current_state <= next_state;
        // q_addr <= d_addr;
        q_instruction <= i_data; /* we are reading the instruction from the*/
        q_opcode <= d_opcode;

        if (store) begin
            for (i = 0 ; i < 16 ; i++) begin
                registers[i] <= _registers[i];
            end
        end
end

/*
 * d and q are the conventional labels to the input/output of the flip-flops
 */
reg [31:0] q_instruction, d_instruction;
reg [31:0] q_addr, _addr;
reg [31:0] next_pc;
reg [3:0]  q_opcode, d_opcode;
reg store;

/* load related signals */
reg  [3:0] dst_idx; /* for LOAD operation */
reg [31:0] load_value;
reg  [1:0] load_type; /* 0: no registers involved 1: immediate 2: registers */

/*
 * Combinatorial logic part
 */
always @*
if (reset) begin
        case (current_state)
            s_fetch:
            begin
                store = 0;
                _addr = registers[0]; /* set the address line */
                _registers[0] = registers[0] + 4;

                next_state = s_decode;
            end
            s_decode:
            begin
                d_opcode = q_instruction[31:28];

                next_state = s_execute;
            end
            s_execute:
            begin
                case (q_opcode)
                    HALT:
                    begin
                    end
                    LOAD:
                    begin
                        // isImmediate = q_instruction[27:27];
                        // isDirect = q_instruction[26:26];
                        // width = q_instruction[25:25]
                        _registers[q_instruction[23:20]] = {16'b0, q_instruction[15:0]};
                        // FIXME: use 'u' to load upper part
                        load_type = 1;
                    end
                    JUMP:
                    /*
                     * We simply want to perform a move into the PC
                     */
                    begin
                        _registers[0] = registers[q_instruction[23:20]];
                    end
                    ADD:
                    begin
                    end
                    SUB:
                    begin
                    end
                    MUL:
                    begin
                    end
                    STR:
                    begin
                    end
                    PUSH:
                    begin
                    end
                    POP:
                    begin
                    end
                    default:
                        next_state = s_fetch; /* FIXME */
                endcase
                next_state = s_store;
            end
            s_store:
            begin
                load_type = 0; /* reset possible loads */
                store = 1; /* now we can commit the changes to the registers */
                next_state = s_fetch;
            end
        endcase
end

assign o_addr = _addr; /* probably should be hiZ when not driven by the CPU */

endmodule
