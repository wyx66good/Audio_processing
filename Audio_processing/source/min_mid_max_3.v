/*************
Author:wyx
Times :2024.7.8


**************/

module min_mid_max_3
//========================< �˿� >==========================================
(
//system --------------------------------------------
input   wire                clk                     ,
input   wire                rst_n                   ,
input   wire                start                   ,
//input ---------------------------------------------
input   wire    [63:0]       data1                   ,
input   wire    [63:0]       data2                   ,
input   wire    [63:0]       data3                   ,
//output --------------------------------------------
output  reg     [63:0]       max_data                , //���ֵ
output  reg     [63:0]       mid_data                , //�м�ֵ
output  reg     [63:0]       min_data                  //��Сֵ
);
//==========================================================================
//==    ���ֵ
//==========================================================================
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        max_data <= 64'd0;
    else if(data1 >= data2 && data1 >= data3&&start)
        max_data <= data1;
    else if(data2 >= data1 && data2 >= data3&&start)
        max_data <= data2;
    else if(data3 >= data1 && data3 >= data2&&start)
        max_data <= data3;
end
//==========================================================================
//==    �м�ֵ
//==========================================================================
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        mid_data <= 64'd0;
    else if(((data2 >= data1 && data1 >= data3) || (data3 >= data1 && data1 >= data2))&&start)
        mid_data <= data1;
    else if(((data1 >= data2 && data2 >= data3) || (data3 >= data2 && data2 >= data1))&&start)
        mid_data <= data2;
    else if(((data1 >= data3 && data3 >= data2) || (data1 >= data3 && data3 >= data2))&&start)
        mid_data <= data3;
end
//==========================================================================
//==    ��Сֵ
//==========================================================================
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        min_data <= 64'd0;
    else if(data3 >= data1 && data2 >= data1&&start)
        min_data <= data1;
    else if(data3 >= data2 && data1 >= data2&&start)
        min_data <= data2;
    else if(data1 >= data3 && data2 >= data3&&start)
        min_data <= data3;
end







endmodule
