module sdram_tb ();
    reg clk, rst;
    wire sdram_clk;
    wire sdram_cle;
    wire sdram_cs;
    wire sdram_cas;
    wire sdram_ras;
    wire sdram_we;
    wire sdram_dqm;
    wire [1:0] sdram_ba;
    wire [12:0] sdram_a;
    wire [7:0] sdram_dq;

    wire [24:0] addr;
    wire rw;
    wire [31:0] data_in, data_out;
    wire busy;
    wire in_valid, out_valid;

    wire [7:0] leds;


   sdram DUT (
        .clk(clk),
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
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .rw(rw),
        .data_in(data_in),
        .data_out(data_out),
        .busy(busy),
        .in_valid(in_valid),
        .out_valid(out_valid),
        .leds(leds)
    );

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        repeat(4) #5 clk = ~clk;
        rst = 1'b0;
        forever #5 clk = ~clk; // generate a clock
    end

    always @* begin

    end

    initial begin
        #300000
        $finish();
    end

endmodule