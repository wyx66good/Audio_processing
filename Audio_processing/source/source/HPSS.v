
/*************
Author:wyx
Times :2024.7.3
HPSS人声分离
**************/
module HPSS#(
    parameter DATA_WIDTH = 16
)
(
    input                           clk,
    input                           rst_n,

//    output wire                     en,

    input wire                     voice_clk_in ,
    input wire                     voice_rst_in ,
    input wire                     voice_en_in  /*synthesis PAP_MARK_DEBUG="1"*/,
    input wire  [DATA_WIDTH - 1:0] voice_data_in/*synthesis PAP_MARK_DEBUG="1"*/,

    output wire [11:0]             wr_water_level,

    input  wire                     voice_clk_out ,
    input  wire                     voice_rst_out ,
    input  wire                     voice_en_out  /*synthesis PAP_MARK_DEBUG="1"*/,
    output wire  [DATA_WIDTH - 1:0] voice_data_out/*synthesis PAP_MARK_DEBUG="1"*/,

    output wire [11:0]              rd_water_level_out/*synthesis PAP_MARK_DEBUG="1"*/

   );
/************************************************************************************/
wire finsh_Framing_hpss_512;
wire start_Framing_hpss_512;
wire fft_finish;
wire finsh_power;
wire finsh_s_h;
wire ifft_finish;
wire finsh_tiaozhi;

wire [11:0] rd_water_level/*synthesis PAP_MARK_DEBUG="1"*/;
wire       w_FFT_ON;

/************************************************************************************/

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
        ST_8:begin//输出一拍
                fsm_n <= ST_1;
        end
        ST_9:begin//分帧
            if(rd_water_level>='d511)
                fsm_n<=ST_1;
            else
                fsm_n <= ST_9;
        end
        ST_1:begin//分帧
            if(start_Framing_hpss_512)
                fsm_n<=ST_2;
            else
                fsm_n <= ST_1;
        end
        ST_2:begin//
            if(finsh_Framing_hpss_512 )
                fsm_n<=ST_3;
            else
                fsm_n <= ST_2;
        end
        ST_3:begin//fft
            if(fft_finish )
                fsm_n<=ST_4;
            else
                fsm_n <= ST_3;
        end
        ST_4:begin//
            if(finsh_power )
                fsm_n<=ST_5;
            else
                fsm_n <= ST_4;
        end
        ST_5:begin//s_h
            if(finsh_s_h )
                fsm_n<=ST_6;
            else
                fsm_n <= ST_5;
        end
        ST_6:begin
            if(ifft_finish )
                fsm_n<=ST_7;
            else
                fsm_n <= ST_6;
        end
        ST_7:begin//调制滤波
            if(finsh_tiaozhi )
                fsm_n<=ST_9;
            else
                fsm_n <= ST_7;
        end
        default:
                fsm_n <= ST_9;
    endcase
end
/************************************************************************************/


/************************************************************************************/
wire         Framing_hpss_512_wr/*synthesis PAP_MARK_DEBUG="1"*/;
wire [15:0]  Framing_hpss_512_data/*synthesis PAP_MARK_DEBUG="1"*/;
wire         en_data;
wire [15:0]  R_Framing_hpss_512_data;
wire  [23:0]  R_Framing_hpss_512_data_1;


wire [7:0]   hanning_data;
wire [23:0]   hanning_data_2;
reg  [9:0]   hanning_i   ;


wire R_Framing_hpss_512_en;
reg [23:0]   data_x_hanning_1;
wire [15:0]   data_x_hanning_2;

Framing_hpss_512#(
   .DATA_WIDTH (16)
)u_Framing_hpss_512
(
.clk        (clk),
.rst_n      (rst_n),
.en         (en_data),
.start      (start_Framing_hpss_512),
.finsh      (finsh_Framing_hpss_512 ),
.wr_en      (Framing_hpss_512_wr    ),
.wr_data    (Framing_hpss_512_data  ),
.rd_en      (R_Framing_hpss_512_en  ),
.rd_data    (R_Framing_hpss_512_data)
);

//Framing_hpss_ram  a_ram(
//  .wr_data(a_adta_wr),    // input [15:0]
//  .wr_addr(a_addr_wr),    // input [9:0]
//  .wr_en(a_ram_wr),        // input
//  .wr_clk(clk),      	  // input
//  .wr_rst(!rst_n),        // input
//  .rd_addr(a_rd_addr),    // input [9:0]
//  .rd_data(a_rd_data),    // output [15:0]
//  .rd_clk(clk),      	  // input
//  .rd_rst(!rst_n)         // input
//);


hanning hanning( 
.clk   (clk), 
.i     (hanning_i),
.data  (hanning_data)
   );


assign R_Framing_hpss_512_en = (fsm_c==ST_2)?'d1:'d0;
assign en_data  =   (rd_water_level>='d511) ? 'd1:'d0;


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
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

assign data_x_hanning_2=data_x_hanning_1>>>8;



wire [15:0]     data_fft_in;
wire            start_fft;
wire            fft_en   ;
wire [63:0]     data_fft_out;
reg  [9:0]      addr_fft_out;



assign data_fft_in=data_x_hanning_2;
assign start_fft  = R_Framing_hpss_512_en;


 fft_ip fft_ip(
 .i_clk               (clk)   ,
 .i_rstn              (rst_n)  ,
 .i_axi4s_cfg_tdata   ('d1)  ,//fft 1,iff,0
 .fft_finish          (fft_finish)  ,
 .rd_clk              (clk)  ,                  
 .data                ({16'd0,data_fft_in})  ,
 .start				  (start_fft),
 .data_en             (fft_en)  ,//落后两拍
 .ifft_data           ()        ,
 .ifft_en             ()  ,                      
 .data_out            (data_fft_out)  ,
 .fft_addr            (addr_fft_out)
 );




wire [31:0]     data_fft_out_real;
wire [31:0]     data_fft_out_real_1;
reg  [63:0]     data_fft_out_real_power;//功率谱

assign data_fft_out_real=data_fft_out[31:0];
assign data_fft_out_real_1= (data_fft_out_real[31])? ~data_fft_out_real+'d1:data_fft_out_real;


always@(posedge clk or negedge rst_n)//打一拍
begin
    if(!rst_n)
        data_fft_out_real_power <= 'd0;
    else
        data_fft_out_real_power <= data_fft_out_real_1*data_fft_out_real_1;
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        addr_fft_out <= 'd0;
    else if((fsm_c==ST_4)||w_FFT_ON)
        addr_fft_out <= addr_fft_out+'d1;
    else
        addr_fft_out <= 'd0;
end

assign finsh_power = (addr_fft_out=='d1023);







/************************************************************************************/


/************************************************************************************/
 reg                             wr_en_Median;    
 wire [63:0]                   wr_data_Median;

 wire [3:0]               fsm_Median;

 wire         [63:0]      rd_data_1  ;
 wire         [9:0]       rd_addr_1  ;
 wire         [63:0]      rd_data_2  ;
 wire         [9:0]       rd_addr_2  ;
 wire         [63:0]      rd_data_3  ;
 wire         [9:0]       rd_addr_3  ;
 wire         [63:0]      rd_data_4  ;
 wire         [9:0]       rd_addr_4  ;
 wire         [63:0]      rd_data_5  ;
 wire         [9:0]       rd_addr_5  ;
 wire         [63:0]      rd_data_6  ;
 wire         [9:0]       rd_addr_6  ;
 wire         [63:0]      rd_data_7  ;
 wire         [9:0]       rd_addr_7  ;
 wire         [63:0]      rd_data_8  ;
 wire         [9:0]       rd_addr_8  ;
 wire         [63:0]      rd_data_9  ;
 wire         [9:0]       rd_addr_9  ;


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        wr_en_Median <= 'd0;
    else if(fsm_c==ST_4)
        wr_en_Median <= 'd1;
    else
        wr_en_Median <= 'd0;
end
assign wr_data_Median  = data_fft_out_real_power;

Median_filtering Median_filtering(
.clk           (clk       ),
.rst_n         (rst_n     ),
.wr_en         (wr_en_Median     ),
.wr_data       (wr_data_Median   ),

.fsm_n         (fsm_Median),


.rd_data_1     (rd_data_1 ),
.rd_addr_1     (rd_addr_1 ),
.rd_data_2     (rd_data_2 ),
.rd_addr_2     (rd_addr_2 ),
.rd_data_3     (rd_data_3 ),
.rd_addr_3     (rd_addr_3 ),
.rd_data_4     (rd_data_4 ),
.rd_addr_4     (rd_addr_4 ),
.rd_data_5     (rd_data_5 ),
.rd_addr_5     (rd_addr_5 ),
.rd_data_6     (rd_data_6 ),
.rd_addr_6     (rd_addr_6 ),
.rd_data_7     (rd_data_7 ),
.rd_addr_7     (rd_addr_7 ),
.rd_data_8     (rd_data_8 ),
.rd_addr_8     (rd_addr_8 ),
.rd_data_9     (rd_data_9 ),
.rd_addr_9     (rd_addr_9 )

   );


wire [63:0]rd_data_H;
wire [9:0] rd_addr_H;
wire [63:0]rd_data_P;
wire [9:0] rd_addr_P;

S_H S_H(
.clk            (clk       ),
.rst_n          (rst_n     ),
.statr          (!(fsm_c==ST_5)&&(fsm_n==ST_5)),
.fsm_Median     (fsm_Median),
.finsh_s_h      (finsh_s_h),

.rd_data_1     (rd_data_1 ),
.rd_addr_1     (rd_addr_1 ),
.rd_data_2     (rd_data_2 ),
.rd_addr_2     (rd_addr_2 ),
.rd_data_3     (rd_data_3 ),
.rd_addr_3     (rd_addr_3 ),
.rd_data_4     (rd_data_4 ),
.rd_addr_4     (rd_addr_4 ),
.rd_data_5     (rd_data_5 ),
.rd_addr_5     (rd_addr_5 ),
.rd_data_6     (rd_data_6 ),
.rd_addr_6     (rd_addr_6 ),
.rd_data_7     (rd_data_7 ),
.rd_addr_7     (rd_addr_7 ),
.rd_data_8     (rd_data_8 ),
.rd_addr_8     (rd_addr_8 ),
.rd_data_9     (rd_data_9 ),
.rd_addr_9     (rd_addr_9 ),

.rd_data_H     (rd_data_H),
.rd_addr_H     (rd_addr_H),
.rd_data_P     (rd_data_P),
.rd_addr_P     (rd_addr_P)

);

/************************************************************************************/
wire [63:0] data_out_ifft;
wire [9:0]  fft_addr_ifft;
iFFT_hpss iFFT_hpss(
.clk            (clk),
.rst_n          (rst_n),
.start          (fsm_n==ST_6),
.ifft_finish    (ifft_finish),
. w_FFT_ON      (w_FFT_ON),
. w_fft_data    (data_fft_out),    
.rd_data_H      (rd_data_H),
.rd_addr_H      (rd_addr_H),
.rd_data_P      (rd_data_P),
.rd_addr_P      (rd_addr_P),
.data_out_ifft  (data_out_ifft),
.fft_addr_ifft  (fft_addr_ifft)   
   );

wire[15:0]   x_h_1/*synthesis PAP_MARK_DEBUG="1"*/;
wire         x_h_1_en/*synthesis PAP_MARK_DEBUG="1"*/;

 tiaozhi tiaozhi(
.clk          (clk),     
.rst_n        (rst_n),
.finsh        (), 
.p_data       (data_out_ifft),
.p_wr_addr    (fft_addr_ifft),
.p_wr_en      ((fsm_n==ST_7)||(fsm_c==ST_7)),
.x_h_1         (x_h_1),
.x_h_1_en      (x_h_1_en),
.finsh_tiaozhi(finsh_tiaozhi)
	);


/************************************************************************************/
vocie_change_fifo1 u_HPSS_fifo_in (
  .wr_clk                         (voice_clk_in ),                    // input
  .wr_rst                         (!voice_rst_in ),                    // input
  .wr_en                          (voice_en_in  ),                      // input
  .wr_data                        (voice_data_in),                  // input [15:0]
  .wr_full                        (),                  // output
  .wr_water_level                 (wr_water_level),    // output [11:0]
  .almost_full                    (),          // output
  .rd_clk                         (clk ),                    // input
  .rd_rst                         (!rst_n ),                    // input
  .rd_en                          (Framing_hpss_512_wr ),                      // input
  .rd_data                        (Framing_hpss_512_data),                  // output [15:0]
  .rd_empty                       (),                // output
  .rd_water_level                 (rd_water_level),    // output [11:0]
  .almost_empty                   ()         // output
);

wire [11:0] wr_water_level_out;
vocie_change_fifo1 u_HPSS_fifo_out (
  .wr_clk                         (clk),                    // input
  .wr_rst                         (!rst_n),                    // input
  .wr_en                          (x_h_1_en   ),                      // input
  .wr_data                        (x_h_1),                  // input [15:0]
  .wr_full                        (),                  // output
  .wr_water_level                 (wr_water_level_out),    // output [11:0]
  .almost_full                    (),          // output
  .rd_clk                         ( voice_clk_out ),                    // input
  .rd_rst                         ( !voice_rst_out ),                    // input
  .rd_en                          ( voice_en_out  ),                      // input
  .rd_data                        ( voice_data_out),                  // output [15:0]
  .rd_empty                       (),                // output
  .rd_water_level                 (rd_water_level_out),    // output [11:0]
  .almost_empty                   ()         // output
);




//assign en=(fsm_c==ST_6);







endmodule