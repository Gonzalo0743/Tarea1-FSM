transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/TEC/II\ Semestre\ 2024/Taller/Tarea1-FSM {D:/TEC/II Semestre 2024/Taller/Tarea1-FSM/mantenimiento_fsm.sv}

vlog -sv -work work +incdir+D:/TEC/II\ Semestre\ 2024/Taller/Tarea1-FSM {D:/TEC/II Semestre 2024/Taller/Tarea1-FSM/tb_mantenimiento_fsm.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_mantenimiento_fsm

add wave *
view structure
view signals
run -all
