module pwm_audio_stereo_out
	(	input clk,
		input aclr,			// on falling edge
		input [7:0] left_top, // duty cycle for left channel
		input [7:0] right_top, // duty cycle for right
		output reg left = 0,
		output reg right = 0
	);

	reg [7:0] count = 0;

	
	always @(posedge clk or negedge aclr)
		begin
			if (~aclr)
				begin
					$display("%m\nreceived reset");
					$display($time, "is current time");
					count <= 0;
					left <= 0;
					right <= 0;
				end
			else
				begin
					// 8 bit PWM core
					if (count == 255)
						begin
							count <= 0;
							left <= 1;
							right <= 1;
						end
					count <= count + 8'b1;
					if (count == left_top)
						begin
							left <= 0;
						end
					if (count == right_top)
						begin
							right <= 0;
						end
				end
		end

endmodule
