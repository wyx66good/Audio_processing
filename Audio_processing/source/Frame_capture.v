/*************
Author:wyx
Times :2024.5.29
帧的截取组合 
**************/


module Frame_capture#(
    parameter DATA_WIDTH = 16
)(

    input                           clk,
    input                           rst_n,

    input [9:0]                     p,
    input                           flag_new_1,
    input                           flag_new_2,

    input wire                     wr_en  ,

    output reg [9:0]               rd_addr_1,
    input wire [DATA_WIDTH - 1:0]   rd_data_1,

    output reg [9:0]               rd_addr_2,
    input  wire [DATA_WIDTH - 1:0] rd_data_2,

    input  wire [10:0]             rd_capture_addr_1 ,
    output wire [15:0]             rd_capture_data_1 ,
    input  wire [10:0]             rd_capture_addr_2 ,
    output wire [15:0]             rd_capture_data_2 ,
    output wire                    flag_end
   );

wire flag_up_dowm;//,flag_up_dowm=1升调，0降调

reg  [15:0]wr_data;
reg  [10:0]wr_addr;



Frame_capture_ram u_Frame_capture_ram1 (
  .wr_data(wr_data),    // input [15:0]
  .wr_addr(wr_addr),    // input [10:0]
  .wr_en  (wr_en  ),        // input
  .wr_clk (clk ),      // input
  .wr_rst (!rst_n ),      // input
  .rd_addr(rd_capture_addr_1 ),    // input [10:0]
  .rd_data(rd_capture_data_1 ),    // output [15:0]
  .rd_clk (clk ),      // input
  .rd_rst (!rst_n )       // input
);

Frame_capture_ram u_Frame_capture_ram2 (
  .wr_data(wr_data),    // input [15:0]
  .wr_addr(wr_addr),    // input [10:0]
  .wr_en  (wr_en  ),        // input
  .wr_clk (clk ),      // input
  .wr_rst (!rst_n ),      // input
  .rd_addr(rd_capture_addr_2 ),    // input [10:0]
  .rd_data(rd_capture_data_2 ),    // output [15:0]
  .rd_clk (clk ),      // input
  .rd_rst (!rst_n )       // input
);

assign flag_up_dowm=(p>=128)?1:0;//1*2^7=128
assign flag_end =(wr_addr=='d1199)?1:0;


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||wr_addr=='d1199)begin
        wr_addr <= 'd0;
    end
    else if(wr_en)begin
        wr_addr <= wr_addr+'d1;
    end
    else
        wr_addr <= wr_addr;
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||wr_addr=='d1199)begin
        rd_addr_1 <= 'd0;
        rd_addr_2 <= 'd0;
    end
    else if(wr_addr<='d599 && flag_new_1)begin
        rd_addr_2 <= wr_addr;
    end
    else if(wr_addr<='d599 && flag_new_2)begin
        rd_addr_1 <= wr_addr;
    end
    else if(wr_addr>'d599 && flag_up_dowm && flag_new_1)begin
        rd_addr_1 <= wr_addr-'d600;
    end
    else if(wr_addr>'d599 && flag_up_dowm && flag_new_2)begin
        rd_addr_2 <= wr_addr-'d600;
    end
    else begin
        rd_addr_1 <= 'd0;
        rd_addr_2 <= 'd0;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||wr_addr=='d1199)begin
        wr_data <= 'd0;
    end
    else if(wr_addr<='d599 && flag_new_1)begin
        wr_data <= rd_data_2;
    end
    else if(wr_addr<='d599 && flag_new_2)begin
        wr_data <= rd_data_1;
    end
    else if(wr_addr>'d599 && flag_up_dowm && flag_new_1)begin
        wr_data <= rd_data_1;
    end
    else if(wr_addr>'d599 && flag_up_dowm && flag_new_2)begin
        wr_data <= rd_data_2;
    end
    else if(wr_addr>'d599 && !flag_up_dowm)begin
        wr_data <= 'd0;
    end
    else
        wr_data <= 'd0;
end




endmodule