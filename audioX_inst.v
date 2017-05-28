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


// Generated by Quartus Prime Version 17.0 (Build Build 595 04/25/2017)
// Created on Sun May 28 00:45:41 2017

audioX audioX_inst
(
	.sys_clock(sys_clock_sig) ,	// input  sys_clock_sig
	.reset_(reset__sig) ,	// input  reset__sig
	.pll_locked(pll_locked_sig) ,	// output  pll_locked_sig
	.audio_fifo_full(audio_fifo_full_sig) ,	// output  audio_fifo_full_sig
	.audio_right(audio_right_sig) ,	// output  audio_right_sig
	.audio_left(audio_left_sig) 	// output  audio_left_sig
);
