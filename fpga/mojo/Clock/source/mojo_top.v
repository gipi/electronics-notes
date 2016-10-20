module mojo_top(
    // 50MHz clock input
    input clk,
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

    /* output clock */
    output wire clk_out,
    output wire clk_out2
    );

wire rst = ~rst_n; // make reset active high

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

assign led = 8'b0;

wire clk_300_out;
wire clk_300_out2;


clk_300 clk_quick(
  .CLK_IN1(clk),
  .CLK_OUT1(clk_300_out),
  .CLK_OUT2(clk_300_out2)
);

ODDR2  out_inst (
  .Q(clk_out2), // 1-bit DDR output
  .C0(clk_300_out2), // 1-bit clock input
  .C1(~clk_300_out2), // 1-bit clock input
  .CE(1), // 1-bit clock enable input
  .D1(0), // 1-bit data input (positive edge)
  .D0(1), // 1-bit data input (negative edge)
  .R(0), // 1-bit reset
  .S(0) // 1-bit set
);

ODDR2  out2_inst (
  .Q(clk_out), // 1-bit DDR output
  .C0(clk_300_out), // 1-bit clock input
  .C1(~clk_300_out), // 1-bit clock input
  .CE(1), // 1-bit clock enable input
  .D1(0), // 1-bit data input (positive edge)
  .D0(1), // 1-bit data input (negative edge)
  .R(0), // 1-bit reset
  .S(0) // 1-bit set
);

endmodule