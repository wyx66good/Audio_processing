/*************
Author:wyx
Times :2024.8.9
MFCC 一帧获取
**************/




module MFCC_frame_13(

    input     wire              clk  ,
    input     wire              rst_n,

    input    wire                MFCC_start,//开始识别
    output   reg                 MFCC_finsh,//结束识别

    input     wire [12:0]       DCT_ADDR,
    input     wire  [8:0]       Frams_Number,

    output    wire              MFCCS13_en,
    output    wire [7:0]        MFCCS13_ADDR,
    input     wire [13:0]       MFCCS13_DATA,

    input    wire [7:0]         MFCCS13_rd_ADDR,
    output     wire [13:0]       MFCCS13_rd_DATA


   );
reg [7:0]   MFCCS13_wr_ADDR_1;
wire [13:0] MFCCS13_wr_DATA;
reg         MFCCS13_wr_en_1;

reg [7:0]   MFCCS13_wr_ADDR;
reg         MFCCS13_wr_en  ;

wire        MFCCS13_wr_ADDR_FINSH;

assign MFCCS13_en=MFCCS13_wr_en_1;



always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||MFCCS13_wr_ADDR_FINSH)begin
        MFCCS13_wr_ADDR_1 <= 'd0;
    end
    else if(MFCCS13_wr_en_1) begin
        MFCCS13_wr_ADDR_1 <= MFCCS13_wr_ADDR_1+'d1;
    end
    else begin
        MFCCS13_wr_ADDR_1 <= 'd0;
    end
end



always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||MFCCS13_wr_ADDR_FINSH)begin
        MFCCS13_wr_en_1 <= 'd0;
    end
    else if(MFCC_start) begin
        MFCCS13_wr_en_1 <= 'd1;
    end
    else begin
        MFCCS13_wr_en_1 <= MFCCS13_wr_en_1;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
       MFCCS13_wr_ADDR<='d0;
       MFCCS13_wr_en   <= 'd0;
       MFCC_finsh      <='d0;
    end
    else begin
       MFCCS13_wr_ADDR<=MFCCS13_wr_ADDR_1;
       MFCCS13_wr_en  <=MFCCS13_wr_en_1  ;
       MFCC_finsh      <=MFCCS13_wr_ADDR_FINSH;
    end
end

assign MFCCS13_wr_ADDR_FINSH=(MFCCS13_wr_ADDR_1=='d12)?'d1:'d0;
assign MFCCS13_wr_DATA=MFCCS13_DATA;
assign MFCCS13_ADDR=MFCCS13_wr_ADDR_1;



MFCCS13_RAM14X12 MFCCS13_RAM14X12 (
  .wr_data(MFCCS13_wr_DATA),    // input [13:0]
  .wr_addr(MFCCS13_wr_ADDR),    // input [4:0]
  .wr_en  (MFCCS13_wr_en  ),        // input
  .wr_clk(clk),      // input
  .wr_rst(!rst_n),      // input
  .rd_addr(MFCCS13_rd_ADDR),    // input [4:0]
  .rd_data(MFCCS13_rd_DATA),    // output [13:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst_n)       // input
);







endmodule