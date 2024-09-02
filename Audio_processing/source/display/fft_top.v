`timescale 1ns / 1ps
`define UD #1
module fft_top(
    input                               clk_100m                   ,
    input                               i_key                      ,
    input                               es0_alrck                  ,
    input              [  15: 0]        rx_data                    ,//adc 数据输入
    output             [   8: 0]        fft_data                   ,//取模后的数据
    output                              fft_eop                    ,//取模后输出的终止信号
    output                              fft_valid                  ,//取模后的数据有效信号

    //inter connection
    input                               out_vsync                   
  );
  ////reg wire define///

    wire               [  15: 0]        ad_data_out                ;
    wire                                ad_data_out_en             ;
    wire                                i_axi4s_data_tlast         ;
    wire               [  31: 0]        i_axi4s_data_tdata         ;
    wire                                o_axi4s_data_tvalid        ;
    wire               [  63: 0]        o_axi4s_data_tdata         ;
    wire                                o_axi4s_data_tlast         ;
    wire               [  23: 0]        o_axi4s_data_tuser         ;

  ////combine logic////
    assign                              fft_clk                   = clk_100m;
    assign                              i_axi4s_data_tvalid       = ad_data_out_en;
    assign                              i_axi4s_data_tdata        = {16'b0, ad_data_out[15:0]};

  //例化adc fifo控制模块
  ad_fft_fifo_ctrl u_ad_fft_fifo_ctrl (
    .fft_clk                            (fft_clk                   ),//输入时钟，100m
    .sys_rst_n                          (i_key                     ),//复位信号，低电平有效
    .in_vsync                           (out_vsync                 ),//帧同步，高有效
    .ad_clk                             (es0_alrck                 ),//ad采样时钟 lrclk
    .ad_data_in                         (rx_data                   ),//AD输入数据 16bits

    .s_axis_data_tready                 (1'b1                      ),//fft数据通道准备完成信号
    .s_axis_data_tlast                  (i_axi4s_data_tlast        ),//fft数据通道接收最后一个数据标志信号
    .s_axis_cfg_tvalid                  (                          ),//fft 动态配置通道有效信号

    .ad_data_out                        (ad_data_out               ),//采集后的adc输出数据 16bits
    .ad_data_out_en                     (ad_data_out_en            ) //采集后的adc输出数据使能
                   );

  //例化fft demo
  ipsxb_fft_demo_r2_1024 fft_r2 (
    .i_aclk                             (fft_clk                   ),// input 100mhz
    .i_axi4s_data_tvalid                (i_axi4s_data_tvalid       ),// input
    .i_axi4s_data_tdata                 (i_axi4s_data_tdata        ),// input[31:0]
    .i_axi4s_data_tlast                 (i_axi4s_data_tlast        ),// input

    .i_axi4s_cfg_tvalid                 (1'b1                      ),// input
    .i_axi4s_cfg_tdata                  (1'b1                      ),// iput

    .o_axi4s_data_tready                (                          ),// output
    .o_axi4s_data_tvalid                (o_axi4s_data_tvalid       ),// output
    .o_axi4s_data_tdata                 (o_axi4s_data_tdata        ),// output[63:0]
    .o_axi4s_data_tlast                 (o_axi4s_data_tlast        ),// output
    .o_axi4s_data_tuser                 (o_axi4s_data_tuser        ),// output[23:0]fft数据通道输出数据的状态信息
    .o_alm                              (                          ),// output[2:0]
    .o_stat                             (                          ) // output
                         );

  //例化数据取模模块
  data_modulus u_data_modulus (
    .clk                                (fft_clk                   ),
    .rst_n                              (i_key                     ),

    .source_real                        (o_axi4s_data_tdata[16:0]  ),//实部 有符号数
    .source_imag                        (o_axi4s_data_tdata[48:32] ),//虚部 有符号数
    .source_eop                         (o_axi4s_data_tlast        ),//fft数据通道接收最后一个数据标志信号
    .source_valid                       (o_axi4s_data_tvalid       ),//输出有效信号，FFT变换完成后，此信号置高，开始输出数据

    .data_modulus                       (fft_data                  ),//取模后的数据
    .data_eop                           (fft_eop                   ),//取模后输出的终止信号
    .data_valid                         (fft_valid                 ) //取模后的数据有效信号
               );


endmodule
