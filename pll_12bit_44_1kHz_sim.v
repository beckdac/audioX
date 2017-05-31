module pll_12bit_44_1kHz_sim
	(
		input areset,
		input inclk0,
		output c0 = 0,
		output locked = 1
	);
	localparam CLOCK_PERIOD_NS = 0.84700282966705;

	always #(CLOCK_PERIOD_NS/2) c0 <= !c0;

	always locked = 1;
endmodule
