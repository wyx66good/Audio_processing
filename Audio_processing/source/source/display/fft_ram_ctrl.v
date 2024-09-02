module fft_ram_ctrl (
  input       clk,
  input       lcd_clk,
  input       rst_n,
  //FFT输入数据
  input [8:0] fft_data,  //FFT频谱数据
  input       fft_eop,   //EOP包结束信号
  input       fft_valid, //FFT频谱数据有效信号

  input            data_req,        //数据请求信号
  input            fft_point_done,  //FFT当前频谱绘制完成
  output reg [8:0] fft_point_cnt,   //FFT频谱位置
  //ram端口  
  output     [8:0] ram_data_out     //ram输出有效数据
);
  //parameter
  parameter TRANSFORM_LEN = 1024;  //FFT采样点数:1024
  //reg
  reg  [9:0] ram_raddr;  //ram读地址
  reg        data_invalid;  //数据无效标志，高有效
  reg  [9:0] ram_waddr;  //ram写地址

  //wire
  wire       ram_wr_en;  //ram写使能
  wire [8:0] ram_wr_data;  //ram写数据
  wire [8:0] ram_rd_data;  //ram读数据

  //产生ram写使能
  assign ram_wr_en    = fft_valid;
  //产生ram写数据
  assign ram_wr_data  = fft_data;
  //在数据无效标志为低的时候将ram读数据赋值给ram输出有效数据信号
  assign ram_data_out = data_invalid ? 'd0 : ram_rd_data;

  //产生ram地址
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) ram_waddr <= 'd0;
    else if (fft_eop) ram_waddr <= 'd0;
    else if (ram_wr_en) ram_waddr <= ram_waddr + 'd1;
    else ram_waddr <= ram_waddr;
  end

  //当前从ram中读到的第几个点，fft_point_cnt（0~511）
  always @(posedge lcd_clk or negedge rst_n) begin
    if (!rst_n) fft_point_cnt <= 'd0;
    else begin
      if (fft_point_done) fft_point_cnt <= 'd0;
      else if (data_req) fft_point_cnt <= fft_point_cnt + 'b1;
      else fft_point_cnt <= fft_point_cnt;
    end
  end

  //产生ram读地址
  always @(posedge lcd_clk or negedge rst_n) begin
    if (!rst_n) ram_raddr <= 'd0;
    else begin
      if (fft_point_done) ram_raddr <= 'd0;
      else if (data_req) ram_raddr <= ram_raddr + 'b1;
      else ram_raddr <= ram_raddr;
    end
  end

  //产生数据无效标志，因为fft的数据是对称的，所以只要取前一半数据就可以了
  always @(posedge lcd_clk or negedge rst_n) begin
    if (!rst_n) data_invalid <= 1'd0;
    else begin
      if (fft_point_done) data_invalid <= 1'd0;
      else if (ram_raddr == TRANSFORM_LEN / 2) data_invalid <= 1'd1;
      else data_invalid <= data_invalid;
    end
  end
  ram_1024x9 u_ram_1024x9 (
    .wr_data(ram_wr_data),  // input [8:0]
    .wr_addr(ram_waddr),    // input [9:0]
    .wr_en  (ram_wr_en),    // input
    .wr_clk (clk),          // input
    .wr_rst (~rst_n),       // input
    .rd_addr(ram_raddr),    // input [9:0]
    .rd_data(ram_rd_data),  // output [8:0]
    .rd_clk (lcd_clk),      // input
    .rd_rst (~rst_n)        // input
  );
endmodule
