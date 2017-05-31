// tone generator for audio_44_1kHz module
//
// (c) 2017, David Beck, beck.dac@live.com
// MIT License

module tone_generator
	#(parameter AUDIO_BITS = 12)
	(
		input clk,
		input aclr_,
		output wire clk_audio,
		output wire left_out,
		output wire right_out,
		output wire pll_locked,
		output reg status = 0,
		output wire ready
	);

	reg wreq = 0;
	reg [(AUDIO_BITS*2)-1:0] sample = 0;
	reg [31:0] count = 0;

	audio_44_1kHz #(AUDIO_BITS) MUT
		(
			.clk(clk),
			.clk_audio(clk_audio),
			.aclr_(aclr_),
			.wreq(wreq),
			.sample(sample),
			.left_out(left_out),
			.right_out(right_out),
			.pll_locked(pll_locked),
			.ready(ready)
		);

	always @(posedge clk_audio or negedge aclr_)
		begin
			if (!aclr_)
				begin
					wreq <= 0;
					sample <= 0;
				end
			else
				begin
					if (ready)
						begin
							wreq <= 1;
							sample[(AUDIO_BITS*2)-1:AUDIO_BITS] <= 4095;
							sample[AUDIO_BITS-1:0] <= 4095;
						end
					else
						begin
							wreq <= 0;
							sample <= 0;
						end
				end
		end
	
	always @(posedge clk_audio or negedge aclr_)
		begin
			if (!aclr_)
				count <= 0;
			else
				begin
					if (count == 44100 * 4096)
						begin
							status <= !status;
							count <= 0;
						end
					else
						begin
							count <= count + 1;
							status <= status;
						end
				end
		end

endmodule
