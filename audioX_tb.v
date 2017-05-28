`timescale 1ps/1ps

module audioX_tb();
	localparam CLOCK_PERIOD_NS = 20;

	reg clk = 0, aclr = 0;
	wire pll_locked, fifo_full, right, left;


	always #(CLOCK_PERIOD_NS/2) clk <= !clk;

	audioX MUT
   		(
			.sys_clock(clk),
			.reset_(aclr),
			.pll_locked(pll_locked),
			.audio_fifo_full(fifo_full),
			.audio_right(right),
			.audio_left(left)
		);

	initial
		begin
			#CLOCK_PERIOD_NS
			aclr <= 1;
			#CLOCK_PERIOD_NS
			aclr <= 0;
			#CLOCK_PERIOD_NS
			#(CLOCK_PERIOD_NS * 255 * 100)
			$finish;
		end

endmodule
