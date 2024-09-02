//////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2022 PANGO MICROSYSTEMS, INC
// ALL RIGHTS REVERVED.
//
// THE SOURCE CODE CONTAINED HEREIN IS PROPRIETARY TO PANGO MICROSYSTEMS, INC.
// IT SHALL NOT BE REPRODUCED OR DISCLOSED IN WHOLE OR IN PART OR USED BY
// PARTIES WITHOUT WRITTEN AUTHORIZATION FROM THE OWNER.
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ns

module ipsxe_fft_onboard_top_tb ();

wire GRS_N;
//输入c
	reg sys_clk; 
	reg sys_rst_n; 
	reg sys_rst_n2; 
	reg [15:0] data_d;
	reg [15:0] data_x;
	reg [15:0] mem1[1:4096];   //设计一个rom放读入的数据      
	reg [15:0] mem2[1:4096];   
	reg  signed [15:0]   xin      	   		   ;
reg  signed [15:0]   din      	   		   ;
integer x_i;
integer x_i_1;
integer d_i;
integer fp1 ; 
reg voice_en_in_x;
wire [11:0] rd_water_level_1;
reg voice_en_out_en;
	parameter xin_num = 20'd690051;//远端参考信号
reg [15:0]  xin_men[xin_num:1];

parameter din_num = 20'd690051;//麦克风信号
reg [15:0]  din_men[din_num:1];
	reg [12:0] i;

//信号初始化，必须有这一步，容易被忽略
initial begin
	sys_clk <= 1'b0; 
	sys_rst_n <= 1'b0;
	sys_rst_n2 <= 1'b0;
	i=1;
    //$readmemb("D:/PDS_FPGA/Audio_python_test/x_d.txt",din_men);//将待滤波信号读入mem
    //$readmemb("D:/PDS_FPGA/Audio_python_test/x_x.txt",xin_men);   

	#1  //延时200ns
	sys_rst_n <= 1'b1;
	sys_rst_n2 <= 1'b1;


end
initial begin
     $readmemb("D:/PDS_FPGA/Audio_test/sim2/data1.txt",din_men); 
       // $readmemb("D:/PDS_FPGA/Audio_test/sim2/aaa.txt",din_men); 
 //  $readmemb("D:/PDS_FPGA/Audio_test_FPGA/LMS/x-x2.txt",xin_men); 

   #46 fp1 = $fopen ("D:/PDS_FPGA/Audio_test/sim2/data2.txt","w");
end
initial
begin
xin                          = 0 ;
din 						 = 0 ;
x_i                          = 1 ; //此处是从1开始计数，也就是说data_men中的第一个数的下标为[1]，而非[0]
x_i_1                          = 1 ;
d_i                          = 16386-1 ;
end

reg        voice_en_out;
wire signed [15:0] voice_data_out;

always@(posedge sys_rst_n2)
  begin
    if(x_i_1=='d120000+1)
      begin
          $fclose(fp1);
          #100;
          $stop;
      end
  end
always@(posedge sys_rst_n2)
  begin
    if (voice_en_out)
      begin
       $fdisplayh(fp1,"%d",voice_data_out);
      end
  end
   always @(posedge sys_rst_n2) begin 
    if ( voice_en_out) begin  //数据请求信号写入
       x_i_1 <= x_i_1+1;
    end
  end
  
//生成时钟，模拟晶振实际的周期时序
always #10 sys_clk <= ~sys_clk; //每10ns，sys_clk进行翻转，达到模拟晶振周期为20ns
//always #24000000 sys_rst_n2 <= ~sys_rst_n2;
always #10 sys_rst_n2 <= ~sys_rst_n2;




// always @(posedge sys_rst_n2) begin 
//    if ( voice_en_in_x) begin  //数据请求信号写入
//       xin <= xin_men[x_i];
//       x_i <= x_i+1;
//    end
//  end
wire data_en;
wire [11:0] wr_water_level;
reg  start;
assign data_en=(wr_water_level<='d1500);

 always @(posedge sys_clk) begin 
    if (data_en) begin  //数据请求信号写入
       din <= din_men[d_i];
       d_i <= d_i+1;
    end
  end
wire fft_finish;
wire ifft_finish;
wire [63:0] data_out;
reg [9:0] fft_addr;
reg en;
wire ifft_en;
wire ifft_en_1;
reg start_ifft;
always@(posedge sys_clk or negedge sys_rst_n)
begin
    if(!sys_rst_n)
        en <= 'd0;
	else if(start_ifft)//finsh
        en <= 'd1;
    else if(fft_addr=='d1023)//finsh
        en <= 'd0;
    else 
        en <= en;
end

   always @(posedge sys_clk) begin 
    if(!sys_rst_n)
        fft_addr <= 'd0;
	else if(en)//finsh
        fft_addr <= fft_addr+'d1;
    else if(fft_addr=='d1023)//finsh
        fft_addr <= 'd0;
    else 
        fft_addr <= fft_addr;
  end

   always @(posedge sys_clk) begin 
    if(!sys_rst_n)
        start <= 'd1;
	 else if(ifft_finish)//finsh
        start <= 'd1;
    else 
        start <= 'd0;
  end


reg start_ifft_1;
   always @(posedge sys_clk) begin 
    if(!sys_rst_n)
        start_ifft <= 'd0;
   else if(fft_finish)//finsh
        start_ifft <= 'd1;
    else 
        start_ifft <= 'd0;
  end
   always @(posedge sys_clk) begin 
    if(!sys_rst_n)
        start_ifft_1 <= 'd0;
    else 
        start_ifft_1 <= start_ifft;
  end

wire [63:0] data_out_ifft;
wire [31:0] data_ifft;
reg [9:0] fft_addr_ifft;
assign data_ifft=data_out_ifft[31:0];
reg start_test;
   always @(posedge sys_clk) begin 
    if(!sys_rst_n||fft_addr_ifft=='d1023)
        start_test <= 'd0;
	 else if(ifft_finish)//finsh
        start_test <= 'd1;
    else 
        start_test <= start_test;
  end
   always @(posedge sys_clk) begin 
    if(!sys_rst_n)
        fft_addr_ifft <= 'd0;
	else if(ifft_en)//finsh
        fft_addr_ifft <= fft_addr_ifft+'d1;
    else if(fft_addr_ifft=='d1023)//finsh
        fft_addr_ifft <= 'd0;
    else 
        fft_addr_ifft <= fft_addr_ifft;
  end

// fft_ip fft_ip(
// .i_clk             	 (sys_clk)   ,
// .i_rstn              (sys_rst_n)  ,
// .i_axi4s_cfg_tdata   ('d1)  ,//fft 1,iff,0
// .fft_finish          (fft_finish)  ,
// .rd_clk              (sys_clk)  ,                  
// .data                ({16'd0,din})  ,
// .start				        (start),
// .data_en             (data_en)  ,
// .ifft_data           ()        ,
// .ifft_en             ()  ,                      
// .data_out            (data_out)  ,
// .fft_addr            (fft_addr)
// );


// fft_ip ifft_ip(
// .i_clk               (sys_clk)   ,
// .i_rstn              (sys_rst_n)  ,
// .i_axi4s_cfg_tdata   ('d0)  ,//fft 1,iff,0
// .fft_finish          (ifft_finish)  ,
// .rd_clk              (sys_clk)  ,                  
// .data                ()  ,
// .start                (start_ifft),
// .data_en             ()  ,
// .ifft_data           (data_out)        ,
// .ifft_en             (ifft_en)  ,                      
// .data_out            (data_out_ifft)  ,
// .fft_addr            (fft_addr_ifft)
// );

wire  [11:0]rd_water_level_out;
 always @(posedge sys_clk) begin 
  if(!sys_rst_n||(rd_water_level_out=='d0))
      voice_en_out <= 'd0;
 else if(rd_water_level_out=='d2047)//finsh
      voice_en_out <= 'd1;
  else 
      voice_en_out <= voice_en_out;
end

 HPSS#(
   .DATA_WIDTH (16)
)U_HPSS
(
.clk			(sys_clk),
.rst_n          (sys_rst_n),
.voice_clk_in   (sys_clk),
.voice_rst_in   (sys_rst_n),
.voice_en_in    (data_en),
.voice_data_in  (din),
.wr_water_level (wr_water_level),
.voice_clk_out  (sys_clk),
.voice_rst_out  (sys_rst_n),
.voice_en_out   (voice_en_out),
.voice_data_out (voice_data_out),
.rd_water_level_out(rd_water_level_out)
   );
   
   
   
  wire [63:0] mid; 
   midian midian(
.clk   (sys_clk),
.rst_n (sys_rst_n),
.a1    (64'd5),
.a2    (64'd2),
.a3    (64'd3),
.a4    (64'd4),
.a5    (64'd1),
.a6    (64'd6),
.a7    (64'd7),
.a8    (64'd15),
.a9    (64'd9),

.mid   (mid)

   );
GTP_GRS GRS_INST (

.GRS_N(1'b1)

);
  

endmodule