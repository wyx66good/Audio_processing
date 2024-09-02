//Author:wyx
//Times :2024.5.24
//Ô¤¼ÓÖØ



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

reg  [DATA_WIDTH - 1:0] data_1;
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        data_1 <= 'd0 ;
    else 
        data_1 <= data_out-data_out>>4;//0.93755*x
end


always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        data_out <= 'd0 ;
    else 
        data_out <= data_in-data_1;
end
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        en_out <= 'd0 ;
    else 
        en_out <= en;
end
endmodule