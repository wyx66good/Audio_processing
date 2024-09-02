
/*************
Author:wyx
Times :2024.7.3
ÖĞÖµÂË²¨ 15*15
**************/
module S_H(
    input                           clk,
    input                           rst_n,
    
    input                           statr,
    input [3:0]                    fsm_Median,
    output wire                    finsh_s_h,
    output wire                    finsh_s_h_2,

    input wire         [63:0]        rd_data_1,
    output  wire         [9:0]       rd_addr_1,
    input wire         [63:0]        rd_data_2,
    output  wire         [9:0]       rd_addr_2,
    input wire         [63:0]        rd_data_3,
    output  wire         [9:0]       rd_addr_3,
    input wire         [63:0]        rd_data_4,
    output  wire         [9:0]       rd_addr_4,
    input wire         [63:0]        rd_data_5,
    output  wire         [9:0]       rd_addr_5,
    input wire         [63:0]        rd_data_6,
    output  wire         [9:0]       rd_addr_6,
    input wire         [63:0]        rd_data_7,
    output  wire         [9:0]       rd_addr_7,
    input wire         [63:0]        rd_data_8,
    output  wire         [9:0]       rd_addr_8,
    input wire         [63:0]        rd_data_9,
    output  wire         [9:0]       rd_addr_9,



    output wire         [63:0]      rd_data_H,
    input  wire         [9:0]       rd_addr_H,

    output wire         [63:0]      rd_data_P,
    input  wire         [9:0]       rd_addr_P
   );



reg [3:0]  addr_9;
wire finsh_midian;
wire finsh_midian_p;

reg        rd_en;
reg        rd_en_1;
reg        en;
reg        en_1;

reg  [9:0]  wr_addr_H;


reg [9:0]  rd_addr;
reg [63:0] rd_data;

wire       finsh_s_h_1;

reg [63:0] a1;
reg [63:0] a2;
reg [63:0] a3;
reg [63:0] a4;
reg [63:0] a5;
reg [63:0] a6;
reg [63:0] a7;
reg [63:0] a8;
reg [63:0] a9;

reg [63:0] b1;
reg [63:0] b2;
reg [63:0] b3;
reg [63:0] b4;
reg [63:0] b5;
reg [63:0] b6;
reg [63:0] b7;
reg [63:0] b8;
reg [63:0] b9;



wire [3:0] fsm_Median_1;

assign  fsm_Median_1=(fsm_Median>=5)?fsm_Median-'d4:fsm_Median+'d5;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        rd_data     <= 'd0;
    end
    else if(fsm_Median_1=='d1) begin
        rd_data     <= rd_data_1;
    end
    else if(fsm_Median_1=='d2) begin
        rd_data     <= rd_data_2;
    end
    else if(fsm_Median_1=='d3) begin
        rd_data     <= rd_data_3;
    end
    else if(fsm_Median_1=='d4) begin
        rd_data     <= rd_data_4;
    end
    else if(fsm_Median_1=='d5) begin
        rd_data     <= rd_data_5;
    end    
    else if(fsm_Median_1=='d6) begin
        rd_data     <= rd_data_6;
    end
    else if(fsm_Median_1=='d7) begin
        rd_data     <= rd_data_7;
    end
    else if(fsm_Median_1=='d8) begin
        rd_data     <= rd_data_8;
    end
    else if(fsm_Median_1=='d9) begin
        rd_data     <= rd_data_9;
    end
    else  begin
        rd_data     <= rd_data;
    end
end


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||finsh_s_h_1)begin
        a1     <= 'd0;
        a2     <= 'd0;
        a3     <= 'd0;
        a4     <= 'd0;
        a5     <= 'd0;
        a6     <= 'd0;
        a7     <= 'd0;
        a8     <= 'd0;
        a9     <= 'd0;
    end
    else if(rd_en) begin
        a1     <= rd_data;
        a2     <= a1;
        a3     <= a2;
        a4     <= a3;
        a5     <= a4;
        a6     <= a5;
        a7     <= a6;
        a8     <= a7;
        a9     <= a8;
    end
end


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        b1     <= 'd0;
        b2     <= 'd0;
        b3     <= 'd0;
        b4     <= 'd0;
        b5     <= 'd0;
        b6     <= 'd0;
        b7     <= 'd0;
        b8     <= 'd0;
        b9     <= 'd0;
    end
    else if(rd_en) begin
        b1     <= rd_data_1;
        b2     <= rd_data_2;
        b3     <= rd_data_3;
        b4     <= rd_data_4;
        b5     <= rd_data_5;
        b6     <= rd_data_6;
        b7     <= rd_data_7;
        b8     <= rd_data_8;
        b9     <= rd_data_9;
    end
end




always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        rd_addr <= 'd0;
    else if(rd_en)
        rd_addr <= rd_addr+'d1;
    else
        rd_addr <= rd_addr;
end

assign finsh_s_h=(wr_addr_H=='d1018)&&finsh_midian_p;
assign finsh_s_h_1=(wr_addr_H=='d1019)&&finsh_midian_p;

assign finsh_s_h_2=(wr_addr_H=='d1023);

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        en <= 'd0;
    else if(statr)
        en <= 'd1;
    else if(finsh_s_h)
        en <= 'd0;
    else
        en <= en;
end


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        en_1 <= 'd0;
    else
        en_1 <= en;
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        rd_en <= 'd0;
    else if(((en&&!en_1)||finsh_midian_p)&&en)
        rd_en <= 'd1;
    else
        rd_en <= 'd0;
end

assign rd_addr_1=rd_addr;
assign rd_addr_2=rd_addr;
assign rd_addr_3=rd_addr;
assign rd_addr_4=rd_addr;
assign rd_addr_5=rd_addr;
assign rd_addr_6=rd_addr;
assign rd_addr_7=rd_addr;
assign rd_addr_8=rd_addr;
assign rd_addr_9=rd_addr;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        rd_en_1 <= 'd0;
    else
        rd_en_1 <= rd_en;
end

wire         start_midian;
wire  [63:0] mid_H_1;
assign start_midian=(!rd_en&&rd_en_1);

midian midian(
.clk     (clk),
.rst_n   (rst_n),
.start   (start_midian),
.finsh   (finsh_midian),
.a1      (a1 ),
.a2      (a2 ),
.a3      (a3 ),
.a4      (a4 ),
.a5      (a5 ),
.a6      (a6 ),
.a7      (a7 ),
.a8      (a8 ),
.a9      (a9 ),
.mid   (mid_H_1)

   );




wire [63:0] mid_P;
midian midian_P(
.clk     (clk),
.rst_n   (rst_n),
.start   (start_midian),
.finsh   (finsh_midian_p),
.a1      (b1 ),
.a2      (b2 ),
.a3      (b3 ),
.a4      (b4 ),
.a5      (b5 ),
.a6      (b6 ),
.a7      (b7 ),
.a8      (b8 ),
.a9      (b9 ),
.mid   (mid_P)

   );

wire [63:0] wr_data_H;
reg  [63:0] wr_data_H_1;
wire        wr_en_H;
wire        wr_en_H_1;

wire [63:0] wr_data_P;
reg [9:0]   wr_addr_P;
wire        wr_en_P;


assign wr_en_H=finsh_midian||wr_en_H_1;
assign wr_en_H_1=(wr_addr_H>'d1019||((wr_addr_H=='d1019)&&finsh_midian))?'d1:'d0;
assign wr_data_H=(wr_addr_H>'d1019)?wr_data_H_1:mid_H_1;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        wr_data_H_1 <= 'd0;
    else if((wr_addr_H=='d1019)&&finsh_midian)
        wr_data_H_1   <=mid_H_1;
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        wr_addr_H <= 'd0;
    else if((wr_en_H&&((rd_addr>='d5)))||wr_en_H_1)
        wr_addr_H <= wr_addr_H+'d1;
    else
        wr_addr_H   <=wr_addr_H;
end

assign wr_en_P=finsh_midian_p;
assign wr_data_P=mid_P;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        wr_addr_P <= 'd0;
    else if(wr_en_P)
        wr_addr_P <= wr_addr_P+'d1;
    else
        wr_addr_P   <=wr_addr_P;
end

Median_ram Median_H (
  .wr_data(wr_data_H),    // input [63:0]
  .wr_addr(wr_addr_H),    // input [9:0]
  .wr_en  (wr_en_H),        // input
  .wr_clk(clk),      // input
  .rd_clk(clk),      // input
  .wr_rst(!rst_n),            // input
  .rd_rst(!rst_n),            // input
//  .rst(!rst_n),            // input
  .rd_addr(rd_addr_H),    // input [9:0]
  .rd_data(rd_data_H)     // output [42:0]
);

Median_ram Median_P (
  .wr_data(wr_data_P),    // input [63:0]
  .wr_addr(wr_addr_P),    // input [9:0]
  .wr_en(wr_en_P),        // input
  .wr_clk(clk),      // input
  .rd_clk(clk),      // input
  .wr_rst(!rst_n),            // input
  .rd_rst(!rst_n),            // input
//  .rst(!rst_n),            // input
  .rd_addr(rd_addr_P),    // input [9:0]
  .rd_data(rd_data_P)     // output [42:0]
);





endmodule