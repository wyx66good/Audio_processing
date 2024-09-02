/*************
Author:wyx
Times :2024.8.4
VQ_LBG �뱾��ʼ��
**************/

module LBG_mean2(
    input     wire              clk  ,
    input     wire              rst_n,

    input   wire                START,
    output   wire               FINSH,
    input   wire                LBG_mean_EN,

    input     wire [12:0]       DCT_ADDR,
    input     wire  [8:0]       Frams_Number,
    output    wire  [12:0]      MFCCS13_ADDR,
    input     wire [13:0]       MFCCS13_DATA,

    output    wire [13:0]       LBG_init,
    output    reg  [3:0]        LBG_init_addr,
    output    wire              LBG_init_en
   );

reg [3:0]   CNT_13;
reg [12:0]  CNT_ADDR;
wire        again;
reg         again2;
reg         again3;

reg [22:0]  LBG_ALL;
wire [22:0] MFCCS13_DATA_1;
wire [12:0] DCT_ADDR_start;
reg         LBG_mean_EN_1;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        LBG_mean_EN_1 <= 'd0;
    end
    else begin
        LBG_mean_EN_1 <= LBG_mean_EN;
    end
end


assign DCT_ADDR_start=DCT_ADDR-'d13;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||START||(CNT_13=='d13))begin
        CNT_13 <= 'd0;
    end
    else if(LBG_mean_EN&&again )begin
        CNT_13 <= CNT_13+'d1;
    end
    else begin
        CNT_13 <= CNT_13;
    end
end


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        CNT_ADDR <= 'd0;
    end
    else if(again) begin
        CNT_ADDR <= CNT_13+'d1;
    end
    else if(LBG_mean_EN) begin
        CNT_ADDR <= CNT_ADDR+'d13;
    end
end


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        LBG_ALL <= 'd0;
    end
    else if(again3) begin
        LBG_ALL <= MFCCS13_DATA_1;
    end
    else if(LBG_mean_EN_1) begin
        LBG_ALL <= LBG_ALL+MFCCS13_DATA_1;
    end
end
Divider #
(
.A_LEN(23),
.B_LEN(9)
)divide32_x_h
(
		.CLK(clk),
		.EN(again3 ),
		.RSTN(rst_n),
		.Dividend(LBG_ALL),
		.Divisor(Frams_Number),
		.Quotient(LBG_init),
		.Mod(),
		.RDY(LBG_init_en)
);

assign MFCCS13_DATA_1={{9{MFCCS13_DATA[13]}},MFCCS13_DATA};
assign again=(LBG_mean_EN&&(CNT_ADDR>=DCT_ADDR_start)&&(CNT_ADDR<=DCT_ADDR))?'d1:'d0;

assign MFCCS13_ADDR=CNT_ADDR;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        again2<='d0;
        again3<='d0;
    end
    else begin
        again2<=again;
        again3<=again2;
    end
end
reg FINSH_1;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        FINSH_1 <= 'd0;
    end
    else if((CNT_13=='d13)) begin
        FINSH_1 <= 'd1;
    end
    else if(FINSH) begin
        FINSH_1 <= 'd0;
    end
    else  begin
        FINSH_1 <= FINSH_1;
    end
end
reg LBG_init_en_1;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        LBG_init_en_1<='d0;
    end
    else begin
        LBG_init_en_1<=LBG_init_en;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||(LBG_init_addr=='d12))begin
        LBG_init_addr<='d0;
    end
    else if(LBG_init_en) begin
        LBG_init_addr<=LBG_init_addr+'d1;
    end
end


assign FINSH=(FINSH_1&&LBG_init_en_1)?'d1:'d0;


endmodule