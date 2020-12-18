/*
 * Controller wishbone for UART.
 *
 * This has two parts: transmitter and receiver.
 *
 * We are going to use three addresses to access TX, RX and CTL, each one with
 * 1byte width.
 *
 * This implements the "3.2.4 Classic pipelined SINGLE WRITE Cycle"
 *
 */
`timescale 1ns/1ps
`default_nettype none

module wb_uart(
    input wire clk,
    input wire reset,
    input i_wb_cyc,
    input i_wb_stb,
    input i_wb_we,
    input [1:0] i_wb_addr,
    input [7:0] i_wb_data,
    output wire o_wb_ack,
    output wire o_wb_stl,
    output reg [7:0] o_wb_data,
    output wire o_uart_tx
);

localparam [1:0] TX_REG = 0,
                 RX_REG = 1,
                 CTL_REG = 2;

baudgenerator clocks(
    .clk(clk),
    .reset(reset),
    .o_tx_clk(tx_clk),
    .o_rx_clk(rx_clk)
);

reg tx_start;
reg tx_done;
wire tx_clk;
/* verilator lint_off UNUSED */
wire rx_clk;

reg [7:0] _o_wb_data; /* this only to have a latch on o_wb_data */
reg internal_wb_ack;

/* ACKNOWNLEDGE */
always @(posedge clk) begin
    if (i_wb_cyc && i_wb_stb) begin
        internal_wb_ack <= 1'b1;
        o_wb_data <= _o_wb_data;
    end
end

/* WRITING / READING */
always @* begin
    if (i_wb_cyc && i_wb_stb && !o_wb_stl) begin
        case (i_wb_addr)
            TX_REG: begin
                if (i_wb_we)
                    tx_start = i_wb_stb; /* FIXME: i_wb_stb is always logic true here :P */
                else begin
                    tx_start = 1'b0;
                    _o_wb_data = 8'b0;
                end
            end
            RX_REG: begin
            end
            CTL_REG: begin
                tx_start = 1'b0;
                if (i_wb_we)
                    _o_wb_data = 8'b0;
                else
                    _o_wb_data = {7'b0, tx_done};
            end
            default: begin end
        endcase
    end /* if () */
    else begin
        tx_start = 1'b0;
        _o_wb_data = 8'b0;
    end
end

always @ (posedge clk)
    if (internal_wb_ack)
        internal_wb_ack <= 1'b0;

uart_tx tx(
    .clk(tx_clk),
    .reset(reset),
    .i_start(tx_start),
    .i_data(i_wb_data),
    .o_done(tx_done),
    .o_tx(o_uart_tx)
);

assign o_wb_ack = (internal_wb_ack) ? internal_wb_ack : 1'bz;
assign o_wb_stl = 1'b0;

endmodule
