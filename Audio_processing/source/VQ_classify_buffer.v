
/*************
Author:wyx
Times :2024.8.9
VQ 缓存
**************/


module VQ_classify_buffer(
    input     wire              clk  ,
    input     wire              rst_n,

    input     wire              START,
    output    wire              FINSH,
    input     wire              VQ_finsh,

    input    wire [7:0]        MFCCS13_13_ADDR,
    input     wire [13:0]       MFCCS13_DATA   ,
    input    wire               MFCCS13_en     ,

    input     wire [4:0]        MIN_i          ,
    input     wire              MIN_EN         ,
    input     wire [40:0]       D              ,
    input     wire              D_en           ,

    output    wire [23:0]       VQ_rd_data,
    input     wire [7:0]        VQ_rd_addr,
    output    reg  [8:0]       Frams_Number_1 ,
    output    reg  [8:0]       Frams_Number_2 ,
    output    reg  [8:0]       Frams_Number_3 ,
    output    reg  [8:0]       Frams_Number_4 ,
    output    reg  [8:0]       Frams_Number_5 ,
    output    reg  [8:0]       Frams_Number_6 ,
    output    reg  [8:0]       Frams_Number_7 ,
    output    reg  [8:0]       Frams_Number_8 ,
    output    reg  [8:0]       Frams_Number_9 ,
    output    reg  [8:0]       Frams_Number_10,
    output    reg  [8:0]       Frams_Number_11,
    output    reg  [8:0]       Frams_Number_12,
    output    reg  [8:0]       Frams_Number_13,
    output    reg  [8:0]       Frams_Number_14,
    output    reg  [8:0]       Frams_Number_15,
    output    reg  [8:0]       Frams_Number_16

   );
reg VQ_classify_buffer_en/*synthesis PAP_MARK_DEBUG="1"*/;

reg  [13:0]       MFCCS13_DATA_1 /*synthesis PAP_MARK_DEBUG="1"*/;
reg  [7:0]   MFCCS13_13_ADDR_1/*synthesis PAP_MARK_DEBUG="1"*/;
reg  [7:0]   MFCCS13_13_ADDR_2;
reg          MFCCS13_wr_en  /*synthesis PAP_MARK_DEBUG="1"*/;
reg          MFCCS13_wr_en_1  ;

reg  [7:0]   MFCCS13_13_rd_ADDR;
reg  [7:0]   MFCCS13_13_rd_ADDR_1;
wire [13:0]  MFCCS13_13_rd_DATA;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        VQ_classify_buffer_en <= 'd0;
    end
    else if(START) begin
        VQ_classify_buffer_en <= 1'b1;
    end
    else if(FINSH) begin
        VQ_classify_buffer_en <= 1'b0;
    end
    else  begin
        VQ_classify_buffer_en <= VQ_classify_buffer_en;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
       MFCCS13_13_ADDR_1<='d0;
       MFCCS13_13_ADDR_2   <= 'd0;
       MFCCS13_wr_en_1   <= 'd0;
       MFCCS13_wr_en   <= 'd0;
       MFCCS13_13_rd_ADDR<='d0;
       MFCCS13_DATA_1   <='d0;
    end
    else begin
       MFCCS13_13_ADDR_2<=MFCCS13_13_ADDR;
       MFCCS13_13_ADDR_1<=MFCCS13_13_ADDR_2;
       MFCCS13_wr_en_1    <=MFCCS13_en  ;
       MFCCS13_wr_en    <=MFCCS13_wr_en_1  ;
       MFCCS13_DATA_1   <=MFCCS13_DATA;
       MFCCS13_13_rd_ADDR    <=MFCCS13_13_rd_ADDR_1  ;
    end
end

MFCCS13_RAM14X12 MFCCS13_RAM14X12 (
  .wr_data(MFCCS13_DATA_1),    // input [13:0]
  .wr_addr(MFCCS13_13_ADDR_1),    // input [4:0]
  .wr_en  (MFCCS13_wr_en  ),        // input
  .wr_clk(clk),      // input
  .wr_rst(!rst_n),      // input
  .rd_addr(MFCCS13_13_rd_ADDR),    // input [4:0]
  .rd_data(MFCCS13_13_rd_DATA),    // output [13:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst_n)       // input
);

reg  [23:0]  VQ_classify_wr_data/*synthesis PAP_MARK_DEBUG="1"*/;
wire [23:0]  MFCCS13_13_rd_DATA_1/*synthesis PAP_MARK_DEBUG="1"*/;
reg  [7:0]   VQ_classify_wr_addr;
reg  [7:0]   VQ_classify_wr_addr_1;
reg          VQ_classify_wr_en  ;
reg          VQ_classify_wr_en_1  ;
reg          VQ_classify_wr_en_2  ;
reg          VQ_classify_wr_en_3  ;

wire [23:0]  VQ_classify_rd_data/*synthesis PAP_MARK_DEBUG="1"*/;
reg  [7:0]   VQ_classify_rd_addr;

assign  MFCCS13_13_rd_DATA_1={{10{MFCCS13_13_rd_DATA[13]}},MFCCS13_13_rd_DATA};

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||(MFCCS13_13_rd_ADDR_1=='d12))begin
        MFCCS13_13_rd_ADDR_1 <= 'd0;
    end
    else if(VQ_classify_wr_en) begin
        MFCCS13_13_rd_ADDR_1 <= MFCCS13_13_rd_ADDR_1+'d1;
    end
    else  begin
        MFCCS13_13_rd_ADDR_1 <= 'd0;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||(MFCCS13_13_rd_ADDR_1=='d12))begin
        VQ_classify_wr_en <= 'd0;
    end
    else if(MIN_EN) begin
        VQ_classify_wr_en <= 1'b1;
    end
    else  begin
        VQ_classify_wr_en <= VQ_classify_wr_en;
    end
end

always@(posedge clk)
begin
    case (MIN_i)
        5'd1 : VQ_classify_rd_addr<=MFCCS13_13_rd_ADDR_1;
        5'd2 : VQ_classify_rd_addr<=MFCCS13_13_rd_ADDR_1+8'd13;
        5'd3 : VQ_classify_rd_addr<=MFCCS13_13_rd_ADDR_1+8'd26;
        5'd4 : VQ_classify_rd_addr<=MFCCS13_13_rd_ADDR_1+8'd39;
        5'd5 : VQ_classify_rd_addr<=MFCCS13_13_rd_ADDR_1+8'd52;
        5'd6 : VQ_classify_rd_addr<=MFCCS13_13_rd_ADDR_1+8'd65;
        5'd7 : VQ_classify_rd_addr<=MFCCS13_13_rd_ADDR_1+8'd78;
        5'd8 : VQ_classify_rd_addr<=MFCCS13_13_rd_ADDR_1+8'd91;
        5'd9 : VQ_classify_rd_addr<=MFCCS13_13_rd_ADDR_1+8'd104;
        5'd10: VQ_classify_rd_addr<=MFCCS13_13_rd_ADDR_1+8'd117;
        5'd11: VQ_classify_rd_addr<=MFCCS13_13_rd_ADDR_1+8'd130;
        5'd12: VQ_classify_rd_addr<=MFCCS13_13_rd_ADDR_1+8'd143;
        5'd13: VQ_classify_rd_addr<=MFCCS13_13_rd_ADDR_1+8'd156;
        5'd14: VQ_classify_rd_addr<=MFCCS13_13_rd_ADDR_1+8'd169;
        5'd15: VQ_classify_rd_addr<=MFCCS13_13_rd_ADDR_1+8'd182;
        5'd16: VQ_classify_rd_addr<=MFCCS13_13_rd_ADDR_1+8'd195;
        default: VQ_classify_rd_addr<='d0;
    endcase

end


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        Frams_Number_1 <='d0;
        Frams_Number_2 <='d0;
        Frams_Number_3 <='d0;
        Frams_Number_4 <='d0;
        Frams_Number_5 <='d0;
        Frams_Number_6 <='d0;
        Frams_Number_7 <='d0;
        Frams_Number_8 <='d0;
        Frams_Number_9 <='d0;
        Frams_Number_10<='d0;
        Frams_Number_11<='d0;
        Frams_Number_12<='d0;
        Frams_Number_13<='d0;
        Frams_Number_14<='d0;
        Frams_Number_15<='d0;
        Frams_Number_16<='d0;
    end
    else if((MIN_i=='d1)&&MIN_EN) begin
        Frams_Number_1 <= Frams_Number_1+1'b1;
    end
    else if((MIN_i=='d2)&&MIN_EN) begin
        Frams_Number_2 <= Frams_Number_2+1'b1;
    end
    else if((MIN_i=='d3)&&MIN_EN) begin
        Frams_Number_3 <= Frams_Number_3+1'b1;
    end
    else if((MIN_i=='d4)&&MIN_EN) begin
        Frams_Number_4 <= Frams_Number_4+1'b1;
    end
    else if((MIN_i=='d5)&&MIN_EN) begin
        Frams_Number_5 <= Frams_Number_5+1'b1;
    end
    else if((MIN_i=='d6)&&MIN_EN) begin
        Frams_Number_6 <= Frams_Number_6+1'b1;
    end
    else if((MIN_i=='d7)&&MIN_EN) begin
        Frams_Number_7 <= Frams_Number_7+1'b1;
    end
    else if((MIN_i=='d8)&&MIN_EN) begin
        Frams_Number_8 <= Frams_Number_8+1'b1;
    end
    else if((MIN_i=='d9)&&MIN_EN) begin
        Frams_Number_9 <= Frams_Number_9+1'b1;
    end
    else if((MIN_i=='d10)&&MIN_EN) begin
        Frams_Number_10 <= Frams_Number_10+1'b1;
    end
    else if((MIN_i=='d11)&&MIN_EN) begin
        Frams_Number_11 <= Frams_Number_11+1'b1;
    end
    else if((MIN_i=='d12)&&MIN_EN) begin
        Frams_Number_12 <= Frams_Number_12+1'b1;
    end
    else if((MIN_i=='d13)&&MIN_EN) begin
        Frams_Number_13 <= Frams_Number_13+1'b1;
    end
    else if((MIN_i=='d14)&&MIN_EN) begin
        Frams_Number_14 <= Frams_Number_14+1'b1;
    end
    else if((MIN_i=='d15)&&MIN_EN) begin
        Frams_Number_15 <= Frams_Number_15+1'b1;
    end
    else if((MIN_i=='d16)&&MIN_EN) begin
        Frams_Number_16 <= Frams_Number_16+1'b1;
    end
    else  begin
        Frams_Number_1 <=Frams_Number_1 ;
        Frams_Number_2 <=Frams_Number_2 ;
        Frams_Number_3 <=Frams_Number_3 ;
        Frams_Number_4 <=Frams_Number_4 ;
        Frams_Number_5 <=Frams_Number_5 ;
        Frams_Number_6 <=Frams_Number_6 ;
        Frams_Number_7 <=Frams_Number_7 ;
        Frams_Number_8 <=Frams_Number_8 ;
        Frams_Number_9 <=Frams_Number_9 ;
        Frams_Number_10<=Frams_Number_10;
        Frams_Number_11<=Frams_Number_11;
        Frams_Number_12<=Frams_Number_12;
        Frams_Number_13<=Frams_Number_13;
        Frams_Number_14<=Frams_Number_14;
        Frams_Number_15<=Frams_Number_15;
        Frams_Number_16<=Frams_Number_16;
    end
end









always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        VQ_classify_wr_addr <= 'd0;
        VQ_classify_wr_addr_1 <= 'd0;
        VQ_classify_wr_en_1 <= 'd0;
        VQ_classify_wr_en_2 <= 'd0;
        VQ_classify_wr_en_3 <= 'd0;

    end
    else  begin
        VQ_classify_wr_addr <= VQ_classify_rd_addr;
        VQ_classify_wr_addr_1 <= VQ_classify_wr_addr;
        VQ_classify_wr_en_1 <= VQ_classify_wr_en;
        VQ_classify_wr_en_2 <= VQ_classify_wr_en_1;
        VQ_classify_wr_en_3 <= VQ_classify_wr_en_2;

    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        VQ_classify_wr_data <= 'd0;
    end
    else if(VQ_classify_buffer_en) begin
        VQ_classify_wr_data <= VQ_classify_rd_data+MFCCS13_13_rd_DATA_1;
    end
//    else if(VQ_classify_buffer_en) begin
//        VQ_classify_wr_data <= VQ_classify_rd_data+MFCCS13_13_rd_DATA_1;
//    end
    else  begin
        VQ_classify_wr_data <= 'd0;
    end
end
wire [23:0]  VQ_rd_data_1;
wire [7:0]   VQ_rd_addr_1/*synthesis PAP_MARK_DEBUG="1"*/;

assign VQ_classify_rd_data=VQ_rd_data_1;
assign VQ_rd_data         =VQ_rd_data_1;

assign VQ_rd_addr_1=(VQ_classify_buffer_en)?VQ_classify_rd_addr:VQ_rd_addr;
/************************************************************************************/
//手动复位清空，不知道为什么官方ram IP复位后ram并没有清空？？？？？
wire [23:0]  VQ_classify_wr_data_rst  ; 
reg  [7:0]   VQ_classify_wr_addr_1_rst;
reg          VQ_classify_wr_en_3_rst   ; 
assign  VQ_classify_wr_data_rst=24'd0;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        VQ_classify_wr_en_3_rst <= 'd1;
    end
    else if(VQ_classify_wr_addr_1_rst=='d208) begin
        VQ_classify_wr_en_3_rst <= 'd0;
    end
    else  begin
        VQ_classify_wr_en_3_rst <= VQ_classify_wr_en_3_rst;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||(VQ_classify_wr_addr_1_rst=='d208))begin
        VQ_classify_wr_addr_1_rst <= 'd0;
    end
    else if(VQ_classify_wr_en_3_rst) begin
        VQ_classify_wr_addr_1_rst <= VQ_classify_wr_addr_1_rst+'d1;
    end
    else  begin
        VQ_classify_wr_addr_1_rst <= 'd0;
    end
end

wire [23:0]wr_data;
wire [7:0] wr_addr;
wire       wr_en  ;
assign wr_data=(VQ_classify_wr_en_3_rst)?VQ_classify_wr_data_rst  :VQ_classify_wr_data   ;
assign wr_addr=(VQ_classify_wr_en_3_rst)?VQ_classify_wr_addr_1_rst:VQ_classify_wr_addr_1 ;
assign wr_en  =(VQ_classify_wr_en_3_rst)?VQ_classify_wr_en_3_rst  :VQ_classify_wr_en_3   ;
/************************************************************************************/


VQ_classify_ram VQ_classify_ram (
  .wr_data  (wr_data),    // input [23:0]
  .wr_addr  (wr_addr),    // input [7:0]
  .wr_en    (wr_en  ),        // input
  .wr_clk   (clk),      // input
  .wr_rst   (!rst_n),      // input
  .rd_addr  (VQ_rd_addr_1),    // input [7:0]
  .rd_data  (VQ_rd_data_1),    // output [23:0]
  .rd_clk   (clk),      // input
//  .rd_clk_en(rd_clk_en),
  .rd_rst   (!rst_n)       // input
);
reg VQ_finsh_1;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        VQ_finsh_1 <= 'd0;
    end
    else if(VQ_finsh) begin
        VQ_finsh_1 <='d1;
    end
    else  begin
        VQ_finsh_1 <= VQ_finsh_1;
    end
end

assign FINSH=(VQ_finsh_1&&(MFCCS13_13_rd_ADDR_1=='d12))?'d1:'d0;




endmodule