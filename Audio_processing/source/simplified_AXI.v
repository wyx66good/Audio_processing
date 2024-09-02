/*****************************************************************/
//
// Create Date: 2024/04/25
// Design Name: WenYiXing
//
/*****************************************************************/

module simplified_AXI#(
    parameter DISP_H                = 1920  , // ��ʾһ֡���ݵ������ظ���
    parameter DISP_V                = 1080  , // ��ʾһ֡���ݵ������ظ���
    parameter MEM_H_PIXEL           = 960   , // ÿһ����ƵԴ��ʾʱ��������
    parameter MEM_V_PIXEL           = 540   , // ÿһ����ƵԴ��ʾʱ��������
    
    parameter AXI_WRITE_BURST_LEN   = 16    , // дͻ�����䳤�ȣ�֧�֣�1,2,4,8,16��
    parameter AXI_READ_BURST_LEN    = 16    , // ��ͻ�����䳤�ȣ�֧�֣�1,2,4,8,16��
    parameter AXI_ID_WIDTH          = 4     , // AXI IDλ��
    parameter AXI_USER_WIDTH        = 1     , // AXI USRTλ��
    parameter AXI_DATA_WIDTH        = 256   , // AXI ����λ��
    parameter MEM_ROW_WIDTH         = 15    , // DDR �е�ַλ��
    parameter MEM_COL_WIDTH         = 10    , // DDR �е�ַλ��
    parameter MEM_BANK_WIDTH        = 3     , // DDR BANK��ַλ��
    parameter MEM_BURST_LEN         = 8     , // DDR ͻ�����䳤��
    parameter AXI_ADDR_WIDTH        = MEM_BANK_WIDTH + MEM_ROW_WIDTH + MEM_COL_WIDTH
)(
    input   wire                            M_AXI_ACLK          ,
    input   wire                            M_AXI_ARESETN       ,
    
    // д�ź�
    input   wire [3:0]                      axi_wr_grant        /*synthesis PAP_MARK_DEBUG="1"*/, // ����FIFO��д����
    input   wire [3:0]                      axi_rd_grant        /*synthesis PAP_MARK_DEBUG="1"*/, // ���FIFO��������

    
    output  reg                             axi_video0_wr_en    , // FIFO_video0��дʹ��
    input   wire [AXI_DATA_WIDTH-1:0]       axi_video0_wr_data  , // FIFO_video0��д����
    input   wire                            video0_wr_rst       , // ��ƵԴ0д��ַ��λ
    
    output  reg                             axi_video1_wr_en    , // FIFO_video1��дʹ��
    input   wire [AXI_DATA_WIDTH-1:0]       axi_video1_wr_data  , // FIFO_video1��д����
    input   wire                            video1_wr_rst       , // ��ƵԴ1д��ַ��λ
    
    output  reg                             axi_video2_wr_en    , // FIFO_video1��дʹ��
    input   wire [AXI_DATA_WIDTH-1:0]       axi_video2_wr_data  , // FIFO_video1��д����
    input   wire                            video2_wr_rst       , // ��ƵԴ1д��ַ��λ
    
    output  reg                             axi_video3_wr_en    , // FIFO_video1��дʹ��
    input   wire [AXI_DATA_WIDTH-1:0]       axi_video3_wr_data  , // FIFO_video1��д����
    input   wire                            video3_wr_rst       , // ��ƵԴ1д��ַ��λ
    
    // ���ź�
    
    output  reg                            rd_en               , // ���FIFO����ʹ��
    output  wire [AXI_DATA_WIDTH-1:0]       rd_data             , // ���FIFO��������
    input   wire                            rd_rst              , // ����ַ��λ�ź�

    output  reg                            rd1_en               , // ���FIFO����ʹ��
    output  wire [AXI_DATA_WIDTH-1:0]       rd1_data             , // ���FIFO��������
    input   wire                            rd1_rst              , // ����ַ��λ�ź�

    output  reg                            rd2_en               , // ���FIFO����ʹ��
    output  wire [AXI_DATA_WIDTH-1:0]       rd2_data             , // ���FIFO��������
    input   wire                            rd2_rst              , // ����ַ��λ�ź�

    output  reg                            rd3_en               , // ���FIFO����ʹ��
    output  wire [AXI_DATA_WIDTH-1:0]       rd3_data             , // ���FIFO��������
    input   wire                            rd3_rst              , // ����ַ��λ�ź�
    
    // AXI �ӿ��ź�
    output  wire [AXI_ADDR_WIDTH-1:0]       M_AXI_AWADDR    ,
    output  wire [AXI_USER_WIDTH-1:0]       M_AXI_AWUSER    ,
    output  wire [AXI_ID_WIDTH-1:0]         M_AXI_AWID      ,
    output  wire [3:0]                      M_AXI_AWLEN     ,
    input   wire                            M_AXI_AWREADY   ,
    output  wire                            M_AXI_AWVALID   ,
    
    output  wire [AXI_DATA_WIDTH-1:0]       M_AXI_WDATA     ,
    output  wire [AXI_DATA_WIDTH/8-1:0]     M_AXI_WSTRB     ,
    input   wire                            M_AXI_WREADY    ,
    input   wire [AXI_ID_WIDTH-1:0]         M_AXI_WID       ,
    output  wire                            M_AXI_WLAST     ,
    
    output  wire [AXI_ADDR_WIDTH-1:0]       M_AXI_ARADDR    ,
    output  wire [AXI_USER_WIDTH-1:0]       M_AXI_ARUSER    ,
    output  wire [AXI_ID_WIDTH-1:0]         M_AXI_ARID      ,
    output  wire [3:0]                      M_AXI_ARLEN     ,
    input   wire                            M_AXI_ARREADY   ,
    output  wire                            M_AXI_ARVALID   ,
    
    input   wire [AXI_DATA_WIDTH-1:0]       M_AXI_RDATA     ,
    input   wire [AXI_ID_WIDTH-1:0]         M_AXI_RID       ,
    input   wire                            M_AXI_RLAST     ,
    input   wire                            M_AXI_RVALID    ,


    //���ŷֱ���
    input wire [15:0] vout_yres,
    input wire [15:0] vout_xres

);

/*************************parameter**************************/
wire [22:0]WRITE_BURST_COUNT    ;
wire [22:0]READ_BURST_COUNT     ;


assign WRITE_BURST_COUNT = MEM_H_PIXEL / (AXI_WRITE_BURST_LEN * MEM_BURST_LEN); // һ��д����ͻ������Ĵ���
assign READ_BURST_COUNT  = MEM_H_PIXEL / (AXI_READ_BURST_LEN  * MEM_BURST_LEN); // һ�ζ�����ͻ������Ĵ���
localparam WRITE_BURST_ADDR  = MEM_BURST_LEN * AXI_WRITE_BURST_LEN; // AXI�ӿ�ÿ��ͻ��д�����ַ�ı���
localparam READ_BURST_ADDR   = MEM_BURST_LEN * AXI_READ_BURST_LEN ; // AXI�ӿ�ÿ��ͻ���������ַ�ı���

wire [25:0] VIDEO0_END_ADDR;
wire [25:0] VIDEO1_START_ADDR  ; 
wire [25:0] VIDEO1_END_ADDR    ;
wire [25:0] VIDEO2_START_ADDR  ;
wire [25:0] VIDEO2_END_ADDR    ;
wire [25:0] VIDEO3_START_ADDR  ;
wire [25:0] VIDEO3_END_ADDR    ;


localparam VIDEO0_START_ADDR = 'd0;
assign VIDEO0_END_ADDR   = (MEM_H_PIXEL*2) * (MEM_V_PIXEL) + VIDEO0_START_ADDR;
assign VIDEO1_START_ADDR =  MEM_H_PIXEL;
assign VIDEO1_END_ADDR   = (MEM_H_PIXEL*2) * (MEM_V_PIXEL*4) + VIDEO1_START_ADDR;
assign VIDEO2_START_ADDR = (MEM_H_PIXEL*2) * (MEM_V_PIXEL);
assign VIDEO2_END_ADDR   = (MEM_H_PIXEL*2) * ('d1000) + VIDEO2_START_ADDR;
assign VIDEO3_START_ADDR = (MEM_H_PIXEL*2) * (MEM_V_PIXEL*2);
assign VIDEO3_END_ADDR   = (MEM_H_PIXEL*2) * (MEM_V_PIXEL) + VIDEO3_START_ADDR;

/****************************reg*****************************/
reg     [3:0]                               r_input_source     /*synthesis PAP_MARK_DEBUG="1"*/ ; // �Ĵ�������ƵԴ
reg     [3:0]                               r_output_source      /*synthesis PAP_MARK_DEBUG="1"*/; // �Ĵ������ƵԴ


reg                                         r_m_axi_awvalid     ; // д��ַ��Ч
reg     [3:0]                               r_awburst_count     ; // ��¼һ��д�������͵ĵ�ַ����
reg     [MEM_ROW_WIDTH+MEM_COL_WIDTH-1:0]   r_video0_wr_addr    /*synthesis PAP_MARK_DEBUG="1"*/; // ��ƵԴ0 д��ַ
reg     [MEM_BANK_WIDTH-2:0]                r_video0_wr_bank    /*synthesis PAP_MARK_DEBUG="1"*/; // ��ƵԴ0 дBNAK
reg     [MEM_ROW_WIDTH+MEM_COL_WIDTH-1:0]   r_video1_wr_addr    /*synthesis PAP_MARK_DEBUG="1"*/; // ��ƵԴ1 д��ַ
reg     [MEM_BANK_WIDTH-2:0]                r_video1_wr_bank   /*synthesis PAP_MARK_DEBUG="1"*/ ; // ��ƵԴ1 дBNAK
reg     [MEM_ROW_WIDTH+MEM_COL_WIDTH-1:0]   r_video2_wr_addr   /*synthesis PAP_MARK_DEBUG="1"*/; // ��ƵԴ2 д��ַ
reg     [MEM_BANK_WIDTH-2:0]                r_video2_wr_bank   /*synthesis PAP_MARK_DEBUG="1"*/ ; // ��ƵԴ2 дBNAK
reg     [MEM_ROW_WIDTH+MEM_COL_WIDTH-1:0]   r_video3_wr_addr    /*synthesis PAP_MARK_DEBUG="1"*/; // ��ƵԴ3 д��ַ
reg     [MEM_BANK_WIDTH-2:0]                r_video3_wr_bank    /*synthesis PAP_MARK_DEBUG="1"*/; // ��ƵԴ3 дBNAK
reg     [AXI_ADDR_WIDTH-1:0]                r_wr_addr           /*synthesis PAP_MARK_DEBUG="1"*/; // д��ַ

reg     [AXI_DATA_WIDTH-1:0]                r_wr_data          /*synthesis PAP_MARK_DEBUG="1"*/ ; // д����
reg                                         r_m_axi_wlast       ;
reg     [3:0]                               r_wburst_cnt        ; // ��¼һ��ͻ�����䷢�����ݸ���
reg     [3:0]                               r_wburst_count      ; // ��¼һ��д����ͻ���������

reg     [AXI_ADDR_WIDTH-1:0]                r_r_addr          /*synthesis PAP_MARK_DEBUG="1"*/ ; // д��ַ
reg     [MEM_ROW_WIDTH+MEM_COL_WIDTH-1:0]   r_rd_addr           /*synthesis PAP_MARK_DEBUG="1"*/; // ����ַ
reg     [MEM_ROW_WIDTH+MEM_COL_WIDTH-1:0]   r_rd1_addr          /*synthesis PAP_MARK_DEBUG="1"*/ ; // ����ַ
reg     [MEM_ROW_WIDTH+MEM_COL_WIDTH-1:0]   r_rd2_addr          /*synthesis PAP_MARK_DEBUG="1"*/ ; // ����ַ
reg     [MEM_ROW_WIDTH+MEM_COL_WIDTH-1:0]   r_rd3_addr           /*synthesis PAP_MARK_DEBUG="1"*/; // ����ַ

reg     [MEM_BANK_WIDTH-2:0]                r_rd_bank           /*synthesis PAP_MARK_DEBUG="1"*/; // ��BANK [MEM_BANK_WIDTH-2:0]
reg     [MEM_BANK_WIDTH-2:0]                r_rd1_bank          /*synthesis PAP_MARK_DEBUG="1"*/ ; // ��BANK [MEM_BANK_WIDTH-2:0]
reg     [MEM_BANK_WIDTH-2:0]                r_rd2_bank          /*synthesis PAP_MARK_DEBUG="1"*/ ; // ��BANK [MEM_BANK_WIDTH-2:0]
reg     [MEM_BANK_WIDTH-2:0]                r_rd3_bank           /*synthesis PAP_MARK_DEBUG="1"*/; // ��BANK [MEM_BANK_WIDTH-2:0]

reg     [3:0]                               r_arburst_count     ; // ��¼һ�ζ��������͵ĵ�ַ����
reg                                         r_m_axi_arvalid     ; // ����ַ��Ч

reg     [3:0]                               r_rburst_count      ; // ��¼һ�ζ�����ͻ���������

reg                                         r_video0_wr_rst     ; // ��ƵԴ0 д��ַ��λ�ź�������
reg                                         r0_video0_wr_rst    ;
reg                                         r1_video0_wr_rst    ;
reg                                         r_video1_wr_rst     ; // ��ƵԴ1 д��ַ��λ�ź�������
reg                                         r0_video1_wr_rst    ;
reg                                         r1_video1_wr_rst    ;
reg                                         r_video2_wr_rst     ; // ��ƵԴ1 д��ַ��λ�ź�������
reg                                         r0_video2_wr_rst    ;
reg                                         r1_video2_wr_rst    ;
reg                                         r_video3_wr_rst     ; // ��ƵԴ1 д��ַ��λ�ź�������
reg                                         r0_video3_wr_rst    ;
reg                                         r1_video3_wr_rst    ;
reg                                         r_rd_rst            ; // ����ַ��λ�ź�������
reg                                         r0_rd_rst           ;
reg                                         r1_rd_rst           ;
reg                                         r_rd1_rst            ; // ����ַ��λ�ź�������
reg                                         r0_rd1_rst           ;
reg                                         r1_rd1_rst           ;
reg                                         r_rd2_rst            ; // ����ַ��λ�ź�������
reg                                         r0_rd2_rst           ;
reg                                         r1_rd2_rst           ;
reg                                         r_rd3_rst            ; // ����ַ��λ�ź�������
reg                                         r0_rd3_rst           ;
reg                                         r1_rd3_rst           ;

/****************************wire****************************/
wire                                write_start         ;
wire                                write_state         ;
wire                                video0_waddr_end    ; // ��ƵԴ0 д�����һ����ַ
wire                                video1_waddr_end    ; // ��ƵԴ1 д�����һ����ַ
wire                                video2_waddr_end    ; // ��ƵԴ2 д�����һ����ַ
wire                                video3_waddr_end    ; // ��ƵԴ3 д�����һ����ַ
wire                                write_done          ; // һ��д��������

wire                                read_start          ;
wire                                read_state          ;
wire                                read_done           ; // һ�ζ���������
wire                                raddr_end           ; // �������һ����ַ
wire                                raddr1_end           ; // �������һ����ַ
wire                                raddr2_end           ; // �������һ����ַ
wire                                raddr3_end           ; // �������һ����ַ


/********************combinational logic*********************/
assign M_AXI_AWADDR         = {r_wr_addr[MEM_COL_WIDTH], 
                               r_wr_addr[AXI_ADDR_WIDTH-1: AXI_ADDR_WIDTH-MEM_BANK_WIDTH], 
                               r_wr_addr[MEM_COL_WIDTH+MEM_ROW_WIDTH-1:MEM_COL_WIDTH+1], 
                               r_wr_addr[MEM_COL_WIDTH-1:0]}        ;
assign M_AXI_AWUSER         = 'd0                                   ;
assign M_AXI_AWID           = 'd0                                   ;
assign M_AXI_AWLEN          = AXI_WRITE_BURST_LEN - 1               ;
assign M_AXI_AWVALID        = r_m_axi_awvalid                       ;
assign video0_waddr_end     = r_video0_wr_addr == VIDEO0_END_ADDR   ;
assign video1_waddr_end     = r_video1_wr_addr == VIDEO1_END_ADDR   ;
assign video2_waddr_end     = r_video2_wr_addr == VIDEO2_END_ADDR   ;
assign video3_waddr_end     = r_video3_wr_addr == VIDEO3_END_ADDR   ;

assign M_AXI_WDATA          = r_wr_data                             ;
assign M_AXI_WSTRB          = {(AXI_DATA_WIDTH/8){1'b1}}            ;
assign M_AXI_WLAST          = r_m_axi_wlast                         ;
assign write_done           = M_AXI_WLAST && (r_wburst_count == WRITE_BURST_COUNT - 1);

assign M_AXI_ARADDR         = {r_r_addr[MEM_COL_WIDTH], 
                               r_r_addr[AXI_ADDR_WIDTH-1: AXI_ADDR_WIDTH-MEM_BANK_WIDTH],
                               r_r_addr[MEM_COL_WIDTH+MEM_ROW_WIDTH-1:MEM_COL_WIDTH+1], 
                               r_r_addr[MEM_COL_WIDTH-1:0]}        ;
assign M_AXI_ARLEN          = AXI_READ_BURST_LEN - 1                ;
assign M_AXI_ARUSER         = 'd0                                   ;
assign M_AXI_ARID           = 'd0                                   ;
assign M_AXI_ARVALID        = r_m_axi_arvalid                       ;
//assign raddr_end            = r_rd_addr == DISP_H * DISP_V          ;
assign raddr_end             = r_rd_addr == VIDEO0_END_ADDR         ;
assign raddr1_end            = r_rd1_addr == VIDEO1_END_ADDR         ;
assign raddr2_end            = r_rd2_addr == VIDEO2_END_ADDR         ;
assign raddr3_end            = r_rd3_addr == VIDEO3_END_ADDR         ;


//assign rd_en                 = (r_output_source[0])? M_AXI_RVALID :'d0   ;
assign rd_data               = (r_output_source[0])? M_AXI_RDATA :'d0    ;
//assign rd1_en                = (r_output_source[1])? M_AXI_RVALID :'d0   ;
assign rd1_data              = (r_output_source[1])? M_AXI_RDATA :'d0    ;
//assign rd2_en                = (r_output_source[2])? M_AXI_RVALID :'d0   ;
assign rd2_data              = (r_output_source[2])? M_AXI_RDATA :'d0    ;
//assign rd3_en                = (r_output_source[3])? M_AXI_RVALID :'d0   ;
assign rd3_data              = (r_output_source[3])? M_AXI_RDATA :'d0    ;
assign read_done             = M_AXI_RLAST && (r_rburst_count == READ_BURST_COUNT - 1);

/****************************FSM*****************************/
localparam ST_IDLE          = 5'b00001;
localparam ST_WRITE_START   = 5'b00010;
localparam ST_WRITE_STATE   = 5'b00100;
localparam ST_READ_START    = 5'b01000;
localparam ST_READ_STATE    = 5'b10000;

reg     [4:0]   fsm_c;
reg     [4:0]   fsm_n;

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        fsm_c <= ST_IDLE;
    else
        fsm_c <= fsm_n;
end

always@(*)
begin
    case(fsm_c)
        ST_IDLE:
            if(r_rd_rst || r_rd1_rst ||r_rd2_rst ||r_rd3_rst ||r_video0_wr_rst || r_video1_wr_rst || r_video2_wr_rst || r_video3_wr_rst)
                fsm_n = ST_IDLE;
            else if(axi_wr_grant != 4'b0000) // д�����ȼ�����
                fsm_n = ST_WRITE_START;
            else if(axi_rd_grant != 4'b0000) //���ж�
                fsm_n = ST_READ_START;
            else
                fsm_n = ST_IDLE;
        ST_WRITE_START:
                fsm_n = ST_WRITE_STATE;
        ST_WRITE_STATE:
            if(write_done)
                fsm_n = ST_IDLE;
            else
                fsm_n = ST_WRITE_STATE;
        ST_READ_START:
                fsm_n = ST_READ_STATE;
        ST_READ_STATE:
            if(read_done)
                fsm_n = ST_IDLE;
            else
                fsm_n = ST_READ_STATE;
        default:
                fsm_n = ST_IDLE;
    endcase
end

assign write_start = (fsm_c == ST_WRITE_START) ? 1'b1 : 1'b0;
assign write_state = (fsm_c == ST_WRITE_STATE) ? 1'b1 : 1'b0;
assign read_start  = (fsm_c == ST_READ_START)  ? 1'b1 : 1'b0;
assign read_state  = (fsm_c == ST_READ_STATE)  ? 1'b1 : 1'b0;

/**************************process***************************/
always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_input_source <= 2'b00;
    else if(fsm_c == ST_WRITE_START)
        r_input_source <= axi_wr_grant;
    else
        r_input_source <= r_input_source;
end

/*д��ַͨ��---------------------------------------------------*/
// ��ƵԴ0
always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_video0_wr_addr  <= VIDEO0_START_ADDR;
    else case(fsm_c)
        ST_IDLE:
            if(r_video0_wr_rst) // ����������ÿһ֡��ʼʱ��λд��ַ
                r_video0_wr_addr <= VIDEO0_START_ADDR;
            else if(video0_waddr_end) // ��д�����һ����ַʱ��λд��ַ
                r_video0_wr_addr <= VIDEO0_START_ADDR;
            else
                r_video0_wr_addr <= r_video0_wr_addr;
        ST_WRITE_STATE:
            if(M_AXI_AWREADY && M_AXI_AWVALID && r_input_source[0])
                if(r_awburst_count == WRITE_BURST_COUNT - 1) // ��һ��д��ʱ��ֱ��������һ��
                    r_video0_wr_addr <= r_video0_wr_addr + WRITE_BURST_ADDR + MEM_H_PIXEL;
                else
                    r_video0_wr_addr <= r_video0_wr_addr + WRITE_BURST_ADDR;
            else
                r_video0_wr_addr <= r_video0_wr_addr;
        default:
            r_video0_wr_addr <= r_video0_wr_addr;
    endcase
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_video0_wr_bank <= 2'd1;
    else if(fsm_c == ST_IDLE)
        if(video0_waddr_end) // ��д�����һ����ַʱ�ı�BANK��ַ
            if(r_video0_wr_bank == r_rd_bank - 1'b1) // ��BANKʼ�����дBANK
                r_video0_wr_bank <= r_video0_wr_bank;
            else
                r_video0_wr_bank <= r_video0_wr_bank + 1'b1;
        else
            r_video0_wr_bank <= r_video0_wr_bank;
    else
        r_video0_wr_bank <= r_video0_wr_bank;
end

// ��ƵԴ1
always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_video1_wr_addr  <= VIDEO1_START_ADDR;
    else case(fsm_c)
        ST_IDLE:
            if(r_video1_wr_rst) // ����������ÿһ֡��ʼʱ��λд��ַ
                r_video1_wr_addr <= VIDEO1_START_ADDR;
            else if(video1_waddr_end) // ��д�����һ����ַʱ��λд��ַ
                r_video1_wr_addr <= VIDEO1_START_ADDR;
            else
                r_video1_wr_addr <= r_video1_wr_addr;
        ST_WRITE_STATE:
            if(M_AXI_AWREADY && M_AXI_AWVALID && r_input_source[1])
                if(r_awburst_count == WRITE_BURST_COUNT - 1) // ��һ��д��ʱ��ֱ��������һ��
                    r_video1_wr_addr <= r_video1_wr_addr + WRITE_BURST_ADDR + MEM_H_PIXEL;
                else
                    r_video1_wr_addr <= r_video1_wr_addr + WRITE_BURST_ADDR;
            else
                r_video1_wr_addr <= r_video1_wr_addr;
        default:
            r_video1_wr_addr <= r_video1_wr_addr;
    endcase
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_video1_wr_bank <= 2'd1;
    else if(fsm_c == ST_IDLE)
        if(video1_waddr_end) // ��д�����һ����ַʱ�ı�BANK��ַ
            if(r_video1_wr_bank == r_rd1_bank - 1'b1) // ��BANKʼ�����дBANK
                r_video1_wr_bank <= r_video1_wr_bank;
            else
                r_video1_wr_bank <= r_video1_wr_bank + 1'b1;
        else
            r_video1_wr_bank <= r_video1_wr_bank;
    else
        r_video1_wr_bank <= r_video1_wr_bank;
end

// ��ƵԴ2
always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_video2_wr_addr  <= VIDEO2_START_ADDR;
    else case(fsm_c)
        ST_IDLE:
            if(r_video2_wr_rst) // ����������ÿһ֡��ʼʱ��λд��ַ
                r_video2_wr_addr <= VIDEO2_START_ADDR;
            else if(video2_waddr_end) // ��д�����һ����ַʱ��λд��ַ
                r_video2_wr_addr <= VIDEO2_START_ADDR;
            else
                r_video2_wr_addr <= r_video2_wr_addr;
        ST_WRITE_STATE:
            if(M_AXI_AWREADY && M_AXI_AWVALID && r_input_source[2])
                if(r_awburst_count == WRITE_BURST_COUNT - 1) // ��һ��д��ʱ��ֱ��������һ��
                    r_video2_wr_addr <= r_video2_wr_addr + WRITE_BURST_ADDR + MEM_H_PIXEL;
                else
                    r_video2_wr_addr <= r_video2_wr_addr + WRITE_BURST_ADDR;
            else
                r_video2_wr_addr <= r_video2_wr_addr;
        default:
            r_video2_wr_addr <= r_video2_wr_addr;
    endcase
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_video2_wr_bank <= 2'd1;
    else if(fsm_c == ST_IDLE)
        if(video2_waddr_end) // ��д�����һ����ַʱ�ı�BANK��ַ
            if(r_video2_wr_bank == r_rd2_bank - 1'b1) // ��BANKʼ�����дBANK
                r_video2_wr_bank <= r_video2_wr_bank;
            else
                r_video2_wr_bank <= r_video2_wr_bank + 1'b1;
        else
            r_video2_wr_bank <= r_video2_wr_bank;
    else
        r_video2_wr_bank <= r_video2_wr_bank;
end

// ��ƵԴ3
always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_video3_wr_addr  <= VIDEO3_START_ADDR;
    else case(fsm_c)
        ST_IDLE:
            if(r_video3_wr_rst) // ����������ÿһ֡��ʼʱ��λд��ַ
                r_video3_wr_addr <= VIDEO3_START_ADDR;
            else if(video3_waddr_end) // ��д�����һ����ַʱ��λд��ַ
                r_video3_wr_addr <= VIDEO3_START_ADDR;
            else
                r_video3_wr_addr <= r_video3_wr_addr;
        ST_WRITE_STATE:
            if(M_AXI_AWREADY && M_AXI_AWVALID && r_input_source[3])
                if(r_awburst_count == WRITE_BURST_COUNT - 1) // ��һ��д��ʱ��ֱ��������һ��
                    r_video3_wr_addr <= r_video3_wr_addr + WRITE_BURST_ADDR + MEM_H_PIXEL;
                else
                    r_video3_wr_addr <= r_video3_wr_addr + WRITE_BURST_ADDR;
            else
                r_video3_wr_addr <= r_video3_wr_addr;
        default:
            r_video3_wr_addr <= r_video3_wr_addr;
    endcase
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_video3_wr_bank <= 2'd1;
    else if(fsm_c == ST_IDLE)
        if(video3_waddr_end) // ��д�����һ����ַʱ�ı�BANK��ַ
            if(r_video3_wr_bank == r_rd3_bank - 1'b1) // ��BANKʼ�����дBANK
                r_video3_wr_bank <= r_video3_wr_bank;
            else
                r_video3_wr_bank <= r_video3_wr_bank + 1'b1;
        else
            r_video3_wr_bank <= r_video3_wr_bank;
    else
        r_video3_wr_bank <= r_video3_wr_bank;
end

// ��ʱ���½��ظ���д��ַ
always@(negedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_wr_addr <= 'd0;
    else if(fsm_c == ST_WRITE_STATE)
        case(r_input_source)
            4'b1000:
                r_wr_addr <= {1'b0, r_video3_wr_bank, r_video3_wr_addr};
            4'b0100:
                r_wr_addr <= {1'b0, 2'd1, r_video2_wr_addr};
            4'b0010:
                r_wr_addr <= {1'b0, r_video1_wr_bank, r_video1_wr_addr};
            4'b0001:
                r_wr_addr <= {1'b0, 1'b1, r_video0_wr_addr};//r_video0_wr_bank
            default:
                r_wr_addr <= 'd0;
        endcase
    else
        r_wr_addr <= 'd0;
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_m_axi_awvalid <= 1'b0;
    else case(fsm_c)
        ST_WRITE_START:
            r_m_axi_awvalid <= 1'b1;
        ST_WRITE_STATE:
            if(r_awburst_count < WRITE_BURST_COUNT - 1)
                r_m_axi_awvalid <= 1'b1;
            else if(r_awburst_count == WRITE_BURST_COUNT - 1)
                if(M_AXI_AWREADY && M_AXI_AWVALID)
                    r_m_axi_awvalid <= 1'b0;
                else
                    r_m_axi_awvalid <= 1'b1;
            else
                r_m_axi_awvalid <= 1'b0;
        default:
            r_m_axi_awvalid <= 1'b0;
    endcase
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_awburst_count <= 4'd0;
    else case(fsm_c)
        ST_WRITE_START:
            r_awburst_count <= 4'd0;
        ST_WRITE_STATE:
            if(M_AXI_AWREADY && M_AXI_AWVALID)
                r_awburst_count <= r_awburst_count + 1'b1;
            else
                r_awburst_count <= r_awburst_count;
        default:
            r_awburst_count <= 4'd0;
    endcase
end

/*д����ͨ��---------------------------------------------------*/
always@(*)
begin
    if(!M_AXI_ARESETN)
        r_wr_data = 'd0;
    else if(fsm_c == ST_WRITE_STATE)
        case(r_input_source)
            4'b1000:
                r_wr_data = axi_video3_wr_data;
            4'b0100:
                r_wr_data = axi_video2_wr_data;
            4'b0010:
                r_wr_data = axi_video1_wr_data;
            4'b0001:
                r_wr_data = axi_video0_wr_data;
            default:
                r_wr_data = 'd0;
        endcase
    else
        r_wr_data = 'd0;
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_m_axi_wlast <= 1'b0;
    else if(r_wburst_cnt == AXI_WRITE_BURST_LEN - 2)
        r_m_axi_wlast <= 1'b1;
    else
        r_m_axi_wlast <= 1'b0;
end

always@(*)
begin
    case(fsm_c)
        ST_WRITE_START: // ��һ��д������ʼʱ���ȴ�����FIFO�ж���һ������
            if(axi_wr_grant[0])
                axi_video0_wr_en = 1'b1;
            else
                axi_video0_wr_en = 1'b0;
        ST_WRITE_STATE:
            if(r_input_source[0])
                if(write_done) // һ��д�����������������дʹ�ܣ���ֹ������FIFO�ж����һ������
                    axi_video0_wr_en = 1'b0;
                else
                    axi_video0_wr_en = M_AXI_WREADY;
            else
                axi_video0_wr_en = 1'b0;
        default:
            axi_video0_wr_en = 1'b0;
    endcase
end

always@(*)
begin
    case(fsm_c)
        ST_WRITE_START: // ��һ��д������ʼʱ���ȴ�����FIFO�ж���һ������
            if(axi_wr_grant[1])
                axi_video1_wr_en = 1'b1;
            else
                axi_video1_wr_en = 1'b0;
        ST_WRITE_STATE:
            if(r_input_source[1])
                if(write_done) // һ��д�����������������дʹ�ܣ���ֹ������FIFO�ж����һ������
                    axi_video1_wr_en = 1'b0;
                else
                    axi_video1_wr_en = M_AXI_WREADY;
            else
                axi_video1_wr_en = 1'b0;
        default:
            axi_video1_wr_en = 1'b0;
    endcase
end

always@(*)
begin
    case(fsm_c)
        ST_WRITE_START: // ��һ��д������ʼʱ���ȴ�����FIFO�ж���һ������
            if(axi_wr_grant[2])
                axi_video2_wr_en = 1'b1;
            else
                axi_video2_wr_en = 1'b0;
        ST_WRITE_STATE:
            if(r_input_source[2])
                if(write_done) // һ��д�����������������дʹ�ܣ���ֹ������FIFO�ж����һ������
                    axi_video2_wr_en = 1'b0;
                else
                    axi_video2_wr_en = M_AXI_WREADY;
            else
                axi_video2_wr_en = 1'b0;
        default:
            axi_video2_wr_en = 1'b0;
    endcase
end

always@(*)
begin
    case(fsm_c)
        ST_WRITE_START: // ��һ��д������ʼʱ���ȴ�����FIFO�ж���һ������
            if(axi_wr_grant[3])
                axi_video3_wr_en = 1'b1;
            else
                axi_video3_wr_en = 1'b0;
        ST_WRITE_STATE:
            if(r_input_source[3])
                if(write_done) // һ��д�����������������дʹ�ܣ���ֹ������FIFO�ж����һ������
                    axi_video3_wr_en = 1'b0;
                else
                    axi_video3_wr_en = M_AXI_WREADY;
            else
                axi_video3_wr_en = 1'b0;
        default:
            axi_video3_wr_en = 1'b0;
    endcase
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_wburst_cnt <= 4'd0;
    else if(M_AXI_WLAST) // ��һ��ͻ�����������
        r_wburst_cnt <= 4'd0;
    else if(M_AXI_WREADY)
        r_wburst_cnt <= r_wburst_cnt + 1;
    else
        r_wburst_cnt <= r_wburst_cnt;
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_wburst_count <= 4'd0;
    else if(write_start) // ��һ��д������ʼʱ����
        r_wburst_count <= 4'd0;
    else if(M_AXI_WLAST)
        r_wburst_count <= r_wburst_count + 1;
    else
        r_wburst_count <= r_wburst_count;
end

/*����ַͨ��---------------------------------------------------*/
//always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
//begin
//    if(!M_AXI_ARESETN)
//        r_rd_addr <= 'd0;
//    else case(fsm_c)
//        ST_IDLE:
//            if(r_rd_rst) // ���������ÿһ֡��ʼʱ��λ����ַ
//                r_rd_addr <= 'd0;
//            else if(raddr_end) // ��Ϊ���һ������ַʱ��λ����ַ
//                r_rd_addr <= 'd0;
//            else
//                r_rd_addr <= r_rd_addr;
//        ST_READ_STATE:
//            if(M_AXI_ARREADY && M_AXI_ARVALID)
//                r_rd_addr <= r_rd_addr + READ_BURST_ADDR;
//            else
//                r_rd_addr <= r_rd_addr;
//        default:
//            r_rd_addr <= r_rd_addr;
//    endcase
//end
always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_output_source <= 2'b00;
    else if(fsm_c == ST_READ_START)
        r_output_source <= axi_rd_grant;
    else
        r_output_source <= r_output_source;
end
//��ƵԴ0
always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_rd_addr <= VIDEO0_START_ADDR;
    else case(fsm_c)
        ST_IDLE:
            if(r_rd_rst) // ���������ÿһ֡��ʼʱ��λ����ַ
                r_rd_addr <= VIDEO0_START_ADDR;
            else if(raddr_end) // ��Ϊ���һ������ַʱ��λ����ַ
                r_rd_addr <= VIDEO0_START_ADDR;
            else
                r_rd_addr <= r_rd_addr;
        ST_READ_STATE:
            if(M_AXI_ARREADY && M_AXI_ARVALID&&r_output_source[0])
                if(r_arburst_count==READ_BURST_COUNT-1)
                        r_rd_addr <= r_rd_addr + READ_BURST_ADDR+MEM_H_PIXEL;
                else 
                        r_rd_addr <= r_rd_addr + READ_BURST_ADDR;
            else
                r_rd_addr <= r_rd_addr;
        default:
            r_rd_addr <= r_rd_addr;
    endcase
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_rd_bank <= 3'd0;
    else if(fsm_c == ST_IDLE)
        if(raddr_end) // ���������һ����ַʱ�ı�BANK��ַ
            if((r_rd_bank == r_video0_wr_bank + 1'b1)) // ������дBANK������BANKʱ 
                r_rd_bank <= r_rd_bank + 1'b1;
            else
                r_rd_bank <= r_rd_bank;
        else
            r_rd_bank <= r_rd_bank;
    else
        r_rd_bank <= r_rd_bank;
end
//(r_rd_bank == r_video0_wr_bank + 1'b1)&& (r_rd_bank == r_video1_wr_bank + 1'b1) && (r_rd_bank == r_video2_wr_bank + 1'b1) && (r_rd_bank == r_video3_wr_bank + 1'b1 )

//��ƵԴ1
always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_rd1_addr <= VIDEO1_START_ADDR;
    else case(fsm_c)
        ST_IDLE:
            if(r_rd1_rst) // ���������ÿһ֡��ʼʱ��λ����ַ
                r_rd1_addr <= VIDEO1_START_ADDR;
            else if(raddr1_end) // ��Ϊ���һ������ַʱ��λ����ַ
                r_rd1_addr <= VIDEO1_START_ADDR;
            else
                r_rd1_addr <= r_rd1_addr;
        ST_READ_STATE:
            if(M_AXI_ARREADY && M_AXI_ARVALID&&r_output_source[1])
                if(r_arburst_count==READ_BURST_COUNT-1)
                        r_rd1_addr <= r_rd1_addr + READ_BURST_ADDR+MEM_H_PIXEL;
                else 
                        r_rd1_addr <= r_rd1_addr + READ_BURST_ADDR;
            else
                r_rd1_addr <= r_rd1_addr;
        default:
            r_rd1_addr <= r_rd1_addr;
    endcase
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_rd1_bank <= 3'd0;
    else if(fsm_c == ST_IDLE)
        if(raddr1_end) // ���������һ����ַʱ�ı�BANK��ַ
            if( (r_rd1_bank == r_video1_wr_bank + 1'b1) ) // ������дBANK������BANKʱ 
                r_rd1_bank <= r_rd1_bank + 1'b1;
            else
                r_rd1_bank <= r_rd1_bank;
        else
            r_rd1_bank <= r_rd1_bank;
    else
        r_rd1_bank <= r_rd1_bank;
end

//��ƵԴ2
always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_rd2_addr <= VIDEO2_START_ADDR;
    else case(fsm_c)
        ST_IDLE:
            if(r_rd2_rst) // ���������ÿһ֡��ʼʱ��λ����ַ
                r_rd2_addr <= VIDEO2_START_ADDR;
            else if(raddr2_end) // ��Ϊ���һ������ַʱ��λ����ַ
                r_rd2_addr <= VIDEO2_START_ADDR;
            else
                r_rd2_addr <= r_rd2_addr;
        ST_READ_STATE:
            if(M_AXI_ARREADY && M_AXI_ARVALID&&r_output_source[2])
                if(r_arburst_count==READ_BURST_COUNT-1)
                        r_rd2_addr <= r_rd2_addr + READ_BURST_ADDR+MEM_H_PIXEL;
                else 
                        r_rd2_addr <= r_rd2_addr + READ_BURST_ADDR;
            else
                r_rd2_addr <= r_rd2_addr;
        default:
            r_rd2_addr <= r_rd2_addr;
    endcase
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_rd2_bank <= 3'd0;
    else if(fsm_c == ST_IDLE)
        if(raddr2_end) // ���������һ����ַʱ�ı�BANK��ַ
            if( (r_rd2_bank == r_video2_wr_bank + 1'b1) ) // ������дBANK������BANKʱ 
                r_rd2_bank <= r_rd2_bank + 1'b1;
            else
                r_rd2_bank <= r_rd2_bank;
        else
            r_rd2_bank <= r_rd2_bank;
    else
        r_rd2_bank <= r_rd2_bank;
end

//��ƵԴ3
always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_rd3_addr <= VIDEO3_START_ADDR;
    else case(fsm_c)
        ST_IDLE:
            if(r_rd3_rst) // ���������ÿһ֡��ʼʱ��λ����ַ
                r_rd3_addr <= VIDEO3_START_ADDR;
            else if(raddr3_end) // ��Ϊ���һ������ַʱ��λ����ַ
                r_rd3_addr <= VIDEO3_START_ADDR;
            else
                r_rd3_addr <= r_rd3_addr;
        ST_READ_STATE:
            if(M_AXI_ARREADY && M_AXI_ARVALID&&r_output_source[3])
                if(r_arburst_count==READ_BURST_COUNT-1)
                        r_rd3_addr <= r_rd3_addr + READ_BURST_ADDR+MEM_H_PIXEL;
                else 
                        r_rd3_addr <= r_rd3_addr + READ_BURST_ADDR;
            else
                r_rd3_addr <= r_rd3_addr;
        default:
            r_rd3_addr <= r_rd3_addr;
    endcase
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_rd3_bank <= 3'd0;
    else if(fsm_c == ST_IDLE)
        if(raddr3_end) // ���������һ����ַʱ�ı�BANK��ַ
            if((r_rd3_bank == r_video3_wr_bank + 1'b1 )) // ������дBANK������BANKʱ 
                r_rd3_bank <= r_rd3_bank + 1'b1;
            else
                r_rd3_bank <= r_rd3_bank;
        else
            r_rd3_bank <= r_rd3_bank;
    else
        r_rd3_bank <= r_rd3_bank;
end

// ��ʱ���½��ظ���д��ַ
always@(negedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_r_addr <= 'd0;
    else if(fsm_c == ST_READ_STATE)
        case(r_output_source)
            4'b1000:
                r_r_addr <= {1'b0, r_rd3_bank, r_rd3_addr};
            4'b0100:
                r_r_addr <= {1'b0, 2'd1, r_rd2_addr};
            4'b0010:
                r_r_addr <= {1'b0, r_rd1_bank, r_rd1_addr};
            4'b0001:
                r_r_addr <= {1'b0, 1'b1, r_rd_addr};//r_rd_bank
            default:
                r_r_addr <= 'd0;
        endcase
    else
        r_r_addr <= 'd0;
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_m_axi_arvalid <= 1'b0;
    else case(fsm_c)
        ST_READ_START:
            r_m_axi_arvalid <= 1'b1;
        ST_READ_STATE:
            if(r_arburst_count < READ_BURST_COUNT - 1)
                r_m_axi_arvalid <= 1'b1;
            else if(r_arburst_count == READ_BURST_COUNT - 1)
                if(M_AXI_ARREADY && M_AXI_ARVALID)
                    r_m_axi_arvalid <= 1'b0;
                else
                    r_m_axi_arvalid <= 1'b1;
            else
                r_m_axi_arvalid <= 1'b0;
        default:
            r_m_axi_arvalid <= 1'b0;
    endcase
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_arburst_count <= 4'd0;
    else case(fsm_c)
        ST_READ_START: // ��д������ʼʱ���д��ַ����������
            r_arburst_count <= 4'd0;
        ST_READ_STATE:
            if(M_AXI_ARREADY && M_AXI_ARVALID)
                r_arburst_count <= r_arburst_count + 1'b1;
            else
                r_arburst_count <= r_arburst_count;
        default:
            r_arburst_count <= 4'd0;
    endcase
end

///*������ͨ��---------------------------------------------------*/

always@(*)
begin
    case(fsm_c)
        ST_READ_STATE:
            if(r_output_source[0])
                    rd_en = M_AXI_RVALID;
            else
                rd_en = 1'b0;
        default:
            rd_en = 1'b0;
    endcase
end

always@(*)
begin
    case(fsm_c)
        ST_READ_STATE:
            if(r_output_source[1])
                    rd1_en = M_AXI_RVALID;
            else
                rd1_en = 1'b0;
        default:
            rd1_en = 1'b0;
    endcase
end

always@(*)
begin
    case(fsm_c)
        ST_READ_STATE:
            if(r_output_source[2])
                    rd2_en = M_AXI_RVALID;
            else
                rd2_en = 1'b0;
        default:
            rd2_en = 1'b0;
    endcase
end

always@(*)
begin
    case(fsm_c)
        ST_READ_STATE:
            if(r_output_source[3])
                    rd3_en = M_AXI_RVALID;
            else
                rd3_en = 1'b0;
        default:
            rd3_en = 1'b0;
    endcase
end
/*������ͨ��---------------------------------------------------*/
always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_rburst_count <= 4'd0;
    else if(read_start) // ��һ�ζ�������ʼʱ����
        r_rburst_count <= 4'd0;
    else if(M_AXI_RLAST)
        r_rburst_count <= r_rburst_count + 1;
    else
        r_rburst_count <= r_rburst_count;
end

/*��д��ַ��λ�ź�---------------------------------------------------*/
always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        begin
            r0_video0_wr_rst <= 1'b0;
            r1_video0_wr_rst <= 1'b0;
            r0_video1_wr_rst <= 1'b0;
            r1_video1_wr_rst <= 1'b0;
            r0_video2_wr_rst <= 1'b0;
            r1_video2_wr_rst <= 1'b0;
            r0_video3_wr_rst <= 1'b0;
            r1_video3_wr_rst <= 1'b0;
            r0_rd_rst        <= 1'b0;
            r1_rd_rst        <= 1'b0;
            r0_rd1_rst        <= 1'b0;
            r1_rd1_rst        <= 1'b0;
            r0_rd2_rst        <= 1'b0;
            r1_rd2_rst        <= 1'b0;
            r0_rd3_rst        <= 1'b0;
            r1_rd3_rst        <= 1'b0;
        end
    else
        begin
            r0_video0_wr_rst <= video0_wr_rst   ;
            r1_video0_wr_rst <= r0_video0_wr_rst;
            r0_video1_wr_rst <= video1_wr_rst   ;
            r1_video1_wr_rst <= r0_video1_wr_rst;
            r0_video2_wr_rst <= video2_wr_rst   ;
            r1_video2_wr_rst <= r0_video2_wr_rst;
            r0_video3_wr_rst <= video3_wr_rst   ;
            r1_video3_wr_rst <= r0_video3_wr_rst;
            r0_rd_rst        <= rd_rst          ;
            r1_rd_rst        <= r0_rd_rst       ;
            r0_rd1_rst        <= rd1_rst          ;
            r1_rd1_rst        <= r0_rd1_rst       ;
            r0_rd2_rst        <= rd2_rst          ;
            r1_rd2_rst        <= r0_rd2_rst       ;
            r0_rd3_rst        <= rd3_rst          ;
            r1_rd3_rst        <= r0_rd3_rst       ;
        end
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_video0_wr_rst <= 1'b0;
    else if(r0_video0_wr_rst && !r1_video0_wr_rst)
        r_video0_wr_rst <= 1'b1;
    else if(r_video0_wr_addr == VIDEO0_START_ADDR)
        r_video0_wr_rst <= 1'b0;
    else
        r_video0_wr_rst <= r_video0_wr_rst;
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_video1_wr_rst <= 1'b0;
    else if(r0_video1_wr_rst && !r1_video1_wr_rst)
        r_video1_wr_rst <= 1'b1;
    else if(r_video1_wr_addr == VIDEO1_START_ADDR)
        r_video1_wr_rst <= 1'b0;
    else
        r_video1_wr_rst <= r_video1_wr_rst;
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_video2_wr_rst <= 1'b0;
    else if(r0_video2_wr_rst && !r1_video2_wr_rst)
        r_video2_wr_rst <= 1'b1;
    else if(r_video2_wr_addr == VIDEO2_START_ADDR)
        r_video2_wr_rst <= 1'b0;
    else
        r_video2_wr_rst <= r_video2_wr_rst;
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_video3_wr_rst <= 1'b0;
    else if(r0_video3_wr_rst && !r1_video3_wr_rst)
        r_video3_wr_rst <= 1'b1;
    else if(r_video3_wr_addr == VIDEO3_START_ADDR)
        r_video3_wr_rst <= 1'b0;
    else
        r_video3_wr_rst <= r_video3_wr_rst;
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_rd_rst <= 1'b0;
    else if(r0_rd_rst && !r1_rd_rst)
        r_rd_rst <= 1'b1;
    else if(r_rd_addr == VIDEO0_START_ADDR)
        r_rd_rst <= 1'b0;
    else
        r_rd_rst <= r_rd_rst;
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_rd1_rst <= 1'b0;
    else if(r0_rd1_rst && !r1_rd1_rst)
        r_rd1_rst <= 1'b1;
    else if(r_rd1_addr == VIDEO1_START_ADDR)
        r_rd1_rst <= 1'b0;
    else
        r_rd1_rst <= r_rd1_rst;
end


always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_rd2_rst <= 1'b0;
    else if(r0_rd2_rst && !r1_rd2_rst)
        r_rd2_rst <= 1'b1;
    else if(r_rd2_addr == VIDEO2_START_ADDR)
        r_rd2_rst <= 1'b0;
    else
        r_rd2_rst <= r_rd2_rst;
end

always@(posedge M_AXI_ACLK or negedge M_AXI_ARESETN)
begin
    if(!M_AXI_ARESETN)
        r_rd3_rst <= 1'b0;
    else if(r0_rd3_rst && !r1_rd3_rst)
        r_rd3_rst <= 1'b1;
    else if(r_rd3_addr == VIDEO3_START_ADDR)
        r_rd3_rst <= 1'b0;
    else
        r_rd3_rst <= r_rd3_rst;
end
endmodule
