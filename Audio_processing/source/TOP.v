//Author:wyx
//Times :2024.4.16

module TOP#(
    parameter H_DISP    = 24'd1920  , // 行有效数据
    parameter V_DISP    = 24'd1080  , // 场有效数据
    parameter CAM_H_PIXEL           = 24'd960       , // 摄像头水平方向像素个数
    parameter CAM_V_PIXEL           = 24'd540       , // 摄像头垂直方向像素个数
    parameter HDMI_H_PIXEL          = 24'd960       , // 摄像头水平方向像素个数
    parameter HDMI_V_PIXEL          = 24'd540       , // 摄像头垂直方向像素个数
    parameter video_o_h             = 'd960    ,
    parameter MEM_H_PIXEL           = 'd960    ,
    parameter MEM_V_PIXEL           = 'd540   ,

    parameter CAM_DATA_WIDTH        = 16            ,
    parameter HDMI_DATA_WIDTH       = 24            ,
    parameter ETH_DATA_WIDTH        = 32            ,
    parameter FIFO_DATA_WIDTH       = 32            ,
    parameter MEM_ROW_WIDTH         = 15            ,
    parameter MEM_COL_WIDTH         = 10            ,
    parameter MEM_BANK_WIDTH        = 3             ,
    parameter MEM_DQ_WIDTH          = 32            ,
    parameter MEM_DM_WIDTH          = MEM_DQ_WIDTH/8,
    parameter MEM_DQS_WIDTH         = MEM_DQ_WIDTH/8,
    parameter MEM_BURST_LEN         = 8             ,
    parameter AXI_WRITE_BURST_LEN   = 8            , // 写突发传输长度，支持（1,2,4,8,16）
    parameter AXI_READ_BURST_LEN    = 8           , // 读突发传输长度，支持（1,2,4,8,16）
    parameter AXI_ID_WIDTH          = 4             ,
    parameter AXI_USER_WIDTH        = 1             

)
(
    input wire        sys_clk         ,//50MHz
    input             key_rstn             /*synthesis PAP_MARK_DEBUG="1"*/,
//ES7243E  ADC  in
    output            es7243_scl      ,//CCLK
    inout             es7243_sda      ,//CDATA
    output            es0_mclk        ,//MCLK  clk_12M
    input             es0_sdin        ,//SDOUT i2s数据输入             i2s_sdin
    input             es0_dsclk       ,//SCLK  i2s数据时钟             i2s_sck   
    input             es0_alrck       ,//LRCK  i2s数据左右信道帧时钟     i2s_ws
//ES8156  DAC   out
    output            es8156_scl      ,//CCLK
    inout             es8156_sda      ,//CDATA 
    output            es1_mclk        ,//MCLK  clk_12M
    input             es1_sdin        ,//SDOUT 回放信号反馈？
    output            es1_sdout       ,//SDIN  DAC i2s数据输出          i2s_sdout
    input             es1_dsclk       ,//SCLK  i2s数据位时钟            i2s_sck
    input             es1_dlrc        ,//LRCK  i2s数据左右信道帧时钟      i2s_ws
//  
    input             lin_test,//麦克风插入检测
    input             lout_test,//扬声器检测
    
    //ES7243E  ADC2  in
    output wire      adc2_es7243_scl      ,//CCLK
    inout  wire      adc2_es7243_sda      ,//CDATA

    output wire      adc2_es0_mclk        ,//MCLK  clk_12M
    input  wire      adc2_es0_sdin        ,//SDOUT i2s数据输入             i2s_sdin
    input  wire      adc2_es0_dsclk       ,//SCLK  i2s数据时钟             i2s_sck   
    input  wire      adc2_es0_alrck       ,//LRCK  i2s数据左右信道帧时钟     i2s_ws


    //ES8156  DAC2   out
    output wire      dac2_es8156_scl      /*synthesis PAP_MARK_DEBUG="1"*/,//CCLK
    inout  wire      dac2_es8156_sda      /*synthesis PAP_MARK_DEBUG="1"*/,//CDATA 

    output wire      dac2_es1_mclk        /*synthesis PAP_MARK_DEBUG="1"*/,//MCLK  clk_12M
    input  wire      dac2_es1_sdin        /*synthesis PAP_MARK_DEBUG="1"*/,//SDOUT 回放信号反馈？
    output wire      dac2_es1_sdout       /*synthesis PAP_MARK_DEBUG="1"*/,//SDIN  DAC i2s数据输出          i2s_sdout
    input  wire      dac2_es1_dsclk       /*synthesis PAP_MARK_DEBUG="1"*/,//SCLK  i2s数据位时钟            i2s_sck
    input  wire      dac2_es1_dlrc        /*synthesis PAP_MARK_DEBUG="1"*/,//LRCK  i2s数据左右信道帧时钟      i2s_ws









    //按键
    input [6:0]       key_on  ,

    //LED
    output wire[7:0]      led    ,


    // HDMI 接口
    output  wire            hdmi_rst_n      , // HDMI输出芯片复位
    
    output  wire            hdmi_rx_scl     , // HDMI输入芯片SCL信号
    inout   wire            hdmi_rx_sda     , // HDMI输入芯片SDA信号
    input   wire            hdmi_rx_pix_clk /*synthesis PAP_MARK_DEBUG="1"*/, // HDMI输入芯片时钟
    input   wire            hdmi_rx_vs      /*synthesis PAP_MARK_DEBUG="1"*/, // HDMI输入场同步信号
    input   wire            hdmi_rx_hs      /*synthesis PAP_MARK_DEBUG="1"*/, // HDMI输入行同步信号
    input   wire            hdmi_rx_de     /*synthesis PAP_MARK_DEBUG="1"*/ , // HDMI输入数据有效信号
    input   wire    [23:0]  hdmi_rx_data   /*synthesis PAP_MARK_DEBUG="1"*/ , // HDMI输入数据
    
    output  wire            hdmi_tx_scl     , // HDMI输出芯片SCL信号
    inout   wire            hdmi_tx_sda     , // HDMI输出芯片SDA信号
    output  wire            hdmi_tx_pix_clk , // HDMI输出芯片时钟
    output  wire             hdmi_tx_vs    /*synthesis PAP_MARK_DEBUG="1"*/ , /*synthesis PAP_MARK_DEBUG="1"*/ // HDMI输出场同步信号


    output  wire             hdmi_tx_hs     /*synthesis PAP_MARK_DEBUG="1"*/ , // HDMI输出行同步信号
    output  wire             hdmi_tx_de     /*synthesis PAP_MARK_DEBUG="1"*/ , // HDMI输出数据有效信号
    output  wire     [23:0]  hdmi_tx_data    /*synthesis PAP_MARK_DEBUG="1"*/, // HDMI输出数据
//
////DDR3
//    output                                  mem_rst_n       ,
//    output                                  mem_ck          ,
//    output                                  mem_ck_n        ,
//    output                                  mem_cke         ,
//    output                                  mem_cs_n        ,
//    output                                  mem_ras_n       ,
//    output                                  mem_cas_n       ,
//    output                                  mem_we_n        ,
//    output                                  mem_odt         ,
//    output      [MEM_ROW_WIDTH-1:0]         mem_a           ,
//    output      [MEM_BANK_WIDTH-1:0]        mem_ba          ,
//    inout       [MEM_DQS_WIDTH-1:0]         mem_dqs         ,
//    inout       [MEM_DQS_WIDTH-1:0]         mem_dqs_n       ,
//    inout       [MEM_DQ_WIDTH-1:0]          mem_dq          ,
//    output      [MEM_DM_WIDTH-1:0]          mem_dm          ,


    //PCIE
    input  wire          pcie_perst_n      , //PCIE复位引脚
    //PCIE LED signals
    output  wire                smlh_link_up    ,//led 7 8
    output  wire                rdlh_link_up    ,
    output  reg                 ref_led         ,
    output  reg                 pclk_led        ,
    output  reg                 pclk_div2_led    
   );
//wire                rdlh_link_up;
//wire                smlh_link_up    ;
wire               locked       ;
wire               pll_lock       ;
wire               pll_lock1       ;
wire               rstn_out     ;
wire               es7243_init  ;
wire               es8156_init  ;
wire               es7243_init2  ;
wire               es8156_init2  ;
wire               clk_12M      ;
wire               hdmi_tx_pix_clk/*synthesis PAP_MARK_DEBUG="1"*/;
wire               cfg_clk    ;

wire [15:0]        rx_data/*synthesis PAP_MARK_DEBUG="1"*/;
wire [15:0]        rx_data2/*synthesis PAP_MARK_DEBUG="1"*/;
wire [15:0]        ldata/*synthesis PAP_MARK_DEBUG="1"*/;
wire [15:0]        rdata/*synthesis PAP_MARK_DEBUG="1"*/;
wire [15:0]        ldata_lms/*synthesis PAP_MARK_DEBUG="1"*/;
wire [15:0]        rdata_lms/*synthesis PAP_MARK_DEBUG="1"*/;
wire [15:0]        ldata2/*synthesis PAP_MARK_DEBUG="1"*/;
wire [15:0]        rdata2/*synthesis PAP_MARK_DEBUG="1"*/;
wire               rx_l_vld/*synthesis PAP_MARK_DEBUG="1"*/;
wire               rx_r_vld/*synthesis PAP_MARK_DEBUG="1"*/;
wire               rx_l_vld2/*synthesis PAP_MARK_DEBUG="1"*/;
wire               rx_r_vld2/*synthesis PAP_MARK_DEBUG="1"*/;
wire               hdmi_tx_vs_temp ; // HDMI输出场同步信号
wire               hdmi_tx_hs_temp ; // HDMI输出行同步信号
wire               hdmi_tx_de_temp ; // HDMI输出数据有效信号
wire    [23:0]     hdmi_tx_data_temp; // HDMI输出数据
wire               hdmi_tx_init   /*synthesis PAP_MARK_DEBUG="1"*/ ;
wire               hdmi_rx_init    ;

wire    [32-1:0]   fifo_rd_data    /*synthesis PAP_MARK_DEBUG="1"*/ ;
wire    [24-1:0]   pix_data        /*synthesis PAP_MARK_DEBUG="1"*/;
//fft to hdmi
wire               fft_finish   ;
wire [63:0]        fft_data     ;
wire [11:0]         fft_addr     ;
wire               ddr_fft_en   ;
wire               ddr_rst   ;
wire [31:0]        fft_ddr_data ;
assign pix_data         = fifo_rd_data[24-1:0];
PLL u_pll (
      .clkin1       (sys_clk   ),   // input//50MHz
      .pll_lock     (locked    ),   // output
      .clkout0      (clk_12M   )    // output//12.288MHz
); 

pll_hdmi u_pll_hdmi (
  .clkin1(sys_clk),        // input
  .pll_lock(pll_lock),    // output
  .clkout0(hdmi_tx_pix_clk),      // output
  .clkout1(cfg_clk)       // output
);

//PLL2 PLL_5M (
//  .clkin1(sys_clk),        // input
//  .pll_lock(pll_lock1),    // output
//  .clkout0(clk_50M),      // output
//  .clkout1(clk_5M)       // output
//);
/**************************按键切换功能*****************************************************/  //1
wire [6:0] key_on_1;
key u_key_1(
.clk     (sys_clk),  
.key     (key_on),
.key_on  (key_on_1)
);


reg  fuct;
wire fir;
wire vocie_change_en;//音调转换
wire lms;//回声消除
wire HPSS_en;//音频分离
reg [9:0]f_set;
reg [9:0]f_original;
always @(posedge sys_clk)
begin
	if(!key_rstn)begin
	    fuct <= 'd0;
    end
	else if(key_on_1[0]) begin
	    fuct <= ~fuct;
	end
	else begin
	    fuct <= fuct;
	end
end

assign vocie_change_en=(fuct)?'d1:'d0;


always @(posedge sys_clk)
begin
	if(!key_rstn)begin
        f_set      <='d160;
        f_original <='d160;
    end
	else if(vocie_change_en) begin//男声
	    if(key_on_1[1])begin
                f_set      <='d160;
                f_original <='d240;
        end
	    if(key_on_1[2])begin//女生
                f_set      <='d240;
                f_original <='d160;
        end
	    if(key_on_1[3])begin//童声
                f_set      <='d400;
                f_original <='d160;
        end
	    if(key_on_1[4])begin//
                f_set      <='d90;
                f_original <='d240;
        end
	    if(key_on_1[5])begin//
                f_set      <=f_set+'d10;
        end
	    if(key_on_1[6])begin//
                f_original      <=f_original-'d10;
        end
//    	if(key_on_1[5])begin//
//                f_original      <=f_original+'d10;
//        end        
	end
end






wire [15:0]        rx_data_1;


wire [15:0]voice_data_out;
assign rx_data_1=(vocie_change_en)?voice_data_out:rx_data;
                


//always@(*)
//begin
//    case(fuct)
//        'd2:begin
//               rx_data_1<=tx_fir_data;
//        end
//        'd1:begin
//               rx_data_1<=voice_data_out;
//        end
//        'd0:begin//lms
//               rx_data_1<=rx_data;
//        end
////        'd3:
//        default:begin
//               rx_data_1<=rx_data;
//        end
//    endcase
//end



//assign rx_data2_1=(fuct=='d0)?voice_data_Echo_cancellation_out:rx_data;











/*******************************************************************************/  //1
/*******************************************************************************/  //1

//wire [15:0] rx_data_1;
//wire [15:0] tx_fir_data;
//wire [15:0]voice_data_out;
//wire [15:0]voice_data_Echo_cancellation_out;
//assign rx_data_1=(fir)?tx_fir_data:voice_data_out;

wire adc_dac_int;
wire adc_dac_int2;
assign es0_mclk    =    clk_12M;
assign es1_mclk    =    clk_12M;
//assign led[0]=lin_test?1'b0:1'b1;
//assign led[1]=lout_test?1'b0:1'b1;

reg  [19:0]                 rstn_1ms            /*synthesis PAP_MARK_DEBUG="1"*/;
    always @(posedge clk_12M)
    begin
    	if(!locked|!key_rstn)
    	    rstn_1ms <= 20'h0;
    	else
    	begin
    		if(rstn_1ms == 20'h50000)
    		    rstn_1ms <= rstn_1ms;
    		else
    		    rstn_1ms <= rstn_1ms + 1'b1;
    	end
    end
    
assign rstn_out = (rstn_1ms == 20'h50000);

ES7243E_reg_config	ES7243E_reg_config(
    	.clk_12M                 (clk_12M           ),//input
    	.rstn                    (rstn_out          ),//input	
    	.i2c_sclk                (es7243_scl        ),//output
    	.i2c_sdat                (es7243_sda        ),//inout
    	.reg_conf_done           (es7243_init       ),//output config_finished
        .clock_i2c               (clock_i2c)
    );
ES8156_reg_config	ES8156_reg_config(
    	.clk_12M                 (clk_12M           ),//input
    	.rstn                    (rstn_out          ),//input	
    	.i2c_sclk                (es8156_scl        ),//output
    	.i2c_sdat                (es8156_sda        ),//inout
    	.reg_conf_done           (es8156_init       )//output config_finished
    );
assign adc_dac_int = es7243_init&&es8156_init;

//ES7243E
pgr_i2s_rx#(
    .DATA_WIDTH(16)
)ES7243_i2s_rx(
    .rst_n          (es7243_init      ),// input

    .sck            (es0_dsclk        ),// input
    .ws             (es0_alrck        ),// input
    .sda            (es0_sdin         ),// input

    .data           (rx_data          ),// output[15:0]
    .l_vld          (rx_l_vld         ),// output
    .r_vld          (rx_r_vld         ) // output
);
wire       rcv_done/*synthesis PAP_MARK_DEBUG="1"*/;
assign rcv_done = rx_l_vld | rx_r_vld;
//ES8156

pgr_i2s_tx#(
    .DATA_WIDTH(16)
)ES8156_i2s_tx(
    .rst_n          (es8156_init    ),// input

    .sck            (es1_dsclk      ),// input  //SCLK  i2s数据位时钟  
    .ws             (es1_dlrc       ),// input  //LRCK  i2s数据左右信道帧时钟 
    .sda            (es1_sdout      ),// output //SDIN  DAC i2s数据输出

    .ldata          (     ldata     ),// input[15:0] ldata
    .l_req          (               ),// output
    .rdata          (    rdata      ),// input[15:0] rdata
    .r_req          (               ) // output
);

i2s_loop#(
    .DATA_WIDTH(16)
)i2s_loop(
    .rst_n          (adc_dac_int),// input
    .sck            (es0_dsclk  ),// input
    .ldata          (ldata      ),// output[15:0]
    .rdata          (rdata      ),// output[15:0]
    .data           (rx_data_1    ),// input[15:0] rx_data_32_out rx_data_1 voice_data_Echo_cancellation_out
    .r_vld          (rx_r_vld   ),// input
    .l_vld          (rx_l_vld   ) // inputrcv_done
);


/*******************************************************************************/


/*****************************************************************************2**/


assign adc2_es0_mclk    =    clk_12M;
assign dac2_es1_mclk    =    clk_12M;
ES7243E_reg_config	ES7243E_reg_config2(
    	.clk_12M                 (clk_12M           ),//input
    	.rstn                    (rstn_out          ),//input	
    	.i2c_sclk                (adc2_es7243_scl        ),//output
    	.i2c_sdat                (adc2_es7243_sda        ),//inout
    	.reg_conf_done           (es7243_init2       ),//output config_finished
        .clock_i2c               (clock_i2c)
    );
ES8156_reg_config	ES8156_reg_config2(
    	.clk_12M                 (clk_12M           ),//input
    	.rstn                    (rstn_out          ),//input	
    	.i2c_sclk                (dac2_es8156_scl        ),//output
    	.i2c_sdat                (dac2_es8156_sda        ),//inout
    	.reg_conf_done           (es8156_init2       )//output config_finished
    );
assign adc_dac_int2 = es8156_init2;



pgr_i2s_rx#(
    .DATA_WIDTH(16)
)ES7243_ADC2_i2s_rx(
    .rst_n          (es7243_init2 ),// input

    .sck            (adc2_es0_dsclk   ),// input
    .ws             (adc2_es0_alrck   ),// input
    .sda            (adc2_es0_sdin    ),// input

    .data           (rx_data2          ),// output[15:0]
    .l_vld          (rx_l_vld2        ),// output
    .r_vld          (rx_r_vld2         ) // output
);

//ES8156
pgr_i2s_tx#(
    .DATA_WIDTH(16)
)ES8156_dac2_i2s_tx(
    .rst_n          (es8156_init2    ),// input

    .sck            (dac2_es1_dsclk      ),// input  //SCLK  i2s数据位时钟  
    .ws             (dac2_es1_dlrc       ),// input  //LRCK  i2s数据左右信道帧时钟 
    .sda            (dac2_es1_sdout      ),// output //SDIN  DAC i2s数据输出

    .ldata          (rx_data          ),// input[15:0]
    .l_req          (          ),// output
    .rdata          (rx_data          ),// input[15:0]
    .r_req          (          ) // output
);
i2s_loop#(
    .DATA_WIDTH(16)
)i2s_loop2(
    .rst_n          (adc_dac_int),// input
    .sck            (adc2_es0_dsclk  ),// input
    .ldata          (ldata2      ),// output[15:0]
    .rdata          (rdata2      ),// output[15:0]
    .data           (  voice_data_out_HPSS   ),// input[15:0] rx_data_32_out  voice_data_Echo_cancellation_out rx_data2
    .r_vld          (rx_r_vld2   ),// input
    .l_vld          (rx_l_vld2   ) // inputrcv_done
);
/*******************************************************************************/



/*******************************************************************************///FIR

	denosising inst_denosising
		(
			.sys_clk     (sys_clk),
			.rst_n       (key_rstn||fir),
			.es7243_init (es7243_init),
			.es0_dsclk   (es0_dsclk),
			.rcv_done    (rx_r_vld|rx_l_vld),
			.rx_data     (rx_data),
			.es1_dsclk   (es1_dsclk),
			.send_done   (rx_r_vld|rx_l_vld),
			.FIR_out (tx_fir_data)
		);

/*******************************************************************************/









//wire start ;
//wire [31:0] rx_data_32;
//wire [31:0] rx_data_32_out;
//wire [15:0] rx_data_16_out;
//assign rx_data_16_out=rx_data_32_out[15:0];
//assign rx_data_32={16'd0,rdata_lms};
//DDR3_interface_top #(
//    .FIFO_DATA_WIDTH        (FIFO_DATA_WIDTH    ), // FIFO 用户端数据位宽
//    .CAM_H_PIXEL            (CAM_H_PIXEL        ), // CAMERA 行像素
//    .CAM_V_PIXEL            (CAM_V_PIXEL        ), // CAMERA 列像素
//    .HDMI_H_PIXEL           (HDMI_H_PIXEL       ), // HDMI 行像素
//    .HDMI_V_PIXEL           (HDMI_V_PIXEL       ), // HDMI 列像素
//    .DISP_H                 (H_DISP             ), // 显示的行像素
//    .DISP_V                 (V_DISP             ), // 显示的列像素
//    .video_o_h              (video_o_h)  ,  // 读出每个画面一帧数据行像素      写fifo
//    .MEM_H_PIXEL            (MEM_H_PIXEL),  // 每一个视频源显示时的行像素 写fifo ddr3地址范围
//    .MEM_V_PIXEL            (MEM_V_PIXEL),  // 每一个视频源显示时的列像素
//
//    .MEM_ROW_WIDTH          (MEM_ROW_WIDTH      ), // DDR 行地址位宽
//    .MEM_COL_WIDTH          (MEM_COL_WIDTH      ), // DDR 列地址位宽
//    .MEM_BANK_WIDTH         (MEM_BANK_WIDTH     ), // DDR BANK地址位宽
//    .MEM_BURST_LEN          (MEM_BURST_LEN      ), // DDR 突发传输长度
//    
//    .AXI_WRITE_BURST_LEN    (AXI_WRITE_BURST_LEN), // 写突发传输长度，支持（1,2,4,8,16）
//    .AXI_READ_BURST_LEN     (AXI_READ_BURST_LEN ), // 读突发传输长度，支持（1,2,4,8,16）
//    .AXI_ID_WIDTH           (AXI_ID_WIDTH       ), // AXI ID位宽
//    .AXI_USER_WIDTH         (AXI_USER_WIDTH     )  // AXI USER位宽
//)u_DDR3_interface_top(
//    .sys_clk                (sys_clk            ), // input
//    .key_rst_n              (   key_rstn      ), // input
//    .ddr_init_done          (ddr_init_done      ), // output
//
//    .video0_wr_clk          (), // input
//    .video0_wr_en           (), // input
//    .video0_wr_data         (), // input
//    .video0_wr_rst          ( ), // input
//                              
//    .video1_wr_clk          (  ), // input
//    .video1_wr_en           ( ), // input
//    .video1_wr_data         (  ), // input
//    .video1_wr_rst          ( ), // input
//                              
//    .video2_wr_clk          (  ), // input
//    .video2_wr_en           (  ), // input
//    .video2_wr_data         (  ), // input
//    .video2_wr_rst          (  ), // input
//                              
//    .video3_wr_clk          (  ), // input
//    .video3_wr_en           (  ), // input
//    .video3_wr_data         (  ), // input
//    .video3_wr_rst          (  ), // input
//
//
//    .fifo_rd_clk            (), // input
//    .fifo_rd_en             ( ) , // input
//    .fifo_rd_data           ( ), // output
//    .rd_rst                 ( ), // input
//
//    .fifo_rd1_clk           (    ), // input
//    .fifo_rd1_en            (    ),
//    .fifo_rd1_data          (     ),
//    .rd1_rst                (    ),
//   
//    .fifo_rd2_clk           (   ), // input           
//    .fifo_rd2_en            (   ),
//    .fifo_rd2_data          (   ),
//    .rd2_rst                (   ),
//               
//    .fifo_rd3_en            (   ),
//    .fifo_rd3_data          (   ),
//    .rd3_rst                (   ),
//    
//    .mem_rst_n              (mem_rst_n          ),
//    .mem_ck                 (mem_ck             ),
//    .mem_ck_n               (mem_ck_n           ),
//    .mem_cke                (mem_cke            ),
//    .mem_cs_n               (mem_cs_n           ),
//    .mem_ras_n              (mem_ras_n          ),
//    .mem_cas_n              (mem_cas_n          ),
//    .mem_we_n               (mem_we_n           ),
//    .mem_odt                (mem_odt            ),
//    .mem_a                  (mem_a              ),
//    .mem_ba                 (mem_ba             ),
//    .mem_dqs                (mem_dqs            ),
//    .mem_dqs_n              (mem_dqs_n          ),
//    .mem_dq                 (mem_dq             ),
//    .mem_dm                 (mem_dm             ),
//    
//    .fifo_video0_full       (fifo_video0_full   ),
//    .fifo_video1_full       (fifo_video1_full   ),
//    .fifo_o_full            (fifo_o_full        ),
//
//    //缩放分辨率
//    .vout_yres              (vout_yres_set),
//    .vout_xres              (vout_xres_set)
//
//);
//

//////////////////////////////////////////pcie
wire [15:0]pcie_data;
assign pcie_data=vocie_change_en?voice_data_out:rx_data;

PCIE u_pcie(
    .clk          (sys_clk),
    .pcie_perst_n (pcie_perst_n),
    .rst_board    (key_rstn), 

    
    .es0_dsclk    (es0_dsclk),
    .es7243_init  (es7243_init2),
    .rx_data      (pcie_data  ),
    .rx_r_vld     (rx_r_vld ),
    .rx_l_vld     (rx_l_vld ),
    .start        (start),

    .smlh_link_up (smlh_link_up),
    .rdlh_link_up (rdlh_link_up)

);
//assign rdlh_link_up=led[6];
//assign smlh_link_up=led[7];



//////////////////////////////////////////pcie


//////////////////////////////////////////HDMI
////
//HDMI_top u_HDMI_top(
//    .sys_clk                (sys_clk            ), // input
//    .cfg_clk                (cfg_clk            ), // input
//    .pll_lock                (pll_lock),
//    .hdmi_tx_pix_clk        (hdmi_tx_pix_clk    ), // input
//    .sys_rst_n              (key_rstn     ), // input
//    .ddr_init_done          (ddr_init_done      ), // input
//    .hdmi_rx_init           (hdmi_rx_init       ), // output
//    .hdmi_tx_init           (hdmi_tx_init       ), // output
//    .hdmi_rst_n             (hdmi_rst_n         ), // output
//
//    .pix_req                 (pix_req            ), // output 显示像素请求
//    .pix_data                (pix_data           ), // input  显示像素数据
//    
//    .hdmi_rx_scl            (hdmi_rx_scl        ), // output
//    .hdmi_rx_sda            (hdmi_rx_sda        ), // output
//    
//    .hdmi_tx_scl            (hdmi_tx_scl        ), // output
//    .hdmi_tx_sda            (hdmi_tx_sda        ), // output
//    .hdmi_tx_vs             (hdmi_tx_vs_temp    ), // output
//    .hdmi_tx_hs             (hdmi_tx_hs_temp    ), // output
//    .hdmi_tx_de             (hdmi_tx_de_temp    ), // output
//    .hdmi_tx_data           (hdmi_tx_data_temp  )  // output
//);
//// 输出打一拍
//always@(posedge hdmi_tx_pix_clk)
//begin
//    if( !key_rstn)//|| !hdmi_rx_init   
//        begin
//            hdmi_tx_vs   <= 1'b0;
//            hdmi_tx_hs   <= 1'b0;
//            hdmi_tx_de   <= 1'b0;
//            hdmi_tx_data <=  'd0;
//        end
//    else
//        begin
//            hdmi_tx_vs   <= hdmi_tx_vs_temp  ;
//            hdmi_tx_hs   <= hdmi_tx_hs_temp  ;
//            hdmi_tx_de   <= hdmi_tx_de_temp  ;
//            hdmi_tx_data <=hdmi_tx_data_temp;
//        end
//end


  //reg wire define////

//    wire               [   8: 0]        fft_data                   ;
//    wire                                fft_eop                    ;
//    wire                                fft_valid                  ;
//    wire                                out_vsync                  ;
//    wire               [   8: 0]        fft_data_ap                ;
//    wire                                fft_eop_ap                 ;
//    wire                                fft_valid_ap               ;
//    wire                                out_vsync_ap               ;
//
//wire [7:0] r_out;
//wire [7:0] g_out;
//wire [7:0] b_out;
//assign hdmi_tx_data={r_out,g_out,b_out};
////fft to hdmi
//
////  //fft instance
//  fft_top u_fft(
//    .clk_100m                           (hdmi_tx_pix_clk                  ),
//    .i_key                              (key_rstn                     ),
//    .es0_alrck                          (es0_alrck                 ),//输入fft数据时钟
//    .rx_data                            (rx_data                   ),//输入fft数据
//    .fft_data                           (fft_data                  ),
//    .fft_eop                            (fft_eop                   ),
//    .fft_valid                          (fft_valid                 ),
//    .out_vsync                          (out_vsync                 ) 
//          );
//  //fft instance 2 处理后的音频数据进行fft
//  fft_top u_fft_ap(
//    .clk_100m                           (hdmi_tx_pix_clk                  ),
//    .i_key                              (key_rstn                     ),
//    .es0_alrck                          (es0_alrck                 ),//输入fft数据时钟
//    .rx_data                            (tx_fir_data                   ),//输入fft数据
//    .fft_data                           (fft_data_ap               ),
//    .fft_eop                            (fft_eop_ap                ),
//    .fft_valid                          (fft_valid_ap              ),
//    .out_vsync                          (out_vsync_ap              ) 
//  );
//
//  //display instance
//  display_top u_display(
//    .clk_10m                            (cfg_clk                   ),
//    .clk_100m                           (hdmi_tx_pix_clk                  ),
//    .es0_dsclk                          (es0_dsclk                 ),
//    .ldata                              (ldata                     ),
//    .rx_l_vld                           (rx_l_vld                  ),
//    .rdata                              (rdata                     ),
//    .rx_r_vld                           (rx_r_vld                  ),
//
//    .fft_data                           (fft_data                  ),//处理前fft输入显示模块
//    .fft_eop                            (fft_eop                   ),
//    .fft_valid                          (fft_valid                 ),
//    .out_vsync                          (out_vsync                 ),
//
//    .fft_data_ap                        (fft_data_ap               ),//处理后fft输入显示模块
//    .fft_eop_ap                         (fft_eop_ap                ),
//    .fft_valid_ap                       (fft_valid_ap              ),
//    .out_vsync_ap                       (out_vsync_ap              ),
//
//    .iic_tx_scl                         (hdmi_tx_scl                ),
//    .iic_tx_sda                         (hdmi_tx_sda                ),
//
//    .pix_clk                            (pix_clk                   ),//pixclk
//    .vs_out                             (hdmi_tx_vs                    ),
//    .hs_out                             (hdmi_tx_hs                    ),
//    .de_out                             (hdmi_tx_de                    ),
//    .r_out                              (r_out                     ),
//    .g_out                              (g_out                     ),
//    .b_out                              (b_out                     ),
//    .rstn_hdmi_out                      (hdmi_rst_n             ),
//
//    .hdmi_init                          (hdmi_init                 ),
//
//    .clk_148m                           (hdmi_tx_pix_clk                  ),
//    .pll_lock                           (pll_lock                  ) 
//              );

////////////////////////////////////////HDMI


//assign vocie_change_en='d0;
////////////////////////////////////////变声
Voice_change#(
   .DATA_WIDTH (16)
)u_Voice_change
(
.clk            (sys_clk),
.rst_n          (key_rstn||vocie_change_en||adc_dac_int),
.f_set          (f_set),
.f_original     (f_original),

.voice_clk_in   (es0_dsclk),
.voice_rst_in   (key_rstn||vocie_change_en||adc_dac_int),
.voice_en_in    (rx_l_vld||rx_r_vld),
.voice_data_in  (rx_data),

.voice_clk_out  (es0_dsclk),
.voice_rst_out  (key_rstn||vocie_change_en||adc_dac_int),
.voice_en_out   (rx_l_vld||rx_r_vld),
.voice_data_out (voice_data_out)

   );
//wire [11:0] rd_water_level_out;
//wire        rd_HPSS;
//
//assign rd_HPSS =rd_water_level_out>='d5;
//HPSS#(
//   .DATA_WIDTH (16)
//)u_HPSS
//(
//.clk            (sys_clk),
//.rst_n          ((key_rstn&&adc_dac_int)&&!vocie_change_en),
//
//
//.voice_clk_in   (es0_dsclk),
//.voice_rst_in   ((key_rstn&&adc_dac_int)&&!vocie_change_en),
//.voice_en_in    (rx_r_vld2),
//.voice_data_in  (rx_data2),
//
//.voice_clk_out  (es0_dsclk),
//.voice_rst_out  ((key_rstn&&adc_dac_int)&&!vocie_change_en),
//.voice_en_out   (rx_r_vld2&&rd_HPSS),
//.voice_data_out (voice_data_out_HPSS),//voice_data_out_HPSS
//.rd_water_level_out(rd_water_level_out)
//   );

////////////////////////////////////////变声



/*******************************************************************************///回声消除

//wire Echo_cancellation_LMS_en;
//wire [11:0]rd_water_level_1/*synthesis PAP_MARK_DEBUG="1"*/;
//reg LMS_en;
//reg key_on_11;
////assign led[2]=Echo_cancellation_LMS_en;
//assign Echo_cancellation_LMS_en='d1;
//always@(posedge sys_clk or negedge key_rstn)
//begin
//    if(!key_rstn)begin
//        Echo_cancellation_LMS_en <= 'd0;
//    end
//    else if(key_on[0]&&!key_on_11) begin
//        Echo_cancellation_LMS_en<='d0;//~Echo_cancellation_LMS_en;
//    end
//end
//always@(posedge sys_clk or negedge key_rstn)
//begin
//    if(!key_rstn)begin
//        key_on_11 <= 'd0;
//    end
//    else  begin
//        key_on_11<=key_on[0];
//    end
//end
//always@(posedge sys_clk or negedge key_rstn)
//begin
//    if(!key_rstn)begin
//        LMS_en <= 'd0;
//    end
//    else if(rd_water_level_1=='d5) begin
//        LMS_en<='d1;
//    end
//    else  begin
//        LMS_en<=LMS_en;
//    end
//end
//
//
//reg lms_on;

//assign lms_on=key_on_1[5]?~lms_on:lms_on;
//
//always@(posedge sys_clk or negedge key_rstn)
//begin
//    if(!key_rstn)begin
//        lms_on <= 'd0;
//    end
//    else if(key_on_1[5]) begin
//        lms_on<=~lms_on;
//    end
//    else  begin
//        lms_on<=lms_on;
//    end
//end
//i2s_loop#(
//    .DATA_WIDTH(16)
//)i2s_loop3(
//    .rst_n          (adc_dac_int),// input
//    .sck            (es0_dsclk  ),// input
//    .ldata          (ldata_lms      ),// output[15:0]
//    .rdata          (rdata_lms      ),// output[15:0]
//    .data           ( rx_data   ),// input[15:0] rx_data_32_out rx_data_1
//    .r_vld          (rx_r_vld   ),// input
//    .l_vld          (rx_l_vld   ) // inputrcv_done
//);
//Echo_cancellation_LMS#(
//  .DATA_WIDTH(16)
//)u_Echo_cancellation_LMS
//(
//.clk			    (hdmi_tx_pix_clk),
//.rst_n              (key_rstn &&(pll_lock)),
//
//.voice_clk_in_x 	(es0_dsclk),	    
//.voice_rst_in_x 	(key_rstn  ),	    
//.voice_en_in_x  	((rx_l_vld) ),	    
//.voice_data_in_x    (ldata_lms),
//
//.voice_clk_in_d 	(es0_dsclk),	    
//.voice_rst_in_d 	(key_rstn  ),	    
//.voice_en_in_d  	((rx_r_vld) ),	    
//.voice_data_in_d    (rdata_lms),       
//          
//.voice_clk_out      (es0_dsclk),
//.voice_rst_out      (key_rstn  ),
//.voice_en_out       ((rx_l_vld)&&LMS_en  ),
//.voice_data_out     (voice_data_Echo_cancellation_out),
//
//.lms_on              (lms_on),
//.rd_water_level_1    (rd_water_level_1)
//);
//

/************************************************************************************/
/************************************************************************************/
reg  VQ_START;
reg XUNLIAN_START;
reg VQ_STOP;
reg VQ_identify_START;
//wire [11:0] wr_water_level;
wire[3:0] VQ_D;
reg [3:0] VQ_D_led;

wire VQ_LBG_XUNLIAN_FINSH_led;
wire VQ_identifys_finsh_led  ;
reg [6:0] key_on_2;

always@(posedge hdmi_tx_pix_clk or negedge key_rstn)
begin
    if(!key_rstn)begin
        key_on_2 <= 'd0;
    end
    else  begin
        key_on_2<=key_on_1;
    end
end

always@(posedge hdmi_tx_pix_clk or negedge key_rstn)
begin
    if(!key_rstn)begin
        VQ_START <= 'd0;
    end
    else if(key_on_1[0]&&!key_on_2[0])  begin
        VQ_START<='d1;
    end
    else  begin
        VQ_START<='d0;
    end
end
always@(posedge hdmi_tx_pix_clk or negedge key_rstn)
begin
    if(!key_rstn)begin
        VQ_STOP <= 'd0;
    end
    else if(key_on_1[1]&&!key_on_2[1])  begin
        VQ_STOP<='d1;
    end
    else  begin
        VQ_STOP<='d0;
    end
end

always@(posedge hdmi_tx_pix_clk or negedge key_rstn)
begin
    if(!key_rstn)begin
        XUNLIAN_START <= 'd0;
    end
    else if(key_on_1[2]&&!key_on_2[2])  begin
        XUNLIAN_START<='d1;
    end
    else  begin
        XUNLIAN_START<='d0;
    end
end

always@(posedge hdmi_tx_pix_clk or negedge key_rstn)
begin
    if(!key_rstn)begin
        VQ_identify_START <= 'd0;
    end
    else if(key_on_1[3]&&!key_on_2[3])  begin
        VQ_identify_START<='d1;
    end
    else  begin
        VQ_identify_START<='d0;
    end
end

reg LBG_1;
reg LBG_2;
reg LBG_3;
reg LBG_4;
always@(posedge hdmi_tx_pix_clk or negedge key_rstn)
begin
    if(!key_rstn)begin
        LBG_1 <= 'd1;
        LBG_2 <= 'd0;
        LBG_3 <= 'd0;
        LBG_4 <= 'd0;

    end
    else if(key_on_1[4]&&!key_on_2[4])  begin
        LBG_1<='d0;
        LBG_2<='d1;
        LBG_3 <= 'd0;
        LBG_4 <= 'd0;
    end
    else if(key_on_1[5]&&!key_on_2[5])  begin
        LBG_1<='d0;
        LBG_2<='d0;
        LBG_3 <= 'd1;
        LBG_4 <= 'd0;
    end
    else if(key_on_1[6]&&!key_on_2[6])  begin
        LBG_1<='d0;
        LBG_2<='d0;
        LBG_3 <= 'd0;
        LBG_4 <= 'd1;
    end
    else  begin
        LBG_1 <=LBG_1;
        LBG_2 <=LBG_2;
        LBG_3 <=LBG_3;
        LBG_4 <=LBG_4;
    end
end

reg XUNLIAN_FINSH_led;
always@(posedge hdmi_tx_pix_clk or negedge key_rstn)
begin
    if(!key_rstn||VQ_LBG_XUNLIAN_FINSH_led)begin
        XUNLIAN_FINSH_led <= 'd0;
    end
    else if(XUNLIAN_START)  begin
        XUNLIAN_FINSH_led<='d1;
    end
    else  begin
        XUNLIAN_FINSH_led<=XUNLIAN_FINSH_led;
    end
end
reg identifys_finsh_led;
always@(posedge hdmi_tx_pix_clk or negedge key_rstn)
begin
    if(!key_rstn||VQ_identifys_finsh_led)begin
        identifys_finsh_led <= 'd0;
    end
    else if(VQ_identify_START)  begin
        identifys_finsh_led<='d1;
    end
    else  begin
        identifys_finsh_led<=identifys_finsh_led;
    end
end
always@(posedge hdmi_tx_pix_clk or negedge key_rstn)
begin
    if(!key_rstn)begin
        VQ_D_led <= 'd0;
    end
    else if(VQ_identifys_finsh_led)  begin
        VQ_D_led<=VQ_D;
    end
    else  begin
        VQ_D_led<=VQ_D_led;
    end
end

assign led[0]= XUNLIAN_FINSH_led ;
assign led[1]= identifys_finsh_led ;

assign led[2]= VQ_D_led[0];
assign led[3]= VQ_D_led[1];
assign led[4]= VQ_D_led[2];
assign led[5]= VQ_D_led[3];

 MFCC_VQ#(
   .DATA_WIDTH (16)
)U_MFCC_VQ
(
.clk			(hdmi_tx_pix_clk),
.rst_n          (key_rstn),
.voice_clk_in   (es0_dsclk),
.voice_rst_in   (key_rstn),
.voice_en_in    (rx_r_vld),
.voice_data_in  (rx_data),
.anew('d0),
.VQ_START (VQ_START),
.VQ_STOP  (VQ_STOP),
.XUNLIAN_START(XUNLIAN_START),
.VQ_identify  (VQ_identify_START),
.LBG_1(LBG_1),
.LBG_2(LBG_2),
.LBG_3(LBG_3),
.LBG_4(LBG_4),
.VQ_D (VQ_D),
.VQ_LBG_XUNLIAN_FINSH_led(VQ_LBG_XUNLIAN_FINSH_led),
.VQ_identifys_finsh_led  (VQ_identifys_finsh_led  ),
.wr_water_level()
   );

/*******************************************************************************/
endmodule