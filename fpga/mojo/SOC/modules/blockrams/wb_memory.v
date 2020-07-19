/*
 * Simple (hopefully) Wishbone compatible RAM controller with variable size I/O
 * (8bit, 16bit or 32bit) controlled with a dedicated signal.
 *
 * TODO: add reset, wb_cyc
 */
`timescale 1ns/1ps
module wb_memory #(parameter ROMFILE="", SIZE=64) (
    input wire clk,
    input wire i_enable,
    input wire i_wb_stb,
    output wire o_wb_stall,
    output reg  o_wb_ack,
    input wire i_we,
    input wire [1:0] i_width,
    input wire [$clog2(SIZE) - 1:0] i_addr, /* the width varies with the size of the ROM */
    input wire [31:0] i_data,
    output reg [31:0] o_data
);

reg [7:0] ram[SIZE - 1:0];

initial begin
    /* verilator lint_off WIDTH */
    if (ROMFILE != "")
        $readmemh(ROMFILE, ram);
end

always @ (posedge clk)
begin
    if (i_enable) begin
    if (i_wb_stb && !o_wb_stall) begin
        o_data <= 32'b0;
        if(i_we) begin
            ram[i_addr] <= i_data[7:0];
            if (i_width[0] | i_width[1]) begin
                ram[i_addr + 1] <= i_data[15:8];
            end
            if (i_width[1]) begin
                ram[i_addr + 2] <= i_data[23:16];
                ram[i_addr + 3] <= i_data[31:24];
            end
        end else begin
            o_data[7:0] <= ram[i_addr];
            if (i_width[0] | i_width[1]) begin
                o_data[15:8] <= ram[i_addr + 1];
            end
            if (i_width[1]) begin
                o_data[23:16] <= ram[i_addr + 2];
                o_data[31:24] <= ram[i_addr + 3];
            end
        end
    end
    o_wb_ack <= i_wb_stb && !o_wb_stall;
    end // if (i_enable)
end

assign o_wb_stall = 1'b0;

endmodule
