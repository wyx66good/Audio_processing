

/*************
Author:wyx
Times :2024.8.6
MIN Á½Â·Ñ¡ÔñÆ÷
**************/



module MIN_TWO#(
    parameter DATA_WIDTH = 16
)
(
     input                             clk,
     input                             rst_n,
   
     input     wire [DATA_WIDTH-1:0]  distance_DATA1       ,                
     input     wire [DATA_WIDTH-1:0]  distance_DATA_2      ,
     input     wire                   distance_EN        ,
     input     wire    [4:0]           MIN_in1_i,
     input     wire    [4:0]           MIN_in2_i,

     output    reg  [DATA_WIDTH-1:0]   MIN,
     output    reg   [4:0]             MIN_i,
     output    reg                     MIN_en
   );

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        MIN <= 0;
        MIN_i<='d0;
    end
    else if(distance_DATA1<=distance_DATA_2)begin
        MIN <= distance_DATA1;
        MIN_i<=MIN_in1_i;
    end
    else begin
        MIN <= distance_DATA_2;
        MIN_i<=MIN_in2_i;
    end
end


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        MIN_en <= 0;
    end
    else begin
        MIN_en <= distance_EN;
    end
end


endmodule