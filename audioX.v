// Copyright (C) 2017  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Intel and sold by Intel or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 17.0.0 Build 595 04/25/2017 SJ Lite Edition"
// CREATED		"Sun May 28 01:00:09 2017"

module audioX(
	sys_clock,
	reset_,
	pll_locked,
	audio_fifo_full,
	audio_right,
	audio_left
);


input wire	sys_clock;
input wire	reset_;
output wire	pll_locked;
output wire	audio_fifo_full;
output wire	audio_right;
output wire	audio_left;

wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	[15:0] SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_5;





altpll_audio_out	b2v_inst(
	.inclk0(sys_clock),
	.areset(reset_),
	.c0(SYNTHESIZED_WIRE_0),
	.locked(SYNTHESIZED_WIRE_5));


audio_stereo_out	b2v_inst1(
	.aclr(reset_),
	.clk_audio(SYNTHESIZED_WIRE_0),
	.clk_pcm(sys_clock),
	.stereo_pcm_rdy(SYNTHESIZED_WIRE_1),
	.stereo_pcm(SYNTHESIZED_WIRE_2),
	.left(audio_left),
	.right(audio_right),
	.fifo_full(SYNTHESIZED_WIRE_6));

assign	audio_fifo_full =  ~SYNTHESIZED_WIRE_6;


tone_generator	b2v_inst3(
	.clk(sys_clock),
	.aclr(reset_),
	.fifo_full(SYNTHESIZED_WIRE_6),
	.tone_pcm_rdy(SYNTHESIZED_WIRE_1),
	.tone_pcm(SYNTHESIZED_WIRE_2));

assign	pll_locked =  ~SYNTHESIZED_WIRE_5;


endmodule
