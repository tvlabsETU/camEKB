
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
add wave -position end  sim:/tb_pal/EKB_top_0/sync_gen_pix_str_frame_q/qout_clk_IS
add wave -position end  sim:/tb_pal/EKB_top_0/sync_gen_pix_str_frame_q/stroka_IS
add wave -position end  sim:/tb_pal/EKB_top_0/sync_gen_pix_str_frame_q/qout_v_IS
add wave -position end  sim:/tb_pal/EKB_top_0/sync_gen_pix_str_frame_q/kadr_IS
add wave -position 5  sim:/tb_pal/EKB_top_0/sync_gen_pix_str_frame_q/qout_clk_Inteface
add wave -position 6  sim:/tb_pal/EKB_top_0/sync_gen_pix_str_frame_q/stroka_Inteface
add wave -position 7  sim:/tb_pal/EKB_top_0/sync_gen_pix_str_frame_q/qout_v_Inteface
add wave -position 8  sim:/tb_pal/EKB_top_0/sync_gen_pix_str_frame_q/kadr_Inteface

add wave -noupdate -divider Image_SEnsor

add wave -noupdate -divider SMPTE_SERDES

add wave -position end sim:/tb_pal/EKB_top_0/image_sensor_RX_LVDS_q/data_RAW_RX

add wave -noupdate -divider HSI
