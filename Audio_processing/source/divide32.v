/*************
Author:wyx
Times :2024.7.19
除法器 正负可算
//A_LEN表示外部模块的接入的被除数宽度,可以不是有效长度
//A_LEN表示外部模块的接入的除数宽度,可以不是有效长度
//因为两个的长度都不是有效长度,所以商最大可能和被除数位宽一样,就弄宽一点
**************/
`timescale 1 ns/ 1 ns
module Divider #(
	parameter		A_LEN = 32,
	parameter		B_LEN = 32)(
	input								CLK,						// 时钟信号
	input								RSTN,                // 复位信号，低有效
	input								EN,                  // 输入数据有效,使能信号
	input [A_LEN-1:0]				Dividend,				//被除数
	input	[B_LEN-1:0]				Divisor,					//除数
	
	output wire [A_LEN-1:0]			Quotient,				//商
	output [B_LEN-1:0]			Mod,						//余
	output							RDY);
	
	wire [A_LEN-1:0]				Quotient_reg		[A_LEN-1:0];
	wire [B_LEN-1:0] 				Mod_reg				[A_LEN-1:0];
	wire [A_LEN-1:0]				Dividend_ini_reg	[A_LEN-1:0];
	wire [A_LEN-1:0]				rdy;
	wire [B_LEN-1:0]				Divisor_reg			[A_LEN-1:0];
	
	// 初始化第一个Div_cell模块，处理最初的被除数和除数
	
	wire [A_LEN-1:0]			Quotient1;
	wire [A_LEN-1:0] Dividend_1;
	reg [A_LEN-1:0] flag1;
	assign Dividend_1=Dividend[A_LEN-1]?~Dividend+'d1:Dividend;
	Div_cell	#(.A_LEN(A_LEN),.B_LEN(B_LEN))	Divider(
		.CLK(CLK),
		.RSTN(RSTN),
		.EN(EN),
		.Dividend({{(B_LEN){1'b0}}, Dividend_1[A_LEN-1]}),		// 将被除数的最高位与0拼接
		.Divisor(Divisor),	
		.Dividend_i(Dividend_1),
		.Quotient_i('b0),
 
		.Quotient(Quotient_reg[A_LEN-1]),
		.Mod(Mod_reg[A_LEN-1]),		
		.Dividend_o(Dividend_ini_reg[A_LEN-1]),
		.Divisor_o(Divisor_reg[A_LEN-1]),
		.RDY(rdy[A_LEN-1])
		);
	
	// 生成多个Div_cell模块，构成流水线计算结构
	genvar i;

	generate 
		for(i=A_LEN-2;i>=0;i=i-1) begin : 
		Div_flow_loop
			Div_cell	#(.A_LEN(A_LEN),.B_LEN(B_LEN))	Divider(
				.CLK(CLK),
				.RSTN(RSTN),
				.EN(rdy[i+1]),
				.Dividend({Mod_reg[i+1], Dividend_ini_reg[i+1][i]}),	// 当前余数与下一个被除数位拼接
				.Divisor(Divisor_reg[i+1]),	
				.Dividend_i(Dividend_ini_reg[i+1]),
				.Quotient_i(Quotient_reg[i+1]),
		
				.Quotient(Quotient_reg[i]),
				.Mod(Mod_reg[i]),		
				.Dividend_o(Dividend_ini_reg[i]),
				.Divisor_o(Divisor_reg[i]),
				.RDY(rdy[i])
				);	
						
		end
	endgenerate
	
	assign RDY=rdy[0];
	assign Quotient1 = Quotient_reg[0];
	assign Mod = Mod_reg[0]; 
	
	
	
	always @(posedge CLK or negedge RSTN) begin
	    if ((!RSTN))begin
	    	flag1<='d0;
	    end
	    else begin
	    	flag1<={flag1[A_LEN-2:0] , Dividend[A_LEN-1]};
	    end
	end
	wire flag;
	
	assign 	flag=flag1[A_LEN-1];
	assign  Quotient=flag?~Quotient1+'d1:Quotient1;
endmodule
