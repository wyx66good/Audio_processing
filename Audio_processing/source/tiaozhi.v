
/*************
Author:wyx
Times :2024.7.14
幅度调制
**************/
module tiaozhi(
	input		wire			clk,
	input		wire			rst_n,
    
    output        wire          finsh,

	input		wire  [63:0]	p_data,
    output       wire  [9:0]    p_wr_addr,
    input       wire            p_wr_en,

	output		wire  [15:0]	x_h_1,
	output		wire 			x_h_1_en ,	

    output      wire            finsh_tiaozhi
	);


wire  [31:0] p_data_1;
wire  [15:0] p_data_2/*synthesis PAP_MARK_DEBUG="1"*/;
wire  [23:0] p_data_3;
reg  [23:0] p_data_4;
wire  [15:0] p_data_5;
reg   [9:0 ] hanning_i;
wire  [7:0]  hanning_data;
wire  [23:0]  hanning_data_3;
assign p_data_1 = p_data[31:0];
assign p_data_2 = p_data_1>>10;


hanning hanning( 
.clk   (clk), 
.i     (hanning_i),
.data  (hanning_data)
   );

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        hanning_i <= 'd0;
    else if(p_wr_en)
        hanning_i <= hanning_i+'d1;
    else
        hanning_i <= 'd0;
end

assign p_wr_addr = hanning_i;
assign p_data_3={{8{p_data_2[15]}},p_data_2};
assign hanning_data_3={{16{0}},hanning_data};


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        p_data_4 <= 'd0;
    else
        p_data_4 <= p_data_3*hanning_data_3;
//        p_data_4 <= p_data_3;
end


assign p_data_5=p_data_4>>8;

assign finsh_tiaozhi=(p_wr_addr=='d1023);
/************************************************************************************/
wire[15:0]   a_adta_wr;
reg         a_ram_wr;
reg  [9:0]   a_addr_wr;
reg  [9:0]   a_rd_addr;
wire [15:0]  a_rd_data;
reg  [16:0]  xh5_wr_data/*synthesis PAP_MARK_DEBUG="1"*/;
//reg  [9:0]   xh5_wr_addr;
reg  [9:0]   b_rd_addr;
wire  [15:0]   b_rd_data;
reg         p_wr_en_1;
reg          xh5_wr_en;
reg          xh5_wr_en_1;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        a_ram_wr <= 'd0;
        p_wr_en_1 <= 'd0;
        xh5_wr_en <= 'd0;
        xh5_wr_en_1 <= 'd0;
    end
    else begin
        p_wr_en_1 <= p_wr_en;
        a_ram_wr  <= p_wr_en_1;
        xh5_wr_en  <= a_ram_wr;
        xh5_wr_en_1  <= xh5_wr_en;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        a_addr_wr <= 'd0;
    else if(a_ram_wr)
        a_addr_wr <= a_addr_wr+'d1;
    else
        a_addr_wr <= 'd0;
end
assign a_adta_wr=p_data_5;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        a_rd_addr <= 'd0;
    else if(p_wr_en_1)
        a_rd_addr <= a_rd_addr+'d1;
    else
        a_rd_addr <= 'd0;
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        b_rd_addr <= 'd512;
    else if(p_wr_en_1)
        b_rd_addr <= b_rd_addr+'d1;
    else
        b_rd_addr <= 'd512;
end

wire [16:0] a_rd_data_1;
wire [16:0] b_rd_data_1;
wire [16:0] p_data_5_1;
assign a_rd_data_1 ={a_rd_data[15],a_rd_data};
assign b_rd_data_1 ={b_rd_data[15],b_rd_data};
assign p_data_5_1  ={p_data_5 [15],p_data_5 };
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        xh5_wr_data <= 'd0;
    else if(a_rd_addr<='d511)
        xh5_wr_data <= a_rd_data_1+b_rd_data_1;
    else 
        xh5_wr_data <= a_rd_data_1+p_data_5_1;
end


sram_1024x16  a_ram(
  .wr_data(a_adta_wr),    // input [15:0]
  .wr_addr(a_addr_wr),    // input [9:0]
  .wr_en(a_ram_wr),        // input
  .wr_clk(clk),      	  // input
  .wr_rst(!rst_n),        // input
  .rd_addr(a_rd_addr),    // input [9:0]
  .rd_data(a_rd_data),    // output [15:0]
  .rd_clk(clk),      	  // input
  .rd_rst(!rst_n)         // input
);

sram_1024x16  b_ram(
  .wr_data(a_rd_data),    // input [15:0]
  .wr_addr(a_addr_wr),    // input [9:0]
  .wr_en(a_ram_wr),        // input
  .wr_clk(clk),      	// input
  .wr_rst(!rst_n),      // input
  .rd_addr(b_rd_addr),    // input [9:0]
  .rd_data(b_rd_data),    // output [15:0]
  .rd_clk(clk),      // input
  .rd_rst(!rst_n)       // input
);

/************************************************************************************/
/************************************************************************************/
wire   [9:0]x_h_7_addr;
wire   [8:0]x_h_7_data;
wire   [24:0]x_h_7_data_1;
wire   [24:0]x_h_5/*synthesis PAP_MARK_DEBUG="1"*/;
reg    [24:0] x_h;
//wire    [23:0] x_h_1;
//x_h_7 两个hanning相乘的rom
x_7 u_x_7(
.clk    (clk),
.i      (x_h_7_addr),
.data   (x_h_7_data)
   );
assign x_h_7_addr=a_addr_wr;


assign x_h_7_data_1={{16{0}},x_h_7_data};
assign x_h_5=xh5_wr_data<<8;

reg x_h_en;
wire[24:0] Quotient_x_h_1;
Divider #
(
.A_LEN(25),
.B_LEN(25)
)divide32_x_h
(
		.CLK(clk),
		.EN(x_h_en),
		.RSTN(rst_n),
		.Dividend(x_h_5),
		.Divisor(x_h_7_data_1),
		.Quotient(Quotient_x_h_1),
		.Mod(),
		.RDY(x_h_1_en)
);

reg [9:0]x_h_1_addr;

wire[27:0] x_h_3/*synthesis PAP_MARK_DEBUG="1"*/;

assign x_h_3=Quotient_x_h_1<<3;//音高提高
assign x_h_1={Quotient_x_h_1[24],Quotient_x_h_1[14:0]};
//assign x_h_1_en=xh5_wr_en_1;




always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        x_h_en <= 'd0;
    else if(a_ram_wr&&(x_h_1_addr<'d511))
        x_h_en <= 'd1;
    else
        x_h_en <= 'd0;
end


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        x_h_1_addr <= 'd0;
    else if(xh5_wr_en)
        x_h_1_addr <= x_h_1_addr+'d1;
    else
        x_h_1_addr <= 'd0;
end



/************************************************************************************/




endmodule