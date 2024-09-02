/*************
Author:wyx
Times :2024.7.19
除法器 正负可算
//A_LEN表示外部模块的接入的被除数宽度,可以不是有效长度
//A_LEN表示外部模块的接入的除数宽度,可以不是有效长度
//因为两个的长度都不是有效长度,所以商最大可能和被除数位宽一样,就弄宽一点
**************/




module Div_cell#(
	parameter						A_LEN = 32,
	parameter						B_LEN = 32
	)(
	input											CLK,						// 时钟信号
	input											RSTN,						// 复位信号，低有效
	input											EN,						// 输入数据有效,使能信号
	input [B_LEN:0]							Dividend,				//被除数,由上一级传递的余数加上外部模块拼接的原始被除数的下一位
	input	[B_LEN-1:0]							Divisor,					//上一级传递的除数
	input [A_LEN-1:0]							Dividend_i,				//原始被除数
	input [A_LEN-1:0]							Quotient_i,				//上一级传递的商
	
	output reg [A_LEN-1:0]					Quotient,				//商,传递到下一级
	output reg [B_LEN-1:0]					Mod,						//余,也是下一级的被除数
	output reg [A_LEN-1:0]					Dividend_o,				//原始被除数
	output reg [B_LEN-1:0]					Divisor_o,				//原始除数								
	output reg									RDY
	);
	
	always @(posedge CLK or negedge RSTN) begin
		if(!RSTN) begin													// 异步复位，清零所有寄存器
			Quotient <=	'b0;
			Mod <= 'b0;	
			Dividend_o <= 'b0;
			Divisor_o <= 'b0;
			RDY <= 'b0;	
		end else if(EN) begin											// 当使能信号有效时，进行除法运算
			RDY <= 1'b1;
			Dividend_o <= Dividend_i;
			Divisor_o <= Divisor;
			if(Dividend>={1'b0,Divisor}) begin						// 当前被除数大于等于除数时，商加1，余数更新
				Quotient <= (Quotient_i<<1)+1'b1;
				Mod <= Dividend-{1'b0,Divisor};
			end else begin																
				Quotient <= (Quotient_i<<1)+1'b0;					// 当前被除数小于除数时，商不变，余数不变
				Mod <= Dividend;
			end
		end else begin														// 当使能信号无效时，清零所有寄存器
			Quotient <=	'b0;
			Mod <= 'b0;	
			Dividend_o <= 'b0;
			Divisor_o <= 'b0;
			RDY <= 'b0;
		end
	end
	
endmodule
