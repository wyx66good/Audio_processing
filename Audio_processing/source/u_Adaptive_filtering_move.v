/*************
Author:wyx
Times :2024.6.15
u_Adaptive_filtering_move
**************/



module Adaptive_filtering_move#(
    parameter DATA_WIDTH = 16
)
(
    input                           clk,
    input                           rst_n,

    input  wire [DATA_WIDTH - 1:0]  wr_data,
    output reg  [9:0]              wr_addr_1,
    input  wire                     wr_en,

    input  wire  [9:0]              rd_addr,
    output wire  [DATA_WIDTH - 1:0] rd_data,

    output wire                     finsh

   );





reg  [9:0]              wr_addr;
reg wr_en_1;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||finsh)begin
        wr_addr_1 <= 'd0;
    end
    else if(wr_en)begin
        wr_addr_1 <= wr_addr_1+'d1;
    end
    else begin
        wr_addr_1 <= wr_addr_1;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||finsh)begin
        wr_addr <= 'd0;
        wr_en_1 <= 'd0;
    end
    else begin
        wr_addr <= wr_addr_1;
        wr_en_1 <= wr_en;
    end
end
assign finsh=(wr_addr_1=='d1023)?'d1:'d0;

Echo_cancellation_LMS_ram u_Echo_cancellation_LMS_ram2 (
  .wr_data  (wr_data),    // input [15:0]
  .wr_addr  (wr_addr),    // input [9:0]
  .wr_en    (wr_en_1),        // input
  .wr_clk   (clk),      // input
  .wr_rst   (!rst_n),      // input
  .rd_addr  (rd_addr),    // input [9:0]
  .rd_data  (rd_data),    // output [15:0]
  .rd_clk   (clk),      // input
  .rd_rst   (!rst_n)       // input
);




endmodule