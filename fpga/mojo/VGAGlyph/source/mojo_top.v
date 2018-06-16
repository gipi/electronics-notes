module mojo_top(
    // 50MHz clock input
    input wire clk,
    // Input from reset button (active low)
    input wire rst_n,
    // cclk input from AVR, high when AVR is ready
    input wire cclk,
    // Outputs to the 8 onboard LEDs
    output wire [7:0]led,
    // AVR SPI connections
    output wire spi_miso,
    input wire spi_ss,
    input wire spi_mosi,
    input wire spi_sck,
    // AVR ADC channel select
    output wire [3:0] spi_channel,
    // Serial connections
    input  wire avr_tx, // AVR Tx => FPGA Rx
    output wire avr_rx, // AVR Rx => FPGA Tx
    input  wire avr_rx_busy, // AVR Rx buffer full

    // VGA connections
    output wire[2:0] pixel,
    output wire hsync_out,
    output wire vsync_out
    );

wire clk_25;
wire clkin1;
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
