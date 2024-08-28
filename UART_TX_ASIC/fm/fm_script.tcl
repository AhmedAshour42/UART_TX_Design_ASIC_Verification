
###################################################################
########################### Variables #############################
###################################################################
set SSLIB "/home/IC/Labs/UART_TX_ASIC/std_cells/scmetro_tsmc_cl013g_rvt_ss_1p08v_125c.db"
set TTLIB "/home/IC/Labs/UART_TX_ASIC/std_cells/scmetro_tsmc_cl013g_rvt_tt_1p2v_25c.db"
set FFLIB "/home/IC/Labs/UART_TX_ASIC/std_cells/scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c.db"


###################################################################
############################ Guidance #############################
###################################################################

# Synopsys setup variable
set synopsys_auto_setup true

# Formality Setup File
set_svf  "/home/IC/Labs/UART_TX_ASIC/syn/top.svf"

###################################################################
###################### Reference Container ########################
###################################################################

# Read Reference Designs Verilog Files
read_verilog -container Ref "/home/IC/Labs/UART_TX_ASIC/rtl/top.v"
read_verilog -container Ref "/home/IC/Labs/UART_TX_ASIC/rtl/FSM.v"
read_verilog -container Ref "/home/IC/Labs/UART_TX_ASIC/rtl/mux.v"
read_verilog -container Ref "/home/IC/Labs/UART_TX_ASIC/rtl/Parity.v"
read_verilog -container Ref "/home/IC/Labs/UART_TX_ASIC/rtl/serializer.v"

# Read Reference technology libraries
read_db -container Ref [list $SSLIB $TTLIB $FFLIB]

# set the top Reference Design 
set_reference_design top
set_top top


###################################################################
#################### Implementation Container #####################
###################################################################

# Read Implementation Design Files
read_verilog -container Imp -netlist "/home/IC/Labs/UART_TX_ASIC/syn/System_Top.v"
#read_verilog -container Imp -netlist "/home/IC/Labs/UART_TX_ASIC/syn/FSM.v"
#read_verilog -container Imp -netlist "/home/IC/Labs/UART_TX_ASIC/syn/mux.v"
#read_verilog -container Imp -netlist "/home/IC/Labs/UART_TX_ASIC/syn/Parity.v"
#read_verilog -container Imp -netlist "/home/IC/Labs/UART_TX_ASIC/syn/serializer.v"

# Read Implementation technology libraries
read_db -container Imp [list $SSLIB $TTLIB $FFLIB]

# set the top Implementation Design
set_implementation_design top
set_top top

###################### Matching Compare points ####################

match

######################### Run Verification ########################

set successful [verify]
if {!$successful} {
diagnose      
#This command gives a detailed diagnosis of the verification process,
 # outlining the nature and location of the mismatches. It provides insights into why certain parts of the design did not match.

analyze_points -failing
 #This command zeroes in on the specific failing points identified during verification. It provides detailed information about these points,
 #such as which signals or components failed to match and why. This analysis
 #helps designers pinpoint the exact issues for debugging.
}

########################### Reporting ############################# 
report_passing_points > "passing_points.rpt"
report_failing_points > "failing_points.rpt"
report_aborted_points > "aborted_points.rpt"          
# Lists points where the verification process was aborted. This can happen due to unresolved dependencies or issues in the design.
report_unverified_points > "unverified_points.rpt"


start_gui

