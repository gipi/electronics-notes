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

    // PS/2 connections
    input wire ps2c,
	 input wire ps2d,
	 output wire ps2_vcc,
	 output wire ps2_gnd
    );

wire rst = ~rst_n; // make reset active high

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

assign ps2_vcc = 1'b1;
assign ps2_gnd = 1'b0;

reg[7:0] led_r;
reg previous_ps2_done;
wire[7:0] code;

button_conditioner #(.COUNT(9'b1)) debounce_data (
	.clk(clk),
	.btn(ps2d),
	.out(ps2d_debounce)
);

button_conditioner #(.COUNT(9'b1)) debounce_clock (
	.clk(clk),
	.btn(ps2c),
	.out(ps2c_debounce)
);

ps2_rx ps2(
	.clk(clk),
	.ps2d(ps2d_debounce),
	.ps2c(ps2c_debounce),
	.rx_en(1'b1),
	.dout(code),
	.rx_done_tick(ps2_done),
	.reset(rst)
);

always @ (posedge clk) begin
	if (ps2_done && ~previous_ps2_done) begin
		led_r <= code;
	end
	previous_ps2_done <= ps2_done;
end

assign led = led_r;

endmodule
