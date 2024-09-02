// Example Design Top
../../source/source/Voice_change.v
../../source/source/sin.v
../../source/source/x.v
../../source/source/d.v
../../source/Framing.v
../../source/Frame_capture.v
../../source/Linear_interpolation.v
../../source/sin_Amplitude_modulation.v
../../source/Filter_modulation.v
../../source/pre_add.v
../../source/Echo_cancellation_LMS.v
../../source/dot.v
../../source/w_updata.v
../../source/divide32.v
../../source/Div_cell.v

// Testbench
../ipsxe_fft_onboard_top_tb.sv 


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

