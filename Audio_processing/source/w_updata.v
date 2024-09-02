
/*************
Author:wyx
Times :2024.6.16
w_updata
**************/


module w_updata#(
    parameter DATA_WIDTH = 16
)
(
  input wire             clk          , 
  input wire             rst_n        , 
  output wire  [58:0]    rd_data_w2    , 
  input wire   [15:0]    rd_data_u    , 
  input wire    [8:0]    rd_addr_u    , 

  input wire             w_update_start  , 
  output reg             w_update_en  , 
  input wire  [15:0]     e_n_data     , 
  input wire             Clear        , 
  output wire            finsh        , 
  input wire   [40:0]    sumu          

   );


reg [31:0] rd_data_u_1;
reg [58:0] rd_data_u_2;

reg [8:0]  wr_addr_w; 

reg   wr_en_w;

reg [58:0] wr_data_w;


wire  [31:0]  rd_data_u_1_1; 
wire  [31:0]  e_n_data_1; 


assign rd_data_u_1_1={{16{rd_data_u[15]}},rd_data_u};
assign e_n_data_1={{16{e_n_data[15]}},e_n_data};


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        rd_data_u_1 <= 'd0;
    end
    else begin
        rd_data_u_1 <= rd_data_u_1_1*e_n_data_1;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        rd_data_u_2 <= 'd0;
    end
    else begin
        rd_data_u_2 <= rd_data_u_1<<27;
    end
end


localparam A_LEN = 59;
localparam B_LEN = 41;
reg  [A_LEN+2:0] rd_data_w_en_1;
wire             rd_data_w_en;
always @(posedge clk or negedge rst_n) begin
    if ((!rst_n))begin
    	rd_data_w_en_1<='d0;
    end
    else begin
    	rd_data_w_en_1<={rd_data_w_en_1[A_LEN+1:0] , w_update_en};
    end
end
assign rd_data_w_en=rd_data_w_en_1[A_LEN+1];

wire        EN;
wire [31:0] Quotient_w_updata_1;
wire [58:0] Quotient_w_updata;
wire Quotient_w_updata_en;
assign EN=rd_data_w_en_1[2];
Divider #
(
//.A_LEN(59),
//.B_LEN(41)
.A_LEN(A_LEN),
.B_LEN(B_LEN)
)divide32_w_updata
(
		.CLK(clk),
		.EN(EN),
		.RSTN(rst_n),
		.Dividend(rd_data_u_2),
		.Divisor(sumu),
		.Quotient(Quotient_w_updata),
		.Mod(),
		.RDY(Quotient_w_updata_en)
);
//assign Quotient_w_updata={27'd0,Quotient_w_updata_1};
reg [8:0]    rd_addr_w;
wire [58:0]   rd_data_w;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        rd_addr_w <= 'd0;
    end
    else if(rd_data_w_en) begin
        rd_addr_w <= rd_addr_w+'d1;
    end
    else begin
        rd_addr_w <= 'd0;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        wr_en_w <= 'd0;
    end
    else  begin
        wr_en_w <= Quotient_w_updata_en;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        wr_addr_w <= 'd0;
    end
    else if(wr_en_w) begin
        wr_addr_w <= wr_addr_w+'d1;
    end
    else begin
        wr_addr_w <= 'd0;
    end
end


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        wr_data_w<='d0;
    end
    else  begin
        wr_data_w<=rd_data_w+Quotient_w_updata;
    end
end




assign finsh=(wr_addr_w=='d511)?'d1:'d0;

reg w_update_start_1;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        w_update_start_1 <= 'd0;

    end
    else  begin
        w_update_start_1 <= w_update_start;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        w_update_en <= 'd0;
    else if(w_update_start&&!w_update_start_1)
        w_update_en <= 'd1;
    else if(rd_addr_u=='d511)
        w_update_en <= 'd0;
    else 
        w_update_en <= w_update_en;

end

w_lms_ram w_lms_ram (
  .wr_data(wr_data_w),    // input [15:0]
  .wr_addr(wr_addr_w),    // input [8:0]
  .wr_en  (wr_en_w  ),        // input
  .wr_clk (clk),      // input
  .wr_rst (!rst_n),      // input
  .rd_addr(rd_addr_w),    // input [8:0]
  .rd_data(rd_data_w),    // output [15:0]
  .rd_clk (clk),      // input
  .rd_rst (!rst_n)       // input
);

w_lms_ram w_lms_ram2 (
  .wr_data(wr_data_w),    // input [15:0]
  .wr_addr(wr_addr_w),    // input [8:0]
  .wr_en  (wr_en_w  ),        // input
  .wr_clk (clk),      // input
  .wr_rst (!rst_n),      // input
  .rd_addr(rd_addr_u),    // input [8:0]
  .rd_data(rd_data_w2),    // output [15:0]
  .rd_clk (clk),      // input
  .rd_rst (!rst_n)       // input
);




endmodule