module mojo_top(
        input clk,
        input rst_n,
        input cclk,
        output[7:0]led,
        output spi_miso,
        input spi_ss,
        input spi_mosi,
        input spi_sck,
        output [3:0] spi_channel,
        input avr_tx,
        output avr_rx,
        input avr_rx_busy,
        output sdram_clk,
        output sdram_cle,
        output sdram_dqm,
        output sdram_cs,
        output sdram_we,
        output sdram_cas,
        output sdram_ras,
        output [1:0] sdram_ba,
        output [12:0] sdram_a,
        inout [7:0] sdram_dq
    );

wire fclk;
wire rst = ~rst_n;

assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

wire [22:0] addr;
wire rw;
wire [31:0] data_in, data_out;
wire busy;
wire in_valid, out_valid;


sdram_clk_gen clkram_clk_gen (
        .clk_in(clk),
        .clk_out(fclk)
    );
//assign fclk = clk;

sdram sdram (
        .clk(fclk),
        .rst(rst),
        .sdram_clk(sdram_clk),
        .sdram_cle(sdram_cle),
        .sdram_cs(sdram_cs),
        .sdram_cas(sdram_cas),
        .sdram_ras(sdram_ras),
        .sdram_we(sdram_we),
        .sdram_dqm(sdram_dqm),
        .sdram_ba(sdram_ba),
        .sdram_a(sdram_a),
        .sdram_dq(sdram_dq),
        .addr(addr),
        .rw(rw),
        .data_in(data_in),
        .data_out(data_out),
        .busy(busy),
        .in_valid(in_valid),
        .out_valid(out_valid)
    );

ram_test ram_test (
        .clk(fclk),
        .rst(rst),
        .addr(addr),
        .rw(rw),
        .data_in(data_in),
        .data_out(data_out),
        .busy(busy),
        .in_valid(in_valid),
        .out_valid(out_valid),
        .leds(led)
    );

endmodule