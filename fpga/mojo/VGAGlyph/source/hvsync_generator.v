`default_nettype none
/*
 VGA
 ---
 
 The VGA 640x480@60Hz is really a canvas of 800x525 clocks
 
 HSYNC                       VSYNC
 -----                       -----
 
 front porch: 16pc           10pc
 sync pulse:  96pc           2pc
 back porch:  48pc           33pc
*/
module hvsync_generator(
    input wire clk,
    input wire rst,
    output wire vga_h_sync,
    output wire vga_v_sync,
    output wire inDisplayArea,
    output reg [9:0] CounterX,
    output reg [9:0] CounterY
  );
  
initial begin
	CounterX = 0;
	CounterY = 0;
end

reg vga_HS, vga_VS;

wire CounterXmaxed = (CounterX == 800);
wire CounterYmaxed = (CounterY == 525);

  // Module get from <http://www.fpga4fun.com/PongGame.html>
always @(posedge clk)
if (~rst || CounterXmaxed)
  CounterX <= 0;
else
  CounterX <= CounterX + 1'b1;

always @(posedge clk)
begin
  if (~rst || CounterXmaxed)
  begin
    if(~rst || CounterYmaxed)
      CounterY <= 0;
    else
      CounterY <= CounterY + 1'b1;
  end
end

always @(posedge clk)
begin
  vga_HS <= (CounterX > (640 + 16) && (CounterX < (640 + 16 + 96)));   // active for 96 clocks
  vga_VS <= (CounterY > (480 + 10) && (CounterY < (480 + 10 + 2)));   // active for 2 clocks
end

assign inDisplayArea = (CounterX < 640) && (CounterY < 480);


assign vga_h_sync = ~vga_HS;
assign vga_v_sync = ~vga_VS;

endmodule