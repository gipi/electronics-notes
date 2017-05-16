module pwm_glitch #(parameter TICK_MASTER=50000000, TICK_GLITCH=1000)(
    input clk,  // clock
    input rst,  // reset
    input glitch, // on rise edge glitch
    output reg out
  );

  integer counter = 0;

  /* Sequential Logic */
  always @(posedge clk) begin
    if (rst) begin
      counter <= 8'h0;
      out <= 1'b0;
    end else begin
      // switch
      if (counter == (TICK_MASTER - 1) || (glitch && counter == (TICK_GLITCH - 1))) begin
        out <= ~out;
        counter <= 8'h0;
      end else begin
        counter <= counter + 1;
      end
    end
  end
  
endmodule
