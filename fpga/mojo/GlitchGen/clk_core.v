`timescale 1ns / 1ps
module clk_core(
	input clk,
	output clk_16a,
	output clk_16b,
	output clk_16c
);

wire clk_16a_internal;
wire clk_16b_internal;
wire clk_16c_internal;

clk_base clk_target(
	.CLK_IN1(clk),
	.CLK_OUT1(clk_16a),
	.CLK_OUT1pi(clk_16api_internal),
	.RESET(rst)
);


clk_B clk_target_B(
	.CLK_IN1(clk_16a_internal),
	.CLK_OUT1(clk_16b_internal),
	.RESET(rst)
);

// https://forums.xilinx.com/t5/Spartan-Family-FPGAs/Clock-issue-about-spartan-6/td-p/67284/page/2
/*ODDR2 #(
      .DDR_ALIGNMENT("NONE"),
      .INIT(1'b0),
      .SRTYPE("SYNC")
   ) ODDR2_a (
      .Q   (clk_16a), // 1-bit DDR output data
      .C0  (clk_16a_internal),     // 1-bit clock input
      .C1  (~clk_16a_internal),    // 1-bit clock input
      .CE  (1'b1),         // 1-bit clock enable input
      .D0  (1'b1),
      .D1  (1'b0),
      .R   (1'b0),   // 1-bit reset input
      .S   (1'b0)    // 1-bit set input
   );
	*/
ODDR2 #(
      .DDR_ALIGNMENT("NONE"),
      .INIT(1'b0),
      .SRTYPE("SYNC")
   ) ODDR2_b (
      .Q   (clk_16b), // 1-bit DDR output data
      .C0  (clk_16b_internal),     // 1-bit clock input
      .C1  (~clk_16b_internal),    // 1-bit clock input
      .CE  (1'b1),         // 1-bit clock enable input
      .D0  (1'b1),
      .D1  (1'b0),
      .R   (rst),   // 1-bit reset input
      .S   (1'b0)    // 1-bit set input
   );
clk_C clk_target_C(
	.CLK_IN1(clk_16a_internal),
	.CLK_OUT1(clk_16c_internal),
	.RESET(rst)
);

ODDR2 #(
      .DDR_ALIGNMENT("NONE"),
      .INIT(1'b0),
      .SRTYPE("SYNC")
   ) ODDR2_c (
      .Q   (clk_16c), // 1-bit DDR output data
      .C0  (clk_16c_internal),     // 1-bit clock input
      .C1  (~clk_16c_internal),    // 1-bit clock input
      .CE  (1'b1),         // 1-bit clock enable input
      .D0  (1'b1),
      .D1  (1'b0),
      .R   (rst),   // 1-bit reset input
      .S   (1'b0)    // 1-bit set input
   );
endmodule
