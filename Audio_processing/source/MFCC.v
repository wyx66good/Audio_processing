/*************
Author:wyx
Times :2024.8.2
MFCC滤波
**************/

module MFCC(

    input   wire              clk  ,
    input   wire              rst_n,
    
    input   wire              start,
    output  reg              finsh,

    input   wire [63:0]      fft_data,
    output  wire [9:0]       fft_addr,

    output  reg [40:0]         MFCC1 ,
    output  reg [40:0]         MFCC2 ,
    output  reg [40:0]         MFCC3 ,
    output  reg [40:0]         MFCC4 ,
    output  reg [40:0]         MFCC5 ,
    output  reg [40:0]         MFCC6 ,
    output  reg [40:0]         MFCC7 ,
    output  reg [40:0]         MFCC8 ,
    output  reg [40:0]         MFCC9 ,
    output  reg [40:0]         MFCC10,
    output  reg [40:0]         MFCC11,
    output  reg [40:0]         MFCC12,
    output  reg [40:0]         MFCC13,
    output  reg [40:0]         MFCC14,
    output  reg [40:0]         MFCC15,
    output  reg [40:0]         MFCC16,
    output  reg [40:0]         MFCC17,
    output  reg [40:0]         MFCC18,
    output  reg [40:0]         MFCC19,
    output  reg [40:0]         MFCC20,
    output  reg [40:0]         MFCC21,
    output  reg [40:0]         MFCC22,
    output  reg [40:0]         MFCC23,
    output  reg [40:0]         MFCC24
    
   );

reg finsh_1;
reg finsh_2;
reg finsh_3;



reg [8:0]rd_addr;

reg en;
reg en_1;
reg en_2;
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||(rd_addr=='d511))begin
        en <= 'd0;
    end
    else if(start)begin
        en <= 'd1;
    end
    else begin
        en <= en;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        en_1 <= 'd0;
        en_2 <= 'd0;
    end
    else begin
        en_1 <= en;
        en_2 <= en_1;
    end
end



reg [8:0]rd_addr_1/*synthesis PAP_MARK_DEBUG="1"*/;
reg [8:0]rd_addr_2;
wire [7:0]  rd_data1;
wire [7:0]  rd_data2;
wire [7:0]  rd_data3;
wire [7:0]  rd_data4;
wire [7:0]  rd_data5;
wire [7:0]  rd_data6;
wire [7:0]  rd_data7;
wire [7:0]  rd_data8;
wire [7:0]  rd_data9;
wire [7:0] rd_data10;
wire [7:0] rd_data11;
wire [7:0] rd_data12;
wire [7:0] rd_data13;
wire [7:0] rd_data14;
wire [7:0] rd_data15;
wire [7:0] rd_data16;
wire [7:0] rd_data17;
wire [7:0] rd_data18;
wire [7:0] rd_data19;
wire [7:0] rd_data20;
wire [7:0] rd_data21;
wire [7:0] rd_data22;
wire [7:0] rd_data23;
wire [7:0] rd_data24;


wire [31:0] fft_real/*synthesis PAP_MARK_DEBUG="1"*/;
wire [31:0] fft_imag;
wire [15:0] fft_real_1/*synthesis PAP_MARK_DEBUG="1"*/;
wire [15:0] fft_imag_1/*synthesis PAP_MARK_DEBUG="1"*/;
reg [31:0]  fft_real_2;
reg [31:0]  fft_imag_2;
assign fft_real=fft_data[31]?~fft_data[31:0]+'d1:fft_data[31:0];
assign fft_imag=fft_data[63]?~fft_data[63:32]+'d1:fft_data[63:32];
assign fft_real_1=fft_real>>>6;
assign fft_imag_1=fft_imag>>>6;

reg [32:0] fft_abs/*synthesis PAP_MARK_DEBUG="1"*/;
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        fft_real_2 <= 'd0;
    end
    else begin
        fft_real_2 <= fft_real_1*fft_real_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        fft_imag_2 <= 'd0;
    end
    else begin
        fft_imag_2 <= fft_imag_1*fft_imag_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        fft_abs <= 'd0;
    end
    else begin
        fft_abs <= fft_real_2+fft_imag_2;
    end
end
reg [39:0] M1/*synthesis PAP_MARK_DEBUG="1"*/;
reg [39:0] M2;
reg [39:0] M3;
reg [39:0] M4;
reg [39:0] M5;
reg [39:0] M6;
reg [39:0] M7;
reg [39:0] M8;
reg [39:0] M9;
reg [39:0] M10;
reg [39:0] M11;
reg [39:0] M12;
reg [39:0] M13;
reg [39:0] M14;
reg [39:0] M15;
reg [39:0] M16;
reg [39:0] M17;
reg [39:0] M18;
reg [39:0] M19;
reg [39:0] M20;
reg [39:0] M21;
reg [39:0] M22;
reg [39:0] M23;
reg [39:0] M24;


always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M1 <= 'd0;
    end
    else  begin
        M1 <=rd_data1 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M2 <= 'd0;
    end
    else  begin
        M2 <=rd_data2 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M3 <= 'd0;
    end
    else  begin
        M3 <=rd_data3 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M4 <= 'd0;
    end
    else  begin
        M4 <=rd_data4 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M5 <= 'd0;
    end
    else  begin
        M5 <=rd_data5 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M6 <= 'd0;
    end
    else  begin
        M6 <=rd_data6 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M7 <= 'd0;
    end
    else  begin
        M7 <=rd_data7 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M8 <= 'd0;
    end
    else  begin
        M8 <=rd_data8 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M9 <= 'd0;
    end
    else  begin
        M9 <=rd_data9 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M10 <= 'd0;
    end
    else  begin
        M10 <=rd_data10 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M11 <= 'd0;
    end
    else  begin
        M11 <=rd_data11 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M12 <= 'd0;
    end
    else  begin
        M12 <=rd_data12 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M13 <= 'd0;
    end
    else  begin
        M13 <=rd_data13 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M14 <= 'd0;
    end
    else  begin
        M14 <=rd_data14 *fft_abs;
    end
end

always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M15 <= 'd0;
    end
    else  begin
        M15 <=rd_data15 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M16 <= 'd0;
    end
    else  begin
        M16 <=rd_data16 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M17 <= 'd0;
    end
    else  begin
        M17 <=rd_data17 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M18 <= 'd0;
    end
    else  begin
        M18 <=rd_data18 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M19 <= 'd0;
    end
    else  begin
        M19 <=rd_data19 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M20 <= 'd0;
    end
    else  begin
        M20 <=rd_data20 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M21 <= 'd0;
    end
    else  begin
        M21 <=rd_data21 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M22 <= 'd0;
    end
    else  begin
        M22 <=rd_data22 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M23 <= 'd0;
    end
    else  begin
        M23 <=rd_data23 *fft_abs;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        M24 <= 'd0;
    end
    else  begin
        M24 <=rd_data24 *fft_abs;
    end
end

wire [31:0]  M1_1;
wire [31:0]  M2_1;
wire [31:0]  M3_1;
wire [31:0]  M4_1;
wire [31:0]  M5_1;
wire [31:0]  M6_1;
wire [31:0]  M7_1;
wire [31:0]  M8_1;
wire [31:0]  M9_1;
wire [31:0] M10_1;
wire [31:0] M11_1;
wire [31:0] M12_1;
wire [31:0] M13_1;
wire [31:0] M14_1;
wire [31:0] M15_1;
wire [31:0] M16_1;
wire [31:0] M17_1;
wire [31:0] M18_1;
wire [31:0] M19_1;
wire [31:0] M20_1;
wire [31:0] M21_1;
wire [31:0] M22_1;
wire [31:0] M23_1;
wire [31:0] M24_1;

assign  M1_1=M1 >>>8; 
assign  M2_1=M2 >>>8; 
assign  M3_1=M3 >>>8; 
assign  M4_1=M4 >>>8; 
assign  M5_1=M5 >>>8; 
assign  M6_1=M6 >>>8; 
assign  M7_1=M7 >>>8; 
assign  M8_1=M8 >>>8; 
assign  M9_1=M9 >>>8; 
assign M10_1=M10>>>8;
assign M11_1=M11>>>8;
assign M12_1=M12>>>8;
assign M13_1=M13>>>8;
assign M14_1=M14>>>8;
assign M15_1=M15>>>8;
assign M16_1=M16>>>8;
assign M17_1=M17>>>8;
assign M18_1=M18>>>8;
assign M19_1=M19>>>8;
assign M20_1=M20>>>8;
assign M21_1=M21>>>8;
assign M22_1=M22>>>8;
assign M23_1=M23>>>8;
assign M24_1=M24>>>8;










always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC1 <= 'd0;
    end
    else if(en_2) begin
        MFCC1 <= MFCC1+M1_1;
    end
end

always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC2 <= 'd0;
    end
    else if(en_2) begin
        MFCC2 <= MFCC2+M2_1;
    end
end

always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC3 <= 'd0;
    end
    else if(en_2) begin
        MFCC3 <= MFCC3+M3_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC4 <= 'd0;
    end
    else if(en_2) begin
        MFCC4 <= MFCC4+M4_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC5 <= 'd0;
    end
    else if(en_2) begin
        MFCC5 <= MFCC5+M5_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC6 <= 'd0;
    end
    else if(en_2) begin
        MFCC6 <= MFCC6+M6_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC7 <= 'd0;
    end
    else if(en_2) begin
        MFCC7 <= MFCC7+M7_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC8 <= 'd0;
    end
    else if(en_2) begin
        MFCC8 <= MFCC8+M8_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC9 <= 'd0;
    end
    else if(en_2) begin
        MFCC9 <= MFCC9+M9_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC10 <= 'd0;
    end
    else if(en_2) begin
        MFCC10 <= MFCC10+M10_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC11 <= 'd0;
    end
    else if(en_2) begin
        MFCC11 <= MFCC11+M11_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC12 <= 'd0;
    end
    else if(en_2) begin
        MFCC12 <= MFCC12+M12_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC13 <= 'd0;
    end
    else if(en_2) begin
        MFCC13 <= MFCC13+M13_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC14 <= 'd0;
    end
    else if(en_2) begin
        MFCC14 <= MFCC14+M14_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC15 <= 'd0;
    end
    else if(en_2) begin
        MFCC15 <= MFCC15+M15_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC16 <= 'd0;
    end
    else if(en_2) begin
        MFCC16 <= MFCC16+M16_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC17 <= 'd0;
    end
    else if(en_2) begin
        MFCC17 <= MFCC17+M17_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC18 <= 'd0;
    end
    else if(en_2) begin
        MFCC18 <= MFCC18+M18_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC19 <= 'd0;
    end
    else if(en_2) begin
        MFCC19 <= MFCC19+M19_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC20 <= 'd0;
    end
    else if(en_2) begin
        MFCC20 <= MFCC20+M20_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC21 <= 'd0;
    end
    else if(en_2) begin
        MFCC21 <= MFCC21+M21_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC22 <= 'd0;
    end
    else if(en_2) begin
        MFCC22 <= MFCC22+M22_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC23 <= 'd0;
    end
    else if(en_2) begin
        MFCC23 <= MFCC23+M23_1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||start)begin
        MFCC24 <= 'd0;
    end
    else if(en_2) begin
        MFCC24 <= MFCC24+M24_1;
    end
end






MFCC_melbank_rom MFCC_melbank_rom (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data1)     // output [7:0]
);
MFCC_melbank_rom2 MFCC_melbank_rom2 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data2)     // output [7:0]
);
MFCC_melbank_rom3 MFCC_melbank_rom3 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data3)     // output [7:0]
);
MFCC_melbank_rom4 MFCC_melbank_rom4 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data4)     // output [7:0]
);
MFCC_melbank_rom5 MFCC_melbank_rom5 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data5)     // output [7:0]
);
MFCC_melbank_rom6 MFCC_melbank_rom6 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data6)     // output [7:0]
);
MFCC_melbank_rom7 MFCC_melbank_rom7 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data7)     // output [7:0]
);
MFCC_melbank_rom8 MFCC_melbank_rom8 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data8)     // output [7:0]
);
MFCC_melbank_rom9 MFCC_melbank_rom9 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data9)     // output [7:0]
);
MFCC_melbank_rom10 MFCC_melbank_rom10 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data10)     // output [7:0]
);MFCC_melbank_rom11 MFCC_melbank_rom11 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data11)     // output [7:0]
);
MFCC_melbank_rom12 MFCC_melbank_rom12 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data12)     // output [7:0]
);
MFCC_melbank_rom13 MFCC_melbank_rom13 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data13)     // output [7:0]
);
MFCC_melbank_rom14 MFCC_melbank_rom14 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data14)     // output [7:0]
);
MFCC_melbank_rom15 MFCC_melbank_rom15 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data15)     // output [7:0]
);
MFCC_melbank_rom16 MFCC_melbank_rom16 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data16)     // output [7:0]
);
MFCC_melbank_rom17 MFCC_melbank_rom17 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data17)     // output [7:0]
);
MFCC_melbank_rom18 MFCC_melbank_rom18 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data18)     // output [7:0]
);
MFCC_melbank_rom19 MFCC_melbank_rom19 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data19)     // output [7:0]
);
MFCC_melbank_rom20 MFCC_melbank_rom20 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data20)     // output [7:0]
);
MFCC_melbank_rom21 MFCC_melbank_rom21 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data21)     // output [7:0]
);
MFCC_melbank_rom22 MFCC_melbank_rom22 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data22)     // output [7:0]
);
MFCC_melbank_rom23 MFCC_melbank_rom23 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data23)     // output [7:0]
);
MFCC_melbank_rom24 MFCC_melbank_rom24 (
  .addr(rd_addr_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(rd_data24)     // output [7:0]
);
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||(rd_addr=='d511))begin
        rd_addr <= 'd0;
    end
    else if(en) begin
        rd_addr <= rd_addr+'d1;
    end
end
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        rd_addr_1 <= 'd0;
        rd_addr_2 <= 'd0;
    end
    else  begin
        rd_addr_2 <= rd_addr;
        rd_addr_1 <= rd_addr_2;
    end
end
assign fft_addr=rd_addr;




always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        finsh_1 <= 'd0;
    end
    else if(rd_addr=='d511) begin
        finsh_1 <= 'd1;
    end
    else  begin
        finsh_1 <= 'd0;
    end
end

always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        finsh_2 <= 'd0;
        finsh_3 <= 'd0;
        finsh   <= 'd0;
    end
    else  begin
        finsh_2 <= finsh_1;
        finsh_3 <= finsh_2;
        finsh   <= finsh_3;
    end
end



endmodule