module dsm_stereo_tb ();
	localparam CLOCK_PERIOD_NS = 20;
	localparam DSM_WIDTH = 12;

	reg clk = 0, aclr = 0;
	reg [DSM_WIDTH-1:0] left = 0, right = 0;
	wire left_out, right_out;

	always #(CLOCK_PERIOD_NS/2) clk <= !clk;

	dsm_stereo #(DSM_WIDTH) MUT
		(
			.aclr(aclr),
			.clk(clk),
			.left_pcm(left),
			.right_pcm(right),
			.left_out(left_out),
			.right_out(right_out)
		);

	initial
		begin
			#CLOCK_PERIOD_NS
			aclr <= 1;
			#CLOCK_PERIOD_NS
			aclr <= 0;
			#CLOCK_PERIOD_NS
			left = 12'd127;
			#(CLOCK_PERIOD_NS * 4096)
			left = 12'd0;
			right = 12'd1024;
			#(CLOCK_PERIOD_NS * 4096)
			left = 12'd2048;
			right = 12'd3750;
			#(CLOCK_PERIOD_NS * 4096)
			left = 12'd0;
			right = 12'd0;
			#(CLOCK_PERIOD_NS * 4096)
			$finish;
		end
	
endmodule
