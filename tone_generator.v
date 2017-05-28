module tone_generator
	(
		input clk,
		input aclr,
		input fifo_full,
		output reg tone_pcm_rdy = 0,
		output reg [15:0] tone_pcm = 0
	);


	always @(posedge clk or posedge aclr)
		begin
			if (aclr)
				begin
					tone_pcm_rdy <= 0;
					tone_pcm <= 0;
				end
			else
				begin
					if (~fifo_full)
						begin
							tone_pcm_rdy <= 1;
							tone_pcm[7:0] <= 8'd127;
							tone_pcm[15:8] <= 8'd63;
						end
					else
						begin
							tone_pcm_rdy <= 0;
						end
				end
		end

endmodule
