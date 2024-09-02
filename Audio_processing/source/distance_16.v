
/*************
Author:wyx
Times :2024.8.11
欧式距离
**************/


module distance_16(
    input     wire              clk  ,
    input     wire              rst_n,

    input    wire               distance_start,//开始识别
    output   wire               distance_finsh,//结束识别

    output   wire     [4:0]     distance_CNT,
    input    wire [13:0]        MFCCS13,

    input    wire [13:0]        vblg1 ,  
    input    wire [13:0]        vblg2 ,  
    input    wire [13:0]        vblg3 ,  
    input    wire [13:0]        vblg4 ,  
    input    wire [13:0]        vblg5 ,  
    input    wire [13:0]        vblg6 ,  
    input    wire [13:0]        vblg7 ,  
    input    wire [13:0]        vblg8 ,  
    input    wire [13:0]        vblg9 ,  
    input    wire [13:0]        vblg10,  
    input    wire [13:0]        vblg11,  
    input    wire [13:0]        vblg12,  
    input    wire [13:0]        vblg13,  
    input    wire [13:0]        vblg14,  
    input    wire [13:0]        vblg15,  
    input    wire [13:0]        vblg16,

    output   wire [31:0]  distance_DATA_1 ,
    output   wire [31:0]  distance_DATA_2 ,
    output   wire [31:0]  distance_DATA_3 ,
    output   wire [31:0]  distance_DATA_4 ,
    output   wire [31:0]  distance_DATA_5 ,
    output   wire [31:0]  distance_DATA_6 ,
    output   wire [31:0]  distance_DATA_7 ,
    output   wire [31:0]  distance_DATA_8 ,
    output   wire [31:0]  distance_DATA_9 ,
    output   wire [31:0]  distance_DATA_10,
    output   wire [31:0]  distance_DATA_11,
    output   wire [31:0]  distance_DATA_12,
    output   wire [31:0]  distance_DATA_13,
    output   wire [31:0]  distance_DATA_14,
    output   wire [31:0]  distance_DATA_15,
    output   wire [31:0]  distance_DATA_16,

    output   wire           distance_EN_1     ,
    output   wire           distance_EN_2     ,
    output   wire           distance_EN_3     ,
    output   wire           distance_EN_4     ,
    output   wire           distance_EN_5     ,
    output   wire           distance_EN_6     ,
    output   wire           distance_EN_7     ,
    output   wire           distance_EN_8     ,
    output   wire           distance_EN_9     ,
    output   wire           distance_EN_10    ,
    output   wire           distance_EN_11    ,
    output   wire           distance_EN_12    ,
    output   wire           distance_EN_13    ,
    output   wire           distance_EN_14    ,
    output   wire           distance_EN_15    ,
    output   wire           distance_EN_16    
   );



distance distance1(
.clk          (clk),
.rst_n        (rst_n),
.START        (distance_start),
.FINSH        (distance_finsh),
.CNT          (distance_CNT),
.DATA1        (vblg1),
.DATA2        (MFCCS13),
.distance_DATA(distance_DATA_1),
.distance_EN  (distance_EN_1  )

   );


distance distance2(
.clk          (clk),
.rst_n        (rst_n),
.START        (distance_start),
.FINSH        (),
.DATA1        (vblg2),
.DATA2        (MFCCS13),
.distance_DATA(distance_DATA_2),
.distance_EN  (distance_EN_2  )

   );

distance distance3(
.clk          (clk),
.rst_n        (rst_n),
.START        (distance_start),
.FINSH        (),
.DATA1        (vblg3),
.DATA2        (MFCCS13),
.distance_DATA(distance_DATA_3),
.distance_EN  (distance_EN_3  )

   );

distance distance4(
.clk          (clk),
.rst_n        (rst_n),
.START        (distance_start),
.FINSH        (),
.DATA1        (vblg4),
.DATA2        (MFCCS13),
.distance_DATA(distance_DATA_4),
.distance_EN  (distance_EN_4  )

   );

distance distance5(
.clk          (clk),
.rst_n        (rst_n),
.START        (distance_start),
.FINSH        (),
.DATA1        (vblg5),
.DATA2        (MFCCS13),
.distance_DATA(distance_DATA_5),
.distance_EN  (distance_EN_5  )

   );

distance distance6(
.clk          (clk),
.rst_n        (rst_n),
.START        (distance_start),
.FINSH        (),
.DATA1        (vblg6),
.DATA2        (MFCCS13),
.distance_DATA(distance_DATA_6),
.distance_EN  (distance_EN_6  )

   );

distance distance7(
.clk          (clk),
.rst_n        (rst_n),
.START        (distance_start),
.FINSH        (),
.DATA1        (vblg7),
.DATA2        (MFCCS13),
.distance_DATA(distance_DATA_7),
.distance_EN  (distance_EN_7  )

   );

distance distance8(
.clk          (clk),
.rst_n        (rst_n),
.START        (distance_start),
.FINSH        (),
.DATA1        (vblg8),
.DATA2        (MFCCS13),
.distance_DATA(distance_DATA_8),
.distance_EN  (distance_EN_8  )

   );

distance distance9(
.clk          (clk),
.rst_n        (rst_n),
.START        (distance_start),
.FINSH        (),
.DATA1        (vblg9),
.DATA2        (MFCCS13),
.distance_DATA(distance_DATA_9),
.distance_EN  (distance_EN_9  )

   );

distance distance10(
.clk          (clk),
.rst_n        (rst_n),
.START        (distance_start),
.FINSH        (),
.DATA1        (vblg10),
.DATA2        (MFCCS13),
.distance_DATA(distance_DATA_10),
.distance_EN  (distance_EN_10  )

   );

distance distance11(
.clk          (clk),
.rst_n        (rst_n),
.START        (distance_start),
.FINSH        (),
.DATA1        (vblg11),
.DATA2        (MFCCS13),
.distance_DATA(distance_DATA_11),
.distance_EN  (distance_EN_11  )

   );

distance distance12(
.clk          (clk),
.rst_n        (rst_n),
.START        (distance_start),
.FINSH        (),
.DATA1        (vblg12),
.DATA2        (MFCCS13),
.distance_DATA(distance_DATA_12),
.distance_EN  (distance_EN_12  )

   );

distance distance13(
.clk          (clk),
.rst_n        (rst_n),
.START        (distance_start),
.FINSH        (),
.DATA1        (vblg13),
.DATA2        (MFCCS13),
.distance_DATA(distance_DATA_13),
.distance_EN  (distance_EN_13  )

   );

distance distance14(
.clk          (clk),
.rst_n        (rst_n),
.START        (distance_start),
.FINSH        (),
.DATA1        (vblg14),
.DATA2        (MFCCS13),
.distance_DATA(distance_DATA_14),
.distance_EN  (distance_EN_14  )

   );

distance distance15(
.clk          (clk),
.rst_n        (rst_n),
.START        (distance_start),
.FINSH        (),
.DATA1        (vblg15),
.DATA2        (MFCCS13),
.distance_DATA(distance_DATA_15),
.distance_EN  (distance_EN_15  )

   );

distance distance16(
.clk          (clk),
.rst_n        (rst_n),
.START        (distance_start),
.FINSH        (),
.DATA1        (vblg16),
.DATA2        (MFCCS13),
.distance_DATA(distance_DATA_16),
.distance_EN  (distance_EN_16  )

   );




endmodule