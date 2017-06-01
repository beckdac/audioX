`timescale 1ps/1ps

module pll_12bit_44_1kHz_sim
	(
		input areset,
		input inclk0,
		output c0,
		output reg locked = 1
	);

	//always @(posedge inclk0 or negedge inclk0)
	//	c0 <= !c0;
	assign c0 = !inclk0;

/*
	always c0 <= inclk0;
	//localparam CLOCK_PERIOD_NS = 0.84700282966705;
	localparam CLOCK_PERIOD_NS = 1;

	always #(CLOCK_PERIOD_NS/2) c0 <= !c0;

	initial
		begin
			c0 = 0;
			locked = 1;
			#(1000000);
			$finish;
		end
*/

endmodule
