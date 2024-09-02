module char_display (
  input         rst_n,   //复位信号
  input         pclk,    //像素时钟
  input         i_hs,    //行同步输入信号   
  input         i_vs,    //场同步输入信号
  input         i_de,    //图像有效输入信号
  input  [23:0] i_data,  //图像数据输入信号
  output        o_hs,    //行同步输出信号    
  output        o_vs,    //场同步输出信号 
  output        o_de,    //图像有效输出信号 
  output [23:0] o_data   //图像数据输出信号
);
  parameter OSD_WIDTH = 12'd416;  //设置OSD的宽度，可根据字符生成软件设置
  parameter OSD_HEGIHT = 12'd32;  //设置OSD的高度，可根据字符生成软件设置

  parameter OSD1_WIDTH = 12'd384;
  parameter OSD1_HEGIHT = 12'd32;

  parameter OSD2_WIDTH = 12'd304;
  parameter OSD2_HEGIHT = 12'd32;

  wire [11:0] pos_x;  //X坐标
  wire [11:0] pos_y;  //Y坐标
  wire        pos_hs;
  wire        pos_vs;
  wire        pos_de;
  wire [23:0] pos_data;
  reg  [23:0] v_data;

  reg  [11:0] osd_x;
  reg  [11:0] osd1_x;
  reg  [11:0] osd2_x;

  reg  [11:0] osd_y;

  reg  [15:0] osd_ram_addr;
  reg  [15:0] osd1_ram_addr;
  reg  [15:0] osd2_ram_addr;

  wire [ 7:0] q ='d0;
  wire [ 7:0] q1='d0;
  wire [ 7:0] q2='d0;

  reg         region_active;
  reg         region_active_d0;
  reg         region_active_d1;
  reg         region_active_d2;

  reg         region1_active;
  reg         region1_active_d0;
  reg         region1_active_d1;
  reg         region1_active_d2;

  reg         region2_active;
  reg         region2_active_d0;
  reg         region2_active_d1;
  reg         region2_active_d2;

  reg         pos_vs_d0;
  reg         pos_vs_d1;

  assign o_data = v_data;
  assign o_hs   = pos_hs;
  assign o_vs   = pos_vs;
  assign o_de   = pos_de;
  ////                                                       ////
  //OSD区域设置，起始坐标为（1，752），区域大小根据生成的字符长宽设置
  always @(posedge pclk) begin
    if (pos_y >= 12'd1 && pos_y <= 12'd1 + OSD_HEGIHT - 12'd1 && pos_x >= 12'd752 && pos_x <= 12'd752 + OSD_WIDTH - 12'd1) region_active <= 1'b1;
    else region_active <= 1'b0;
  end

  always @(posedge pclk) begin
    region_active_d0 <= region_active;
    region_active_d1 <= region_active_d0;
    region_active_d2 <= region_active_d1;
  end

  always @(posedge pclk) begin
    pos_vs_d0 <= pos_vs;
    pos_vs_d1 <= pos_vs_d0;
  end

  //产生OSD的计数器
  always @(posedge pclk) begin
    if (region_active_d0 == 1'b1) osd_x <= osd_x + 12'd1;
    else osd_x <= 12'd0;
  end
  //产生ROM的读地址，在region_active有效时，地址加1
  always @(posedge pclk) begin
    if (pos_vs_d1 == 1'b1 && pos_vs_d0 == 1'b0) osd_ram_addr <= 16'd0;
    else if (region_active == 1'b1) osd_ram_addr <= osd_ram_addr + 16'd1;
  end
  ////                                                       ////

  ////                                                       ////
  //OSD1区域设置 320，768
  always @(posedge pclk) begin
    if (pos_y >= 12'd320 && pos_y <= 12'd320 + OSD1_HEGIHT - 12'd1 && pos_x >= 12'd768 && pos_x <= 12'd768 + OSD1_WIDTH - 12'd1) region1_active <= 1'b1;
    else region1_active <= 1'b0;
  end
  always @(posedge pclk) begin
    region1_active_d0 <= region1_active;
    region1_active_d1 <= region1_active_d0;
    region1_active_d2 <= region1_active_d1;
  end
  //产生OSD1的计数器
  always @(posedge pclk) begin
    if (region1_active_d0 == 1'b1) osd1_x <= osd1_x + 12'd1;
    else osd1_x <= 12'd0;
  end
  //产生ROM的读地址，在region1_active有效时，地址加1
  always @(posedge pclk) begin
    if (pos_vs_d1 == 1'b1 && pos_vs_d0 == 1'b0) osd1_ram_addr <= 16'd0;
    else if (region1_active == 1'b1) osd1_ram_addr <= osd1_ram_addr + 16'd1;
  end
  ////                                                       ////

  //OSD2区域设置 638，764
  always @(posedge pclk) begin
    if (pos_y >= 12'd638 && pos_y <= 12'd638 + OSD2_HEGIHT - 12'd1 && pos_x >= 12'd810 && pos_x <= 12'd810 + OSD2_WIDTH - 12'd1) region2_active <= 1'b1;
    else region2_active <= 1'b0;
  end
  always @(posedge pclk) begin
    region2_active_d0 <= region2_active;
    region2_active_d1 <= region2_active_d0;
    region2_active_d2 <= region2_active_d1;
  end
  //产生OSD2的计数器
  always @(posedge pclk) begin
    if (region2_active_d0 == 1'b1) osd2_x <= osd2_x + 12'd1;
    else osd2_x <= 12'd0;
  end
  //产生ROM的读地址，在region2_active有效时，地址加1
  always @(posedge pclk) begin
    if (pos_vs_d1 == 1'b1 && pos_vs_d0 == 1'b0) osd2_ram_addr <= 16'd0;
    else if (region2_active == 1'b1) osd2_ram_addr <= osd2_ram_addr + 16'd1;
  end
  ////                                                       ////

  //像素赋值
  always @(posedge pclk) begin
    if (region_active_d0 == 1'b1 || region1_active_d0 == 1'b1 || region2_active_d0 == 1'b1) begin
      if (q[osd_x[2:0]] == 1'b1 || q1[osd1_x[2:0]] == 1'b1 || q2[osd2_x[2:0]] == 1'b1)  //检查bit位是否是1，如果是1，将此像素设为自定义色
        v_data <= 24'h0066cc;  //字体颜色
      else v_data <= pos_data;  //否则保持原来的值
    end else v_data <= pos_data;
  end

//  char_rom voice_char_rom (
//    .addr   (osd_ram_addr[15:3]),  //生成的字符一个点为1bit，由于数据宽度为8bit，因此8个周期检查一次数据
//    .clk    (pclk),
//    .rst    (1'b0),
//    .rd_data(q)
//  );
//  char1_rom orignal_fft_char_rom (
//    .addr   (osd1_ram_addr[15:3]),  // input [10:0]
//    .clk    (pclk),                 // input
//    .rst    (1'b0),                 // input
//    .rd_data(q1)                    // output [7:0]
//  );
//
//  char2_rom ap_fft_char_rom (
//    .addr   (osd2_ram_addr[15:3]),  // input [10:0]
//    .clk    (pclk),                 // input
//    .rst    (1'b0),                 // input
//    .rd_data(q2)                    // output [7:0]
//  );


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
