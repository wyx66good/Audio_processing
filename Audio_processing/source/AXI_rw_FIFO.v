/*****************************************************************/
//
// Create Date: 2024/04/25
// Design Name: WenYiXing
//
/*****************************************************************///************************************************

module AXI_rw_FIFO#(
    parameter AXI_DATA_WIDTH    = 256       , // AXI数据位宽
    parameter MEM_BURST_LEN     = 8         , // DDR突发长度
    parameter FIFO_DATA_WIDTH   = 32        , // FIFO用户端数据位宽
    parameter MEM_H_PIXEL       = 960       , // 写入一帧数据行像素
    parameter DISP_H            = 960       , // 读出一帧数据行像素
    parameter video_o_h         =960           // 读出每个画面一帧数据行像素
)(
    input   wire                                ddrphy_clkin        ,
    input   wire                                rst_n               ,
    
    input   wire                                video0_wr_clk       ,
    input   wire                                video0_wr_en        ,
    input   wire    [FIFO_DATA_WIDTH-1:0]       video0_wr_data      ,
    input   wire                                video0_wr_rst       ,

    input   wire                                video1_wr_clk       ,
    input   wire                                video1_wr_en        ,
    input   wire    [FIFO_DATA_WIDTH-1:0]       video1_wr_data      ,
    input   wire                                video1_wr_rst       ,

    input   wire                                video2_wr_clk       ,
    input   wire                                video2_wr_en        ,
    input   wire    [FIFO_DATA_WIDTH-1:0]       video2_wr_data      ,
    input   wire                                video2_wr_rst       ,

    input   wire                                video3_wr_clk       ,
    input   wire                                video3_wr_en        ,
    input   wire    [FIFO_DATA_WIDTH-1:0]       video3_wr_data      ,
    input   wire                                video3_wr_rst       /*synthesis PAP_MARK_DEBUG="1"*/,
    
    input   wire                                fifo_rd_clk         ,
    input   wire                                fifo_rd_en          /*synthesis PAP_MARK_DEBUG="1"*/,
    output  wire    [FIFO_DATA_WIDTH-1:0]       fifo_rd_data        /*synthesis PAP_MARK_DEBUG="1"*/,
    input   wire                                fifo_rd_rst         /*synthesis PAP_MARK_DEBUG="1"*/,
    
    input   wire                                fifo_rd1_clk         ,
    input   wire                                fifo_rd1_en          /*synthesis PAP_MARK_DEBUG="1"*/,
    output  wire    [FIFO_DATA_WIDTH-1:0]       fifo_rd1_data        /*synthesis PAP_MARK_DEBUG="1"*/,
    input   wire                                fifo_rd1_rst         /*synthesis PAP_MARK_DEBUG="1"*/,

    input   wire                                fifo_rd2_clk         ,
    input   wire                                fifo_rd2_en          /*synthesis PAP_MARK_DEBUG="1"*/,
    output  wire    [FIFO_DATA_WIDTH-1:0]       fifo_rd2_data       /*synthesis PAP_MARK_DEBUG="1"*/ ,
    input   wire                                fifo_rd2_rst        /*synthesis PAP_MARK_DEBUG="1"*/ ,

    input   wire                                fifo_rd3_en         /*synthesis PAP_MARK_DEBUG="1"*/ ,
    output  wire    [FIFO_DATA_WIDTH-1:0]       fifo_rd3_data       /*synthesis PAP_MARK_DEBUG="1"*/ ,
    input   wire                                fifo_rd3_rst         /*synthesis PAP_MARK_DEBUG="1"*/,
    
    output  wire    [3:0]                       axi_wr_req          /*synthesis PAP_MARK_DEBUG="1"*/,
    
    input   wire                                axi_video0_wr_en    ,
    output  wire    [AXI_DATA_WIDTH-1:0]        axi_video0_wr_data  ,
    input   wire                                axi_video1_wr_en    ,
    output  wire    [AXI_DATA_WIDTH-1:0]        axi_video1_wr_data  ,
    input   wire                                axi_video2_wr_en    ,
    output  wire    [AXI_DATA_WIDTH-1:0]        axi_video2_wr_data  ,
    input   wire                                axi_video3_wr_en    ,
    output  wire    [AXI_DATA_WIDTH-1:0]        axi_video3_wr_data  ,
    
    input   wire                                axi_rd_en           /*synthesis PAP_MARK_DEBUG="1"*/,
    input   wire    [AXI_DATA_WIDTH-1:0]        axi_rd_data         /*synthesis PAP_MARK_DEBUG="1"*/,

    input   wire                                axi_rd1_en           /*synthesis PAP_MARK_DEBUG="1"*/,
    input   wire    [AXI_DATA_WIDTH-1:0]        axi_rd1_data         /*synthesis PAP_MARK_DEBUG="1"*/,

    input   wire                                axi_rd2_en           /*synthesis PAP_MARK_DEBUG="1"*/,
    input   wire    [AXI_DATA_WIDTH-1:0]        axi_rd2_data         /*synthesis PAP_MARK_DEBUG="1"*/,

    input   wire                                axi_rd3_en           /*synthesis PAP_MARK_DEBUG="1"*/,
    input   wire    [AXI_DATA_WIDTH-1:0]        axi_rd3_data         /*synthesis PAP_MARK_DEBUG="1"*/,
    
    output  wire    [3:0]                       axi_rd_req          /*synthesis PAP_MARK_DEBUG="1"*/,

    output  wire                                fifo_video0_full    ,
    output  wire                                fifo_video1_full    ,
    output  wire                                fifo_o1_full         ,

    //缩放分辨率
    input wire [15:0] vout_xres
);
/****************************reg*****************************/
reg     [15:0]              r_fifo_o_rst            ;
reg                         fifo_o_rst_posedge      ;
reg                         fifo_o_rst_posedge_d    ;
reg     [ 9:0]              r_cnt_fifo_o_rst        ;

reg     [15:0]              r_fifo_o1_rst            ;
reg                         fifo_o1_rst_posedge      ;
reg                         fifo_o1_rst_posedge_d    ;
reg     [ 9:0]              r_cnt_fifo_o1_rst        ;

reg     [15:0]              r_fifo_o2_rst            ;
reg                         fifo_o2_rst_posedge      ;
reg                         fifo_o2_rst_posedge_d    ;
reg     [ 9:0]              r_cnt_fifo_o2_rst        ;

reg     [15:0]              r_fifo_o3_rst            ;
reg                         fifo_o3_rst_posedge      ;
reg                         fifo_o3_rst_posedge_d    /*synthesis PAP_MARK_DEBUG="1"*/;
reg     [ 9:0]              r_cnt_fifo_o3_rst        ;


reg     [15:0]              r_fifo_video0_rst       ;
reg                         fifo_video0_rst_posedge ;
reg     [15:0]              r_fifo_video1_rst       ;
reg                         fifo_video1_rst_posedge ;
reg     [15:0]              r_fifo_video2_rst       ;
reg                         fifo_video2_rst_posedge ;
reg     [15:0]              r_fifo_video3_rst       ;
reg                         fifo_video3_rst_posedge /*synthesis PAP_MARK_DEBUG="1"*/;

reg                         axi_video0_wr_req       /*synthesis PAP_MARK_DEBUG="1"*/;
reg                         axi_video1_wr_req       ;
reg                         axi_video2_wr_req       ;
reg                         axi_video3_wr_req       ;

reg                         axi_rd0_req       /*synthesis PAP_MARK_DEBUG="1"*/;
reg                         axi_rd1_req       /*synthesis PAP_MARK_DEBUG="1"*/;
reg                         axi_rd2_req       /*synthesis PAP_MARK_DEBUG="1"*/;
reg                         axi_rd3_req       /*synthesis PAP_MARK_DEBUG="1"*/;

/****************************wire****************************/
wire    [8:0]               fifo_video0_water_level /*synthesis PAP_MARK_DEBUG="1"*/;
wire    [8:0]               fifo_video1_water_level /*synthesis PAP_MARK_DEBUG="1"*/;
wire    [8:0]               fifo_video2_water_level /*synthesis PAP_MARK_DEBUG="1"*/;
wire    [8:0]               fifo_video3_water_level /*synthesis PAP_MARK_DEBUG="1"*/;
wire    [9:0]               fifo_o_water_level      /*synthesis PAP_MARK_DEBUG="1"*/;
wire    [9:0]               fifo_o1_water_level      /*synthesis PAP_MARK_DEBUG="1"*/;
wire    [9:0]               fifo_o2_water_level      /*synthesis PAP_MARK_DEBUG="1"*/;
wire    [9:0]               fifo_o3_water_level     /*synthesis PAP_MARK_DEBUG="1"*/ ;



wire                        fifo_video0_almost_full ;
wire                        fifo_video1_almost_full ;
wire                        fifo_video2_almost_full ;
wire                        fifo_video3_almost_full ;
wire                        fifo_o_almost_empty     ;
wire                        fifo_o1_almost_empty     ;
wire                        fifo_o2_almost_empty     ;
wire                        fifo_o3_almost_empty     ;


/********************combinational logic*********************/
//assign axi_wr_req               = {axi_video3_wr_req, axi_video2_wr_req, axi_video1_wr_req, axi_video0_wr_req};
//assign axi_rd_req               = {axi_rd3_req, axi_rd2_req, axi_rd1_req, axi_rd0_req};
assign axi_wr_req               = {'d0, axi_video2_wr_req, axi_video1_wr_req, axi_video0_wr_req};
assign axi_rd_req               = {'d0, axi_rd2_req, axi_rd1_req, axi_rd0_req};

assign fifo_video0_almost_full  = (fifo_video0_water_level >= (MEM_H_PIXEL / MEM_BURST_LEN));
assign fifo_video1_almost_full  = (fifo_video1_water_level >= (MEM_H_PIXEL / MEM_BURST_LEN));
assign fifo_video2_almost_full  = (fifo_video2_water_level >= (MEM_H_PIXEL / MEM_BURST_LEN));
assign fifo_video3_almost_full  = (fifo_video3_water_level >= (MEM_H_PIXEL / MEM_BURST_LEN));
assign fifo_o_almost_empty      = (fifo_o_water_level <= (MEM_H_PIXEL / MEM_BURST_LEN) - 1);
assign fifo_o1_almost_empty      = (fifo_o1_water_level <= (MEM_H_PIXEL / MEM_BURST_LEN) - 1);
assign fifo_o2_almost_empty      = (fifo_o2_water_level <= (MEM_H_PIXEL / MEM_BURST_LEN) - 1);
assign fifo_o3_almost_empty      = (fifo_o3_water_level <= (MEM_H_PIXEL / MEM_BURST_LEN) - 1);



/***********************instantiation************************/
axi_fifo_video u_axi_fifo_video0(
    .wr_clk             (video0_wr_clk      ), // input
    .wr_rst             (!rst_n || fifo_video0_rst_posedge), // input
    .wr_en              (video0_wr_en       ), // input
    .wr_data            (video0_wr_data     ), // input [31:0]
    .wr_full            (fifo_video0_full   ), // output
    .almost_full        (                   ), // output
    .rd_clk             (ddrphy_clkin       ), // input
    .rd_rst             (!rst_n || fifo_video0_rst_posedge), // input
    .rd_en              (axi_video0_wr_en   ), // input
    .rd_data            (axi_video0_wr_data ), // output [255:0]
    .rd_empty           (                   ), // output
    .almost_empty       (                   ), // output
    .rd_water_level     (fifo_video0_water_level)  // output [8:0]
);

axi_fifo_video u_axi_fifo_video1(
    .wr_clk             (video1_wr_clk      ), // input
    .wr_rst             (!rst_n || fifo_video1_rst_posedge), // input
    .wr_en              (video1_wr_en       ), // input
    .wr_data            (video1_wr_data     ), // input [31:0]
    .wr_full            (fifo_video1_full   ), // output
    .almost_full        (                   ), // output
    .rd_clk             (ddrphy_clkin       ), // input
    .rd_rst             (!rst_n || fifo_video1_rst_posedge), // input
    .rd_en              (axi_video1_wr_en   ), // input
    .rd_data            (axi_video1_wr_data ), // output [255:0]
    .rd_empty           (                   ), // output
    .almost_empty       (                   ), // output
    .rd_water_level     (fifo_video1_water_level)  // output [9:0]
);

axi_fifo_video u_axi_fifo_video2(
    .wr_clk             (video2_wr_clk      ), // input
    .wr_rst             (!rst_n || fifo_video2_rst_posedge), // input
    .wr_en              (video2_wr_en       ), // input
    .wr_data            (video2_wr_data     ), // input [31:0]
    .wr_full            (fifo_video2_full   ), // output
    .almost_full        (                   ), // output
    .rd_clk             (ddrphy_clkin       ), // input
    .rd_rst             (!rst_n || fifo_video2_rst_posedge), // input
    .rd_en              (axi_video2_wr_en   ), // input
    .rd_data            (axi_video2_wr_data ), // output [255:0]
    .rd_empty           (                   ), // output
    .almost_empty       (                   ), // output
    .rd_water_level     (fifo_video2_water_level)  // output [9:0]
);

axi_fifo_video u_axi_fifo_video3(
    .wr_clk             (video3_wr_clk      ), // input
    .wr_rst             (!rst_n || fifo_video3_rst_posedge), // input
    .wr_en              (video3_wr_en       ), // input
    .wr_data            (video3_wr_data     ), // input [31:0]
    .wr_full            (fifo_video3_full   ), // output
    .almost_full        (                   ), // output
    .rd_clk             (ddrphy_clkin       ), // input
    .rd_rst             (!rst_n || fifo_video3_rst_posedge), // input
    .rd_en              (axi_video3_wr_en   ), // input
    .rd_data            (axi_video3_wr_data ), // output [255:0]
    .rd_empty           (                   ), // output
    .almost_empty       (                   ), // output
    .rd_water_level     (fifo_video3_water_level)  // output [9:0]
);

axi_fifo_o u_axi_fifo_o(
    .wr_clk             (ddrphy_clkin       ), // input
    .wr_rst             (!rst_n || fifo_o_rst_posedge_d), // input
    .wr_en              (axi_rd_en          ), // input
    .wr_data            (axi_rd_data        ), // input [255:0]
    .wr_full            (fifo_o_full        ), // output
    .almost_full        (                   ), // output
    .wr_water_level     (fifo_o_water_level ), // output [9:0]
    .rd_clk             (fifo_rd_clk        ), // input
    .rd_rst             (!rst_n || fifo_o_rst_posedge_d), // input
    .rd_en              (fifo_rd_en         ), // input
    .rd_data            (fifo_rd_data       ), // output [31:0]
    .rd_empty           (                   ), // output
    .almost_empty       (                   )  // output
);

axi_fifo_o u_axi_fifo_o1(
    .wr_clk             (ddrphy_clkin       ), // input
    .wr_rst             (!rst_n || fifo_o1_rst_posedge_d), // input
    .wr_en              (axi_rd1_en          ), // input
    .wr_data            (axi_rd1_data        ), // input [255:0]
    .wr_full            (fifo_o1_full        ), // output
    .almost_full        (                   ), // output
    .wr_water_level     (fifo_o1_water_level ), // output [9:0]
    .rd_clk             (fifo_rd1_clk        ), // input
    .rd_rst             (!rst_n || fifo_o1_rst_posedge_d), // input
    .rd_en              (fifo_rd1_en         ), // input
    .rd_data            (fifo_rd1_data       ), // output [31:0]
    .rd_empty           (                   ), // output
    .almost_empty       (                   )  // output
);

axi_fifo_o u_axi_fifo_o2(
    .wr_clk             (ddrphy_clkin       ), // input
    .wr_rst             (!rst_n || fifo_o2_rst_posedge_d), // input
    .wr_en              (axi_rd2_en          ), // input
    .wr_data            (axi_rd2_data        ), // input [255:0]
    .wr_full            (fifo_o2_full        ), // output
    .almost_full        (                   ), // output
    .wr_water_level     (fifo_o2_water_level ), // output [9:0]
    .rd_clk             (fifo_rd2_clk        ), // input
    .rd_rst             (!rst_n || fifo_o2_rst_posedge_d), // input
    .rd_en              (fifo_rd2_en         ), // input
    .rd_data            (fifo_rd2_data       ), // output [31:0]
    .rd_empty           (                   ), // output
    .almost_empty       (                   )  // output
);

axi_fifo_o u_axi_fifo_o3(
    .wr_clk             (ddrphy_clkin       ), // input
    .wr_rst             (!rst_n || fifo_o3_rst_posedge_d), // input
    .wr_en              (axi_rd3_en          ), // input
    .wr_data            (axi_rd3_data        ), // input [255:0]
    .wr_full            (fifo_o3_full        ), // output
    .almost_full        (                   ), // output
    .wr_water_level     (fifo_o3_water_level ), // output [9:0]
    .rd_clk             (fifo_rd_clk        ), // input
    .rd_rst             (!rst_n || fifo_o3_rst_posedge_d), // input
    .rd_en              (fifo_rd3_en         ), // input
    .rd_data            (fifo_rd3_data       ), // output [31:0]
    .rd_empty           (                   ), // output
    .almost_empty       (                   )  // output
);

/**************************process***************************/
// FIFO模块对AXI接口发出的读写请求信号
always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        axi_video0_wr_req <= 1'b0;
    else if(fifo_video0_almost_full)
        axi_video0_wr_req <= 1'b1;
    else
        axi_video0_wr_req <= 1'b0;
end

always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        axi_video1_wr_req <= 1'b0;
    else if(fifo_video1_almost_full)
        axi_video1_wr_req <= 1'b1;
    else
        axi_video1_wr_req <= 1'b0;
end

always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        axi_video2_wr_req <= 1'b0;
    else if(fifo_video2_almost_full)
        axi_video2_wr_req <= 1'b1;
    else
        axi_video2_wr_req <= 1'b0;
end

always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        axi_video3_wr_req <= 1'b0;
    else if(fifo_video3_almost_full)
        axi_video3_wr_req <= 1'b1;
    else
        axi_video3_wr_req <= 1'b0;
end

always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        axi_rd0_req <= 1'b0;
    else if( fifo_o_almost_empty && (r_cnt_fifo_o_rst == 10'd1000)) // 输出FIFO复位后等待10ms再发出读请求信号
        axi_rd0_req <= 1'b1;
    else
        axi_rd0_req <= 1'b0;
end

always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        axi_rd1_req <= 1'b0;
    else if(fifo_o1_almost_empty&& (r_cnt_fifo_o1_rst == 10'd1000) ) // 输出FIFO复位后等待10ms再发出读请求信号
        axi_rd1_req <= 1'b1;
    else
        axi_rd1_req <= 1'b0;
end

always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        axi_rd2_req <= 1'b0;
    else if(fifo_o2_almost_empty&& (r_cnt_fifo_o2_rst == 10'd1000) ) // 输出FIFO复位后等待10ms再发出读请求信号
        axi_rd2_req <= 1'b1;
    else
        axi_rd2_req <= 1'b0;
end

always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        axi_rd3_req <= 1'b0;
    else if( fifo_o3_almost_empty && (r_cnt_fifo_o3_rst == 10'd1000)) // 输出FIFO复位后等待10ms再发出读请求信号
        axi_rd3_req <= 1'b1;
    else
        axi_rd3_req <= 1'b0;
end
//!fifo_video3_almost_full && !fifo_video2_almost_full && !fifo_video1_almost_full && !fifo_video0_almost_full && fifo_o3_almost_empty && (r_cnt_fifo_o3_rst == 10'd1000)
/*---------------------------------------------------*/
// 输入FIFO_video0的复位信号持续16个周期高电平
always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        r_fifo_video0_rst <= 16'd0;
    else
        r_fifo_video0_rst <= {r_fifo_video0_rst[15:0], video0_wr_rst};
end

always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        fifo_video0_rst_posedge <= 1'b0;
    else if(!r_fifo_video0_rst[15] && r_fifo_video0_rst[0])
        fifo_video0_rst_posedge <= 1'b1;
    else
        fifo_video0_rst_posedge <= 1'b0;
end


// 输入FIFO_video1的复位信号持续16个周期高电平
always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        r_fifo_video1_rst <= 16'd0;
    else
        r_fifo_video1_rst <= {r_fifo_video1_rst[15:0], video1_wr_rst};
end

always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        fifo_video1_rst_posedge <= 1'b0;
    else if(!r_fifo_video1_rst[15] && r_fifo_video1_rst[0])
        fifo_video1_rst_posedge <= 1'b1;
    else
        fifo_video1_rst_posedge <= 1'b0;
end

// 输入FIFO_video2的复位信号持续16个周期高电平
always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        r_fifo_video2_rst <= 16'd0;
    else
        r_fifo_video2_rst <= {r_fifo_video2_rst[15:0], video2_wr_rst};
end

always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        fifo_video2_rst_posedge <= 1'b0;
    else if(!r_fifo_video2_rst[15] && r_fifo_video2_rst[0])
        fifo_video2_rst_posedge <= 1'b1;
    else
        fifo_video2_rst_posedge <= 1'b0;
end

// 输入FIFO_video3的复位信号持续16个周期高电平
always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        r_fifo_video3_rst <= 16'd0;
    else
        r_fifo_video3_rst <= {r_fifo_video3_rst[15:0], video3_wr_rst};
end

always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        fifo_video3_rst_posedge <= 1'b0;
    else if(!r_fifo_video3_rst[15] && r_fifo_video3_rst[0])
        fifo_video3_rst_posedge <= 1'b1;
    else
        fifo_video3_rst_posedge <= 1'b0;
end

// 输出FIFO的复位信号持续16个周期高电平00000
always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        r_fifo_o_rst <= 16'd0;
    else
        r_fifo_o_rst <= {r_fifo_o_rst[15:0], fifo_rd_rst};
end

always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        fifo_o_rst_posedge <= 1'b0;
    else if(!r_fifo_o_rst[15] && r_fifo_o_rst[0])
        fifo_o_rst_posedge <= 1'b1;
    else
        fifo_o_rst_posedge <= 1'b0;
end

// 由于FIFO是异步复位，因此将复位信号延迟一个周期给FIFO，让计数器先清零
always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        fifo_o_rst_posedge_d <= 1'b0;
    else
        fifo_o_rst_posedge_d <= fifo_o_rst_posedge;
end

// 在输出FIFO复位后计数器开始计时
always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        r_cnt_fifo_o_rst <= 10'd0;
    else if(fifo_o_rst_posedge)
        r_cnt_fifo_o_rst <= 10'd0;
    else if(r_cnt_fifo_o_rst == 10'd1000)
        r_cnt_fifo_o_rst <= r_cnt_fifo_o_rst;
    else
        r_cnt_fifo_o_rst <= r_cnt_fifo_o_rst + 1'b1;
end

// 输出FIFO的复位信号持续16个周期高电平1111
always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        r_fifo_o1_rst <= 16'd0;
    else
        r_fifo_o1_rst <= {r_fifo_o1_rst[15:0], fifo_rd1_rst};
end

always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        fifo_o1_rst_posedge <= 1'b0;
    else if(!r_fifo_o1_rst[15] && r_fifo_o1_rst[0])
        fifo_o1_rst_posedge <= 1'b1;
    else
        fifo_o1_rst_posedge <= 1'b0;
end

// 由于FIFO是异步复位，因此将复位信号延迟一个周期给FIFO，让计数器先清零
always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        fifo_o1_rst_posedge_d <= 1'b0;
    else
        fifo_o1_rst_posedge_d <= fifo_o1_rst_posedge;
end

// 在输出FIFO复位后计数器开始计时
always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        r_cnt_fifo_o1_rst <= 10'd0;
    else if(fifo_o1_rst_posedge)
        r_cnt_fifo_o1_rst <= 10'd0;
    else if(r_cnt_fifo_o1_rst == 10'd1000)
        r_cnt_fifo_o1_rst <= r_cnt_fifo_o1_rst;
    else
        r_cnt_fifo_o1_rst <= r_cnt_fifo_o1_rst + 1'b1;
end

// 输出FIFO的复位信号持续16个周期高电平2222
always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        r_fifo_o2_rst <= 16'd0;
    else
        r_fifo_o2_rst <= {r_fifo_o2_rst[15:0], fifo_rd2_rst};
end

always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        fifo_o2_rst_posedge <= 1'b0;
    else if(!r_fifo_o2_rst[15] && r_fifo_o2_rst[0])
        fifo_o2_rst_posedge <= 1'b1;
    else
        fifo_o2_rst_posedge <= 1'b0;
end

// 由于FIFO是异步复位，因此将复位信号延迟一个周期给FIFO，让计数器先清零
always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        fifo_o2_rst_posedge_d <= 1'b0;
    else
        fifo_o2_rst_posedge_d <= fifo_o2_rst_posedge;
end

// 在输出FIFO复位后计数器开始计时
always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        r_cnt_fifo_o2_rst <= 10'd0;
    else if(fifo_o2_rst_posedge)
        r_cnt_fifo_o2_rst <= 10'd0;
    else if(r_cnt_fifo_o2_rst == 10'd1000)
        r_cnt_fifo_o2_rst <= r_cnt_fifo_o2_rst;
    else
        r_cnt_fifo_o2_rst <= r_cnt_fifo_o2_rst + 1'b1;
end

// 输出FIFO的复位信号持续16个周期高电平333333
always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        r_fifo_o3_rst <= 16'd0;
    else
        r_fifo_o3_rst <= {r_fifo_o3_rst[15:0], fifo_rd3_rst};
end

always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        fifo_o3_rst_posedge <= 1'b0;
    else if(!r_fifo_o3_rst[15] && r_fifo_o3_rst[0])
        fifo_o3_rst_posedge <= 1'b1;
    else
        fifo_o3_rst_posedge <= 1'b0;
end

// 由于FIFO是异步复位，因此将复位信号延迟一个周期给FIFO，让计数器先清零
always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        fifo_o3_rst_posedge_d <= 1'b0;
    else
        fifo_o3_rst_posedge_d <= fifo_o3_rst_posedge;
end

// 在输出FIFO复位后计数器开始计时
always@(posedge ddrphy_clkin or negedge rst_n)
begin
    if(!rst_n)
        r_cnt_fifo_o3_rst <= 10'd0;
    else if(fifo_o3_rst_posedge)
        r_cnt_fifo_o3_rst <= 10'd0;
    else if(r_cnt_fifo_o3_rst == 10'd1000)
        r_cnt_fifo_o3_rst <= r_cnt_fifo_o3_rst;
    else
        r_cnt_fifo_o3_rst <= r_cnt_fifo_o3_rst + 1'b1;
end

endmodule
