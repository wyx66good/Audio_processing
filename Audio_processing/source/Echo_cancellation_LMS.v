/*************
Author:wyx
Times :2024.6.15
回声消除-lms
**************/

module Echo_cancellation_LMS#(
    parameter DATA_WIDTH = 16
)
(
    input                           clk,
    input                           rst_n,

    input wire                     voice_clk_in_x ,
    input wire                     voice_rst_in_x ,
    input wire                     voice_en_in_x  ,
    input wire  [DATA_WIDTH - 1:0] voice_data_in_x,

    input wire                     voice_clk_in_d ,
    input wire                     voice_rst_in_d ,
    input wire                     voice_en_in_d  ,
    input wire  [DATA_WIDTH - 1:0] voice_data_in_d,


    input  wire                     voice_clk_out ,
    input  wire                     voice_rst_out ,
    input  wire                     voice_en_out  ,
    output wire  [DATA_WIDTH - 1:0] voice_data_out,
    
    input wire lms_on,
    output wire full,
    output wire [11:0] rd_water_level_1
   );

wire [11:0] wr_water_level_x;
wire [11:0] rd_water_level_x/*synthesis PAP_MARK_DEBUG="1"*/;
wire [11:0] wr_water_level_d;
wire [11:0] rd_water_level_d/*synthesis PAP_MARK_DEBUG="1"*/;

wire updata_finsh;
wire finsh_w_update;
wire dot_finsh;


localparam ST_in                  = 5'b00000;
localparam ST_start               = 5'b00001;
localparam ST_up_u                = 5'b00010;
localparam ST_dot                 = 5'b00100;
localparam ST_in_1                = 5'b01000;
//localparam ST_dot                 = 5'b10000;
localparam ST_finsh               = 5'b10001;

reg     [4:0]   fsm_c;
reg     [4:0]   fsm_n;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        fsm_c <= ST_in;
    else
        fsm_c <= fsm_n;
end
always@(*)
begin
    case(fsm_c) 
        ST_in:
                fsm_n<=ST_in_1;  
        ST_in_1:
                fsm_n<=ST_start;  
        ST_start:
            if(rd_water_level_x>='d5&&rd_water_level_d>='d5&&rd_water_level_1<='d2000)//
                fsm_n<=ST_up_u;
            else
                fsm_n<=ST_start;        
        ST_up_u:
            if(updata_finsh)//
                fsm_n<=ST_dot;
            else
                fsm_n<=ST_up_u;    
        ST_dot:
            if(dot_finsh)//
                fsm_n<=ST_finsh;
            else
                fsm_n<=ST_dot;    
        ST_finsh:
            if(finsh_w_update)//
                fsm_n<=ST_start;
            else
                fsm_n<=ST_finsh;      
        default:
                fsm_n <= ST_start;
    endcase
end

////////////////////////测试
reg rd_en;
reg [8:0]addr;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        rd_en <= 1'b0;
    end
    else if(fsm_c==ST_start)begin
        rd_en <= 1'b0;
    end
    else if(updata_finsh)begin
        rd_en <= 1'b1;
    end
    else begin
        rd_en <= rd_en;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||updata_finsh)begin
        addr <= 'd0;
    end
    else if(rd_en)begin
        addr <= addr+'d1;
    end
    else begin
        addr <= addr;
    end
end
assign voice_change_finsh=(addr=='d511)?'d1:'d0;

//////////////////////测试
wire rd_en_x;
wire [15:0] rd_data_x;
wire rd_en_d;
wire [15:0] rd_data_d;
wire [8:0]  rd_addr_w;
wire [58:0]  rd_data_w;
wire [15:0]  rd_data_u;
wire         w_update_en;
wire         e_n_en/*synthesis PAP_MARK_DEBUG="1"*/;
wire [15:0]  e_n_data/*synthesis PAP_MARK_DEBUG="1"*/;
wire [40:0]  sumu;
dot#(
    .DATA_WIDTH (16)
)u_dot
(
.clk                (clk),
.rst_n              (rst_n),
.en_x               (rd_en_x),
.data_x             (rd_data_x),
.en_d               (rd_en_d),  
.data_d             (rd_data_d),  
.addr_w1            (rd_addr_w),
.data_w1            (rd_data_w),//rd_data_w
.rd_data1           (rd_data_u ),
.w_update_en        (w_update_en),
.updata_finsh       (updata_finsh),
.finsh              (dot_finsh),
.Clear              (fsm_c==ST_start),
.up_u_en            (fsm_c==ST_up_u),
.dot_en             (fsm_n==ST_dot),
.e_n_en             (e_n_en),
.e_n_data           (e_n_data),
.sumu               (sumu)
   );
     

 w_updata#(
    .DATA_WIDTH (16)
)u_w_updata
(
 .clk           (clk),
 .rst_n         (rst_n),
 .rd_data_w2     (rd_data_w),
 .rd_data_u     (rd_data_u),
 .rd_addr_u     (rd_addr_w),
 .w_update_en   (w_update_en),
 .w_update_start(fsm_n==ST_finsh),
 .e_n_data      (e_n_data),
 .Clear         (fsm_c==ST_start),
 .finsh         (finsh_w_update),
 .sumu          (sumu)
   );





wire wr_full/*synthesis PAP_MARK_DEBUG="1"*/;
wire almost_full/*synthesis PAP_MARK_DEBUG="1"*/;
wire rd_empty;
wire almost_empty; 
wire wr_full_d;
wire almost_full_d;
wire rd_empty_d;
wire almost_empty_d; 
wire rd_empty_1/*synthesis PAP_MARK_DEBUG="1"*/;
wire wr_full_1/*synthesis PAP_MARK_DEBUG="1"*/;

assign full=wr_full&&wr_full_d;
LMS_FIFO u_LMS_FIFO (
  .wr_clk(voice_clk_in_x),                    // input
  .wr_rst(!voice_rst_in_x),                    // input
  .wr_en(voice_en_in_x),                      // input
  .wr_data(voice_data_in_x),                  // input [15:0]
  .wr_full(wr_full),                  // output
  .wr_water_level(wr_water_level_x),    // output [11:0]
  .almost_full(almost_full),          // output
  .rd_clk(clk),                    // input
  .rd_rst(!rst_n),                    // input
  .rd_en(rd_en_x),                      // input
  .rd_data(rd_data_x),                  // output [15:0]
  .rd_empty(rd_empty),                // output
  .rd_water_level(rd_water_level_x),    // output [11:0]
  .almost_empty(almost_empty)         // output
);


LMS_FIFO u_LMS_FIFO_d (
  .wr_clk(voice_clk_in_d),                    // input
  .wr_rst(!voice_rst_in_d),                    // input
  .wr_en(voice_en_in_d),                      // input
  .wr_data(voice_data_in_d),                  // input [15:0]
  .wr_full(wr_full_d),                  // output
  .wr_water_level(wr_water_level_d),    // output [11:0]
  .almost_full(almost_full_d),          // output
  .rd_clk(clk),                    // input
  .rd_rst(!rst_n),                    // input
  .rd_en(rd_en_d),                      // input
  .rd_data(rd_data_d),                  // output [15:0]
  .rd_empty(rd_empty_d),                // output
  .rd_water_level(rd_water_level_d),    // output [11:0]
  .almost_empty(almost_empty_d)         // output
);



LMS_FIFO u_LMS_FIFO_out (
  .wr_clk                         (clk),                    // input
  .wr_rst                         (!rst_n),                    // input
  .wr_en                          ( e_n_en  ),                      // input
  .wr_data                        ( e_n_data  ),                  // input [15:0]
  .wr_full                        ( wr_full_1   ),                  // output
  .wr_water_level                 (    ),    // output [11:0]
  .almost_full                    (    ),          // output
  .rd_clk                         ( voice_clk_out ),                    // input
  .rd_rst                         ( !voice_rst_out ),                    // input
  .rd_en                          ( voice_en_out  ),                      // input
  .rd_data                        ( voice_data_out),                  // output [15:0]
  .rd_empty                       (rd_empty_1),                // output
  .rd_water_level                 (rd_water_level_1),    // output [11:0]
  .almost_empty                   (almost_empty_1)         // output
);


endmodule