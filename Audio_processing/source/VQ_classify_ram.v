///*************
//Author:wyx
//Times :2024.8.4
//VQ ∑÷¿‡¥Ê»°∆˜£¨ram
//**************/
//
//
//
//
//module VQ_classify_ram1(
//
//    input     wire              clk  ,
//    input     wire              rst_n,
//    input     wire              Clear,
//
//    input   wire                START,
//    output   wire               FINSH,
//
//    output   reg    [8:0]       Frams_Number,
//    output   wire   [12:0]      VQ_classify_DCT_ADDR,
//
//    input    wire [13:0]        MFCCS13 ,
//    output reg             VQ_classify_ram_wr_EN,
//
//    input    wire  [12:0]      VQ_classify_ram_rd_ADDR,
//    output     wire [13:0]       VQ_classify_ram_rd_DATA
//
//
//   );
//
//wire  [13:0]     VQ_classify_ram_wr_DATA;
//reg [11:0]      VQ_classify_ram_wr_ADDR;
//reg             VQ_classify_ram_wr_EN_1;
//reg  [3:0]      CNT;
//
//always@(posedge clk or negedge rst_n)
//begin
//    if(!rst_n)begin
//        VQ_classify_ram_wr_EN <= 0;
//    end
//    else if(START) begin
//        VQ_classify_ram_wr_EN <='d1;
//    end
//    else if((CNT=='d12)) begin
//        VQ_classify_ram_wr_EN <='d0;
//    end
//end
//always@(posedge clk or negedge rst_n)
//begin
//    if(!rst_n)begin
//        VQ_classify_ram_wr_EN_1 <= 0;
//    end
//    else begin
//        VQ_classify_ram_wr_EN_1 <=VQ_classify_ram_wr_EN;
//    end
//end
//always@(posedge clk or negedge rst_n)
//begin
//    if(!rst_n||Clear)begin
//        VQ_classify_ram_wr_ADDR <= 'd0;
//    end
//    else if(VQ_classify_ram_wr_EN_1) begin
//        VQ_classify_ram_wr_ADDR <=VQ_classify_ram_wr_ADDR+'d1;
//    end
//    else  begin
//        VQ_classify_ram_wr_ADDR <=VQ_classify_ram_wr_ADDR;
//    end
//end
//
//assign VQ_classify_ram_wr_DATA=MFCCS13;
//
//always@(posedge clk or negedge rst_n)
//begin
//    if(!rst_n||START||Clear||(CNT=='d12))begin
//        CNT <= 0;
//    end
//    else if(VQ_classify_ram_wr_EN) begin
//        CNT <=CNT+'d1;
//    end
//end
//
//assign FINSH=(CNT=='d12)?'d1:'d0;
//VQ_classify_ram1 VQ_classify_ram1 (
//  .wr_data  (VQ_classify_ram_wr_DATA        ),    // input [13:0]
//  .wr_addr  (VQ_classify_ram_wr_ADDR        ),    // input [12:0]
//  .wr_en    (VQ_classify_ram_wr_EN_1     ),        // input
//  .wr_clk   (clk             ),      // input
//  .wr_rst   (!rst_n  ||Clear        ),      // input
//  .rd_addr  (VQ_classify_ram_rd_ADDR[11:0]    ),    // input [12:0]
//  .rd_data  (VQ_classify_ram_rd_DATA    ),    // output [13:0]
//  .rd_clk   (clk             ),      // input
//  .rd_rst   (!rst_n     ||Clear     )       // input
//);
//
//
//
//always@(posedge clk or negedge rst_n)
//begin
//    if(!rst_n||Clear)begin
//        Frams_Number <= 0;
//    end
//    else if(FINSH) begin
//        Frams_Number <=Frams_Number+'d1;
//    end
//    else  begin
//        Frams_Number <=Frams_Number;
//    end
//end
//
//
//assign VQ_classify_DCT_ADDR=VQ_classify_ram_wr_ADDR;
//
//
//endmodule