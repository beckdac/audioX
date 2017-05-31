// 44.1 kHz audio out with dsm and pll clock
//
// (c) 2017, David Beck, beck.dac@live.com
// MIT License

module audio_44_1kHz
	#(parameter AUDIO_BITS = 12)
	(
		input clk,							// system clock
		input aclr_,						// inverted asynchronous clear (active high to low)
		input wreq,							// write request for next sample, active high
		input [(2*AUDIO_BITS)-1:0] sample,	// when wreq, this sample is read into internal buffer
		output wire left_out,				// left 1 bit dac
		output wire right_out,				// right 1 bit dac
		output wire pll_locked,				// is the audio pll locked
		output reg ready = 0,				// 1 when ready for next sample
		output wire clk_audio				// 44.1 kHz clock * max unsigned integer(AUDIO_BITS)
	);

	reg [(2*AUDIO_BITS)-1:0] sample_buf = 0;// internal buffer for audio sample, updated at +e wreq
	reg [AUDIO_BITS-1:0] left_pcm = 0;		// values sent to dsm
	reg [AUDIO_BITS-1:0] right_pcm = 0;
	reg sample_ready = 0;					// has a new value been read into sample_buf
	reg [AUDIO_BITS-1:0] sample_clock = 0;	// when this overflows, one full audio cycle has passed

	reg aclr = 0;							// active high reset (inverted from alcr_)
	always aclr = !aclr_;

	// audio pll that runs at 44.1 kHz * 12 bit dsm depth
	pll_12bit_44_1kHz AUDIO_PLL (
			.areset(aclr),
			.inclk0(clk),
			.c0(clk_audio),
			.locked(pll_locked)
		);

	// stereo dsm generator using pll	
	dsm_stereo #(AUDIO_BITS) AUDIO_DSM (
			.clk(clk_audio),
			.aclr(aclr),
			.left_pcm(left_pcm),
			.right_pcm(right_pcm),
			.left_out(left_out),
			.right_out(right_out)
		);

	// handle write request
	always @(posedge clk_audio or posedge aclr)
		begin
			if (aclr)
				sample_buf <= 0;
			else
				if (wreq)
					sample_buf <= sample;
				else
					sample_buf <= sample_buf;
		end

	always @(posedge clk_audio or posedge aclr)
		begin
			if (aclr)
				ready <= 1;
			else
				if (wreq)
					ready <= 0;
				else if (sample_clock == 0)
					ready <= 1;
				else
					ready <= ready;
		end

	// handle transfer of sample_buf to left and right channels
	always @(posedge clk_audio or posedge aclr)
		begin
			if (aclr)
				begin
					left_pcm <= 0;
					right_pcm <= 0;
				end
			else
				begin
					if (sample_clock == 0 && !ready)
						begin
							left_pcm <= sample_buf[(AUDIO_BITS * 2)-1:AUDIO_BITS];
							right_pcm <= sample_buf[AUDIO_BITS-1:0];
						end
					else if (sample_clock == 0 && ready)
						begin
							// no sample is available, but the clock is done,
							// zero the sample
							left_pcm <= 0;
							right_pcm <= 0;
						end
					else
						begin
							left_pcm <= left_pcm;
							right_pcm <= right_pcm;
						end
				end
		end

	// handle cycle of audio sample clock
	always @(posedge clk_audio or posedge aclr)
		begin
			if (aclr)
				sample_clock <= 0;
			else
				sample_clock <= sample_clock + 1;
		end

endmodule
