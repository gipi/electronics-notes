`timescale 1ns / 1ps
// http://referencedesigner.com/tutorials/verilog/verilog_32.php
module free_run_shift_reg#(parameter N=8)(
    input clk,
    input rst,
    input s_in,
    output s_out
    );

// signal declaration
reg [N-1:0] r_reg;
wire [N-1:0] r_next;

always @(posedge clk or posedge rst)
	if (rst)
		r_reg <= 0;
	else
		r_reg <= r_next;


assign r_next = {s_in, r_reg[N-1:1]};
assign s_out = r_reg[0];

endmodule
