`timescale 1ns / 1ps
module sim_tb( );
wire GRS_N;
//����
	reg sys_clk; 
	reg sys_rst_n; 
//���
	wire [1:0] led;
    reg rx_r_vld;
    wire [127:0]axis_master_tdata;
//�źų�ʼ������������һ�������ױ�����
initial begin
	sys_clk = 1'b0; 
    rx_r_vld ='d0;
	sys_rst_n = 1'b0;
	#200  //��ʱ200ns
	sys_rst_n = 1'b1;
//    #250
//    axis_master_tdata={ 32'd0,32'h110,32'd0,8'h40,14'd0,10'd1};
//    #260
//    axis_master_tdata='d0;
end

//����ʱ�ӣ�ģ�⾧��ʵ�ʵ�����ʱ��
always #10 sys_clk = ~sys_clk; //ÿ10ns��sys_clk���з�ת���ﵽģ�⾧������Ϊ20ns
always #25 rx_r_vld = ~rx_r_vld;

pcie_dma u_pcie_dma(
.clk                 (sys_clk), 
.rstn                (!sys_rst_n),                                        
.es0_dsclk           (sys_clk),
.es7243_init         (!sys_rst_n),
.rx_data             (),
.rx_r_vld            (),
.rx_l_vld            (),
.start               (),                                      
.axis_master_tvalid  ('d1), 
.axis_master_tready  (), 
.axis_master_tdata   (axis_master_tdata), 
.axis_master_tkeep   (), 
.axis_master_tlast   (), 
.axis_master_tuser   (),                        
.ep_bus_num          (),
.ep_dev_num          (),                        
.axis_slave2_tready  (),
.axis_slave2_tvalid  (),
.axis_slave2_tdata   (),
.axis_slave2_tlast   (),
.axis_slave2_tuser   ()
);


GTP_GRS GRS_INST (

.GRS_N(1'b1)

);




endmodule


