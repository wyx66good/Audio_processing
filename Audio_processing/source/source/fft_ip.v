
/*************
Author:wyx
Times :2024.6.24
fft ifft
**************/
module fft_ip (
    input                   i_clk                 ,
    input                   i_rstn                ,

    input    wire           i_axi4s_cfg_tdata     ,//fft 1,iff,0

    output  reg             fft_finish            ,
    input   wire            rd_clk                ,
                                                  
    input        [31:0]     data                  ,
    input  wire             start,
    output  wire            data_en               ,

    input   wire [63:0]     ifft_data                   ,
    output  wire            ifft_en               ,
                                                  
    output  wire [63:0]     data_out              ,
    input   wire [9:0]     fft_addr
);


reg           i_axi4s_cfg_tdata_1;
wire           i_axi4s_cfg_tvalid;
reg            i_axi4s_data_tvalid;
wire [31:0]    i_axi4s_data_tdata ;
reg            i_axi4s_data_tlast ;
wire           o_axi4s_data_tready;
wire           o_axi4s_data_tvalid;
wire  [63:0]   o_axi4s_data_tdata ;
wire           o_axi4s_data_tlast ;
reg            o_axi4s_data_tlast_1 ;
wire  [22:0]   o_axi4s_data_tuser ;
wire           stat;
wire  [2:0]    alm;
wire   [15:0]   fft_Real;
wire   [15:0]   fft_Imaginary;
wire  [31:0]   o_fft_Real_1;
wire  [31:0]   o_fft_Imaginary_1;
wire  [21:0]   o_fft_Real;
wire  [21:0]   o_fft_Imaginary;
reg            i_axi4s_data_tvalid_1;

reg [9:0]cnt;


//wire [31:0] data;
//assign i_axi4s_cfg_tdata='d1;//工作模式的选择 
assign fft_Real=i_axi4s_cfg_tdata?data:{ifft_data[31],ifft_data[14:0]};//实
assign fft_Imaginary=i_axi4s_cfg_tdata?'d0:{ifft_data[63],ifft_data[46:32]};//虚
assign i_axi4s_data_tdata={fft_Imaginary,fft_Real};
assign i_axi4s_cfg_tvalid=1'd1;//(i_axi4s_cfg_tdata&&!i_axi4s_cfg_tdata_1)||(!i_axi4s_cfg_tdata&&i_axi4s_cfg_tdata_1);//动态配置有效指示
assign o_fft_Real_1=o_axi4s_data_tdata[31:0];
assign o_fft_Imaginary_1=o_axi4s_data_tdata[63:32];
assign o_fft_Real=o_fft_Real_1>>10;
assign o_fft_Imaginary=o_fft_Imaginary_1>>10;

assign data_en=i_axi4s_cfg_tdata?i_axi4s_data_tvalid:'d0;
assign ifft_en=i_axi4s_cfg_tdata?'d0:i_axi4s_data_tvalid;



//打拍
always @(posedge i_clk or negedge i_rstn ) begin
    if(!i_rstn) begin
        i_axi4s_data_tvalid_1<='d0;
        i_axi4s_cfg_tdata_1 <='d0;
        o_axi4s_data_tlast_1 <='d0;
    end
    else begin
        i_axi4s_data_tvalid_1<=i_axi4s_data_tvalid;
        i_axi4s_cfg_tdata_1  <=i_axi4s_cfg_tdata;
        o_axi4s_data_tlast_1 <=o_axi4s_data_tlast;
    end

end

//数据帧启动
reg stat_en;
always @(posedge i_clk or negedge i_rstn ) begin
    if(!i_rstn) begin
        stat_en<='d0;
    end
    else if(stat)begin
        stat_en<='d1;
    end
    else if(i_axi4s_data_tlast)begin
        stat_en<='d0;
    end
    else begin
        stat_en<=stat_en;
    end

end



parameter  MWR_IDLE       = 2'd0;
parameter  MWR_TLP_HEADER = 2'd1;
parameter  MWR_TLP_DATA   = 2'd2;
reg [1:0]   mwr_state;
always @(posedge i_clk or negedge i_rstn ) begin
    if(!i_rstn) begin
        mwr_state <=MWR_IDLE;
    end
    else begin 
        case(mwr_state)
            MWR_IDLE:
            begin
                if(o_axi4s_data_tready&&(start)) begin

                    mwr_state <= MWR_TLP_HEADER;
                end
                else begin
                    mwr_state <= mwr_state;
                end
            end 
            MWR_TLP_HEADER:
            begin
                if(o_axi4s_data_tready) begin//当Valid和Ready同时拉高时，进入下一个状态
                    mwr_state <= MWR_TLP_DATA;
                end
                else begin
                    mwr_state <= mwr_state;
                end
            end
            MWR_TLP_DATA:
            begin
                if(i_axi4s_data_tlast) begin //拉高后回归IDLE
                    mwr_state <= MWR_IDLE;
                end
                else begin
                    mwr_state <= mwr_state;
                end
            end
            default:
            begin 
                    mwr_state  <= mwr_state;
            end
        endcase
    end
end


always @(posedge i_clk or negedge i_rstn ) begin
    if(!i_rstn) begin
        i_axi4s_data_tvalid<='d0;
        cnt<='d0;
    end
    else begin 
        case(mwr_state)
            MWR_IDLE:
            begin
                cnt<='d0;
                i_axi4s_data_tlast<='d0;
            end 

            MWR_TLP_HEADER:
            begin
                    i_axi4s_data_tvalid<=1;
                
            end
            MWR_TLP_DATA:
            begin
//                if (i_axi4s_cfg_tdata) begin
                    if(cnt=='d1023)begin
                        i_axi4s_data_tlast<='d1;
                        i_axi4s_data_tvalid<='d0;
                    end
                    cnt<=cnt+'d1;
//                end
//                else begin
//                    if(fft_addr=='d1023)begin
//                        i_axi4s_data_tlast<='d1;
//                        i_axi4s_data_tvalid<='d0;
//                    end
//                end
            end
            default:
            begin 
                i_axi4s_data_tvalid<=i_axi4s_data_tvalid;
            end
        endcase
    end
end
reg [9:0] fft_ram_1024_cnt;
// sin u_sin(
//.i     (cnt),// fft_ram_1024_cnt
//.data (data)
//   );

wire o_en;
assign o_en=o_axi4s_data_tvalid;


always @(posedge i_clk or negedge i_rstn ) begin
    if(!i_rstn) begin
       fft_ram_1024_cnt <='d0;
    end
    else if (o_en)begin
       fft_ram_1024_cnt<=fft_ram_1024_cnt+'d1;
    end
end

always @(posedge i_clk or negedge i_rstn ) begin
    if(!i_rstn) begin
       fft_finish <='d0;
    end
    else if (!o_axi4s_data_tlast&&o_axi4s_data_tlast_1)begin
       fft_finish<='d1;
    end
    else begin
       fft_finish<='d0;
    end
end
//assign fft_finish=((mwr_state==MWR_TLP_HEADER||mwr_state==MWR_TLP_DATA)&&!i_axi4s_cfg_tdata)
//always @(posedge i_clk or negedge i_rstn ) begin
//    if(!i_rstn) begin
//       fft_addr <='d0;
//    end
//    else if ((mwr_state==MWR_TLP_HEADER||mwr_state==MWR_TLP_DATA)&&!i_axi4s_cfg_tdata)begin
//       fft_addr<=fft_addr+'d1;
//    end
//end

fft_ram_1024 u_fft_ram_1024 (
  .wr_data(o_axi4s_data_tdata),    // input [63:0] {32'd0,data}
  .wr_addr(fft_ram_1024_cnt),    // input [9:0]
  .wr_en(o_en),        // input
  .wr_clk(i_clk),      // input
  .wr_rst(!i_rstn),      // input
  .rd_addr(fft_addr),    // input [9:0]
  .rd_data(data_out),    // output [63:0]
  .rd_clk(i_clk),      // input
  .rd_rst(!i_rstn)       // input
);

ipsxb_fft_demo_r2_1024  u_ipsxb_fft_demo_r2_1024 ( 
    .i_aclk                 (i_clk               ),

    .i_axi4s_data_tvalid    (i_axi4s_data_tvalid),
    .i_axi4s_data_tdata     (i_axi4s_data_tdata ),
    .i_axi4s_data_tlast     (i_axi4s_data_tlast ),
    .o_axi4s_data_tready    (o_axi4s_data_tready),
    .i_axi4s_cfg_tvalid     (i_axi4s_cfg_tvalid ),
    .i_axi4s_cfg_tdata      (i_axi4s_cfg_tdata  ),
    .o_axi4s_data_tvalid    (o_axi4s_data_tvalid),
    .o_axi4s_data_tdata     (o_axi4s_data_tdata ),
    .o_axi4s_data_tlast     (o_axi4s_data_tlast ),
    .o_axi4s_data_tuser     (o_axi4s_data_tuser ),
    .o_alm                  (alm                 ),
    .o_stat                 (stat                )
);


endmodule