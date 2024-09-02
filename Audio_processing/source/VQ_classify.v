/*************
Author:wyx
Times :2024.8.4
VQ_LBG ·ÖÀà
**************/
module VQ_classify(

    input     wire              clk  ,
    input     wire              rst_n,

    input     wire              START,
    output    wire              FINSH,

    input     wire  [8:0]       Frams_Number,
    input     wire [12:0]       DCT_ADDR,
    input     wire  [2:0]       CNT_FOR,

    output    wire  [12:0]      MFCCS13_ADDR,
    input     wire [13:0]       MFCCS13_DATA,

    input     wire [13:0]       LBG_rd_data,
    output    wire [7:0]        LBG_rd_addr,

    output    wire [40:0]       D      ,
    output    wire              D_en   ,
    output    wire [23:0]       VQ_rd_data,
    input     wire [7:0]        VQ_rd_addr,
    output    wire  [8:0]       Frams_Number_1 ,
    output    wire  [8:0]       Frams_Number_2 ,
    output    wire  [8:0]       Frams_Number_3 ,
    output    wire  [8:0]       Frams_Number_4 ,
    output    wire  [8:0]       Frams_Number_5 ,
    output    wire  [8:0]       Frams_Number_6 ,
    output    wire  [8:0]       Frams_Number_7 ,
    output    wire  [8:0]       Frams_Number_8 ,
    output    wire  [8:0]       Frams_Number_9 ,
    output    wire  [8:0]       Frams_Number_10,
    output    wire  [8:0]       Frams_Number_11,
    output    wire  [8:0]       Frams_Number_12,
    output    wire  [8:0]       Frams_Number_13,
    output    wire  [8:0]       Frams_Number_14,
    output    wire  [8:0]       Frams_Number_15,
    output    wire  [8:0]       Frams_Number_16

   );
wire [7:0]   MFCCS13_13_ADDR;
wire         MFCCS13_en;
wire         VQ_finsh;

wire [31:0]       MIN    ;
wire [4:0]        MIN_i  ;
wire              MIN_EN ;


VQ VQ(
.clk              (clk          ),
.rst_n            (rst_n        ),
.VQ_start         (START        ),
.VQ_finsh         (VQ_finsh     ),
.DCT_ADDR         (DCT_ADDR     ),
.CNT_FOR          (CNT_FOR      ),
.Frams_Number     (Frams_Number ),
.MFCCS13_13_ADDR_1(MFCCS13_13_ADDR),
.MFCCS13_en       (MFCCS13_en     ),
.MFCCS13_ADDR     (MFCCS13_ADDR ),
.MFCCS13_DATA     (MFCCS13_DATA ),
.LBG_rd_data_1    (LBG_rd_data  ),
.LBG_rd_addr_1    (LBG_rd_addr  ),
.MIN              (MIN          ), 
.MIN_i            (MIN_i        ),
.MIN_EN           (MIN_EN       ),
.D                (D            ),
.D_en             (D_en         )
   );

VQ_classify_buffer VQ_classify_buffer
(
.clk             (clk            ),    
.rst_n           (rst_n          ),                 
.START           (START          ),
.FINSH           (FINSH          ),    
.VQ_finsh         (VQ_finsh     ),             
.MFCCS13_13_ADDR (MFCCS13_13_ADDR),
.MFCCS13_DATA    (MFCCS13_DATA   ),
.MFCCS13_en      (MFCCS13_en     ),
.MIN_i           (MIN_i          ),
.MIN_EN          (MIN_EN         ),
.D               (D              ),
.D_en            (D_en           ),
.VQ_rd_data      (VQ_rd_data     ),
.VQ_rd_addr      (VQ_rd_addr     ),
.Frams_Number_1  (Frams_Number_1 ),
.Frams_Number_2  (Frams_Number_2 ),
.Frams_Number_3  (Frams_Number_3 ),
.Frams_Number_4  (Frams_Number_4 ),
.Frams_Number_5  (Frams_Number_5 ),
.Frams_Number_6  (Frams_Number_6 ),
.Frams_Number_7  (Frams_Number_7 ),
.Frams_Number_8  (Frams_Number_8 ),
.Frams_Number_9  (Frams_Number_9 ),
.Frams_Number_10 (Frams_Number_10),
.Frams_Number_11 (Frams_Number_11),
.Frams_Number_12 (Frams_Number_12),
.Frams_Number_13 (Frams_Number_13),
.Frams_Number_14 (Frams_Number_14),
.Frams_Number_15 (Frams_Number_15),
.Frams_Number_16 (Frams_Number_16)

);






endmodule