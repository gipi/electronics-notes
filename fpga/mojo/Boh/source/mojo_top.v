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
    output pcEn,
    input button
);


wire rst = ~rst_n; // make reset active high

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

//wire btn_out;
reg [7:0] led_r;

reg btn_r;
reg btn_prev_r;
reg btn_out_delayed;

assign led = led_r;

wire clk_;


clk_wiz_v3_6 clk_quick(
  .CLK_IN1(clk),
  .CLK_OUT1(clk_),
  .RESET(rst)
);

button_conditioner btn(
  .clk(clk_),
  .btn(button),
  .out(btn_out)
);



// http://electronics.stackexchange.com/a/266127/66517
always @(posedge rst or posedge clk_) begin
  if (rst)
    led_r <= 0;
  else begin
  /*
   * if we don't put the rest of the code under else we will have an error
   * like "Assignment under multiple single edges is not supported for synthesis"
   * since we are trying to drive led_r contemporary from the rst "if" block than
   * from the last line of this "else".
   */
    if (btn_out & ~btn_out_delayed)
      led_r <= led_r + 1;

    btn_out_delayed <= btn_out;
  end
end

// https://electronics.stackexchange.com/questions/102646/how-to-efficiently-implement-a-single-output-pulse-from-a-long-input-on-altera
  
  reg r1, r2, r3;
  //wire pcEn;

  always @(posedge signal) begin
    r1 <= btn_out;    // first stage of 2-stage synchronizer
    r2 <= r1;       // second stage of 2-stage synchronizer
    r3 <= r2;       // edge detector memory
  end

  assign pcEn = r2 && !r3;   // pulse on rising edge
wire sig2;

/*pwm pwm_1(
  .clk(clk),
  .rst(rst),
  .out(signal)
);*/

pwm #(.OFFSET(5),.COUNTER(10 -1)) pwm_2(
  .clk(clk_),
  .rst(rst),
  .out(sig2)
);

assign signal2 = sig2;

wire dummy;

// 1 MHz base frequency with 
pwm_glitch #(.TICK_MASTER(150), .TICK_GLITCH(10)) gl(
  .clk(clk_),
  .rst(rst),
  .glitch(pcEn),
  .out(signal)
);




endmodule