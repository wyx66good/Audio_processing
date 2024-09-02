/*************
Author:wyx
Times :2024.8.2
MFCC系数
**************/

module MFCC_DCT(

    input   wire              clk  ,
    input   wire              rst_n,
    
    input   wire              start,
    output  wire              DCT_FINSH,

    input   wire [63:0]      fft_data,
    output  wire [9:0]       fft_addr,

    output  wire [13:0] DCT_DATA,
    output  wire        DCT1_FINSH2

    
   );
wire                finsh;
wire [40:0]         MFCC1 ; 
wire [40:0]         MFCC2 ; 
wire [40:0]         MFCC3 ; 
wire [40:0]         MFCC4 ; 
wire [40:0]         MFCC5 ; 
wire [40:0]         MFCC6 ; 
wire [40:0]         MFCC7 ; 
wire [40:0]         MFCC8 ; 
wire [40:0]         MFCC9 ; 
wire [40:0]         MFCC10; 
wire [40:0]         MFCC11; 
wire [40:0]         MFCC12; 
wire [40:0]         MFCC13; 
wire [40:0]         MFCC14; 
wire [40:0]         MFCC15; 
wire [40:0]         MFCC16; 
wire [40:0]         MFCC17; 
wire [40:0]         MFCC18; 
wire [40:0]         MFCC19; 
wire [40:0]         MFCC20; 
wire [40:0]         MFCC21; 
wire [40:0]         MFCC22; 
wire [40:0]         MFCC23; 
wire [40:0]         MFCC24; 



MFCC u_MFCC(
.clk      (clk),
.rst_n    (rst_n),
.start    (start),
.finsh    (finsh),
.fft_data (fft_data),
.fft_addr (fft_addr),
.MFCC1    (MFCC1 ),
.MFCC2    (MFCC2 ),
.MFCC3    (MFCC3 ),
.MFCC4    (MFCC4 ),
.MFCC5    (MFCC5 ),
.MFCC6    (MFCC6 ),
.MFCC7    (MFCC7 ),
.MFCC8    (MFCC8 ),
.MFCC9    (MFCC9 ),
.MFCC10   (MFCC10),
.MFCC11   (MFCC11),
.MFCC12   (MFCC12),
.MFCC13   (MFCC13),
.MFCC14   (MFCC14),
.MFCC15   (MFCC15),
.MFCC16   (MFCC16),
.MFCC17   (MFCC17),
.MFCC18   (MFCC18),
.MFCC19   (MFCC19),
.MFCC20   (MFCC20),
.MFCC21   (MFCC21),
.MFCC22   (MFCC22),
.MFCC23   (MFCC23),
.MFCC24   (MFCC24) 
   );


reg         MFCC_LOG_EN;
reg [40:0]  MFCC_IN/*synthesis PAP_MARK_DEBUG="1"*/;
reg     [4:0]   fsm_c;
reg     [4:0]   fsm_n;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        fsm_c <= 'd1;
    else
        fsm_c <= fsm_n;
end
always@(*)
begin
    case(fsm_c)
        'd1:begin//输出一拍
            if(finsh )begin
                fsm_n<='d2;
                MFCC_LOG_EN<='d1;
            end
            else begin
                fsm_n <= 'd1;
                MFCC_LOG_EN<='d0;
            end
            MFCC_IN<=MFCC1;
        end
        'd2:begin//分帧
            fsm_n <= 'd3;
            MFCC_IN<=MFCC2;
        end
        'd3:begin//分帧
            fsm_n<='d4;
            MFCC_IN<=MFCC3;
        end
        'd4:begin//
            fsm_n <= 'd5;
            MFCC_IN<=MFCC4;
        end
        'd5:begin//
            fsm_n <= 'd6;
            MFCC_IN<=MFCC5;
        end
        'd6:begin//MFCC
            fsm_n <= 'd7;
            MFCC_IN<=MFCC6;
        end
        'd7:begin//MFCC
            fsm_n <= 'd8;
            MFCC_IN<=MFCC7;
        end
        'd8:begin//MFCC
            fsm_n <= 'd9;
            MFCC_IN<=MFCC8;
        end
        'd9:begin//MFCC
            fsm_n <= 'd10;
            MFCC_IN<=MFCC9;
        end
        'd10:begin//MFCC
            fsm_n <= 'd11;
            MFCC_IN<=MFCC10;
        end
        'd11:begin//MFCC
            fsm_n <= 'd12;
            MFCC_IN<=MFCC11;
        end
        'd12:begin//MFCC
            fsm_n <= 'd13;
            MFCC_IN<=MFCC12;
        end
        'd13:begin//MFCC
            fsm_n <= 'd14;
            MFCC_IN<=MFCC13;
        end
        'd14:begin//MFCC
            fsm_n <= 'd15;
            MFCC_IN<=MFCC14;
        end
        'd15:begin//MFCC
            fsm_n <= 'd16;
            MFCC_IN<=MFCC15;
        end
        'd16:begin//MFCC
            fsm_n <= 'd17;
            MFCC_IN<=MFCC16;
        end
        'd17:begin//MFCC
            fsm_n <= 'd18;
            MFCC_IN<=MFCC17;
        end
        'd18:begin//MFCC
            fsm_n <= 'd19;
            MFCC_IN<=MFCC18;
        end
        'd19:begin//MFCC
            fsm_n <= 'd20;
            MFCC_IN<=MFCC19;
        end
        'd20:begin//MFCC
            fsm_n <= 'd21;
            MFCC_IN<=MFCC20;
        end
        'd21:begin//MFCC
            fsm_n <= 'd22;
            MFCC_IN<=MFCC21;
        end
        'd22:begin//MFCC
            fsm_n <= 'd23;
            MFCC_IN<=MFCC22;
        end
        'd23:begin//MFCC
            fsm_n <= 'd24;
            MFCC_IN<=MFCC23;
        end
        'd24:begin//MFCC
            fsm_n <= 'd1;
            MFCC_IN<=MFCC24;
        end
        default:
                fsm_n <= 'd1;
    endcase
end

wire [40:0]  MFCC_IN_1/*synthesis PAP_MARK_DEBUG="1"*/;
wire        MFCC_LOG_OUT_EN/*synthesis PAP_MARK_DEBUG="1"*/;
reg         MFCC_LOG_OUT_EN_1;
wire [17:0] MFCC_LOG_DATA/*synthesis PAP_MARK_DEBUG="1"*/;
wire [7:0]  MFCC_LOG_DATA_Z;
wire [9:0]  MFCC_LOG_DATA_X;
assign MFCC_IN_1=(MFCC_IN=='d0)?41'd1:MFCC_IN;
LOG10 LOG10(
.clk		(clk),
.rst_n      (rst_n),
.i_en       (MFCC_LOG_EN),
.data_in    (MFCC_IN_1),
.o_en       (MFCC_LOG_OUT_EN),
.data_out   (MFCC_LOG_DATA)
	);

assign MFCC_LOG_DATA_Z=MFCC_LOG_DATA[17:10];
assign MFCC_LOG_DATA_X=MFCC_LOG_DATA[9:0];

wire [17:0] MFCC_LOG;
reg [7:0] MFCC_LOG_CNT;
wire [4:0] MFCC_LOG_CNT_out;
MFCC_LOG_RAM18X24 MFCC_LOG_RAM18X24 (
  .wr_data(MFCC_LOG_DATA),    // input [17:0]
  .wr_addr({3'd0,MFCC_LOG_CNT}),    // input [4:0]
  .wr_en(MFCC_LOG_OUT_EN),        // input
  .wr_clk(clk),      // input
  .wr_rst(!rst_n),      // input
  .rd_addr({3'd0,MFCC_LOG_CNT_out}),    // input [4:0]
  .rd_data(MFCC_LOG),    // output [17:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst_n)       // input
);
wire MFCC_LOG_OUT_FINSH;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||(MFCC_LOG_OUT_FINSH))
        MFCC_LOG_CNT <= 'd0;
    else if(MFCC_LOG_OUT_EN)
        MFCC_LOG_CNT <= MFCC_LOG_CNT+'d1;
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        MFCC_LOG_OUT_EN_1 <= 'd0;
    else
        MFCC_LOG_OUT_EN_1 <= MFCC_LOG_OUT_EN;
end




assign MFCC_LOG_OUT_FINSH=(MFCC_LOG_OUT_EN_1&&!MFCC_LOG_OUT_EN)?'d1:'d0;

DCT DCT(
 .clk         (clk),     
 .rst_n       (rst_n),     
 .start       (MFCC_LOG_OUT_FINSH),  
 .FINSH       (DCT_FINSH),   
 .MFCC_LOG    (MFCC_LOG),
 .MFCC_LOG_CNT(MFCC_LOG_CNT_out),
 .DCT_DATA    (DCT_DATA),
 .DCT1_FINSH2 (DCT1_FINSH2)
   );


endmodule