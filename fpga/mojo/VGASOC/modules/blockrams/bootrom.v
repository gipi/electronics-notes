/*
 */
`timescale 1ns/1ps
module bootrom #(parameter ROMFILE="") (
    input wire clk,
    input wire i_enable,
    input wire i_wb_stb,
    output wire o_wb_stall,
    output reg  o_wb_ack,
    input wire i_we,
    input wire [6:0] i_addr, /* the width varies with the size of the ROM */
    input wire [31:0] i_data,
    output reg [31:0] o_data
);

reg [31:0] ram[64:0];

initial begin
    /* verilator lint_off WIDTH */
    if (ROMFILE != "")
        $readmemh(ROMFILE, ram);
end

always @ (posedge clk)
begin
    if (i_enable) begin
    if (i_wb_stb && !o_wb_stall) begin
        if(i_we)
            ram[i_addr] <= i_data;
        else
            o_data <= ram[i_addr];
    end
    else
        o_data <= 32'b0;
    o_wb_ack <= i_wb_stb && !o_wb_stall;
    end // if (i_enable)
end

assign o_wb_stall = 1'b0;

endmodule
