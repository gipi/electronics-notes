/*
 * This block RAM will contain the text to be used by the VGA controller.
 *
 * It's is a 80x30 characters grid.
 */
module text_ram(
    input wire clk,
    input wire we,
    input wire [11:0] addr,
    input wire [7:0] i_data,
    output reg [7:0] o_data
);

reg [7:0] ram[4095:0];

initial begin
    $readmemh("../source/text.mem", ram);
end

always @ (posedge clk)
begin
    if(we)
        ram[addr] <= i_data;
    else
        o_data <= ram[addr];
end

endmodule
