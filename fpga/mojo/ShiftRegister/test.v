`timescale 1ns / 1ps
module stimulus;
	// Inputs
	reg clk ;
	reg reset;
	// Outputs
	reg s_in;
	wire s_out;
	// Instantiate the Unit Under Test (UUT)
	free_run_shift_reg  #(2) s1  (
		.clk(clk), 
		.rst(reset), 
		.s_in(s_in),
		.s_out(s_out)
	);
 
 integer i, j;
 initial 
 begin
 
 clk = 0;
 for(i =0; i<=40; i=i+1)
 begin
  #10 clk = ~clk;
 end
 end
 
initial 
begin
	s_in = 0; reset =1;
	#2 s_in = 0 ; reset = 0;
	#2 reset =1;
	for(i =0; i<=10; i=i+1)
	begin
	  #20 s_in = ~s_in;
	end
	#20 s_in = 1;
	#20 s_in = 1;
	#20 s_in = 0;
	#20 s_in = 1;
	#20 s_in = 1;
	#20 s_in = 0;
	#20 s_in = 1;
	#20 s_in = 1;
	#20 s_in = 0;
end  
 
initial begin
	$monitor("clk=%d s_in=%d,s_out=%d",clk,s_in, s_out);
end
 
endmodule