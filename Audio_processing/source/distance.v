

/*************
Author:wyx
Times :2024.8.4
distance OSHI
**************/


module distance(
    input     wire              clk  ,
    input     wire              rst_n,

    input     wire              START,
    output    wire              FINSH,

    output    reg     [4:0]     CNT,
    output    wire              CNT_EN,
    input     wire   [13:0]     DATA1,
    input     wire   [13:0]     DATA2,

    output    reg  [31:0]     distance_DATA,
    output    reg             distance_EN

   );

reg  START_1;
wire START_2;
reg  START_3;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        START_1 <= 'd0;
        START_3 <= 'd0;
    end
    else begin
        START_1 <=START;
        START_3 <=START_1;
    end
end
assign START_2=(START&&!START_1)?'d1:'d0;


reg       EN;
reg       EN2;
reg       EN3;
reg       EN4;
reg       EN5;
wire      FINSH1;
reg       FINSH2;
reg       FINSH3;
reg       FINSH4;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||FINSH1)begin
        CNT <= 'd0;
    end
    else if(EN) begin
        CNT <=CNT+'d1;
    end
    else begin
        CNT <=CNT;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        EN <= 'd0;
    end
    else if(START_2) begin
        EN <='d1;
    end
    else if(FINSH1) begin
        EN <='d0;
    end
    else begin
        EN <=EN;
    end
end
assign CNT_EN=EN;


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        EN2<='d0;
        EN3<='d0;
        EN4<='d0;
        EN5<='d0;
    end
    else begin
        EN2<=EN;
        EN3<=EN2;
        EN4<=EN3;
        EN5<=EN4;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        FINSH2<='d0;
        FINSH3<='d0;
        FINSH4<='d0;
    end
    else begin
        FINSH2<=FINSH1;
        FINSH3<=FINSH2;
        FINSH4<=FINSH3;
    end
end
assign FINSH1=(CNT=='d12)?'d1:'d0;

wire   [27:0]     DATA1_1;
wire   [27:0]     DATA2_1;
reg [27:0]  Difference;
wire [27:0] Difference_1;
reg [27:0]  square;
reg [31:0]  SUM;

assign DATA1_1={{14{DATA1[13]}},DATA1};
assign DATA2_1={{14{DATA2[13]}},DATA2};

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        Difference <= 'd0;
    end
    else begin
        Difference <=DATA1_1-DATA2_1;
    end
end

assign Difference_1=Difference[27]?~Difference+'d1:Difference;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        square <= 'd0;
    end
    else begin
        square <=Difference_1;
    end
end


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||START_3)begin
        SUM <= 'd0;
    end
    else if(EN4) begin
        SUM <=SUM+square;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        distance_DATA <= 'd0;
    end
    else if(!EN4&&EN5) begin
        distance_DATA <=SUM;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        distance_EN <= 'd0;
    end
    else if(!EN4&&EN5) begin
        distance_EN <='d1;
    end
    else  begin
        distance_EN <='d0;
    end
end

//assign distance_DATA=(distance_EN)?SUM:distance_DATA;
//assign distance_EN=(!EN4&&EN5);
assign FINSH=distance_EN;

endmodule