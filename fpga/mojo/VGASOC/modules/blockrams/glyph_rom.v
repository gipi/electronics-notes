/*
 * Block ROM for the glyphs: we have 128 entries and each glyph is a matrix of 8x16 bits
 * so we need 16384bits.
 *
 * It uses the wishbone interface.
 *
 * Inspired by
 *
 *  <https://stackoverflow.com/questions/36610527/how-to-initialize-contents-of-inferred-block-ram-bram-in-verilog>
 *  <https://timetoexplore.net/blog/block-ram-in-verilog-with-vivado>
 */
`timescale 1ns / 1ps
`default_nettype none

module glyph_rom(
    input wire clk,
    // input i_wb_cyc,
    input       i_wb_stb,
    output reg  o_wb_ack,
    output wire o_wb_stall,
    input  wire [13:0] i_addr,
    output reg [0:0] o_data
);

reg [0:0] rom[16383:0];

initial begin
    $readmemh("glyph.mem", rom);
end

always @(posedge clk) begin
    if (i_wb_stb) begin
        o_data <= rom[i_addr];
    end
    o_wb_ack <= i_wb_stb && !o_wb_stall;
end

assign o_wb_stall = 1'b0;

endmodule
