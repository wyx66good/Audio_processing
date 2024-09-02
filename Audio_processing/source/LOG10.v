
// -----------------------------------------------------------------------------
// Author : lh
// File   : log.v
// Create : 2024-07-12 16:53:29
// Revise : 2024-07-17 22:08:15
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
module LOG10(
	input			wire					clk,
	input			wire					rst_n,

	input			wire					i_en, //为高电平时进行一次变换操作
	input			wire signed	[40:0]		data_in,
	output			wire					o_en, //输出使能信号
	output			wire		[17:0]		data_out // out的数除以2^16，再乘以0.86858896即为最后的结果
	);


parameter p_tnah_0  = 'd181574 , 
          p_tnah_1  = 'd158735 ,
          p_tnah_2  = 'd135764 ,
          p_tnah_3  = 'd112525 ,
          p_tnah_4  = 'd88736  ,
          p_tnah_5  = 'd63767  ,
          p_tnah_6  = 'd35999  ,
          p_tnah_7  = 'd16738  ,
          p_tnah_8  = 'd8238   ,
          p_tnah_9  = 'd4103   ,
          p_tnah_10 = 'd4103   ,
          p_tnah_11 = 'd2051   ,
          p_tnah_12 = 'd1022   ,
          p_tnah_13 = 'd511    ,
          p_tnah_14 = 'd256    ,
          p_tnah_15 = 'd131    ;





reg signed	[50:0]				x_data;
reg	signed	[50:0]				y_data;
reg	signed	[40:0]				z_data;

always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		x_data <= 'd0;
		y_data <= 'd0;
		z_data <= 'd0;
	end
	else if (data_in < 1000) begin  //小于1000就扩大更多倍
		x_data <= {(data_in + 1'b1)<<12,10'b0};
		y_data <= {(data_in - 1'b1)<<12,10'b0};
		z_data <= 'd0;
	end 
	else begin //扩大倍速增加迭代次数增加准确性
		x_data <= {data_in + 1'b1,10'b0};
		y_data <= {data_in - 1'b1,10'b0};
		z_data <= 'd0;
	end
end

//第一次迭代 i+S=0+-5
reg signed	[50:0]				x_data_1;
reg	signed	[50:0]				y_data_1;
reg	signed	[40:0]				z_data_1;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		x_data_1 <= 'd0;
		y_data_1 <= 'd0;
		z_data_1 <= 'd0;
	end
	else if (y_data<=0) begin  //负数
		x_data_1 <= x_data + (y_data - (y_data >>> (5 + 2)));
		y_data_1 <= y_data + (x_data - (x_data >>> (5 + 2)));
		z_data_1 <= z_data - p_tnah_0 ;
	end 
	else begin
		x_data_1 <= x_data - (y_data - (y_data >>> (5 + 2)));
		y_data_1 <= y_data - (x_data - (x_data >>> (5 + 2)));
		z_data_1 <= z_data + p_tnah_0 ;
	end
end

//第二次迭代 i+S=1+-5
reg signed	[50:0]				x_data_2;
reg	signed	[50:0]				y_data_2;
reg	signed	[40:0]				z_data_2;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		x_data_2 <= 'd0;
		y_data_2 <= 'd0;
		z_data_2 <= 'd0;
	end
	else if (y_data_1<=0) begin  //负数
		x_data_2 <= x_data_1 + (y_data_1 - (y_data_1 >>> (5 - 1 + 2)));
		y_data_2 <= y_data_1 + (x_data_1 - (x_data_1 >>> (5 - 1 + 2)));
		z_data_2 <= z_data_1 - p_tnah_1 ;
	end 
	else  begin
		x_data_2 <= x_data_1 - (y_data_1 - (y_data_1 >>> (5 - 1 + 2)));
		y_data_2 <= y_data_1 - (x_data_1 - (x_data_1 >>> (5 - 1 + 2)));
		z_data_2 <= z_data_1 + p_tnah_1 ;
	end
end

//第三次迭代 i+S=2+-5
reg signed	[50:0]				x_data_3;
reg	signed	[50:0]				y_data_3;
reg	signed	[40:0]				z_data_3;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		x_data_3 <= 'd0;
		y_data_3 <= 'd0;
		z_data_3 <= 'd0;
	end
	else if (y_data_2<=0) begin  //负数
		x_data_3 <= x_data_2 + (y_data_2 - (y_data_2 >>> (5 - 2 + 2)));
		y_data_3 <= y_data_2 + (x_data_2 - (x_data_2 >>> (5 - 2 + 2)));
		z_data_3 <= z_data_2 - p_tnah_2 ;
	end 
	else  begin
		x_data_3 <= x_data_2 - (y_data_2 - (y_data_2 >>> (5 - 2 + 2)));
		y_data_3 <= y_data_2 - (x_data_2 - (x_data_2 >>> (5 - 2 + 2)));
		z_data_3 <= z_data_2 + p_tnah_2 ;
	end
end

//第四次迭代 i+S=3+-5
reg signed	[50:0]				x_data_4;
reg	signed	[50:0]				y_data_4;
reg	signed	[40:0]				z_data_4;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		x_data_4 <= 'd0;
		y_data_4 <= 'd0;
		z_data_4 <= 'd0;
	end
	else if (y_data_3<=0) begin  //负数
		x_data_4 <= x_data_3 + (y_data_3 - (y_data_3 >>> (5 - 3 + 2)));
		y_data_4 <= y_data_3 + (x_data_3 - (x_data_3 >>> (5 - 3 + 2)));
		z_data_4 <= z_data_3 - p_tnah_3 ;
	end 
	else begin
		x_data_4 <= x_data_3 - (y_data_3 - (y_data_3 >>> (5 - 3 + 2)));
		y_data_4 <= y_data_3 - (x_data_3 - (x_data_3 >>> (5 - 3 + 2)));
		z_data_4 <= z_data_3 + p_tnah_3 ;
	end
end

//第五次迭代 i+S=4 +-5 = -1
reg signed	[50:0]				x_data_5;
reg	signed	[50:0]				y_data_5;
reg	signed	[40:0]				z_data_5;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		x_data_5 <= 'd0;
		y_data_5 <= 'd0;
		z_data_5 <= 'd0;
	end
	else if (y_data_4<=0) begin  //负数
		x_data_5 <= x_data_4 + (y_data_4 - (y_data_4 >>> (5 - 4 + 2)));
		y_data_5 <= y_data_4 + (x_data_4 - (x_data_4 >>> (5 - 4 + 2)));
		z_data_5 <= z_data_4 - p_tnah_4 ;
	end 
	else begin
		x_data_5 <= x_data_4 - (y_data_4 - (y_data_4 >>> (5 - 4 + 2)));
		y_data_5 <= y_data_4 - (x_data_4 - (x_data_4 >>> (5 - 4 + 2)));
		z_data_5 <= z_data_4 + p_tnah_4 ;
	end
end

//第六次迭代 i+S=5 +-5 = 0
reg signed	[50:0]				x_data_6;
reg	signed	[50:0]				y_data_6;
reg	signed	[40:0]				z_data_6;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		x_data_6 <= 'd0;
		y_data_6 <= 'd0;
		z_data_6 <= 'd0;
	end
	else if (y_data_5<=0) begin  //负数
		x_data_6 <= x_data_5 + (y_data_5 - (y_data_5 >>> (5 - 5 + 2)));
		y_data_6 <= y_data_5 + (x_data_5 - (x_data_5 >>> (5 - 5 + 2)));
		z_data_6 <= z_data_5 - p_tnah_5 ;
	end 
	else begin
		x_data_6 <= x_data_5 - (y_data_5 - (y_data_5 >>> (5 - 5 + 2)));
		y_data_6 <= y_data_5 - (x_data_5 - (x_data_5 >>> (5 - 5 + 2)));
		z_data_6 <= z_data_5 + p_tnah_5 ;
	end
end

//第七次迭代 i+s = -5 + 6 = 1
reg signed	[50:0]				x_data_7;
reg	signed	[50:0]				y_data_7;
reg	signed	[40:0]				z_data_7;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		x_data_7 <= 'd0;
		y_data_7 <= 'd0;
		z_data_7 <= 'd0;
	end
	else if (y_data_6<0) begin  //负数
		x_data_7 <= x_data_6 + (y_data_6 >>> 1);
		y_data_7 <= y_data_6 + (x_data_6 >>> 1);
		z_data_7 <= z_data_6 - p_tnah_6;
	end 
	else if (y_data_6 == 0) begin
		z_data_7 <= z_data_6;
	end
	else begin
		x_data_7 <= x_data_6 - (y_data_6 >>> 1);
		y_data_7 <= y_data_6 - (x_data_6 >>> 1);
		z_data_7 <= z_data_6 + p_tnah_6;
	end
end

//第八次迭代 i+s = -5 + 7 = 2
reg signed	[50:0]				x_data_8;
reg	signed	[50:0]				y_data_8;
reg	signed	[40:0]				z_data_8;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		x_data_8 <= 'd0;
		y_data_8 <= 'd0;
		z_data_8 <= 'd0;
	end
	else if (y_data_7<0) begin  //负数
		x_data_8 <= x_data_7 + (y_data_7 >>> 2);
		y_data_8 <= y_data_7 + (x_data_7 >>> 2);
		z_data_8 <= z_data_7 -  p_tnah_7;
	end 
	else if (y_data_7 == 0) begin
		x_data_8 <= x_data_7 + (y_data_7 >>> 2);
		y_data_8 <= y_data_7 + (x_data_7 >>> 2);
		z_data_8 <= z_data_7;
	end
	else begin
		x_data_8 <= x_data_7 - (y_data_7 >>> 2);
		y_data_8 <= y_data_7 - (x_data_7 >>> 2);
		z_data_8 <= z_data_7 +  p_tnah_7;
	end
end

//第九次迭代 i+s = -5 + 8 = 3
reg signed	[50:0]				x_data_9;
reg	signed	[50:0]				y_data_9;
reg	signed	[40:0]				z_data_9;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		x_data_9 <= 'd0;
		y_data_9 <= 'd0;
		z_data_9 <= 'd0;
	end
	else if (y_data_8<0) begin  //负数
		x_data_9 <= x_data_8 + (y_data_8 >>> 3);
		y_data_9 <= y_data_8 + (x_data_8 >>> 3);
		z_data_9 <= z_data_8 -  p_tnah_8;
	end 
	else if (y_data_8 == 0) begin
		x_data_9 <= x_data_8 + (y_data_8 >>> 3);
		y_data_9 <= y_data_8 + (x_data_8 >>> 3);
		z_data_9 <= z_data_8;
	end
	else begin
		x_data_9 <= x_data_8 - (y_data_8 >>> 3);
		y_data_9 <= y_data_8 - (x_data_8 >>> 3);
		z_data_9 <= z_data_8 +  p_tnah_8;
	end
end


//第十次迭代 i+s = -5 + 9 = 4
reg signed	[50:0]				x_data_10;
reg	signed	[50:0]				y_data_10;
reg	signed	[40:0]				z_data_10;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		x_data_10 <= 'd0;
		y_data_10 <= 'd0;
		z_data_10 <= 'd0;
	end
	else if (y_data_9<0) begin  //负数
		x_data_10 <= x_data_9 + (y_data_9 >>> 4);
		y_data_10 <= y_data_9 + (x_data_9 >>> 4);
		z_data_10 <= z_data_9 -  p_tnah_9;
	end 
	else if (y_data_9 == 0) begin
		x_data_10 <= x_data_9 + (y_data_9 >>> 4);
		y_data_10 <= y_data_9 + (x_data_9 >>> 4);
		z_data_10 <= z_data_9;
	end
	else begin
		x_data_10 <= x_data_9 - (y_data_9 >>> 4);
		y_data_10 <= y_data_9 - (x_data_9 >>> 4);
		z_data_10 <= z_data_9 +  p_tnah_9;
	end
end

//第十一次迭代 i+s = -5 + 10 = 5
reg signed	[50:0]				x_data_11;
reg	signed	[50:0]				y_data_11;
reg	signed	[40:0]				z_data_11;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		x_data_11 <= 'd0;
		y_data_11 <= 'd0;
		z_data_11 <= 'd0;
	end
	else if (y_data_10<0) begin  //负数
		x_data_11 <= x_data_10 + (y_data_10 >>> 5);
		y_data_11 <= y_data_10 + (x_data_10 >>> 5);
		z_data_11 <= z_data_10 -  p_tnah_10;
	end 
	else if (y_data_10 == 0) begin
		x_data_11 <= x_data_10 + (y_data_10 >>> 5);
		y_data_11 <= y_data_10 + (x_data_10 >>> 5);
		z_data_11 <= z_data_10;
	end
	else begin
		x_data_11 <= x_data_10 - (y_data_10 >>> 5);
		y_data_11 <= y_data_10 - (x_data_10 >>> 5);
		z_data_11 <= z_data_10 +  p_tnah_10;
	end
end

//第十二次迭代 i+s = -5 + 11 = 6
reg signed	[50:0]				x_data_12;
reg	signed	[50:0]				y_data_12;
reg	signed	[40:0]				z_data_12;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		x_data_12 <= 'd0;
		y_data_12 <= 'd0;
		z_data_12 <= 'd0;
	end
	else if (y_data_11<0) begin  //负数
		x_data_12 <= x_data_11 + (y_data_11 >>> 6);
		y_data_12 <= y_data_11 + (x_data_11 >>> 6);
		z_data_12 <= z_data_11 -  p_tnah_11;
	end 
	else if (y_data_11 == 0) begin
		x_data_12 <= x_data_11 + (y_data_11 >>> 6);
		y_data_12 <= y_data_11 + (x_data_11 >>> 6);
		z_data_12 <= z_data_11;
	end
	else begin
		x_data_12 <= x_data_11 - (y_data_11 >>> 6);
		y_data_12 <= y_data_11 - (x_data_11 >>> 6);
		z_data_12 <= z_data_11 +  p_tnah_11;
	end
end

//第十三次迭代 i+s = -5 + 12 = 7
reg signed	[50:0]				x_data_13;
reg	signed	[50:0]				y_data_13;
reg	signed	[40:0]				z_data_13;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		x_data_13 <= 'd0;
		y_data_13 <= 'd0;
		z_data_13 <= 'd0;
	end
	else if (y_data_12<0) begin 	//负数
		x_data_13 <= x_data_12 + (y_data_12 >>> 7);
		y_data_13 <= y_data_12 + (x_data_12 >>> 7);
		z_data_13 <= z_data_12 -  p_tnah_12;
	end 
	else if (y_data_12 == 0) begin
	 	x_data_13 <= x_data_12 + (y_data_12 >>> 7);
		y_data_13 <= y_data_12 + (x_data_12 >>> 7);
		z_data_13 <= z_data_12;
	end
	else begin
		x_data_13 <= x_data_12 - (y_data_12 >>> 7);
		y_data_13 <= y_data_12 - (x_data_12 >>> 7);
		z_data_13 <= z_data_12 +  p_tnah_12;
	end
end

//第十四次迭代 i+s = -5 + 13 = 8
reg signed	[50:0]				x_data_14;
reg	signed	[50:0]				y_data_14;
reg	signed	[40:0]				z_data_14;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		x_data_14 <= 'd0;
		y_data_14 <= 'd0;
		z_data_14 <= 'd0;
	end
	else if (y_data_13<0) begin 	//负数
		x_data_14 <= x_data_13 + (y_data_13 >>> 8);
		y_data_14 <= y_data_13 + (x_data_13 >>> 8);
		z_data_14 <= z_data_13 -  p_tnah_13;
	end 
	else if (y_data_13 == 0) begin
		x_data_14 <= x_data_13 + (y_data_13 >>> 8);
		y_data_14 <= y_data_13 + (x_data_13 >>> 8);
		z_data_14 <= z_data_13;
	end
	else begin
		x_data_14 <= x_data_13 - (y_data_13 >>> 8);
		y_data_14 <= y_data_13 - (x_data_13 >>> 8);
		z_data_14 <= z_data_13 +  p_tnah_13;
	end
end

//第十五次迭代 i+s = -5 + 14 = 9
reg signed	[50:0]				x_data_15;
reg	signed	[50:0]				y_data_15;
reg	signed	[40:0]				z_data_15;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		x_data_15 <= 'd0;
		y_data_15 <= 'd0;
		z_data_15 <= 'd0;
	end
	else if (y_data_14<0) begin //负数
		x_data_15<= x_data_14 + (y_data_14 >>> 9);
		y_data_15<= y_data_14 + (x_data_14 >>> 9);
		z_data_15<= z_data_14 -  p_tnah_14;
	end 
	else if (y_data_14 == 0) begin
		x_data_15<= x_data_14 + (y_data_14 >>> 9);
		y_data_15<= y_data_14 + (x_data_14 >>> 9);
		z_data_15 <= z_data_14;
	end
	else  begin
		x_data_15 <= x_data_14 - (y_data_14 >>> 9);
		y_data_15 <= y_data_14 - (x_data_14 >>> 9);
		z_data_15 <= z_data_14 +  p_tnah_14;
	end
end

//第十六次迭代 i+s = -5 + 15 = 9
reg signed	[50:0]				x_data_16;
reg	signed	[50:0]				y_data_16;
reg	signed	[40:0]				z_data_16;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		// reset
		x_data_16 <= 'd0;
		y_data_16 <= 'd0;
		z_data_16 <= 'd0;
	end
	else if (y_data_15<0) begin //负数
		x_data_16<= x_data_15 + (y_data_15 >>> 10);
		y_data_16<= y_data_15 + (x_data_15 >>> 10);
		z_data_16<= z_data_15 -  p_tnah_15;
	end 
	else if (y_data_15 == 0) begin
		x_data_16<= x_data_15 + (y_data_15 >>> 10);
		y_data_16<= y_data_15 + (x_data_15 >>> 10);
		z_data_16 <= z_data_15;
	end
	else  begin
		x_data_16 <= x_data_15 - (y_data_15 >>> 10);
		y_data_16 <= y_data_15 - (x_data_15 >>> 10);
		z_data_16 <= z_data_15 +  p_tnah_15;
	end
end

////使能延迟对齐输出
 wire [40:0] data_out2;
 reg [50:0] data_out3;
reg [17:0] r_en_delay ;
always @(posedge clk)
begin
    r_en_delay <= {r_en_delay[16:0],i_en};
end

assign o_en = r_en_delay[17]; //输出使能信号
assign  data_out2 = z_data_16[40:0];
  always @(posedge clk or negedge rst_n) begin 
   if(!rst_n)
       data_out3 <= 'd0;
   else 
       data_out3 <= data_out2*'d889;
 end
 assign data_out=data_out3[33:16];

endmodule