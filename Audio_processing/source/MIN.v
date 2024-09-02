
/*************
Author:wyx
Times :2024.8.6
MIN
**************/

module MIN#(
    parameter DATA_WIDTH = 16
)(
    input     wire              clk             ,
    input     wire              rst_n           ,

    input     wire  [2:0]       CNT_FOR         ,

    input     wire [DATA_WIDTH-1:0]  distance_DATA1       ,
    input     wire         distance_EN_1        ,
                                                
    input     wire [DATA_WIDTH-1:0]  distance_DATA_2      ,
    input     wire         distance_EN_2        ,
                                                
    input     wire [DATA_WIDTH-1:0]  distance_DATA_3      ,
    input     wire         distance_EN_3        ,
                                                
    input     wire [DATA_WIDTH-1:0]  distance_DATA_4      ,
    input     wire         distance_EN_4        ,
                                                
    input     wire [DATA_WIDTH-1:0]  distance_DATA_5      ,
    input     wire         distance_EN_5        ,
   
    input     wire [DATA_WIDTH-1:0]  distance_DATA_6      ,
    input     wire         distance_EN_6        ,
    
    input     wire [DATA_WIDTH-1:0]  distance_DATA_7      ,
    input     wire         distance_EN_7        ,
    
    input     wire [DATA_WIDTH-1:0]  distance_DATA_8      ,
    input     wire         distance_EN_8        ,
    
    input     wire [DATA_WIDTH-1:0]  distance_DATA_9      ,
    input     wire         distance_EN_9        ,
   
    input     wire [DATA_WIDTH-1:0]  distance_DATA_10     ,
    input     wire         distance_EN_10       ,
      
    input     wire [DATA_WIDTH-1:0]  distance_DATA_11     ,
    input     wire         distance_EN_11       ,
  
    input     wire [DATA_WIDTH-1:0]  distance_DATA_12     ,
    input     wire         distance_EN_12       ,
    
    input     wire [DATA_WIDTH-1:0]  distance_DATA_13     ,
    input     wire         distance_EN_13       ,
   
    input     wire [DATA_WIDTH-1:0]  distance_DATA_14     ,
    input     wire         distance_EN_14       ,
    
    input     wire [DATA_WIDTH-1:0]  distance_DATA_15     ,
    input     wire         distance_EN_15       ,
  
    input     wire [DATA_WIDTH-1:0]  distance_DATA_16     ,
    input     wire         distance_EN_16   ,

    output    wire  [DATA_WIDTH-1:0]       MIN_1_1,
    output    wire  [4:0]                  MIN_1_1_i,
    output    wire                         MIN_1_1_en
   );


wire [DATA_WIDTH-1:0]  MIN_8_1;
wire [4:0]             MIN_8_1_i;
wire                   MIN_8_1_en;

wire [DATA_WIDTH-1:0]  MIN_8_2;
wire [4:0]             MIN_8_2_i;
wire                   MIN_8_2_en;

wire [DATA_WIDTH-1:0]  MIN_8_3;
wire [4:0]             MIN_8_3_i;
wire                   MIN_8_3_en;

wire [DATA_WIDTH-1:0]  MIN_8_4;
wire [4:0]             MIN_8_4_i;
wire                   MIN_8_4_en;

wire [DATA_WIDTH-1:0]  MIN_8_5;
wire [4:0]             MIN_8_5_i;
wire                   MIN_8_5_en;

wire [DATA_WIDTH-1:0]  MIN_8_6;
wire [4:0]             MIN_8_6_i;
wire                   MIN_8_6_en;

wire [DATA_WIDTH-1:0]  MIN_8_7;
wire [4:0]             MIN_8_7_i;
wire                   MIN_8_7_en;

wire [DATA_WIDTH-1:0]  MIN_8_8;
wire [4:0]             MIN_8_8_i;
wire                   MIN_8_8_en;
                           
wire [DATA_WIDTH-1:0]  MIN_4_1;
wire [4:0]             MIN_4_1_i;
wire                   MIN_4_1_en;
                           
wire [DATA_WIDTH-1:0]  MIN_4_2;
wire [4:0]             MIN_4_2_i;
wire                   MIN_4_2_en;
                           
wire [DATA_WIDTH-1:0]  MIN_4_3;
wire [4:0]             MIN_4_3_i;
wire                   MIN_4_3_en;
                           
wire [DATA_WIDTH-1:0]  MIN_4_4;
wire [4:0]             MIN_4_4_i;
wire                   MIN_4_4_en;

wire [DATA_WIDTH-1:0]  MIN_2_1;
wire [4:0]             MIN_2_1_i;
wire                   MIN_2_1_en;
                           
wire [DATA_WIDTH-1:0]  MIN_2_2;
wire [4:0]             MIN_2_2_i;
wire                   MIN_2_2_en;

MIN_TWO#(
   .DATA_WIDTH (DATA_WIDTH)
)MIN_TWO_8_1
(
.clk            (clk  ),
.rst_n          (rst_n),
.distance_DATA1 (distance_DATA1),                     
.distance_DATA_2(distance_DATA_2),     
.distance_EN    (distance_EN_1),     
.MIN_in1_i      (5'd1),  
.MIN_in2_i      (5'd2),
.MIN            (MIN_8_1),
.MIN_i          (MIN_8_1_i),
.MIN_en         (MIN_8_1_en)
   );

MIN_TWO#(
   .DATA_WIDTH (DATA_WIDTH)
)MIN_TWO_8_2
(
.clk            (clk  ),
.rst_n          (rst_n),
.distance_DATA1 (distance_DATA_3),                     
.distance_DATA_2(distance_DATA_4),     
.distance_EN    (distance_EN_3),     
.MIN_in1_i      (5'd3),  
.MIN_in2_i      (5'd4),
.MIN            (MIN_8_2),
.MIN_i          (MIN_8_2_i),
.MIN_en         (MIN_8_2_en)
   );

MIN_TWO#(
   .DATA_WIDTH (DATA_WIDTH)
)MIN_TWO_8_3
(
.clk            (clk  ),
.rst_n          (rst_n),
.distance_DATA1 (distance_DATA_5),                     
.distance_DATA_2(distance_DATA_6),     
.distance_EN    (distance_EN_5),     
.MIN_in1_i      (5'd5),  
.MIN_in2_i      (5'd6),
.MIN            (MIN_8_3),
.MIN_i          (MIN_8_3_i),
.MIN_en         (MIN_8_3_en)
   );


MIN_TWO#(
   .DATA_WIDTH (DATA_WIDTH)
)MIN_TWO_8_4
(
.clk            (clk  ),
.rst_n          (rst_n),
.distance_DATA1 (distance_DATA_7),                     
.distance_DATA_2(distance_DATA_8),     
.distance_EN    (distance_EN_7),     
.MIN_in1_i      (5'd7),  
.MIN_in2_i      (5'd8),
.MIN            (MIN_8_4),
.MIN_i          (MIN_8_4_i),
.MIN_en         (MIN_8_4_en)
   );


MIN_TWO#(
   .DATA_WIDTH (DATA_WIDTH)
)MIN_TWO_8_5
(
.clk            (clk  ),
.rst_n          (rst_n),
.distance_DATA1 (distance_DATA_9),                     
.distance_DATA_2(distance_DATA_10),     
.distance_EN    (distance_EN_9),     
.MIN_in1_i      (5'd9),  
.MIN_in2_i      (5'd10),
.MIN            (MIN_8_5),
.MIN_i          (MIN_8_5_i),
.MIN_en         (MIN_8_5_en)
   );

MIN_TWO#(
   .DATA_WIDTH (DATA_WIDTH)
)MIN_TWO_8_6
(
.clk            (clk  ),
.rst_n          (rst_n),
.distance_DATA1 (distance_DATA_11),                     
.distance_DATA_2(distance_DATA_12),     
.distance_EN    (distance_EN_11),     
.MIN_in1_i      (5'd11),  
.MIN_in2_i      (5'd12),
.MIN            (MIN_8_6),
.MIN_i          (MIN_8_6_i),
.MIN_en         (MIN_8_6_en)
   );
MIN_TWO#(
   .DATA_WIDTH (DATA_WIDTH)
)MIN_TWO_8_7
(
.clk            (clk  ),
.rst_n          (rst_n),
.distance_DATA1 (distance_DATA_13),                     
.distance_DATA_2(distance_DATA_14),     
.distance_EN    (distance_EN_13),     
.MIN_in1_i      (5'd13),  
.MIN_in2_i      (5'd14),
.MIN            (MIN_8_7),
.MIN_i          (MIN_8_7_i),
.MIN_en         (MIN_8_7_en)
   );

MIN_TWO#(
   .DATA_WIDTH (DATA_WIDTH)
)MIN_TWO_8_8
(
.clk            (clk  ),
.rst_n          (rst_n),
.distance_DATA1 (distance_DATA_15),                     
.distance_DATA_2(distance_DATA_16),     
.distance_EN    (distance_EN_12),     
.MIN_in1_i      (5'd15),  
.MIN_in2_i      (5'd16),
.MIN            (MIN_8_8),
.MIN_i          (MIN_8_8_i),
.MIN_en         (MIN_8_8_en)
   );
////////4




MIN_TWO#(
   .DATA_WIDTH (DATA_WIDTH)
)MIN_TWO_4_1
(
.clk            (clk  ),
.rst_n          (rst_n),
.distance_DATA1 (MIN_8_1),                     
.distance_DATA_2(MIN_8_2),     
.distance_EN    (MIN_8_1_en),     
.MIN_in1_i      (MIN_8_1_i),  
.MIN_in2_i      (MIN_8_2_i),
.MIN            (MIN_4_1),
.MIN_i          (MIN_4_1_i),
.MIN_en         (MIN_4_1_en)
   );

MIN_TWO#(
   .DATA_WIDTH (DATA_WIDTH)
)MIN_TWO_4_2
(
.clk            (clk  ),
.rst_n          (rst_n),
.distance_DATA1 (MIN_8_3),                     
.distance_DATA_2(MIN_8_4),     
.distance_EN    (MIN_8_3_en),     
.MIN_in1_i      (MIN_8_3_i),  
.MIN_in2_i      (MIN_8_4_i),
.MIN            (MIN_4_2),
.MIN_i          (MIN_4_2_i),
.MIN_en         (MIN_4_2_en)
   );
MIN_TWO#(
   .DATA_WIDTH (DATA_WIDTH)
)MIN_TWO_4_3
(
.clk            (clk  ),
.rst_n          (rst_n),
.distance_DATA1 (MIN_8_5),                     
.distance_DATA_2(MIN_8_6),     
.distance_EN    (MIN_8_5_en),     
.MIN_in1_i      (MIN_8_5_i),  
.MIN_in2_i      (MIN_8_6_i),
.MIN            (MIN_4_3),
.MIN_i          (MIN_4_3_i),
.MIN_en         (MIN_4_3_en)
   );

MIN_TWO#(
   .DATA_WIDTH (DATA_WIDTH)
)MIN_TWO_4_4
(
.clk            (clk  ),
.rst_n          (rst_n),
.distance_DATA1 (MIN_8_7),                     
.distance_DATA_2(MIN_8_8),     
.distance_EN    (MIN_8_7_en),     
.MIN_in1_i      (MIN_8_7_i),  
.MIN_in2_i      (MIN_8_8_i),
.MIN            (MIN_4_4),
.MIN_i          (MIN_4_4_i),
.MIN_en         (MIN_4_4_en)
   );


MIN_TWO#(
   .DATA_WIDTH (DATA_WIDTH)
)MIN_TWO_2_1
(
.clk            (clk  ),
.rst_n          (rst_n),
.distance_DATA1 (MIN_4_1),                     
.distance_DATA_2(MIN_4_2),     
.distance_EN    (MIN_4_1_en),     
.MIN_in1_i      (MIN_4_1_i),  
.MIN_in2_i      (MIN_4_2_i),
.MIN            (MIN_2_1),
.MIN_i          (MIN_2_1_i),
.MIN_en         (MIN_2_1_en)
   );

MIN_TWO#(
   .DATA_WIDTH (DATA_WIDTH)
)MIN_TWO_2_2
(
.clk            (clk  ),
.rst_n          (rst_n),
.distance_DATA1 (MIN_4_3),                     
.distance_DATA_2(MIN_4_4),     
.distance_EN    (MIN_4_3_en),     
.MIN_in1_i      (MIN_4_3_i),  
.MIN_in2_i      (MIN_4_4_i),
.MIN            (MIN_2_2),
.MIN_i          (MIN_2_2_i),
.MIN_en         (MIN_2_2_en)
   );


MIN_TWO#(
   .DATA_WIDTH (DATA_WIDTH)
)MIN_TWO_1_1
(
.clk            (clk  ),
.rst_n          (rst_n),
.distance_DATA1 (MIN_2_1),                     
.distance_DATA_2(MIN_2_2),     
.distance_EN    (MIN_2_1_en),     
.MIN_in1_i      (MIN_2_1_i),  
.MIN_in2_i      (MIN_2_2_i),
.MIN            (MIN_1_1),
.MIN_i          (MIN_1_1_i),
.MIN_en         (MIN_1_1_en)
   );

endmodule