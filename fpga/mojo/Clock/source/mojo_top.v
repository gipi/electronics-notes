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
    output wire boh
    );

wire rst = ~rst_n; // make reset active high

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

assign led = 8'b0;

/*clk_wiz_v3_6 clk_quick(
  .CLK_IN1(clk),
  .CLK_OUT1(clk_out),
  .RESET(rst)
);*/

/*BUFG clk_bufg_inst(
  .I(clk),
  .O(boh)
);*/
ODDR2  boh_inst (
  .Q(boh), // 1-bit DDR output
  .C0(clk), // 1-bit clock input
  .C1(~clk), // 1-bit clock input
  .CE(1), // 1-bit clock enable input
  .D1(0), // 1-bit data input (positive edge)
  .D0(1), // 1-bit data input (negative edge)
  .R(0), // 1-bit reset
  .S(0) // 1-bit set
);
//assign clk_out = 1'b1;

endmodule