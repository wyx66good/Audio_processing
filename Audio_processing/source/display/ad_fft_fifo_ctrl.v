module ad_fft_fifo_ctrl (
  input        fft_clk,    //输入时钟，100m
  input        sys_rst_n,  //复位信号，低电平有效
  input        in_vsync,   //帧同步，高有效 
  input        ad_clk,     //ad采样时钟 lrclk
  input [15:0] ad_data_in, //AD输入数据 16bits

  input  s_axis_data_tready,  //fft数据通道准备完成信号 
  output s_axis_data_tlast,   //fft数据通道接收最后一个数据标志信号
  output s_axis_cfg_tvalid,   //fft 动态配置通道有效信号

  output [15:0] ad_data_out,    //采集后的adc输出数据 16bits
  output        ad_data_out_en  //采集后的adc输出数据使能

);
  //reg
  reg        in_vsync_t;  //帧同步打拍信号
  reg        in_vsync_t0;
  reg        in_vsync_t1;
  reg [15:0] ad_data_in_d0;  //AD输入数据打拍信号
  reg [15:0] ad_data_in_d1;
  reg [10:0] cnt_fifo_wr_en;  //fifo写使能计数器
  reg        fifo_wr_en;  //fifo写使能
  reg [10:0] cnt_rd_en;  //读使能计数器        
  reg        rd_en;  //读有效使能
  reg ad_data_out_en_r0, ad_data_out_en_r1;

  //wire
  wire [11:0] rd_data_count;  //读端fifo剩余数据量
  wire        fifo_rd_en;  //fifo读使能

  //当读出最后一个数据时，拉高fft数据通道接收最后一个数据标志信号
  assign s_axis_data_tlast = ((cnt_rd_en[10:0] == 1023) && ad_data_out_en) ? 1'b1 : 1'b0;

  //fifo的模式设为FWFT模式，读使能可以是数据有效使能
  assign ad_data_out_en    = fifo_rd_en;

  //在读有效使能为高并且fft数据通道准备完成信号有效的时候去读出数据
  //以此保证读出的数据全部写入fft模块
  assign fifo_rd_en        = rd_en && s_axis_data_tready;

  //产生fifo的写使能
  always @(posedge ad_clk or negedge sys_rst_n) begin
    if (sys_rst_n == 1'b0) fifo_wr_en <= 1'b0;
    else if (in_vsync_t0 && ~in_vsync_t1)  //在场同步上升沿到来时写入数据
      fifo_wr_en <= 1'b1;
    else if (cnt_fifo_wr_en >= 1023) fifo_wr_en <= 1'b0;
    else fifo_wr_en <= fifo_wr_en;
  end

  //产生fifo写使能计数器
  always @(posedge ad_clk or negedge sys_rst_n) begin
    if (sys_rst_n == 1'b0) cnt_fifo_wr_en <= 11'd0;
    else if (fifo_wr_en) cnt_fifo_wr_en <= cnt_fifo_wr_en + 1'b1;
    else cnt_fifo_wr_en <= 11'd0;
  end

  //产生读有效使能
  always @(posedge fft_clk or negedge sys_rst_n) begin
    if (sys_rst_n == 1'b0) rd_en <= 1'b0;
    else if (cnt_rd_en >= 1023) rd_en <= 1'b0;
    else if (rd_data_count >= 1022) rd_en <= 1'b1;
    else rd_en <= rd_en;
  end

  //产生读使能计数器
  always @(posedge fft_clk or negedge sys_rst_n) begin
    if (sys_rst_n == 1'b0) cnt_rd_en <= 11'd0;
    else if (s_axis_data_tlast) cnt_rd_en <= 11'd0;
    else if (fifo_rd_en) cnt_rd_en <= cnt_rd_en + 1'b1;
    else cnt_rd_en <= cnt_rd_en;
  end

  //时钟域同步
  always @(posedge ad_clk or negedge sys_rst_n) begin
    if (sys_rst_n == 1'b0) begin
      in_vsync_t        <= 1'b0;
      in_vsync_t0       <= 1'b0;
      in_vsync_t1       <= 1'b0;
      ad_data_in_d0     <= 8'd0;
      ad_data_in_d1     <= 8'd0;
      ad_data_out_en_r0 <= 8'd0;
      ad_data_out_en_r1 <= 8'd0;
    end else begin
      in_vsync_t        <= in_vsync;
      in_vsync_t0       <= in_vsync_t;
      in_vsync_t1       <= in_vsync_t0;
      ad_data_in_d0     <= ad_data_in;
      ad_data_in_d1     <= ad_data_in_d0;
      ad_data_out_en_r0 <= ad_data_out_en;
      ad_data_out_en_r1 <= ad_data_out_en_r0;
    end
  end

  assign s_axis_cfg_tvalid = (~ad_data_out_en_r1 && ad_data_out_en_r0);


  fifo_2048x16 u_fifo_2048x16 (
    .wr_clk        (ad_clk),         // input
    .wr_rst        (~sys_rst_n),     // input
    .wr_en         (fifo_wr_en),     // input
    .wr_data       (ad_data_in_d1),  // input [15:0]
    .wr_full       (),               // output
    .almost_full   (),               // output
    .rd_clk        (fft_clk),        // input
    .rd_rst        (~sys_rst_n),     // input
    .rd_en         (fifo_rd_en),     // input
    .rd_data       (ad_data_out),    // output [15:0]
    .rd_empty      (),               // output
    .rd_water_level(rd_data_count),  // output [11:0]
    .almost_empty  ()                // output
  );
endmodule
