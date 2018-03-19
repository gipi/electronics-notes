module btn_toggle(
	input clk,
	input btn,
	output out
);

reg signal;
reg btn_debounced_delayed;

button_conditioner clk_btn(
	.clk(clk),
	.btn(btn),
	.out(btn_debounced)
);

always @(posedge clk) begin
	if (btn_debounced && ~btn_debounced_delayed) begin
		signal <= ~signal;
	end
	btn_debounced_delayed <= btn_debounced;
end

assign out = signal;

endmodule
