module mojo_top_tb ();
    reg clk, rst;

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        repeat(4) #5 clk = ~clk;
        rst = 1'b0;
        forever #5 clk = ~clk; // generate a clock
    end

    mojo_top DUT(
        .clk(clk),
        .rst_n(~rst),
        .cclk(1'b1),
        .led(),
        .spi_miso(),
        .spi_ss(1'b1),
        .spi_mosi(1'b0),
        .spi_sck(1'b0),
        .spi_channel(),
        .avr_tx(1'b1),
        .avr_rx(),
        .avr_rx_busy(1'b0),
        .sdram_clk(),
        .sdram_cle(),
        .sdram_dqm(),
        .sdram_cs(),
        .sdram_we(),
        .sdram_cas(),
        .sdram_ras(),
        .sdram_ba(),
        .sdram_a(),
        .sdram_dq()
    );

endmodule