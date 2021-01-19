module draw_triangle_testbench();

timeunit 10ns;
timeprecision 1ns;

logic Clk, draw_triangle_start, Reset;
logic [1:0][9:0] V1, V2, V3;
logic [9:0] DrawX, DrawY;
logic draw_triangle_done;
logic draw_line_start, draw_line_done;
logic [9:0] x0,x1,y0,y1;

draw_triangle dt(.*);

assign x0 = dt.x0;
assign y0 = dt.y0;
assign x1 = dt.x1;
assign y1 = dt.y1;
assign draw_line_start = dt.draw_line_start;
assign draw_line_done = dt.draw_line_done;
assign curr_state = dt.curr_state;

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST_VECTORS

Reset = 1;
#5 Reset = 0;

draw_triangle_start = 0;
V1[0] = 10'd20;
V1[1] = 10'd20;
V2[0] = 10'd40;
V2[1] = 10'd20;
V3[0] = 10'd20;
V3[1] = 10'd40;

#5 draw_triangle_start = 1;

#100;
end
endmodule
