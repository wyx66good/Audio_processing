// Example Design Top
../../source/MFCC_VQ.v
../../source/source/pre_add.v
../../source/source/fft_ip.v
../../source/Framing_hpss_512.v
../../source/hanning.v
../../source/divide32.v
../../source/Div_cell.v
../../source/PA_init.v
../../source/MFCC_DCT.v
../../source/MFCC.v
../../source/LOG10.v
../../source/DCT.v
../../source/VQ_LBG.v
../../source/VQ_LBG_XUNLIAN.v
../../source/LBG_mean.v
../../source/SPLIT.v
../../source/VQ_classify.v
../../source/distance.v
../../source/MIN.v
../../source/MIN4.v
../../source/VQ_classify_ram.v
../../source/LBG_mean_class.v
../../source/D_update.v
../../source/VQ_identifys.v
../../source/VQ_identifys_MIN_D.v
../../source/VQ.v
../../source/MFCC_frame_13.v
../../source/LBG_frame_13.v
../../source/MIN_TWO.v
../../source/distance_16.v
../../source/VQ_classify_buffer.v
../../source/panduan_genxing.v

// Testbench
../MFCC_VQ_tb.sv 

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

../../ipcore/MFCC_VQ_FIFO/MFCC_VQ_FIFO.v
../../ipcore/MFCC_VQ_FIFO/rtl/ipml_fifo_v1_6_MFCC_VQ_FIFO.v
../../ipcore/MFCC_VQ_FIFO/rtl/ipml_sdpram_v1_6_MFCC_VQ_FIFO.v
../../ipcore/MFCC_VQ_FIFO/rtl/ipml_fifo_ctrl_v1_3.v

../../ipcore/MFCCS13_RAM/MFCCS13_RAM.v
../../ipcore/MFCCS13_RAM/rtl/ipml_sdpram_v1_6_MFCCS13_RAM.v

../../ipcore/VQ_LBG_16X13/VQ_LBG_16X13.v
../../ipcore/VQ_LBG_16X13/rtl/ipml_sdpram_v1_6_VQ_LBG_16X13.v

../../ipcore/LBG_16X13/LBG_16X13.v
../../ipcore/LBG_16X13/rtl/ipml_sdpram_v1_6_LBG_16X13.v

../../ipcore/LBG_16X13_2/LBG_16X13_2.v
../../ipcore/LBG_16X13_2/rtl/ipml_sdpram_v1_6_LBG_16X13_2.v

../../ipcore/LBG_16X13_3/LBG_16X13_3.v
../../ipcore/LBG_16X13_3/rtl/ipml_sdpram_v1_6_LBG_16X13_3.v

../../ipcore/LBG_16X13_4/LBG_16X13_4.v
../../ipcore/LBG_16X13_4/rtl/ipml_sdpram_v1_6_LBG_16X13_4.v

../../ipcore/LBG_16X13_rom_1/LBG_16X13_rom_1.v
../../ipcore/LBG_16X13_rom_1/rtl/ipml_rom_v1_5_LBG_16X13_rom_1.v
../../ipcore/LBG_16X13_rom_1/rtl/ipml_spram_v1_5_LBG_16X13_rom_1.v

../../ipcore/LBG_16X13_rom_2/LBG_16X13_rom_2.v
../../ipcore/LBG_16X13_rom_2/rtl/ipm_distributed_rom_v1_3_LBG_16X13_rom_2.v

../../ipcore/MFCC_LOG_RAM18X24/MFCC_LOG_RAM18X24.v
../../ipcore/MFCC_LOG_RAM18X24/rtl/ipml_sdpram_v1_6_MFCC_LOG_RAM18X24.v

../../ipcore/vblg14x12/vblg14x12.v
../../ipcore/vblg14x12/rtl/ipml_sdpram_v1_6_vblg14x12.v

../../ipcore/vblg14x12_2/vblg14x12_2.v
../../ipcore/vblg14x12_2/rtl/ipml_sdpram_v1_6_vblg14x12_2.v

../../ipcore/MFCCS13_RAM14X12/MFCCS13_RAM14X12.v
../../ipcore/MFCCS13_RAM14X12/rtl/ipml_sdpram_v1_6_MFCCS13_RAM14X12.v

../../ipcore/VQ_classify_ram1/VQ_classify_ram1.v
../../ipcore/VQ_classify_ram1/rtl/ipml_sdpram_v1_6_VQ_classify_ram1.v

../../ipcore/VQ_classify_ram/VQ_classify_ram.v
../../ipcore/VQ_classify_ram/rtl/ipml_sdpram_v1_6_VQ_classify_ram.v

../../ipcore/MFCC_melbank_rom/MFCC_melbank_rom.v
../../ipcore/MFCC_melbank_rom/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom.v
../../ipcore/MFCC_melbank_rom2/MFCC_melbank_rom2.v
../../ipcore/MFCC_melbank_rom2/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom2.v
../../ipcore/MFCC_melbank_rom3/MFCC_melbank_rom3.v
../../ipcore/MFCC_melbank_rom3/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom3.v
../../ipcore/MFCC_melbank_rom4/MFCC_melbank_rom4.v
../../ipcore/MFCC_melbank_rom4/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom4.v
../../ipcore/MFCC_melbank_rom5/MFCC_melbank_rom5.v
../../ipcore/MFCC_melbank_rom5/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom5.v
../../ipcore/MFCC_melbank_rom6/MFCC_melbank_rom6.v
../../ipcore/MFCC_melbank_rom6/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom6.v
../../ipcore/MFCC_melbank_rom7/MFCC_melbank_rom7.v
../../ipcore/MFCC_melbank_rom7/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom7.v
../../ipcore/MFCC_melbank_rom8/MFCC_melbank_rom8.v
../../ipcore/MFCC_melbank_rom8/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom8.v
../../ipcore/MFCC_melbank_rom9/MFCC_melbank_rom9.v
../../ipcore/MFCC_melbank_rom9/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom9.v
../../ipcore/MFCC_melbank_rom10/MFCC_melbank_rom10.v
../../ipcore/MFCC_melbank_rom10/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom10.v
../../ipcore/MFCC_melbank_rom11/MFCC_melbank_rom11.v
../../ipcore/MFCC_melbank_rom11/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom11.v
../../ipcore/MFCC_melbank_rom12/MFCC_melbank_rom12.v
../../ipcore/MFCC_melbank_rom12/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom12.v
../../ipcore/MFCC_melbank_rom13/MFCC_melbank_rom13.v
../../ipcore/MFCC_melbank_rom13/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom13.v
../../ipcore/MFCC_melbank_rom14/MFCC_melbank_rom14.v
../../ipcore/MFCC_melbank_rom14/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom14.v
../../ipcore/MFCC_melbank_rom15/MFCC_melbank_rom15.v
../../ipcore/MFCC_melbank_rom15/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom15.v
../../ipcore/MFCC_melbank_rom16/MFCC_melbank_rom16.v
../../ipcore/MFCC_melbank_rom16/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom16.v
../../ipcore/MFCC_melbank_rom17/MFCC_melbank_rom17.v
../../ipcore/MFCC_melbank_rom17/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom17.v
../../ipcore/MFCC_melbank_rom18/MFCC_melbank_rom18.v
../../ipcore/MFCC_melbank_rom18/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom18.v
../../ipcore/MFCC_melbank_rom19/MFCC_melbank_rom19.v
../../ipcore/MFCC_melbank_rom19/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom19.v
../../ipcore/MFCC_melbank_rom20/MFCC_melbank_rom20.v
../../ipcore/MFCC_melbank_rom20/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom20.v
../../ipcore/MFCC_melbank_rom21/MFCC_melbank_rom21.v
../../ipcore/MFCC_melbank_rom21/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom21.v
../../ipcore/MFCC_melbank_rom22/MFCC_melbank_rom22.v
../../ipcore/MFCC_melbank_rom21/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom21.v
../../ipcore/MFCC_melbank_rom22/MFCC_melbank_rom22.v
../../ipcore/MFCC_melbank_rom22/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom22.v
../../ipcore/MFCC_melbank_rom23/MFCC_melbank_rom23.v
../../ipcore/MFCC_melbank_rom23/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom23.v
../../ipcore/MFCC_melbank_rom24/MFCC_melbank_rom24.v
../../ipcore/MFCC_melbank_rom24/rtl/ipm_distributed_rom_v1_3_MFCC_melbank_rom24.v
../../ipcore/DCT_COS/DCT_COS.v
../../ipcore/DCT_COS/rtl/ipm_distributed_rom_v1_3_DCT_COS.v

../../ipcore/LBG_16X13_rom1_1/LBG_16X13_rom1_1.v
../../ipcore/LBG_16X13_rom1_1/rtl/ipm_distributed_rom_v1_3_LBG_16X13_rom1_1.v

../../ipcore/LBG_16X13_rom1_3/LBG_16X13_rom1_3.v
../../ipcore/LBG_16X13_rom1_3/rtl/ipm_distributed_rom_v1_3_LBG_16X13_rom1_3.v

../../ipcore/LBG_16X13_rom1_4/LBG_16X13_rom1_4.v
../../ipcore/LBG_16X13_rom1_4/rtl/ipm_distributed_rom_v1_3_LBG_16X13_rom1_4.v