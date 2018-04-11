module mojo_top(
    // 50MHz clock input
    input clk_mojo,
    // Input from reset button (active low)
    input rst_n,
    // cclk input from AVR, high when AVR is ready
    input cclk,
    // Outputs to the 8 onboard LEDs
    output[7:0]led,
    // AVR SPI connections
    output spi_miso,
    input spi_ss,
    input spi_mosi,
    input spi_sck,
    // AVR ADC channel select
    output [3:0] spi_channel,
    // Serial connections
    input avr_tx, // AVR Tx => FPGA Rx
    output avr_rx, // AVR Rx => FPGA Tx
    input avr_rx_busy, // AVR Rx buffer full
	 input  btn_select_clk,
	 input btn_manual_clk,
    output clk_target,
    output clk_16b,
    output clk_16c
);
// Input buffering
//------------------------------------
IBUFG clkin1_buf
 (.O (clk_main),
  .I (clk_mojo));


wire rst = ~rst_n; // make reset active high

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

reg [7:0] led_r;

assign led = led_r;

/*
 * Generates the clocks used for glitching
 */
clk_core clk(
	.clk(clk_main),
	.clk_16a(clk_16a),
	.clk_16b(clk_16b),
	.clk_16c(clk_16c),
	.rst(rst)
);

/*
 * When click the button we toggle the active clock
 */
btn_toggle clk_selection(
	.clk(clk_16a),
	.btn(btn_select_clk),
	.out(enable_clk)
);
/*
 * Here we have the single step clock
 */
btn_clk clk_manual_module(
	.clk(clk_16a),
	.btn(btn_manual_clk),
	.pulse(clk_manual)
);

BUFGMUX clk_mux(
	.I0(clk_16a),
	.I1(clk_manual),
	.S(enable_clk),
	.O(clk_target_internal)
);
ODDR2 #(
      .DDR_ALIGNMENT("NONE"),
      .INIT(1'b0),
      .SRTYPE("SYNC")
   ) ODDR2_a (
      .Q   (clk_target), // 1-bit DDR output data
      .C0  (clk_target_internal),     // 1-bit clock input
      .C1  (~clk_target_internal),    // 1-bit clock input
      .CE  (1'b1),         // 1-bit clock enable input
      .D0  (1'b1),
      .D1  (1'b0),
      .R   (1'b0),   // 1-bit reset input
      .S   (1'b0)    // 1-bit set input
   );
endmodule
