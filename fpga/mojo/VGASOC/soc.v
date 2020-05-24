`default_nettype none
`timescale 1ns/1ps

module soc(
    input wire clk,
    input wire reset
);

wire [31:0] cpu_to_rom_signal_data;
wire [31:0] rom_to_cpu_signal_data;
wire [6:0] signal_address;
/* verilator lint_off UNUSED */
wire [22:0] _void;
wire wb_stb, wb_stall, wb_ack;

cpu core(
    .clk(clk),
    .reset(reset),
    .i_data(rom_to_cpu_signal_data),
    .o_data(cpu_to_rom_signal_data),
    .o_addr({_void, signal_address, 1'b0, 1'b0}),
    .o_wb_stb(wb_stb),
    .i_wb_stall(wb_stall),
    .i_wb_ack(wb_ack)
);

bootrom br(
    .clk(clk),
    .i_data(cpu_to_rom_signal_data),
    .o_data(rom_to_cpu_signal_data),
    .i_addr(signal_address),
    .i_wb_stb(wb_stb),
    .o_wb_stall(wb_stall),
    .o_wb_ack(wb_ack),
    .i_we(0)
);

endmodule
