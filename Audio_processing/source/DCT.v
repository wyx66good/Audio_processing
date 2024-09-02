/*************
Author:wyx
Times :2024.8.3
DCT
**************/


module DCT(

    input   wire              clk  ,
    input   wire              rst_n,

    input   wire               start,
    output  wire               FINSH,

    input   wire [17:0]        MFCC_LOG,
    output   wire [4:0]        MFCC_LOG_CNT,

    output  wire [13:0]        DCT_DATA,
    output  reg                DCT1_FINSH2

   );


reg        DCT_EN;
reg        DCT_EN_2;
reg        DCT_EN_3;

reg [26:0] DCT_DATA_2;
wire [31:0] DCT_DATA_3;
reg [31:0] DCT_DATA_ALL;
reg [3:0]  DCT_CNT;
reg [8:0]  CNT_312;
reg [8:0]  CNT_312_1;
reg [4:0]  CNT_24;
reg        DCT1_FINSH;

wire       DCT_FINSH;
reg        DCT_FINSH_2;
reg        DCT_FINSH_3;
wire [8:0] DCT_COS_DATA/*synthesis PAP_MARK_DEBUG="1"*/;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        DCT_EN <= 'd0;
    end
    else if(start)begin
        DCT_EN <= 'd1;
    end
    else if(DCT_FINSH)begin
        DCT_EN <= 'd0;
    end
    else begin
        DCT_EN <= DCT_EN;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        DCT_EN_2 <= 'd0;
        DCT_EN_3 <= 'd0;
    end
    else begin
        DCT_EN_2 <= DCT_EN;
        DCT_EN_3 <= DCT_EN_2;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||(DCT_CNT>'d13))begin
        DCT_CNT <= 'd0;
    end
    else if(DCT1_FINSH)begin
        DCT_CNT <= DCT_CNT+'d1;
    end
    else begin
        DCT_CNT <= DCT_CNT;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||(CNT_312=='d311))begin
        CNT_312 <= 'd0;
    end
    else if(DCT_EN&&(CNT_24!='d24))begin
        CNT_312 <= CNT_312+'d1;
    end
    else begin
        CNT_312 <= CNT_312;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||(CNT_24=='d23))begin
        CNT_24 <= 'd0;
    end
    else if(DCT_EN)begin
        CNT_24 <= CNT_24+'d1;
    end
    else begin
        CNT_24 <= CNT_24;
    end
end
wire [13:0]        DCT_DATA_1;
assign DCT_DATA_1=DCT_DATA_ALL>>>12;
assign DCT_DATA=(DCT1_FINSH2)?DCT_DATA_1:DCT_DATA;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        DCT_DATA_ALL <= 'd0;
    end
    else if((CNT_24=='d2)&&DCT_EN_3)begin
        DCT_DATA_ALL <= DCT_DATA_3;
    end
    else if(DCT_EN_3)begin
        DCT_DATA_ALL <= DCT_DATA_ALL+DCT_DATA_3;
    end
    else begin
        DCT_DATA_ALL <= DCT_DATA_ALL;
    end
end

wire [26:0] MFCC_LOG_1;
wire [26:0] DCT_COS_DATA_1;

assign MFCC_LOG_CNT=CNT_24;
assign MFCC_LOG_1={9'd0,MFCC_LOG};
assign DCT_COS_DATA_1={{18{DCT_COS_DATA[8]}},DCT_COS_DATA};

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        DCT_DATA_2 <= 'd0;
    end
    else begin
        DCT_DATA_2 <= DCT_COS_DATA_1*MFCC_LOG_1;
    end
end
assign DCT_DATA_3={{5{DCT_DATA_2[26]}},DCT_DATA_2};
assign DCT_FINSH=(CNT_312=='d311)?'d1:'d0;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        DCT1_FINSH <= 'd0;
    end
    else if(CNT_24=='d23) begin
        DCT1_FINSH <= 'd1;
    end
    else  begin
        DCT1_FINSH <= 'd0;
    end
end
reg DCT1_FINSH3;
reg DCT_FINSH_4;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        DCT1_FINSH3 <= 'd0;
        DCT1_FINSH2 <= 'd0;
        DCT_FINSH_2 <= 'd0;
        DCT_FINSH_3 <= 'd0;
        DCT_FINSH_4 <= 'd0;
    end
    else  begin
        DCT1_FINSH3 <= DCT1_FINSH;
        DCT1_FINSH2 <= DCT1_FINSH3;
        DCT_FINSH_2 <= DCT_FINSH;
        DCT_FINSH_3 <= DCT_FINSH_2;
        DCT_FINSH_4 <= DCT_FINSH_3;
    end
end

assign FINSH=(DCT_FINSH_4&&DCT1_FINSH2)?'d1:'d0;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        CNT_312_1 <= 'd0;
    end
    else begin
        CNT_312_1 <= CNT_312;
    end
end
DCT_COS DCT_COS (
  .addr(CNT_312_1),          // input [8:0]
  .clk(clk),            // input
  .rst(!rst_n),            // input
  .rd_data(DCT_COS_DATA)     // output [8:0]
);







endmodule