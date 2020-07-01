
_add_menu main controls right SystemButtonFace black RUN_1uS   {run 1000000}
_add_menu main controls right SystemButtonFace blue RUN_10uS   {run 10000000}
_add_menu main controls right SystemButtonFace red  RUN_100uS  {run 100000000}
_add_menu main controls right SystemButtonFace green RUN_1mS   {run 1000000000}
_add_menu main controls right SystemButtonFace magenta  RUN_10mS   {run 10000000000}
_add_menu main controls right SystemButtonFace yellow  RUN_100mS   {run 100000000000}

onerror {resume}
quietly WaveActivateNextPane {} 0

onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -divider SYNC_GEN

add wave -position end  sim:/tb_adv/EKB_top_0/sync_gen_pix_str_frame_q/qout_clk_IS
add wave -position end  sim:/tb_adv/EKB_top_0/sync_gen_pix_str_frame_q/stroka_IS
add wave -position end  sim:/tb_adv/EKB_top_0/sync_gen_pix_str_frame_q/qout_v_IS
add wave -position end  sim:/tb_adv/EKB_top_0/sync_gen_pix_str_frame_q/kadr_IS

add wave -noupdate -divider Image_SEnsor
add wave -position end  sim:/tb_adv/EKB_top_0/IMAGE_SENSOR_SIM_q/IS_SIM_Paralell_q/gen_pix_str_frame_Inteface/qout_clk
add wave -position end  sim:/tb_adv/EKB_top_0/IMAGE_SENSOR_SIM_q/IS_SIM_Paralell_q/gen_pix_str_frame_Inteface/stroka
add wave -position end  sim:/tb_adv/EKB_top_0/IMAGE_SENSOR_SIM_q/IS_SIM_Paralell_q/gen_pix_str_frame_Inteface/qout_v
add wave -position end  sim:/tb_adv/EKB_top_0/IMAGE_SENSOR_SIM_q/IS_SIM_Paralell_q/gen_pix_str_frame_Inteface/kadr
add wave -noupdate -divider SMPTE_SERDES

add wave -position end  sim:/tb_adv/EKB_top_0/image_sensor_RX_LVDS_q/sync_word_4ch_q/data_rx_ch_0
add wave -position end  sim:/tb_adv/EKB_top_0/image_sensor_RX_LVDS_q/sync_word_4ch_q/data_rx_ch_1
add wave -position end  sim:/tb_adv/EKB_top_0/image_sensor_RX_LVDS_q/sync_word_4ch_q/data_rx_ch_2
add wave -position end  sim:/tb_adv/EKB_top_0/image_sensor_RX_LVDS_q/sync_word_4ch_q/data_rx_ch_3
add wave -position end  sim:/tb_adv/EKB_top_0/image_sensor_RX_LVDS_q/sync_word_4ch_q/stp
add wave -position end  sim:/tb_adv/EKB_top_0/image_sensor_RX_LVDS_q/sync_word_4ch_q/Sync_flag
add wave -position end  sim:/tb_adv/EKB_top_0/image_sensor_RX_LVDS_q/sync_word_4ch_q/align_done

add wave -noupdate -divider HSI
