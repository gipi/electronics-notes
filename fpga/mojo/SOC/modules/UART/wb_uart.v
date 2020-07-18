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
    output reg o_wb_ack,
    output wire o_wb_stall,
    output reg [7:0] o_wb_data,
    output wire o_uart_tx
);

localparam [1:0] TX_REG = 0,
                 RX_REG = 1,
                 CTL_REG = 2;

// FIXME: add baudrate generation module, for now we use the clock as comes from
// the cpu

reg tx_start;
reg tx_done;

reg [7:0] _o_wb_data; /* this only to have a latch on o_wb_data */

/* ACKNOWNLEDGE */
always @(posedge clk) begin
    if (i_wb_cyc) begin
        o_wb_ack <= i_wb_stb && !o_wb_stall;
        o_wb_data <= _o_wb_data;
    end
end

/* WRITING / READING */
always @* begin
    if (i_wb_cyc && i_wb_stb && !o_wb_stall) begin
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

uart_tx tx(
    .clk(clk),
    .reset(reset),
    .i_start(tx_start),
    .i_data(i_wb_data),
    .o_done(tx_done),
    .o_tx(o_uart_tx)
);

assign o_wb_stall = 1'b0;

endmodule
