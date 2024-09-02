//Author:wyx
//Times :2024.5.24
//Ԥ����



module pre_add
#(
    parameter DATA_WIDTH = 16
)
(
    input                       	 clk   ,
    input                       	 rst_n,
    input   [DATA_WIDTH - 1:0]  	 data_in     ,
	input                       	 en,
    output reg [DATA_WIDTH - 1:0]    data_out,
	output reg						 en_out	
   );
wire  [DATA_WIDTH - 5:0] data_2_1;
wire  [DATA_WIDTH - 1:0] data_2;
reg  [DATA_WIDTH - 1:0]  data_1;
reg                      en_out_1;
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        data_1 <= 'd0 ;
    else 
        data_1 <= data_in-data_2;//0.93755*x
end
assign data_2_1=data_in>>4;
assign data_2={{4{data_2_1[11]}},data_2_1};
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        data_out <= 'd0 ;
    else 
        data_out <= data_in-data_1;
end
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        en_out_1 <= 'd0 ;
        en_out <= 'd0 ;
    end
    else begin
        en_out_1 <= en;
        en_out <= en_out_1;
    end
end
endmodule