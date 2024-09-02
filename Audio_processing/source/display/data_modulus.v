module data_modulus (
  input         clk,
  input         rst_n,
  //FFT ST接口
  input  [16:0] source_real,   //实部 有符号数
  input  [16:0] source_imag,   //虚部 有符号数
  input         source_eop,    //fft数据通道接收最后一个数据标志信号
  input         source_valid,  //输出有效信号，FFT变换完成后，此信号置高，开始输出数据
  //取模运算后的数据接口
  output [ 8:0] data_modulus,  //取模后的数据
  output        data_eop,      //取模后输出的终止信号
  output        data_valid     //取模后的数据有效信号
);
  //reg define 
  reg  [31:0] source_data;  //原码平方和
  reg  [15:0] data_real;  //实部原码
  reg  [15:0] data_imag;  //虚部原码
  reg  [18:0] source_valid_d;
  reg  [18:0] source_eop_d;
  wire [15:0] data_sqrt;

  assign data_eop = source_eop_d[7];
  //取实部和虚部的平方和
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      source_data <= 'd0;
      data_real   <= 'd0;
      data_imag   <= 'd0;
    end else begin
      if (source_real[16] == 1'b0)  //由补码计算原码
        data_real <= source_real[15:0];
      else data_real <= ~source_real[15:0] + 1'b1;

      if (source_imag[16] == 1'b0)  //由补码计算原码
        data_imag <= 'd0;
      else data_imag <= 'd0;
      //计算原码平方和
      source_data <= (data_real * data_real) + (data_imag * data_imag);
    end
  end

  //对信号进行打拍延时处理
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      source_eop_d   <= 18'd0;
      source_valid_d <= 18'd0;
    end else begin
      source_valid_d <= {source_valid_d[18:0], source_valid};
      source_eop_d   <= {source_eop_d[18:0], source_eop};
    end
  end
  sqrt u_sqrt (
    .clk    (clk),
    .rst_n  (rst_n),
    .i_vaild(source_valid_d[1]),
    .data_i (source_data),
    .o_vaild(data_valid),
    .data_o (data_sqrt),
    .data_r ()
  );
  assign data_modulus = (data_sqrt * 'd512) / 'd65536;  //对数据进行归一化处理，以适应屏幕
endmodule
