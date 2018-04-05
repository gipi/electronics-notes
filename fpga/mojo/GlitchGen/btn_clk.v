/*
 * Generates a pulse when click a button
 */
module btn_clk #(parameter WIDTH={2{1'b1}})(
	input clk,
	input btn,
	output pulse
);

reg enable_counter;
reg btn_debounced_delayed;
reg reg_pulse;
reg[1:0] counter;

initial begin
	enable_counter <= 0;
	reg_pulse <= 0;
end

button_conditioner btn_pulse(
	.clk(clk),
	.btn(btn),
	.out(btn_debounced)
);

/*
 * When the pulse is enabled use a counter to set HIGH the signal
 */
always @(posedge clk) begin
	if (btn_debounced && ~btn_debounced_delayed) begin
		enable_counter <= 1'b1;
	end
	if (enable_counter == 1'b1) begin
		counter <= counter + 1;
		reg_pulse <= 1'b1;
	end
	
	if (counter == WIDTH) begin
		reg_pulse <= 1'b0;
		enable_counter <= 1'b0;
	end
	btn_debounced_delayed <= btn_debounced;
end

assign pulse = reg_pulse;

endmodule
