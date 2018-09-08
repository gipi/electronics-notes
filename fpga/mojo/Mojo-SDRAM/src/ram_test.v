module ram_test (
        input clk,
        input rst,
        output reg [22:0] addr,
        output reg rw,
        output reg [31:0] data_in,
        input [31:0] data_out,
        input busy,
        output reg in_valid,
        input out_valid,
        output [7:0] leds
    );


    localparam STATE_SIZE = 2;
    localparam WRITE = 0,
               READ = 1,
               IDLE = 2;

    reg [STATE_SIZE-1:0] state_d, state_q = WRITE;

    reg [4:0] led_d, led_q;

    reg [22:0] addr_d, addr_q;

    reg [6:0] error_d, error_q;
    reg [31:0] seed_d, seed_q;

    assign leds = {led_q[4], error_q};

    reg pn_rst, pn_next;
    wire [31:0] pn;

    pn_gen pn_gen (
        .clk(clk),
        .rst(pn_rst),
        .next(pn_next),
        .seed(seed_q),
        .num(pn)
      );

    always @* begin
        addr_d = addr_q;
        led_d = led_q;
        state_d = state_q;
        error_d = error_q;

        addr = 23'd0;
        rw = 1'b0;
        data_in = 32'h00;
        in_valid = 1'b0;

        pn_rst = 1'b0 | rst;
        pn_next = 1'b0;
        seed_d = seed_q;

        case (state_q)
            WRITE: begin
                led_d[4] = 1'b0;
                if (!busy) begin
                    pn_next = 1'b1;
                    addr_d = addr_q + 1'b1;
                    addr = addr_q;
                    rw = 1'b1;
                    data_in = pn;
                    in_valid = 1'b1;
                    if (addr_q == {23{1'b1}}) begin
                        addr_d = 8'b0;
                        state_d = READ;
                        pn_rst = 1'b1;
                    end
                end
            end
            READ: begin
                led_d[4] = 1'b1;
                if (!busy) begin
                    addr_d = addr_q + 1'b1;
                    addr = addr_q;
                    in_valid = 1'b1;
                    if (addr_q == {23{1'b1}}-25'd10)
                        seed_d = seed_q + 1'b1;
                    if (addr_q == {23{1'b1}}) begin
                        addr_d = 8'b0;
                        state_d = WRITE;
                        pn_rst = 1'b1;
                    end
                end

                if (out_valid) begin
                    pn_next = 1'b1;
                    led_d[0] = pn[7:0] != data_out[7:0];
                    led_d[1] = pn[15:8] != data_out[15:8];
                    led_d[2] = pn[23:16] != data_out[23:16];
                    led_d[3] = pn[31:24] != data_out[31:24];
                    if (data_out != pn && error_q < {7{1'b1}})
                        error_d = error_q + 1'b1;
                end
            end
            IDLE: begin
                led_d[4] = 1'b0;
            end
            default: state_d = WRITE;
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin
            state_q <= WRITE;
            addr_q <= 8'd0;
            error_q <= 1'b0;
            seed_q <= 32'd0;
            led_q <= 5'b0;
        end else begin
            state_q <= state_d;
            addr_q <= addr_d;
            error_q <= error_d;
            seed_q <= seed_d;
            led_q <= led_d;
        end
    end
endmodule