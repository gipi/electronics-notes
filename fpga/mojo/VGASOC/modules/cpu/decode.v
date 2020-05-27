/*
 * Decodes the meaning of the instruction.
 *
 * Note: for now it's a combinatorial logic module, no clock involved!
 */
`timescale 1ns/1ps
`default_nettype none

module decode(
    /* input wire clk, */
    input  wire reset,
    input  wire i_enable,
    input  wire [31:0] i_instruction,
    output wire [3:0]  o_opcode,
    output wire [27:0] o_operandA,
    output wire [27:0] o_operandB,
    output wire [27:0] o_operandC,
    output reg o_completed
);

endmodule
