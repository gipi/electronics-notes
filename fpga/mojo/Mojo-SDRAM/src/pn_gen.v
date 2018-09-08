module pn_gen (
    input clk,
    input rst,
    input next,
    input [31:0] seed,
    output [31:0] num
  );

  localparam INIT = 32'b01101011110010110111011010011100;

  reg [31:0] pn_d, pn_q = INIT;

  assign num = pn_q;

  always @(*) begin
    if (next)
      pn_d = {pn_q[30:0], pn_q[30] ^ pn_q[24] ^ pn_q[10] ^ pn_q[6]};
    else
      pn_d = pn_q;
  end

  always @(posedge clk) begin
    if (rst)
      pn_q <= INIT ^ seed;
    else
      pn_q <= pn_d;
  end

endmodule