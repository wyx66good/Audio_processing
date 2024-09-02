// -----------------------------------------------------------------------------
// Author : 3056710696@qq.com
// File   : denosising.v
// Create : 2024-06-27 00:40:24
// Revise : 2024-06-27 01:14:36
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
module denosising(
input		wire			sys_clk,
input		wire			rst_n,
input		wire			es7243_init,
input		wire			es0_dsclk,
input		wire			rcv_done,
input 		wire	[15:0]	rx_data,
input		wire			es1_dsclk,
input		wire			send_done,
output		wire	[15:0]	FIR_out
	);





wire		clk_50M;
wire		clk_5M;
wire		wr_full;
wire		valid_flag;
wire  [15:0] rx_rd_data;
//wire  [15:0]   FIR_out/*synthesis PAP_MARK_DEBUG="1"*/;
wire  [11:0]   rd_water_level/*synthesis PAP_MARK_DEBUG="1"*/; //读水位


reg       rx_rd_en;


always @(posedge clk_50M)
begin
    if(~es7243_init)
        rx_rd_en <= 'd0;
    else if(wr_full)
        rx_rd_en <= 'd1;                  
    else if(rd_empty == 1'b1)         
        rx_rd_en <= 'd0;
    else
        rx_rd_en <= rx_rd_en;
end


PLL2 PLL_5M (
  .clkin1(sys_clk),        // input
  .pll_lock(pll_lock),    // output
  .clkout0(clk_50M),      // output
  .clkout1(clk_5M)       // output
);


//音频采集数据使用fifo缓存
asfifo_1024x16 rx_fifo (
  .wr_clk(es0_dsclk),                 // input 音频数据时钟
  .wr_rst(!es7243_init),              // input 
  .wr_en(rcv_done),                   // input
  .wr_data(rx_data),                  // input [15:0]
  .wr_full(wr_full),                  // output
  .wr_water_level(),                  // output [10:0]
  .almost_full(),                     // output
  .rd_clk(clk_5M),                    // input
  .rd_rst(~es7243_init),              // input
  .rd_en(rx_rd_en&&valid_flag),                   // input
  .rd_data(rx_rd_data),               // output [15:0]
  .rd_empty(rd_empty),                // output
  .rd_water_level(rd_water_level),                  // output [10:0]
  .almost_empty()                     // output
);

FIR inst_FIR(
	.clk        (clk_5M),
	.rst_n      (es7243_init),
	.FIR_in     (rx_rd_data),
	.FIR_out    (FIR_out),
	.valid_flag (valid_flag)
);



//音频发送数据使用fifo缓存
asfifo_1024x16 tx_fifo (
  .wr_clk(clk_5M),                   // input 音频数据时钟
  .wr_rst(!es7243_init),              // input 
  .wr_en(valid_flag),                 // input
  .wr_data(FIR_out),                  // input [15:0]
  .wr_full(),                         // output
  .wr_water_level(),                  // output [10:0]
  .almost_full(),                     // output
  .rd_clk(es1_dsclk),                 // input
  .rd_rst(~es7243_init),              // input
  .rd_en(send_done),                  // input
  .rd_data(tx_fir_data),              // output [15:0]
  .rd_empty(),                        // output
  .rd_water_level(),                  // output [10:0]
  .almost_empty()                     // output
);


endmodule