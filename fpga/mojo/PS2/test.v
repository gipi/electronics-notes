`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:10:20 01/10/2018
// Design Name:   ps2_rx
// Module Name:   /opt/3043096/fpga/mojo/PS2/test.v
// Project Name:  PS2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ps2_rx
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test;

	// Inputs
	reg clk;
	reg reset;
	reg ps2d;
	reg ps2c;
	reg rx_en;

	// Outputs
	wire rx_done_tick;
	wire [7:0] dout;

	integer i, j;

	// Instantiate the Unit Under Test (UUT)
	ps2_rx uut (
		.clk(clk), 
		.reset(reset), 
		.ps2d(ps2d), 
		.ps2c(ps2c), 
		.rx_en(rx_en), 
		.rx_done_tick(rx_done_tick), 
		.dout(dout)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		ps2d = 1;
		ps2c = 1;
		rx_en = 0;

		#100;		// Wait 100 ns for global reset to finish
		reset = 1;
		#20
		reset = 0;

		for (i = 0 ; i <= 1000 ; i = i+1)
		begin
			#2 clk = ~clk;
		end
		// Add stimulus here

	end
	
	initial begin
		#10
		rx_en = 1;
		#100
		for (j = 0 ; j <= 21 ; j = j+1)
		begin
			#50 ps2c = ~ps2c;
		end
	end

	initial begin
		#100
		ps2d = 1'b0; // start bit

		#100
		ps2d = 1'b0;

		#100
		ps2d = 1'b0;

		#100
		ps2d = 1'b1;

		#100
		ps2d = 1'b1;

		#100
		ps2d = 1'b1;

		#100
		ps2d = 1'b0;

		#100
		ps2d = 1'b0;

		#100
		ps2d = 1'b0;

		#100
		ps2d = 1'b0; // parity bit

		#100
		ps2d = 1'b1; // stop bit
	end
      
endmodule

