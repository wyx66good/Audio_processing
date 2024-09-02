/*************
Author:wyx
Times :2024.6.16
dotÄÚ»ı
**************/

module dot#(
    parameter DATA_WIDTH = 16
)
(
    input                           clk,
    input                           rst_n,

    output wire                     en_x ,
    input  wire  [DATA_WIDTH - 1:0] data_x,

    output wire                     en_d ,
    input  wire  [DATA_WIDTH - 1:0] data_d,

    output wire  [8:0]              addr_w1 ,
    input  wire  [58:0]             data_w1,
    output wire [15:0]              rd_data1,

    input wire                    w_update_en,

    output reg                     updata_finsh,
    output wire                     finsh,

    input  wire                     Clear,

    input  wire                     up_u_en   ,
    input  wire                     dot_en   ,

    output reg                     e_n_en,
    output wire [15:0]              e_n_data  ,

    output reg  [40:0]            sumu

    

   );

wire [15:0] wr_data;
reg [8:0]  wr_addr;
reg        wr_en;

reg [8:0]  rd_addr1;
wire updata_finsh_1;

//wire [8:0]  rd_addr2;
//wire [15:0] rd_data2;
//
//wire [8:0]  rd_addr3;
//wire [15:0] rd_data3;
//
//wire [8:0]  rd_addr4;
//wire [15:0] rd_data4;

reg [8:0]  rd_addr5;
wire [15:0] rd_data5;
reg  [15:0] rd_data5_1;

     
/////////////////////////////////////////////////////////////////////////U
reg updata_en;
reg dot_en_1;
reg up_u_en_1;



//assign wr_addr=rd_addr5;
assign wr_data=(wr_addr=='d0)?data_x:rd_data5_1;
//assign wr_en=(rd_addr5=='d0)&&dot_en||updata_en;
assign en_x = updata_en&&(rd_addr5=='d0);

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        rd_data5_1 <= 'd0;
    else
        rd_data5_1 <= rd_data5;

end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        wr_en <= 'd0;
    else
        wr_en <= updata_en;
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        wr_addr <= 'd0;
    else
        wr_addr <= rd_addr5;
end


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        up_u_en_1 <= 'd0;
    end
    else begin
        up_u_en_1 <= up_u_en;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        updata_en <= 'd0;
    else if(up_u_en&&!up_u_en_1)
        updata_en <= 'd1;
    else if(updata_finsh_1)
        updata_en <= 'd0;
    else 
        updata_en <= updata_en;

end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        rd_addr5 <= 'd0;
    else if(updata_en)
        rd_addr5 <= rd_addr5+'d1;
    else 
        rd_addr5 <= rd_addr5;

end


assign updata_finsh_1=(rd_addr5=='d511)?'d1:'d0;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        updata_finsh <= 'd0;
    else 
        updata_finsh <= updata_finsh_1;

end
/////////////////////////////////////////////////////////////////////////

/*******************************************************************************/

wire start;
assign start=dot_en&&!dot_en_1;


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        dot_en_1 <= 'd0;
    end
    else begin
        dot_en_1 <= dot_en;
    end
end

reg sum_en;
reg sum_en1;
reg sum_en2;
reg sum_en3;
reg sum_en4;
reg [74:0] sum1_1;
reg [74:0] sum1_2;
reg [83:0] sum1_3;
reg [51:0] sum;
reg [31:0] sumu_1;
reg [31:0] sumu_2;
reg [40:0] sumu_3;

//assign w_update_en=sum_en1;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        sum_en1 <= 'd0;
        sum_en2 <= 'd0;
        sum_en3 <= 'd0;
        sum_en4 <= 'd0;
    end
    else  begin
        sum_en1 <= sum_en;
        sum_en2 <= sum_en1;
        sum_en3 <= sum_en2;
        sum_en4 <= sum_en3;
    end

end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        sum_en <= 'd0;
    else if(start)
        sum_en <= 'd1;
    else if( rd_addr1=='d511)
        sum_en <= 'd0;
    else 
        sum_en <= sum_en;

end


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||rd_addr1=='d511)
        rd_addr1 <= 'd0;
    else if(sum_en||w_update_en)
        rd_addr1 <= rd_addr1+'d1;
    else 
        rd_addr1 <= rd_addr1;
end

assign addr_w1=rd_addr1;


wire flag_f1;
wire flag_f2;
reg flag_f1_1;
reg flag_f2_1;

wire  [DATA_WIDTH - 1:0]  rd_data1_1; 
wire  [58:0]              data_w1_1; 
wire  [58:0]              data_w1_2; 

assign data_w1_2=data_w1>>16;

assign flag_f1=((rd_data1[15]))?'d1:'d0;
assign flag_f2=((data_w1[58]))?'d1:'d0;

assign rd_data1_1=(flag_f1)?~rd_data1+'d1:rd_data1;
assign data_w1_1=(flag_f2)?~data_w1+'d1:data_w1;


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||Clear)begin
        sum1_1 <= 'd0;
        flag_f1_1<='d0;
        flag_f2_1<='d0;
    end
    else if(sum_en1)begin
        sum1_1 <= rd_data1_1*data_w1_1;
        flag_f1_1<=flag_f1;
        flag_f2_1<=flag_f2;
    end
    else begin
        sum1_1 <= sum1_1;
        flag_f1_1<=flag_f1;
        flag_f2_1<=flag_f2;
    end

end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||Clear)begin
        sumu_1 <= 'd0;
    end
    else if(sum_en1)begin
        sumu_1<=rd_data1_1*rd_data1_1;
    end
    else begin
        sumu_1 <= sumu_1;
    end

end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||Clear)begin
        sum1_2 <= 'd0;
    end
    else if(flag_f1_1!=flag_f2_1) begin
        sum1_2<=~sum1_1+'d1;
    end
    else  begin
        sum1_2<=sum1_1;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||Clear)begin
        sumu_2 <= 'd0;
    end
    else  begin
        sumu_2 <= sumu_1;
    end
end
wire [83:0] sum1_2_1;
assign sum1_2_1={ {9{sum1_2[74]}},sum1_2[74:0]};

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||Clear)begin
        sum1_3 <= 'd0;
    end
    else  begin
        sum1_3<=sum1_3+sum1_2_1;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||Clear)begin
        sumu_3 <= 'd0;
    end
    else  begin
        sumu_3<=sumu_3+sumu_2;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n||Clear)begin
        sum <= 'd0;
    end
    else  begin
        sum<=sum1_3>>32;//33
    end
end


assign finsh=(sum_en4&&!sum_en3)?'d1:'d0;
assign en_d=(sum_en3&&!sum_en2)?'d1:'d0;
/*******************************************************************************/
reg finsh_1;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        finsh_1 <= 'd0;
    end
    else  begin
        finsh_1<=finsh;
    end
end

//assign e_n_en=en_d;
//assign e_n_data=(e_n_en)?data_d-sum1:e_n_data_1;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        sumu <= 'd1;
    end
    else if(finsh) begin
        if (sumu_3=='d0 )
                sumu<=sumu;
        else
                sumu<=sumu_3;
    end
    else  begin
        sumu<=sumu;
    end
end

//wire [47:0] data_d_1;
//wire [56:0] data_d_2;
reg  [15:0] e_n_data_1;
//wire  [24:0] e_n_data_2;
//assign data_d_1=data_d<<32;
//assign data_d_2={ {9{data_d_1[47]}},data_d_1[47:0]};

wire  [15:0] sum1;
assign sum1=sum[15:0];
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        e_n_data_1 <= 'd0;
        e_n_en <='d0;
    end
    else if(finsh_1) begin
        e_n_data_1<=data_d-sum1;//-sum1;//-sum;//
        e_n_en<='d1;
    end
    else  begin
        e_n_data_1<=e_n_data_1;
        e_n_en<='d0;
    end
end
//assign e_n_data_2=e_n_data_1>>32;//{e_n_data_1[35],e_n_data_1[14:0]};
assign e_n_data=e_n_data_1;
/*******************************************************************************/









/*******************************************************************************/

Echo_cancellation_LMS_ram u_Echo_cancellation_LMS_ram1 (
  .wr_data  (wr_data),    // input [15:0]
  .wr_addr  (wr_addr),    // input [9:0]
  .wr_en    (wr_en),        // input
  .wr_clk   (clk),      // input
  .wr_rst   (!rst_n),      // input
  .rd_addr  (rd_addr1),    // input [9:0]
  .rd_data  (rd_data1),    // output [15:0]
  .rd_clk   (clk),      // input
  .rd_rst   (!rst_n)       // input
);

//Echo_cancellation_LMS_ram u_Echo_cancellation_LMS_ram2 (
//  .wr_data  (wr_data),    // input [15:0]
//  .wr_addr  (wr_addr),    // input [9:0]
//  .wr_en    (wr_en),        // input
//  .wr_clk   (clk),      // input
//  .wr_rst   (!rst_n),      // input
//  .rd_addr  (rd_addr2),    // input [9:0]
//  .rd_data  (rd_data2),    // output [15:0]
//  .rd_clk   (clk),      // input
//  .rd_rst   (!rst_n)       // input
//);
//
//Echo_cancellation_LMS_ram u_Echo_cancellation_LMS_ram3 (
//  .wr_data  (wr_data),    // input [15:0]
//  .wr_addr  (wr_addr),    // input [9:0]
//  .wr_en    (wr_en),        // input
//  .wr_clk   (clk),      // input
//  .wr_rst   (!rst_n),      // input
//  .rd_addr  (rd_addr3),    // input [9:0]
//  .rd_data  (rd_data3),    // output [15:0]
//  .rd_clk   (clk),      // input
//  .rd_rst   (!rst_n)       // input
//);
//
//Echo_cancellation_LMS_ram u_Echo_cancellation_LMS_ram4 (
//  .wr_data  (wr_data),    // input [15:0]
//  .wr_addr  (wr_addr),    // input [9:0]
//  .wr_en    (wr_en),        // input
//  .wr_clk   (clk),      // input
//  .wr_rst   (!rst_n),      // input
//  .rd_addr  (rd_addr4),    // input [9:0]
//  .rd_data  (rd_data4),    // output [15:0]
//  .rd_clk   (clk),      // input
//  .rd_rst   (!rst_n)       // input
//);

Echo_cancellation_LMS_ram u_Echo_cancellation_LMS_ram5 (
  .wr_data  (wr_data),    // input [15:0]
  .wr_addr  (wr_addr),    // input [9:0]
  .wr_en    (wr_en),        // input
  .wr_clk   (clk),      // input
  .wr_rst   (!rst_n),      // input
  .rd_addr  (rd_addr5),    // input [9:0]
  .rd_data  (rd_data5),    // output [15:0]
  .rd_clk   (clk),      // input
  .rd_rst   (!rst_n)       // input
);






endmodule