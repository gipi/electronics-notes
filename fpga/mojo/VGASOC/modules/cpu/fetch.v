/*
 * Instruction fetch module.
 *
 * This implements a master wishbone controller to query the memory for an
 * instruction.
 *
 * TODO: add stall signal
 *
 * This controller has four states:
 *
 *  IDLE: it's not active, has strobe and cycle not asserted waiting for
 *  enable to be asserted
 *  START TRANSACTION: enable is asserted, cycle and strobe are asserted
 *  WAITING RESULT: strobe deasserted, waiting for acknowledge
 *  COMPLETED: cycle deasserted and completed asserted
 *
 *  Some hints adopted from
 *   <https://zipcpu.com/zipcpu/2017/11/18/wb-prefetch.html>.
 *
 */
`timescale 1ns/1ps
`default_nettype none

module fetch(
    input wire clk,
    input wire reset,
    input wire i_enable, /* from cpu */
    input wire [31:0] i_pc, /* from cpu */
    output reg [31:0] o_instruction, /* to cpu */
    output reg o_completed, /* to cpu */
    output reg o_wb_cyc,
    output reg o_wb_stb,
    input wire [31:0] i_wb_data,
    input wire i_wb_ack,
    output reg [31:0] o_wb_addr
);

initial begin
    o_wb_cyc = 1'b0;
    o_wb_stb = 1'b0;
    o_completed = 1'b0;
end

always @(posedge clk)
/* IDLE: from a reset or from an ack during a transaction */
if (~reset | (i_wb_ack && o_wb_cyc))
begin
    o_wb_cyc <= 1'b0;
    o_wb_stb <= 1'b0;
end
/* START TRANSACTION: it's enabled so we assert cycle and strobe */
else if (!o_wb_cyc && i_enable && !o_completed)
begin
    o_wb_cyc <= 1'b1;
    o_wb_stb <= 1'b1;
    o_wb_addr <= i_pc;
    o_completed <= 1'b0;
end
/* WAITING RESULT */
else if(o_wb_cyc)
begin
    o_wb_stb <= 1'b0;
end

/* COMPLETED */
always @(posedge clk) begin
    if (o_wb_cyc && i_wb_ack) begin
        o_instruction <= i_wb_data;
        o_completed <= 1'b1;
    end
end

always @(posedge clk) begin
    if (o_completed)
        o_completed <= 1'b0;
end

endmodule
