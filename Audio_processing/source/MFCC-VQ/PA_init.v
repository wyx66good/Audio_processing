/*************
Author:wyx
Times :2024.7.30
阀值
PA:PA_SUM=PA_SUM+sum
**************/


module PA_init#(
    parameter DATA_WIDTH = 16
)
(
    input                       	 clk   ,
    input                       	 rst_n,
    input   [DATA_WIDTH - 1:0]  	 data_in     ,
	input                       	 en,
    output wire [25:0]               PA_SUM_OUT,
	output wire						 PA_SUM_finsh	
   );

wire [7:0] data_in_1;
wire [7:0] data_in_2;
reg [15:0] data_in_3;
assign data_in_1=data_in>>8;
assign data_in_2=data_in_1[7]?~data_in_1+'d1:data_in_1;

always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)
        data_in_3 <= 'd0;
    else
        data_in_3 <= data_in_2*data_in_2;
end

reg en_1;

always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        en_1 <= 'd0;
    end
    else begin
        en_1 <= en;
    end
end
reg  [9:0]   cnt   ;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt <= 'd0;
    else if(en_1)
        cnt <= cnt+'d1;
    else
        cnt <= 'd0;
end

reg [25:0] PA_SUM;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        PA_SUM <= 'd0;
    else if(en_1)
        PA_SUM <= PA_SUM+data_in_3;
    else
        PA_SUM <= 'd0;
end

assign PA_SUM_OUT=(cnt=='d1023)?PA_SUM:PA_SUM_OUT;
assign PA_SUM_finsh=(cnt=='d1023)?'d1:'d0;




endmodule