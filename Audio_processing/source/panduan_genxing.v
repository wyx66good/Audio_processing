
/*************
Author:wyx
Times :2024.8.11
VQ 判断是否继续和更新码本
**************/




module panduan_genxing(
    input     wire              clk  ,
    input     wire              rst_n,//开始时清空

    input     wire              START,
    output    wire               SPLIT_FINSH,
    output    reg               FINSH,
    input     wire  [2:0]       CNT_FOR,

    input     wire [40:0]       D      ,
    input     wire              D_en   ,
    input     wire [23:0]       VQ_rd_data,
    output    reg  [7:0]        VQ_rd_addr,
    input     wire  [8:0]       Frams_Number_1 ,
    input     wire  [8:0]       Frams_Number_2 ,
    input     wire  [8:0]       Frams_Number_3 ,
    input     wire  [8:0]       Frams_Number_4 ,
    input     wire  [8:0]       Frams_Number_5 ,
    input     wire  [8:0]       Frams_Number_6 ,
    input     wire  [8:0]       Frams_Number_7 ,
    input     wire  [8:0]       Frams_Number_8 ,
    input     wire  [8:0]       Frams_Number_9 ,
    input     wire  [8:0]       Frams_Number_10,
    input     wire  [8:0]       Frams_Number_11,
    input     wire  [8:0]       Frams_Number_12,
    input     wire  [8:0]       Frams_Number_13,
    input     wire  [8:0]       Frams_Number_14,
    input     wire  [8:0]       Frams_Number_15,
    input     wire  [8:0]       Frams_Number_16,

    output    wire [13:0]       LBG_wr_data ,
    output    reg  [7:0]        LBG_wr_addr ,
    output    wire              LBG_wr_en   ,


    output    reg               while_en

   );
reg         D_en_1;
reg         D_en_2;
wire [40:0] D1/*synthesis PAP_MARK_DEBUG="1"*/;
reg  [40:0] D2;
reg  [40:0] ABS;
wire  [40:0] ABS_1;
wire  [40:0] ABS_2/*synthesis PAP_MARK_DEBUG="1"*/;
assign D1=D;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
       D_en_1<='d0;
       D_en_2<='d0;
    end
    else  begin
       D_en_1<=D_en;
       D_en_2<=D_en_1;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
       D2<='d0;
    end
    else if(D_en) begin
       D2<=D1;
    end
    else  begin
       D2<=D2;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
       ABS<='d0;
    end
    else if(D_en) begin
       ABS<=D2-D1;
    end
    else  begin
       ABS<=ABS;
    end
end
assign ABS_1=(ABS[40])?~ABS+'d1:ABS;
assign ABS_2=ABS_1<<14;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||((ABS_2<=D1) &&D_en_1))begin
       while_en<='d0;
    end
    else if((ABS_2>D1)  &&D_en_1) begin
       while_en<='d1;
    end
    else  begin
       while_en<=while_en;
    end
end

reg genxing_en;
reg genxing_en_1;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
       genxing_en<='d0;
    end
    else if((VQ_rd_addr=='d25)&&(CNT_FOR=='d1)) begin
       genxing_en<='d0;
    end
    else if((VQ_rd_addr=='d51)&&(CNT_FOR=='d2)) begin
       genxing_en<='d0;
    end
    else if((VQ_rd_addr=='d103)&&(CNT_FOR=='d3)) begin
       genxing_en<='d0;
    end
    else if((VQ_rd_addr=='d207)&&(CNT_FOR=='d4)) begin
       genxing_en<='d0;
    end
    else if(D_en_2&&while_en) begin
       genxing_en<='d1;
    end
    else  begin
       genxing_en<=genxing_en;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
       genxing_en_1<='d0;
    end
    else  begin
       genxing_en_1<=genxing_en;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
       VQ_rd_addr<='d0;
    end
    else if(genxing_en) begin
       VQ_rd_addr<=VQ_rd_addr+'d1;
    end
    else  begin
       VQ_rd_addr<='d0;
    end
end
reg  [9:0] Frams_Number;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        Frams_Number <='d0;
    end
    else if(VQ_rd_addr<'d13) begin
        Frams_Number <= Frams_Number_1;
    end
    else if((VQ_rd_addr>='d13)&&(VQ_rd_addr<'d26)) begin
        Frams_Number <= Frams_Number_2;
    end
    else if((VQ_rd_addr>='d26)&&(VQ_rd_addr<'d39)) begin
        Frams_Number <= Frams_Number_3;
    end
    else if((VQ_rd_addr>='d39)&&(VQ_rd_addr<'d52)) begin
        Frams_Number <= Frams_Number_4;
    end
    else if((VQ_rd_addr>='d52)&&(VQ_rd_addr<'d65)) begin
        Frams_Number <= Frams_Number_5;
    end
    else if((VQ_rd_addr>='d65)&&(VQ_rd_addr<'d78)) begin
        Frams_Number <= Frams_Number_6;
    end
    else if((VQ_rd_addr>='d78)&&(VQ_rd_addr<'d91)) begin
        Frams_Number <= Frams_Number_7;
    end
    else if((VQ_rd_addr>='d91)&&(VQ_rd_addr<'d104)) begin
        Frams_Number <= Frams_Number_8;
    end
    else if((VQ_rd_addr>='d104)&&(VQ_rd_addr<'d117)) begin
        Frams_Number <= Frams_Number_9;
    end
    else if((VQ_rd_addr>='d117)&&(VQ_rd_addr<'d130)) begin
        Frams_Number <= Frams_Number_10;
    end
    else if((VQ_rd_addr>='d130)&&(VQ_rd_addr<'d143)) begin
        Frams_Number <= Frams_Number_11;
    end
    else if((VQ_rd_addr>='d143)&&(VQ_rd_addr<'d156)) begin
        Frams_Number <= Frams_Number_12;
    end
    else if((VQ_rd_addr>='d156)&&(VQ_rd_addr<'d169)) begin
        Frams_Number <= Frams_Number_13;
    end
    else if((VQ_rd_addr>='d169)&&(VQ_rd_addr<'d182)) begin
        Frams_Number <= Frams_Number_14;
    end
    else if((VQ_rd_addr>='d182)&&(VQ_rd_addr<'d195)) begin
        Frams_Number <= Frams_Number_15;
    end
    else if((VQ_rd_addr>='d195)&&(VQ_rd_addr<'d208)) begin
        Frams_Number <= Frams_Number_16;
    end
    else  begin
        Frams_Number <=Frams_Number ;
    end
end
wire  [9:0] Frams_Number1;
wire [23:0] VQ_rd_data1;
assign VQ_rd_data1=((Frams_Number=='d0))?'d0:VQ_rd_data;
assign Frams_Number1=(Frams_Number=='d0)?10'd1:Frams_Number;
wire  [23:0] Q_PA;
wire        PA_FINSH;
Divider #
(
.A_LEN(24),
.B_LEN(10)
)divide32_x_h
(
		.CLK(clk),
		.RSTN(rst_n),
		.EN(genxing_en_1 ),
		.Dividend(VQ_rd_data1),
		.Divisor(Frams_Number1),
		.Quotient(Q_PA),
		.Mod(),
		.RDY(PA_FINSH)
);


assign LBG_wr_data=Q_PA[13:0];
assign LBG_wr_en=PA_FINSH;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
       LBG_wr_addr<='d0;
    end
    else if(LBG_wr_en) begin
       LBG_wr_addr<=LBG_wr_addr+'d1;
    end
    else  begin
       LBG_wr_addr<='d0;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
       FINSH<='d0;
    end
    else if((LBG_wr_addr=='d25)&&(CNT_FOR=='d1)) begin
       FINSH<='d1;
    end
    else if((LBG_wr_addr=='d51)&&(CNT_FOR=='d2)) begin
       FINSH<='d1;
    end
    else if((LBG_wr_addr=='d103)&&(CNT_FOR=='d3)) begin
       FINSH<='d1;
    end
    else if((LBG_wr_addr=='d207)&&(CNT_FOR=='d4)) begin
       FINSH<='d1;
    end
    else  begin
       FINSH<='d0;
    end
end


assign SPLIT_FINSH=(D_en_2&&!while_en)?'d1:'d0;

endmodule