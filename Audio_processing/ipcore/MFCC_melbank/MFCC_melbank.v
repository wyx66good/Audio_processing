
//////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2014 PANGO MICROSYSTEMS, INC
// ALL RIGHTS REVERVED.
//
// THE SOURCE CODE CONTAINED HEREIN IS PROPRIETARY TO PANGO MICROSYSTEMS, INC.
// IT SHALL NOT BE REPRODUCED OR DISCLOSED IN WHOLE OR IN PART OR USED BY
// PARTIES WITHOUT WRITTEN AUTHORIZATION FROM THE OWNER.
//
//////////////////////////////////////////////////////////////////////////////
//
// Library:
// Filename:MFCC_melbank.v
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps
module MFCC_melbank
     (
      wr_data        ,
      wr_addr        ,
      rd_addr        ,
      wr_clk         ,
      rd_clk         ,
      wr_en          ,
      rst            ,
      rd_data
     );

    localparam ADDR_WIDTH = 9 ; //@IPC int 4,10

    localparam DATA_WIDTH = 8 ; //@IPC int 1,256

    localparam RST_TYPE = "ASYNC" ; //@IPC enum ASYNC,SYNC

    localparam OUT_REG = 1 ; //@IPC bool

    localparam INIT_ENABLE = 1 ; //@IPC bool

    localparam INIT_FILE = "init_param_bin_exmp_MFCC_melbank.dat" ; //@IPC string

    localparam FILE_FORMAT = "BIN" ; //@IPC enum BIN,HEX


    input    wire     [DATA_WIDTH-1:0]       wr_data               ;
    input    wire     [ADDR_WIDTH-1:0]       wr_addr               ;
    input    wire     [ADDR_WIDTH-1:0]       rd_addr               ;
    input    wire                            wr_clk                ;
    input    wire                            rd_clk                ;
    input    wire                            wr_en                 ;
    input    wire                            rst                   ;
    output   wire     [DATA_WIDTH-1:0]       rd_data               ;


ipm_distributed_sdpram_v1_2_MFCC_melbank
    #(
     .ADDR_WIDTH    (ADDR_WIDTH )	,    //address width   range:4-10
     .DATA_WIDTH    (DATA_WIDTH ) 	,    //data width      range:4-256
     .RST_TYPE      (RST_TYPE   )   ,    //reset type   "ASYNC_RESET" "SYNC_RESET"
     .OUT_REG       (OUT_REG    )   ,    //output options :non_register(0)  register(1)
     .INIT_FILE     (INIT_FILE  )   ,
     .FILE_FORMAT   (FILE_FORMAT)
     ) u_ipm_distributed_sdpram_MFCC_melbank
     (
      .wr_data      (wr_data    )   ,
      .wr_addr      (wr_addr    )   ,
      .rd_addr      (rd_addr    )   ,
      .wr_clk       (wr_clk     )   ,
      .rd_clk       (rd_clk     )   ,
      .wr_en        (wr_en      )   ,
      .rst          (rst        )   ,
      .rd_data      (rd_data    )
     );
endmodule
