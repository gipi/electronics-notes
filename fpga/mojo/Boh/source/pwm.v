module pwm #(parameter OFFSET=0, COUNTER=25 - 1)(
    input clk,  // clock
    input rst,  // reset
    output out
  );

 // Input clock is 50MHz
 localparam CLOCK_FREQUENCY = 50000000;
 
 // Counter for toggling of clock
 integer counter = OFFSET;
 
 reg sq_wave_reg = 0;
 assign out = sq_wave_reg;
 
 always @(posedge clk) begin
 
   if (rst) begin
     counter <= 8'h00;
     sq_wave_reg <= 1'b0;
   end
 
   else begin 
 
   // If counter is zero, toggle sq_wave_reg 
   if (counter == 8'h00) begin
     sq_wave_reg <= ~sq_wave_reg;
   
     // Generate 1Hz Frequency
     counter <= COUNTER;  
   end 
 
   // Else count down
   else 
     counter <= counter - 1; 
   end
 end
endmodule
