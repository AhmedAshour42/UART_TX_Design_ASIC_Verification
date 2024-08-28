vlib work
vlog -f src_file.list
vlog top_tb.v
vsim -voptargs=+acc work.top_tb
add wave -position insertpoint sim:/top_tb/*
run -all
