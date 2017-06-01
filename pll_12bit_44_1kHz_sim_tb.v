`timescale 1ps/1ps

module pll_12bit_44_1kHz_sim_tb();
	wire aclr, clk, c0, locked;

	pll_12bit_44_1kHz_sim MUT
		(
			.areset(aclr),
			.inclk0(clk),
			.c0(c0),
			.locked(locked)
		);
	
	assign #(10) clk = !clk;

endmodule
