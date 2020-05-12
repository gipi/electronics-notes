/*
 * VGA controller.
 *
 * It has a raster/text memory as interface RW.
 */
`timescale 1ns / 1ps
`default_nettype none

module VGA(
    input wire clk,
    input wire rst,
    input wire we,
    input wire [11:0] addr,
    input wire [7:0] i_data,
    output reg [7:0] o_data,
    output wire [2:0] pixel,
    output wire hsync_out,
    output wire vsync_out,
    output o_inDisplayArea
);

wire inDisplayArea;
wire [9:0] CounterX;
wire [9:0] CounterY;

reg  [2:0] r_pixel;
/* verilator lint_off UNOPTFLAT */
wire [2:0] framebuffer_pixel;

reg hsync_delayed1;
reg hsync_delayed2;
reg hsync_delayed3;

reg vsync_delayed1;
reg vsync_delayed2;
reg vsync_delayed3;

reg inDisplayAreaDelayed1;
reg inDisplayAreaDelayed2;

// Here we delay the hsync and vsync to align with the
// value of the pixels. There are three clock cycles since
// we have two clock cycles from the framebuffer module
// and one from the last flip flop exiting block.
always@(posedge clk) begin
	hsync_delayed1 <= hsync_out_original;
	hsync_delayed2 <= hsync_delayed1;
	hsync_delayed3 <= hsync_delayed2;
	
	vsync_delayed1 <= vsync_out_original;
	vsync_delayed2 <= vsync_delayed1;
	vsync_delayed3 <= vsync_delayed2;

	inDisplayAreaDelayed1 <= inDisplayArea;
	inDisplayAreaDelayed2 <= inDisplayAreaDelayed1;
end

wire hsync_out_original;
wire vsync_out_original;

assign hsync_out = hsync_delayed3;
assign vsync_out = vsync_delayed3;


hvsync_generator hvsync(
  .clk(clk),
  .rst(rst),
  .vga_h_sync(hsync_out_original),
  .vga_v_sync(vsync_out_original),
  .CounterX(CounterX),
  .CounterY(CounterY),
  .inDisplayArea(inDisplayArea)
);

framebuffer fb(
	.clk(clk),
    .we(we),
    .addr(addr),
    .i_data(i_data),
    .o_data(o_data),
	.x(CounterX),
	.y(CounterY),
	.o_pixel(framebuffer_pixel),
    .text_mode(0)
);

/*
 * Use the delayed inDisplayArea to be in sync with the correct
 * pixel values.
 */
always @(posedge clk)
begin
	  if (inDisplayAreaDelayed2)
		 r_pixel <= framebuffer_pixel;
	  else // if it's not to display, go dark
		 r_pixel <= 3'b000;
end

assign pixel = r_pixel;

assign o_inDisplayArea = inDisplayAreaDelayed2;

endmodule
