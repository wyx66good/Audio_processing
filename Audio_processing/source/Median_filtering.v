

/*************
Author:wyx
Times :2024.7.3
ÖĞÖµÂË²¨ 15*15
**************/


module Median_filtering(
    input                           clk,
    input                           rst_n,

    input                           wr_en ,
    input   [63:0]                  wr_data,

    output wire         [3:0]       fsm_n,


    output wire         [63:0]      rd_data_1,
    input  wire         [9:0]       rd_addr_1,
    output wire         [63:0]      rd_data_2,
    input  wire         [9:0]       rd_addr_2,
    output wire         [63:0]      rd_data_3,
    input  wire         [9:0]       rd_addr_3,
    output wire         [63:0]      rd_data_4,
    input  wire         [9:0]       rd_addr_4,
    output wire         [63:0]      rd_data_5,
    input  wire         [9:0]       rd_addr_5,
    output wire         [63:0]      rd_data_6,
    input  wire         [9:0]       rd_addr_6,
    output wire         [63:0]      rd_data_7,
    input  wire         [9:0]       rd_addr_7,
    output wire         [63:0]      rd_data_8,
    input  wire         [9:0]       rd_addr_8,
    output wire         [63:0]      rd_data_9,
    input  wire         [9:0]       rd_addr_9

   );




wire [63:0] wr_data_1;
wire [9:0]  wr_addr_1;
wire          wr_en_1;

wire [63:0] wr_data_2;
wire [9:0]  wr_addr_2;
wire          wr_en_2;

wire [63:0] wr_data_3;
wire [9:0]  wr_addr_3;
wire          wr_en_3;

wire [63:0] wr_data_4;
wire [9:0]  wr_addr_4;
wire          wr_en_4;

wire [63:0] wr_data_5;
wire [9:0]  wr_addr_5;
wire          wr_en_5;

wire [63:0] wr_data_6;
wire [9:0]  wr_addr_6;
wire          wr_en_6;

wire [63:0] wr_data_7;
wire [9:0]  wr_addr_7;
wire          wr_en_7;

wire [63:0] wr_data_8;
wire [9:0]  wr_addr_8;
wire          wr_en_8;

wire [63:0] wr_data_9;
wire [9:0]  wr_addr_9;
wire          wr_en_9;


reg          wr_en1;
wire          wr_en2;
reg [9:0]    wr_addr;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        wr_en1 <= 'd0;
    end
    else begin
        wr_en1 <= wr_en;
    end
end

assign wr_en2=(wr_en1||wr_en);


reg     [3:0]   fsm_c;
assign fsm_n=fsm_c;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        fsm_c <= 'd0;
    end
    else if (fsm_c == 'd10)begin
        fsm_c <= 'd1;
    end
    else if(!wr_en1&&wr_en)begin
        fsm_c <= fsm_c+'d1;
    end
end


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        wr_addr <= 'd0;
    else if(wr_en_1|| wr_en_2 ||wr_en_3||wr_en_4||wr_en_5||wr_en_6||wr_en_7||wr_en_8||wr_en_9)
        wr_addr <= wr_addr+'d1;
    else
        wr_addr <= 'd0;
end



assign  wr_data_1 = wr_data;
assign  wr_data_2 = wr_data;
assign  wr_data_3 = wr_data;
assign  wr_data_4 = wr_data;
assign  wr_data_5 = wr_data;
assign  wr_data_6 = wr_data;
assign  wr_data_7 = wr_data;
assign  wr_data_8 = wr_data;
assign  wr_data_9 = wr_data;

assign  wr_en_1 = (fsm_c == 'd1)?wr_en1:'d0;
assign  wr_en_2 = (fsm_c == 'd2)?wr_en1:'d0;
assign  wr_en_3 = (fsm_c == 'd3)?wr_en1:'d0;
assign  wr_en_4 = (fsm_c == 'd4)?wr_en1:'d0;
assign  wr_en_5 = (fsm_c == 'd5)?wr_en1:'d0;
assign  wr_en_6 = (fsm_c == 'd6)?wr_en1:'d0;
assign  wr_en_7 = (fsm_c == 'd7)?wr_en1:'d0;
assign  wr_en_8 = (fsm_c == 'd8)?wr_en1:'d0;
assign  wr_en_9 = (fsm_c == 'd9)?wr_en1:'d0;



assign  wr_addr_1 = wr_addr;
assign  wr_addr_2 = wr_addr;
assign  wr_addr_3 = wr_addr;
assign  wr_addr_4 = wr_addr;
assign  wr_addr_5 = wr_addr;
assign  wr_addr_6 = wr_addr;
assign  wr_addr_7 = wr_addr;
assign  wr_addr_8 = wr_addr;
assign  wr_addr_9 = wr_addr;


Median_ram Median_1 (
  .wr_data(wr_data_1),    // input [42:0]
  .wr_addr(wr_addr_1),    // input [9:0]
  .rd_addr(rd_addr_1),    // input [9:0]
  .wr_clk(clk),      // input
  .rd_clk(clk),      // input
  .wr_en(wr_en_1),        // input
  .wr_rst(!rst_n),            // input
  .rd_rst(!rst_n),            // input
  .rd_data(rd_data_1)     // output [42:0]
);


Median_ram Median_2 (
  .wr_data(wr_data_2),    // input [42:0]
  .wr_addr(wr_addr_2),    // input [9:0]
  .rd_addr(rd_addr_2),    // input [9:0]
  .wr_clk(clk),      // input
  .rd_clk(clk),      // input
  .wr_en(wr_en_2),        // input
  .wr_rst(!rst_n),            // input
  .rd_rst(!rst_n),            // input
  .rd_data(rd_data_2)     // output [42:0]
);


Median_ram Median_3 (
  .wr_data(wr_data_3),    // input [42:0]
  .wr_addr(wr_addr_3),    // input [9:0]
  .rd_addr(rd_addr_3),    // input [9:0]
  .wr_clk(clk),      // input
  .rd_clk(clk),      // input
  .wr_en(wr_en_3),        // input
  .wr_rst(!rst_n),            // input
  .rd_rst(!rst_n),            // input
  .rd_data(rd_data_3)     // output [42:0]
);

Median_ram Median_4 (
  .wr_data(wr_data_4),    // input [42:0]
  .wr_addr(wr_addr_4),    // input [9:0]
  .rd_addr(rd_addr_4),    // input [9:0]
  .wr_clk(clk),      // input
  .rd_clk(clk),      // input
  .wr_en(wr_en_4),        // input
  .wr_rst(!rst_n),            // input
  .rd_rst(!rst_n),            // input
  .rd_data(rd_data_4)     // output [42:0]
);

Median_ram Median_5 (
  .wr_data(wr_data_5),    // input [42:0]
  .wr_addr(wr_addr_5),    // input [9:0]
  .rd_addr(rd_addr_5),    // input [9:0]
  .wr_clk(clk),      // input
  .rd_clk(clk),      // input
  .wr_en(wr_en_5),        // input
  .wr_rst(!rst_n),            // input
  .rd_rst(!rst_n),            // input
  .rd_data(rd_data_5)     // output [42:0]
);

Median_ram Median_6 (
  .wr_data(wr_data_6),    // input [42:0]
  .wr_addr(wr_addr_6),    // input [9:0]
  .rd_addr(rd_addr_6),    // input [9:0]
  .wr_clk(clk),      // input
  .rd_clk(clk),      // input
  .wr_en(wr_en_6),        // input
  .wr_rst(!rst_n),            // input
  .rd_rst(!rst_n),            // input
  .rd_data(rd_data_6)     // output [42:0]
);
Median_ram Median_7 (
  .wr_data(wr_data_7),    // input [42:0]
  .wr_addr(wr_addr_7),    // input [9:0]
  .rd_addr(rd_addr_7),    // input [9:0]
  .wr_clk(clk),      // input
  .rd_clk(clk),      // input
  .wr_en(wr_en_7),        // input
  .wr_rst(!rst_n),            // input
  .rd_rst(!rst_n),            // input
  .rd_data(rd_data_7)     // output [42:0]
);
Median_ram Median_8 (
  .wr_data(wr_data_8),    // input [42:0]
  .wr_addr(wr_addr_8),    // input [9:0]
  .rd_addr(rd_addr_8),    // input [9:0]
  .wr_clk(clk),      // input
  .rd_clk(clk),      // input
  .wr_en(wr_en_8),        // input
  .wr_rst(!rst_n),            // input
  .rd_rst(!rst_n),            // input
  .rd_data(rd_data_8)     // output [42:0]
);
Median_ram Median_9 (
  .wr_data(wr_data_9),    // input [42:0]
  .wr_addr(wr_addr_9),    // input [9:0]
  .rd_addr(rd_addr_9),    // input [9:0]
  .wr_clk(clk),      // input
  .rd_clk(clk),      // input
  .wr_en(wr_en_9),        // input
  .wr_rst(!rst_n),            // input
  .rd_rst(!rst_n),            // input
  .rd_data(rd_data_9)     // output [42:0]
);



endmodule