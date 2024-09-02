/*************
Author:wyx
Times :2024.7.3
ÇóÖÐÖµ
**************/


module midian(
    input                           clk,
    input                           rst_n,

    input    wire                   start,
    output  reg                     finsh,

    input  wire [63:0]                a1    ,
    input  wire [63:0]                a2    ,
    input  wire [63:0]                a3    ,
    input  wire [63:0]                a4    ,
    input  wire [63:0]                a5    ,
    input  wire [63:0]                a6    ,
    input  wire [63:0]                a7    ,
    input  wire [63:0]                a8    ,
    input  wire [63:0]                a9    ,
    output wire [63:0]                mid

   );

wire [63:0]  max1;
wire [63:0]  mid1;
wire [63:0]  min1;

wire [63:0]  max2;
wire [63:0]  mid2;
wire [63:0]  min2;

wire [63:0]  max3;
wire [63:0]  mid3;
wire [63:0]  min3;


reg [63:0]  max_min;
reg [63:0]  mid_mid;
reg [63:0]  min_max;


reg [63:0]  mid_1;

reg finsh_1;
reg finsh_2;
reg finsh_3;

min_mid_max_3 min_mid_max_3_1
(
    .clk                    (clk        ),
    .rst_n                  (rst_n      ),
.start(start),
    .data1                  (a1         ), 
    .data2                  (a2         ), 
    .data3                  (a3         ),
    .min_data               (min1       ),
    .mid_data               (mid1       ),
    .max_data               (max1       )
);


min_mid_max_3 min_mid_max_3_2(
.clk                    (clk        ),
.rst_n                  (rst_n      ),
.start(start),
.data1    (a4),
.data2    (a5),
.data3    (a6),
.min_data (min2),
.mid_data (mid2),
.max_data (max2)
);

min_mid_max_3 min_mid_max_3_3(
    .clk                    (clk        ),
    .rst_n                  (rst_n      ),
.start(start),
.data1     (a7),
.data2     (a8),
.data3     (a9),
.min_data  (min3),
.mid_data  (mid3),
.max_data  (max3)
);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n||!finsh_1)
        max_min <= 64'd0;
    else if(max3 >= max1 && max2 >= max1&&finsh_1)
        max_min <= max1;
    else if(max3 >= max2 && max1 >= max2&&finsh_1)
        max_min <= max2;
    else if(max1 >= max3 && max2 >= max3&&finsh_1)
        max_min <= max3;
end
//min_mid_max_3 min_mid_max_3_max_min(
//    .clk                    (clk        ),
//    .rst_n                  (rst_n      ),
//.start(finsh_1),
//.data1     (max1),
//.data2     (max2),
//.data3     (max3),
//.min_data  (max_min),
//.mid_data  (),
//.max_data  ()
//);
always @(posedge clk or negedge rst_n) begin
    if(!rst_n||!finsh_1)
        mid_mid <= 64'd0;
    else if(((mid2 >= mid1 && mid1 >= mid3) || (mid3 >= mid1 && mid1 >= mid2))&&finsh_1)
        mid_mid <= mid1;
    else if(((mid1 >= mid2 && mid2 >= mid3) || (mid3 >= mid2 && mid2 >= mid1))&&finsh_1)
        mid_mid <= mid2;
    else if(((mid1 >= mid3 && mid3 >= mid2) || (mid1 >= mid3 && mid3 >= mid2))&&finsh_1)
        mid_mid <= mid3;
end
//min_mid_max_3 min_mid_max_3_mid_mid(
//    .clk                    (clk        ),
//    .rst_n                  (rst_n      ),
//.start(finsh_1),
//.data1     (mid1),
//.data2     (mid2),
//.data3     (mid3),
//.min_data  (),
//.mid_data  (mid_mid),
//.max_data  ()
//);
//
always @(posedge clk or negedge rst_n) begin
    if(!rst_n||!finsh_1)
        min_max <= 64'd0;
    else if((min1 >= min2 && min1 >= min3)&&finsh_1)
        min_max <= min1;
    else if((min2 >= min1 && min2 >= min3)&&finsh_1)
        min_max <= min2;
    else if((min3 >= min1 && min3 >= min2)&&finsh_1)
        min_max <= min3;
end
//min_mid_max_3 min_mid_max_3_min_max(
//    .clk                    (clk        ),
//    .rst_n                  (rst_n      ),
//.start(finsh_1),
//.data1     (min1),
//.data2     (min2),
//.data3     (min3),
//.min_data  (),
//.mid_data  (),
//.max_data  (min_max)
//);
//
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        mid_1 <= 64'd0;
    else if(((mid_mid >= max_min && max_min >= min_max) || (min_max >= max_min && max_min >= mid_mid))&&finsh_2)
        mid_1 <= max_min;
    else if(((max_min >= mid_mid && mid_mid >= min_max) || (min_max >= mid_mid && mid_mid >= max_min))&&finsh_2)
        mid_1 <= mid_mid;
    else if(((max_min >= min_max && min_max >= mid_mid) || (max_min >= min_max && min_max >= mid_mid))&&finsh_2)
        mid_1 <= min_max;
    else
        mid_1 <= mid_1;
end

//min_mid_max_3 min_mid_max_mid(
//    .clk                    (clk        ),
//    .rst_n                  (rst_n      ),
//.start(finsh_2),
//.data1     (max_min),
//.data2     (mid_mid),
//.data3     (min_max),
//.min_data  (),
//.mid_data  (mid),
//.max_data  ()
//);
assign mid=mid_1;

//always @(posedge clk or negedge rst_n) begin
//    if(!rst_n)
//        mid <= 64'd0;
//    else if(finsh_3)
//        mid <= mid_1;
//    else 
//        mid <= mid;
//end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        finsh <= 'd0;
        finsh_1 <= 'd0;
        finsh_2 <= 'd0;
        finsh_3 <= 'd0;
    end
    else begin
        finsh_1 <= start;
        finsh_2 <= finsh_1;
        finsh_3 <= finsh_2;
        finsh   <= finsh_3;
    end
end

endmodule