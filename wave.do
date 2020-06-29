
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

add wave -position 1  sim:/tb_adv/EKB_top_0/ADV7343_control_q0/qout_clk
add wave -position 2  sim:/tb_adv/EKB_top_0/ADV7343_control_q0/qout_v
add wave -position 3  sim:/tb_adv/EKB_top_0/ADV7343_control_q0/ena_clk_x_q

add wave -noupdate -divider Image_SEnsor


add wave -noupdate -divider SMPTE_SERDES



add wave -position 5  sim:/tb_adv/EKB_top_0/ADV7343_control_q0/cnt_reg
add wave -position 6  sim:/tb_adv/EKB_top_0/ADV7343_control_q0/reset_n_i2c
add wave -position 7  sim:/tb_adv/EKB_top_0/ADV7343_control_q0/ena_i2c
add wave -position 8  sim:/tb_adv/EKB_top_0/ADV7343_control_q0/addr_i2c
add wave -position 9  sim:/tb_adv/EKB_top_0/ADV7343_control_q0/rw_i2c
add wave -position 10  sim:/tb_adv/EKB_top_0/ADV7343_control_q0/data_wr_i2c
add wave -position 11  sim:/tb_adv/EKB_top_0/ADV7343_control_q0/busy_i2c
add wave -position 12  sim:/tb_adv/EKB_top_0/ADV7343_control_q0/data_rd_i2c
add wave -position 13  sim:/tb_adv/EKB_top_0/ADV7343_control_q0/ack_error_i2c
add wave -position 14  sim:/tb_adv/EKB_top_0/ADV7343_control_q0/sda_i2c
add wave -position 15  sim:/tb_adv/EKB_top_0/ADV7343_control_q0/scl_i2c


add wave -noupdate -divider HSI
