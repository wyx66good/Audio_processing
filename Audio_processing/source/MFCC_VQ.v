/*************
Author:wyx
Times :2024.7.28
MFCC_VQ声纹识别
**************/

module MFCC_VQ#(
    parameter DATA_WIDTH = 16
)(
    input                           clk,
    input                           rst_n,

    input wire                     voice_clk_in ,
    input wire                     voice_rst_in ,
    input wire                     voice_en_in  /*synthesis PAP_MARK_DEBUG="1"*/,
    input wire  [DATA_WIDTH - 1:0] voice_data_in,

    input wire                     anew,
    input wire                     VQ_START/*synthesis PAP_MARK_DEBUG="1"*/,//提取mfcc
    input wire                     VQ_STOP/*synthesis PAP_MARK_DEBUG="1"*/,//结束提取
    input wire                     XUNLIAN_START/*synthesis PAP_MARK_DEBUG="1"*/,//训练
    input wire                     VQ_identify/*synthesis PAP_MARK_DEBUG="1"*/,//识别
    input wire                     LBG_1/*synthesis PAP_MARK_DEBUG="1"*/,//选择lbg训练人
    input wire                     LBG_2/*synthesis PAP_MARK_DEBUG="1"*/,//选择lbg训练人
    input wire                     LBG_3/*synthesis PAP_MARK_DEBUG="1"*/,//选择lbg训练人
    input wire                     LBG_4/*synthesis PAP_MARK_DEBUG="1"*/,//选择lbg训练人

    output wire                    VQ_LBG_XUNLIAN_FINSH_led,
    output wire                    VQ_identifys_finsh_led,

    output wire [3:0]               VQ_D,

    output wire [11:0] wr_water_level/*synthesis PAP_MARK_DEBUG="1"*/
   );


wire        voice_pre_en/*synthesis PAP_MARK_DEBUG="1"*/;
wire [15:0] voice_pre_data/*synthesis PAP_MARK_DEBUG="1"*/;
wire        Framing_hpss_512_wr/*synthesis PAP_MARK_DEBUG="1"*/;
wire [15:0] Framing_hpss_512_data/*synthesis PAP_MARK_DEBUG="1"*/;
//wire [11:0] wr_water_level/*synthesis PAP_MARK_DEBUG="1"*/;
wire [11:0] rd_water_level/*synthesis PAP_MARK_DEBUG="1"*/;
wire        finsh_Framing_hpss_512;
wire        start_Framing_hpss_512;
wire        PA_SUM_finsh;
reg [5:0]   CNT_SHATR/*synthesis PAP_MARK_DEBUG="1"*/;
wire        voiced/*synthesis PAP_MARK_DEBUG="1"*/;
wire        fft_finish;
wire        MFCC_FINSH;
wire        VQ_LBG_XUNLIAN_FINSH/*synthesis PAP_MARK_DEBUG="1"*/;
wire        VQ_identifys_finsh/*synthesis PAP_MARK_DEBUG="1"*/;




assign VQ_LBG_XUNLIAN_FINSH_led=VQ_LBG_XUNLIAN_FINSH;
assign VQ_identifys_finsh_led=VQ_identifys_finsh;

reg VQ_START_1;
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)
        VQ_START_1 <= 'd0;
    else
        VQ_START_1 <= VQ_START;
end

/************************************************************************************/
localparam ST_1          = 5'b00001;
localparam ST_2          = 5'b00010;
localparam ST_3          = 5'b00100;
localparam ST_4          = 5'b01000;
localparam ST_5          = 5'b10000;
localparam ST_6          = 5'b10001;
localparam ST_7          = 5'b10011;
localparam ST_8          = 5'b10101;
localparam ST_9          = 5'b11001;
localparam ST_10          = 5'b11011;

reg     [4:0]   fsm_c;
reg     [4:0]   fsm_n/*synthesis PAP_MARK_DEBUG="1"*/;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        fsm_c <= ST_8;
    else
        fsm_c <= fsm_n;
end
always@(*)
begin
    case(fsm_c)
        ST_1:begin//输出一拍
                    fsm_n <= ST_9;
        end
        ST_9:begin//输出一拍
//               if(VQ_START)
//                    fsm_n <= ST_2;
//               else 
               if(VQ_STOP)
                    fsm_n <= ST_8;
               else 
                    fsm_n <= ST_2;    
        end
        ST_2:begin//分帧
             if(VQ_STOP)
                fsm_n <= ST_8;
            else if(wr_water_level>='d511)
                fsm_n<=ST_3;
            else
                fsm_n <= ST_2;
        end
        ST_3:begin//分帧
             if(VQ_STOP)
                fsm_n <= ST_8;
            else if(start_Framing_hpss_512)
                fsm_n<=ST_4;

            else
                fsm_n <= ST_3;
        end
        ST_4:begin//
            if(VQ_STOP)
                fsm_n <= ST_8;

            else if(finsh_Framing_hpss_512 )
                fsm_n<=ST_5;
            else
                fsm_n <= ST_4;
        end
        ST_5:begin//
            if(VQ_STOP)
                fsm_n <= ST_8;
            else if(PA_SUM_finsh && CNT_SHATR<'d32 )
                fsm_n<=ST_2;
            else if(CNT_SHATR>='d32 &&voiced &&fft_finish )
                fsm_n<=ST_6;
            else if(CNT_SHATR>='d32 && !voiced &&fft_finish)//判断清浊音
                fsm_n<=ST_2;
            else
                fsm_n <= ST_5;
        end
        ST_6:begin//MFCC
            if(VQ_STOP)
                fsm_n <= ST_8;
            else if(MFCC_FINSH )
                fsm_n<=ST_2;
             
            else
                fsm_n <= ST_6;
        end
        ST_7:begin//训练
            if(VQ_LBG_XUNLIAN_FINSH)
                fsm_n<=ST_8;
            else
                fsm_n <= ST_7;
        end
        ST_10:begin//识别
            if(VQ_identifys_finsh)
                fsm_n<=ST_8;
            else
                fsm_n <= ST_10;
        end
        ST_8:begin//模式选择 提取mmfcc 训练 识别
            if(VQ_START_1)//提取mfcc
                fsm_n<=ST_1;
            else if(XUNLIAN_START)//训练
                fsm_n<=ST_7;
            else if(VQ_identify)//识别
                fsm_n<=ST_10;
            else
                fsm_n <= ST_8;
        end
        default:
                fsm_n <= ST_8;
    endcase
end
/************************************************************************************/


////预加重
//pre_add #(
//    .DATA_WIDTH(DATA_WIDTH)
//)pre_add
//(
//.clk      (voice_clk_in),
//.rst_n    (voice_rst_in&&!VQ_START),
//.data_in  (voice_data_in),  
//.en       (voice_en_in),
//.data_out (voice_pre_data),
//.en_out	  (voice_pre_en)
//);
wire MFCC_VQ_FIFO_rst;

assign MFCC_VQ_FIFO_rst=!voice_rst_in ||VQ_START;
//缓存
MFCC_VQ_FIFO u_MFCC_VQ_fifo (
  .wr_clk                         (voice_clk_in ),                    // input
  .wr_rst                         (MFCC_VQ_FIFO_rst),                    // input
  .wr_en                          ( voice_en_in ),                      // input
  .wr_data                        (voice_data_in),                  // input [15:0]
  .wr_full                        (),                  // output
  .wr_water_level                 (wr_water_level),    // output [11:0]
  .almost_full                    (),          // output
  .rd_clk                         (clk ),                    // input
  .rd_rst                         (MFCC_VQ_FIFO_rst),                    // input
  .rd_en                          (Framing_hpss_512_wr),                      // input Framing_hpss_512_wr
  .rd_data                        (Framing_hpss_512_data),                  // output [15:0]
  .rd_empty                       (),                // output
  .rd_water_level                 (rd_water_level),    // output [11:0]
  .almost_empty                   ()         // output
);
//分帧
wire R_Framing_hpss_512_en/*synthesis PAP_MARK_DEBUG="1"*/;
wire [15:0]  R_Framing_hpss_512_data/*synthesis PAP_MARK_DEBUG="1"*/;
Framing_hpss_512#(
   .DATA_WIDTH (16)
)u_Framing_hpss_512
(
.clk        (clk),
.rst_n      (rst_n&&!VQ_START),
.en         (en_data),
.start      (start_Framing_hpss_512),
.finsh      (finsh_Framing_hpss_512 ),
.wr_en      (Framing_hpss_512_wr    ),
.wr_data    (Framing_hpss_512_data  ),
.rd_en      (R_Framing_hpss_512_en  ),
.rd_data    (R_Framing_hpss_512_data)
);
assign R_Framing_hpss_512_en = (fsm_c==ST_4)?'d1:'d0;
wire  [23:0]  R_Framing_hpss_512_data_1;
wire [7:0]   hanning_data;
wire [23:0]   hanning_data_2;
reg  [9:0]   hanning_i   ;
reg [23:0]   data_x_hanning_1;
wire [15:0]   data_x_hanning_2/*synthesis PAP_MARK_DEBUG="1"*/;

hanning hanning( 
.clk   (clk), 
.i     (hanning_i),
.data  (hanning_data)
   );


assign en_data  =   (rd_water_level>='d511) ? 'd1:'d0;


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||VQ_START)
        hanning_i <= 'd0;
    else if(R_Framing_hpss_512_en)
        hanning_i <= hanning_i+'d1;
    else
        hanning_i <= 'd0;
end


assign hanning_data_2={{16{0}},hanning_data};
assign R_Framing_hpss_512_data_1={{8{R_Framing_hpss_512_data[15]}},R_Framing_hpss_512_data};


always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)
        data_x_hanning_1 <= 'd0;
    else
        data_x_hanning_1 <= hanning_data_2*R_Framing_hpss_512_data_1;
end

assign data_x_hanning_2=data_x_hanning_1>>8;

reg R_Framing_hpss_512_en_1;
reg R_Framing_hpss_512_en_2;

always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        R_Framing_hpss_512_en_1 <= 'd0;
        R_Framing_hpss_512_en_2 <= 'd0;
    end
    else begin
        R_Framing_hpss_512_en_1 <= R_Framing_hpss_512_en;
        R_Framing_hpss_512_en_2 <= R_Framing_hpss_512_en_1;
    end
end

wire [25:0] PA_SUM_OUT;
PA_init #(
    .DATA_WIDTH(DATA_WIDTH)
)PA_init
(
.clk              (clk),
.rst_n            (rst_n&&!VQ_START),
.data_in          (data_x_hanning_2),  
.en               (R_Framing_hpss_512_en_2),
.PA_SUM_OUT       (PA_SUM_OUT),
.PA_SUM_finsh	  (PA_SUM_finsh)
)
;

//开始32帧

always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||VQ_START)begin
        CNT_SHATR <= 'd0;
    end
    else if(PA_SUM_finsh && CNT_SHATR<'d32) begin
        CNT_SHATR <= CNT_SHATR+'d1;
    end
    else begin
        CNT_SHATR <= CNT_SHATR;
    end
end
reg  [30:0] PA_SUM_OUT_all/*synthesis PAP_MARK_DEBUG="1"*/;
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||VQ_START)begin
        PA_SUM_OUT_all <= 'd0;
    end
    else if(PA_SUM_finsh && CNT_SHATR<'d32) begin
        PA_SUM_OUT_all <= PA_SUM_OUT_all+PA_SUM_OUT;
    end
    else begin
        PA_SUM_OUT_all <= PA_SUM_OUT_all;
    end
end
wire  [25:0] Q_PA;
wire        PA_FINSH;
Divider #
(
.A_LEN(31),
.B_LEN(7)
)divide32_x_h
(
		.CLK(clk),
		.EN(PA_SUM_finsh && CNT_SHATR=='d31 ),
		.RSTN(rst_n),
		.Dividend(PA_SUM_OUT_all),
		.Divisor({1'b0,CNT_SHATR}),
		.Quotient(Q_PA),
		.Mod(),
		.RDY(PA_FINSH)
);

reg  [25:0] PA_judge/*synthesis PAP_MARK_DEBUG="1"*/;
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||VQ_START)begin
        PA_judge <= 'd0;
    end
    else if(PA_FINSH) begin
        PA_judge <= Q_PA+'d450;
    end
    else begin
        PA_judge <= PA_judge;
    end
end

//判断的
reg  [25:0] PA/*synthesis PAP_MARK_DEBUG="1"*/;
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||VQ_START)begin
        PA <= 'd0;
    end
    else if(PA_SUM_finsh&&CNT_SHATR>='d32) begin
        PA <= PA_SUM_OUT;
    end
    else begin
        PA <= PA;
    end
end
assign voiced=(PA>PA_judge)&&(CNT_SHATR>='d32)?'d1:'d0;



//FFT
wire [63:0] data_fft_out;
wire [9:0] addr_fft_out;
wire start_fft;
wire fft_en;
 fft_ip fft_ip(
 .i_clk               (clk)   ,
 .i_rstn              (rst_n)  ,
 .i_axi4s_cfg_tdata   ('d1)  ,//fft 1,iff,0
 .fft_finish          (fft_finish)  ,
 .rd_clk              (clk)  ,                  
 .data                ({16'd0,data_x_hanning_2})  ,
 .start				  (start_fft),
 .data_en             (fft_en)  ,//落后两拍
 .ifft_data           ()        ,
 .ifft_en             ()  ,                      
 .data_out            (data_fft_out)  ,
 .fft_addr            (addr_fft_out)
 );

assign start_fft=(R_Framing_hpss_512_en&&CNT_SHATR>='d32)?'d1:'d0;

//MFCC系数

wire [13:0] DCT_DATA    /*synthesis PAP_MARK_DEBUG="1"*/;
wire        DCT1_FINSH2 /*synthesis PAP_MARK_DEBUG="1"*/;
reg  [12:0] DCT_ADDR/*synthesis PAP_MARK_DEBUG="1"*/;
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||VQ_START)begin
        DCT_ADDR <= 'd0;
    end
    else if(DCT1_FINSH2) begin
        DCT_ADDR <= DCT_ADDR+'d1;
    end
    else begin
        DCT_ADDR <= DCT_ADDR;
    end
end

MFCC_DCT u_MFCC_DCT(
.clk         (clk),
.rst_n       (rst_n&&!VQ_START),
.start       ((fsm_n==ST_6)&&!(fsm_c==ST_6)),
.DCT_FINSH   (MFCC_FINSH),
.fft_data    (data_fft_out),
.fft_addr    (addr_fft_out),
.DCT_DATA    (DCT_DATA),
.DCT1_FINSH2 (DCT1_FINSH2)
   );

wire [12:0] MFCCS13_ADDR;
wire [13:0] MFCCS13_DATA;

wire [12:0]VQ_LBG_XUNLIAN_MFCCS13_ADDR;
wire [13:0]VQ_LBG_XUNLIAN_MFCCS13_DATA;

wire [12:0]VQ_identifys_MFCCS13_ADDR;
wire [13:0]VQ_identifys_MFCCS13_DATA;


assign MFCCS13_ADDR=((fsm_n == ST_7)||(fsm_c == ST_7))?VQ_LBG_XUNLIAN_MFCCS13_ADDR:VQ_identifys_MFCCS13_ADDR;
assign VQ_LBG_XUNLIAN_MFCCS13_DATA=MFCCS13_DATA;
assign VQ_identifys_MFCCS13_DATA=MFCCS13_DATA;

MFCCS13_RAM MFCCS13_RAM (
  .wr_data  (DCT_DATA        ),    // input [13:0]
  .wr_addr  (DCT_ADDR        ),    // input [12:0]
  .wr_en    (DCT1_FINSH2     ),        // input
  .wr_clk   (clk             ),      // input
  .wr_rst   (!rst_n  ||VQ_START        ),      // input
  .rd_addr  (MFCCS13_ADDR    ),    // input [12:0]
  .rd_data  (MFCCS13_DATA    ),    // output [13:0]
  .rd_clk   (clk             ),      // input
  .rd_rst   (!rst_n   ||VQ_START       )       // input
);
wire  [12:0] Quotient_Frams/*synthesis PAP_MARK_DEBUG="1"*/;
reg   [8:0] Frams_Number/*synthesis PAP_MARK_DEBUG="1"*/;
wire        Frams_Finsh;
Divider #
(
.A_LEN(14),
.B_LEN(5)
)divide32_Frams
(
		.CLK(clk),
		.EN(VQ_STOP ),
		.RSTN(rst_n),
		.Dividend({'d0,DCT_ADDR}),
		.Divisor(5'd13),
		.Quotient(Quotient_Frams),
		.Mod(),
		.RDY(Frams_Finsh)
);
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n||VQ_START)begin
        Frams_Number <= 'd0;
    end
    else if(Frams_Finsh) begin
        Frams_Number <= Quotient_Frams[8:0];
    end
    else begin
        Frams_Number <= Frams_Number;
    end
end


wire [13:0]       LBG_data/*synthesis PAP_MARK_DEBUG="1"*/;
wire [7:0]        LBG_addr/*synthesis PAP_MARK_DEBUG="1"*/;
wire              LBG_en  /*synthesis PAP_MARK_DEBUG="1"*/;
reg XUNLIAN_START_1;
reg XUNLIAN_START_2;
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        XUNLIAN_START_1 <= 'd0;
        XUNLIAN_START_2 <= 'd0;
    end
    else begin
        XUNLIAN_START_1 <= XUNLIAN_START;
        XUNLIAN_START_2 <= XUNLIAN_START_1;
    end
end
VQ_LBG_XUNLIAN u_VQ_LBG_XUNLIAN(
.clk                 (clk          ),
.rst_n               (rst_n   && !XUNLIAN_START    ),
.START               (XUNLIAN_START_2         ),//Frams_Finsh
.VQ_LBG_XUNLIAN_FINSH(VQ_LBG_XUNLIAN_FINSH),
.DCT_ADDR            (DCT_ADDR     ),
.Frams_Number        (Frams_Number ),
.MFCCS13_ADDR        (VQ_LBG_XUNLIAN_MFCCS13_ADDR ),
.MFCCS13_DATA        (VQ_LBG_XUNLIAN_MFCCS13_DATA ),
.LBG_data            (LBG_data),
.LBG_addr            (LBG_addr),
.LBG_en              (LBG_en  )
   );




wire [13:0]LBG_rd_data_1;
wire [7:0] LBG_rd_addr_1;
wire [13:0]LBG_rd_data_2;
wire [7:0] LBG_rd_addr_2;
wire [13:0]LBG_rd_data_3;
wire [7:0] LBG_rd_addr_3;
wire [13:0]LBG_rd_data_4;
wire [7:0] LBG_rd_addr_4;



//码本 1
wire LBG_16X13_1_en;
assign LBG_16X13_1_en=(LBG_en &&LBG_1)?'d1:'d0;
LBG_16X13 LBG_16X13_1 (
  .wr_data    (LBG_data),    // input [7:0]
  .wr_addr    (LBG_addr),    // input [7:0]
  .wr_en      (LBG_16X13_1_en ),        // input
  .wr_clk     (clk            ),      // input
  .wr_rst     (!rst_n         ),      // input
  .rd_addr    (LBG_rd_addr_1 ),    // input [7:0]
  .rd_data    (LBG_rd_data_1 ),    // output [7:0]
  .rd_clk     (clk            ),      // input
  .rd_rst     (!rst_n          )       // input
);

wire LBG_16X13_2_en;
assign LBG_16X13_2_en=(LBG_en &&LBG_2)?'d1:'d0;
//码本 2
LBG_16X13_2 LBG_16X13_2 (
  .wr_data    (LBG_data),    // input [7:0]
  .wr_addr    (LBG_addr),    // input [7:0]
  .wr_en      (LBG_16X13_2_en ),        // input
  .wr_clk     (clk            ),      // input
  .wr_rst     (!rst_n        ),      // input
  .rd_addr    (LBG_rd_addr_2 ),    // input [7:0]
  .rd_data    (LBG_rd_data_2 ),    // output [7:0]
  .rd_clk     (clk            ),      // input
  .rd_rst     (!rst_n         )       // input
);
wire LBG_16X13_3_en;
assign LBG_16X13_3_en=(LBG_en &&LBG_3)?'d1:'d0;
//码本 3
LBG_16X13_3 LBG_16X13_3 (
  .wr_data    (LBG_data),    // input [7:0]
  .wr_addr    (LBG_addr),    // input [7:0]
  .wr_en      (LBG_16X13_3_en ),        // input
  .wr_clk     (clk            ),      // input
  .wr_rst     (!rst_n        ),      // input
  .rd_addr    (LBG_rd_addr_3 ),    // input [7:0]
  .rd_data    (LBG_rd_data_3 ),    // output [7:0]
  .rd_clk     (clk            ),      // input
  .rd_rst     (!rst_n         )       // input
);
wire LBG_16X13_4_en;
assign LBG_16X13_4_en=(LBG_en &&LBG_4)?'d1:'d0;
//码本 4
LBG_16X13_4 LBG_16X13_4 (
  .wr_data    (LBG_data),    // input [7:0]
  .wr_addr    (LBG_addr),    // input [7:0]
  .wr_en      (LBG_16X13_4_en ),        // input
  .wr_clk     (clk            ),      // input
  .wr_rst     (!rst_n        ),      // input
  .rd_addr    (LBG_rd_addr_4 ),    // input [7:0]
  .rd_data    (LBG_rd_data_4 ),    // output [7:0]
  .rd_clk     (clk            ),      // input
  .rd_rst     (!rst_n         )       // input
);

//LBG_16X13_rom1_1 LBG_16X13_1 (
//  .addr       (LBG_rd_addr_1 ),    // input [7:0]
//  .rd_data    (LBG_rd_data_1_1 ),    // output [7:0]
//  .clk     (clk            ),      // input
//  .rst     (!rst_n          )       // input
//);
//LBG_16X13_rom_2 LBG_16X13_2 (
//  .addr       (LBG_rd_addr_2 ),    // input [7:0]
//  .rd_data    (LBG_rd_data_2_1 ),    // output [7:0]
//  .clk     (clk            ),      // input
//  .rst     (!rst_n          )       // input
//);
//LBG_16X13_rom1_3 LBG_16X13_3 (
//  .addr       (LBG_rd_addr_3 ),    // input [7:0]
//  .rd_data    (LBG_rd_data_3_1 ),    // output [7:0]
//  .clk     (clk            ),      // input
//  .rst     (!rst_n          )       // input
//);
//LBG_16X13_rom1_4 LBG_16X13_4 (
//  .addr       (LBG_rd_addr_4 ),    // input [7:0]
//  .rd_data    (LBG_rd_data_4_1 ),    // output [7:0]
//  .clk     (clk            ),      // input
//  .rst     (!rst_n          )       // input
//);
//欧式距离
wire       VQ_identifys_start;
reg        VQ_identifys_start_1;
wire [7:0] LBG_rd_addr/*synthesis PAP_MARK_DEBUG="1"*/;
wire [13:0]LBG_rd_data/*synthesis PAP_MARK_DEBUG="1"*/;
wire [2:0] VQ_identifys_CNT/*synthesis PAP_MARK_DEBUG="1"*/;
wire [3:0] D_MIN       ;
assign VQ_identifys_start=((fsm_n==ST_10)&&!(fsm_c==ST_10))?'d1:'d0;
always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)begin
        VQ_identifys_start_1 <= 'd0;
    end
    else begin
        VQ_identifys_start_1 <= VQ_identifys_start;
    end
end
VQ_identifys VQ_identifys1(
.clk  			   ( clk  ),
.rst_n             ( rst_n&&!VQ_identifys_start),
.VQ_identifys_start( VQ_identifys_start_1 ), //开始识别
.VQ_identifys_finsh( VQ_identifys_finsh), //结束识别
.DCT_ADDR          (DCT_ADDR ),
.Frams_Number      (Frams_Number),
.MFCCS13_ADDR      (VQ_identifys_MFCCS13_ADDR ),
.MFCCS13_DATA      (VQ_identifys_MFCCS13_DATA ),
.LBG_rd_addr_1     (LBG_rd_addr ),
.LBG_rd_data_1     (LBG_rd_data),
.CNT               (VQ_identifys_CNT),   
.D_MIN             (VQ_D           ),
.D_MIN_FINSH       (     )
   );


assign LBG_rd_addr_1=LBG_rd_addr;
assign LBG_rd_addr_2=LBG_rd_addr;
assign LBG_rd_addr_3=LBG_rd_addr;
assign LBG_rd_addr_4=LBG_rd_addr;

assign LBG_rd_data=(VQ_identifys_CNT=='d0)?LBG_rd_data_1:(VQ_identifys_CNT=='d1)?LBG_rd_data_2:
                   (VQ_identifys_CNT=='d2)?LBG_rd_data_3:(VQ_identifys_CNT=='d3)?LBG_rd_data_4:'d0;

endmodule