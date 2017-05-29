module pwm_audio_stereo_out_tb();
	localparam CLOCK_PERIOD_NS = 20;

	reg clk = 0, aclr = 0;
	reg [7:0] left = 0, right = 0;
	wire left_out, right_out;

	always #(CLOCK_PERIOD_NS/2) clk <= !clk;

	pwm_audio_stereo_out MUT
		(
			.aclr(aclr),
			.clk(clk),
			.left_top(left),
			.right_top(right),
			.left(left_out),
			.right(right_out)
		);

	initial
		begin
			#CLOCK_PERIOD_NS
			aclr <= 1;
			#CLOCK_PERIOD_NS
			aclr <= 0;
			#CLOCK_PERIOD_NS
			left = 8'd127;
			#(CLOCK_PERIOD_NS * 255)
			left = 8'd0;
			right = 8'd127;
			#(CLOCK_PERIOD_NS * 255)
			left = 8'd127;
			right = 8'd127;
			#(CLOCK_PERIOD_NS * 255)
			left = 8'd0;
			right = 8'd0;
			#(CLOCK_PERIOD_NS * 255)
			$finish;
		end
	
endmodule
