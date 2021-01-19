transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/vga_clk.v}
vlog -vlog01compat -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/ram.v}
vlog -vlog01compat -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/db {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/db/vga_clk_altpll.v}
vlib nios_system
vmap nios_system nios_system
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/nios_system.v}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/altera_reset_controller.v}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/altera_reset_synchronizer.v}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_mm_interconnect_0.v}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_avalon_st_adapter.v}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/altera_avalon_sc_fifo.v}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_sysid_qsys_0.v}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_sdram_pll.v}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_sdram.v}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_otg_hpi_data.v}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_otg_hpi_cs.v}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_otg_hpi_address.v}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_nios2_gen2_0.v}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_nios2_gen2_0_cpu.v}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_nios2_gen2_0_cpu_debug_slave_sysclk.v}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_nios2_gen2_0_cpu_debug_slave_tck.v}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_nios2_gen2_0_cpu_debug_slave_wrapper.v}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_nios2_gen2_0_cpu_test_bench.v}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_keycode.v}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_jtag_uart_0.v}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/hpi_io_intf.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/euler_angle.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/HexDriver.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/trigonometric_lib.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/display.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/triangle_list.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/project_triangle.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/project_cal.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/project.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/matrix_lib.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/get_view_matrix.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/get_projection_matrix.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/get_mvp_matrix.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/get_model_matrix.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/fixedpoint_lib.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/draw.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/triangle_fifo_ram.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/triangle_fifo.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/VGA_controller.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/renderer_top.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/frame_buffer.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/draw_line.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/control_unit.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/color_mapper.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/clear_frame.sv}
vlog -sv -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_irq_mapper.sv}
vlog -sv -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_avalon_st_adapter_error_adapter_0.sv}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/altera_avalon_st_handshake_clock_crosser.v}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/altera_avalon_st_clock_crosser.v}
vlog -vlog01compat -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/altera_std_synchronizer_nocut.v}
vlog -sv -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_rsp_mux_001.sv}
vlog -sv -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/altera_merlin_arbitrator.sv}
vlog -sv -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_rsp_mux.sv}
vlog -sv -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_rsp_demux_001.sv}
vlog -sv -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_rsp_demux.sv}
vlog -sv -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_cmd_mux_001.sv}
vlog -sv -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_cmd_mux.sv}
vlog -sv -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_cmd_demux_001.sv}
vlog -sv -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_cmd_demux.sv}
vlog -sv -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_router_003.sv}
vlog -sv -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_router_002.sv}
vlog -sv -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_router_001.sv}
vlog -sv -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/nios_system_mm_interconnect_0_router.sv}
vlog -sv -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/altera_merlin_slave_agent.sv}
vlog -sv -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/altera_merlin_burst_uncompressor.sv}
vlog -sv -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/altera_merlin_master_agent.sv}
vlog -sv -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/altera_merlin_slave_translator.sv}
vlog -sv -work nios_system +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/nios_system/synthesis/submodules/altera_merlin_master_translator.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/triangle_list_ram.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/draw_triangle.sv}

vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/renderer_top_testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -L nios_system -voptargs="+acc"  renderer_top_testbench

add wave *
view structure
view signals
run 15 ms
