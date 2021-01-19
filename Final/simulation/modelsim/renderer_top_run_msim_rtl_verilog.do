transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/vga_clk.v}
vlog -vlog01compat -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/ram.v}
vlog -vlog01compat -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/db {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/db/vga_clk_altpll.v}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/trigonometric_lib.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/display.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/triangle_list_ram.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/triangle_list.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/project_triangle.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/project_cal.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/project.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/matrix_lib.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/list_writer.sv}
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
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/draw_triangle.sv}

vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final {D:/GZM/study/ELSE/ECE385_Project/Final/Project/Final/renderer_top_testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  renderer_top_testbench

add wave *
view structure
view signals
run 15 ms
