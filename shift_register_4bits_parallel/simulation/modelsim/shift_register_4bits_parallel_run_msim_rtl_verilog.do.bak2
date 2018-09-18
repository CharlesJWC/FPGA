transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {c:/altera/91/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {c:/altera/91/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {c:/altera/91/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {c:/altera/91/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/cycloneii_ver
vmap cycloneii_ver ./verilog_libs/cycloneii_ver
vlog -vlog01compat -work cycloneii_ver {c:/altera/91/quartus/eda/sim_lib/cycloneii_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Workspace/Altera_Quartus_Workspace/shift_register_4bits_parallel {D:/Workspace/Altera_Quartus_Workspace/shift_register_4bits_parallel/D_FlipFlop.v}
vlog -vlog01compat -work work +incdir+D:/Workspace/Altera_Quartus_Workspace/shift_register_4bits_parallel {D:/Workspace/Altera_Quartus_Workspace/shift_register_4bits_parallel/shift_register_4bits_parallel.v}

vlog -vlog01compat -work work +incdir+D:/Workspace/Altera_Quartus_Workspace/shift_register_4bits_parallel {D:/Workspace/Altera_Quartus_Workspace/shift_register_4bits_parallel/tb_shift_register_4bits_parallel.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L cycloneii_ver -L rtl_work -L work -voptargs="+acc" shift_register_4bits_parallel

add wave *
view structure
view signals
run 10 ms
