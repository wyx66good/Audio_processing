//Author:wyx
//Times :2024.4.16

module PCIE(
    input  wire          clk,
    input  wire          rst_board          ,
    input  wire          pcie_perst_n       ,//PCIE¸´Î»Òý½Å    
//vudio in
    input  wire         es0_dsclk,
    input  wire         es7243_init,
    input  wire [15:0]  rx_data  ,
    input  wire         rx_r_vld ,
    input  wire         rx_l_vld ,
    output                     start,

    output           smlh_link_up,
    output           rdlh_link_up
   );

//axis slave 2 interface
wire            axis_slave0_tvalid ;
wire            axis_slave0_tlast  ;
wire            axis_slave0_tuser  ;
wire  [127:0]   axis_slave0_tdata  ;
wire            axis_slave1_tvalid ;
wire            axis_slave1_tlast  ;
wire            axis_slave1_tuser  ;
wire  [127:0]   axis_slave1_tdata  ;

wire 			axis_master_tvalid    /* synthesis PAP_MARK_DEBUG="1" */;
wire			axis_master_tready    /* synthesis PAP_MARK_DEBUG="1" */;
wire [127:0]	axis_master_tdata     /* synthesis PAP_MARK_DEBUG="1" */;
wire [3:0]	    axis_master_tkeep         /* synthesis PAP_MARK_DEBUG="1" */;
wire 			axis_master_tlast     /* synthesis PAP_MARK_DEBUG="1" */;
wire [7:0] 	    axis_master_tuser     /* synthesis PAP_MARK_DEBUG="1" */;

wire            axis_slave2_tready      /* synthesis PAP_MARK_DEBUG="1" */;
wire            axis_slave2_tvalid      /* synthesis PAP_MARK_DEBUG="1" */;
wire    [127:0] axis_slave2_tdata       /* synthesis PAP_MARK_DEBUG="1" */;
wire            axis_slave2_tlast       /* synthesis PAP_MARK_DEBUG="1" */;
wire            axis_slave2_tuser       /* synthesis PAP_MARK_DEBUG="1" */;

wire    [7:0]   cfg_pbus_num            ;
wire    [4:0]   cfg_pbus_dev_num        ;
wire    [2:0]   cfg_max_rd_req_size     ;
wire    [2:0]   cfg_max_payload_size    ;
wire            cfg_rcb                 ;
//system signal
wire    [4:0]   smlh_ltssm_state       /* synthesis PAP_MARK_DEBUG="1" */;
wire            core_rst_n             /* synthesis PAP_MARK_DEBUG="1" */;
wire            sync_button_rst_n      /* synthesis PAP_MARK_DEBUG="1" */;
wire            sync_perst_n           /* synthesis PAP_MARK_DEBUG="1" */;  
wire            smlh_link_up           /* synthesis PAP_MARK_DEBUG="1" */;
wire            rdlh_link_up           /* synthesis PAP_MARK_DEBUG="1" */; 

wire            pclk        ;
wire            pclk_div2    /* synthesis PAP_MARK_DEBUG="1" */;
wire            pcie_ref_clk;
wire            ref_clk_n   ;
wire            ref_clk_p   ;

assign axis_slave0_tvalid      = 'd0;
assign axis_slave0_tlast       = 'd0;
assign axis_slave0_tuser       = 'd0;
assign axis_slave0_tdata       = 'd0;
assign axis_slave1_tvalid      = 'd0;
assign axis_slave1_tlast       = 'd0;
assign axis_slave1_tuser       = 'd0;
assign axis_slave1_tdata       = 'd0;
    

wire  [7 : 0] cfg_pbus_num           ;
wire  [4 : 0] cfg_pbus_dev_num           ;

pcie_dma u_pcie_dma(
.clk                   (pclk_div2                ),
.rstn                  (rst_board          ),

.es0_dsclk             (es0_dsclk          ),
.es7243_init           (es7243_init),
.rx_data               (rx_data            ),
.rx_r_vld              (rx_r_vld           ),
.rx_l_vld              (rx_l_vld           ),
.start                 (start              ),

.axis_master_tvalid    (axis_master_tvalid ),
.axis_master_tready    (axis_master_tready ),
.axis_master_tdata     (axis_master_tdata  ),
.axis_master_tkeep     (axis_master_tkeep  ),
.axis_master_tlast     (axis_master_tlast  ),
.axis_master_tuser     (axis_master_tuser  ),
.ep_bus_num            (cfg_pbus_num       ),
.ep_dev_num            (cfg_pbus_dev_num   ),
.axis_slave2_tready    (axis_slave2_tready ),
.axis_slave2_tvalid    (axis_slave2_tvalid ),
.axis_slave2_tdata     (axis_slave2_tdata  ),
.axis_slave2_tlast     (axis_slave2_tlast  ),
.axis_slave2_tuser     (axis_slave2_tuser  ) 


); 

//----------------------------------------------------------rst debounce ----------------------------------------------------------
//ASYNC RST  define IPSL_PCIE_SPEEDUP_SIM when simulation
hsst_rst_cross_sync_v1_0 #(
    `ifdef IPSL_PCIE_SPEEDUP_SIM
    .RST_CNTR_VALUE     (16'h10             )
    `else
    .RST_CNTR_VALUE     (16'hC000           )
    `endif
)
u_refclk_buttonrstn_debounce(
    .clk                (pcie_ref_clk            ),
    .rstn_in            (rst_board       ),
    .rstn_out           (sync_button_rst_n  )
);

hsst_rst_cross_sync_v1_0 #(
    `ifdef IPSL_PCIE_SPEEDUP_SIM
    .RST_CNTR_VALUE     (16'h10             )
    `else
    .RST_CNTR_VALUE     (16'hC000           )
    `endif
)
u_refclk_perstn_debounce(
    .clk                (pcie_ref_clk            ),
    .rstn_in            (pcie_perst_n            ),
    .rstn_out           (sync_perst_n       )
);

ipsl_pcie_sync_v1_0  u_ref_core_rstn_sync    (
    .clk                (pcie_ref_clk            ),
    .rst_n              (core_rst_n         ),
    .sig_async          (1'b1               ),
    .sig_synced         (ref_core_rst_n     )
);

ipsl_pcie_sync_v1_0  u_pclk_core_rstn_sync   (
    .clk                (pclk               ),
    .rst_n              (core_rst_n         ),
    .sig_async          (1'b1               ),
    .sig_synced         (s_pclk_rstn        )
);

ipsl_pcie_sync_v1_0  u_pclk_div2_core_rstn_sync   (
    .clk                (pclk_div2          ),
    .rst_n              (core_rst_n         ),
    .sig_async          (1'b1               ),
    .sig_synced         (s_pclk_div2_rstn   )
);

pcie_test u_ipsl_pcie_wrap
(
    .button_rst_n               (sync_button_rst_n      ),
    .power_up_rst_n             (sync_perst_n           ),
    .perst_n                    (sync_perst_n           ),
    //clk and rst
    .free_clk                   (clk                    ),
    .pclk                       (pclk                   ),      //output
    .pclk_div2                  (pclk_div2              ),      //output
    .ref_clk                    (pcie_ref_clk           ),      //output
    .ref_clk_n                  (                       ),      //input
    .ref_clk_p                  (                       ),      //input
    .core_rst_n                 (core_rst_n             ),      //output
    
    //APB interface to  DBI cfg
//  .p_clk                      (ref_clk                ),      //input
    .p_sel                      (                       ),      //input
    .p_strb                     (                       ),      //input  [ 3:0]
    .p_addr                     (                       ),      //input  [15:0]
    .p_wdata                    (                       ),      //input  [31:0]
    .p_ce                       (                       ),      //input
    .p_we                       (                       ),      //input
    .p_rdy                      (                       ),      //output
    .p_rdata                    (                       ),      //output [31:0]
    
    //PHY diff signals
    .rxn                        (                    ),      //input   max[3:0]
    .rxp                        (                    ),      //input   max[3:0]
    .txn                        (                    ),      //output  max[3:0]
    .txp                        (                    ),      //output  max[3:0]
    
    .pcs_nearend_loop           ({2{1'b0}}              ),      //input
    .pma_nearend_ploop          ({2{1'b0}}              ),      //input
    .pma_nearend_sloop          ({2{1'b0}}              ),      //input
    
    //AXIS master interface
    .axis_master_tvalid         (axis_master_tvalid     ),      //output
    .axis_master_tready         ('d1     ),      //input
    .axis_master_tdata          (axis_master_tdata      ),      //output [127:0]
    .axis_master_tkeep          (axis_master_tkeep      ),      //output [3:0]
    .axis_master_tlast          (axis_master_tlast      ),      //output
    .axis_master_tuser          (axis_master_tuser      ),      //output [7:0]
    
    //axis slave 0 interface
    .axis_slave0_tready         (axis_slave0_tready   ),      //output
    .axis_slave0_tvalid         ('d0   ),      //input
    .axis_slave0_tdata          ('d0   ),      //input  [127:0]
    .axis_slave0_tlast          ('d0   ),      //input
    .axis_slave0_tuser          ('d0   ),      //input
                                                    
    //axis slave 1 interface                        
    .axis_slave1_tready         (axis_slave1_tready   ),      //output
    .axis_slave1_tvalid         ('d0   ),      //input
    .axis_slave1_tdata          ('d0   ),      //input  [127:0]
    .axis_slave1_tlast          ('d0   ),      //input
    .axis_slave1_tuser          ('d0   ),      //input
    //axis slave 2 interface                        
    .axis_slave2_tready         (axis_slave2_tready   ),      //output
    .axis_slave2_tvalid         (axis_slave2_tvalid   ),      //input
    .axis_slave2_tdata          (axis_slave2_tdata    ),      //input  [127:0]
    .axis_slave2_tlast          (axis_slave2_tlast    ),      //input
    .axis_slave2_tuser          (axis_slave2_tuser  ),      //input
  
    .pm_xtlh_block_tlp          (                       ),      //output
    
    .cfg_send_cor_err_mux       (                       ),      //output
    .cfg_send_nf_err_mux        (                       ),      //output
    .cfg_send_f_err_mux         (                       ),      //output
    .cfg_sys_err_rc             (                       ),      //output
    .cfg_aer_rc_err_mux         (                       ),      //output
    //radm timeout
    .radm_cpl_timeout           (                       ),      //output
    
    //configuration signals
    .cfg_max_rd_req_size        (cfg_max_rd_req_size    ),      //output [2:0]
    .cfg_bus_master_en          (                       ),      //output
    .cfg_max_payload_size       (cfg_max_payload_size   ),      //output [2:0]
    .cfg_ext_tag_en             (                       ),      //output
    .cfg_rcb                    (cfg_rcb                ),      //output
    .cfg_mem_space_en           (                       ),      //output
    .cfg_pm_no_soft_rst         (                       ),      //output
    .cfg_crs_sw_vis_en          (                       ),      //output
    .cfg_no_snoop_en            (                       ),      //output
    .cfg_relax_order_en         (                       ),      //output
    .cfg_tph_req_en             (                       ),      //output [2-1:0]
    .cfg_pf_tph_st_mode         (                       ),      //output [3-1:0]
    .rbar_ctrl_update           (                       ),      //output
    .cfg_atomic_req_en          (                       ),      //output
    
    .cfg_pbus_num               (cfg_pbus_num           ),      //output [7:0]
    .cfg_pbus_dev_num           (cfg_pbus_dev_num       ),      //output [4:0]
    
    //debug signals
    .radm_idle                  (                       ),      //output
    .radm_q_not_empty           (                       ),      //output
    .radm_qoverflow             (                       ),      //output
    .diag_ctrl_bus              (2'b0                   ),      //input   [1:0]
    .cfg_link_auto_bw_mux       (                       ),      //output              merge cfg_link_auto_bw_msi and cfg_link_auto_bw_int
    .cfg_bw_mgt_mux             (                       ),      //output              merge cfg_bw_mgt_int and cfg_bw_mgt_msi
    .cfg_pme_mux                (                       ),      //output              merge cfg_pme_int and cfg_pme_msi
    .app_ras_des_sd_hold_ltssm  (1'b0                   ),      //input
    .app_ras_des_tba_ctrl       (2'b0                   ),      //input   [1:0]
    
    .dyn_debug_info_sel         (4'b0                   ),      //input   [3:0]
    .debug_info_mux             (                       ),      //output  [132:0]
    
    //system signal
    .smlh_link_up               (smlh_link_up           ),      //output
    .rdlh_link_up               (rdlh_link_up           ),      //output
    .smlh_ltssm_state           (smlh_ltssm_state       )       //output  [4:0]
);
endmodule