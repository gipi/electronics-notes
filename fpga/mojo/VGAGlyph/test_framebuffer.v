`timescale 1ns / 1ps

module test_framebuffer;

	// Inputs
	reg clk;
	reg [9:0] x;
	reg [8:0] y;
	reg text_mode;

	// Outputs
	wire [2:0] pixel;

	// Instantiate the Unit Under Test (UUT)
	framebuffer uut (
		.clk(clk), 
		.x(x), 
		.y(y), 
		.text_mode(text_mode), 
		.pixel(pixel)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		text_mode = 0;

		// Wait 100 ns for global reset to finish
		#100;
	end
	
	integer i;
	initial begin
		for (i = 0 ; i < 1000 ; i = i+1)
			#2 clk = ~clk;
	end

	integer j,k;
	initial begin
		#100;
		for (j = 0 ; j < 8*2 ; j = j+1)
		begin
			for (k = 0 ; k < 16*2; k = k+1)
			begin
				#4
				x = j;
				y = k;
			end
		end
	end
      
endmodule

