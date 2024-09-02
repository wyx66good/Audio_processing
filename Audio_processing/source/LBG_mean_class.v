///*************
//Author:wyx
//Times :2024.8.7
//VQ_LBG 分类码本求平均
//**************/
//
//
//
//
//module LBG_mean_class(
//    input     wire              clk  ,
//    input     wire              rst_n,
//
//    input     wire              clear,
//
//    input   wire                START,
//    output   wire               FINSH,
//    input   wire                LBG_mean_EN,
//
//    input     wire [12:0]       DCT_ADDR,
//    input     wire  [8:0]       Frams_Number,
//    input     wire  [2:0]       CNT_FOR,
//
//    output    wire  [12:0]      MFCCS13_ADDR,
//    input     wire [13:0]       MFCCS13_DATA,
//
//    output    reg [13:0]       LBG_init_data_1,
//    output    reg [7:0]        LBG_init_addr_1,
//    output    reg              LBG_init_en_1  ,
//
//
//    input wire[8:0]    Frams_Number_classify_1,
//    input wire[12:0]   VQ_classify_DCT_ADDR_1,
//    output  wire[12:0] VQ_classify_ram_rd_ADDR_1,
//    input wire[13:0] VQ_classify_ram_rd_DATA_1,
//                                        
//    input  wire[8:0]    Frams_Number_classify_2,
//    input  wire[12:0]   VQ_classify_DCT_ADDR_2,
//    output wire[12:0] VQ_classify_ram_rd_ADDR_2,
//    input  wire[13:0] VQ_classify_ram_rd_DATA_2,
//                                        
//    input  wire[8:0]    Frams_Number_classify_3,
//    input  wire[12:0]   VQ_classify_DCT_ADDR_3,
//    output wire[12:0] VQ_classify_ram_rd_ADDR_3,
//    input  wire[13:0] VQ_classify_ram_rd_DATA_3,
//                                        
//                                        
//    input  wire[8:0]    Frams_Number_classify_4,
//    input  wire[12:0]   VQ_classify_DCT_ADDR_4,
//    output wire[12:0] VQ_classify_ram_rd_ADDR_4,
//    input  wire[13:0] VQ_classify_ram_rd_DATA_4,
//                                        
//    input  wire[8:0]    Frams_Number_classify_5,
//    input  wire[12:0]   VQ_classify_DCT_ADDR_5,
//    output wire[12:0] VQ_classify_ram_rd_ADDR_5,
//    input  wire[13:0] VQ_classify_ram_rd_DATA_5,
//                                        
//    input  wire[8:0]    Frams_Number_classify_6,
//    input  wire[12:0]   VQ_classify_DCT_ADDR_6,
//    output wire[12:0] VQ_classify_ram_rd_ADDR_6,
//    input  wire[13:0] VQ_classify_ram_rd_DATA_6,
//                                        
//                                        
//    input  wire[8:0]    Frams_Number_classify_7,
//    input  wire[12:0]   VQ_classify_DCT_ADDR_7,
//    output wire[12:0] VQ_classify_ram_rd_ADDR_7,
//    input  wire[13:0] VQ_classify_ram_rd_DATA_7,
//                                        
//                                       
//    input  wire[8:0]    Frams_Number_classify_8,
//    input  wire[12:0]   VQ_classify_DCT_ADDR_8,
//    output wire[12:0] VQ_classify_ram_rd_ADDR_8,
//    input  wire[13:0] VQ_classify_ram_rd_DATA_8,
//                                        
//                                        
//    input  wire[8:0]    Frams_Number_classify_9,
//    input  wire[12:0]   VQ_classify_DCT_ADDR_9,
//    output wire[12:0] VQ_classify_ram_rd_ADDR_9,
//    input  wire[13:0] VQ_classify_ram_rd_DATA_9,
//                                        
//                                        
//    input  wire[8:0]    Frams_Number_classify_10,
//    input  wire[12:0]   VQ_classify_DCT_ADDR_10,
//    output wire[12:0] VQ_classify_ram_rd_ADDR_10,
//    input  wire[13:0] VQ_classify_ram_rd_DATA_10,
//                                        
//    input  wire[8:0]    Frams_Number_classify_11,
//    input  wire[12:0]   VQ_classify_DCT_ADDR_11,
//    output wire[12:0] VQ_classify_ram_rd_ADDR_11,
//    input  wire[13:0] VQ_classify_ram_rd_DATA_11,
//                                        
//    input  wire[8:0]    Frams_Number_classify_12,
//    input  wire[12:0]   VQ_classify_DCT_ADDR_12,
//    output wire[12:0] VQ_classify_ram_rd_ADDR_12,
//    input  wire[13:0] VQ_classify_ram_rd_DATA_12,
//                                        
//    input  wire[8:0]    Frams_Number_classify_13,
//    input  wire[12:0]   VQ_classify_DCT_ADDR_13,
//    output wire[12:0] VQ_classify_ram_rd_ADDR_13,
//    input  wire[13:0] VQ_classify_ram_rd_DATA_13,
//                                        
//    input  wire[8:0]    Frams_Number_classify_14,
//    input  wire[12:0]   VQ_classify_DCT_ADDR_14,
//    output wire[12:0] VQ_classify_ram_rd_ADDR_14,
//    input  wire[13:0] VQ_classify_ram_rd_DATA_14,
//                                        
//    input  wire[8:0]    Frams_Number_classify_15,
//    input  wire[12:0]   VQ_classify_DCT_ADDR_15,
//    output wire[12:0] VQ_classify_ram_rd_ADDR_15,
//    input  wire[13:0] VQ_classify_ram_rd_DATA_15,
//    
//    input  wire[8:0]    Frams_Number_classify_16,
//    input  wire[12:0]   VQ_classify_DCT_ADDR_16,
//    output wire[12:0] VQ_classify_ram_rd_ADDR_16,
//    input  wire[13:0] VQ_classify_ram_rd_DATA_16
//
//
//   );
//
//
//reg LBG_mean_class_START;
//wire  LBG_mean_class_START_1;
//reg LBG_mean_class_START_2;
//wire LBG_mean_class_FINSH;
//reg finsh;
//
//reg LBG_mean_class_EN;
//reg [4:0] LBG_mean_class_CNT;
//
//wire[12:0]  VQ_classify_DCT_ADDR    ; 
//wire[8:0] Frams_Number_classify   ; 
//wire[12:0] VQ_classify_ram_rd_ADDR ; 
//wire[13:0] VQ_classify_ram_rd_DATA ;  
//
//
//always@(posedge clk or negedge rst_n)
//begin
//    if(!rst_n)
//        LBG_mean_class_START <= 'd0;
//    else if((START||finsh)&&((LBG_mean_class_CNT<'d2)&&(CNT_FOR=='d1)))
//        LBG_mean_class_START <= 'd1;
//    else if((START||finsh)&&((LBG_mean_class_CNT<'d4)&&(CNT_FOR=='d2)))
//        LBG_mean_class_START <= 'd1;
//    else if((START||finsh)&&((LBG_mean_class_CNT<'d8)&&(CNT_FOR=='d3)))
//        LBG_mean_class_START <= 'd1;
//    else if((START||finsh)&&((LBG_mean_class_CNT<'d16)&&(CNT_FOR=='d4)))
//        LBG_mean_class_START <= 'd1;
//    else
//        LBG_mean_class_START <= 'd0;
//end
////always@(posedge clk or negedge rst_n)
////begin
////    if(!rst_n)
////        LBG_mean_class_START_1 <= 'd0;
////    else if(LBG_mean_class_START&&(Frams_Number_classify!='d0))
////        LBG_mean_class_START_1 <= 'd1;
////    else
////        LBG_mean_class_START_1 <= 'd0;
////end
//assign LBG_mean_class_START_1=(LBG_mean_class_START||(Frams_Number_classify=='d0))?'d1:'d0;
//always@(posedge clk or negedge rst_n)
//begin
//    if(!rst_n)
//        LBG_mean_class_START_2 <= 'd0;
//    else
//        LBG_mean_class_START_2 <= LBG_mean_class_START_1;
//end
//always@(posedge clk or negedge rst_n)
//begin
//    if(!rst_n||(VQ_classify_ram_rd_ADDR==VQ_classify_DCT_ADDR-'d1))
//        LBG_mean_class_EN <= 'd0;
//    else if(!LBG_mean_class_START_1&&LBG_mean_class_START_2)
//        LBG_mean_class_EN <= 'd1;
//    else
//        LBG_mean_class_EN <= LBG_mean_class_EN;
//end
//always@(posedge clk or negedge rst_n)
//begin
//    if(!rst_n||clear)
//        LBG_mean_class_CNT <= 'd0;
//    else if(LBG_mean_class_START_1&&((LBG_mean_class_CNT<'d2)&&(CNT_FOR=='d1)))
//        LBG_mean_class_CNT <= LBG_mean_class_CNT+'d1;
//    else if(LBG_mean_class_START_1&&((LBG_mean_class_CNT<'d4)&&(CNT_FOR=='d2)))
//        LBG_mean_class_CNT <= LBG_mean_class_CNT+'d1;
//    else if(LBG_mean_class_START_1&&((LBG_mean_class_CNT<'d8)&&(CNT_FOR=='d3)))
//        LBG_mean_class_CNT <= LBG_mean_class_CNT+'d1;
//    else if(LBG_mean_class_START_1&&((LBG_mean_class_CNT<'d16)&&(CNT_FOR=='d4)))
//        LBG_mean_class_CNT <= LBG_mean_class_CNT+'d1;
//    else
//        LBG_mean_class_CNT <= LBG_mean_class_CNT;
//end
//
//assign FINSH=(((LBG_mean_class_CNT=='d2)&&(LBG_init_addr_1=='d26)&&(CNT_FOR=='d1)) ||((LBG_mean_class_CNT=='d4)&&(LBG_init_addr_1=='d52)&&(CNT_FOR=='d2)) ||
//                ((LBG_mean_class_CNT=='d8)&&(LBG_init_addr_1=='d104)&&(CNT_FOR=='d3))||((LBG_mean_class_CNT=='d16)&&(LBG_init_addr_1=='d208)&&(CNT_FOR=='d4))            
//                )?'d1:'d0;
//wire [3:0] LBG_init_addr;
//wire [13:0]LBG_init_data; 
//wire       LBG_init_en;    
//LBG_mean LBG_mean_class_1(
//.clk              (clk          ),
//.rst_n            (rst_n  &&(!finsh)     ),
//.START            (LBG_mean_class_START),
//.FINSH            (LBG_mean_class_FINSH),
//.LBG_mean_EN      (LBG_mean_class_EN          ),
//.DCT_ADDR         (VQ_classify_DCT_ADDR     ),
//.Frams_Number     (Frams_Number_classify    ),
//.MFCCS13_ADDR     (VQ_classify_ram_rd_ADDR  ),
//.MFCCS13_DATA     (VQ_classify_ram_rd_DATA  ),
//.LBG_init_data    (LBG_init_data), 
//.LBG_init_addr    (LBG_init_addr),
//.LBG_init_en      (LBG_init_en  )
//   );
//always@(posedge clk or negedge rst_n)
//begin
//    if(!rst_n)
//        finsh <= 'd0;
//    else if((LBG_init_addr=='d13))
//        finsh <= 'd1;
//    else
//        finsh <= 'd0;
//end
//
//always@(posedge clk or negedge rst_n)
//begin
//    if(!rst_n||clear)
//        LBG_init_addr_1 <= 'd0;
//    else if(LBG_init_en_1&&LBG_mean_EN)
//        LBG_init_addr_1 <= LBG_init_addr_1+'d1;
//    else if((Frams_Number_classify=='d0)&&LBG_mean_EN)
//        LBG_init_addr_1 <= LBG_init_addr_1+'d13;
//    else
//        LBG_init_addr_1 <= LBG_init_addr_1;
//end
//always@(posedge clk or negedge rst_n)
//begin
//    if(!rst_n)begin
//        LBG_init_en_1 <= 'd0;
//        LBG_init_data_1 <= 'd0;
//    end
//    else begin
//        LBG_init_en_1 <= LBG_init_en;
//        LBG_init_data_1 <= LBG_init_data;
//    end
//end
//
//
//assign VQ_classify_DCT_ADDR=((LBG_mean_class_CNT=='d1))?VQ_classify_DCT_ADDR_1:
//                            ((LBG_mean_class_CNT=='d2))?VQ_classify_DCT_ADDR_2:
//                            ((LBG_mean_class_CNT=='d3))?VQ_classify_DCT_ADDR_3:
//                            ((LBG_mean_class_CNT=='d4))?VQ_classify_DCT_ADDR_4:
//                            ((LBG_mean_class_CNT=='d5))?VQ_classify_DCT_ADDR_5:
//                            ((LBG_mean_class_CNT=='d6))?VQ_classify_DCT_ADDR_6:
//                            ((LBG_mean_class_CNT=='d7))?VQ_classify_DCT_ADDR_7:
//                            ((LBG_mean_class_CNT=='d8))?VQ_classify_DCT_ADDR_8:
//                            ((LBG_mean_class_CNT=='d9))?VQ_classify_DCT_ADDR_9:
//                            ((LBG_mean_class_CNT=='d10))?VQ_classify_DCT_ADDR_10:
//                            ((LBG_mean_class_CNT=='d11))?VQ_classify_DCT_ADDR_11:
//                            ((LBG_mean_class_CNT=='d12))?VQ_classify_DCT_ADDR_12:
//                            ((LBG_mean_class_CNT=='d13))?VQ_classify_DCT_ADDR_13:
//                            ((LBG_mean_class_CNT=='d14))?VQ_classify_DCT_ADDR_14:
//                            ((LBG_mean_class_CNT=='d15))?VQ_classify_DCT_ADDR_15:
//                            ((LBG_mean_class_CNT=='d16))?VQ_classify_DCT_ADDR_16:VQ_classify_DCT_ADDR_1;
//
//assign Frams_Number_classify=((LBG_mean_class_CNT=='d1))?Frams_Number_classify_1:
//                            ((LBG_mean_class_CNT=='d2))? Frams_Number_classify_2:
//                            ((LBG_mean_class_CNT=='d3))? Frams_Number_classify_3:
//                            ((LBG_mean_class_CNT=='d4))? Frams_Number_classify_4:
//                            ((LBG_mean_class_CNT=='d5))? Frams_Number_classify_5:
//                            ((LBG_mean_class_CNT=='d6))? Frams_Number_classify_6:
//                            ((LBG_mean_class_CNT=='d7))? Frams_Number_classify_7:
//                            ((LBG_mean_class_CNT=='d8))? Frams_Number_classify_8:
//                            ((LBG_mean_class_CNT=='d9))? Frams_Number_classify_9:
//                            ((LBG_mean_class_CNT=='d10))?Frams_Number_classify_10:
//                            ((LBG_mean_class_CNT=='d11))?Frams_Number_classify_11:
//                            ((LBG_mean_class_CNT=='d12))?Frams_Number_classify_12:
//                            ((LBG_mean_class_CNT=='d13))?Frams_Number_classify_13:
//                            ((LBG_mean_class_CNT=='d14))?Frams_Number_classify_14:
//                            ((LBG_mean_class_CNT=='d15))?Frams_Number_classify_15:
//                            ((LBG_mean_class_CNT=='d16))?Frams_Number_classify_16:Frams_Number_classify_1;
//
//assign VQ_classify_ram_rd_DATA=((LBG_mean_class_CNT=='d1))? VQ_classify_ram_rd_DATA_1:
//                               ((LBG_mean_class_CNT=='d2))? VQ_classify_ram_rd_DATA_2:
//                               ((LBG_mean_class_CNT=='d3))? VQ_classify_ram_rd_DATA_3:
//                               ((LBG_mean_class_CNT=='d4))? VQ_classify_ram_rd_DATA_4:
//                               ((LBG_mean_class_CNT=='d5))? VQ_classify_ram_rd_DATA_5:
//                               ((LBG_mean_class_CNT=='d6))? VQ_classify_ram_rd_DATA_6:
//                               ((LBG_mean_class_CNT=='d7))? VQ_classify_ram_rd_DATA_7:
//                               ((LBG_mean_class_CNT=='d8))? VQ_classify_ram_rd_DATA_8:
//                               ((LBG_mean_class_CNT=='d9))? VQ_classify_ram_rd_DATA_9:
//                               ((LBG_mean_class_CNT=='d10))?VQ_classify_ram_rd_DATA_10:
//                               ((LBG_mean_class_CNT=='d11))?VQ_classify_ram_rd_DATA_11:
//                               ((LBG_mean_class_CNT=='d12))?VQ_classify_ram_rd_DATA_12:
//                               ((LBG_mean_class_CNT=='d13))?VQ_classify_ram_rd_DATA_13:
//                               ((LBG_mean_class_CNT=='d14))?VQ_classify_ram_rd_DATA_14:
//                               ((LBG_mean_class_CNT=='d15))?VQ_classify_ram_rd_DATA_15:
//                               ((LBG_mean_class_CNT=='d16))?VQ_classify_ram_rd_DATA_16:VQ_classify_ram_rd_DATA_1;
//
//assign  VQ_classify_ram_rd_ADDR_1=((LBG_mean_class_CNT=='d1))? VQ_classify_ram_rd_ADDR:'d0;
//assign  VQ_classify_ram_rd_ADDR_2=((LBG_mean_class_CNT=='d2))? VQ_classify_ram_rd_ADDR:'d0;
//assign  VQ_classify_ram_rd_ADDR_3=((LBG_mean_class_CNT=='d3))? VQ_classify_ram_rd_ADDR:'d0;
//assign  VQ_classify_ram_rd_ADDR_4=((LBG_mean_class_CNT=='d4))? VQ_classify_ram_rd_ADDR:'d0;
//assign  VQ_classify_ram_rd_ADDR_5=((LBG_mean_class_CNT=='d5))? VQ_classify_ram_rd_ADDR:'d0;
//assign  VQ_classify_ram_rd_ADDR_6=((LBG_mean_class_CNT=='d6))? VQ_classify_ram_rd_ADDR:'d0;
//assign  VQ_classify_ram_rd_ADDR_7=((LBG_mean_class_CNT=='d7))? VQ_classify_ram_rd_ADDR:'d0;
//assign  VQ_classify_ram_rd_ADDR_8=((LBG_mean_class_CNT=='d8))? VQ_classify_ram_rd_ADDR:'d0;
//assign  VQ_classify_ram_rd_ADDR_9=((LBG_mean_class_CNT=='d9))? VQ_classify_ram_rd_ADDR:'d0;
//assign VQ_classify_ram_rd_ADDR_10=((LBG_mean_class_CNT=='d10))?VQ_classify_ram_rd_ADDR:'d0;
//assign VQ_classify_ram_rd_ADDR_11=((LBG_mean_class_CNT=='d11))?VQ_classify_ram_rd_ADDR:'d0;
//assign VQ_classify_ram_rd_ADDR_12=((LBG_mean_class_CNT=='d12))?VQ_classify_ram_rd_ADDR:'d0;
//assign VQ_classify_ram_rd_ADDR_13=((LBG_mean_class_CNT=='d13))?VQ_classify_ram_rd_ADDR:'d0;
//assign VQ_classify_ram_rd_ADDR_14=((LBG_mean_class_CNT=='d14))?VQ_classify_ram_rd_ADDR:'d0;
//assign VQ_classify_ram_rd_ADDR_15=((LBG_mean_class_CNT=='d15))?VQ_classify_ram_rd_ADDR:'d0;
//assign VQ_classify_ram_rd_ADDR_16=((LBG_mean_class_CNT=='d16))?VQ_classify_ram_rd_ADDR:'d0;
//
//
//
//
//
//
//endmodule