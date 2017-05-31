// test bench for audio_44_1kHz module
//
// (c) 2017, David Beck, beck.dac@live.com
// MIT License
//
// to use in quartus / modelsim
// vlog -vlog01compat -work work +incdir+C:/Users/dacb/Desktop/audioX {C:/Users/dacb/Desktop/audioX/audio_44_1kHz_tb.v}
// vsim +altera -L altera_ver -L altera -L 220model_ver -L 220model -L altera_lnsim_ver -L altera_lnsim -L  cycloneive_ver -L cycloneive -L altera_mf_ver -L altera_mf -do audioX_run_msim_rtl_verilog.do -gui -l  msim_transcript work.audio_44_1kHz_tb

`timescale 1ns/1ns

module audio_44_1kHz_tb #(parameter AUDIO_BITS = 12) ();
	localparam CLOCK_PERIOD_NS = 20;

	reg clk = 0;
	always #(CLOCK_PERIOD_NS/2) clk <= !clk;

	reg aclr = 1;
	reg wreq = 0;
	reg [(AUDIO_BITS*2)-1:0] sample = 0;
	wire status, ready, pll_locked;
	wire left_out, right_out;

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

	initial
		begin
			#CLOCK_PERIOD_NS
			aclr <= 0;
			#CLOCK_PERIOD_NS
			aclr <= 1;
			#CLOCK_PERIOD_NS
			sample[(AUDIO_BITS*2)-1:AUDIO_BITS] <= 1024;
			sample[AUDIO_BITS-1:0] <= 4000;
			wreq <= 1;
			#CLOCK_PERIOD_NS
			// ready should fall
			#(CLOCK_PERIOD_NS * 1150) // 23000 ns is just > 1 sample at 44.1 kHz
			// ready should come back up
			$finish;
		end

endmodule
