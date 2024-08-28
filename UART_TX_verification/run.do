vlib work
vlog -f src_file.list
vlog TOP_INTEFACE.sv
vsim -voptargs=+acc work.TOP_INTEFACE
coverage save TOP_INTEFACE.ucdb -onexit

add wave -position insertpoint  \
sim:/TOP_INTEFACE/intf/clk \
sim:/TOP_INTEFACE/intf/rst \
sim:/TOP_INTEFACE/intf/Data_valid \
sim:/TOP_INTEFACE/intf/P_data \
sim:/TOP_INTEFACE/intf/Par_type \
sim:/TOP_INTEFACE/intf/Par_en
add wave -position insertpoint  \
sim:/TOP_INTEFACE/tops/DUT_3/current_state
add wave -position insertpoint  \
sim:/TOP_INTEFACE/intf/Busy \
sim:/TOP_INTEFACE/intf/TX_out
add wave -position insertpoint  \
sim:/TOP_INTEFACE/top_tbs/correct \
sim:/TOP_INTEFACE/top_tbs/wrong

run -all
