/*************
Author:wyx
Times :2024.5.29
实时变声
**************/


module Voice_change#(
    parameter DATA_WIDTH = 16
)
(
    input                           clk,
    input                           rst_n,

    input wire  [9:0]              f_set,
    input wire  [9:0]              f_original,


    input wire                     voice_clk_in ,
    input wire                     voice_rst_in ,
    input wire                     voice_en_in  ,
    input wire  [DATA_WIDTH - 1:0] voice_data_in,


    input  wire                     voice_clk_out ,
    input  wire                     voice_rst_out ,
    input  wire                     voice_en_out  ,
    output wire  [DATA_WIDTH - 1:0] voice_data_out

   );
wire addr_end_1;
wire addr_end_2;
wire flag_capture_end;
wire flag_Linear_end   ;
wire flag_Filter_end;
wire voice_change_finsh;

wire [11:0] rd_water_level;


reg  flag_new_1;
reg  flag_new_2;
reg [1:0] ram12_en;
wire [DATA_WIDTH - 1:0]  data_out;
wire  [DATA_WIDTH - 1:0]  data ;
localparam ST_Framing        = 5'b00001;
localparam ST_Frame_capture  = 5'b00010;
localparam ST_Linear         = 5'b00100;
localparam ST_Filter         = 5'b01000;
localparam ST_Finsh          = 5'b10000;
localparam ST_start          = 5'b10001;

reg     [4:0]   fsm_c;
reg     [4:0]   fsm_n;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        fsm_c <= ST_Framing;
    else
        fsm_c <= fsm_n;
end
always@(*)
begin
    case(fsm_c)
        ST_start:
            if(rd_water_level>='d600)//
                fsm_n<=ST_Framing;
            else
                fsm_n<=ST_start;  
        ST_Framing:
            if(addr_end_1||addr_end_2)//
                fsm_n<=ST_Frame_capture;
            else
                fsm_n<=ST_Framing;   
        ST_Frame_capture:
            if(flag_capture_end)
                fsm_n<=ST_Linear;
            else
                fsm_n<=ST_Frame_capture;
        ST_Linear:
            if(flag_Linear_end)
                fsm_n<=ST_Filter;
            else
                fsm_n<=ST_Linear;
        ST_Filter: 
            if(flag_Filter_end)
                fsm_n<=ST_Finsh;
            else
                fsm_n<=ST_Filter;
        ST_Finsh: 
            if(voice_change_finsh)
                fsm_n<=ST_start;
            else
                fsm_n<=ST_Finsh;
        default:
                fsm_n <= ST_start;
    endcase
end

//分帧
wire [9:0]             rd_addr_1;
wire [DATA_WIDTH - 1:0]rd_data_1;
wire [9:0]             rd_addr_2;
wire [DATA_WIDTH - 1:0]rd_data_2;
wire [10:0]            rd_capture_addr_1;
wire [15:0]            rd_capture_data_1;
wire [10:0]            rd_capture_addr_2;
wire [15:0]            rd_capture_data_2;
//////////////////////测试
reg rd_en;
reg [10:0]addr;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        rd_en <= 1'b0;
    end
    else if(voice_change_finsh)begin
        rd_en <= 1'b0;
    end
    else if(flag_Filter_end)begin
        rd_en <= 1'b1;
    end
    else begin
        rd_en <= rd_en;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||voice_change_finsh)begin
        addr <= 'd0;
    end
    else if(rd_en)begin
        addr <= addr+'d1;
    end
    else begin
        addr <= addr;
    end
end
assign voice_change_finsh=(addr=='d600)?'d1:'d0;

//////////////////////测试

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        ram12_en <= 2'b01;
    end
    else if(((addr_end_2) && (fsm_c==ST_Framing)))begin
        ram12_en <= 2'b01;
    end
    else if(addr_end_1  && (fsm_c==ST_Framing))begin
        ram12_en <= 2'b10;
    end
    else begin
        ram12_en <= ram12_en;
    end
end

//新一帧判断标志位
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        flag_new_1 <= 'd0;
        flag_new_2 <= 'd1;
    end
    else if(addr_end_1)begin
        flag_new_1 <= 'd1;
        flag_new_2 <= 'd0;
    end
    else if(addr_end_2)begin
        flag_new_1 <= 'd0;
        flag_new_2 <= 'd1;
    end
    else begin
        flag_new_1 <= flag_new_1;
        flag_new_2 <= flag_new_2;
    end
end

Framing#(
  .DATA_WIDTH (DATA_WIDTH)
)u_Framing1
(
.clk            (clk),
.rst_n          (rst_n),

.wr_addr_max    ('d600),
.fifo_en        (),
.wr_en          (ram12_en[0]&&(fsm_c==ST_Framing)),
.wr_data        (data),
.addr_end       (addr_end_1),

.rd_addr        (rd_addr_1),
.rd_data        (rd_data_1),
.rd_clk         (clk ),
.rd_rst         (!rst_n )
   );

Framing#(
  .DATA_WIDTH (DATA_WIDTH)
)u_Framing2
(
.clk            (clk),
.rst_n          (rst_n),

.wr_addr_max    ('d600),
.fifo_en        (),
.wr_en          (ram12_en[1] && (fsm_c==ST_Framing)),
.wr_data        (data),
.addr_end       (addr_end_2),

.rd_addr        (rd_addr_2),
.rd_data        (rd_data_2),
.rd_clk         (clk),
.rd_rst         (!rst_n)
   );


///升/降调判断
reg [9:0] p;//变调因子
reg [16:0] f_set_1;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        f_set_1 <= 'd0;
    end
    else begin
         f_set_1<=f_set<<7;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        p <= 'd0;
    end
    else begin
        p <= f_set_1/f_original;
    end
end

Frame_capture#(
   . DATA_WIDTH (DATA_WIDTH)
)u_Frame_capture
(
.clk           (clk),
.rst_n         (rst_n),
.p             (p),
.flag_new_1    (flag_new_1),
.flag_new_2    (flag_new_2),
.wr_en         ( (fsm_c==ST_Frame_capture)),
.rd_addr_1     (rd_addr_1),
.rd_data_1     (rd_data_1),
.rd_addr_2     (rd_addr_2),
.rd_data_2     (rd_data_2),
.rd_capture_addr_1       (rd_capture_addr_1),
.rd_capture_data_1       (rd_capture_data_1),
.rd_capture_addr_2       (rd_capture_addr_2),
.rd_capture_data_2       (rd_capture_data_2),
.flag_end      (flag_capture_end)
 );

//线 性 插 值式 
wire [9:0]              rd_Linear_addr    ;
wire [DATA_WIDTH - 1:0] rd_Linear_data    ;


Linear_interpolation#(
  . DATA_WIDTH (DATA_WIDTH)
)u_Linear_interpolation
(
. clk                    (clk),
. rst_n                  (rst_n),
. p                      (p),
. wr_addr_max            ('d600),
. wr_en_1                ((fsm_c==ST_Linear)),
.rd_capture_addr_1       (rd_capture_addr_1),
.rd_capture_data_1       (rd_capture_data_1),
.rd_capture_addr_2       (rd_capture_addr_2),
.rd_capture_data_2       (rd_capture_data_2),
. rd_addr_out            (rd_Linear_addr),
. rd_data_out            (rd_Linear_data),
.flag_end                (flag_Linear_end)
   );

//正弦幅度调制一阶滤波 


wire [9:0]              rd_Filter_addr    ;
wire [DATA_WIDTH - 1:0] rd_Filter_data    ;
wire  [7:0]                    a;
assign a='d10;//扩大了128倍，0.08
Filter_modulation#(
   . DATA_WIDTH (DATA_WIDTH)
)u_Filter_modulation
(
.clk                (clk),
.rst_n              (rst_n),
.a                  (a),
.wr_en_1            ((fsm_c==ST_Filter)),
.wr_addr_max        ('d600),
.rd_Linear_addr     (rd_Linear_addr),
.rd_Linear_data     (rd_Linear_data),
.rd_addr_out        (addr),
.rd_data_out        (rd_Filter_data),
.flag_end           (flag_Filter_end)
   );




vocie_change_fifo1 u_vocie_change_fifo_in (
  .wr_clk                         (voice_clk_in ),                    // input
  .wr_rst                         (!voice_rst_in ),                    // input
  .wr_en                          (voice_en_in  ),                      // input
  .wr_data                        (voice_data_in),                  // input [15:0]
  .wr_full                        (wr_full),                  // output
  .wr_water_level                 (wr_water_level),    // output [11:0]
  .almost_full                    (almost_full),          // output
  .rd_clk                         (clk ),                    // input
  .rd_rst                         (!rst_n ),                    // input
  .rd_en                          ((fsm_c==ST_Framing)  ),                      // input
  .rd_data                        (data),                  // output [15:0]
  .rd_empty                       (rd_empty),                // output
  .rd_water_level                 (rd_water_level),    // output [11:0]
  .almost_empty                   (almost_empty)         // output
);


vocie_change_fifo1 u_vocie_change_fifo_out (
  .wr_clk                         (clk),                    // input
  .wr_rst                         (!rst_n),                    // input
  .wr_en                          (rd_en   ),                      // input
  .wr_data                        (rd_Filter_data),                  // input [15:0]
  .wr_full                        (wr_full_1),                  // output
  .wr_water_level                 (wr_water_level_1),    // output [11:0]
  .almost_full                    (almost_full_1),          // output
  .rd_clk                         ( voice_clk_out ),                    // input
  .rd_rst                         ( !voice_rst_out ),                    // input
  .rd_en                          ( voice_en_out  ),                      // input
  .rd_data                        ( voice_data_out),                  // output [15:0]
  .rd_empty                       (rd_empty_1),                // output
  .rd_water_level                 (rd_water_level_1),    // output [11:0]
  .almost_empty                   (almost_empty_1)         // output
);



endmodule