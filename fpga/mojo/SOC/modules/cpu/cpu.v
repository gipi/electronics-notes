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
    output wire [31:0] o_data,
    output wire [31:0] o_wb_addr,
    output wire o_wb_we,
    output wire o_wb_cyc,
    output wire o_wb_stb,
    input wire i_wb_ack,
    input wire i_wb_stl,
    output wire [1:0] o_data_width
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
reg [width_flags_reg - 1:0] flags;

reg carry, sign, zero, overflow;
reg inner_carry;


/* Initialize internals */
initial begin
        registers[0] = 32'hb0000000;
        inner_registers[0] = 32'hb0000000;
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
        inner_registers[SP] <= 32'hb0010000; /* at reset we use the internal RAM for the stack */
        carry <= 1'b0;
        zero <= 1'b0;
        sign <= 1'b0;
        overflow <= 1'b0;
        enable_fetch <= 1'b1;
    end
end


reg enable_fetch;

always @(posedge clk)
    if (reset && enable_fetch)
        enable_fetch <= 1'b0;

fetch fetch_phase(
    .clk(clk),
    .reset(reset),
    .i_enable(enable_fetch),
    .i_pc(registers[0]),
    .i_value(32'h0000),
    .o_instruction(fetched_instruction),
    .o_completed(enable_decode),
    .o_wb_we(o_wb_we),
    .o_wb_addr(o_wb_addr),
    .o_wb_cyc(o_wb_cyc),
    .o_wb_stb(o_wb_stb),
    .i_wb_ack(i_wb_ack),
    .i_wb_stl(i_wb_stl),
    .i_wb_data(i_data),
    .o_wb_data(o_data),
    .i_data_width(2'b11),
    .o_data_width(o_data_width),
    .i_we(1'b0)
);

wire [31:0] fetched_instruction;
wire enable_decode;

always @(posedge clk) begin
    if (enable_decode) /* modify here the pc so that after we don't have race condition */
        inner_registers[PC] <= registers[PC] + 4;
end

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
 *  ldrmw  r8, [r10 + 0x1d34] r8 = *(r10 + 0x1d34)
 *
 * The flags are reset during a load. <--- FIX
 *
 * > Stores
 *
 * This instruction stores from a source register (rs) to
 * location in memory pointed by a destination register (rd)
 * plus an optional offset. IT IS NOT ALLOWED AN IMMEDIATE
 *
 *  - 4bits: opcode
 *  - 2bits: width of the operation (byte, short, word).
 *  - 1bit:  immediate/register [ldi/ldr] <--- fix
 *  - 1bit:  upper/lower for the intermediate
 *  - 4bits: destination register idx
 *  - 4bits: source register idx
 *  - 16bits: value (when reg as source is for offset)
 *
 *  st  r8, [r10 + 0x1d34] *(r10 + 0x1d34) = r8
 *
 * The flags are reset during a store. <--- FIX
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
 * > Push/Pop
 *
 * These instructions use the stack pointer (r14).
 *
 * push r12           sp -= 4; *(sp) = r12
 * pop r3             r3 = *(sp); sp += 4
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
reg [31:0] memoryReference; /* address used in the memory phase */
reg memoryWrite; /* we are going to write */
reg [31:0] memoryValue; /* value read/stored */

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
                    else begin // it's impossible to set a flag with a lower immediate
                        inner_registers[operandA][15:0] <= immediate ;
                    end

                    enableWriteBack <= 1'b1;
                    updateFlags <= 1'b0;
                end
                else begin
                    enableMemory <= 1'b1;
                    memoryWrite <= 1'b0;
                    memoryReference <= inner_registers[operandB] + {16'h0000, immediate};
                    store_reg_idx <= operandA;
                end
            end
            STR:
            begin
                memoryValue <= inner_registers[operandA];
                memoryReference <= inner_registers[operandB] + {16'h0000, immediate};
                memoryWrite <= 1'b1;
                enableMemory <= 1'b1;
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
                    inner_registers[PC] <= registers[PC] + (registers[{1'b1, operandA[2:0]}] & ~(32'h3));
                else
                    inner_registers[PC] <= registers[{1'b1, operandA[2:0]}];
                if (saveLink) // here we are saving the return address and inner_ has it
                    inner_registers[linkRegister] <= inner_registers[PC];
                enableWriteBack <= 1'b1;
            end
            ADD:
            begin
                {inner_carry, inner_registers[extra]} <= registers[operandA] + registers[{1'b1, operandB[2:0]}];
                enableWriteBack <= 1'b1;
                updateFlags <= 1'b1;
                store_reg_idx <= extra;
            end
            SUB:
            begin
            end
            MUL:
            begin
                {inner_registers[destinationMSB], inner_registers[destinationLSB]} <= inner_registers[operandA] * inner_registers[operandB];
                enableWriteBack <= 1;
            end
            /* the stack register has only memory related meaning, so it's
             * mandatory to be aligned to 4bytes*/
            PUSH:
            begin
                inner_registers[SP] <= (inner_registers[SP] & ~32'b11) - 4;
                memoryReference <= (inner_registers[SP] & ~32'b11) - 4;
                memoryValue <= inner_registers[operandA];
                memoryWrite <= 1'b1;
                enableMemory <= 1'b1;
            end
            POP:
            begin
                store_reg_idx <= operandA;
                memoryReference <= inner_registers[SP] & ~32'b11;
                enableMemory <= 1'b1;
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

reg enableMemory;
reg memoryCompleted;

/* HERE WE ARE GOING TO LOAD/STORE */
always @(posedge clk) begin
    if (enableMemory)
        enableMemory <= 1'b0;

    if (memoryCompleted) begin
        if (~memoryWrite) begin
            inner_registers[store_reg_idx] <= memoryValue;
            if (opcode == POP)
                inner_registers[SP] <= (inner_registers[SP] & ~32'b11) + 4;
        end

        enableWriteBack <= 1'b1;
        memoryWrite <= 1'b0;
    end
end

fetch loadOperation(
    .clk(clk),
    .reset(reset),
    .i_enable(enableMemory),
    .i_pc(memoryReference),
    .o_instruction(memoryValue),
    .i_value(memoryValue),
    .o_completed(memoryCompleted),
    .o_wb_addr(o_wb_addr),
    .o_wb_cyc(o_wb_cyc),
    .o_wb_stb(o_wb_stb),
    .o_wb_we(o_wb_we),
    .i_wb_ack(i_wb_ack),
    .i_wb_stl(i_wb_stl),
    .i_wb_data(i_data),
    .o_wb_data(o_data),
    .i_data_width(2'b11),
    .o_data_width(o_data_width),
    .i_we(memoryWrite)
);

reg updateFlags;

/* COMMIT STAGE */
always @(posedge clk)
begin
    if (enableWriteBack) begin
        registers <= inner_registers;
        enable_fetch <= 1;
        enableWriteBack <= 1'b0;
    end

    /* if the operation involves flags here we are going to update it */
    if (updateFlags) begin
        carry <= inner_carry;
        zero <= inner_registers[store_reg_idx] == width_reg * {1'b0};
        sign <= inner_registers[store_reg_idx][width_reg - 1] == 1'b1;
        overflow <= 1'b0;
    end
end

assign flags = {12'b0, overflow, sign, zero, carry};

endmodule
