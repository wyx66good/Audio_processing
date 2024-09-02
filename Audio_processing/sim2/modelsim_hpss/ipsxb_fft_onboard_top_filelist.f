// Example Design Top
../../source/source/Voice_change.v
../../source/source/sin.v
../../source/source/x.v
../../source/source/d.v
../../source/source/fft_ip.v
../../source/Framing_hpss_512.v
../../source/source/HPSS.v
../../source/hanning.v
../../source/midian.v
../../source/Median_filtering.v
../../source/S_H.v
../../source/tiaozhi.v
../../source/x_7.v
../../source/min_mid_max_3.v
../../source/iFFT_hpss.v
../../source/divide32.v
../../source/Div_cell.v


// Testbench
../HPSS_tb.sv 

// FFT TOP
../../source/radix2/ipsxb_fft_demo_r2_1024.v

// FFT CORE
../../source/rtl/synplify/ipsxb_fft_core_v1_0_simvpAll.vp     

../../source/radix2/drm_sdpram/ipsxb_fft_drm_sdpram_9k.v
../../source/radix2/drm_sdpram/rtl/ipsxb_fft_drm_sdpram_v1_8_9k.v

../../source/radix2/distram_sreg/ipsxe_fft_distram_sreg.v
../../source/radix2/distram_sreg/rtl/ipsxe_fft_distributed_shiftregister_v1_3.v
../../source/radix2/distram_sreg/rtl/ipsxe_fft_distributed_sdpram_v1_2.v
../../source/radix2/distram_sdpram/ipsxe_fft_distram_sdpram.v


../../ipcore/Voice_change_ram/Voice_change_ram.v
../../ipcore/Frame_capture_ram/Frame_capture_ram.v
../../ipcore/Echo_cancellation_LMS_ram/Echo_cancellation_LMS_ram.v
../../ipcore/w_lms_ram/w_lms_ram.v

../../ipcore/Voice_change_ram/rtl/ipml_sdpram_v1_6_Voice_change_ram.v
../../ipcore/Frame_capture_ram/rtl/ipml_sdpram_v1_6_Frame_capture_ram.v
../../ipcore/Echo_cancellation_LMS_ram/rtl/ipml_sdpram_v1_6_Echo_cancellation_LMS_ram.v
../../ipcore/w_lms_ram/rtl/ipml_sdpram_v1_6_w_lms_ram.v

//../../ipcore/vocie_change_fifo/vocie_change_fifo.v
//../../ipcore/vocie_change_fifo/rtl/ipml_fifo_v1_6_vocie_change_fifo.v
//../../ipcore/vocie_change_fifo/rtl/ipml_sdpram_v1_6_vocie_change_fifo.v
//../../ipcore/vocie_change_fifo/rtl/ipml_fifo_ctrl_v1_3.v

../../ipcore/LMS_FIFO/LMS_FIFO.v
../../ipcore/LMS_FIFO/rtl/ipml_fifo_v1_6_LMS_FIFO.v
../../ipcore/LMS_FIFO/rtl/ipml_sdpram_v1_6_LMS_FIFO.v
../../ipcore/LMS_FIFO/rtl/ipml_fifo_ctrl_v1_3.v

../../ipcore/fft_ram_1024/fft_ram_1024.v
../../ipcore/fft_ram_1024/rtl/ipml_sdpram_v1_6_fft_ram_1024.v

../../ipcore/Framing_512/Framing_512.v
../../ipcore/Framing_512/rtl/ipml_fifo_v1_6_Framing_512.v
../../ipcore/Framing_512/rtl/ipml_sdpram_v1_6_Framing_512.v
../../ipcore/Framing_512/rtl/ipml_fifo_ctrl_v1_3.v

../../ipcore/Framing_1024/Framing_1024.v
../../ipcore/Framing_1024/rtl/ipml_fifo_v1_6_Framing_1024.v
../../ipcore/Framing_1024/rtl/ipml_sdpram_v1_6_Framing_1024.v
../../ipcore/Framing_1024/rtl/ipml_fifo_ctrl_v1_3.v

../../ipcore/vocie_change_fifo1/vocie_change_fifo1.v
../../ipcore/vocie_change_fifo1/rtl/ipml_fifo_v1_6_vocie_change_fifo1.v
../../ipcore/vocie_change_fifo1/rtl/ipml_sdpram_v1_6_vocie_change_fifo1.v
../../ipcore/vocie_change_fifo1/rtl/ipml_fifo_ctrl_v1_3.v

../../ipcore/Median/Median.v
../../ipcore/Median/rtl/ipm_distributed_sdpram_v1_2_Median.v

../../ipcore/Median_ram/Median_ram.v
../../ipcore/Median_ram/rtl/ipml_sdpram_v1_6_Median_ram.v

../../ipcore/sram_1024x16/sram_1024x16.v
../../ipcore/sram_1024x16/rtl/ipml_sdpram_v1_6_sram_1024x16.v