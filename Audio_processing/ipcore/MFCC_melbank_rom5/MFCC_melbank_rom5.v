
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
// Filename:MFCC_melbank_rom5.v
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps
module MFCC_melbank_rom5
    (
     addr        ,
     rst         ,
     clk         ,
     rd_data
    );

    localparam ADDR_WIDTH = 9 ; //@IPC int 4,10

    localparam DATA_WIDTH = 8 ; //@IPC int 1,256

    localparam RST_TYPE = "ASYNC" ; //@IPC enum ASYNC,SYNC

    localparam OUT_REG = 0 ; //@IPC bool

    localparam INIT_ENABLE = 1 ; //@IPC bool

    localparam INIT_FILE = "D:/PDS_FPGA/Audio_test/ipcore/MFCC_melbank_rom5/rtl/output4_MFCC_melbank_rom5.dat" ; //@IPC string

    localparam FILE_FORMAT = "BIN" ; //@IPC enum BIN,HEX


     output   wire  [DATA_WIDTH-1:0]       rd_data ;
     input    wire  [ADDR_WIDTH-1:0]       addr    ;
     input                                 clk     ;
     input                                 rst     ;

ipm_distributed_rom_v1_3_MFCC_melbank_rom5
   #(
     .ADDR_WIDTH    (ADDR_WIDTH     ), //address width   range:4-10
     .DATA_WIDTH    (DATA_WIDTH     ), //data width      range:4-256
     .RST_TYPE      (RST_TYPE       ), //reset type   "ASYNC_RESET" "SYNC_RESET"
     .OUT_REG       (OUT_REG        ), //output options :non_register(0)  register(1)
     .INIT_FILE     (INIT_FILE      ), //legal value:"NONE" or "initial file name"
     .FILE_FORMAT   (FILE_FORMAT    )  //initial data format : "bin" or "hex"
    )u_ipm_distributed_rom_MFCC_melbank_rom5
    (
     .rd_data       (rd_data        ),
     .addr          (addr           ),
     .clk           (clk            ),
     .rst           (rst            )

    );
endmodule
