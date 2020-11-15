//Copyright (C)2014-2020 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: GowinSynthesis V1.9.7Beta
//Part Number: GW2A-LV18PG484C8/I7
//Device: GW2A-18
//Created Time: Thu Nov 05 20:38:33 2020

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	async_fifo_512x32b your_instance_name(
		.Data(Data_i), //input [31:0] Data
		.Reset(Reset_i), //input Reset
		.WrClk(WrClk_i), //input WrClk
		.RdClk(RdClk_i), //input RdClk
		.WrEn(WrEn_i), //input WrEn
		.RdEn(RdEn_i), //input RdEn
		.Wnum(Wnum_o), //output [9:0] Wnum
		.Rnum(Rnum_o), //output [9:0] Rnum
		.Q(Q_o), //output [31:0] Q
		.Empty(Empty_o), //output Empty
		.Full(Full_o) //output Full
	);

//--------Copy end-------------------
