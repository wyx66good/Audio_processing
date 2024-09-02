`timescale 1ns / 1ps
module sim_tb( );
wire GRS_N;
//输入
	reg sys_clk; 
	reg sys_rst_n; 
//输出
	wire [1:0] led;
    reg rx_r_vld;
    wire [127:0]axis_master_tdata;
//信号初始化，必须有这一步，容易被忽略
initial begin
	sys_clk = 1'b0; 
    rx_r_vld ='d0;
	sys_rst_n = 1'b0;
	#200  //延时200ns
	sys_rst_n = 1'b1;
//    #250
//    axis_master_tdata={ 32'd0,32'h110,32'd0,8'h40,14'd0,10'd1};
//    #260
//    axis_master_tdata='d0;
end

//生成时钟，模拟晶振实际的周期时序
always #10 sys_clk = ~sys_clk; //每10ns，sys_clk进行翻转，达到模拟晶振周期为20ns
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


