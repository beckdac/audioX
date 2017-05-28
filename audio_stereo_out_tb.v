`timescale 1ps/1ps

module audio_stereo_out_tb();
	localparam PCM_CLOCK_PERIOD_NS = 20;
	localparam AUDIO_CLOCK_PERIOD_NS = 8.89245;

	reg aclr = 1, clk_pcm = 0, clk_audio = 0;
	reg [7:0] left = 0, right = 0;
	wire left_out, right_out, fifo_full;
	reg stereo_pcm_rdy = 0;

	always #(PCM_CLOCK_PERIOD_NS/2) clk_pcm <= !clk_pcm;
	always #(AUDIO_CLOCK_PERIOD_NS/2) clk_audio <= !clk_audio;

	audio_stereo_out MUT
		(
			.aclr(aclr),
			.clk_audio(clk_audio),
			.left(left_out),
			.right(left_out),
			.clk_pcm(clk_pcm),
			.stereo_pcm_rdy(stereo_pcm_rdy),
			.stereo_pcm({left, right}),
			.fifo_full(fifo_full)
		);

	initial
		begin
			#PCM_CLOCK_PERIOD_NS
			aclr <= 0;
			#PCM_CLOCK_PERIOD_NS
			aclr <= 1;
			#PCM_CLOCK_PERIOD_NS
			left = 8'd127;
			stereo_pcm_rdy <= 1;
			#PCM_CLOCK_PERIOD_NS
			stereo_pcm_rdy <= 0;
			#(PCM_CLOCK_PERIOD_NS * 255 * 10)
			left = 8'd0;
			right = 8'd127;
			stereo_pcm_rdy <= 1;
			#PCM_CLOCK_PERIOD_NS
			stereo_pcm_rdy <= 0;
			#(PCM_CLOCK_PERIOD_NS * 255 * 10)
			left = 8'd127;
			right = 8'd127;
			stereo_pcm_rdy <= 1;
			#PCM_CLOCK_PERIOD_NS
			stereo_pcm_rdy <= 0;
			#(PCM_CLOCK_PERIOD_NS * 255 * 10)
			left = 8'd0;
			right = 8'd0;
			stereo_pcm_rdy <= 1;
			#PCM_CLOCK_PERIOD_NS
			stereo_pcm_rdy <= 0;
			#(PCM_CLOCK_PERIOD_NS * 255 * 10)
			$finish;
		end
	
endmodule
