/*****************************************************************/
//
// Create Date: 2024/04/25
// Design Name: WenYiXing
//
/*****************************************************************/

module DDR3_interface_top#(
    parameter FIFO_DATA_WIDTH       = 32    ,
    parameter CAM_H_PIXEL           = 1024  , // ����ͷˮƽ�������ظ���
    parameter CAM_V_PIXEL           = 768   , // ����ͷ��ֱ�������ظ���
    parameter HDMI_H_PIXEL          = 1920  , // HDMI����ˮƽ�������ظ���
    parameter HDMI_V_PIXEL          = 1080  , // HDMI���봹ֱ�������ظ���
    parameter DISP_H                = 1920  , // HDMI���ˮƽ�������ظ���
    parameter DISP_V                = 1080  , // HDMI�����ֱ�������ظ���
    parameter video_o_h             =960    ,  // ����ÿ������һ֡����������      дfifo
    parameter MEM_H_PIXEL           = 960, // ÿһ����ƵԴ��ʾʱ�������� дfifo
    parameter MEM_V_PIXEL           = 540, // ÿһ����ƵԴ��ʾʱ��������
    
    parameter MEM_ROW_WIDTH         = 15    ,
    parameter MEM_COL_WIDTH         = 10    ,
    parameter MEM_BANK_WIDTH        = 3     ,
    parameter MEM_DQ_WIDTH          = 32    ,
    parameter MEM_DM_WIDTH          = MEM_DQ_WIDTH/8,
    parameter MEM_DQS_WIDTH         = MEM_DQ_WIDTH/8,
    parameter MEM_BURST_LEN         = 8     ,
    
    parameter AXI_WRITE_BURST_LEN   = 8     , // дͻ�����䳤�ȣ�֧�֣�1,2,4,8,16��
    parameter AXI_READ_BURST_LEN    = 16    , // ��ͻ�����䳤�ȣ�֧�֣�1,2,4,8,16��
    parameter AXI_ID_WIDTH          = 4     ,
    parameter AXI_USER_WIDTH        = 1     ,
    parameter AXI_DATA_WIDTH        = MEM_DQ_WIDTH * MEM_BURST_LEN,
    parameter AXI_ADDR_WIDTH        = MEM_BANK_WIDTH + MEM_ROW_WIDTH + MEM_COL_WIDTH
)(
    input   wire                                sys_clk         ,
    input   wire                                key_rst_n       ,
    output  wire                                ddr_init_done   ,
    
    input   wire                                video0_wr_clk   ,
    input   wire                                video0_wr_en    ,
    input   wire    [FIFO_DATA_WIDTH-1:0]       video0_wr_data  ,
    input   wire                                video0_wr_rst   ,
    
    input   wire                                video1_wr_clk   ,
    input   wire                                video1_wr_en    ,
    input   wire    [FIFO_DATA_WIDTH-1:0]       video1_wr_data  ,
    input   wire                                video1_wr_rst   ,

    input   wire                                video2_wr_clk   ,
    input   wire                                video2_wr_en    ,
    input   wire    [FIFO_DATA_WIDTH-1:0]       video2_wr_data  ,
    input   wire                                video2_wr_rst   ,

    input   wire                                video3_wr_clk   ,
    input   wire                                video3_wr_en    ,
    input   wire    [FIFO_DATA_WIDTH-1:0]       video3_wr_data  ,
    input   wire                                video3_wr_rst   ,
    
    input   wire                                fifo_rd_clk     ,
    input   wire                                fifo_rd_en      ,
    output  wire    [FIFO_DATA_WIDTH-1:0]       fifo_rd_data    ,
    input   wire                                rd_rst          ,

    input   wire                                fifo_rd1_clk         ,
    input   wire                                fifo_rd1_en      ,
    output  wire    [FIFO_DATA_WIDTH-1:0]       fifo_rd1_data    ,
    input   wire                                rd1_rst          ,

    input   wire                                fifo_rd2_clk         ,
    input   wire                                fifo_rd2_en      ,
    output  wire    [FIFO_DATA_WIDTH-1:0]       fifo_rd2_data    ,
    input   wire                                rd2_rst          ,

    input   wire                                fifo_rd3_en      ,
    output  wire    [FIFO_DATA_WIDTH-1:0]       fifo_rd3_data    ,
    input   wire                                rd3_rst          ,
    
    output  wire                                mem_rst_n       ,
    output  wire                                mem_ck          ,
    output  wire                                mem_ck_n        ,
    output  wire                                mem_cke         ,
    output  wire                                mem_cs_n        ,
    output  wire                                mem_ras_n       ,
    output  wire                                mem_cas_n       ,
    output  wire                                mem_we_n        ,
    output  wire                                mem_odt         ,
    output  wire    [MEM_ROW_WIDTH-1:0]         mem_a           ,
    output  wire    [MEM_BANK_WIDTH-1:0]        mem_ba          ,
    inout   wire    [MEM_DQS_WIDTH-1:0]         mem_dqs         ,
    inout   wire    [MEM_DQS_WIDTH-1:0]         mem_dqs_n       ,
    inout   wire    [MEM_DQ_WIDTH-1:0]          mem_dq          ,
    output  wire    [MEM_DM_WIDTH-1:0]          mem_dm          ,
    
    output  wire                                fifo_video0_full,
    output  wire                                fifo_video1_full,
    output  wire                                fifo_o_full     ,

    //���ŷֱ���
    input wire [15:0] vout_yres   ,
    input wire [15:0] vout_xres

);

/****************************wire****************************/
wire    [3:0]                   axi_wr_req         /*synthesis PAP_MARK_DEBUG="1"*/ ;
wire    [3:0]                   axi_rd_req          ;

wire    [3:0]                   axi_wr_grant        /*synthesis PAP_MARK_DEBUG="1"*/;
wire    [3:0]                   axi_rd_grant        ;

wire                            axi_video0_wr_en    ;
wire                            axi_video1_wr_en    ;
wire                            axi_video2_wr_en    ;
wire                            axi_video3_wr_en    ;
wire    [AXI_DATA_WIDTH-1:0]    axi_video0_wr_data  ;
wire    [AXI_DATA_WIDTH-1:0]    axi_video1_wr_data  ;
wire    [AXI_DATA_WIDTH-1:0]    axi_video2_wr_data  ;
wire    [AXI_DATA_WIDTH-1:0]    axi_video3_wr_data  ;

wire                            axi_rd_en           ;
wire    [AXI_DATA_WIDTH-1:0]    axi_rd_data         ;
wire                            axi_rd1_req          ;
wire                             axi_rd1_en           ;
wire    [AXI_DATA_WIDTH-1:0]    axi_rd1_data         ;
wire                            axi_rd2_req          ;
wire                            axi_rd2_en           ;
wire    [AXI_DATA_WIDTH-1:0]    axi_rd2_data         ;
wire                            axi_rd3_req          ;
wire                            axi_rd3_en           ;
wire    [AXI_DATA_WIDTH-1:0]    axi_rd3_data         ;

wire                            ddrphy_clkin    ;
wire                            sys_rst_n       ;

wire    [AXI_ADDR_WIDTH-1:0]    axi_awaddr      ;
wire    [AXI_USER_WIDTH-1:0]    axi_awuser_ap   ;
wire    [AXI_ID_WIDTH-1:0]      axi_awuser_id   ;
wire    [3:0]                   axi_awlen       ;
wire                            axi_awready     ;
wire                            axi_awvalid     ;

wire    [AXI_DATA_WIDTH-1:0]    axi_wdata       ;
wire    [AXI_DATA_WIDTH/8-1:0]  axi_wstrb       ;
wire                            axi_wready      ;
wire    [AXI_ID_WIDTH-1:0]      axi_wusero_id   ;
wire                            axi_wusero_last ;

wire    [AXI_ADDR_WIDTH-1:0]    axi_araddr      ;
wire    [AXI_USER_WIDTH-1:0]    axi_aruser_ap   ;
wire    [AXI_ID_WIDTH-1:0]      axi_aruser_id   ;
wire    [3:0]                   axi_arlen       ;
wire                            axi_arready     ;
wire                            axi_arvalid     ;

wire    [AXI_DATA_WIDTH-1:0]    axi_rdata       ;
wire    [AXI_ID_WIDTH-1:0]      axi_rid         ;
wire                            axi_rlast       ;
wire                            axi_rvalid      ;

/********************combinational logic*********************/
assign sys_rst_n = key_rst_n && ddr_init_done; // FIFOģ����DDR��ʼ����ɺ�Ÿ�λ���

///***********************instantiation************************/
//AXI_rw_FIFO #(
//    .AXI_DATA_WIDTH             (AXI_DATA_WIDTH     ), // AXI ����λ��
//    .MEM_BURST_LEN              (MEM_BURST_LEN      ), // DDR ͻ�����䳤��
//    .FIFO_DATA_WIDTH            (FIFO_DATA_WIDTH    ), // FIFO �û�������λ��
//    .MEM_H_PIXEL                (MEM_H_PIXEL        ), // д��һ֡��������
//    .DISP_H                     (DISP_H             ),  // ����һ֡���������� û
//    .video_o_h                  (video_o_h          )   // ����ÿ������һ֡����������
//)u_AXI_rw_FIFO(
//    .ddrphy_clkin               (ddrphy_clkin       ), // input
//    .rst_n                      (sys_rst_n          ), // input
//    
//    .video0_wr_clk              (video0_wr_clk      ), // input
//    .video0_wr_en               (video0_wr_en       ), // input
//    .video0_wr_data             (video0_wr_data     ), // input  [FIFO_DATA_WIDTH-1:0]
//    .video0_wr_rst              (video0_wr_rst      ), // input
//    
//    .video1_wr_clk              (video1_wr_clk      ), // input
//    .video1_wr_en               (video1_wr_en       ), // input
//    .video1_wr_data             (video1_wr_data     ), // input  [FIFO_DATA_WIDTH-1:0]
//    .video1_wr_rst              (video1_wr_rst      ), // input
//
//    .video2_wr_clk              (video2_wr_clk      ), // input
//    .video2_wr_en               (video2_wr_en       ), // input
//    .video2_wr_data             (video2_wr_data     ), // input  [FIFO_DATA_WIDTH-1:0]
//    .video2_wr_rst              (video2_wr_rst      ), // input
//
//    .video3_wr_clk              (video3_wr_clk      ), // input
//    .video3_wr_en               (video3_wr_en       ), // input
//    .video3_wr_data             (video3_wr_data     ), // input  [FIFO_DATA_WIDTH-1:0]
//    .video3_wr_rst              (video3_wr_rst      ), // input
//    
//    .fifo_rd_clk                (fifo_rd_clk        ), // input
//    .fifo_rd_en                 (fifo_rd_en         ), // input
//    .fifo_rd_data               (fifo_rd_data       ), // output [FIFO_DATA_WIDTH-1:0]
//    .fifo_rd_rst                (rd_rst             ), // input
//
//    .fifo_rd1_clk                (fifo_rd1_clk        ), // input
//    .fifo_rd1_en                 (fifo_rd1_en         ), // input
//    .fifo_rd1_data               (fifo_rd1_data       ), // output [FIFO_DATA_WIDTH-1:0]
//    .fifo_rd1_rst                (rd1_rst             ), // input
//
//    .fifo_rd2_clk                (fifo_rd2_clk        ),
//    .fifo_rd2_en                 (fifo_rd2_en         ), // input
//    .fifo_rd2_data               (fifo_rd2_data       ), // output [FIFO_DATA_WIDTH-1:0]
//    .fifo_rd2_rst                (rd2_rst             ), // input
//
//    .fifo_rd3_en                 (fifo_rd3_en         ), // input
//    .fifo_rd3_data               (fifo_rd3_data       ), // output [FIFO_DATA_WIDTH-1:0]
//    .fifo_rd3_rst                (rd3_rst             ), // input
//    
//    .axi_wr_req                 (axi_wr_req         ), // output
//    
//    .axi_video0_wr_en           (axi_video0_wr_en   ), // input
//    .axi_video0_wr_data         (axi_video0_wr_data ), // output [FIFO_DATA_WIDTH-1:0]
//    
//    .axi_video1_wr_en           (axi_video1_wr_en   ),// input
//    .axi_video1_wr_data         (axi_video1_wr_data ),// output [FIFO_DATA_WIDTH-1:0]
//
//    .axi_video2_wr_en           (axi_video2_wr_en   ),// input
//    .axi_video2_wr_data         (axi_video2_wr_data ),// output [FIFO_DATA_WIDTH-1:0]
//
//    .axi_video3_wr_en           (axi_video3_wr_en   ),// input
//    .axi_video3_wr_data         (axi_video3_wr_data ),// output [FIFO_DATA_WIDTH-1:0]
//    
//    .axi_rd_en                  (axi_rd_en          ), // input
//    .axi_rd_data                (axi_rd_data        ), // input  [FIFO_DATA_WIDTH-1:0]
//
//    .axi_rd1_en                  (axi_rd1_en          ), // input
//    .axi_rd1_data                (axi_rd1_data        ), // input  [FIFO_DATA_WIDTH-1:0]
//
//    .axi_rd2_en                  (axi_rd2_en          ), // input
//    .axi_rd2_data                (axi_rd2_data        ), // input  [FIFO_DATA_WIDTH-1:0]
//
//    .axi_rd3_en                  (axi_rd3_en          ), // input
//    .axi_rd3_data                (axi_rd3_data        ), // input  [FIFO_DATA_WIDTH-1:0]
//
//    
//    .axi_rd_req                 (axi_rd_req         ), // output
//
//
//    .fifo_video0_full           (fifo_video0_full   ),
//    .fifo_video1_full           (fifo_video1_full   ),
//    .fifo_o1_full                (fifo_o_full        ),
//    //���ŷֱ���
//    .vout_xres                  (vout_xres)
//);
//
//arbiter u_arbiter(
//    .request                    (axi_wr_req     ), // input  [HDMI, CAMERA]
//    .grant                      (axi_wr_grant   ),  // output [HDMI, CAMERA]
//    .request_rd                 (axi_rd_req     ), // input  [HDMI, CAMERA]
//    .grant_rd                   (axi_rd_grant   )  // output [HDMI, CAMERA]
//);
//
//simplified_AXI #(
//    .DISP_H                     (DISP_H             ), // ��ʾһ֡���ݵ������ظ���
//    .DISP_V                     (DISP_V             ), // ��ʾһ֡���ݵ������ظ���
//    .MEM_H_PIXEL                (MEM_H_PIXEL        ), // ÿһ����ƵԴ��ʾʱ��������
//    .MEM_V_PIXEL                (MEM_V_PIXEL        ), // ÿһ����ƵԴ��ʾʱ��������
//    
//    .AXI_WRITE_BURST_LEN        (AXI_WRITE_BURST_LEN), // AXI дͻ�����䳤��
//    .AXI_READ_BURST_LEN         (AXI_READ_BURST_LEN ), // AXI ��ͻ�����䳤��
//    .AXI_ID_WIDTH               (AXI_ID_WIDTH       ), // AXI IDλ��
//    .AXI_USER_WIDTH             (AXI_USER_WIDTH     ), // AXI USERλ��
//    .AXI_DATA_WIDTH             (AXI_DATA_WIDTH     ), // AXI ����λ��
//    .MEM_ROW_WIDTH              (MEM_ROW_WIDTH      ), // DDR �е�ַλ��
//    .MEM_COL_WIDTH              (MEM_COL_WIDTH      ), // DDR �е�ַλ��
//    .MEM_BANK_WIDTH             (MEM_BANK_WIDTH     ), // DDR BANK��ַλ��
//    .MEM_BURST_LEN              (MEM_BURST_LEN      )  // DDR ͻ�����䳤��
//)u_simplified_AXI(
//    .M_AXI_ACLK                 (ddrphy_clkin       ), // input
//    .M_AXI_ARESETN              (sys_rst_n          ), // input
//
//    .axi_wr_grant               (axi_wr_grant       ), // input  ����FIFO��д����
//    .axi_rd_grant               (axi_rd_grant       ), // input  ����FIFO��д����
//
//    
//    .axi_video0_wr_en           (axi_video0_wr_en   ), // output FIFO_video0��дʹ��
//    .axi_video0_wr_data         (axi_video0_wr_data ), // input  FIFO_video0��д����
//    .video0_wr_rst              (video0_wr_rst      ), // input  ��ƵԴ0д��ַ��λ
//    
//    .axi_video1_wr_en           (axi_video1_wr_en   ), // output FIFO_video1��дʹ��
//    .axi_video1_wr_data         (axi_video1_wr_data ), // input  FIFO_video1��д����
//    .video1_wr_rst              (video1_wr_rst      ), // input  ��ƵԴ1д��ַ��λ
//
//    .axi_video2_wr_en           (axi_video2_wr_en   ), // output FIFO_video1��дʹ��
//    .axi_video2_wr_data         (axi_video2_wr_data ), // input  FIFO_video1��д����
//    .video2_wr_rst              (video2_wr_rst      ), // input  ��ƵԴ1д��ַ��λ
//
//    .axi_video3_wr_en           (axi_video3_wr_en   ), // output FIFO_video1��дʹ��
//    .axi_video3_wr_data         (axi_video3_wr_data ), // input  FIFO_video1��д����
//    .video3_wr_rst              (video3_wr_rst      ), // input  ��ƵԴ1д��ַ��λ
//    
//    .rd_en                      (axi_rd_en          ), // output ���FIFO����ʹ��
//    .rd_data                    (axi_rd_data        ), // output ���FIFO��������
//    .rd_rst                     (rd_rst             ), // input  ����ַ��λ�ź�
//
//    .rd1_en                      (axi_rd1_en          ), // output ���FIFO����ʹ��
//    .rd1_data                    (axi_rd1_data        ), // output ���FIFO��������
//    .rd1_rst                     (rd1_rst             ), // input  ����ַ��λ�ź�
//
//    .rd2_en                      (axi_rd2_en          ), // output ���FIFO����ʹ��
//    .rd2_data                    (axi_rd2_data        ), // output ���FIFO��������
//    .rd2_rst                     (rd2_rst             ), // input  ����ַ��λ�ź�
//
//    .rd3_en                      (axi_rd3_en          ), // output ���FIFO����ʹ��
//    .rd3_data                    (axi_rd3_data        ), // output ���FIFO��������
//    .rd3_rst                     (rd3_rst             ), // input  ����ַ��λ�ź�
//
//    .M_AXI_AWADDR               (axi_awaddr     ),
//    .M_AXI_AWUSER               (axi_awuser_ap  ),
//    .M_AXI_AWID                 (axi_awuser_id  ),
//    .M_AXI_AWLEN                (axi_awlen      ),
//    .M_AXI_AWREADY              (axi_awready    ),
//    .M_AXI_AWVALID              (axi_awvalid    ),
//                                
//    .M_AXI_WDATA                (axi_wdata      ),
//    .M_AXI_WSTRB                (axi_wstrb      ),
//    .M_AXI_WREADY               (axi_wready     ),
//    .M_AXI_WID                  (axi_wusero_id  ),
//    .M_AXI_WLAST                (axi_wusero_last),
//                                
//    .M_AXI_ARADDR               (axi_araddr     ),
//    .M_AXI_ARUSER               (axi_aruser_ap  ),
//    .M_AXI_ARID                 (axi_aruser_id  ),
//    .M_AXI_ARLEN                (axi_arlen      ),
//    .M_AXI_ARREADY              (axi_arready    ),
//    .M_AXI_ARVALID              (axi_arvalid    ),
//                                
//    .M_AXI_RDATA                (axi_rdata      ),
//    .M_AXI_RID                  (axi_rid        ),
//    .M_AXI_RLAST                (axi_rlast      ),
//    .M_AXI_RVALID               (axi_rvalid     ),
//
//    //���ŷֱ���
//    .vout_yres                  (vout_yres),
//    .vout_xres                  (vout_xres)
//
//);

ddr3_interface #(
    .MEM_ROW_WIDTH              (MEM_ROW_WIDTH  ),
    .MEM_COLUMN_WIDTH           (MEM_COL_WIDTH  ),
    .MEM_BANK_WIDTH             (MEM_BANK_WIDTH ),
    .MEM_DQ_WIDTH               (MEM_DQ_WIDTH   ),
    .MEM_DM_WIDTH               (MEM_DM_WIDTH   ),
    .MEM_DQS_WIDTH              (MEM_DQS_WIDTH  ),
    .CTRL_ADDR_WIDTH            (AXI_ADDR_WIDTH )
)u_ddr3_interface(
    .ref_clk                    (sys_clk        ),   // input
    .resetn                     (key_rst_n      ),   // input
    .ddr_init_done              (ddr_init_done  ),   // output
    .ddrphy_clkin               (ddrphy_clkin   ),   // output
    .pll_lock                   (               ),   // output
    
    .axi_awaddr                 (axi_awaddr     ),   // input {ROW[14], BANK[2:0], ROW[13:0], COL[9:0]}
    .axi_awuser_ap              (axi_awuser_ap  ),   // input
    .axi_awuser_id              (axi_awuser_id  ),   // input [3:0]
    .axi_awlen                  (axi_awlen      ),   // input [3:0]
    .axi_awready                (axi_awready    ),   // output
    .axi_awvalid                (axi_awvalid    ),   // input
    
    .axi_wdata                  (axi_wdata      ),   // input [32*8-1:0]
    .axi_wstrb                  (axi_wstrb      ),   // input [31:0]
    .axi_wready                 (axi_wready     ),   // output
    .axi_wusero_id              (axi_wusero_id  ),   // output [3:0]
    .axi_wusero_last            (axi_wusero_last),   // output
    
    .axi_araddr                 (axi_araddr     ),   // input {ROW[14], BANK[2:0], ROW[13:0], COL[9:0]}
    .axi_aruser_ap              (axi_aruser_ap  ),   // input
    .axi_aruser_id              (axi_aruser_id  ),   // input [3:0]
    .axi_arlen                  (axi_arlen      ),   // input [3:0]
    .axi_arready                (axi_arready    ),   // output
    .axi_arvalid                (axi_arvalid    ),   // input
    
    .axi_rdata                  (axi_rdata      ),   // output [32*8-1:0]
    .axi_rid                    (axi_rid        ),   // output [3:0]
    .axi_rlast                  (axi_rlast      ),   // output
    .axi_rvalid                 (axi_rvalid     ),   // output
    
    .apb_clk                    (1'b0           ),
    .apb_rst_n                  (1'b0           ),
    .apb_sel                    (1'b0           ),
    .apb_enable                 (1'b0           ),
    .apb_addr                   (8'd0           ),
    .apb_write                  (1'b0           ),
    .apb_ready                  (               ),
    .apb_wdata                  (16'd0          ),
    .apb_rdata                  (               ),
    .apb_int                    (               ),
    
    .debug_data                 (               ),
    .debug_calib_ctrl           (               ),
    .debug_slice_state          (               ),
    .dll_step                   (               ),
    .dll_lock                   (               ),
    .force_read_clk_ctrl        (1'b0           ), 
    .init_slip_step             (4'd0           ),
    .init_read_clk_ctrl         (3'd0           ), 
    .force_ck_dly_en            (1'b0           ),
    .force_ck_dly_set_bin       (8'h14          ),
    .ddrphy_gate_update_en      (1'b0           ),
    .update_com_val_err_flag    (               ),
    .rd_fake_stop               (1'b0           ),
    .ck_dly_set_bin             (               ),
    
    .mem_rst_n                  (mem_rst_n      ),   // output
    .mem_ck                     (mem_ck         ),   // output
    .mem_ck_n                   (mem_ck_n       ),   // output
    .mem_cke                    (mem_cke        ),   // output
    .mem_cs_n                   (mem_cs_n       ),   // output
    .mem_ras_n                  (mem_ras_n      ),   // output
    .mem_cas_n                  (mem_cas_n      ),   // output
    .mem_we_n                   (mem_we_n       ),   // output
    .mem_odt                    (mem_odt        ),   // output
    .mem_a                      (mem_a          ),   // output [14:0]
    .mem_ba                     (mem_ba         ),   // output [2:0]
    .mem_dqs                    (mem_dqs        ),   // inout  [3:0]
    .mem_dqs_n                  (mem_dqs_n      ),   // inout  [3:0]
    .mem_dq                     (mem_dq         ),   // inout  [31:0]
    .mem_dm                     (mem_dm         )    // output [3:0]
);

endmodule
