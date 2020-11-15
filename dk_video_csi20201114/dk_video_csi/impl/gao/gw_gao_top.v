module gw_gao(
    img_req_Z,
    img_vs_Z,
    \img_data[15] ,
    \img_data[14] ,
    \img_data[13] ,
    \img_data[12] ,
    \img_data[11] ,
    \img_data[10] ,
    \img_data[9] ,
    \img_data[8] ,
    \img_data[7] ,
    \img_data[6] ,
    \img_data[5] ,
    \img_data[4] ,
    \img_data[3] ,
    \img_data[2] ,
    \img_data[1] ,
    \img_data[0] ,
    \u_img_data_pkt/sync_fifo_2048x32b_inst/WrEn ,
    \u_img_data_pkt/Data[31] ,
    \u_img_data_pkt/Data[30] ,
    \u_img_data_pkt/Data[29] ,
    \u_img_data_pkt/Data[28] ,
    \u_img_data_pkt/Data[27] ,
    \u_img_data_pkt/Data[26] ,
    \u_img_data_pkt/Data[25] ,
    \u_img_data_pkt/Data[24] ,
    \u_img_data_pkt/Data[23] ,
    \u_img_data_pkt/Data[22] ,
    \u_img_data_pkt/Data[21] ,
    \u_img_data_pkt/Data[20] ,
    \u_img_data_pkt/Data[19] ,
    \u_img_data_pkt/Data[18] ,
    \u_img_data_pkt/Data[17] ,
    \u_img_data_pkt/Data[16] ,
    \u_img_data_pkt/Data[15] ,
    \u_img_data_pkt/Data[14] ,
    \u_img_data_pkt/Data[13] ,
    \u_img_data_pkt/Data[12] ,
    \u_img_data_pkt/Data[11] ,
    \u_img_data_pkt/Data[10] ,
    \u_img_data_pkt/Data[9] ,
    \u_img_data_pkt/Data[8] ,
    \u_img_data_pkt/Data[7] ,
    \u_img_data_pkt/Data[6] ,
    \u_img_data_pkt/Data[5] ,
    \u_img_data_pkt/Data[4] ,
    \u_img_data_pkt/Data[3] ,
    \u_img_data_pkt/Data[2] ,
    \u_img_data_pkt/Data[1] ,
    \u_img_data_pkt/Data[0] ,
    \udp_tx_data_img[31] ,
    \udp_tx_data_img[30] ,
    \udp_tx_data_img[29] ,
    \udp_tx_data_img[28] ,
    \udp_tx_data_img[27] ,
    \udp_tx_data_img[26] ,
    \udp_tx_data_img[25] ,
    \udp_tx_data_img[24] ,
    \udp_tx_data_img[23] ,
    \udp_tx_data_img[22] ,
    \udp_tx_data_img[21] ,
    \udp_tx_data_img[20] ,
    \udp_tx_data_img[19] ,
    \udp_tx_data_img[18] ,
    \udp_tx_data_img[17] ,
    \udp_tx_data_img[16] ,
    \udp_tx_data_img[15] ,
    \udp_tx_data_img[14] ,
    \udp_tx_data_img[13] ,
    \udp_tx_data_img[12] ,
    \udp_tx_data_img[11] ,
    \udp_tx_data_img[10] ,
    \udp_tx_data_img[9] ,
    \udp_tx_data_img[8] ,
    \udp_tx_data_img[7] ,
    \udp_tx_data_img[6] ,
    \udp_tx_data_img[5] ,
    \udp_tx_data_img[4] ,
    \udp_tx_data_img[3] ,
    \udp_tx_data_img[2] ,
    \udp_tx_data_img[1] ,
    \udp_tx_data_img[0] ,
    tx_start_en,
    off0_syn_de,
    tx_req_Z,
    eth_txc_d,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input img_req_Z;
input img_vs_Z;
input \img_data[15] ;
input \img_data[14] ;
input \img_data[13] ;
input \img_data[12] ;
input \img_data[11] ;
input \img_data[10] ;
input \img_data[9] ;
input \img_data[8] ;
input \img_data[7] ;
input \img_data[6] ;
input \img_data[5] ;
input \img_data[4] ;
input \img_data[3] ;
input \img_data[2] ;
input \img_data[1] ;
input \img_data[0] ;
input \u_img_data_pkt/sync_fifo_2048x32b_inst/WrEn ;
input \u_img_data_pkt/Data[31] ;
input \u_img_data_pkt/Data[30] ;
input \u_img_data_pkt/Data[29] ;
input \u_img_data_pkt/Data[28] ;
input \u_img_data_pkt/Data[27] ;
input \u_img_data_pkt/Data[26] ;
input \u_img_data_pkt/Data[25] ;
input \u_img_data_pkt/Data[24] ;
input \u_img_data_pkt/Data[23] ;
input \u_img_data_pkt/Data[22] ;
input \u_img_data_pkt/Data[21] ;
input \u_img_data_pkt/Data[20] ;
input \u_img_data_pkt/Data[19] ;
input \u_img_data_pkt/Data[18] ;
input \u_img_data_pkt/Data[17] ;
input \u_img_data_pkt/Data[16] ;
input \u_img_data_pkt/Data[15] ;
input \u_img_data_pkt/Data[14] ;
input \u_img_data_pkt/Data[13] ;
input \u_img_data_pkt/Data[12] ;
input \u_img_data_pkt/Data[11] ;
input \u_img_data_pkt/Data[10] ;
input \u_img_data_pkt/Data[9] ;
input \u_img_data_pkt/Data[8] ;
input \u_img_data_pkt/Data[7] ;
input \u_img_data_pkt/Data[6] ;
input \u_img_data_pkt/Data[5] ;
input \u_img_data_pkt/Data[4] ;
input \u_img_data_pkt/Data[3] ;
input \u_img_data_pkt/Data[2] ;
input \u_img_data_pkt/Data[1] ;
input \u_img_data_pkt/Data[0] ;
input \udp_tx_data_img[31] ;
input \udp_tx_data_img[30] ;
input \udp_tx_data_img[29] ;
input \udp_tx_data_img[28] ;
input \udp_tx_data_img[27] ;
input \udp_tx_data_img[26] ;
input \udp_tx_data_img[25] ;
input \udp_tx_data_img[24] ;
input \udp_tx_data_img[23] ;
input \udp_tx_data_img[22] ;
input \udp_tx_data_img[21] ;
input \udp_tx_data_img[20] ;
input \udp_tx_data_img[19] ;
input \udp_tx_data_img[18] ;
input \udp_tx_data_img[17] ;
input \udp_tx_data_img[16] ;
input \udp_tx_data_img[15] ;
input \udp_tx_data_img[14] ;
input \udp_tx_data_img[13] ;
input \udp_tx_data_img[12] ;
input \udp_tx_data_img[11] ;
input \udp_tx_data_img[10] ;
input \udp_tx_data_img[9] ;
input \udp_tx_data_img[8] ;
input \udp_tx_data_img[7] ;
input \udp_tx_data_img[6] ;
input \udp_tx_data_img[5] ;
input \udp_tx_data_img[4] ;
input \udp_tx_data_img[3] ;
input \udp_tx_data_img[2] ;
input \udp_tx_data_img[1] ;
input \udp_tx_data_img[0] ;
input tx_start_en;
input off0_syn_de;
input tx_req_Z;
input eth_txc_d;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire img_req_Z;
wire img_vs_Z;
wire \img_data[15] ;
wire \img_data[14] ;
wire \img_data[13] ;
wire \img_data[12] ;
wire \img_data[11] ;
wire \img_data[10] ;
wire \img_data[9] ;
wire \img_data[8] ;
wire \img_data[7] ;
wire \img_data[6] ;
wire \img_data[5] ;
wire \img_data[4] ;
wire \img_data[3] ;
wire \img_data[2] ;
wire \img_data[1] ;
wire \img_data[0] ;
wire \u_img_data_pkt/sync_fifo_2048x32b_inst/WrEn ;
wire \u_img_data_pkt/Data[31] ;
wire \u_img_data_pkt/Data[30] ;
wire \u_img_data_pkt/Data[29] ;
wire \u_img_data_pkt/Data[28] ;
wire \u_img_data_pkt/Data[27] ;
wire \u_img_data_pkt/Data[26] ;
wire \u_img_data_pkt/Data[25] ;
wire \u_img_data_pkt/Data[24] ;
wire \u_img_data_pkt/Data[23] ;
wire \u_img_data_pkt/Data[22] ;
wire \u_img_data_pkt/Data[21] ;
wire \u_img_data_pkt/Data[20] ;
wire \u_img_data_pkt/Data[19] ;
wire \u_img_data_pkt/Data[18] ;
wire \u_img_data_pkt/Data[17] ;
wire \u_img_data_pkt/Data[16] ;
wire \u_img_data_pkt/Data[15] ;
wire \u_img_data_pkt/Data[14] ;
wire \u_img_data_pkt/Data[13] ;
wire \u_img_data_pkt/Data[12] ;
wire \u_img_data_pkt/Data[11] ;
wire \u_img_data_pkt/Data[10] ;
wire \u_img_data_pkt/Data[9] ;
wire \u_img_data_pkt/Data[8] ;
wire \u_img_data_pkt/Data[7] ;
wire \u_img_data_pkt/Data[6] ;
wire \u_img_data_pkt/Data[5] ;
wire \u_img_data_pkt/Data[4] ;
wire \u_img_data_pkt/Data[3] ;
wire \u_img_data_pkt/Data[2] ;
wire \u_img_data_pkt/Data[1] ;
wire \u_img_data_pkt/Data[0] ;
wire \udp_tx_data_img[31] ;
wire \udp_tx_data_img[30] ;
wire \udp_tx_data_img[29] ;
wire \udp_tx_data_img[28] ;
wire \udp_tx_data_img[27] ;
wire \udp_tx_data_img[26] ;
wire \udp_tx_data_img[25] ;
wire \udp_tx_data_img[24] ;
wire \udp_tx_data_img[23] ;
wire \udp_tx_data_img[22] ;
wire \udp_tx_data_img[21] ;
wire \udp_tx_data_img[20] ;
wire \udp_tx_data_img[19] ;
wire \udp_tx_data_img[18] ;
wire \udp_tx_data_img[17] ;
wire \udp_tx_data_img[16] ;
wire \udp_tx_data_img[15] ;
wire \udp_tx_data_img[14] ;
wire \udp_tx_data_img[13] ;
wire \udp_tx_data_img[12] ;
wire \udp_tx_data_img[11] ;
wire \udp_tx_data_img[10] ;
wire \udp_tx_data_img[9] ;
wire \udp_tx_data_img[8] ;
wire \udp_tx_data_img[7] ;
wire \udp_tx_data_img[6] ;
wire \udp_tx_data_img[5] ;
wire \udp_tx_data_img[4] ;
wire \udp_tx_data_img[3] ;
wire \udp_tx_data_img[2] ;
wire \udp_tx_data_img[1] ;
wire \udp_tx_data_img[0] ;
wire tx_start_en;
wire off0_syn_de;
wire tx_req_Z;
wire eth_txc_d;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;
wire tdo_er2;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(tdo_er2)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top_0  u_la0_top(
    .control(control0[9:0]),
    .trig0_i(img_req_Z),
    .trig1_i({\img_data[15] ,\img_data[14] ,\img_data[13] ,\img_data[12] ,\img_data[11] ,\img_data[10] ,\img_data[9] ,\img_data[8] ,\img_data[7] ,\img_data[6] ,\img_data[5] ,\img_data[4] ,\img_data[3] ,\img_data[2] ,\img_data[1] ,\img_data[0] }),
    .trig5_i(img_vs_Z),
    .trig6_i(\u_img_data_pkt/sync_fifo_2048x32b_inst/WrEn ),
    .trig7_i({\udp_tx_data_img[31] ,\udp_tx_data_img[30] ,\udp_tx_data_img[29] ,\udp_tx_data_img[28] ,\udp_tx_data_img[27] ,\udp_tx_data_img[26] ,\udp_tx_data_img[25] ,\udp_tx_data_img[24] ,\udp_tx_data_img[23] ,\udp_tx_data_img[22] ,\udp_tx_data_img[21] ,\udp_tx_data_img[20] ,\udp_tx_data_img[19] ,\udp_tx_data_img[18] ,\udp_tx_data_img[17] ,\udp_tx_data_img[16] ,\udp_tx_data_img[15] ,\udp_tx_data_img[14] ,\udp_tx_data_img[13] ,\udp_tx_data_img[12] ,\udp_tx_data_img[11] ,\udp_tx_data_img[10] ,\udp_tx_data_img[9] ,\udp_tx_data_img[8] ,\udp_tx_data_img[7] ,\udp_tx_data_img[6] ,\udp_tx_data_img[5] ,\udp_tx_data_img[4] ,\udp_tx_data_img[3] ,\udp_tx_data_img[2] ,\udp_tx_data_img[1] ,\udp_tx_data_img[0] }),
    .trig8_i(tx_start_en),
    .trig9_i(off0_syn_de),
    .trig10_i(tx_req_Z),
    .trig11_i({\u_img_data_pkt/Data[31] ,\u_img_data_pkt/Data[30] ,\u_img_data_pkt/Data[29] ,\u_img_data_pkt/Data[28] ,\u_img_data_pkt/Data[27] ,\u_img_data_pkt/Data[26] ,\u_img_data_pkt/Data[25] ,\u_img_data_pkt/Data[24] ,\u_img_data_pkt/Data[23] ,\u_img_data_pkt/Data[22] ,\u_img_data_pkt/Data[21] ,\u_img_data_pkt/Data[20] ,\u_img_data_pkt/Data[19] ,\u_img_data_pkt/Data[18] ,\u_img_data_pkt/Data[17] ,\u_img_data_pkt/Data[16] ,\u_img_data_pkt/Data[15] ,\u_img_data_pkt/Data[14] ,\u_img_data_pkt/Data[13] ,\u_img_data_pkt/Data[12] ,\u_img_data_pkt/Data[11] ,\u_img_data_pkt/Data[10] ,\u_img_data_pkt/Data[9] ,\u_img_data_pkt/Data[8] ,\u_img_data_pkt/Data[7] ,\u_img_data_pkt/Data[6] ,\u_img_data_pkt/Data[5] ,\u_img_data_pkt/Data[4] ,\u_img_data_pkt/Data[3] ,\u_img_data_pkt/Data[2] ,\u_img_data_pkt/Data[1] ,\u_img_data_pkt/Data[0] }),
    .data_i({img_req_Z,img_vs_Z,\img_data[15] ,\img_data[14] ,\img_data[13] ,\img_data[12] ,\img_data[11] ,\img_data[10] ,\img_data[9] ,\img_data[8] ,\img_data[7] ,\img_data[6] ,\img_data[5] ,\img_data[4] ,\img_data[3] ,\img_data[2] ,\img_data[1] ,\img_data[0] ,\u_img_data_pkt/sync_fifo_2048x32b_inst/WrEn ,\u_img_data_pkt/Data[31] ,\u_img_data_pkt/Data[30] ,\u_img_data_pkt/Data[29] ,\u_img_data_pkt/Data[28] ,\u_img_data_pkt/Data[27] ,\u_img_data_pkt/Data[26] ,\u_img_data_pkt/Data[25] ,\u_img_data_pkt/Data[24] ,\u_img_data_pkt/Data[23] ,\u_img_data_pkt/Data[22] ,\u_img_data_pkt/Data[21] ,\u_img_data_pkt/Data[20] ,\u_img_data_pkt/Data[19] ,\u_img_data_pkt/Data[18] ,\u_img_data_pkt/Data[17] ,\u_img_data_pkt/Data[16] ,\u_img_data_pkt/Data[15] ,\u_img_data_pkt/Data[14] ,\u_img_data_pkt/Data[13] ,\u_img_data_pkt/Data[12] ,\u_img_data_pkt/Data[11] ,\u_img_data_pkt/Data[10] ,\u_img_data_pkt/Data[9] ,\u_img_data_pkt/Data[8] ,\u_img_data_pkt/Data[7] ,\u_img_data_pkt/Data[6] ,\u_img_data_pkt/Data[5] ,\u_img_data_pkt/Data[4] ,\u_img_data_pkt/Data[3] ,\u_img_data_pkt/Data[2] ,\u_img_data_pkt/Data[1] ,\u_img_data_pkt/Data[0] ,\udp_tx_data_img[31] ,\udp_tx_data_img[30] ,\udp_tx_data_img[29] ,\udp_tx_data_img[28] ,\udp_tx_data_img[27] ,\udp_tx_data_img[26] ,\udp_tx_data_img[25] ,\udp_tx_data_img[24] ,\udp_tx_data_img[23] ,\udp_tx_data_img[22] ,\udp_tx_data_img[21] ,\udp_tx_data_img[20] ,\udp_tx_data_img[19] ,\udp_tx_data_img[18] ,\udp_tx_data_img[17] ,\udp_tx_data_img[16] ,\udp_tx_data_img[15] ,\udp_tx_data_img[14] ,\udp_tx_data_img[13] ,\udp_tx_data_img[12] ,\udp_tx_data_img[11] ,\udp_tx_data_img[10] ,\udp_tx_data_img[9] ,\udp_tx_data_img[8] ,\udp_tx_data_img[7] ,\udp_tx_data_img[6] ,\udp_tx_data_img[5] ,\udp_tx_data_img[4] ,\udp_tx_data_img[3] ,\udp_tx_data_img[2] ,\udp_tx_data_img[1] ,\udp_tx_data_img[0] ,tx_start_en,off0_syn_de,tx_req_Z}),
    .clk_i(eth_txc_d)
);

endmodule
