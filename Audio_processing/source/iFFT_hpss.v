

/*************
Author:wyx
Times :2024.7.9
iFFT_hpss
**************/



module iFFT_hpss(
    input                           clk,
    input                           rst_n,

    input  wire                    start,
    output wire                    ifft_finish,

    output wire                    w_FFT_ON  ,
    input wire         [63:0]      w_fft_data,

    input wire         [63:0]      rd_data_H/*synthesis PAP_MARK_DEBUG="1"*/,
    output  wire         [9:0]     rd_addr_H,

    input wire         [63:0]      rd_data_P/*synthesis PAP_MARK_DEBUG="1"*/,
    output  wire         [9:0]     rd_addr_P,

    output  wire [63:0]            data_out_ifft ,
    input   wire [9:0]             fft_addr_ifft
   );


reg [9:0]  addr;
reg [9:0]  addr_1;
reg [64:0] H_P/*synthesis PAP_MARK_DEBUG="1"*/;
wire [63:0] H_H_P;
wire [31:0] w_fft_data_real/*synthesis PAP_MARK_DEBUG="1"*/;
wire [31:0] w_fft_data_imag;
wire       ifft_en;
reg        start_1;
reg        addr_en;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        start_1 <= 'd0;
    end
    else  begin
        start_1 <= start;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        addr_en <= 'd0;
    end
    else if((start)&&!start_1) begin
        addr_en <= 'd1;
    end
    else if(addr=='d1023) begin
        addr_en <= 'd0;
    end
    else begin
        addr_en <= addr_en;
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        addr <= 'd0;
    end
    else if(addr_en) begin
        addr <= addr+'d1;
    end
end
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        addr_1 <= 'd0;
    end
    else  begin
        addr_1 <= addr;
    end
end
assign rd_addr_H=addr;
assign rd_addr_P=addr;
assign w_FFT_ON   =addr_en;
assign w_fft_data_real=w_fft_data[31:0];
assign w_fft_data_imag=w_fft_data[63:32];

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        H_P <= 'd0;
    else
        H_P <= rd_data_H+rd_data_P;
end

wire   [63:0]  rd_data_H_1/*synthesis PAP_MARK_DEBUG="1"*/; 
wire [63:0] w_fft_data_real_1/*synthesis PAP_MARK_DEBUG="1"*/;
wire [63:0] w_fft_data_imag_1;
wire  [32:0]  H_P_1/*synthesis PAP_MARK_DEBUG="1"*/; 
reg  [63:0]  rd_data_H_2_real/*synthesis PAP_MARK_DEBUG="1"*/; 
reg  [63:0]  rd_data_H_2_imag/*synthesis PAP_MARK_DEBUG="1"*/; 

assign H_P_1=H_P[32:0];
assign rd_data_H_1={32'd0,rd_data_H[31:0]};

assign w_fft_data_real_1={{32{w_fft_data_real[31]}},w_fft_data_real};
assign w_fft_data_imag_1={{32{w_fft_data_imag[31]}},w_fft_data_imag};

always@(posedge clk or negedge rst_n)//3pai
begin
    if(!rst_n)begin
        rd_data_H_2_real <= 'd0;
    end
    else begin
        rd_data_H_2_real <=rd_data_H_1*w_fft_data_real_1;
    end
end
always@(posedge clk or negedge rst_n)//3pai
begin
    if(!rst_n)begin
        rd_data_H_2_imag <= 'd0;
    end
    else begin
        rd_data_H_2_imag <=rd_data_H_1*w_fft_data_imag_1;
    end
end

reg [31:0] w_fft_data_real_2/*synthesis PAP_MARK_DEBUG="1"*/;
reg [31:0] w_fft_data_imag_2;
always @(posedge clk or negedge rst_n) begin
    if ((!rst_n))begin
    	w_fft_data_real_2<='d0;
    	w_fft_data_imag_2<='d0;
    end
    else begin
    	w_fft_data_real_2<=w_fft_data_real;
    	w_fft_data_imag_2<=w_fft_data_imag;
    end
end


wire  [49:0]  rd_data_H_2_real_1/*synthesis PAP_MARK_DEBUG="1"*/; 
wire  [49:0]  rd_data_H_2_imag_1; 

assign rd_data_H_2_real_1=rd_data_H_2_real[49:0];
assign rd_data_H_2_imag_1=rd_data_H_2_imag[49:0];

wire rdy/*synthesis PAP_MARK_DEBUG="1"*/;
wire [49:0] Quotient_real_1/*synthesis PAP_MARK_DEBUG="1"*/;
wire [49:0] Quotient_imag_1;
reg [31:0] Quotient_real/*synthesis PAP_MARK_DEBUG="1"*/;
reg [31:0] Quotient_imag;
reg start_2;
reg start_3;
reg start_4;
reg [49:0] start_5;
wire  start_6;


//Divider #
//(
//.A_LEN(50),
//.B_LEN(33)
//)divide32_real
//(
//		.CLK(clk),
//		.EN(start_2),
//		.RSTN(rst_n),
//		.Dividend(rd_data_H_2_real_1),
//		.Divisor(H_P_1),
////		.Dividend(w_fft_data_real_2),
////		.Divisor(32'd1),
//		.Quotient(Quotient_real_1),
//		.Mod(),
//		.RDY(rdy)
//);
//
//always @(posedge clk or negedge rst_n) begin
//    if ((!rst_n))begin
//    	start_5<='d0;
//    end
//    else begin
//    	start_5<={start_5[49-1:0] , start_2};
//    end
//end
//assign start_6=start_5[49-2];


//Divider #
//(
//.A_LEN(50),
//.B_LEN(33)
//)divide32_imag
//(
//		.CLK(clk),
//		.EN(start_2),
//		.RSTN(rst_n),
//		.Dividend(rd_data_H_2_imag_1),
//		.Divisor(H_P_1),
////		.Dividend(w_fft_data_imag_2),
////		.Divisor(32'd1),
//		.Quotient(Quotient_imag_1),
//		.Mod(),
//		.RDY(rdy1)
//);

always @(posedge clk or negedge rst_n) begin
    if ((!rst_n))begin
    	Quotient_real<='d0;
    	Quotient_imag<='d0;
    end
    else if(rd_data_H>=rd_data_P) begin
    	Quotient_real<=w_fft_data_real;
    	Quotient_imag<=w_fft_data_imag;
    end
    else  begin
    	Quotient_real<='d0;
    	Quotient_imag<='d0;
    end
end


//assign Quotient_real=(rd_data_H>=rd_data_P)?w_fft_data_real:'d0;
//assign Quotient_imag=(rd_data_H>=rd_data_P)?w_fft_data_imag:'d0;

//assign Quotient_real=Quotient_real_1[31:0];
//assign Quotient_imag=Quotient_imag_1[31:0];

assign H_H_P={Quotient_imag,Quotient_real};








always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        start_4 <= 'd0;
        start_2 <= 'd0;
        start_3 <= 'd0;

    end
    else  begin
        start_4 <= addr_en;
        start_2 <= start_4;
        start_3 <= start_2;

    end
end






 fft_ip ifft_ip(
 .i_clk               (clk)   ,
 .i_rstn              (rst_n)  ,
 .i_axi4s_cfg_tdata   ('d0)  ,//fft 1,iff,0
 .fft_finish          (ifft_finish)  ,
 .rd_clk              (clk)  ,                  
 .data                ()  ,
 .start               (addr_en),
 .data_en             ()  ,
 .ifft_data           (H_H_P)        ,
 .ifft_en             (ifft_en)  ,            //а╫ед          
 .data_out            (data_out_ifft)  ,
 .fft_addr            (fft_addr_ifft)
 );










endmodule