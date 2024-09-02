/*************
Author:wyx
Times :2024.5.29
∑÷÷°ª∫¥Ê 
**************/

module Framing#(
    parameter DATA_WIDTH = 16
)
(
    input                           clk,
    input                           rst_n,

    input wire [9:0]                wr_addr_max , 
    output wire                     fifo_en,
    input wire                      wr_en , 
    input wire  [DATA_WIDTH - 1:0]  wr_data,
    output wire                     addr_end,

    input wire [9:0]               rd_addr,
    output wire [DATA_WIDTH - 1:0]  rd_data,
    input wire                     rd_clk ,
    input wire                     rd_rst  
   );



reg  [9:0] wr_addr;


Voice_change_ram u_Voice_change_ram (
  .wr_data(wr_data),    // input [15:0]
  .wr_addr(wr_addr),    // input [9:0]
  .wr_en  (wr_en  ),        // input
  .wr_clk (clk    ),      // input
  .wr_rst (!rst_n ),      // input
  .rd_addr(rd_addr),    // input [9:0]
  .rd_data(rd_data),    // output [15:0]
  .rd_clk (rd_clk ),      // input
  .rd_rst (rd_rst )       // input
);

assign fifo_en=wr_en;
assign addr_end=(wr_addr==wr_addr_max)?1:0;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||wr_addr==wr_addr_max)begin
        wr_addr <= 'd0;
    end
    else if(wr_en)begin
        wr_addr <= wr_addr+'d1;
    end
    else
        wr_addr <= 'd0;
end



endmodule