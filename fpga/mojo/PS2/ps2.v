`timescale 1ns / 1ps
// TODO:
//		add watchdog for restarting if ps2 clk is high for too long
//		parity check
module ps2_rx(
	input wire clk,
	input wire reset,
   input wire ps2d, ps2c, rx_en,
   output reg rx_done_tick,
   output wire [7:0] dout
);
	// symbolic state
	localparam [1:0]
		idle = 2'b00,
		dps  = 2'b01,
		load = 2'b10;

	// signal declaration
	reg  [1:0] state_reg, state_next ;
	reg  fall_edge_ps2c_reg;
	wire fall_edge_ps2c_next;
	reg  [3:0] n_reg, n_next ;
	reg [10:0] b_reg, b_next ;
	wire fall_edge;

	always @(posedge clk, posedge reset)
		if (reset)
			begin
				fall_edge_ps2c_reg <= 0;
			end
		else
			begin
				fall_edge_ps2c_reg <= fall_edge_ps2c_next;
			end

	assign fall_edge_ps2c_next = ps2c;
	assign fall_edge = fall_edge_ps2c_reg & ~fall_edge_ps2c_next;

	// FSMD state & data register
	always @ (posedge clk, posedge reset)
		if (reset)
			begin
				state_reg <= idle;
				n_reg <= 0;
				b_reg <= 0 ;
			end
		else
			begin
				state_reg <= state_next;
				n_reg <= n_next;
				b_reg <= b_next ;
			end

	// FSMD next state logic
	always @ *
	begin
		state_next = state_reg;
		rx_done_tick = 1'b0;
		n_next = n_reg;
		b_next = b_reg;
		
		case (state_reg)
			idle:
				if (fall_edge & rx_en)
					begin
						b_next     = {ps2d, b_reg[10:1]};
						n_next     = 4'b1001;
						state_next = dps;
					end
			dps:
				if (fall_edge)
					begin
						b_next = {ps2d, b_reg[10:1]};
						if (n_reg == 0)
							state_next = load;
						else
							n_next = n_reg - 1;
					end
			load:
				begin
					state_next = idle;
					rx_done_tick = 1'b1;
				end
		endcase
		end

		// output
		assign dout = b_reg[8:1];
	endmodule
