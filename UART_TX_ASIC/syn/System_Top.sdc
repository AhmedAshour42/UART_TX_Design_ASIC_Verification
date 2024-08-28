###################################################################

# Created by write_sdc on Wed Aug 28 08:53:31 2024

###################################################################
set sdc_version 2.0

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_operating_conditions -max scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -max_library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -min scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c -min_library scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c
set_wire_load_model -name tsmc13_wl30 -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports clk]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports rst]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports Data_valid]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports {P_data[7]}]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports {P_data[6]}]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports {P_data[5]}]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports {P_data[4]}]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports {P_data[3]}]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports {P_data[2]}]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports {P_data[1]}]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports {P_data[0]}]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports Par_type]
set_driving_cell -lib_cell BUFX2M -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -pin Y [get_ports Par_en]
set_load -pin_load 0.5 [get_ports Busy]
set_load -pin_load 0.5 [get_ports TX_out]
create_clock [get_ports clk]  -name MASTER_CLK  -period 8680  -waveform {0 4340}
set_clock_latency 0  [get_clocks MASTER_CLK]
set_clock_uncertainty -setup 0.25  [get_clocks MASTER_CLK]
set_clock_uncertainty -hold 0.05  [get_clocks MASTER_CLK]
set_clock_transition -max -rise 0.1 [get_clocks MASTER_CLK]
set_clock_transition -min -rise 0.1 [get_clocks MASTER_CLK]
set_clock_transition -max -fall 0.1 [get_clocks MASTER_CLK]
set_clock_transition -min -fall 0.1 [get_clocks MASTER_CLK]
group_path -name INOUT  -from [list [get_ports clk] [get_ports rst] [get_ports Data_valid] [get_ports {P_data[7]}] [get_ports {P_data[6]}] [get_ports {P_data[5]}] [get_ports {P_data[4]}] [get_ports {P_data[3]}] [get_ports {P_data[2]}] [get_ports {P_data[1]}] [get_ports {P_data[0]}] [get_ports Par_type] [get_ports Par_en]]  -to [list [get_ports Busy] [get_ports TX_out]]
group_path -name INREG  -from [list [get_ports clk] [get_ports rst] [get_ports Data_valid] [get_ports {P_data[7]}] [get_ports {P_data[6]}] [get_ports {P_data[5]}] [get_ports {P_data[4]}] [get_ports {P_data[3]}] [get_ports {P_data[2]}] [get_ports {P_data[1]}] [get_ports {P_data[0]}] [get_ports Par_type] [get_ports Par_en]]
group_path -name REGOUT  -to [list [get_ports Busy] [get_ports TX_out]]
set_input_delay -clock MASTER_CLK  2604  [get_ports Data_valid]
set_input_delay -clock MASTER_CLK  2604  [get_ports {P_data[7]}]
set_input_delay -clock MASTER_CLK  2604  [get_ports {P_data[6]}]
set_input_delay -clock MASTER_CLK  2604  [get_ports {P_data[5]}]
set_input_delay -clock MASTER_CLK  2604  [get_ports {P_data[4]}]
set_input_delay -clock MASTER_CLK  2604  [get_ports {P_data[3]}]
set_input_delay -clock MASTER_CLK  2604  [get_ports {P_data[2]}]
set_input_delay -clock MASTER_CLK  2604  [get_ports {P_data[1]}]
set_input_delay -clock MASTER_CLK  2604  [get_ports {P_data[0]}]
set_input_delay -clock MASTER_CLK  2604  [get_ports Par_type]
set_input_delay -clock MASTER_CLK  2604  [get_ports Par_en]
set_output_delay -clock MASTER_CLK  2604  [get_ports Busy]
set_output_delay -clock MASTER_CLK  2604  [get_ports TX_out]
