/*
 * Simple 32bit cpu with load/store operations.
 *
 * Phases:
 *  1. fetch
 *  2. decode
 *  3. execute
 *  4. store
 */
`timescale 1ns/1ps
`default_nettype none


module cpu(
    input wire clk,
    input wire reset,
/* verilator lint_off UNUSED */
    input wire [31:0] i_data,
/* verilator lint_off UNDRIVEN */
    output wire [31:0] o_data,
    output wire [31:0] o_addr,
    output wire o_wb_cyc,
    output wire o_wb_stb,
    input wire i_wb_ack,
    input wire i_wb_stall
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
parameter CARRY = 0;
parameter SIGN  = 1;
parameter ZERO  = 2;
parameter OVERF = 3;
reg [width_flags_reg - 1:0] flags;
reg [width_flags_reg - 1:0] _flags;
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
 * The flags are reset during a load.
 *
 * > Jumps
 *
 * - 4bits: opcode
 * - 4bits: indicate the condition for the jump
 * - 4bits: register containing the address where jump to
 * - 1bit:  save the return address
 * - 3bits: register where to put the return address (r8-r15)
 * - 16bits: offset
 *
 *   |  op  |    cond   |   reg source  | save | reg return  |    offset   |
 *    31  28 27       24 23           20   19   18         16 15          0
 *
 *
 *  jr r7               pc = r7
 *  jrl r7              r15 = pc, pc = r7
 *  jrl r7, r6          r6 = pc, pc = r7
 *
 * The flags are preserved during a jump.
 *
 * Note that mov r0, rX is like a jump so we could save the conditional bit
 *
 * > Add
 *
 *  - 4bits: opcode
 *  - 4bits: destination register
 *  - 4bits: first source register
 *  - 1bit: upper/lower
 *  - 3bits: second source register (r8-r15)
 *  - 16bits: immediate value
 *
 *  |    op     |   dest   |   src   |  u/l | src2  |   immediate  |
 *   31       28 27      24 23     20   19   18   16 15           0
 *
 *  add r7, r11, r12                 r7 = r11 + r12
 *  add r7, r7, 0xabcd               r7 = r7 + 0xabcd
 *  addu r7, r7, 0xabcd              r7 = r7 + 0xabcd0000
 *  add r6, r2, r9 + 0x1d34           r6 = r2 + r9 + 0x1d34
 *
 *  The flags are modified depending on the result of the operation.
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
parameter s_fetch   = 4'b0001;    // fetch next instruction from memory
parameter s_decode  = 4'b0010;    // decode instruction into opcode and operands
parameter s_execute = 4'b0100;    // execute the instruction inside the ALU
parameter s_store   = 4'b1000;    // store the result back to memory

wire [3:0] current_state;

/* Initialize internals */
initial begin
        registers[0] = 32'hb0000000;
        _flags = 16'b0;
end

integer i;
/* Sequential part */
always @(posedge clk)
begin
    if (~reset)
    begin
        current_state = 4'b0001;
        registers[0] <= 32'hb0000000;
        flags <= 16'b0;
        //_flags <= 16'b0;
    end
    else
        if (store) begin
            for (i = 0 ; i < 16 ; i++) begin
                registers[i] <= _registers[i];
            end
            flags <= _flags;
        end
end

/*
 * d and q are the conventional labels to the input/output of the flip-flops
 */
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
                _registers[0] = registers[0] + 4;

            end
            s_execute:
            begin
                case (opcode)
                    HALT:
                    begin
                    end
                    LOAD:
                    begin
                        // isImmediate = q_instruction[27:27];
                        // isDirect = q_instruction[26:26];
                        // width = q_instruction[25:25]
                        //_registers[q_instruction[23:20]] = {16'b0, q_instruction[15:0]};
                        _flags[3:0] = 4'b0;
                        // FIXME: use 'u' to load upper part
                        load_type = 1;
                    end
                    JUMP:
                    /*
                     * We simply want to perform a move into the PC
                     */
                    begin
                    /*
                        _registers[0] = registers[q_instruction[23:20]];
                        if (q_instruction[19]) begin
                            _registers[q_instruction[19:16]] = registers[0] + 4;
                        end
                        */
                    end
                    ADD:
                    begin
                    /*
                        {_flags[CARRY], _registers[q_instruction[27:24]]} = 
                            registers[q_instruction[23:20]] + registers[{1'b1, q_instruction[18:16]}];
                            */
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
                endcase
            end
            s_store:
            begin
                load_type = 0; /* reset possible loads */
                store = 1; /* now we can commit the changes to the registers */
            end
        endcase
end

wire enable_fetch;

fetch fetch_phase(
    .clk(clk),
    .reset(reset),
    .i_enable(enable_fetch),
    .i_pc(registers[0]),
    .o_instruction(fetched_instruction),
    .o_completed(enable_decode),
    .o_wb_addr(o_addr),
    .o_wb_cyc(o_wb_cyc),
    .o_wb_stb(o_wb_stb),
    .i_wb_ack(i_wb_ack),
    .i_wb_data(i_data)
);

wire fetched_instruction;
wire enable_decode;

decode decode_phase(
    .reset(reset),
    .i_enable(enable_decode),
    .i_instruction(fetched_instruction),
    .o_opcode(opcode),
    .o_operandA(operandA),
    .o_operandB(operandB),
    .o_operandC(operandC),
    .o_completed(enable_execute)
);

wire opcode, operandA, operandB, operandC;

wire enable_execute;

assign current_state = {0, enable_execute, enable_decode, enable_fetch};

endmodule
