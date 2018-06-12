`timescale 1ns / 1ps
module VGA(
	input wire clk,
	input wire rst,
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

  // Input buffering
  //------------------------------------
  IBUFG clkin1_buf
   (.O (clkin1),
    .I (clk));

clk_25MHz clk_video(
  .CLK_IN1(clkin1),
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
	.clk(clkin1),
	.x(CounterX),
	.y(CounterY),
	.pixel(framebuffer_pixel)
);

/*
 * The "draw" register is used to be sure that the memories
 * had enough time to read the memory and output the pixel
 * values for the glyphs.
 *
 * For this reason this piece of hardware uses a clock with
 * a frequency that is twice the pixel clock.
 */
reg draw;

initial begin
	draw = 0;
end

always @(posedge clkin1)
begin
	draw <= ~draw;
	if (draw)
	begin
	  if (inDisplayArea)
		 r_pixel <= framebuffer_pixel;
	  else // if it's not to display, go dark
		 r_pixel <= 3'b000;
	end
end

assign pixel = r_pixel;

endmodule
