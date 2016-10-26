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
    output signal,
    output signal2,
    input button
);


wire rst = ~rst_n; // make reset active high

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

wire btn_out;
reg [7:0] led_r;

reg btn_r;
reg btn_prev_r;

assign led = led_r;

button_conditioner btn(
  .clk(clk),
  .btn(button),
  .out(btn_out)
);


always @(posedge rst or posedge btn_out) begin
  if (rst)
    led_r <= 0;
  else if (!btn_out) // Y U NEED !?
    led_r <= led_r + 1;  
end

wire sig2;

pwm pwm_1(
  .clk(clk),
  .rst(rst),
  .out(signal)
);

pwm #(.OFFSET(5),.COUNTER(10 -1)) pwm_2(
  .clk(clk),
  .rst(rst),
  .out(sig2)
);

assign signal2 = sig2 & signal;

endmodule