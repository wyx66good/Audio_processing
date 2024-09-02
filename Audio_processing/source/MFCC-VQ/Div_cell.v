/*************
Author:wyx
Times :2024.7.19
������ ��������
//A_LEN��ʾ�ⲿģ��Ľ���ı��������,���Բ�����Ч����
//A_LEN��ʾ�ⲿģ��Ľ���ĳ������,���Բ�����Ч����
//��Ϊ�����ĳ��ȶ�������Ч����,�����������ܺͱ�����λ��һ��,��Ū��һ��
**************/




module Div_cell#(
	parameter						A_LEN = 32,
	parameter						B_LEN = 32
	)(
	input											CLK,						// ʱ���ź�
	input											RSTN,						// ��λ�źţ�����Ч
	input											EN,						// ����������Ч,ʹ���ź�
	input [B_LEN:0]							Dividend,				//������,����һ�����ݵ����������ⲿģ��ƴ�ӵ�ԭʼ����������һλ
	input	[B_LEN-1:0]							Divisor,					//��һ�����ݵĳ���
	input [A_LEN-1:0]							Dividend_i,				//ԭʼ������
	input [A_LEN-1:0]							Quotient_i,				//��һ�����ݵ���
	
	output reg [A_LEN-1:0]					Quotient,				//��,���ݵ���һ��
	output reg [B_LEN-1:0]					Mod,						//��,Ҳ����һ���ı�����
	output reg [A_LEN-1:0]					Dividend_o,				//ԭʼ������
	output reg [B_LEN-1:0]					Divisor_o,				//ԭʼ����								
	output reg									RDY
	);
	
	always @(posedge CLK or negedge RSTN) begin
		if(!RSTN) begin													// �첽��λ���������мĴ���
			Quotient <=	'b0;
			Mod <= 'b0;	
			Dividend_o <= 'b0;
			Divisor_o <= 'b0;
			RDY <= 'b0;	
		end else if(EN) begin											// ��ʹ���ź���Чʱ�����г�������
			RDY <= 1'b1;
			Dividend_o <= Dividend_i;
			Divisor_o <= Divisor;
			if(Dividend>={1'b0,Divisor}) begin						// ��ǰ���������ڵ��ڳ���ʱ���̼�1����������
				Quotient <= (Quotient_i<<1)+1'b1;
				Mod <= Dividend-{1'b0,Divisor};
			end else begin																
				Quotient <= (Quotient_i<<1)+1'b0;					// ��ǰ������С�ڳ���ʱ���̲��䣬��������
				Mod <= Dividend;
			end
		end else begin														// ��ʹ���ź���Чʱ���������мĴ���
			Quotient <=	'b0;
			Mod <= 'b0;	
			Dividend_o <= 'b0;
			Divisor_o <= 'b0;
			RDY <= 'b0;
		end
	end
	
endmodule
