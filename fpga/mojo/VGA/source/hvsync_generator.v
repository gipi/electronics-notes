module hvsync_generator(
    clk,
    vga_h_sync,
    vga_v_sync,
    inDisplayArea,
    CounterX,
    CounterY
  );
  input clk;
  output vga_h_sync, vga_v_sync;
  output inDisplayArea;
  output [10:0] CounterX;
  output [9:0] CounterY;

  // Module get from <http://www.fpga4fun.com/PongGame.html>
  // we have changed values to accomodate the 50MHz clock instead of 25MHz
  //
  // With 50MHz clock we have a time-step of 20ns, in order to generate a hsync, vsync
  // of 31.5kHz and 60Hz we have to do
  
  // (1/(31.5*10^3))*10^9/20 = 1587.30158730158700000000
  // 31.5*10^3/60 = 525.00000000000000000000
  //////////////////////////////////////////////////
  reg [10:0] CounterX;
  reg [9:0] CounterY;
  wire CounterXmaxed = (CounterX == 1587); // we need 1587 clock-cycle for 31kHz
  wire CounterYmaxed = (CounterY == 526);  // we need 525*1587 clock-cycle for 60Hz

  always @(posedge clk)
    if(CounterXmaxed)
    	CounterX <= 0;
    else
    	CounterX <= CounterX + 1;

  // here we increment or reset the counter for the VSYNC signal
  always @(posedge clk)
    begin
      if(CounterXmaxed && !CounterYmaxed)
        CounterY <= CounterY + 1;
      if (CounterYmaxed)
        CounterY <= 0;
    end

  // here we generate the HSYNC and VSYNC signal to be sent to the VGA monitor
  reg	vga_HS, vga_VS;
  always @(posedge clk)
    begin
    	vga_HS <= (CounterX[10:5] == 0); // pulse width
    	vga_VS <= (CounterY == 525);     // (maybe) pulse width
    end

  reg inDisplayArea;
  always @(posedge clk)
    if(inDisplayArea == 0)
    	inDisplayArea <= (CounterXmaxed) && (CounterY < 480);
    else
    	inDisplayArea <= !(CounterX == 639);
  
  assign vga_h_sync = ~vga_HS;
  assign vga_v_sync = ~vga_VS;

endmodule