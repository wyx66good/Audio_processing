
/*************
Author:wyx
Times :2024.8.9
LBG 码本获取 16
**************/


module LBG_frame_13(
    input     wire              clk  ,
    input     wire              rst_n,

    input    wire               LBG_start,//开始
    output   reg                LBG_finsh,//结束

    output     reg [7:0]         LBG_ADDR,
    input     wire [13:0]       LBG_DATA,

    input     wire [7:0]        rd_addr_1 ,
    input     wire [7:0]        rd_addr_2 ,
    input     wire [7:0]        rd_addr_3 ,
    input     wire [7:0]        rd_addr_4 ,
    input     wire [7:0]        rd_addr_5 ,
    input     wire [7:0]        rd_addr_6 ,
    input     wire [7:0]        rd_addr_7 ,
    input     wire [7:0]        rd_addr_8 ,
    input     wire [7:0]        rd_addr_9 ,
    input     wire [7:0]        rd_addr_10,
    input     wire [7:0]        rd_addr_11,
    input     wire [7:0]        rd_addr_12,
    input     wire [7:0]        rd_addr_13,
    input     wire [7:0]        rd_addr_14,
    input     wire [7:0]        rd_addr_15,
    input     wire [7:0]        rd_addr_16,

    output    wire [13:0]       rd_vblg_1 ,
    output    wire [13:0]       rd_vblg_2 ,
    output    wire [13:0]       rd_vblg_3 ,
    output    wire [13:0]       rd_vblg_4 ,
    output    wire [13:0]       rd_vblg_5 ,
    output    wire [13:0]       rd_vblg_6 ,
    output    wire [13:0]       rd_vblg_7 ,
    output    wire [13:0]       rd_vblg_8 ,
    output    wire [13:0]       rd_vblg_9 ,
    output    wire [13:0]       rd_vblg_10,
    output    wire [13:0]       rd_vblg_11,
    output    wire [13:0]       rd_vblg_12,
    output    wire [13:0]       rd_vblg_13,
    output    wire [13:0]       rd_vblg_14,
    output    wire [13:0]       rd_vblg_15,
    output    wire [13:0]       rd_vblg_16

   );
reg              LBG_ADDR_en;
reg [7:0]        LBG_ADDR_1;
reg              LBG_ADDR_en_1;
reg [7:0]        LBG_vblg14x12_addr;
wire              LBG_finsh_1;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||LBG_finsh_1)begin
        LBG_ADDR <= 'd0;
    end
    else if(LBG_ADDR_en) begin
        LBG_ADDR <= LBG_ADDR+'d1;
    end
    else begin
        LBG_ADDR <= 'd0;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||(LBG_vblg14x12_addr=='d12))begin
        LBG_vblg14x12_addr <= 'd0;
    end
    else if(LBG_ADDR_en_1) begin
        LBG_vblg14x12_addr <= LBG_vblg14x12_addr+'d1;
    end
    else begin
        LBG_vblg14x12_addr <= 'd0;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||LBG_finsh_1)begin
        LBG_ADDR_en <= 'd0;
    end
    else if(LBG_start) begin
        LBG_ADDR_en <= 'd1;
    end
    else begin
        LBG_ADDR_en <= LBG_ADDR_en;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
       LBG_ADDR_en_1<='d0;
       LBG_ADDR_1   <='d0;
       LBG_finsh    <='d0;
    end
    else begin
       LBG_ADDR_en_1<=LBG_ADDR_en;
       LBG_ADDR_1   <=LBG_ADDR;
       LBG_finsh    <=LBG_finsh_1;
    end
end

assign LBG_finsh_1=(LBG_ADDR=='d207)?'d1:'d0;



wire vblg14x12_en_1 ;
wire vblg14x12_en_2 ;
wire vblg14x12_en_3 ;
wire vblg14x12_en_4 ;
wire vblg14x12_en_5 ;
wire vblg14x12_en_6 ;
wire vblg14x12_en_7 ;
wire vblg14x12_en_8 ;
wire vblg14x12_en_9 ;
wire vblg14x12_en_10;
wire vblg14x12_en_11;
wire vblg14x12_en_12;
wire vblg14x12_en_13;
wire vblg14x12_en_14;
wire vblg14x12_en_15;
wire vblg14x12_en_16;

assign vblg14x12_en_1 =((LBG_ADDR_1<='d12)&&LBG_ADDR_en_1)?'d1:'d0;
assign vblg14x12_en_2 =(((LBG_ADDR_1>'d12)&& (LBG_ADDR_1<='d25))   &&LBG_ADDR_en_1)?'d1:'d0;
assign vblg14x12_en_3 =(((LBG_ADDR_1>'d25)&& (LBG_ADDR_1<='d38))   &&LBG_ADDR_en_1)?'d1:'d0;
assign vblg14x12_en_4 =(((LBG_ADDR_1>'d38)&& (LBG_ADDR_1<='d51))   &&LBG_ADDR_en_1)?'d1:'d0;
assign vblg14x12_en_5 =(((LBG_ADDR_1>'d51)&& (LBG_ADDR_1<='d64))   &&LBG_ADDR_en_1)?'d1:'d0;
assign vblg14x12_en_6 =(((LBG_ADDR_1>'d64)&& (LBG_ADDR_1<='d77))   &&LBG_ADDR_en_1)?'d1:'d0;
assign vblg14x12_en_7 =(((LBG_ADDR_1>'d77)&& (LBG_ADDR_1<='d90))   &&LBG_ADDR_en_1)?'d1:'d0;
assign vblg14x12_en_8 =(((LBG_ADDR_1>'d90)&& (LBG_ADDR_1<='d103))  &&LBG_ADDR_en_1)?'d1:'d0;
assign vblg14x12_en_9 =(((LBG_ADDR_1>'d103)&&(LBG_ADDR_1<='d116)) &&LBG_ADDR_en_1)?'d1:'d0;
assign vblg14x12_en_10=(((LBG_ADDR_1>'d116)&&(LBG_ADDR_1<='d129)) &&LBG_ADDR_en_1)?'d1:'d0;
assign vblg14x12_en_11=(((LBG_ADDR_1>'d129)&&(LBG_ADDR_1<='d142)) &&LBG_ADDR_en_1)?'d1:'d0;
assign vblg14x12_en_12=(((LBG_ADDR_1>'d142)&&(LBG_ADDR_1<='d155)) &&LBG_ADDR_en_1)?'d1:'d0;
assign vblg14x12_en_13=(((LBG_ADDR_1>'d155)&&(LBG_ADDR_1<='d168)) &&LBG_ADDR_en_1)?'d1:'d0;
assign vblg14x12_en_14=(((LBG_ADDR_1>'d168)&&(LBG_ADDR_1<='d181)) &&LBG_ADDR_en_1)?'d1:'d0;
assign vblg14x12_en_15=(((LBG_ADDR_1>'d181)&&(LBG_ADDR_1<='d194)) &&LBG_ADDR_en_1)?'d1:'d0;
assign vblg14x12_en_16=(((LBG_ADDR_1>'d194)&&(LBG_ADDR_1<='d207)) &&LBG_ADDR_en_1)?'d1:'d0;





vblg14x12 vblg14x12_1 (
  .wr_data(LBG_DATA),    // input [13:0]
  .wr_addr(LBG_vblg14x12_addr),    // input [4:0]
  .wr_en  (vblg14x12_en_1),        // input
  .wr_clk(clk),      // input
  .wr_rst(!rst_n),      // input
  .rd_addr(rd_addr_1),    // input [4:0]
  .rd_data(rd_vblg_1),    // output [13:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst_n)       // input
);



vblg14x12 vblg14x12_2 (
  .wr_data(LBG_DATA),    // input [13:0]
  .wr_addr(LBG_vblg14x12_addr),    // input [4:0]
  .wr_en(vblg14x12_en_2),        // input
  .wr_clk(clk),      // input
  .wr_rst(!rst_n),      // input
  .rd_addr(rd_addr_2),    // input [4:0]
  .rd_data(rd_vblg_2),    // output [13:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst_n)       // input
);

vblg14x12 vblg14x12_3 (
  .wr_data(LBG_DATA),    // input [13:0]
  .wr_addr(LBG_vblg14x12_addr),    // input [4:0]
  .wr_en(vblg14x12_en_3),        // input
  .wr_clk(clk),      // input
  .wr_rst(!rst_n),      // input
  .rd_addr(rd_addr_3),    // input [4:0]
  .rd_data(rd_vblg_3),    // output [13:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst_n)       // input
);

vblg14x12 vblg14x12_4 (
  .wr_data(LBG_DATA),    // input [13:0]
  .wr_addr(LBG_vblg14x12_addr),    // input [4:0]
  .wr_en(vblg14x12_en_4),        // input
  .wr_clk(clk),      // input
  .wr_rst(!rst_n),      // input
  .rd_addr(rd_addr_4),    // input [4:0]
  .rd_data(rd_vblg_4),    // output [13:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst_n)       // input
);


vblg14x12 vblg14x12_5 (
  .wr_data(LBG_DATA),    // input [13:0]
  .wr_addr(LBG_vblg14x12_addr),    // input [4:0]
  .wr_en(vblg14x12_en_5),        // input
  .wr_clk(clk),      // input
  .wr_rst(!rst_n),      // input
  .rd_addr(rd_addr_5),    // input [4:0]
  .rd_data(rd_vblg_5),    // output [13:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst_n)       // input
);

vblg14x12 vblg14x12_6 (
  .wr_data(LBG_DATA),    // input [13:0]
  .wr_addr(LBG_vblg14x12_addr),    // input [4:0]
  .wr_en(vblg14x12_en_6),        // input
  .wr_clk(clk),      // input
  .wr_rst(!rst_n),      // input
  .rd_addr(rd_addr_6),    // input [4:0]
  .rd_data(rd_vblg_6),    // output [13:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst_n)       // input
);

vblg14x12 vblg14x12_7 (
  .wr_data(LBG_DATA),    // input [13:0]
  .wr_addr(LBG_vblg14x12_addr),    // input [4:0]
  .wr_en(vblg14x12_en_7),        // input
  .wr_clk(clk),      // input
  .wr_rst(!rst_n),      // input
  .rd_addr(rd_addr_7),    // input [4:0]
  .rd_data(rd_vblg_7),    // output [13:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst_n)       // input
);
vblg14x12 vblg14x12_8 (
  .wr_data(LBG_DATA),    // input [13:0]
  .wr_addr(LBG_vblg14x12_addr),    // input [4:0]
  .wr_en(vblg14x12_en_8),        // input
  .wr_clk(clk),      // input
  .wr_rst(!rst_n),      // input
  .rd_addr(rd_addr_8),    // input [4:0]
  .rd_data(rd_vblg_8),    // output [13:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst_n)       // input
);
vblg14x12 vblg14x12_9 (
  .wr_data(LBG_DATA),    // input [13:0]
  .wr_addr(LBG_vblg14x12_addr),    // input [4:0]
  .wr_en(vblg14x12_en_9),        // input
  .wr_clk(clk),      // input
  .wr_rst(!rst_n),      // input
  .rd_addr(rd_addr_9),    // input [4:0]
  .rd_data(rd_vblg_9),    // output [13:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst_n)       // input
);
vblg14x12 vblg14x12_10 (
  .wr_data(LBG_DATA),    // input [13:0]
  .wr_addr(LBG_vblg14x12_addr),    // input [4:0]
  .wr_en(vblg14x12_en_10),        // input
  .wr_clk(clk),      // input
  .wr_rst(!rst_n),      // input
  .rd_addr(rd_addr_10),    // input [4:0]
  .rd_data(rd_vblg_10),    // output [13:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst_n)       // input
);
vblg14x12 vblg14x12_11 (
  .wr_data(LBG_DATA),    // input [13:0]
  .wr_addr(LBG_vblg14x12_addr),    // input [4:0]
  .wr_en(vblg14x12_en_11),        // input
  .wr_clk(clk),      // input
  .wr_rst(!rst_n),      // input
  .rd_addr(rd_addr_11),    // input [4:0]
  .rd_data(rd_vblg_11),    // output [13:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst_n)       // input
);
vblg14x12 vblg14x12_12 (
  .wr_data(LBG_DATA),    // input [13:0]
  .wr_addr(LBG_vblg14x12_addr),    // input [4:0]
  .wr_en(vblg14x12_en_12),        // input
  .wr_clk(clk),      // input
  .wr_rst(!rst_n),      // input
  .rd_addr(rd_addr_12),    // input [4:0]
  .rd_data(rd_vblg_12),    // output [13:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst_n)       // input
);
vblg14x12 vblg14x12_13 (
  .wr_data(LBG_DATA),    // input [13:0]
  .wr_addr(LBG_vblg14x12_addr),    // input [4:0]
  .wr_en(vblg14x12_en_13),        // input
  .wr_clk(clk),      // input
  .wr_rst(!rst_n),      // input
  .rd_addr(rd_addr_13),    // input [4:0]
  .rd_data(rd_vblg_13),    // output [13:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst_n)       // input
);
vblg14x12 vblg14x12_14 (
  .wr_data(LBG_DATA),    // input [13:0]
  .wr_addr(LBG_vblg14x12_addr),    // input [4:0]
  .wr_en(vblg14x12_en_14),        // input
  .wr_clk(clk),      // input
  .wr_rst(!rst_n),      // input
  .rd_addr(rd_addr_14),    // input [4:0]
  .rd_data(rd_vblg_14),    // output [13:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst_n)       // input
);
vblg14x12 vblg14x12_15 (
  .wr_data(LBG_DATA),    // input [13:0]
  .wr_addr(LBG_vblg14x12_addr),    // input [4:0]
  .wr_en(vblg14x12_en_15),        // input
  .wr_clk(clk),      // input
  .wr_rst(!rst_n),      // input
  .rd_addr(rd_addr_15),    // input [4:0]
  .rd_data(rd_vblg_15),    // output [13:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst_n)       // input
);
vblg14x12 vblg14x12_16 (
  .wr_data(LBG_DATA),    // input [13:0]
  .wr_addr(LBG_vblg14x12_addr),    // input [4:0]
  .wr_en(vblg14x12_en_16),        // input
  .wr_clk(clk),      // input
  .wr_rst(!rst_n),      // input
  .rd_addr(rd_addr_16),    // input [4:0]
  .rd_data(rd_vblg_16),    // output [13:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst_n)       // input
);



endmodule