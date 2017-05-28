module audio_stereo_out
	(
		input aclr,
		input clk_audio,
		output wire left,
		output wire right,
		input clk_pcm,
		input stereo_pcm_rdy,
		input [15:0] stereo_pcm,
		output wire fifo_full
	);
	localparam SUBSAMPLES = 10;

	wire [15:0] fifo_data_out;
	reg [15:0] pcm_data = 0;
	wire fifo_empty;
	reg read_rq_fifo = 0;
	reg [3:0] subsample = 0;

	pwm_audio_stereo_out PWMASO
		(
			.aclr(aclr),
			.clk(clk_audio),
			.left(left),
			.right(right),
			.left_top(pcm_data[7:0]),
			.right_top(pcm_data[15:8])
		);

	fifo_audio FIFO_PCM2PWM
		(
			.aclr(aclr),
			.data(stereo_pcm),
			.rdclk(clk_audio),
			.rdreq(read_rq_fifo),
			.wrclk(clk_pcm),
			.wrreq(stereo_pcm_rdy),
			.q(fifo_data_out),
			.rdempty(fifo_empty),
			.wrfull(fifo_full)
		);

	always @(posedge clk_audio or negedge(aclr))
		begin
			if (~aclr)
				begin
					$display("%m\nreceived reset");
					$display($time);
					subsample <= 0;
				end
			else
				begin
					case (subsample)
						0:
							begin
								// read the pcm data into the pwm subsystem
								if (fifo_empty)
									pcm_data <= 0;
								else
									pcm_data <= fifo_data_out;

								// pulse read_q_fifo so that the data are
								// ready for the next sample in 10 subsamples
								read_rq_fifo <= 1;

								subsample <= 1;
							end
						1:
							begin
								// end pulse read_q_fifo
								read_rq_fifo <= 0;

								subsample <= 2;
							end
						SUBSAMPLES-1:
							begin
								subsample <= 0;
							end
						default:
							begin
								subsample <= subsample + 4'b1;
							end
					endcase
				end
		end

endmodule
