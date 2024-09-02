//Author:wyx
//Times :2024.4.16



module pcie_dma(
    input     wire              clk                   ,
    input     wire              rstn                  ,
              
    //voice in
    input     wire              es0_dsclk,
    input     wire              es7243_init,
    input     wire [15:0]       rx_data  /* synthesis PAP_MARK_DEBUG="1" */ ,
    input     wire              rx_r_vld ,
    input     wire              rx_l_vld ,
    output    reg                 start,


    input     wire              axis_master_tvalid    ,
    output    wire              axis_master_tready    ,
    input     wire    [127:0]   axis_master_tdata     ,
    input     wire    [3:0]     axis_master_tkeep     ,
    input     wire              axis_master_tlast     ,
    input     wire    [7:0]     axis_master_tuser     ,

    input  [7 : 0]              ep_bus_num      ,
    input  [4 : 0]              ep_dev_num      ,

    input   wire                 axis_slave2_tready     ,
    output  wire                 axis_slave2_tvalid     ,
    output  wire       [127:0]   axis_slave2_tdata       /* synthesis PAP_MARK_DEBUG="1" */,
    output  wire                 axis_slave2_tlast      ,
    output  wire                 axis_slave2_tuser      


   );

wire [13 : 0]    rd_water_level /* synthesis PAP_MARK_DEBUG="1" */;
//分配的帧缓存地址
reg [3 : 0]   alloc_addr_state    /* synthesis PAP_MARK_DEBUG="1" */;
reg [1 : 0]   addr_page           /* synthesis PAP_MARK_DEBUG="1" */;
reg [31: 0]   dma_addr0           /* synthesis PAP_MARK_DEBUG="1" */;
reg [31: 0]   dma_addr1           /* synthesis PAP_MARK_DEBUG="1" */;
reg [31: 0]   dma_addr2           /* synthesis PAP_MARK_DEBUG="1" */;
reg [31: 0]   dma_addr3           /* synthesis PAP_MARK_DEBUG="1" */;
reg           dma_addr_cfg_flag   /* synthesis PAP_MARK_DEBUG="1" */;
reg           dma_stop_flag       /* synthesis PAP_MARK_DEBUG="1" */;
              
reg [127:0]   axis_master_tdata_d0    /* synthesis PAP_MARK_DEBUG="1" */;
reg           axis_master_tvalid_d0   /* synthesis PAP_MARK_DEBUG="1" */;
reg           axis_master_tvalid_d1   /* synthesis PAP_MARK_DEBUG="1" */;
reg [2 : 0]   tlp_fmt             /* synthesis PAP_MARK_DEBUG="1" */;
reg [4 : 0]   tlp_type            /* synthesis PAP_MARK_DEBUG="1" */;
reg           mwr32               /* synthesis PAP_MARK_DEBUG="1" */;
reg [31: 0]   mwr_addr            /* synthesis PAP_MARK_DEBUG="1" */;
reg [11: 0]   cmd_reg_addr        /* synthesis PAP_MARK_DEBUG="1" */;
reg [9 : 0]   tlp_lenght           /* synthesis PAP_MARK_DEBUG="1" */;   
reg           rc_cfg_ep_flag      /* synthesis PAP_MARK_DEBUG="1" */;
reg           rc_cfg_ep_flag_d0   /* synthesis PAP_MARK_DEBUG="1" */;
reg [31: 0]   alloc_addrl          /* synthesis PAP_MARK_DEBUG="1" */;
reg [15: 0]   dma_cnt             /* synthesis PAP_MARK_DEBUG="1" */;
reg           r_axis_s_tvalid/* synthesis PAP_MARK_DEBUG="1" */;
reg [127:0]   r_axis_s_tdata;
reg           r_axis_s_tlast;
reg [10 :0]   r_tlp_length_cnt/* synthesis PAP_MARK_DEBUG="1" */;

reg [7  : 0]  fram_cnt    /* synthesis PAP_MARK_DEBUG="1" */;
reg [7  : 0]  fram_cnt_1    /* synthesis PAP_MARK_DEBUG="1" */;
reg           pcie_rd_en        /* synthesis PAP_MARK_DEBUG="1" */;
reg           dma_start        /* synthesis PAP_MARK_DEBUG="1" */;
reg           dma_start_d0;
wire[127:0]   pcie_dma_data;
reg           axis_slave2_tlast_d0;
reg           r_pre_rd_flag        /* synthesis PAP_MARK_DEBUG="1" */;
reg           r_pre_rd_flag_d0        /* synthesis PAP_MARK_DEBUG="1" */;
reg           rd_flag/* synthesis PAP_MARK_DEBUG="1" */;

//assign  pcie_dma_data='d11111111111;
assign axis_slave2_tvalid = r_axis_s_tvalid;
assign axis_slave2_tdata  = r_axis_s_tdata ;
assign axis_slave2_tlast  = r_axis_s_tlast ;
assign axis_slave2_tuser  = 'd0;
assign axis_master_tready='d1;
parameter  MWR_IDLE       = 2'd0;
parameter  MWR_TLP_HEADER = 2'd1;
parameter  MWR_TLP_DATA   = 2'd2;
parameter  TLP_LENGTH     = 10'd16;
parameter  DMA_TRAN_TIMES = 'd4000;// 次传输 
reg [1:0]   mwr_state /* synthesis PAP_MARK_DEBUG="1" */;

//对输入数据多打一拍
always  @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        axis_master_tdata_d0  <= 'd0;
        axis_master_tvalid_d0 <= 'd0;
        axis_master_tvalid_d1 <= 'd0;
        rc_cfg_ep_flag_d0     <= 'd0;
        axis_slave2_tlast_d0  <= 'd0;
        dma_start_d0          <= 'd0;
        r_pre_rd_flag_d0      <= 'd0;
    end
    else begin
        axis_master_tdata_d0  <= axis_master_tdata;
        axis_master_tvalid_d0 <= axis_master_tvalid;
        axis_master_tvalid_d1 <= axis_master_tvalid_d0;
        axis_slave2_tlast_d0  <=axis_slave2_tlast;
        rc_cfg_ep_flag_d0     <= rc_cfg_ep_flag;
        dma_start_d0          <=dma_start;
        r_pre_rd_flag_d0      <=r_pre_rd_flag;
    end
end


//根据输入数据分析格式
always  @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        tlp_fmt  <= 'd0;
        tlp_type <= 'd0;
        mwr32    <= 'd0;
        mwr_addr <= 'd0;
        cmd_reg_addr <= 'd0;
        tlp_lenght <= 'd0;
    end
    else if(axis_master_tvalid_d0&&!axis_master_tvalid_d1)begin
        tlp_fmt  <= axis_master_tdata_d0[31:29];
        tlp_type <= axis_master_tdata_d0[28:24];
        tlp_lenght <= axis_master_tdata_d0[9:0];//TLP数据包长度
        mwr_addr <= axis_master_tdata_d0[95:64];
        cmd_reg_addr <= axis_master_tdata_d0[75:64];//cmd偏移地址
    end
    else begin
        tlp_fmt  <= 'd0;
        tlp_type <= 'd0;
        mwr_addr <= 'd0;
        cmd_reg_addr <= 'd0;
        tlp_lenght <= 'd0;
    end
end

wire [7:0] MWR/* synthesis PAP_MARK_DEBUG="1" */;
assign MWR={tlp_fmt,tlp_type};
localparam MWR_32    = 8'h40;
localparam DMA_CMD_L_ADDR                   = 12'h110;
localparam DMA_CMD_CLEAR_ADDR               = 12'h150;
parameter  ALLOC_ADDR_1   = 4'd1;
parameter  ALLOC_ADDR_2   = 4'd2;
parameter  ALLOC_ADDR_3   = 4'd3;
parameter  ALLOC_ADDR_4   = 4'd4;
reg [12:0] cnt;
reg flag/* synthesis PAP_MARK_DEBUG="1" */;
reg flag1/* synthesis PAP_MARK_DEBUG="1" */;
always  @(posedge clk or negedge rstn) begin//对RC配置EP的MWR信号进行计数
    if(!rstn || dma_stop_flag) begin
        alloc_addr_state  <= ALLOC_ADDR_1;
        dma_addr0         <= 'd0;
        dma_start       <= 'd0;
        cnt <='d0;
flag1<='d0;
    end
    else if(({tlp_fmt,tlp_type} == MWR_32 )&& (tlp_lenght == 'd1) && (cmd_reg_addr == DMA_CMD_L_ADDR)) begin
        dma_start <= 'd1;
        dma_addr0  <= {axis_master_tdata_d0[7:0],axis_master_tdata_d0[15:8],axis_master_tdata_d0[23:16],axis_master_tdata_d0[31:24]};
    end
    else if(({tlp_fmt,tlp_type} == MWR_32 )&& (tlp_lenght == 1) && (cmd_reg_addr == DMA_CMD_CLEAR_ADDR)) begin//接收到清空DMA地址命令
//        dma_start <= 1'b1;
    flag1<='d1;
    cnt<=cnt+'d1;
    end
    else begin
        alloc_addr_state  <=  alloc_addr_state ; 
        dma_start         <=  dma_start        ;
        dma_addr0         <=  dma_addr0        ; 
    flag1<='d0;
    end
end
//reg start;
always @(posedge clk or negedge rstn)
begin
    if(~rstn|| dma_stop_flag)begin
        start<= 'd0;
    end
    else if(dma_start&&(rd_water_level < TLP_LENGTH/4 - 1)) begin //dma_start_d0&&!dma_start  &&cnt=='d4000
        start <='d1;
    end
    else if((!dma_start)||(dma_start&&(rd_water_level >= 4095) )) begin //dma_start_d0&&!dma_start  &&cnt=='d4000
        start <='d0;
    end
    else begin 
        start<=start;
    end
        
end

always @(posedge clk or negedge rstn)
begin
    if(~rstn)begin
        dma_stop_flag <= 'd0;
    end
    else if(dma_cnt >=( DMA_TRAN_TIMES-1)&&r_axis_s_tlast) begin //dma_start_d0&&!dma_start  &&cnt=='d4000
        dma_stop_flag <='d1;
    end
    else begin
        dma_stop_flag <= 'd0;
    end
end
always @(posedge clk or negedge rstn)
begin
    if(~rstn|| dma_stop_flag)begin
        flag <= 'd1;
    end
    else if(flag1) begin
        flag <='d1;
    end
    else if(dma_cnt >=( DMA_TRAN_TIMES)) begin
        flag <= 'd0;
    end
end
always @(posedge clk or negedge rstn)
begin
    if(~rstn|| dma_stop_flag)begin
        r_pre_rd_flag <= 'd0;
    end
    else if((rd_water_level >= TLP_LENGTH/4+'d4)) begin
        r_pre_rd_flag <='d1;
    end
    else begin
        r_pre_rd_flag <= 'd0;
    end
end

always @(posedge clk or negedge rstn)
begin
    if(~rstn|| dma_stop_flag)begin
        rc_cfg_ep_flag <= 'd0;
    end
    else if(r_pre_rd_flag) begin
        rc_cfg_ep_flag <='d1;
    end
    else if(r_axis_s_tlast) begin
        rc_cfg_ep_flag <= 'd0;
    end
    else begin
        rc_cfg_ep_flag <= rc_cfg_ep_flag;
    end
end

always @(posedge clk or negedge rstn)
begin
    if(~rstn|| dma_stop_flag)begin
        dma_cnt         <= 'd0;
    end
    else if(r_axis_s_tlast) begin
            if(dma_cnt >= DMA_TRAN_TIMES - 1) begin
                dma_cnt <= 'd0;
            end
            else begin 
                dma_cnt <= dma_cnt +'d1;
            end
    end
end
//控制AXIS发送TLP包
always @(posedge clk  or negedge rstn) begin
    if(!rstn  || dma_stop_flag ||!es7243_init) begin
        r_axis_s_tvalid  <= 'd0;
        r_axis_s_tdata   <= 'd0;
        r_axis_s_tlast   <= 'd0;
//        rd_flag          <= 'd0;
        r_tlp_length_cnt <= 'd0;
        pcie_rd_en       <= 'd0;
        alloc_addrl      <= 'd0;
        addr_page        <= 'd0;
        fram_cnt         <= 'd1;
        fram_cnt_1         <= 'd4;
    end
//    else if (!es7243_init||dma_stop_flag) begin
//        r_axis_s_tvalid  <= 'd0; 
//        r_axis_s_tdata   <= 'd0; 
//        r_axis_s_tlast   <= 'd0; 
//        rd_flag          <= 'd1;
//        pcie_rd_en       <= 'd0; 
//        alloc_addrl      <= dma_addr0;
//    end
    else if (!dma_start_d0&&dma_start) begin
        alloc_addrl      <= dma_addr0;
    end
    else if ( dma_start && rc_cfg_ep_flag) begin//&&flag
        case(mwr_state)
            MWR_IDLE:
            begin
                r_axis_s_tvalid <= 'd0;
                r_axis_s_tdata  <= 'd0;
                r_axis_s_tlast  <= 'd0;
                if(!rd_flag) begin
                    pcie_rd_en <= 'd1;
//                    rd_flag <= 'd1;
                end
                else begin
                    pcie_rd_en <= 'd0;
                end
            end
            MWR_TLP_HEADER:
            begin
//                Mwr
                r_axis_s_tvalid <= 'd1;
                r_axis_s_tlast  <= 'd0;
//                Byte 0+
                r_axis_s_tdata[9  :  0]  <= TLP_LENGTH;        //包长 2
                r_axis_s_tdata[11 : 10]  <= 'h0;        //AT
                r_axis_s_tdata[13 : 12]  <= 'h0;        //Attr
                r_axis_s_tdata[14]       <= 'h0;        //EP
                r_axis_s_tdata[15]       <= 'h0;        //TD
                r_axis_s_tdata[16]       <= 'h0;        //TH
                r_axis_s_tdata[17]       <= 'h0;        //保留
                r_axis_s_tdata[18]       <= 'h0;        //Attr2
                r_axis_s_tdata[19]       <= 'h0;        //保留
                r_axis_s_tdata[22 : 20]  <= 'h0;        //TC
                r_axis_s_tdata[23]       <= 'h0;        //保留
                r_axis_s_tdata[28 : 24]  <= 'h0;        //Type
                r_axis_s_tdata[31 : 29]  <= 3'b010;     //Fmt 3DW Mwr
//                Byte 4+                               
                r_axis_s_tdata[35 : 32]  <= 4'hf;    //First DW BE 用于说明数据第一个DW哪一个字节有效
                r_axis_s_tdata[39 : 36]  <= 4'hf;    //Last DW BE  用于说明数据最后一个DW哪一个字节有效
                r_axis_s_tdata[47 : 40]  <= 8'h01;        //Tag
                r_axis_s_tdata[63 : 48]  <= {ep_bus_num,ep_dev_num,3'b0};  //Requester ID [63:56] Bus Num [55:51] Device Num [50:48] Function Num 
//                Byte 8+
                r_axis_s_tdata[95 : 64]  <= alloc_addrl;//r_dma_addr;     //64位的高32位地址 or 32位的低30位地址（低两位保留，保证数据DW对其）
//                Byte 12+_                
                r_axis_s_tdata[127: 96]  <= 32'd0;     //64位的低30位地址（低两位保留）
                pcie_rd_en <= 'd1;//提前一个周期把数据整出来
            end
            MWR_TLP_DATA:
            begin
                if(axis_slave2_tready) begin
                    if(dma_cnt <= DMA_TRAN_TIMES - 2) begin
//                        地址做变换
                        r_axis_s_tdata <= {
                                            pcie_dma_data[103: 96],pcie_dma_data[111:104],pcie_dma_data[119:112],pcie_dma_data[127:120],
                                            pcie_dma_data[71 : 64],pcie_dma_data[79 : 72],pcie_dma_data[87 : 80],pcie_dma_data[95 : 88],
                                            pcie_dma_data[39 : 32],pcie_dma_data[47 : 40],pcie_dma_data[55 : 48],pcie_dma_data[63 : 56],
                                            pcie_dma_data[7  :  0],pcie_dma_data[15 :  8],pcie_dma_data[23 : 16],pcie_dma_data[31 : 24] };//前60次传输，传输数据
//                        r_axis_s_tdata <= pcie_dma_data;//前60次传输，传输数据
                   
//                        r_axis_s_tdata <= {16{fram_cnt_1}};//128'hdddd_dddd_dddd_dddd_dddd_dddd_dddd_dddd;//最后4次传输，传输标志位
//                        if(fram_cnt_1 == 8'd256) begin
//                            fram_cnt_1 <= 'd3;
//                        end
//                        else begin
//                            fram_cnt_1 <= fram_cnt_1 + 'd3;
//                        end
                     end
                    else if(dma_cnt >= DMA_TRAN_TIMES-1) begin
                        r_axis_s_tdata <= {16{fram_cnt}};//128'hdddd_dddd_dddd_dddd_dddd_dddd_dddd_dddd;//最后4次传输，传输标志位
                        if(fram_cnt == 8'hff) begin
                            fram_cnt <= 'd1;
                        end
                        else begin
                            fram_cnt <= fram_cnt + 'd1;
                        end
                        pcie_rd_en <= 'd0;
                    end
                    r_tlp_length_cnt <= r_tlp_length_cnt + 1'd1;

                    if(axis_slave2_tlast) begin
                        r_tlp_length_cnt <= 'd0;
                        r_axis_s_tvalid  <= 'd0;
                        r_axis_s_tdata   <= 'd0;
                        r_axis_s_tlast   <= 'd0;
//                        
                        alloc_addrl <= alloc_addrl + 'd64;//结束传输后地址自增 包长*4
                    end   
                    else if((TLP_LENGTH <= 4) || ((TLP_LENGTH > 4) && (r_tlp_length_cnt >= TLP_LENGTH/4 - 1)) && axis_slave2_tready) begin
                        r_axis_s_tlast  <= 'd1;                      
                        pcie_rd_en       <= 'd0;
                    end       
                end
                else begin
                    pcie_rd_en <= 'd0;
                end
            end
            default:
            begin
                r_axis_s_tvalid <= 'd0;
                r_axis_s_tdata  <= 'd0;
                r_axis_s_tlast  <= 'd0;
                pcie_rd_en      <='d0 ;
            end
        endcase
    end
end

/************************state_machine**********************************/
//控制AXIS发送TLP包
always @(posedge clk or negedge rstn ) begin
    if(!rstn   || dma_stop_flag) begin
        mwr_state <=MWR_IDLE;
        rd_flag          <= 'd0;
    end
    else if( dma_start && rc_cfg_ep_flag) begin // (rc_cfg_ep_flag) begin //&&flag
        case(mwr_state)
            MWR_IDLE:
            begin
                if(!rd_flag) begin
                    rd_flag <= 'd1;
                end
                if(axis_slave2_tready) begin
                    mwr_state <= MWR_TLP_HEADER;
                end
                else begin
                    mwr_state <= mwr_state;
                end
            end 
            MWR_TLP_HEADER:
            begin
                if(axis_slave2_tready) begin//当Valid和Ready同时拉高时，进入下一个状态
                    mwr_state <= MWR_TLP_DATA;
                end
                else begin
                    mwr_state <= mwr_state;
                end
            end
            MWR_TLP_DATA:
            begin
                if(axis_slave2_tlast) begin //拉高后回归IDLE
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
    else begin
        mwr_state <= mwr_state;
    end
end
wire wr_en/* synthesis PAP_MARK_DEBUG="1" */;

assign wr_en = (rx_r_vld);
reg [15:0] data;

always @(posedge es0_dsclk or negedge rstn)
begin
    if(~rstn|| dma_stop_flag)begin
        data <= 'd0;
    end
    else if((rx_r_vld)) begin
        data <=data+'d1;
    end
    else  begin
        data <= data;
    end
end
 
PCIE_FIFO u_pcie_fifo
   (
. wr_clk        (es0_dsclk)  ,  // input write clock
. wr_rst        (!es7243_init||(!dma_start_d0&&dma_start))  ,  // input write reset
. wr_en         ((rx_r_vld))  ,  // input write enable 1 active
. wr_data       (rx_data)  ,  // input write data rx_data
. wr_full       ()  ,  // output write full  flag 1 activ
. wr_water_level()  ,  // output write water level
. rd_clk        (clk)  ,  // input read clock
. rd_rst        (!es7243_init||(!dma_start_d0&&dma_start))  ,  // input read reset
. rd_en         (pcie_rd_en)  ,  // input read enable
. rd_data       (pcie_dma_data)  ,  // output read data
. almost_full   ()  ,  // output write almost full
. rd_empty      ()  ,  // output read empty    
. rd_water_level(rd_water_level)  ,  // output read water level
. almost_empty  ()     // output write almost empty 
   );
endmodule