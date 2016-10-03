module hvsync_generator(
    input clk,
    output vga_h_sync,
    output vga_v_sync,
    output inDisplayArea,
    output CounterX,
    output CounterY
  );
reg [9:0] CounterX;
reg [8:0] CounterY;
wire CounterXmaxed = (CounterX==767);

  // Module get from <http://www.fpga4fun.com/PongGame.html>
always @(posedge clk)
if(CounterXmaxed)
  CounterX <= 0;
else
  CounterX <= CounterX + 1;

always @(posedge clk)
if(CounterXmaxed)
    CounterY <= CounterY + 1;
   

reg vga_HS, vga_VS;
always @(posedge clk)
begin
  vga_HS <= (CounterX[9:4]==0);   // active for 16 clocks
  vga_VS <= (CounterY==0);   // active for 768 clocks
end

reg inDisplayArea;
always @(posedge clk)
if(inDisplayArea==0)
	inDisplayArea <= (CounterXmaxed) && (CounterY<480);
else
	inDisplayArea <= !(CounterX==639);

assign vga_h_sync = ~vga_HS;
assign vga_v_sync = ~vga_VS;

assign R = CounterY[3] | (CounterX==256);
assign G = (CounterX[5] ^ CounterX[6]) | (CounterX==256);
assign B = CounterX[4] | (CounterX==256);

endmodule