/*
 VGA
 ---
 
 The VGA 640x480@60Hz is really a canvas of 800x525 pixels clocks (pc)
 
 HSYNC                       VSYNC
 -----                       -----
 
 front porch: 16pc           10pc
 sync pulse:  96pc           2pc
 back porch:  48pc           33pc
*/
module hvsync_generator(
    input clk,
    output vga_h_sync,
    output vga_v_sync,
    output reg inDisplayArea,
    output reg [9:0] CounterX,
    output reg [9:0] CounterY
  );
reg vga_HS, vga_VS;

wire CounterXmaxed = (CounterX == 800); // 16 + 48 + 96 + 640
wire CounterYmaxed = (CounterY == 525); // 10 + 2 + 33 + 480

  // Module get from <http://www.fpga4fun.com/PongGame.html>
always @(posedge clk)
if (CounterXmaxed)
  CounterX <= 0;
else
  CounterX <= CounterX + 1;

always @(posedge clk)
begin
  if (CounterXmaxed)
  begin
    if(CounterYmaxed)
      CounterY <= 0;
    else
      CounterY <= CounterY + 1;
  end
end

always @(posedge clk)
begin
  vga_HS <= (CounterX > (640 + 16) && (CounterX < (640 + 16 + 96)));   // active for 96 clocks
  vga_VS <= (CounterY > (480 + 10) && (CounterY < (480 + 10 + 2)));   // active for 2 clocks
end

always @(posedge clk)
begin
	inDisplayArea <= (CounterX < 640) && (CounterY < 480);
end

assign vga_h_sync = ~vga_HS;
assign vga_v_sync = ~vga_VS;

endmodule
