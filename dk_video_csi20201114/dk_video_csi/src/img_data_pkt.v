
module img_data_pkt
  #(
    parameter  CMOS_H_PIXEL = 11'd640,       //CMOS水平方向像素个数
    parameter  CMOS_V_PIXEL = 11'd1440        //CMOS垂直方向像素个数
    )
    (
    input                 SW             ,   //启动开关

    input                 clk            ,   //时钟信号
    input                 aud_bclk       ,
    input                 rst_n          ,   //复位信号，低电平有效
    input        [15:0]   img_data       ,   //从sdram中读取的16位rgb565数据
    input                 udp_tx_req     ,   //udp发送数据请求信号
    input                 udp_tx_done    ,   //udp发送数据完成信号     
    input                 img_de, 
    input                 aud_rx_done    ,  //音频数据接收完成信号
    input        [31:0]   aud_adc_data   ,  //32位音频数据

    output       wire      img_vs         ,
                     
    output  reg           img_req        ,   //图像数据请求信号
    output  reg           udp_tx_start_en,   //udp开始发送信号
    output  reg  [31:0]   udp_tx_data    ,   //udp发送的数据
    output  reg  [15:0]   udp_tx_byte_num    //udp单包发送的有效字节数
    );

//parameter define
//图像帧头，用于标志一帧数据的开始
localparam  IMG_FRAME_HEAD = {32'hf0_5a_a5_0f};  
//以太网帧间隙，单位:时钟周期40ns，百兆以太网中要求帧间隙至少为960ns
//localparam  ETH_IFG = 16'd25;       
//localparam  ETH_IFG = 16'hff_ff;    
//localparam  ETH_IFG = 24'h40_ff_ff;  
localparam  ETH_IFG = 24'hff_ff;  
//图像数据帧间隙 时钟周期 40ns, 22'hf_ff_ff = 1048575; 1048575 * 40ns = 41.943ms
//在此处用于降低图像的发送帧率,因为上位机解析图像较慢,如果数据发送太快图像容易卡顿
//localparam  IMG_IFG = 22'hf_ff_ff;
//localparam  IMG_IFG = 32'h4f_ff_ff_ff;
localparam  IMG_IFG = 32'hf_ff_ff;
//localparam  IMG_IFG = 32'hff_ff_ff_ff;

//语音帧头，用于一包语音数据的开始
localparam  IMG_AUDIO_HEAD = {32'h0f_a5_5f_f0};  
//fifo缓存的数量大于等于此值时控制udp开始发送数据
localparam  AUDIO_TX_NUM = 9'd256;

wire    [9:0]   data_cnt;                  //fifo中缓存的个数
wire    [11:0]  img_cnt;

reg             udp_tx_flag ;              //udp正在发送数据的标志
reg             udp_tx_aud_flag;
reg             udp_tx_aud_start_en;
reg             udp_tx_aud_done;

//reg define
reg             img_ifg_done   ;  //图像帧间隙延时完成信号          
//reg    [21:0]   img_ifg_cnt    ;  //图像帧间隙延时计数器
//reg    [7:0]    eth_ifg_cnt    ;  //以太网数据帧间隙延时计数器
reg    [31:0]   img_ifg_cnt    ;  //图像帧间隙延时计数器
reg    [23:0]   eth_ifg_cnt    ;  //以太网数据帧间隙延时计数器

reg    [10:0]   img_h_cnt      ;  //图像水平像素计数器,用于控制img_req信号
reg    [10:0]   img_v_cnt      ;  //图像垂直像素计数器,用于添加帧头
reg             img_val_en     ;  //图像数据有效使能信号
reg             wr_sw          ;  //用于位拼接的标志
reg             wr_fifo_en     ;  //写fifo使能
reg    [31:0]   wr_fifo_data   ;  //写fifo数据
reg             head_flag      ;  //标志当前数据包是否需要添加帧头
reg    [15:0]   img_data_t     ;  //寄存16位图像数据，用于拼接成32位数据
reg             fifo_empty_d0  ;  //对fifo空信号进行打拍
 
reg    [31:0]   wr_fifo_aud_data ;
reg             wr_fifo_aud_en   ;


//wire define                  
wire            fifo_empty     ;  //fifo空信号
wire            neg_fifo_empty ;  //fifo空信号的下降沿

//*****************************************************
//**                    main code
//*****************************************************
//==============================================================================

//assign  Pout_vs_w =  ~((V_cnt>=16'd0) & (V_cnt<=(I_v_sync-1'b1))
//assign  img_vs =  ~(((img_v_cnt == CMOS_V_PIXEL - 1'b1) && (img_ifg_cnt <= 3'd5)) || ((img_v_cnt == 1'b0) && (img_h_cnt == 1'b0) && (eth_ifg_cnt <= ETH_IFG-3'd5)));  
//assign  img_vs =  ~((img_v_cnt == CMOS_V_PIXEL - 1'b1) && (img_ifg_cnt <= 4'd10)); 

assign  img_vs =  ~((img_ifg_cnt <= 4'd10) && (img_ifg_cnt >= 4'd2)); 

//assign  udp_tx_aud_byte_num = {AUDIO_TX_NUM,2'd0};  

reg     [15:0]      udp_tx_byte_num_img;
reg     [8:0]       udp_tx_byte_num_aud;
reg                 udp_tx_start_en_img;
reg                 udp_tx_start_en_aud;
reg                 udp_tx_req_img;
reg                 udp_tx_req_aud;
reg                 udp_tx_done_img;
reg                 udp_tx_done_aud;
reg     [31:0]      udp_tx_data_img;
reg     [31:0]      udp_tx_data_aud;
reg                 skip_en;
reg                 skip_en1;


parameter   IDLE     = 3'b100;
parameter   AUD      = 3'b010;
parameter   IMG      = 3'b001;

reg [2:0]   current_state;
reg [2:0]   next_state;

//assign udp_tx_byte_num = (current_state == IMG) ? udp_tx_byte_num_img : udp_tx_byte_num_aud;
//assign udp_tx_start_en = (current_state == IMG) ? udp_tx_start_en_img : udp_tx_start_en_aud;
assign udp_tx_req_img  = (current_state == IMG) ? udp_tx_req : 1'b0;
assign udp_tx_req_aud  = (current_state == AUD) ? udp_tx_req : 1'b0;
assign udp_tx_done_img = (current_state == IMG) ? udp_tx_done : 1'b0;
assign udp_tx_done_aud = (current_state == AUD) ? udp_tx_done : 1'b0;
assign udp_tx_data = (current_state == IMG) ? udp_tx_data_img : udp_tx_data_aud;
assign udp_tx_byte_num_img = head_flag ? ({CMOS_H_PIXEL,1'b0} + 16'd4) : {CMOS_H_PIXEL,1'b0};

//localparam  FRE_NUM = 21'd1250000;
reg             en;     //使能信号
//reg     [20:0]  cnt;    
//reg             fre;    //启动频次
//reg             signal_A;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
       en <= 1'b0;
    else if(SW)
       en <= 1'b1;
    else
       en <= 1'b0;
end

//always @(posedge clk or negedge rst_n) begin
//    if(!rst_n)
//       cnt <= 'd0;
//    else if(cnt >= FRE_NUM)
//       cnt <= 'd0;
//    else 
//       cnt <= cnt + 1'b1;
//end

//always @(posedge clk or negedge rst_n) begin
//    if(!rst_n)
//       fre <= 1'b0;
//    else if(cnt == FRE_NUM - 1'b1)
//       fre <= 1'b1;
//    else 
//       fre <= 1'b0;
//end

//always @(posedge clk or negedge rst_n) begin
//    if(!rst_n)
//       signal_A <= 1'b0;
//    else if(fre && en)
//       signal_A <= 1'b1;
//    else 
//       signal_A <= 1'b0;
//end

//fifo空信号打拍，用于采沿
always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        fifo_empty_d0 <= 1'b1;
    else
        fifo_empty_d0 <= fifo_empty;        
end

//采fifo空信号的下降沿，当fifo_empty信号由高电平变为低电平时，说明fifo中已经有数据
assign  neg_fifo_empty = fifo_empty_d0 & (~fifo_empty);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        current_state <= 3'b0;
    else
        current_state <= next_state;
end

always @(*) begin
    case (current_state)
        IDLE: begin

            if(skip_en)
                next_state = IMG;
            else  if(skip_en1)
                next_state = AUD;
            else
                next_state = IDLE;
/*

            if(en & (data_cnt >= AUDIO_TX_NUM))
                next_state = AUD;
            else begin
                if(img_cnt >= 350)
                    next_state = IMG;
                else    
                   next_state = IDLE; 
            end

*/
        end
        AUD: begin
            if(skip_en)
                next_state = IDLE;
            else
                next_state = AUD;
        end
        IMG: begin
            if(skip_en)
                next_state = IDLE;
            else
                next_state = IMG;
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        skip_en <= 1'b0;
        skip_en1 <= 1'b0;
        udp_tx_start_en <= 1'b0;
        udp_tx_byte_num <= 'd0;
        udp_tx_flag <= 1'b0;
    end
    else begin
        skip_en <= 1'b0;
        skip_en1 <= 1'b0;
        udp_tx_start_en <= 1'b0;
        case(next_state)
            IDLE: begin
                if(en & (data_cnt >= AUDIO_TX_NUM))
                    skip_en1 <= 1'b1;
                else  if(img_cnt >= 170)
                    skip_en <= 1'b1;
            end
            AUD: begin
                udp_tx_start_en  <= 1'b0;
                if(udp_tx_flag == 1'b0)begin
                    if(data_cnt >= AUDIO_TX_NUM) begin
                        udp_tx_byte_num <= {AUDIO_TX_NUM,2'd0};
                        udp_tx_start_en <=1'b1;
                        udp_tx_flag <= 1'b1;
                    end
                end
                else if(udp_tx_done)begin
                        skip_en <= 1'b1;
                        udp_tx_flag <= 1'b0;
                end
            end
            IMG: begin  
                
/*
                if(fifo_empty_d0 & (~fifo_empty))begin        
                    udp_tx_start_en <= 1'b1;
                    udp_tx_byte_num <= udp_tx_byte_num_img;
                end
                else begin
                    udp_tx_start_en  <= 1'b0;
                    if(udp_tx_done)begin
                        skip_en <= 1'b1;
                    end
                end
*/
                udp_tx_start_en  <= 1'b0;
                if(udp_tx_flag == 1'b0)begin        
                    udp_tx_start_en <= 1'b1;
                    udp_tx_byte_num <= udp_tx_byte_num_img;
                    udp_tx_flag <= 1'b1;
                end
                else begin
 //                    if(udp_tx_done)begin
                        udp_tx_start_en  <= 1'b0;
                        if(udp_tx_done)begin
                            skip_en <= 1'b1;
                            udp_tx_flag <= 1'b0;
                        end
 //                   end
                end


            end
            default : ;
        endcase
    end
end

//控制图像帧间隙延时计数
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        img_ifg_done <= 1'b0;
        img_ifg_cnt <= 32'd0;
    end
    else begin
        img_ifg_done <= 1'b0;
        if(udp_tx_done_img) begin
            if(img_v_cnt == CMOS_V_PIXEL - 1'b1)            //    CMOS_V_PIXEL = 11'd1440        //CMOS垂直方向像素个数
                //最后一行图像数据发送完成，延时计数器赋值
                img_ifg_cnt <= IMG_IFG;                     //IMG_IFG = 32'h1f_ff_ff_ff;
            else
                //非最后一行图像数据发送完成
                img_ifg_done <= 1'b1;       
        end    
        else if(img_ifg_cnt !=32'd0 ) begin                 //增加一个img_ifg_cnt计数延时   IMG_IFG = 32'h1f_ff_ff_ff;
            img_ifg_cnt <= img_ifg_cnt - 1'd1;
            if(img_ifg_cnt == 1'b1)
                img_ifg_done <= 1'b1;  
        end    
    end
end            

//控制以太网帧间隙
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        eth_ifg_cnt <= 24'd0;
    else if(img_ifg_done)
        eth_ifg_cnt <= 24'd0;
    else if(eth_ifg_cnt <= ETH_IFG - 1'b1)                //正常UDP包之间的延时   ETH_IFG = 16'hff_ff; 
        eth_ifg_cnt <= eth_ifg_cnt + 1'b1;                //加到FF FF时停止
end

//图像水平像素计数器,用于控制img_req信号,一次请求一行数据
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        img_h_cnt <= 11'b0;
    else if(img_h_cnt == 11'd0) begin
        if(eth_ifg_cnt == ETH_IFG - 1'b1)                //正常延时到
            img_h_cnt <= CMOS_H_PIXEL;                   //CMOS_H_PIXEL = 11'd640,       //CMOS水平方向像素个数
    end
    else
        img_h_cnt <= img_h_cnt - 11'b1;
end

//图像垂直像素计数器,用于添加帧头
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        img_v_cnt <= 11'b0;
    else if(udp_tx_done_img) begin                        //每完成一个UDP包，包数量加1
        img_v_cnt <= img_v_cnt + 11'd1;
        if(img_v_cnt == CMOS_V_PIXEL - 1'b1)              //CMOS_V_PIXEL = 11'd1440 
            img_v_cnt <= 11'd0;                           //包数量置0
    end        
end

//图像请求信号,用于读取SDRAM控制模块的读使能信号
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        img_req <= 1'b0;
    else if(img_h_cnt!=11'd0)                             //如果img_h_cnt >=1  req就为1
        img_req <= 1'b1;
    else
        img_req <= 1'b0;    
end

//sdram数据有效标志
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        img_val_en <= 1'b0;
    else
        img_val_en <= img_de;
end            

//图像数据有效之后,向fifo中写入数据
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wr_fifo_en <= 1'b0;
        wr_fifo_data <= 32'b0;
        img_data_t <= 16'd0;
        wr_sw <= 1'b0;
        head_flag <= 1'b0;
    end
    else begin
        if(img_de) begin                 ///img_val_en
            wr_sw <= ~wr_sw;
            if(wr_sw==1'b0) begin
                img_data_t <= img_data;
                //head_flag = 0，像fifo中写入帧头
                if(img_v_cnt == 11'd0 && head_flag == 1'b0) begin
                    wr_fifo_en <= 1'b1;
                    wr_fifo_data <= IMG_FRAME_HEAD;
                    head_flag <= 1'b1; 
                end
                else    
                    wr_fifo_en <= 1'b0;
            end    
            else begin
                //16位数据转32位数据，将32位数据写入fifo
                wr_fifo_en <= 1'b1;
                wr_fifo_data <= {img_data_t,img_data};
            end    
        end    
        else begin
            wr_fifo_en <= 1'b0;
            wr_fifo_data <= 32'b0;
            wr_sw <= 1'b0;    
            head_flag <= 1'b0;     
        end
    end    
end        

/*
//采到fifo信号的下降沿之后,说明fifo中已经有数据,此时开始通知udp模块发送数据
//因为写入速度大于读出速度，在一行数据写完之前,不会出现fifo读空的情况
always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        udp_tx_start_en <= 1'b0;
        udp_tx_byte_num <= 16'd0;
    end        
    else begin
         if(neg_fifo_empty) begin
            udp_tx_start_en <= 1'b1;
            if(head_flag == 1'b0) 
                //发送的字节数 = 行像素数（rgb565）*2
                udp_tx_byte_num <= {CMOS_H_PIXEL,1'b0};             
            else
                //发送的字节数 = 行像素数（rgb565）*2 + 4(帧头)
                udp_tx_byte_num <= {CMOS_H_PIXEL,1'b0} + 16'd4;     
        end    
        else
            udp_tx_start_en <= 1'b0;
    end
end
*/

sync_fifo_2048x32b  sync_fifo_2048x32b_inst (
    .Clk(clk),
    .Reset(~rst_n),
    .WrEn(wr_fifo_en),
    .RdEn(udp_tx_req_img),
    .Data(wr_fifo_data),
    .Full(),
    .Empty(fifo_empty),
    .Wnum(img_cnt),
    .Q(udp_tx_data_img)
);

/*
//判断fifo中缓存的个数，超过预设值控制udp开始发送数据
always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        udp_tx_flag <= 1'b0;
        udp_tx_start_en <= 1'b0;
    end
    else begin
        udp_tx_start_en <= 1'b0;
        //只有当udp没有发送数据时才判断fifo大小是否满足发送条件
        if(udp_tx_flag == 1'b0) begin      
            if(data_cnt >= AUDIO_TX_NUM) begin
                udp_tx_flag <= 1'b1;
                udp_tx_start_en <= 1'b1;       //udp开始发送信号
            end    
        end        
        else if(udp_tx_done)                   //udp发送完成后,将udp发送标志清零
           udp_tx_flag <= 1'b0;              
    end        
end    
*/
//reg [31:0] adc_data;
//always @(posedge aud_bclk or negedge rst_n) begin
//    if(rst_n == 1'b0)
//        adc_data <= 32'd0;
//    else if(aud_rx_done)
//        adc_data <= adc_data +1'b1;
//end

async_fifo_512x32b  async_fifo_512x32b_inst (
    .RdClk(clk),
    .WrClk(aud_bclk),
    .Reset(~rst_n),
    .WrEn(aud_rx_done),
    .RdEn(udp_tx_req_aud),
    .Data(aud_adc_data),
//    .Data(adc_data),
    .Empty(),
    .Full(),
    .Wnum(data_cnt),
    .Rnum(),
    .Q(udp_tx_data_aud)
);

endmodule