/*
 * Block ROM for the glyphs: we have 128 entries and each glyph is a matrix of 8x16 bits
 * so we need 16384bits
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
    input [13:0] addr,
    output reg [0:0] data
);

reg [0:0] rom[16383:0];

initial begin
    $readmemh("../source/glyph.mem", rom);
end

always @(posedge clk) begin
    data <= rom[addr];
end

endmodule
