/*
 * Simple 32bit cpu with load/store operations.
 *
 * Phases:
 *  1. fetch
 *  2. decode
 *  3. execute
 *  4. store
 *
 * TODO:
 *  - traps/exceptions/interrupts
 *
 */
`timescale 1ns/1ps
`default_nettype none


module cpu(
    input wire clk,
    input wire reset,
/* verilator lint_off UNUSED */
    input wire i_exception,
/* verilator lint_off UNUSED */
    input wire [31:0] i_data,
/* verilator lint_off UNDRIVEN */
    output wire [31:0] o_data,
    output wire [31:0] o_addr,
    output wire o_we,
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
parameter PC = 0;
parameter SP = 14;
parameter LN = 15;
parameter opcode_size = 4;        // size of opcode in bits
parameter n_reg       = 16;       // number of registers
parameter width_reg   = 32;       // width in bits of the registers
parameter width_flags_reg = 16;

reg [width_reg - 1:0] registers[n_reg - 1:0]; // here our registers
reg [width_reg - 1:0] inner_registers[n_reg - 1:0]; // here our copy to store final writes


/*
 * FLAGS
 *
 *  - carry
 *  - sign
 *  - zero
 *  - overflow
 */
parameter CARRY = 2'b0;
parameter SIGN  = 2'b1;
parameter ZERO  = 2'b10;
parameter OVERF = 2'b11;
reg [width_flags_reg - 1:0] flags;
reg [width_flags_reg - 1:0] _flags;


/* Initialize internals */
initial begin
        registers[0] = 32'hb0000000;
        inner_registers[0] = 32'hb0000000;
        _flags = 16'b0;
        enable_fetch = 1'b0;
end

/* Sequential part */
always @(posedge clk)
begin
    if (~reset)
    begin
        registers[PC] <= 32'hb0000000;
        inner_registers[PC] <= 32'hb0000000;
        registers[SP] <= 32'hb000fffc; /* at reset we use the internal RAM for the stack */
        inner_registers[SP] <= 32'hb000fffc; /* at reset we use the internal RAM for the stack */
        flags <= 16'b0;
        //_flags <= 16'b0;
        enable_fetch <= 1'b1;
    end
    else
        enable_fetch <= feedback_enable_fetch;
end


reg enable_fetch;

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

wire [31:0] fetched_instruction;
wire enable_decode;

decode decode_phase(
    .clk(clk),
    .reset(reset),
    .i_enable(enable_decode),
    .i_instruction(fetched_instruction),
    .o_opcode(opcode),
    .o_extra(extra),
    .o_operandA(operandA),
    .o_operandB(operandB),
    .o_immediate(immediate),
    .o_completed(enable_execute)
);

reg enable_execute;
wire [3:0] opcode;
wire [3:0] extra;
wire [3:0] operandA;
wire [3:0] operandB;
wire [15:0] immediate;

parameter NOP  = 4'b0000; /* 0 */
parameter LOAD = 4'b0001; /* 1 */
parameter MOVE = 4'b0010; /* 2 */
parameter JUMP = 4'b0011; /* 3 */
parameter ADD  = 4'b0100; /* 4 */
parameter SUB  = 4'b0101; /* 5 */
parameter MUL  = 4'b0110; /* 6 */
parameter STR  = 4'b0111; /* 7 */
parameter PUSH = 4'b1000; /* 8 */
parameter POP  = 4'b1001; /* 9 */
parameter XOR  = 4'b1010; /* a */
parameter HALT = 4'b1011; /* b */

/*
 * Layout instructions
 *
 *  - 4bits: opcode
 *  - 4bits: extra
 *  - 4bits: destination register
 *  - 4bits: operand register
 *  - 16bits: immediate
 *
 *   |  op  |    extra  |   reg dest    |    op  reg      n  |    offset   |
 *    31  28 27       24 23           20 19                16 15          0
 *
 * > Loads
 *
 * This instruction loads into a destination register (rd) the value
 * pointed in the location in memory pointed by a source register
 * plus an offset or an immediate.
 *
 *  - 4bits: opcode
 *  - 2bits: width of the operation (byte, short, word).
 *  - 1bit:  immediate/register [ldi/ldr]
 *  - 1bit:  upper/lower for the intermediate
 *  - 4bits: destination register idx
 *  - 4bits: source register idx
 *  - 16bits: value (when reg as source use msb to indicate relative addressing)
 *
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
 * - 1bit:  absolute/relative (MIPS has branch and jump as different instructions)
 * - 3bits: register containing the address where jump to (r8-r15)
 * - 1bit:  save the return address
 * - 3bits: register where to put the return address (r8-r15)
 * - 16bits: offset
 *
 *   |  op  |    cond   |   reg source  | save | reg return  |    offset   |
 *    31  28 27       24 23           20   19   18         16 15          0
 *
 *  jr r8               pc = r7
 *  jrl r8              r15 = pc, pc = r8
 *  jrl r8, r12         r12 = pc, pc = r8
 *  jrr r11             pc += r12
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
 *
 * > Multiplication
 *
 * mul r7, r6
 *
 */
/*********************************
 * EXECUTE STEP
 *********************************/
/*
 * Here we are in trouble: some operations need first to load something from
 * memory to set a register (LOAD) and other to save something in memory.
 *
 * The latter is not a problem, for the former we need to save the register
 * index where to load the data meanwhile we are waiting to fetch the data
 * itself.
 */
reg [3:0] store_reg_idx;
wire loadImmediate, loadUpper;

assign loadImmediate = extra[0];
assign loadUpper = extra[1];

/* JUMP */
wire saveLink, jumpRelative;
wire [3:0] linkRegister;

assign saveLink = operandB[3];
assign jumpRelative = operandA[3];
assign linkRegister = {1'b1, operandB[2:0]};

/* multiplication */
wire [3:0] destinationMSB, destinationLSB;
assign destinationMSB = operandA;
assign destinationLSB = operandB;

reg enableWriteBack; /* rename "commit"? */

always @(posedge clk)
begin
        if (enable_execute)
        begin
        inner_registers[0] <= inner_registers[0] + 4;
        enable_execute <= 1'b0;
        case (opcode)
            NOP:
            begin
                enableWriteBack <= 1'b1;
            end
            LOAD:
            begin
                if (loadImmediate) begin
                    if (loadUpper)
                        inner_registers[operandA][31:16] <= immediate ;
                    else
                        inner_registers[operandA][15:0] <= immediate ;

                    enableWriteBack <= 1'b1;
                end
                else begin
                    store_reg_idx <= operandA;
                end
            end
            MOVE:
            begin
               inner_registers[operandA] <= inner_registers[operandB];
               enableWriteBack <= 1'b1;
            end
            HALT:
            begin
            end
            JUMP:
            begin
                /* we allow only 4bits aligned addresses */
                /* should we fault? */
                if (jumpRelative) /* FIXME: negative offset? */
                    inner_registers[PC] <= inner_registers[PC] + (inner_registers[operandA] & ~(32'h3));
                else
                    inner_registers[PC] <= inner_registers[operandA] & ~(32'h3);
                if (saveLink)
                    inner_registers[linkRegister] <= inner_registers[PC];
                enableWriteBack <= 1'b1;
            end
            ADD:
            begin
            end
            SUB:
            begin
            end
            MUL:
            begin
                {inner_registers[destinationMSB], inner_registers[destinationLSB]} <= inner_registers[operandA] * inner_registers[operandB];
                enableWriteBack <= 1;
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
            XOR:
            begin
            end
            default:
            begin
            end
        endcase
        end
end

always @(posedge clk)
begin
    if (enableWriteBack) begin
        registers <= inner_registers;
        enable_fetch <= 1;
        enableWriteBack <= 1'b0;
    end
end

wire feedback_enable_fetch;

endmodule
