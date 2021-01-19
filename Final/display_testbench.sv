module display_testbench();

timeunit 10ns;
timeprecision 1ns;

parameter WI = 8;
parameter WF = 8;

logic Clk, Reset, frame_clk_rising_edge;
logic [7:0]       keycode;
logic [11:0]      alpha, beta, gamma;
logic [WI+WF-1:0] x, y, z;
logic [11:0] x_angle, x_angle_in, x_angle_v, x_angle_v_in;
logic j1, j2, j3, j4, j6;

display #(.WI(WI),.WF(WF)) play(.*);

assign x_angle = play.x_angle;
assign x_angle_in = play.x_angle_in;
assign x_angle_v = play.x_angle_v;
assign x_angle_v_in = play.x_angle_v_in;
assign j1 = x_angle + x_angle_v < 0;
assign j2 = $signed(x_angle + x_angle_v) < 0;
assign j3 = $signed(x_angle + x_angle_v) >= 12'h648;
assign j4 = $signed(x_angle + x_angle_v) > 12'h648;
assign j5 = $signed(x_angle + x_angle_v) >= $signed(12'h648);
assign j6 = $signed(x_angle + x_angle_v) > $signed(12'h648);

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST_VECTORS

frame_clk_rising_edge = 1;
Reset = 1;
#5 Reset = 0;

keycode = 8'h14;
#1000
keycode = 0;
#1000
keycode = 8'h08;
#1000
keycode = 0;
#1000;
end
endmodule
