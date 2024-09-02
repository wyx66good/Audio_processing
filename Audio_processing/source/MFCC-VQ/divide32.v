/*************
Author:wyx
Times :2024.7.19
������ ��������
//A_LEN��ʾ�ⲿģ��Ľ���ı��������,���Բ�����Ч����
//A_LEN��ʾ�ⲿģ��Ľ���ĳ������,���Բ�����Ч����
//��Ϊ�����ĳ��ȶ�������Ч����,�����������ܺͱ�����λ��һ��,��Ū��һ��
**************/
`timescale 1 ns/ 1 ns
module Divider #(
	parameter		A_LEN = 32,
	parameter		B_LEN = 32)(
	input								CLK,						// ʱ���ź�
	input								RSTN,                // ��λ�źţ�����Ч
	input								EN,                  // ����������Ч,ʹ���ź�
	input [A_LEN-1:0]				Dividend,				//������
	input	[B_LEN-1:0]				Divisor,					//����
	
	output wire [A_LEN-1:0]			Quotient,				//��
	output [B_LEN-1:0]			Mod,						//��
	output							RDY);
	
	wire [A_LEN-1:0]				Quotient_reg		[A_LEN-1:0];
	wire [B_LEN-1:0] 				Mod_reg				[A_LEN-1:0];
	wire [A_LEN-1:0]				Dividend_ini_reg	[A_LEN-1:0];
	wire [A_LEN-1:0]				rdy;
	wire [B_LEN-1:0]				Divisor_reg			[A_LEN-1:0];
	
	// ��ʼ����һ��Div_cellģ�飬��������ı������ͳ���
	
	wire [A_LEN-1:0]			Quotient1;
	wire [A_LEN-1:0] Dividend_1;
	reg [A_LEN-1:0] flag1;
	assign Dividend_1=Dividend[A_LEN-1]?~Dividend+'d1:Dividend;
	Div_cell	#(.A_LEN(A_LEN),.B_LEN(B_LEN))	Divider(
		.CLK(CLK),
		.RSTN(RSTN),
		.EN(EN),
		.Dividend({{(B_LEN){1'b0}}, Dividend_1[A_LEN-1]}),		// �������������λ��0ƴ��
		.Divisor(Divisor),	
		.Dividend_i(Dividend_1),
		.Quotient_i('b0),
 
		.Quotient(Quotient_reg[A_LEN-1]),
		.Mod(Mod_reg[A_LEN-1]),		
		.Dividend_o(Dividend_ini_reg[A_LEN-1]),
		.Divisor_o(Divisor_reg[A_LEN-1]),
		.RDY(rdy[A_LEN-1])
		);
	
	// ���ɶ��Div_cellģ�飬������ˮ�߼���ṹ
	genvar i;

	generate 
		for(i=A_LEN-2;i>=0;i=i-1) begin : 
		Div_flow_loop
			Div_cell	#(.A_LEN(A_LEN),.B_LEN(B_LEN))	Divider(
				.CLK(CLK),
				.RSTN(RSTN),
				.EN(rdy[i+1]),
				.Dividend({Mod_reg[i+1], Dividend_ini_reg[i+1][i]}),	// ��ǰ��������һ��������λƴ��
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
