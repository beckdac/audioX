// 44.1 kHz audio out with dsm and pll clock

module audio_44_1kHz
	#(parameter AUDIO_BITS = 12)
	(
		input clk,
		input aclr_,
		output wire left_out,
		output wire right_out,
		output wire pll_locked,
		output reg status
	);

	wire clk_audio;

	reg [AUDIO_BITS-1:0] left_pcm;
	reg [AUDIO_BITS-1:0] right_pcm;

	reg [25:0] count;
	reg aclr;

	always aclr = !aclr_;

	pll_12bit_44_1kHz AUDIO_PLL (
			.areset(aclr),
			.inclk0(clk),
			.c0(clk_audio),
			.locked(pll_locked)
		);
	
	dsm_stereo #(AUDIO_BITS) AUDIO_DSM (
			.clk(clk_audio),
			.aclr(aclr),
			.left_pcm(left_pcm),
			.right_pcm(right_pcm),
			.left_out(left_out),
			.right_out(right_out)
		);

	always @(posedge clk or posedge aclr)
		begin
			if (aclr)
				begin
					count <= 0;
					left_pcm <= 0;
					right_pcm <= 0;
				end
			else
				begin
					if (count == 50000000)
						begin
							count <= 0;
							left_pcm <= left_pcm + 12'd127;
							right_pcm <= right_pcm + 12'd127;
							status <= !status;
						end
					else
						begin
							count <= count + 1'b1;
							left_pcm <= left_pcm;
							right_pcm <= right_pcm;
							status <= status;
						end
				end
		end

endmodule
