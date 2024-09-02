
/*************
Author:wyx
Times :2024.8.9
VQ识别
**************/


module VQ_identifys(
    input     wire              clk  ,
    input     wire              rst_n,

    input   wire                VQ_identifys_start,//开始识别
    output   wire               VQ_identifys_finsh,//结束识别

    input     wire [12:0]       DCT_ADDR,
    input     wire  [8:0]       Frams_Number,

    output    wire   [12:0]     MFCCS13_ADDR,
    input     wire [13:0]       MFCCS13_DATA,

    output    wire [7:0]        LBG_rd_addr_1,
    input     wire [13:0]       LBG_rd_data_1,

    output    reg  [2:0]        CNT         ,
    output    wire [3:0]        D_MIN       ,
    output    wire              D_MIN_FINSH

   );
wire [40:0] D;
wire        D_en/*synthesis PAP_MARK_DEBUG="1"*/;
reg  [40:0] D1/*synthesis PAP_MARK_DEBUG="1"*/;
reg  [40:0] D2/*synthesis PAP_MARK_DEBUG="1"*/;
reg  [40:0] D3/*synthesis PAP_MARK_DEBUG="1"*/;
reg  [40:0] D4/*synthesis PAP_MARK_DEBUG="1"*/;
wire VQ_start;
reg VQ_start_1;
reg VQ_finsh;


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||(VQ_finsh&&(CNT=='d4)))begin
       CNT<='d0;
    end
    else if(VQ_finsh)begin
       CNT<=CNT+'d1;
    end
    else begin
       CNT<=CNT;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
       D1<='d0;
    end
    else if(VQ_finsh&&(CNT=='d0))begin
       D1<=D;
    end
    else begin
       D1<=D1;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
       D2<='d0;
    end
    else if(VQ_finsh&&(CNT=='d1))begin
       D2<=D;
    end
    else begin
       D2<=D2;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
       D3<='d0;
    end
    else if(VQ_finsh&&(CNT=='d2))begin
       D3<=D;
    end
    else begin
       D3<=D3;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
       D4<='d0;
    end
    else if(VQ_finsh&&(CNT=='d3))begin
       D4<=D;
    end
    else begin
       D4<=D4;
    end
end

reg VQ_start_2;
wire VQ_finsh_1;
reg  VQ_finsh_2;

assign VQ_start=(VQ_identifys_start||(VQ_finsh&&(CNT=='d0))||(VQ_finsh&&(CNT=='d1))||(VQ_finsh&&(CNT=='d2)))?'d1:'d0;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
       VQ_start_1<='d0;
       VQ_start_2<='d0;
       VQ_finsh<='d0;
       VQ_finsh_2<='d0;

    end
    else begin
       VQ_start_1<=VQ_start;
       VQ_start_2<=VQ_start_1;
       VQ_finsh<=VQ_finsh_1;
       VQ_finsh_2<=VQ_finsh;

    end
end

VQ VQ(
.clk          (clk          ),
.rst_n        (rst_n  &&!VQ_start_1      ),
.VQ_start     (VQ_start_2     ),
.VQ_finsh     (VQ_finsh_1     ),
.DCT_ADDR     (DCT_ADDR     ),
.CNT_FOR      ('d4          ),
.Frams_Number (Frams_Number ),
.MFCCS13_ADDR (MFCCS13_ADDR ),
.MFCCS13_DATA (MFCCS13_DATA ),
.LBG_rd_data_1(LBG_rd_data_1),
.LBG_rd_addr_1(LBG_rd_addr_1),
.D            (D            ),
.D_en         (D_en         )
   );
wire [4:0] MIN_i;
wire MIN_en;
MIN4 #(
.DATA_WIDTH(41)
)MIN4
(
.clk                 (clk             ),   
.rst_n               (rst_n           ),    
.distance_DATA1      (D1 ),
.distance_DATA_2     (D2 ),
.distance_DATA_3     (D3 ),
.distance_DATA_4     (D4 ),                
.distance_EN_1       (VQ_finsh_2&&(CNT=='d4)  ),
.distance_EN_2       (VQ_finsh_2&&(CNT=='d4)  ),
.distance_EN_3       (VQ_finsh_2&&(CNT=='d4)  ),
.distance_EN_4       (VQ_finsh_2&&(CNT=='d4)  ),            
.MIN_1_1             (         ),
.MIN_1_1_i           (MIN_i       ),
.MIN_1_1_en          (MIN_en      )
);
assign D_MIN_FINSH=MIN_en;
assign VQ_identifys_finsh=MIN_en;
assign D_MIN=(MIN_i=='d1)?4'b0001:(MIN_i=='d2)?4'b0010:(MIN_i=='d3)?4'b0100:(MIN_i=='d4)?4'b1000:4'b0000;

endmodule