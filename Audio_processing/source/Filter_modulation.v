/*************
Author:wyx
Times :2024.5.30
正弦幅度调制一阶滤波
**************/


module Filter_modulation#(
    parameter DATA_WIDTH = 16
)(

    input                           clk,
    input                           rst_n,

    input wire  [7:0]                    a,

    input wire                      wr_en_1 , 
    input wire [9:0]                wr_addr_max , 

    output wire [9:0]                rd_Linear_addr,
    input wire [DATA_WIDTH - 1:0]    rd_Linear_data,

    input wire [9:0]                rd_addr_out,
    output wire [DATA_WIDTH - 1:0]  rd_data_out,

    output reg                    flag_end
   );

reg [9:0] wr_addr_1;
reg [9:0] wr_addr;
wire [15:0] wr_data;

reg [7:0] a_l;
wire [7:0] sin_data ;
reg  [15:0] k      ;
reg  [31:0]data     ;
wire  [16:0]data_1   ;
reg  [31:0]data_2   ;
reg  [16:0]data_3   ;
reg  [23:0]data_4   ;
reg  [16:0]data_5   ;
wire [16:0]data_5_1;
wire [24:0]data_5_2;
wire [24:0]data_5_3;
wire [16:0]data_5_4;
reg  [15:0]data_6   ;

reg  wr_en;
reg  wr_en_2 ;
reg  wr_en_3 ;
reg  wr_en_4 ;

wire  flag_end_1 ;
reg  flag_end_2 ;
reg  flag_end_3 ;
reg  flag_end_4 ;

Voice_change_ram u_Filter_modulationn_ram (
  .wr_data(wr_data),    // input [15:0]
  .wr_addr(wr_addr),    // input [9:0]
  .wr_en  (wr_en  ),        // input
  .wr_clk (clk    ),      // input
  .wr_rst (!rst_n ),      // input
  .rd_addr(rd_addr_out),    // input [9:0]
  .rd_data(rd_data_out),    // output [15:0]
  .rd_clk (clk ),      // input
  .rd_rst (!rst_n )       // input
);
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        wr_en <= 'd0;
        wr_en_2 <= 'd0;
        wr_en_3 <= 'd0;
        wr_en_4 <= 'd0;
    end
    else begin
        wr_en_2 <=wr_en_1 ;
        wr_en_3 <=wr_en_2 ;
        wr_en_4 <=wr_en_3 ;
        wr_en   <=wr_en_4 ;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        flag_end <= 'd0;
        flag_end_2 <= 'd0;
        flag_end_3 <= 'd0;
        flag_end_4 <= 'd0;
    end
    else begin 
        flag_end_2  <=flag_end_1 ;
        flag_end_3  <=flag_end_2 ;
        flag_end_4  <=flag_end_3 ;
        flag_end    <=flag_end_4 ;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||wr_addr_1==wr_addr_max)begin
        wr_addr_1 <= 'd0;
    end
    else if(wr_en_1)begin
        wr_addr_1 <= wr_addr_1+'d1;
    end
    else
        wr_addr_1 <= 'd0;
end
assign rd_Linear_addr=wr_addr_1;
assign flag_end_1=(wr_addr_1==wr_addr_max)?'d1:'d0;

wire flag_f1;
reg flag_f1_1;
reg flag_f1_2;

wire  [DATA_WIDTH - 1:0]  rd_capture_data_1_1; 

assign flag_f1=((rd_Linear_data[15]))?'d1:'d0;

assign rd_capture_data_1_1=(flag_f1)?~rd_Linear_data+'d1:rd_Linear_data;

sin_Amplitude_modulation u_sin_Amplitude_modulation(
.i    (rd_Linear_addr),   
.data (sin_data      )
);

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        k  <= 'd0;
    end
    else begin
        k  <=sin_data*a ;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        data <= 'd0;
        flag_f1_1<='d0;
    end
    else begin
        data <=rd_capture_data_1_1*k ;
        flag_f1_1<=flag_f1;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        data_2 <= 'd0;
    end
    else if(flag_f1_1) begin
        data_2<=~data+'d1;
    end
    else  begin
        data_2<=data;
    end
end



always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        data_3 <= 'd0;
    end
    else begin
        data_3 <=data_2>>14;
    end
end

assign data_1=(!rst_n)?'d0:data_3+data_5_4;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        data_5 <= 'd0;
    end
    else begin
        data_5 <=data_1;//;
    end
end
wire flag_f2;

assign flag_f2=((data_5[16]))?'d1:'d0;
assign data_5_1=(flag_f2)?~data_5+'d1:data_5;
assign data_5_2=data_5_1*('d128-a);
assign data_5_3=(flag_f2)?(~data_5_2+'d1):data_5_2;
assign data_5_4=data_5_3>>7;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||wr_addr==wr_addr_max)begin
        wr_addr <= 'd0;
    end
    else if(wr_en)begin
        wr_addr <= wr_addr+'d1;
    end
    else
        wr_addr <= 'd0;
end

assign wr_data=data_1;

endmodule