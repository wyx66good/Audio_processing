//
///*************
//Author:wyx
//Times :2024.8.4
//VQ_LBG 训练码本
//**************/
//
//module VQ_LBG(
//
//    input     wire              clk  ,
//    input     wire              rst_n,
//
//    input   wire                START,
//
//    input     wire [12:0]       DCT_ADDR,
//    input     wire  [8:0]       Frams_Number,
//    output    wire  [12:0]       MFCCS13_ADDR,
//    input     wire [13:0]       MFCCS13_DATA
//
//
//
//
//   );
//
//reg  Clear;
//wire LBG_mean_FINSH;
//wire SPLIT_FINSH;
//wire VQ_classify_FINSH;
///************************************************************************************/
//
//localparam ST_1          = 5'b00001;
//localparam ST_2          = 5'b00010;
//localparam ST_3          = 5'b00100;
//localparam ST_4          = 5'b01000;
//localparam ST_5          = 5'b10000;
//localparam ST_6          = 5'b10001;
//localparam ST_7          = 5'b10011;
//localparam ST_8          = 5'b10101;
//localparam ST_9          = 5'b11001;
//
//reg     [4:0]   fsm_c;
//reg     [4:0]   fsm_n/*synthesis PAP_MARK_DEBUG="1"*/;
//always@(posedge clk or negedge rst_n)
//begin
//    if(!rst_n)
//        fsm_c <= ST_1;
//    else
//        fsm_c <= fsm_n;
//end
//always@(*)
//begin
//    case(fsm_c)
//        ST_1:begin//求均值
//            if(LBG_mean_FINSH)begin
//                fsm_n<=ST_2;
//                Clear<='d0;
//            end
//            else begin
//                fsm_n <= ST_1;
//                Clear<='d1;
//            end
//        end
//        ST_2:begin//分裂
//            if(SPLIT_FINSH)begin
//                fsm_n<=ST_3;
//            end
//            else
//                fsm_n <= ST_2;
//        end
//        ST_3:begin//分类
//            if(VQ_classify_FINSH)
//                fsm_n<=ST_2;
//            else
//                fsm_n <= ST_3;
//        end
//
//        default:
//                fsm_n <= ST_1;
//    endcase
//end
///************************************************************************************/
//
//
//wire LBG_mean_EN;
//
////always@(posedge clk or negedge rst_n)
////begin
////    if(!rst_n||LBG_mean_FINSH)begin
////        LBG_mean_EN <= 'd0;
////    end
////    else if(START) begin
////        LBG_mean_EN <='d1;
////    end
////end
//
//wire [13:0]       LBG_init;
//wire              LBG_init_en;
//wire  [12:0]       LBG_mean_MFCCS13_ADDR;
//LBG_mean LBG_mean(
//.clk              (clk          ),
//.rst_n            (rst_n        ),
//.START            (START        ),
//.FINSH            (LBG_mean_FINSH),
//.LBG_mean_EN      (LBG_mean_EN  ),
//.DCT_ADDR         (DCT_ADDR     ),
//.Frams_Number     (Frams_Number ),
//.MFCCS13_ADDR     (LBG_mean_MFCCS13_ADDR ),
//.MFCCS13_DATA     (MFCCS13_DATA ),
////.LBG_init         (LBG_init), 
//.LBG_init_en      (LBG_init_en)
//   );
//
//
//reg [7:0] LBG_Addr;
//
//always@(posedge clk or negedge rst_n)
//begin
//    if(!rst_n)begin
//        LBG_Addr <= 'd0;
//    end
//    else if(LBG_init_en) begin
//        LBG_Addr <=LBG_Addr+'d1;
//    end
//end
//
//
////码本分裂
//wire [13:0] VQ_LBG_rd_data;
//
//wire        SPLIT_START;
//wire [13:0] LBG_SPLIT_wr_data;
//wire [7:0]  LBG_SPLIT_wr_addr;
//wire        LBG_SPLIT_wr_en  ;
//wire [13:0] LBG_SPLIT_rd_data;
//wire [7:0]  LBG_SPLIT_rd_addr;
//
//SPLIT SPLIT(
//.clk                  (clk              ),
//.rst_n                (rst_n            ),
//.START                (SPLIT_START      ),
//.FINSH                (SPLIT_FINSH      ),
//.LBG_SPLIT_wr_data    (LBG_SPLIT_wr_data),
//.LBG_SPLIT_wr_addr    (LBG_SPLIT_wr_addr),
//.LBG_SPLIT_wr_en      (LBG_SPLIT_wr_en  ),
//.LBG_SPLIT_rd_data    (LBG_SPLIT_rd_data),
//.LBG_SPLIT_rd_addr    (LBG_SPLIT_rd_addr)
//
//   );
//assign LBG_SPLIT_rd_data=VQ_LBG_rd_data;
//assign SPLIT_START=((fsm_n==ST_2)&&!(fsm_c==ST_2))?'d1:'d0;
//
//
//
////码本
//reg   [13:0] LBG_wr_data;
//reg   [7:0]  LBG_wr_addr;
//reg          LBG_wr_en  ;
//reg   [7:0]  VQ_LBG_rd_addr;
//wire  [7:0]  VQ_LBG_SPLIT_rd_addr;
//always@(posedge clk or negedge rst_n)
//begin
//    if(!rst_n)begin
//        LBG_wr_data<='d0;
//        LBG_wr_addr<='d0;
//        LBG_wr_en  <='d0;
//        VQ_LBG_rd_addr<='d0;
//    end
//    else if( fsm_n == ST_1) begin
//        LBG_wr_data<=LBG_init;
//        LBG_wr_addr<=LBG_Addr;
//        LBG_wr_en  <=LBG_init_en;
//    end
//    else if( fsm_n == ST_2) begin
//        LBG_wr_data<=LBG_SPLIT_wr_data;
//        LBG_wr_addr<=LBG_SPLIT_wr_addr;
//        LBG_wr_en  <=LBG_SPLIT_wr_en  ;
//        VQ_LBG_rd_addr<=LBG_SPLIT_rd_addr;
//    end
//    else if( fsm_n == ST_3) begin
//        VQ_LBG_rd_addr<=VQ_LBG_SPLIT_rd_addr;
//    end
//end
//
//
//
////16x13=208
//VQ_LBG_16X13 VQ_LBG_16X13_1 (
//  .wr_data    (LBG_wr_data    ),    // input [7:0]
//  .wr_addr    (LBG_wr_addr    ),    // input [7:0]
//  .wr_en      (LBG_wr_en      ),        // input
//  .wr_clk     (clk            ),      // input
//  .wr_rst     (!rst_n         ),      // input
//  .rd_addr    (VQ_LBG_rd_addr ),    // input [7:0]
//  .rd_data    (VQ_LBG_rd_data ),    // output [7:0]
//  .rd_clk     (clk            ),      // input
//  .rd_rst     (!rst_n         )       // input
//);
//
//wire  [12:0]       VQ_classify_MFCCS13_ADDR;
//
//VQ_classify VQ_classify(
//
//.clk              (clk                           ),
//.rst_n            (rst_n                         ),
//.START            (!(fsm_c==ST_3)&&(fsm_n==ST_3) ),
//.FINSH            (VQ_classify_FINSH             ),
//.Clear            (Clear                         ),
//.Frams_Number     (Frams_Number                  ),
//.CNT_FOR          (CNT_FOR                       ),
//.DCT_ADDR         (DCT_ADDR                      ),
//.MFCCS13_ADDR     (VQ_classify_MFCCS13_ADDR      ),
//.MFCCS13_DATA     (MFCCS13_DATA                  ),
//.LBG_SPLIT_rd_data(VQ_LBG_rd_data                ),
//.LBG_SPLIT_rd_addr(VQ_LBG_SPLIT_rd_addr          )
//
//   );
//
//
//assign MFCCS13_ADDR=(fsm_c == ST_1)?LBG_mean_MFCCS13_ADDR:VQ_classify_MFCCS13_ADDR;
//
//
//
//
//
//
//
//endmodule