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

    // VGA connections
    output wire[2:0] pixel,
    output hsync_out,
    output vsync_out
    );


wire rst = ~rst_n; // make reset active high


// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

assign led = 8'b10101010;
// Input buffering
//------------------------------------
IBUFG clkin1_buf
 (.O (clkin1),
  .I (clk));

clk_25MHz clk_video(
  .CLK_IN1(clkin1),
  .CLK_OUT1(clk_25),
  .RESET(rst)
);

VGA vga(
	.clk(clk_25),
	.rst(rst),
	.pixel(pixel),
	.hsync_out(hsync_out),
	.vsync_out(vsync_out)
);

endmodule
