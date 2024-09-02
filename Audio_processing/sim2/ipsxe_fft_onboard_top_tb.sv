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

`timescale 1 ns/ 1 ns

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

	#200  //延时200ns
	sys_rst_n <= 1'b1;
	sys_rst_n2 <= 1'b1;


end
initial begin
   $readmemb("D:/PDS_FPGA/Audio_test_FPGA/LMS/x-d2.txt",din_men); 
   $readmemb("D:/PDS_FPGA/Audio_test_FPGA/LMS/x-x2.txt",xin_men); 

   #46 fp1 = $fopen ("D:/PDS_FPGA/Audio_test_FPGA/LMS/lms1.txt","w");
end
initial
begin
xin                          = 0 ;
din 						 = 0 ;
x_i                          = 1 ; //此处是从1开始计数，也就是说data_men中的第一个数的下标为[1]，而非[0]
x_i_1                          = 1 ;
d_i                          = 1 ;
end
always@(posedge sys_rst_n2)
  begin
    if(x_i_1=='d120000+1)
      begin
          $fclose(fp1);
          #100;
          $stop;
      end
  end
   always @(posedge sys_rst_n2) begin 
    if ( voice_en_out_en) begin  //数据请求信号写入
       x_i_1 <= x_i_1+1;
    end
  end
  
//生成时钟，模拟晶振实际的周期时序
always #10 sys_clk <= ~sys_clk; //每10ns，sys_clk进行翻转，达到模拟晶振周期为20ns
//always #24000000 sys_rst_n2 <= ~sys_rst_n2;
always #10 sys_rst_n2 <= ~sys_rst_n2;

wire [15:0]vudio_data ;
wire [15:0]vudio_data_d ;
reg [10:0] vudio_addr;
reg  addr_en;
wire voice_change_finsh;

wire signed[15:0]voice_data_in;
wire signed[15:0]voice_data_out;
always@(posedge sys_rst_n2 or negedge sys_rst_n)
begin
    if(!sys_rst_n||vudio_addr=='d1199)
        vudio_addr <= 'd0;
//	else if(vudio_addr==599)//finsh
//        vudio_addr <= vudio_addr;
    else if(vudio_addr<='d1199)//finsh
        vudio_addr <= vudio_addr + 1;
    else 
        vudio_addr <= vudio_addr;
end
always@(posedge sys_rst_n2 or negedge sys_rst_n)
begin
    if(!sys_rst_n)
        addr_en <= 'd0;
    else if(vudio_addr=='d0)//finsh
        addr_en <= 'd1;
    else 
        addr_en <= 'd0;
end

 x u_x(
.i     (vudio_addr),// fft_ram_1024_cnt
.data (vudio_data)
   );
 d u_d(
.i     (vudio_addr),// fft_ram_1024_cnt
.data (vudio_data_d)
   );
   
always@(posedge sys_rst_n2 or negedge sys_rst_n) 
      if(!sys_rst_n)                                
          data_d <= 16'b0 ;
       else
          data_d <= din_men[i];     //读入数据
          
always@(posedge sys_rst_n2 or negedge sys_rst_n) 
      if(!sys_rst_n)                                
          data_x <= 16'b0 ;
       else
          data_x <= xin_men[i];     //读入数据

   
always@(posedge sys_rst_n2 or negedge sys_rst_n) 
      if(!sys_rst_n)
         i <= 12'd0;
       else
         i <= i + 1'd1;

 always @(posedge sys_rst_n2) begin 
    if ( voice_en_in_x) begin  //数据请求信号写入
       xin <= xin_men[x_i];
       x_i <= x_i+1;
    end
  end

 always @(posedge sys_rst_n2) begin 
    if (voice_en_in_x) begin  //数据请求信号写入
       din <= din_men[d_i];
       d_i <= d_i+1;
    end
  end

always@(posedge sys_rst_n2 or negedge sys_rst_n)
begin
    if(!sys_rst_n)
        voice_en_out_en <= 'd0;
    else if(rd_water_level_1>='d2000)//finsh
        voice_en_out_en <= 'd1;
	else if(rd_water_level_1<='d0)//finsh
        voice_en_out_en <= 'd0;
    else 
        voice_en_out_en <= voice_en_out_en;
end

wire full;
always@(posedge sys_rst_n2 or negedge sys_rst_n)
begin
    if(!sys_rst_n||full)
        voice_en_in_x <= 'd0;
    else 
        voice_en_in_x <= 'd1;
end
always@(posedge sys_rst_n2)
  begin
    if (voice_en_out_en)
      begin
       $fdisplayh(fp1,"%d",voice_data_out);
      end
  end
Echo_cancellation_LMS#(
  .DATA_WIDTH(16)
)u_Echo_cancellation_LMS
(
. clk			(sys_clk),
. rst_n         (sys_rst_n),
.voice_clk_in_x 	(sys_rst_n2),	    
.voice_rst_in_x 	(sys_rst_n),	    
.voice_en_in_x  	(voice_en_in_x),	    
.voice_data_in_x  (xin),
 .voice_clk_in_d 	(sys_rst_n2),	    
 .voice_rst_in_d 	(sys_rst_n),	    
 .voice_en_in_d  	(voice_en_in_x),	    
 .voice_data_in_d  (din),                 
 .voice_clk_out  (sys_rst_n2),
 .voice_rst_out  (sys_rst_n),
 .voice_en_out   (voice_en_out_en),
 .voice_data_out (voice_data_out),
 .full         (full),
 .rd_water_level_1(rd_water_level_1)
);



GTP_GRS GRS_INST (

.GRS_N(1'b1)

);
  

endmodule