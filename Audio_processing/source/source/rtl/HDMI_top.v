/*****************************************************************/
//
// Create Date: 2023/09/24
// Design Name: WenYiXing
//
/*****************************************************************/

module HDMI_top#(
)(
    input   wire                sys_clk         ,
    input   wire                cfg_clk         ,
    input   wire                pll_lock         ,
    input   wire                hdmi_tx_pix_clk ,
    input   wire                sys_rst_n       ,
    input   wire                ddr_init_done   ,
    output  wire                hdmi_tx_init    ,
    output  wire                hdmi_rx_init    ,
    output  wire                hdmi_rst_n      ,


    output  wire                pix_req         ,
    input   wire    [23:0]      pix_data        ,
    
    output  wire                hdmi_rx_scl     , // HDMI输入芯片SCL信号
    inout   wire                hdmi_rx_sda     , // HDMI输入芯片SDA信号
    
    output  wire                hdmi_tx_scl     , // HDMI输出芯片SCL信号
    inout   wire                hdmi_tx_sda     , // HDMI输出芯片SDA信号
    
    output  wire                hdmi_tx_vs      , // HDMI输出场同步信号

    output  wire                hdmi_tx_hs      , // HDMI输出行同步信号
    output  wire                hdmi_tx_de      , // HDMI输出数据有效信号
    output  wire    [23:0]      hdmi_tx_data      // HDMI输出数据
);
/****************************reg*****************************/
reg     [15:0]          rstn_1ms     ;

/****************************wire****************************/
wire                    rst_n       ;



/********************combinational logic*********************/

assign rst_n       = sys_rst_n && hdmi_rst_n ;

/***********************instantiation************************/
    ms72xx_ctl ms72xx_ctl(
        .clk         (  cfg_clk    ), //input       clk,
        .rst_n       (  hdmi_rst_n   ), //input       rstn,
                                
        .init_over   (  hdmi_tx_init  ), //output      init_over,
        .iic_tx_scl  (  hdmi_tx_scl ), //output      iic_scl,
        .iic_tx_sda  (  hdmi_tx_sda ), //inout       iic_sda
        .iic_scl     (  hdmi_rx_scl    ), //output      iic_scl,
        .iic_sda     (  hdmi_rx_sda    )  //inout       iic_sda
    );

video_driver u_video_driver(
    .pix_clk        (hdmi_tx_pix_clk), // input
    .rst_n          (hdmi_rst_n          ), // input

    .video_hs       (hdmi_tx_hs     ), // output
    .video_vs       (hdmi_tx_vs     ), // output
    .video_de       (hdmi_tx_de     ), // output
    .video_data     (hdmi_tx_data   ), // output
    .pix_req        (pix_req        ), // output
    .pix_data       (pix_data       )
);
//MODE_1080p
//    parameter V_TOTAL = 12'd1125;
//    parameter V_FP = 12'd4;
//    parameter V_BP = 12'd36;
//    parameter V_SYNC = 12'd5;
//    parameter V_ACT = 12'd1080;
//    parameter H_TOTAL = 12'd2200;
//    parameter H_FP = 12'd88;
//    parameter H_BP = 12'd148;
//    parameter H_SYNC = 12'd44;
//    parameter H_ACT = 12'd1920;
//    parameter HV_OFFSET = 12'd0;
//    parameter   X_WIDTH = 4'd12;
//    parameter   Y_WIDTH = 4'd12;  
//    wire [X_WIDTH - 1'b1:0]     act_x      ;
//    wire [Y_WIDTH - 1'b1:0]     act_y      ;    
//    wire                        hs         ;
//    wire                        vs         ;
//    wire                        de         ;
//    sync_vg #(
//        .X_BITS               (  X_WIDTH              ), 
//        .Y_BITS               (  Y_WIDTH              ),
//        .V_TOTAL              (  V_TOTAL              ),//                        
//        .V_FP                 (  V_FP                 ),//                        
//        .V_BP                 (  V_BP                 ),//                        
//        .V_SYNC               (  V_SYNC               ),//                        
//        .V_ACT                (  V_ACT                ),//                        
//        .H_TOTAL              (  H_TOTAL              ),//                        
//        .H_FP                 (  H_FP                 ),//                        
//        .H_BP                 (  H_BP                 ),//                        
//        .H_SYNC               (  H_SYNC               ),//                        
//        .H_ACT                (  H_ACT                ) //                        
// 
//    ) sync_vg                                         
//    (                                                 
//        .clk                  (  hdmi_tx_pix_clk               ),//input                   clk,                                 
//        .rstn                 (  hdmi_rst_n                 ),//input                   rstn,                            
//        .vs_out               (  vs                   ),//output reg              vs_out,                                                                                                                                      
//        .hs_out               (  hs                   ),//output reg              hs_out,            
//        .de_out               (  de                   ),//output reg              de_out,             
//        .x_act                (  act_x                ),//output reg [X_BITS-1:0] x_out,             
//        .y_act                (  act_y                ) //output reg [Y_BITS:0]   y_out,             
//    );
//    
//    pattern_vg #(
//        .COCLOR_DEPP          (  8                    ), // Bits per channel
//        .X_BITS               (  X_WIDTH              ),
//        .Y_BITS               (  Y_WIDTH              ),
//        .H_ACT                (  H_ACT                ),
//        .V_ACT                (  V_ACT                )
//    ) // Number of fractional bits for ramp pattern
//    pattern_vg (
//        .rstn                 (  hdmi_rst_n                 ),//input                         rstn,                                                     
//        .pix_clk              (  hdmi_tx_pix_clk               ),//input                         clk_in,  
//        .act_x                (  act_x                ),//input      [X_BITS-1:0]       x,   
//        .act_y                (act_y                )    ,
//        // input video timing
//        .vs_in                (  vs                   ),//input                         vn_in                        
//        .hs_in                (  hs                   ),//input                         hn_in,                           
//        .de_in                (  de                   ),//input                         dn_in,
//        // test pattern image output                                                    
//        .vs_out               (  hdmi_tx_vs               ),//output reg                    vn_out,                       
//        .hs_out               (  hdmi_tx_hs               ),//output reg                    hn_out,                       
//        .de_out               (  hdmi_tx_de               ),//output reg                    den_out,     
//
//        .video_data (hdmi_tx_data),
//        .pix_req    (pix_req),
//        .pix_data   (pix_data)            
//
//    );

/**************************process***************************/
    always @(posedge cfg_clk)
    begin
    	if(!pll_lock)
    	    rstn_1ms <= 16'd0;
    	else
    	begin
    		if(rstn_1ms == 16'h2710)
    		    rstn_1ms <= rstn_1ms;
    		else
    		    rstn_1ms <= rstn_1ms + 1'b1;
    	end
    end
    
    assign hdmi_rst_n = (rstn_1ms == 16'h2710);
endmodule
