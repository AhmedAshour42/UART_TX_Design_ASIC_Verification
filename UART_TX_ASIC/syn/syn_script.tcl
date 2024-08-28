########################### Define Top Module ############################
                                                   
set top_module top

##################### Define Working Library Directory ######################
                                                   
define_design_lib work -path ./work

########################### Formality Setup file ############################

set_svf top.svf

################## Design Compiler Library Files #setup ######################

lappend search_path /home/IC/Labs/UART_TX_ASIC/std_cells
lappend search_path /home/IC/Labs/UART_TX_ASIC/rtl

set SSLIB "scmetro_tsmc_cl013g_rvt_ss_1p08v_125c.db"
set TTLIB "scmetro_tsmc_cl013g_rvt_tt_1p2v_25c.db"
set FFLIB "scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c.db"

## Standard Cell libraries 
set target_library [list $SSLIB $TTLIB $FFLIB]

## Standard Cell & Hard Macros libraries 
set link_library [list * $SSLIB $TTLIB $FFLIB]  

#echo "###############################################"
#echo "############# Reading RTL Files  ##############"
#echo "###############################################"

set file_format verilog
read_file -format $file_format top.v
read_file -format $file_format mux.v
read_file -format $file_format FSM.v
read_file -format $file_format Parity.v
read_file -format $file_format serializer.v
#top Files

###################### Defining toplevel ###################################

current_design $top_module


#################### Liniking All The Design Parts #########################
puts "###############################################"
puts "######## Liniking All The Design Parts ########"
puts "###############################################"

link 

#################### Liniking All The Design Parts #########################
puts "###############################################"
puts "######## checking design consistency ##########"
puts "###############################################"

check_design

############################### Path groups ################################
puts "###############################################"
puts "################ Path groups ##################"
puts "###############################################"

group_path -name INREG -from [all_inputs]
group_path -name REGOUT -to [all_outputs]
group_path -name INOUT -from [all_inputs] -to [all_outputs]

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
set CLK_PER 8680
set CLK_SETUP_SKEW 0.25
set CLK_HOLD_SKEW 0.05
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

#/* -------------------------------------------------------------------------- */
#/*                            Constrain Input Paths                          */
#/* -------------------------------------------------------------------------- */

set_input_delay $in1_delay -clock MASTER_CLK [get_port Data_valid]
set_input_delay $in1_delay -clock MASTER_CLK [get_port P_data]
set_input_delay $in1_delay -clock MASTER_CLK [get_port Par_type]
set_input_delay $in1_delay -clock MASTER_CLK [get_port Par_en]


#/* -------------------------------------------------------------------------- */
#/*                          Constrain Output Paths                        */
#/* -------------------------------------------------------------------------- */

set_output_delay $out1_delay -clock MASTER_CLK [get_port Busy]
set_output_delay $out1_delay -clock MASTER_CLK [get_port TX_out]


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

###################################################################################
           #########################################################
                  #### Section 5 : Output load ####
           #########################################################
####################################################################################

set_load 0.5 [get_port Busy]
set_load 0.5 [get_port TX_out]

# dont touch
set_dont_touch_network [get_clocks MASTER_CLK]

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

###################### Mapping and optimization ########################
puts "###############################################"
puts "########## Mapping & Optimization #############"
puts "###############################################"

compile -map_effort high 

##################### Close Formality Setup file ###########################

set_svf -off

#############################################################################
# Write out Design after initial compile
#############################################################################

write_file -format verilog -hierarchy -output System_Top.v
write_file -format ddc -hierarchy -output System_Top.ddc
write_sdc  -nosplit System_Top.sdc
write_sdf           System_Top.sdf

################# reporting #######################

report_area -hierarchy > area.rpt
report_power -hierarchy > power.rpt
report_timing -max_paths 100 -delay_type min > hold.rpt
report_timing -max_paths 100 -delay_type max > setup.rpt
report_clock -attributes > clocks.rpt
report_constraint -all_violators > constraints.rpt

################# starting graphical user interface #######################

gui_start

#exit
