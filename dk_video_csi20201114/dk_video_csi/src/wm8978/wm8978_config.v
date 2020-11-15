
`timescale 1ns/1ns

module wm8978_config(
    input        clk     ,                  // 时钟信号
    input        rst_n   ,                  // 复位信号
    
    output       aud_scl ,                  // WM8978的SCL时钟
    inout        aud_sda ,                   // WM8978的SDA信号
    output       cfg_done                    // WM8978配置完成标志
);

//parameter define
parameter   SLAVE_ADDR = 7'h1a         ;    // 器件地址
parameter   WL         = 6'd32         ;    // word length音频字长参数设置
parameter   BIT_CTRL   = 1'b0          ;    // 字地址位控制参数(16b/8b)
parameter   CLK_FREQ   = 26'd50_000_000;    // i2c_dri模块的驱动时钟频率(CLK_FREQ)
parameter   I2C_FREQ   = 18'd250_000   ;    // I2C的SCL时钟频率

//wire define
wire        clk_i2c   ;                     // i2c的操作时钟
wire        i2c_exec  ;                     // i2c触发控制
wire        i2c_done  ;                     // i2c操作结束标志
wire [15:0] reg_data  ;                     // WM8978需要配置的寄存器（地址及数据）

//*****************************************************
//**                    main code
//*****************************************************

//配置WM8978的寄存器
i2c_reg_cfg #(
    .WL             (WL       )             // word length音频字长参数设置
) u_i2c_reg_cfg(  
    .clk            (clk_i2c  ),            // i2c_reg_cfg驱动时钟
    .rst_n          (rst_n    ),            // 复位信号
  
    .i2c_exec       (i2c_exec ),            // I2C触发执行信号
    .i2c_data       (reg_data ),            // 寄存器数据（7位地址+9位数据）
    
    .i2c_done       (i2c_done ),            // I2C一次操作完成的标志信号            
    .cfg_done       (cfg_done )             // WM8978配置完成
);

//调用IIC协议
i2c_dri #(
    .SLAVE_ADDR     (SLAVE_ADDR),           // slave address从机地址，放此处方便参数传递
    .CLK_FREQ       (CLK_FREQ  ),           // i2c_dri模块的驱动时钟频率(CLK_FREQ)
    .I2C_FREQ       (I2C_FREQ  )            // I2C的SCL时钟频率
) u_i2c_dri(  
    .clk            (clk       ),           // i2c_dri模块的驱动时钟(CLK_FREQ)
    .rst_n          (rst_n     ),           // 复位信号
  
    .i2c_exec       (i2c_exec  ),           // I2C触发执行信号
    .bit_ctrl       (BIT_CTRL  ),           // 器件地址位控制(16b/8b)
    .i2c_rh_wl      (1'b0      ),           // I2C读写控制信号
    .i2c_addr       (reg_data[15:8]),       // I2C器件字地址
    .i2c_data_w     (reg_data[ 7:0]),       // I2C要写的数据
      
    .i2c_data_r     (),                     // I2C读出的数据
    .i2c_done       (i2c_done  ),           // I 2C一次操作完成
      
    .scl            (aud_scl   ),           // I2C的SCL时钟信号
    .sda            (aud_sda   ),           // I2C的SDA信号
    .dri_clk        (clk_i2c   )            // I2C操作时钟
);

endmodule 