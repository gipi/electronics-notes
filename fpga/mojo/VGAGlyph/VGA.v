`timescale 1ns / 1ps
module VGA(
	input wire clk,
	output wire[2:0] pixel,
	output hsync_out,
   output vsync_out
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


clk_25MHz clk_video(
  .CLK_IN1(clk),
  .CLK_OUT1(clk_25),
  .RESET(rst)
);

hvsync_generator hvsync(
  .clk(clk_25),
  .vga_h_sync(hsync_out),
  .vga_v_sync(vsync_out),
  .CounterX(CounterX),
  .CounterY(CounterY),
  .inDisplayArea(inDisplayArea)
);

framebuffer fb(
	.clk(clk_25),
	.x(CounterX),
	.y(CounterY),
	.pixel(framebuffer_pixel)
);

always @(posedge clk_25)
begin
  if (inDisplayArea)
    r_pixel <= framebuffer_pixel;
  else // if it's not to display, go dark
    r_pixel <= 3'b000;
end

assign pixel = r_pixel;

endmodule
