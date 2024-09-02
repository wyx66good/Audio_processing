
/*************
Author:wyx
Times :2024.8.9
VQ识别最小d值
**************/



module VQ_identifys_MIN_D(
    input     wire              clk             ,
    input     wire              rst_n           ,

    input     wire          distance_EN       ,  
    input     wire [31:0]  distance_DATA1       ,                                             
    input     wire [31:0]  distance_DATA_2      ,                                               
    input     wire [31:0]  distance_DATA_3      ,                                               
    input     wire [31:0]  distance_DATA_4      ,                                              
    input     wire [31:0]  distance_DATA_5      ,
    input     wire [31:0]  distance_DATA_6      ,  
    input     wire [31:0]  distance_DATA_7      ,
    input     wire [31:0]  distance_DATA_8      ,
    input     wire [31:0]  distance_DATA_9      ,
    input     wire [31:0]  distance_DATA_10     ,
    input     wire [31:0]  distance_DATA_11     ,
    input     wire [31:0]  distance_DATA_12     ,
    input     wire [31:0]  distance_DATA_13     ,
    input     wire [31:0]  distance_DATA_14     ,
    input     wire [31:0]  distance_DATA_15     ,
    input     wire [31:0]  distance_DATA_16     ,
    output    reg  [31:0]       MIN,
    output    reg              MIN_EN
   );





always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        MIN <= 0;
    end
    else if((distance_DATA1<=distance_DATA_2)&&(distance_DATA1<=distance_DATA_3)&&(distance_DATA1<=distance_DATA_4)
                &&(distance_DATA1<=distance_DATA_5)&&(distance_DATA1<=distance_DATA_6)&&(distance_DATA1<=distance_DATA_7)
                &&(distance_DATA1<=distance_DATA_8)&&(distance_DATA1<=distance_DATA_9)&&(distance_DATA1<=distance_DATA_10)
                &&(distance_DATA1<=distance_DATA_11)&&(distance_DATA1<=distance_DATA_12)&&(distance_DATA1<=distance_DATA_13)
                &&(distance_DATA1<=distance_DATA_14)&&(distance_DATA1<=distance_DATA_15)&&(distance_DATA1<=distance_DATA_16)&&distance_EN) begin
        MIN <= distance_DATA1;
    end
    else if((    distance_DATA_2<=distance_DATA1)&&(distance_DATA_2<=distance_DATA_3)&&(distance_DATA_2<=distance_DATA_4)
                &&(distance_DATA_2<=distance_DATA_5)&&(distance_DATA_2<=distance_DATA_6)&&(distance_DATA_2<=distance_DATA_7)
                &&(distance_DATA_2<=distance_DATA_8)&&(distance_DATA_2<=distance_DATA_9)&&(distance_DATA_2<=distance_DATA_10)
                &&(distance_DATA_2<=distance_DATA_11)&&(distance_DATA_2<=distance_DATA_12)&&(distance_DATA_2<=distance_DATA_13)
                &&(distance_DATA_2<=distance_DATA_14)&&(distance_DATA_2<=distance_DATA_15)&&(distance_DATA_2<=distance_DATA_16)&&distance_EN) begin
        MIN <= distance_DATA_2;
    end
    else if((    distance_DATA_3<=distance_DATA1)&&(distance_DATA_3<=distance_DATA_2)&&(distance_DATA_3<=distance_DATA_4)
                &&(distance_DATA_3<=distance_DATA_5)&&(distance_DATA_3<=distance_DATA_6)&&(distance_DATA_3<=distance_DATA_7)
                &&(distance_DATA_3<=distance_DATA_8)&&(distance_DATA_3<=distance_DATA_9)&&(distance_DATA_3<=distance_DATA_10)
                &&(distance_DATA_3<=distance_DATA_11)&&(distance_DATA_3<=distance_DATA_12)&&(distance_DATA_3<=distance_DATA_13)
                &&(distance_DATA_3<=distance_DATA_14)&&(distance_DATA_3<=distance_DATA_15)&&(distance_DATA_3<=distance_DATA_16)&&distance_EN) begin
        MIN <= distance_DATA_3;
    end
    else if((    distance_DATA_4<=distance_DATA1)&&(distance_DATA_4<=distance_DATA_2)&&(distance_DATA_4<=distance_DATA_3)
                &&(distance_DATA_4<=distance_DATA_5)&&(distance_DATA_4<=distance_DATA_6)&&(distance_DATA_4<=distance_DATA_7)
                &&(distance_DATA_4<=distance_DATA_8)&&(distance_DATA_4<=distance_DATA_9)&&(distance_DATA_4<=distance_DATA_10)
                &&(distance_DATA_4<=distance_DATA_11)&&(distance_DATA_4<=distance_DATA_12)&&(distance_DATA_4<=distance_DATA_13)
                &&(distance_DATA_4<=distance_DATA_14)&&(distance_DATA_4<=distance_DATA_15)&&(distance_DATA_4<=distance_DATA_16)&&distance_EN) begin
        MIN <= distance_DATA_4;
    end
    else if((    distance_DATA_5<=distance_DATA1)&&(distance_DATA_5<=distance_DATA_2)&&(distance_DATA_5<=distance_DATA_3)
                &&(distance_DATA_5<=distance_DATA_4)&&(distance_DATA_5<=distance_DATA_6)&&(distance_DATA_5<=distance_DATA_7)
                &&(distance_DATA_5<=distance_DATA_8)&&(distance_DATA_5<=distance_DATA_9)&&(distance_DATA_5<=distance_DATA_10)
                &&(distance_DATA_5<=distance_DATA_11)&&(distance_DATA_5<=distance_DATA_12)&&(distance_DATA_5<=distance_DATA_13)
                &&(distance_DATA_5<=distance_DATA_14)&&(distance_DATA_5<=distance_DATA_15)&&(distance_DATA_5<=distance_DATA_16)&&distance_EN) begin
        MIN <= distance_DATA_5;
    end
    else if((    distance_DATA_6<=distance_DATA1)&&(distance_DATA_6<=distance_DATA_2)&&(distance_DATA_6<=distance_DATA_3)
                &&(distance_DATA_6<=distance_DATA_4)&&(distance_DATA_6<=distance_DATA_5)&&(distance_DATA_6<=distance_DATA_7)
                &&(distance_DATA_6<=distance_DATA_8)&&(distance_DATA_6<=distance_DATA_9)&&(distance_DATA_6<=distance_DATA_10)
                &&(distance_DATA_6<=distance_DATA_11)&&(distance_DATA_6<=distance_DATA_12)&&(distance_DATA_6<=distance_DATA_13)
                &&(distance_DATA_6<=distance_DATA_14)&&(distance_DATA_6<=distance_DATA_15)&&(distance_DATA_6<=distance_DATA_16)&&distance_EN) begin
        MIN <= distance_DATA_6;
    end
    else if((    distance_DATA_7<=distance_DATA1)&&(distance_DATA_7<=distance_DATA_2)&&(distance_DATA_7<=distance_DATA_3)
                &&(distance_DATA_7<=distance_DATA_4)&&(distance_DATA_7<=distance_DATA_5)&&(distance_DATA_7<=distance_DATA_6)
                &&(distance_DATA_7<=distance_DATA_8)&&(distance_DATA_7<=distance_DATA_9)&&(distance_DATA_7<=distance_DATA_10)
                &&(distance_DATA_7<=distance_DATA_11)&&(distance_DATA_7<=distance_DATA_12)&&(distance_DATA_7<=distance_DATA_13)
                &&(distance_DATA_7<=distance_DATA_14)&&(distance_DATA_7<=distance_DATA_15)&&(distance_DATA_7<=distance_DATA_16)&&distance_EN) begin
        MIN <= distance_DATA_7;
    end
    else if((      distance_DATA_8<=distance_DATA1)&&  (distance_DATA_8<=distance_DATA_2)&& (distance_DATA_8<=distance_DATA_3)
                &&(distance_DATA_8<=distance_DATA_4)&& (distance_DATA_8<=distance_DATA_5)&& (distance_DATA_8<=distance_DATA_6)
                &&(distance_DATA_8<=distance_DATA_7)&& (distance_DATA_8<=distance_DATA_9)&& (distance_DATA_8<=distance_DATA_10)
                &&(distance_DATA_8<=distance_DATA_11)&&(distance_DATA_8<=distance_DATA_12)&&(distance_DATA_8<=distance_DATA_13)
                &&(distance_DATA_8<=distance_DATA_14)&&(distance_DATA_8<=distance_DATA_15)&&(distance_DATA_8<=distance_DATA_16)&&distance_EN) begin
        MIN <= distance_DATA_8;
    end
    else if((      distance_DATA_9<=distance_DATA1)&&  (distance_DATA_9<=distance_DATA_2)&& (distance_DATA_9<=distance_DATA_3)
                &&(distance_DATA_9<=distance_DATA_4)&& (distance_DATA_9<=distance_DATA_5)&& (distance_DATA_9<=distance_DATA_6)
                &&(distance_DATA_9<=distance_DATA_7)&& (distance_DATA_9<=distance_DATA_8)&& (distance_DATA_9<=distance_DATA_10)
                &&(distance_DATA_9<=distance_DATA_11)&&(distance_DATA_9<=distance_DATA_12)&&(distance_DATA_9<=distance_DATA_13)
                &&(distance_DATA_9<=distance_DATA_14)&&(distance_DATA_9<=distance_DATA_15)&&(distance_DATA_9<=distance_DATA_16)&&distance_EN) begin
        MIN <= distance_DATA_9;
    end
    else if((      distance_DATA_10<=distance_DATA1)&&  (distance_DATA_10<=distance_DATA_2)&& (distance_DATA_10<=distance_DATA_3)
                &&(distance_DATA_10<=distance_DATA_4)&& (distance_DATA_10<=distance_DATA_5)&& (distance_DATA_10<=distance_DATA_6)
                &&(distance_DATA_10<=distance_DATA_7)&& (distance_DATA_10<=distance_DATA_8)&& (distance_DATA_10<=distance_DATA_9)
                &&(distance_DATA_10<=distance_DATA_11)&&(distance_DATA_10<=distance_DATA_12)&&(distance_DATA_10<=distance_DATA_13)
                &&(distance_DATA_10<=distance_DATA_14)&&(distance_DATA_10<=distance_DATA_15)&&(distance_DATA_10<=distance_DATA_16)&&distance_EN) begin
        MIN <= distance_DATA_10;
    end
    else if((      distance_DATA_11<=distance_DATA1)&&  (distance_DATA_11<=distance_DATA_2)&& (distance_DATA_11<=distance_DATA_3)
                &&(distance_DATA_11<=distance_DATA_4)&& (distance_DATA_11<=distance_DATA_5)&& (distance_DATA_11<=distance_DATA_6)
                &&(distance_DATA_11<=distance_DATA_7)&& (distance_DATA_11<=distance_DATA_8)&& (distance_DATA_11<=distance_DATA_9)
                &&(distance_DATA_11<=distance_DATA_10)&&(distance_DATA_11<=distance_DATA_12)&&(distance_DATA_11<=distance_DATA_13)
                &&(distance_DATA_11<=distance_DATA_14)&&(distance_DATA_11<=distance_DATA_15)&&(distance_DATA_11<=distance_DATA_16)&&distance_EN) begin
        MIN <= distance_DATA_11;
    end
    else if((      distance_DATA_12<=distance_DATA1)&&  (distance_DATA_12<=distance_DATA_2)&& (distance_DATA_12<=distance_DATA_3)
                &&(distance_DATA_12<=distance_DATA_4)&& (distance_DATA_12<=distance_DATA_5)&& (distance_DATA_12<=distance_DATA_6)
                &&(distance_DATA_12<=distance_DATA_7)&& (distance_DATA_12<=distance_DATA_8)&& (distance_DATA_12<=distance_DATA_9)
                &&(distance_DATA_12<=distance_DATA_11)&&(distance_DATA_12<=distance_DATA_10)&&(distance_DATA_12<=distance_DATA_13)
                &&(distance_DATA_12<=distance_DATA_14)&&(distance_DATA_12<=distance_DATA_15)&&(distance_DATA_12<=distance_DATA_16)&&distance_EN) begin
        MIN <= distance_DATA_12;
    end
    else if((      distance_DATA_13<=distance_DATA1)&&  (distance_DATA_13<=distance_DATA_2)&& (distance_DATA_13<=distance_DATA_3)
                &&(distance_DATA_13<=distance_DATA_4)&& (distance_DATA_13<=distance_DATA_5)&& (distance_DATA_13<=distance_DATA_6)
                &&(distance_DATA_13<=distance_DATA_7)&& (distance_DATA_13<=distance_DATA_8)&& (distance_DATA_13<=distance_DATA_9)
                &&(distance_DATA_13<=distance_DATA_11)&&(distance_DATA_13<=distance_DATA_12)&&(distance_DATA_13<=distance_DATA_10)
                &&(distance_DATA_13<=distance_DATA_14)&&(distance_DATA_13<=distance_DATA_15)&&(distance_DATA_13<=distance_DATA_16)&&distance_EN) begin
        MIN <= distance_DATA_13;
    end
    else if((      distance_DATA_14<=distance_DATA1)&&  (distance_DATA_14<=distance_DATA_2)&& (distance_DATA_14<=distance_DATA_3)
                &&(distance_DATA_14<=distance_DATA_4)&& (distance_DATA_14<=distance_DATA_5)&& (distance_DATA_14<=distance_DATA_6)
                &&(distance_DATA_14<=distance_DATA_7)&& (distance_DATA_14<=distance_DATA_8)&& (distance_DATA_14<=distance_DATA_9)
                &&(distance_DATA_14<=distance_DATA_11)&&(distance_DATA_14<=distance_DATA_12)&&(distance_DATA_14<=distance_DATA_13)
                &&(distance_DATA_14<=distance_DATA_10)&&(distance_DATA_14<=distance_DATA_15)&&(distance_DATA_14<=distance_DATA_16)&&distance_EN) begin
        MIN <= distance_DATA_14;
    end
    else if((      distance_DATA_15<=distance_DATA1)&&  (distance_DATA_15<=distance_DATA_2)&& (distance_DATA_15<=distance_DATA_3)
                &&(distance_DATA_15<=distance_DATA_4)&& (distance_DATA_15<=distance_DATA_5)&& (distance_DATA_15<=distance_DATA_6)
                &&(distance_DATA_15<=distance_DATA_7)&& (distance_DATA_15<=distance_DATA_8)&& (distance_DATA_15<=distance_DATA_9)
                &&(distance_DATA_15<=distance_DATA_11)&&(distance_DATA_15<=distance_DATA_12)&&(distance_DATA_15<=distance_DATA_13)
                &&(distance_DATA_15<=distance_DATA_10)&&(distance_DATA_15<=distance_DATA_14)&&(distance_DATA_15<=distance_DATA_16)&&distance_EN) begin
        MIN <= distance_DATA_15;
    end
    else if((      distance_DATA_16<=distance_DATA1)&&  (distance_DATA_16<=distance_DATA_2)&& (distance_DATA_16<=distance_DATA_3)
                &&(distance_DATA_16<=distance_DATA_4)&& (distance_DATA_16<=distance_DATA_5)&& (distance_DATA_16<=distance_DATA_6)
                &&(distance_DATA_16<=distance_DATA_7)&& (distance_DATA_16<=distance_DATA_8)&& (distance_DATA_16<=distance_DATA_9)
                &&(distance_DATA_16<=distance_DATA_11)&&(distance_DATA_16<=distance_DATA_12)&&(distance_DATA_16<=distance_DATA_13)
                &&(distance_DATA_16<=distance_DATA_10)&&(distance_DATA_16<=distance_DATA_15)&&(distance_DATA_16<=distance_DATA_14)&&distance_EN) begin
        MIN <= distance_DATA_16;
    end
end



always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        MIN_EN <= 0;
    end
    else  begin
        MIN_EN <=distance_EN;
    end
end


endmodule