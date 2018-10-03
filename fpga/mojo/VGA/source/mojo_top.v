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
    output reg [2:0] pixelR,
    output reg [2:0] pixelG,
    output reg [2:0] pixelB,
    output hsync_out,
    output vsync_out
    );

wire clk_25;
wire rst = ~rst_n; // make reset active high
wire inDisplayArea;
wire [9:0] CounterX;
wire [8:0] CounterY;
wire [3:0] selector;

clk_25MHz clk_video(
  .CLK_IN1(clk),
  .CLK_OUT1(clk_25),
  .RESET(rst)
);

hvsync_generator hvsync(
  .clk(clk_25),
  .vga_h_sync(hsync_out),
  .vga_v_sync(vsync_out),
  .CounterX(CounterX),
  .CounterY(CounterY),
  .inDisplayArea(inDisplayArea)
);


// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

assign led = 8'b10101010;

// use this bits from CounterX to divide the
// horizontal screen in strips 64 bytes wide
assign selector = CounterX[9:6];

always @(posedge clk_25)
begin
  if (inDisplayArea) begin
      /*
       * I don't know if there is a smarter way to assign
       * only one color for strip.
       *
       * Maybe using the selector signal as index?
       */
      pixelR[2] <= selector == 4'b0000;
      pixelR[1] <= selector == 4'b0001;
      pixelR[0] <= selector == 4'b0010;
      pixelG[2] <= selector == 4'b0011;
      pixelG[1] <= selector == 4'b0100;
      pixelG[0] <= selector == 4'b0101;
      pixelB[2] <= selector == 4'b0110;
      pixelB[1] <= selector == 4'b0111;
      pixelB[0] <= selector == 4'b1000;
  end
  else begin// if it's not to display, go dark
      pixelR <= 3'b000;
      pixelG <= 3'b000;
      pixelB <= 3'b000;
  end
end

endmodule
