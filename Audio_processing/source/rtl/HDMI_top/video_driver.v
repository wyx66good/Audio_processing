/*****************************************************************/
//
// Create Date: 2023/09/24
// Design Name: WenYiXing
//
/*****************************************************************/

module video_driver#(
    parameter X_BITS    = 12        ,
    parameter Y_BITS    = 12        ,

    parameter H_SYNC    = 12'd44    , //行同步
    parameter H_BACK    = 12'd148   , //行显示后沿
    parameter H_DISP    = 12'd1920  , //行有效数据
    parameter H_FRONT   = 12'd88    , //行显示前沿
    parameter H_TOTAL   = 12'd2200  , //行扫描周期

    parameter V_SYNC    = 12'd5     , //场同步
    parameter V_BACK    = 12'd36    , //场显示后沿
    parameter V_DISP    = 12'd1080  , //场有效数据
    parameter V_FRONT   = 12'd4     , //场显示前沿
    parameter V_TOTAL   = 12'd1125    //场扫描周期
)(
    input   wire                    pix_clk     ,
    input   wire                    rst_n       ,
   
    output  wire                    video_hs    /*synthesis PAP_MARK_DEBUG="1"*/,
    output  wire                    video_vs    /*synthesis PAP_MARK_DEBUG="1"*/,

    output  wire                    video_de   /*synthesis PAP_MARK_DEBUG="1"*/ ,

    output  reg    [23:0]           video_data  /*synthesis PAP_MARK_DEBUG="1"*/,
    
    output  wire                    pix_req    , // 请求像素数据输入（像素点坐标提前实际时序一个周期）
    input   wire    [23:0]          pix_data   
);
/****************************reg*****************************/
reg     [X_BITS-1:0]    cnt_h   /*synthesis PAP_MARK_DEBUG="1"*/; // 行计数器
reg     [X_BITS-1:0]    cnt_v   /*synthesis PAP_MARK_DEBUG="1"*/; // 场计数器


/****************************wire****************************/
wire                    video_en/*synthesis PAP_MARK_DEBUG="1"*/; // 输出数据有效信号

/********************combinational logic*********************/

assign video_hs  = ( cnt_h < H_SYNC ) ? 1'b1 : 1'b0; // 行同步信号赋值
assign video_vs  = ( cnt_v < V_SYNC||cnt_v == (V_SYNC + V_BACK + V_DISP ) ) ? 1'b1 : 1'b0; // 场同步信号赋值

assign video1_vs  = ( cnt_v <( V_SYNC )||cnt_v == (V_SYNC + V_BACK + V_DISP ) ) ? 1'b1 : 1'b0; // 场同步信号赋值


assign video_en  = (((cnt_h >= H_SYNC+H_BACK) && (cnt_h < H_SYNC+H_BACK+H_DISP))
                 &&((cnt_v >= V_SYNC+V_BACK) && (cnt_v < V_SYNC+V_BACK+V_DISP)))
                 ?  1'b1 : 1'b0;


assign video_de  = video_en;

//视频0
assign pix_req    = (((cnt_h >= H_SYNC+H_BACK-1'b1) && 
                   (cnt_h < H_SYNC+H_BACK+'d1920-1'b1))
                   && ((cnt_v >= V_SYNC+V_BACK) && (cnt_v < V_SYNC+V_BACK+'d1080)))
                   ? 1'b1 : 1'b0;


/**************************process***************************/
// 读数据使能
always@(*)
begin
         if(!rst_n)
            video_data<={8'h00,8'hff,8'hff};
        else if(video_en) 
            video_data<={8'h00,8'hff,8'hff};
        else 
            video_data<={8'h00,8'hff,8'hff};
end

always@(posedge pix_clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_h <= 'd0;
    else if(cnt_h <= H_TOTAL - 1)
        cnt_h <= cnt_h + 1;
    else
        cnt_h <= 'd0;
end

always@(posedge pix_clk or negedge rst_n)
begin
    if(!rst_n)
        cnt_v <= 'd0;
    else if(cnt_h == H_TOTAL - 1)
        if(cnt_v <= V_TOTAL - 1)
            cnt_v <= cnt_v + 1;
        else
            cnt_v <= 'd0;
    else
        cnt_v <= cnt_v;
end


endmodule
