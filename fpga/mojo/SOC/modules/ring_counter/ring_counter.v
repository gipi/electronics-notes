`default_nettype none

module ring_counter#(parameter STATE_WIDTH=3)(
    input clk,
    input rst,
    output [STATE_WIDTH - 1:0] states
);

/*
 * Be sure that the module starts in a consistent state
 */
initial begin;
    states = 3'b1;
end

always @(posedge clk) begin
    if (~rst)
        states <= 3'b1;
    else begin
        // I don't understand why this works, really!
        states <= states << 1;
        states[0] <= states[STATE_WIDTH - 1];
    end
end

endmodule
