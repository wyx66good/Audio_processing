/*************
Author:wyx
Times :2024.5.29
线 性 插 值式 
**************/

module Linear_interpolation#(
    parameter DATA_WIDTH = 16
)(
    input                           clk,
    input                           rst_n,

    input [9:0]                     p,

    input wire [9:0]                wr_addr_max , 
    input wire                      wr_en_1 , 
    output wire [10:0]               rd_capture_addr_1,
    output wire [10:0]               rd_capture_addr_2,
    input wire  [DATA_WIDTH - 1:0]  rd_capture_data_1,
    input wire  [DATA_WIDTH - 1:0]  rd_capture_data_2,

    input wire [9:0]                rd_addr_out,
    output wire [DATA_WIDTH - 1:0]  rd_data_out,

    output reg                    flag_end
   );


reg [9:0] wr_addr;
reg [9:0] wr_addr_1;
reg [19:0] pn;
reg [19:0] pn_1;
reg [19:0] pn_2;
reg [19:0] pn_3;
reg [19:0] pn_4;
reg [19:0] pn_int;
reg [19:0] pn_int_1;
reg [7:0] k;
reg [7:0] k_1;
reg [7:0] k_2;
reg [10:0]rd_addr_1;
reg [23:0] data1;
reg [23:0] data2;
reg [23:0] data1_1;
reg [23:0] data2_1;
reg [15:0] data1_2;
reg [15:0] data2_2;
reg [15:0] wr_data;

reg  wr_en;
reg  wr_en_2 ;
reg  wr_en_3 ;
reg  wr_en_4 ;
reg  wr_en_5 ;
reg  wr_en_6 ;
reg  wr_en_7 ;
reg  wr_en_8 ;
reg  wr_en_9 ;
reg  wr_en_10 ;
reg  wr_en_11 ;

wire  flag_end_1 ;
reg  flag_end_2 ;
reg  flag_end_3 ;
reg  flag_end_4 ;
reg  flag_end_5 ;
reg  flag_end_6 ;
reg  flag_end_7 ;
reg  flag_end_8 ;
reg  flag_end_9 ;
reg  flag_end_10 ;
reg  flag_end_11 ;

Voice_change_ram u_Linear_interpolation_ram (
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
//assign flag_end =(wr_addr==wr_addr_max)?1:0;

//打9拍
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        wr_en <= 'd0;
        wr_en_2 <= 'd0;
        wr_en_3 <= 'd0;
        wr_en_4 <= 'd0;
        wr_en_5 <= 'd0;
        wr_en_6 <= 'd0;
        wr_en_7 <= 'd0;
        wr_en_8 <= 'd0;
        wr_en_9  <= 'd0;
        wr_en_10 <= 'd0;
        wr_en_11 <= 'd0;
    end
    else begin
        wr_en_2 <=wr_en_1 ;
        wr_en_3 <=wr_en_2 ;
        wr_en_4 <=wr_en_3 ;
        wr_en_5 <=wr_en_4 ;
        wr_en_6 <=wr_en_5 ;
        wr_en_7 <=wr_en_6 ;
        wr_en_8 <=wr_en_7 ;
        wr_en_9 <=wr_en_8 ;
        wr_en_10 <=wr_en_9 ;
        wr_en_11 <=wr_en_10 ;
        wr_en   <=wr_en_11 ;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        flag_end <= 'd0;
        flag_end_2 <= 'd0;
        flag_end_3 <= 'd0;
        flag_end_4 <= 'd0;
        flag_end_5 <= 'd0;
        flag_end_6 <= 'd0;
        flag_end_7 <= 'd0;
        flag_end_8 <= 'd0;
        flag_end_9  <= 'd0;
        flag_end_10 <= 'd0;
        flag_end_11 <= 'd0;
    end
    else begin 
        flag_end_2  <=flag_end_1 ;
        flag_end_3  <=flag_end_2 ;
        flag_end_4  <=flag_end_3 ;
        flag_end_5  <=flag_end_4 ;
        flag_end_6  <=flag_end_5 ;
        flag_end_7  <=flag_end_6 ;
        flag_end_8  <=flag_end_7 ;
        flag_end_9  <=flag_end_8 ;
        flag_end_10 <=flag_end_9 ;
        flag_end_11 <=flag_end_10 ;
        flag_end    <=flag_end_11 ;
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

assign flag_end_1=(wr_addr_1==wr_addr_max)?'d1:'d0;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        pn <= 'd0;
    end
    else begin
        pn <=p*wr_addr_1 ;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        pn_int_1 <= 'd0;
        pn_1     <='d0;
    end
    else begin
        pn_int_1 <=pn>>7 ;
        pn_1     <=pn;//pn打一拍
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        pn_int <= 'd0;
        pn_2     <='d0;
    end
    else begin
        pn_int <=pn_int_1<<7 ;
        pn_2     <=pn_1;//pn打二拍
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        k <= 'd0;
        pn_3     <='d0;
        pn_4     <='d0;
    end
    else begin
        k <=pn_2-pn_int ;
        pn_3     <=pn_2;//pn打三拍
        pn_4     <=pn_3;//pn打四拍
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        k_1 <= 'd0;
        k_2 <= 'd0;
        rd_addr_1<='d0;
    end
    else begin
        k_1     <=k;//k打一拍
        k_2     <=k_1;//k打二拍
        rd_addr_1<=pn_3>>7;//rd_addr_in注意超限
    end
end

assign rd_capture_addr_1=rd_addr_1+'d1;
assign rd_capture_addr_2=rd_addr_1;

//正负号判断
wire flag_f1;
wire flag_f2;
reg flag_f1_1;
reg flag_f2_1;

wire  [DATA_WIDTH - 1:0]  rd_capture_data_1_1; 
wire  [DATA_WIDTH - 1:0]  rd_capture_data_2_1; 

assign flag_f1=((rd_capture_data_1[15]))?'d1:'d0;
assign flag_f2=((rd_capture_data_2[15]))?'d1:'d0;

assign rd_capture_data_1_1=(flag_f1)?~rd_capture_data_1+'d1:rd_capture_data_1;
assign rd_capture_data_2_1=(flag_f2)?~rd_capture_data_2+'d1:rd_capture_data_2;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        data1 <= 'd0;
        data2 <= 'd0;
        flag_f1_1<='d0;
        flag_f2_1<='d0;
    end
    else begin
        data1 <=rd_capture_data_1_1*k_2 ;
        data2 <=rd_capture_data_2_1*('d128-k_2) ;
        flag_f1_1<=flag_f1;
        flag_f2_1<=flag_f2;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        data1_1 <= 'd0;
    end
    else if(flag_f1_1) begin
        data1_1<=~data1+'d1;
    end
    else  begin
        data1_1<=data1;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        data2_1 <= 'd0;
    end
    else if(flag_f2_1) begin
        data2_1<=~data2+'d1;
    end
    else  begin
        data2_1<=data2;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        data1_2 <= 'd0;
        data2_2 <= 'd0;
    end
    else begin
        data1_2 <=data1_1>>7 ;
        data2_2 <=data2_1>>7 ;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        wr_data <= 'd0;
    end
    else begin
        wr_data <=data1_2 + data2_2 ;
    end
end

//wire [3:0] a;
//wire [3:0] a_1;
//wire [3:0] b;
//reg  [7:0] c;
//reg  [7:0] c_1;
//assign a=-'d5;
//assign b=7;
//assign a_1=(a[3])?~a+'d1:a;
//
//always@(posedge clk or negedge rst_n)
//begin
//    if(!rst_n)begin
//        c <= 'd0;
//    end
//    else begin
//        c <=a_1*b;
//    end
//end
//always@(posedge clk or negedge rst_n)
//begin
//    if(!rst_n)begin
//        c_1 <= 'd0;
//    end
//    else begin
//        c_1 <= ~c+'d1;//{c[7],~c[6:0]+'d1} ;
//    end
//end
//
//
endmodule