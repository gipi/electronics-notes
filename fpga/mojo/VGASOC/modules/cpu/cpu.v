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
 *  we use 1bit of the opcode to store if immediate or deference memory, or
 *  a register; obviously we cannot load directly 32bit as immediate so we can
 *  adopt some strategies like ARM with barrel shifter.
 *  Also, use a couple of bits to select the width of the loading (byte,
 *  short, word).
 *  Also load with relative addressing.
 *
 * > Jumps
 *
 * - we can indicate the register containing the address where jump to
 * - Xbits to indicate the condition for the jump
 * - 1bit to indicate if conditional or not
 * - 1bit to save the return address to r15
 *
 * Note that mov r0, rX is like a jump so we could save the conditional bit
 */

parameter HALT = 4'b0000; /* 0 */
parameter LOAD = 4'b0001; /* 1 */
parameter MOVE = 4'b0010; /* 2 */
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
        registers[0] <= next_pc;
        q_instruction <= i_data; /* we are reading the instruction from the*/
        q_opcode <= d_opcode;
        q_operand1 <= d_operand1;
        q_operand2 <= d_operand2;
        q_operand3 <= d_operand3;

        /*
         * TODO: factorize in a sub-module and use load_value as src_idx
         *       using load_type in a case() block.
         *       Probably should be a generic module to allow any number of
         *       registers to be loaded.
         */
        if (load_type == 2'b01)
        begin
            registers[dst_idx] <= load_value;
        end
        else if (load_type == 2'b10)
        begin
            registers[dst_idx] <= registers[load_value];
        end
end

/*
 * d and q are the conventional labels to the input/output of the flip-flops
 */
reg [31:0] q_instruction, d_instruction;
reg [31:0] q_addr, _addr;
reg [31:0] next_pc;
reg [3:0]  q_opcode, d_opcode;
reg [11:0] q_operand1, d_operand1;
reg [7:0]  q_operand2, d_operand2;
reg [7:0]  q_operand3, d_operand3;

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
                _addr = registers[0]; /* set the address line */
                next_pc = registers[0] + 4;

                next_state = s_decode;
            end
            s_decode:
            begin
                d_opcode = q_instruction[31:28];
                d_operand1 = q_instruction[27:16];
                d_operand2 = q_instruction[15:8];
                d_operand3 = q_instruction[7:0];

                next_state = s_execute;
            end
            s_execute:
            begin
                case (q_opcode)
                    MOVE:
                    begin
                    end
                    HALT:
                    begin
                    end
                    LOAD:
                    begin
                        dst_idx = q_operand3[3:0];
                        load_value = {q_operand1, 20'b0};
                        load_type = 1;
                    end
                    JUMP:
                    /*
                     * We simply want to perform a move into the PC
                     */
                    begin
                        next_pc = registers[q_operand3[3:0]]; /* FIXME: width for jump */
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
                next_state = s_fetch;
            end
        endcase
end

assign o_addr = _addr; /* probably should be hiZ when not driven by the CPU */

endmodule
