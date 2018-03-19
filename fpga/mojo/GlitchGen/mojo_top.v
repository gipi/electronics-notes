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
    output clk_16a,
    output clk_16b,
    output clk_16c
);


wire rst = ~rst_n; // make reset active high

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

//wire btn_out;
reg [7:0] led_r;

assign led = led_r;

clk_core clk(
	.clk(clk_mojo),
	.clk_16a(clk_16a),
	.clk_16b(clk_16b),
	.clk_16c(clk_16c)
);

endmodule
