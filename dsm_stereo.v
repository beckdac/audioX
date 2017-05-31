// delta sigma modulator for stereo applications

module dsm_stereo
	#(parameter DSM_WIDTH)
	(
		input clk,
		input aclr,
		input [DSM_WIDTH-1:0] left_pcm,
		input [DSM_WIDTH-1:0] right_pcm,
		output left_out,
		output right_out
	);

	reg [DSM_WIDTH:0] left_accum;
	reg [DSM_WIDTH:0] right_accum;

	always @(posedge clk or posedge aclr)
		begin
			if (!aclr)
				begin
					left_accum <= 0;
					right_accum <= 0;
				end
			else
				begin
					left_accum <= left_accum[DSM_WIDTH-1:0] + left_pcm;
					right_accum <= right_accum[DSM_WIDTH-1:0] + right_pcm;
				end
		end
	
	assign left_out = left_accum[DSM_WIDTH];
	assign right_out = right_accum[DSM_WIDTH];

endmodule
