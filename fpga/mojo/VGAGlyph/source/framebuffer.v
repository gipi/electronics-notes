`timescale 1ns / 1ps
`default_nettype none
/*
 * This modules returns the value of the pixel to be displayied
 * at coordinate (x, y) allowing to select when get as source
 * the text or the raster buffer.
 *
 * RASTER MODE
 * -----------
 *
 * We use a Dual RAM of 640x480*3 = 921600 bits = 115200 bytes; this
 * will contain the raw RGB values to display.
 *
 *
 * TEXT MODE
 * ---------
 *
 * We want to write some text using glyph stored into some ROM.
 *
 * Each glyph is a matrix of 8x16 pixels, we want to cover at least the
 * first 127 ASCII character, so we need at least 128*128 = 16384 bits
 * (so an address space of 14 bits).
 *
 * 640x480 will give us 80x30 characters, so the TEXT buffer needs 2400 bytes
 * (so an address space of 12 bits).
 *
 * NB: since there are two memories involved, there are two clock cycles
 *     of delay before the right pixel values come out.
 *
 */
module framebuffer(
	input wire clk,
    input wire we,
    /* verilator lint_off UNUSED */
    input wire [11:0] addr,
    input wire [7:0] i_data,
    /* verilator lint_off UNDRIVEN */
    output reg [7:0] o_data,
	input wire [9:0] x,
	input wire [9:0] y,
	input wire text_mode,
	output wire [2:0] o_pixel
);

wire  [6:0] column;        // 80 columns
wire  [4:0] row;           // 30 rows
wire [11:0] text_address;
wire  [7:0] text_value;    // character to display

reg  [2:0] glyph_x;       // coordinates
reg  [3:0] glyph_y;       // in the grid of the glyph
wire [13:0] glyph_address; 
 
// (column, row) = (x / 8, y / 16)
assign column = x[9:3];
assign row = y[8:4];
/* verilator lint_off WIDTH */
assign text_address = column + (row * 80);

text_ram tr(
  .clk(clk), // input clka
  .we(we), // input [0 : 0] wea
  .addr(text_address), // input [11 : 0] addra
  .i_data(i_data), // input [7 : 0] dina
  .o_data(text_value) // output [7 : 0] doutb
);

// here we get the remainder
// it's delayed of the one clock cycle needed
// to sync with the value from the text memory
always @(posedge clk) begin
	glyph_x <= x[2:0];
	glyph_y <= y[3:0];
end


/* verilator lint_off WIDTH */
                     // text_value * (8*16) + glyph_x + (glyph_y * 8)
assign glyph_address = (text_value << 7) + glyph_x + (glyph_y << 3);

glyph_rom glyph(
  .clk(clk),
  .addr(glyph_address),
  .data(o_pixel[0])
);

/* we are using setting white as output */
assign o_pixel[1] = o_pixel[0];
assign o_pixel[2] = o_pixel[0];

endmodule
