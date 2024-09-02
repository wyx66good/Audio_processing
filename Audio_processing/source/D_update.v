/*************
Author:wyx
Times :2024.8.7
D_update D1¸üÐÂ
**************/



module D_update(
    input     wire              clk  ,
    input     wire              rst_n,

    input     wire              START,
    output    wire              FINSH,
    input     wire              Clear,

    input     wire  [8:0]       Frams_Number,
    input     wire [12:0]       DCT_ADDR,
    input     wire  [2:0]       CNT_FOR,

    output    reg   [12:0]      MFCCS13_ADDR,
    input     wire [13:0]       MFCCS13_DATA,

    input     wire [13:0]       LBG_SPLIT_rd_data,
    output    reg [7:0]         LBG_SPLIT_rd_addr,

    output    reg  [44:0]       D1
   );

reg [3:0] D_update_CNT;
wire  D_update_finsh;
wire  D_update_start;
wire   D_update_en;
wire     [4:0]     CNT;
wire [31:0] D_update_DATA_1;
wire        D_update_EN_1  ;
distance distance1(
.clk          (clk),
.rst_n        (rst_n),
.START        (D_update_start),
.FINSH        (D_update_finsh),
.CNT          (CNT),
.CNT_EN       (D_update_en),
.DATA1        (LBG_SPLIT_rd_data),
.DATA2        (MFCCS13_DATA),
.distance_DATA(D_update_DATA_1),
.distance_EN  (D_update_EN_1  )

   );
assign D_update_start=((START||D_update_finsh)&&(MFCCS13_ADDR<DCT_ADDR))?'d1:'d0;


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||Clear)begin
        D_update_CNT <= 'd0;
    end
    else if(((MFCCS13_ADDR==DCT_ADDR)&&(((CNT_FOR=='d1)&&(D_update_CNT!='d1))||((CNT_FOR=='d2)&&(D_update_CNT!='d3))||((CNT_FOR=='d3)&&(D_update_CNT!='d7))||((CNT_FOR=='d4)&&(D_update_CNT!='d15))))) begin
        D_update_CNT <=D_update_CNT+'d1;
    end
    else begin
        D_update_CNT <=D_update_CNT;
    end
end

assign finsh1=((CNT_FOR=='d1)&&(D_update_CNT=='d1)&&(MFCCS13_ADDR==DCT_ADDR)&&D_update_finsh)?'d1:((CNT_FOR=='d2)&&(D_update_CNT=='d3)&&(MFCCS13_ADDR==DCT_ADDR)&&D_update_finsh)?'d1
               :((CNT_FOR=='d3)&&(D_update_CNT=='d7)&&(MFCCS13_ADDR==DCT_ADDR)&&D_update_finsh)?'d1:((CNT_FOR=='d4)&&(D_update_CNT=='d15)&&(MFCCS13_ADDR==DCT_ADDR)&&D_update_finsh)?'d1:'d0;
assign FINSH=finsh1;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||Clear||((MFCCS13_ADDR==DCT_ADDR)&&(((CNT_FOR=='d1)&&(D_update_CNT!='d1))||((CNT_FOR=='d2)&&(D_update_CNT!='d3))||((CNT_FOR=='d3)&&(D_update_CNT!='d7))||((CNT_FOR=='d4)&&(D_update_CNT!='d15)))))begin
        MFCCS13_ADDR <= 'd0;
    end
    else if(D_update_en) begin
        MFCCS13_ADDR <=MFCCS13_ADDR+'d1;
    end
    else begin
        MFCCS13_ADDR <=MFCCS13_ADDR;
    end
end


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||Clear)begin
        LBG_SPLIT_rd_addr <= 'd0;
    end
    else if((CNT=='d0)&&(D_update_CNT=='d0)) begin
        LBG_SPLIT_rd_addr <='d0;
    end
    else if((CNT=='d0)&&(D_update_CNT=='d1)) begin
        LBG_SPLIT_rd_addr <='d13;
    end
    else if((CNT=='d0)&&(D_update_CNT=='d2)) begin
        LBG_SPLIT_rd_addr <='d26;
    end
    else if((CNT=='d0)&&(D_update_CNT=='d3)) begin
        LBG_SPLIT_rd_addr <='d39;
    end
    else if((CNT=='d0)&&(D_update_CNT=='d4)) begin
        LBG_SPLIT_rd_addr <='d52;
    end
    else if((CNT=='d0)&&(D_update_CNT=='d5)) begin
        LBG_SPLIT_rd_addr <='d65;
    end
    else if((CNT=='d0)&&(D_update_CNT=='d6)) begin
        LBG_SPLIT_rd_addr <='d78;
    end
    else if((CNT=='d0)&&(D_update_CNT=='d7)) begin
        LBG_SPLIT_rd_addr <='d91;
    end
    else if((CNT=='d0)&&(D_update_CNT=='d8)) begin
        LBG_SPLIT_rd_addr <='d104;
    end
    else if((CNT=='d0)&&(D_update_CNT=='d9)) begin
        LBG_SPLIT_rd_addr <='d117;
    end
    else if((CNT=='d0)&&(D_update_CNT=='d10)) begin
        LBG_SPLIT_rd_addr <='d130;
    end
    else if((CNT=='d0)&&(D_update_CNT=='d11)) begin
        LBG_SPLIT_rd_addr <='d143;
    end
    else if((CNT=='d0)&&(D_update_CNT=='d12)) begin
        LBG_SPLIT_rd_addr <='d156;
    end
    else if((CNT=='d0)&&(D_update_CNT=='d13)) begin
        LBG_SPLIT_rd_addr <='d169;
    end
    else if((CNT=='d0)&&(D_update_CNT=='d14)) begin
        LBG_SPLIT_rd_addr <='d182;
    end
    else if((CNT=='d0)&&(D_update_CNT=='d15)) begin
        LBG_SPLIT_rd_addr <='d195;
    end
    else if(D_update_en) begin
        LBG_SPLIT_rd_addr <=LBG_SPLIT_rd_addr+'d1;
    end
    else begin
        LBG_SPLIT_rd_addr <=LBG_SPLIT_rd_addr;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||Clear)begin
        D1 <= 'd0;
    end
    else if(D_update_EN_1) begin
        D1 <=D1+D_update_DATA_1;
    end
    else begin
        D1 <=D1;
    end
end


endmodule