`timescale 1ns / 1ps
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
 */
module framebuffer(
	input wire clk,
	input wire [9:0] x,
	input wire [8:0] y,
	input wire text_mode,
	output wire [2:0] pixel
);

wire  [6:0] column;        // 80 columns
wire  [5:0] row;           // 30 rows
wire [11:0] text_address;
wire  [7:0] text_value;    // character to display

wire  [2:0] glyph_x;       // coordinates
wire  [3:0] glyph_y;       // in the grid of the glyph
wire [13:0] glyph_address; 
 
// (column, row) = (x / 8, y / 16)
assign column = x[9:3];
assign row = y[8:4]; // FIXME
assign text_address = column + (row * 80);

text_memory tm(
  .clka(clk), // input clka
  .wea(wea), // input [0 : 0] wea
  .addra(text_address), // input [11 : 0] addra
  .dina(dina), // input [7 : 0] dina
  .clkb(clk), // input clkb
  .addrb(text_address), // input [11 : 0] addrb
  .doutb(text_value) // output [7 : 0] doutb
);

// here we get the remainder
assign glyph_x = x[2:0];
assign glyph_y = y[3:0];
                        // text_value * 128 + glyph_x + (glyph_y * 16)
assign glyph_address = (text_value << 7) + glyph_x + (glyph_y << 4);

blk_mem_gen_v7_3 glyph_rom(
  .clka(clk), // input clka
  .addra(glyph_address), // input [13 : 0] addra
  .douta(pixel[0]) // output [0 : 0] douta
);
endmodule
