`timescale 1ns / 1ps
`default_nettype none

module VGA(
	input wire clk,
	input wire rst,
	output wire[2:0] pixel,
	output wire hsync_out,
   output wire vsync_out
);

wire inDisplayArea;
wire [9:0] CounterX;
wire [8:0] CounterY;

wire [6:0] column;
wire [5:0] row;
wire [2:0] idx;
reg  [2:0] r_pixel;
wire [2:0] framebuffer_pixel;
wire clk_25;

reg hsync_delayed1;
reg hsync_delayed2;
reg hsync_delayed3;

reg vsync_delayed1;
reg vsync_delayed2;
reg vsync_delayed3;

reg inDisplayAreaDelayed1;
reg inDisplayAreaDelayed2;

// Here we delay the hsync and vsync to align with the
// value of the pixels
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

assign hsync_out = hsync_delayed2;
assign vsync_out = vsync_delayed2;

hvsync_generator hvsync(
  .clk(clk),
  .vga_h_sync(hsync_out_original),
  .vga_v_sync(vsync_out_original),
  .CounterX(CounterX),
  .CounterY(CounterY),
  .inDisplayArea(inDisplayArea)
);

framebuffer fb(
	.clk(clk),
	.x(CounterX),
	.y(CounterY),
	.pixel(framebuffer_pixel)
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

endmodule
