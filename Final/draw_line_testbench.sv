module draw_line_testbench();

timeunit 10ns;
timeprecision 1ns;

logic Clk, Reset, draw_line_start, draw_line_done;
logic [9:0] x0,x1,y0,y1,x,y;
logic [9:0] DrawX, DrawY;
logic Done;
logic curr_state;
logic [9:0] dx,dy,sx,sy;
logic signed [9:0] err;

draw_line dl(.*);

assign x = dl.x;
assign y = dl.y;
assign dx = dl.dx;
assign dy = dl.dy;
assign sx = dl.sx;
assign sy = dl.sy;
assign err = dl.err;
assign curr_state = dl.curr_state;

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST_VECTORS
Reset = 1;
draw_line_start = 0;
x0 = 10'd20;
x1 = 10'd40;
y0 = 10'd20;
y1 = 10'd20;
#5 Reset = 0;
#5 draw_line_start = 1;

#100;
end


endmodule
