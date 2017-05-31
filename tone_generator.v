// tone generator for audio_44_1kHz module
//
// (c) 2017, David Beck, beck.dac@live.com
// MIT License

module tone_generator
	#(parameter AUDIO_BITS = 12)
	(
		input clk,
		input aclr_,
		output wire left_out,
		output wire right_out,
		output wire pll_locked,
		output wire status,
		output wire ready
	);

	reg wreq = 0;
	reg [(AUDIO_BITS*2)-1:0] sample = 0;

	audio_44_1kHz #(AUDIO_BITS) MUT
		(
			.clk(clk),
			.aclr_(aclr_),
			.wreq(wreq),
			.sample(sample),
			.left_out(left_out),
			.right_out(right_out),
			.pll_locked(pll_locked),
			.status(status),
			.ready(ready)
		);

	reg [11:0] count = 0;

	always @(posedge clk or negedge aclr_)
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
							sample[(AUDIO_BITS*2)-1:AUDIO_BITS] <= sample[(AUDIO_BITS*2)-1:AUDIO_BITS] - 1;
							sample[AUDIO_BITS-1:0] <= sample[AUDIO_BITS-1:0] + 1;
						end
					else
						begin
							wreq <= 0;
							sample <= 0;
						end
				end
		end

endmodule
