
module wm8978_ctrl(
    input                clk        ,   // 时钟信号
    input                rst_n      ,   // 复位信号
    
    //audio interface(mast  
    input                aud_bclk   ,   // WM8978位时钟
    input                aud_lrc    ,   // 对齐信号
    input                aud_adcdat ,   // 音频输入
    output               aud_dacdat ,   // 音频输出
    
    //control interfac  
    output               aud_scl    ,   // WM8978的SCL信号
    inout                aud_sda    ,   // WM8978的SDA信号
    
    //user i    
    output     [31:0]    adc_data   ,   // 输入的音频数据
    input      [31:0]    dac_data   ,   // 输出的音频数据
    output               rx_done    ,   // 一次采集完成
    output               tx_done        // 一次发送完成
);

//parameter define
parameter    WL = 6'd32;                // word length音频字长定义

//*****************************************************
//**                    main code
//*****************************************************

//例化WM8978寄存器配置模块
wm8978_config #(
    .WL             (WL)
) u_wm8978_config(
    .clk            (clk),              // 时钟信号
    .rst_n          (rst_n),            // 复位信号
        
    .aud_scl        (aud_scl),          // WM8978的SCL时钟
    .aud_sda        (aud_sda),          // WM8978的SDA信号
    .cfg_done       (cfg_done)
);

//例化WM8978音频接收模块
audio_receive #(
    .WL             (WL)
) u_audio_receive(    
    .rst_n          (rst_n  &  cfg_done),            // 复位信号
    
    .aud_bclk       (aud_bclk),         // WM8978位时钟
    .aud_lrc        (aud_lrc),          // 对齐信号
    .aud_adcdat     (aud_adcdat),       // 音频输入
        
    .adc_data       (adc_data),         // FPGA接收的数据
    .rx_done        (rx_done)           // FPGA接收数据完成
);

//例化WM8978音频发送模块
audio_send #(
    .WL             (WL)
) u_audio_send(
    .rst_n          (rst_n  &  cfg_done),            // 复位信号
        
    .aud_bclk       (aud_bclk),         // WM8978位时钟
    .aud_lrc        (aud_lrc),          // 对齐信号
    .aud_dacdat     (aud_dacdat),       // 音频数据输出
        
    .dac_data       (dac_data),         // 预输出的音频数据
    .tx_done        (tx_done)           // 发送完成信号
);

endmodule 