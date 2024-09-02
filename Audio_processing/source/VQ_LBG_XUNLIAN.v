
/*************
Author:wyx
Times :2024.8.4
VQ_LBG 训练码本
**************/



module VQ_LBG_XUNLIAN(
    input     wire              clk  ,
    input     wire              rst_n,

    input   wire                START/*synthesis PAP_MARK_DEBUG="1"*/,//开始训练
    output   wire               VQ_LBG_XUNLIAN_FINSH,//结束训练

    input     wire [12:0]       DCT_ADDR,
    input     wire  [8:0]       Frams_Number,
    output    wire  [12:0]      MFCCS13_ADDR,
    input     wire [13:0]       MFCCS13_DATA,

    output    wire [13:0]       LBG_data/*synthesis PAP_MARK_DEBUG="1"*/,
    output    wire [7:0]        LBG_addr/*synthesis PAP_MARK_DEBUG="1"*/,
    output    wire              LBG_en  /*synthesis PAP_MARK_DEBUG="1"*/
   );
/************************************************************************************/

wire         LBG_mean_FINSH/*synthesis PAP_MARK_DEBUG="1"*/;
wire  [12:0] LBG_mean_MFCCS13_ADDR;
wire [13:0]  LBG_init_data/*synthesis PAP_MARK_DEBUG="1"*/;
wire [3:0]   LBG_init_addr/*synthesis PAP_MARK_DEBUG="1"*/;
wire [7:0]   LBG_init_addr_1;
wire         LBG_init_en  /*synthesis PAP_MARK_DEBUG="1"*/;
wire         LBG_mean_EN;

assign LBG_init_addr_1={4'd0,LBG_init_addr};
//平均初始码本
LBG_mean LBG_mean(
.clk              (clk          ),
.rst_n            (rst_n        ),
.START            (START        ),
.FINSH            (LBG_mean_FINSH),
.DCT_ADDR         (DCT_ADDR     ),
.Frams_Number     (Frams_Number ),
.MFCCS13_ADDR     (LBG_mean_MFCCS13_ADDR ),
.MFCCS13_DATA     (MFCCS13_DATA ),
.LBG_mean_EN      (LBG_mean_EN),
.LBG_init_data    (LBG_init_data), 
.LBG_init_addr    (LBG_init_addr),
.LBG_init_en      (LBG_init_en)
   );

/************************************************************************************/

wire [13:0]       LBG_wr_data ;
wire [7:0]        LBG_wr_addr ;
wire              LBG_wr_en   ;
wire [13:0]       LBG_SPLIT_wr_data_1/*synthesis PAP_MARK_DEBUG="1"*/;
wire [7:0]        LBG_SPLIT_wr_addr_1/*synthesis PAP_MARK_DEBUG="1"*/;
wire              LBG_SPLIT_wr_en_1  /*synthesis PAP_MARK_DEBUG="1"*/;
wire [13:0]       panduan_genxing_LBG_wr_data;
wire  [7:0]       panduan_genxing_LBG_wr_addr;
wire              panduan_genxing_LBG_wr_en  ;

wire [13:0] VQ_LBG_rd_data ;
wire [7:0]  VQ_LBG_rd_addr ;
wire [7:0]  VQ_classify_LBG_rd_addr ;
wire [7:0] LBG_SPLIT_rd_addr ;


wire SPLIT_en   ;


assign LBG_wr_data =(LBG_mean_EN)?LBG_init_data  :(SPLIT_en)?LBG_SPLIT_wr_data_1 :panduan_genxing_LBG_wr_data;
assign LBG_wr_addr =(LBG_mean_EN)?LBG_init_addr_1:(SPLIT_en)?LBG_SPLIT_wr_addr_1 :panduan_genxing_LBG_wr_addr;
assign LBG_wr_en   =(LBG_mean_EN)?LBG_init_en    :(SPLIT_en)?LBG_SPLIT_wr_en_1   :panduan_genxing_LBG_wr_en  ;

assign VQ_LBG_rd_addr=(SPLIT_en)?LBG_SPLIT_rd_addr:VQ_classify_LBG_rd_addr;


//码本暂存器
VQ_LBG_16X13 VQ_LBG_16X13_1 (
  .wr_data    (LBG_wr_data    ),    // input [7:0]
  .wr_addr    (LBG_wr_addr    ),    // input [7:0]
  .wr_en      (LBG_wr_en      ),        // input
  .wr_clk     (clk            ),      // input
  .wr_rst     (!rst_n         ),      // input
  .rd_addr    (VQ_LBG_rd_addr ),    // input [7:0]
  .rd_data    (VQ_LBG_rd_data ),    // output [7:0]
  .rd_clk     (clk            ),      // input
  .rd_rst     (!rst_n         )       // input
);
/************************************************************************************/

wire SPLIT_START/*synthesis PAP_MARK_DEBUG="1"*/;
wire SPLIT_FINSH/*synthesis PAP_MARK_DEBUG="1"*/;
wire panduan_genxing_SPLIT_FINSH/*synthesis PAP_MARK_DEBUG="1"*/;
reg  [2:0]       CNT_FOR/*synthesis PAP_MARK_DEBUG="1"*/;

assign SPLIT_START=(CNT_FOR>='d4)?'d0:(LBG_mean_FINSH||panduan_genxing_SPLIT_FINSH);
assign VQ_LBG_XUNLIAN_FINSH=((CNT_FOR>='d4)&&panduan_genxing_SPLIT_FINSH)?'d1:'d0;


SPLIT SPLIT(
.clk                  (clk              ),
.rst_n                (rst_n            ),
.START                (SPLIT_START      ),
.FINSH                (SPLIT_FINSH      ),
.SPLIT_en             (SPLIT_en         ),
.LBG_SPLIT_wr_data    (LBG_SPLIT_wr_data_1),
.LBG_SPLIT_wr_addr    (LBG_SPLIT_wr_addr_1),
.LBG_SPLIT_wr_en      (LBG_SPLIT_wr_en_1  ),
.LBG_SPLIT_rd_data    (VQ_LBG_rd_data    ),
.LBG_SPLIT_rd_addr    (LBG_SPLIT_rd_addr)

   );
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
       CNT_FOR<='d0;
    end
    else if(SPLIT_FINSH)begin
       CNT_FOR<=CNT_FOR+'d1;
    end
    else begin
       CNT_FOR<=CNT_FOR;
    end
end
/************************************************************************************/
wire panduan_genxing_FINSH;

reg  VQ_classify_start;
wire VQ_classify_start_1;
wire VQ_classify_FINSH;
wire  [12:0] VQ_classify_MFCCS13_ADDR;
wire [40:0]       D   ;
wire              D_en;
wire [23:0]       VQ_rd_data;
wire [7:0]        VQ_rd_addr;
wire  [8:0]       Frams_Number_1 /*synthesis PAP_MARK_DEBUG="1"*/;
wire  [8:0]       Frams_Number_2 /*synthesis PAP_MARK_DEBUG="1"*/;
wire  [8:0]       Frams_Number_3 /*synthesis PAP_MARK_DEBUG="1"*/;
wire  [8:0]       Frams_Number_4 /*synthesis PAP_MARK_DEBUG="1"*/;
wire  [8:0]       Frams_Number_5 /*synthesis PAP_MARK_DEBUG="1"*/;
wire  [8:0]       Frams_Number_6 /*synthesis PAP_MARK_DEBUG="1"*/;
wire  [8:0]       Frams_Number_7 ;
wire  [8:0]       Frams_Number_8 ;
wire  [8:0]       Frams_Number_9 ;
wire  [8:0]       Frams_Number_10;
wire  [8:0]       Frams_Number_11;
wire  [8:0]       Frams_Number_12;
wire  [8:0]       Frams_Number_13;
wire  [8:0]       Frams_Number_14;
wire  [8:0]       Frams_Number_15;
wire  [8:0]       Frams_Number_16;
VQ_classify VQ_classify(
.clk              (clk           ),
.rst_n            (rst_n &&!VQ_classify_start_1        ),//开始前先清空
.START            (VQ_classify_start   ),
.FINSH            (VQ_classify_FINSH   ),
.Frams_Number     (Frams_Number  ),
.DCT_ADDR         (DCT_ADDR      ),
.CNT_FOR          (CNT_FOR      ),
.MFCCS13_ADDR     (VQ_classify_MFCCS13_ADDR  ),
.MFCCS13_DATA     (MFCCS13_DATA  ),
.LBG_rd_data      (VQ_LBG_rd_data   ),
.LBG_rd_addr      (VQ_classify_LBG_rd_addr   ),
.D                (D                        ),   
.D_en             (D_en                     ),
.VQ_rd_data      (VQ_rd_data     ),
.VQ_rd_addr      (VQ_rd_addr     ),
.Frams_Number_1  (Frams_Number_1 ),
.Frams_Number_2  (Frams_Number_2 ),
.Frams_Number_3  (Frams_Number_3 ),
.Frams_Number_4  (Frams_Number_4 ),
.Frams_Number_5  (Frams_Number_5 ),
.Frams_Number_6  (Frams_Number_6 ),
.Frams_Number_7  (Frams_Number_7 ),
.Frams_Number_8  (Frams_Number_8 ),
.Frams_Number_9  (Frams_Number_9 ),
.Frams_Number_10 (Frams_Number_10),
.Frams_Number_11 (Frams_Number_11),
.Frams_Number_12 (Frams_Number_12),
.Frams_Number_13 (Frams_Number_13),
.Frams_Number_14 (Frams_Number_14),
.Frams_Number_15 (Frams_Number_15),
.Frams_Number_16 (Frams_Number_16)
   );

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
       VQ_classify_start<='d0;
    end
    else begin
       VQ_classify_start<=VQ_classify_start_1;
    end
end
assign VQ_classify_start_1=SPLIT_FINSH||panduan_genxing_FINSH;
assign MFCCS13_ADDR=(LBG_mean_EN)?LBG_mean_MFCCS13_ADDR:VQ_classify_MFCCS13_ADDR ;


wire panduan_genxing_START;
reg  panduan_genxing_START_1;
wire while_en/*synthesis PAP_MARK_DEBUG="1"*/;

assign panduan_genxing_START=VQ_classify_FINSH;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
       panduan_genxing_START_1<='d0;
    end
    else begin
       panduan_genxing_START_1<=panduan_genxing_START;
    end
end

panduan_genxing panduan_genxing
(

.clk                 (clk                 ),        
.rst_n               (rst_n  &&!SPLIT_FINSH      ),     //当跳出迭代时清零       
.START               (panduan_genxing_START_1            ),
.SPLIT_FINSH         (panduan_genxing_SPLIT_FINSH        ),
.FINSH               (panduan_genxing_FINSH               ),
.CNT_FOR             (CNT_FOR           ),                  
.D                   (D                   ),
.D_en                (panduan_genxing_START_1                ),
.VQ_rd_data          (VQ_rd_data          ),
.VQ_rd_addr          (VQ_rd_addr          ),
.Frams_Number_1      (Frams_Number_1      ),
.Frams_Number_2      (Frams_Number_2      ),
.Frams_Number_3      (Frams_Number_3      ),
.Frams_Number_4      (Frams_Number_4      ),
.Frams_Number_5      (Frams_Number_5      ),
.Frams_Number_6      (Frams_Number_6      ),
.Frams_Number_7      (Frams_Number_7      ),
.Frams_Number_8      (Frams_Number_8      ),
.Frams_Number_9      (Frams_Number_9      ),
.Frams_Number_10     (Frams_Number_10     ),
.Frams_Number_11     (Frams_Number_11     ),
.Frams_Number_12     (Frams_Number_12     ),
.Frams_Number_13     (Frams_Number_13     ),
.Frams_Number_14     (Frams_Number_14     ),
.Frams_Number_15     (Frams_Number_15     ),
.Frams_Number_16     (Frams_Number_16     ),      
.LBG_wr_data         (panduan_genxing_LBG_wr_data),
.LBG_wr_addr         (panduan_genxing_LBG_wr_addr),
.LBG_wr_en           (panduan_genxing_LBG_wr_en  ),
.while_en            (while_en            )
);

assign LBG_data =panduan_genxing_LBG_wr_data ;
assign LBG_addr =panduan_genxing_LBG_wr_addr ;
assign LBG_en   =panduan_genxing_LBG_wr_en   ;



endmodule