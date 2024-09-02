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

module MFCC_VQ_tb ();

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
reg  signed [15:0]   din    ;
reg  signed [15:0]   din1    ;
reg  signed [15:0]   din2    ;
reg  signed [15:0]   din3    ;
reg  signed [15:0]   din4   ;

reg  signed [15:0]   din26  ;
reg  signed [15:0]   din40  ;
reg  signed [15:0]   din63  ;
integer x_i;
integer x_i_1;
integer d_i;
integer d_i1;
integer d_i2;
integer d_i3;
integer d_i4;
integer d_i26;
integer d_i40;
integer d_i63;
integer fp1 ; 
reg voice_en_in_x;
wire [11:0] rd_water_level_1;
reg voice_en_out_en;
	parameter xin_num = 20'd690051;//远端参考信号
reg [15:0]  xin_men[xin_num:1];

parameter din_num = 20'd690051;//麦克风信号
parameter din_num1 = 20'd690051;//麦克风信号
parameter din_num2 = 20'd690051;//麦克风信号
parameter din_num3 = 20'd690051;//麦克风信号
parameter din_num4 = 20'd690051;//麦克风信号
parameter din_num26 = 20'd690051;//麦克风信号
parameter din_num40 = 20'd690051;//麦克风信号
parameter din_num63 = 20'd690051;//麦克风信号

reg [15:0]  din_men[din_num:1];
reg [15:0]  din_men1[din_num1:1];
reg [15:0]  din_men2[din_num2:1];
reg [15:0]  din_men3[din_num3:1];
reg [15:0]  din_men4[din_num4:1];
reg [15:0]  din_men26[din_num26:1];
reg [15:0]  din_men40[din_num40:1];
reg [15:0]  din_men63[din_num63:1];

	reg [12:0] i;
   reg   VQ_identifys_start;











//信号初始化，必须有这一步，容易被忽略
initial begin
	sys_clk <= 1'b0; 
	sys_rst_n <= 1'b0;
	VQ_identifys_start<='d0;
	sys_rst_n2 <= 1'b0;
	i=1;
    //$readmemb("D:/PDS_FPGA/Audio_python_test/x_d.txt",din_men);//将待滤波信号读入mem
    //$readmemb("D:/PDS_FPGA/Audio_python_test/x_x.txt",xin_men);   

	#1  //延时200ns
	sys_rst_n <= 1'b1;
	sys_rst_n2 <= 1'b1;


end
//生成时钟，模拟晶振实际的周期时序
always #1 sys_clk <= ~sys_clk; //每10ns，sys_clk进行翻转，达到模拟晶振周期为20ns
always #1 sys_rst_n2 <= ~sys_rst_n2;


initial begin
     $readmemb("D:/PDS_FPGA/Audio_test/sim2/MFCC_VQ_1.txt",din_men); 
     $readmemb("D:/PDS_FPGA/Audio_test/sim2/MFCC_VQ_26.txt",din_men26); 
	 $readmemb("D:/PDS_FPGA/Audio_test/sim2/MFCC_VQ_40.txt",din_men40); 
	 $readmemb("D:/PDS_FPGA/Audio_test/sim2/MFCC_VQ_63.txt",din_men63); 
	 $readmemb("D:/PDS_FPGA/Audio_test/sim2/MFCC_VQ_1_1.txt",din_men1);
	 $readmemb("D:/PDS_FPGA/Audio_test/sim2/MFCC_VQ_2_2.txt",din_men2);
	 $readmemb("D:/PDS_FPGA/Audio_test/sim2/MFCC_VQ_3_3.txt",din_men3);
	 $readmemb("D:/PDS_FPGA/Audio_test/sim2/MFCC_VQ_4_4.txt",din_men4);
end
initial
begin
xin                            = 0 ;
din 						   = 0 ;
din26 						   = 0 ;
din40 						   = 0 ;
din63 						   = 0 ;
din1						   = 0 ;
din2 						   = 0 ;
din3 						   = 0 ;
din4 						   = 0 ;
x_i                            = 1 ; //此处是从1开始计数，也就是说data_men中的第一个数的下标为[1]，而非[0]
x_i_1                          = 1 ;
d_i                            = 6386-1 ;
d_i1                            = 6386-1 ;
d_i2                            = 6386-1 ;
d_i3                            = 6386-1 ;
d_i4                            = 6386-1 ;
d_i26                          = 6386-1 ;
d_i40                          = 6386-1 ;
d_i63                          = 6386-1 ;

end
reg VQ_START;
reg VQ_STOP;
reg XUNLIAN_START;
reg VQ_identify_START;
reg MFCC_EN;
reg one;
reg two;
reg three;
reg four;
reg one_1;
reg two_2;
reg three_3;
reg four_4;
reg VQ_EN;

initial begin
	VQ_START<='d0;
	VQ_STOP<='d0;
	XUNLIAN_START<='d0;
	one<='d0;
	two<='d0;
	three<='d0;
	four<='d0;
	one_1<='d0;
	two_2<='d0;
	three_3<='d0;
	four_4<='d0;
	VQ_EN<='d0;
	VQ_identify_START<='d0;
	#15
	VQ_START<='d1;
	one<='d1;
	#16
	VQ_START<='d0;
	#1500000
	VQ_STOP<='d1;
	#2
	VQ_STOP<='d0;
	XUNLIAN_START<='d1;
	#2
	XUNLIAN_START<='d0;
	

	
	#1000000
	one<='d0;
	VQ_START<='d1;
	two<='d1;
	#2
	VQ_START<='d0;
	#1500000
	VQ_STOP<='d1;
	#2
	VQ_STOP<='d0;
	XUNLIAN_START<='d1;
	#2
	XUNLIAN_START<='d0;
	
	
	#1000000
	two<='d0;
	VQ_START<='d1;
	three<='d1;
	#2
	VQ_START<='d0;
	#1500000
	VQ_STOP<='d1;
	#2
	VQ_STOP<='d0;
	XUNLIAN_START<='d1;
	#2
	XUNLIAN_START<='d0;
	
	
	#1000000
	three<='d0;
	VQ_START<='d1;
	four<='d1;
	#2
	VQ_START<='d0;
	#1500000
	VQ_STOP<='d1;
	#2
	VQ_STOP<='d0;
	XUNLIAN_START<='d1;
	#2
	XUNLIAN_START<='d0;
	
	
	#1000000
	four<='d0;
	d_i                            = 6386-1 ;
	d_i26                          = 6386-1 ;
	d_i40                          = 6386-1 ;
	d_i63                          = 6386-1 ;
	VQ_START<='d1;
	two<='d1;//2
	VQ_EN<='d1;
	#2
	VQ_START<='d0;
	#1500000
	VQ_STOP<='d1;
	two<='d0;
	VQ_EN<='d0;
	#2
	VQ_STOP<='d0;
	VQ_identify_START<='d1;
	#2
	VQ_identify_START<='d0;
	
	#100000
	d_i                            = 6386-1 ;
	d_i26                          = 6386-1 ;
	d_i40                          = 6386-1 ;
	d_i63                          = 6386-1 ;
	VQ_START<='d1;
	one<='d1;//1
	VQ_EN<='d1;
	#2
	VQ_START<='d0;
	#1500000
	VQ_STOP<='d1;
	one<='d0;
	VQ_EN<='d0;
	#2
	VQ_STOP<='d0;
	VQ_identify_START<='d1;
	#2
	VQ_identify_START<='d0;
	
	#100000
	d_i                            = 6386-1 ;
	d_i26                          = 6386-1 ;
	d_i40                          = 6386-1 ;
	d_i63                          = 6386-1 ;
	VQ_START<='d1;
	four<='d1;//4
	VQ_EN<='d1;
	#2
	VQ_START<='d0;
	#1500000
	VQ_STOP<='d1;
	four<='d0;
	VQ_EN<='d0;
	#2
	VQ_STOP<='d0;
	VQ_identify_START<='d1;
	#2
	VQ_identify_START<='d0;
	
	#100000
	d_i                            = 6386-1 ;
	d_i26                          = 6386-1 ;
	d_i40                          = 6386-1 ;
	d_i63                          = 6386-1 ;
	VQ_START<='d1;
	three<='d1;//3
	VQ_EN<='d1;
	#2
	VQ_START<='d0;
	#1500000
	VQ_STOP<='d1;
	three<='d0;
	VQ_EN<='d0;
	#2
	VQ_STOP<='d0;
	VQ_identify_START<='d1;
	#2
	VQ_identify_START<='d0;
	
	#100000
	d_i                            = 6386-1 ;
	d_i26                          = 6386-1 ;
	d_i40                          = 6386-1 ;
	d_i63                          = 6386-1 ;
	VQ_START<='d1;
	one_1<='d1;
	VQ_EN<='d1;
	#2
	VQ_START<='d0;
	#1500000
	VQ_STOP<='d1;
	one_1<='d0;
	VQ_EN<='d0;
	#2
	VQ_STOP<='d0;
	VQ_identify_START<='d1;
	#2
	VQ_identify_START<='d0;
	
	#100000
	d_i                            = 6386-1 ;
	d_i26                          = 6386-1 ;
	d_i40                          = 6386-1 ;
	d_i63                          = 6386-1 ;
	VQ_START<='d1;
	two_2<='d1;
	VQ_EN<='d1;
	#2
	VQ_START<='d0;
	#1500000
	VQ_STOP<='d1;
	two_2<='d0;
	VQ_EN<='d0;
	#2
	VQ_STOP<='d0;
	VQ_identify_START<='d1;
	#2
	VQ_identify_START<='d0;
	
	#100000
	d_i                            = 6386-1 ;
	d_i26                          = 6386-1 ;
	d_i40                          = 6386-1 ;
	d_i63                          = 6386-1 ;
	VQ_START<='d1;
	three_3<='d1;
	VQ_EN<='d1;
	#2
	VQ_START<='d0;
	#1500000
	VQ_STOP<='d1;
	three_3<='d0;
	VQ_EN<='d0;
	#2
	VQ_STOP<='d0;
	VQ_identify_START<='d1;
	#2
	VQ_identify_START<='d0;	
	
	#100000
	d_i                            = 6386-1 ;
	d_i26                          = 6386-1 ;
	d_i40                          = 6386-1 ;
	d_i63                          = 6386-1 ;
	VQ_START<='d1;
	four_4<='d1;
	VQ_EN<='d1;
	#2
	VQ_START<='d0;
	#1500000
	VQ_STOP<='d1;
	four_4<='d0;
	VQ_EN<='d0;
	#2
	VQ_STOP<='d0;
	VQ_identify_START<='d1;
	#2
	VQ_identify_START<='d0;	
end
   always @(posedge sys_clk or negedge sys_rst_n) begin 
    if(!sys_rst_n)
        MFCC_EN <= 'd0;
    else if(VQ_START)
        MFCC_EN <= 'd1;
	else if(VQ_STOP)
        MFCC_EN <= 'd0;
	else 
        MFCC_EN <= MFCC_EN;
  end
  
  


wire [11:0]wr_water_level;
reg MFCC_VQ_en;
   always @(posedge sys_clk or negedge sys_rst_n) begin 
    if(!sys_rst_n)
        MFCC_VQ_en <= 'd0;
    else if((wr_water_level<'d2047)&&MFCC_EN)
        MFCC_VQ_en <= 'd1;
	else 
        MFCC_VQ_en <= 'd0;
  end

wire  [12:0]      MFCCS13_ADDR;
wire  [7:0]      LBG_rd_addr_1;
 always @(posedge sys_clk or negedge sys_rst_n) begin 
    if (MFCC_VQ_en&&(one)) begin  //数据请求信号写入 
	   din <= din_men[d_i];
       d_i <= d_i+1;
    end
  end
   always @(posedge sys_clk or negedge sys_rst_n) begin 
    if (MFCC_VQ_en&&(two)) begin  //数据请求信号写入
	   din26 <= din_men26[d_i26];
       d_i26 <= d_i26+1;
    end
  end
  always @(posedge sys_clk or negedge sys_rst_n) begin 
    if (MFCC_VQ_en&&(three)) begin  //数据请求信号写入
	   din40 <= din_men40[d_i40];
       d_i40 <= d_i40+1;
    end
  end
    always @(posedge sys_clk or negedge sys_rst_n) begin 
    if (MFCC_VQ_en&&(four)) begin  //数据请求信号写入
	   din63 <= din_men63[d_i63];
       d_i63 <= d_i63+1;
    end
  end
  
      always @(posedge sys_clk or negedge sys_rst_n) begin 
    if (MFCC_VQ_en&&(one_1)) begin  //数据请求信号写入
	   din1 <= din_men1[d_i1];
       d_i1 <= d_i1+1;
    end
  end
  
      always @(posedge sys_clk or negedge sys_rst_n) begin 
    if (MFCC_VQ_en&&(two_2)) begin  //数据请求信号写入
	   din2 <= din_men2[d_i2];
       d_i2 <= d_i2+1;
    end
  end
  
      always @(posedge sys_clk or negedge sys_rst_n) begin 
    if (MFCC_VQ_en&&(three_3)) begin  //数据请求信号写入
	   din3 <= din_men3[d_i3];
       d_i3 <= d_i3+1;
    end
  end
  
      always @(posedge sys_clk or negedge sys_rst_n) begin 
    if (MFCC_VQ_en&&(four_4)) begin  //数据请求信号写入
	   din4 <= din_men4[d_i4];
       d_i4 <= d_i4+1;
    end
  end

wire  signed [15:0]   voice_data_in    ;

assign voice_data_in=(one)?din:((two))?din26:(three)?din40:(four)?din63:
					(one_1)?din1:(two_2)?din2:(three_3)?din3:(four_4)?din4:'d0;


wire [3:0] VQ_D;

 MFCC_VQ#(
   .DATA_WIDTH (16)
)U_MFCC_VQ
(
.clk			(sys_clk),
.rst_n          (sys_rst_n),
.voice_clk_in   (sys_clk),
.voice_rst_in   (sys_rst_n&&!VQ_STOP),
.voice_en_in    (MFCC_VQ_en),
.voice_data_in  (voice_data_in),
.anew('d0),
.VQ_START (VQ_START),
.VQ_STOP  (VQ_STOP),

.XUNLIAN_START(XUNLIAN_START),
.VQ_identify  (VQ_identify_START),
.LBG_1((one)),
.LBG_2((two)),
.LBG_3((three)),
.LBG_4((four)),
.VQ_D  (VQ_D),
.wr_water_level(wr_water_level)
   );
   // wire VQ_identifys_finsh;
// VQ_identifys VQ_identifys(
// .clk  				(sys_clk),
// .rst_n             ( sys_rst_n),
// .VQ_identifys_start( VQ_identifys_start), //开始识别
// .VQ_identifys_finsh( VQ_identifys_finsh), //结束识别
// .DCT_ADDR          ('d2600 ),
// .Frams_Number      ( 'd200),
// .MFCCS13_ADDR      (MFCCS13_ADDR ),
// .MFCCS13_DATA      ({din[15],din[12:0]} ),
// .LBG_rd_data_1     ( {din26[15],din26[12:0]}),
// .LBG_rd_addr_1     (LBG_rd_addr_1 )


   // );
// VQ_LBG_XUNLIAN u_VQ_LBG_XUNLIAN(
// .clk              (sys_clk          ),
// .rst_n            (sys_rst_n        ),
// .START            (XUNLIAN_START        ),
// .DCT_ADDR         ('d2600     ),
// .Frams_Number     ('d200 ),
// .MFCCS13_ADDR     (MFCCS13_ADDR ),
// .MFCCS13_DATA     (din )
   // );

GTP_GRS GRS_INST (

.GRS_N(1'b1)

);
  

endmodule