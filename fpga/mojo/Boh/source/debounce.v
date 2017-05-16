/*
 * Uses two flip-flops to stabilize the output from a button.
 *
 * Original code from <https://embeddedmicro.com/tutorials/mojo/metastability-and-debouncing>
 */
 module button_conditioner #(parameter COUNT={20{1'b1}})(
    input clk,
    input btn,
    output out
  );
 
  reg [19:0] ctr_d, ctr_q;
  reg [1:0] sync_d, sync_q;
 
  assign out = ctr_q == COUNT;
 
  always @(*) begin
    sync_d[0] = btn;
    sync_d[1] = sync_q[0];
    ctr_d = ctr_q + 1'b1;
 
    if (ctr_q == COUNT) begin
      ctr_d = ctr_q;
    end
 
    if (!sync_q[1])
      ctr_d = 0;
  end
 
  always @(posedge clk) begin
    ctr_q <= ctr_d;
    sync_q <= sync_d;
  end
 
endmodule