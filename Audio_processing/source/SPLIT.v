
/*************
Author:wyx
Times :2024.8.4
SPLIT 码本分裂
**************/



module SPLIT(
    input     wire              clk  ,
    input     wire              rst_n,


    input   wire                START,
    output   wire               FINSH,

    output    reg               SPLIT_en,

    output    wire [13:0]       LBG_SPLIT_wr_data/*synthesis PAP_MARK_DEBUG="1"*/,
    output    reg  [7:0]        LBG_SPLIT_wr_addr/*synthesis PAP_MARK_DEBUG="1"*/,
    output    reg               LBG_SPLIT_wr_en  /*synthesis PAP_MARK_DEBUG="1"*/,


    input     wire [13:0]       LBG_SPLIT_rd_data/*synthesis PAP_MARK_DEBUG="1"*/,
    output    reg [7:0]         LBG_SPLIT_rd_addr/*synthesis PAP_MARK_DEBUG="1"*/



   );


wire [21:0] epision_1;
wire [21:0] epision_2;

assign epision_1={14'd0,8'd132};
assign epision_2={14'd0,8'd124};

reg [3:0] CNT;
reg       FLAG;
reg       FLAG1;
reg       FLAG2;
reg       FLAG3;
wire       FINSH_2;
reg  [21:0] LBG_SPLIT_wr_data_1;
wire [21:0] LBG_SPLIT_rd_data_1;

reg               LBG_SPLIT_wr_en_1  ;
reg               LBG_SPLIT_wr_en_2  ;
reg               LBG_SPLIT_wr_en_3  ;
reg  [7:0]        LBG_SPLIT_wr_addr_1;
reg  [7:0]        LBG_SPLIT_wr_addr_2;


assign LBG_SPLIT_rd_data_1={{8{LBG_SPLIT_rd_data[13]}},LBG_SPLIT_rd_data};


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        LBG_SPLIT_wr_en_1 <= 'd0;
    end
    else if(START) begin
        LBG_SPLIT_wr_en_1 <='d1;
    end
    else if(FINSH_2) begin
        LBG_SPLIT_wr_en_1 <='d0;
    end
    else  begin
        LBG_SPLIT_wr_en_1 <=LBG_SPLIT_wr_en_1;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||START)begin
        LBG_SPLIT_wr_addr_1 <= 'd207;
    end
    else if(LBG_SPLIT_wr_en_1) begin
        LBG_SPLIT_wr_addr_1 <= LBG_SPLIT_wr_addr_1-'d1;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        LBG_SPLIT_wr_data_1 <= 'd207;
    end
    else if(LBG_SPLIT_wr_en_3&&(!FLAG1)) begin
        LBG_SPLIT_wr_data_1 <= LBG_SPLIT_rd_data_1*epision_1;
    end
    else if(LBG_SPLIT_wr_en_3&&(FLAG1)) begin
        LBG_SPLIT_wr_data_1 <= LBG_SPLIT_rd_data_1*epision_2;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
            LBG_SPLIT_wr_en_2  <='d0;
            LBG_SPLIT_wr_en_3  <='d0;
            LBG_SPLIT_wr_addr_2<='d0;
            LBG_SPLIT_wr_addr <='d0;
            LBG_SPLIT_wr_en   <='d0;


    end
    else  begin
            LBG_SPLIT_wr_en_2  <=LBG_SPLIT_wr_en_1;
            LBG_SPLIT_wr_en_3  <=LBG_SPLIT_wr_en_2;
            LBG_SPLIT_wr_addr_2<=LBG_SPLIT_wr_addr_1;
            LBG_SPLIT_wr_addr <=LBG_SPLIT_wr_addr_2;
            LBG_SPLIT_wr_en   <=LBG_SPLIT_wr_en_2;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
            FLAG1<='d0;
            FLAG2<='d0;
            FLAG3<='d0;

    end
    else  begin
            FLAG1<=FLAG;
            FLAG2<=FLAG1;
            FLAG3<=FLAG2;
    end
end


assign LBG_SPLIT_wr_data=LBG_SPLIT_wr_data_1>>>6;//留1小数位

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||START)begin
        LBG_SPLIT_rd_addr <= 'd103;
    end
    else if((CNT=='d12)&&!FLAG) begin
        LBG_SPLIT_rd_addr <= LBG_SPLIT_rd_addr+'d12;
    end
    else if(LBG_SPLIT_wr_en_1) begin
        LBG_SPLIT_rd_addr <= LBG_SPLIT_rd_addr-'d1;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||START||(CNT=='d12))begin
        CNT <= 'd0;
    end
    else if(LBG_SPLIT_wr_en_1) begin
        CNT <= CNT+'d1;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        FLAG <= 'd0;
    end
    else if((CNT=='d12)) begin
        FLAG <=~FLAG;
    end
end

assign FINSH_2=(LBG_SPLIT_wr_addr_1=='d0)?'d1:'d0;
assign FINSH=(LBG_SPLIT_wr_en&&!LBG_SPLIT_wr_en_2)?'d1:'d0;


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||FINSH)begin
        SPLIT_en <= 'd0;
    end
    else if(START) begin
        SPLIT_en <='d1;
    end
    else  begin
        SPLIT_en <=SPLIT_en;
    end
end


endmodule