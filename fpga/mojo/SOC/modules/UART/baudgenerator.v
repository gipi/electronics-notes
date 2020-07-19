`timescale 1ns/1ps
`default_nettype none

module baudgenerator(
    input wire clk,
    /* verilator lint_off UNUSED */
    input wire reset,
    output wire o_tx_clk,
    output wire o_rx_clk
);

`ifdef verilator
assign o_tx_clk = clk;
assign o_rx_clk = clk;
`else
`endif


endmodule
