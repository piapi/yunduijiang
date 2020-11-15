//Copyright (C)2014-2020 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.6.02 Beta
//Created Time: 2020-10-20 16:32:46
create_clock -name clk_12m -period 83.333 -waveform {0 41.666} [get_ports {aud_mclk}]
create_clock -name eth_txc_clk -period 8 -waveform {0 4} [get_ports {eth_txc}]
create_clock -name eth_rxc_clk -period 8 -waveform {0 4} [get_ports {eth_rxc}]
create_clock -name clk_x4i -period 3.333 -waveform {0 1.667} [get_nets {DDR3_Memory_Interface_Top_inst/gw3mc_top/u_ddr_phy_top/clk_x4i}] -add
create_clock -name clk_x4 -period 3.333 -waveform {0 1.667} [get_nets {DDR3_Memory_Interface_Top_inst/gw3mc_top/u_ddr_phy_top/clk_x4}] -add
create_clock -name I_clk -period 20 -waveform {0 10} [get_ports {I_clk}] -add
create_clock -name dma_clk -period 13.333 -waveform {0 6.667} [get_nets {dma_clk}] -add
