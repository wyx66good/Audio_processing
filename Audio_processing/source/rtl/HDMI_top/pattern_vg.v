`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:Meyesemi 
// Engineer: Will
// 
// Create Date: 2023-01-29 20:31  
// Design Name:  
// Module Name: 
// Project Name: 
// Target Devices: Pango
// Tool Versions: 
// Description: 
//      
// Dependencies: 
// 
// Revision:
// Revision 1.0 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define UD #1
module pattern_vg # (
    parameter                            COCLOR_DEPP=8, // number of bits per channel
    parameter                            X_BITS=13,
    parameter                            Y_BITS=13,
    parameter                            H_ACT = 12'd1920,
    parameter                            V_ACT = 12'd1080
)(                                       
    input                                rstn, 
    input                                pix_clk,
    input [X_BITS-1:0]                   act_x/*synthesis PAP_MARK_DEBUG="1"*/,
    input [X_BITS-1:0]                   act_y/*synthesis PAP_MARK_DEBUG="1"*/,
    input                                vs_in, 
    input                                hs_in, 
    input                                de_in,
    
    output reg                           vs_out, 
    output reg                           hs_out, 
    output reg                           de_out,
    output  reg    [23:0]                video_data  ,/*synthesis PAP_MARK_DEBUG="1"*/
    output  wire                         pix_req    , // 请求像素数据输入（像素点坐标提前实际时序一个周期）
    input   wire    [23:0]               pix_data   
);

assign pix_req    = (((act_x >= 1'b1) && 
                   (act_x < 'd1921))
                   && ((act_y >= 'd0) && (act_y < 'd1080)))
                   ? 1'b1 : 1'b0;
    
always @(posedge pix_clk)
begin
    vs_out <= `UD vs_in;
    hs_out <= `UD hs_in;
    de_out <= `UD de_in;
end

always@(*)
begin
         if(!rstn)
            video_data<='d0;
        else if(de_out) 
            video_data<=pix_data;
        else 
            video_data<='d0;
end
    
endmodule
