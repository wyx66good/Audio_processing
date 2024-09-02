
/*************
Author:wyx
Times :2024.8.6
MIN
**************/

module MIN4#(
    parameter DATA_WIDTH = 16
)(
    input     wire                      clk             ,
    input     wire                      rst_n           ,

    input     wire [DATA_WIDTH-1:0]  distance_DATA1       ,                                                
    input     wire [DATA_WIDTH-1:0]  distance_DATA_2      ,
    input     wire [DATA_WIDTH-1:0]  distance_DATA_3      ,
    input     wire [DATA_WIDTH-1:0]  distance_DATA_4      ,

    input     wire                    distance_EN_1        ,
    input     wire                    distance_EN_2        ,
    input     wire                    distance_EN_3        ,
    input     wire                    distance_EN_4        ,

    output    wire  [DATA_WIDTH-1:0]       MIN_1_1,
    output    wire  [4:0]                  MIN_1_1_i,
    output    wire                         MIN_1_1_en
   );


wire [DATA_WIDTH-1:0]  MIN_2_1;
wire [4:0]             MIN_2_1_i;
wire                   MIN_2_1_en;
                           
wire [DATA_WIDTH-1:0]  MIN_2_2;
wire [4:0]             MIN_2_2_i;
wire                   MIN_2_2_en;


MIN_TWO#(
   .DATA_WIDTH (DATA_WIDTH)
)MIN_TWO_2_1
(
.clk            (clk  ),
.rst_n          (rst_n),
.distance_DATA1 (distance_DATA1),                     
.distance_DATA_2(distance_DATA_2),     
.distance_EN    (distance_EN_1),     
.MIN_in1_i      ('d1),  
.MIN_in2_i      ('d2),
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
.distance_DATA1 (distance_DATA_3),                     
.distance_DATA_2(distance_DATA_4),     
.distance_EN    (distance_EN_3),     
.MIN_in1_i      ('d3),  
.MIN_in2_i      ('d4),
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