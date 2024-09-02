//Author:wyx
//Times :2024.5.24


module Voice_change#(
    parameter DATA_WIDTH = 8
)
(
    input                           clk,
    input                           rst_n,

    input wire                      sck   ,
    input wire                      voide_rst_n,
    input wire  [DATA_WIDTH - 1:0]  data     ,
    input wire                      r_vld    ,
    input wire                      l_vld



   );

wire [DATA_WIDTH - 1:0]  data_out;
pre_add
#(
    .a          (0.98      ),
    .DATA_WIDTH (DATA_WIDTH)
)u_pre_add
(
    .sck          (sck        ),
    .voide_rst_n  (voide_rst_n),
    .data         (data       ),
    .r_vld        (r_vld      ),
    .l_vld        (l_vld      ),
    .data_out     (data_out   )
   );







endmodule