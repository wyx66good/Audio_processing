`timescale 1ns / 1ps
`define UD #1
module display_top(
    input                               clk_10m                    ,
    input                               clk_100m                   ,
    input                               es0_dsclk                  ,
    input              [  15: 0]        ldata                      ,
    input                               rx_l_vld                   ,
    input              [  15: 0]        rdata                      ,
    input                               rx_r_vld                   ,
    input              [   8: 0]        fft_data                   ,
    input                               fft_eop                    ,
    input                               fft_valid                  ,
    output                              out_vsync                  ,

    input              [   8: 0]        fft_data_ap                ,
    input                               fft_eop_ap                 ,
    input                               fft_valid_ap               ,
    output                              out_vsync_ap               ,

    //hdmi ms72xx_ctl reg config
    output                              iic_tx_scl                 ,
    inout                               iic_tx_sda                 ,
    //hdmi out
    output                              pix_clk                    ,//pixclk
    output                              vs_out                     ,
    output                              hs_out                     ,
    output                              de_out                     ,
    output             [   7: 0]        r_out                      ,
    output             [   7: 0]        g_out                      ,
    output             [   7: 0]        b_out                      ,
    output                              rstn_hdmi_out              ,
    //hdmi init detect hdmi 信号灯
    output                              hdmi_init                  ,//hdmi初始化led C5 led5

    //inter connection
    input                               clk_148m                   ,
    input                               pll_lock                    
  );
  ////reg wire define////
    wire                                video_hs                   ;
    wire                                video_vs                   ;
    wire                                video_de                   ;
    wire               [   7: 0]        video_r                    ;
    wire               [   7: 0]        video_g                    ;
    wire               [   7: 0]        video_b                    ;

    wire                                grid_hs                    ;
    wire                                grid_vs                    ;
    wire                                grid_de                    ;
    wire               [   7: 0]        grid_r                     ;
    wire               [   7: 0]        grid_g                     ;
    wire               [   7: 0]        grid_b                     ;


    wire                                adc0_buf_wr                ;
    wire               [  10: 0]        adc0_buf_addr              ;
    wire               [   7: 0]        adc0_buf_data              ;

    wire                                adc1_buf_wr                ;
    wire               [  10: 0]        adc1_buf_addr              ;
    wire               [   7: 0]        adc1_buf_data              ;

    wire                                hs_left                    ;
    wire                                vs_left                    ;
    wire                                de_left                    ;
    wire               [   7: 0]        r_left                     ;
    wire               [   7: 0]        g_left                     ;
    wire               [   7: 0]        b_left                     ;

    wire                                hs_right                   ;
    wire                                vs_right                   ;
    wire                                de_right                   ;
    wire               [   7: 0]        r_right                    ;
    wire               [   7: 0]        g_right                    ;
    wire               [   7: 0]        b_right                    ;

    wire                                char_hs                    ;
    wire                                char_vs                    ;
    wire                                char_de                    ;
    wire               [   7: 0]        char_r                     ;
    wire               [   7: 0]        char_g                     ;
    wire               [   7: 0]        char_b                     ;

   wire                                 hs_fft                    ;
   wire                                 vs_fft                    ;
   wire                                 de_fft                    ;
   wire               [   7: 0]         r_fft;
   wire               [   7: 0]         g_fft;
   wire               [   7: 0]         b_fft ;

    reg                [  15: 0]        rstn_hdmi_1ms              ;

  ////combine logic////
    assign                              hdmi_init                 = init_over;
    assign                              rstn_hdmi_out             = (rstn_hdmi_1ms == 16'h2710);
    assign                              pix_clk                   = clk_148m;

  ////process////
  always @(posedge clk_10m)
  begin
    if (~pll_lock)
      rstn_hdmi_1ms <= 16'd0;
    else
    begin
      if (rstn_hdmi_1ms == 16'h2710)
        rstn_hdmi_1ms <= rstn_hdmi_1ms;
      else
        rstn_hdmi_1ms <= rstn_hdmi_1ms + 1'b1;
    end
  end

  //HDMI RGB 转 TMDS 芯片ms7210配置
  ms72xx_ctl ms72xx_ctl (
    .clk                                (clk_10m                   ),//input       clk,
    .rst_n                              (rstn_hdmi_out             ),//input       rstn,

    .init_over                          (init_over                 ),//output      init_over,
    .iic_tx_scl                         (iic_tx_scl                ),//output      iic_scl,
    .iic_tx_sda                         (iic_tx_sda                ),//inout       iic_sda
    .iic_scl                            (                          ),//output      iic_scl,
    .iic_sda                            (                          ) //inout       iic_sda
             );
  //背景颜色显示
  color_bar background_display (
    .clk                                (pix_clk                   ),
    .rst                                (~rstn_hdmi_out            ),
    .hs                                 (video_hs                  ),
    .vs                                 (video_vs                  ),
    .de                                 (video_de                  ),
    .rgb_r                              (video_r                   ),
    .rgb_g                              (video_g                   ),
    .rgb_b                              (video_b                   ) 
            );
  //波形栅格显示
  grid_display grid_display_m0 (
    .rst_n                              (rstn_hdmi_out             ),
    .pclk                               (pix_clk                   ),
    .i_hs                               (video_hs                  ),
    .i_vs                               (video_vs                  ),
    .i_de                               (video_de                  ),
    .i_data                             ({video_r, video_g, video_b}),
    .o_hs                               (grid_hs                   ),
    .o_vs                               (grid_vs                   ),
    .o_de                               (grid_de                   ),
    .o_data                             ({grid_r, grid_g, grid_b}  ) 
               );
  //音频接收模块左通道 符号数处理
  ES7243E_sample ES7243E_sample_left (
    .adc_clk                            (es0_dsclk                 ),
    .rst                                (~rstn_hdmi_out            ),
    .adc_data                           (ldata                     ),//input
    .adc_data_valid                     (rx_l_vld                  ),
    .adc_buf_wr                         (adc0_buf_wr               ),
    .adc_buf_addr                       (adc0_buf_addr             ),
    .adc_buf_data                       (adc0_buf_data             ) 
                 );
  //音频接受模块右通道 符号数处理
  ES7243E_sample ES7243E_sample_right (
    .adc_clk                            (es0_dsclk                 ),
    .rst                                (~rstn_hdmi_out            ),
    .adc_data                           (rdata                     ),
    .adc_data_valid                     (rx_r_vld                  ),
    .adc_buf_wr                         (adc1_buf_wr               ),
    .adc_buf_addr                       (adc1_buf_addr             ),
    .adc_buf_data                       (adc1_buf_data             ) 
                 );
  //字符显示模块
  char_display char_display (
    .rst_n                              (rstn_hdmi_out             ),//复位信号
    .pclk                               (pix_clk                   ),//像素时钟
    .i_hs                               (grid_hs                   ),//行同步输入信号
    .i_vs                               (grid_vs                   ),//场同步输入信号
    .i_de                               (grid_de                   ),//图像有效输入信号
    .i_data                             ({grid_r, grid_g, grid_b}  ),//图像数据输入信号
    .o_hs                               (char_hs                   ),//行同步输出信号
    .o_vs                               (char_vs                   ),//场同步输出信号
    .o_de                               (char_de                   ),//图像有效输出信号
    .o_data                             ({char_r, char_g, char_b}  ) //图像数据输出信号
               );
  //左通道音频显示模块
  wave_display wave_display_left (
    .rst_n                              (rstn_hdmi_out             ),
    .pclk                               (pix_clk                   ),
    .wave_color                         (24'hff0000                ),//红色可修改
    .adc_clk                            (es0_dsclk                 ),
    .adc_buf_wr                         (adc0_buf_wr               ),
    .adc_buf_addr                       (adc0_buf_addr             ),
    .adc_buf_data                       (adc0_buf_data             ),
    .i_hs                               (char_hs                   ),
    .i_vs                               (char_vs                   ),
    .i_de                               (char_de                   ),
    .i_data                             ({char_r, char_g, char_b}  ),
    .o_hs                               (hs_left                   ),
    .o_vs                               (vs_left                   ),
    .o_de                               (de_left                   ),
    .o_data                             ({r_left, g_left, b_left}  ) 
               );
  //右通道音频显示
  wave_display wave_display_right (
    .rst_n                              (rstn_hdmi_out             ),
    .pclk                               (pix_clk                   ),
    .wave_color                         (24'h00ff00                ),//绿色可修改
    .adc_clk                            (es0_dsclk                 ),
    .adc_buf_wr                         (adc1_buf_wr               ),
    .adc_buf_addr                       (adc1_buf_addr             ),
    .adc_buf_data                       (adc1_buf_data             ),
    .i_hs                               (hs_left                   ),
    .i_vs                               (vs_left                   ),
    .i_de                               (de_left                   ),
    .i_data                             ({r_left, g_left, b_left}  ),
    .o_hs                               (hs_right                  ),
    .o_vs                               (vs_right                  ),
    .o_de                               (de_right                  ),
    .o_data                             ({r_right, g_right, b_right}) 
               );
  //fft 显示
  fft_display u_fft_display (
    .rst_n                              (rstn_hdmi_out             ),
    .i_clk_100m                         (clk_100m                  ),
    .pclk                               (pix_clk                   ),
    .i_hs                               (hs_right                  ),
    .i_vs                               (vs_right                  ),
    .i_de                               (de_right                  ),
    .i_data                             ({r_right, g_right, b_right}),
    .o_hs                               (hs_fft                    ),
    .o_vs                               (vs_fft                    ),
    .o_de                               (de_fft                    ),
    .o_data                             ({r_fft, g_fft, b_fft}     ),

    .fft_data                           (fft_data                  ),//取模后的数据
    .fft_eop                            (fft_eop                   ),//取模后输出的终止信号
    .fft_valid                          (fft_valid                 ),//取模后的数据有效信号
    .out_vsync                          (out_vsync                 ) //帧同步，高有效
              );

  //处理后fft显示
  fft_display_ap u_fft_display_ap (
    .rst_n                              (rstn_hdmi_out             ),
    .i_clk_100m                         (clk_100m                  ),
    .pclk                               (pix_clk                   ),
    .i_hs                               (hs_fft                    ),
    .i_vs                               (vs_fft                    ),
    .i_de                               (de_fft                    ),
    .i_data                             ({r_fft, g_fft, b_fft}     ),
    .o_hs                               (hs_out                    ),
    .o_vs                               (vs_out                    ),
    .o_de                               (de_out                    ),
    .o_data                             ({r_out, g_out, b_out}     ),
            
    .fft_data                           (fft_data_ap               ),//取模后的数据
    .fft_eop                            (fft_eop_ap                ),//取模后输出的终止信号
    .fft_valid                          (fft_valid_ap              ),//取模后的数据有效信号
    .out_vsync                          (out_vsync_ap              ) //帧同步，高有效
                          );

endmodule
