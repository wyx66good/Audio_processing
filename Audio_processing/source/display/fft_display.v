module fft_display (
  input         rst_n,
  input         i_clk_100m,
  input         pclk,
  input         i_hs,
  input         i_vs,
  input         i_de,
  input  [23:0] i_data,
  output        o_hs,
  output        o_vs,
  output        o_de,
  output [23:0] o_data,

  input  [8:0] fft_data,   //取模后的数据
  input        fft_eop,    //取模后输出的终止信号
  input        fft_valid,  //取模后的数据有效信号
  output       out_vsync   //帧同步，高有效
);
  localparam BLACK = 24'b00000000_00000000_00000000;  //RGB888 黑色
  localparam WHITE = 24'b11111111_11111111_11111111;  //RGB888 白色
  localparam BLUE = 24'b00000000_00000000_11111111;  //RGB888 蓝色
  localparam RED = 24'b11111111_00000000_00000000;  //RGB888 红色
  localparam YELLOW = 24'h00ff00;  //黄色
  wire [11:0] pos_x;
  wire [11:0] pos_y;
  wire        pos_hs;
  wire        pos_vs;
  wire        pos_de;
  wire [23:0] pos_data;
  reg  [23:0] v_data;
  assign o_data    = v_data;
  assign o_hs      = pos_hs;
  assign o_vs      = pos_vs;
  assign o_de      = pos_de;
  assign out_vsync = pos_vs;
  //wire define
  wire [ 8:0] ram_data_out;  //ram读数据
  wire [ 8:0] fft_point_cnt;  //FFT频谱位置0~511
  reg         fft_point_done;  //FFT当前频谱绘制完成
  reg         data_req;  //请求数据信号
  reg  [ 3:0] fft_step;

  reg  [ 8:0] fft_point_cnt_d0;
  reg  [ 8:0] fft_point_cnt_d1;
  reg         data_req_d0;
  reg         data_req_d1;

  reg  [10:0] fft_y_frame_start;  //产生Y方向上的边框结束位置
  reg  [10:0] fft_x_frame_start;  //产生X方向上的边框结束位置
  reg  [10:0] fft_x_frame_end;  //产生X方向上的边框结束位置
  reg  [10:0] fft_y_frame_end;  //产生Y方向上的边框结束位置

  reg  [23:0] x_frame_data;  //竖直方向上的边框数据
  reg  [23:0] y_frame_data;  //水平方向上的边框数据

  //对信号打拍
  always @(posedge pclk or negedge rst_n) begin
    if (!rst_n) begin
      fft_point_cnt_d0 <= 8'd0;
      fft_point_cnt_d1 <= 8'd0;
      data_req_d0      <= 1'b0;
      data_req_d1      <= 1'b0;
    end else begin
      fft_point_cnt_d0 <= fft_point_cnt;
      fft_point_cnt_d1 <= fft_point_cnt_d0;
      data_req_d0      <= data_req;
      data_req_d1      <= data_req_d0;
    end
  end

  //产生一个采样点的频谱宽度，本次的显示的点是512个，所以采用2个像素作为宽度
  always @(posedge pclk or negedge rst_n) begin
    if (!rst_n) fft_step <= 4'd0;
    else begin
      fft_step <= 'd2;
    end
  end
  //产生X方向上的边框结束位置
  always @(posedge pclk or negedge rst_n) begin
    if (!rst_n) fft_x_frame_end <= 11'd0;
    else begin
      fft_x_frame_end <= 'd453 + fft_step * 512;  //'d453为音频显示框起点
    end
  end

  //产生X方向上的边框起始位置
  always @(posedge pclk or negedge rst_n) begin
    if (!rst_n) fft_x_frame_start <= 11'd0;
    else begin
      fft_x_frame_start <= 'd453;
    end
  end

  //产生Y方向上的边框结束位置
  always @(posedge pclk or negedge rst_n) begin
    if (!rst_n) fft_y_frame_end <= 11'd0;
    else begin
      fft_y_frame_end <= 'd607;  //'d351+'d256='d607
    end
  end

  //产生Y方向上的边框起始位置
  always @(posedge pclk or negedge rst_n) begin
    if (!rst_n) fft_y_frame_start <= 11'd0;
    else begin
      fft_y_frame_start <= 'd351;  //'d287+'d32+'d32='d351
    end
  end

  //产生请求数据信号
  always @(posedge pclk or negedge rst_n) begin
    if (!rst_n) data_req <= 1'b0;
    else begin
      if ((pos_x == (fft_point_cnt + 1) * fft_step - 3 + 'd453) && (pos_y >= fft_y_frame_start)) data_req <= 1'b1;
      else data_req <= 1'b0;
    end
  end

  //1行结束，拉高done信号，表示此次的频谱显示已完成
  always @(posedge pclk or negedge rst_n) begin
    if (!rst_n) fft_point_done <= 1'b0;
    else begin
      if (pos_x == 'd1920 - 1) fft_point_done <= 1'b1;
      else fft_point_done <= 1'b0;
    end
  end

  //产生竖直方向上的边框数据
  always @(posedge pclk or negedge rst_n) begin
    if (!rst_n) x_frame_data <= BLACK;
    else begin
      if (pos_y >= fft_y_frame_start && pos_y <= fft_y_frame_end) begin
        if (pos_x == fft_x_frame_start - 1) x_frame_data <= 24'h191970;  //24'h191970藏青
        else if (data_req_d1) begin
          if (fft_point_cnt_d1 == 85) x_frame_data <= 24'h191970;
          else if (fft_point_cnt_d1 == 170) x_frame_data <= 24'h191970;
          else if (fft_point_cnt_d1 == 255) x_frame_data <= 24'h191970;
          else if (fft_point_cnt_d1 == 340) x_frame_data <= 24'h191970;
          else if (fft_point_cnt_d1 == 425) x_frame_data <= 24'h191970;
          else if (fft_point_cnt_d1 == 510) x_frame_data <= 24'h191970;
          else x_frame_data <= BLACK;
        end else x_frame_data <= BLACK;
      end else x_frame_data <= BLACK;
    end
  end

  //产生水平方向上的边框数据
  always @(posedge pclk or negedge rst_n) begin
    if (!rst_n) y_frame_data <= BLACK;
    else begin
      if ((pos_x >= fft_x_frame_start) && (pos_x <= fft_x_frame_end - 2)) begin
        if (pos_y == fft_y_frame_start) y_frame_data <= 24'h191970;
        else if (pos_y == fft_y_frame_start + 'd51) y_frame_data <= 24'h191970;
        else if (pos_y == fft_y_frame_start + 'd102) y_frame_data <= 24'h191970;
        else if (pos_y == fft_y_frame_start + 'd153) y_frame_data <= 24'h191970;
        else if (pos_y == fft_y_frame_start + 'd204) y_frame_data <= 24'h191970;
        else if (pos_y == fft_y_frame_start + 'd256) y_frame_data <= 24'h191970;
        else y_frame_data <= BLACK;
      end else y_frame_data <= BLACK;
    end
  end

  //产生像素数据信号
  always @(posedge pclk or negedge rst_n) begin
    if (!rst_n) v_data <= BLACK;
    else begin
      if (x_frame_data[20]) v_data <= x_frame_data;
      else if (y_frame_data[20]) v_data <= y_frame_data;
      else if ((pos_x >= (fft_point_cnt_d0 * fft_step + 'd453)) && (pos_x < (fft_point_cnt_d0 + 1'd1) * fft_step + 'd453)) begin
        if ((pos_y >= fft_y_frame_end - ram_data_out / 'd2) && (pos_y <= fft_y_frame_end)) v_data <= 24'hcc0000;  //红
        else v_data <= pos_data;
      end else v_data <= pos_data;
    end
  end
  //ram读写控制模块zz
  fft_ram_ctrl u_rw_ram_ctrl (
    .clk    (i_clk_100m),
    .lcd_clk(pclk),
    .rst_n  (rst_n),

    .fft_data (fft_data),
    .fft_eop  (fft_eop),
    .fft_valid(fft_valid),

    .data_req      (data_req),        //请求数据信号
    .fft_point_done(fft_point_done),  //FFT当前频谱绘制完成
    .fft_point_cnt (fft_point_cnt),   //FFT频谱位置

    .ram_data_out(ram_data_out)  //ram读数据
  );

  timing_gen_xy timing_gen_xy_m0 (
    .rst_n (rst_n),
    .clk   (pclk),
    .i_hs  (i_hs),
    .i_vs  (i_vs),
    .i_de  (i_de),
    .i_data(i_data),
    .o_hs  (pos_hs),
    .o_vs  (pos_vs),
    .o_de  (pos_de),
    .o_data(pos_data),
    .x     (pos_x),
    .y     (pos_y)
  );
endmodule
