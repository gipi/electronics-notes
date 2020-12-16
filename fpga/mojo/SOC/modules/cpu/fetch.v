/*
 * Memory controller module.
 *
 * This implements a master wishbone controller to interact with the memory; it's
 * used to read/write data in the memory with different sizes.
 *
 * This controller has three states:
 *
 *  IDLE: default state with o_wb_cyc and o_wb_stb negated. When i_enable is
 *        asserted transitions to STARTED.
 *  STARTED: o_wb_cyc and o_wb_stb are asserted, if the o_wb_stl signal is not
 *        asserted then moves to WAITING.
 *  WAITING: o_wb_stb deasserted, waiting for o_wb_ack to be asserted. If this
 *  happens cycle back to IDLE asserting o_completed for a clock cycle.
 *
 * FIXME: the o_wb_we signal should be a simple wire but the simulator seems to
 * behaves strangely using it.
 * TODO: substitute i_enable, i_wb_data, i_data_width, i_pc, i_value, i_we with
 * a "command" signal that encapulates all of these
 * TODO: suppose we i_enable this module while is waiting for a previous cycle to
 * finish (o_wb_cyc asserted), what the caller should do, we should espose a new
 * signal, like o_wait?
 */
`timescale 1ns/1ps
`default_nettype none

module fetch(
    input wire clk,
    input wire reset,
    input wire i_enable, /* from cpu TODO: maybe use cyc directly instead */
    input wire [31:0] i_pc, /* from cpu */
    output reg [31:0] o_instruction, /* to cpu */
    input wire [31:0] i_value,
    output reg o_completed, /* to cpu */
    output reg o_wb_cyc,
    output reg o_wb_stb,
    output reg o_wb_we,
    input wire [31:0] i_wb_data, /* from here is coming the data from the memory */
    output reg [31:0] o_wb_data, /* from here is going the data to memory */
    input wire i_wb_ack,
    input wire i_wb_stl,
    input wire i_we,
    output reg [31:0] o_wb_addr, /* this is the requested address */
    input wire [1:0] i_data_width, /* this indicates if access happens in byte/short/word */
    output wire [1:0] o_data_width /* this indicates if access happens in byte/short/word */
);

initial begin
    o_wb_cyc = 1'b0;
    o_wb_stb = 1'b0;
    state = IDLE;
end

parameter IDLE  = 2'b00; /* 0 */
parameter STARTED = 2'b01; /* 1 */
parameter WAITING = 2'b10;


/* This register holds the internal state of the controller*/
reg [1:0] state;

/* FSM */
always @(posedge clk)
    /* when a reset arrives negated all the signals and set the state to IDLE */
    if (~reset) begin
        o_wb_cyc <= 1'b0;
        o_wb_stb <= 1'b0;
        o_completed <= 1'b0;
        state <= IDLE;
    end else begin
        /* verilator lint_off CASEINCOMPLETE */
        case (state)
            IDLE: begin
                if (o_completed)
                    o_completed <= 1'b0;
                if (i_enable) begin
                    o_wb_cyc <= 1'b1;
                    o_wb_stb <= 1'b1;
                    o_wb_addr <= i_pc;
                    if (i_we) begin
                        o_wb_we <= i_we;
                        o_wb_data <= i_value;
                    end
                    state <= STARTED;
                end
            end
            STARTED: /* remains in this state if STL is asserted */
                if (!i_wb_stl) begin
                    o_wb_stb <= 1'b0;
                    state <= WAITING;
                end
            WAITING: /* remains in this state up to an ACK */
                if (i_wb_ack) begin
                    o_wb_cyc <= 1'b0;
                    o_instruction <= i_wb_data;
                    o_completed <= 1'b1;
                    state <= IDLE;
                end
        endcase
    end

assign o_data_width = i_data_width;

endmodule
