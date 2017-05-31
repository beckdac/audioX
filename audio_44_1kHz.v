// 44.1 kHz audio out with dsm and pll clock
//
// (c) 2017, David Beck, beck.dac@live.com
// MIT License

module audio_44_1kHz
	#(parameter AUDIO_BITS = 12)
	(
		input clk,							// system clock
		input aclr_,						// inverted asynchronous clear (active high to low)
		input wreq;							// write request for next sample, active high
		input [(2*AUDIO_BITS)-1:0] sample;	// when wreq, this sample is read into internal buffer
		output wire left_out,				// left 1 bit dac
		output wire right_out,				// right 1 bit dac
		output wire pll_locked,				// is the audio pll locked
		output reg status					// 1s blinkenlicht for status
	);

	wire clk_audio;

	reg [AUDIO_BITS-1:0] left_pcm = 0;
	reg [AUDIO_BITS-1:0] right_pcm = 0;

	reg [25:0] count = 0;
	reg aclr = 0;

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
