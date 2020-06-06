/*
 * This block RAM will contain the text to be used by the VGA controller.
 *
 * It's is a 80x30 characters grid.
 */
module text_ram(
    input wire clk,
    input wire i_wb_stb,
    output wire o_wb_stall,
    output reg  o_wb_ack,
    input wire i_we,
    input wire [11:0] i_addr,
    input wire [7:0] i_data,
    output reg [7:0] o_data
);

reg [7:0] ram[4095:0];

initial begin
    $readmemh("../source/text.mem", ram);
end

always @ (posedge clk)
begin
    if(i_we && i_wb_stb && !o_wb_stall)
        ram[i_addr] <= i_data;
    else
        o_data <= ram[i_addr];
    o_wb_ack <= i_wb_stb && !o_wb_stall;
end

assign o_wb_stall = 1'b0;

endmodule
