/*
 * Decodes the meaning of the instruction.
 *
 * Note: for now it's a combinatorial logic module, no clock involved!
 */
`timescale 1ns/1ps
`default_nettype none

module decode(
    input wire clk,
    input  wire reset,
    input  wire i_enable,
    input  wire [31:0] i_instruction,
    output wire [3:0]  o_opcode,
    output wire [3:0] o_extra,
    output wire [3:0] o_operandA,
    output wire [3:0] o_operandB,
    output wire [15:0] o_immediate,
    output reg o_completed
);

always @(posedge clk) begin
    o_completed <= i_enable && reset;
end

assign o_opcode = i_instruction[31:28];
assign o_extra = i_instruction[27:24];
assign o_operandA = i_instruction[23:20];
assign o_operandB = i_instruction[19:16];
assign o_immediate = i_instruction[15:0];

endmodule
