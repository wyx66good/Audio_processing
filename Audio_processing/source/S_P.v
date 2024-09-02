//
///*************
//Author:wyx
//Times :2024.7.3
//ÖĞÖµÂË²¨ 15*15
//**************/
//module S_P(
//    input                           clk,
//    input                           rst_n,
//    
//    input                           statr,
//    input [3:0]                    fsm_Median,
//    output wire                    finsh_s_h,
//
//    input wire         [63:0]      rd_data_1,
//    output  wire         [9:0]       rd_addr_1,
//    input wire         [63:0]      rd_data_2,
//    output  wire         [9:0]       rd_addr_2,
//    input wire         [63:0]      rd_data_3,
//    output  wire         [9:0]       rd_addr_3,
//    input wire         [63:0]      rd_data_4,
//    output  wire         [9:0]       rd_addr_4,
//    input wire         [63:0]      rd_data_5,
//    output  wire         [9:0]       rd_addr_5,
//    input wire         [63:0]      rd_data_6,
//    output  wire         [9:0]       rd_addr_6,
//    input wire         [63:0]      rd_data_7,
//    output  wire         [9:0]       rd_addr_7,
//    input wire         [63:0]      rd_data_8,
//    output  wire         [9:0]       rd_addr_8,
//    input wire         [63:0]      rd_data_9,
//    output  wire         [9:0]       rd_addr_9,
//    input wire         [63:0]      rd_data_10,
//    output  wire         [9:0]       rd_addr_10,
//    input wire         [63:0]      rd_data_11,
//    output  wire         [9:0]       rd_addr_11,
//    input wire         [63:0]      rd_data_12,
//    output  wire         [9:0]       rd_addr_12,
//    input wire         [63:0]      rd_data_13,
//    output  wire         [9:0]       rd_addr_13,
//    input wire         [63:0]      rd_data_14,
//    output  wire         [9:0]       rd_addr_14,
//    input wire         [63:0]      rd_data_15,
//    output  wire         [9:0]       rd_addr_15,
//
//
//
//    output wire         [63:0]      rd_data_P,
//    input  wire         [9:0]       rd_addr_P
//   );
//
//reg     [3:0]   fsm_c;
//reg [9:0] Median_addr;
//wire finsh_midian;
///************************************************************************************/
//localparam ST_1          = 5'b00001;
//localparam ST_2          = 5'b00010;
//localparam ST_3          = 5'b00100;
//localparam ST_4          = 5'b01000;
//localparam ST_5          = 5'b10000;
//localparam ST_6          = 5'b10001;
//
//reg     [4:0]   fsm_c_1;
//reg     [4:0]   fsm_n_1;
//always@(posedge clk or negedge rst_n)
//begin
//    if(!rst_n)
//        fsm_c_1 <= ST_1;
//    else
//        fsm_c_1 <= fsm_n_1;
//end
//always@(*)
//begin
//    case(fsm_c_1)
//        ST_1:begin
//            if(statr)
//                fsm_n_1<=ST_2;
//            else
//                fsm_n_1 <= ST_1;
//        end
//        ST_2:begin
//            if(fsm_c=='d15 )
//                fsm_n_1<=ST_3;
//            else
//                fsm_n_1 <= ST_2;
//        end
//        ST_3:begin
//                fsm_n_1 <= ST_4;
//        end
//        ST_4:begin
//            if(finsh_midian)
//                fsm_n_1<=ST_1;
//            else
//                fsm_n_1 <= ST_4;
//        end
//
//    
//        default:
//                fsm_n_1 <= ST_1;
//    endcase
//end
///************************************************************************************/
//
//
//
//
//
//reg  [63:0] rd_data;
//
//wire [3:0] data_which;
//
//
//
//assign rd_addr_1 =fsm_Median-'d14;
//assign rd_addr_2 =fsm_Median-'d13;
//assign rd_addr_3 =fsm_Median-'d12;
//assign rd_addr_4 =fsm_Median-'d11;
//assign rd_addr_5 =fsm_Median-'d10;
//assign rd_addr_6 =fsm_Median-'d9;
//assign rd_addr_7 =fsm_Median-'d8;
//assign rd_addr_8 =fsm_Median-'d7;
//assign rd_addr_9 =fsm_Median-'d6;
//assign rd_addr_10=fsm_Median-'d5;
//assign rd_addr_11=fsm_Median-'d4;
//assign rd_addr_12=fsm_Median-'d3;
//assign rd_addr_13=fsm_Median-'d2;
//assign rd_addr_14=fsm_Median-'d1;
//assign rd_addr_15=fsm_Median;
//
//
//
//always@(posedge clk or negedge rst_n)
//begin
//    if(!rst_n)
//        Median_addr <= 'd0;
//    else if(fsm_c_1== ST_3 )
//        Median_addr <=Median_addr+'d1;
//    else 
//        Median_addr <= Median_addr;
//end
//
//
//assign finsh_s_h=(Median_addr=='d1023)&&finsh_midian;
//
//
//reg  [9:0]  wr_addr_H;
//wire [63:0] wr_data_H;
//wire        wr_en_H;
//reg  finsh_midian_1;
//always@(posedge clk or negedge rst_n)
//begin
//    if(!rst_n||wr_addr_H=='d1023)
//        wr_addr_H <= 'd0;
//    else if(finsh_midian )
//        wr_addr_H <=wr_addr_H+'d1;
//    else 
//        wr_addr_H <= wr_addr_H;
//end
//always@(posedge clk or negedge rst_n)
//begin
//    if(!rst_n)
//        finsh_midian_1 <= 'd0;
//    else 
//        finsh_midian_1 <= finsh_midian;
//end
//
//
//
//wire [63:0]     b1    ;
//wire [63:0]     b2    ;
//wire [63:0]     b3    ;
//wire [63:0]     b4    ;
//wire [63:0]     b5    ;
//wire [63:0]     b6    ;
//wire [63:0]     b7    ;
//wire [63:0]     b8    ;
//wire [63:0]     b9    ;
//wire [63:0]     b10   ;
//wire [63:0]     b11   ;
//wire [63:0]     b12   ;
//wire [63:0]     b13   ;
//wire [63:0]     b14   ;
//wire [63:0]     b15   ;
//
//assign b1 =rd_data_1;
//assign b2 =rd_data_2;
//assign b3 =rd_data_3;
//assign b4 =rd_data_4;
//assign b5 =rd_data_5;
//assign b6 =rd_data_6;
//assign b7 =rd_data_7;
//assign b8 =rd_data_8;
//assign b9 =rd_data_9;
//assign b10=rd_data_10;
//assign b11=rd_data_11;
//assign b12=rd_data_12;
//assign b13=rd_data_13;
//assign b14=rd_data_14;
//assign b15=rd_data_15;
//
//wire [63:0] mid_P;
//midian midian_P(
//.clk     (clk),
//.rst_n   (rst_n),
//.start   ((fsm_n_1==ST_4)&&!(fsm_c_1==ST_4)),
//.finsh   (finsh_midian),
//.a1      (b1 ),
//.a2      (b2 ),
//.a3      (b3 ),
//.a4      (b4 ),
//.a5      (b5 ),
//.a6_1    (b6 ),
//.a7_1    (b7 ),
//.a8_1    (b8 ),
//.a9_1    (b9 ),
//.a10_1   (b10),
//.a11_1   (b11),
//.a12_1   (b12),
//.a13_1   (b13),
//.a14_1   (b14),
//.a15_1   (b15),
//.mid   (mid_P)
//
//   );
//wire [63:0] wr_data_p;
//
//assign wr_data_p=mid_P;
//
//Median Median_P (
//  .wr_data(wr_data_p),    // input [42:0]
//  .wr_addr(wr_addr_H),    // input [9:0]
//  .rd_addr(rd_addr_P),    // input [9:0]
//  .wr_clk(clk),      // input
//  .rd_clk(clk),      // input
//  .wr_en(wr_en_H),        // input
//  .rst(!rst_n),            // input
//  .rd_data(rd_data_P)     // output [42:0]
//);
//
//
//
//
//
//endmodule