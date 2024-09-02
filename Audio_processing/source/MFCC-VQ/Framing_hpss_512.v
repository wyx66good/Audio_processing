/*************
Author:wyx
Times :2024.7.3
分帧512
**************/

module Framing_hpss_512#(
    parameter DATA_WIDTH = 16
)(

    input                           clk,
    input                           rst_n,

    input       wire                en,
    output      reg                 start,
    output      wire                finsh,          

    output wire                     wr_en  ,
    input wire  [DATA_WIDTH - 1:0]  wr_data,


    input  wire                     rd_en  ,
    output wire  [DATA_WIDTH - 1:0] rd_data


   );



wire         wr_en_1_1             ;   
reg          wr_en_Framing_512             ;   
wire  [15:0] wr_data_Framing_512           ;  
wire [9:0]   rd_water_level_1    ;
wire [15:0]  rd_data_1           ;
wire         rd_en_1             ;
reg          rd_en_1_1             ;


wire [9:0]   wr_water_level_1    ;
wire [15:0]  rd_data_2           ;

reg          wr_en_2 ;
wire [15:0]  wr_data_2;        ;
wire [10:0]  wr_water_level_2    ;     
wire [10:0]  rd_water_level_2    ;


reg [9:0] finsh_addr ;

localparam ST_1  = 5'b00001;
localparam ST_2  = 5'b00010;
localparam ST_3  = 5'b00100;
localparam ST_4  = 5'b01000;
localparam ST_5  = 5'b10000;


reg     [4:0]   fsm_c;
reg     [4:0]   fsm_n;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        fsm_c <= ST_4;
    else
        fsm_c <= fsm_n;
end
always@(*)
begin
    case(fsm_c)
        ST_4:begin
                fsm_n <= ST_5;
        end
        ST_5:begin
            if(wr_water_level_2=='d511)
                fsm_n<=ST_3;
            else
                fsm_n <= ST_5;
        end
        ST_3:begin
            if(rd_water_level_2=='d0)
                fsm_n<=ST_1;
            else
                fsm_n <= ST_3;
        end
        ST_1:begin
            if(rd_water_level_1=='d511 )
                fsm_n<=ST_2;
            else
                fsm_n <= ST_1;
        end
        ST_2:begin
            if(rd_water_level_1=='d0)
                fsm_n<=ST_3;
            else
                fsm_n <= ST_2;
        end

        default:begin
                fsm_n <= ST_1;
        end
    endcase
end


/************************************************************************************/
wire rd_en_2;
assign wr_en_1_1 = ( ((wr_water_level_1<'d511) &&( rd_en_2 ))  && (!rd_en_1)) ? 'd1:'d0;
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)
        wr_en_Framing_512 <= 'd0;
    else if(wr_en_1_1)
        wr_en_Framing_512 <= 'd1;
    else
        wr_en_Framing_512 <= 'd0;
end

assign wr_data_Framing_512 = wr_data ;

assign rd_en_1 = rd_en &&(finsh_addr>='d512)?'d1:'d0 ;

always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)
        rd_en_1_1 <= 'd0;
    else
        rd_en_1_1 <= rd_en_1;
end
/************************************************************************************/



/************************************************************************************/

//assign wr_en_2  =(rd_en_1 || (wr_water_level_2<='d511)) && (rst_n);
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)
        wr_en_2 <= 'd0;
    else if((rd_en_1 || (fsm_n==ST_5)) && (rst_n))
        wr_en_2 <= 'd1;
    else
        wr_en_2 <= 'd0;
end
assign wr_data_2=rd_data_1;
assign rd_en_2 = (rd_en &&(finsh_addr<'d512)) ?'d1:'d0;
/************************************************************************************/

assign wr_en   = wr_en_1_1;
assign rd_data = (rd_en_1_1)? rd_data_1:rd_data_2;




always@(posedge clk or negedge rst_n)
begin
    if(!rst_n )
        finsh_addr <= 'd0;
    else if(rd_en)
        finsh_addr <=finsh_addr + 'd1;
    else
        finsh_addr <= finsh_addr;
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n )
        start <= 'd0;
    else if(rd_water_level_2=='d512)
        start <= 'd1;
    else
        start <= 'd0;
end
assign finsh = ( finsh_addr =='d1023)?'d1:'d0;



Framing_512 u_Framing_512 (
  .wr_clk                (clk),                    // input
  .wr_rst                (!rst_n),                    // input
  .wr_en                 (wr_en_Framing_512),                      // input
  .wr_data               (wr_data_Framing_512),                  // input [15:0]
  .wr_full               (),                  // output
  .wr_water_level        (wr_water_level_1),    // output [9:0]
  .almost_full           (),          // output
  .rd_clk                (clk),                    // input
  .rd_rst                (!rst_n),                    // input
  .rd_en                 (rd_en_1),                      // input
  .rd_data               (rd_data_1),                  // output [15:0]
  .rd_empty              (),                // output
  .rd_water_level        (rd_water_level_1),    // output [9:0]
  .almost_empty          ()         // output
);

Framing_1024 u_Framing_1024 (
  .wr_clk                (clk),                    // input
  .wr_rst                (!rst_n),                    // input
  .wr_en                 (wr_en_2),                      // input
  .wr_data               (wr_data_2),                  // input [15:0]
  .wr_full               (),                  // output
  .wr_water_level        (wr_water_level_2),    // output [9:0]
  .almost_full           (),          // output
  .rd_clk                (clk),                    // input
  .rd_rst                (!rst_n),                    // input
  .rd_en                 (rd_en_2),                      // input
  .rd_data               (rd_data_2),                  // output [15:0]
  .rd_empty              (),                // output
  .rd_water_level        (rd_water_level_2),    // output [9:0]
  .almost_empty          ()         // output
);













endmodule