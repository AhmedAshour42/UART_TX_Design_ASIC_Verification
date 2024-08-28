# #################### Define Design Constraints #########################

 puts "###############################################"

puts "############ Design Constraints #### ##########"

 puts "###############################################"





####################################################################################

           #########################################################

                  #### Section 1 : Clock Definition ####

           #########################################################

#################################################################################### 



set CLK_NAME MASTER_CLK

set CLK_PER 100

set CLK_SETUP_SKEW 0.025

set CLK_HOLD_SKEW 0.01

set CLK_LAT 0

set CLK_RISE 0.1

set CLK_FALL 0.1

set in1_delay  [expr 0.3*$CLK_PER]

set out1_delay [expr 0.3*$CLK_PER]

#/* -------------------------------------------------------------------------- */

#/*                             ###### create clock                            */

#/* -------------------------------------------------------------------------- */

create_clock -name $CLK_NAME -period $CLK_PER -waveform "0 [expr $CLK_PER/2]" [get_ports clk]

set_clock_uncertainty -setup $CLK_SETUP_SKEW [get_clock $CLK_NAME]

set_clock_uncertainty -hold $CLK_HOLD_SKEW  [get_clock $CLK_NAME]

set_clock_transition -rise $CLK_RISE  [get_clock $CLK_NAME]

set_clock_transition -fall $CLK_FALL  [get_clock $CLK_NAME]

set_clock_latency $CLK_LAT [get_clock $CLK_NAME]



####################################################################################

           #########################################################

                  #### Section 1 : Clock Definition_DFT####

           #########################################################

#################################################################################### 

set CLK_NAME_DFT MASTER_CLK_DFT

set CLK_PER_DFT 100

set CLK_SETUP_SKEW_DFT 0.025

set CLK_HOLD_SKEW_DFT 0.01

set CLK_LAT_DFT 0

set CLK_RISE_DFT 0.1

set CLK_FALL_DFT 0.1

set in2_delay  [expr 0.3*$CLK_PER_DFT]

set out2_delay [expr 0.3*$CLK_PER_DFT]

create_clock -name $CLK_NAME_DFT -period $CLK_PER_DFT -waveform "0 [expr $CLK_PER_DFT/2]" [get_ports scan_clk]

set_clock_uncertainty -setup $CLK_SETUP_SKEW_DFT [get_clock $CLK_NAME_DFT]

set_clock_uncertainty -hold $CLK_HOLD_SKEW_DFT  [get_clock $CLK_NAME_DFT]

set_clock_transition -rise $CLK_RISE_DFT  [get_clock $CLK_NAME_DFT]

set_clock_transition -fall $CLK_FALL_DFT  [get_clock $CLK_NAME_DFT]

set_clock_latency $CLK_LAT_DFT [get_clock $CLK_NAME_DFT]


#/* -------------------------------------------------------------------------- */

#/*                            Constrain Input Paths                          */

#/* -------------------------------------------------------------------------- */



set_input_delay $in1_delay -clock MASTER_CLK [get_port Data_valid]

set_input_delay $in1_delay -clock MASTER_CLK [get_port P_data]

set_input_delay $in1_delay -clock MASTER_CLK [get_port Par_type]

set_input_delay $in1_delay -clock MASTER_CLK [get_port Par_en]


#/* -------------------------------------------------------------------------- */

#/*                            Constrain Input Paths_DFT                          */

#/* -------------------------------------------------------------------------- */
set_input_delay $in2_delay -clock MASTER_CLK_DFT [get_port SI]

set_input_delay $in2_delay -clock MASTER_CLK_DFT [get_port SE]

set_input_delay $in2_delay -clock MASTER_CLK_DFT [get_port test_mode]



#/* -------------------------------------------------------------------------- */

#/*                          Constrain Output Paths                        */

#/* -------------------------------------------------------------------------- */



set_output_delay $out1_delay -clock MASTER_CLK [get_port Busy]

set_output_delay $out1_delay -clock MASTER_CLK [get_port TX_out]

#/* -------------------------------------------------------------------------- */

#/*                          Constrain Output Paths _DFT                      */

#/* -------------------------------------------------------------------------- */


set_output_delay $out2_delay -clock MASTER_CLK_DFT [get_port SO]




####################################################################################

           #########################################################

                  #### Section 4 : Driving cells ####

           #########################################################

####################################################################################

set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [get_port clk]

set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [get_port rst]

set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [get_port Data_valid]

set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [get_port P_data]

set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [get_port Par_type]

set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [get_port Par_en]

set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [get_port SI]

set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [get_port SE]

set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [get_port test_mode]
###################################################################################

           #########################################################

                  #### Section 5 : Output load ####

           #########################################################

####################################################################################



set_load 0.1 [get_port Busy]

set_load 0.1 [get_port TX_out]

set_load 0.1 [get_port SO]

#dont touch

set_dont_touch_network [get_clocks {MASTER_CLK MASTER_CLK_DFT }]




####################################################################################

           #########################################################

                 #### Section 6 : Operating Condition ####

           #########################################################

####################################################################################

# Define the Worst Library for Max(#setup) analysis

# Define the Best Library for Min(hold) analysis

set_operating_conditions -min_library "scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c" -min "scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c" -max_library "scmetro_tsmc_cl013g_rvt_ss_1p08v_125c" -max "scmetro_tsmc_cl013g_rvt_ss_1p08v_125c"



####################################################################################

           #########################################################

                  #### Section 7 : wireload Model ####

           #########################################################

####################################################################################



set_wire_load_model -name tsmc13_wl30 -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c





